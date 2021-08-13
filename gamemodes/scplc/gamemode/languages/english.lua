--[[-------------------------------------------------------------------------
Language: English
Date: 15.02.2021
Translated by: danx91 (aka ZGFueDkx)
---------------------------------------------------------------------------]]

local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "You can be selected as SCP in next round",
	scpwait = "You have to wait %i rounds to be able to play as SCP",
	abouttostart = "Game will start in %i seconds!",
	kill = "You received %d points for killing %s: %s!",
	assist = "You received %d points for assisting in kill of player: %s!",
	rdm = "You lost %d points for killing %s: %s!",
	acc_denied = "Access denied",
	acc_granted = "Access granted",
	acc_omnitool = "An Omnitool is required to operate this door",
	device_noomni = "An Omnitool is required to operate this device",
	elevator_noomni = "An Omnitool is required to operate this elevator",
	acc_wrong = "Higher clearance level is required to perform this action",
	rxpspec = "You received %i experience for playing on this server!",
	rxpplay = "You received %i experience for staying alive in the round!",
	rxpplus = "You received %i experience for surviving more than half of the round!",
	roundxp = "You received %i experience for your points",
	gateexplode = "Time to Gate A explosion: %i",
	explodeterminated = "Gate A destruction has been terminated",
	r106used = "SCP 106 recontain procedure can be triggered only once per round",
	r106eloiid = "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure",
	r106sound = "Enable sound transmission in order to start SCP 106 recontain procedure",
	r106human = "Alive human is required in cage in order to start SCP 106 recontain procedure",
	r106already = "SCP 106 is already recontained",
	r106success = "You received %i points for recontaining SCP 106!",
	vestpickup = "You picked up vest",
	vestdrop = "You dropped your vest",
	hasvest = "You already has vest! Use your EQ to drop it",
	escortpoints = "You received %i points for escorting your allies",
	femur_act = "Femur Breaker activated...",
	levelup = "You leveled up! Your current level: %i",
	healplayer = "You received %i points for healing other player",
	detectscp = "You received %i points for detecting SCPs",
	winxp = "You received %i experience because your initial team won the game",
	winalivexp = "You received %i experience because your team won the game",
	upgradepoints = "You received new upgrade point(s)! Press '%s' to open SCP upgrade menu",
	prestigeup = "Player %s earned higher prestige! Their current prestige level: %i",
	omega_detonation = "OMEGA Warhead detonation in %i seconds. Get on the surface or proceed to the blast shelter immediately!",
	alpha_detonation = "ALPHA Warhead detonation in %i seconds. Get in the facility or proceed to the evacuation immediately!",
	alpha_card = "You've inserted ALPHA Warhead nuclear card",
	destory_scp = "You received %i points for destroying SCP object!",
	afk = "You are AFK. You will not spawn and receive XP over time!",
	afk_end = "You are no longer AFK",
	overload_cooldown = "Wait %i seconds to overload this door!",
	advanced_overload = "This door seems to be stronger! Try again in %i seconds",
	lockdown_once = "Facility lockdown can be activated only once per round!",
}

lang.NFailed = "Failed to access NRegistry with key: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "You escaped!",
	escapeinfo = "Good job! You escaped in %s",
	escapexp = "You received %i experience",
	escort = "You have been escorted!",
	roundend = "Round ended!",
	nowinner = "No winner in this round!",
	roundnep = "Not enough players!",
	roundwin = "Round winner: %s",
	roundwinmulti = "Round winners: [RAW]",
	shelter_escape = "You survived explosion in blast shelter",
	alpha_escape = "You escaped before warhead exploded",

	mvp = "MVP: %s with score: %i",
	stat_kill = "Players killed: %i",
	stat_rdm = "RDM kills: %i",
	stat_rdmdmg = "RDM damage: %i",
	stat_dmg = "Damage dealt: %i",
	stat_bleed = "Bleeding damage: %i",
	stat_106recontain = "SCP 106 has been recontained",
	stat_escapes = "Escaped players: %i",
	stat_escorts = "Players escorted: %i",
	stat_023 = "Sudden deaths caused by SCP 023: %i",
	stat_049 = "Cured people: %i",
	stat_066 = "Played masterpieces: %i",
	stat_096 = "Players killed by shy guy: %i",
	stat_106 = "Players teleported to Pocket Dimension: %i",
	stat_173 = "Snapped necks: %i",
	stat_457 = "Incinerated players: %i",
	stat_682 = "Players killed by overgrown reptile: %i",
	stat_8602 = "Players nailed to wall: %i",
	stat_939 = "SCP 939 preys: %i",
	stat_966 = "Insidious cuts: %i",
	stat_3199 = "Assassinations by SCP 3199: %i",
	stat_24273 = "People judged by SCP 2427-3: %i",
	stat_omega_warhead = "Omega warhead has been detonated",
	stat_alpha_warhead = "Alpha warhead has been detonated",
}

lang.NCFailed = "Failed to access NCRegistry with key: %s"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "Pick up"
hud.class = "Class"
hud.team = "Team"
hud.prestige_points = "Prestige Points"
hud.hp = "HP"
hud.stamina = "STAMINA"
hud.sanity = "SANITY"
hud.xp = "XP"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "LMB - Select"
lang.eq_rmb = "RMB - Drop"
lang.eq_hold = "Hold LMB - Move item"
lang.eq_vest = "Vest"
lang.eq_key = "Press '%s' to open EQ"

