--[[-------------------------------------------------------------------------
SCP 106 functions
---------------------------------------------------------------------------]]
local function setup_collision_106( ent )
	if !IsValid( ent ) then return end

	local class = ent:GetClass()
	if class != "func_door" and class != "func_door_rotating" and class != "prop_dynamic" then return end

	if class == "prop_dynamic" then
		local ennt = ents.FindInSphere( ent:GetPos(), 50 )
		local neardors = false

		for i, v in ipairs( ennt ) do
			local fc = v:GetClass()
			if fc == "func_door" or fc == "func_door_rotating" then
				neardors = true
				break
			end
		end

		if !neardors then
			ent.ignorecollide106 = false
			return
		end
	end

	for _, pos in pairs( DOOR_RESTRICT106 ) do
		if ent:GetPos():Distance( pos ) < 100 then
			ent.ignorecollide106 = false
			return
		end
	end
	
	ent.ignorecollide106 = true
end

if CLIENT then
	hook.Add( "OnEntityCreated", "SCP106Collision", function( ent )
		timer.Simple( 0, function()
			setup_collision_106( ent )
		end )
	end )
end

local scp106_bounds = Vector( 32, 15, 55 )
local scp106_mid = Vector( 2304, 4612.5, 568 )//Vector( 2304, 4975, 568 )
local scp106_num = 8
local scp106_rad = 350
local scp106_off = {
	-0.5,
	-0.8,
	-0.65,
	0,
	0.6,
	0.8,
	0.6,
	0
}

local pos_106tp_pd = {
	Vector( 2297.00, 4588.00, 523.00 ),
	Vector( 2369.00, 6085.00, 347.00 ),
	Vector( 1718.00, 6072.00, 139.00 ),
	Vector( 2698.00, 6059.00, 139.00 ),
	Vector( 3711.00, 4865.00, 651.00 ),
	Vector( 3717.00, 3877.00, 907.00 ),
}

local pos_106tp_hcz = {
	Vector( 2410.00, 2889.00, -373.00 ),
	Vector( 4693.00, 3020.00, -117.00 ),
	Vector( 4159.00, 3026.00, 11.00 ),
	Vector( 4156.00, 1077.00, 12.00 ),
	Vector( 3470.00, -192.00, 11.00 ),
	Vector( 5447.00, -194.00, 12.00 ),
	Vector( 2863.00, 1741.00, 11.00 ),
	Vector( 2113.00, 4060.00, 12.00 ),
}

local pos_106tp_ez = {
	Vector( 836.00, 2976.00, 11.00 ),
	Vector( -780.00, 2821.00, 11.00 ),
	Vector( -2361.00, 2394.00, 11.00 ),
	Vector( -1661.00, 3655.00, 11.00 ),
	Vector( -1054.00, 3839.00, -53.00 ),
	Vector( -647.00, 4321.00, -53.00 ),
	Vector( 136.00, 3426.00, -117.00 ),
	Vector( -1532.00, 2526.00, -117.00 ),
	Vector( -1930.00, 2543.00, -117.00 ),
	Vector( -3378.00, 2261.00, 139.00 ),
	Vector( -1087.00, 2224.00, 11.00 ),
}

local pos_106tp_surf = {
	Vector( -638.00, 5023.00, 2571.00 ),
	Vector( -992.00, 5500.00, 2315.00 ),
	Vector( -482.00, 5503.00, 2315.00 ),
	Vector( -77.00, 7294.00, 2571.00 ),
	Vector( -2491.00, 6592.00, 3115.00 ),
	Vector( 426.00, 6724.00, 2187.00 ),
	Vector( -1983.00, 6631.00, 2187.00 ),
	Vector( -3128.00, 5329.00, 2187.00 ),
	Vector( -690.00, 6887.00, 2571.00 ),
	Vector( -2741.00, 7373.00, 3115.00 ),
	Vector( -77.00, 6533.00, 3115.00 ),
	Vector( -2422.00, 6744.00, 2571.00 ),
}

