ROUND = ROUND or {
	status = ROUND_STATUS_INACTIVE,
	preparing = false,
	post = false,
	active = false,
	aftermatch = false,
	infoscreen = false,
	timers = setmetatable( {}, { __mode = "v" } ),
	stats = {},
	queue = {},
	properties = {},
	freeze = false,
	modifiers = {},
	rules = {},
}

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function SetupSupportTimer()
	local time

	local override = GetRoundProperty( "SupportTimerOverride" )
	if override then
		SetRoundProperty( "SupportTimerOverride", nil )
		time = override
	else
		time, max = string.match( string.gsub( CVAR.slc_support_spawnrate:GetString(), "%s", "" ), "(%d+),*(%d*)" )

		time = tonumber( time )
		max = tonumber( max )

		if max then
			time = SLCRandom( time, max )
		end
	end

	AddTimer( "SupportTimer", time, 1, function( self, n )
		if !SpawnSupport() then
			self:Change( 10, 0 )
			self:Start()
		else
			self:Destroy()
			SetupSupportTimer()
		end
	end )
end

function AddTimer( ... )
	local t = Timer( ... )
	table.insert( ROUND.timers, t )

	return t
end

function AddThenableTimer( ... )
	local p, t = ThenableTimer( ... )
	table.insert( ROUND.timers, t )

	return p, t
end

--[[-------------------------------------------------------------------------
Round properties
---------------------------------------------------------------------------]]
SLCSyncRoundProperties = SLCSyncRoundProperties or {}

function SetRoundProperty( key, value, sync )
	if !ROUND.active then return end

	ROUND.properties[key] = value

	if sync then
		net.Start( "SLCRoundProperties" )
			net.WriteTable( { [key] = value } )
		net.Broadcast()

		SLCSyncRoundProperties[key] = value
	end

	return value
end

function GetRoundProperty( key, def )
	if !ROUND.active then return def end

	if !ROUND.properties[key] and def != nil then
		ROUND.properties[key] = def
	end

	return ROUND.properties[key]
end

function ClearRoundProperties()
	ROUND.properties = {}
	SLCSyncRoundProperties = {}
end

hook.Add( "PlayerReady", "SLCSyncRoundProperties", function( ply )
	net.Start( "SLCRoundProperties" )
		net.WriteTable( SLCSyncRoundProperties )
	net.Broadcast()
end )

function SendRoundInfo( ply )
	net.Start( "RoundInfo" )

	net.WriteUInt( ROUND.status, 3 )
	net.WriteString( ROUND.roundtype and ROUND.roundtype.name or "" )

	local dur = 0
	local time = 0

	local t

	if ROUND.status == ROUND_STATUS_INFO then
		t = GetTimer( "SLCSetup" )
	elseif ROUND.status == ROUND_STATUS_PREPARING then
		t = GetTimer( "SLCPreround" )
	elseif ROUND.status == ROUND_STATUS_LIVE then
		t = GetTimer( "SLCRound" )
	elseif ROUND.status == ROUND_STATUS_POST then
		t = GetTimer( "SLCPostround" )
	end

	if IsValid( t ) then
		dur = t:GetTime()
		time = CurTime() + t:GetRemainingTime()
	end

	net.WriteFloat( dur )
	net.WriteFloat( time )

	net.WriteTable( ROUND.modifiers )
	net.WriteTable( ROUND.rules )

	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end
end

--[[-------------------------------------------------------------------------
Local util functions
---------------------------------------------------------------------------]]
local function UpdateRoundType()
	print( "Updating round type..." )
	ROUND.roundtype = SelectRoundType()
	print( "  > Round type selected", ROUND.roundtype and ROUND.roundtype.name )
end

local function DestroyTimers()
	for k, v in pairs( ROUND.timers ) do
		v:Destroy()
		ROUND.timers[k] = nil
	end
end

local function CleanupPlayers()
	SCPTeams.ResetScore()

	for i, v in ipairs( player.GetAll() ) do
		if v:GetAdminMode() then continue end

		v:Cleanup( false, true )
		v:ResetDailyBonus()

		if v:IsAFK() then
			v:InvalidatePlayerForSpectate()
			v:KillSilent()
			v:SetupSpectator( true )
		end
	end
end

