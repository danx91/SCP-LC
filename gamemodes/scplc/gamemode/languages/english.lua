--[[-------------------------------------------------------------------------
Language: English
Date: 15.02.2021
Translated by: danx91 (aka ZGFueDkx)
Updated: 27.07.2024
---------------------------------------------------------------------------]]

local lang = {}

lang.self = "English" --Language name (not translated)
lang.self_en = "English" --Language name (in english)

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "You can be become SCP in the next round (%ix chance)",
	scpwait = "You have to wait %i rounds to be able to play as SCP",
	abouttostart = "Game will start in %i seconds!",
	kill = "You received %d points for killing %s: %s!",
	kill_n = "You killed %s: %s!",
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
	explodeterminated = "Gate A explosion has been terminated",
	r106used = "SCP-106 recontain procedure can be triggered only once per round",
	r106eloiid = "Power down ELO-IID electromagnet in order to start SCP-106 recontain procedure",
	r106sound = "Enable sound transmission in order to start SCP-106 recontain procedure",
	r106human = "Alive human is required in cage in order to start SCP-106 recontain procedure",
	r106already = "SCP-106 is already recontained",
	r106success = "You received %i points for recontaining SCP-106!",
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
	omega_detonation = "OMEGA Warhead detonation in %i seconds. Get on the surface or proceed to the blast shelter immediately!",
	alpha_detonation = "ALPHA Warhead detonation in %i seconds. Get in the facility or proceed to the evacuation immediately!",
	alpha_card = "You've inserted ALPHA Warhead nuclear card",
	destory_scp = "You received %i points for destroying SCP object!",
	afk = "You are AFK. You will not spawn and receive XP over time!",
	afk_end = "You are no longer AFK",
	overload_cooldown = "Wait %i seconds to overload this door!",
	advanced_overload = "This door seems to be stronger! Try again in %i seconds",
	lockdown_once = "Facility lockdown can be activated only once per round!",
	dailybonus = "Remaining daily bonus: %i XP\nNext reset in: %s",
	xp_goc_device = "You received %i XP for successfully deploying a GOC device!",
	goc_device_destroyed = "You received %i points for destroying GOC device!",
	goc_detonation = "OMEGA and ALPHA Warhead detonation in %i seconds. Proceed to the evacuation or enter the blast shelter immediately!",
	fuserating = "You need a fuse with a higher rating!",
	nofuse = "You need a fuse to use this device",
	cantremfuse = "Fuse is overheating - it's too hot to remove!",
	fusebroken = "Fuse is broken and it's welded in place!",
	nopower = "You've pressed the button, but nothing happened...",
	nopower_omni = "You've put omnitool to the reader, but nothing happened...",
	docs = "You received %i points for escaping with %i document(s)",
	docs_pick = "You obtained valuable documents of SCP Foundation - escape with it to get reward!",
	gaswarn = "%s decontamination in 60 seconds",
	queue_alive = "You are alive",
	queue_not = "You are not in the support queue!",
	queue_low = "You are in the low priority support queue!",
	queue_pos = "Your position in the support queue: %i",
	support_optout = "You didn't spawn as support because you opted out. You can change that in !settings",
	zombie_optout = "You didn't spawn as SCP-049-2 because you opted out. You can change that in !settings",
	preparing_classd = "You were spawned as a Class D because you've joined during preparing. You can change that in !settings",
	property_dmg = "You lost %d points for destroying Foundation property!",
	unknown_cmd = "Unknown command: %s",
	tailor_success = "You successfully stole an ID. Be careful, it will expire soon!",
	tailor_fail = "You wasn't able to find a valid ID on the body!",
	tailor_end = "Your stolen ID expired!",
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
	stat_106recontain = "SCP-106 has been recontained",
	stat_escapes = "Escaped players: %i",
	stat_escorts = "Players escorted: %i",
	stat_023 = "Players killed by SCP-023: %i",
	stat_049 = "Players cured by SCP-049: %i",
	stat_0492 = "Players mauled by zombies: %i",
	stat_058 = "Players killed by SCP-058: %i",
	stat_066 = "Masterpieces played by SCP-066: %i",
	stat_096 = "Players killed by shy guy: %i",
	stat_106 = "Players teleported to Pocket Dimension: %i",
	stat_173 = "Snapped necks: %i",
	stat_457 = "Players burned alive: %i",
	stat_682 = "Players killed by overgrown reptile: %i",
	stat_8602 = "Players killed by SCP-860-2: %i",
	stat_939 = "SCP-939 preys: %i",
	stat_966 = "Players put to sleep: %i",
	stat_3199 = "Assassinations by SCP-3199: %i",
	stat_24273 = "People judged by SCP-2427-3: %i",
	stat_omega_warhead = "Omega warhead has been detonated",
	stat_alpha_warhead = "Alpha warhead has been detonated",
	stat_goc_warhead = "GOC device was activated",
}

lang.NCFailed = "Failed to access NCRegistry with key: %s"

--[[-------------------------------------------------------------------------
Main menu
---------------------------------------------------------------------------]]
local main_menu = {}
lang.MenuScreen = main_menu

main_menu.start = "Start"
main_menu.settings = "Settings"
main_menu.precache = "Precache models"
main_menu.credits = "Credits"
main_menu.quit = "Quit"

main_menu.quit_server = "Quit server?"
main_menu.quit_server_confirmation = "Are you sure?"
main_menu.model_precache = "Precache models"
main_menu.model_precache_text = "Models are precached automatically when it's required, but it happens during gameplay so it may cause lag spikes. To avoid it, you can precache them now manually.\nYor game can freeze during this process!"
main_menu.yes = "Yes"
main_menu.no = "No"
main_menu.all = "Precache models"
main_menu.cancel = "Cancel"


main_menu.credits_text = [[Gamemode created by ZGFueDkx (aka danx91)
Gamemode is based on SCP and released under CC BY-SA 3.0 license

Menu animations are created by Madow

Models:
	Alski - guards, omnitool, turret and more
	Slusher - SCP-689, doors, tablet and more

Materials:
	Foer - Workshop logo and few other graphics
	SCP Containment Breach

Sounds:
	SCP Containment Breach

Main translators:
	Chinese - xiaobai
	German - Justinnn
	Korean - joon00
	Polish - Slusher, Alski
	Russian - Deiryn, berry
	Turkish - Akane

Special thanks:
	1000 Shells for help with models
	PolishLizard for hosting test server
]]
--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "Pick up"
hud.class = "Class"
hud.team = "Team"
hud.class_points = "Class Unlock Points"
hud.prestige_points = "Prestige Points"
hud.hp = "HP"
hud.stamina = "STAMINA"
hud.sanity = "SANITY"
hud.xp = "XP"
hud.extra_hp = "Extra HP"

hud.escaping = "Escaping..."
hud.escape_blocked = "Escape Blocked!"
hud.waiting = "Waiting for players"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
local eq = {}
lang.EQ = eq

eq.eq = "Equipment"
eq.actions = "Actions"
eq.backpack = "Backpack"
eq.id = "This is your ID, show it to others to reveal your class and team"
eq.no_id = "You don't have ID"
eq.class = "Your class: "
eq.team = "Your team: "
eq.p_class = "Your fake class: "
eq.p_team = "Your fake team: "
eq.allies = "Your allies:"
eq.durability = "Durability: "
eq.mobility = "Mobility: "
eq.weight = "Weight: "
eq.weight_unit = "KG"
eq.multiplier = "Damage multiplier:"
eq.count = "Count"

lang.eq_unknown = "Unknown item"
lang.durability = "Durability"
lang.info = "Information"

lang.eq_buttons = {
	escort = "Escort",
	gatea = "Destroy Gate A"
}

lang.pickup_msg = {
	max_eq = "Your EQ is full!",
	cant_stack = "You can't carry more of this item!",
	has_already = "You already have this item!",
	same_type = "You already has item of the same type!",
	one_weapon = "You can carry only one firearm at the time!",
	goc_only = "Only GOC members can pick this up!"
}

--[[-------------------------------------------------------------------------
XP Bar
---------------------------------------------------------------------------]]
lang.XP_BAR = {
	general = "General experience",
	round = "Staying on this server",
	escape = "Escape from the facility",
	score = "Score earned during round",
	win = "Winning the round",
	vip = "VIP bonus",
	daily = "Daily bonus",
	cmd = "Divine power",
}

