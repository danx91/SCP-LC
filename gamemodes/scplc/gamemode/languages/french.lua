--[[-------------------------------------------------------------------------
Language: English
Date: 15.02.2021
Translated by: danx91 (aka ZGFueDkx)
---------------------------------------------------------------------------]]

local lang = {}

lang.self = "Français" --Language name (not translated)
lang.self_en = "French" --Language name (in english)

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Vous pouvez être sélectionné comme SCP a partir du prochain round",
	scpwait = "Vous devez attendre %i rounds avant de pouvoir jouer en tant que SCP",
	abouttostart = "La partie va commencer dans %i secondes!",
	kill = "Vous avez reçu %d points pour avoir tué %s: %s!",
	kill_n = "Vous avez tué %s: %s!",
	assist = "Vous avez reçu %d points pour avoir contribué a la mort d'un joueur: %s!",
	rdm = "Vous avez perdu %d points pour avoir tué %s: %s!",
	acc_denied = "Accès refusé",
	acc_granted = "Accès accordé",
	acc_omnitool = "Un Omnitool est nécessaire pour faire fonctionner cette porte",
	device_noomni = "Un Omnitool est nécessaire pour faire fonctionner cet appareil",
	elevator_noomni = "Un Omnitool est nécessaire pour faire fonctionner cet ascenseur",
	acc_wrong = "Un niveau d'accrédidation plus élevé est nécessaire pour effectuer cette action",
	rxpspec = "Vous avez reçu %i points d'experience pour avoir joué sur le serveur!",
	rxpplay = "Vous avez reçu %i points d'experience pour avoir survécu ce round!",
	rxpplus = "Vous avez reçu %i points d'experience pour avoir survécu plus de la moitié du round!",
	roundxp = "Vous avez reçu %i points d'experience pour vos points",
	gateexplode = "Temps avant explosion de la Gate A: %i",
	explodeterminated = "Explosion de la Gate A terminée",
	r106used = "La procédure de reconfinement de SCP 106 ne peut être effectuée qu'une fois par round",
	r106eloiid = "Désactivez l'électroaimant ELO-IID afin de démarrer la procédure de reconfinement de SCP 106",
	r106sound = "Activez la transmission sonore afin de démarrer la procédure de reconfinement de SCP 106",
	r106human = "Un humain vivant est nécessaire en cage afin de démarrer la procédure de reconfinement de SCP 106",
	r106already = "SCP 106 est déjà reconfiné",
	r106success = "Vous avez reçu %i points pour avoir reconfiné SCP 106!",
	vestpickup = "Vous avez enfilé une tenue",
	vestdrop = "Vous avez retiré votre tenue",
	hasvest = "Vous avez déjà une tenue! Utilisez l'EQ pour la retirer",
	escortpoints = "Vous avez reçu %i points pour avoir escorté vos alliés",
	femur_act = "Femur Breaker activé...",
	levelup = "Vous avez monté de niveau! Votre niveau actuel est: %i",
	healplayer = "Vous avez reçu %i points pour avoir soigné d'autres joueurs",
	detectscp = "Vous avez reçu %i points pour avoir detecté des SCP",
	winxp = "Vous avez reçu %i points d'experience votre équipe originale a gagné la partie",
	winalivexp = "Vous avez reçu %i points d'experience car votre équipe a gagné la partie",
	upgradepoints = "Vous avez reçu de nouveaux points d'amélioration! Appuyez sur '%s' le menu d'amélioration des SCP",
	omega_detonation = "L'OMEGA Warhead explose dans %i secondes. Rendez vous a la surface ou a l'abri anti explosion!",
	alpha_detonation = "L'ALPHA Warhead explose dans %i secondes. Rendez vous a l'intérieur ou evacuez immédiatement!",
	alpha_card = "Vous avez inséré la carte nucléaire de l'ALPHA WARHEAD",
	destory_scp = "Vous avez reçu %i points pour avoir détruit un objet SCP!",
	afk = "Vous êtes AFK. Pendant cette période vous ne réapparaitrez pas, et votre gain en exp sera annulé!",
	afk_end = "Vous n'êtes plus AFK",
	overload_cooldown = "Attendez %i secondes pour pouvoir surcharger cette porte!",
	advanced_overload = "Cette porte a l'air plus puissante! Réessayez dans %i secondes",
	lockdown_once = "Le confinement de l'installation ne peut être utilisée qu'une fois par partie !",
	dailybonus = "Bonus journalier restant: %i XP\nProchaine rénitialisation dans: %s",
	xp_goc_device = "Vous avez reçu %i XP pour avoir déployé le dispositif de la CMO!",
	goc_device_destroyed = "Vous avez reçu %i points pour avoir détruir le dispositif de la CMO!",
	goc_detonation = "L'OMEGA et L'ALPHA Warhead vont exploser dans %i secondes. Procédez a l'évacuation ou réfugiez vous dans l'abri anti nucléaire !",
	fuserating = "Vous avez besoin d'un fusible plus puissant!",
	nofuse = "Vous avez besoin d'un fusible pour utiliser cet appareil",
	cantremfuse = "Le fusible est en surchauffe. Impossible de le retirer maintenant !",
	fusebroken = "Le fusible est cassé et semble impossible a retirer!",
	nopower = "Vous avez appuyé sur le bouton, mais rien ne se passe...",
	nopower_omni = "Vous avez placé votre omnitool devant le lecteur, mais rien ne se passe...",
	docs = "Vous avez reçu %i points pour vous etre échappé avec %i document(s)",
	docs_pick = "Vous avez des documents de valeur de la fondation en votre possession - échappez vous avec pour être récompensé!",
	gaswarn = "La %s sera gazée dans 60 secondes ",
	queue_alive = "Vous êtes en vie",
	queue_not = "Vous n'êtes pas dans la file d'attente!",
	queue_low = "Vous êtes dans la file d'attente basse priorité !",
	queue_pos = "Votre position dans la file d'attente: %i",
	support_optout = "Vous n'êtes pas apparu en tant que support car vous avez choisi de ne pas apparaitre. Vous pouvez changer ça en faisant !settings dans le chat",
	property_dmg = "Vous avez perdu %d points pour avoir détruit du matériel de la fondation!",
	unknown_cmd = "Commande inconnue: %s"
}

lang.NFailed = "Failed to access NRegistry with key: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "Vous vous êtes échappé!",
	escapeinfo = "Bon travail! Vous vous êtes échappé en %s",
	escapexp = "Vous avez reçu %i points d'experience",
	escort = "Vous avez été escorté!",
	roundend = "Round terminé!",
	nowinner = "Aucun vainqueur dans ce round!",
	roundnep = "Il n'y a pas assez de joueurs!",
	roundwin = "Gagnant du round: %s",
	roundwinmulti = "Gagnants du round: [RAW]",
	shelter_escape = "Vous avez survécu a l'explosion dans le bunker",
	alpha_escape = "Vous vous êtes échappé avant l'explosion de l'Alpha Warhead",

	mvp = "MVP: %s avec un score de: %i",
	stat_kill = "Joueurs tués: %i",
	stat_rdm = "Nombre de teamkill: %i",
	stat_rdmdmg = "Nombre de dégâts sur alliés: %i",
	stat_dmg = "Dégâts infligés: %i",
	stat_bleed = "Dégâts de saignement: %i",
	stat_106recontain = "SCP 106 a été reconfiné",
	stat_escapes = "Joueurs échappés: %i",
	stat_escorts = "Joueurs escortés: %i",
	stat_023 = "Morts soudaines causées par SCP 023: %i",
	stat_049 = "Personnes soignées: %i",
	stat_0492 = "Joueurs mutilés par les zombies: %i",
	stat_058 = "Joueurs tués par SCP-058: %i",
	stat_066 = "Sons joués: %i",
	stat_096 = "Joueurs tués par L'Homme Timide: %i",
	stat_106 = "Joueurs téléportés dans la dimension de poche: %i",
	stat_173 = "Nuques brisées: %i",
	stat_457 = "Joueurs incinérés: %i",
	stat_682 = "Joueurs tués par le Reptile Indestructible: %i",
	stat_8602 = "Joueurs cloués aux murs: %i",
	stat_939 = "Nombre de proies de SCP 939: %i",
	stat_966 = "Nombre de coupures insidieuses: %i",
	stat_3199 = "Nombre d'assassinats de SCP 3199: %i",
	stat_24273 = "Nombres de jugements par SCP 2427-3: %i",
	stat_omega_warhead = "L'Omega warhead a été activée",
	stat_alpha_warhead = "L'Alpha warhead a été activée",
	stat_goc_warhead = "Le dispositif de la CMO a été activé",
}

lang.NCFailed = "Failed to access NCRegistry with key: %s"

--[[-------------------------------------------------------------------------
Main menu
---------------------------------------------------------------------------]]
local main_menu = {}
lang.MenuScreen = main_menu

main_menu.start = "Commencer"
main_menu.settings = "Options"
main_menu.precache = "Precache models"
main_menu.credits = "Credits"
main_menu.quit = "Quitter"

main_menu.quit_server = "Quitter le serveur?"
main_menu.quit_server_confirmation = "Vous êtes sûr ?"
main_menu.model_precache = "Precache models"
main_menu.model_precache_text = "Les modèles sont automatiquement mis en cache lorsque cela est nécessaire, mais cela se produit pendant le jeu, ce qui peut provoquer des pics de lags. Pour l'éviter, vous pouvez maintenant les pré-cacher manuellement.\nVotre jeu peut freeze durant le processus!"
main_menu.yes = "Oui"
main_menu.no = "Non"
main_menu.all = "Precache models"
main_menu.cancel = "Annuler"

