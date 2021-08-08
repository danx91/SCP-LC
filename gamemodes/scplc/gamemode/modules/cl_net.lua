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

	if SetupForceSCP then SetupForceSCP() end
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

net.Receive( "SLCProgressBar", function( len )
	local enable = net.ReadBool()
	if enable then
		local start_time = net.ReadFloat()
		local end_time = net.ReadFloat()
		local text = net.ReadString()

		if text == "" then
			text = nil
		end

		SetProgressBarColor( Color( 225, 225, 225, 255 ), Color( 75, 75, 90, 255 ) )
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

function ply:SCPVarUpdated( id, data_type, new_val )
	if new_val != nil then
		local cb = self.scp_var_callbacks[data_type][id]
		if cb then
			cb( self, new_val )
		end
	end
end

function ply:SetSCPVarCallback( id, data_type, cb )
	assert( type( cb ) == "function", "Bad argument #1 to function SetSCPVarCallback. Function expected got "..type( cb ) )

	self.scp_var_callbacks[data_type][id] = cb
end

function ply:AddSCPVar( name, id, data_type )
	if !name or !id or !data_type then return end

	if !self.scp_var_table then
		self:SetupSCPVarTable()
	end

	/*assert( self.scp_var_table[data_type], "Invalid data_type '"..data_type.."'!" )

	if !id then
		id = self.scp_var_lookup[data_type][name]
		print( "ID after lookup", data_type, name, id )

		if !id then
			for i = 0, 15 do
				if self.scp_var_table[data_type][i] == nil then
					id = i
					print( "Assigning id", data_type, name, id )
					break
				end
			end
		end
	end

	assert( id, "Failed to assign ID for SCPVar '"..name.."'! " )
	assert( id < 16, "You can only create maximum of 16 SCPVars of each data_type!" )*/
	assert( id < 16, "Too big ID in AddSCPVar function. IDs cannot be greater than 15!" )
	assert( id >= 0, "ID in AddSCPVar cannot be negative!" )

	if data_type == "BOOL" then
		self.scp_var_table.BOOL[id] = self.scp_var_table.BOOL[id] or false
		self["Set"..name] = function( this, b )
			assert( type( b ) == "boolean", "Bad argument #1 to function Set"..name..". Boolean expected, got "..type( b ) )
				this.scp_var_table.BOOL[id] = !!b
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.BOOL[id]
		end
	elseif data_type == "INT" then
		self.scp_var_table.INT[id] = self.scp_var_table.INT[id] or 0
		self["Set"..name] = function( this, int )
			assert( type( int ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got "..type( int ) )
				this.scp_var_table.INT[id] = math.floor( int )
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.INT[id]
		end
	elseif data_type == "FLOAT" then
		self.scp_var_table.FLOAT[id] = self.scp_var_table.FLOAT[id] or 0
		self["Set"..name] = function( this, f )
			assert( type( f ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got "..type( f ) )
			this.scp_var_table.FLOAT[id] = f
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.FLOAT[id]
		end
	elseif data_type == "STRING" then
		self.scp_var_table.STRING[id] = self.scp_var_table.STRING[id] or ""
		self["Set"..name] = function( this, str )
			assert( type( str ) == "string", "Bad argument #1 to function Set"..name..". String expected, got "..type( str ) )
			this.scp_var_table.STRING[id] = str
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.STRING[id]
		end
	end
end

function ply:RequestSCPVars()
	net.Start( "UpdateSCPVars" )
	net.SendToServer()
end

net.Receive( "UpdateSCPVars", function()
	local lp = LocalPlayer()

	if !lp.scp_var_table then
		if !lp.SetupSCPVarTable then return end

		lp:SetupSCPVarTable()
	end

	local len = net.ReadUInt( 6 )

	for i = 1, len do
		local sig = net.ReadInt( 6 )

		local t = bit.band( sig, -16 ) --xxxxxx & 110000
		local id = bit.band( sig, 15 ) --xxxxxx & 001111

		if t == 0 then --BOOL
			local val = net.ReadBool()
			lp.scp_var_table.BOOL[id] = val
			lp:SCPVarUpdated( id, "BOOL", val )
		elseif t == 16 then --INT
			local val = net.ReadInt( 32 )
			lp.scp_var_table.INT[id] = val
			lp:SCPVarUpdated( id, "INT", val )
		elseif t == -32 then --FLOAT
			local val = net.ReadFloat()
			lp.scp_var_table.FLOAT[id] = val
			lp:SCPVarUpdated( id, "FLOAT", val )
		elseif t == -16 then --STRING
			local val = net.ReadString()
			lp.scp_var_table.STRING[id] = val
			lp:SCPVarUpdated( id, "STRING", val )
		end
	end
end )