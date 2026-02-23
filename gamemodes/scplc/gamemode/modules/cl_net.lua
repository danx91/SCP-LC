--[[-------------------------------------------------------------------------
Receivers
---------------------------------------------------------------------------]]
net.ReceiveTable( "SLCPlayerMeta", function( data )
	LocalPlayer().playermeta = data
end )

net.ReceiveTable( "SLCInfoScreen", function( data )
	if data.type == "spawn" then
		SLCWindowAlert()
	end

	InfoScreen( { team = data.team, class = data.class }, data.type, data.time, data.data )

	hook.Run( "SLCCloseMinigames" )
end )

net.Receive( "PlayerReady", function( len )
	LocalPlayer().playermeta = net.ReadTable()
end )

net.Receive( "SCPList", function( len )
	local data = net.ReadTable()

	SCPS = {}
	ShowSCPs = {}
	SCPStats = {}

	local lang_tab = _LANG_DEFAULT
	local lang = lang_tab.CLASSES
	local numbers = {}

	for i, v in ipairs( data ) do
		local name = v.name
		
		CLASSES[name] = name
		SCPStats[name] = v

		if !v.hide then
			table.insert( ShowSCPs, v )
		end
		
		local nice_name = lang[name]
		if !nice_name then
			numbers[name] = { 0, 0 }
		else
			local n1, n2 = string.match( nice_name, "SCP[%s%-](%d+)-?(%d*)" )
			numbers[name] = { tonumber( n1 ) or 0, tonumber( n2 ) or 0 }
		end

		if !v.no_select then
			table.insert( SCPS, name )
		end
	end

	table.sort( ShowSCPs, function( a, b )
		if numbers[a.name][1] == numbers[b.name][1] then
			return numbers[a.name][2] < numbers[b.name][2]
		end

		return numbers[a.name][1] < numbers[b.name][1]
	end )

	hook.Run( "SetupForceSCP" )
end )

net.Receive( "SLCEscape", function( len )
	ESCAPE_STATUS = net.ReadUInt( 2 )
	ESCAPE_TIMER = net.ReadFloat()
end )

net.Receive( "PlayerMessage", function( len )
	local msg = net.ReadString()
	local center = net.ReadBool()

	PlayerMessage( msg, nil, center )
end )

net.Receive( "CenterMessage", function( len )
	CenterMessage( net.ReadString() )
end )

net.Receive( "SLCChatPrint", function( len )
	chat.AddText( unpack( net.ReadTable() ) )
end )

net.Receive( "SLCProgressBar", function( len )
	local enable = net.ReadBool()
	if enable then
		local start_time = net.ReadFloat()
		local end_time = net.ReadFloat()
		local text = net.ReadString()
		local col1 = net.ReadColor()
		local col2 = net.ReadColor()

		if text == "" then
			text = nil
		end

		SetProgressBarColor( col1, col2 )
		TimeBasedProgressBar( start_time, end_time, text )
	else
		ProgressBar( false )
	end
end )

net.Receive( "CameraDetect", function( len )
	local tab = net.ReadTable()

	for i, v in ipairs( tab ) do
		table.insert( SCPMarkers, { time = CurTime() + 10, data = v } )
	end
end )

net.Receive( "InitialIDs", function( len )
	//HUDDrawSpawnInfo = CurTime() + 20
	SetupInitialIDs( net.ReadTable() )
end )

net.Receive( "PlayerCleanup", function( len )
	local ply = net.ReadEntity()
	if IsValid( ply ) then
		hook.Run( "SLCPlayerCleanup", ply )

		ply:ResetProperties()
		
		if ply == LocalPlayer() then
			ClearPlayerIDs()
		end
	end
end )

net.Receive( "RoundInfo", function( len )
	local data = net.ReadTable()

	if data.name then
		ROUND.name = data.name
	end

	local status = data.status

	if status == "off" then
		CENTERMESSAGES = {}
		hook.Run( "SLCRoundCleanup" )

		ROUND.active = false
		ROUND.preparing = false
		ROUND.infoscreen = false
		ROUND.post = false
		ROUND.name = ""
		ROUND.time = 0
		ROUND.duration = 0
	elseif status == "live" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.duration = data.duration
		ROUND.preparing = false
		ROUND.infoscreen = false
		ROUND.post = false
	elseif status == "inf" then
		CENTERMESSAGES = {}
		hook.Run( "SLCRoundCleanup" )
		
		ROUND.active = true
		ROUND.time = data.time
		ROUND.duration = data.duration
		ROUND.preparing = true
		ROUND.infoscreen = true
		ROUND.post = false
	elseif status == "pre" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.duration = data.duration
		ROUND.preparing = true
		ROUND.infoscreen = false
		ROUND.post = false
	elseif status == "post" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.duration = data.duration
		ROUND.preparing = false
		ROUND.infoscreen = false
		ROUND.post = true

		SLCWindowAlert()
	end
end )

net.Receive( "SLCRoundProperties", function( len )
	for k, v in pairs( net.ReadTable() ) do
		ROUND.properties[k] = v
	end
end )

net.Receive( "SCPHooks", function( len )
	local mode = net.ReadBool()

	if mode then
		local tab = net.ReadTable()

		ClearSCPHooks()

		for k, v in pairs( tab ) do
			EnableSCPHook( k )
		end
	else
		local scp = net.ReadString()
		EnableSCPHook( scp )
	end
end )

