local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "Security Guard Vest"
vest.heavyguard = "Heavy Guard Vest"
vest.specguard = "Specialist Guard Vest"
vest.guard_medic = "Medic Guard Vest"
vest.ntf = "MTF NTF Vest"
vest.mtf_medic = "MTF NTF Medic Vest"
vest.ntfcom = "MTF NTF Commander Vest"
vest.alpha1 = "MTF Alpha-1 Vest"
vest.ci = "Chaos Insurgency Vest"
vest.cicom = "CI Commander Vest"
vest.cimedic = "CI Medic Vest"
vest.goc = "GOC Vest"
vest.gocmedic = "GOC Medic Vest"
vest.goccom = "GOC Commander Vest"
vest.fire = "Fireproof Vest"
vest.electro = "Electroproof Vest"
vest.hazmat = "Hazmat"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Fire Damage"
dmg.SHOCK = "Electrical Damage"
dmg.BULLET = "Bullet Damage"
dmg.FALL = "Fall Damage"
dmg.POISON = "Poison Damage"

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
wep.SCP009 = {
	name = "SCP-009",
}

wep.SCP500 = {
	name = "SCP-500",
	death_info = "You choked on that SCP-500",
	text_used = "You soon as you swallowed this pill, you felt better",
}

wep.SCP714 = {
	name = "SCP-714"
}

wep.SCP1025 = {
	name = "SCP-1025",
	diseases = {
		arrest = "Cardiac arrest",
		mental = "Mental Illness",
		asthma = "Asthma",
		blindness = "Blindness",
		hemo = "Haemophilia",
		oste = "Osteoporosis",

		adhd = "ADHD",
		throm = "Thrombocythemia",
		urbach = "Urbach–Wiethe disease",

		gas = "Tympanites",
	},
	descriptions = {
		arrest = "Cardiac arrest is a sudden loss of blood flow resulting from the failure of the heart to pump effectively. Signs include loss of consciousness and abnormal or absent breathing. Some individuals may experience chest pain, shortness of breath, or nausea immediately before entering cardiac arrest. Radiating pain to one arm is a common symptom, as is long term malaise and general weakness of heart. If not treated within minutes, it typically leads to death.",
		asthma = "Asthma is a long-term inflammatory disease of the airways of the lungs. It is characterized by variable and recurring symptoms, reversible airflow obstruction, and easily triggered bronchospasms. Symptoms include episodes of wheezing, coughing, chest tightness, and shortness of breath. These may occur a few times a day or a few times per week.",
		blindness = "Visual impairment, also known as vision impairment or vision loss, is a decreased ability to see to a degree that causes problems not fixable by usual means, such as glasses. Some also include those who have a decreased ability to see because they do not have access to glasses or contact lenses. The term blindness is used for complete or nearly complete vision loss.",
		hemo = "Haemophilia (also spelled hemophilia) is a mostly inherited genetic disorder that impairs the body's ability to make blood clots, a process needed to stop bleeding. This results in people bleeding for a longer time after an injury, easy bruising, and an increased risk of bleeding inside joints or the brain. Characteristic symptoms vary with severity. In general symptoms are internal or external bleeding episodes.",
		oste = "Osteoporosis is a systemic skeletal disorder characterized by low bone mass, micro-architectural deterioration of bone tissue leading to bone fragility, and consequent increase in fracture risk. It is the most common reason for a broken bone among the elderly. Bones that commonly break include the vertebrae in the spine, the bones of the forearm, and the hip. Until a broken bone occurs there are typically no symptoms.",

		adhd = "Attention-deficit/hyperactivity disorder (ADHD) is a neurodevelopmental disorder characterized by inattention, bouts of excessive energy, hyper-fixation, and impulsivity, which are otherwise not appropriate for a person's age. Some individuals with ADHD also display difficulty regulating emotions or problems with executive function. Additionally, it is associated with other mental disorders.",
		throm = "Thrombocythemia is a condition of high platelet (thrombocyte) count in the blood. High platelet counts do not necessarily signal any clinical problems, and can be picked up on a routine full blood count. However, it is important that a full medical history be elicited to ensure that the increased platelet count is not due to a secondary process.",
		urbach = "Urbach–Wiethe disease is a very rare recessive genetic disorder. The symptoms of the disease vary greatly from individual to individual. Urbach–Wiethe disease show bilateral symmetrical calcifications on the medial temporal lobes. These calcifications often affect the amygdala. The amygdala is thought to be involved in processing biologically relevant stimuli and in emotional long-term memory, particularly those associated with fear.",
	},
	death_info_arrest = "You died due to cardiac arrest"
}

