--[[-------------------------------------------------------------------------
Spawn players
---------------------------------------------------------------------------]]
local function select_wighted( tab )
	local rng = math.random( tab.total_weight )
	local sum = 0

	for i, v in ipairs( tab ) do
		sum = sum + v.weight
		if sum >= rng then
			table.remove( tab, i )
			tab.total_weight = tab.total_weight - v.weight
			return v.class
		end
	end
end

function SetupPlayers()
	local plys = GetActivePlayers()
	local all = #plys
	
	//Assign SCPs
	local scp_list = table.Copy( SCPS )
	local assigned_scps = {}
	local scp_plys = {}
	local scp_num = 0
	local scp_sum = 0

	if SLC_SCP_OVERRIDE then
		scp_num = SLC_SCP_OVERRIDE( all )
	elseif all >= CVAR.slc_scp_min_players:GetInt() then
		if all < 12 then
			scp_num = 1
		elseif all < 21 then
			scp_num = 2
		else
			scp_num = math.floor( ( all - 20 ) / 12 ) + 3
		end
	end

	for k, v in ipairs( plys ) do
		local p = v:GetSCPPenalty()
		if p <= 0 then
			local w = -p + 1

			scp_sum = scp_sum + w
			table.insert( scp_plys, { v, w } )
		end

		if p > 0 or scp_num > 0 then
			v:SetSCPPenalty( p - 1 )
		end
	end

	
	for i = 1, scp_num do
		if #scp_list == 0 then --not enough SCPs
			break
		end

		if #scp_plys == 0 then
			scp_plys = {}

			for n, v in ipairs( plys ) do
				scp_plys[n] = { v, 1 }
			end

			scp_sum = #scp_plys
		end

		local ply
		local rng = math.random( scp_sum )

		for idx, v in ipairs( scp_plys ) do
			rng = rng - v[2]

			if rng <= 0 then
				ply = v[1]

				scp_sum = scp_sum - v[2]
				table.remove( scp_plys, idx )

				break
			end
		end

		if !ply then
			print( "Failed to select any player as SCP!" )
			continue
		end

		local scp = table.remove( scp_list, math.random( #scp_list ) )
		local obj = GetSCP( scp )

		if obj.basestats.avoid then
			for _, v in ipairs( obj.basestats.avoid ) do
				table.RemoveByValue( scp_list, v )
			end
		end

		table.RemoveByValue( plys, ply )
		assigned_scps[ply] = scp
		all = all - 1
	end

	hook.Run( "SLCAlterAssignedSCPs", assigned_scps )

	//Build list of players
	local groups = GetClassGroups()
	local available_classes = {}
	
	for _, ply in ipairs( plys ) do
		local p_tab = {}
		available_classes[ply] = p_tab

		for group_name, group in pairs( groups ) do
			if group_name == "SUPPORT" then continue end

			local g_tab = {
				total_weight = 0,
			}

			p_tab[group_name] = g_tab

			for class_name, class in pairs( group ) do
				local weight

				if class.override then
					local result = class.override( ply )
					if result then
						weight = isnumber( result ) and result or class.weight or class.tier and ( class.tier + 1 ) or 1
					elseif result == false then
						weight = false
					end
				end

				weight = weight or ply:IsClassUnlocked( class.name ) and ( class.weight or class.tier and ( class.tier + 1 ) or 1 )

				if weight and weight > 0 then
					g_tab.any = true
					g_tab.total_weight = g_tab.total_weight + weight
					table.insert( g_tab, { class = class_name, weight = weight } )
				end
			end
		end
	end
	
	//Assign players to classes
	local classes = GetPlayerTable( all )
	local num_classes = #classes
	local assigned_groups = {}
	local classes_in_use = {}
	local select_groups = {}

	for i, group_info in ipairs( classes ) do
		local group_name = group_info[1]
		local to_spawn = i == num_classes and #plys or group_info[2]

		if !assigned_groups[group_name] then
			assigned_groups[group_name] = {}
		end

		if #plys == 0 then
			print( "No more players! Interrupting!" )
			break
		end
		
		while to_spawn > 0 do
			local indices = PopulateTable( #plys )
			local ply

			//Select valid player
			repeat
				local ind = table.remove( indices, math.random( #indices ) )
				local tmp_ply = plys[ind]

				if available_classes[tmp_ply][group_name].total_weight > 0 then
					ply = tmp_ply
				end
			until ply or #indices == 0

			if !ply then
				print( "No more valid players! Failed to assign "..to_spawn.." players to group '"..group_name.."'!" )
				continue
			end

			local ply_classes = available_classes[ply][group_name]
			local class_name, select_group_name

			//Attempt to select class
			repeat
				local tmp_class_name = select_wighted( ply_classes )
				local tmp_class_tab = groups[group_name][tmp_class_name]

				if !classes_in_use[tmp_class_name] then
					classes_in_use[tmp_class_name] = 0
				end

				if tmp_class_tab.select_group and !select_groups[tmp_class_tab.select_group] then
					select_groups[tmp_class_tab.select_group] = 0
				end

				local override = tmp_class_tab.select_override and tmp_class_tab.select_override( tmp_class_tab.select_group and select_groups[tmp_class_tab.select_group] or classes_in_use[tmp_class_name], group_info[2] )
				if ( override or override == nil ) and ( !tmp_class_tab.max or tmp_class_tab.max == 0 or ( tmp_class_tab.select_group and select_groups[tmp_class_tab.select_group] or classes_in_use[tmp_class_name] ) < tmp_class_tab.max ) then
					class_name = tmp_class_name
					select_group_name = tmp_class_tab.select_group
				end
			until class_name or #ply_classes == 0

			if !class_name then
				print( "Failed to assing player '"..ply:Nick().."' to any class in group '"..group_name.."'!" )
				continue
			end

			table.RemoveByValue( plys, ply )
			to_spawn = to_spawn - 1
			assigned_groups[group_name][ply] = class_name
			classes_in_use[class_name] = classes_in_use[class_name] + 1

			if select_group_name then
				select_groups[select_group_name] = select_groups[select_group_name] + 1
			end
		end
	end

	hook.Run( "SLCAlterAssignedClasses", assigned_groups )

	/*print( "SCPs selected" )
	PrintTable( assigned_scps )
	print( "Classes selected" )
	PrintTable( assigned_groups )*/

	local initial_teams = {
		scps = {}
	}

	//Spawn SCPs
	local penalty = CVAR.slc_scp_penalty:GetInt()
	local ppenalty = CVAR.slc_scp_premium_penalty:GetInt()

	for ply, scp in pairs( assigned_scps ) do
		local obj = GetSCP( scp )
		obj:SetupPlayer( ply )
		
		//ply:SetSCPData( "scp_penalty", ply:IsPremium() and ppenalty or penalty )
		ply:SetSCPPenalty( ply:IsPremium() and ppenalty or penalty )
		
		ply:SetInitialTeam( TEAM_SCP )
		table.insert( initial_teams.scps, ply )

		print( "Assigning '"..ply:Nick().."' to class '"..obj.name.."' [SCP]" )
	end

	//Spawn other classes
	for group_name, tab in pairs( assigned_groups ) do
		local group_data, spawn_info = GetClassGroup( group_name )
		local spawns = table.Copy( spawn_info )
		local class_spawns = {}

		for ply, class_name in pairs( tab ) do
			local class_data = group_data[class_name]
			local pos

			if class_data.spawn then
				if istable( class_data.spawn ) then
					if !class_spawns[class_name] or #class_spawns[class_name] == 0 then
						class_spawns[class_name] = table.Copy( class_data.spawn )
					end

					pos = table.remove( class_spawns[class_name], math.random( #class_spawns[class_name] ) )
				else
					pos = class_data.spawn
				end
			else
				if #spawns == 0 then
					spawns = table.Copy( spawn_info )
				end

				pos = table.remove( spawns, math.random( #spawns ) )
			end

			ply:SetupPlayer( class_data, pos )
			ply:SetInitialTeam( class_data.team )

			if !initial_teams[group_name] then
				initial_teams[group_name] = {}
			end

			table.insert( initial_teams[group_name], ply )

			print( "Assigning '"..ply:Nick().."' to class '"..class_name.."' ["..group_name.."]" )
		end
	end

	//Transmit initial IDs
	AddTimer( "RoundInitialIDs", INFO_SCREEN_DURATION + 1, 1, function()
		for k, v in pairs( initial_teams ) do
			net.Start( "InitialIDs" )
				net.WriteTable( v )
			net.Send( v )
		end
	end )
end

--[[-------------------------------------------------------------------------
Support Queue
---------------------------------------------------------------------------]]
local queue = {}
local queue_lookup = {}
local suicide_queue = {} //Players who commited suicide have lower priority
local suicide_queue_sid = {}

function _QueueDebug()
	print( "Queue", #queue )
	PrintTable( queue )

	print( "Suicide Queue", #suicide_queue )
	PrintTable( suicide_queue )

	print( "Suicide Queue SteamIDs" )
	PrintTable( suicide_queue_sid )
end

function ClearQueue()
	queue = {}
	queue_lookup = {}
	suicide_queue = {}

	for i, v in ipairs( player.GetAll() ) do
		suicide_queue_sid[v:SteamID64()] = nil
	end
end

function MoveSuicideQueue()
	for i, v in ipairs( suicide_queue ) do
		if !v:IsValid() or v:IsAFK() or v:SCPTeam() != TEAM_SPEC then continue end

		v:SetQueuePosition( table.insert( queue, v ) )
		suicide_queue_sid[v:SteamID64()] = nil
	end

	suicide_queue = {}
end

function QueueCheck()
	//Rebuild both queues and remove invalid players 
	//It could just remove invalid players instead of full rebuild, but it's safer to double check for duplicate entries and it's not that bad optimisation wise
	local new_queue = {}
	local new_suicide_queue = {}
	queue_lookup = {}

	for i, v in ipairs( suicide_queue ) do
		if !IsValid( v ) then continue end

		if !v:IsValidSpectator() then
			v:SetQueuePosition( 0 )

			if !v:IsAFK() then
				suicide_queue_sid[v:SteamID64()] = nil
			end
		elseif !queue_lookup[v] then
			v:SetQueuePosition( -1 )
			table.insert( new_suicide_queue, v )
			queue_lookup[v] = true
			suicide_queue_sid[v:SteamID64()] = true
		end
	end

	for i, v in ipairs( queue ) do
		if !IsValid( v ) then continue end

		if !v:IsValidSpectator() then
			v:SetQueuePosition( 0 )
		elseif !queue_lookup[v] then
			v:SetQueuePosition( table.insert( new_queue, v ) )
			queue_lookup[v] = true
		end
	end

	//Add missing players if we missed them somehow
	for i, v in ipairs( player.GetAll() ) do
		if queue_lookup[v] or !v:IsValidSpectator() then continue end

		if suicide_queue_sid[v:SteamID64()] then
			table.insert( suicide_queue, v )
			v:SetQueuePosition( -1 )
		else
			v:SetQueuePosition( table.insert( new_queue, v ) )
		end

		queue_lookup[v] = true
	end

	queue = new_queue
	suicide_queue = new_suicide_queue

	return #queue
end

function QueueInsert( ply, front )
	if !ply:IsValidSpectator() or queue_lookup[ply] then return end

	if suicide_queue_sid[ply:SteamID64()] then
		QueueInsertSuicide( ply )
		return
	end

	if front then
		ply:SetQueuePosition( table.insert( queue, 1, ply ) )
	else
		ply:SetQueuePosition( table.insert( queue, ply ) )
	end

	queue_lookup[ply] = true
end

function QueueInsertSuicide( ply )
	if !ply:IsValidSpectator() or queue_lookup[ply] then return end

	queue_lookup[ply] = true
	suicide_queue_sid[ply:SteamID64()] = true
	table.insert( suicide_queue, ply )

	ply:SetQueuePosition( -1 )
end

function QueueRemove( low )
	local ply

	repeat
		if #queue == 0 then
			if !low then return NULL end

			ply = nil
			break
		end

		ply = table.remove( queue, 1 )
		queue_lookup[ply] = nil
	until IsValid( ply ) and ply:IsValidSpectator()

	if ply then return ply end

	repeat
		if #suicide_queue == 0 then return NULL end

		ply = table.remove( suicide_queue, 1 )
		queue_lookup[ply] = nil

		if IsValid( ply ) then
			suicide_queue_sid[ply:SteamID64()] = nil
		end
	until IsValid( ply ) and ply:IsValidSpectator()

	return ply
end

--[[-------------------------------------------------------------------------
Spawn support
---------------------------------------------------------------------------]]
function SpawnSupport( group_override )
	local queue_size = QueueCheck()
	if queue_size == 0 then return false end

	//Get support group and its data
	local group_name, group_data
	
	if group_override then
		group_name = group_override
		group_data = GetSupportData( group_override )
	end

	if !group_name or !group_data then
		group_name, group_data = SelectSupportGroup()
	end

	//Calculate how many players to spawn
	local to_spawn = 0
	local max = CVAR.slc_support_amount:GetString()
	local max_num = tonumber( max )

	if max_num then
		to_spawn = max_num
	else
		local min, pct
		min, max, pct = string.match( max, "^(%d+),(%d+),(%d+)$" )
		to_spawn = math.Clamp( math.Round( player.GetCount() * pct / 100 ), min, max )
	end

	if isnumber( group_data.max ) and group_data.max > 0 and group_data.max < to_spawn then
		to_spawn = group_data.max
	elseif isfunction( group_data.max ) then
		to_spawn = group_data.max( to_spawn )
	end

	if SLC_SUPPORT_OVERRIDE then
		to_spawn = SLC_SUPPORT_OVERRIDE( to_spawn )
	end

	local support_minimum = CVAR.slc_support_minimum:GetInt()
	if queue_size < support_minimum then return false end

	max = to_spawn

	print( "Spawning support", group_name )

	//Assign players to classes
	local classes, spawn_info = GetSupportGroup( group_name )
	local assigned_classes = {}
	local unused_players = {}
	local classes_in_use = {}
	local select_groups = {}

	while to_spawn > 0 do
		local ply = QueueRemove( false )
		if !IsValid( ply ) then --No more valid players in queue!
			print( "No more valid players! Failed to select "..to_spawn.." players in group '"..group_name.."'!" )
			break
		end

		if ply:GetInfoNum( "cvar_slc_support_optout", 0 ) == 1 then
			PlayerMessage( "support_optout", ply )
			table.insert( unused_players, ply )
			continue
		end

		//Get available classes
		local available_classes = {
			total_weight = 0
		}

		for class_name, class in pairs( classes ) do
			local weight

			if class.override then
				local result = class.override( ply )
				if result then
					weight = isnumber( result ) and result or class.weight or class.tier and ( class.tier + 1 ) or 1
				elseif result == false then
					weight = false
				end
			end

			weight = weight or ply:IsClassUnlocked( class.name ) and ( class.weight or class.tier and ( class.tier + 1 ) or 1 )

			if weight and weight > 0 then
				available_classes.total_weight = available_classes.total_weight + weight
				table.insert( available_classes, { class = class_name, weight = weight } )
			end
		end

		if available_classes.total_weight <= 0 then
			//print( "Player has no support classes", ply, group_name )
			table.insert( unused_players, ply )
			continue
		end

		//Attempt to select class
		local class_name, select_group_name, slots

		repeat
			local tmp_class_name = select_wighted( available_classes )
			local tmp_class_tab = classes[tmp_class_name]

			if !classes_in_use[tmp_class_name] then
				classes_in_use[tmp_class_name] = 0
			end

			if tmp_class_tab.select_group and !select_groups[tmp_class_tab.select_group] then
				select_groups[tmp_class_tab.select_group] = 0
			end

			slots = tmp_class_tab.slots or 1

			local override = tmp_class_tab.select_override and tmp_class_tab.select_override( tmp_class_tab.select_group and select_groups[tmp_class_tab.select_group] or classes_in_use[tmp_class_name], max )
			if override != false and to_spawn - slots >= 0 and ( !tmp_class_tab.max or tmp_class_tab.max == 0 or ( tmp_class_tab.select_group and select_groups[tmp_class_tab.select_group] or classes_in_use[tmp_class_name] ) < tmp_class_tab.max ) then
				class_name = tmp_class_name
				select_group_name = tmp_class_tab.select_group
			end
		until class_name or #available_classes == 0

		if !class_name then
			print( "Failed to assing player '"..ply:Nick().."' to any class in group '"..group_name.."'!" )
			table.insert( unused_players, ply )
			continue
		end

		to_spawn = to_spawn - slots
		assigned_classes[ply] = class_name
		classes_in_use[class_name] = classes_in_use[class_name] + 1

		if select_group_name then
			select_groups[select_group_name] = select_groups[select_group_name] + 1
		end
	end

	/*print( "Classes assigned" )
	PrintTable( assigned_classes )
	print( "Unused players" )
	PrintTable( unused_players )*/

	//Return unused players to queue
	for i, v in rpairs( unused_players ) do
		QueueInsert( v, true )
	end

	//Amount check
	local count = table.Count( assigned_classes )
	if count == 0 or count < support_minimum then
		print( "Failed to assign minimum amount of players to support '"..group_name.."' ("..count..")!" )

		for ply, class in pairs( assigned_classes ) do
			QueueInsert( ply, true )
		end

		SetRoundProperty( "support_fail", group_name )
		return false
	end

	hook.Run( "SLCAlterAssignedSupport", assigned_classes )

	//Spawn all players
	local spawned = {}
	local class_spawns = {}
	local spawns = table.Copy( spawn_info )

	for ply, class_name in pairs( assigned_classes ) do
		local class_data = classes[class_name]
		local pos

		if class_data.spawn then
			if istable( class_data.spawn ) then
				if !class_spawns[class_name] or #class_spawns[class_name] == 0 then
					class_spawns[class_name] = table.Copy( class_data.spawn )
				end

				pos = table.remove( class_spawns[class_name], math.random( #class_spawns[class_name] ) )
			else
				pos = class_data.spawn
			end
		else
			if #spawns == 0 then
				spawns = table.Copy( spawn_info )
			end

			pos = table.remove( spawns, math.random( #spawns ) )
		end

		print( "Assigning '"..ply:Nick().."' to support class '"..class_name.."' ["..group_name.."]" )
		ply:SetupPlayer( class_data, pos )

		table.insert( spawned, ply )
	end

	if group_data.callback then
		group_data.callback()
	end

	SetRoundProperty( "support_fail", nil )

	AddTimer( "SupportInitialIDs", INFO_SCREEN_DURATION + 1, 1, function()
		net.Start( "InitialIDs" )
			net.WriteTable( spawned )
		net.Send( spawned )
	end )

	if group_override then
		SetupSupportTimer()
	end

	MoveSuicideQueue()

	return true
end

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

		if override or SCPTeams.CanEscape( team ) or GetRoundStat( "alpha_warhead" ) then
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

		TransmitEscapeInfo( tab )

		if GetRoundStat( "alpha_warhead" ) then
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

				v:KillSilent()
				v:SetSCPTeam( TEAM_SPEC )
				v:SetSCPClass( "spectator" )
				v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

				AddRoundStat( "escapes" )
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

				if ROUND.aftermatch then
					xp = min

					msg = {
						"escape1",
						{ "escape_xp", "text;"..xp }
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
						{ "escape_xp", "text;"..xp }
					}
				end

				for k, v in ipairs( tab ) do
					if hook.Run( "SLCPlayerEscaped", v, false, diff or -1, rtime or -1 ) == true then continue end

					//CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp ), v )
					InfoScreen( v, "escaped", INFO_SCREEN_DURATION, msg )

					v:AddXP( xp, "escape" )

					local team = v:SCPTeam()
					SCPTeams.AddScore( team, SCPTeams.GetReward( team ) * 3 )

					v:Despawn()

					v:KillSilent()
					v:SetSCPTeam( TEAM_SPEC )
					v:SetSCPClass( "spectator" )
					v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

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
function StartAftermatch( endcheck )
	if ROUND.post then return end

	print( "Starting aftermatch" )
	//PlayerMessage( "aftermatch", LAST_ESCAPE )

	local support_timer = GetTimer( "SupportTimer" )
	if IsValid( support_timer ) then
		support_timer:Destroy()
		//print( "SUPPORT TIMER DESTROYED" )
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

			v:TakeDamage( 1 )
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
			v:SetSCPTeam( TEAM_SPEC )
			v:SetSCPClass( "spectator" )
			v.DeathScreen = CurTime() + INFO_SCREEN_DURATION
		end

		AddRoundStat( "escorts", num )

		local points = num * CVAR.slc_points_escort:GetInt()

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

	for k, v in ipairs( tab ) do
		local r = v:GetSCPPenalty()
		if r <= 0 then
			PlayerMessage( "scpready$"..( -r + 1 ).."#50,200,50", v )
		else
			PlayerMessage( "scpwait$"..r.."#200,50,50", v )
		end
	end
end

--[[-------------------------------------------------------------------------
Map functions
---------------------------------------------------------------------------]]
function UseAll()
	for k, v in ipairs( FORCE_USE ) do
		for _, ent in ipairs( ents.GetAll() ) do
			if ent:GetPos() == v then
				ent:Fire( "Use" )
				break
			end
		end
	end
end

function DestroyAll()
	for k, v in ipairs( FORCE_DESTROY ) do
		if isvector( v ) then
			for _, ent in ipairs( ents.GetAll() ) do
				if ent:GetPos() == v then
					ent:Remove()
					break
				end
			end
		elseif isnumber( v ) then
			local ent = ents.GetMapCreatedEntity( v )
			if IsValid( ent ) then
				ent:Remove()
			end
		end
	end
end

function OpenSCPs()
	local lookup = {
		func_door = POS_DOOR,
		func_rot_button = POS_ROT_BUTTON,
		func_button = POS_BUTTON,
	}

	for i, v in ipairs( ents.GetAll() ) do
		local class = v:GetClass()
		local tab = lookup[class]
		if !tab then continue end

		for _, pos in ipairs( tab ) do
			if v:GetPos() != pos then continue end

			if class == "func_door" then
				v:Fire( "unlock" )
				v:Fire( "open" )
			else
				v:Fire( "use" )
			end

			break
		end
	end
end