net.Receive( "SLCXPSummary", function( len )
	local data = net.ReadTable()

	HUDXPSummaryData = nil

	local tab = {}
	local general_index

	for i, v in ipairs( XPSUMMARY_ORDER ) do
		if data[v] then
			local index = table.insert( tab, { data[v], v } )
			data[v] = nil

			if v == "general" then
				general_index = index
			end
		end
	end

	for k, v in pairs( data ) do
		if !general_index then
			general_index = table.insert( tab, { 0, "general" } )
		end
		
		tab[general_index][1] = tab[general_index][1] + v
	end

	HUDXPSummary = tab
end )

net.Receive( "SLCGasZones", function( len )
	local reset = net.ReadBool()
	local old_power = SLC_GAS.GasPower

	SLC_GAS = net.ReadTable()
	SLC_GAS_VENT = net.ReadTable()

	if reset then
		SLC_GAS.GasPower = 0
	else
		SLC_GAS.GasPower = old_power or 0
	end
end )

net.Receive( "SLCHitMarker", function( len )
	ShowHitMarker()
end )

net.Receive( "SLCDamageIndicator", function( len )
	ShowDamageIndicator( net.ReadUInt( 10 ), net.ReadFloat(), net.ReadFloat() )
end )

net.ReceivePing( "AFKSlayWarning", function( data )
	SLCAFKWarning = true
end )

--[[-------------------------------------------------------------
SLC VARS
---------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:SetupSLCVarTable()
	self.scp_var_table = {
		BOOL = {},
		INT = {},
		FLOAT = {},
		STRING = {},
	}

	self.scp_var_callbacks = {
		BOOL = {},
		INT = {},
		FLOAT = {},
		STRING = {},
	}
end

function PLAYER:SLCVarUpdated( id, var_type, new_val )
	if new_val != nil then
		local cb = self.scp_var_callbacks[var_type][id]
		if cb then
			cb( self, new_val )
		end
	end
end

function PLAYER:SetSLCVarCallback( id, var_type, cb )
	assert( self.scp_var_callbacks[var_type], "Invalid var_type '"..var_type.."'!" )
	assert( type( cb ) == "function", "Bad argument #1 to function SetSLCVarCallback. Function expected got "..type( cb ) )

	self.scp_var_callbacks[var_type][id] = cb
end

function PLAYER:AddSLCVar( name, id, var_type, cb )
	if !name or !id or !var_type then return end

	if !self.scp_var_table then
		self:SetupSLCVarTable()
	end

	assert( self.scp_var_table[var_type], "Invalid var_type '"..var_type.."'!" )
	assert( id < 64, "Too big ID in AddSLCVar function. IDs cannot be greater than 63!" )
	assert( id >= 0, "ID in AddSLCVar cannot be negative!" )

	if var_type == "BOOL" then
		self.scp_var_table.BOOL[id] = self.scp_var_table.BOOL[id] or false
		self["Set"..name] = function( this, b )
			assert( type( b ) == "boolean", "Bad argument #1 to function Set"..name..". Boolean expected, got "..type( b ) )
			this.scp_var_table.BOOL[id] = !!b
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.BOOL[id]
		end
	elseif var_type == "INT" then
		self.scp_var_table.INT[id] = self.scp_var_table.INT[id] or 0
		self["Set"..name] = function( this, int )
			assert( type( int ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got "..type( int ) )
			this.scp_var_table.INT[id] = math.floor( int )
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.INT[id]
		end
	elseif var_type == "FLOAT" then
		self.scp_var_table.FLOAT[id] = self.scp_var_table.FLOAT[id] or 0
		self["Set"..name] = function( this, f )
			assert( type( f ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got "..type( f ) )
			this.scp_var_table.FLOAT[id] = f
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.FLOAT[id]
		end
	elseif var_type == "STRING" then
		self.scp_var_table.STRING[id] = self.scp_var_table.STRING[id] or ""
		self["Set"..name] = function( this, str )
			assert( type( str ) == "string", "Bad argument #1 to function Set"..name..". String expected, got "..type( str ) )
			this.scp_var_table.STRING[id] = str
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.STRING[id]
		end
	end

	if cb then
		self:SetSLCVarCallback( id, var_type, cb )
	end
end

function PLAYER:RequestSLCVars()
	net.Start( "UpdateSLCVars" )
	net.SendToServer()
end

local FLAG_BOOL = 0 //b00000000
local FLAG_INT = 64  //b01000000
local FLAG_FLOAT = -128  //b10000000
local FLAG_STRING = -64  //b11000000
local TYPE_MASK = FLAG_STRING
local ID_MASK = -FLAG_STRING - 1

net.Receive( "UpdateSLCVars", function()
	local lp = LocalPlayer()

	if !lp.scp_var_table then
		if !lp.SetupSLCVarTable then return end

		lp:SetupSLCVarTable()
	end

	local len = net.ReadUInt( 8 )

	for i = 1, len do
		local sig = net.ReadInt( 8 )

		local t = bit.band( sig, TYPE_MASK )
		local id = bit.band( sig, ID_MASK )

		if t == FLAG_BOOL then --BOOL
			local val = net.ReadBool()
			lp.scp_var_table.BOOL[id] = val
			lp:SLCVarUpdated( id, "BOOL", val )
		elseif t == FLAG_INT then --INT
			local val = net.ReadInt( 32 )
			lp.scp_var_table.INT[id] = val
			lp:SLCVarUpdated( id, "INT", val )
		elseif t == FLAG_FLOAT then --FLOAT
			local val = net.ReadFloat()
			lp.scp_var_table.FLOAT[id] = val
			lp:SLCVarUpdated( id, "FLOAT", val )
		elseif t == FLAG_STRING then --STRING
			local val = net.ReadString()
			lp.scp_var_table.STRING[id] = val
			lp:SLCVarUpdated( id, "STRING", val )
		end
	end
end )