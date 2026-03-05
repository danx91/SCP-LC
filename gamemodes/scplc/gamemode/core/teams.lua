SCPTeams = {
	ALL = {},
	REGISTRY = {},
	SCORE = {},
}

local info_num = 0

--[[---------------------------------------------------------------------------
SCPTeams.AddTeamInfo( name )

Registers info flag that can be added to teams

@param		[string]		name				Name of the info, SCPTeams.INFO_[NAME] will be created (name will be converted to upper case)

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function SCPTeams.AddTeamInfo( name )
	if !isstring( name ) then argerror( 1, "AddTeamInfo", "string", type( name ) ) end

	local key = "INFO_"..string.upper( name )
	if SCPTeams[key] then
		return SCPTeams[key]
	end

	if info_num > 31 then
		ErrorNoHalt( "Cannot add new TeamInfo! Maximum amount is 32\n" )
		return
	end

	local info = bit.lshift( 1, info_num )
	info_num = info_num + 1

	SCPTeams[key] = info

	return info
end

--[[---------------------------------------------------------------------------
SCPTeams.Register( name, data )

Registers new team

@param		[string]		name				Team name, global TEAM_[NAME] will be created (name will be converted to upper case)
@param		[TeamData]		data				Team data

@return		[nil]			-					-

Types:
	TeamData [table]
		@field		[Color]					color				Team color
		@field		[number]				reward				Initial reward for killing class in this team
		@field		[number]				reward_max			Optional, maximum reward for killing class in this team, defaults to 5x reward
		@field		[string]				group				Optional, team group for automatic ally relation and common score calculation, defaults to name
		@field		[boolean]				can_escape			Optional, whether this team can naturally escape, defaults to false
		@field		[number/table]			info				Optional, teams info flag, either number or table of flags (bit.bor will be used), defaults to 0
---------------------------------------------------------------------------]]--
function SCPTeams.Register( name, data )
	if !isstring( name ) then argerror( 1, "Register", "string", type( name ) ) end
	if !istable( data ) then argerror( 2, "Register", "table", type( data ) ) end

	if !IsColor( data.color ) then fielderror( "color", 2, "Register", "Color", type( data.color ) ) end
	if !isnumber( data.reward ) then fielderror( "reward", 2, "Register", "number", type( data.reward ) ) end

	if data.reward_max and !isnumber( data.reward_max ) then fielderror( "reward_max", 2, "Register", "number", type( data.reward_max ) ) end
	if data.group and !isstring( data.group ) then fielderror( "group", 2, "Register", "string", type( data.group ) ) end
	if data.can_escape and !isbool( data.can_escape ) then fielderror( "can_escape", 2, "Register", "boolean", type( data.can_escape ) ) end
	if data.info and !isnumber( data.info ) and !istable( data.info ) then fielderror( "info", 2, "Register", "number or table", type( data.info ) ) end

	name = string.upper( name )

	local info = 0
	if istable( data.info ) then
		info = next( data.info ) and bit.bor( unpack( data.info ) ) or 0
	elseif data.info then
		info = data.info
	end

	local tab = {
		name = name,
		color = data.color,
		reward = data.reward,
		reward_max = data.reward_max or ( data.reward * 5 ),
		group = data.group or name,
		can_escape = data.can_escape or false,
		info = info,

		relations = {},
		escort = {},
		escorted_by = {},
	}

	local index = table.insert( SCPTeams.REGISTRY, tab )

	table.insert( SCPTeams.ALL, index )
	_G["TEAM_"..name] = index
end

--[[---------------------------------------------------------------------------
SCPTeams.GetAll()

Gets all teams

@return		[table]			teams			Table containing all teams
---------------------------------------------------------------------------]]--
function SCPTeams.GetAll()
	return SCPTeams.ALL
end

--[[-------------------------------------------------------------------------
Team functions
---------------------------------------------------------------------------]]
function SCPTeams.AddInfo( team, info )
	local data = SCPTeams.REGISTRY[team]
	if !data then return end

	data.info = bit.bor( data.info, info )
end

function SCPTeams.RemoveInfo( team, info )
	local data = SCPTeams.REGISTRY[team]
	if !data then return end

	data.info = bit.band( data.info, bit.bnot( info ) )
end

function SCPTeams.HasInfo( team, info )
	local data = SCPTeams.REGISTRY[team]
	if !data then return false end

	return bit.band( data.info, info ) == info
end

function SCPTeams.InGroup( team, group )
	local data = SCPTeams.REGISTRY[team]
	if !data then return false end

	return data.group == group
end

function SCPTeams.GetName( team )
	local data = SCPTeams.REGISTRY[team]
	if !data then return false end

	return data.name
end

function SCPTeams.GetColor( team )
	local data = SCPTeams.REGISTRY[team]
	if !data then return false end

	return data.color
end

function SCPTeams.GetReward( team )
	local data = SCPTeams.REGISTRY[team]
	if !data then return false end

	return data.reward, data.reward_max
end

function SCPTeams.CanEscape( team )
	local data = SCPTeams.REGISTRY[team]
	if !data then return false end

	return data.can_escape
end

--[[-------------------------------------------------------------------------
Team relations
---------------------------------------------------------------------------]]
function SCPTeams.SetupAllies( tab, ally )
	if !istable( tab ) then
		tab = { tab }
	end

	if !ally then
		ally = tab
	elseif ally == true then
		ally = SCPTeams.ALL
	elseif !istable( ally ) then
		ally = { ally }
	end

	for k, v in pairs( tab ) do
		local t = SCPTeams.REGISTRY[v]

		for _k, _v in pairs( ally ) do
			if v != _v then
				t.relations[_v] = true
			end
		end
	end
end

function SCPTeams.SetupNeutral( tab, neutral )
	if !istable( tab ) then
		tab = { tab }
	end

	if !neutral then
		neutral = tab
	elseif neutral == true then
		neutral = SCPTeams.ALL
	elseif !istable( neutral ) then
		neutral = { neutral }
	end

	for k, v in pairs( tab ) do
		local t = SCPTeams.REGISTRY[v]

		for _k, _v in pairs( neutral ) do
			if v != _v then
				t.relations[_v] = false
			end
		end
	end
end

function SCPTeams.SetupEnemy( tab, enemy )
	if !istable( tab ) then
		tab = { tab }
	end

	if !enemy then
		enemy = tab
	elseif enemy == true then
		enemy = SCPTeams.ALL
	elseif !istable( enemy ) then
		enemy = { enemy }
	end

	for k, v in pairs( tab ) do
		local t = SCPTeams.REGISTRY[v]

		for _k, _v in pairs( enemy ) do
			if v != _v then
				t.relations[_v] = nil
			end
		end
	end
end

function SCPTeams.Relation( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REGISTRY[team1]
	if t then
		return t.relations[team2]
	end

	return false
end

function SCPTeams.PlayerDamageRelation( ply1, ply2 )
	local prevent_rdm = ply1:GetProperty( "prevent_rdm" )
	local override = ply1:GetProperty( "relation_override" )

	if override then
		local use, result = override( ply1, ply2 )
		if use then
			if result == nil and prevent_rdm then
				return false
			end

			return result
		end
	end

	local result = SCPTeams.Relation(
		ply1:GetProperty( "dmg_team_override" ) or ply1:SCPTeam(),
		ply2:GetProperty( "dmg_team_override" ) or ply2:SCPTeam()
	)

	if result == nil and prevent_rdm then
		return false
	end

	return result
end

function SCPTeams.IsEnemy( team1, team2 )
	if team1 == team2 then return false end

	local t = SCPTeams.REGISTRY[team1]
	if t then
		return t.relations[team2] == nil
	end

	return true
end

function SCPTeams.IsAlly( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REGISTRY[team1]
	if t then
		return t.relations[team2] == true
	end

	return false
end

function SCPTeams.IsNeutral( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REGISTRY[team1]
	if t then
		return t.relations[team2] == false
	end

	return false
end

function SCPTeams.GetAllies( team, include_self )
	local t = SCPTeams.REGISTRY[team]

	if t then
		local allies = {}

		for k, v in pairs( t.relations ) do
			if v == true then
				table.insert( allies, k )
			end
		end

		if include_self then
			table.insert( allies, team )
		end

		return allies
	end
end

--[[-------------------------------------------------------------------------
Escort rules
---------------------------------------------------------------------------]]
function SCPTeams.SetupEscort( team, tab )
	tab = istable( tab ) and tab or { tab }

	local t = SCPTeams.REGISTRY[team]
	if !t then return end

	for k, v in pairs( tab ) do
		t.escort[v] = true

		local t2 = SCPTeams.REGISTRY[v]
		if !t2 then continue end

		t2.escorted_by[team] = true
	end
end

function SCPTeams.CanEscort( team1, team2 )
	if !SCPTeams.REGISTRY[team1] then return false end
	if !next( SCPTeams.REGISTRY[team1].escort ) then return false end

	if team2 == true then
		return true
	end

	return SCPTeams.REGISTRY[team1].escort[team2]
end

function SCPTeams.CanBeEscorted( team1, team2 )
	if !SCPTeams.REGISTRY[team1] then return false end
	if !next( SCPTeams.REGISTRY[team1].escorted_by ) then return false end

	if team2 == true then
		return true
	end

	if !SCPTeams.REGISTRY[team2] then return false end
	return SCPTeams.REGISTRY[team2].escort[team1]
end

function SCPTeams.GetEscort( team )
	if !SCPTeams.REGISTRY[team] then return {} end
	if !next( SCPTeams.REGISTRY[team].escort ) then return {} end

	local tab = {}

	for k, v in pairs( SCPTeams.REGISTRY[team].escort ) do
		table.insert( tab, k )
	end

	return tab
end

function SCPTeams.GetEscortedBy( team )
	if !SCPTeams.REGISTRY[team] then return {} end
	if !next( SCPTeams.REGISTRY[team].escorted_by ) then return {} end

	local tab = {}

	for k, v in pairs( SCPTeams.REGISTRY[team].escorted_by ) do
		table.insert( tab, k )
	end

	return tab
end

--[[-------------------------------------------------------------------------
Team score
---------------------------------------------------------------------------]]
function SCPTeams.SetScore( team, score )
	local data = SCPTeams.REGISTRY[team]
	if !data then return end

	SCPTeams.SCORE[data.group] = score
end

function SCPTeams.GetScore( team, score )
	local data = SCPTeams.REGISTRY[team]
	if !data then return end

	local group = data.group

	if !SCPTeams.SCORE[group] then
		SCPTeams.SCORE[group] = 0
	end

	return SCPTeams.SCORE[group]
end

function SCPTeams.AddScore( team, score )
	local data = SCPTeams.REGISTRY[team]
	if !data then return end

	local group = data.group

	if !SCPTeams.SCORE[group] then
		SCPTeams.SCORE[group] = 0
	end

	SCPTeams.SCORE[group] = SCPTeams.SCORE[group] + score
end

function SCPTeams.HighestScore()
	local score = 0
	local group

	for k, v in pairs( SCPTeams.SCORE ) do
		if v > score then
			score = v
			group = { k }
		elseif v > 0 and v == score then
			table.insert( group, k )
		end
	end

	return group
end

function SCPTeams.ResetScore()
	for k, v in pairs( SCPTeams.SCORE ) do
		SCPTeams.SCORE[k] = 0
	end
end

--[[-------------------------------------------------------------------------
Helper functions
---------------------------------------------------------------------------]]
function SCPTeams.GetPlayersByTeam( team )
	local plys = {}

	for i, v in ipairs( player.GetAll() ) do
		if v:SCPTeam() == team then
			table.insert( plys, v )
		end
	end

	return plys
end

function SCPTeams.GetPlayersByInfo( info )
	local plys = {}

	for i, v in ipairs( player.GetAll() ) do
		if SCPTeams.HasInfo( v:SCPTeam(), info ) then
			table.insert( plys, v )
		end
	end

	return plys
end

function SCPTeams.GetPlayersByGroup( group )
	local plys = {}

	for i, v in ipairs( player.GetAll() ) do
		if SCPTeams.InGroup( v:SCPTeam(), group ) then
			table.insert( plys, v )
		end
	end

	return plys
end

function SCPTeams.GetTeamsByGroup()
	local tab = {}

	for i, v in ipairs( SCPTeams.REGISTRY ) do
		if SCPTeams.InGroup( i ) then
			table.insert( tab, i )
		end
	end

	return tab
end

--[[-------------------------------------------------------------------------
Player funtions
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:SCPTeam()
	if !self.Get_SCPTeam then
		self:DataTables()
	end

	return self:Get_SCPTeam()
end

function PLAYER:SetSCPTeam( team, persona )
	if !self.Set_SCPTeam then
		self:DataTables()
	end

	self:Set_SCPTeam( team )
	self:Set_SCPPersonaT( persona or team )
end

--[[-------------------------------------------------------------------------
Base teams
---------------------------------------------------------------------------]]
//SCPTeams.AddTeamInfo( "ALIVE" ) 	// Unused atm
SCPTeams.AddTeamInfo( "HUMAN" )
SCPTeams.AddTeamInfo( "SCP" )
SCPTeams.AddTeamInfo( "STAFF" )

SCPTeams.Register( "SPEC", {
	color = Color( 150, 150, 150 ),
	reward = 0,
} )

SCPTeams.Register( "CLASSD", {
	color = Color( 242, 125, 25 ),
	reward = 2,
	max_reward = 20,
	can_escape = true,
	info = SCPTeams.INFO_HUMAN,
} )

SCPTeams.Register( "SCI", {
	color = Color( 60, 200, 220 ),
	reward = 2,
	max_reward = 20,
	can_escape = true,
	info = { SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF },
	group = "STAFF",
} )

SCPTeams.Register( "GUARD", {
	color = Color( 30, 75, 110 ),
	reward = 3,
	max_reward = 25,
	can_escape = false,
	info = { SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF },
	group = "STAFF",
} )

SCPTeams.Register( "MTF", {
	color = Color( 10, 20, 80 ),
	reward = 4,
	max_reward = 30,
	can_escape = false,
	info = { SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF },
	group = "STAFF",
} )

SCPTeams.Register( "CI", {
	color = Color( 10, 80, 5 ),
	reward = 4,
	max_reward = 30,
	can_escape = false,
	info = { SCPTeams.INFO_HUMAN },
} )

SCPTeams.Register( "GOC", {
	color = Color( 80, 5, 130 ),
	reward = 4,
	max_reward = 30,
	can_escape = false,
	info = { SCPTeams.INFO_HUMAN },
} )

SCPTeams.Register( "SCP", {
	color = Color( 100, 0, 0 ),
	reward = 10,
	max_reward = 75,
	can_escape = true,
	info = {},
} )

hook.Run( "SLCSetupTeams" )

SCPTeams.SetupNeutral( TEAM_GOC, true )
SCPTeams.SetupNeutral( { TEAM_CLASSD, TEAM_SCI, TEAM_GUARD }, TEAM_GOC )
SCPTeams.SetupNeutral( { TEAM_CLASSD, TEAM_SCI } )

SCPTeams.SetupEnemy( TEAM_GOC, { TEAM_SCP, TEAM_CI } )

SCPTeams.SetupAllies( { TEAM_CLASSD, TEAM_CI } )
SCPTeams.SetupAllies( { TEAM_SCI, TEAM_GUARD, TEAM_MTF } )

SCPTeams.SetupEscort( TEAM_MTF, TEAM_SCI )
SCPTeams.SetupEscort( TEAM_GUARD, TEAM_SCI )
SCPTeams.SetupEscort( TEAM_CI, TEAM_CLASSD )

hook.Run( "SLCTeamsRelations" )