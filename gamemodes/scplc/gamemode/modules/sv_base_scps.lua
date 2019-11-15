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


		weapon (String) - SWEP call name. If you put wrong name your scp will not receive weapon and you
			will see red error in console


		static_stats (Table) - this table contain important entries for your SCP. Things specified inside
			this table are more important than dynamic_stats, so this will overwrite them. These stats cannot
			be changed in 'scp.txt' file. This table cotains keys and values (key = "value"). List of valid keys is below.


		dynamic_stats (Table) - this table contains entries for your SCP that can be accessed and changed in
			'garrysmod/data/breach/scp.txt' file. So everybody can customize them. These stats will be overwritten
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
							no_ragdoll - if true, rgdoll will not appear
							model_scale - scale of model
							hands_model - model of hands
							prep_freeze - if true, SCP will not be able to move during preparing
							no_spawn - position will not be changed
							no_model - model will not be changed
							no_swep - SCP won't have SWEP
							no_strip - player EQ won't be stripped
							no_select - SCP won't appear in game


		callback (Function) - called on beginning of SetupPlayer, return true to override default actions (post callback will not be called).
			function( ply, basestats, ... ) - 3 arguments are passed:
				ply - player
				basestats - result of static_stats and dynamic_stats
				... - (varargs) passsed from SetupPlayer
		

		post_callback (Function) - called on end of SetupPlayer. Only player is passed as argument:
			function( ply )
				ply - player


To get registered SCP:
		GetSCP( name ) - global function that returns SCP object
			arguments:
				name - name of SCP(same as used in RegisterSCP)

			return:
				ObjectSCP - (explained below)

	ObjectSCP:
		functions:
			ObjectSCP:SetCallback( callback, post ) - used internally by RegisterSCP. Sets callback, if post == true, sets post_callback

			ObjectSCP:SetupPlayer( ply, ... ) - use to set specified player as SCP.
					ply - player who will become SCP
					... - varargs passed to callback if ObjectSCP has one

---------------------------------------------------------------------------]]