main_menu.credits_text = [[Gamemode created by ZGFueDkx (aka danx91)
Gamemode is based on SCP and released under CC BY-SA 3.0 license

Menu animations are created by Madow

Models:
	Alski - guards, omnitool, turret and more

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

hud.pickup = "Ramasser"
hud.class = "Classe"
hud.team = "Équipe"
hud.class_points = "Points de débloquage de classes"
hud.prestige_points = "Points de prestige"
hud.hp = "PV"
hud.stamina = "Endurance"
hud.sanity = "Santé mentale"
hud.xp = "XP"
hud.extra_hp = "PV supplémentaires"

hud.escaping = "Escaping..."
hud.escape_blocked = "Escape Blocked!"
hud.waiting = "En attente de joueu"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
local eq = {}
lang.EQ = eq

eq.eq = "Equipement"
eq.actions = "Actions"
eq.backpack = "Sac a dos"
eq.id = "Ceci est votre ID. Montrez le aux autres pour révéler votre équipe"
eq.no_id = "Vous n'avez pas d'ID"
eq.class = "Votre classe: "
eq.team = "Votre équipe: "
eq.p_class = "Votre fausse classe: "
eq.p_team = "Votre fausse équipe: "
eq.allies = "Vos alliés:"
eq.durability = "Durabilité: "
eq.mobility = "Mobilité: "
eq.weight = "Poids: "
eq.weight_unit = "KG"
eq.multiplier = "Multiplicateur de dégats:"

lang.eq_unknown = "Objet inconnu"
lang.durability = "Durabilité"
lang.info = "Informations"

lang.eq_buttons = {
	escort = "Escorter",
	gatea = "Detruire la Gate A"
}

lang.pickup_msg = {
	max_eq = "Votre inventaire est complet !",
	cant_stack = "Vous avez atteint la limite de cet objet!",
	has_already = "Vous avez déjà cet objet !",
	same_type = "Vous avez déjà un objet du même type !",
	one_weapon = "Vous ne pouvez avoir qu'une seule arme a feu a la fois !",
	goc_only = "Seul les membres de la CMO peuvent ramasser cela !"
}

--[[-------------------------------------------------------------------------
XP Bar
---------------------------------------------------------------------------]]
lang.XP_BAR = {
	general = "Experience Générale",
	round = "Rester sur le serveur",
	escape = "S'échapper de l'installation",
	score = "Score gagné durant la partie",
	win = "Gagner la partie",
	vip = "Bonus VIP",
	daily = "Bonus journalier",
	cmd = "Pouvoir Divin",
}

--[[-------------------------------------------------------------------------
AFK Warning
---------------------------------------------------------------------------]]
lang.AFK = {
	afk = "Vous êtes AFK!",
	afk_warn = "Avertissement AFK",
	slay_warn = "Vous êtes sur le point d'être tué et marqué comme AFK!",
	afk_msg = "Vous n'allez plus apparaitre, ni gagner d'EXP!",
	afk_action = "-- Appuyez sur n'importe quel bouton pour être de nouveau -actif --",
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
effects.insane = "Psychotique"
effects.gas_choke = "Étouffement"
effects.radiation = "Radiation"
effects.deep_wounds = "Bléssure profonde"
effects.poison = "Poison"
effects.heavy_bleeding = "Grosse Hemorragie"
effects.spawn_protection = "Anti SpawnKill"
effects.fracture = "Fracture"
effects.decay = "Désintégration"
effects.scp_chase = "En Chasse"
effects.human_chase = "En Chasse"
effects.expd_rubber_bones = "Effet experimental"
effects.expd_stamina_tweaks = "Effet experimental"
effects.expd_revive = "Effet experimental"
effects.expd_recovery = "Récupération"
effects.electrical_shock = "Choc électrique"
effects.scp009 = "SCP-009"
effects.scp106_withering = "Dépérissement"
effects.scp966_effect = "Fatigue"
effects.scp966_mark = "Marque de la mort"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Apperçu des classes"
lang.preview = "Aperçu"
lang.random = "Aléatoire"
lang.buy = "Acheter"
lang.buy_prestige = "Acheter - Prestige"
lang.refund = "Remboursement"
lang.prestige = "Prestige"
lang.prestige_warn = "Vous êtes sur le point de prestige. Vous allez perdre : XP/Niveaux/Classes et un point de prestige vous sera accordé .\n\nWARNING: Cette action ne peut pas être annulée !!"
lang.none = "Aucun"
lang.refunded = "Toutes vos classes ont étés remboursées. Vous recevez %d points de classe et %d points de prestige!"
lang.tierlocked = "Vous devez acheter les classes précédentes de cette catégorie avant de pouvoir acheter cette classe"
lang.xp = "XP"
lang.level = "Niveaux"

lang.details = {
	details = "Details",
	prestige = "Récompense de prestige",
    name = "Nom",
	tier = "Tier",
    team = "Équipe",
    walk_speed = "Vitesse de marche",
	run_speed = "Vitesse de course",
    chip = "Puce d'accès",
	persona = "Faux ID",
	loadout = "Arme principale",
	weapons = "Armes",
	class = "Classe",
	hp = "Points de vie",
	speed = "Vitesse",
	health = "Points de vie",
   	sanity = "Santé mentale",
	slots = "Slots de support",
	no_select = "Ne peut pas spawn dans le round"
}

lang.headers = {
	support = "Support",
	classes = "Classes",
	scp = "SCP"
}

lang.view_cat = {
	classd = "Classes D",
	sci = "Scientifiques",
    guard = "Sécurité",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alpha-1",
	ci = "Insurrection Du Chaos",
	goc = "CMO",
}

local l_weps = {
	pistol = "pistolet",
	smg = "SMG",
	rifle = "fusil",
	shotgun = "fusil à pompe",
}

local l_tiers = {
	low = "Low tier",
	mid = "Mid tier",
	high = "High tier",
}

lang.loadouts = {
	grenade = "Grenade aléatoire",
	pistol_all = "Pistolet aléatoire",
	smg_all = "SMG aléatoire",
	rifle_all = "Fusil aléatoire",
	shotgun_all = "Fusil à pompe aléatoire",
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
	settings = "Paramètres du gamemode",

	none = "Aucune",
	press_key = "> Appuyez sur une touche <",
	client_reset = "Réinitialiser les paramètres du client",
	server_reset = "Réinitialiser les paramètres du serveur",

	client_reset_desc = "Vous êtes sur le point de réinitialiser vos paramètres du gamemode.\nCette action ne peut pas être annulée!",
	server_reset_desc = "Pour des raisons de sécurité vous ne pouvez pas faire ça ici.\nPour réinitialiser les paramètres du serveur, entrez 'slc_factory_reset' dans la console serveur et suivez les instructions.\nFaites attention, cette action ne peut pas être annulée et va TOUT remettre a zéro!",

	popup_ok = "Ok",
	popup_cancel = "Annuler",
	popup_continue = "Continuer",

	panels = {
		binds = "Touches clavier",
		general_config = "Configuration générale",
		hud_config = "Configuration HUD",
		performance_config = "Performances",
		scp_config = "Configuration SCP",
		skins = "kins",
		reset = "Réinitialiser le Gamemode",
		cvars = "Éditeur de ConVars",
	},

	binds = {
		eq_button = "Equipement",
		upgrade_tree_button = "Arbre de compétence",
		ppshop_button = "Visualisateur de classes",
		settings_button = "Paramètres du gamemode",
		scp_special = "Abilité spéciale des SCP"
	},

	config = {
		search_indicator = "Afficher l'indicateur de recherche",
		scp_hud_skill_time = "Afficher le cooldown des compétences SCP",
		smooth_blink = "Activer le clignement doux",
		scp_hud_overload_cd = "Montrer le cooldown de la surcharge",
		any_button_close_search = "N'importe quel bouton ferme le menu de recherche",
		hud_hitmarker = "Montrer les hitmarkers",
		hud_hitmarker_mute = "Retirer le son des hitmarkers",
		hud_damage_indicator = "Show damage indicator",
		scp_hud_dmg_mod = "Afficher le modificateur de dégats des SCP",
		scp_nvmod = "Augmente la luminosité de l'écran en tant que SCP",
		dynamic_fov = "FOV dynamique",
		hud_draw_crosshair = "Afficher le crosshair",
		hud_hl2_crosshair = "Legacy HL2 crosshair",
		hud_lq = "Images et polygones de faible qualité (si possible)",
		hud_image_poly = "Images au lieu de polygones (si possible)",
		hud_windowed_mode = "Décalage HUD (pour le mode fenêtré)",
		hud_avoid_roman = "Éviter les chiffres romains",
		hud_escort = "Afficher les zones d'escorte",
		hud_timer_always = "Toujours montrer le temps restant",
		hud_stamina_always = "Toujours montrer l'endurance",
		eq_instant_desc = "Description instantanée de l'objet dans l'inventaire",
		scp106_spots = "Toujours afficher les portails de SCP-106",

		cvar_slc_support_optout = "Support spawn opt-out",
		cvar_slc_language = "Langage",
		cvar_slc_language_options = {
			default = "Default",
		},
		cvar_slc_hud_scale = "Taille HUD",
		cvar_slc_hud_scale_options = {
			normal = "Normal",
			big = "Grand",
			vbig = "très Grand",
			small = "Petit",
			vsmall = "Très Petit",
			imretard = "Minuscule",
		},

		hud_skin_main = "Main",
		hud_skin_scoreboard = "Scoreboard",
		hud_skin_hud = "HUD",
		hud_skin_eq = "Equipement",

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
		feature = "Features"
	}
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Unconnected"

lang.scoreboard = {
	name = "Scoreboard",
	playername = "Nom",
	ping = "Ping",
	level = "Niveau",
	score = "Score",
	ranks = "Rangs",
	badges = "Badges",
}

lang.ranks = {
	superadmin = "Superadmin",
	admin = "Admin",
	author = "Créateur",
	vip = "VIP",
	contributor = "Contributeur",
	translator = "Traducteur",
	tester = "Testeur",
	patron = "Patron",
	hunter = "Chasseur de bug"
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
	tree = "%s Améliorer l'arbre",
	points = "Points",
	cost = "Coût",
	owned = "Possédé",
	requiresall = "Necessite",
	requiresany = "Necessite tout",
	blocked = "Bloqué par"
}

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
lang.SCPHUD = {
	skill_not_ready = "L'abilité n'est pas encore prête!",
	skill_cant_use = "L'abilité ne peut pas être utilisée maintenant!",
	overload_cd = "Prochaine surcharge: ",
	overload_ready = "Surcharge prête!",
	damage_scale = "Dégats reçus"
}

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "Sujet",
	class = "Classe",
	team = "Équipe",
	status = "Status",
	objectives = "Objectifs",
	details = "Details",
	registry_failed = "info_screen_registry failed"
}

lang.info_screen_registry = {
	escape_time = "Vous vous êtes échappé en %s minutes",
	escape_xp = "Vous avez reçu %s points experience",
	escape1 = "Vous vous êtes échappé de la fondation",
	escape2 = "Vous vous êtes échappé pendant le décompte de la warhead",
	escape3 = "Vous avez survécu dans le bunker",
	escorted = "Vous avez étés escorté",
	killed_by = "VOus avez été tué par: %s",
	suicide = "Vous vous êtes suicidé",
	unknown = "la cause de votre mort est inconnue",
	hazard = "Vous êtes mort comme une merde",
	alpha_mia = "Dernière position connue: A la surface",
	omega_mia = "Dernière position connue: Dans la fondation",
	killer_t = "L'équipe de celui qui vous a tué: %s"
}

lang.info_screen_type = {
	alive = "Vivant",
	escaped = "Échappé",
	dead = "Décédé",
	mia = "Porté disparu",
	unknown = "Inconnu",
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
	idle = "l'OMEGA Warhead est inactive\n\nEn attente d'activation...",
	waiting = "l'OMEGA Warhead est inactive\n\nPremière activation acceptée!\nEn attente de la seconde...",
	failed = "L'OMEGA Warhead est vérouillée\n\nSeconde activation non détéctée!\nPatientez %is",
	no_remote = "L'OMEGA Warhead a échouée\n\nLa connection a la warhead n'a pas pu être établie!\t",
	active = "L'OMEGA Warhead est enclenchée\n\nProcedez a l'évacuation immédiatement!\nDetonation dans %.2fs",
}

misc.alpha_warhead = {
	idle = "ALPHA Warhead est inactive\n\nEn attente des codes nucléaires...",
	ready = "ALPHA Warhead est inactive\n\nCodes acceptés!\nEn attente de l'activation...",
	no_remote = "L'ALPHA Warhead a échouée\n\nLa connection a la warhead n'a pas pu être établie!\t",
	active = "ALPHA Warhead est enclenchée\n\nProcedez a l'évacuation immédiatement!\nDetonation dans %.2fs",
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
	MOUSE1 = "Clique Gauche",
	MOUSE2 = "Clique Droit",
	MOUSE3 = "Clique Molette",
}

misc.inventory = {
	unsearched = "Non fouillé",
	search = "Appuyez [%s] pour fouiller",
	unknown_chip = "Puce inconnue",
	name = "Nom",
	team = "Équipe",
	death_time = "Timer de mort",
	time = {
		[0] = "A l'instant",
		"Il y a une minute",
		"Il y a deux minutes",
		"Il y a trois minutes",
		"Il y a quatre minutes",
		"Il y a cinq minutes",
		"Il y a six minutes",
		"Il y a sept minutes",
		"Il y a huit minutes",
		"Il y a neuf minutes",
		"Il y a dix minutes",
		long = "Il y a plus de dix minutes",
	},
}

misc.font = {
	name = "Fonts",
	content = [[Custom gamemode font failed to load! Falling back to system font...
It's gmod issue and I can't fix it. To fix it, you have to manually delete some files.
Navigate to 'steamapps/common/GarrysMod/garrysmod/cache/workshop/resource/fonts' and delete following files: 'impacted.ttf', 'ds-digital.ttf' and 'unispace.ttf']],
	ok = "OK"
}
--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "Tenue de garde de sécurité"
vest.heavyguard = "Tenue de garde lourd"
vest.specguard = "Tenue de garde spécial"
vest.guard_medic = "Tenue de garde secouriste"
vest.ntf = "Tenue d'MTF NTF"
vest.mtf_medic = "Tenue de médecin MTF NTF"
vest.ntfcom = "Tenue de commandant MTF NTF"
vest.alpha1 = "Tenue de MTF Alpha-1"
vest.ci = "Tenue de l'Insurrection du Chaos"
vest.cicom = "Tenue de commandant de l'IC"
vest.cimedic = "Tenue de médecin IC"
vest.goc = "Tenue de la CMO"
vest.gocmedic = "Tenue de médecin de la CMO"
vest.goccom = "Tenue de commandant de la CMO"
vest.fire = "Tenue ignifuge"
vest.electro = "Tenue électrorésistante"
vest.hazmat = "Tenue Hazmat"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Dégâts de brûlure"
dmg.SHOCK = "Dégâts électriques"
dmg.BULLET = "Dégâts par balle"
dmg.FALL = "Dégâts de chûte"
dmg.POISON = "Dégâts de poison"

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.unknown = "inconnu"

teams.SPEC = "Spectateurs"
teams.CLASSD = "Classe D"
teams.SCI = "Scientifique"
teams.GUARD = "Securité"
teams.MTF = "MTF"
teams.CI = "IC"
teams.GOC = "CMO"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
lang.UNK_CLASSES = {
	CLASSD = "Classe D inconnu",
	SCI = "Scientifique inconnu",
	GUARD = "Garde inconnu",
}

local classes = {}
lang.CLASSES = classes

classes.unknown = "Inconnu"
classes.spectator = "Spectateur"

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

classes.classd = "Classe D"
classes.veterand = "Classe D Vétéran"
classes.kleptod = "Classe D Kleptomane"
classes.contrad = "Classe D Avec Contrebande"
classes.ciagent = "Agent IC"
classes.expd = "Classe D Experimentale"
classes.classd_prestige = "Classe D Tailleur"

classes.sciassistant = "Assistant Chercheur"
classes.sci = "Chercheur"
classes.seniorsci = "Chercheur confirmé"
classes.headsci = "Superviseur"
classes.contspec = "Spécialiste du confinement"
classes.sci_prestige = "Classe D En Fuite"

classes.guard = "Garde De Sécurité"
classes.chief = "Chef Des Gardes"
classes.lightguard = "Garde De Sécurité Léger"
classes.heavyguard = "Garde De Sécurité Lourd"
classes.specguard = "Garde De Sécurité Spécialisé"
classes.guardmedic = "Garde De Sécurité Secouriste"
classes.tech = "Garde de sécurité technicien"
classes.cispy = "Espion de l'Insurrection Du Chaos"
classes.lightcispy = "Espion IC léger"
classes.heavycispy = "Espion IC lourd"
classes.guard_prestige = "Garde De Sécurité Ingénieur"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Fusil a pompe"
classes.ntf_3 = "MTF NTF - Fusil d'assault"
classes.ntfcom = "Commandant MTF NTF"
classes.ntfsniper = "MTF NTF Sniper"
classes.ntfmedic = "MTF NTF Medecin"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Tireur d'élite"
classes.alpha1medic = "MTF Alpha-1 Médecin"
classes.alpha1com = "Commandant MTF Alpha-1"
classes.ci = "Insurrection Du Chaos"
classes.cisniper = "Sniper de l'Insurrection Du Chaos"
classes.cicom = "Commandant de l'Insurrection Du Chaos"
classes.cimedic = "Médecin de l'Insurrection Du Chaos"
classes.cispec = "Spécialiste de l'Insurrection Du Chaos"
classes.ciheavy = "Unité lourde de l'Insurrection Du Chaos"
classes.goc = "Soldat de la CMO"
classes.gocmedic = "Médecin de la CMO"
classes.goccom = "Commandant de la CMO"

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
local generic_classd = [[- Échappez vous de la fondation
- Évitez les membres du personnel et les SCP
- Coopérez avec les autres]]

local generic_sci = [[- Échappez vous de la fondation
- Évitez les Classes D et les SCP
- Coopérez avec les gardes et les MTF]]

local generic_guard = [[- Secourrez les scientifiques
- Tuez tout les classes D et les SCP
- Écoutez votre superviseur]]

local generic_cispy = [[- Prétendez être un garde
- Aidez les Classes D encore en vie
- Sabotez la sécurité du site]]

local generic_ntf = [[- Rendez vous dans la fondation
- Aidez le personnel restant a l'intérieur
- Ne laissez ni les classes D, ni les SCP
s'enfuir ]]

local generic_scp = [[- Échappez vous de la fondation
- Tuez tout ceux que vous rencontrez
- Coopérez avec les autres SCP]]

local generic_scp_friendly = [[- Échappez vous de la fondation
- Vous pouvez coopérer avec les humains
- Coopérez avec les autres SCP]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	contrad = generic_classd,

	ciagent = [[- Escortez les Classes D
- Évitez les membres du personnel et les SCP
- Coopérer avec les autres]],

	expd = [[- Échappez vous de la fondation
- Évitez les membres du personnel et les SCP
- Vous avez survécu a d'étranges expériences]],

	classd_prestige = [[- Échappez vous de la fondation
- Évitez les membres du personnel et les SCP
- Vous pouvez voler les vêtements des morts]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	contspec = generic_sci,

	sci_prestige = [[- Échappez vous de la fondation
- Évitez les membres du personnel et les SCP
- Vous avez volé vêtements et ID
 d'un scientifique]],

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Sauvez les scientifiques
- Tuez les Classes D et les SCP
- Donnez vos ordres aux gardes]],

	guardmedic = [[- Sauvez les scientifiques
- Tuez les Classes D et les SCP
- Aidez les autres gardes avec votre kit de soin]],

	tech = [[- Sauvez les scientifiques
- Tuez les Classes D et les SCP
- Aidez les autres gardes avec votre tourelle]],

	cispy = generic_cispy,

	lightcispy = generic_cispy,

	heavycispy = generic_cispy,

	guard_prestige = [[- Sauvez les scientifiques
    - Tuez les Classes D et les SCP
	- Vous pouvez bloquer les portes]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- Aidez le personnel restant a l'intérieur
- Aidez les autres MFT avec votre kit de soin
- Ne laissez ni les Classes D, ni les SCP s'échapper]],

	ntfcom = [[- Aidez le personnel restant a l'intérieur
- Ne laissez ni les Classes D, ni les SCP s'échapper
- Donnez vos ordres aux autres MTF]],

	ntfsniper = [[- Aidez le personnel restant a l'intérieur
- Ne laissez ni les Classes D, ni les SCP s'échapper
- Protegez votre équipe de derrière]],

	alpha1 = [[- Protegez la fondation a tout prix
- Arrêtez tout les Classes D et les SCP
- Vous êtes autorisé à ]].."[CLASSIFIÉ]",

	alpha1sniper = [[- Protegez la fondation a tout prix
- Arrêtez tout les Classes D et les SCP
- Vous êtes autorisé à ]].."[CLASSIFIÉ]",

	alpha1medic = [[- Protegez la fondation a tout prix
- Arrêtez tout les Classes D et les SCP
- Vous êtes autorisé à ]].."[CLASSIFIÉ]",

	alpha1com = [[- Protegez la fondation a tout prix
- Donnez des ordres a vos hommes
- Vous êtes autorisé à ]].."[CLASSIFIÉ]",

	ci = [[- Aidez les Classes D
- Éliminez tout le personnel de la fondation
- Écoutez votre commandant]],

	cisniper = [[- Aidez les Classes D
- Éliminez tout le personnel de la fondation
- Protégez votre équipe a distance]],

    cicom = [[- Aidez les Classes D
- Éliminez tout le personnel de la fondation
- Donnez vos ordres aux autres IC]],

	cimedic = [[- Aidez le personnel de Classe D
- Aidez les autres IC avec votre kit de soin
- Écoutez votre commandant]],

	cispec = [[- Aidez le personnel de Classe D
- Aidez les autres IC avec votre tourelle
- Écoutez votre commandant]],

	ciheavy = [[- Aidez le personnel de Classe D
- Éliminez tout le personnel de la fondation
- Écoutez votre commandant]],

	goc = [[- Détruisez tout les SCP
- Localisez et déployez le dispositif de la CMO
- Écoutez votre commandant]],

	gocmedic = [[- Détruisez tout les SCP
- Aidez les soldats a l'aide de votre kit de soin
- Écoutez votre commandant]],

	goccom = [[- Détruisez tout les SCP
- Localisez et déployez le dispositif de la CMO
- Donnez des ordres a vos soldats]],

	SCP023 = generic_scp,

	SCP049 = [[- Échappez vous de la fondation
- Cooperez avec les autres SCP
- Soignez les humains]],

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
	classd = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Faible
Peut s' chapper : Oui
Peut escorter : Non
Escort  par : IC

Aperçu:
Classe Basique. Coopérez avec les autres pour faire face aux SCP et aux membres du personnel. Vous pouvez etre escorté par des IC.
]],

	veterand = [[Difficulté: Facile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Peut s' chapper : Oui
Peut escorter : Non
Escort  par : IC

Aperçu:
Classe plus avancée. Vous avez un accès basique a la fondation. Coopérez avec les autres pour faire face aux SCP et aux membres du personnel. Vous pouvez etre escorté par des IC.
]],

	kleptod = [[Difficulté: Difficile
Resistance: Faible
Agilité: Très Élevée
Potentiel de combat: Faible
Peut s'échapper : Oui
Peut escorter : Non
Escorté par : IC
Aperçu:

Classe a forte utilité. Vous commencez avec un objet aléatoire. Coopérez avec les autres pour faire face aux SCP et les membres du personnel. Vous pouvez etre escorté par des IC.
]],

	contrad = [[Difficulté: Medium
Résistance: Normal
Agilité: Normal
Potentiel de combat: Normal
Peut s'échapper: Yes
Peut escorter: Non
Escorté par: CI

Aperçu:
Classe avec une arme de contrebande. Utilisez la correctement, cette dernière n'est pas durable.
]],

	ciagent = [[Difficulté: Moyenne
Resistance: Très Élevée
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper : Non
Peut escorter : Classes D
Escorté par : Personne
Aperçu:

Un IC armé d'un Tazer. Profitez en pour aider les Classes D et coopérer avec eux. Vous pouvez escorter les Classes D.
]],

	expd = [[Difficulté: ?
Resistance: ?
Agilité: ?
Potentiel de combat: ?
Peut s'échapper: Oui
Peut escorter: Personne
Escorté par: IC

Aperçu:
Classe qui a vécu des choses étranges dans la fondation. Qui sait ce qui s'est vraiment passé...
]],

	classd_prestige = [[Difficulty: Difficile
Resistance: Normale
Agility: Normale
Potentiel de combat: Élevé
Peut s'échapper: Oui
Peut escorter: Personne
Escorté par: IC

Overview:
Ressemble a une classe basique mais possède l'abilité de voler les vêtements sur les cadavres. Coopérez avec les autres pour faire face aux SCP et au personnel de la fondation. Vous pouvez être escortés par les IC.
]],

sciassistant = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Normale
Potentiel de combat: Faible
Peut s'échapper : Oui
Peut escorter : Non
Escorté  par : Sécurité, Mtf
Aperçu:
Classe basique. Coopérez avec le personnel de la fondation et restez éloigné des SCP. Vous pouvez etre escorté par les MTF
]],

	sci = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Normale
Potentiel de combat: Faible
Peut s'échapper : Oui
Peut escorter : Non
Escorté par : Sécurité, Mtf
Aperçu:
Classe scientifique. Coopérez avec le personnel de la fondation et restez éloigné des SCP. Vous pouvez etre escorté par les MTF
]],

	seniorsci = [[Difficulté: Facile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper : Oui
Peut escorter : Non
Escorté par : Sécurité, Mtf
Aperçu:
Classe scientifique. Vous avez une accréditation plus élevée. Coopérez avec le personnel de la fondation et restez éloigné des SCP. Vous pouvez etre escorté par les MTF
]],

	headsci = [[Difficulté: Facile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper : Oui
Peut escorter : Non
Escorté par : Sécurité, Mtf

Aperçu:
Meilleure classe scientifique. Vous avez plus de stats. Coopérez avec le personnel de la fondation et restez éloigné des SCP. Vous pouvez etre escorté par les MTF
]],


	contspec = [[Difficulté: Moyenne
Résistance: Très Élevée
Agilité: Très Élevée
Potentiel de combat: Faible
Peut s'échapper : Oui
Peut escorter : Non
Escorté par : Sécurité, Mtf

Aperçu:
Scientifique avec les meilleures resistances. Coopérez avec le personnel et restez loin des SCP. Vous pouvez etre escorté par les MTF.
]],

	sci_prestige = [[Difficulté: Difficile
Résistance: Normale
Agilité: Normale
Potentiel de combat: Moyen
Peut s'échapper: Oui
Peut escorter: Personne
Escorté par: IC

Overview:
Classe D qui est entré par effraction dans le placard de certains scientifiques et a volé des vêtements et l'ID. Faites semblant d'être un scientifique et coopérez avec les classes D et IC..
]],

guard = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Normal
Peut s'échapper : Non
Peut escorter : Scientifiques
Escorté par : Personne
Aperçu:
Classe de sécurité basique. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP
]],

	lightguard = [[Difficulté: Difficile
Resistance: Faible
Agilité: Très Élevée
Potentiel de combat: Faible
Peut s'échapper : Non
Peut escorter : Scientifiques
Escorté par : Personne

Aperçu:
Classe de sécurité. Vitesse élevée, pas d'armure et peu d'HP. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP
]],

	heavyguard = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Faible
Potentiel de combat: Élevé
Peut s'échapper : Non
Peut escorter : Scientifiques
Escorté par : Personne

Aperçu:
Classe de sécurité. Vitesse faible, meilleure armure et plus d'HP. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP
]],

    specguard = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Faible
