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
	"models/bmscientistcits/p_female_01.mdl",
	"models/bmscientistcits/p_female_02.mdl",
	"models/bmscientistcits/p_female_03.mdl",
	"models/bmscientistcits/p_female_04.mdl",
	"models/bmscientistcits/p_female_06.mdl",
	"models/bmscientistcits/p_female_07.mdl",
	"models/bmscientistcits/p_male_01.mdl",
	"models/bmscientistcits/p_male_02.mdl",
	"models/bmscientistcits/p_male_03.mdl",
	"models/bmscientistcits/p_male_04.mdl",
	"models/bmscientistcits/p_male_05.mdl",
	"models/bmscientistcits/p_male_06.mdl",
	"models/bmscientistcits/p_male_07.mdl",
	"models/bmscientistcits/p_male_08.mdl",
	"models/bmscientistcits/p_male_09.mdl",
	"models/bmscientistcits/p_male_10.mdl",
	"models/scp/apsci_cohrt.mdl",
	"models/scp/apsci_male_02.mdl",
	"models/scp/apsci_male_03.mdl",
	"models/scp/apsci_male_05.mdl",
	"models/scp/apsci_male_07.mdl",
	"models/scp/apsci_male_08.mdl",
	"models/scp/apsci_male_09.mdl",
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
	"models/kerry/player/merriweather/male_01.mdl",
	"models/kerry/player/merriweather/male_02.mdl",
	"models/kerry/player/merriweather/male_03.mdl",
	"models/kerry/player/merriweather/male_04.mdl",
	"models/kerry/player/merriweather/male_05.mdl",
	"models/kerry/player/merriweather/male_06.mdl",
	"models/kerry/player/merriweather/male_07.mdl",
	"models/kerry/player/merriweather/male_08.mdl",
	"models/kerry/player/merriweather/male_09.mdl",
}

hook.Add( "SLCRegisterClassGroups", "BaseGroups", function()
	addClassGroup( "classd", 49, SPAWN_CLASSD )
	addClassGroup( "sci", 21, SPAWN_SCIENT )
	addClassGroup( "mtf", 30, SPAWN_MTF )

	addSupportGroup( "mtf_ntf", 70, SPAWN_SUPPORT_MTF )
	//addSupportGroup( "mtf_fire", 25, SPAWN_SUPPORT_MTF )
	addSupportGroup( "mtf_alpha", 10, SPAWN_SUPPORT_MTF, 3, function()
		SetRoundStat( "mtfalphaspawned", true )
	end, function()
		local round = GetTimer( "SLCRound" )
		if !IsValid( round ) or round:GetRemainingTime() <= round:GetTime() / 2 then
			return !GetRoundStat( "mtfalphaspawned" )
		end

		return false
	end )
	addSupportGroup( "ci", 25, SPAWN_SUPPORT_CI )
end )

