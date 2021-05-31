local queueReg = {}

/*local queue_iter = {}
function queue_iter:New( tab )
	local t = setmetatable( {}, { __index = queue_iter } )

	t.tab = tab
	t.index = 1

	return t
end

function queue_iter:Next()
	local item = self.tab[self.index]

	if !item then
		self.index = 1
		return nil
	else
		self.index = self.index + 1

	end

	return item[1]
end

function queue_iter:Remove()
	table.remove( self.tab, self.index )
end

function queue_iter:Finish()
	for i, v in rpairs( self.tab ) do

	end
end

setmetatable( queue_iter, { __call = queue_iter.New } )*/

--[[-------------------------------------------------------------------------
Queue
---------------------------------------------------------------------------]]
function CheckQueue()
	queueReg = {}
	local queue = {}
	
	for i, v in ipairs( ROUND.queue ) do
		if IsValid( v ) and !v:Alive() and v:SCPTeam() == TEAM_SPEC and !queueReg[v] then
			table.insert( queue, v )
			queueReg[v] = true
		end
	end

	for i, v in ipairs( SCPTeams.getPlayersByTeam( TEAM_SPEC ) ) do
		if !queueReg[v] and !v:Alive() then
			table.insert( queue, v )
			queueReg[v] = true
		end
	end

	ROUND.queue = queue
end

function QueueInsert( ply, num )
	if !queueReg[ply] then
		queueReg[ply] = true

		if num then
			table.insert( ROUND.queue, num, ply )
		else
			table.insert( ROUND.queue, ply )
		end
	end
end

function QueueRemove( num )
	local ply

	if num == -1 then
		ply = table.remove( ROUND.queue )
	else
		ply = table.remove( ROUND.queue, num or 1 )
	end

	if ply then
		queueReg[ply] = nil
		return ply
	end
end

function GetQueuePlayers( num, norem )
	CheckQueue()

	if !num or num == -1 then
		return ROUND.queue
	end

	local plys = {}

	local len = #ROUND.queue
	if num > len then
		num = len
	end

	if num > 0 then
		for i = 1, num do
			local ply = norem and ROUND.queue[i] or table.remove( ROUND.queue, 1 )
			plys[i] = ply

			if !norem then
				queueReg[ply] = nil
			end
		end
	end

	return plys
end

function ClearQueue()
	ROUND.queue = {}
	queueReg = {}
end

--[[-------------------------------------------------------------------------
Spawning players
---------------------------------------------------------------------------]]
local function levelsort( a, b )
	return a:SCPLevel() > b:SCPLevel()
end

