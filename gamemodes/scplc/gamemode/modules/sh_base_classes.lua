CLASSD_MODELS = {
	"models/player/kerry/class_d_1.mdl",
	"models/player/kerry/class_d_2.mdl",
	"models/player/kerry/class_d_3.mdl",
	"models/player/kerry/class_d_4.mdl",
	"models/player/kerry/class_d_5.mdl",
	"models/player/kerry/class_d_6.mdl",
	"models/player/kerry/class_d_7.mdl",
}

VETERAND_MODELS = {
	"models/player/kerry/class_jan_2.mdl",
	"models/player/kerry/class_jan_3.mdl",
	"models/player/kerry/class_jan_4.mdl",
	"models/player/kerry/class_jan_5.mdl",
	"models/player/kerry/class_jan_6.mdl",
	"models/player/kerry/class_jan_7.mdl",
}

SCI_MODELS = {
	"models/scp/apsci_cohrt.mdl",
	"models/scp/apsci_male_02.mdl",
	"models/scp/apsci_male_03.mdl",
	"models/scp/apsci_male_05.mdl",
	"models/scp/apsci_male_07.mdl",
	"models/scp/apsci_male_08.mdl",
	"models/scp/apsci_male_09.mdl",
	"models/player/kerry/Class_scientist_1.mdl",
	"models/player/kerry/Class_scientist_2.mdl",
	"models/player/kerry/Class_scientist_3.mdl",
	"models/player/kerry/Class_scientist_4.mdl",
	"models/player/kerry/Class_scientist_5.mdl",
	"models/player/kerry/Class_scientist_6.mdl",
	"models/player/kerry/Class_scientist_7.mdl",
}

SCI_MODELS_2 = {
	"models/1000shells/sci/scientists_1.mdl",
	"models/1000shells/sci/scientists_2.mdl",
	"models/1000shells/sci/scientists_3.mdl",
	"models/1000shells/sci/scientists_4.mdl",
	"models/1000shells/sci/scientists_5.mdl",
	"models/1000shells/sci/scientists_6.mdl",
	"models/1000shells/sci/scientists_7.mdl",
	"models/1000shells/sci/scientists_8.mdl",
	"models/1000shells/sci/scientists_9.mdl",
}

GUARD_MODELS = {
	"models/player/alski/security.mdl",
	"models/player/alski/security2.mdl",
	"models/player/alski/security3.mdl",
	"models/player/alski/security4.mdl",
	"models/player/alski/security5.mdl",
	"models/player/alski/security6.mdl",
	"models/player/alski/security7.mdl",
	"models/player/alski/security8.mdl",
	"models/player/alski/security9.mdl",
}

MTF_MODELS = {
	"models/npc/portal/male_02_garde.mdl",
	"models/npc/portal/male_04_garde.mdl",
	"models/npc/portal/male_05_garde.mdl",
	"models/npc/portal/male_06_garde.mdl",
	"models/npc/portal/male_07_garde.mdl",
	"models/npc/portal/male_08_garde.mdl",
	"models/npc/portal/male_09_garde.mdl",
}

CI_MODELS = {
	"models/player/1000shells/unit_1_ci.mdl",
	"models/player/1000shells/unit_2_ci.mdl",
	"models/player/1000shells/unit_3_ci.mdl",
	"models/player/1000shells/unit_4_ci.mdl",
	"models/player/1000shells/unit_5_ci.mdl",
	"models/player/1000shells/unit_6_ci.mdl",
	"models/player/1000shells/unit_7_ci.mdl",
	"models/player/1000shells/unit_8_ci.mdl",
}

