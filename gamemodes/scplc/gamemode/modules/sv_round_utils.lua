--[[-------------------------------------------------------------------------
Spawn players
---------------------------------------------------------------------------]]
local function copy_spawns( spawns, prev )
	if !istable( spawns ) then return spawns end
	if !istable( spawns[1] ) then return table.Copy( spawns ) end

	local rng = prev and prev._rng or SLCRandom( #spawns )
	local copy = table.Copy( spawns[rng] )
	copy._rng = rng

	return copy
end

local function select_weighted( tab, total_weight, rem )
	if isbool( total_weight ) then
		rem = total_weight
		total_weight = nil
	end

	local rng = SLCRandom( total_weight or tab.total_weight )
	local sum = 0

	for i, v in ipairs( tab ) do
		sum = sum + v.weight
		if sum < rng then continue end

		if rem then
			table.remove( tab, i )

			if !total_weight then
				tab.total_weight = tab.total_weight - v.weight
			end
		end

		return v.value
	end
end

local function assign_scps( plys, num )
	if num <= 0 then return {} end

	local skip_filter = CVAR.slc_scp_filter_last:GetInt() != 1
	local scp_list = {}

	-- Filter last round SCP
	//print( "Collecting SCPS", skip_filter )
	for i, v in ipairs( SCPS ) do
		if skip_filter or !ROUND.LastRoundSCPs or !ROUND.LastRoundSCPs[v] then
			//print( "Add", v )
			table.insert( scp_list, v )
		else
			//print( "Skip", v )
		end
	end

	-- Calculate select chances
	local priority_players, other_players = { total_weight = 0 }, {}
	local exponent = CVAR.slc_scp_chance_exponent:GetFloat()
	local use_weights = exponent > 0
	local karma_enabled = CVAR.slc_scp_karma:GetInt() == 1

	//printf( "Collecting players - plys: %i, num: %i, exp: %.2f, u/w: %s", #plys, num, exponent, use_weights )
	for i, v in ipairs( plys ) do
		local penalty = v:GetSCPPenalty()
		if use_weights and penalty <= 0 then
			local karma_mult = 1

			if karma_enabled then
				karma_mult =  math.ClampMap( v:GetPlayerKarma(), 0, 1000, 1, 1.2 )
			end

			local weight = math.ceil( ( -penalty + 1 ) ^ exponent * karma_mult )

			priority_players.total_weight = priority_players.total_weight + weight
			table.insert( priority_players, { value = v, weight = weight } )
		else
			table.insert( other_players, v )
		end
	end

	//print( "Prio" )
	//PrintTable( priority_players )
	//print( "Non-prio" )
	//PrintTable( other_players )

	-- Select players and SCPs
	local assigned_scps = {}

	for i = 1, num do
		//print( "Iter", i )

		if #scp_list == 0 then
			//print( "SCP Select - not enough SCPs" )
			break
		end

		local ply

		if priority_players.total_weight > 0 then
			//print( "Priority select" )
			ply = select_weighted( priority_players, true )
		else
			//print( "Non-priority select" )
			local other_len = #other_players
			if other_len > 0 then
				ply = table.remove( other_players, SLCRandom( other_len ) )
			end
		end

		if !ply then
			ErrorNoHalt( "THIS SHOULD NEVER HAPPEN! Failed to select player for SCP\n" )
			break
		end

		local scp = table.remove( scp_list, SLCRandom( #scp_list ) )
		local obj = GetSCP( scp )

		//print( "Selected", ply, scp )

		if obj.basestats.avoid then
			for _, v in ipairs( obj.basestats.avoid ) do
				table.RemoveByValue( scp_list, v )
				//print( "Removing avoid SCP", v )
			end
		end

		table.RemoveByValue( plys, ply )
		assigned_scps[ply] = scp
	end

	//printf( "Done - plys left: %i, SCPs left: %i", #plys, #scp_list )
	//PrintTable( assigned_scps )

	return assigned_scps
end

function get_player_classes( plys, groups )
	local player_classes = {}

	//printf( "Collecting players for group", #plys )

	for _, ply in ipairs( plys ) do
		local ply_tab = {}
		player_classes[ply] = ply_tab
	
		//print( "> "..tostring( ply ) )
	
		for group, classes in pairs( groups ) do
			//print( "  > "..group )

			local ply_weight = ply:GetGroupData( group ) + 1
			local override = hook.Run( "SLCGroupPlayerWeight", ply, group, ply_weight )
			if isnumber( override ) then
				ply_weight = math.ceil( override )
			end

			if ply_weight <= 0 then /*print( "    > weight <= 0", ply_weight )*/ continue end

			local group_tab = { total_weight = 0, ply_weight = ply_weight }
			ply_tab[group] = group_tab

			for class, data in pairs( classes ) do
				//print( "    > "..class )
				if data.no_select then continue end

				local weight

				if data.override then
					local result = data.override( ply )
					if result then
						weight = isnumber( result ) and result or true
					elseif result == false then
						weight = false
					end
					//print( "      > override", weight )
				end

				if weight != false and !isnumber( weight ) then
					weight = ( weight or ply:IsClassUnlocked( data.name ) ) and ( data.weight or data.tier and ( data.tier + 1 ) or 1 )
					//print( "      > weight", weight )
				end

				if weight and weight > 0 then
					weight = math.ceil( weight )

					group_tab.total_weight = group_tab.total_weight + weight
					table.insert( group_tab, { value = class, weight = weight } )
				end
			end

			if group_tab.total_weight <= 0 then
				ErrorNoHalt( "THIS SHOULD NEVER HAPPEN! Player '", ply, "' has no class available in group: ", group, "! Did you register this group properly?\n" )
				continue
			end
		end
	end

	//print( "Done" )
	//PrintTable( player_classes )

	return player_classes
end

local function group_players_compare( a, b )
	if a.order == b.order then
		return a.index < b.index
	end

	return a.order > b.order
end

function assign_groups( plys, all_groups, player_classes )
	local groups_order = {}

	//print( "Collecting groups" )
	for k, v in pairs( all_groups ) do
		table.insert( groups_order, k )
	end
	//PrintTable( groups_order )

	//print( "Shuffle" )
	ShuffleTable( groups_order )
	//PrintTable( groups_order )

	//print( "Player table" )
	local ply_tab = GetPlayerTable( #plys )
	//PrintTable( ply_tab )

	local assigned_groups = {}
	for idx, group in ipairs( groups_order ) do
		//print( "Processing", idx, group )
		//PrintTable( plys )

		local available_plys = { total_weight = 0 }
		for _, ply in ipairs( plys ) do
			local group_data = player_classes[ply][group]
			if !group_data or group_data.total_weight < 1 then /*print( "Player has no class in group", ply, group )*/ continue end

			available_plys.total_weight = available_plys.total_weight + group_data.ply_weight
			table.insert( available_plys, { value = ply, weight = group_data.ply_weight } )
		end

		local to_select = math.Clamp( ply_tab[group] or 0, 0, #available_plys )
		//print( "Selecting", to_select, ply_tab[group], #available_plys )

		local karma_enabled = CVAR.slc_scp_karma:GetInt() == 1
		local tmp_players = {}

		for i = 1, to_select do
			local ply = select_weighted( available_plys, true )
			if !ply then
				//print( "FATAL" )
				break
			end

			local karma_add = 0

			if karma_enabled then
				karma_add = math.floor( math.ClampMap( ply:GetPlayerKarma(), 0, 1000, 0, 2.5 ) )
			end

			tmp_players[i] = { ply = ply, index = i, order = ply:GetPrestigeLevel() + karma_add }
			table.RemoveByValue( plys, ply )
			//print( "Player select", i, ply )
		end

		table.sort( tmp_players, group_players_compare )

		local group_tab = {}
		assigned_groups[group] = group_tab

		for i, v in ipairs( tmp_players ) do
			group_tab[i] = v.ply
		end

		//print( "---" )
	end

	//print( "Done" )
	//PrintTable( assigned_groups )

	return assigned_groups
end

function assign_classes( groups, assigned_groups, player_classes )
	local assigned_classes = {}
	local classes_in_use = {}
	local select_groups = {}

	for group, plys in pairs( assigned_groups ) do
		local group_tab = groups[group]
		local group_total = #plys

		//print( "Processing", group, #plys )

		for i, ply in ipairs( plys ) do
			//print( "  > "..tostring(ply) )
			local ply_classes = player_classes[ply][group]

			while ply_classes.total_weight > 0 do
				local tmp_class = select_weighted( ply_classes, true )
				local tmp_data = group_tab[tmp_class]
				local select_group = tmp_data.select_group or tmp_class

				//Msg( "    > "..tmp_class )

				if !classes_in_use[tmp_class] then
					classes_in_use[tmp_class] = 0
				end

				if !select_groups[select_group] then
					select_groups[select_group] = 0
				end

				local override = tmp_data.select_override and tmp_data.select_override( tmp_class, classes_in_use[tmp_class], select_groups[select_group], group_total )
				if override == true or override == nil and (
					( !tmp_data.max or tmp_data.max == 0 or classes_in_use[tmp_class] < tmp_data.max ) and
					( !tmp_data.group_max or tmp_data.group_max == 0 or select_groups[select_group] < tmp_data.group_max )
				) then
					assigned_classes[ply] = tmp_class
					classes_in_use[tmp_class] = classes_in_use[tmp_class] + 1
					select_groups[select_group] = select_groups[select_group] + ( tmp_data.group_slots or 1 )
					//Msg( " <----", tmp_data.max, classes_in_use[tmp_class], select_groups[select_group], "\n" )
					break
				end
				//print()
			end

			if !assigned_classes[ply] then
				ErrorNoHalt( "Failed to assign player '", ply, "' to any class in group '", group, "'! Falling back to 'classd'..." )
				assigned_classes[ply] = "classd"
			end
		end
	end

	//print( "Done" )
	//PrintTable( assigned_classes )

	return assigned_classes
end

function SetupPlayers()
	local active_plys = GetActivePlayers()
	local plys_num = #active_plys
	local scp_num = 0

	if SLC_SCP_OVERRIDE then
		scp_num = SLC_SCP_OVERRIDE( plys_num )
	elseif plys_num >= CVAR.slc_scp_min_players:GetInt() then
		scp_num = math.ceil( plys_num / math.max( CVAR.slc_players_per_scp:GetInt(), 5 ) )
	end

	//print( "Setting up players", plys_num )
	//print( "==================================" )

	//print( "=== Assigning SCPs ===" )
	local assigned_scps = assign_scps( active_plys, scp_num )
	hook.Run( "SLCAlterAssignedSCPs", assigned_scps )
	//print( "==================================" )

	for i, v in ipairs( active_plys ) do
		local penalty = v:GetSCPPenalty()
		if penalty > 0 or scp_num > 0 then
			v:SetSCPPenalty( penalty - 1 )
		end
	end

	local groups = GetClassGroups()
	local spawns = GetSpawnInfo()

	groups.SUPPORT = nil

	//print( "=== Setting up player classes ===" )
	local player_classes = get_player_classes( active_plys, groups )
	//print( "==================================" )

	//print( "=== Assigning groups ===" )
	local assigned_groups = assign_groups( active_plys, groups, player_classes )
	hook.Run( "SLCAlterAssignedGroups", assigned_groups )
	//print( "==================================" )

	//print( "=== Assigning classes ===" )
	local assigned_classes = assign_classes( groups, assigned_groups, player_classes )
	hook.Run( "SLCAlterAssignedClasses", assigned_classes )
	//print( "==================================" )

	//print( "=== Spawning SCPs ===" )
	local initial_teams = {
		scps = {}
	}

	local initial_teams_plys = {
		scps = {}
	}

	local penalty = CVAR.slc_scp_penalty:GetInt()
	local ppenalty = CVAR.slc_scp_premium_penalty:GetInt()

	for ply, scp in pairs( assigned_scps ) do
		local obj = GetSCP( scp )
		obj:SetupPlayer( ply )
		
		ply:SetSCPPenalty( ply:IsPremium() and ppenalty or penalty )
		
		ply:SetInitialTeam( TEAM_SCP )
		table.insert( initial_teams_plys.scps, ply )
		initial_teams.scps[ply] = { TEAM_SCP, TEAM_SCP }

		print( "Spawning '"..ply:Nick().."' as '"..obj.name.."' [SCP]" )
	end
	//print( "==================================" )
	//print( "=== Spawning classes ===" )

	local group_spawn_table = {}
	local class_spawn_table = {}

	for group, plys in pairs( assigned_groups ) do
		//print( "Spawning group", group, #plys )
		local group_data = groups[group]
		local group_spawns = group_spawn_table[group]

		for _, ply in ipairs( plys ) do
			local class = assigned_classes[ply]
			//print( "  > "..tostring( ply ), class )
			local class_data = group_data[class]
			local spawn_pos

			local class_spawns = class_data.spawn
			local stype = type( class_spawns )
			if stype == "Vector" then
				//print( "    > using individual spawn (single)" )
				spawn_pos = class_spawns
			elseif stype == "table" then
				local spawn_table = class_spawn_table[class_spawns]
				if !spawn_table or #spawn_table == 0 then
					spawn_table = copy_spawns( class_spawns, spawn_table )
					class_spawn_table[class_spawns] = spawn_table
				end

				//print( "    > using individual spawn (table)", #spawn_table )
				spawn_pos = table.remove( spawn_table, SLCRandom( #spawn_table ) )
			elseif stype == "string" then
				local spawn_table = group_spawn_table[class_spawns]
				if !spawn_table or #spawn_table == 0 then
					spawn_table = copy_spawns( spawns[class_spawns], spawn_table )
					group_spawn_table[class_spawns] = spawn_table
				end

				//print( "    > using foreign spawn", class_spawns, #spawn_table )
				spawn_pos = table.remove( spawn_table, SLCRandom( #spawn_table ) )
			else
				if !group_spawns or #group_spawns == 0 then
					group_spawns = copy_spawns( spawns[group], group_spawns )
					group_spawn_table[group] = group_spawns
				end

				//print( "    > using native spawn", #group_spawns )
				spawn_pos = table.remove( group_spawns, SLCRandom( #group_spawns ) )
			end

			ply:SetupPlayer( class_data, spawn_pos )
			ply:SetInitialTeam( class_data.team )
			ply:ApplyGroupData( group )

			if !initial_teams[group] then
				initial_teams[group] = {}
				initial_teams_plys[group] = {}
			end

			table.insert( initial_teams_plys[group], ply )
			initial_teams[group][ply] = { class_data.team, class_data.persona and class_data.persona.team or class_data.team }

			if class_data.id_group then
				if !initial_teams[class_data.id_group] then
					initial_teams[class_data.id_group] = {}
					initial_teams_plys[class_data.id_group] = {}
				end

				table.insert( initial_teams_plys[class_data.id_group], ply )
				initial_teams[class_data.id_group][ply] = { class_data.team, class_data.persona and class_data.persona.team or class_data.team }
			end

			print( "Spawning '"..ply:Nick().."' as '"..class.."' ["..group.."]" )
		end
	end

	AddTimer( "RoundInitialIDs", INFO_SCREEN_DURATION + 1, 1, function()
		for k, v in pairs( initial_teams ) do
			net.Start( "InitialIDs" )
				net.WriteTable( v )
			net.Send( initial_teams_plys[k] )
		end
	end )
	//print( "==================================" )
	//print( "All done!" )
end

hook.Add( "SLCRound", "SLCSCPLastRound", function()
	local tab = {}
	ROUND.LastRoundSCPs = tab

	for i, v in ipairs( player.GetAll() ) do
		if v:SCPTeam() == TEAM_SCP then
			tab[v:SCPClass()] = true
		end
	end
end )

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

function QueueUpdate()
	local done = {}

	for i, v in ipairs( queue ) do
		if IsValid( v ) then
			v:SetQueuePosition( i )
			done[v] = true
		end
	end

	for i, v in ipairs( suicide_queue ) do
		if IsValid( v ) then
			v:SetQueuePosition( -1 )
			done[v] = true
		end
	end

	for i, v in ipairs( player.GetAll() ) do
		if !done[v] and IsValid( v ) then
			v:SetQueuePosition( 0 )
		end
	end
end

function QueueInsert( ply, front )
	if !ply:IsValidSpectator() or queue_lookup[ply] then return end

	if suicide_queue_sid[ply:SteamID64()] then
		QueueInsertSuicide( ply, front )
		return
	end

	if front then
		table.insert( queue, 1, ply )
		QueueUpdate()
	else
		ply:SetQueuePosition( table.insert( queue, ply ) )
	end

	queue_lookup[ply] = true
end

function QueueInsertSuicide( ply, front )
	if !ply:IsValidSpectator() or queue_lookup[ply] then return end

	queue_lookup[ply] = true
	suicide_queue_sid[ply:SteamID64()] = true

	if front then
		table.insert( suicide_queue, 1, ply )
	else
		table.insert( suicide_queue, ply )
	end

	ply:SetQueuePosition( -1 )
end

function QueueRemove( low )
	local ply

	repeat
		if #queue == 0 then
			if !low then return NULL, false end

			ply = nil
			break
		end

		ply = table.remove( queue, 1 )
		queue_lookup[ply] = nil
	until IsValid( ply ) and ply:IsValidSpectator()

	if ply then return ply, false end

	repeat
		if #suicide_queue == 0 then return NULL, true end

		ply = table.remove( suicide_queue, 1 )
		queue_lookup[ply] = nil

		if IsValid( ply ) then
			suicide_queue_sid[ply:SteamID64()] = nil
		end
	until IsValid( ply ) and ply:IsValidSpectator()

	return ply, true
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
					weight = isnumber( result ) and result or true
				elseif result == false then
					weight = false
				end
			end

			if weight != false and !isnumber( weight ) then
				weight = ( weight or ply:IsClassUnlocked( class.name ) ) and ( class.weight or class.tier and ( class.tier + 1 ) or 1 )
			end

			if weight and weight > 0 then
				available_classes.total_weight = available_classes.total_weight + weight
				table.insert( available_classes, { value = class_name, weight = weight } )
			end
		end

		if available_classes.total_weight <= 0 then
			//print( "Player has no support classes", ply, group_name )
			table.insert( unused_players, ply )
			continue
		end

		//Attempt to select class
		while available_classes.total_weight > 0 do
			local tmp_class = select_weighted( available_classes, true )
			local tmp_data = classes[tmp_class]
			local select_group = tmp_data.select_group or tmp_class
			local slots = tmp_data.slots or 1

			if !classes_in_use[tmp_class] then
				classes_in_use[tmp_class] = 0
			end

			if !select_groups[select_group] then
				select_groups[select_group] = 0
			end


			local override = tmp_data.select_override and tmp_data.select_override( tmp_class, classes_in_use[tmp_class], select_groups[select_group], max )
			if override == true or override == nil and to_spawn - slots >= 0 and (
				( !tmp_data.max or tmp_data.max == 0 or classes_in_use[tmp_class] < tmp_data.max ) and
				( !tmp_data.group_max or tmp_data.group_max == 0 or select_groups[select_group] < tmp_data.max )
			) then
				to_spawn = to_spawn - slots
				assigned_classes[ply] = tmp_class
				classes_in_use[tmp_class] = classes_in_use[tmp_class] + 1
				select_groups[select_group] = select_groups[select_group] + ( tmp_data.group_slots or slots )

				break
			end
		end

		if !assigned_classes[ply] then
			print( "Failed to assing player '"..ply:Nick().."' to any class in group '"..group_name.."'!" )
			table.insert( unused_players, ply )
			continue
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
	local spawned_plys = {}

	local class_spawns = {}
	local spawns = copy_spawns( spawn_info )

	for ply, class_name in pairs( assigned_classes ) do
		local class_data = classes[class_name]
		local pos

		if class_data.spawn then
			if istable( class_data.spawn ) then
				if !class_spawns[class_name] or #class_spawns[class_name] == 0 then
					class_spawns[class_name] = copy_spawns( class_data.spawn, class_spawns[class_name] )
				end

				pos = table.remove( class_spawns[class_name], SLCRandom( #class_spawns[class_name] ) )
			else
				pos = class_data.spawn
			end
		else
			if #spawns == 0 then
				spawns = copy_spawns( spawn_info, spawns )
			end

			pos = table.remove( spawns, SLCRandom( #spawns ) )
		end

		print( "Assigning '"..ply:Nick().."' to support class '"..class_name.."' ["..group_name.."]" )
		ply:SetupPlayer( class_data, pos )

		table.insert( spawned_plys, ply )
		spawned[ply] = { class_data.team, class_data.persona and class_data.persona.team or class_data.team }
	end

	if group_data.callback then
		group_data.callback()
	end

	SetRoundProperty( "support_fail", nil )

	AddTimer( "SupportInitialIDs", INFO_SCREEN_DURATION + 1, 1, function()
		net.Start( "InitialIDs" )
			net.WriteTable( spawned )
		net.Send( spawned_plys )
	end )

	if group_override then
		SetupSupportTimer()
	end

	MoveSuicideQueue()

	return true
end