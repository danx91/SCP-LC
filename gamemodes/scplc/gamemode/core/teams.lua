SCPTeams = {
	ALL = {},
	REG = {},
	SCORE = {}
}

local info_num = 0
function SCPTeams.AddTeamInfo( name )
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

function SCPTeams.Register( name, info, clr, reward, can_escape )
	local n = table.insert( SCPTeams.REG, {
		info = info or 0,
		color = clr, name = name,
		reward = math.floor( reward ),
		can_escape = can_escape,
		relations = {},
		escort = {},
		escorted_by = {},
	} )

	_G["TEAM_"..name] = n
	table.insert( SCPTeams.ALL, n )
end

function SCPTeams.GetAll()
	return SCPTeams.ALL
end

function SCPTeams.AddInfo( team, info )
	local t = SCPTeams.REG[team]
	if t then
		t.info = bit.bor( t.info, info )
	end
end

function SCPTeams.RemoveInfo( team, info )
	local t = SCPTeams.REG[team]
	if t then
		t.info = bit.band( t.info, bit.bnot( info ) )
	end
end

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
		local t = SCPTeams.REG[v]

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
		local t = SCPTeams.REG[v]

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
		local t = SCPTeams.REG[v]

		for _k, _v in pairs( enemy ) do
			if v != _v then
				t.relations[_v] = nil
			end
		end
	end
end

function SCPTeams.SetupEscort( team, tab )
	tab = istable( tab ) and tab or { tab }

	local t = SCPTeams.REG[team]
	if !t then return end

	for k, v in pairs( tab ) do
		t.escort[v] = true

		local t2 = SCPTeams.REG[v]
		if !t2 then continue end

		t2.escorted_by[team] = true
	end
end

function SCPTeams.IsEnemy( team1, team2 )
	if team1 == team2 then return false end

	local t = SCPTeams.REG[team1]
	if t then
		return t.relations[team2] == nil
	end

	return true
end

function SCPTeams.IsAlly( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REG[team1]
	if t then
		return t.relations[team2] == true
	end

	return false
end

function SCPTeams.IsNeutral( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REG[team1]
	if t then
		return t.relations[team2] == false
	end

	return false
end

function SCPTeams.GetAllies( team, include_self )
	local t = SCPTeams.REG[team]

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

function SCPTeams.CanEscort( team1, team2 )
	if !SCPTeams.REG[team1] then return false end
	if !next( SCPTeams.REG[team1].escort ) then return false end

	if team2 == true then
		return true
	end

	return SCPTeams.REG[team1].escort[team2]
end

function SCPTeams.CanBeEscorted( team1, team2 )
	if !SCPTeams.REG[team1] then return false end
	if !next( SCPTeams.REG[team1].escorted_by ) then return false end

	if team2 == true then
		return true
	end

	if !SCPTeams.REG[team2] then return false end
	return SCPTeams.REG[team2].escort[team1]
end

function SCPTeams.GetEscort( team )
	if !SCPTeams.REG[team] then return {} end
	if !next( SCPTeams.REG[team].escort ) then return {} end

	local tab = {}

	for k, v in pairs( SCPTeams.REG[team].escort ) do
		table.insert( tab, k )
	end

	return tab
end

function SCPTeams.GetEscortedBy( team )
	if !SCPTeams.REG[team] then return {} end
	if !next( SCPTeams.REG[team].escorted_by ) then return {} end

	local tab = {}

	for k, v in pairs( SCPTeams.REG[team].escorted_by ) do
		table.insert( tab, k )
	end

	return tab
end

function SCPTeams.CanEscape( team )
	if !SCPTeams.REG[team] then return false end

	return SCPTeams.REG[team].can_escape
end

function SCPTeams.GetName( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].name
end

function SCPTeams.GetColor( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].color
end

function SCPTeams.GetReward( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].reward
end

function SCPTeams.SetScore( team, score )
	SCPTeams.SCORE[team] = score
end

function SCPTeams.GetScore( team, score )
	if !SCPTeams.SCORE[team] then
		SCPTeams.SCORE[team] = 0
	end

	return SCPTeams.SCORE[team]
end

function SCPTeams.AddScore( team, score )
	if !SCPTeams.SCORE[team] then
		SCPTeams.SCORE[team] = 0
	end

	SCPTeams.SCORE[team] = SCPTeams.SCORE[team] + score
end

function SCPTeams.HighestScore()
	local score = 0
	local team

	for k, v in pairs( SCPTeams.SCORE ) do
		if v > score then
			score = v
			team = { k }
		elseif v > 0 and v == score then
			table.insert( team, k )
		end
	end

	if !team then
		return
	end

	return #team == 1 and team[1] or team
end

function SCPTeams.ResetScore()
	for k, v in pairs( SCPTeams.SCORE ) do
		SCPTeams.SCORE[k] = 0
	end
end

function SCPTeams.HasInfo( team, info )
	local t = SCPTeams.REG[team]

	if t then
		if !t.info then
			t.info = 0
		end

		return bit.band( t.info, info ) == info
	end
end

function SCPTeams.GetPlayersByTeam( team )
	local plys = {}

	for i, v in ipairs( player.GetAll() ) do
		if v:SCPTeam() == team then
			table.insert( plys, v )
		end
	end

	return plys
end

function SCPTeams.GetPlayersByInfo( info, alive )
	local plys = {}

	for i, v in ipairs( player.GetAll() ) do
		if SCPTeams.HasInfo( v:SCPTeam(), info ) and ( !alive or v:Alive() ) then
			table.insert( plys, v )
		end
	end

	return plys
end

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

SCPTeams.AddTeamInfo( "ALIVE" )
SCPTeams.AddTeamInfo( "HUMAN" )
SCPTeams.AddTeamInfo( "SCP" )
SCPTeams.AddTeamInfo( "STAFF" )

SCPTeams.Register( "SPEC", 0, Color( 150, 150, 150 ), 0 )
SCPTeams.Register( "CLASSD", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN ), Color( 242, 125, 25 ), 1, true )
SCPTeams.Register( "SCI", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF ), Color( 60, 200, 220 ), 2, true )
SCPTeams.Register( "GUARD", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF ), Color( 30, 75, 110 ), 3, false )
SCPTeams.Register( "MTF", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN, SCPTeams.INFO_STAFF ), Color( 10, 20, 80 ), 4, false )
SCPTeams.Register( "CI", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN ), Color( 10, 80, 5 ), 4, false )
SCPTeams.Register( "GOC", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_HUMAN ), Color( 80, 5, 130 ), 4, false )
SCPTeams.Register( "SCP", bit.bor( SCPTeams.INFO_ALIVE, SCPTeams.INFO_SCP ), Color( 100, 0, 0 ), 10, true )

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