local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

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
Weapons
---------------------------------------------------------------------------]]
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