Potentiel de combat: Très Élevé
Peut s'échapper : Non
Peut escorter : Scientifiques
Escorté par : Personne

Aperçu:
Classe de sécurité. Vitesse pas si élevée, plus d'HP et un gros potentiel de combat. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP
]],

	chief = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Normal
Peut s'échapper : Non
Peut escorter : Scientifiques
Escorté par : Personne
Aperçu:
Classe de sécurité. Possède un meilleur potentiel de combat et un tazer. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP
]],

	guardmedic = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Faible
Peut s'échapper : Non
Peut escorter : Scientifiques
Escorté par : Personne
Aperçu:
Classe de sécurité, vous avez un kit de soin et un tazer. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP
]],

	tech = [[Difficulté: Difficile
Resistance: Normale
Agilit : Normale
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne

Aperçu:
Classe de sécurité. Possède une tourelle déployable, avec 3 modes de tir (Maintenez E sur la tourelle pour ouvrir son menu). Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP. Vous pouvez escorter les scientifiques.
]],

    cispy = [[Difficulté: Très Difficile
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper: Non
Peut escorter: Classes D
Escorté par: Personne
Aperçu:
Espion IC. Mélangez vous aux gardes pour sauver les Classes D
]],

	lightcispy = [[Difficulté : Très Difficile
Resistance : Faible
Agilité : élevée
Potentiel de combat : Faible
Peut s'échapper : Non
Peut escorter : Classes D
Escorté par : Personne

Overview:
Espion IC léger. Essayez de vous fondre dans les gardes de sécurité et aidez les Classes D.
]],

	heavycispy = [[Difficulty: Très Difficile
Resistance: Élevée
Agilité: Faible
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Classes D
Escorté par: Personne

Overview:
Espion IC lourd. Essayez de vous fondre dans les gardes de sécurité et aidez les Classes D.
]],

	guard_prestige = [[Difficulty: Difficile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par : Personne

Overview:
Classe de sécurité. Possède un dispositif capable de bloquer temporairement les portes dans leur état actuel. Utilisez vos outils et armes pour aider le reste du personnel et tuer les Classes D et les SCP. Vous pouvez escorter les scientifiques.
]],

    ntf_1 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF armée d'une SMG. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D	et les SCP
]],

	ntf_2 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF armée d'un fusil a pompe. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

	ntf_3 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF armée d'un fusil d'assault. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D	et les SCP
]],

    ntfmedic = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Faible
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF armée d'un pistolet, possède un kit de soin. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D	et les SCP
]],


	ntfcom = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Très Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF armée d'un fusil a longue distance. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

    ntfsniper = [[Difficulté: Difficile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF armée d'un sniper. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

    alpha1 = [[Difficulté: Moyenne
Resistance: Extrême
Agilité: Très Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
MTF Alpha-1. Possède une grosse armure et une vitessé elevée. Armé d'un fusil d'assault. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

	alpha1sniper = [[Difficulté: Difficile
Resistance: Extrême
Agilité: Extrême
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
MTF Alpha-1. Possède une grosse armure et une vitesse élevée. Armé d'un fusil a longue distance. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

	alpha1medic = [[Difficulté: Difficile
Résistance: Très élevée
Agilité: Très élevée
Potentiel de combat: Très élevé
Peut s'échapper: Non
Peut escorter: Scientifiques
Escorté par: Personne
Aperçu:
Unité MTF Alpha-1. Lourdement protégé, Capable de soigner. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

    alpha1com = [[Difficulté: Hard
Résistance : Très elevée
Agilité: Très elevée
Potentiel de combat : Très elevé
peut s'échapper : Non
Peut escorter : scientifiques
Escorté par : Personne
Aperçu:
Unité MTF Alpha-1. Lourdement protégé, Capable de soigner. Rejoignez l'intérieur afin de le sécuriser. Aidez le personnel a l'intérieur tout en tuant les Classes D et les SCP
]],

	ci = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper: Non
Peut escorter: Classes D
Escorté  par: Personne
Aperçu:
Unité IC. Rejoignez l'intérieur, aidez les Classes D et tuez tout le personnel de la fondation
]],

	cisniper = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Classes D
Escorté  par: Personne

Overview:
Unité IC. Rejoignez l'intérieur, aidez les Classes D et tuez tout le personnel de la fondation. Couvez votre équipe.
]],

cicom = [[Difficulté: Moyenne
Resistance: Très Élevée
Agilité: Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Classes D
Escorté par: Personne
Aperçu:
Commandant IC. Possède un gros potentiel de combat. Rejoignez l'intérieur, aidez les Classes D et tuez tout le personnel de la fondation
]],

	cimedic = [[Difficulté: Moyenne
Résistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Peut s'échapper: Non
Peut escorter: Classes D
Escorté par: Personne

Aperçu:
Unité IC. Rejoignez l'intérieur du complexe, sauvez les Classes D et tuez tout le reste. Vous avez un kit de soin
]],

	cispec = [[Difficulté: Moyenne
Resistance: Moyenne/Élevée
Agilité: Moyenne/Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Classes D
Escorté par: Personne

Aperçu:
Unité IC. Rejoignez l'intérieur du complexe, sauvez les Classes D et tuez tout le reste. Vous avez une tourelle déployable
]],

ciheavy = [[Difficulté: Moyenne
Resistance: Moyenne/Élevée
Agilité: Moyenne/Élevée
Potentiel de combat: Très Élevé
Peut s'échapper: Non
Peut escorter: Classes D
Escorté par: Personne

Aperçu:
Unité IC. Rejoignez l'intérieur du complexe, sauvez les Classes D et tuez tout le reste. Vous avez une grosse mitralleuse.
]],


	goc = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: No
Escorté par: Personne

Aperçu:
Soldat de la CMO. Detruisez les SCP, utilisez votre tablette personnelle pour localiser l'appareil GOC qui a été précédemment livré à l'installation, puis déployez-le et protégez-le. Évadez-vous vers l'abri d'évacuation après avoir déployé avec succès l'appareil.
]],

	gocmedic = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Non
Escorté par: Personne

Aperçu:
Soldat de la CMO. Detruisez les SCP, utilisez votre tablette personnelle pour localiser l'appareil GOC qui a été précédemment livré à l'installation, puis déployez-le et protégez-le. Évadez-vous vers l'abri d'évacuation après avoir déployé avec succès l'appareil. Vous avez un kit de soin.
]],

	goccom = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Élevé
Peut s'échapper: Non
Peut escorter: Non
Escorté par: Personne

Aperçu:
Commandant de la CMO. Detruisez les SCP, utilisez votre tablette personnelle pour localiser l'appareil GOC qui a été précédemment livré à l'installation, puis déployez-le et protégez-le. Évadez-vous vers l'abri d'évacuation après avoir déployé avec succès l'appareil. Vous avez des fumigènes.
]],

	SCP0492 = [[General:
Un zombie créé par SCP-049. Il s'agit de l'un des types suivants :

Zombie Classique:
Difficulté: - | Resistance: - | Agilité: - | Dégats: -
Un choix décent avec des statistiques équilibrées

Zombie Assassin:
Difficulté: - | Resistance: - | Agilité: - | Dégats: -
Le plus rapide, mais a le moins de points de vie et de dégâts

Zombie Djihadiste:
Difficulté: Medium | Resistance: High | Agilité: Low | Dégats: Normal/High
Faible vitesse de déplacement, mais a une santé élevée et des dégâts plus élevés

Zombie Caillasseur:
Difficulté: Moyenne | Resistance: High | Agilité: Low | Dégats: Normal/High
Le type de zombie le plus lent, mais il a des dégâts élevés et le plus de santé
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "Renforcement extérieur",
		info = "Octroie une régénération a la surface, lorsque ne prenant pas de dégâts pendant un moment. De plus, offre également une réduction des dégâts lorsque positionné sur la plateforme d'évacuation"
	}
}