wep.HOLSTER = {
	name = "Holster",
	info = "Use to hide currently equipped item"
}

wep.ID = {
	name = "ID",
	pname = "Name:",
	server = "Server:",
}

wep.CCTV = {
	name = "Surveillance System",
	showname = "CCTV",
	info = "CCTV system allows you to see what is happening in the facility.\nIt also provides you an ability to scan SCPs and transmit this information to your current radio channel",
	scanning = "Scanning...",
	scan_info = "Press [%s] to scan SCPs",
	map_info = "Press [%s] to open map",
	scan_cd = "Wait before next scan...",
	no_signal = "No signal...",
}

wep.RADIO = {
	name = "Radio",
}

wep.NVG = {
	name = "NVG",
	info = "Night Vision Goggles - Device that makes dark areas brighter and makes bright areas even more brighter.\nSometimes you can see anomalous things through them."
}

wep.NVGPLUS = {
	name = "Enhanced NVG",
	showname = "NVG+",
	info = "Enhanced version of NVG, allows you to use it while holding other items in hands.\nUnfortunately battery lasts only for 10 seconds"
}

wep.THERMAL = {
	showname = "THERMAL",
	name = "Thermal Vision Device"
}

wep.ACCESS_CHIP = {
	name = "Access Chip",
	cname = "Access Chip - %s",
	showname = "CHIP",
	pickupname = "CHIP",
	clearance = "Clearance level: %i",
	clearance2 = "Clearance level: ",
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
		o5 = "O5",
		goc = "GOC Hacked",
	},
	SHORT = {
		general = "General",
		jan1 = "Janitor",
		jan = "Janitor",
		jan2 = "Senior Jan.",
		acc = "Accountant",
		log = "Logistician",
		sci1 = "Res. lvl. 1",
		sci2 = "Res. lvl. 2",
		sci3 = "Res. lvl. 3",
		spec = "Cont. Spec.",
		guard = "Security",
		chief = "Sec. Chief",
		mtf = "MTF",
		com = "MTF Com.",
		hacked3 = "Hacked 3",
		hacked4 = "Hacked 4",
		hacked5 = "Hacked 5",
		director = "Director",
		o5 = "O5",
		goc = "GOC Hacked",
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
		GATE_C = "Gate C",
		FEMUR = "Femur Breaker",
		ALPHA = "Alpha Warhead",
		OMEGA = "Omega Warhead",
		PARTICLE = "Particle Cannon",
	},
}

wep.OMNITOOL = {
	name = "Omnitool",
	cname = "Omnitool - %s",
	showname = "Omnitool",
	pickupname = "Omnitool",
	none = "NONE",
	chip = "Installed Chip: %s",
	chip2 = "Installed Chip: ",
	clearance = "Clearance level: %i",
	clearance2 = "Clearance level: ",
	SCREEN = {
		loading = "Loading",
		name = "Omnitool v4.78",
		installing = "Installing new chip...",
		ejecting = "Ejecting access chip...",
		ejectwarn = "Are you sure to eject chip?",
		ejectconfirm = "Press again to confirm...",
		chip = "Installed Chip:",
	},
}

wep.MEDKIT = {
	name = "Medkit (Charges Left: %d)",
	showname = "Medkit",
	pickupname = "Medkit",
}

wep.MEDKITPLUS = {
	name = "Big Medkit (Charges Left: %d)",
	showname = "Medkit+",
	pickupname = "Medkit+",
}

wep.FLASHLIGHT = {
	name = "Flashlight"
}

wep.BATTERY = {
	name = "Battery"
}

wep.GASMASK = {
	name = "Gas Mask"
}

wep.HEAVYMASK = {
	name = "Heavy Gas Mask"
}

wep.FUSE = {
	name = "Fuse",
	name_f = "Fuse %iA",
}

