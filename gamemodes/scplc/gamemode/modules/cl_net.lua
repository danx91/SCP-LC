--[[-------------------------------------------------------------------------
Receivers
---------------------------------------------------------------------------]]
net.ReceiveTable( "SLCPlayerMeta", function( data )
	LocalPlayer().playermeta = data
end )

net.ReceiveTable( "SLCInfoScreen", function( data )
	InfoScreen( { team = data.team, class = data.class }, data.type, data.time, data.data )
end )

net.Receive( "PlayerReady", function( len )
	LocalPlayer().playermeta = net.ReadTable()
end )

net.Receive( "SCPList", function( len )
	//SCPS = net.ReadTable()
	local data = net.ReadTable()
	local transmited = net.ReadTable()

	SCPS = {}
	ShowSCPs = {}

	for i, v in ipairs( data ) do
		table.insert( SCPS, v.name )
		table.insert( ShowSCPs, v )
	end

	for i, v in ipairs( SCPS ) do
		CLASSES[v] = v
	end

	for i, v in ipairs( transmited ) do
		CLASSES[v] = v
	end

	SetupForceSCP()
end )

net.Receive( "SLCEscape", function( len )
	EscapeStatus = net.ReadUInt( 2 )
	EscapeTimer = net.ReadFloat()
end )

net.Receive( "PlayerMessage", function( len )
	local msg = net.ReadString()
	local center = net.ReadBool()

	PlayerMessage( msg, nil, center )
end )

net.Receive( "CenterMessage", function( len )
	CenterMessage( net.ReadString() )
end )

net.Receive( "CameraDetect", function( len )
	local tab = net.ReadTable()

	for i, v in ipairs( tab ) do
		table.insert( SCPMarkers, { time = CurTime() + 10, data = v } )
	end
end )

/*net.Receive( "PlayerSetup", function( len )
	HUDDrawSpawnInfo = CurTime() + 20
end )*/

net.Receive( "PlayerCleanup", function( len )
	local ply = net.ReadEntity()

	if IsValid( ply ) then
		hook.Run( "SLCPlayerCleanup", ply )

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
		ROUND.active = false
		ROUND.preparing = false
		ROUND.infoscreen = false
		ROUND.post = false
		ROUND.name = ""
		ROUND.time = 0
	elseif status == "live" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = false
		ROUND.infoscreen = false
		ROUND.post = false
	elseif status == "inf" then
		CENTERMESSAGES = {}
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = true
		ROUND.infoscreen = true
		ROUND.post = false
	elseif status == "pre" then
		//CENTERMESSAGES = {}
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = true
		ROUND.infoscreen = false
		ROUND.post = false
	elseif status == "post" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = false
		ROUND.infoscreen = false
		ROUND.post = true
	end
end )

--[[-------------------------------------------------------------
SCP VARS
---------------------------------------------------------------]]
local ply = FindMetaTable( "Player" )
local _type = type

function ply:SetupSCPVarTable()
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

function ply:SCPVarUpdated( id, type, newVal )
	if newVal != nil then
		local cb = self.scp_var_callbacks[type][id]
		if cb then
			cb( self, newVal )
		end
	end
end

function ply:SetSCPVarCallback( id, type, cb )
	assert( _type( cb ) == "function", "Bad argument #1 to function SetSCPVarCallback. Function expected got ".._type( cb ) )

	self.scp_var_callbacks[type][id] = cb
end

function ply:AddSCPVar( name, id, type )
	if !name or !id or !type then return end

	if !self.scp_var_table then
		self:SetupSCPVarTable()
	end

	/*assert( self.scp_var_table[type], "Invalid type '"..type.."'!" )

	if !id then
		id = self.scp_var_lookup[type][name]
		print( "ID after lookup", type, name, id )

		if !id then
			for i = 0, 15 do
				if self.scp_var_table[type][i] == nil then
					id = i
					print( "Assigning id", type, name, id )
					break
				end
			end
		end
	end

	assert( id, "Failed to assign ID for SCPVar '"..name.."'! " )
	assert( id < 16, "You can only create maximum of 16 SCPVars of each type!" )*/
	assert( id < 16, "Too big ID in AddSCPVar function. IDs cannot be greater than 15!" )
	assert( id >= 0, "ID in AddSCPVar cannot be negative!" )

	if type == "BOOL" then
		self.scp_var_table.BOOL[id] = self.scp_var_table.BOOL[id] or false
		self["Set"..name] = function( self, b )
			assert( _type( b ) == "boolean", "Bad argument #1 to function Set"..name..". Boolean expected, got ".._type( b ) )
			self.scp_var_table.BOOL[id] = !!b
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.BOOL[id]
		end
	elseif type == "INT" then
		self.scp_var_table.INT[id] = self.scp_var_table.INT[id] or 0
		self["Set"..name] = function( self, int )
			assert( _type( int ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got ".._type( int ) )
			self.scp_var_table.INT[id] = math.floor( int )
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.INT[id]
		end
	elseif type == "FLOAT" then
		self.scp_var_table.FLOAT[id] = self.scp_var_table.FLOAT[id] or 0
		self["Set"..name] = function( self, f )
			assert( _type( f ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got ".._type( f ) )
			self.scp_var_table.FLOAT[id] = f
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.FLOAT[id]
		end
	elseif type == "STRING" then
		self.scp_var_table.STRING[id] = self.scp_var_table.STRING[id] or ""
		self["Set"..name] = function( self, str )
			assert( _type( str ) == "string", "Bad argument #1 to function Set"..name..". String expected, got ".._type( str ) )
			self.scp_var_table.STRING[id] = str
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.STRING[id]
		end
	end
end

function ply:RequestSCPVars()
	net.Start( "UpdateSCPVars" )
	net.SendToServer()
end

net.Receive( "UpdateSCPVars", function()
	local ply = LocalPlayer()

	if !ply.scp_var_table then
		if !ply.SetupSCPVarTable then return end

		ply:SetupSCPVarTable()
	end

	local len = net.ReadUInt( 6 )

	for i = 1, len do
		local sig = net.ReadInt( 6 )

		local t = bit.band( sig, -16 ) --xxxxxx & 110000
		local id = bit.band( sig, 15 ) --xxxxxx & 001111

		if t == 0 then --BOOL
			local val = net.ReadBool()
			ply.scp_var_table.BOOL[id] = val
			ply:SCPVarUpdated( id, "BOOL", val )
		elseif t == 16 then --INT
			local val = net.ReadInt( 32 )
			ply.scp_var_table.INT[id] = val
			ply:SCPVarUpdated( id, "INT", val )
		elseif t == -32 then --FLOAT
			local val = net.ReadFloat()
			ply.scp_var_table.FLOAT[id] = val
			ply:SCPVarUpdated( id, "FLOAT", val )
		elseif t == -16 then --STRING
			local val = net.ReadString()
			ply.scp_var_table.STRING[id] = val
			ply:SCPVarUpdated( id, "STRING", val )
		end
	end
end )