lang.CommonSkills = {
	c_button_overload = {
		name = "Surcharge",
		dsc = "Vous permet de surcharger les portes pour les ouvrir/fermer. "
	},
	c_dmg_mod = {
		name = "Protection aux dégats",
		dsc = "Protection actuelle: [mod]\n\nCeci est la protection contre les dégats non directs reçus. Il ne prend en compte que le modificateur de dégats et le renforcement extérieur. Les modificateurs spécifiques aux SCP ne sont pas inclus!"
	},
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	skills = {
		_overview = { "passive", "drain", "clone", "hunt" },
		drain = {
			name = "Vol d'Énergie",
			dsc = "Vole l'endurance des joueurs proches. Si les joueurs quittent le champ d'action, place l'abilité en cooldown",
		},
		clone = {
			name = "Clone",
			dsc = "Place un clone qui possède les mêmes passifs que vous. Le clone se promènera et poursuivra les joueurs à proximité",
		},
		hunt = {
			name = "Chasse",
			dsc = "Tuez instantanément l'une de vos proies ou une personne à proximité et téléportez-vous vers son corps",
		},
		passive = {
			name = "Passif",
			dsc = "Entrer en collision avec des joueurs les font prendre feu",
		},
		drain_bar = {
			name = "Vol",
			dsc = "Temps restant sur votre abilité de vol d'énergie",
		},
	},

	upgrades = {
		parse_description = true,

		passive = {
			name = "Braise Incandescente",
			info = "Augmente les dégâts de votre brûlure passive de [+burn_power]",
		},
		invis1 = {
			name = "Flamme Invisible I",
			info = "Octroie une invisibilité\n\t• Vous disparaissez aux yeux des joueurs assez lointains\n\t• Les joueurs ne pouvant pas vous voir ne seront pas ajoutés a votre liste de proies\n\t• Cette amélioration fonctionne aussi sur le clone\n\t• Vous devenez invisible a partir de [invis_range] unités de distance",
		},
		invis2 = {
			name = "Flamme Invisible II",
			info = "Améliore votre invisibilité\n\t• Vous devenez invisible a partir de [invis_range] unités de distance",
		},
		prot1 = {
			name = "Feu Immortel I",
			info = "Octroie [-prot] de protection aux dégats par balle",
		},
		prot2 = {
			name = "Undying Fire II",
			info = "Améliore la protection a [-prot]",
		},
		drain1 = {
			name = "Détournement I",
			info = "Améliore votre abilité de vol\n\t• Durée augmentée de [+drain_dur]\n\t• Distance maximale augmentée de [+drain_dist]",
		},
		drain2 = {
			name = "Détournement II",
			info = "Améliore votre abilité de vol\n\t• Puissance du vol augmentée de [/drain_rate]\n\t• Soigne vos PV de [%drain_heal] de l'endurance volée",
		},
		drain3 = {
			name = "Détournement III",
			info = "Améliore votre abilité de vol\n\t• Durée augmentée de [+drain_dur]\n\t• Distance maximale augmentée de [+drain_dist]",
		},
		drain4 = {
			name = "Détournement IV",
			info = "Améliore votre abilité de vol\n\t• Puissance du vol augmentée de [/drain_rate]\n\t• Soigne vos PV de [%drain_heal] de l'endurance volée",
		},
		hunt1 = {
			name = "Ardeur Infinie I",
			info = "Améliore votre capacité de chasse\n\t• Cooldown réduit de [-hunt_cd]",
		},
		hunt2 = {
			name = "Ardeur Infinie II",
			info = "Améliore votre capacité de chasse\n\t• Cooldown réduit de [-hunt_cd]\n\t• Rayon de recherche de proies aléatoires augmenté de [+hunt_range]",
		},
	}
}

wep.SCP049 = {
	zombies = {
		normal = "Zombie Classique",
		assassin = "Zombie Assassin",
		boomer = "Zombie Djihadiste",
		heavy = "Zombie Caillasseur",
	},
	zombies_desc = {
	normal = "Un zombie standard\n\t• Possède des attaques légères et lourdes\n\t• Choix décent avec des statistiques équilibrées",
    assassin = "Un zombie assassin\n\t• Possède une attaque légère et une capacité d'attaque rapide\n\t• Le plus rapide, mais a les points de vie et les dégâts les plus faibles",
    boomer = "Un zombie lourd et explosif\n\t• Possède une capacité d'attaque et d'explosion importante\n\t• Faible vitesse de déplacement, mais a une santé élevée et des dégâts plus élevés",
    heavy = "Un zombie lourd et crachant\n\t• Possède de lourdes capacités d'attaque et de tir\n\t• Le type de zombie le plus lent, mais il a des dégâts élevés et le plus de santé",
	},
	skills = {
		_overview = { "passive", "choke", "surgery", "boost" },
		surgery_failed = "Surgery failed!",

		choke = {
			name = "Touché Du Docteur",
			dsc = "Étranglez un joueur jusqu'a la mort. Peut être interrompu en encaissant assez de dégats",
		},
		surgery = {
			name = "Opération",
			dsc = "Éffectue une opération sur un cadavre pour le transformer en SCP-049-2. Recevoir des dégats annule l'opération",
		},
		boost = {
			name = "Soulèvement!",
			dsc = "Octroie des boost a vous ainsi que tout les SCP-049-2 ",
		},
		passive = {
			name = "Passif",
			dsc = "Les zombies a proximité gagnent une protection aux dégats par balle",
		},
		choke_bar = {
			name = "Touché Du Docteur",
			dsc = "Lorsque remplie, la cible meurt",
		},
		surgery_bar = {
			name = "Opération",
			dsc = "Temps restant de l'opération",
		},
		boost_bar = {
			name = "Soulèvement!",
			dsc = "Temps restant du boost",
		},
	},

	upgrades = {
		parse_description = true,

		choke1 = {
			name = "Touché Du Docteur I",
			info = "Améliore votre étranglement\n\t• Cooldown reduit de [-choke_cd]\n\t• Seuil de dégats augmenté de [+choke_dmg]",
		},
		choke2 = {
			name = "Touché Du Docteur II",
			info = "Améliore votre étranglement\n\t• Vitesse d'étranglement augmentée de [+choke_rate]\n\t• Ralentissement après étranglement réduit de [-choke_slow]",
		},
		choke3 = {
			name = "Touché Du Docteur III",
			info = "UAméliore votre étranglement\n\t• Cooldown reduit de [-choke_cd]\n\t• Seuil de dégats augmenté de [+choke_dmg]\n\t• Vitesse d'étranglement augmentée de [+choke_rate]",
		},
		buff1 = {
			name = "Soulèvement I",
			info = "Améliore votre boost\n\t• Cooldown réduit de [-buff_cd]\n\t• Durée augmentée de [+buff_dur]",
		},
		buff2 = {
			name = "Soulèvement II",
			info = "Améliore votre boost\n\t• Rayon augmenté de [+buff_radius]\n\t• Puissance augmentée de [+buff_power]",
		},
		surgery_cd1 = {
			name = "Précision Chirurgicale I",
			info = "Réduit le temps d'opération de [surgery_time]s\n\t• Cette amélioration est cumulable avec une autre",
		},
		surgery_cd2 = {
			name = "Précision Chirurgicale II",
			info = "Réduit le temps d'opération de [surgery_time]s\n\t• Cette amélioration est cumulable avec une autre",
		},
		surgery_heal = {
			name = "Transplantation",
			info = "Améliore votre opération\n\t• Après chaque chirurgie vous récupérez [surgery_heal] HP\n\t• les zombies a proximité récupèrent [surgery_zombie_heal] HP",
		},
		surgery_dmg = {
			name = "Chirurgien Ultime",
			info = "Encaisser des dégats n'arrête plus l'opération ",
		},
		surgery_prot = {
			name = "Main de Maitre",
			info = "Pendant une opération, gagnez [-surgery_prot] de protection contre les dégats par balle",
		},
		zombie_prot = {
			name = "L'infirmier",
			info = "Gagnez des protection contre les balles pour chaque zombie proche de vous\n\t• Protection pour chaque zombie proche: [%zombie_prot]\n\t• Protection maximale: [%zombie_prot_max]",
		},
		zombie_lifesteal = {
			name = "Soif De Sang I",
			info = "Les zombies gagnent [%zombie_ls] vol de vie sur leurs attaques",
		},
		stacks_hp = {
			name = "Injection De Stéroïdes",
			info = "Lorsqu'un zombie est crée, ses HP sont augmentés de [%stacks_hp] pour chaque chirurgie précédente",
		},
		stacks_dmg = {
			name = "Thérapie Radicale",
			info = "Lorsqu'un zombie est crée, ses dégats sont augmentés de [%stacks_dmg] pour chaque chirurgie précédente",
		},
		zombie_heal = {
			name = "Soif De Sang II",
			info = "Vous vous soignez de [%zombie_heal] des dégats infligés par les zombies proche de vous",
		}
	}
}

wep.SCP0492 = {
	skills = {
		prot = {
			name = "Protection",
			dsc = "Vous gagnez des réduction de dégats en étant proche de SCP-049",
		},
		boost = {
			name = "Boost",
			dsc = "Indique lorsque le boost de SCP-049 est actif sur vous",
		},
		light_attack = {
			name = "Attaque Légère",
			dsc = "Éffectue une attaque légère",
		},
		heavy_attack = {
			name = "Attaque Lourde",
			dsc = "Éffectue une attaque lourde",
		},
		rapid = {
			name = "Attaque Rapide",
			dsc = "Éffectue une attaque rapide",
		},
		shot = {
			name = "Tir",
			dsc = "Envoie un projectile blessant",
		},
		explode = {
			name = "Explosion",
			dsc = "Activez la lorsque vous avez moins de 50 HP. Vous rend temporairement immortel et augmente votre vitesse. Après une courte période, vous explosez blessant tout le monde dans une zone restreinte",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Durée restante du boost",
		},
		explode_bar = {
			name = "Explode",
			dsc = "Temps restant avant l'explosion",
		},
	},

	upgrades = {
		parse_description = true,

		primary1 = {
			name = "Attaque Principale I",
			info = "Améliore votre attaque principale\n\t• Cooldown réduit de [-primary_cd]",
		},
		primary2 = {
			name = "Attaque Principale II",
			info = "Améliore votre attaque principale\n\t• Cooldown réduit de [-primary_cd]\n\t• Dégats augmentés de [+primary_dmg]",
		},
		secondary1 = {
			name = "Attaque Secondaire I",
			info = "Améliore votre attaque secondaire\n\t• Dégats augmentés de [+secondary_dmg]",
		},
		secondary2 = {
			name = "Attaque Secondaire II",
			info = "Améliore votre attaque secondaire\n\t• Dégats augmentés de [+secondary_dmg]\n\t• Cooldown réduit de [-secondary_cd]",
		},
		overload = {
			name = "Surcharge",
			info = "Augmente le nombre de surcharges de [overloads]",
		},
		buff = {
			name = "Soulèvement!",
			info = "Améliore votre protection et le boost de SCP-049\n\t• Pouvoir de protection: [%+prot_power]\n\t• Pouvoir du boost: [++buff_power]",
		},
	}
}

wep.SCP058 = {
	skills = {
		_overview = { "primary_attack", "shot", "explosion" },
		primary_attack = {
			name = "Attaque principale",
			dsc = "Attaque juste en face de vous a l'aide de votre dard. Peut appliquer un empoisonnement si l'amélioration adéquate est débloquée.",
		},
		shot = {
			name = "Tir",
			dsc = "Tir un projectile dans la direction ou vous regardez.",
		},
		explosion = {
			name = "Explosion",
			dsc = "Release burst of corrupted blood dealing massive damage to targets nearby",
		},
		shot_stacks = {
			name = "Tirs restants",
			dsc = "Vous montre combien de tirs vous pouvez effectuer. Certaines amélioration peuvent varier le cooldown ou le nombre maximal par exemple.",
		},
	},

	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Dard Vénimeux I",
			info = "Applique un empoisonnement sur votre attaque principale"
		},
		attack2 = {
			name = "Dard Vénimeux II",
			info = "Augmente les dégâts d'attaque principale, les dégâts du poison, et réduit le cooldown.\n\t• Ajoute [prim_dmg] dégâts aux attaques\n\t• Attack poison deals [pp_dmg] Dégâts\n\t• Le cooldown est réduit de [prim_cd]s"
		},
		attack3 = {
			name = "Dard Vénimeux III",
			info = "Augmente les dégâts du poison et réduit le cooldown.\n\t• Si la cible n'est pas empoisonée, applique 2 stacks de poison\n\t• Attack poison deals [pp_dmg] Dégâts\n\t• Cooldown is reduced by [prim_cd]s"
		},
		shot = {
			name = "Sang Contaminé",
			info = "Applique un empoisonnement sur vos tirs"
		},
		shot11 = {
			name = "Surtension I",
			info = "Augmente les dégats, la taille du projectile, le cooldown. Ralentit le projectile\n\t• Dégats augmentés de [+shot_damage]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]\n\t• Cooldown augmenté de [shot_cd]s"
		},
		shot12 = {
			name = "Surge II",
			info = "Augmente les dégats, la taille du projectile, le cooldown. Ralentit le projectile\n\t• Dégats augmentés de [+shot_damage]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]\n\t• Cooldown augmenté de [shot_cd]s"
		},
		shot21 = {
			name = "Brume Sanglante I",
			info = "Les tirs laissent une brûme a l'impact, blessant et empoisonnant toute personne a son contact.\n\t• Les dégâts du tir sont retirés\n\t• La brûme inflige [cloud_damage] dégâts a son contact\n\t• Le poison appliqué par la brûme inflige [sp_dmg] dégats\n\t• Stacks limités à [stacks]\n\t• Cooldown augmenté de [shot_cd]s\n\t• Vitesse de récupération: [/+regen_rate]"
		},
		shot22 = {
			name = "Brume Sanglante II",
			info = "Renforce la brume.\n\t• La brûme inflige [cloud_damage] dégâts a son contact\n\t• Le poison appliqué par la brûme inflige [sp_dmg] dégâts\n\t• Les tirs sont récupérés a une vitesse de: [/+regen_rate]"
		},
		shot31 = {
			name = "Tir Rapide I",
			info = "Vous permet de tirer vite en maintenant le bouton de tir\n\t• Débloque la capacité de tir rapide\n\t• Les dégâts des tirs sont retirés\n\t• Stacks limités à [stacks]\n\t• Vitesse de récupération: [/+regen_rate]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]"
		},
		shot32 = {
			name = "Tir Rapide II",
			info = "Augmente le maximum de stacks et la vitesse de tir\n\t• Stacks limités a à[stacks]\n\t• Vitesse de récupération: [/+regen_rate]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]"
		},
		exp1 = {
			name = "Explosion",
			info = "Débloque la capacité d'exploser, infligeant des Dégâts massifs lorsque votre santé diminue pour la première fois en dessous de chaque multiple de 1000 PV."
		},
		exp2 = {
			name = "Soufle Toxique",
			info = "Améliore votre abilité d'explosion\n\t• Applique 2 stacks de poison\n\t• Multiplicateur du rayon: [+explosion_radius]"
		},
	}
}

