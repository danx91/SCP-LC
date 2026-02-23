local lang = LANGUAGE

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
	karma = "Your karma rating: %s"
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
	max_type = "You've reached a limit of items of this type!",
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
effects.ephedrine = "Ephedrine"
effects.hemostatic = "Hemostatic"
effects.antidote = "Antidote"
effects.poison_syringe = "Poison"

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
	scp914_death = "Your heart was stopped by SCP-914",
	killer_t = "Your killer's team: %s"
}

lang.info_screen_type = {
	alive = "Alive",
	escaped = "Escaped",
	dead = "Deceased",
	mia = "Missing in Action",
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

misc.karma = {
	vbad = "Very Bad",
	bad = "Bad",
	good = "Good",
	vgood = "Very Good",
	perfect = "Outstanding",
}

misc.font = {
	name = "Fonts",
	content = [[Custom gamemode font failed to load! Falling back to system font...
It's gmod issue and I can't fix it. To fix it, you have to manually delete some files.
Navigate to 'steamapps/common/GarrysMod/garrysmod/cache/workshop/resource/fonts' and delete following files: 'impacted.ttf', 'ds-digital.ttf' and 'unispace.ttf']],
	ok = "OK"
}

--[[-------------------------------------------------------------------------
Aliases
---------------------------------------------------------------------------]]
misc.commands_aliases = {
	["admin"] = "adminmode",
	["daily"] = "bonus",
	["mute"] = "muteall",
	["unmute"] = "unmuteall",
	["config"] = "settings",
	["cfg"] = "settings",
}

--[[-------------------------------------------------------------------------
Pages
---------------------------------------------------------------------------]]
lang.SLCPAGES = {}
lang.SLCPAGES.message = "Message"
lang.SLCPAGES.error = "Error"
lang.SLCPAGES.fatal = "Fatal Error"

local pages = {}
lang.SLCPAGES.PAGES = pages

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
