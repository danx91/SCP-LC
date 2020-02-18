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
function registerPlayerStatus( name, default, set, reset )
	PlayerStatus[name] = { default, set, reset }
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
		data.Status[k] = v[1]

		ply["Set"..k] = function( ply, value )
			data:SetStatus( k, value )
		end

		ply["Get"..k] = function( ply )
			return data:GetStatus( k )
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
		self.Stats[name] = sessionstat

		if HasFlag( stat, PlayerStats.STAT_ARCHIVE ) then
			self.Player:SetSCPData( name, globalstat )
		end
	end
end

function PlayerData:GetStat( name )
	local stat = self.Stat[name]

	if !stat then
		if HasFlag( v, PlayerStats.STAT_NUMBER ) or HasFlag( v, PlayerStats.STAT_INT ) then
			stat = 0
		elseif HasFlag( v, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif HasFlag( v, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:GetRoundStat( name )
	local stat = self.Round[name]

	if !stat then
		if HasFlag( v, PlayerStats.STAT_NUMBER ) or HasFlag( v, PlayerStats.STAT_INT ) then
			stat = 0
		elseif HasFlag( v, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif HasFlag( v, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:GetSessionStat( name )
	local stat = self.Session[name]

	if !stat then
		if HasFlag( v, PlayerStats.STAT_NUMBER ) or HasFlag( v, PlayerStats.STAT_INT ) then
			stat = 0
		elseif HasFlag( v, PlayerStats.STAT_BOOLEAN ) then
			stat = false
		elseif HasFlag( v, PlayerStats.STAT_STRING ) then
			stat = ""
		end
	end

	return stat
end

function PlayerData:Reset( roundend )
	for k, v in pairs( PlayerStatus ) do
		local reset = true

		if v[3] == false then
			reset = false
		elseif v[3] == true and !roundend then
			reset = false
		elseif isfunction( v[3] ) then
			reset = !v[3]( self.Player, self.Status[k], v[1] )
		end

		if reset then
			self.Status[k] = v[1]
		end
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

	if self.Status[name] != value then
		if !PlayerStatus[name][2] or PlayerStatus[name][2]( self.Player, self.Status[name], value ) != true then
			self.Status[name] = value
		end
	end
end

setmetatable( PlayerData, { __call = PlayerData.Create } )

---------------------------- BASE STATS ----------------------------



--------------------------------------------------------------------

---------------------------- BASE STATUS ----------------------------
//registerPlayerStatus( "name", <initial value>, func/false[nil], nil/func/ture/false* )
//* - true: only on roundend, false: never, nil: always, func: return true to suppress

registerPlayerStatus( "Premium", false, function( ply, old, new ) ply:Set_SCPPremium( new ) end, false )
registerPlayerStatus( "Active", false, function( ply, old, new ) ply:Set_SCPActive( new ) end, false )

registerPlayerStatus( "InitialTeam", 0, false, true )

registerPlayerStatus( "Blink", false )
registerPlayerStatus( "SightLimit", -1 )

registerPlayerStatus( "SCPHuman", false )
registerPlayerStatus( "SCPChat", false )
registerPlayerStatus( "SCPNoRagdoll", false )
registerPlayerStatus( "SCPTerror", true )

registerPlayerStatus( "SCP714", false )
--------------------------------------------------------------------
-- for k, v in pairs( player.GetAll() ) do
-- 	PlayerData( v )
-- end