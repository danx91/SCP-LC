function Setup106Collision( ent )
	if !IsValid( ent ) then return end

	local class = ent:GetClass()
	if class != "func_door" and class != "func_door_rotating" and class != "prop_dynamic" then return end

	if class == "prop_dynamic" then
		local ennt = ents.FindInSphere( ent:GetPos(), 50 )
		local neardors = false

		for k, v in pairs( ennt ) do
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

hook.Add( "SLCPreround", "Site19Preround", function()
	for k, v in pairs( ents.GetAll() ) do
		local name = v:GetName()
		//local class = v:GetClass()

		if name == "049_hall_button" then
			v:Fire( "Unlock" )
		elseif name == "966_door" then
			v:SetKeyValue( "forceclosed", "1" )
		elseif name == "049_door" then
			v:SetKeyValue( "forceclosed", "1" )
		elseif name == "4016" then
			v:Remove()
		end
		
		/*local class = v:GetClass()
		if class == "func_door" then
			print( "set for", v, name )
			v:SetCollisionGroup( COLLISION_GROUP_PLAYER )
			v:SetKeyValue( "dmg", 0 )
		end*/

		local pos = v:GetPos()
		if pos == Vector( 3972.00, 264.00, -330.00 ) then
			local btn = ents.Create( "slc_button" )
			if IsValid( btn ) then
				btn:SetName( "warhead_lever_alpha" )
				btn:Tie( v, 1, 1, Angle( 0, 0, 0 ), Angle( -180, 0, 0 ), true )
				btn:SetSound( "Buttons.snd21" )
				btn:Spawn()
			end
		elseif pos == Vector( 3972.00, 306.00, -330.00 ) then
			local btn = ents.Create( "slc_button" )
			if IsValid( btn ) then
				btn:SetName( "warhead_lever_omega" )
				btn:Tie( v, 1, 1, Angle( 0, 0, 0 ), Angle( -180, 0, 0 ), true )
				btn:SetSound( "Buttons.snd21" )
				btn:Spawn()
			end
		elseif pos == Vector( 228.00, -1388.00, -78.00 ) then
			v:SetName( "shelter_door_l" )
		elseif pos == Vector( 156.00, -1388.00, -78.00 ) then
			v:SetName( "shelter_door_r" )
		end
	end
end )

//STORED_DOORS = STORED_DOORS or {}
hook.Add( "EntityKeyValue", "Site19EntityKeyValue", function( ent, key, value )
	if CLIENT then return end

	if CVAR.slc_enable_door_unblocker:GetBool() then
		if !IsValid( LUA_ENT ) then
			LUA_ENT = ents.Create( "lua_run" )
			LUA_ENT:SetName( "door_unblocker" )
			LUA_ENT:Spawn()
		end

		local class = ent:GetClass()
		if class == "func_door" and key == "targetname" then
			if string.match( value, "^lcz_door_" ) or string.match( value, "^hcz_door_" ) or string.match( value, "^ez_door_" ) then
				//STORED_DOORS[ent] = true

				--if unblocker then
					ent:Fire( "AddOutput", "OnClose door_unblocker:RunPassedCode:hook.Run( 'SLCOnDoorClosed' ):0:-1" )
				--end
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

if SERVER then
	hook.Add( "PostCleanupMap", "SCP106Collision", function()
		for k, v in pairs( ents.GetAll() ) do
			Setup106Collision( v )
		end
	end )
end

//hook.Add( "AcceptInput", "Site19ChangeDoors", function( ent, input, activator, caller, value )
	//if ent:GetClass() == "func_button" then
		//print( ent, input, activator, caller, value, ent:GetName() )
		//PrintTable( ent:GetKeyValues() )
	//end
//end )