--[[-------------------------------------------------------------------------
Escape system
---------------------------------------------------------------------------]]
ESCAPE_STATUS = ESCAPE_STATUS or 0 -- 0 - no escape; 1 - escape; 2 - blocked;
ESCAPE_TIMER = ESCAPE_TIMER or 0
LAST_ESCAPE = LAST_ESCAPE or {}
LAST_ESCAPE_LOOKUP = LAST_ESCAPE_LOOKUP or {}

local function TransmitEscapeInfo( plys, override )
	net.Start( "SLCEscape" )
		net.WriteUInt( override or ESCAPE_STATUS, 2 )
		net.WriteFloat( ESCAPE_TIMER )
	net.Send( plys )
end

local function GetEscapeData()
	local teams = {}
	local players = {}
	local all = {}

	for i, v in ipairs( player.GetAll() ) do
		local team = v:SCPTeam()
		if team == TEAM_SPEC or !v:IsInEscape() then continue end

		teams[team] = true
		table.insert( all, v )

		local override = v:GetProperty( "escape_override" )
		if override == false then continue end

		if override or SCPTeams.CanEscape( team ) or GetRoundProperty( "alpha_warhead_activated" ) then
			table.insert( players, v )
		end
	end

	for t1, v1 in pairs( teams ) do
		for t2, v2 in pairs( teams ) do
			if SCPTeams.IsEnemy( t1, t2 ) then
				return players, true, all
			end
		end
	end

	return players, false, all
end

function CheckEscape()
	if ROUND.post then return end

	local t = GetTimer( "SLCRound" )
	if IsValid( t ) and ESCAPE_STATUS == 0 then
		local tab, blocked, all = GetEscapeData()

		if #tab > 0 then
			ESCAPE_STATUS = blocked and 2 or 1
			ESCAPE_TIMER = blocked and 0 or CurTime() + 20
			LAST_ESCAPE = blocked and all or tab
			LAST_ESCAPE_LOOKUP = CreateLookupTable( LAST_ESCAPE )

			//print( "Starting Escape", ESCAPE_STATUS )

			TransmitEscapeInfo( blocked and all or tab )
		end
	end
end

