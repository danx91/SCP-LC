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

function RegisterPlayerStatus( name, default, set, reset, transmit )
	assert( name != "_reset", "PlayerStatus name '_reset' is forbidden!" )

	local db_key
	local t = type( default )
	if t == "string" then
		local key, init = string.match( default, "^!(.+):(.-)$" )
		if key and init then
			db_key = key

			local try_num = tonumber( init )
			if try_num then
				default = try_num
			elseif init == "true" then
				default = true
			elseif init == "false" then
				default = false
			else
				default = init
			end
		end
	end
	
	assert( !transmit or t == "number" or t == "boolean", "Failed to register PlayerStatus! Transmited PlayerStatus only supports numbers and booleans!" )

	PlayerStatus[name] = { def = default, set = set, reset = reset, transmit = transmit and t, db = db_key }
end

local function has_flag( num, flag )
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
			data:SetStatus( k, value, v.db )
		end

		ply["Get"..k] = function( p )
			return data:GetStatus( k )
		end

		if SERVER and v.db then
			ply:GetSCPData( v.db, v.def ):Then( function( db_val )
				data:SetStatus( k, tonumber( db_val ) or db_val )
			end )
		end
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
		if has_flag( stat, PlayerStats.STAT_INT ) or has_flag( stat, PlayerStats.STAT_NUMBER ) then
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

		if has_flag( stat, PlayerStats.STAT_ARCHIVE ) then
			self.Player:SetSCPData( name, globalstat )
		end
	end
end

function PlayerData:GetStat( name )
	local stat_flag = PlayerStats._STATS[name]
	local stat = self.Stats[name]

	if !stat then
		if has_flag( stat_flag, PlayerStats.STAT_NUMBER ) or has_flag( stat_flag, PlayerStats.STAT_INT ) then
			stat = 0
		elseif has_flag( stat_flag, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif has_flag( stat_flag, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:GetRoundStat( name )
	local stat_flag = PlayerStats._STATS[name]
	local stat = self.Round[name]

	if !stat then
		if has_flag( stat_flag, PlayerStats.STAT_NUMBER ) or has_flag( stat_flag, PlayerStats.STAT_INT ) then
			stat = 0
		elseif has_flag( stat_flag, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif has_flag( stat_flag, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:GetSessionStat( name )
	local stat_flag = PlayerStats._STATS[name]
	local stat = self.Session[name]

	if !stat then
		if has_flag( stat_flag, PlayerStats.STAT_NUMBER ) or has_flag( stat_flag, PlayerStats.STAT_INT ) then
			stat = 0
		elseif has_flag( stat_flag, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif has_flag( stat_flag, PlayerStats.STAT_STRING ) then
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
		local saved = has_flag( v, PlayerStats.STAT_ARCHIVE ) and self.Player:GetSCPData( k ) --TODO turn to promise

		if has_flag( v, PlayerStats.STAT_NUMBER ) or has_flag( v, PlayerStats.STAT_INT ) then
			if saved != nil then 
				self.Stats[k] = tonumber( saved )
			else
				self.Stats[k] = 0
			end
		elseif has_flag( v, PlayerStats.STAT_BOOLEAN ) then
			if saved != nil then 
				self.Stats[k] = tobool( saved )
			else
				self.Stats[k] = false
			end
		elseif has_flag( v, PlayerStats.STAT_STRING ) then
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

function PlayerData:SetStatus( name, value, db )
	assert( value != nil, "Bad argument #2 to SetStatus, any value expected got nil" )
	assert( self.Status[name] != nil, "Tried to set invalid player status: "..name )

	local obj = PlayerStatus[name]
	if self.Status[name] != value then
		if !obj.set or obj.set( self.Player, self.Status[name], value ) != true then
			self.Status[name] = value

			if db then
				self.Player:SetSCPData( db, value )
			end

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

if CLIENT then
	net.Receive( "SLCPlayerDataUpdate", function( len )
		local ply = LocalPlayer()
		if !IsValid( ply ) or !ply.PlayerData then return end
		
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
//RegisterPlayerStatus( "name", <initial value>, set: func/false[nil], reset: nil/func/ture/false*, transmit )
//set = function( ply, old, new ) return true to prevent
//reset = function( ply, val ) return true to prevent
//* - true: only on roundend, false: never, nil: always, func: return true to suppress
//name cannot contain ':'
//if <initial value> is like '!key:value', value will be initially set to 'value' and will be replaced with value in database with key 'key'
//(gamemode will always try to convert 'value' to number or bool)

RegisterPlayerStatus( "Premium", false, function( ply, old, new ) ply:Set_SCPPremium( new ) end, false )
RegisterPlayerStatus( "Active", false, function( ply, old, new ) ply:Set_SCPActive( new ) end, false )

RegisterPlayerStatus( "InitialTeam", 0, false, true )

RegisterPlayerStatus( "Blink", false )
RegisterPlayerStatus( "NextBlink", -1 )
RegisterPlayerStatus( "SightLimit", -1 )
RegisterPlayerStatus( "SCPPenalty", "!scp_penalty:0", false, false )
RegisterPlayerStatus( "SCPKarma", "!scp_karma:250", false, false )

RegisterPlayerStatus( "SCPHuman", false, nil, nil, true )
RegisterPlayerStatus( "SCPCanInteract", false )
RegisterPlayerStatus( "SCPChat", false )
RegisterPlayerStatus( "SCPNoRagdoll", false )
RegisterPlayerStatus( "SCPDisableOverload", false, nil, nil, true )

RegisterPlayerStatus( "SCPChase", false )
RegisterPlayerStatus( "ChaseLevel", 0 )
--------------------------------------------------------------------
 /*for i, v in ipairs( player.GetAll() ) do
 	PlayerData( v )
 	v:SetActive( true )
 end*/