hook.Add( "RegisterSCP", "RegisterBaseSCPs", function()
	/*RegisterSCP( "SCPSantaJ", "models/player/christmas/santa.mdl", "weapon_scp_santaJ", {
		jump_power = 200,
		prep_freeze = true,
		no_ragdoll = true,
	}, {
		base_health = 2500,
		max_health = 2500,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	} )*/

	/*RegisterSCP( "SCP023", "models/Novux/023/Novux_SCP-023.mdl", "weapon_scp_023", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 250,
		run_speed = 250,
	} )*/

	/*RegisterSCP( "SCP049", "models/vinrax/player/scp049_player.mdl", "weapon_scp_049", {
		jump_power = 200,
	}, {
		base_health = 1600,
		max_health = 1600,
		base_speed = 135,
		run_speed = 135,
		allow_chat = true
	} )*/

	/*RegisterSCP( "SCP0492", "models/player/zombie_classic.mdl", "weapon_br_zombie", {
		jump_power = 200,
		no_spawn = true,
		no_select = true,
	}, {
		base_health = 750,
		max_health = 750,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
		WinCheck()
	end )*/

	RegisterSCP( "SCP066", "models/player/mrsilver/scp_066pm/scp_066_pm.mdl", "weapon_scp_066", {
		jump_power = 200,
		no_ragdoll = true,
		prep_freeze = true,
	}, {
		base_health = 2250,
		max_health = 2250,
		base_speed = 165,
		run_speed = 165,
	} )

	/*RegisterSCP( "SCP076", "models/abel/abel.mdl", "weapon_scp_076", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 300,
		max_health = 300,
		base_speed = 220,
		run_speed = 220,
		max_speed = 220,
	}, nil, function( ply )
		SetupSCP0761( ply )
	end )

	RegisterSCP( "SCP082", "models/models/konnie/savini/savini.mdl", "weapon_scp_082", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2300,
		max_health = 2800,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
		ply:SetBodygroup( ply:FindBodygroupByName( "Mask" ), 1 )
	end )

	RegisterSCP( "SCP096", "models/scp096anim/player/scp096pm_raf.mdl", "weapon_scp_096", {
		jump_power = 200,
	}, {
		base_health = 1750,
		max_health = 1750,
		base_speed = 120,
		run_speed = 500,
		max_speed = 500,
	} )*/

	RegisterSCP( "SCP106", "models/scp/106/unity/unity_scp_106_player.mdl", "weapon_scp_106", {
		jump_power = 200,
	}, {
		base_health = 2250,
		max_health = 2250,
		base_speed = 160,
		run_speed = 160,
	}, nil, function( ply )
		ply:SetCustomCollisionCheck( true )
	end )

	RegisterSCP( "SCP173", "models/jqueary/scp/unity/scp173/scp173unity.mdl", "weapon_scp_173", {
		jump_power = 200,
		no_ragdoll = true,
		no_damage_forces = true,
	}, {
		base_health = 5000,
		max_health = 5000,
		base_speed = 550,
		run_speed = 550,
	} )

	RegisterSCP( "SCP457", "models/player/corpse1.mdl", "weapon_scp_457", {
		jump_power = 200,
		no_draw = true,
	}, {
		base_health = 2500,
		max_health = 2500,
		base_speed = 155,
		run_speed = 155,
	} )

	RegisterSCP( "SCP682", "models/scp_682/scp_682.mdl", "weapon_scp_682", {
		jump_power = 200,
		no_ragdoll = true,
		no_damage_forces = true,
	}, {
		base_health = 9000,
		max_health = 9000,
		base_speed = 150,
		run_speed = 150,
	} )

	/*RegisterSCP( "SCP689", "models/dwdarksouls/models/darkwraith.mdl", "weapon_scp_689", {
		jump_power = 200,
	}, {
		base_health = 1750,
		max_health = 1750,
		base_speed = 100,
		run_speed = 100,
		max_speed = 100,
	} )*/

	RegisterSCP( "SCP8602", "models/props/forest_monster/forest_monster2.mdl", "weapon_scp_8602", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2250,
		max_health = 2250,
		base_speed = 195,
		run_speed = 195,
	} )

	RegisterSCP( "SCP939", "models/scp/939/unity/unity_scp_939.mdl", "weapon_scp_939", {
		jump_power = 200,
		prep_freeze = true,
		allow_chat = true,
		no_damage_forces = true,
	}, {
		base_health = 2175,
		max_health = 2175,
		base_speed = 210,
		run_speed = 210,
	} )

	/*RegisterSCP( "SCP957", "models/immigrant/outlast/walrider_pm.mdl", "weapon_scp_957", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 1500,
		max_health = 1500,
		base_speed = 175,
		run_speed = 175,
		max_speed = 175,
	} )

	RegisterSCP( "SCP9571", "", "", {
		no_spawn = true,
		no_select = true,
	}, {
		base_health = 500,
		max_health = 500,
	}, function( ply, basestats )
		if !ply.SetLastRole or !ply.SetLastTeam then
			player_manager.RunClass( ply, "SetupDataTables" )
		end

		ply:SetHealth( basestats.base_health or 500 )
		ply:SetMaxHealth( basestats.max_health or 500 )

		ply:SetLastRole( ply:GetNClass() )
		ply:SetLastTeam( ply:GTeam() )
		ply:SetGTeam( TEAM_SCP )
		ply:SetNClass( ROLES.ROLE_SCP9571 )
		ply.canblink = false

		net.Start( "RolesSelected" )
		net.Send( ply )

		return true
	end )*/

	RegisterSCP( "SCP966", "models/player/mishka/966_new.mdl", "weapon_scp_966", {
		jump_power = 200,
	}, {
		base_health = 1300,
		max_health = 1300,
		base_speed = 180,
		run_speed = 180,
	} )

	/*RegisterSCP( "SCP999", "models/scp/999/jq/scp_999_pmjq.mdl", "weapon_scp_999", {
		jump_power = 200,
	}, {
		base_health = 1000,
		max_health = 1000,
		base_speed = 150,
		run_speed = 150,
		max_speed = 150,
	} )

	RegisterSCP( "SCP1048A", "models/1048/tdyear/tdybrownearpm.mdl", "weapon_scp_1048A", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 1500,
		max_health = 1500,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP1048B", "models/player/teddy_bear/teddy_bear.mdl", "weapon_scp_1048B", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 165,
		run_speed = 165,
		max_speed = 165,
	} )

	RegisterSCP( "SCP1471", "models/burd/scp1471/scp1471.mdl", "weapon_scp_1471", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 3000,
		max_health = 3000,
		base_speed = 160,
		run_speed = 325,
		max_speed = 160,
	} )*/
end )

function SetupSCP0761( ply )
	if !IsValid( SCP0761 ) then
		cspawn076 = table.Random( SPAWN_SCP076 )
		SCP0761 = ents.Create( "item_scp_0761" )
		SCP0761:Spawn()
		SCP0761:SetPos( cspawn076 )
	end
	ply:SetPos( cspawn076 )
end