wep.SCP066 = {
	skills = {
		_overview = { "eric", "music", "dash", "boost" },
		not_threatened = "Vous n'êtes pas assez menacé pour attaquer!",

		music = {
			name = "Symphony No. 2",
			dsc = "Si vous vous sentez menacé, vous pouvez emettre une puissante musique",
		},
		dash = {
			name = "Dash",
			dsc = "Foncez en avant. Si vous touchez un joueur, vous y serez collé pendant une courte période",
		},
		boost = {
			name = "Boost",
			dsc = "Obtiens l'un des 3 boosts actuellement actifs. Après utilisation, il sera remplacé par le suivant. La puissance de tous les boosts augmente avec chaque accumulation passive (limitée à [cap] stacks).\n\nBoost actuel : [boost]\n\nBoost de vitesse : [speed]\nBoost de défense contre les balles : [def]\nBoost de régénération : [regen]",
			buffs = {
				"Vitesse",
				"Défense contre les balles",
				"Regneration",
			},
		},
		eric = {
			name = "Eric?",
			dsc = "Vous demandez aux joueurs non armés s'ils sont Eric. Obtenez un stack de passif à chaque fois",
		},
		music_bar = {
			name = "Symphony No. 2",
			dsc = "Temps restant de cette abilité",
		},
		dash_bar = {
			name = "Detach time",
			dsc = "Temps restant avant de vous détacher",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Temps restant de cette abilité",
		},
	},

	upgrades = {
		parse_description = true,

		eric1 = {
			name = "Eric? I",
			info = "Réduit le cooldown du passif de [-eric_cd]",
		},
		eric2 = {
			name = "Eric? II",
			info = "Réduit le cooldown du passif de [-eric_cd]",
		},
		music1 = {
			name = "Symphonie No. 2 I",
			info = "Améliore votre attaque principale\n\t• Cooldown diminué de [-music_cd]\n\t• Portée augmentée de [+music_range]",
		},
		music2 = {
			name = "Symphonie No. 2 II",
			info = "Améliore votre attaque principale\n\t• Cooldown diminué de [-music_cd]\n\t• Portée augmentée de [+music_range]",
		},
		music3 = {
			name = "Symphonie No. 2 III",
			info = "Améliore votre attaque principale\n\t• Dégâts augmentés de [+music_damage]",
		},
		dash1 = {
			name = "Dash I",
			info = "Améliore votre capacité de dash\n\t• Cooldown diminué de [-dash_cd]\n\t• Vous restez [+detach_time] plus longtemps sur votre cible",
		},
		dash2 = {
			name = "Dash II",
			info = "Améliore votre capacité de dash\n\t• Cooldown diminué de [-dash_cd]\n\t• Vous restez [+detach_time] plus longtemps sur votre cible",
		},
		dash3 = {
			name = "Dash III",
			info = "Améliore votre capacité de dash\n\t• Lorsque vous êtes attaché à une cible, vous pouvez réutiliser cette capacité pour vous détacher\n\t• En vous détachant, vous pouvez vous attacher à un autre joueur\n\t• Vous ne pouvez pas vous attacher au même joueur plus d'une fois par utilisation de cette capacité",
		},
		boost1 = {
			name = "Boost I",
			info = "Améliore votre capacité de boost\n\t• Cooldown diminué de [-boost_cd]\n\t• Durée augmentée de [+boost_dur]",
		},
		boost2 = {
			name = "Boost II",
			info = "Améliore votre capacité de boost\n\t• Cooldown diminué de [-boost_cd]\n\t• Puissance augmentée de [+boost_power]",
		},
		boost3 = {
			name = "Boost III",
			info = "Améliore votre capacité de boost\n\t• Cooldown diminué de [-boost_cd]\n\t• Puissance augmentée de [+boost_power]",
		},
	}
}

wep.SCP096 = {
	skills = {
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {
			name = "Assaut Foudroyant",
			dsc = "Projetez-vous vers l'avant pendant la rage. Met instantanément fin à la rage. Vous ne consommerez pas de corps après la charge.",
		},
		regen = {
			name = "Regeneration",
			dsc = "Asseyez-vous et convertissez les stacks de régénération en santé",
		},
		special = {
			name = "Fin De La Chasse",
			dsc = "Arrêtez la rage. Obtenez des stacks de régénération pour chaque cible active",
		},
		passive = {
			name = "Passif",
			dsc = "Si quelqu'un vous regarde, vous entrez en rage. Vous tuez instantanément les joueurs qui vous ont mis en rage",
		},
	},

	upgrades = {
		parse_description = true,

		rage = {
			name = "Colère",
			info = "Recevoir [rage_dmg] en [rage_time] secondes d'un seul joueur vous mettra en rage",
		},
		heal1 = {
			name = "Devoration I",
			info = "Après avoir tué la cible, dévorez le corps de la cible et obtenez une protection contre les balles pendant la durée\n\t• Guérison par tick : [heal]\n\t• Ticks de guérison : [heal_ticks]\n\t• Protection contre les dégâts des balles : [-prot]",
		},
		heal2 = {
			name = "Devoration II",
			info = "Améliore votre capacité de dévoration\n\t• Guérison par tick : [heal]\n\t• Ticks de guérison : [heal_ticks]\n\t• Protection contre les dégâts des balles : [-prot]",
		},
		multi1 = {
			name = "Rage Infinie I",
			info = "Vous permet de tuer plusieurs cibles pendant une période limitée après le premier kill lors de la rage\n\t• Cibles maximum : [multi]\n\t• Limite de temps : [multi_time] secondes\n\t• Dégâts des balles après avoir tué la première cible augmentés de [+prot]",
		},
		multi2 = {
			name = "Rage Infinie II",
			info = "Vous permet de tuer encore plus de cibles pendant la rage\n\t• Cibles maximum : [multi]\n\t• Limite de temps : [multi_time] secondes\n\t• Dégâts des balles après avoir tué la première cible augmentés de [+prot]",
		},
		regen1 = {
			name = "Pleurs De Desespoir I",
			info = "Améliore votre capacité de régénération\n\t• Guérison augmentée de [+regen_mult]",
		},
		regen2 = {
			name = "Pleurs De Desespoir II",
			info = "Améliore votre capacité de régénération\n\t• Taux de gain des stacks augmenté de [/regen_stacks]",
		},
		regen3 = {
			name = "Pleurs de Desespoir III",
			info = "Améliore votre capacité de régénération\n\t• Guérison augmentée de [+regen_mult]\n\t• Taux de gain des stacks augmenté de [/regen_stacks]",
		},
		spec1 = {
			name = "Misericorde I",
			info = "Améliore votre capacité spéciale et ajoute un drain de santé mentale\n\t• Obtenez [+spec_mult] stacks supplémentaires\n\t• Drain de santé mentale : [sanity]",
		},
		spec2 = {
			name = "Misericorde II",
			info = "Améliore votre capacité spéciale\n\t• Obtenez [+spec_mult] stacks supplémentaires\n\t• Drain de santé mentale : [sanity]",
		},
	}
}

wep.SCP106 = {
	cancel = "Press [%s] to cancel",

	skills = {
		_overview = { "passive", "wither", "teleport", "trap" },
		withering = {
			name = "Deperissement",
			dsc = "Infligez un effet de dépérissement à la cible. Le dépérissement ralentit progressivement la cible au fil du temps. Attaquer une cible qui se trouve dans la Dimension de Poche la tue instantanément\n\nDurée de l'effet : [dur]\nRalentissement maximal : [slow]",
		},
		trap = {
			name = "Piège",
			dsc = "Placez un piège sur le mur. Lorsque le piège s'active, la cible est ralentie et vous pouvez réutiliser cette capacité pour vous téléporter instantanément à ce piège.",
		},
		teleport = {
			name = "Teleportation",
			dsc = "Utilisez pour placer un point de téléportation. Lorsque maintenu près d'un point de téléportation existant, vous pouvez sélectionner la destination de la téléportation. Relâchez pour vous téléporter au point sélectionné.",
		},
		passive = {
			name = "Collection De Dents",
			dsc = "Les balles ne peuvent pas vous tuer, mais elles peuvent vous assommer temporairement. De plus, vous pouvez passer à travers les portes. Toucher un joueur le téléporte dans la Dimension de Poche. Chaque joueur téléporté dans la Dimension de Poche vous accorde une dent. Les dents collectées renforcent votre capacité de dépérissement.",
		},
		teleport_cd = {
			name = "Teleportation",
			dsc = "Affiche le cooldown du point de téléportation",
		},
		passive_bar = {
			name = "Collection De Dents",
			dsc = "Lorsque cette barre atteint zéro, vous serez assommé.",
		},
		trap_bar = {
			name = "Piège",
			dsc = "Indique la durée d'activation du piège"
		}
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Collection De Dents I",
			info = "Améliore votre capacité passive\n\t• Augmente les dégâts nécessaires pour vous assommer de [+passive_dmg]\n\t• Réduit l'étourdissement de l'assommement de [-passive_cd]",
		},
		passive2 = {
			name = "Collection De Dents II",
			info = "Améliore votre capacité passive\n\t• Augmente les dégâts nécessaires pour vous assommer de [+passive_dmg]\n\t• Dégâts infligés aux joueurs augmentés de [+teleport_dmg]",
		},
		passive3 = {
			name = "Collection De Dents III",
			info = "Améliore votre capacité passive\n\t• Augmente les dégâts nécessaires pour vous assommer de [+passive_dmg]\n\t• Réduit l'étourdissement de l'assommement de [-passive_cd]\n\t• Dégâts infligés aux joueurs augmentés de [+teleport_dmg]",
		},
		withering1 = {
			name = "Deperissement I",
			info = "Améliore votre capacité de dépérissement\n\t• Cooldown diminué de [-attack_cd]\n\t• Durée de base de l'effet augmentée de [+withering_dur]",
		},
		withering2 = {
			name = "Deperissement II",
			info = "Améliore votre capacité de dépérissement\n\t• Cooldown diminué de [-attack_cd]\n\t• Ralentissement de base de l'effet augmenté de [+withering_slow]",
		},
		withering3 = {
			name = "Deperissement III",
			info = "Améliore votre capacité de dépérissement\n\t• Cooldown diminué de [-attack_cd]\n\t• Durée de base de l'effet augmentée de [+withering_dur]\n\t• Ralentissement de base de l'effet augmenté de [+withering_slow]",
		},
		tp1 = {
			name = "Teleportation I",
			info = "Améliore votre capacité de téléportation\n\t• Nombre maximal de points augmenté de [spot_max]\n\t• Cooldown des points diminué de [-spot_cd]",
		},
		tp2 = {
			name = "Teleportation II",
			info = "Améliore votre capacité de téléportation\n\t• Nombre maximal de points augmenté de [spot_max]\n\t• Cooldown de téléportation diminué de [-tp_cd]",
		},
		tp3 = {
			name = "Teleportation III",
			info = "Améliore votre capacité de téléportation\n\t• Nombre maximal de points augmenté de [spot_max]\n\t• Cooldown des points diminué de [-spot_cd]\n\t• Cooldown de téléportation diminué de [-tp_cd]",
		},
		trap1 = {
			name = "Piège I",
			info = "Améliore votre capacité de piège\n\t• Cooldown du piège diminué de [-trap_cd]\n\t• Durée de vie du piège augmentée de [+trap_life]",
		},
		trap2 = {
			name = "Piège II",
			info = "Améliore votre capacité de piège\n\t• Cooldown du piège diminué de [-trap_cd]\n\t• Durée de vie du piège augmentée de [+trap_life]",
		},
	}
}

local scp173_prot = {
	name = "Béton Armé",
	info = "Obtenez une réduction des dégâts de balle de [%prot]\n• Cette capacité se cumule avec d'autres compétences du même type",
}

