local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "Security Guard Weste"
vest.heavyguard = "Heavy Guard Weste"
vest.specguard = "Specialist Guard Weste"
vest.guard_medic = "Medic Guard Weste"
vest.ntf = "MTF NTF Weste"
vest.mtf_medic = "MTF NTF Medic Weste"
vest.jugernautt = "Jugernaut Weste"
vest.ntfcom = "MTF NTF Commander Weste"
vest.alpha1 = "MTF Alpha-1 Weste"
vest.ci = "Chaos Insurgency Weste"
vest.fire = "Feuerfeste Weste"
vest.electro = "Elektrofeste Weste"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Feuer Schaden"
dmg.SHOCK = "Elektrischer Schaden"
dmg.BULLET = "Kugelschaden"
dmg.FALL = "Fallschaden"

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
wep.SCP714 = {
	name = "SCP 714"
}

wep.SCP500 = {
	name = "SCP 500"
}

wep.HOLSTER = {
	name = "Holster",
}

wep.ID = {
	name = "ID",
	pname = "Name:",
	server = "Server:",
}

wep.CAMERA = {
	name = "Überwachungssystem",
	showname = "Kameras",
	info = "Kameras lassen dich sehen, was in der Einrichtung passiert.\nDie können dir auch die Fähigkeit geben, SCPs zu skannieren und es über den Funk mitzuteilen.",
}

wep.RADIO = {
	name = "Radio",
}

wep.NVG = {
	name = "NVG",
	info = "Nachtsichtsgerät - Gerät, das dunkle Zonen heller und hellere Zonen noch heller macht.\nManchmal kannst du anomale Sachen durch dies sehen"
}

wep.NVGPLUS = {
	name = "Verbeserter NVG",
	showname = "NVG+",
	info = "verbesserte Version der NVG, lässt dich es benutzen während du andere Sachen in der Hand hältst.\nLeider ist die Batterie nur für 10 Sekunden da."
}

wep.ACCESS_CHIP = {
	name = "Access Chip",
	cname = "Access Chip - %s",
	showname = "CHIP",
	pickupname = "CHIP",
	clearance = "Clearance level: %i",
	hasaccess = "Grants access to:",
	NAMES = {
		general = "General",
		jan1 = "Janitor",
		jan = "Janitor",
		jan2 = "Senior Janitor",
		acc = "Accountant",
		log = "Logistician",
		sci1 = "Researcher level 1",
		sci2 = "Researcher level 2",
		sci3 = "Researcher level 3",
		spec = "Containment Specialist",
		guard = "Security",
		chief = "Security Chief",
		mtf = "MTF",
		com = "MTF Commander",
		hacked3 = "Hacked 3",
		hacked4 = "Hacked 4",
		hacked5 = "Hacked 5",
		director = "Site Director",
		o5 = "O5"
	},
	ACCESS = {
		GENERAL = "General",
		SAFE = "Safe",
		EUCLID = "Euclid",
		KETER = "Keter",
		OFFICE = "Office",
		MEDBAY = "MedBay",
		CHECKPOINT_LCZ = "Checkpoint LCZ-HCZ",
		CHECKPOINT_EZ = "Checkpoint EZ-HCZ",
		WARHEAD_ELEVATOR = "Warhead Elevator",
		EC = "Electrical Center",
		ARMORY = "Armory",
		GATE_A = "Gate A",
		GATE_B = "Gate B",
		FEMUR = "Femur Breaker",
		ALPHA = "Alpha Warhead",
		OMEGA = "Omega Warhead",
		PARTICLE = "Particle Cannon",
	},
}

wep.OMNITOOL = {
	name = "Omnitool",
	cname = "Omnitool - %s",
	showname = "OMNITOOL",
	pickupname = "OMNITOOL",
	none = "NONE",
	chip = "Installierter Chip: %s",
	clearance = "Clearance level: %i",
	SCREEN = {
		loading = "Loading",
		name = "Omnitool v4.78",
		installing = "Installieren des neues chips...",
		ejecting = "Auswerfen des chips...",
		ejectwarn = "Bist Du sicher das Du dein Chip auswerfen möchtest?",
		ejectconfirm = "Drücke wieder um fortzusetzen...",
		chip = "Installierter Chip:",
	},
}

wep.KEYCARD = {
	author = "danx91",
	instructions = "Access:",
	ACC = {
		"SAFE",
		"EUCLID",
		"KETER",
		"Checkpoints",
		"OMEGA Warhead",
		"General Access",
		"Gate A",
		"Gate B",
		"Armory",
		"Femur Breaker",
		"EC",
	},
	STATUS = {
		"ACCESS",
		"NO ACCESS",
	},
	NAMES = {
		"Keycard Level 1",
		"Keycard Level 2",
		"Keycard Level 3",
		"Researcher Keycard",
		"MTF Guard Keycard",
		"MTF Commander Keycard",
		"Keycard Level OMNI",
		"Checkpoint Security Keycard",
		"Hacked CI Keycard",
	},
}

wep.MEDKIT = {
	name = "Medkit (Benutzen übrig: %d)",
	showname = "Medkit",
	pickupname = "Medkit",
}

wep.MEDKITPLUS = {
	name = "Big Medkit (Benutzen übrig: %d)",
	showname = "Medkit+",
	pickupname = "Medkit+",
}

wep.TASER = {
	name = "Taser"
}

wep.FLASHLIGHT = {
	name = "Taschenlampe"
}

wep.BATTERY = {
	name = "Batterie"
}

wep.GASMASK = {
	name = "Gas Maske"
}

wep.TURRET = {
	name = "Turret",
	pickup = "Aufheben",
	MODES = {
		off = "Ausschalten",
		filter = "Filter der Mitarbeiter",
		all = "Alles targeten",
		supp = "unterdrückendes Feuer"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALPHA Warhead Codes #1"
}

wep.ALPHA_CARD2 = {
	name = "ALPHA Warhead Codes #2"
}

wep.weapon_stunstick = "Stunstick"
