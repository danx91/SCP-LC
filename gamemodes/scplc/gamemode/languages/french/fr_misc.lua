local lang = LANGUAGE

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