lang.info = "Informations"
lang.author = "Author"
lang.mobility = "Mobility"
lang.weight = "Weight"
lang.protection = "Protection"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "Escort",
	gatea = "Destroy Gate A"
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "perm"
effects.bleeding = "Bleeding"
effects.doorlock = "Door Lock"
effects.amnc227 = "AMN-C227"
effects.insane = "Insane"
effects.gas_choke = "Choking"
effects.radiation = "Radiation"
effects.deep_wounds = "Deep Wounds"
effects.heavy_bleeding = "Heavy Bleeding"
effects.weak_bleeding = "Weak Bleeding"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Class Viewer"
lang.preview = "Preview"
lang.random = "Random"
lang.price = "Price"
lang.buy = "Buy"
lang.refound = "Refund"
lang.none = "None"
lang.refounded = "All removed classes has been refunded. You've recived %d prestige points."

lang.details = {
	details = "Details",
	name = "Name",
	team = "Team",
	price = "Prestige Points price",
	walk_speed = "Walk Speed",
	run_speed = "Run Speed",
	chip = "Access Chip",
	persona = "Fake ID",
	weapons = "Weapons",
	class = "Class",
	hp = "Health",
	speed = "Speed",
	health = "Health",
	sanity = "Sanity"
}

lang.headers = {
	support = "SUPPORT",
	classes = "CLASSES",
	scp = "SCPs"
}

lang.view_cat = {
	classd = "Class D",
	sci = "Scientists",
	mtf = "Security",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alpha-1",
	ci = "Chaos Insurgency",
}

--[[-------------------------------------------------------------------------
Settings
---------------------------------------------------------------------------]]
lang.settings = {
	settings = "Gamemode settings",

	none = "NONE",
	press_key = "> Press a key <",
	client_reset = "Reset Client Settings to Defaults",
	server_reset = "Reset Server Settings to Defaults",

	client_reset_desc = "You are about to reset your ALL setting in this gamemode.\nThis action cannot be undone!",
	server_reset_desc = "Due to security reasons you cannot reset server settings here.\nTo reset server to default settings, enter 'slc_factory_reset' in server console and follow instructions.\nBe careful this action cannot be undone and will reset EVERYTHING!",

	popup_ok = "OK",
	popup_cancel = "CANCEL",
	popup_continue = "CONTINUE",

	panels = {
		binds = "Keybinds",
		reset = "Reset Gamemode",
		cvars = "ConVars Editor",
	},

	binds = {
		eq_button = "Equipment",
		upgrade_tree_button = "SCP Upgrade Tree",
		ppshop_button = "Class Viewer",
		settings_button = "Gamemode Settings",
		scp_special = "SCP Special Ability"
	}
}

lang.gamemode_config = {
	loading = "Loading...",

	categories = {
		general = "General",
		round = "Round",
		xp = "XP",
		support = "Support",
		warheads = "Warheads",
		afk = "AFK",
		time = "Time",
		premium = "Premium",
		scp = "SCP",
	}
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Unconnected"

lang.scoreboard = {
	name = "Scoreboard",
	playername = "Name",
	ping = "Ping",
	prestige = "Prestige",
	level = "Level",
	score = "Score",
	ranks = "Ranks",
}

lang.ranks = {
	author = "Author",
	vip = "VIP",
	tester = "Tester",
	contributor = "Contributor",
	translator = "Translator",
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
	tree = "%s UPGRADE TREE",
	points = "Points",
	cost = "Cost",
	owned = "Owned",
	requiresall = "Requires",
	requiresany = "Requires any",
	blocked = "Blocked by"
}

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
local scp_hud = {}
lang.SCPHUD = scp_hud

scp_hud.skill_not_ready = "Skill is not ready yet!"
scp_hud.skill_cant_use = "Skill can't be used now!"

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "Subject",
	class = "Class",
	team = "Team",
	status = "Status",
	objectives = "Objectives",
	details = "Details",
	registry_failed = "info_screen_registry failed"
}

lang.info_screen_registry = {
	escape_time = "You escaped in %s minutes",
	escape_xp = "You received %s experience",
	escape1 = "You escaped from facility",
	escape2 = "You escaped during warhead countdown",
	escape3 = "You survived in blast shelter",
	escorted = "You have been escorted",
	killed_by = "You have been killed by: %s",
	suicide = "You've commited suicide",
	unknown = "Cause of your death is unknown",
	hazard = "You have been killed by hazard",
	alpha_mia = "Last known location: Surface",
	omega_mia = "Last known location: Facility",
}

lang.info_screen_type = {
	alive = "Alive",
	escaped = "Escaped",
	dead = "Deceased",
	mia = "Missed in action",
	unknown = "Unknown",
}