wep.SCP173 = {
	restricted = "Restreint!",

	skills = {
		_overview = { "gas", "decoy", "stealth" },
		gas = {
			name = "Gaz",
			dsc = "Émettez un nuage de gaz irritant qui ralentira, obscurcira la vision et augmentera la fréquence de clignement des joueurs à proximité.",
		},
		decoy = {
			name = "Leurre",
			dsc = "Placez un leurre qui distraira et drainera la santé mentale des joueurs.",
		},
		stealth = {
			name = "Furtivité",
			dsc = "Entrez en mode furtif. En mode furtif, vous êtes invisible et vous pouvez passer à travers les portes. De plus, vous devenez invulnérable aux dégâts (les dégâts de zone comme les explosions peuvent encore vous atteindre), mais vous ne pouvez pas infliger de dégâts aux joueurs et vous ne pouvez pas interagir avec le monde.",
		},
		looked_at = {
			name = "Pas Bouger!",
			dsc = "S'illumine si une personne vous regarde.",
		},
		next_decoy = {
			name = "Stacks De Leurres",
			dsc = "Nombre de leurres disponibles",
		},
		stealth_bar = {
			name = "Furtivité",
			dsc = "Temps restant de furtivité.",
		},
	},

	upgrades = {
		parse_description = true,

		horror_a = {
			name = "Présence Écrasante",
			info = "Le rayon d'horreur est augmenté de [+horror_dist]",
		},
		horror_b = {
			name = "Présence Inquiétante",
			info = "Le drain de santé mentale d'horreur est augmenté de [+horror_sanity]",
		},
		attack_a = {
			name = "Tueur Rapide",
			info = "Le rayon de mise à mort est augmenté de [+snap_dist]",
		},
		attack_b = {
			name = "Tueur Agile",
			info = "Le rayon de déplacement est augmenté de [+move_dist]",
		},
		gas1 = {
			name = "Gaz I",
			info = "Le rayon de gaz est augmenté de [+gas_dist]",
		},
		gas2 = {
			name = "Gaz II",
			info = "Le rayon de gaz est augmenté de [+gas_dist] et le cooldown du gaz est réduit de [-gas_cd]",
		},
		decoy1 = {
			name = "Leurre I",
			info = "Le cooldown du leurre est réduit de [-decoy_cd]",
		},
		decoy2 = {
			name = "Leurre II",
			info = "Le cooldown du leurre est réduit à 0,5s\n• Le cooldown original s'applique aux stacks de leurres\n• La limite des leurres est augmentée de [decoy_max].",
		},
		stealth1 = {
			name = "Furtivité I",
			info = "Le cooldown de la furtivité est réduit de [-stealth_cd]",
		},
		stealth2 = {
			name = "Furtivité II",
			info = "Le cooldown de la furtivité est réduit de [-stealth_cd]\n• La durée de la furtivité est augmentée de [+stealth_dur]",
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
            name = "Boule de Feu",
            dsc = "Coût en carburant : [cost]\nTirez une boule de feu qui avancera jusqu'à ce qu'elle entre en collision avec quelque chose",
        },
        trap = {
            name = "Piège",
            dsc = "Coût en carburant : [cost]\nPlacez un piège qui enflammera les joueurs qui le touchent",
        },
        ignite = {
            name = "Rage Intérieure",
            dsc = "Coût en carburant : [cost] pour chaque feu généré\nLibérez des vagues de flammes autour de vous. La portée de cette capacité est illimitée et chaque anneau de feu supplémentaire consomme plus de carburant. Cette capacité ne peut pas être interrompue",
        },
        passive = {
            name = "Passif",
            dsc = "Vous enflammez tous ceux que vous touchez. Enflammer un joueur ajoute du carburant",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Torche Vivante I",
            info = "Améliore votre capacité passive\n\t• Rayon de feu augmenté de [+fire_radius]\n\t• Gain de carburant augmenté de [+fire_fuel]",
        },
        passive2 = {
            name = "Torche Vivante II",
            info = "Améliore votre capacité passive\n\t• Rayon de feu augmenté de [+fire_radius]\n\t• Dégâts de feu augmentés de [+fire_dmg]",
        },
        passive3 = {
            name = "Torche Vivante III",
            info = "Améliore votre capacité passive\n\t• Gain de carburant augmenté de [+fire_fuel]\n\t• Dégâts de feu augmentés de [+fire_dmg]",
        },
        passive_heal1 = {
            name = "Flamme de Vie I",
            info = "Vous vous soignez de [%fire_heal] des dégâts causés par le feu de l'une de vos capacités",
        },
        passive_heal2 = {
            name = "Flamme de Vie II",
            info = "Vous vous soignez de [%fire_heal] des dégâts causés par le feu de l'une de vos capacités",
        },
        fireball1 = {
            name = "Balle Aux Prisonniers I",
            info = "Améliore votre capacité de boule de feu\n\t• Cooldown diminué de [-fireball_cd]\n\t• Vitesse augmentée de [+fireball_speed]\n\t• Coût en carburant diminué de [-fireball_cost]",
        },
        fireball2 = {
            name = "Balle Aux Prisonniers II",
            info = "Améliore votre capacité de boule de feu\n\t• Dégâts augmentés de [+fireball_dmg]\n\t• Taille augmentée de [+fireball_size]\n\t• Coût en carburant diminué de [-fireball_cost]",
        },
        fireball3 = {
            name = "Balle Aux Prisonniers III",
            info = "Améliore votre capacité de boule de feu\n\t• Cooldown diminué de [-fireball_cd]\n\t• Dégâts augmentés de [+fireball_dmg]\n\t• Vitesse augmentée de [+fireball_speed]",
        },
        trap1 = {
            name = "C'est un Piège ! I",
            info = "Améliore votre capacité de piège\n\t• Pièges supplémentaires : [trap_max]\n\t• Coût en carburant diminué de [-trap_cost]\n\t• Durée de vie augmentée de [+trap_time]",
        },
        trap2 = {
            name = "C'est un Piège ! II",
            info = "Améliore votre capacité de piège\n\t• Pièges supplémentaires : [trap_max]\n\t• Dégâts augmentés de [+trap_dmg]\n\t• Durée de vie augmentée de [+trap_time]",
        },
        trap3 = {
            name = "C'est un Piège ! III",
            info = "Améliore votre capacité de piège\n\t• Coût en carburant diminué de [-trap_cost]\n\t• Dégâts augmentés de [+trap_dmg]\n\t• Durée de vie augmentée de [+trap_time]",
        },
        ignite1 = {
            name = "Rage Intérieure I",
            info = "Améliore votre capacité de rage intérieure\n\t• Taux de vague augmenté de [/ignite_rate]\n\t• Le premier anneau génère [ignite_flames] flammes supplémentaires",
        },
        ignite2 = {
            name = "Rage Intérieure II",
            info = "Améliore votre capacité de rage intérieure\n\t• Coût en carburant diminué de [-ignite_cost]\n\t• Le premier anneau génère [ignite_flames] flammes supplémentaires",
        },
        fuel = {
            name = "Livraison de Carburant !",
            info = "Obtenez instantanément [fuel] carburant",
        }
	}
}

wep.SCP682 = {
	skills = {
		_overview = { "primary", "secondary", "charge", "shield" },
		primary = {
            name = "Attaque Basique",
            dsc = "Attaquez avec votre patte directement devant vous en infligeant des dégâts mineurs",
        },
        secondary = {
            name = "Morsure",
            dsc = "Maintenez la touche pour préparer une attaque puissante qui infligera des dégâts importants dans une zone en forme de cône devant vous",
        },
        charge = {
            name = "Charge",
            dsc = "Après un court délai, chargez vers l'avant et devenez inarrêtable. À pleine vitesse, tuez tout le monde sur votre chemin et gagnez la capacité de franchir la plupart des portes. Cette compétence doit être débloquée dans l'arbre de compétences",
        },
        shield = {
            name = "Bouclier",
            dsc = "Bouclier qui absorbera tous les dégâts non directs/de chute. Cette capacité est affectée par les améliorations achetées dans votre arbre de compétences",
        },
        shield_bar = {
            name = "Bouclier",
            dsc = "Quantité actuelle de bouclier qui absorbera tous les dégâts non directs/de chute",
        },
	},

	upgrades = {
		parse_description = true,

		shield_a = {
            name = "Bouclier Renforcé",
            info = "Améliore la puissance de votre bouclier\n\t• Puissance du bouclier : [%shield]\n\t• Temps de recharge : [%shield_cd]",
        },
        shield_b = {
            name = "Bouclier de Régénération",
            info = "Modifie la puissance de votre bouclier\n\t• Puissance du bouclier : [%shield]\n\t• Temps de recharge : [%shield_cd]\n\t• Le temps de recharge commence après que le bouclier soit complètement épuisé\n\t• Lorsque le bouclier est en recharge, régénérez [shield_regen] PV/s",
        },
        shield_c = {
            name = "Bouclier de Sacrifice",
            info = "Modifie la puissance de votre bouclier\n\t• Temps de recharge : [%shield_cd]\n\t• Le temps de recharge commence après que le bouclier soit complètement épuisé\n\t• La puissance de votre bouclier est égale à votre PV maximum\n\t• Lorsqu'il est brisé, vous perdez [shield_hp] PV maximum",
        },
        shield_d = {
            name = "Bouclier Réfléchissant",
            info = "Modifie la puissance de votre bouclier\n\t• Puissance du bouclier : [%shield]\n\t• Temps de recharge : [%shield_cd]\n\t• Le temps de recharge commence après que le bouclier soit complètement épuisé\n\t• Votre bouclier bloque seulement [%shield_pct] des dégâts\n\t• [%reflect_pct] des dégâts bloqués sont réfléchis vers l'attaquant",
        },

        shield_1 = {
            name = "Bouclier I",
            info = "Ajoute des effets à votre bouclier. Une fois complètement brisé, recevez un bonus de vitesse de déplacement de [+shield_speed_pow] pour [shield_speed_dur] secondes",
        },
        shield_2 = {
            name = "Bouclier II",
            info = "Ajoute des effets à votre bouclier. Une fois complètement brisé, recevez un bonus de vitesse de déplacement de [+shield_speed_pow] pour [shield_speed_dur] secondes. De plus, chaque point de dégât reçu réduit le temps de recharge du bouclier de [shield_cdr] secondes",
        },

        attack_1 = {
            name = "Coup Renforcé",
            info = "Améliore votre attaque basique\n\t• Temps de recharge réduit de [-prim_cd]\n\t• Dégâts augmentés de [prim_dmg]",
        },
        attack_2 = {
            name = "Morsure Renforcée",
            info = "Améliore votre morsure\n\t• Portée augmentée de [+sec_range]\n\t• Vitesse de déplacement pendant la préparation augmentée de [+sec_speed]",
        },
        attack_3 = {
            name = "Coup Impitoyable",
            info = "Améliore à la fois l'attaque basique et la morsure\n\t• Les deux attaques infligent des saignements\n\t• L'attaque de morsure inflige une fracture lorsqu'elle est complètement chargée",
        },

        charge_1 = {
            name = "Charge",
            info = "Débloque la capacité de charge",
        },
        charge_2 = {
            name = "Charge Impitoyable",
            info = "Renforce la capacité de charge\n\t• Temps de recharge réduit de [-charge_cd]\n\t• La durée de l'étourdissement et du ralentissement est réduite de [-charge_stun]",
        },
	}
}

wep.SCP8602 = {
	skills = {
		_overview = { "passive", "primary", "defense", "charge" },
		primary = {
            name = "Attaque",
            dsc = "Effectuer une attaque de base",
        },
        defense = {
            name = "Posture Défensive",
            dsc = "Maintenez pour activer. En maintenant, vous gagnez de la protection au fil du temps mais vous êtes également ralenti. Relâchez pour foncer en avant et infliger des dégâts égaux à [dmg_ratio] des dégâts atténués. Cette capacité n'a pas de limite de durée",
        },
        charge = {
            name = "Charge",
            dsc = "Gagnez de la vitesse au fil du temps et infligez des dégâts au premier joueur devant vous. Si le joueur attaqué est suffisamment proche d'un mur, épinglez-le contre ce mur pour augmenter les dégâts",
        },
        passive = {
            name = "Passif",
            dsc = "Vous voyez les joueurs à l'intérieur de votre forêt et pendant un certain temps après qu'ils en soient sortis. Les joueurs à l'intérieur de la forêt perdent de la santé mentale, s'ils n'ont plus de santé mentale, ils perdent de la santé à la place. Soignez-vous avec la santé mentale/santé des joueurs à l'intérieur de la forêt. Cette guérison peut dépasser votre santé maximale",
        },
        overheal_bar = {
            name = "Soin Excédentaire",
            dsc = "Santé excédentaire soignée",
        },
        defense_bar = {
            name = "Défense",
            dsc = "Puissance de protection actuelle",
        },
        charge_bar = {
            name = "Charge",
            dsc = "Temps de charge restant",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Forêt Dense I",
            info = "Améliore votre capacité passive\n\t• Soin excédentaire maximal augmenté de [+overheal]\n\t• Taux passif augmenté de [/passive_rate]\n\t• Temps de détection des joueurs augmenté de [+detect_time]",
        },
        passive2 = {
            name = "Forêt Dense II",
            info = "Améliore votre capacité passive\n\t• Soin excédentaire maximal augmenté de [+overheal]\n\t• Taux passif augmenté de [/passive_rate]\n\t• Temps de détection des joueurs augmenté de [+detect_time]",
        },
        primary = {
            name = "Simple mais Dangereux",
            info = "Améliore votre attaque de base\n\t• Temps de recharge réduit de [-primary_cd]\n\t• Dégâts augmentés de [+primary_dmg]",
        },
        def1a = {
            name = "Armure Rapide",
            info = "Modifie votre capacité de posture défensive\n\t• Temps d'activation réduit de [-def_time]\n\t• Temps de recharge augmenté de [+def_cooldown]",
        },
        def1b = {
            name = "Armure Rapide",
            info = "Modifie votre capacité de posture défensive\n\t• Temps d'activation augmenté de [+def_time]\n\t• Temps de recharge réduit de [-def_cooldown]",
        },
        def2a = {
            name = "Longue Charge",
            info = "Modifie votre capacité de posture défensive\n\t• Distance maximale de la charge augmentée de [+def_range]\n\t• Largeur de la charge réduite de [-def_width]",
        },
        def2b = {
            name = "Charge Maladroite",
            info = "Modifie votre capacité de posture défensive\n\t• Distance maximale de la charge réduite de [-def_range]\n\t• Largeur de la charge augmentée de [+def_width]",
        },
        def3a = {
            name = "Armure Lourde",
            info = "Modifie votre capacité de posture défensive\n\t• Protection maximale augmentée de [+def_prot]\n\t• Ralentissement maximal augmenté de [+def_slow]",
        },
        def3b = {
            name = "Armure Légère",
            info = "Modifie votre capacité de posture défensive\n\t• Protection maximale réduite de [-def_prot]\n\t• Ralentissement maximal réduit de [-def_slow]",
        },
        def4 = {
            name = "Armure Efficace",
            info = "Améliore votre capacité de posture défensive\n\t• Multiplicateur de conversion des dégâts augmenté de [+def_mult]",
        },
        charge1 = {
            name = "Charge I",
            info = "Améliore votre capacité de charge\n\t• Temps de recharge réduit de [-charge_cd]\n\t• Durée augmentée de [+charge_time]\n\t• Dégâts de base augmentés de [+charge_dmg]",
        },
        charge2 = {
            name = "Charge II",
            info = "Améliore votre capacité de charge\n\t• Portée augmentée de [+charge_range]\n\t• Durée augmentée de [+charge_time]\n\t• Dégâts d'épingle augmentés de [+charge_pin_dmg]",
        },
        charge3 = {
            name = "Charge III",
            info = "Améliore votre capacité de charge\n\t• Vitesse augmentée de [+charge_speed]\n\t• Dégâts de base augmentés de [+charge_dmg]\n\t• Épingler un joueur contre un mur lui brise les os",
        },
	}
}

