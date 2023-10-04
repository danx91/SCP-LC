function Setup106Collision( ent )
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
		local tab = GetGasPower( ZONE_HCZ ) == 0 and pos_106tp_hcz or GetGasPower( ZONE_EZ ) == 0 and pos_106tp_ez or pos_106tp_surf
		ent:SetPos( tab[math.random( #tab )] )
	else
		ent:SetPos( pos_106tp_pd[math.random( #pos_106tp_pd )] )
		TransmitSound( "#scp_lc/scp/106/laugh.ogg", true, ent, 1 )
	end
end

hook.Add( "SLCPreround", "Site19Preround", function()
	for i, v in ipairs( ents.GetAll() ) do
		local name = v:GetName()
		local class = v:GetClass()
		local mapid = v:MapCreationID()

		Setup106Collision( v )

		if name == "049_hall_button" then
			v:Fire( "Unlock" )
		elseif name == "966_door" then
			v:SetKeyValue( "forceclosed", "1" )
		elseif name == "049_door" then
			v:SetKeyValue( "forceclosed", "1" )
		elseif name == "4016" then
			v:Remove()
		elseif mapid == 3097 or mapid == 3096 then
			v:Remove()
		elseif mapid == 3240 then
			v:Fire( "Unlock" )
		end
		
		if class == "func_door" and string.match( name, "^elve_" ) then
			v:SetKeyValue( "dmg", 0 )
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

if CLIENT then
	hook.Add( "OnEntityCreated", "SCP106Collision", function( ent )
		timer.Simple( 0, function()
			Setup106Collision( ent )
		end )
	end )
end