--[[-------------------------------------------------------------------------
AFK Warning
---------------------------------------------------------------------------]]
lang.AFK = {
	afk = "You are AFK!",
	afk_warn = "AFK Warning",
	slay_warn = "You are about to be slayed and marked as AFK!",
	afk_msg = "You won't spawn or receive XP over time!",
	afk_action = "-- Press any button to become active --",
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
effects.poison = "Poison"
effects.heavy_bleeding = "Heavy Bleeding"
effects.light_bleeding = "Light Bleeding"
effects.spawn_protection = "Spawn Protection"
effects.fracture = "Fracture"
effects.decay = "Decay"
effects.scp_chase = "Chase"
effects.human_chase = "Chase"
effects.expd_all = "Experimental Effect"
effects.expd_recovery = "Recovery"
effects.electrical_shock = "Electrical Shock"
effects.scp009 = "SCP-009"
effects.scp106_withering = "Withering"
effects.scp966_effect = "Fatigue"
effects.scp966_mark = "Death Mark"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Class Viewer"
lang.preview = "Preview"
lang.random = "Random"
lang.buy = "Buy"
lang.buy_prestige = "Buy - Prestige"
lang.refund = "Refund"
lang.prestige = "Prestige"
lang.prestige_warn = "You are about to prestige. This process will reset your level, XP, class unlock points and unlocked classes and you will be awarded with 1 prestige point.\n\nWARNING: This action cannot be reverted!"
lang.none = "None"
lang.refunded = "All removed classes has been refunded. You've received %d class points and %d prestige points!"
lang.tierlocked = "You have to buy every class from previous tiers in order to unlock classes in this tier (also classes from other categories)"
lang.xp = "XP"
lang.level = "Level"

lang.details = {
	details = "Details",
	prestige = "Prestige Reward",
	name = "Name",
	tier = "Tier",
	team = "Team",
	walk_speed = "Walk Speed",
	run_speed = "Run Speed",
	chip = "Access Chip",
	persona = "Fake ID",
	loadout = "Main weapon",
	weapons = "Items",
	class = "Class",
	hp = "Health",
	speed = "Speed",
	health = "Health",
	sanity = "Sanity",
	slots = "Support Slots",
	no_select = "Can't spawn in round"
}

lang.headers = {
	support = "SUPPORT",
	classes = "CLASSES",
	scp = "SCPs"
}

lang.view_cat = {
	classd = "Class D",
	sci = "Scientists",
	guard = "Security",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alpha-1",
	ci = "Chaos Insurgency",
	goc = "GOC",
}

local l_weps = {
	pistol = "pistol",
	smg = "SMG",
	rifle = "rifle",
	shotgun = "shotgun",
	sniper = "sniper",
}

local l_tiers = {
	low = "Low tier",
	mid = "Mid tier",
	high = "High tier",
}

lang.loadouts = {
	grenade = "Random grenade",
	pistol_all = "Random pistol",
	smg_all = "Random SMG",
	rifle_all = "Random rifle",
	shotgun_all = "Random shotgun",
}

for k_wep, wep in pairs( l_weps ) do
	for k_tier, tier in pairs( l_tiers ) do
		lang.loadouts[k_wep.."_"..k_tier] = tier.." "..wep
	end
end

--[[-------------------------------------------------------------------------
Settings
---------------------------------------------------------------------------]]
lang.settings = {
	settings = "Gamemode settings",

	none = "NONE",
	press_key = "> Press a key <",
	client_reset = "Reset Client Settings to Defaults",
	server_reset = "Reset Server Settings to Defaults",

	client_reset_desc = "You are about to reset your ALL settings in this gamemode.\nThis action cannot be undone!",
	server_reset_desc = "Due to security reasons you cannot reset server settings here.\nTo reset server to default settings, enter 'slc_factory_reset' in server console and follow instructions.\nBe careful this action cannot be undone and will reset EVERYTHING!",

	popup_ok = "OK",
	popup_cancel = "CANCEL",
	popup_continue = "CONTINUE",

	enabled = "Enabled",
	resource_warn = "Due to how materials work in Garry's Mod, your changes will be applied after you rejoin the server.",

	panels = {
		binds = "Keybinds",
		general_config = "General Config",
		hud_config = "HUD Config",
		performance_config = "Performance",
		scp_config = "SCP Config",
		skins = "GUI Skins",
		resource_packs = "Resource Packs",
		reset = "Reset Gamemode",
		cvars = "ConVars Editor",
	},

	binds = {
		eq_button = "Equipment",
		upgrade_tree_button = "SCP Upgrade Tree",
		ppshop_button = "Class Viewer",
		settings_button = "Gamemode Settings",
		scp_special = "SCP Special Ability"
	},

	config = {
		search_indicator = "Show search indicator",
		scp_hud_skill_time = "Show SCP skill cooldown",
		smooth_blink = "Enable smooth blink",
		scp_hud_overload_cd = "Show overload cooldown",
		any_button_close_search = "Any button closes search menu",
		hud_hitmarker = "Show hitmarkers",
		hud_hitmarker_mute = "Mute hitmarkers",
		hud_damage_indicator = "Show damage indicator",
		scp_hud_dmg_mod = "Show SCP received damage modificator",
		scp_nvmod = "Increase screen brightness when playing SCP",
		dynamic_fov = "Dynamic FOV",
		hud_draw_crosshair = "Draw crosshair",
		hud_hl2_crosshair = "Legacy HL2 crosshair",
		hud_lq = "Low quality images and polygons (if possible)",
		hud_image_poly = "Images instead of polygons (if possible)",
		hud_windowed_mode = "HUD offset (for windowed mode)",
		hud_avoid_roman = "Avoid roman digits",
		hud_escort = "Show escort zones",
		hud_timer_always = "Always show time",
		hud_stamina_always = "Always show stamina",
		eq_instant_desc = "Instant item description in EQ",
		scp106_spots = "Always show SCP-106 teleport spots",

		cvar_slc_support_optout = "Support spawn opt-out",
		cvar_slc_zombie_optout = "SCP-049-2 spawn opt-out",
		cvar_slc_preparing_classd = "Spawn as Class D if connected during preparing",
		cvar_slc_language = "Language",
		cvar_slc_language_options = {
			default = "Default",
		},
		cvar_slc_hud_scale = "HUD Scale",
		cvar_slc_hud_scale_options = {
			normal = "Normal",
			big = "Big",
			vbig = "Very big",
			small = "Small",
			vsmall = "Very small",
			imretard = "Tiny",
		},

		hud_skin_main = "Main",
		hud_skin_scoreboard = "Scoreboard",
		hud_skin_hud = "HUD",
		hud_skin_eq = "Equipment",

		hud_skin_main_options = {
			custom = "Custom",
			default = "Default",
			legacy = "Legacy",
		}
	},
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
		gas = "Gas",
		feature = "Features",
		minigames = "Minigames",
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
	level = "Level",
	score = "Score",
	ranks = "Ranks",
	badges = "Badges",
}

lang.scoreboard_actions = {
	copy_name = "Copy name",
	copy_sid = "Copy SteamID",
	copy_sid64 = "Copy SteamID64",
	open_profile = "Open Steam profile",
}

lang.ranks = {
	superadmin = "Superadmin",
	admin = "Admin",
	author = "Author",
	vip = "VIP",
	contributor = "Contributor",
	translator = "Translator",
	tester = "Tester",
	patron = "Patron",
	hunter = "Bug Hunter"
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
lang.SCPHUD = {
	skill_not_ready = "Skill is on cooldown!",
	skill_cant_use = "Skill can't be used now!",
	overload_cd = "Next overload: ",
	overload_ready = "Overload ready!",
	damage_scale = "Received damage"
}

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
	escape2 = "You escaped during ALPHA Warhead countdown",
	escape3 = "You survived in blast shelter",
	escorted = "You have been escorted",
	killed_by = "You have been killed by: %s",
	suicide = "You've committed suicide",
	unknown = "Cause of your death is unknown",
	hazard = "You have been killed by hazard",
	alpha_mia = "Last known location: Surface",
	omega_mia = "Last known location: Facility",
	scp914_death = "Your hearth was stopped by SCP-914",
	killer_t = "Your killer's team: %s"
}

lang.info_screen_type = {
	alive = "Alive",
	escaped = "Escaped",
	dead = "Deceased",
	mia = "Missed in action",
	unknown = "Unknown",
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "Nothing"
lang.exit = "Exit"
lang.default = "Default"
lang.yes = "Yes"
lang.no = "No"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.escort_zone = "Escort zone"

misc.content_checker = {
	title = "Gamemode Content",
	status = "Status",
	auto_check = "Run automatically",
	slist = {
		"Disabled",
		"Checking",
		"Mounting",
		"Downloading",
		"Done",
	},
	btn_workshop = "Workshop Collection",
	btn_download = "Download",
	btn_check = "Check & Download",
	allok = "All addons are installed!",
	nsub_warn = "You don't have some of the required addons! We downloaded and mounted them, but please download them using Steam Workshop. Check console to see which addons are missing.",
	disabled_warn = "Some of required addons are disabled! gamemode mounted it for you, but some content may still be missing. Please head to the menu and enable disabled addons (list in the console).",
	missing = "Missing addons",
	disabled = "Disabled addons",
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

misc.intercom = {
	name = "Intercom",
	idle = "Intercom is idle",
	active = "Intercom is active\n\nRemaining time: %is",
	cooldown = "Intercom is on cooldown\n\nRemaining time: %is",
}

misc.zones = {
	lcz = "LCZ",
	hcz = "HCZ",
	ez = "EZ",
}

misc.buttons = {
	MOUSE1 = "LMB",
	MOUSE2 = "RMB",
	MOUSE3 = "MMB",
}

misc.inventory = {
	unsearched = "Unsearched",
	search = "Press [%s] to search",
	unknown_chip = "Unknown chip",
	name = "Name",
	team = "Team",
	death_time = "Death time",
	time = {
		[0] = "Just now",
		"About one minute ago",
		"About two minutes ago",
		"About three minutes ago",
		"About four minutes ago",
		"About five minutes ago",
		"About six minutes ago",
		"About seven minutes ago",
		"About eight minutes ago",
		"About nine minutes ago",
		"About ten minutes ago",
		long = "More than ten minutes ago",
	},
}

misc.font = {
	name = "Fonts",
	content = [[Custom gamemode font failed to load! Falling back to system font...
It's gmod issue and I can't fix it. To fix it, you have to manually delete some files.
Navigate to 'steamapps/common/GarrysMod/garrysmod/cache/workshop/resource/fonts' and delete following files: 'impacted.ttf', 'ds-digital.ttf' and 'unispace.ttf']],
	ok = "OK"
}

misc.commands_aliases = {
	["admin"] = "adminmode",
	["daily"] = "bonus",
	["mute"] = "muteall",
	["unmute"] = "unmuteall",
	["config"] = "settings",
	["cfg"] = "settings",
	["mines"] = "minigames",
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
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.unknown = "Unknown"

teams.SPEC = "Spectators"
teams.CLASSD = "Class D"
teams.SCI = "Scientists"
teams.GUARD = "Security"
teams.MTF = "MTF"
teams.CI = "CI"
teams.GOC = "GOC"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
lang.UNK_CLASSES = { 
	CLASSD = "Unknown Class D",
	SCI = "Unknown Scientist",
	GUARD = "Unknown Guard",
	MTF = "Unknown MTF",
	CI = "Unknown CI",
	GOC = "Unknown GOC"
}

local classes = {}
lang.CLASSES = classes

classes.unknown = "Unknown"
classes.spectator = "Spectator"

classes.SCP023 = "SCP-023"
classes.SCP049 = "SCP-049"
classes.SCP0492 = "SCP-049-2"
classes.SCP058 = "SCP-058"
classes.SCP066 = "SCP-066"
classes.SCP096 = "SCP-096"
classes.SCP106 = "SCP-106"
classes.SCP173 = "SCP-173"
classes.SCP457 = "SCP-457"
classes.SCP682 = "SCP-682"
classes.SCP8602 = "SCP-860-2"
classes.SCP939 = "SCP-939"
classes.SCP966 = "SCP-966"
classes.SCP3199 = "SCP-3199"
classes.SCP24273 = "SCP-2427-3"

classes.classd = "Class D"
classes.veterand = "Class D Veteran"
classes.kleptod = "Class D Kleptomaniac"
classes.contrad = "Class D with Contraband"
classes.ciagent = "CI Agent"
classes.expd = "Experimental Class D"
classes.classd_prestige = "Class D Tailor"

classes.sciassistant = "Scientist Assistant"
classes.sci = "Scientist"
classes.seniorsci = "Senior Scientist"
classes.headsci = "Head Scientist"
classes.contspec = "Containment Specialist"
classes.sci_prestige = "Class D Escapee"

classes.guard = "Security Guard"
classes.chief = "Security Chief"
classes.lightguard = "Light Security Guard"
classes.heavyguard = "Heavy Security Guard"
classes.specguard = "Security Guard Specialist"
classes.guardmedic = "Security Guard Medic"
classes.tech = "Security Guard Technician"
classes.cispy = "CI Spy"
classes.lightcispy = "Light CI Spy"
classes.heavycispy = "Heavy CI Spy"
classes.guard_prestige = "Security Guard Engineer"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Shotgun"
classes.ntf_3 = "MTF NTF - Rifle"
classes.ntfcom = "MTF NTF Commander"
classes.ntfsniper = "MTF NTF Sniper"
classes.ntfmedic = "MTF NTF Medic"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Marksman"
classes.alpha1medic = "MTF Alpha-1 Medic"
classes.alpha1com = "MTF Alpha-1 Commander"
classes.ci = "Chaos Insurgency"
classes.cisniper = "Chaos Insurgency Marksman"
classes.cicom = "Chaos Insurgency Commander"
classes.cimedic = "Chaos Insurgency Medic"
classes.cispec = "Chaos Insurgency Specialist"
classes.ciheavy = "Chaos Insurgency Heavy Unit"
classes.goc = "GOC Soldier"
classes.gocmedic = "GOC Medic"
classes.goccom = "GOC Commander"

local classes_id = {}
lang.CLASSES_ID = classes_id

classes_id.ntf_1 = "MTF NTF"
classes_id.ntf_2 = "MTF NTF"
classes_id.ntf_3 = "MTF NTF"

--[[-------------------------------------------------------------------------
Class Info - NOTE: Each line is limited to 48 characters!
Screen is designed to hold max of 5 lines of text and THERE IS NO internal protection!
Note that last (5th) line should be shorter to prevent text overlapping (about 38 characters)
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

local generic_cispy = [[- Pretend to be a guard
- Help remaining Class D Personnel
- Sabotage security actions]]

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

	contrad = generic_classd,

	ciagent = [[- Escort Class D members
- Avoid staff and SCP objects
- Cooperate with others]],

	expd = [[- Escape from the facility
- Avoid staff and SCP objects
- You underwent some strange experiments]],

	classd_prestige = [[- Escape from the facility
- Avoid staff and SCP objects
- You can steal clothes from dead bodies]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	contspec = generic_sci,

	sci_prestige = [[- Escape from the facility
- Avoid staff and SCP objects
- You stole clothes and ID of scientist]],

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

	cispy = generic_cispy,

	lightcispy = generic_cispy,

	heavycispy = generic_cispy,

	guard_prestige = [[- Rescue scientists
- Terminate all Class D and SCPs
- You can temporarily block doors]],

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

	alpha1medic = [[- Protect foundation at all cost
- Support your unit with healing
- You are authorized to ]].."[REDACTED]",

	alpha1com = [[- Protect foundation at all cost
- Give orders to your unit
- You are authorized to ]].."[REDACTED]",

	ci = [[- Help Class D Personnel
- Eliminate all facility staff
- Listen to your supervisor]],

	cisniper = [[- Help Class D Personnel
- Eliminate all facility staff
- Protect your team from behind]],

	cicom = [[- Help Class D Personnel
- Eliminate all facility staff
- Give orders to other CIs]],

	cimedic = [[- Help Class D Personnel
- Help other CIs with your medkit
- Listen to your supervisor]],

	cispec = [[- Help Class D Personnel
- Support CIs with your turret
- Listen to your supervisor]],

	ciheavy = [[- Help Class D Personnel
- Provide covering fire
- Listen to your supervisor]],

	goc = [[- Destroy all SCPs
- Locate and deploy GOC device
- Listen to your supervisor]],

	gocmedic = [[- Destroy all SCPs
- Help GOC soldiers with your medkit
- Listen to your supervisor]],

	goccom = [[- Destroy all SCPs
- Locate and deploy GOC device
- Give orders to GOC soldiers]],

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
Basic class. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.
]],

	veterand = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
More advanced class. You have basic access in facility. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.
]],

	kleptod = [[Difficulty: Hard
Toughness: Low
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
High utility class. Starts with one random item. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.
]],

	contrad = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Class with contraband weapon. Use it wisely because this weapon isn't durable.
]],

	ciagent = [[Difficulty: Medium
Toughness: Very High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Armed with taser CI unit. Provide help to Class D and cooperate with them. You can escort Class D members.
]],

	expd = [[Difficulty: ?
Toughness: ?
Agility: ?
Combat potential: ?
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Class that underwent some strange experiments inside the facility. Who knows what was the subject of said experiments...
]],

	classd_prestige = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Looks just like basic class, but has ability to steal clothes from dead bodies. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.

Idea by: Mr.Kiełbasa (contest winner)
]],

	sciassistant = [[Difficulty: Medium
Toughness: Low
Agility: Low
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
Basic class. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	sci = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	seniorsci = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists. You have higher access level. You've also found a primitive weapon. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	headsci = [[Difficulty: Easy
Toughness: Very High
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
Best of the scientists. You have higher utility and HP. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	contspec = [[Difficulty: Medium
Toughness: Very High
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists with high utility and HP, also have best access level. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	sci_prestige = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: Medium
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Runaway Class D who broke into some scientist's closet and stole clothes and ID. Pretend to be a scientist and cooperate with Class D and CI.

Idea by: Artieusz (contest winner)
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
Agility: High
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
Agility: Normal
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
CI spy. Try to blend in Security Guards and help Class D.
]],

	lightcispy = [[Difficulty: Very Hard
Toughness: Low
Agility: High
Combat potential: Low
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Light CI spy. High utility. Try to blend in Security Guards and help Class D.
]],

	heavycispy = [[Difficulty: Very Hard
Toughness: High
Agility: Low
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Heavy CI spy. Lower utility, better armor and higher health. Try to blend in Security Guards and help Class D.
]],

	guard_prestige = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Has device that can temporarily block doors in their current state. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.

Idea by: F"$LAYER (contest winner)
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
MTF Alpha-1 Unit. Heavily armored, high utility unit, armed with marksman rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1medic = [[Difficulty: Hard
Toughness: Very High
Agility: Very High
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavily armored, high utility unit, provides heal. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1com = [[Difficulty: Hard
Toughness: Very High
Agility: Very High
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavily armored, high utility unit. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
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

	cisniper = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. Cover your team.
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

	cimedic = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. You spawn with medkit
]],

	cispec = [[Difficulty: Medium
Toughness: Medium/High
Agility: Medium/High
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. You can place turret.
]],

	ciheavy = [[Difficulty: Medium
Toughness: Medium/High
Agility: Medium/High
Combat potential: Very High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. You are in possession of heavy machine gun.
]],

	goc = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: High
Can escape: No
Can escort: No
Escorted by: None

Overview:
Basic Global Occult Coalition soldier. Destroy all SCPs, use your personal tablet to locate GOC device that was earlier delivered to the facility then deploy and protect it. Escape to the evacuation shelter after successfully deploying the device.
]],

	gocmedic = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: High
Can escape: No
Can escort: No
Escorted by: None

Overview:
Basic Global Occult Coalition soldier. Destroy all SCPs, use your personal tablet to locate GOC device that was earlier delivered to the facility then deploy and protect it. Escape to the evacuation shelter after successfully deploying the device. You spawn with the medkit.
]],

	goccom = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: Very High