local function scp106_tp_func( self, ent )
	if !ent:IsPlayer() then return end

	local t = ent:SCPTeam()
	if t == TEAM_SPEC then return end

	local status = t == TEAM_SCP

	if !status then
		local num = ent:GetProperty( "106exit", 0 ) + 1
		if math.random() < num * 0.25 then
			ent:SetProperty( "106exit", 0 )
			status = true
		else
			ent:SetProperty( "106exit", num )
		end
	end

	if status then
		local tab = !GetRoundStat( "omega_warhead" ) and (
				GetGasPower( ZONE_HCZ ) == 0 and pos_106tp_hcz or ( GetRoundStat( "alpha_warhead" ) or GetGasPower( ZONE_EZ ) == 0 ) and pos_106tp_ez
			) or pos_106tp_surf
		
		ent:SetPos( tab[math.random( #tab )] )
	else
		ent:SetPos( pos_106tp_pd[math.random( #pos_106tp_pd )] )
		TransmitSound( "#scp_lc/scp/106/laugh.ogg", true, ent, 1 )
	end
end

--[[-------------------------------------------------------------------------
Door destroying

Must implement:
	- CanDestroyDoor( ent )
	- GetDoorEnts( ent )
	- GetDoorAreaportal( ent )
	- TranslateDoorModel( ent )
---------------------------------------------------------------------------]]

MAP_DOOR_POS = MAP_DOOR_POS or {}
MAP_DOOR_PAIRS = MAP_DOOR_PAIRS or {}
MAP_DOOR_PROPS = MAP_DOOR_PROPS or {}
MAP_DOOR_AREAPORTALS = MAP_DOOR_AREAPORTALS or {}
door_allowed_zones = {
	lcz = true,
	hcz = true,
	ez = true,
}

function CanDestroyDoor( ent, check_velocity )
	return IsValid( MAP_DOOR_PAIRS[ent] ) and ( !check_velocity or ent:GetVelocity():LengthSqr() < 1 )
end

function GetDoorEnts( ent )
	local other = MAP_DOOR_PAIRS[ent]
	if !other then
		return {
			ent,
			MAP_DOOR_PROPS[ent]
		}
	end

	return {
		ent,
		other,
		MAP_DOOR_PROPS[ent],
		MAP_DOOR_PROPS[other],
	}
end

function GetDoorAreaportal( ent )
	local other = MAP_DOOR_PAIRS[ent]
	return MAP_DOOR_AREAPORTALS[ent:GetName()] or IsValid( other ) and MAP_DOOR_AREAPORTALS[other:GetName()]
end

local door_data = {
	lcz = {
		model = "models/slc/destroyed_doors/lcz_door.mdl",
		offset = Vector( 0, 0, -54 ),
		right = 3,
		forward = 3,
		scale = 1.05,
		yaw = 90,
	},
	hcz = {
		model = "models/slc/destroyed_doors/hcz_door.mdl",
		offset = Vector( 0, 0, -53 ),
		right = 2,
		forward = 1,
		scale = 1.03,
		yaw = 90,
	},
}

local hcz_fix = {
	["models/foundation/doors/hcz_door_01.mdl"] = Vector( 0, -12, 0 ),
	["models/foundation/doors/hcz_door_02.mdl"] = Vector( 0, 8, 0 ),
}

door_data.ez = door_data.lcz

function TranslateDoorModel( ent, breach_ang )
	local zone = string.match( ent:GetName(), "^(%w+)_door_" )
	if !zone then return end

	local prop = MAP_DOOR_PROPS[ent]
	if !IsValid( prop ) then return end

	local data = door_data[zone]
	if !data then return end

	local ang = prop:GetAngles()
	ang.y = ang.y + data.yaw

	local right = data.right
	local forward = data.forward

	if math.abs( math.AngleDifference( breach_ang.y, ang.y ) ) > 90 then
		ang.y = ang.y + 180
	end

	local pos = MAP_DOOR_POS[ent] or prop:GetPos()

	local other = MAP_DOOR_PAIRS[ent]
	if IsValid( other ) then --calculate center based on model bounds of both parts of door
		local other_prop = MAP_DOOR_PROPS[other]
		if IsValid( other_prop ) then
			local other_pos = MAP_DOOR_POS[other] or other_prop:GetPos()
			local mins, maxs = prop:GetModelBounds()
			local other_mins, other_maxs = other:GetModelBounds()

			//debugoverlay.Box( pos, mins, maxs, 15, Color( 255, 0, 0, 20 ) )
			//debugoverlay.Box( other_pos, other_mins, other_maxs, 15, Color( 0, 255, 0, 20 ) )

			mins = pos + mins
			maxs = pos + maxs

			other_mins = other_pos + other_mins
			other_maxs = other_pos + other_maxs

			OrderVectors( mins, other_mins )
			OrderVectors( other_maxs, maxs )

			
			pos = ( mins + maxs ) / 2
			//debugoverlay.Box( pos, mins - pos, maxs - pos, 15, Color( 0, 0, 255, 20 ) )
		end
	end

	pos = pos + data.offset + ang:Right() * right + ang:Forward() * forward

	if zone == "hcz" and math.abs( math.abs( prop:GetAngles().y ) - 90 ) < 1 then
		pos = pos + hcz_fix[prop:GetModel()]
	end

	//debugoverlay.Axis( pos, Angle( 0 ), 15, 15, true )

	return data.model, pos, ang, data.scale
end

--[[-------------------------------------------------------------------------
It turns out that author of site19 missed some things during map creation like fcking door being wrongly named and now I have to fix it in code
because, yes you guessed correctly, he will not give vmf file to fix it and, yes you are also correct, he isn't going to fix it either...
Also, idk how the hell this "very skilled" mapper managed to make half of the fcking doors to have wrongly oriented fcking bounding boxes...
---------------------------------------------------------------------------]]
FRENCH_MAP_FIXED = FRENCH_MAP_FIXED or false
FRENCH_DOOR_SWAP = FRENCH_DOOR_SWAP or {}

local function fix_french_map()
	FRENCH_MAP_FIXED = true

	print( "French Map Fixer™" )

	local mismatch = {}
	for k, v in pairs( MAP_DOOR_PAIRS ) do
		if k:GetPos():DistToSqr( v:GetPos() ) > 2500 then
			mismatch[k] = true
		end
	end

	for door, _ in pairs( mismatch ) do
		local fix = false
		local near = ents.FindInSphere( door:GetPos(), 50 )
		for _, ent in ipairs( near ) do
			if ent == door or ent:GetClass() != "func_door" then continue end

			FRENCH_DOOR_SWAP[door:GetName()] = ent:GetName()
			fix = true

			break
		end

		if !fix then
			FRENCH_DOOR_SWAP[door:GetName()] = false
		end
	end
end

--[[-------------------------------------------------------------------------
New 914 logic ^^ because old one is dogshit
Also, fu mapper and release vmf if you don't care about it ffs
---------------------------------------------------------------------------]]
local function new_914_logic( ent, input, activator, caller, data )
	if input != "Use" then return end

	local use = CacheEntity( "bt_914_tirette" )
	local mode = CacheEntity( "bt_914_selecteur" )
	local door_input = CacheEntity( "914_door_input" )
	local door_output = CacheEntity( "914_door_output" )

	mode:Fire( "Lock" )
	CacheEntity( "machine" ):Fire( "PlaySound" )

	for i = 1, 7 do
		CacheEntity( "rot_914_"..i ):Fire( "Start" )
	end

	AddTimer( "Site19SCP914Logic_LockButton", 0.5, 1, function()
		use:Fire( "Lock" )
	end )

	AddTimer( "Site19SCP914Logic_CloseDoors", 2, 1, function()
		door_input:Fire( "Close" )
		door_output:Fire( "Close" )
	end )

	AddTimer( "Site19SCP914Logic_StopGears", 10, 1, function()
		for i = 1, 7 do
			CacheEntity( "rot_914_"..i ):Fire( "Stop" )
		end
	end )

	AddTimer( "Site19SCP914Logic_Finish", 14, 1, function()
		use:Fire( "Unlock" )
		mode:Fire( "Unlock" )

		door_input:Fire( "Open" )
		door_output:Fire( "Open" )
	end )
end

--[[-------------------------------------------------------------------------
Map related hooks
---------------------------------------------------------------------------]]
local remove_name = {
	//["914_relay"] = true,
	["4016"] = true, --Explosive melon
}

local remove_mapid = {
	[3097] = true, --PD rock
	[3096] = true, --PD rock
}

hook.Add( "SLCPreround", "Site19Preround", function()
	local door_lookup = {}
	local MAP_DOOR_PAIRS_TMP = {}

	MAP_DOOR_AREAPORTALS = {}
	MAP_DOOR_PAIRS = {}
	MAP_DOOR_PROPS = {}
	MAP_DOOR_POS = {}

	for i, v in ipairs( ents.GetAll() ) do
		local name = v:GetName()
		local class = v:GetClass()
		local mapid = v:MapCreationID()

		setup_collision_106( v )

		if name == "049_hall_button" then
			v:Fire( "Unlock" )
		elseif name == "966_door" then
			v:SetKeyValue( "forceclosed", "1" )
		elseif name == "049_door" then
			v:SetKeyValue( "forceclosed", "1" )
		elseif mapid == 3240 then --Unlock Gate B
			v:Fire( "Unlock" )
		elseif name == "bt_914_tirette" then
			v:ClearAllOutputs( "OnPressed" )
			CatchInput( "bt_914_tirette", new_914_logic )
		end
		
		if remove_name[name] or remove_mapid[mapid] then
			v:Remove()
		end

		if class == "func_door" and string.match( name, "^elev_" ) then
			v:SetKeyValue( "dmg", 0 )
		end

		if class == "func_door" and string.match( name, "_containment_door_" ) then
			v:SetKeyValue( "dmg", 0.2 )
		end

		if class == "func_areaportal" then
			MAP_DOOR_AREAPORTALS[v:GetKeyValues().target] = v
		end

		local door_zone, door_id = string.match( name, "^(%w-)_door_[12]_(%d+)$" )
		if door_zone and door_id and door_allowed_zones[door_zone] then
			door_lookup[name] = v

			if !MAP_DOOR_PAIRS_TMP[door_zone] then
				MAP_DOOR_PAIRS_TMP[door_zone] = {}
			end

			if !MAP_DOOR_PAIRS_TMP[door_zone][door_id] then
				MAP_DOOR_PAIRS_TMP[door_zone][door_id] = {}
			end

			table.insert( MAP_DOOR_PAIRS_TMP[door_zone][door_id], v )

			local prop = v:GetChildren()[1]
			MAP_DOOR_PROPS[v] = prop

			if IsValid( prop ) then
				MAP_DOOR_POS[v] = prop:GetPos()
			end
		end

		local pos = v:GetPos()
		if pos == Vector( 3972.00, 264.00, -330.00 ) then
			local btn = ents.Create( "slc_button" )
			if IsValid( btn ) then
				btn:SetName( "warhead_lever_alpha" )
				btn:Tie( v, 1, 1, Angle( 0, 0, 0 ), Angle( -180, 0, 0 ), true, Angle( 90, 0, 0 ) )
				btn:SetSound( "Buttons.snd21" )
				btn:Spawn()
			end
		elseif pos == Vector( 3972.00, 306.00, -330.00 ) then
			local btn = ents.Create( "slc_button" )
			if IsValid( btn ) then
				btn:SetName( "warhead_lever_omega" )
				btn:Tie( v, 1, 1, Angle( 0, 0, 0 ), Angle( -180, 0, 0 ), true, Angle( 90, 0, 0 ) )
				btn:SetSound( "Buttons.snd21" )
				btn:Spawn()
			end
		elseif pos == Vector( 228.00, -1388.00, -78.00 ) then
			v:SetName( "shelter_door_l" )
		elseif pos == Vector( 156.00, -1388.00, -78.00 ) then
			v:SetName( "shelter_door_r" )
		end
	end

	--[[-------------------------------------------------------------------------
	PD Teleport Change
	---------------------------------------------------------------------------]]
	for i = 1, scp106_num do
		local ang = 360 / scp106_num * i + ( scp106_off[i] or 0 )
		local rad = math.rad( ang )
		local pos = scp106_mid + Vector( math.sin( rad ) * scp106_rad, -math.cos( rad ) * scp106_rad, 0 )

		local tp = ents.Create( "slc_trigger" )
		if IsValid( tp ) then
			tp:SetPos( pos )
			tp:SetAngles( Angle( 0, ang, 0 ) )
			tp:Spawn()

			tp:SetTriggerBounds( -scp106_bounds, scp106_bounds, 1 )

			tp.StartTouch = scp106_tp_func
		end
	end

	CatchInput( "gate_b_enter", function( ent, input, activator, caller, data )
		if input == "Lock" then return true end
	end )

	for _, zone in pairs( MAP_DOOR_PAIRS_TMP ) do
		for _, doors in pairs( zone ) do
			if #doors != 2 then continue end

			MAP_DOOR_PAIRS[doors[1]] = doors[2]
			MAP_DOOR_PAIRS[doors[2]] = doors[1]
		end
	end

	if !FRENCH_MAP_FIXED then
		fix_french_map()
	end

	for k, v in pairs( FRENCH_DOOR_SWAP ) do
		local k_lookup = door_lookup[k]
		if !k_lookup then continue end

		if v == false then
			MAP_DOOR_PAIRS[k_lookup] = nil
		else
			local v_lookup = door_lookup[v]
			if !v_lookup then continue end

			MAP_DOOR_PAIRS[k_lookup] = v_lookup
		end
	end
end )

hook.Add( "EntityKeyValue", "Site19EntityKeyValue", function( ent, key, value )
	if CLIENT then return end

	if CVAR.slc_door_unblocker:GetBool() then
		if !IsValid( LUA_ENT ) then
			LUA_ENT = ents.Create( "lua_run" )
			LUA_ENT:SetName( "door_unblocker" )
			LUA_ENT:SetDefaultCode( "hook.Run( 'SLCOnDoorClosed', true, 3 )" )
			LUA_ENT:Spawn()
		end

		local class = ent:GetClass()
		if class == "func_door" and key == "targetname" then
			if string.match( value, "^lcz_door_1_" ) or string.match( value, "^hcz_door_1_" ) or string.match( value, "^ez_door_1_" ) then
				ent:Fire( "AddOutput", "OnClose door_unblocker:RunPassedCode:hook.Run( 'SLCOnDoorClosed' ):0:-1" )
				ent.IsDoor = true
			elseif string.match( value, "elev_" ) and string.match( value, "_o" ) then
				ent:Fire( "AddOutput", "OnClose door_unblocker:RunCode::0:-1" )
				ent.IsElevatorDoor = true
			end
		end
	end
end )