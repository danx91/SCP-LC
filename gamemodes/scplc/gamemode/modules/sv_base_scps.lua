--[[-------------------------------------------------------------------------

								READ CAREFULLY!

Now to add SCP you have to call RegisterSCP() inside 'RegisterSCP' hook
Therefore if you only want to add SCPs, you don't have to reupload gamemode! Use hook instead and
place files in 'lua/autorun/server/'!


Basic infotmations about RegisterSCP():
	

	RegisterSCP( name, model, weapon, static_stats, dynamic_stats, callback, post_callback )


		name (String) - name of SCP, it will be used by most things. This function will automatically add
			all necessary variables so you no longer have to care about ROLES table(function will
			create ROLES.ROLE_name = name). Funtion will look for valid language and spawnpos entries
			(for language: english.ROLES.ROLE_name and english.starttexts.ROLE_name, for
			spawnpos: SPAWN_name = Vector or Table of vectors). Function will throw error if something
			is wrong(See errors section below)


		model (String) - full path to model. If you put wrong path you will see error instead of model!


		weapon (String) - SWEP class name. If you put wrong name your scp will not receive weapon and you
			will see red error in console


		static_stats (Table) - this table contain important entries for your SCP. Things specified inside
			this table are more important than dynamic_stats, so this will overwrite them. These stats cannot
			be changed in 'scp.txt' file. This table cotains keys and values (key = "value"). List of valid keys is below.


		dynamic_stats (Table) - this table contains entries for your SCP that can be accessed and changed in
			'garrysmod/data/slc/scp_override.txt' file. So everybody can customize them. These stats will be overwritten
			by statc_stats. This table cotains keys and values (key = "value") or tables that contains value and
			clamping info (num values only!) (key = "value" or key = { var = num_value, max = max_value, min = minimum_value }).
			List of valid keys is below. 

					Valid entreis for static_stats and dynamic_stats:
							base_speed - walk speed
							run_speed - run speed
							max_speed - maximum speed
							base_health - starting health
							max_health - maximum health
							jump_power - jump power
							crouch_speed - crouched walk speed
							no_ragdoll - if true, rgdoll will not be created
							model_scale - scale of model
							hands_model - model of hands
							prep_freeze - if true, SCP will not be able to move during preparing
							no_spawn - position will not be changed
							no_model - model will not be changed
							no_swep - SCP won't have SWEP
							no_strip - player EQ won't be stripped
							no_select - SCP won't appear in game


		callback (Function) - called on beginning of SetupPlayer, return true to override default actions (post callback will not be called).
			function( ply, basestats, ... )
				ply - player
				basestats - result of static_stats and dynamic_stats
				... - (varargs) passsed from SetupPlayer
		

		post_callback (Function) - called on end of SetupPlayer. Only player is passed as argument:
			function( ply, ... )
				ply - player
				... - (varargs) passsed from SetupPlayer


To get registered SCP:
		GetSCP( name ) - global function that returns SCP object
			arguments:
				name - name of SCP(same as used in RegisterSCP)

			return:
				ObjectSCP - (explained below)

	ObjectSCP:
		functions:
			ObjectSCP:SetCallback( callback, post ) - used internally by RegisterSCP. Sets callback, if post == true, sets post_callback

			ObjectSCP:SetupPlayer( ply, instant, ... ) - use to set specified player as SCP.
					ply - player who will become SCP
					instant - 
					... - varargs passed to callback if ObjectSCP has one

---------------------------------------------------------------------------]]

