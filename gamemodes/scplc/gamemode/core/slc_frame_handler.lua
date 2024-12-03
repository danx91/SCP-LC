--[[-------------------------------------------------------------------------
Fonts
---------------------------------------------------------------------------]]
local function create_font( name, font, size, weight, outline )
	SLCCreateFont( name, {
		font = font,
		size = size,
		weight = weight or 500,
		extended = true,
		antialias = true,
	}, outline )
end

hook.Add( "RebuildFonts", "SLCFrame", function()
	local w = ScrW()
	local scale = 1

	create_font( "SLCFrame.EBig", "Arial", w * 0.026 * scale, 800, 8 )
	create_font( "SLCFrame.VBig", "Arial", w * 0.022 * scale, 800, 8 )
	create_font( "SLCFrame.Big", "Arial", w * 0.018 * scale, 800, 8 )
	create_font( "SLCFrame.Medium", "Arial", w * 0.014 * scale, 800, 8 )
	create_font( "SLCFrame.Small", "Arial", w * 0.01 * scale, 800, 8 )
	create_font( "SLCFrame.VSmall", "Arial", w * 0.008 * scale, 800, 8 )
end )

--[[-------------------------------------------------------------------------
Default Page
---------------------------------------------------------------------------]]
local DEF_PAGE = {}

function DEF_PAGE:SendData( name, data, ply )
	if SERVER and !IsValid( ply ) then return end
	
	local bin
	if istable( data ) and data.__bin then
		bin = data.__bin
		data.__bin = nil
	end

	net.Start( "SLCPages" )
		net.WriteString( self.Handler.Name )
		net.WriteString( self.ID )
		net.WriteString( name or "" )
		net.WriteTable( istable( data ) and data or { data } )

		net.WriteBit( !!bin )
		
		if bin then
			local len = string.len( bin )
			net.WriteUInt( len, 32 )
			net.WriteData( bin, len )
		end

	if SERVER then
		net.Send( ply )
	else
		net.SendToServer()
	end
end

function DEF_PAGE:ReceiveData_Internal( name, data, ply )
	if CLIENT then
		if name == "__reload" then
			self:Reload( data )
			return
		elseif name == "__load" then
			self:LoadPage( data.id, data.data )
			return
		elseif name == "__error" then
			self:Error( data.msg, data.fatal )
			return
		elseif name == "__msg" then
			self:Message( data.id )
			return
		elseif name == "__update" then
			if self.PageData then
				for k, v in pairs( data ) do
					self.PageData[k] = v
				end
			end

			return
		end
	end

	local rid, req = string.match( name, "^r(%d+)_(.+)$" )
	rid = tonumber( rid )

	if SERVER then
		if self.Handler.IsBanned( ply:SteamID64(), self.ID ) then
			if req == "load" then
				self:SendData( name, { __banned = true }, ply )
			end

			return
		elseif self.PANIC or self.IsVisible and !self:IsVisible( ply ) then
			if req == "load" then
				self:SendData( name, { __restrict = true }, ply )
			end

			return
		end
	end

	if !rid or SERVER then
		local rname = req or name
		local receiver = self.Receivers[rname]
		local res

		if isfunction( receiver ) then
			res = receiver( self, data, ply, rid )
		else
			res = receiver
		end

		if rid then
			if ispromise( res ) then
				res:Then( function( d )
					self:SendData( name, d, ply )
				end )
			else
				self:SendData( name, res, ply )
			end
		end
	else
		local r = self.Requests[rid]
		if r then
			self.Requests[rid] = nil
			data.RequestID = r.id

			r.promise:Resolve( data )
		end
	end
end

function DEF_PAGE:Reload( data, ply )
	if SERVER then
		self:SendData( "__reload", data, ply )
		return
	end

	self.Handler:Reload( data )
end

