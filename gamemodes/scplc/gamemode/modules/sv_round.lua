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
}

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function SetupSupportTimer()
	local time, max = string.match( string.gsub( CVAR.spawnrate:GetString(), "%s", "" ), "(%d+),*(%d*)" )

	time = tonumber( time )
	max = tonumber( max )

	if max then
		time = math.random( time, max )
	end

	AddTimer( "SupportTimer", time, 1, function( self, n )
		if !SpawnSupport() then
			self:Change( 30, 0 )
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

function SetRoundProperty( key, value )
	if !ROUND.active then return end

	ROUND.properties[key] = value
end

function GetRoundProperty( key )
	if !ROUND.active then return end

	return ROUND.properties[key]
end
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
	for k, v in pairs( player.GetAll() ) do
		v.PlayerData:RoundReset()
		v.Logger:Reset( true )
		v:Cleanup()

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

	ROUND.properties = {}

	//ROUND.queue = {}
	ClearQueue()
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

	local post = CVAR.posttime:GetInt()

	net.Start( "RoundInfo" )
		net.WriteTable{
			status = "post",
			time = CurTime() + post,
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
	//util.TimerCycle()

	DestroyTimers()
	print( "Timers destroyed!" )
	//print( string.format( "Took %i ms!", util.TimerCycle() ) )

	CleanupPlayers()
	print( "Players cleaned!" )
	//print( string.format( "Took %i ms!", util.TimerCycle() ) )

	ResetEvents()
	ResetRoundStats()
	print( "Round data reset!" )
	//print( string.format( "Took %i ms!", util.TimerCycle() ) )

	game.CleanUpMap()
	print( "Map cleaned!" )
	//print( string.format( "Took %i ms!", util.TimerCycle() ) )

	hook.Run( "SLCRoundCleanup" )
	print( "Everything is ready!" )
	//print( string.format( "Took %i ms!", util.TimerCycle() ) )

	if #GetActivePlayers() < CVAR.minplayers:GetInt() then
		MsgC( Color( 255, 50, 50 ), "Not enough players to start round! Round restart canceled!\n" )
		ROUND.active = false

		for k, v in pairs( player.GetAll() ) do
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
	ROUND.roundtype:init()

	ROUND.preparing = true
	ROUND.infoscreen = true

	local prep = CVAR.pretime:GetInt()

	net.Start( "RoundInfo" )
		net.WriteTable{
			status = "inf",
			time = CurTime() + INFO_SCREEN_DURATION,
			name = ROUND.roundtype.name,
		}
	net.Broadcast()
	//print( string.format( "Took %i ms!", util.TimerCycle() ) )

	AddTimer( "SLCSetup", INFO_SCREEN_DURATION, 1, function( self, n )
		CheckSpectatorMode( true )

		ROUND.infoscreen = false
		hook.Run( "SLCPreround" )

		net.Start( "RoundInfo" )
			net.WriteTable{
				status = "pre",
				time = CurTime() + prep,
				name = ROUND.roundtype.name,
			}
		net.Broadcast()

		AddTimer( "SLCPreround", prep, 1, function( self, n )
			print( "Preparing end, starting round..." )
			ROUND.preparing = false
			ROUND.roundtype:roundstart()

			hook.Run( "SLCRound" )

			local endcheck = AddTimer( "SLCRoundEndCheck", 10, 0, CheckRoundEnd )
			local round = CVAR.roundtime:GetInt()

			net.Start( "RoundInfo" )
				net.WriteTable{
					status = "live",
					time = CurTime() + round,
				}
			net.Broadcast()

			AddTimer( "SLCRound", round, 1, function( self, n, winner )
				if winner != nil or ESCAPE_STATUS == 0 then
					FinishRoundInternal( winner, endcheck )
				else
					StartAftermatch( endcheck )
				end
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
	if !ROUND.active and #GetActivePlayers() >= CVAR.minplayers:GetInt() then
		if !abouttostart then
			abouttostart = true

			local time = CVAR.waittime:GetInt()
			PlayerMessage( "abouttostart$"..time )

			timer.Simple( time, function()
				abouttostart = false

				if !ROUND.active then
					if #GetActivePlayers() < CVAR.minplayers:GetInt() then
						MsgC( Color( 255, 50, 50 ), "Round start terminated due to not enough players!" )
						return
					end

					RestartRound()
				end
			end )
		end
	end
end

cvars.AddChangeCallback( CVAR.minplayers:GetName(), function()
	CheckRoundStart()
end, "CheckRoundStart" )
--[[-------------------------------------------------------------------------
GM hooks
---------------------------------------------------------------------------]]
function GM:SLCPreround()
	TransmitSound( "scp_lc/round_start.ogg", true )
	/*net.Start( "PlaySound" )
		net.WriteUInt( 1, 1 )
		net.WriteString( "Alarm2.ogg" )
	net.Broadcast()*/
end

function GM:SLCRound()
	TransmitSound( "scp_lc/bell2.ogg", true )
	/*net.Start( "PlaySound" )
		net.WriteUInt( 1, 1 )
		net.WriteString( "Bell2.ogg" )
	net.Broadcast()*/
end

--winner can be: team id, table of team ids, false (time's up) or true (not enough players)
function GM:SLCPostround( winner )
	//BroadcastLua( "surface.PlaySound('Bell1.ogg')" )
	TransmitSound( "scp_lc/bell1.ogg", true )
	/*net.Start( "PlaySound" )
		net.WriteUInt( 1, 1 )
		net.WriteString( "Bell1.ogg" )
	net.Broadcast()*/

	local specialinfo

	if /*winner and*/ winner != true then
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

	local time = CVAR.posttime:GetInt()

	if !winner then
		print( "Round has ended! Nobody wins" )
		CenterMessage( "time:"..time..";offset:75;roundend#255,0,0,SCPHUDVBig;nowinner"..specialinfo )
	elseif winner == true then
		print( "Round has ended due to not enough players!" )
		CenterMessage( "time:"..time..";offset:75;roundend#255,0,0,SCPHUDVBig;roundnep" )
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

		local msg = "time:"..time..";offset:75;roundend#255,0,0,SCPHUDVBig;roundwinmulti$"..txt..",raw:"..raw

		if specialinfo and specialinfo != "" then
			msg = msg..specialinfo
		end

		CenterMessage( msg )
	else
		local name = SCPTeams.GetName( winner )

		print( "Round has ended! Winner: "..name )

		local msg = "time:"..time..";offset:75;roundend#255,0,0,SCPHUDVBig;roundwin$@TEAMS."..name

		if specialinfo and specialinfo != "" then
			msg = msg..specialinfo
		end

		CenterMessage( msg )
	end

	local wintab

	if winner and winner != true then
		if istable( winner ) then
			wintab = winner
		else
			wintab = { winner }
		end
	end

	local pxp = CVAR.pointsxp:GetInt()
	local alivexp, winxp = string.match( CVAR.winxp:GetString(), "(%d+),(%d+)" )

	alivexp = tonumber( alivexp )
	winxp = tonumber( winxp )

	for k, v in pairs( player.GetAll() ) do
		local frags = v:Frags()
		v:SetFrags( 0 )

		if frags > 0 then
			local xp = pxp * frags

			v:AddXP( xp )
			PlayerMessage( "roundxp$"..xp, v )
		end

		if wintab then
			local rewarded = false

			local vteam = v:SCPTeam()
			for _, t in pairs( wintab ) do
				if vteam == t then
					v:AddXP( alivexp )
					PlayerMessage( "winalivexp$"..alivexp, v )
					rewarded = true
					break
				end
			end

			if !rewarded then
				local viteam = v:GetInitialTeam()
				for _, t in pairs( wintab ) do
					if viteam == t then
						v:AddXP( winxp )
						PlayerMessage( "winxp$"..winxp, v )
						break
					end
				end
			end
		end
	end
end