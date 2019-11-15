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

		local lvl = ply:SCPLevel()
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
						owned = lvl >= class.level
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
		for i = 1, num do
			local index = math.random( #plys )
			local ply = plys[index]

			if playertab[ply][g_name].any then
				table.remove( plys, index )
				table.insert( classplayers, ply )
			end
		end

		table.sort( classplayers, levelsort )

		local classes, spawninfo = getClassGroup( g_name )
		local spawns = table.Copy( spawninfo )
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

					print( "Assigning '"..ply:Nick().." to class '"..class.name.."' ["..g_name.."]" )

					ply:SetupPlayer( class )
					ply:SetInitialTeam( class.team )

					--if class.spawn then
						--ply:SetPos( istable( class.spawn ) and table.Random( class.spawn ) or class.spawn )
					--else
						ply:SetPos( table.remove( spawns, math.random( #spawns ) ) )
					--end

					all = all - 1
				end
			end
		end
	end
end

function SpawnSupport()
	local plys = ROUND.queue
	if #plys == 0 then
		local tab = SCPTeams.getPlayersByTeam( TEAM_SPEC )

		if #tab == 0 then return end
		plys = tab
	end


	local group, callback = selectSupportGroup()
	local classes, spawninfo = getSupportGroup( group )
	local spawns = table.Copy( spawninfo )

	local num = 0
	local inuse = {}
	local max = CVAR.maxsupport:GetInt()

	repeat
		local ply

		repeat
			local p = table.remove( plys, 1 )

			if IsValid( p ) and !p:Alive() and p:SCPTeam() == TEAM_SPEC then
				ply = p
				break
			end
		until #plys == 0

		if !IsValid( ply ) then break end

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
					owned = ply:SCPLevel() >= v.level
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
			ply:SetupPlayer( class )
			ply:SetPos( table.remove( spawns, math.random( #spawns ) ) )

			inuse[class.name] = inuse[class.name] + 1
			num = num + 1
		end
	until num >= max

	if num > 0 then
		if callback then
			callback()
		end

		return true
	end
end

function CheckEscape()
	if ROUND.post then return end
	for k, v in pairs( player.GetAll() ) do
		local team = v:SCPTeam()
		if v:GetPos():DistToSqr( POS_ESCAPE ) <= 22500 and SCPTeams.canEscape( team ) then
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

				xp = math.floor( xp )

				CenterMessage( string.format( "escaped#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp ), v )

				v:AddXP( xp )
				SCPTeams.addScore( team, SCPTeams.getReward( team ) * 3 )

				v:Despawn()

				v:KillSilent()
				v:SetupSpectator()

				AddRoundStat( "escapes" )

				CheckRoundEnd()
			end
		end
	end
end

function PlayerEscort( ply )
	if ROUND.post then return end

	local team = ply:SCPTeam()
	local pos = _G["POS_ESCORT_"..SCPTeams.getName( team )] or POS_ESCORT
	if ply:GetPos():DistToSqr( pos ) > 62500 then return end

	local t = GetTimer( "SLCRound" )
	if IsValid( timer ) then
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

		local msg = string.format( "escorted#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp )
		for k, v in pairs( plys ) do
			CenterMessage( msg, v )

			v:AddXP( xp )
			local vteam = v:SCPTeam()
			SCPTeams.addScore( vteam, SCPTeams.getReward( vteam ) * 5 )

			v:Despawn()

			v:KillSilent()
			v:SetupSpectator()
		end

		AddRoundStat( "escorts", num )

		local points = num * CVAR.escortpoints:GetInt()
		
		PlayerMessage( "escortpoints$"..points )
		ply:AddFrags( points )

		CheckRoundEnd()
	end
end

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

local function applyTable( item, tab )
	for k, v in pairs( tab ) do
		if istable( v ) then
			if v._final then
				v._final = nil
				item[k] = v
			else
				item[k] = item[k] or {}
				applyTable( item[k], v )
			end
		else
			item[k] = v
		end
	end
end

function SpawnGeneric( class, pos, num, post_tab, post_func )
	if isfunction( post_tab ) then
		post_func = post_tab
		post_tab = nil
	end

	if istable( pos ) then
		if pos._dnc or post_tab and post_tab._dnc  then
			pos._dnc = nil
		else
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
			item:Spawn()
			item:SetPos( seq and pos[i] or table.remove( pos, math.random( #pos ) ) )

			if post_tab then
				applyTable( item, post_tab )
			end

			if post_func then
				post_func( item )
			end
		end
	end
end

function SpawnItems() --TODO
	--[[-------------------------------------------------------------------------
	SCPs
	---------------------------------------------------------------------------]]
	/*local item = ents.Create( "item_scp_714" )
	if IsValid( item ) then
		item:SetPos( SPAWN_714 )
		item:Spawn()
	end
	
	local pos500 = table.Copy( SPAWN_500 )
	
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
		local vest = ents.Create( "item_vest" )
		if IsValid( vest ) then
			vest:Spawn()
			vest:SetPos( v - Vector( 0, 0, 10 ) )
			vest:SetVest( VEST.getRandomVest() )
		end
	end
	
	--[[-------------------------------------------------------------------------
	Weapons
	---------------------------------------------------------------------------]]
	SpawnGeneric( { "cw_deagle", "cw_fiveseven" }, SPAWN_PISTOLS, -1, { Dropped = 0 } )
	SpawnGeneric( { "cw_g36c", "cw_ump45", "cw_mp5" }, SPAWN_SMGS, -1, { Dropped = 0 } )
	SpawnGeneric( { "cw_ak74", "cw_ar15", "cw_m14", "cw_scarh" }, SPAWN_RIFLES, -1, { Dropped = 0 } )
	SpawnGeneric( { "cw_shorty", "cw_m3super90" }, SPAWN_PUMP, -1, { Dropped = 0 } )
	SpawnGeneric( "cw_l115", SPAWN_SNIPER, -1, { Dropped = 0 } )
	SpawnGeneric( "cw_ammo_kit_regular", SPAWN_AMMO_CW, -1, { AmmoCapacity = 15 } )
	SpawnGeneric( "weapon_crowbar", SPAWN_MELEE, 3, { Dropped = 0 } )
	
	--[[-------------------------------------------------------------------------
	Items
	---------------------------------------------------------------------------]]
	local spawn_items = table.Copy( SPAWN_ITEMS )

	SpawnGeneric( "item_slc_radio", spawn_items, 2, { Dropped = 0, _dnc = true } )
	SpawnGeneric( "item_slc_nvg", spawn_items, 2, { Dropped = 0, _dnc = true } )
	SpawnGeneric( "item_slc_gasmask", spawn_items, 2, { Dropped = 0, _dnc = true } )
	SpawnGeneric( "item_slc_battery", SPAWN_BATTERY, -1, { Dropped = 0 } )
	SpawnGeneric( "item_slc_flashlight", SPAWN_FLASHLIGHT, 8, { Dropped = 0 } )
	SpawnGeneric( "item_slc_medkit", SPAWN_MEDKITS, 4, { Dropped = 0 } )
	
	--[[-------------------------------------------------------------------------
	Keycards
	---------------------------------------------------------------------------]]
	for k, v in pairs( KEYCARDS or {} ) do
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
	end

	--[[-------------------------------------------------------------------------
	Cameras
	---------------------------------------------------------------------------]]
	for i, v in ipairs( CCTV ) do
		local cctv = ents.Create( "item_cctv" )

		if IsValid( cctv ) then
			cctv:Spawn()
			cctv:SetPos( v.pos )

			cctv:SetCam( i )

			v.ent = cctv
		end
	end

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
end