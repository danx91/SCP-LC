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
					instant - spawn player instantly skipping info screen
					... - varargs passed to callback if ObjectSCP has one

---------------------------------------------------------------------------]]

--BASE_SCP_SPEED = 175 ~ 77.7% BASE_RUN_SPEED
hook.Add( "RegisterSCP", "RegisterBaseSCPs", function()
	RegisterSCP( "SCP023", "models/Novux/023/Novux_SCP-023.mdl", "weapon_scp_023", {
		jump_power = 200,
		prep_freeze = true,
		no_chase = true,
	}, {
		base_health = 2550,
		max_health = 2550,
		base_speed = 180,
		buff_scale = 0.9,
	}, nil, function( ply )
		ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
		ply:SetCustomCollisionCheck( true )
	end )

	RegisterSCP( "SCP049", "models/vinrax/player/scp049_player.mdl", "weapon_scp_049", {
		jump_power = 200,
		allow_chat = true,
		can_interact = true,
		no_chase = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 180,
		buff_scale = 0.9,
	} )

	RegisterSCP( "SCP0492", "models/player/zombie_classic.mdl", "weapon_scp_0492", {
		jump_power = 200,
		dynamic_spawn = true,
		no_select = true,
		no_chase = true,
		reward_override = 3,
	}, {
		base_health = 400,
		max_health = 400,
		base_speed = 165,
	}, function( ply, basestats, pos, scp049, zombie_type, hp, speed, dmg, ls, model, skin )
		basestats.base_health = math.Round( basestats.base_health * hp )
		basestats.max_health = math.Round( basestats.max_health * hp )
		basestats.base_speed = math.Round( basestats.base_speed * speed )
	end, function( ply, pos, scp049, zombie_type, hp, speed, dmg, ls, model, skin )
		local wep = ply:GetSCPWeapon()
		if IsValid( wep ) then
			wep:SetSCP049( scp049 )
			wep:SetZombieType( zombie_type )
			wep.DamageMultiplier = dmg or 1
			wep.LifeSteal = ls or 0
		end

		if model then
			ply:SetModel( model )
		end

		if skin then
			ply:SetSkin( skin )
		end
	end )

	RegisterSCP( "SCP058", "models/player/alski/scp/scp_058.mdl", "weapon_scp_058", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2900,
		max_health = 2900,
		base_speed = 175,
	} )

	//RegisterSCP( "SCP066", "models/player/mrsilver/scp_066pm/scp_066_pm.mdl", "weapon_scp_066", {
	RegisterSCP( "SCP066", "models/cpthazama/scp/066.mdl", "weapon_scp_066", {
		jump_power = 200,
		no_ragdoll = true,
		prep_freeze = true,
		no_chase = true,
	}, {
		base_health = 2600,
		max_health = 2600,
		base_speed = 165,
		buff_scale = 0.85,
	} )

	RegisterSCP( "SCP096", "models/shaklin/scp/096/scp_096.mdl", "weapon_scp_096", {
		jump_power = 200,
		no_damage_forces = true,
		no_chase = true,
		avoid = { "SCP173" },
	}, {
		base_health = 1900,
		max_health = 1900,
		base_speed = 125,
		buff_scale = 0.5,
	} )

	RegisterSCP( "SCP106", "models/danx91/scp/scp_106.mdl", "weapon_scp_106", {
		jump_power = 200,
		no_damage_forces = true,
	}, {
		base_health = 1000,
		max_health = 1000,
		base_speed = 150,
		buff_scale = 0.1,
	}, nil, function( ply )
		ply:SetCustomCollisionCheck( true )
	end )

	RegisterSCP( "SCP173", "models/scp/173.mdl", "weapon_scp_173", {
		jump_power = 200,
		no_damage_forces = true,
		no_chase = true,
		avoid = { "SCP096" },
	}, {
		base_health = 4000,
		max_health = 4000,
		base_speed = 500,
	} )

	RegisterSCP( "SCP457", "models/cultist/scp/scp_457.mdl", "weapon_scp_457", {
		jump_power = 200,
		no_ragdoll = true,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 165,
		buff_scale = 0.75,
	} )

	RegisterSCP( "SCP682", "models/danx91/scp/scp_682.mdl", "weapon_scp_682", {
		jump_power = 200,
		no_damage_forces = true,
	}, {
		base_health = 2900,
		max_health = 2900,
		base_speed = 160,
	} )

	RegisterSCP( "SCP8602", "models/props/forest_monster/forest_monster2.mdl", "weapon_scp_8602", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 4400,
		max_health = 4400,
		base_speed = 170,
	} )

	RegisterSCP( "SCP939", "models/scp/939/unity/unity_scp_939.mdl", "weapon_scp_939", {
		jump_power = 200,
		prep_freeze = true,
		allow_chat = true,
		no_damage_forces = true,
	}, {
		base_health = 3100,
		max_health = 3100,
		base_speed = 175,
	} )

	RegisterSCP( "SCP966", "models/player/mishka/966_new.mdl", "weapon_scp_966", {
		jump_power = 200,
		no_chase = true,
	}, {
		base_health = 1750,
		max_health = 1750,
		base_speed = 190,
		buff_scale = 0.75,
	} )

	RegisterSCP( "SCP24273", "models/player/alski/scp2427-3.mdl", "weapon_scp_24273", {
		jump_power = 200,
		prep_freeze = true,
		no_ragdoll = true,
	}, {
		base_health = 3000,
		max_health = 3000,
		base_speed = 160,
	} )

	RegisterSCP( "SCP3199", "models/player/alski/scp3199/scp3199.mdl", "weapon_scp_3199", {
		jump_power = 200,
		prep_freeze = true
	}, {
		base_health = 1450,
		max_health = 1450,
		base_speed = 215,
		buff_scale = 0.85,
	} )
end )