Can escape: No
Can escort: No
Escorted by: None

Overview:
Basic Global Occult Coalition soldier. Destroy all SCPs, use your personal tablet to locate GOC device that was earlier delivered to the facility then deploy and protect it. Escape to the evacuation shelter after successfully deploying the device. You have smoke grenades.
]],

	SCP0492 = [[General:
A zombie created by SCP-049. Comes as one of following types:

Normal zombie:
Difficulty: Easy | Toughness: Normal | Agility: Normal | Damage: Normal
A decent choice with balanced statistics

Assasin zombie:
Difficulty: Medium | Toughness: Low | Agility: High | Damage: Normal/High
The fastest one, but has the lowest health and damage

Exploding zombie:
Difficulty: Medium | Toughness: High | Agility: Low | Damage: Normal/High
Low movement speed, but has high health and highest damage

Spitting zombie:
Difficulty: Medium | Toughness: High | Agility: Low | Damage: Normal/High
The slowest zombie type, but has high damage and the most health
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "Outside buff",
		info = "Receive additional bullet protection and enable healing and regeneration when on surface.\n\t• Additional bullet defense: [%def]\n\t• Additional flat bullet defense: [flat] dmg\n\t• Once on surface heal for [buff_hp] HP in a short time\n\t• When out of combat, quickly recover [%regen_min] - [%regen_max] (time scaled) of received bullet damage\n\t• Dealing damage heals you for [%heal_min] - [%heal_max] (time scaled) of dealt damage\n\t• Returning back to the facility voids all active healings"
	}
}

lang.CommonSkills = {
	c_button_overload = {
		name = "Overload",
		dsc = "Allows you to overload most of locked doors. Overloaded doors open (or close) for a short period of time"
	},
	c_dmg_mod = {
		name = "Damage protection",
		dsc = "Current protection: [mod]\nCurrent flat protection: [flat]\n\nThis is the protection against received non-direct damage. It takes into account only modificators of time scaling and outside buff. SCP specific modificators are not included!\n\nOutside buff: [buff]",
		dmg = "DMG",
		not_bought = "Not bought",
		not_surface = "Disabled inside the facility",
		buff = "\n   • Current recovery: %s of received bullet damage\n   • Current heal: %s of dealt damage",
	},
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	skills = {
		_overview = { "passive", "drain", "clone", "hunt" },
		drain = {
			name = "Stamina Drain",
			dsc = "Start draining stamina from nearby players. If all players leave area, ability is instantly put on cooldown",
		},
		clone = {
			name = "Clone",
			dsc = "Place clone that will mimic work of your passive (including upgrades). Clone will wander around and chase nearby players",
		},
		hunt = {
			name = "Hunt",
			dsc = "Instantly kill one of your preys or people near them and teleport to their body",
		},
		passive = {
			name = "Passive",
			dsc = "Colliding with players ignites them. You also don't collide with doors",
		},
		drain_bar = {
			name = "Drain",
			dsc = "Remaining time of drain ability",
		},
	},

	upgrades = {
		parse_description = true,

		passive = {
			name = "Incandescent Ember",
			info = "Upgrades your passive ability increasing burning damage by [+burn_power]",
		},
		invis1 = {
			name = "Invisible Flame I",
			info = "Enhances your passive ability\n\t• You fade away for distant players\n\t• Players who can't see you, won't be added to hunt preys\n\t• This upgrade also applies to your clone\n\t• You become fully invisible [invis_range] units away",
		},
		invis2 = {
			name = "Invisible Flame II",
			info = "Upgrades your invisibility\n\t• You become fully invisible [invis_range] units away",
		},
		prot1 = {
			name = "Undying Fire I",
			info = "Enhances your passive ability by providing [-prot] bullet damage protection",
		},
		prot2 = {
			name = "Undying Fire II",
			info = "Upgrades your protection against bullets to [-prot]",
		},
		drain1 = {
			name = "Power Drain I",
			info = "Upgrades your drain ability\n\t• Duration increased by [+drain_dur]\n\t• Maximum distance increased by [+drain_dist]",
		},
		drain2 = {
			name = "Power Drain II",
			info = "Upgrades your drain ability\n\t• Drain rate increased by [/drain_rate]\n\t• Heal for [%drain_heal] drained stamina",
		},
		drain3 = {
			name = "Power Drain III",
			info = "Upgrades your drain ability\n\t• Duration increased by [+drain_dur]\n\t• Maximum distance increased by [+drain_dist]",
		},
		drain4 = {
			name = "Power Drain IV",
			info = "Upgrades your drain ability\n\t• Drain rate increased by [/drain_rate]\n\t• Heal for [%drain_heal] drained stamina",
		},
		hunt1 = {
			name = "Endless Flame I",
			info = "Empowers your hunt ability\n\t• Cooldown reduced by [-hunt_cd]",
		},
		hunt2 = {
			name = "Endless Flame II",
			info = "Empowers your hunt ability\n\t• Cooldown reduced by [-hunt_cd]\n\t• Random prey search radius increased by [+hunt_range]",
		},
	}
}

