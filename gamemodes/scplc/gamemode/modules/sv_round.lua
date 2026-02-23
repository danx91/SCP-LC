ROUND = ROUND or {
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
	winners = {},
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

--[[-------------------------------------------------------------------------
Local util functions
---------------------------------------------------------------------------]]
local function UpdateRoundType()
	ROUND.roundtype = ROUNDS.normal
end

local function DestroyTimers()
	for k, v in pairs( ROUND.timers ) do
		v:Destroy()
		ROUND.timers[k] = nil
	end
end

local function CleanupPlayers()
	for i, v in ipairs( player.GetAll() ) do
		if v:GetAdminMode() then continue end

		v._SLCXPCategories = {}

		v.Logger:Reset( true )
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
	ROUND.active = true
	ROUND.post = false
	ROUND.preparing = false
	ROUND.aftermatch = false
	ROUND.infoscreen = false
	ROUND.freeze = false
	ROUND.roundtype = ROUNDS.dull

	ROUND.winners = {}

	ClearRoundProperties()
	ClearQueue()
	ClearSCPHooks()

	SLCUpdateUnixDay()
end

--[[-------------------------------------------------------------------------
Core functions
---------------------------------------------------------------------------]]
function FinishRoundInternal( winner, endcheck )
	print( "Round end, starting postround..." )

	if winner == nil then
		winner = ROUND.roundtype:getwinner()

		if winner == nil then
			winner = false
		end
	end

	ROUND.post = true
	ROUND.roundtype:postround( winner )

	print( "Destroying timers!" )
	DestroyTimers()

	if IsValid( endckeck ) then
		endcheck:Destroy()
	end

	hook.Run( "SLCPostround", winner )

	local post = CVAR.slc_time_postround:GetInt()

	net.Start( "RoundInfo" )
		net.WriteTable{
			status = "post",
			time = CurTime() + post,
			duration = post,
		}
	net.Broadcast()

	AddTimer( "SLCPostround", post, 1, function( self, n )
		ROUND.post = false
		RestartRound()
	end )
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
	ResetRoundStats()
	print( string.format( "Round data reset - %i ms!", util.TimerCycle() ) )

	game.CleanUpMap( false, {}, function()
		print( string.format( "Map cleaned - %i ms!", util.TimerCycle() ) )

		hook.Run( "SLCRoundCleanup" )
		print( string.format( "Everything is ready -  total time: %.5f ms!", ( SysTime() - t_start ) * 1000 ) )

		if #GetActivePlayers() < CVAR.slc_min_players:GetInt() then
			MsgC( Color( 255, 50, 50 ), "Not enough players to start round! Round restart canceled!\n" )
			ROUND.active = false

			for i, v in ipairs( player.GetAll() ) do
				v:KillSilent()
				v:InvalidatePlayerForSpectate()
				v:SetupSpectator()
			end

			net.Start( "RoundInfo" )
				net.WriteTable{
					status = "off",
				}
			net.Broadcast()

			return
		end

		UpdateRoundType()

		print( "Initializing round..." )

		ROUND.preparing = true
		ROUND.infoscreen = true

		SCPHooks.__PreventUpdate = true
		ROUND.roundtype:init()
		SCPHooks.__PreventUpdate = false

		TransmitSCPHooks()

		local prep = CVAR.slc_time_preparing:GetInt()

		net.Start( "RoundInfo" )
			net.WriteTable{
				status = "inf",
				time = CurTime() + INFO_SCREEN_DURATION,
				duration = INFO_SCREEN_DURATION,
				name = ROUND.roundtype.name,
			}
		net.Broadcast()
		//print( string.format( "Took %i ms!", util.TimerCycle() ) )

		AddTimer( "SLCSetup", INFO_SCREEN_DURATION, 1, function()
			CheckSpectatorMode( true )

			ROUND.infoscreen = false
			hook.Run( "SLCPreround", prep )

			net.Start( "RoundInfo" )
				net.WriteTable{
					status = "pre",
					time = CurTime() + prep,
					duration = prep,
					name = ROUND.roundtype.name,
				}
			net.Broadcast()

			AddTimer( "SLCPreround", prep, 1, function()
				print( "Preparing end, starting round..." )
				ROUND.preparing = false
				ROUND.roundtype:roundstart()

				local endcheck = AddTimer( "SLCRoundEndCheck", 10, 0, CheckRoundEnd )
				local round = CVAR.slc_time_round:GetInt()

				hook.Run( "SLCRound", round )

				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "live",
						time = CurTime() + round,
						duration = round
					}
				net.Broadcast()

				AddTimer( "SLCRound", round, 1, function( _, _, winner )
					if winner != nil or ESCAPE_STATUS == 0 then
						FinishRoundInternal( winner, endcheck )
					else
						StartAftermatch( endcheck )
					end
				end )
			end )
		end )
	end )