hook.Add( "SLCRegisterClassGroups", "BaseGroups", function()
	AddClassGroup( "classd", 49, SPAWN_CLASSD )
	AddClassGroup( "sci", 21, SPAWN_SCIENT )
	AddClassGroup( "guard", 30, SPAWN_GUARD or SPAWN_MTF )

	AddSupportGroup( "mtf_ntf", 60, SPAWN_SUPPORT_MTF, -1, function()
		SetRoundProperty( "mtfs_spawned", true )

		local num = math.random( 3 )
		PlayPA( string.format( "scp_lc/announcements/ntf_entered%i.ogg", num ), num == 1 and 25 or 12 )
	end )

	//AddSupportGroup( "mtf_fire", 25, SPAWN_SUPPORT_MTF )

	AddSupportGroup( "mtf_alpha", 20, SPAWN_SUPPORT_MTF, function( max )
		return CVAR.slc_alpha1_amount:GetInt()
	end, function()
		SetRoundProperty( "mtfs_spawned", true )
		SetRoundProperty( "mtf_alpha_spawned", true )

		if GetRoundProperty( "goc_spawned" ) and !GetRoundProperty( "mtf_alpha_goc" ) then
			SetRoundProperty( "mtf_alpha_goc", true )
		end

		PlayPA( "scp_lc/announcements/alpha1_entered.ogg", 24 )
	end, function()
		if GetRoundProperty( "goc_spawned" ) and !GetRoundProperty( "mtf_alpha_goc" ) then return true, true end
		if GetRoundProperty( "mtf_alpha_spawned" ) then return false end

		local round = GetTimer( "SLCRound" )
		return !IsValid( round ) or round:GetRemainingTime() <= round:GetTime() / 2
	end )

	AddSupportGroup( "ci", 30, SPAWN_SUPPORT_CI )

	AddSupportGroup( "goc", 15, SPAWN_SUPPORT_GOC, -1, function()
		SetRoundProperty( "goc_spawned", true )

		if !GetRoundProperty( "goc_device" ) then
			local ent = ents.Create( "item_slc_goc_device" )
			if IsValid( ent ) then
				ent:SetPos( table.Random( GOC_DEVICE_SPAWN ) )
				ent:Spawn()
				ent.Dropped = 0

				SetRoundProperty( "goc_device", true )
			end
		end

		SetRoundProperty( "SupportTimerOverride", CVAR.slc_alpha1_time_goc:GetInt() )
	end, function()
		return GetRoundProperty( "mtfs_spawned" ) and !GetRoundProperty( "goc_spawned" ) and !GetRoundStat( "omega_warhead" )
	end )
end )