local function ResetEvents()
	ROUND.status = ROUND_STATUS_INACTIVE
	ROUND.active = true
	ROUND.post = false
	ROUND.preparing = false
	ROUND.aftermatch = false
	ROUND.infoscreen = false
	ROUND.freeze = false
	ROUND.roundtype = nil

	ClearRoundStats()
	ClearRoundProperties()
	ClearRoundModifiers()
	ClearRoundRules()
	ClearQueue()
	ClearSCPHooks()

	SLCUpdateUnixDay()
end

--[[-------------------------------------------------------------------------
Core functions
---------------------------------------------------------------------------]]
function FinishRoundInternal( winners, endcheck )
	print( "Round end, starting postround..." )

	print( "finish - winners", winners )
	if winners == nil then
		winners = ROUND.roundtype:GetWinners()

		print( "round return" )
		if winners == nil then
			winners = false
		end
	end

	ROUND.status = ROUND_STATUS_POST
	ROUND.post = true
	ROUND.roundtype:RoundPost( winners )

	print( "Destroying timers!" )
	DestroyTimers()

	if IsValid( endckeck ) then
		endcheck:Destroy()
	end

	local postround_time = CVAR.slc_time_postround:GetInt()
	AddTimer( "SLCPostround", postround_time, 1, function( self, n )
		ROUND.post = false
		ROUND.roundtype:RoundCleanup()
		RestartRound()
	end )

	hook.Run( "SLCPostround", postround_time, winners )
	SendRoundInfo()
end

function RestartRound()
	assert( MAP_LOADED, "Map config is not loaded and game will not start! Change map to supported one in order to play this gamemode!" )

	print( "(Re)starting round..." )
	local t_start = SysTime()
	util.TimerCycle()

	DestroyTimers()
	print( string.format( "Timers destroyed - %i ms!", util.TimerCycle() ) )

	CleanupPlayers()
	print( string.format( "Players cleaned - %i ms!", util.TimerCycle() ) )

	ResetEvents()
	print( string.format( "Round data reset - %i ms!", util.TimerCycle() ) )

	game.CleanUpMap( false, {}, function()
		print( string.format( "Map cleaned - %i ms!", util.TimerCycle() ) )

		hook.Run( "SLCRoundCleanup" )
		print( string.format( "Everything is ready -  total time: %.5f ms!", ( SysTime() - t_start ) * 1000 ) )

		if #GetActivePlayers() < CVAR.slc_min_players:GetInt() then
			SLCErrorMessage( "Not enough players to start round! Round restart canceled!" )
			ROUND.active = false

			for i, v in ipairs( player.GetAll() ) do
				v:KillSilent()
				v:InvalidatePlayerForSpectate()
				v:SetupSpectator()
			end

			SendRoundInfo()

			return
		end

		UpdateRoundType()

		print( "Initializing round..." )

		ROUND.status = ROUND_STATUS_INFO
		ROUND.preparing = true
		ROUND.infoscreen = true

		SCPHooks.__PreventUpdate = true
		ROUND.roundtype:RoundInit()
		SCPHooks.__PreventUpdate = false

		TransmitSCPHooks()

		//print( string.format( "Took %i ms!", util.TimerCycle() ) )

		AddTimer( "SLCSetup", INFO_SCREEN_DURATION, 1, function()
			CheckSpectatorMode( true )

			ROUND.status = ROUND_STATUS_PREPARING
			ROUND.infoscreen = false

			local prep = CVAR.slc_time_preparing:GetInt()

			AddTimer( "SLCPreround", prep, 1, function()
				print( "Preparing end, starting round..." )
				ROUND.status = ROUND_STATUS_LIVE
				ROUND.preparing = false
				ROUND.roundtype:RoundStart()

				local endcheck = AddTimer( "SLCRoundEndCheck", 10, 0, CheckRoundEnd )
				local round = CVAR.slc_time_round:GetInt()

				AddTimer( "SLCRound", round, 1, function( _, _, winners )
					if winners != nil or ESCAPE_STATUS == 0 then
						FinishRoundInternal( winners, endcheck )
					else
						StartAftermatch( endcheck )
					end
				end )

				hook.Run( "SLCRound", round )
				SendRoundInfo()
			end )

			hook.Run( "SLCPreround", prep )
			SendRoundInfo()
		end )

		SendRoundInfo()
		hook.Run( "SLCRoundInit", INFO_SCREEN_DURATION )
	end )
end

function InterruptRound( winners )
	local t = GetTimer( "SLCRound" )
	if t then
		print( "Interrupring round..." )

		t:Call( winners )
		t:Destroy()
	end
end

function HoldRound()
	ROUND.freeze = true
end

function ReleaseRound()
	ROUND.freeze = false
	CheckRoundEnd()