function DEF_PAGE:Error( msg, fatal, ply )
	if SERVER then
		if !ply then return end

		self:SendData( "__error", {
			msg = msg,
			fatal = !!fatal
		}, ply )
	else
		if fatal and IsValid( self.Handler.Instance ) then
			self.Handler.Instance:Close()
		end
		
		self.Handler:Popup( self.Handler.Lang.Name.." - "..( fatal and LANG.SLCPAGES.fatal or LANG.SLCPAGES.error ), msg, false, { "OK" } )
	end

	self.Handler:Log( "[ERROR]["..self.ID.."]", msg, fatal )
end

function DEF_PAGE:Message( id, ply )
	if SERVER then
		if !ply then return end
		self:SendData( "__msg", {
			id = id,
		}, ply )
	else
		local msg

		if self.Lang.Messages then
			msg = self.Lang.Messages[id]
		end

		if !msg and self.Handler.Lang.Messages then
			msg = self.Handler.Lang.Messages[id]
		end

		self.Handler:Popup( self.Handler.Lang.Name.." - "..LANG.SLCPAGES.message, msg or id, false, { "OK" } )
	end
end

function DEF_PAGE:ReceiveData( name, func )
	self.Receivers[name] = func
end

function DEF_PAGE:GetSubPage( id )
	return self.PAGE and self.PAGE.SUB_PAGES[id] or self.SUB_PAGES[id]
end

if CLIENT then
	function DEF_PAGE:Load( root, data )
		if self.DirectBuild then
			if !istable( data ) then
				data = { data }
			end

			data.Root = root
			self.PageData = data
			self:Build( root, data )

			return data
		end

		
		local p, id = self:Request( "load", data )
		
		self.PageData = nil
		self.LastRequestID = id
		
		return p:Then( function( rdata )
			if !IsValid( root ) or rdata.RequestID != self.LastRequestID then return end
			if rdata.__banned then
				MsgC( Color( 255, 75, 75 ), "Banned", "\t", self.ID, "\t", rdata.__reason or "No reason provided", "\n" )
			elseif rdata.__restrict then
				MsgC( Color( 255, 75, 75 ), "Restricted", "\t", self.ID, "\n" )
			else
				rdata.Root = root
				self.PageData = rdata

				if self.Build then
					self:Build( root, rdata )
				end
			end

			return rdata
		end )/*:Catch( function( err )
			print( "[PAGE BUILD ERROR - "..self.Name.."]" )
			print( err )
		end )*/
	end

	function DEF_PAGE:Request( name, data, to, override )
		if override then
			for k, v in pairs( self.Requests ) do
				if v.name == name then
					v.promise:Reject( "discard" )
					self.Requests[k] = nil
				end
			end
		end

		local rid = self.ReqID
		local p = SLCPromise()

		self.Requests[rid] = {
			name = name,
			id = rid,
			promise = p,
		}

		self:SendData( "r"..rid.."_"..name, data )

		timer.Simple( to or self.Handler.CONFIG.Timeout, function()
			local pr = self.Requests[rid]
			if pr then
				self.Requests[rid] = nil
				pr.promise:Reject( "to" )
			end
		end )

		self.ReqID = self.ReqID + 1

		if self.ReqID > 999 then
			self.ReqID = 0
		end

		return p, rid
	end

	function DEF_PAGE:LoadPage( id, data )
		self.Handler:LoadPage( id, data )
	end

	function DEF_PAGE:NoBackend()
		self.DirectBuild = true
	end
end

if SERVER then
	function DEF_PAGE:LoadPage( id, data, ply )
		self:SendData( "__load", {
			id = id,
			data = data,
		}, ply )
	end
end

--[[-------------------------------------------------------------------------
Handler
---------------------------------------------------------------------------]]
local def_cfg = {
	Timeout = 5
}

local FrameHandler = {}
SLCFrameHandler = FrameHandler

local function handler_to_string( obj )
	return obj.Handler.Name.." Page: "..obj.Name.." ["..obj.ID.."]"
end

local function sub_to_string( obj )
	return obj.Handler.Name.." Sub Page: "..obj.Name.." ["..obj.ID.."]"
end