local NEscape = 0
hook.Add( "Tick", "SLCEscapeCheck", function()
	if ROUND.post or ESCAPE_STATUS == 0 then return end
	if NEscape > CurTime() then return end
	NEscape = CurTime() + 0.5

	local tab, blocked, all = GetEscapeData()

	if #tab == 0 then
		ESCAPE_STATUS = 0
		ESCAPE_TIMER = 0

		TransmitEscapeInfo( LAST_ESCAPE )
		LAST_ESCAPE = {}
		LAST_ESCAPE_LOOKUP = {}

		//print( "Escape aborted!" )
		return
	else
		local ls = ESCAPE_STATUS
		ESCAPE_STATUS = blocked and 2 or 1

		if ESCAPE_STATUS != ls then
			ESCAPE_TIMER = blocked and 0 or CurTime() + 20

			//print( "status changed", ESCAPE_STATUS, ls )
			TransmitEscapeInfo( blocked and all or tab )
		end
		--else
			local done = {}
			local transmit = {}
			local ntransmit = {}

			for k, v in ipairs( blocked and all or tab ) do
				if !LAST_ESCAPE_LOOKUP[v] then
					table.insert( transmit, v )
					//print( "player added to escape", v )
				end

				done[v] = true
			end

			for k, v in ipairs( LAST_ESCAPE ) do
				if !done[v] then
					table.insert( ntransmit, v )
					//print( "player removed from escape", v )
				end
			end

			if #transmit > 0 then
				TransmitEscapeInfo( transmit )
			end

			if #ntransmit > 0 then
				TransmitEscapeInfo( ntransmit, 0 )
			end
		--end

		LAST_ESCAPE = blocked and all or tab
		LAST_ESCAPE_LOOKUP = CreateLookupTable( LAST_ESCAPE )
	end

	//print( "EscapeTick", ESCAPE_STATUS )

	if ESCAPE_STATUS == 1 and ESCAPE_TIMER > 0 and ESCAPE_TIMER <= CurTime() then
		//print( "EscapePlayers" )
		//PrintTable( tab )

		ESCAPE_STATUS = 0
		ESCAPE_TIMER = 0
		LAST_ESCAPE = {}
		LAST_ESCAPE_LOOKUP = {}

		TransmitEscapeInfo( tab )

		if GetRoundProperty( "alpha_warhead_activated" ) then
			local xp = CVAR.slc_xp_alpha_escape:GetInt()
			local min, max = string.match( CVAR.slc_xp_escape:GetString(), "^(%d+),(%d+)$" )
			local time_xp = 0

			local t = GetTimer( "SLCRound" )
			if IsValid( t ) then
				local time = t:GetRemainingTime() / t:GetTime()

				if time < 0.2 then
					time_xp = min
				elseif time > 0.8 then
					time_xp = max
				else
					time_xp = math.Map( time, 0.2, 0.8, min, max )
				end

				time_xp = math.floor( time_xp )
			end

			for k, v in ipairs( tab ) do
				//CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;alpha_escape;escapexp$%d", xp ), v )
				if hook.Run( "SLCPlayerEscaped", v, true ) == true then continue end

				local team = v:SCPTeam()
				local give_xp = SCPTeams.CanEscape( team ) and math.max( time_xp, xp ) or xp

				InfoScreen( v, "escaped", INFO_SCREEN_DURATION, {
					"escape2",
					{ "escape_xp", "text;"..give_xp }
				} )

				v:AddXP( give_xp, "escape" )
				SCPTeams.AddScore( team, SCPTeams.GetReward( team ) * 2 )

				v:Despawn()
				v:SkipNextSuicide()

				v:KillSilent()
				v:SetSCPTeam( TEAM_SPEC )
				v:SetSCPClass( "spectator" )
				v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

				local stat = SCPTeams.GetStat( team, "escape" )
				if stat then
					stat:AddValue( 1, { player = v, type = "alpha" } )
				end
			end
		else
			local t = GetTimer( "SLCRound" )
			if IsValid( t ) or ROUND.aftermatch then
				local min, max = string.match( CVAR.slc_xp_escape:GetString(), "^(%d+),(%d+)$" )
				min = tonumber( min )
				max = tonumber( max )

				local xp = 0
				local msg

				local rtime, ttime, diff
				local xp_info = { "escape_xp" }

				local mult_tab = {
					skip_count = {},
					skip_mult = {},
					bonus_mult = {},
				}

				for i, v in ipairs( tab ) do
					mult_tab[v] = 1
				end

				hook.Run( "SLCEscapeMultiplier", tab, mult_tab )

				if ROUND.aftermatch then
					xp = min

					msg = {
						"escape1",
						xp_info
					}
				else
					rtime = t:GetRemainingTime()
					ttime = t:GetTime()
					diff = math.floor( ttime - rtime )

					local time = rtime / ttime
					if time < 0.2 then
						xp = min
					elseif time > 0.8 then
						xp = max
					else
						xp = math.Map( time, 0.2, 0.8, min, max )
					end

					xp = math.floor( xp )

					msg = {
						"escape1",
						{ "escape_time", "time;"..diff },
						xp_info
					}
				end

				for k, v in ipairs( tab ) do
					if hook.Run( "SLCPlayerEscaped", v, false, diff or -1, rtime or -1, tab ) == true then continue end

					local ply_xp = math.floor( xp * mult_tab[v] )

					xp_info[2] = "text;"..ply_xp
					InfoScreen( v, "escaped", INFO_SCREEN_DURATION, msg )

					v:AddXP( ply_xp, "escape" )

					local team = v:SCPTeam()
					SCPTeams.AddScore( team, SCPTeams.GetReward( team ) * 3 )

					v:Despawn()
					v:SkipNextSuicide()

					v:KillSilent()
					v:SetSCPTeam( TEAM_SPEC )
					v:SetSCPClass( "spectator" )
					v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

					local stat = SCPTeams.GetStat( team, "escape" )
					if stat then
						stat:AddValue( 1, { player = v, type = "normal" } )
					end
				end

				CheckRoundEnd()
			end
		end
	end
end )

function GetEscapeBlockingPlayers( ply )
	local our_team = ply:SCPTeam()
	local blocking = {}

	for i, v in ipairs( LAST_ESCAPE ) do
		if v == ply then continue end

		local t = v:SCPTeam()
		if !SCPTeams.IsEnemy( our_team, t ) and !SCPTeams.IsEnemy( t, our_team ) then continue end

		table.insert( blocking, v )
	end

	return blocking
end