function SetupPlayers( multi )
	local plys = GetActivePlayers()
	local all = #plys

	local scp = 0

	if all < 9 then
		scp = 1
	elseif all < 15 then
		scp = 2
	else
		scp = math.floor( ( all - 14 ) / 7 ) + 3
	end

	local penalty = CVAR.penalty:GetInt()
	local ppenalty = CVAR.p_penalty:GetInt()

	local scpply = {}

	for k, v in pairs( plys ) do
		local p = tonumber( v:GetSCPData( "scp_penalty", 0 ) )

		if p <= 0 then
			table.insert( scpply, v )
		else
			v:SetSCPData( "scp_penalty", p - 1 )
		end
	end

	local SCP = table.Copy( SCPS )
	local rscp = SCP[math.random( #SCP )]

	for i = 1, scp do
		if #SCP == 0 then --not enough SCPs
			break
		end

		if #scpply == 0 then
			scpply = plys
		end

		local ply = table.remove( scpply, math.random( #scpply ) )
		local obj = multi and GetSCP( rscp ) or GetSCP( table.remove( SCP, math.random( #SCP ) ) )

		table.RemoveByValue( plys, ply )
		ply:SetSCPData( "scp_penalty", ply:IsPremium() and ppenalty or penalty )

		print( "Assigning '"..ply:Nick().."' to class '"..obj.name.."' [SCP]" )
		obj:SetupPlayer( ply )
		ply:SetInitialTeam( TEAM_SCP )

		all = all - 1
	end

	local tab = getPlayerTable( all )
	local groups = getGroups()
	local playertab = {}

	for k, ply in pairs( plys ) do
		playertab[ply] = {}

		//local lvl = ply:SCPLevel()
		for g_name, group in pairs( groups ) do
			if g_name != "SUPPORT" then
				playertab[ply][g_name] = {}
				for c_name, class in pairs( group ) do
					local owned

					if class.override then
						local result = class.override( ply )

						if result then
							owned = true
						elseif result == false then
							owned = false
						end
					end

					if owned == nil then
						//owned = lvl >= class.level
						owned = ply:IsClassUnlocked( class.name )
					end

					if owned then
						playertab[ply][g_name].any = true
						table.insert( playertab[ply][g_name], c_name )
					end
				end
			end
		end
	end

	for n, v in pairs( tab ) do
		if v[2] == 0 then continue end

		local g_name = v[1]
		local classplayers = {}

		local num = n == #tab and all or v[2]

		local len = #plys
		local playerindices = PopulateTable( len )
		local torem = {}

		local i = 1
		repeat --TODO test
			local index = table.remove( playerindices, math.random( len ) )
			len = len - 1

			local ply = plys[index]
			//print( "aaa", index, ply )
			if playertab[ply][g_name].any then
				torem[index] = true
				//table.remove( plys, index )
				table.insert( classplayers, ply )

				i = i + 1
			end
		until i > num or len < 1
		//print( "end", i > num, len < 1 )

		for i, v in rpairs( plys ) do
			if torem[i] then
				table.remove( plys, i )
				//local a = table.remove( plys, i )
				//print( "rem", i, a )
			end
		end

		table.sort( classplayers, levelsort )

		local classes, spawninfo = getClassGroup( g_name )
		local spawns = table.Copy( spawninfo )

		local classspawns = {}
		local inuse = {}

		local len = #classplayers
		local num = 0

		if len == 0 then
			print( "Failed to assign any player to group: "..g_name )
		else
			for i = 1, len do
				local ply = classplayers[i]
				local tab = playertab[ply][g_name]

				local class = nil

				repeat
					local rc = table.remove( tab, math.random( #tab ) )
					if !inuse[rc] then inuse[rc] = 0 end

					if classes[rc].max == 0 or inuse[rc] < classes[rc].max then
						inuse[rc] = inuse[rc] + 1
						class = classes[rc]
						break
					end
				until #tab == 0

				if !class then
					print( "Failed to assign '"..ply:Nick().."' to any class in group '"..g_name.."'." )
					table.insert( plys, ply )
				else
					if #spawns == 0 then
						spawns = table.Copy( spawninfo )
					end

					local cname = class.name
					print( "Assigning '"..ply:Nick().."' to class '"..cname.."' ["..g_name.."]" )

					local pos
					if class.spawn then
						if istable( class.spawn ) then
							if !classspawns[cname] or #classspawns[cname] == 0 then
								classspawns[cname] = table.Copy( cname )
							end

							pos = table.remove( classspawns[cname], math.random( #classspawns[cname] ) )
						else
							pos = class.spawn
						end
					else
						pos = table.remove( spawns, math.random( #spawns ) )
					end

					ply:SetupPlayer( class, pos )
					ply:SetInitialTeam( class.team )

					all = all - 1
				end
			end
		end
	end
end

function SpawnSupport()
	CheckQueue()

	if #ROUND.queue == 0 then
		return
	end

	local group, data = selectSupportGroup()
	local classes, spawninfo = getSupportGroup( group )
	local spawns = table.Copy( spawninfo )

	local num = 0
	local inuse = {}
	local max = CVAR.maxsupport:GetInt()
	local unused = {}

	if data.max > 0 and data.max < max then
		max = data.max
	end

	repeat
		local ply = QueueRemove()
		if !ply then break end --no more players in queue
		/*repeat
			local p = table.remove( plys, 1 )

			if IsValid( p ) then
				ply = p
				break
			end
		until #plys == 0*/

		if IsValid( ply ) and ply:IsActive() and !ply:IsAFK() and ply:SCPTeam() == TEAM_SPEC then
			if !ply:GetProperty( "spawning" ) and !ply:GetProperty( "spawning_scp" ) then
				local plytab = {}

				for k, v in pairs( classes ) do
					if !inuse[k] then inuse[k] = 0 end
					if v.max == 0 or inuse[k] < v.max then
						local owned

						if v.override then
							local result = v.override( ply )

							if result then
								owned = true
							elseif result == false then
								owned = false
							end
						end

						if owned == nil then
							//owned = ply:SCPLevel() >= v.level
							owned = ply:IsClassUnlocked( v.name )
						end

						if owned then
							table.insert( plytab, v )
						end
					end
				end

				if #plytab > 0 then
					if #spawns == 0 then
						spawns = table.Copy( spawninfo )
					end

					local class = table.Random( plytab )

					print( "Assigning '"..ply:Nick().."' to support class '"..class.name.."' ["..group.."]" )
					ply:SetupPlayer( class, table.remove( spawns, math.random( #spawns ) ) )

					inuse[class.name] = inuse[class.name] + 1
					num = num + 1
				else
					table.insert( unused, ply )
				end
			end
		end
	until num >= max

	if #unused > 0 then
		for i, v in rpairs( unused ) do
			QueueInsert( v, 1 )
		end
	end

	if num > 0 then
		if data.callback then
			data.callback()
		end

		return true
	end
end

--[[-------------------------------------------------------------------------
Escape system
---------------------------------------------------------------------------]]
/*function CheckEscape()
	CheckEscape1()
end*/

ESCAPE_STATUS = ESCAPE_STATUS or 0 -- 0 - no escape; 1 - escape; 2 - blocked;
ESCAPE_TIMER = ESCAPE_TIMER or 0
LAST_ESCAPE = LAST_ESCAPE or {}

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

	local ist = istable( POS_ESCAPE )
	for k, v in pairs( player.GetAll() ) do
		local team = v:SCPTeam()

		if team != TEAM_SPEC then
			if ist and v:GetPos():WithinAABox( POS_ESCAPE[1], POS_ESCAPE[2] ) or !ist and v:GetPos():DistToSqr( POS_ESCAPE ) <= 22500 then
				if SCPTeams.canEscape( team ) or GetRoundStat( "alpha_warhead" ) then
					table.insert( players, v )
				end

				table.insert( all, v )

				teams[team] = true
			end
		end
	end	

	for t1, v1 in pairs( teams ) do
		for t2, v2 in pairs( teams ) do
			if !SCPTeams.isAlly( t1, t2 ) then
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

			//print( "Starting Escape", ESCAPE_STATUS )

			TransmitEscapeInfo( blocked and all or tab )
		end

		/*local players = {}
		local teams = {}

		for k, v in pairs( player.GetAll() ) do
			local team = v:SCPTeam()
			if SCPTeams.canEscape( team ) then
				local ist = istable( POS_ESCAPE )
				if ist and v:GetPos():WithinAABox( POS_ESCAPE[1], POS_ESCAPE[2] ) or !ist and v:GetPos():DistToSqr( POS_ESCAPE ) <= 22500 then
					table.insert( players, v )
					teams[team] = true*/



					/*local rtime = t:GetRemainingTime()
					local ttime = t:GetTime()

					local diff = math.floor( ttime - rtime )
					hook.Run( "SLCPlayerEscaped", v, diff, rtime )

					local time = rtime / ttime
					local min, max = string.match( CVAR.escapexp:GetString(), "^(%d+),(%d+)$" )
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

					xp = math.floor( xp )

					CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp ), v )

					v:AddXP( xp )
					SCPTeams.addScore( team, SCPTeams.getReward( team ) * 3 )

					v:Despawn()

					v:KillSilent()
					v:SetupSpectator()
					QueueInsert( v )

					AddRoundStat( "escapes" )

					CheckRoundEnd()*/
				--end
			--end
		--end
	end
end

local NEscape = 0
hook.Add( "Tick", "SLCEscapeCheck", function() --TODO remove timer on escape / exit
	if ROUND.post or ESCAPE_STATUS == 0 then return end
	if NEscape > CurTime() then return end
	NEscape = CurTime() + 0.5

	local tab, blocked, all = GetEscapeData()

	if #tab == 0 then
		ESCAPE_STATUS = 0
		ESCAPE_TIMER = 0

		TransmitEscapeInfo( LAST_ESCAPE )
		LAST_ESCAPE = {}

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

			local lookup = CreateLookupTable( LAST_ESCAPE )

			for k, v in pairs( blocked and all or tab ) do
				if !lookup[v] then
					table.insert( transmit, v )
					//print( "player added to escape", v )
				end

				done[v] = true
			end

			for k, v in pairs( LAST_ESCAPE ) do
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
	end

	//print( "EscapeTick", ESCAPE_STATUS )

	if ESCAPE_STATUS == 1 and ESCAPE_TIMER > 0 and ESCAPE_TIMER <= CurTime() then
		//print( "EscapePlayers" )
		//PrintTable( tab )

		ESCAPE_STATUS = 0
		ESCAPE_TIMER = 0

		TransmitEscapeInfo( tab )

		if GetRoundStat( "alpha_warhead" ) then
			local xp = CVAR.alpha_escape_xp:GetInt()

			for k, v in pairs( tab ) do
				CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;alpha_escape;escapexp$%d", xp ), v )

				InfoScreen( v, "escaped", INFO_SCREEN_DURATION, {
					"escape2",
					{ "escape_xp", "text;"..xp }
				} )

				v:AddXP( xp )

				local team = v:SCPTeam()
				SCPTeams.addScore( team, SCPTeams.getReward( team ) * 2 )

				v:Despawn()

				v:KillSilent()
				v:SetSCPTeam( TEAM_SPEC )
				v:SetSCPClass( "spectator" )
				v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

				//v:SetupSpectator()
				//QueueInsert( v )

				AddRoundStat( "escapes" )
			end
		else
			local t = GetTimer( "SLCRound" )
			if IsValid( t ) or ROUND.aftermatch then
				local min, max = string.match( CVAR.escapexp:GetString(), "^(%d+),(%d+)$" )
				min = tonumber( min )
				max = tonumber( max )

				local xp = 0
				local msg

				if ROUND.aftermatch then
					xp = min

					msg = {
						"escape1",
						{ "escape_xp", "text;"..xp }
					}
				else
					local rtime = t:GetRemainingTime()
					local ttime = t:GetTime()

					local diff = math.floor( ttime - rtime )

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
						{ "escape_xp", "text;"..xp }
					}
				end

				for k, v in pairs( tab ) do
					hook.Run( "SLCPlayerEscaped", v, diff, rtime )

					//CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp ), v )
					InfoScreen( v, "escaped", INFO_SCREEN_DURATION, msg )

					v:AddXP( xp )

					local team = v:SCPTeam()
					SCPTeams.addScore( team, SCPTeams.getReward( team ) * 3 )

					v:Despawn()

					v:KillSilent()
					v:SetSCPTeam( TEAM_SPEC )
					v:SetSCPClass( "spectator" )
					v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

					//v:SetupSpectator()
					//QueueInsert( v )

					AddRoundStat( "escapes" )
				end

				CheckRoundEnd()
			end
		end
	end

end )

--[[-------------------------------------------------------------------------
Round aftermatch
---------------------------------------------------------------------------]]
local ecc
function StartAftermatch( endcheck )
	if ROUND.post then return end

	print( "Starting aftermatch" )
	//PlayerMessage( "aftermatch", LAST_ESCAPE )

	local support_timer = GetTimer( "SupportTimer" )
	if IsValid( support_timer ) then
		support_timer:Destroy()
		//print( "SUPPORT TIMER DESTROYED" )
	end

	ecc = endcheck
	ROUND.aftermatch = true
end

local NACheck = 0
hook.Add( "Tick", "SLCRoundAftermatch", function()
	if ROUND.post or !ROUND.aftermatch then return end

	if NACheck > CurTime() then return end
	NACheck = CurTime() + 1

	//print( "Aftermatch tick" )

	if ESCAPE_STATUS == 0 then
		local cb = ecc

		ecc = nil
		ROUND.aftermatch = false

		FinishRoundInternal( nil, cb )
	end
end )

--[[-------------------------------------------------------------------------
Escort
---------------------------------------------------------------------------]]
function PlayerEscort( ply )
	if ROUND.post then return end

	local team = ply:SCPTeam()
	local pos = _G["POS_ESCORT_"..SCPTeams.getName( team )] or POS_ESCORT
	if ply:GetPos():DistToSqr( pos ) > 62500 then return end

	local t = GetTimer( "SLCRound" )
	if IsValid( t ) then
		local rtime = t:GetRemainingTime()
		local ttime = t:GetTime()

		local diff = math.floor( ttime - rtime )
		local time = rtime / ttime
		local min, max = string.match( CVAR.escapexp:GetString(), "^(%d+),(%d+)$" )
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

		for k, v in pairs( player.GetAll() ) do
			if v:GetPos():DistToSqr( pos ) <= 62500 and SCPTeams.canEscort( team, v:SCPTeam() ) then
				table.insert( plys, v )
			end
		end

		local num = #plys
		if num == 0 then return end

		//local msg = string.format( "offset:75;escorted#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp )
		local msg = {
			"escorted",
			{ "escape_time", "time;"..diff },
			{ "escape_xp", "text;"..xp }
		}
		for k, v in pairs( plys ) do
			//CenterMessage( msg, v )
			InfoScreen( v, "escaped", INFO_SCREEN_DURATION, msg )
			hook.Run( "SLCPlayerEscorted", v, ply )

			v:AddXP( xp )
			local vteam = v:SCPTeam()
			SCPTeams.addScore( vteam, SCPTeams.getReward( vteam ) * 3 )

			v:Despawn()

			v:KillSilent()
			v:SetSCPTeam( TEAM_SPEC )
			v:SetSCPClass( "spectator" )
			v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

			//v:SetupSpectator()
			//QueueInsert( v )
		end

		AddRoundStat( "escorts", num )

		local points = num * CVAR.escortpoints:GetInt()
		
		PlayerMessage( "escortpoints$"..points, ply )
		ply:AddFrags( points )

		CheckRoundEnd()
	end
end

--[[-------------------------------------------------------------------------
Misc functions
---------------------------------------------------------------------------]]
function PrintSCPNotice( tab )
	if !tab then
		tab = GetActivePlayers()
	elseif !istable( tab ) then
		tab = { tab }
	end

	for k, v in pairs( tab ) do
		local r = tonumber( v:GetSCPData( "scp_penalty", 0 ) )

		if r == 0 then
			PlayerMessage( "scpready#50,200,50", v )
		else
			PlayerMessage( "scpwait$"..r.."#200,50,50", v )
		end
	end
end

--[[-------------------------------------------------------------------------
Map functions
---------------------------------------------------------------------------]]
function UseAll()
	for k, v in pairs( FORCE_USE ) do
		local enttab = ents.FindInSphere( v, 3 )
		for _, ent in pairs( enttab ) do
			if ent:GetPos() == v then
				ent:Fire( "Use" )
				break
			end
		end
	end
end

function DestroyAll()
	for k, v in pairs( FORCE_DESTROY ) do
		if isvector( v ) then
			local enttab = ents.FindInSphere( v, 1 )
			for _, ent in pairs( enttab ) do
				if ent:GetPos() == v then
					ent:Remove()
					break
				end
			end
		elseif isnumber( v ) then
			local ent = ents.GetByIndex( v )
			if IsValid( ent ) then
				ent:Remove()
			end
		end
	end
end

function OpenSCPs()
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		for _, pos in pairs( POS_DOOR ) do
			if v:GetPos() == pos then
				v:Fire( "unlock" )
				v:Fire( "open" )
				break
			end
		end
	end

	for k, v in pairs( ents.FindByClass( "func_button" ) ) do
		for _, pos in pairs( POS_BUTTON ) do
			if v:GetPos() == pos then
				v:Fire( "use" )
				break
			end
		end
	end

	for k, v in pairs( ents.FindByClass( "func_rot_button" ) ) do
		for _, pos in pairs( POS_ROT_BUTTON ) do
			if v:GetPos() == pos then
				v:Fire( "use" )
				break
			end
		end
	end
end

--[[-------------------------------------------------------------------------
Item spawn
---------------------------------------------------------------------------]]
local GAS_TABLE = {
	Touch = function( self, ent )
		if ent:IsPlayer() then
			if !ent.NextGasChoke or ent.NextGasChoke < CurTime() then
				ent.NextGasChoke = CurTime() + 2.5

				ent:ApplyEffect( "gas_choke" )
			end
		end
	end
}

local function GAS_POST( item, i )
	local data = GAS_DIM[i]
	item:SetTriggerBounds( data.mins, data.maxs, data.bounds )
end

local function applyTable( item, tab )
	for k, v in pairs( tab ) do
		if k != "_dnc" then
			if istable( v ) then
				item[k] = item[k] or {}
				applyTable( item[k], v )
			else
				item[k] = v
			end
		end
	end
end

function SpawnGeneric( class, pos, num, post_tab, post_func )
	if isfunction( post_tab ) then
		post_func = post_tab
		post_tab = nil
	end

	if istable( pos ) then
		if !post_tab or !post_tab._dnc  then
			pos = table.Copy( pos )
		end
	else
		pos = { pos }
	end

	local seq = false

	if num < 0 then
		num = #pos
		seq = true
	end

	for i = 1, num do
		local item = ents.Create( istable( class ) and class[math.random( #class )] or class )
		if IsValid( item ) then
			item:SetPos( seq and pos[i] or table.remove( pos, math.random( #pos ) ) )

			if post_tab then
				applyTable( item, post_tab )
			end

			item:Spawn()

			if post_func then
				post_func( item, i )
			end
		end
	end
end

function SpawnItems() --TODO
	--[[-------------------------------------------------------------------------
	SCPs
	---------------------------------------------------------------------------]]
	local item = ents.Create( "item_scp_714" )
	if IsValid( item ) then
		item:SetPos( SPAWN_714 )
		item:Spawn()
		item.Dropped = CurTime()
	end
	
	/*local pos500 = table.Copy( SPAWN_500 )
	
	for i = 1, 2 do
		local item = ents.Create( "item_scp_500" )
		if IsValid( item ) then
			local pos = table.Random( pos500 )
			item:SetPos( pos )
			item:Spawn()
			table.RemoveByValue( pos500, pos )
		end
	end
	
	for k, v in pairs( SPAWN_420 ) do
		local item = ents.Create( "item_scp_420j" )
		if IsValid( item ) then
			local pos = table.Random( v )
			item:SetPos( pos )
			item:Spawn()
		end
	end*/

	--[[-------------------------------------------------------------------------
	Vests
	---------------------------------------------------------------------------]]
	for k,v in pairs( SPAWN_VEST ) do
		local vest = ents.Create( "slc_vest" )
		if IsValid( vest ) then
			vest:Spawn()
			vest:SetPos( v - Vector( 0, 0, 10 ) )
			vest:SetVest( VEST.getRandomVest() )
		end
	end
	
	--[[-------------------------------------------------------------------------
	Weapons
	---------------------------------------------------------------------------]]
	local post = { Dropped = 0 }
	local post_dnc = { Dropped = 0, _dnc = true }
	
	SpawnGeneric( "weapon_slc_pc", SPAWN_PARTICLE_CANNON, -1, post )

	SpawnGeneric( { "cw_deagle", "cw_makarov", "cw_mr96" }, SPAWN_PISTOLS, -1, post )
	SpawnGeneric( { "cw_g36c", "cw_ump45", "cw_mp5" }, SPAWN_SMGS, -1, post )
	SpawnGeneric( { "cw_ak74", "cw_ar15", "cw_m14", "cw_scarh", "cw_l85a2" }, SPAWN_RIFLES, -1, post )
	SpawnGeneric( { "cw_shorty", "cw_m3super90" }, SPAWN_PUMP, -1, post )
	SpawnGeneric( "cw_l115", SPAWN_SNIPER, -1, post )

	SpawnGeneric( "weapon_crowbar", SPAWN_MELEE, 3, post )

	SpawnGeneric( "cw_ammo_kit_regular", SPAWN_AMMO_CW, -1, { AmmoCapacity = 20 } )
	
	--[[-------------------------------------------------------------------------
	Items
	---------------------------------------------------------------------------]]
	local spawn_items = table.Copy( SPAWN_ITEMS )

	SpawnGeneric( "item_slc_radio", spawn_items, 2, post_dnc )
	SpawnGeneric( "item_slc_nvg", spawn_items, 3, post_dnc )
	SpawnGeneric( "item_slc_gasmask", spawn_items, 3, post_dnc )
	SpawnGeneric( "item_slc_battery", SPAWN_BATTERY, -1, post )
	SpawnGeneric( "item_slc_flashlight", SPAWN_FLASHLIGHT, 8, post )
	SpawnGeneric( "item_slc_medkit", SPAWN_MEDKITS, 4, post )
	
	--[[-------------------------------------------------------------------------
	MedBay
	---------------------------------------------------------------------------]]
	local spawn_medbay = table.Copy( SPAWN_MEDBAY )

	for i = 1, #spawn_medbay do
		local rng = math.random( 1, 100 )
		if rng <= 15 then
			SpawnGeneric( "item_slc_medkitplus", spawn_medbay, 1, post_dnc )
		else
			SpawnGeneric( "item_slc_medkit", spawn_medbay, 1, post_dnc )
		end
	end

	--[[-------------------------------------------------------------------------
	Keycards
	---------------------------------------------------------------------------]]
	/*for k, v in pairs( KEYCARDS or {} ) do
		local spawns = table.Copy( v.spawns )
		//local cards = table.Copy( v.ents )
		local dices = {}

		local n = 0
		for _, dice in pairs( v.ents ) do
			local d = {
				min = n,
				max = n + dice[2],
				ent = dice[1]
			}
			
			table.insert( dices, d )
			n = n + dice[2]
		end

		for i = 1, math.min( v.amount, #spawns ) do
			local spawn = table.remove( spawns, math.random( 1, #spawns ) )
			local dice = math.random( 0, n - 1 )
			local ent

			for _, d in ipairs( dices ) do
				if d.min <= dice and d.max > dice then
					ent = d.ent
					break
				end
			end

			if ent then
				local keycard = ents.Create( "item_slc_keycard" )
				if IsValid( keycard ) then
					keycard:Spawn()
					keycard:SetPos( spawn )
					keycard:SetKeycardType( ent )
					keycard.Dropped = 0
				end
			end
		end
	end*/

	--[[-------------------------------------------------------------------------
	Chips
	---------------------------------------------------------------------------]]
	for k, v in pairs( CHIPS ) do
		local spawns = table.Copy( v.spawns )

		for i = 1, v.amount do
			local len = #spawns

			if len == 0 then
				break
			end

			local chip = CreateChip( SelectChip( v.level ) )
			if IsValid( chip ) then
				chip:SetPos( table.remove( spawns, math.random( len ) ) )
				chip:Spawn()
				chip.Dropped = 0
			end
		end
	end

	--[[-------------------------------------------------------------------------
	Omnitool
	---------------------------------------------------------------------------]]
	for k, v in pairs( OMNITOOLS ) do
		local spawns = table.Copy( v.spawns )

		for i = 1, v.amount do
			local len = #spawns

			if len == 0 then
				break
			end

			local omnitool = ents.Create( "item_slc_omnitool" )
			if IsValid( omnitool ) then
				omnitool:SetPos( table.remove( spawns, math.random( len ) ) )
				omnitool:Spawn()
				omnitool.Dropped = 0
			end
		end
	end

	--[[-------------------------------------------------------------------------
	Cameras
	---------------------------------------------------------------------------]]
	for i, v in ipairs( CCTV ) do
		local cctv = ents.Create( "slc_cctv" )

		if IsValid( cctv ) then
			cctv:Spawn()
			cctv:SetPos( v.pos )

			cctv:SetCam( i )

			if v.destroy_alpha or v.destroy_omega then
				DestroyOnWarhead( cctv, v.destroy_alpha, v.destroy_omega )
			end

			v.ent = cctv
		end
	end

	--[[-------------------------------------------------------------------------
	Gas 
	---------------------------------------------------------------------------]]
	SpawnGeneric( "slc_trigger", GAS_POS, -1, GAS_TABLE, GAS_POST )

	--[[-------------------------------------------------------------------------
	Vechicles
	---------------------------------------------------------------------------]]
	/*if GetConVar("br_allow_vehicle"):GetInt() != 0 then
		for k, v in pairs(SPAWN_VEHICLE_GATE_A) do
			local car = ents.Create("prop_vehicle_jeep")
			if GetConVar("br_cars_oldmodels"):GetInt() == 0 then
				car:SetModel("models/tdmcars/jeep_wrangler_fnf.mdl")
				car:SetKeyValue("vehiclescript","scripts/vehicles/TDMCars/wrangler_fnf.txt")
			else
				car:SetModel("models/buggy.mdl")
				car:SetKeyValue("vehiclescript","scripts/vehicles/jeep_test.txt")
			end
			car:SetPos( v )
			car:SetAngles( Angle( 0, 90, 0 ) )
			car:Spawn()
			WakeEntity( car )
		end
	
		for k, v in ipairs(SPAWN_VEHICLE_NTF) do
			if k > math.Clamp( GetConVar( "br_cars_ammount" ):GetInt(), 0, 12 ) then
				break
			end
			local car = ents.Create("prop_vehicle_jeep")
			if GetConVar("br_cars_oldmodels"):GetInt() == 0 then
				car:SetModel("models/tdmcars/jeep_wrangler_fnf.mdl")
				car:SetKeyValue("vehiclescript","scripts/vehicles/TDMCars/wrangler_fnf.txt")
			else
				car:SetModel("models/buggy.mdl")
				car:SetKeyValue("vehiclescript","scripts/vehicles/jeep_test.txt")
			end
			car:SetPos( v )
			car:SetAngles( Angle( 0, 270, 0 ) )
			car:Spawn()
			WakeEntity( car )
		end
	end*/

	hook.Run( "SLCSpawnItems" )
end