PlayerStats = {
	_STATS = {},
	STAT_ARCHIVE = bit.lshift( 1, 0 ),
	STAT_NUMBER = bit.lshift( 1, 1 ),
	STAT_INT = bit.lshift( 1, 2 ),
	STAT_BOOLEAN = bit.lshift( 1, 3 ),
	STAT_STRING = bit.lshift( 1, 4 ),
}

local PlayerStatus = {}

function PlayerStats.Register( name, flags )
	PlayerStats._STATS[name] = flags
end

--set = function( ply, old, new ) return true to prevent
--reset = function( ply, val ) return true to prevent
function RegisterPlayerStatus( name, default, set, reset, transmit )
	assert( name != "_reset", "PlayerStatus name '_reset' is forbidden!" )

	local t = type( default )
	assert( !transmit or t == "number" or t == "boolean", "Failed to register PlayerStatus! Transmited PlayerStatus only supports numbers and booleans!" )

	PlayerStatus[name] = { def = default, set = set, reset = reset, transmit = transmit and t }
end

local function HasFlag( num, flag )
	return bit.band( num, flag ) == flag
end

PlayerData = {}

function PlayerData:Create( ply )
	local data = setmetatable( {}, { __index = PlayerData } )
	data.Create = function() end

	ply.PlayerData = data
	data.Player = ply

	data.Stats = {}
	data.Round = {}
	data.Session = {}

	data.Status = {}

	for k, v in pairs( PlayerStatus ) do
		data.Status[k] = v.def

		ply["Set"..k] = function( p, value )
			data:SetStatus( k, value )
		end

		ply["Get"..k] = function( p )
			return data:GetStatus( k )
		end

		/*if v.transmit then
			local use = nil

			if v.transmit == "BOOL" or v.transmit == "INT" or v.transmit == "FLOAT" or v.transmit == "STRING" then
				use = v[4]
			else
				local t = type( v.def )
				if t == "number" then
					use = "FLOAT"
				elseif t == "string" then
					use = "STRING"
				elseif t == "boolean" then
					use = "BOOL"
				end
			end

			if use then
				local id = ply:AddSCPVar( "PD_"..k, use )

				if id then
					v.transmit_ok = true
				end

				if CLIENT then
					ply:SetSCPVarCallback( id, use, function( p, val )
						/*if v[2] then
							v[2]( p, k, val )
						end*/

						/*print( "callback", p, k, val )
						data.Status[k] = val
					end )
				end
			end
		end*/
	end

	data:SetupData()

	return data
end

function PlayerData:AddStat( name, value, replace )
	local stat = PlayerStats._STATS[name]
	local globalstat = self.Stats[name]
	local roundstat = self.Round[name]
	local sessionstat = self.Session[name]

	if stat then
		if HasFlag( stat, PlayerStats.STAT_INT ) or HasFlag( stat, PlayerStats.STAT_NUMBER ) then
			globalstat = replace and value or ( ( globalstat or 0 ) + ( value or 1 ) )
			roundstat = replace and value or ( ( roundstat or 0 ) + ( value or 1 ) )
			sessionstat = replace and value or ( ( sessionstat or 0 ) + ( value or 1 ) )
		else
			globalstat = value
			roundstat = value
			sessionstat = value
		end

		self.Stats[name] = globalstat
		self.Round[name] = roundstat
		self.Session[name] = sessionstat

		if HasFlag( stat, PlayerStats.STAT_ARCHIVE ) then
			self.Player:SetSCPData( name, globalstat )
		end
	end
end