wep.TURRET = {
	name = "Turret",
	placing_turret = "Placing turret",
	pickup_turret = "Picking up turret",
	pickup = "Pick up",
	MODES = {
		off = "Disable",
		filter = "Filter staff",
		target = "Target staff",
		all = "Target everything",
		supp = "Suppressive fire",
		scp = "Target SCPs"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALPHA Warhead Codes #1"
}

wep.ALPHA_CARD2 = {
	name = "ALPHA Warhead Codes #2"
}

wep.COM_TAB = {
	name = "NTF Tablet",
	loading = "Loading",
	eta = "ETA: ",
	detected = "Detected subjects:",
	tesla_deactivated = "Teslas deactivated: ",
	change = "RMB - change",
	confirm = "LMB - confirm",
	options = {
		scan = "Facility scan",
		tesla = "Request tesla",
		intercom = "Intercom",
		vent = "Enable gas vents",
	},
	actions = {
		scan = "Scanning facility...",
		tesla = "Disabling tesla...",
		intercom = "Intercom active...",
		vent = "Gas ventilation active...",
	}
}

wep.GOC_TAB = {
	name = "GOC Tablet",
	info = "Personal GOC tablet. Contains a small explosive that destroys tablet in the event of user's death",
	loading = "Loading",
	status = "Status:",
	dist = "Distance to target",
	objectives = {
		failed = "Device destroyed",
		nothing = "Unknown",
		find = "Find device",
		deliver = "Deliver device",
		escort = "Escort Device",
		protect = "Protect Device",
		escape = "Escape"
	}
}

wep.GOCDEVICE = {
	name = "GOC Device",
	placing = "Placing GOC device..."
}

wep.DOCUMENT = {
	name = "Documents",
	info = "Bundle of several documents that may contain valuable information about SCPs, facility and staff",
	types = {

	}
}

wep.BACKPACK = {
	name = "Backpack",
	info = "Allows you to store more items",
	size = "Size: ",
	NAMES = {
		small = "Small Backpack",
		medium = "Medium Backpack",
		large = "Large Backpack",
		huge = "Huge Backpack",
	}
}

wep.ADRENALINE = {
	name = "Adrenaline",
	info = "Provides momentary boost to stamina for a short time",
}

wep.ADRENALINE_BIG = {
	name = "Large Adrenaline",
	info = "Provides momentary boost to stamina for a considerable amount of time",
}

wep.MORPHINE = {
	name = "Morphine",
	info = "Provides some temporary health that decreases over time",
}

wep.MORPHINE_BIG = {
	name = "Large Morphine",
	info = "Provides a lot of temporary health that decreases over time",
}

wep.EPHEDRINE = {
	name = "Ephedrine",
	info = "Provides small speed boost for a short time",
}

wep.EPHEDRINE_BIG = {
	name = "Large Ephedrine",
	info = "Provides big speed boost for a short time",
}

wep.HEMOSTATIC = {
	name = "Hemostatic",
	info = "All types of bleeding will disappear quickly. Effect lasts for a short time.",
}

wep.HEMOSTATIC_BIG = {
	name = "Large Hemostatic",
	info = "All types of bleeding will disappear quickly. Effect lasts for a longer time",
}

wep.ANTIDOTE = {
	name = "Antidote",
	info = "All types of poison will disappear quickly. Effect lasts for a short time.",
}

wep.ANTIDOTE_BIG = {
	name = "Large Antidote",
	info = "All types of poison will disappear quickly. Effect lasts for a longer time",
}

wep.POISON = {
	name = "Poison",
	info = "Causes major damage over time",
}

wep.POISON_BIG = {
	name = "Large Poison",
	info = "Causes lethal damage over time",
}

wep.TASER = {
	name = "Taser"
}

wep.PIPE = {
	name = "Metal pipe"
}

wep.GLASS_KNIFE = {
	name = "Glass knife"
}

wep.CLOTHES_CHANGER = {
	name = "Clothes Changer (Holster)",
	info = "Works like regular holster. Additionally allows you to steal clothes from dead bodies. Look at dead body and hold LMB to use",
	skill = "Clothes Changer",
	wait = "Wait",
	ready = "Ready",
	id_time = "Remaining stolen ID time",
	progress = "Changing clothes",
	vest = "Remove your vest in order to change clothes"
}

wep.DOOR_BLOCKER = {
	name = "Door Blocker",
	info = "Aim at button and hold LMB to charge. Release LMB to discharge and temporarily block door usage",
	skill = "Door Blocker",
	wait = "Wait",
	ready = "Ready",
	progress = "Charging"
}

wep.SNAV = {
	name = "S-NAV",
	low_battery = "Low Battery",
	no_signal = "No Signal",
}

wep.SNAV_ULT = {
	name = "S-NAV ULTIMATE",
	showname = "S-NAV+",
	low_battery = "Low Battery",
	no_signal = "No Signal",
}

wep.__slc_ammo = "Ammo"

wep.CROWBAR = {
	name = "Crowbar",
}
wep.STUNSTICK = {
	name = "Stunstick",
}