wep.SCP049 = {
	zombies = {
		normal = "Standard Zombie",
		assassin = "Assassin Zombie",
		boomer = "Exploding Zombie",
		heavy = "Spiting Zombie",
	},
	zombies_desc = {
		normal = "A standard zombie\n\t• Has both light and heavy attacks\n\t• Decent choice with balanced statistics",
		assassin = "An assassin zombie\n\t• Has light attack and rapid attack ability\n\t• The fastest one, but has the lowest health and damage",
		boomer = "An exploding heavy zombie\n\t• Has heavy attack and explode ability\n\t• Low movement speed, but has high health and highest damage",
		heavy = "A spiting heavy zombie\n\t• Has heavy attack and shot ability\n\t• The slowest zombie type, but has high damage and the most health",
	},
	skills = {
		_overview = { "passive", "choke", "surgery", "boost" },
		surgery_failed = "Surgery failed!",

		choke = {
			name = "Doctor's Touch",
			dsc = "Choke player to death. This ability can be interrupted by receiving enough damage",
		},
		surgery = {
			name = "Surgery",
			dsc = "Perform surgery on the body turning it into SCP-049-2 instance. Receiving damage interrupts surgery",
		},
		boost = {
			name = "Rise!",
			dsc = "Provides boost to you and all nearby SCP-049-2 instances",
		},
		passive = {
			name = "Passive",
			dsc = "Zombies near you gain bullet damage protection",
		},
		choke_bar = {
			name = "Doctor's Touch",
			dsc = "When full, target dies",
		},
		surgery_bar = {
			name = "Surgery",
			dsc = "Remaining time of the surgery",
		},
		boost_bar = {
			name = "Rise!",
			dsc = "Remaining time of the boost",
		},
	},

	upgrades = {
		parse_description = true,

		choke1 = {
			name = "Doctor's Touch I",
			info = "Upgrades your choke ability\n\t• Cooldown reduced by [-choke_cd]\n\t• Damage threshold increased by [+choke_dmg]",
		},
		choke2 = {
			name = "Doctor's Touch II",
			info = "Upgrades your choke ability\n\t• Choke speed increased by [+choke_rate]\n\t• Slow after choke reduced by [-choke_slow]",
		},
		choke3 = {
			name = "Doctor's Touch III",
			info = "Upgrades your choke ability\n\t• Cooldown reduced by [-choke_cd]\n\t• Damage threshold increased by [+choke_dmg]\n\t• Choke speed increased by [+choke_rate]",
		},
		buff1 = {
			name = "Rise I",
			info = "Upgrades your boost ability\n\t• Cooldown reduced by [-buff_cd]\n\t• Boost duration increased by [+buff_dur]",
		},
		buff2 = {
			name = "Rise II",
			info = "Upgrades your boost ability\n\t• Boost radius increased by [+buff_radius]\n\t• Boost power increased by [+buff_power]",
		},
		surgery_cd1 = {
			name = "Surgical Precision I",
			info = "Reduces surgery time by [surgery_time]s\n\t• This upgrade is stackable",
		},
		surgery_cd2 = {
			name = "Surgical Precision II",
			info = "Reduces surgery time by [surgery_time]s\n\t• This upgrade is stackable",
		},
		surgery_heal = {
			name = "Transplantation",
			info = "Upgrades your surgery ability\n\t• After surgery you heal for [surgery_heal] HP\n\t• After surgery all zombies nearby heal for [surgery_zombie_heal] HP",
		},
		surgery_dmg = {
			name = "Unstoppable Surgery",
			info = "Receiving damage no longer stops surgery",
		},
		surgery_prot = {
			name = "Steady Hand",
			info = "During surgery gain [-surgery_prot] bullet protection",
		},
		zombie_prot = {
			name = "The Nurse",
			info = "Gain bullet damage protection for each SCP-049-2 nearby\n\t• Protection for each zombie nearby: [%zombie_prot]\n\t• Maximum protection: [%zombie_prot_max]",
		},
		zombie_lifesteal = {
			name = "Transfusion I",
			info = "Zombies gain [%zombie_ls] life steal on basic attacks",
		},
		stacks_hp = {
			name = "Steroids Injection",
			info = "When creating zombie, their health is increased by [%stacks_hp] for each prior surgery",
		},
		stacks_dmg = {
			name = "Radical Therapy",
			info = "When creating zombie, their damage is increased by [%stacks_dmg] for each prior surgery",
		},
		zombie_heal = {
			name = "Transfusion II",
			info = "You heal for [%zombie_heal] of any damage dealt by zombies nearby",
		}
	}
}

wep.SCP0492 = {
	skills = {
		prot = {
			name = "Protection",
			dsc = "You gain some damage protection when near SCP-049",
		},
		boost = {
			name = "Boost",
			dsc = "Indicates whenever SCP-049 boost is active on you",
		},
		light_attack = {
			name = "Light Attack",
			dsc = "Perform a light attack",
		},
		heavy_attack = {
			name = "Heavy Attack",
			dsc = "Perform a heavy attack",
		},
		rapid = {
			name = "Rapid Attack",
			dsc = "Perform a rapid attack",
		},
		shot = {
			name = "Shot",
			dsc = "Shot damaging projectile",
		},
		explode = {
			name = "Explode",
			dsc = "Enables when you have 50 HP or less. Gain ability to become unkillable and gain speed boost. After short time, you will explode dealing damage in small radius",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Remaining boost time",
		},
		explode_bar = {
			name = "Explode",
			dsc = "Remaining time to an explosion",
		},
	},

	upgrades = {
		parse_description = true,

		primary1 = {
			name = "Primary Attack I",
			info = "Upgrades your primary attack\n\t• Cooldown reduced by [-primary_cd]",
		},
		primary2 = {
			name = "Primary Attack II",
			info = "Upgrades your primary attack\n\t• Cooldown reduced by [-primary_cd]\n\t• Damage increased by [+primary_dmg]",
		},
		secondary1 = {
			name = "Secondary Attack I",
			info = "Upgrades your secondary attack\n\t• Damage increased by [+secondary_dmg]",
		},
		secondary2 = {
			name = "Secondary Attack II",
			info = "Upgrades your secondary attack\n\t• Damage increased by [+secondary_dmg]\n\t• Cooldown reduced by [-secondary_cd]",
		},
		overload = {
			name = "Overload",
			info = "Grants additional [overloads] button overloads",
		},
		buff = {
			name = "Rise!",
			info = "Empowers your protection and SCP-049 boost\n\t• Protection power: [%+prot_power]\n\t• Boost power: [++buff_power]",
		},
	}
}

wep.SCP058 = {
	skills = {
		_overview = { "primary_attack", "shot", "explosion" },
		primary_attack = {
			name = "Primary attack",
			dsc = "Attack with your sting directly in front of you. Applies poison if an appropriate upgrade is bought",
		},
		shot = {
			name = "Shot",
			dsc = "Shots projectile in your aim direction. Projectile will move in ballistic curve. Shot related upgrades affect cooldown, speed, size and effects of this ability",
		},
		explosion = {
			name = "Explode",
			dsc = "Release burst of corrupted blood dealing massive damage to targets nearby",
		},
		shot_stacks = {
			name = "Shot stacks",
			dsc = "Show stored amount of shots. Various shot related upgrades affect maximum amount and cooldown time",
		},
	},

	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Poisonous Sting I",
			info = "Adds poison to primary attacks"
		},
		attack2 = {
			name = "Poisonous Sting II",
			info = "Buffs attack damage, poison damage and decreases cooldown\n\t• Adds [prim_dmg] damage to attacks\n\t• Attack poison deals [pp_dmg] damage\n\t• Cooldown is reduced by [prim_cd]s"
		},
		attack3 = {
			name = "Poisonous Sting III",
			info = "Buffs poison damage and decreases cooldown\n\t• If target is not poisoned, instantly apply 2 stacks of poison\n\t• Attack poison deals [pp_dmg] damage\n\t• Cooldown is reduced by [prim_cd]s"
		},
		shot = {
			name = "Corrupted Blood",
			info = "Adds poison to shot attacks"
		},
		shot11 = {
			name = "Surge I",
			info = "Increases damage and projectile size but also increases cooldown and slows down projectile\n\t• Projectile damage increased by [+shot_damage]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]\n\t• Cooldown increased by [shot_cd]s"
		},
		shot12 = {
			name = "Surge II",
			info = "Increases damage and projectile size but also increases cooldown and slows down projectile\n\t• Projectile damage increased by [+shot_damage]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]\n\t• Cooldown increased by [shot_cd]s"
		},
		shot21 = {
			name = "Bloody Mist I",
			info = "Shot leaves mist on impact, hurting and poisoning everyone who touches it.\n\t• Direct and splash damage is removed\n\t• Cloud deals [cloud_damage] damage on contact\n\t• Poison inflicted by cloud deals [sp_dmg] damage\n\t• Shot stacks limited to [stacks]\n\t• Cooldown increased by [shot_cd]s\n\t• Stacks gain rate: [/+regen_rate]"
		},
		shot22 = {
			name = "Bloody Mist II",
			info = "Buffs mist left by shots.\n\t• Cloud deals [cloud_damage] damage on contact\n\t• Poison inflicted by cloud deals [sp_dmg] damage\n\t• Stacks gain rate: [/+regen_rate]"
		},
		shot31 = {
			name = "Multishot I",
			info = "Allows you to shot at rapid speed while holding attack button\n\t• Unlock ability of rapid shooting\n\t• Direct and splash damage is removed\n\t• Shot stacks limited to [stacks]\n\t• Stacks gain rate: [/+regen_rate]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]"
		},
		shot32 = {
			name = "Multishot II",
			info = "Increases maximum stacks and buffs shot speed\n\t• Shot stacks limited to [stacks]\n\t• Stacks gain rate: [/+regen_rate]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]"
		},
		exp1 = {
			name = "Aortal Burst",
			info = "Unlocks explode ability that deals massive damage to nearby targets. This ability activates when your health decreases below each multiple of 1000 HP for the first time. If bought when below 1000 HP, first received damage activates this ability. Previous thresholds can't be reached (even with healing)"
		},
		exp2 = {
			name = "Toxic Blast",
			info = "Buffs your explode ability\n\t• Applies 2 stacks of poison\n\t• Radius increased by [+explosion_radius]"
		},
	}
}