hook.Add( "SLCRegisterPlayerClasses", "BaseClasses", function()
	--[[-------------------------------------------------------------------------
	CLASS D
	---------------------------------------------------------------------------]]
	registerClass( "classd", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "",
		omnitool = false,
		health = 115,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		price = 0,
		max = 0,
	} )

	/*registerClass( "test1", "classd", CLASSD_MODELS, {
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
		price = 10,
		max = 0,
	} )*/

	registerClass( "veterand", "classd", VETERAND_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "jan",
		omnitool = true,
		health = 130,
		walk_speed = 100,
		run_speed = 240,
		sanity = 100,
		vest = nil,
		price = 3,
		max = 3,
	} )

	registerClass( "kleptod", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = { { "item_slc_radio", "item_slc_camera", "item_slc_nvg", "item_slc_medkit", "item_slc_flashlight", "item_slc_gasmask" }, "item_slc_battery" },
		ammo = {},
		chip = "",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 260,
		sanity = 50,
		vest = nil,
		price = 5,
		max = 1,
	} )

	registerClass( "ciagent", "classd", CLASSD_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_taser" },
		ammo = {},
		chip = "jan",
		omnitool = true,
		health = 150,
		walk_speed = 110,
		run_speed = 250,
		sanity = 100,
		vest = nil,
		price = 8,
		max = 1,
		persona = { team = TEAM_CLASSD, class = "classd" },
	} )

	--[[-------------------------------------------------------------------------
	SCI
	---------------------------------------------------------------------------]]
	registerClass( "sci", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci2",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = nil,
		price = 2,
		max = 0,
	} )

	registerClass( "sciassistant", "sci", SCI_MODELS, {
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
		price = 0,
		max = 0,
	} )

	registerClass( "seniorsci", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci3",
		omnitool = true,
		health = 120,
		walk_speed = 110,
		run_speed = 225,
		sanity = 125,
		vest = nil,
		price = 6,
		max = 1,
	} )

	registerClass( "headsci", "sci", SCI_MODELS, {
		team = TEAM_SCI,
		weapons = {},
		ammo = {},
		chip = "sci3",
		omnitool = true,
		health = 150,
		walk_speed = 115,
		run_speed = 240,
		sanity = 150,
		vest = nil,
		price = 10,
		max = 1,
	} )

	--[[-------------------------------------------------------------------------
	MTF
	---------------------------------------------------------------------------]]
	registerClass( "guard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_mp5" },
		ammo = { cw_mp5 = 180 },
		chip = "guard",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 0,
		max = 0,
		skin = 4,
	} )
	
	registerClass( "lightguard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_flashlight", "item_slc_battery", "cw_makarov" },
		ammo = { cw_makarov = 120 },
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 110,
		run_speed = 250,
		sanity = 100,
		vest = nil,
		price = 2,
		max = 0,
		skin = 4,
	} )

	registerClass( "heavyguard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_m3super90" },
		ammo = { cw_m3super90 = 32 },
		chip = "guard",
		omnitool = true,
		health = 140,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "heavyguard",
		price = 3,
		max = 0,
		skin = 4,
	} )

	registerClass( "specguard", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_nvg", "item_slc_gasmask", "cw_g36c" },
		ammo = { cw_g36c = 180 },
		chip = "guard",
		omnitool = true,
		health = 125,
		walk_speed = 100,
		run_speed = 230,
		sanity = 120,
		vest = "specguard",
		price = 5,
		max = 0,
		skin = 3,
		bodygroups = { nvg = 1 }
	} )

	registerClass( "chief", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "weapon_taser", "cw_ump45" },
		ammo = { cw_ump45 = 150 },
		chip = "chief",
		omnitool = true,
		health = 115,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 4,
		max = 1,
		skin = 2,
	} )

	registerClass( "guardmedic", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_medkitplus", "weapon_taser", "cw_fiveseven" },
		ammo = { cw_fiveseven = 80 },
		chip = "guard",
		omnitool = true,
		health = 130,
		walk_speed = 120,
		run_speed = 260,
		sanity = 100,
		vest = "guard_medic",
		price = 8,
		max = 2,
		skin = 1,
	} )

	registerClass( "tech", "mtf", GUARD_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_ump45", "item_slc_turret" },
		ammo = { cw_ump45 = 150 },
		chip = "guard",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 10,
		max = 1,
		skin = 3,
	} )

	registerClass( "cispy", "mtf", GUARD_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_mp5" },
		ammo = { cw_mp5 = 180 },
		chip = "guard",
		omnitool = true,
		health = 110,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		price = 6,
		max = 2,
		persona = { team = TEAM_MTF, class = "guard" },
		skin = 4,
	} )

	--[[-------------------------------------------------------------------------
	SUPPORT
	---------------------------------------------------------------------------]]
	--NTF
	registerSupportClass( "ntf_1", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_ump45" },
		ammo = { cw_ump45 = 150 },
		chip = "mtf",
		omnitool = true,
		health = 115,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ntf",
		price = 4,
		max = 0,
	} )

	registerSupportClass( "ntf_2", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_m3super90" },
		ammo = { cw_m3super90 = 32 },
		chip = "mtf",
		omnitool = true,
		health = 115,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ntf",
		price = 5,
		max = 0,
	} )

	registerSupportClass( "ntf_3", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_g36c" },
		ammo = { cw_g36c = 240 },
		chip = "mtf",
		omnitool = true,
		health = 115,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ntf",
		price = 6,
		max = 0,
	} )

	registerSupportClass( "ntfmedic", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_medkit", "item_slc_medkitplus", "cw_fiveseven" },
		ammo = { cw_fiveseven = 120 },
		chip = "mtf",
		omnitool = true,
		health = 125,
		walk_speed = 115,
		run_speed = 250,
		sanity = 150,
		vest = "mtf_medic",
		price = 8,
		max = 1,
	} )

	registerSupportClass( "ntfcom", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "item_slc_nvg", "cw_m14" },
		ammo = { cw_m14 = 120 },
		chip = "com",
		omnitool = true,
		health = 135,
		walk_speed = 120,
		run_speed = 255,
		sanity = 150,
		vest = "ntfcom",
		price = 10,
		max = 1,
	} )

	registerSupportClass( "ntfsniper", "mtf_ntf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_l115" },
		ammo = { cw_l115 = 30 },
		chip = "mtf",
		omnitool = true,
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "ntf",
		price = 6,
		max = 1,
	} )

	--Alpha-1
	registerSupportClass( "alpha1", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", { "item_slc_nvg", "item_slc_gasmask" }, "cw_scarh" },
		ammo = { cw_scarh = 120 },
		chip = "o5",
		omnitool = true,
		health = 225,
		walk_speed = 125,
		run_speed = 260,
		sanity = 175,
		vest = "alpha1",
		price = 15,
		max = 2,
	} )

	registerSupportClass( "alpha1sniper", "mtf_alpha", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", { "item_slc_nvg", "item_slc_gasmask" }, "cw_m14" },
		ammo = { cw_m14 = 120 },
		chip = "o5",
		omnitool = true,
		health = 175,
		walk_speed = 120,
		run_speed = 255,
		sanity = 175,
		vest = "alpha1",
		price = 15,
		max = 2,
	} )

	--CI
	registerSupportClass( "ci", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_l85a2" },
		ammo = { cw_l85a2 = 240 },
		chip = "hacked3",
		omnitool = true,
		health = 145,
		walk_speed = 110,
		run_speed = 245,
		sanity = 125,
		vest = "ci",
		price = 6,
		max = 0,
	} )

	registerSupportClass( "cicom", "ci", CI_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_ak74" },
		ammo = { cw_ak74 = 240 },
		chip = "hacked4",
		omnitool = true,
		health = 180,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ci",
		price = 12,
		max = 1,
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