function IsBlockingEscape( ply1, ply2 )
	if !LAST_ESCAPE_LOOKUP[ply1] or !LAST_ESCAPE_LOOKUP[ply2] then return false end

	local ply1_team = ply1:SCPTeam()
	local ply2_team = ply2:SCPTeam()
	return SCPTeams.IsEnemy( ply1_team, ply2_team ) or SCPTeams.IsEnemy( ply2_team, ply1_team )
end

function GM:SLCEscapeMultiplier( plys, mult )
	local num_ply = -1

	for i, v in ipairs( plys ) do
		if !mult.skip_count[v]  then
			num_ply = num_ply + 1
		end
	end

	local xp_mult = math.Clamp( num_ply / 10, 0, 1 )

	for i, v in ipairs( plys ) do
		if !mult.skip_mult[v] then
			mult[v] = mult[v] + xp_mult * ( mult.bonus_mult[v] or 1 )
		end
	end
end
--[[-------------------------------------------------------------------------
Round aftermatch
---------------------------------------------------------------------------]]
function StartAftermatch( endcheck )
	if ROUND.post then return end

	print( "Starting aftermatch" )

	local support_timer = GetTimer( "SupportTimer" )
	if IsValid( support_timer ) then
		support_timer:Destroy()
	end

	ROUND.aftermatch = true

	AddTimer( "SLCAftermatch", 1, 0, function()
		if ROUND.post or ESCAPE_STATUS != 0 then return end

		ROUND.aftermatch = false
		FinishRoundInternal( nil, endcheck )
	end )

	AddTimer( "SLCSuddenDeath", 0.333, 0, function()
		if ROUND.post then return end

		for i, v in ipairs( player.GetAll() ) do
			if !v:Alive() then return end

			local dmg = DamageInfo()

			dmg:SetDamage( v:SCPTeam() == TEAM_SCP and 10 or 1 )
			dmg:SetDamageType( DMG_DIRECT )
			dmg:SetAttacker( NULL )
			dmg:SetInflictor( NULL )

			v:TakeDamageInfo( dmg )
		end
	end )
end

--[[-------------------------------------------------------------------------
Escort
---------------------------------------------------------------------------]]
function PlayerEscort( ply )
	if ROUND.post then return end

	local team = ply:SCPTeam()
	local pos = _G["POS_ESCORT_"..SCPTeams.GetName( team )] or POS_ESCORT
	if !ply:GetPos():WithinAABox( pos[1], pos[2] ) then return end

	local t = GetTimer( "SLCRound" )
	if IsValid( t ) then
		local rtime = t:GetRemainingTime()
		local ttime = t:GetTime()

		local diff = math.floor( ttime - rtime )
		local time = rtime / ttime
		local min, max = string.match( CVAR.slc_xp_escape:GetString(), "^(%d+),(%d+)$" )
		local xp = 0

		min = tonumber( min )
		max = tonumber( max )

		if time < 0.2 then
			xp = min
		elseif time > 0.8 then
			xp = max
		else
			xp = math.Map( time, 0.2, 0.8, min, max )
		end

		xp = math.floor( xp * 1.5 )

		local plys = {}

		for i, v in ipairs( player.GetAll() ) do
			if v:GetPos():WithinAABox( pos[1], pos[2] ) and SCPTeams.CanEscort( team, v:SCPTeam() ) then
				table.insert( plys, v )
			end
		end

		local num = #plys
		if num == 0 then return end

		local msg = {
			"escorted",
			{ "escape_time", "time;"..diff },
			{ "escape_xp", "text;"..xp }
		}

		for k, v in ipairs( plys ) do
			if hook.Run( "SLCPlayerEscorted", v, ply, diff or -1, rtime or -1 ) == true then continue end

			InfoScreen( v, "escaped", INFO_SCREEN_DURATION, msg )

			v:AddXP( xp, "escape" )
			local vteam = v:SCPTeam()
			SCPTeams.AddScore( vteam, SCPTeams.GetReward( vteam ) * 3 )

			v:Despawn()
			v:KillSilent()
			v:SkipNextSuicide()

			v:SetSCPTeam( TEAM_SPEC )
			v:SetSCPClass( "spectator" )

			v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

			local stat = SCPTeams.GetStat( team, "escort" )
			if stat then
				stat:AddValue( 1, { escorted = v, escorting = ply } )
			end
		end

		local points = num * CVAR.slc_points_escort:GetInt()

		PlayerMessage( "escortpoints$"..points, ply )
		ply:AddFrags( points )

		CheckRoundEnd()
	end
end