lang.info_screen_macro = {
	time = function( args )
		local t = tonumber( args[1] )
		return t and string.ToMinutesSeconds( t ) or "--:--"
	end
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "Nothing"
lang.exit = "Exit"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "Gamemode Content",
	msg = [[It looks like you don't have some addons. It may cause errors like missing content (textures/models/sounds) and may break your gameplay experience.
You don't have %i addons out of %i. Would you like to download it now? (you can either download it through game or do it manually on workshop page)]],
	no = "No",
	download = "Download now",
	workshop = "Show workshop page",
	downloading = "Downloading",
	mounting = "Mounting",
	idle = "Waiting for download...",
	processing = "Processing addon: %s\nStatus: %s",
	cancel = "Cancel"
}

misc.omega_warhead = {
	idle = "OMEGA Warhead is idle\n\nWaiting for input...",
	waiting = "OMEGA Warhead is idle\n\nInput accepted!\nWaiting for second input...",
	failed = "OMEGA Warhead is locked\n\nNo second input detected!\nWait %is",
	no_remote = "OMEGA Warhead failed\n\nFailed to establish connection to warhead!\t",
	active = "OMEGA Warhead is engaged\n\nProceed to evacuation immediately!\nDetonation in %.2fs",
}

misc.alpha_warhead = {
	idle = "ALPHA Warhead is idle\n\nWaiting for nuclear codes...",
	ready = "ALPHA Warhead is idle\n\nCodes accepted!\nWaiting for activation...",
	no_remote = "ALPHA Warhead failed\n\nFailed to establish connection to warhead!\t",
	active = "ALPHA Warhead is engaged\n\nProceed to evacuation immediately!\nDetonation in %.2fs",
}

misc.buttons = {
	MOUSE1 = "LMB",
	MOUSE2 = "RMB",
	MOUSE3 = "MMB",
}
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
vest.fire = "Fireproof Vest"
vest.electro = "Electroproof Vest"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Fire Damage"
dmg.SHOCK = "Electrical Damage"
dmg.BULLET = "Bullet Damage"
dmg.FALL = "Fall Damage"

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "Spectators"
teams.CLASSD = "Class D"
teams.SCI = "Scientists"
teams.MTF = "MTF"
teams.CI = "CI"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "Unknown"

classes.SCP023 = "SCP 023"
classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
classes.SCP058 = "SCP 058"
classes.SCP066 = "SCP 066"
classes.SCP096 = "SCP 096"
classes.SCP106 = "SCP 106"
classes.SCP173 = "SCP 173"
classes.SCP457 = "SCP 457"
classes.SCP682 = "SCP 682"
classes.SCP8602 = "SCP 860-2"
classes.SCP939 = "SCP 939"
classes.SCP966 = "SCP 966"
classes.SCP3199 = "SCP 3199"
classes.SCP24273 = "SCP 2427-3"

classes.classd = "Class D"
classes.veterand = "Class D Veteran"
classes.kleptod = "Class D Kleptomaniac"
classes.ciagent = "CI Agent"

classes.sciassistant = "Scientist Assistant"
classes.sci = "Scientist"
classes.seniorsci = "Senior Scientist"
classes.headsci = "Head Scientist"

classes.guard = "Security Guard"
classes.chief = "Security Chief"
classes.lightguard = "Light Security Guard"
classes.heavyguard = "Heavy Security Guard"
classes.specguard = "Security Guard Specialist"
classes.guardmedic = "Security Guard Medic"
classes.tech = "Security Guard Technician"
classes.cispy = "CI Spy"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Shotgun"
classes.ntf_3 = "MTF NTF - Rifle"
classes.ntfcom = "MTF NTF Commander"
classes.ntfsniper = "MTF NTF Sniper"
classes.ntfmedic = "MTF NTF Medic"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Marksman"
classes.ci = "Chaos Insurgency"
classes.cicom = "Chaos Insurgency Commander"

local classes_id = {}
lang.CLASSES_ID = classes_id

classes_id.ntf_1 = "MTF NTF"
classes_id.ntf_2 = "MTF NTF"
classes_id.ntf_3 = "MTF NTF"

--[[-------------------------------------------------------------------------
Class Info - NOTE: Each line is limited to 48 characters!
Screen is designed to hold max of 5 lines of text and THERE IS NO internal protection!
Note that last (5th) line should be shorter to prevent text overlaping (about 38 characters)
---------------------------------------------------------------------------]]
local generic_classd = [[- Escape from the facility
- Avoid staff and SCP objects
- Cooperate with others]]

local generic_sci = [[- Escape from the facility
- Avoid Class D and SCP objects
- Cooperate with guards and MTFs]]

local generic_guard = [[- Rescue scientists
- Terminate all Class D and SCPs
- Listen to your supervisor]]

local generic_ntf = [[- Get to the facility
- Help the remaining staff inside
- Don't let Class D and SCPs escape]]

local generic_scp = [[- Escape from the facility
- Kill everyone you meet
- Cooperate with other SCPs]]

local generic_scp_friendly = [[- Escape from the facility
- You may cooperate with humans
- Cooperate with other SCPs]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	ciagent = [[- Escort Class D memebers
- Avoid staff and SCP objects
- Cooperate with others]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Rescue scientists
- Terminate all Class D and SCPs
- Give orders to other guards]],

	guardmedic = [[- Rescue scientists
- Terminate all Class D and SCPs
- Support other guards with your medkit]],

	tech = [[- Rescue scientists
- Terminate all Class D and SCPs
- Support other guards with your turret]],

	cispy = [[- Pretend to be a guard
- Help remaining Class D Personnel
- Sabotage security actions]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- Help the remaining staff inside
- Support other NTFs with your medkit
- Don't let Class D and SCPs escape]],

	ntfcom = [[- Help the remaining staff inside
- Don't let Class D and SCPs escape
- Give orders to other NTFs]],

	ntfsniper = [[- Help the remaining staff inside
- Don't let Class D and SCPs escape
- Protect your team from behind]],

	alpha1 = [[- Protect foundation at all cost
- Stop SCPs and Class D
- You are authorized to ]].."[REDACTED]",

	alpha1sniper = [[- Protect foundation at all cost
- Stop SCPs and Class D
- You are authorized to ]].."[REDACTED]",

	ci = [[- Help Class D Personnel
- Eliminate all facility staff
- Listen to your supervisor]],

	cicom = [[- Help Class D Personnel
- Eliminate all facility staff
- Give orders to other CIs]],

	SCP023 = generic_scp,

	SCP049 = [[- Escape from the facility
- Cooperate with other SCPs
- Cure people]],

	SCP0492 = [[]],

	SCP066 = generic_scp_friendly,

	SCP058 = generic_scp,

	SCP096 = generic_scp,

	SCP106 = generic_scp,

	SCP173 = generic_scp,

	SCP457 = generic_scp,

	SCP682 = generic_scp,

	SCP8602 = generic_scp,

	SCP939 = generic_scp,

	SCP966 = generic_scp,

	SCP24273 = generic_scp,

	SCP3199 = generic_scp,
}

lang.CLASS_DESCRIPTION = {
	classd = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Basic class. Cooperate with others to face SCPs and facility staff. You can be escorted by CI memebers.
]],

	veterand = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
More advanced class. You have basic access in facility. Cooperate with others to face SCPs and facility staff. You can be escorted by CI memebers.
]],

	kleptod = [[Difficulty: Hard
Toughness: Low
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
High utility class. Starts with one random item. Cooperate with others to face SCPs and facility staff. You can be escorted by CI memebers.
]],

	ciagent = [[Difficulty: Medium
Toughness: Very High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Armed with taser CI unit. Provide help to Class D and cooperate with them. You can escort Class D memebers.
]],

	sciassistant = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
Basic class. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs memebers.
]],

	sci = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs memebers.
]],

	seniorsci = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists. You have higher access level. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs memebers.
]],

	headsci = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
