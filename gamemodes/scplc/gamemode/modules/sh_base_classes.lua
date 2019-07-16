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
	"models/player/kerry/Class_Jan_2.mdl",
	"models/player/kerry/Class_Jan_3.mdl",
	"models/player/kerry/Class_Jan_4.mdl",
	"models/player/kerry/Class_Jan_5.mdl",
	"models/player/kerry/Class_Jan_6.mdl",
	"models/player/kerry/Class_Jan_7.mdl",
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

MTF_MODELS = {
	"models/npc/portal/Male_02_Garde.mdl",
	"models/npc/portal/Male_04_Garde.mdl",
	"models/npc/portal/Male_05_Garde.mdl",
	"models/npc/portal/Male_06_Garde.mdl",
	"models/npc/portal/Male_07_Garde.mdl",
	"models/npc/portal/Male_08_Garde.mdl",
	"models/npc/portal/Male_09_Garde.mdl",
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

	addSupportGroup( "mtf", 75, SPAWN_SUPPORT_MTF )
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
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 75,
		vest = nil,
		level = 0,
		max = 0,
	} )

	registerClass( "veterand", "classd", VETERAND_MODELS, {
		team = TEAM_CLASSD,
		weapons = {},
		ammo = {},
		chip = "safe",
		health = 120,
		walk_speed = 100,
		run_speed = 240,
		sanity = 100,
		vest = nil,
		level = 2,
		max = 3,
	} )

	registerClass( "kleptod", "classd", CLASSD_MODELS, {
		team = TEAM_CLASSD,
		weapons = { { "item_slc_radio", "item_slc_camera", "item_slc_nvg", "item_slc_medkit" } },
		ammo = {},
		chip = "",
		health = 80,
		walk_speed = 100,
		run_speed = 260,
		sanity = 50,
		vest = nil,
		level = 5,
		max = 1,
	} )

	registerClass( "ciagent", "classd", CLASSD_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_taser" },
		ammo = {},
		chip = "safe",
		health = 150,
		walk_speed = 110,
		run_speed = 250,
		sanity = 100,
		vest = nil,
		level = 7,
		max = 1,
		persona = { team = TEAM_CLASSD, class = "classd" },
	} )

	--[[-------------------------------------------------------------------------
	SCI
	---------------------------------------------------------------------------]]
	registerClass( "sci", "sci", SCI_MODELS, {
		team = TEAM_SCIENT,
		weapons = {},
		ammo = {},
		chip = "res",
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = nil,
		level = 3,
		max = 0,
	} )

	registerClass( "sciassistant", "sci", SCI_MODELS, {
		team = TEAM_SCIENT,
		weapons = {},
		ammo = {},
		chip = "safe",
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 50,
		vest = nil,
		level = 0,
		max = 0,
	} )

	registerClass( "seniorsci", "sci", SCI_MODELS, {
		team = TEAM_SCIENT,
		weapons = {},
		ammo = {},
		chip = "res",
		health = 120,
		walk_speed = 110,
		run_speed = 225,
		sanity = 125,
		vest = nil,
		level = 6,
		max = 1,
	} )

	registerClass( "headsci", "sci", SCI_MODELS, {
		team = TEAM_SCIENT,
		weapons = {},
		ammo = {},
		chip = "res",
		health = 150,
		walk_speed = 115,
		run_speed = 240,
		sanity = 150,
		vest = nil,
		level = 9,
		max = 1,
	} )

	--[[-------------------------------------------------------------------------
	MTF
	---------------------------------------------------------------------------]]
	registerClass( "guard", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_mp5" },
		ammo = { cw_mp5 = 180 },
		chip = "mtf",
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		level = 0,
		max = 0,
	} )

	registerClass( "chief", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "weapon_taser", "cw_ump45" },
		ammo = { cw_ump45 = 150 },
		chip = "mtf",
		health = 125,
		walk_speed = 105,
		run_speed = 235,
		sanity = 125,
		vest = "chief",
		level = 3,
		max = 1,
	} )

	registerClass( "private", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_m3super90" },
		ammo = { cw_m3super90 = 32 },
		chip = "mtf",
		health = 150,
		walk_speed = 110,
		run_speed = 240,
		sanity = 125,
		vest = "private",
		level = 1,
		max = 3,
	} )

	registerClass( "sergeant", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_nvg", "cw_g36c" },
		ammo = { cw_g36c = 180 },
		chip = "mtf",
		health = 175,
		walk_speed = 115,
		run_speed = 250,
		sanity = 150,
		vest = "sergeant",
		level = 5,
		max = 1,
	} )

	registerClass( "medic", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_medkitplus", "weapon_taser", "cw_fiveseven" },
		ammo = { cw_fiveseven = 120 },
		chip = "mtf",
		health = 125,
		walk_speed = 120,
		run_speed = 260,
		sanity = 100,
		vest = "medic",
		level = 6,
		max = 3,
	} )

	registerClass( "lieutenant", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_nvg", "cw_m14" },
		ammo = { cw_m14 = 120 },
		chip = "mtf",
		health = 200,
		walk_speed = 120,
		run_speed = 260,
		sanity = 175,
		vest = "lieutenant",
		level = 8,
		max = 1,
	} )

	registerClass( "alpha1", "mtf", MTF_MODELS, {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "item_slc_nvg", "cw_scarh" },
		ammo = { cw_scarh = 120 },
		chip = "omni",
		health = 250,
		walk_speed = 125,
		run_speed = 275,
		sanity = 200,
		vest = "alpha1",
		level = 10,
		max = 1,
	} )

	registerClass( "cispy", "mtf", MTF_MODELS, {
		team = TEAM_CI,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_mp5" },
		ammo = { cw_mp5 = 180 },
		chip = "mtf",
		health = 100,
		walk_speed = 100,
		run_speed = 230,
		sanity = 100,
		vest = "guard",
		level = 4,
		max = 2,
		persona = { team = TEAM_MTF, class = "guard" },
	} )

	--[[-------------------------------------------------------------------------
	SUPPORT
	---------------------------------------------------------------------------]]
	--MTF

	registerSupportClass( "ntf", "mtf", MTF_MODELS,  {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_nvg", "cw_ar15" },
		ammo = { cw_ar15 = 360 },
		chip = "mtf",
		health = 150,
		walk_speed = 115,
		run_speed = 250,
		sanity = 125,
		vest = "ntf",
		level = 2,
		max = 0,
	} )

	registerSupportClass( "ntfcom", "mtf", MTF_MODELS,  {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "item_slc_camera", "cw_m14" },
		ammo = { cw_m14 = 120 },
		chip = "mtf",
		health = 200,
		walk_speed = 115,
		run_speed = 255,
		sanity = 150,
		vest = "ntf",
		level = 5,
		max = 1,
	} )

	registerSupportClass( "ntfsniper", "mtf", MTF_MODELS,  {
		team = TEAM_MTF,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_l115" },
		ammo = { cw_l115 = 30 },
		chip = "mtf",
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		vest = "ntf",
		level = 7,
		max = 1,
	} )

	--CI
	registerSupportClass( "ci", "ci", CI_MODELS,  {
		team = TEAM_CI,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_g36c" },
		ammo = { cw_g36c = 180 },
		chip = "ci",
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 90,
		vest = "ci",
		level = 3,
		max = 0,
	} )

	registerSupportClass( "cicom", "ci", CI_MODELS,  {
		team = TEAM_CI,
		weapons = { "weapon_stunstick", "item_slc_radio", "cw_ak74" },
		ammo = { cw_ak74 = 270 },
		chip = "ci",
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 90,
		vest = "ci",
		level = 9,
		max = 1,
	} )
end )