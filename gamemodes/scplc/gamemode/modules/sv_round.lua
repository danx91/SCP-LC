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
ROUNDSTAT_OTHER = 0
ROUNDSTAT_NUMBER = 1

--RegisterRoundStat( name, init, ref, type )
-- 	name - name of stat
-- 	init - iniatial value, it will be reseted to this value every round
-- 	ref - refernce - number: how important whis value is. true: transmit always if changed. false:transmit if not changed. nil: never transmit
function RegisterRoundStat( name, init, ref, type )
	ROUND.stats[name] = { init, init, type or 0, ref }
end

function AddRoundStat( name, val )
	local tab = ROUND.stats[name]

	if tab[3] == ROUNDSTAT_NUMBER then
		tab[1] = tab[1] + ( val or 1 )
	else
		tab[1] = val
	end
end

function SetRoundStat( name, val, comp )
	local tab = ROUND.stats[name]

	if tab[3] == ROUNDSTAT_NUMBER then
		if !comp or comp == "h" and val > tab[1] or comp == "l" and val < tab[1] then
			tab[1] = val
		end
	else
		tab[1] = val
	end
end

function GetRoundStat( name )
	if !ROUND.stats[name] then return end
	return ROUND.stats[name][1]
end

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

local function ResetStats()
	for k, v in pairs( ROUND.stats ) do
		v[1] = v[2]
	end
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
	ResetStats()
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

	if !winner then
		print( "Round has ended! Time's up" )
		CenterMessage( "roundend#255,0,0,SCPHUDVBig;timesup" )
	elseif winner == true then
		print( "Round has ended due to not enough players!" )
		CenterMessage( "roundend#255,0,0,SCPHUDVBig;roundnep" )
	elseif istable( winner ) then
		local txt = ""
		local raw = ""
		local show = ""

		for k, v in pairs( winner ) do
			local name = SCPTeams.getName( v )

			txt = txt.."@TEAMS:"..name..","
			raw = raw.."%%s. "
			show = show..name..", "
		end

		txt = string.sub( txt, 1, string.len( txt ) - 1 )
		raw = string.sub( raw, 1, string.len( raw ) - 2 )
		show = string.sub( show, 1, string.len( show ) - 2 )

		print( "Round has ended! Winners: "..show )
		CenterMessage( "roundend#255,0,0,SCPHUDVBig;roundwinmulti$"..txt..",raw:"..raw )
	else
		local name = SCPTeams.getName( winner )

		print( "Round has ended! Winner: "..name )
		CenterMessage( "roundend#255,0,0,SCPHUDVBig;roundwin$@TEAMS:"..name )
	end

	

	local pxp = CVAR.pointsxp:GetInt()
	for k, v in pairs( player.GetAll() ) do
		local frags = v:Frags()
		v:SetFrags( 0 )
		if frags > 0 then
			local xp = pxp * frags

			v:AddXP( xp )
			PlayerMessage( "roundxp$"..xp, v )
		end
	end
	
	--TODO give exp etc.
end

--[[-------------------------------------------------------------------------
Base round stats
---------------------------------------------------------------------------]]
RegisterRoundStat( "kill", 0, 10, ROUNDSTAT_NUMBER )
RegisterRoundStat( "rdm", 0, 3, ROUNDSTAT_NUMBER )
RegisterRoundStat( "rdmdmg", 0, 250, ROUNDSTAT_NUMBER )
//RegisterRoundStat( "", 0, ROUNDSTAT_NUMBER )

--Stats can be used as info about round beause they will be reset on round restart, just don't transmit them
RegisterRoundStat( "gatea", false, nil, ROUNDSTAT_OTHER )
RegisterRoundStat( "106recontain", false, nil, ROUNDSTAT_OTHER )
RegisterRoundStat( "914use", false, nil, ROUNDSTAT_OTHER )
//RegisterRoundStat( "omega_active", false, nil, ROUNDSTAT_OTHER )