local cur_id
function FrameHandler:RegisterPage( data )
	assert( cur_id, "Illegal call of FrameHandler.RegisterPage!" )

	data.Handler = self
	data.ID = cur_id
	data.Name = data.Name or cur_id
	data.Lang = self.Lang.Pages and self.Lang.Pages[cur_id] or {}

	data.Messages = {}
	data.Receivers = {}
	data.Requests = {}
	data.ReqID = 0

	data.SUB_PAGES = {}

	setmetatable( data, {
		__metatable = "SLCPages",
		__tostring = handler_to_string,
		__index = DEF_PAGE,
	} )

	self.PAGES[cur_id] = data
	return data
end

function FrameHandler:RegisterSubPage( id, data )
	assert( PAGE, "Illegal call of FrameHandler.RegisterSubPage!" )

	data.Handler = self

	local spid = PAGE.ID.."_"..id
	data.ID = spid
	data.Name = data.Name or spid
	data.Lang = PAGE.Lang.SubPages and PAGE.Lang.SubPages[id] or {}
	data.PAGE = PAGE

	data.Messages = {}
	data.Receivers = {}
	data.Requests = {}
	data.ReqID = 0

	data.IsVisible = function() return SERVER end

	setmetatable( data, {
		__metatable = "SLCPages",
		__tostring = sub_to_string,
		__index = DEF_PAGE,
	} )

	self.PAGES[spid] = data
	PAGE.SUB_PAGES[id] = data

	return data
end

function FrameHandler:SubPage( id, data )
	assert( PAGE, "Illegal call of FrameHandler.SubPage!" )

	local sub = PAGE.SUB_PAGES[id]
	if !sub then
		sub = self:RegisterSubPage( id, data or {} )
	end

	SUBPAGE = sub
end

function FrameHandler:RegisterAction( id, cb, sort, color, is_visible )
	self.ACTIONS[id] = {
		callback = cb,
		sort = sort,
		color = color,
		is_visible = is_visible
	}
end

function FrameHandler:Panic( name )
	self:GetPage( name ).PANIC = true
end

function FrameHandler:GetPage( id )
	return self.PAGES[id]
end

function FrameHandler:GetAllPages()
	return self.PAGES
end

function FrameHandler:GetPages()
	local pages = {}

	for k, v in pairs( self.PAGES ) do
		if SERVER or v.ID != "index" and ( !v.IsVisible or v:IsVisible( LocalPlayer() ) ) then
			table.insert( pages, k )
		end
	end

	table.sort( pages, function( a, b )
		return ( self.PAGES[a].Order or 999 ) < ( self.PAGES[b].Order or 999 )
	end )

	return pages
end

function FrameHandler:GetButtons()
	local ply = LocalPlayer()
	local buttons = {}

	for k, v in pairs( self.PAGES ) do
		if CLIENT and ( v.ID == "index" or v.IsVisible and !v:IsVisible( ply ) ) then continue end

		table.insert( buttons, {
			name = v.Lang.Name or v.Name,
			page_id = k,
			page_obj = v,
			color = v.Color,
			sort = v.Order or 999
		} )
	end

	for k, v in pairs( self.ACTIONS ) do
		if CLIENT and v.is_visible and !v.is_visible( ply ) then continue end

		table.insert( buttons, {
			name = k,
			action = v.callback,
			color = v.color,
			sort = v.sort or 1111
		} )
	end

	table.sort( buttons, function( a, b )
		return a.sort < b.sort
	end )

	return buttons
end

function FrameHandler:IsBanned( ply, page )
	if CLIENT then return end
	--
end

function FrameHandler:Popup( name, text, keep, options, callback )
	if SERVER then return end
	SLCPopup( name, text, keep, options, callback )
end

function FrameHandler:OpenFrame()
	if SERVER or IsValid( self.Instance ) then return end

	self.Instance = vgui.Create( "SLCFrame" )
	self.Instance:SetHandler( self )
	self.Instance:SetFrameTitle( self.Lang.Name or self.Name )

	return self.Instance
end

