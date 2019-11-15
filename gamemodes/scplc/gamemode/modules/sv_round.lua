ROUND = ROUND or {
	preparing = false,
	post = false,
	active = false,
	timers = {},
	stats = {},
	queue = {},
	freeze = false,
}

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function SetupSupportTimer()
	local values = {}

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

--[[-------------------------------------------------------------------------
Local util functions
---------------------------------------------------------------------------]]
function AddTimer( name, time, rep, func )
	local t = Timer( name, time, rep, func )
	table.insert( ROUND.timers, t )

	return t
end

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
		v.Logger:Reset()
		v:Cleanup()
	end
end

local function ResetEvents()
	ROUND.active = true
	ROUND.post = false
	ROUND.preparing = false
	ROUND.freeze = false
	ROUND.queue = {}
	ROUND.roundtype = ROUNDS.dull
end

--[[-------------------------------------------------------------------------
Core functions
---------------------------------------------------------------------------]]
function RestartRound()
	assert( MAP_LOADED, "Map config is not loaded and game will not start! Change map to supported one in order to play this gamemode!" )

	print( "(Re)starting round..." )

	DestroyTimers()
	print( "Timers destroyed!" )

	CleanupPlayers()
	print( "Players cleaned!" )

	ResetEvents()
	ResetRoundStats()
	print( "Round data reset!" )

	game.CleanUpMap()
	print( "Map cleaned!" )
	print( "Everything is ready!" )

	if #GetActivePlayers() < CVAR.minplayers:GetInt() then
		MsgC( Color( 255, 50, 50 ), "Not enough players to start round! Round restart canceled!\n" )
		ROUND.active = false

		for k, v in pairs( player.GetAll() ) do
			v:KillSilent()
			v:InvalidatePlayerForSpectate()
			v:SetupSpectator()
		end

		return
	end

	UpdateRoundType()

	print( "Initializing round..." )
	ROUND.roundtype:init()

	ROUND.preparing = true
	hook.Run( "SLCPreround" )

	local prep = CVAR.pretime:GetInt()

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
			print( "Round end, starting postround..." )

			if !winner then
				winner = ROUND.roundtype:getwinner()
			end

			ROUND.post = true
			ROUND.roundtype:postround( winner )

			print( "Destroying timers!" )
			DestroyTimers()

			endcheck:Destroy()
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
		end )
	end )
end

local function interruptRound( winner )
	local t = GetTimer( "SLCRound" )

	if winner == nil then
		winner = false
	end

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

	local winner = ROUND.roundtype:endcheck()

	if winner then
		interruptRound( winner )
	end
end

local abouttostart = false
function CheckRoundStart()
	if !ROUND.active and #GetActivePlayers() >= CVAR.minplayers:GetInt() then
		if !abouttostart then
			abouttostart = true
			PlayerMessage( "abouttostart" )

			timer.Simple( 10, function()
				abouttostart = false

				if !ROUND.active then
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
	TransmitSound( "Alarm2.ogg", true )
	/*net.Start( "PlaySound" )
		net.WriteUInt( 1, 1 )
		net.WriteString( "Alarm2.ogg" )
	net.Broadcast()*/
end

function GM:SLCRound()
	TransmitSound( "Bell2.ogg", true )
	/*net.Start( "PlaySound" )
		net.WriteUInt( 1, 1 )
		net.WriteString( "Bell2.ogg" )
	net.Broadcast()*/
end

--winner can be: team id, table of team ids, false (time's up) or true (not enough players)
function GM:SLCPostround( winner )
	//BroadcastLua( "surface.PlaySound('Bell1.ogg')" )
	TransmitSound( "Bell1.ogg", true )
	/*net.Start( "PlaySound" )
		net.WriteUInt( 1, 1 )
		net.WriteString( "Bell1.ogg" )
	net.Broadcast()*/

	local specialinfo

	if winner and winner != true then
		local sb = StringBuilder()

		local mvp, points = GetRoundMVP()
		if mvp then
			sb:append( ";mvp$", mvp:Nick(), ",", points )
		end

		for i, v in ipairs( GetRoundSummary() ) do
			if !v or v == true then
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
		CenterMessage( "time:"..time..";roundend#255,0,0,SCPHUDVBig;nowinner" )
	elseif winner == true then
		print( "Round has ended due to not enough players!" )
		CenterMessage( "time:"..time..";roundend#255,0,0,SCPHUDVBig;roundnep" )
	elseif istable( winner ) then
		local txt = ""
		local raw = ""
		local show = ""

		for k, v in pairs( winner ) do
			local name = SCPTeams.getName( v )

			txt = txt.."@TEAMS."..name..","
			raw = raw.."%%s. "
			show = show..name..", "
		end

		txt = string.sub( txt, 1, string.len( txt ) - 1 )
		raw = string.sub( raw, 1, string.len( raw ) - 2 )
		show = string.sub( show, 1, string.len( show ) - 2 )

		print( "Round has ended! Winners: "..show )

		local msg = "time:"..time..";roundend#255,0,0,SCPHUDVBig;roundwinmulti$"..txt..",raw:"..raw

		if specialinfo and specialinfo != "" then
			msg = msg..specialinfo
		end

		CenterMessage( msg )
	else
		local name = SCPTeams.getName( winner )

		print( "Round has ended! Winner: "..name )

		local msg = "time:"..time..";roundend#255,0,0,SCPHUDVBig;roundwin$@TEAMS."..name

		if specialinfo and specialinfo != "" then
			msg = msg..specialinfo
		end

		CenterMessage( msg )
	end

	local wintab

	if winner and winner != true and !istable( winner ) then
		wintab = { winner }
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
			for _, t in pairs( wintab ) do
				if v:SCPTeam() == t then
					v:AddXP( alivexp )
					PlayerMessage( "winalivexp$"..alivexp, v )
					break
				elseif v:GetInitialTeam() == t then
					v:AddXP( winxp )
					PlayerMessage( "winxp$"..winxp, v )
					break
				end
			end
		end
	end

	--TODO give exp etc.
end