end

function CheckRoundEnd()
	if !ROUND.active or ROUND.post or ROUND.freeze then return end

	if ROUND.roundtype:EndCheck() then
		InterruptRound()
	end
end

local abouttostart = false
function CheckRoundStart()
	if !ROUND.active and #GetActivePlayers() >= CVAR.slc_min_players:GetInt() then
		if !abouttostart then
			abouttostart = true

			local time = CVAR.slc_time_wait:GetInt()
			PlayerMessage( "abouttostart$"..time )

			timer.Simple( time, function()
				abouttostart = false

				if !ROUND.active then
					if #GetActivePlayers() < CVAR.slc_min_players:GetInt() then
						SLCErrorMessage( "Round start terminated due to not enough players!" )
						return
					end

					RestartRound()
				end
			end )
		end
	end
end

cvars.AddChangeCallback( CVAR.slc_min_players:GetName(), function()
	CheckRoundStart()
end, "CheckRoundStart" )

--[[-------------------------------------------------------------------------
GM hooks
---------------------------------------------------------------------------]]
function GM:SLCPreround( time )
	TransmitSound( "scp_lc/round_start.ogg", true )
end

function GM:SLCRound( time )
	TransmitSound( "scp_lc/bell2.ogg", true )
end

--winner can be: table of team group ids, false (no winner) or true (not enough players)
function GM:SLCPostround( time, winners )
	TransmitSound( "scp_lc/bell1.ogg", true )

	net.SendTable( "SLCRoundSummary", {
		winners = winners,
		stats = GetRoundSummary(),
		mvp = { GetRoundMVP() },
		duration = time - 1,
	}, nil, false, true )

	local points_xp = CVAR.slc_points_xp:GetInt()
	local base_xp = CVAR.slc_xp_finish:GetInt()
	local first, second, third = string.match( CVAR.slc_xp_winners:GetString(), "(%d+),(%d+),(%d+)" )

	first = math.Round( 1 + tonumber( first ) / 100 )
	second = math.Round( 1 + tonumber( second ) / 100 )
	third = math.Round( 1 + tonumber( third ) / 100 )

	if !istable( winners ) or !next( winners ) then
		print( "no winners table" )
		winners = {}
	end

	local winners_lookup = {}

	for i, v in ipairs( winners ) do
		winners_lookup[v[1]] = i
	end

	for i, v in ipairs( player.GetAll() ) do
		local frags = v:Frags()
		local frags_xp = frags * points_xp

		local part = { 0, 0, 0, 0 }
		local total = 0

		print( "XP ply", v )

		local init_index = winners_lookup[SCPTeams.GetGroup( v:GetInitialTeam() )] or 4
		print( "INIT", v:GetInitialTeam(), SCPTeams.GetGroup( v:GetInitialTeam() ), init_index )

		part[init_index] = part[init_index] + 20
		total = total + 20

		local cur_group = SCPTeams.GetGroup( v:SCPTeam() )
		if cur_group then
			local cur_index = winners_lookup[cur_group] or 4
			print( "CUR", v:SCPTeam(), SCPTeams.GetGroup( v:SCPTeam() ), cur_index )

			part[cur_index] = part[cur_index] + 10
			total = total + 10
		else
			print( "CUR", v:SCPTeam(), SCPTeams.GetGroup( v:SCPTeam() ) )
		end

		PrintTable( v:GetProperty( "slc_group_frags", {} ) )

		for group, points in pairs( v:GetProperty( "slc_group_frags", {} ) ) do
			local index = winners_lookup[group] or 4
			part[index] = part[index] + points
			total = total + points
		end

		local round_xp = ( first * part[1] + second * part[2] + third * part[3] + part[4] ) * base_xp / total

		print( "XP pre calc", frags_xp, round_xp )

		local new_frags = math.min( ( round_xp + frags_xp ) / points_xp + 5, 0 )
		v:ClearFrags( new_frags )

		if frags_xp < 0 then
			round_xp = math.max( round_xp + frags_xp, 0 )
			frags_xp = 0
		end

		if frags_xp > 0 then
			v:AddXP( frags_xp, "score" )
		end

		if round_xp > 0 then
			v:AddXP( round_xp, "win" )
		end

		local total_xp = frags_xp + round_xp
		PlayerMessage( "roundxp$"..total_xp, v )

		print( "Finish XP", frags_xp, round_xp, total_xp, new_frags )
		PrintTable( part )

		v:ExperienceSummary()
	end
end