function FrameHandler:CloseFrame()
	if SERVER or !IsValid( self.Instance ) then return end
	self.Instance:Remove()
end

function FrameHandler:IsFrameOpen()
	if SERVER then return end
	return IsValid( self.Instance )
end

function FrameHandler:LoadPage( id, data )
	if SERVER or !IsValid( self.Instance ) then return end
	self.Instance:LoadPage( id, data )
end

function FrameHandler:Reload( data )
	if SERVER or !IsValid( self.Instance ) then return end
	self.Instance:Reload( data )
end

function FrameHandler:Log( ... )
	print( "[SLCPage - "..self.Name.."]", ... )
end

--[[-------------------------------------------------------------------------
New Handler
---------------------------------------------------------------------------]]
SLCFrameHandlers = SLCFrameHandlers or {}

function GetSLCFrameHandler( name )
	return SLCFrameHandlers[name]
end

local function new_handler( _, name, path, cfg )
	if !path then
		path = BASE_GAMEMODE_PATH.."/"..name	
	end

	path = path.."/"

	local handler = setmetatable( {
		Name = name,
		Lang = CLIENT and LANG.SLCPAGES.PAGES[name] or {},
		CONFIG = table.Copy( def_cfg ),
	}, {
		__index = FrameHandler
	} )

	if cfg then
		for k, v in pairs( cfg ) do
			handler.CONFIG[k] = v
		end
	end

	SLCFrameHandlers[name] = handler
	handler.PAGES = {}
	handler.ACTIONS = {}
	handler.Errors = {}

	SLCPages = handler

	print( "# Loading page handler: "..name.." ("..path..")" )

	local _, folders = file.Find( path.."*", "LUA" )
	for _, folder in ipairs( folders ) do
		if string.sub( folder, 1, 1 ) == "_" then
			print( "  # Skipping page:"..string.sub( folder, 2 ) )
			continue
		end

		local manifest_file = "_"..folder..".lua"
		local manifest = path..folder.."/"..manifest_file
		if !file.Exists( manifest, "LUA" ) then return end

		print( "  # Loading page: "..folder )

		if SERVER then
			AddCSLuaFile( manifest )
		end

		cur_id = folder
		include( manifest )
		cur_id = nil

		local tab = handler.PAGES[folder]
		if !tab then return end

		PAGE = tab

		for _, f in ipairs( file.Find( path..folder.."/*.lua", "LUA" ) ) do
			if f == manifest_file then continue end

			local full = path..folder.."/"..f
			local pre = string.sub( f, 1, 3 )

			if SERVER and pre != "sv_" then
				AddCSLuaFile( full )
			end

			if SERVER and pre != "cl_" or CLIENT and pre != "sv_" then
				print( "    > "..f )
				SUBPAGE = nil
				include( full )
				SUBPAGE = nil
			end
		end

		PAGE = nil
	end

	SLCPages = nil

	return handler
end

setmetatable( FrameHandler, { __call = new_handler } )

--[[-------------------------------------------------------------------------
Net
---------------------------------------------------------------------------]]
if SERVER then
	util.AddNetworkString( "SLCPages" )

	net.Receive( "SLCPages", function( len, ply )
		local handler = GetSLCFrameHandler( net.ReadString() )
		if !handler then return end
		
		local page = handler:GetPage( net.ReadString() )
		if !page then return end
	
		local name, data = net.ReadString(), net.ReadTable()

		if net.ReadBit() == 1 then
			data.__bin = net.ReadData( net.ReadUInt( 32 ) )
		end

		page:ReceiveData_Internal( name, data, ply )
	end )
else
	net.Receive( "SLCPages", function( len )
		local handler = GetSLCFrameHandler( net.ReadString() )
		if !handler then return end

		local page = handler:GetPage( net.ReadString() )
		if !page then return end
		
		local name, data = net.ReadString(), net.ReadTable()

		if net.ReadBit() == 1 then
			data.__bin = net.ReadData( net.ReadUInt( 32 ) )
		end

		page:ReceiveData_Internal( name, data )
	end )
end