wep.SCP066 = {
	skills = {
		_overview = { "eric", "music", "dash", "boost" },
		not_threatened = "You don't feel threatened enough to attack!",

		music = {
			name = "Symphony No. 2",
			dsc = "If you feel threatened, you can emit loud music",
		},
		dash = {
			name = "Dash",
			dsc = "Dash forward. If you hit player, you will stick to them for a short time. Use again to detach",
		},
		boost = {
			name = "Boost",
			dsc = "Get one of 3 boosts that is currently active. After use it will be replaced by the next one. Power of all boosts increases with each passive stack (capped at [cap] stacks).\n\nCurrent boost: [boost]\n\nSpeed boost: [speed]\nBullet defense boost: [def]\nRegeneration boost: [regen]",
			buffs = {
				"Speed",
				"Bullet defense",
				"Regeneration",
			},
		},
		eric = {
			name = "Eric?",
			dsc = "You ask unarmed players if they are Eric. Get one passive stack each time",
		},
		music_bar = {
			name = "Symphony No. 2",
			dsc = "Remaining time of this ability",
		},
		dash_bar = {
			name = "Detach time",
			dsc = "Remaining time of being attached to this target",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Remaining time of this ability",
		},
	},

	upgrades = {
		parse_description = true,

		eric1 = {
			name = "Eric? I",
			info = "Reduces passive cooldown by [-eric_cd]",
		},
		eric2 = {
			name = "Eric? II",
			info = "Reduces passive cooldown by [-eric_cd]",
		},
		music1 = {
			name = "Symphony No. 2 I",
			info = "Upgrades your primary attack\n\t• Cooldown decreased by [-music_cd]\n\t• Range increased by [+music_range]",
		},
		music2 = {
			name = "Symphony No. 2 II",
			info = "Upgrades your primary attack\n\t• Cooldown decreased by [-music_cd]\n\t• Range increased by [+music_range]",
		},
		music3 = {
			name = "Symphony No. 2 III",
			info = "Upgrades your primary attack\n\t• Damage increased by [+music_damage]",
		},
		dash1 = {
			name = "Dash I",
			info = "Upgrades your dash ability\n\t• Cooldown decreased by [-dash_cd]\n\t• You can stay [+detach_time] longer on your target",
		},
		dash2 = {
			name = "Dash II",
			info = "Upgrades your dash ability\n\t• Cooldown decreased by [-dash_cd]\n\t• You can stay [+detach_time] longer on your target",
		},
		dash3 = {
			name = "Dash III",
			info = "Upgrades your dash ability\n\t• While usning this ability again, you will jump off instead of detaching\n\t• While jumping off, you can attach to another player\n\t• You can't stick to the same player you just jumped off",
		},
		boost1 = {
			name = "Boost I",
			info = "Upgrades your boost ability\n\t• Cooldown decreased by [-boost_cd]\n\t• Duration increased by [+boost_dur]",
		},
		boost2 = {
			name = "Boost II",
			info = "Upgrades your boost ability\n\t• Cooldown decreased by [-boost_cd]\n\t• Power increased by [+boost_power]",
		},
		boost3 = {
			name = "Boost III",
			info = "Upgrades your boost ability\n\t• Duration increased by [+boost_dur]\n\t• Power increased by [+boost_power]",
		},
	}
}

wep.SCP096 = {
	skills = {
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {
			name = "Lunge",
			dsc = "Lunge forward while in rage. Instantly ends rage. You won't eat body after lunge",
		},
		regen = {
			name = "Regeneration",
			dsc = "Sit in place and convert regeneration stacks to health",
		},
		special = {
			name = "Hunt's Over",
			dsc = "Stop rage. Get regeneration stacks for each active target",
		},
		passive = {
			name = "Passive",
			dsc = "If someone looks at you, you become enraged. You instantly kill players who enraged you",
		},
	},

	upgrades = {
		parse_description = true,

		rage = {
			name = "Anger",
			info = "Receiving [rage_dmg] in [rage_time] seconds from single player will enrage you",
		},
		heal1 = {
			name = "Devour I",
			info = "After killing target, devour target's body and gain bullet protection for duration\n\t• Heal per tick: [heal]\n\t• Heal ticks: [heal_ticks]\n\t• Bullet damage protection: [-prot]",
		},
		heal2 = {
			name = "Devour II",
			info = "Upgrades your devour\n\t• Heal per tick: [heal]\n\t• Heal ticks: [heal_ticks]\n\t• Bullet damage protection: [-prot]",
		},
		multi1 = {
			name = "Endless Rage I",
			info = "Allows you to kill multiple targets while in rage for a limited time after first kill\n\t• Maximum targets: [multi]\n\t• Time limit: [multi_time] seconds\n\t• Received bullet damage after killing first target increased by [+prot]",
		},
		multi2 = {
			name = "Endless Rage II",
			info = "Allows you to kill even more targets while in rage\n\t• Maximum targets: [multi]\n\t• Time limit: [multi_time] seconds\n\t• Received bullet damage after killing first target increased by [+prot]",
		},
		regen1 = {
			name = "Cry of Despair I",
			info = "Upgrades your regeneration ability\n\t• Heal increased by [+regen_mult]",
		},
		regen2 = {
			name = "Cry of Despair II",
			info = "Upgrades your regeneration ability\n\t• Stacks gain rate increased by [/regen_stacks]",
		},
		regen3 = {
			name = "Cry of Despair III",
			info = "Upgrades your regeneration ability\n\t• Heal increased by [+regen_mult]\n\t• Stacks gain rate increased by [/regen_stacks]",
		},
		spec1 = {
			name = "Mercy I",
			info = "Upgrades your special ability and adds sanity drain\n\t• Gain [+spec_mult] more stacks\n\t• Sanity drain: [sanity]",
		},
		spec2 = {
			name = "Mercy II",
			info = "Upgrades your special ability\n\t• Gain [+spec_mult] more stacks\n\t• Sanity drain: [sanity]",
		},
	}
}

wep.SCP106 = {
	cancel = "Press [%s] to cancel",

	skills = {
		_overview = { "passive", "withering", "teleport", "trap" },
		withering = {
			name = "Withering",
			dsc = "Inflict withering effect on target. Withering gradually slow target over time. Attacking target who is inside Pocket Dimension instantly kill them\n\nEffect duration [dur]\nMaximum slow: [slow]",
		},
		trap = {
			name = "Trap",
			dsc = "Place trap on the wall. When trap activates, target is slowed and you can use this ability again to instantly teleport to that trap",
		},
		teleport = {
			name = "Teleport",
			dsc = "Use to place teleport spot. Holding this ability near existing teleport spot, allows you to select teleport destination, release button to teleport to selected spot",
		},
		passive = {
			name = "Teeth Collection",
			dsc = "Bullets can't kill you, but they can temporarily knock you down, also you can pass through doors. Touching player, teleports them to Pocket Dimension. Each player teleported to Pocket Dimension grants one tooth. Collected teeth empower your withering ability",
		},
		teleport_cd = {
			name = "Teleport",
			dsc = "Shows cooldown of teleport spot",
		},
		passive_bar = {
			name = "Teeth Collection",
			dsc = "When this bar reaches zero, you will be knocked down",
		},
		trap_bar = {
			name = "Trap",
			dsc = "Shows how long trap will remain active"
		}
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Teeth Collection I",
			info = "Upgrades your passive ability\n\t• Increases damage required to knock you down by [+passive_dmg]\n\t• Reduces knock down stun by [-passive_cd]",
		},
		passive2 = {
			name = "Teeth Collection II",
			info = "Upgrades your passive ability\n\t• Increases damage required to knock you down by [+passive_dmg]\n\t• Damage dealt to players increased by [+teleport_dmg]",
		},
		passive3 = {
			name = "Teeth Collection III",
			info = "Upgrades your passive ability\n\t• Increases damage required to knock you down by [+passive_dmg]\n\t• Reduces knock down stun by [-passive_cd]\n\t• Damage dealt to players increased by [+teleport_dmg]",
		},
		withering1 = {
			name = "Withering I",
			info = "Upgrades your withering ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Effect base duration increased by [+withering_dur]",
		},
		withering2 = {
			name = "Withering II",
			info = "Upgrades your withering ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Effect base slow increased by [+withering_slow]",
		},
		withering3 = {
			name = "Withering III",
			info = "Upgrades your withering ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Effect base duration increased by [+withering_dur]\n\t• Effect base slow increased by [+withering_slow]",
		},
		tp1 = {
			name = "Teleport I",
			info = "Upgrades your teleport ability\n\t• Maximum spots increased by [spot_max]\n\t• Spot cooldown decreased by [-spot_cd]",
		},
		tp2 = {
			name = "Teleport II",
			info = "Upgrades your teleport ability\n\t• Maximum spots increased by [spot_max]\n\t• Teleport cooldown decreased by [-tp_cd]",
		},
		tp3 = {
			name = "Teleport III",
			info = "Upgrades your teleport ability\n\t• Maximum spots increased by [spot_max]\n\t• Spot cooldown decreased by [-spot_cd]\n\t• Teleport cooldown decreased by [-tp_cd]",
		},
		trap1 = {
			name = "Trap I",
			info = "Upgrades your trap ability\n\t• Trap cooldown decreased by [-trap_cd]\n\t• Trap life time increased by [+trap_life]",
		},
		trap2 = {
			name = "Trap II",
			info = "Upgrades your trap ability\n\t• Trap cooldown decreased by [-trap_cd]\n\t• Trap life time increased by [+trap_life]",
		},
	}
}

