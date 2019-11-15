SCPTeams = {
	INFO_ALIVE = bit.lshift( 1, 0 ),
	INFO_HUMAN = bit.lshift( 1, 1 ),
	INFO_SCP = bit.lshift( 1, 2 ),
	REG = {},
	SCORE = {}
}

function SCPTeams.register( name, info, clr, reward, canescape )
	_G["TEAM_"..name] = table.insert( SCPTeams.REG, { info = info or 0, color = clr, name = name, reward = reward, canescape = canescape } )
end

function SCPTeams.setupAllies( tab1, tab2 )
	tab1 = istable( tab1 ) and tab1 or { tab1 }
	tab2 = tab2 or tab1

	for k, v in pairs( tab1 ) do
		local t = SCPTeams.REG[v]
		t.relations = t.relations or {}
		
		for _k, _v in pairs( tab2 ) do
			if v != _v then
				t.relations[_v] = true
			end
		end
	end
end

function SCPTeams.setupEscort( team, tab )
	tab = istable( tab ) and tab or { tab }

	local t = SCPTeams.REG[team]
	t.escort = t.escort or {}

	for k, v in pairs( tab ) do
		t.escort[v] = true
	end
end

function SCPTeams.isAlly( team1, team2 )
	if team1 == team2 then return true end

	local t = SCPTeams.REG[team1]
	if t and t.relations then
		return t.relations[team2] == true
	end
end

function SCPTeams.getAllies( team )
	local t = SCPTeams.REG[team]
	
	if t and t.relations then
		local allies = {}

		for k, v in pairs( t.relations ) do
			if v == true then
				table.insert( allies, k )
			end
		end

		return allies
	end
end

function SCPTeams.canEscort( team1, team2 )
	if !SCPTeams.REG[team1] then return end
	if !SCPTeams.REG[team1].escort then return end

	return SCPTeams.REG[team1].escort[team2]
end 

function SCPTeams.canEscape( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].canescape
end

function SCPTeams.getName( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].name
end

function SCPTeams.getColor( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].color
end

function SCPTeams.getReward( team )
	if !SCPTeams.REG[team] then return end

	return SCPTeams.REG[team].reward
end

function SCPTeams.setScore( team, score )
	SCPTeams.SCORE[team] = score
end

function SCPTeams.getScore( team, score )
	if !SCPTeams.SCORE[team] then
		SCPTeams.SCORE[team] = 0
	end

	return SCPTeams.SCORE[team]
end

function SCPTeams.addScore( team, score )
	if !SCPTeams.SCORE[team] then
		SCPTeams.SCORE[team] = 0
	end

	SCPTeams.SCORE[team] = SCPTeams.SCORE[team] + score
end

function SCPTeams.highestScore()
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

	return #team == 1 and team[1] or team
end

function SCPTeams.resetScore()
	for k, v in pairs( SCPTeams.SCORE ) do
		SCPTeams.SCORE[k] = 0
	end
end

function SCPTeams.hasInfo( team, info )
	local t = SCPTeams.REG[team]

	if t then
		if !t.info then
			t.info = 0
		end

		return bit.band( t.info, info ) == info
	end
end

function SCPTeams.getPlayersByTeam( team )
	local plys = {}

	for k, v in pairs( player.GetAll() ) do
		if v:SCPTeam() == team then
			table.insert( plys, v )
		end
	end

	return plys
end

function SCPTeams.getPlayersByInfo( info )
	local plys = {}

	for k, v in pairs( player.GetAll() ) do
		if SCPTeams.hasInfo( v:SCPTeam(), info ) then
			table.insert( plys, v )
		end
	end

	return plys
end

local ply = FindMetaTable( "Player" )

function ply:SCPTeam()
	if !self.Get_SCPTeam then
		self:DataTables()
	end

	return self:Get_SCPTeam()
end

function ply:SetSCPTeam( team )
	if !self.Set_SCPTeam then
		self:DataTables()
	end

	self:Set_SCPTeam( team )
	self:Set_SCPPersonaT( team )
end

SCPTeams.register( "SPEC", 0, Color( 150, 150, 150 ), 0 )
SCPTeams.register( "CLASSD", SCPTeams.INFO_ALIVE + SCPTeams.INFO_HUMAN, Color( 242, 125, 25 ), 1, true )
SCPTeams.register( "SCIENT", SCPTeams.INFO_ALIVE + SCPTeams.INFO_HUMAN, Color( 60, 200, 215 ), 2, true )
SCPTeams.register( "MTF", SCPTeams.INFO_ALIVE + SCPTeams.INFO_HUMAN, Color( 30, 50, 180 ), 3, false )
SCPTeams.register( "CI", SCPTeams.INFO_ALIVE + SCPTeams.INFO_HUMAN, Color( 10, 80, 5 ), 3, false )
SCPTeams.register( "SCP", SCPTeams.INFO_ALIVE + SCPTeams.INFO_SCP, Color( 100, 0, 0 ), 10, true )

SCPTeams.setupAllies( { TEAM_CLASSD, TEAM_CI } )
SCPTeams.setupAllies( { TEAM_SCIENT, TEAM_MTF } )

SCPTeams.setupEscort( TEAM_MTF, TEAM_SCIENT )
SCPTeams.setupEscort( TEAM_CI, TEAM_CLASSD )