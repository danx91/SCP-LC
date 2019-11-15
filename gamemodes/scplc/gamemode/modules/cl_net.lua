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

net.Receive( "SCPForceExhaust", function( len )
	local ply = LocalPlayer()

	if !ply.Exhausted then
		ply.Stamina = 0
		ply.StaminaRegen = CurTime() + 0.5
	end
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

net.Receive( "PlayerSetup", function( len )
	HUDDrawSpawnInfo = CurTime() + 20
end )

net.Receive( "PlayerDespawn", function( len )
	clearPlayerIDs()
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
		ROUND.post = false
		ROUND.name = ""
		ROUND.time = 0
	elseif status == "live" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = false
		ROUND.post = false
	elseif status == "pre" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = true
		ROUND.post = false
	elseif status == "post" then
		ROUND.active = true
		ROUND.time = data.time
		ROUND.preparing = false
		ROUND.post = true
	end
end )

net.Receive( "DeathInfo", function( len )
	local data = net.ReadTable()

	DamageLogger.Print( data )
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
end

function ply:AddSCPVar( name, id, type )
	if !name or !id or !type then return end

	assert( id < 16, "Too big ID in AddSCPVar function. IDs cannot be greater than 15!" )
	assert( id >= 0, "ID in AddSCPVar cannot be negative!" )

	if !self.scp_var_table then
		self:SetupSCPVarTable()
	end

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
			ply.scp_var_table.BOOL[id] = net.ReadBool()
		elseif t == 16 then --INT
			ply.scp_var_table.INT[id] = net.ReadInt( 32 )
		elseif t == -32 then --FLOAT
			ply.scp_var_table.FLOAT[id] = net.ReadFloat()
		elseif t == -16 then --STRING
			ply.scp_var_table.STRING[id] = net.ReadString()
		end
	end
end )