wep.SCP939 = {
	skills = {
		_overview = { "passive", "primary", "trail", "special" },
		primary = {
            name = "Attaque",
            dsc = "Mordez tout le monde dans une zone en forme de cône devant vous",
        },
        trail = {
            name = "ANM-C227",
            dsc = "Maintenez la touche enfoncée pour laisser une traînée ANM-C227 derrière vous",
        },
        special = {
            name = "Détection",
            dsc = "Commencez à détecter les joueurs autour de vous",
        },
        passive = {
            name = "Passif",
            dsc = "Vous ne pouvez pas voir les joueurs, mais vous pouvez voir les ondes sonores. Vous avez une aura ANM-C227 autour de vous",
        },
        special_bar = {
            name = "Détection",
            dsc = "Temps de détection restant",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Aura I",
            info = "Améliore votre capacité passive\n\t• Rayon de l'aura augmenté de [+aura_radius]\n\t• Dégâts de l'aura augmentés de [aura_damage]",
        },
        passive2 = {
            name = "Aura II",
            info = "Améliore votre capacité passive\n\t• Rayon de l'aura augmenté de [+aura_radius]\n\t• Dégâts de l'aura augmentés de [aura_damage]",
        },
        passive3 = {
            name = "Aura III",
            info = "Améliore votre capacité passive\n\t• Rayon de l'aura augmenté de [+aura_radius]\n\t• Dégâts de l'aura augmentés de [aura_damage]",
        },
        attack1 = {
            name = "Morsure I",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Dégâts augmentés de [+attack_dmg]",
        },
        attack2 = {
            name = "Morsure II",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Portée augmentée de [+attack_range]",
        },
        attack3 = {
            name = "Morsure III",
            info = "Améliore votre capacité d'attaque\n\t• Dégâts augmentés de [+attack_dmg]\n\t• Portée augmentée de [+attack_range]\n\t• Vos attaques ont une chance d'appliquer un saignement",
        },
        trail1 = {
            name = "Amnésie I",
            info = "Améliore votre capacité ANM-C227\n\t• Rayon augmenté de [+trail_radius]\n\t• Taux de génération de stacks augmenté de [/trail_rate]",
        },
        trail2 = {
            name = "Amnésie II",
            info = "Améliore votre capacité ANM-C227\n\t• Dégâts augmentés de [trail_dmg]\n\t• Nombre maximum de stacks augmenté de [+trail_stacks]",
        },
        trail3a = {
            name = "Amnésie III A",
            info = "Améliore votre capacité ANM-C227\n\t• Durée de vie de la traînée augmentée de [+trail_life]\n\t• Rayon augmenté de [+trail_radius]",
        },
        trail3b = {
            name = "Amnésie III B",
            info = "Améliore votre capacité ANM-C227\n\t• Nombre maximum de stacks augmenté de [+trail_stacks]",
        },
        trail3c = {
            name = "Amnésie III C",
            info = "Améliore votre capacité ANM-C227\n\t• Taux de génération de stacks augmenté de [/trail_rate]",
        },
        special1 = {
            name = "Écholocalisation I",
            info = "Améliore votre capacité spéciale\n\t• Temps de recharge réduit de [-special_cd]\n\t• Rayon augmenté de [+special_radius]",
        },
        special2 = {
            name = "Écholocalisation II",
            info = "Améliore votre capacité spéciale\n\t• Temps de recharge réduit de [-special_cd]\n\t• Durée augmentée de [+special_times]",
        },
	}
}

wep.SCP966 = {
	skills = {
		_overview = { "passive", "attack", "channeling", "mark" },
		attack = {
            name = "Attaque basique",
            dsc = "Effectuez une attaque basique. Vous ne pouvez attaquer que les joueurs ayant au moins 10 stacks de fatigue. Les joueurs attaqués perdent quelques stacks de fatigue. Les effets de cette attaque sont affectés par l'arbre de compétences",
        },
        channeling = {
            name = "Canalisation",
            dsc = "Canaliser la capacité sélectionnée dans l'arbre de compétences",
        },
        mark = {
            name = "Marque de la mort",
            dsc = "Marquez un joueur. Les joueurs marqués transféreront les stacks de fatigue des autres joueurs proches vers eux-mêmes",
        },
        passive = {
            name = "Fatigue",
            dsc = "De temps en temps, vous appliquez des stacks de fatigue aux joueurs proches. Vous gagnez également une stack passive pour chaque stack de fatigue appliquée",
        },
        channeling_bar = {
            name = "Canalisation",
            dsc = "Temps restant de la capacité de canalisation",
        },
        mark_bar = {
            name = "Marque de la mort",
            dsc = "Temps restant de la marque sur le joueur marqué",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Fatigue I",
            info = "Améliore votre capacité passive\n\t• Taux passif augmenté de [/passive_rate]",
        },
        passive2 = {
            name = "Fatigue II",
            info = "Améliore votre capacité passive\n\t• Taux passif augmenté de [/passive_rate]\n\t• Portée passive augmentée de [+passive_radius]",
        },
        basic1 = {
            name = "Griffes Aiguisées I",
            info = "Améliore votre attaque basique en augmentant les dégâts de [%basic_dmg] pour chaque [basic_stacks] stacks passives. Le gain de stacks passives débloque également :\n\t• [bleed1_thr] stacks : Applique une hémorragie si la cible ne saigne pas\n\t• [drop1_thr] stacks : La perte de stacks de fatigue de la cible est réduite à [%drop1]\n\t• [slow_thr] stacks : La cible est ralentie de [-slow_power] pendant [slow_dur] secondes",
        },
        basic2 = {
            name = "Griffes Aiguisées II",
            info = "Améliore votre attaque basique en augmentant les dégâts de [%basic_dmg] pour chaque [basic_stacks] stacks passives. Le gain de stacks passives débloque également :\n\t• [bleed2_thr] stacks : Applique une hémorragie à l'impact\n\t• [drop2_thr] stacks : La perte de stacks de fatigue de la cible est réduite à [%drop2]\n\t• [hb_thr] stacks : Applique une hémorragie sévère à l'impact au lieu d'une hémorragie",
        },
        heal = {
            name = "Drain de Sang",
            info = "Vous soignez de [%heal_rate] par stack passive par stack de fatigue de la cible à chaque coup",
        },
        channeling_a = {
            name = "Fatigue Infinie",
            info = "Débloque une capacité de canalisation qui vous permet de vous concentrer sur une seule cible\n\t• Passif désactivé pendant la canalisation\n\t• Temps de recharge [channeling_cd] secondes\n\t• Durée maximale [channeling_time] secondes\n\t• La cible gagne un stack de fatigue toutes les [channeling_rate] secondes",
        },
        channeling_b = {
            name = "Drain d'Énergie",
            info = "Débloque une capacité de canalisation qui vous permet de drainer des stacks de fatigue des joueurs proches\n\t• Passif désactivé pendant la canalisation\n\t• Temps de recharge [channeling_cd] secondes\n\t• Durée maximale [channeling_time] secondes\n\t• Chaque [channeling_rate] seconde, transfère 1 stack de fatigue de tous les joueurs proches aux stacks passives",
        },
        channeling = {
            name = "Canalisation Renforcée",
            info = "Améliore votre capacité de canalisation\n\t• Portée de la canalisation augmentée de [+channeling_range_mul]\n\t• Durée de la canalisation augmentée de [+channeling_time_mul]",
        },
        mark1 = {
            name = "Marque Mortelle I",
            info = "Améliore la capacité de marque :\n\t• Taux de transfert de stacks augmenté de [/mark_rate]",
        },
        mark2 = {
            name = "Marque Mortelle II",
            info = "Améliore la capacité de marque :\n\t• Taux de transfert de stacks augmenté de [/mark_rate]\n\t• Portée de transfert de stacks augmentée de [+mark_range]",
        },
	}
}

wep.SCP24273 = {
	skills = {
		_overview = { "change", "primary", "secondary", "special" },
		primary = {
            name = "Dash / Camouflage",
            dsc = "\nJuge :\nFoncez vers l'avant en infligeant des dégâts à tous ceux sur votre chemin\n\nProcureur :\nActivez le camouflage. Pendant le camouflage, vous êtes moins visible. Utiliser des compétences, bouger ou recevoir des dégâts l'interrompt",
        },
        secondary = {
            name = "Examen / Surveillance",
            dsc = "\nJuge :\nCommencez à vous concentrer sur le joueur ciblé pendant un certain temps. Lorsque le sort est entièrement lancé, ralentissez la cible et infligez des dégâts. Si la ligne de vue est perdue, la compétence est interrompue et vous êtes ralenti à la place\n\nProcureur :\nQuittez votre corps et regardez depuis la perspective d'un joueur aléatoire à proximité. Votre passif fonctionne également depuis la perspective de ce joueur",
        },
        special = {
            name = "Jugement / Fantôme",
            dsc = "\nJuge :\nRestez sur place et forcez tous les joueurs à proximité à marcher vers vous. Lorsque c'est terminé, les joueurs à proximité immédiate reçoivent des dégâts et sont repoussés\n\nProcureur :\nEntrez en forme de fantôme. En forme de fantôme, vous êtes immunisé contre tout dommage (sauf les explosions et les dommages directs)",
        },
        change = {
            name = "Juge / Procureur",
            dsc = "\nChangez entre le mode Juge et le mode Procureur\n\nJuge :\nLes dégâts que vous infligez sont augmentés par les preuves accumulées sur la cible. Attaquer la cible réduit le niveau de preuves. Attaquer des joueurs avec des preuves complètes les tue instantanément\n\nProcureur :\nVous êtes ralenti et vous recevez une protection contre les dommages par balles. Regarder les joueurs recueille des preuves contre eux",
        },
        camo_bar = {
            name = "Camouflage",
            dsc = "Temps de camouflage restant",
        },
        spectate_bar = {
            name = "Surveillance",
            dsc = "Temps de surveillance restant",
        },
        drain_bar = {
            name = "Examen",
            dsc = "Temps d'examen restant",
        },
        ghost_bar = {
            name = "Fantôme",
            dsc = "Temps de fantôme restant",
        },
        special_bar = {
            name = "Jugement",
            dsc = "Temps de jugement restant",
        },
	},

	upgrades = {
		parse_description = true,

		j_passive1 = {
            name = "Juge strict I",
            info = "Améliore votre compétence passive de juge\n\t• Les preuves augmentent les dégâts jusqu'à [%j_mult] supplémentaire\n\t• Perte de preuves lors d'une attaque réduite à [%j_loss]",
        },
        j_passive2 = {
            name = "Juge strict II",
            info = "Améliore votre compétence passive de juge\n\t• Les preuves augmentent les dégâts jusqu'à [%j_mult] supplémentaire\n\t• Perte de preuves lors d'une attaque réduite à [%j_loss]",
        },
        p_passive1 = {
            name = "Procureur I",
            info = "Améliore votre compétence passive de procureur\n\t• Protection contre les balles augmentée à [%p_prot]\n\t• Ralentissement augmenté à [%p_slow]\n\t• Taux de collecte de preuves augmenté à [%p_rate] par seconde",
        },
        p_passive2 = {
            name = "Procureur II",
            info = "Améliore votre compétence passive de procureur\n\t• Protection contre les balles augmentée à [%p_prot]\n\t• Ralentissement augmenté à [%p_slow]\n\t• Taux de collecte de preuves augmenté à [%p_rate] par seconde",
        },
        dash1 = {
            name = "Dash I",
            info = "Améliore votre compétence de dash\n\t• Temps de recharge réduit de [-dash_cd]\n\t• Dégâts augmentés de [+dash_dmg]",
        },
        dash2 = {
            name = "Dash II",
            info = "Améliore votre compétence de dash\n\t• Temps de recharge réduit de [-dash_cd]\n\t• Dégâts augmentés de [+dash_dmg]",
        },
        camo1 = {
            name = "Camouflage I",
            info = "Améliore votre compétence de camouflage\n\t• Temps de recharge réduit de [-camo_cd]\n\t• Durée augmentée de [+camo_dur]\n\t• Vous pouvez vous déplacer de [camo_limit] unités sans interrompre cette compétence",
        },
        camo2 = {
            name = "Camouflage II",
            info = "Améliore votre compétence de camouflage\n\t• Temps de recharge réduit de [-camo_cd]\n\t• Durée augmentée de [+camo_dur]\n\t• Vous pouvez vous déplacer de [camo_limit] unités sans interrompre cette compétence",
        },
        drain1 = {
            name = "Examen I",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-drain_cd]\n\t• Durée réduite de [-drain_dur]",
        },
        drain2 = {
            name = "Examen II",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-drain_cd]\n\t• Durée réduite de [-drain_dur]",
        },
        spect1 = {
            name = "Surveillance I",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-spect_cd]\n\t• Durée augmentée de [+spect_dur]\n\t• Protection contre les balles augmentée à [%spect_prot]",
        },
        spect2 = {
            name = "Surveillance II",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-spect_cd]\n\t• Durée augmentée de [+spect_dur]\n\t• Protection contre les balles augmentée à [%spect_prot]",
        },
        combo = {
            name = "Cour Suprême",
            info = "Améliore vos compétences de jugement et de fantôme\n\t• Protection de jugement augmentée à [%special_prot]\n\t• Durée de fantôme augmentée de [+ghost_dur]",
        },
        spec = {
            name = "Jugement",
            info = "Améliore votre compétence de jugement\n\t• Temps de recharge réduit de [-special_cd]\n\t• Durée augmentée de [+special_dur]\n\t• Protection augmentée à [%special_prot]",
        },
        ghost1 = {
            name = "Fantôme I",
            info = "Améliore votre compétence de fantôme\n\t• Temps de recharge réduit de [-ghost_cd]\n\t• Durée augmentée de [+ghost_dur]\n\t• Soin augmenté à [ghost_hel] par 1 preuve consommée",
        },
        ghost2 = {
            name = "Fantôme II",
            info = "Améliore votre compétence de fantôme\n\t• Temps de recharge réduit de [-ghost_cd]\n\t• Durée augmentée de [+ghost_dur]\n\t• Soin augmenté à [ghost_hel] par 1 preuve consommée",
        },
        change1 = {
            name = "Échange I",
            info = "Temps de recharge de changement réduit de [-change_cd]",
        },
        change2 = {
            name = "Échange II",
            info = "Temps de recharge de changement réduit de [-change_cd]. De plus, changer de mode n'interrompt plus la compétence de camouflage",
        },
	}
}