hook.Add( "RegisterSCP", "RegisterBaseSCPs", function()
	RegisterSCP( "SCP023", "models/Novux/023/Novux_SCP-023.mdl", "weapon_scp_023", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2150,
		max_health = 2150,
		base_speed = 185,
		run_speed = 185,
	}, nil, function( ply )
		ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
		ply:SetCustomCollisionCheck( true )
	end )

	RegisterSCP( "SCP049", "models/vinrax/player/scp049_player.mdl", "weapon_scp_049", {
		jump_power = 200,
		allow_chat = true,
		can_interact = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 185,
		run_speed = 185,
	} )

	RegisterSCP( "SCP0492", "models/player/zombie_classic.mdl", "weapon_scp_0492", {
		jump_power = 200,
		//no_spawn = true,
		dynamic_spawn = true,
		no_select = true,
		//no_model = true,
		no_terror = true,
		reward_override = 3,
	}, {
		base_health = 800,
		max_health = 800,
		base_speed = 165,
		run_speed = 165,
	}, function( ply, basestats, pos, scp049, hp, speed, damage, ls, model, skin )
		if hp and speed and damage then --TODO remove check?
			basestats.base_health = math.floor( basestats.base_health * hp )
			basestats.max_health = math.floor( basestats.max_health * hp )

			basestats.base_speed = math.floor( basestats.base_speed * speed )
			basestats.run_speed = math.floor( basestats.run_speed * speed )
		end
	end, function( ply, pos, scp049, hp, speed, damage, ls, model, skin )
		local wep = ply:GetWeapon( "weapon_scp_0492" )
		if IsValid( wep ) then
			wep.DamageMult = damage
			wep.LifeSteal = ls
			wep:SetSCP049( scp049 )
		end

		if model then
			ply:SetModel( model )
		end

		if skin then
			ply:SetSkin( skin )
		end

		CheckRoundEnd()
	end )

	RegisterSCP( "SCP066", "models/player/mrsilver/scp_066pm/scp_066_pm.mdl", "weapon_scp_066", {
		jump_power = 200,
		no_ragdoll = true,
		prep_freeze = true,
	}, {
		base_health = 3500,
		max_health = 3500,
		base_speed = 160,
		run_speed = 160,
	} )

	RegisterSCP( "SCP096", "models/shaklin/scp/096/scp_096.mdl", "weapon_scp_096", {
		jump_power = 200,
		no_terror = true,
		no_damage_forces = true,
	}, {
		base_health = 3000,
		max_health = 3000,
		base_speed = 125,
		run_speed = 125,
	} )

	RegisterSCP( "SCP106", "models/scp/106/unity/unity_scp_106_player.mdl", "weapon_scp_106", {
		jump_power = 200,
		no_damage_forces = true,
	}, {
		base_health = 2450,
		max_health = 2450,
		base_speed = 155,
		run_speed = 155,
	}, nil, function( ply )
		ply:SetCustomCollisionCheck( true )
	end )

	RegisterSCP( "SCP173", "models/jqueary/scp/unity/scp173/scp173unity.mdl", "weapon_scp_173", {
		jump_power = 200,
		no_ragdoll = true,
		no_damage_forces = true,
	}, {
		base_health = 6000,
		max_health = 6000,
		base_speed = 550,
		run_speed = 550,
	} )

	RegisterSCP( "SCP457", "models/player/corpse1.mdl", "weapon_scp_457", {
		jump_power = 200,
		no_ragdoll = true,
		//no_draw = true,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 165,
		run_speed = 165,
	} )

	RegisterSCP( "SCP682", "models/scp_682/scp_682.mdl", "weapon_scp_682", {
		jump_power = 200,
		no_ragdoll = true,
		no_damage_forces = true,
	}, {
		base_health = 7000,
		max_health = 7000,
		base_speed = 160,
		run_speed = 160,
	} )

	RegisterSCP( "SCP8602", "models/props/forest_monster/forest_monster2.mdl", "weapon_scp_8602", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 4200,
		max_health = 4200,
		base_speed = 170,
		run_speed = 170,
	} )

	RegisterSCP( "SCP939", "models/scp/939/unity/unity_scp_939.mdl", "weapon_scp_939", {
		jump_power = 200,
		prep_freeze = true,
		allow_chat = true,
		no_damage_forces = true,
	}, {
		base_health = 2600,
		max_health = 2600,
		base_speed = 175,
		run_speed = 175,
	} )

	RegisterSCP( "SCP966", "models/player/mishka/966_new.mdl", "weapon_scp_966", {
		jump_power = 200,
	}, {
		base_health = 1250,
		max_health = 1250,
		base_speed = 190,
		run_speed = 190,
	} )

	RegisterSCP( "SCP24273", "models/player/alski/scp2427-3.mdl", "weapon_scp_24273", {
		jump_power = 200,
		prep_freeze = true,
		no_ragdoll = true,
	}, {
		base_health = 3100,
		max_health = 3100,
		base_speed = 160,
		run_speed = 160,
	} )

	RegisterSCP( "SCP3199", "models/player/alski/scp3199/scp3199.mdl", "weapon_scp_3199", {
		jump_power = 200,
		prep_freeze = true
	}, {
		base_health = 1800,
		max_health = 1800,
		base_speed = 225,
		run_speed = 225,
	}, nil, function( ply )
		SpawnSCP3199Eggs()
	end )
end )