local scp173_prot = {
	name = "Reinforced Concrete",
	info = "• Gain [%prot] bullet damage reduction\n• This ability stacks with other skills of the same type",
}

wep.SCP173 = {
	restricted = "Restricted!",

	skills = {
		_overview = { "gas", "decoy", "stealth" },
		gas = {
			name = "Gas",
			dsc = "Emit cloud of irritating gas that will slow down, obscure vision and increase blinking rate of players nearby",
		},
		decoy = {
			name = "Decoy",
			dsc = "Place decoy that will distract and drain sanity of players",
		},
		stealth = {
			name = "Stealth",
			dsc = "Enter stealth mode. In stealth mode you are invisible and you can pass through doors. Additionally, you become invulnerable to damage (AOE damage like explosions can still hit you), but you also can't inflict any damage to players and you can't interact with the world",
		},
		looked_at = {
			name = "Freeze!",
			dsc = "Shows if someone is looking at you",
		},
		next_decoy = {
			name = "Decoy stacks",
			dsc = "Number of available decoys",
		},
		stealth_bar = {
			name = "Stealth",
			dsc = "Remaining time of stealth ability",
		},
	},

	upgrades = {
		parse_description = true,

		horror_a = {
			name = "Overwhelming Presence",
			info = "Horror radius is increased by [+horror_dist]",
		},
		horror_b = {
			name = "Unnerving Presence",
			info = "Horror sanity drain is increased by [+horror_sanity]",
		},
		attack_a = {
			name = "Swift Killer",
			info = "Kill radius is increased by [+snap_dist]",
		},
		attack_b = {
			name = "Agile Killer",
			info = "Move radius is increased by [+move_dist]",
		},
		gas1 = {
			name = "Gas I",
			info = "Gas radius is increased by [+gas_dist]",
		},
		gas2 = {
			name = "Gas II",
			info = "Gas radius is increased by [+gas_dist] and gas cooldown is reduced by [-gas_cd]",
		},
		decoy1 = {
			name = "Decoy I",
			info = "Decoy cooldown is reduced by [-decoy_cd]",
		},
		decoy2 = {
			name = "Decoy II",
			info = "• Decoy cooldown is reduced to 0.5s\n• Original cooldown applies to decoy stacks instead\n• Decoys limit is increased by [decoy_max].",
		},
		stealth1 = {
			name = "Stealth I",
			info = "Stealth cooldown is reduced by [-stealth_cd]",
		},
		stealth2 = {
			name = "Stealth I",
			info = "• Stealth cooldown is reduced by [-stealth_cd]\n• Stealth duration is increased by [+stealth_dur]",
		},
		prot1 = scp173_prot,
		prot2 = scp173_prot,
		prot3 = scp173_prot,
		prot4 = scp173_prot,
	},
}

wep.SCP457 = {
	skills = {
		_overview = { "passive", "fireball", "trap", "ignite" },
		fireball = {
			name = "Fireball",
			dsc = "Fuel cost: [cost]\nFire fireball that will travel forward until it collides with something",
		},
		trap = {
			name = "Trap",
			dsc = "Fuel cost: [cost]\nPlace trap that will ignite players that touch it",
		},
		ignite = {
			name = "Inner Rage",
			dsc = "Fuel cost: [cost] for each spawned fire\nRelease waves of flames near you. Range of this ability is unlimited and each subsequent ring of fire consumes more fuel. This ability cannot be interrupted",
		},
		passive = {
			name = "Passive",
			dsc = "You ignite everyone you touch. Igniting player adds fuel",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Living Torch I",
			info = "Upgrades your passive ability\n\t• Fire radius increased by [+fire_radius]\n\t• Fuel gain increased by [+fire_fuel]",
		},
		passive2 = {
			name = "Living Torch II",
			info = "Upgrades your passive ability\n\t• Fire radius increased by [+fire_radius]\n\t• Fire damage increased by [+fire_dmg]",
		},
		passive3 = {
			name = "Living Torch III",
			info = "Upgrades your passive ability\n\t• Fuel gain increased by [+fire_fuel]\n\t• Fire damage increased by [+fire_dmg]",
		},
		passive_heal1 = {
			name = "Flame of Life I",
			info = "You heal for [%fire_heal] damage caused by fire from any of your abilities",
		},
		passive_heal2 = {
			name = "Flame of Life II",
			info = "You heal for [%fire_heal] damage caused by fire from any of your abilities",
		},
		fireball1 = {
			name = "Dodgeball I",
			info = "Upgrades your fireball ability\n\t• Cooldown decreased by [-fireball_cd]\n\t• Speed increased by [+fireball_speed]\n\t• Fuel cost decreased by [-fireball_cost]",
		},
		fireball2 = {
			name = "Dodgeball II",
			info = "Upgrades your fireball ability\n\t• Damage increased by [+fireball_dmg]\n\t• Size increased by [+fireball_size]\n\t• Fuel cost decreased by [-fireball_cost]",
		},
		fireball3 = {
			name = "Dodgeball III",
			info = "Upgrades your fireball ability\n\t• Cooldown decreased by [-fireball_cd]\n\t• Damage increased by [+fireball_dmg]\n\t• Speed increased by [+fireball_speed]",
		},
		trap1 = {
			name = "It's a Trap! I",
			info = "Upgrades your trap ability\n\t• Additional traps: [trap_max]\n\t• Fuel cost decreased by [-trap_cost]\n\t• Lifetime increased by [+trap_time]",
		},
		trap2 = {
			name = "It's a Trap! II",
			info = "Upgrades your trap ability\n\t• Additional traps: [trap_max]\n\t• Damage increased by [+trap_dmg]\n\t• Lifetime increased by [+trap_time]",
		},
		trap3 = {
			name = "It's a Trap! III",
			info = "Upgrades your trap ability\n\t• Fuel cost decreased by [-trap_cost]\n\t• Damage increased by [+trap_dmg]\n\t• Lifetime increased by [+trap_time]",
		},
		ignite1 = {
			name = "Inner Rage I",
			info = "Upgrades your inner rage ability\n\t• Wave rate increased by [/ignite_rate]\n\t• First ring spawns [ignite_flames] additional flames",
		},
		ignite2 = {
			name = "Inner Rage II",
			info = "Upgrades your inner rage ability\n\t• Fuel cost decreased by [-ignite_cost]\n\t• First ring spawns [ignite_flames] additional flames",
		},
		fuel = {
			name = "Fuel Delivery!",
			info = "Instantly gain [fuel] fuel",
		}
	}
}

wep.SCP682 = {
	skills = {
		_overview = { "primary", "secondary", "charge", "shield" },
		primary = {
			name = "Basic attack",
			dsc = "Attack with your hand directly in front of you inflicting minor damage",
		},
		secondary = {
			name = "Bite",
			dsc = "Hold key to prepare a strong attack that will inflict major damage in a cone shaped area in front of you",
		},
		charge = {
			name = "Charge",
			dsc = "After a short delay charge forward and become unstoppable. When on full speed, kill everyone in your path and gain ability to breach most of doors. This skill has to be unlocked in upgrade tree",
		},
		shield = {
			name = "Shield",
			dsc = "Shield that will absorb any non-direct/fall damage. This ability is affected by bought upgrades on your skill tree",
		},
		shield_bar = {
			name = "Shield",
			dsc = "Current amount of shield that will absorb any non-direct/fall damage",
		},
	},

	upgrades = {
		parse_description = true,

		shield_a = {
			name = "Empowered Shield",
			info = "Upgrades power of your shield\n\t• Shield power: [%shield]\n\t• Cooldown: [%shield_cd]",
		},
		shield_b = {
			name = "Regeneration Shield",
			info = "Alters power of your shield\n\t• Shield power: [%shield]\n\t• Cooldown: [%shield_cd]\n\t• Cooldown starts after shield is fully depleted\n\t• When shield is on cooldown, regenerate [shield_regen] HP/s",
		},
		shield_c = {
			name = "Shield of Sacrifice",
			info = "Alters power of your shield\n\t• Cooldown: [%shield_cd]\n\t• Cooldown starts after shield is fully depleted\n\t• Power of your shield is equal to your maximum HP\n\t• When broken, you lose [shield_hp] maximum HP",
		},
		shield_d = {
			name = "Reflective Shield",
			info = "Alters power of your shield\n\t• Shield power: [%shield]\n\t• Cooldown: [%shield_cd]\n\t• Cooldown starts after shield is fully depleted\n\t• Your shield blocks only [%shield_pct] of damage\n\t• [%reflect_pct] of blocked damage is reflected to attacker",
		},

		shield_1 = {
			name = "Shield I",
			info = "Adds effects to your shield. Once fully broken, receive additional [+shield_speed_pow] movement speed for [shield_speed_dur] seconds",
		},
		shield_2 = {
			name = "Shield II",
			info = "Adds effects to your shield. Once fully broken, receive additional [+shield_speed_pow] movement speed for [shield_speed_dur] seconds. Additionally, every 1 point of received damage shortens shield cooldown by [shield_cdr] seconds",
		},

		attack_1 = {
			name = "Empowered Swing",
			info = "Upgrades your basic attack\n\t• Cooldown reduced by [-prim_cd]\n\t• Damage increased by [prim_dmg]",
		},
		attack_2 = {
			name = "Empowered Bite",
			info = "Upgrades your bite\n\t• Range increased by [+sec_range]\n\t• Movement speed while preparing is increased by [+sec_speed]",
		},
		attack_3 = {
			name = "Merciless Strike",
			info = "Upgrades both basic attack and bite\n\t• Both attacks inflict bleeding\n\t• Bite attack inflicts fracture when fully charged",
		},

		charge_1 = {
			name = "Charge",
			info = "Unlocks charge ability",
		},
		charge_2 = {
			name = "Ruthless Charge",
			info = "Empowers charge ability\n\t• Cooldown is reduced by [-charge_cd]\n\t• Stun and slow duration are reduced by [-charge_stun]",
		},
	}
}