--BASE_WALK_SPEED = 100
--BASE_RUN_SPEED = 225 ~ 128.6% BASE_SCP_SPEED
hook.Add( "SLCRegisterPlayerClasses", "BaseClasses", function()
	--[[-------------------------------------------------------------------------
	CLASS D
	---------------------------------------------------------------------------]]
	RegisterClass( "classd", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 0,
		tier = 0,
	} )

	/*RegisterClass( "test1", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "",
		omnitool = false,
		health = 125,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 0,
		price = 1,
	} )*/

	RegisterClass( "veterand", "classd", VETERAND_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "jan",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = nil,
		max = 0,
		tier = 1,
	} )

	RegisterClass( "kleptod", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = { { "item_slc_radio", "item_slc_camera", "item_slc_nvg", "item_slc_medkit", "item_slc_flashlight", "item_slc_gasmask", amount = 2 }, "item_slc_battery" },
		ammo = {},
		chip = "",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 240,
		sanity = 70,
		vest = nil,
		max = 2,
		tier = 1,
	} )

	RegisterClass( "contrad", "classd", VETERAND_MODELS, {
		team = TEAM_CLASSD,
		weapons = { { "weapon_slc_glass_knife", "weapon_slc_pipe" } },
		ammo = {},
		chip = "jan",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 2,
		tier = 2,
	} )

	RegisterClass( "ciagent", "classd", CLASSD_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_taser" },
		ammo = {},
		chip = "jan",
		omnitool = true,
		health = 120,
		walk_speed = 110,
		run_speed = 235,
		sanity = 100,
		vest = nil,
		max = 1,
		tier = 2,
		persona = { team = TEAM_CLASSD, class = "classd" },
	} )

	RegisterClass( "expd", "classd", VETERAND_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 1,
		tier = 3,
		rng_effects = { "expd_rubber_bones", "expd_stamina_tweaks", "expd_revive" },
		callback = function( ply, this )
			ply:ApplyEffect( this.rng_effects[math.random( #this.rng_effects )] )
		end
	} )

	RegisterClass( "classd_prestige", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 3,
		tier = -1,
		weight = 4,
		holster_override = "item_slc_clothes_changer"
	} )

	--[[-------------------------------------------------------------------------
	SCI
	---------------------------------------------------------------------------]]
	RegisterClass( "sciassistant", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci1",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 50,
		vest = nil,
		max = 0,
		tier = 0,
	} )

	RegisterClass( "sci", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci2",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 0,
		tier = 1,
	} )

	RegisterClass( "seniorsci", "sci", SCI_MODELS_2, {
		team = TEAM_SCI,
		weapons = { { "weapon_slc_glass_knife", "weapon_slc_pipe" } },
		ammo = {},
		chip = "sci3",
		omnitool = true,
		health = 120,
		walk_speed = 105,
		run_speed = 235,
		sanity = 100,
		vest = nil,
		max = 1,
		tier = 2,
		bodygroups = { glasses = "?" },
	} )

	RegisterClass( "headsci", "sci", SCI_MODELS_2, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci3",
		omnitool = true,
		health = 140,
		walk_speed = 110,
		run_speed = 240,
		sanity = 125,
		vest = nil,
		max = 1,
		tier = 2,
		bodygroups = { glasses = "?" },
	} )

	RegisterClass( "contspec", "sci", SCI_MODELS_2, {
		team = TEAM_SCI,
		weapons = { { "item_slc_radio", "item_slc_camera", "item_slc_nvg", "item_slc_medkit", "item_slc_flashlight", "item_slc_gasmask" } },
		ammo = {},
		chip = "spec",
		omnitool = true,
		health = 140,
		walk_speed = 115,
		run_speed = 240,
		sanity = 150,
		vest = "hazmat",
		max = 1,
		tier = 3,
		bodygroups = { glasses = "?" },
	} )

	RegisterClass( "sci_prestige", "sci", SCI_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "sci2",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		max = 1,
		tier = -1,
		weight = 4,
		persona = { team = TEAM_SCI, class = "sci" },
	} )

	--[[-------------------------------------------------------------------------
	Guards
	---------------------------------------------------------------------------]]
	RegisterClass( "guard", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = "guard",
		max = 0,
		tier = 0,
		skin = 4,
	} )

	RegisterClass( "lightguard", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		loadout = "pistol_low",
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_flashlight", "item_slc_battery" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 105,
		run_speed = 240,
		sanity = 100,
		vest = nil,
		max = 0,
		tier = 1,
		skin = 4,
	} )

	RegisterClass( "heavyguard", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 125,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = "heavyguard",
		max = 0,
		tier = 1,
		skin = 4,
	} )

	RegisterClass( "chief", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "weapon_taser" },
		ammo = {},
		chip = "chief",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 120,
		vest = "guard",
		max = 1,
		tier = 2,
		skin = 2,
	} )

	RegisterClass( "specguard", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		loadout = "smg_low",
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_nvg", "item_slc_gasmask" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 120,
		vest = "specguard",
		max = 2,
		tier = 3,
		skin = 3,
		bodygroups = { nvg = 1 },
	} )

	RegisterClass( "guardmedic", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_medkitplus", "weapon_taser" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 110,
		run_speed = 250,
		sanity = 100,
		vest = "guard_medic",
		max = 2,
		tier = 2,
		skin = 1,
	} )

	RegisterClass( "tech", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "item_slc_turret" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		max = 1,
		tier = 3,
		skin = 3,
	} )

	RegisterClass( "cispy", "guard", GUARD_MODELS, {
		team = TEAM_CI,
		loadout = "guard",
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = "guard",
		max = 2,
		tier = 1,
		select_group = "cispy",
		persona = { team = TEAM_GUARD, class = "guard" },
		skin = 4,
		select_override = function( cur, total )
			return cur < math.floor( total / 2 )
		end,
	} )

	RegisterClass( "lightcispy", "guard", GUARD_MODELS, {
		team = TEAM_CI,
		loadout = "pistol_low",
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_flashlight", "item_slc_battery" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 105,
		run_speed = 240,
		sanity = 100,
		vest = nil,
		max = 2,
		tier = 2,
		weight = 1,
		select_group = "cispy",
		persona = { team = TEAM_GUARD, class = "lightguard" },
		skin = 4,
		select_override = function( cur, total )
			return cur < math.floor( total / 2 )
		end,
	} )

	RegisterClass( "heavycispy", "guard", GUARD_MODELS, {
		team = TEAM_CI,
		loadout = "heavyguard",
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 125,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = "heavyguard",
		max = 2,
		tier = 2,
		weight = 1,
		select_group = "cispy",
		persona = { team = TEAM_GUARD, class = "heavyguard" },
		skin = 4,
		select_override = function( cur, total )
			return cur < math.floor( total / 2 )
		end,
	} )

	RegisterClass( "guard_prestige", "guard", GUARD_MODELS, {
		team = TEAM_GUARD,
		loadout = "tech",
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_fuse", "item_slc_door_blocker" },
		ammo = {},
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		max = 1,
		tier = -1,
		skin = 3,
		weight = 4,
		callback = function( ply, this )
			local fuse = ply:GetWeapon( "item_slc_fuse" )
			if !IsValid( fuse ) then return end

			fuse:SetRating( math.random( 3, 15 ) )
		end
	} )

	--[[-------------------------------------------------------------------------
	SUPPORT
	---------------------------------------------------------------------------]]
	--NTF
	RegisterSupportClass( "ntf_1", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		loadout = "smg_mid",
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_gasmask", "item_slc_thermal" },
		ammo = {},
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 105,
		run_speed = 240,
		sanity = 125,
		vest = "ntf",
		max = 0,
		tier = 0,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "ntf_2", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		loadout = "shotgun_mid",
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_gasmask", "item_slc_thermal" },
		ammo = {},
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 105,
		run_speed = 240,
		sanity = 125,
		vest = "ntf",
		max = 0,
		tier = 0,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "ntf_3", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_gasmask", "item_slc_thermal" },
		ammo = {},
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 105,
		run_speed = 240,
		sanity = 125,
		vest = "ntf",
		max = 0,
		tier = 1,
		weight = 1,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "ntfmedic", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_gasmask", "item_slc_thermal", "item_slc_medkitplus", { "item_slc_morphine", "item_slc_adrenaline" } },
		ammo = {},
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 110,
		run_speed = 250,
		sanity = 125,
		vest = "mtf_medic",
		max = 1,
		tier = 2,
		backpack = "medium",
		spawn_protection = true,
	} )

	RegisterSupportClass( "ntfcom", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_commander_tablet", "item_slc_radio", "item_slc_camera", "item_slc_gasmask", "item_slc_thermal" },
		ammo = {},
		chip = "com",
		omnitool = true,
		health = 115,
		walk_speed = 120,
		run_speed = 250,
		sanity = 150,
		vest = "ntfcom",
		max = 1,
		tier = 3,
		backpack = "large",
		spawn_protection = true,
	} )

	RegisterSupportClass( "ntfsniper", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_gasmask" },
		ammo = {},
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 125,
		vest = "ntf",
		max = 1,
		tier = 2,
		backpack = "small",
		spawn_protection = true,
	} )

	--Alpha-1
	RegisterSupportClass( "alpha1", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_heavymask", "item_slc_thermal", "loadout:grenade" },
		ammo = {},
		chip = "o5",
		omnitool = true,
		health = 150,
		walk_speed = 120,
		run_speed = 260,
		sanity = 175,
		vest = "alpha1",
		max = 0,
		tier = 2,
		backpack = "medium",
		spawn_protection = true,
	} )

	RegisterSupportClass( "alpha1sniper", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_heavymask", "item_slc_thermal", "cw_smoke_grenade" },
		ammo = {},
		chip = "o5",
		omnitool = true,
		health = 125,
		walk_speed = 110,
		run_speed = 250,
		sanity = 175,
		vest = "alpha1",
		max = 1,
		tier = 3,
		weight = 3,
		backpack = "medium",
		spawn_protection = true,
	} )

	RegisterSupportClass( "alpha1medic", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		loadout = "smg_high",
		weapons = { "item_slc_radio", "item_slc_camera", "item_slc_heavymask", "item_slc_thermal", { "item_slc_morphine", "item_slc_adrenaline" }, "item_slc_medkitplus" },
		ammo = {},
		chip = "o5",
		omnitool = true,
		health = 150,
		walk_speed = 120,
		run_speed = 265,
		sanity = 175,
		vest = "alpha1",
		max = 1,
		tier = 3,
		backpack = "medium",
		spawn_protection = true,
	} )

	RegisterSupportClass( "alpha1com", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "item_slc_commander_tablet", "item_slc_radio", "item_slc_camera", "item_slc_heavymask", "item_slc_thermal", "cw_frag_grenade" },
		ammo = { cw_frag_grenade = 3 },
		chip = "o5",
		omnitool = true,
		health = 160,
		walk_speed = 125,
		run_speed = 270,
		sanity = 175,
		vest = "alpha1",
		max = 1,
		tier = 4,
		weight = 4,
		backpack = "large",
		spawn_protection = true,
	} )

	--CI
	RegisterSupportClass( "ci", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_gasmask", "item_slc_nvg", "cw_flash_grenade",  },
		ammo = {},
		chip = "hacked4",
		omnitool = true,
		health = 110,
		walk_speed = 110,
		run_speed = 240,
		sanity = 125,
		vest = "ci",
		max = 0,
		tier = 1,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "cisniper", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_gasmask", "item_slc_nvg" },
		ammo = {},
		chip = "hacked4",
		omnitool = true,
		health = 100,
		walk_speed = 110,
		run_speed = 240,
		sanity = 115,
		vest = "ci",
		max = 1,
		tier = 2,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "cicom", "ci", "models/player/1000shells/captan_ci.mdl", {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_gasmask", "item_slc_nvg", "cw_frag_grenade" },
		ammo = {},
		chip = "hacked5",
		omnitool = true,
		health = 130,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "cicom",
		max = 1,
		tier = 2,
		backpack = "medium",
		spawn_protection = true,
	} )

	RegisterSupportClass( "cimedic", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_gasmask", "item_slc_medkitplus", { "item_slc_morphine", "item_slc_adrenaline" } },
		ammo = {},
		chip = "hacked4",
		omnitool = true,
		health = 115,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "cimedic",
		max = 1,
		tier = 2,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "cispec", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_gasmask", "item_slc_thermal", "item_slc_turret" },
		ammo = {},
		chip = "hacked4",
		omnitool = true,
		health = 110,
		walk_speed = 110,
		run_speed = 240,
		sanity = 125,
		vest = "ci",
		max = 1,
		tier = 3,
		weight = 3,
		backpack = "small",
		spawn_protection = true,
	} )

	RegisterSupportClass( "ciheavy", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "item_slc_radio", "item_slc_heavymask", "item_slc_nvg" },
		ammo = {},
		chip = "hacked4",
		omnitool = true,
		health = 125,
		walk_speed = 105,
		run_speed = 230,
		sanity = 125,
		vest = "ci",
		max = 1,
		tier = 4,
		weight = 3,
		slots = 2,
		backpack = "small",
		spawn_protection = true,
	} )

	--[[-------------------------------------------------------------------------
	GOC Group
	---------------------------------------------------------------------------]]
	local goc_bgs = {}

	for i = 1, 16 do
		goc_bgs[i] = 1
	end

	RegisterSupportClass( "goc", "goc", "models/player/cheddar/goc/goc_soldier2.mdl", {
		team = TEAM_GOC,
		weapons = { "item_slc_goc_tablet", "item_slc_radio", "item_slc_heavymask", "item_slc_thermal", "cw_flash_grenade" },
		ammo = {},
		chip = "goc",
		omnitool = true,
		health = 120,
		walk_speed = 110,
		run_speed = 245,
		sanity = 125,
		vest = "goc",
		max = 0,
		tier = 2,
		bodygroups = goc_bgs,
		backpack = "large",
		spawn_protection = true,
	} )

	RegisterSupportClass( "gocmedic", "goc", "models/player/cheddar/goc/goc_soldier2.mdl", {
		team = TEAM_GOC,
		weapons = { "item_slc_goc_tablet", "item_slc_radio", "item_slc_heavymask", "item_slc_thermal", "item_slc_medkitplus", { "item_slc_morphine", "item_slc_adrenaline" } },
		ammo = {},
		chip = "goc",
		omnitool = true,
		health = 105,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "gocmedic",
		max = 1,
		tier = 2,
		bodygroups = goc_bgs,
		backpack = "large",
		spawn_protection = true,
	} )

	RegisterSupportClass( "goccom", "goc", "models/player/cheddar/goc/goc_soldier2.mdl", {
		team = TEAM_GOC,
		weapons = { "item_slc_goc_tablet", "item_slc_radio", "item_slc_heavymask", "item_slc_thermal", "cw_smoke_grenade" },
		ammo = { cw_smoke_grenade = 3 },
		chip = "goc",
		omnitool = true,
		health = 130,
		walk_speed = 115,
		run_speed = 250,
		sanity = 150,
		vest = "goccom",
		max = 1,
		tier = 3,
		weight = 3,
		bodygroups = goc_bgs,
		backpack = "large",
		spawn_protection = true,
	} )
end )

if CLIENT then
	timer.Simple( 0, function()
		ClassViewerOverride( "guard", { skin = 4 } )
		ClassViewerOverride( "lightguard", { skin = 4 } )
		ClassViewerOverride( "heavyguard", { skin = 4 } )
		ClassViewerOverride( "specguard", { skin = 3, nvg = 1 } )
		ClassViewerOverride( "chief", { skin = 2 } )
		ClassViewerOverride( "guardmedic", { skin = 1 } )
		ClassViewerOverride( "tech", { skin = 3 } )
		ClassViewerOverride( "cispy", { skin = 4 } )
	end )
end