end

function InterruptRound( winner )
	if winner == nil then
		winner = ROUND.roundtype:getwinner()

		if winner == nil then
			winner = false
		end
	end

	local t = GetTimer( "SLCRound" )
	if t then
		print( "Interrupring round..." )

		t:Call( winner )
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

	if ROUND.roundtype:endcheck() then
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
						MsgC( Color( 255, 50, 50 ), "Round start terminated due to not enough players!" )
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

--winner can be: team id, table of team ids, false (time's up) or true (not enough players)
function GM:SLCPostround( winner )
	TransmitSound( "scp_lc/bell1.ogg", true )

	/*net.SendTable( "SLCRoundSummary", {
		stats = GetRoundSummary(),
		mvp = GetRoundMVP(),
		time = CVAR.slc_time_postround:GetInt(),
		winner = winner,
	}, nil, false, true )*/
	
	local specialinfo

	if winner != true then
		local sb = StringBuilder()

		local mvp, points = GetRoundMVP()
		if mvp then
			sb:append( ";mvp$", EscapeMessage( mvp:Nick() ), ",", points )
		end

		for i, v in ipairs( GetRoundSummary() ) do
			if !v[2] or v[2] == true then
				sb:append( ";stat_", v[1] )
			else
				sb:append( ";stat_", v[1], "$", v[2] )
			end
		end

		specialinfo = tostring( sb )
	end

	local time = CVAR.slc_time_postround:GetInt()

	if !winner then
		print( "Round has ended! Nobody wins" )
		CenterMessage( "time:"..time..";offset:-250;roundend#255,0,0,SCPHUDVBig;nowinner"..specialinfo )
	elseif winner == true then
		print( "Round has ended due to not enough players!" )
		CenterMessage( "time:"..time..";offset:-250;roundend#255,0,0,SCPHUDVBig;roundnep" )
	elseif istable( winner ) then
		local txt = ""
		local raw = ""
		local show = ""

		for k, v in pairs( winner ) do
			local name = SCPTeams.GetName( v )

			txt = txt.."@TEAMS."..name..","
			raw = raw.."%%s. "
			show = show..name..", "
		end

		txt = string.sub( txt, 1, string.len( txt ) - 1 )
		raw = string.sub( raw, 1, string.len( raw ) - 2 )
		show = string.sub( show, 1, string.len( show ) - 2 )

		print( "Round has ended! Winners: "..show )

		local msg = "time:"..time..";offset:-250;roundend#255,0,0,SCPHUDVBig;roundwinmulti$"..txt..",raw:"..raw

		if specialinfo and specialinfo != "" then
			msg = msg..specialinfo
		end

		CenterMessage( msg )
	else
		local name = SCPTeams.GetName( winner )

		print( "Round has ended! Winner: "..name )

		local msg = "time:"..time..";offset:-250;roundend#255,0,0,SCPHUDVBig;roundwin$@TEAMS."..name

		if specialinfo and specialinfo != "" then
			msg = msg..specialinfo
		end

		CenterMessage( msg )
	end

	local wintab = {}

	if winner and winner != true then
		if istable( winner ) then
			for k, v in pairs( winner ) do
				wintab[v] = true
			end
		else
			wintab = { [winner] = true }
		end
	end

	ROUND.winners = wintab

	local pxp = CVAR.slc_points_xp:GetInt()
	local alivexp, winxp = string.match( CVAR.slc_xp_win:GetString(), "(%d+),(%d+)" )

	alivexp = tonumber( alivexp )
	winxp = tonumber( winxp )

	for i, v in ipairs( player.GetAll() ) do
		local frags = v:Frags()
		v:SetFrags( 0 )

		if frags > 0 then
			local xp = pxp * frags

			v:AddXP( xp, "score" )
			PlayerMessage( "roundxp$"..xp, v )
		end

		if wintab[v:SCPTeam()] then
			v:AddXP( alivexp, "win" )
			PlayerMessage( "winalivexp$"..alivexp, v )
		elseif wintab[v:GetInitialTeam()] then
			v:AddXP( winxp, "win" )
			PlayerMessage( "winxp$"..winxp, v )
		end
	end

	--Send xp summary
	for i, v in ipairs( player.GetAll() ) do
		net.Start( "SLCXPSummary" )
			net.WriteTable( v:ExperienceSummary() )
		net.Send( v )
	end
end