function PlayerData:GetStat( name )
	local stat_flag = PlayerStats._STATS[name]
	local stat = self.Stats[name]

	if !stat then
		if HasFlag( stat_flag, PlayerStats.STAT_NUMBER ) or HasFlag( stat_flag, PlayerStats.STAT_INT ) then
			stat = 0
		elseif HasFlag( stat_flag, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif HasFlag( stat_flag, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:GetRoundStat( name )
	local stat_flag = PlayerStats._STATS[name]
	local stat = self.Round[name]

	if !stat then
		if HasFlag( stat_flag, PlayerStats.STAT_NUMBER ) or HasFlag( stat_flag, PlayerStats.STAT_INT ) then
			stat = 0
		elseif HasFlag( stat_flag, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif HasFlag( stat_flag, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:GetSessionStat( name )
	local stat_flag = PlayerStats._STATS[name]
	local stat = self.Session[name]

	if !stat then
		if HasFlag( stat_flag, PlayerStats.STAT_NUMBER ) or HasFlag( stat_flag, PlayerStats.STAT_INT ) then
			stat = 0
		elseif HasFlag( stat_flag, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif HasFlag( stat_flag, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:Reset( roundend )
	//local names = ""
	local to_transmit = {}

	for k, v in pairs( PlayerStatus ) do
		local reset = true

		if v.reset == false then
			reset = false
		elseif v.reset == true and !roundend then
			reset = false
		elseif isfunction( v.reset ) then
			reset = !v.reset( self.Player, self.Status[k], v.def )
		end

		if reset then
			//if v[2] then v[2]( self.Player, self.Status[k], v.def ) end
			self.Status[k] = v.def

			/*if v.transmit_ok then
				local func = self.Player["SetPD"..k]
				if func then
					func( v.def )
				end
			end*/

			/*if v[4] == true then
				names = names..k..";"
			end*/

			if v.transmit then
				table.insert( to_transmit, k )
			end
		end
	end

	/*if names != "" then
		net.Ping( "SLCPlayerData", "_reset:"..names, self.Player )
	end*/

	if SERVER and #to_transmit > 0 then
		net.Start( "SLCPlayerDataUpdate" )
			net.WriteString( "_reset" )
			net.WriteTable( to_transmit ) -- shouldn't exceed limit
		net.Send( self.Player )
	end
end

function PlayerData:RoundReset()
	self.Round = {}
	self:Reset( true )
end

function PlayerData:SetupData()
	for k, v in pairs( PlayerStats._STATS ) do
		local saved = HasFlag( v, PlayerStats.STAT_ARCHIVE ) and self.Player:GetSCPData( k )

		if HasFlag( v, PlayerStats.STAT_NUMBER ) or HasFlag( v, PlayerStats.STAT_INT ) then
			if saved != nil then 
				self.Stats[k] = tonumber( saved )
			else
				self.Stats[k] = 0
			end
		elseif HasFlag( v, PlayerStats.STAT_BOOLEAN ) then
			if saved != nil then 
				self.Stats[k] = tobool( saved )
			else
				self.Stats[k] = false
			end
		elseif HasFlag( v, PlayerStats.STAT_STRING ) then
			if saved != nil then 
				self.Stats[k] = saved
			else
				self.Stats[k] = ""
			end
		end
	end
end

function PlayerData:GetStatus( name )
	assert( self.Status[name] != nil, "Tried to access invalid player status: "..name )

	return self.Status[name]
end

function PlayerData:SetStatus( name, value )
	assert( value != nil, "Bad argument #2 to SetStatus, any value expected got nil" )
	assert( self.Status[name] != nil, "Tried to set invalid player status: "..name )

	local obj = PlayerStatus[name]
	if self.Status[name] != value then
		if !obj.set or obj.set( self.Player, self.Status[name], value ) != true then
			self.Status[name] = value

			/*if obj.transmit_ok then
				local func = self.Player["SetPD"..name]
				if func then
					func( v.def )
				end
			end*/

			/*if obj[4] then
				net.Ping( "SLCPlayerData", name..":"..tostring( value ), self.Player )
			end*/

			if SERVER and obj.transmit then
				net.Start( "SLCPlayerDataUpdate" )
					net.WriteString( name )

					if obj.transmit == "boolean" then
						net.WriteBool( value )
					else
						net.WriteFloat( value )
					end

				net.Send( self.Player )
			end
		end
	end
end

setmetatable( PlayerData, { __call = PlayerData.Create } )

//local ply = FindMetaTable( "Player" )
--create direct bindings to PlayerData table

/*if CLIENT then
	net.ReceivePing( "SLCPlayerData", function( data )
		local name, value = string.match( data, "(.-):(.+)" )

		if !name then
			name = data

			local obj = PlayerStatus[name]
			if !obj then return end

			value = obj[1]
		end

		if name == "_reset" then
			for line in string.gmatch( value, "[^;]+" ) do
				local obj = PlayerStatus[line]

				if obj then
					LocalPlayer().PlayerData.Status[line] = obj[1]
					//print( "PD reset", line )
				end
			end
		else
			local obj = PlayerStatus[name]

			if obj then
				local t = type( obj[1] )

				if t == "number" then
					value = tonumber( value )
				elseif t == "boolean" then
					value = tobool( value )
				end

				//print( "casted", value, type( value ) )
				if value != nil then
					LocalPlayer().PlayerData.Status[name] = value
					//print( "PD set", name, value )
				end
			end
		end
	end )
end*/

if CLIENT then
	net.Receive( "SLCPlayerDataUpdate", function( len )
		local ply = LocalPlayer()
		local name = net.ReadString()

		if name == "_reset" then
			local to_reset = net.ReadTable()

			for k, v in pairs( to_reset ) do
				local obj = PlayerStatus[v]
				if obj then
					ply.PlayerData.Status[v] = obj.def
				end
			end
		else
			local obj = PlayerStatus[name]
			if obj then
				if obj.transmit == "boolean" then
					ply.PlayerData.Status[name] = net.ReadBool()
				else
					ply.PlayerData.Status[name] = net.ReadFloat()
				end
			end
		end
	end )
end

---------------------------- BASE STATS ----------------------------



--------------------------------------------------------------------

---------------------------- BASE STATUS ----------------------------
//RegisterPlayerStatus( "name", <initial value>, func/false[nil], nil/func/ture/false* )
//* - true: only on roundend, false: never, nil: always, func: return true to suppress
//name cannot contain ':'

RegisterPlayerStatus( "Premium", false, function( ply, old, new ) ply:Set_SCPPremium( new ) end, false )
RegisterPlayerStatus( "Active", false, function( ply, old, new ) ply:Set_SCPActive( new ) end, false )

RegisterPlayerStatus( "InitialTeam", 0, false, true )

RegisterPlayerStatus( "Blink", false )
RegisterPlayerStatus( "SightLimit", -1 )

RegisterPlayerStatus( "SCPHuman", false, nil, nil, true )
RegisterPlayerStatus( "SCPCanInteract", false )
RegisterPlayerStatus( "SCPChat", false )
RegisterPlayerStatus( "SCPNoRagdoll", false )
RegisterPlayerStatus( "SCPDisableOverload", false )
//RegisterPlayerStatus( "SCPTerror", true )

RegisterPlayerStatus( "SCP714", false, nil, nil, true )
RegisterPlayerStatus( "SCP096Chase", false )
--------------------------------------------------------------------
 /*for k, v in pairs( player.GetAll() ) do
 	PlayerData( v )
 	v:SetActive( true )
 end*/