Best of the scientists. You have higher utility and HP. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs memebers.
]],

	guard = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
Basic security guard. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	lightguard = [[Difficulty: Hard
Toughness: Low
Agility: Very High
Combat potential: Low
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. High utility, no armor and lower health. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	heavyguard = [[Difficulty: Medium
Toughness: High
Agility: Low
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Lower utility, better armor and higher health. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	specguard = [[Difficulty: Hard
Toughness: High
Agility: Low
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Not so high utility, higher health and strong combat potential. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	chief = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Slightly better combat potential, has taser. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	guardmedic = [[Difficulty: Hard
Toughness: High
Agility: High
Combat potential: Low
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. You have medkit and taser. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	tech = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Has placeable turret, with 3 fire modes (Hold E on turret to see its menu). Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	cispy = [[Difficulty: Very Hard
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
CI spy. High utility. Try to blend in Security Guards and help Class D.
]],

	ntf_1 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with SMG. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntf_2 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with shotgun. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntf_3 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntfmedic = [[Difficulty: Hard
Toughness: High
Agility: High
Combat potential: Low
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with pistol, has medkit. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntfcom = [[Difficulty: Hard
Toughness: High
Agility: Very High
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with marksman rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntfsniper = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with sniper rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1 = [[Difficulty: Medium
Toughness: Extreme
Agility: Very High
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavly armored, high utility unit, armed with rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1sniper = [[Difficulty: Hard
Toughness: Very High
Agility: Very High
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavly armored, high utility unit, armed with marksman rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ci = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff.
]],

	cicom = [[Difficulty: Medium
Toughness: Very High
Agility: High
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Higher combat potential. Get into facility, help Class D and kill facility staff.
]],

	SCP023 = [[Difficulty: Hard
Toughness: Low
Agility: High
Damage: Instant Death

Overview:
You can walk through walls. If someone sees you, they will be put on your list. Once in a while you teleport to one player on list and burn them to death. You can place your clone.
]],

	SCP049 = [[Difficulty: Hard
Toughness: Low
Agility: High
Damage: Instant Death after 3 attacks

Overview:
Attack player 3 times to kill them. You can create zombies out of bodies (reload key).
]],

	SCP0492 = [[]],

	SCP066 = [[Difficulty: Medium
Toughness: High
Agility: Normal
Damage: Low / AoE

Overview:
You play very loud music damaging all players near you.
]],

	SCP058 = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Damage: Normal

Overview:
SCP with flexible playstyle. Can attack melee and shot. Has various upgrades which can add poison to attacks, modify shot attack or unlocks ability to explode.
]],

	SCP096 = [[Difficulty: Hard
Toughness: High
Agility: Very Low / Extreme when enraged
Damage: Instant Death

Overview:
If someone sees you, you will become enraged. While in rage, you run extremely fast and you can kill your targets.
]],

	SCP106 = [[Difficulty: Medium
Toughness: Normal
Agility: Low
Damage: Medium / Instant death in Pocket Dimension

Overview:
You can walk through walls. Attack somebody to teleport them to pocket dimension. While in pocket dimension you instantly kill your targets.
]],

	SCP173 = [[Difficulty: Easy
Toughness: Extreme
Agility: Super Extreme
Damage: Instant Death

Overview:
You are extremely fast, but you can't move if someone sees you. You automatically kill nearby players. You can use special attack to teleport to one player in range.
]],

	SCP457 = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Damage: Medium / Fire can spread

Overview:
You are burning and you can burn nearby players. You can also place traps that activate when someone steps on them.
]],

	SCP682 = [[Difficulty: Hard
Toughness: Super Extreme
Agility: Normal
Damage: High

Overview:
Extremely tough and deadly. Use special ability to gain damage immunity for short period of time.
]],

	SCP8602 = [[Difficulty: Medium
Toughness: High
Agility: High
Damage: Low / High (strong attack)

Overview:
If someone is near a wall, you can pin them against this wall, dealing massive damage to them. You will also lose some health.
]],

	SCP939 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Damage: Medium

Overview:
You leave trail of invisible, toxic cloud. Intoxicated players can't use LMB and RMB.
]],

	SCP966 = [[Difficulty: Medium
Toughness: Low
Agility: High
Damage: Low / Bleeding

Overview:
You are invisible. Your attacks always inflict bleeding.
]],

	SCP24273 = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Damage: High / Instant death during Mind Control

Overview:
You can dash forward to deal damage to first hit player. Special ability allows you to control other player for a short time. Bringing controlled player to you, will allow you to kill him instantly. Commiting suicide while controlling player will cause health loss.
]],

	SCP3199 = [[Difficulty: Very Hard
Toughness: Low
Agility: Very High
Damage: Low / Medium

Overview:
Attacking the player grants you frenzy and inflicts deep wounds. While in frenzy, you move slightly faster and you can see location of nearby players. Missing an attack or attacking a player who already has deep wounds, stops frenzy and applies penalty. Having at least 5 frenzy tokens allows you to use special attack. Special attack kills player after short preparation.
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "Extra Vision",
		info = "Brightness of your vision is increased\nDark areas will no longer stop you"
	}
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	editMode1 = "Press LMB to place spectre",
	editMode2 = "RMB - cancel, R - Rotate",
	preys = "Available preys: %i",
	attack = "Next attack: %s",
	trapActive = "Trap is active!",
	trapInactive = "Press RMB to place trap",
	upgrades = {
		attack1 = {
			name = "Lust I",
			info = "Your attack cooldown is reduced by 20 seconds",
		},
		attack2 = {
			name = "Lust II",
			info = "Your attack cooldown is reduced by 20 seconds\n\t• Total cooldown: 40s",
		},
		attack3 = {
			name = "Lust III",
			info = "Your attack cooldown is reduced by 20 seconds\n\t• Total cooldown: 60s",
		},
		trap1 = {
			name = "Bad Omen I",
			info = "Your trap cooldown is reduced to 40 seconds",
		},
		trap2 = {
			name = "Bad Omen II",
			info = "Your trap cooldown is reduced to 20 seconds\nSpectre travel distance is increased by 25 units",
		},
		trap3 = {
			name = "Bad Omen III",
			info = "Spectre travel distance is increased by 25 units\n\t• Total increase: 50 units",
		},
		hp = {
			name = "Alpha male I",
			info = "You gain 1000 HP (also maximum HP) and 10% bullet protection, but trap cooldown is increased by 30 seconds",
		},
		speed = {
			name = "Alpha male II",
			info = "You gain 10% movement speed and additional 15% bullet protection, but trap cooldown is increased by 30 seconds\n\t• Total protection: 25%, total cooldown increase: 60s",
		},
		alt = {
			name = "Alpha male III",
			info = "Your attack cooldown is reduced by 30 seconds and you gain 15% bullet protection, but you can no longer use your trap\n\t• Total protection: 40%",
		},
	}
}

wep.SCP049 = {
	surgery = "Performing surgery",
	surgery_failed = "Surgery failed!",
	zombies = {
		normal = "Standard Zombie",
		light = "Light Zombie",
		heavy = "Heavy Zombie"
	},
	upgrades = {
		cure1 = {
			name = "I am the Cure I",
			info = "Get 40% bullet protection",
		},
		cure2 = {
			name = "I am the Cure II",
			info = "Recover 300HP every 180 seconds",
		},
		merci = {
			name = "Act of Mercy",
			info = "Primary attack cooldown is reduced by 2.5 seconds\nYou no longer apply the 'Door Lock' effect to nearby humans",
		},
		symbiosis1 = {
			name = "Symbiosis I",
			info = "After performing surgery, you are healed by 10% of your maximum health",
		},
		symbiosis2 = {
			name = "Symbiosis II",
			info = "After performing surgery, you are healed by 15% of your maximum health\nNearby SCP 049-2 instances are healed by 10% of their maximum health",
		},
		symbiosis3 = {
			name = "Symbiosis III",
			info = "After performing surgery, you are healed by 20% of your maximum health\nNearby SCP 049-2 instances are healed by 20% of their maximum health",
		},
		hidden = {
			name = "Hidden Potential",
			info = "You gain 1 token for every successful surgery\nEach token increases HP of zombies by 5%\n\t• This ability only affects newly created zombies",
		},
		trans = {
			name = "Transfusion",
			info = "Your zombies have their HP increased by 15%\nYour zombies gain 20% of life steal\n\t• This ability only affects newly created zombies",
		},
		rm = {
			name = "Radical Therapy",
			info = "Whenever it's possible, you create 2 zombies from 1 body\n\t• If only 1 spectator is available, you create only 1 zombie\n\t• Both zombies are of the same type\n\t• Second zombie has HP reduced by 50%\n\t• Second zombie has damage reduced by 25%",
		},
		doc1 = {
			name = "Surgical Precision I",
			info = "Surgery time is reduced by 5s",
		},
		doc2 = {
			name = "Surgical Precision II",
			info = "Surgery time is reduced by 5s\n\t• Total surgery time reduction: 10s",
		},
	}
}

wep.SCP0492 = {
	too_far = "You are becoming weaker!"
}

wep.SCP066 = {
	wait = "Next attack: %is",
	ready = "Attack is ready!",
	chargecd = "Dash cooldown: %is",
	upgrades = {
		range1 = {
			name = "Resonance I",
			info = "Damage radius is increased by 75",
		},
		range2 = {
			name = "Resonance II",
			info = "Damage radius is increased by 75\n\t• Total increase: 150",
		},
		range3 = {
			name = "Resonance III",
			info = "Damage radius is increased by 75\n\t• Total increase: 225",
		},
		damage1 = {
			name = "Bass I",
			info = "Damage is increased to 112.5%, but radius is reduced to 90%",
		},
		damage2 = {
			name = "Bass II",
			info = "Damage is increased to 135%, but radius is reduced to 75%",
		},
		damage3 = {
			name = "Bass III",
			info = "Damage is increased to 200%, but radius is reduced to 50%",
		},
		def1 = {
			name = "Negation Wave I",
			info = "While playing music, you negate 10% of incoming damage",
		},
		def2 = {
			name = "Negation Wave II",
			info = "While playing music, you negate 25% of incoming damage",
		},
		charge = {
			name = "Dash",
			info = "Unlocks ability to dash forward by pressing reload key\n\t• Ability cooldown: 20s",
		},
		sticky = {
			name = "Sticky",
			info = "After dashing into human, you stick to him for the next 10s",
		}
	}
}

wep.SCP058 = {
	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Poisonous Sting I",
			info = "Adds poison to primary attacks"
		},
		attack2 = {
			name = "Poisonous Sting II",
			info = "Buffs attack damage, poison damage and decreases cooldown.\n\t• Adds [prim_dmg] damage to attacks\n\t• Attack poison deals [pp_dmg] damage\n\t• Cooldown is reduced by [prim_cd]s"
		},
		attack3 = {
			name = "Poisonous Sting III",
			info = "Buffs poison damage and decreases cooldown.\n\t• If target is not poisoned, instantly apply 2 stacks of poison\n\t• Attack poison deals [pp_dmg] damage\n\t• Cooldown is reduced by [prim_cd]s"
		},
		shot = {
			name = "Corrupted Blood",
			info = "Adds poison to shot attacks"
		},
		shot11 = {
			name = "Surge I",
			info = "Increases damage and projectile size but also increases cooldown and slows down projectile\n\t• Projectile damage multiplier: [shot_damage]\n\t• Projectile size multiplier: [shot_size]\n\t• Projectile speed multiplier: [shot_size]\n\t• Total cooldown increased by [shot_cd]s"
		},
		shot12 = {
			name = "Surge II",
			info = "Increases damage and projectile size but also increases cooldown and slows down projectile\n\t• Poison effect is removed\n\t• Projectile damage multiplier: [shot_damage]\n\t• Projectile size multiplier: [shot_size]\n\t• Projectile speed multiplier: [shot_size]\n\t• Total cooldown increased by [shot_cd]s"
		},
		shot21 = {
			name = "Bloody Mist I",
			info = "Shot leaves mist on impact, hurting and poisoning everyone who touches it.\n\t• Direct and splash damage is removed\n\t• Cloud deals [cloud_damage] damage on contact\n\t• Poison inflicted by cloud deals [sp_dmg] damage\n\t• Shot stacks limited to [stacks]\n\t• Cooldown increased by [shot_cd]s\n\t• Stacks are generated at [regen_rate] rate"
		},
		shot22 = {
			name = "Bloody Mist II",
			info = "Buffs mist left by shots.\n\t• Cloud deals [cloud_damage] damage on contact\n\t• Poison inflicted by cloud deals [sp_dmg] damage\n\t• Stacks are generated at [regen_rate] rate"
		},
		shot31 = {
			name = "Multishot I",
			info = "Allows you to shot at rapid speed while holding attack button.\n\t• Unlock ability of rapid shoting\n\t• Direct and splash damage is removed\n\t• Shot stacks limited to [stacks]\n\t• Stacks are generated at [regen_rate] rate\n\t• Projectile size multiplier: [shot_size]\n\t• Projectile speed multiplier: [shot_size]"
		},
		shot32 = {
			name = "Multishot II",
			info = "Increases maximum stacks and buffs shot speed.\n\t• Shot stacks limited to [stacks]\n\t• Stacks are generated at [regen_rate] rate\n\t• Projectile size multiplier: [shot_size]\n\t• Projectile speed multiplier: [shot_size]"
		},
		exp1 = {
			name = "Aortal Burst",
			info = "Unlocks ability to explode dealing massive damage when your hp decreases below each 1000 for the first time"
		},
		exp2 = {
			name = "Toxic Blast",
			info = "Buffs your ability to explode\n\t• Applies 2 stacks of poison\n\t• Radius multiplier: [explosion_radius]"
		},
	}
}

wep.SCP096 = {
	charges = "Regeneration charges: %i",
	regen = "Regenerating HP - charges: %i",
	upgrades = {
		sregen1 = {
			name = "Calm Spirit I",
			info = "You gain one regenration charge each 4 seconds instead of 5 seconds"
		},
		sregen2 = {
			name = "Calm Spirit II",
			info = "Your regeneration charges heal you for 6 HP instead of 5 HP"
		},
		sregen3 = {
			name = "Calm Spirit III",
			info = "Your regeneration rate is 66% faster"
		},
		kregen1 = {
			name = "Hannibal I",
			info = "You regenerate additional 90 HP for successful kill"
		},
		kregen2 = {
			name = "Hannibal II",
			info = "You regenerate additional 90 HP for successful kill\n\t• Total heal increase: 180HP"
		},
		hunt1 = {
			name = "Shy I",
			info = "Hunting area is increased to 4250 units"
		},
		hunt2 = {
			name = "Shy II",
			info = "Hunting area is increased to 5500 units"
		},
		hp = {
			name = "Goliath",
			info = "Your maximum health is increased to 4000 HP\n\t• Your current health is not increased"
		},
		def = {
			name = "Persistent",
			info = "You gain 30% bullet protection"
		}
	}
}

wep.SCP106 = {
	swait = "Special ability cooldown: %is",
	sready = "Special ability is ready!",
	upgrades = {
		cd1 = {
			name = "Void Walk I",
			info = "Special ability cooldown is reduced by 15s"
		},
		cd2 = {
			name = "Void Walk II",
			info = "Special ability cooldown is reduced by 15s\n\t• Total cooldown: 30s"
		},
		cd3 = {
			name = "Void Walk III",
			info = "Special ability cooldown is reduced by 15s\n\t• Total cooldown: 45s"
		},
		tpdmg1 = {
			name = "Decaying Touch I",
			info = "After teleport gain 15 additional damage for 10s"
		},
		tpdmg2 = {
			name = "Decaying Touch II",
			info = "After teleport gain 20 additional damage for 20s"
		},
		tpdmg3 = {
			name = "Decaying Touch III",
			info = "After teleport gain 25 additional damage for 30s"
		},
		tank1 = {
			name = "Pocket Shield I",
			info = "Get 20% bullet damage protection, but you will be 10% slower"
		},
		tank2 = {
			name = "Pocket Shield II",
			info = "Get 20% bullet damage protection, but you will be 10% slower\n\t• Total protection: 40%\n\t• Total slow: 20%"
		},
	}
}

wep.SCP173 = {
	swait = "Special ability cooldown: %is",
	sready = "Special ability is ready!",
	upgrades = {
		specdist1 = {
			name = "Wraith I",
			info = "Your special ability distance is increased by 500"
		},
		specdist2 = {
			name = "Wraith II",
			info = "Your special ability distance is increased by 700\n\t• Total increase: 1200"
		},
		specdist3 = {
			name = "Wraith III",
			info = "Your special ability distance is increased by 800\n\t• Total increase: 2000"
		},
		boost1 = {
			name = "Bloodthirster I",
			info = "Each time you kill human you will gain 150 HP and your special ability cooldown will be decreased by 10%"
		},
		boost2 = {
			name = "Bloodthirster II",
			info = "Each time you kill human you will gain 300 HP and your special ability cooldown will be decreased by 25%"
		},
		boost3 = {
			name = "Bloodthirster III",
			info = "Each time you kill human you will gain 500 HP and your special ability cooldown will be decreased by 50%"
		},
		prot1 = {
			name = "Concrete Skin I",
			info = "Instantly heal 1000 HP and get 10% protection against bullet wounds"
		},
		prot2 = {
			name = "Concrete Skin II",
			info = "Instantly heal 1000 HP and get 10% protection against bullet wounds\n\t• Total protection: 20%"
		},
		prot3 = {
			name = "Concrete Skin III",
			info = "Instantly heal 1000 HP and get 20% protection against bullet wounds\n\t• Total protection: 40%"
		},
	},
	back = "You can hold R to back to previous position",
}

wep.SCP457 = {
	swait = "Special ability cooldown: %is",
	sready = "Special ability is ready!",
	placed = "Active traps: %i/%i",
	nohp = "Not enough HP!",
	upgrades = {
		fire1 = {
			name = "Live Torch I",
			info = "Your burn radius is increased by 25"
		},
		fire2 = {
			name = "Live Torch II",
			info = "Your burn damage is increased by 0.5"
		},
		fire3 = {
			name = "Live Torch III",
			info = "Your burn radius is increased by 50 and your burn damage is increased by 0.5\n\t• Total radius increase: 75\n\t• Total damage increase: 1"
		},
		trap1 = {
			name = "Little Surprise I",
			info = "Trap lifetime is increased to 4 minutes and will burn 1s longer"
		},
		trap2 = {
			name = "Little Surprise II",
			info = "Trap lifetime is increased to 5 minutes and will burn 1s longer and its damage is increased by 0.5\n\t• Total burn time increase: 2s"
		},
		trap3 = {
			name = "Little Surprise III",
			info = "Trap will burn 1s longer and its damage is increased by 0.5\n\t• Total burn time increase: 3s\n\t• Total damage increase: 1"
		},
		heal1 = {
			name = "Sizzling Snack I",
			info = "Burning people will heal you for additional 1 health"
		},
		heal2 = {
			name = "Sizzling Snack II",
			info = "Burning people will heal you for additional 1 health\n\t• Total heal increase: 2"
		},
		speed = {
			name = "Fast Fire",
			info = "Your speed is increased by 10%"
		}
	}
}

wep.SCP682 = {
	swait = "Special ability cooldown: %is",
	sready = "Special ability is ready!",
	s_on = "You are immune to any damage! %is",
	upgrades = {
		time1 = {
			name = "Unbroken I",
			info = "Your special ability duration is increased by 2.5s\n\t• Total duration: 12.5s"
		},
		time2 = {
			name = "Unbroken II",
			info = "Your special ability duration is increased by 2.5s\n\t• Total duration: 15s"
		},
		time3 = {
			name = "Unbroken III",
			info = "Your special ability duration is increased by 2.5s\n\t• Total duration: 17.5s"
		},
		prot1 = {
			name = "Adaptation I",
			info = "You take 10% less bullet damage"
		},
		prot2 = {
			name = "Adaptation II",
			info = "You take 15% less bullet damage\n\t• Total damage reduction: 25%"
		},
		prot3 = {
			name = "Adaptation III",
			info = "You take 15% less bullet damage\n\t• Total damage reduction: 40%"
		},
		speed1 = {
			name = "Furious Rush I",
			info = "After using special ability, gain 10% movement speed until receiving damage"
		},
		speed2 = {
			name = "Furious Rush II",
			info = "After using special ability, gain 20% movement speed until receiving damage"
		},
		ult = {
			name = "Regeneration",
			info = "5 seconds after receiving damage, regenerate 5% of missing health"
		},
	}
}

wep.SCP8602 = {
	upgrades = {
		charge11 = {
			name = "Brutality I",
			info = "Damage of strong attack is increased by 5"
		},
		charge12 = {
			name = "Brutality II",
			info = "Damage of strong attack is increased by 10\n\t• Total damage increase: 15"
		},
		charge13 = {
			name = "Brutality III",
			info = "Damage of strong attack is increased by 10\n\t• Total damage increase: 25"
		},
		charge21 = {
			name = "Charge I",
			info = "Range of strong attack is increased by 15"
		},
		charge22 = {
			name = "Charge II",
			info = "Range of strong attack is increased by 15\n\t• Total range increase: 30"
		},
		charge31 = {
			name = "Shared Pain",
			info = "When you perform strong attack, everyone nearby impact point will receive 20% of the original damage"
		},
	}
}

wep.SCP939 = {
	upgrades = {
		heal1 = {
			name = "Bloodlust I",
			info = "Your attacks heal you for at least 22.5 HP (up to 30)"
		},
		heal2 = {
			name = "Bloodlust II",
			info = "Your attacks heal you for at least 37.5 HP (up to 50)"
		},
		heal3 = {
			name = "Bloodlust III",
			info = "Your attacks heal you for at least 52.5 HP (up to 70)"
		},
		amn1 = {
			name = "Lethal Breath I",
			info = "Your poison radius is increased to 100"
		},
		amn2 = {
			name = "Lethal Breath II",
			info = "Your poison now deals damage: 1.5 dmg/s"
		},
		amn3 = {
			name = "Lethal Breath III",
			info = "Your poison radius is increased to 125 and your poison damage is increased to 3 dmg/s"
		},
	}
}

wep.SCP966 = {
	upgrades = {
		lockon1 = {
			name = "Frenzy I",
			info = "Time required to attack is reduced to 2.5s"
		},
		lockon2 = {
			name = "Frenzy II",
			info = "Time required to attack is reduced to 2s"
		},
		dist1 = {
			name = "Call of the Hunter I",
			info = "Attack range is increased by 15"
		},
		dist2 = {
			name = "Call of the Hunter II",
			info = "Attack range is increased by 15\n\t• Total range increase: 30"
		},
		dist3 = {
			name = "Call of the Hunter III",
			info = "Attack range is increased by 15\n\t• Total range increase: 45"
		},
		dmg1 = {
			name = "Sharp Claws I",
			info = "Attack damage is increased by 5"
		},
		dmg2 = {
			name = "Sharp Claws II",
			info = "Attack damage is increased by 5\n\t• Total damage increase: 10"
		},
		bleed1 = {
			name = "Deep Wounds I",
			info = "Your attacks have 25% chance of inflicting higher tier bleeding"
		},
		bleed2 = {
			name = "Deep Wounds II",
			info = "Your attacks have 50% chance of inflicting higher tier bleeding"
		},
	}
}

wep.SCP24273 = {
	mind_control = "Mind Control is ready! Press RMB",
	mind_control_cd = "Mind Control is on cooldown! Wait: %is",
	dash = "Attack is ready!",
	dash_cd = "Attack is on cooldown! Wait: %is",
	upgrades = {
		dash1 = {
			name = "Ruthless Charge I",
			info = "Your attack cooldown is reduced by 1 second and its power is increased by 15%"
		},
		dash2 = {
			name = "Ruthless Charge II",
			info = "Penalty time after attack is reduced by 0.5 second and speed penalty is reduced from 50% to 35%"
		},
		dash3 = {
			name = "Ruthless Charge III",
			info = "Your attack damage is increased by 50"
		},
		mc11 = {
			name = "Persistent Hunter I",
			info = "Your Mind Control duration is increased by 10s, but cooldown is increased by 20s"
		},
		mc12 = {
			name = "Persistent Hunter II",
			info = "Your Mind Control duration is increased by 10s, but cooldown is increased by 25s\n\t• Total duration increase: 20s\n\t• Total cooldown increase: 45s"
		},
		mc21 = {
			name = "Impatient Hunter I",
			info = "Your Mind Control duration is reduced by 5s and cooldown is reduced by 10s"
		},
		mc22 = {
			name = "Impatient Hunter II",
			info = "Your Mind Control duration is reduced by 10s and cooldown is reduced by 15s"
		},
		mc3 = {
			name = "Unbroken Hunter",
			info = "During Mind Control gain 50% reduction for all types of damage"
		},
		mc13 = {
			name = "Strict Judge",
			info = "Killing your prey during Mind Control, reduces its cooldown by 40%. Mind Control range is increased by 1000 units"
		},
		mc23 = {
			name = "Crimson Judge",
			info = "Killing your prey during Mind Control, heals you by 400 HP. Mind Control range is increased by 500 units"
		},
	}
}

wep.SCP3199 = {
	special = "Special attack is ready! Press RMB",
	upgrades = {
		regen1 = {
			name = "Taste of Blood I",
			info = "Regenerate 2 HP per second while in Frenzy"
		},
		regen2 = {
			name = "Taste of Blood II",
			info = "Health regeneration ratio is increased by 10% for each Frenzy token"
		},
		frenzy1 = {
			name = "Hunter's Game I",
			info = "Your maximum Frenzy tokens are increased by 1\nYour Frenzy duration is increased by 20%"
		},
		frenzy2 = {
			name = "Hunter's Game II",
			info = "Your maximum Frenzy tokens are increased by 1\nYour Frenzy duration is increased by 30%\nYour special attack is disabled\n\t• Total Frenzy tokens increase: 2\n\t• Total duration increase: 50%"
		},
		ch = {
			name = "Blind Fury",
			info = "Your speed is increased by 25%\nYou can no longer detect heartbeat of nearby humans"
		},
		egg1 = {
			name = "Another One",
			info = "You create 1 new inactive egg upon buying this upgrade\n\t• Egg will not be created if there is no empty spot for egg in map"
		},
		egg2 = {
			name = "Legacy",
			info = "One of inactive eggs will be activated once this upgrade is bought\n\t• This won't have effect is there is no inactive egg on map"
		},
		egg3 = {
			name = "Easter Egg",
			info = "Your respawn time is decreased to 20 seconds"
		},
	}
}

wep.SCP500 = {
	name = "SCP 500",
	death_info = "You choked on that SCP 500",
	text_used = "You soon as you swallowed this pill, you felt better",
}

wep.SCP714 = {
	name = "SCP 714"
}

wep.SCP1025 = {
	name = "SCP 1025",
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
}

wep.ID = {
	name = "ID",
	pname = "Name:",
	server = "Server:",
}

wep.CAMERA = {
	name = "Surveillance System",
	showname = "Cameras",
	info = "Cameras allow you to see what is happening in the facility.\nThey also provide you an ability to scan SCPs and transmit this information to your current radio channel",
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
	chip = "Installed Chip: %s",
	clearance = "Clearance level: %i",
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

wep.TASER = {
	name = "Taser"
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

wep.TURRET = {
	name = "Turret",
	pickup = "Pick up",
	MODES = {
		off = "Disable",
		filter = "Filter staff",
		all = "Target everything",
		supp = "Suppressing fire"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALPHA Warhead Codes #1"
}

wep.ALPHA_CARD2 = {
	name = "ALPHA Warhead Codes #2"
}

wep.weapon_stunstick = "Stunstick"

registerLanguage( lang, "english", "en", "default" )