wep.SCP3199 = {
	skills = {
		_overview = { "passive", "primary", "special", "egg" },
		eggs_max = "Vous avez déjà le nombre maximum d'œufs !",

        primary = {
            name = "Attaque",
            dsc = "Effectuez une attaque de base. Toucher une cible active (ou rafraîchit) la frénésie, applique l'effet de blessures profondes et accorde un stack passif et un stack de frénésie.\nLes attaques infligent des dégâts réduits aux cibles avec des blessures profondes. Manquer l'attaque arrête la frénésie. Toucher uniquement la cible avec des blessures profondes arrête la frénésie et applique une pénalité de tokens",
        },
        special = {
            name = "Attaque de l'Au-delà",
            dsc = "S'active après [tokens] attaques réussies consécutives. Utilisez pour terminer instantanément la frénésie et endommager tous les joueurs qui ont des blessures profondes. Les joueurs affectés sont également ralentis",
        },
        egg = {
            name = "Œufs",
            dsc = "Après avoir tué un joueur, vous pouvez pondre un œuf. Lorsque vous recevez des dégâts létaux, vous réapparaîtrez à un œuf aléatoire. La réapparition consomme l'œuf. De plus, chaque œuf accorde [prot] de protection contre les balles (plafonné à [cap])\n\nŒufs actuels : [eggs] / [max]",
        },
        passive = {
            name = "Passif",
            dsc = "Pendant la frénésie, voyez l'emplacement des joueurs à proximité sans blessures profondes. Gagner des tokens de frénésie accorde également des tokens passifs. Si votre attaque touche uniquement un joueur avec des blessures profondes, vous perdrez [penalty] de stacks. Les tokens passifs améliorent vos autres compétences\n\nRégénérer [heal] PV par seconde en frénésie\nBonus de dégâts d'attaque : [dmg]\nBonus de vitesse de frénésie : [speed]\nRalenti supplémentaire de l'attaque spéciale : [slow]\nLes attaques spéciales infligent [bleed] niveau(x) de saignement",
        },
        frenzy_bar = {
            name = "Frénésie",
            dsc = "Temps de frénésie restant",
        },
        egg_bar = {
            name = "Œuf",
            dsc = "Temps de pondaison restant",
        },
	},

	upgrades = {
		parse_description = true,

		frenzy1 = {
            name = "Frénésie I",
            info = "Améliore votre capacité de frénésie\n\t• Durée augmentée de [+frenzy_duration]\n\t• Nombre maximum de stacks augmentés de [frenzy_max]",
        },
        frenzy2 = {
            name = "Frénésie II",
            info = "Améliore votre capacité de frénésie\n\t• Nombre maximum de stacks augmentés de [frenzy_max]\n\t• Vitesse de frénésie augmentée de [%frenzy_speed_stacks] par stack passif",
        },
        frenzy3 = {
            name = "Frénésie III",
            info = "Améliore votre capacité de frénésie\n\t• Durée augmentée de [+frenzy_duration]\n\t• Vitesse de frénésie augmentée de [%frenzy_speed_stacks] par stack passif",
        },
        attack1 = {
            name = "Griffes Aiguisées I",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Dégâts augmentés de [+attack_dmg]",
        },
        attack2 = {
            name = "Griffes Aiguisées II",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Dégâts augmentés de [%attack_dmg_stacks] par stack passif",
        },
        attack3 = {
            name = "Griffes Aiguisées III",
            info = "Améliore votre capacité d'attaque\n\t• Dégâts augmentés de [+attack_dmg]\n\t• Dégâts augmentés de [%attack_dmg_stacks] par stack passif",
        },
        special1 = {
            name = "Attaque de l'Au-delà I",
            info = "Améliore votre capacité spéciale\n\t• Dégâts augmentés de [+special_dmg]\n\t• Ralenti augmenté de [%special_slow] par stack passif\n\t• Durée du ralenti augmentée de [+special_slow_duration]",
        },
        special2 = {
            name = "Attaque de l'Au-delà II",
            info = "Améliore votre capacité spéciale\n\t• Dégâts augmentés de [+special_dmg]\n\t• Ralenti augmenté de [%special_slow] par stack passif\n\t• Durée du ralenti augmentée de [+special_slow_duration]",
        },
        passive = {
            name = "Sens du Sang",
            info = "Rayon de détection passif augmenté de [+passive_radius]",
        },
        egg = {
            name = "Œuf de Pâques",
            info = "Pond instantanément un nouvel œuf. Cette capacité peut dépasser la limite des œufs",
        },
	}
}

wep.SCP009 = {
	name = "SCP-009",
}

wep.SCP500 = {
	name = "SCP-500",
	death_info = "Vous vous êtes étouffé avec ce SCP-500",
	text_used = "Dès que vous avez avalé cette pilule, vous vous êtes senti mieux",
}

wep.SCP714 = {
	name = "SCP-714"
}

wep.SCP1025 = {
	name = "SCP-1025",
	diseases = {
		arrest = "Arrêt cardiaque",
		mental = "Maladie mentale",
		asthma = "Asthme",
		blindness = "Cécité",
		hemo = "Hémophilie",
		oste = "Ostéoporose",

		adhd = "TDAH",
		throm = "Thrombocytémie",
		urbach = "Maladie d'Urbach-Wiethe",

		gas = "Tympanite",
	},
	descriptions = {
		arrest = "L'arrêt cardiaque est une perte soudaine du flux sanguin résultant de l'incapacité du cœur à pomper efficacement. Les signes incluent la perte de conscience et une respiration anormale ou absente. Certaines personnes peuvent ressentir une douleur thoracique, un essoufflement ou des nausées immédiatement avant d'entrer en arrêt cardiaque. Une douleur irradiant vers un bras est un symptôme courant, tout comme un malaise à long terme et une faiblesse générale du cœur. Si elle n'est pas traitée dans les minutes qui suivent, elle conduit généralement à la mort.",
		asthma = "L'asthme est une maladie inflammatoire chronique des voies respiratoires des poumons. Elle se caractérise par des symptômes variables et récurrents, une obstruction réversible des voies respiratoires et des bronchospasmes facilement déclenchés. Les symptômes incluent des épisodes de respiration sifflante, de toux, de serrement de la poitrine et d'essoufflement. Ceux-ci peuvent survenir quelques fois par jour ou quelques fois par semaine.",
		blindness = "L'altération de la vision, également appelée déficience visuelle ou perte de vision, est une capacité réduite à voir à un degré qui pose des problèmes non corrigibles par les moyens habituels, comme les lunettes. Certains incluent également ceux qui ont une capacité réduite à voir parce qu'ils n'ont pas accès à des lunettes ou des lentilles de contact. Le terme cécité est utilisé pour une perte de vision complète ou presque complète.",
		hemo = "L'hémophilie est un trouble génétique principalement hérité qui altère la capacité du corps à former des caillots sanguins, un processus nécessaire pour arrêter les saignements. Cela entraîne des saignements plus longs après une blessure, des ecchymoses faciles et un risque accru de saignement à l'intérieur des articulations ou du cerveau. Les symptômes caractéristiques varient selon la gravité. En général, les symptômes sont des épisodes de saignement internes ou externes.",
		oste = "L'ostéoporose est un trouble squelettique systémique caractérisé par une faible masse osseuse, une détérioration microarchitecturale du tissu osseux entraînant une fragilité osseuse et une augmentation conséquente du risque de fracture. C'est la raison la plus courante de fractures osseuses chez les personnes âgées. Les os qui se cassent couramment comprennent les vertèbres de la colonne vertébrale, les os de l'avant-bras et la hanche. Jusqu'à ce qu'un os se casse, il n'y a généralement aucun symptôme.",

		adhd = "Le trouble du déficit de l'attention avec ou sans hyperactivité (TDAH) est un trouble du neurodéveloppement caractérisé par de l'inattention, des accès d'énergie excessive, une hyper-fixation et de l'impulsivité, qui ne sont autrement pas appropriés pour l'âge de la personne. Certaines personnes atteintes de TDAH présentent également des difficultés à réguler les émotions ou des problèmes de fonction exécutive. De plus, il est associé à d'autres troubles mentaux.",
		throm = "La thrombocytémie est une condition caractérisée par un nombre élevé de plaquettes (thrombocytes) dans le sang. Un nombre élevé de plaquettes ne signale pas nécessairement des problèmes cliniques et peut être détecté lors d'une numération sanguine complète de routine. Cependant, il est important de recueillir des antécédents médicaux complets pour s'assurer que l'augmentation du nombre de plaquettes n'est pas due à un processus secondaire.",
		urbach = "La maladie d'Urbach-Wiethe est une maladie génétique récessive très rare. Les symptômes de la maladie varient considérablement d'une personne à l'autre. La maladie d'Urbach-Wiethe présente des calcifications symétriques bilatérales sur les lobes temporaux médians. Ces calcifications affectent souvent l'amygdale. On pense que l'amygdale est impliquée dans le traitement des stimuli biologiquement pertinents et dans la mémoire émotionnelle à long terme, en particulier celle associée à la peur.",
	},
	death_info_arrest = "Vous êtes mort d'un arrêt cardiaque",
}

wep.HOLSTER = {
	name = "Holster",
	info = "Utilisez pour cacher l'objet actuellement équipé"
}

wep.ID = {
	name = "ID",
	pname = "Nom :",
	server = "Serveur :",
}

wep.CAMERA = {
	name = "Système de Surveillance",
	showname = "CCTV",
	info = "Les caméras vous permettent de voir ce qui se passe dans l'installation.\nElles vous permettent également de scanner les SCP et de transmettre ces informations à votre canal radio actuel",
	scanning = "Scan en cours...",
	scan_info = "Appuyez sur [%s] pour scanner les SCP",
}

wep.RADIO = {
	name = "Radio",
}

wep.NVG = {
	name = "NVG",
	info = "Lunettes de Vision Nocturne - Dispositif qui rend les zones sombres plus lumineuses et rend les zones lumineuses encore plus lumineuses.\nParfois, vous pouvez voir des choses anormales à travers elles."
}

wep.NVGPLUS = {
	name = "Lunettes NVG Améliorées",
	showname = "NVG+",
	info = "Version améliorée des NVG, vous permettant de les utiliser tout en tenant d'autres objets en main.\n"
}

wep.THERMAL = {
	showname = "THERMAL",
	name = "Dispositif de Vision Thermique"
}

wep.ACCESS_CHIP = {
	name = "Puce d'Accès",
    cname = "Puce d'Accès - %s",
    showname = "PUCE",
    pickupname = "PUCE",
    clearance = "Niveau d'Accès : %i",
    clearance2 = "Niveau d'Accès : ",
    hasaccess = "Accorde l'accès à :",
    NAMES = {
        general = "Général",
        jan1 = "Agent d'entretien",
        jan = "Agent d'entretien",
        jan2 = "Agent d'entretien senior",
        acc = "Comptable",
        log = "Logisticien",
        sci1 = "Chercheur niveau 1",
        sci2 = "Chercheur niveau 2",
        sci3 = "Chercheur niveau 3",
        spec = "Spécialiste de Confinement",
        guard = "Sécurité",
        chief = "Chef de la Sécurité",
        mtf = "MTF",
        com = "Commandant MTF",
        hacked3 = "Piratée 3",
        hacked4 = "Piratée 4",
        hacked5 = "Piratée 5",
        director = "Directeur de Site",
        o5 = "O5",
        goc = "CMO",
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
	none = "AUCUN",
	chip = "Puce Installée : %s",
	chip2 = "Puce Installée : ",
	clearance = "Niveau d'Accès : %i",
	clearance2 = "Niveau d'Accès : ",
	SCREEN = {
		loading = "Chargement",
		name = "Omnitool v4.78",
		installing = "Installation de la nouvelle puce...",
		ejecting = "Éjection de la puce d'accès...",
		ejectwarn = "Êtes-vous sûr de vouloir éjecter la puce?",
		ejectconfirm = "Appuyez à nouveau pour confirmer...",
		chip = "Puce Installée :",
	},
}

wep.MEDKIT = {
	name = "Kit de soin (Charges Restantes : %d)",
	showname = "Kit de soin",
	pickupname = "Kit de soin",
}

wep.MEDKITPLUS = {
	name = "Gros kit de soin (Charges Restantes : %d)",
	showname = "Kit de soin+",
	pickupname = "Kit de soin+",
}

wep.FLASHLIGHT = {
	name = "Lampe torche"
}

wep.BATTERY = {
	name = "Batterie"
}

wep.GASMASK = {
	name = "Masque à gaz"
}

wep.HEAVYMASK = {
	name = "Masque à gaz lourd"
}

wep.FUSE = {
	name = "Fusible",
	name_f = "Fusible %iA",
}

wep.TURRET = {
	name = "Tourelle",
	placing_turret = "Placement de la tourelle",
	pickup_turret = "Ramassage de la tourelle",
	pickup = "Ramasser",
	MODES = {
		off = "Désactiver",
		filter = "Filtrer le personnel",
		target = "Cibler le personnel",
		all = "Cibler tout",
		supp = "Feu de suppression",
		scp = "Cibler les SCPs"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALPHA Warhead Codes #1"
}

wep.ALPHA_CARD2 = {
	name = "ALPHA Warhead Codes #2"
}

wep.COM_TAB = {
	name = "Tablette MTF",
	loading = "Chargement",
	eta = "ETA: ",
	detected = "Sujets détectés:",
	tesla_deactivated = "Teslas desactivées: ",
	change = "RMB - changer",
	confirm = "LMB - confirmer",
	options = {
		scan = "Scanner la fondation",
		tesla = "Désactiver les teslas"
	},
	actions = {
		scan = "Scan en cours...",
		tesla = "Désactivation en cours...",
	}
}

wep.GOC_TAB = {
	name = "Tablette CMO",
	info = "Tablette de la CMO. Contient un explosif qui détruit la tablette a la mort de l'utilisateur",
	loading = "Chargement",
	status = "Status:",
	dist = "Distance de la cible",
	objectives = {
		failed = "Appareil détruit",
		nothing = "Inconnu",
		find = "Trouver l'appareil",
		deliver = "Livrer l'appareil",
		escort = "Escorter l'appareil",
		protect = "Proteger l'appareil",
		escape = "S'enfuir"
	}
}

wep.GOCDEVICE = {
	name = "Appareil CMO",
	placing = "Déploiment de l'appareil..."
}

wep.DOCUMENT = {
	name = "Documents",
	info = "Ensemble de plusieurs documents pouvant contenir des informations précieuses sur les SCP, les installations et le personnel",
	types = {

	}
}

wep.BACKPACK = {
	name = "Sac à dos",
	info = "Vous permet de stocker plus d'objets",
	size = "Taille : ",
	NAMES = {
		small = "Petit Sac à dos",
		medium = "Sac à dos Moyen",
		large = "Grand Sac à dos",
		huge = "Très Grand Sac à dos",
	}
}

wep.ADRENALINE = {
	name = "Adrenaline",
	info = "Octroie un boost d'endurance pendant un court instant",
}

wep.ADRENALINE_BIG = {
	name = "Grosse Adrénaline",
	info = "Octroie un boost d'endurance pendant un bon moment",
}

wep.MORPHINE = {
	name = "Morphine",
	info = "Octroie quelques points de vie supplémentaires qui vont diminuer avec le temps",
}

wep.MORPHINE_BIG = {
	name = "Grosse Morphine",
	info = "Octroie beaucoup de points de vie qui vont diminuer avec le temps",
}

wep.TASER = {
	name = "Taser"
}

wep.PIPE = {
	name = "Tuyau de métal"
}

wep.GLASS_KNIFE = {
	name = "Couteau en verre"
}

wep.CLOTHES_CHANGER = {
	name = "Changeur de Vêtements (Holster)",
	info = "Fonctionne comme un holster classique. Permet également de voler des vêtements sur des corps. Regardez un cadavre et maintenez LMB pour utiliser",
	skill = "Changeur de Vêtements",
	wait = "Attendez",
	ready = "Prêt",
	progress = "Changement de vêtements"
}

wep.DOOR_BLOCKER = {
	name = "Bloqueur de Porte",
	info = "Visez le bouton et maintenez LMB pour charger. Relâchez LMB pour décharger et bloquer temporairement l'utilisation de la porte",
	skill = "Bloqueur de Porte",
	wait = "Attendez",
	ready = "Prêt",
	progress = "Chargement"
}

wep.__slc_ammo = "Munitions"

wep.weapon_stunstick = "Matraque"
wep.weapon_crowbar = "Pied de biche"

--[[-------------------------------------------------------------------------
Minigames
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
RegisterLanguage( lang, "french", "fr" )