wep.SCP8602 = {
	skills = {
		_overview = { "passive", "primary", "defense", "charge" },
		primary = {
			name = "Attack",
			dsc = "Perform basic attack",
		},
		defense = {
			name = "Defensive Stance",
			dsc = "Hold to activate. While holding, gain protection over time but you are also slowed. Release to dash forward and deal damage equal to [dmg_ratio] of mitigated damage. This ability doesn't have duration limit",
		},
		charge = {
			name = "Charge",
			dsc = "Gain speed over time and deal damage to first player in front of you. If attacked player is close enough to wall, pin them to that and perform strong attack",
		},
		passive = {
			name = "Passive",
			dsc = "You see player inside your forest and for some time after they exit it. Players inside forest lose sanity, if they are out of sanity, they lose health instead. Heal for taken sanity/heath from players inside forest. This healing can exceed your maximum health",
		},
		overheal_bar = {
			name = "Overheal",
			dsc = "Overhealed health",
		},
		defense_bar = {
			name = "Defense",
			dsc = "Current protection power",
		},
		charge_bar = {
			name = "Charge",
			dsc = "Remaining charge time",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Dense Woods I",
			info = "Upgrades your passive ability\n\t• Maximum overheal increased by [+overheal]\n\t• Passive rate increased by [/passive_rate]\n\t• Player detect time increased by [+detect_time]",
		},
		passive2 = {
			name = "Dense Woods II",
			info = "Upgrades your passive ability\n\t• Maximum overheal increased by [+overheal]\n\t• Passive rate increased by [/passive_rate]\n\t• Player detect time increased by [+detect_time]",
		},
		primary = {
			name = "Simple but Dangerous",
			info = "Upgrades your basic attack\n\t• Cooldown decreased by [-primary_cd]\n\t• Damage increased by [+primary_dmg]",
		},
		def1a = {
			name = "Swift Armor",
			info = "Alters your defensive stance ability\n\t• Activation time reduced by [-def_time]\n\t• Cooldown increased by [+def_cooldown]",
		},
		def1b = {
			name = "Rapid Armor",
			info = "Alters your defensive stance ability\n\t• Activation time increased by [+def_time]\n\t• Cooldown decreased by [-def_cooldown]",
		},
		def2a = {
			name = "Long Dash",
			info = "Alters your defensive stance ability\n\t• Dash maximum distance increased by [+def_range]\n\t• Dash width reduced by [-def_width]",
		},
		def2b = {
			name = "Clumsy Dash",
			info = "Alters your defensive stance ability\n\t• Dash maximum distance reduced by [-def_range]\n\t• Dash width increased by [+def_width]",
		},
		def3a = {
			name = "Heavy Armor",
			info = "Alters your defensive stance ability\n\t• Maximum protection increased by [+def_prot]\n\t• Maximum slow increased by [+def_slow]",
		},
		def3b = {
			name = "Light Armor",
			info = "Alters your defensive stance ability\n\t• Maximum protection decreased by [-def_prot]\n\t• Maximum slow reduced by [-def_slow]",
		},
		def4 = {
			name = "Effective Armor",
			info = "Upgrades your defensive stance ability\n\t• Damage conversion multiplier increased by [+def_mult]",
		},
		charge1 = {
			name = "Charge I",
			info = "Upgrades your charge ability\n\t• Cooldown decreased by [-charge_cd]\n\t• Duration increased by [+charge_time]\n\t• Basic damage increased by [+charge_dmg]",
		},
		charge2 = {
			name = "Charge II",
			info = "Upgrades your charge ability\n\t• Range increased by [+charge_range]\n\t• Duration increased by [+charge_time]\n\t• Pin damage increased by [+charge_pin_dmg]",
		},
		charge3 = {
			name = "Charge III",
			info = "Upgrades your charge ability\n\t• Speed increased by [+charge_speed]\n\t• Above 80% of charge progress, any hit counts as strong attack\n\t• Pinning player to wall breaks their bones",
		},
	}
}

wep.SCP939 = {
	skills = {
		_overview = { "passive", "primary", "trail", "special" },
		primary = {
			name = "Attack",
			dsc = "Bite everyone in cone shaped area on front of you",
		},
		trail = {
			name = "ANM-C227",
			dsc = "Hold key to leave ANM-C227 trail behind you",
		},
		special = {
			name = "Detection",
			dsc = "Start detecting players around you",
		},
		passive = {
			name = "Passive",
			dsc = "You can't see players, but you can see sound waves. You have ANM-C227 aura around you",
		},
		special_bar = {
			name = "Detection",
			dsc = "Remaining detection time",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Aura I",
			info = "Upgrades your passive ability\n\t• Aura radius increased by [+aura_radius]\n\t• Aura damage increased by [aura_damage]",
		},
		passive2 = {
			name = "Aura II",
			info = "Upgrades your passive ability\n\t• Aura radius increased by [+aura_radius]\n\t• Aura damage increased by [aura_damage]",
		},
		passive3 = {
			name = "Aura III",
			info = "Upgrades your passive ability\n\t• Aura radius increased by [+aura_radius]\n\t• Aura damage increased by [aura_damage]",
		},
		attack1 = {
			name = "Bite I",
			info = "Upgrades your attack ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Damage increased by [+attack_dmg]",
		},
		attack2 = {
			name = "Bite II",
			info = "Upgrades your attack ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Range increased by [+attack_range]",
		},
		attack3 = {
			name = "Bite III",
			info = "Upgrades your attack ability\n\t• Damage increased by [+attack_dmg]\n\t• Range increased by [+attack_range]\n\t• Your attacks have chance to apply bleeding",
		},
		trail1 = {
			name = "Amnesia I",
			info = "Upgrades your ANM-C227 ability\n\t• Radius increased by [+trail_radius]\n\t• Stacks generation rate increased by [/trail_rate]",
		},
		trail2 = {
			name = "Amnesia II",
			info = "Upgrades your ANM-C227 ability\n\t• Damage increased by [trail_dmg]\n\t• Maximum stacks increased by [+trail_stacks]",
		},
		trail3a = {
			name = "Amnesia III A",
			info = "Upgrades your ANM-C227 ability\n\t• Life time of trail increased by [+trail_life]\n\t• Radius increased by [+trail_radius]",
		},
		trail3b = {
			name = "Amnesia III B",
			info = "Upgrades your ANM-C227 ability\n\t• Maximum stacks increased by [+trail_stacks]",
		},
		trail3c = {
			name = "Amnesia III C",
			info = "Upgrades your ANM-C227 ability\n\t• Stacks generation rate increased by [/trail_rate]",
		},
		special1 = {
			name = "Echolocation I",
			info = "Upgrades your special ability\n\t• Cooldown decreased by [-special_cd]\n\t• Radius increased by [+special_radius]",
		},
		special2 = {
			name = "Echolocation II",
			info = "Upgrades your special ability\n\t• Cooldown decreased by [-special_cd]\n\t• Duration increased by [+special_times]",
		},
	}
}

wep.SCP966 = {
	fatigue = "Fatigue level:",

	skills = {
		_overview = { "passive", "attack", "channeling", "mark" },
		attack = {
			name = "Basic attack",
			dsc = "Perform basic attack. You can only attack players with at least 10 fatigue stacks. Attacked players loses some of fatigue stacks. Effects of this attack are affected by skill tree",
		},
		channeling = {
			name = "Channeling",
			dsc = "Channel ability selected in skill tree",
		},
		mark = {
			name = "Death Mark",
			dsc = "Mark player. Marked players will transfer fatigue stacks from other nearby players to themselves",
		},
		passive = {
			name = "Fatigue",
			dsc = "Once in a while you apply fatigue stacks to nearby players. You also gain passive stack for each applied fatigue stack",
		},
		channeling_bar = {
			name = "Channeling",
			dsc = "Remaining time of channeling ability",
		},
		mark_bar = {
			name = "Death Mark",
			dsc = "Remaining time of mark on marked player",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Fatigue I",
			info = "Upgrades your passive ability\n\t• Passive rate increased by [/passive_rate]",
		},
		passive2 = {
			name = "Fatigue II",
			info = "Upgrades your passive ability\n\t• Passive rate increased by [/passive_rate]\n\t• Passive range increased by [+passive_radius]",
		},
		basic1 = {
			name = "Sharp Claws I",
			info = "Upgrades your basic attack increasing damage by [%basic_dmg] for each [basic_stacks] passive stacks. Also gaining passive stacks unlock:\n\t• [bleed1_thr] stacks: Apply bleeding if target is not bleeding\n\t• [drop1_thr] stacks: Target loss of fatigue stacks decreased to [%drop1]\n\t• [slow_thr] stacks: Target is slowed by [-slow_power] for [slow_dur] seconds",
		},
		basic2 = {
			name = "Sharp Claws II",
			info = "Upgrades your basic attack increasing damage by [%basic_dmg] for each [basic_stacks] passive stacks. Also gaining passive stacks unlock:\n\t• [bleed2_thr] stacks: Apply bleeding on hit\n\t• [drop2_thr] stacks: Target loss of fatigue stacks decreased to [%drop2]\n\t• [hb_thr] stacks: Apply heavy bleeding instead of bleeding on hit",
		},
		heal = {
			name = "Blood Drain",
			info = "Heal [%heal_rate] per passive stack per target fatigue stack on hit",
		},
		channeling_a = {
			name = "Endless Fatigue",
			info = "Unlocks channeling ability that will allow you to focus on single target\n\t• Passive is disabled during channeling\n\t• Cooldown [channeling_cd] seconds\n\t• Maximum duration [channeling_time] seconds\n\t• Target will gain fatigue stack once every [channeling_rate] second",
		},
		channeling_b = {
			name = "Energy Drain",
			info = "Unlocks channeling ability that will allow you to drain fatigue charges from nearby players\n\t• Passive is disabled during channeling\n\t• Cooldown [channeling_cd] seconds\n\t• Maximum duration [channeling_time] seconds\n\t• Each [channeling_rate] second, transfer 1 fatigue charge from all nearby players to passive stacks",
		},
		channeling = {
			name = "Empowered Channeling",
			info = "Upgrades your channeling ability\n\t• Channeling range increased by [+channeling_range_mul]\n\t• Channeling duration increased by [+channeling_time_mul]",
		},
		mark1 = {
			name = "Lethal Mark I",
			info = "Upgrades mark ability:\n\t• Stacks transfer rate increased by [/mark_rate]",
		},
		mark2 = {
			name = "Lethal Mark II",
			info = "Upgrades mark ability:\n\t• Stacks transfer rate increased by [/mark_rate]\n\t• Stacks transfer range increased by [+mark_range]",
		},
	}
}

wep.SCP24273 = {
	skills = {
		_overview = { "change", "primary", "secondary", "special" },
		primary = {
			name = "Dash / Camouflage",
			dsc = "\nJudge:\nDash forward dealing damage to everyone on your path\n\nProsecutor:\nEnable camouflage. During camouflage you are less visible. Using skills, moving or receiving damage interrupts it",
		},
		secondary = {
			name = "Examination / Surveillance",
			dsc = "\nJudge:\nStart focusing on targeted player for some time. When fully casted, slow target and deal damage. If line of sight is lost, skill is interrupted and you are slowed instead\n\nProsecutor:\nLeave your body and look from a perspective of random player nerby. Your passive also works from that player's perspective",
		},
		special = {
			name = "Judgement / Ghost",
			dsc = "\nJudge:\nStay in place and force everyone nearby to walk to you. When finished, players in close proximity receive damage and are knocked back\n\nProsecutor:\nEnter ghost form. While in ghost form, you are immune to any damage (except explosions and direct damage)",
		},
		change = {
			name = "Judge / Prosecutor",
			dsc = "\nChange between Judge and Prosecutor mode\n\nJudge:\nDamage you deal is increased by evidence cumulated on target. Attacking target reduces evidence level. Attacking players with full evidence, instantly kills them\n\nProsecutor:\nYou are slowed and you receive bullet damage protection. Looking at players gathers evidence against them",
		},
		camo_bar = {
			name = "Camouflage",
			dsc = "Remaining camouflage time",
		},
		spectate_bar = {
			name = "Surveillance",
			dsc = "Remaining surveillance time",
		},
		drain_bar = {
			name = "Examination",
			dsc = "Remaining examination time",
		},
		ghost_bar = {
			name = "Ghost",
			dsc = "Remaining ghost time",
		},
		special_bar = {
			name = "Judgement",
			dsc = "Remaining judgement time",
		},
	},

	upgrades = {
		parse_description = true,

		j_passive1 = {
			name = "Strict Judge I",
			info = "Upgrades your judge passive ability\n\t• Evidence increases damage up to additional [%j_mult]\n\t• Evidence loss on attack reduced to [%j_loss]",
		},
		j_passive2 = {
			name = "Strict Judge II",
			info = "Upgrades your judge passive ability\n\t• Evidence increases damage up to additional [%j_mult]\n\t• Evidence loss on attack reduced to [%j_loss]",
		},
		p_passive1 = {
			name = "District Attorney I",
			info = "Upgrades your prosecutor passive ability\n\t• Bullet protection increased to [%p_prot]\n\t• Slow increased to [%p_slow]\n\t• Evidence gathering rate increased to [%p_rate] pre second",
		},
		p_passive2 = {
			name = "District Attorney II",
			info = "Upgrades your prosecutor passive ability\n\t• Bullet protection increased to [%p_prot]\n\t• Slow increased to [%p_slow]\n\t• Evidence gathering rate increased to [%p_rate] pre second",
		},
		dash1 = {
			name = "Dash I",
			info = "Upgrades your dash ability\n\t• Cooldown reduced by [-dash_cd]\n\t• Damage increased by [+dash_dmg]",
		},
		dash2 = {
			name = "Dash II",
			info = "Upgrades your dash ability\n\t• Cooldown reduced by [-dash_cd]\n\t• Damage increased by [+dash_dmg]",
		},
		camo1 = {
			name = "Camouflage I",
			info = "Upgrades your camouflage ability\n\t• Cooldown reduced by [-camo_cd]\n\t• Duration increased by [+camo_dur]\n\t• You can move [camo_limit] units without interrupting this ability",
		},
		camo2 = {
			name = "Camouflage II",
			info = "Upgrades your camouflage ability\n\t• Cooldown reduced by [-camo_cd]\n\t• Duration increased by [+camo_dur]\n\t• You can move [camo_limit] units without interrupting this ability",
		},
		drain1 = {
			name = "Examination I",
			info = "Upgrades your examination ability\n\t• Cooldown reduced by [-drain_cd]\n\t• Duration reduced by [-drain_dur]",
		},
		drain2 = {
			name = "Examination II",
			info = "Upgrades your examination passive ability\n\t• Cooldown reduced by [-drain_cd]\n\t• Duration reduced by [-drain_dur]",
		},
		spect1 = {
			name = "Surveillance I",
			info = "Upgrades your surveillance ability\n\t• Cooldown reduced by [-spect_cd]\n\t• Duration increased by [+spect_dur]\n\t• Bullet damage protection increased to [%spect_prot]",
		},
		spect2 = {
			name = "Surveillance II",
			info = "Upgrades your surveillance ability\n\t• Cooldown reduced by [-spect_cd]\n\t• Duration increased by [+spect_dur]\n\t• Bullet damage protection increased to [%spect_prot]",
		},
		combo = {
			name = "Supreme Court",
			info = "Upgrades your judgement and ghost ability\n\t• Judgement protection increased to [%special_prot]\n\t• Ghost duration increased by [+ghost_dur]",
		},
		spec = {
			name = "Judgement",
			info = "Upgrades your judgement ability\n\t• Cooldown reduced by [-special_cd]\n\t• Duration increased by [+special_dur]\n\t• Protection increased to [%special_prot]",
		},
		ghost1 = {
			name = "Ghost I",
			info = "Upgrades your ghost ability\n\t• Cooldown reduced by [-ghost_cd]\n\t• Duration increased by [+ghost_dur]\n\t• Heal increased to [ghost_hel] per 1 consumed evidence",
		},
		ghost2 = {
			name = "Ghost II",
			info = "Upgrades your ghost ability\n\t• Cooldown reduced by [-ghost_cd]\n\t• Duration increased by [+ghost_dur]\n\t• Heal increased to [ghost_hel] per 1 consumed evidence",
		},
		change1 = {
			name = "Swap I",
			info = "Swap cooldown reduced by [-change_cd]",
		},
		change2 = {
			name = "Swap II",
			info = "Swap cooldown reduced by [-change_cd]. Additionally, changing mode no longer interrupts camouflage ability",
		},
	}
}

wep.SCP3199 = {
	skills = {
		_overview = { "passive", "primary", "special", "egg" },
		eggs_max = "You already have maximum eggs!",

		primary = {
			name = "Attack",
			dsc = "Perform basic attack. Hitting target activates (or refreshes) frenzy, applies deep wounds effect and grants passive stack and frenzy stack.\nAttacks deal reduced damage to targets with deep wounds. Missing the attack stops frenzy. Hitting only the target with deep wounds stops frenzy and applies tokens penalty",
		},
		special = {
			name = "Attack from Beyond",
			dsc = "Activates after [tokens] successful attacks in a row. Use to instantly end frenzy and damage all players who have deep wounds. Affected players are also slowed",
		},
		egg = {
			name = "Eggs",
			dsc = "After killing player you can spawn egg. When you receive lethal damage, you will respawn at the random egg. Respawning consumes egg. Additionally, each egg grants [prot] bullet protection (capped at [cap])\n\nCurrent eggs: [eggs] / [max]",
		},
		passive = {
			name = "Passive",
			dsc = "While in frenzy see location of nearby players without deep wounds. Gaining frenzy tokens also grant passive tokens. If your attack hits only player with deep wounds, you will lose [penalty] stacks. Passive tokens upgrade your other abilities\n\nRegenerate [heal] HP per second in frenzy\nAttack damage bonus: [dmg]\nFrenzy speed bonus: [speed]\nSpecial attack additional slow: [slow]\nSpecial attacks inflict [bleed] bleed level(s)",
		},
		frenzy_bar = {
			name = "Frenzy",
			dsc = "Remaining frenzy time",
		},
		egg_bar = {
			name = "Egg",
			dsc = "Remaining egg spawn time",
		},
	},

	upgrades = {
		parse_description = true,

		frenzy1 = {
			name = "Frenzy I",
			info = "Upgrades your frenzy ability\n\t• Duration increased by [+frenzy_duration]\n\t• Maximum stacks increased by [frenzy_max]",
		},
		frenzy2 = {
			name = "Frenzy II",
			info = "Upgrades your frenzy ability\n\t• Maximum stacks increased by [frenzy_max]\n\t• Frenzy speed increased by [%frenzy_speed_stacks] per passive stack",
		},
		frenzy3 = {
			name = "Frenzy III",
			info = "Upgrades your frenzy ability\n\t• Duration increased by [+frenzy_duration]\n\t• Frenzy speed increased by [%frenzy_speed_stacks] per passive stack",
		},
		attack1 = {
			name = "Sharp Claws I",
			info = "Upgrades your attack ability\n\t• Cooldown reduced by [-attack_cd]\n\t• Damage increased by [+attack_dmg]",
		},
		attack2 = {
			name = "Sharp Claws II",
			info = "Upgrades your attack ability\n\t• Cooldown reduced by [-attack_cd]\n\t• Damage increased by [%attack_dmg_stacks] per passive stack",
		},
		attack3 = {
			name = "Sharp Claws III",
			info = "Upgrades your attack ability\n\t• Damage increased by [+attack_dmg]\n\t• Damage increased by [%attack_dmg_stacks] per passive stack",
		},
		special1 = {
			name = "Attack from Beyond I",
			info = "Upgrades your special ability\n\t• Damage increased by [+special_dmg]\n\t• Slow increased by [%special_slow] per passive stack\n\t• Slow duration increased by [+special_slow_duration]",
		},
		special2 = {
			name = "Attack from Beyond II",
			info = "Upgrades your special ability\n\t• Damage increased by [+special_dmg]\n\t• Slow increased by [%special_slow] per passive stack\n\t• Slow duration increased by [+special_slow_duration]",
		},
		passive = {
			name = "Blood Sense",
			info = "Passive detection radius increased by [+passive_radius]",
		},
		egg = {
			name = "Easter Egg",
			info = "Instantly spawn new egg. This ability can exceed eggs limit",
		},
	}
}

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
		tesla = "Request tesla"
	},
	actions = {
		scan = "Scanning facility...",
		tesla = "Disabling tesla...",
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

wep.CANDY = { --REMOVE
	name = "Cukierek"
}

--[[-------------------------------------------------------------------------
Minigames - Global
---------------------------------------------------------------------------]]
local minigames = {}
lang.minigames = minigames

--[[-------------------------------------------------------------------------
Snake
---------------------------------------------------------------------------]]
local snake = {}
minigames.snake = snake

snake.score = "Score"
snake.high_score = "High Score"
snake.game_over = "Game Over!"
snake.paused = "Get Ready!"
snake.info = "Press W, A, S or D to start"
snake.restart = "Press space to restart"

--[[-------------------------------------------------------------------------
Data binds - DO NOT EDIT!
---------------------------------------------------------------------------]]
lang.__binds = {
	["badges"] = "ranks",
}

--[[-------------------------------------------------------------------------
Register language
---------------------------------------------------------------------------]]
RegisterLanguage( lang, "english", "en", "default" )
