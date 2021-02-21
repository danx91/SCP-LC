local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Vous pouvez être sélectionné comme SCP a partir du prochain round",
	scpwait = "Vous devez attendre %i rounds avant de pouvoir jouer en tant que SCP",
	abouttostart = "La partie va commencer dans %i secondes!",
	kill = "Vous avez reçu %d points pour avoir tué %s: %s!",
	assist = "Vous avez reçu %d points pour avoir contribué a la mort d'un joueur: %s!",
	rdm = "Vous avez perdu %d points pour avoir tué %s: %s!",
	//acc_nocard = "Une carte d'accès est nécessaire pour faire fonctionner cette porte",
	//acc_wrongcard = "Une carte d'accès avec un niveau d'accréditation plus élevé est nécessaire pour faire fonctionner cette porte",
	acc_denied = "Accès refusé",
	acc_granted = "Accès accordé",
	//device_nocard = "Une carte d'accès est nécessaire pour faire fonctionner cet appareil",
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
	prestigeup = "Le joueur %s a gagné un niveau de prestige! Son niveau de prestige actuel est: %i",
}

lang.NFailed = "Echec a accéder NRegistry avec la clé: %s"

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
}

lang.NCFailed = "Echec a accéder NRegistry avec la clé: %s"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}

hud.pickup = "Récuperer"
hud.class = "Classe"
hud.team = "Équipe"
hud.prestige_points = "Points de prestige"
hud.hp = "Points de vie"
hud.stamina = "Endurance"
hud.sanity = "Santé mentale"
hud.xp = "XP"

lang.HUD = hud

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "Clique G - Selectionner"
lang.eq_rmb = "Clique D - Lacher"
lang.eq_hold = "Maintenir Clique G - Bouger l'objet"
lang.eq_vest = "Tenue"
lang.eq_key = "Appuyez '%s' pour ouvrir l'EQ"

lang.info = "Informations"
lang.author = "Auteur"
lang.mobility = "Mobilité"
lang.weight = "Poids"
lang.protection = "Protection"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "Escorter",
	gatea = "Detruire la Gate A"
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}

effects.permanent = "Permanent"
effects.bleeding = "Saignement"
effects.doorlock = "Porte bloquée"
effects.amnc227 = "AMN-C227"
effects.insane = "Insensé"
effects.gas_choke = "En train d'étouffer"
effects.radiation = "Radiation"
effects.deep_wounds = "Blessure profonde"

lang.EFFECTS = effects

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Apperçu des classes"
lang.preview = "Apperçu"
lang.random = "Aléatoire"
lang.price = "Prix"
lang.buy = "Acheter"
lang.refound = "Remboursement"
lang.none = "Aucune"

lang.details = {
	details = "Details",
	name = "Nom",
	team = "Équipe",
	price = "Prix de la classe (en points de prestige)",
	walk_speed = "Vitesse de marche",
	run_speed = "Vitesse de course",
	chip = "Puce d'accès",
	persona = "Faux ID",
	weapons = "Armes",
	class = "Classe",
	hp = "Points de vie",
	speed = "Vitesse",
	health = "Points de vie", 
   	sanity = "Santé mentale" 
}

lang.headers = {
	support = "Support",
	classes = "Classes",
	scp = "SCP"
}

lang.view_cat = {
	classd = "Classes D",
	sci = "Scientifiques",
	mtf = "Securité",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alpha-1",
	ci = "Insurrection Du Chaos",
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Non connecté"

lang.scoreboard = {
	name = "Scoreboard",
	playername = "Nom",
	ping = "Ping",
	prestige = "Prestige",
	level = "Niveau",
	score = "Score",
	ranks = "Rang",
}

lang.ranks = {
	author = "Auteur",
	vip = "VIP",
	tester = "Testeur",
	countbob = "Count Bob"
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
	requiresany = "Necessite tout"
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "Nothing"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}

misc.content_checker = {
	title = "Contenu du Gamemode",
	msg = [[Il semble que vous n'avez pas tout les addons. Cela pourrait causer des erreurs comme du contenu manquant  (textures/modeles/sons) et pourrait affecter votre experience de jeu.
Vous n'avez pas  %i addons sur %i. Voudriez vous les télécharger maintenant? (Vous pouvez les télécharger via le jeu ou bien sur la page du workshop )]],
	no = "Non",
	download = "Telecharger maintenant",
	workshop = "Afficher la page du workshop",
	downloading = "Telechargement en cours",
	mounting = "Montage",
	processing = "Addon en traitement: %s\nStatus: %s",
	cancel = "Annuler"
}

lang.MISC = misc

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}

vest.guard = "Tenue de garde de sécurité"
vest.heavyguard = "Tenue de garde lourd"
vest.specguard = "Tenue de garde spécial"
vest.medic = "Tenue de Medecin"
vest.ntf = "Tenue d'MTF NTF"
vest.ci = "Tenue de l'Insurrection du Chaos"
vest.fire = "Tenue ignifuge"
vest.electro = "Tenue resistante a l'électricité"

lang.VEST = vest

local dmg = {}

dmg.BURN = "Dégâts de brûlure"
dmg.SHOCK = "Dégâts électriques"
dmg.BULLET = "Dégâts par balle"
dmg.FALL = "Dégâts"

lang.DMG = dmg

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}

teams.SPEC = "Spectateurs"
teams.CLASSD = "Classes D"
teams.SCI = "Scientifiques"
teams.MTF = "MTF"
teams.CI = "IC"
teams.SCP = "SCP"

lang.TEAMS = teams


--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}

classes.unknown = "Inconnu"

classes.SCP023 = "SCP 023"
classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
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

classes.classd = "Classe D"
classes.veterand = "Classe D Vétéran"
classes.kleptod = "Classe D kleptomane"
classes.ciagent = "Agent IC"

classes.sciassistant = "Assistant Chercheur"
classes.sci = "Chercheur"
classes.seniorsci = "Chercheur confirmé"
classes.headsci = "Superviseur"

classes.guard = "Garde De Sécurité"
classes.chief = "Chef Des Gardes"
classes.lightguard = "Garde De Sécurité Léger"
classes.heavyguard = "Garde De Sécurité Lourd"
classes.specguard = "Garde De Sécurité Spécialisé"
classes.guardmedic = "Garde De Sécurité Médecin"
classes.cispy = "Espion de l'Insurrection Du Chaos"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Fusil a pompe"
classes.ntf_3 = "MTF NTF - Fusil d'assault"
classes.ntfcom = "Commandant MTF NTF"
classes.ntfsniper = "MTF NTF Sniper"
classes.ntfmedic = "MTF NTF Medecin"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Tireur d'élite"
classes.ci = "Insurrection Du Chaos"
classes.cicom = "Commandant de l'Insurrection Du Chaos"

lang.CLASSES = classes

--[[-------------------------------------------------------------------------
Class Info
---------------------------------------------------------------------------]]
lang.CLASS_INFO = {
	classd = [[Vous êtes un personnel de classe-D
Votre objectif est de vous échapper de la fondation
Coopérez avec les autres et cherchez les cartes
Faites attention au personnel de la fondation et aux SCP]],

	veterand = [[Vous êtes Classe D Veteran
Votre objectif est de vous échapper de la fondation
Coopérez avec les autres
Faites attention au personnel de la fondation et aux SCP]],

	kleptod = [[Vous êtes Classe D Kleptomane
Votre objectif est de vous échapper de la fondation
You avez volé quelque chose au personnel de la fondation
Faites attention au personnel de la fondation et aux SCP]],

	ciagent = [[Vous êtes Agent IC
Votre objectif est de protéger le personnel de Classe D
Escortez les a la sortie
Faites attention au personnel de la fondation et aux SCP]],

	sciassistant = [[Vous êtes Assistant Chercheur
Votre objectif est de vous échapper de la fondation
Coopérez avec les autres scientifiques et la sécurité
Faites attention a l'Insurrection Du Chaos et aux SCP]],

	sci = [[Vous êtes Chercheur
Votre objectif est de vous échapper de la fondation
Coopérez avec les autres scientifiques et la sécurité
Faites attention a l'Insurrection Du Chaos et aux SCP]],

	seniorsci = [[Vous êtes Chercheur Confirmé
Votre objectif est de vous échapper de la fondation
Coopérez avec les autres scientifiques et la sécurité
Faites attention a l'Insurrection Du Chaos et aux SCP]],

	headsci = [[Vous êtes Superviseur
Votre objectif est de vous échapper de la fondation
Coopérez avec les autres scientifiques et la sécurité
Faites attention a l'Insurrection Du Chaos et aux SCP]],

	guard = [[Vous êtes Garde De Sécurité
Votre objectif est de secourir tout les scientifiques
Vous devez tuer tout les Classes D et les SCP]],

	lightguard = [[Vous êtes Garde De Sécurité
Votre objectif est de secourir tout les scientifiques
Vous devez tuer tout les Classes D et les SCP]],

	heavyguard = [[Vous êtes Garde De Sécurité
Votre objectif est de secourir tout les scientifiques
Vous devez tuer tout les Classes D et les SCP]],

	specguard = [[Vous êtes Garde De Sécurité Spécialisé
Votre objectif est de secourir tout les scientifiques
Vous devez tuer tout les Classes D et les SCP]],

	chief = [[Vous êtes Chef De La Sécurité
Votre objectif est de secourir tout les scientifiques
Vous devez tuer tout les Classes D et les SCP]],

	guardmedic = [[Garde De Sécurité Secouriste
Votre objectif est de secourir tout les scientifiques
Utilisez votre kit de soin pour aider vos alliés
Vous devez tuer tout les Classes D et les SCP]],

	cispy = [[Vous êtes Espion IC
Votre objectif est d'aider les Classes D
Faites vous passer pour un garde]],

	ntf_1 = [[Vous êtes MTF NTF
Aidez le personnel a l'intérieur de la fondation
Ne laissez pas les Classes D et les SCP s'échapper]],

	ntf_2 = [[Vous êtes MTF NTF
Aidez le personnel a l'intérieur de la fondation
Ne laissez pas les Classes D et les SCP s'échapper]],

	ntf_3 = [[Vous êtes MTF NTF
Aidez le personnel a l'intérieur de la fondation
Ne laissez pas les Classes D et les SCP s'échapper]],

	ntfmedic = [[Vous êtes MTF NTF Médecin
Aidez le personnel a l'intérieur de la fondation
Utilisez votre kit de soin pour aider les autres MTF]],

	ntfcom = [[Vous êtes Commandant MTF NTF
Aidez le personnel a l'intérieur de la fondation
Ne laissez pas les Classes D et les SCP s'échapper]],

	ntfsniper = [[Vous êtes MTF NTF Sniper
Protegez vos alliés a distance
Ne laissez pas les Classes D et les SCP s'échapper]],

	alpha1 = [[Vous êtes MTF Alpha 1
Vous travaillez directement pour le conseil O5
Protegez la fondation a tout prix
Votre mission est de [DONNÉES SUPPRIMÉES] ]],

	alpha1sniper = [[Vous êtes MTF Alpha 1 Tireur d'Élite
Vous travaillez directement pour le conseil O5
Protegez la fondation a tout prix
Votre mission est de [DONNÉES SUPPRIMÉES] ]],

	ci = [[Vous êtes Soldat de l'Insurrection Du Chaos
Aidez le personnel de Classe D
Tuez les MTF et le personnel de la fondation]],

	cicom = [[Vous êtes Commandant de l'Insurrection Du Chaos
Aidez le personnel de Classe D
Tuez les MTF et le personnel de la fondation]],
	
	SCP023 = [[Vous êtes SCP 023
Votre objectif est de vous échapper de la fondation
Vous allez tuer une personne qui vous a regardé
Clique Droit pour placer un spectre]],

	SCP049 = [[Vous êtes SCP 049
Votre objectif est de vous échapper de la fondation
Votre toucher est mortel pour les humains
Vous pouvez effectuer une intervention chirurgicale pour «guérir» des personnes]],

	SCP0492 = [[Vous êtes SCP 049-2
Votre objectif est de vous échapper de la fondation
Ecoutez les ordres de SCP 049 et protegez le]],

	SCP066 = [[Vous êtes SCP 066
Votre objectif est de vous échapper de la fondation
Vous pouvez jouer des sons très forts]],

	SCP096 = [[Vous êtes SCP 096
Votre objectif est de vous échapper de la fondation
Vous devenez enragé quand quelqu'un vous regarde
Vous pouvez régénérer vos points de vie en appuyant sur R]],

	SCP106 = [[Vous êtes SCP 106
Votre objectif est de vous échapper de la fondation
Vous pouvez traverser les portes et vous téléporter a un endroit sélectionné
Clique Gauche: Teleporter les humains dans votre dimension de poche
Clique Droit: Placer votre point de téléportation
R: Se téléporter]],

	SCP173 = [[Vous êtes SCP 173
Votre objectif est de vous échapper de la fondation
Vous ne pouvez pas bouger lorsque quelqu'un vous regarde
Votre abilité spéciale vous teleporte a l'humain le plus proche]],

	SCP457 = [[Vous êtes SCP 457
Votre objectif est de vous échapper de la fondation
Vous brûlez et enflammez tout ce qui est proche de vous
Vous pouvez placer jusqu'a 5 pièges de feu]],

	SCP682 = [[Vous êtes SCP 682
Votre objectif est de vous échapper de la fondation
Vous avez beaucoup de points de vie
Votre abilité spéciale vous immunise temporairement a tout les dégats]],

	SCP8602 = [[Vous êtes SCP 860-2
Votre objectif est de vous échapper de la fondation
Si vous attaquez quelqu'un proche d'un mur,vous allez
le clouer au mur et lui infliger d'énormes dégâts]],

	SCP939 = [[Vous êtes SCP 939
Votre objectif est de vous échapper de la fondation
Vous pouvez parler aux humains]],

	SCP966 = [[You are SCP 966
Votre objectif est de vous échapper de la fondation
Vous êtes invisible]],

	SCP3199 = [[Vous êtes SCP 3199
Votre objectif est de vous échapper de la fondation
Vous êtes un agile et mortel prédateur
Vous pouvez ressentir le battement cardiaque des humain proches]],
}

lang.CLASS_DESCRIPTION = {
	classd = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Faible
Style de jeu conseillé: 

apperçu:
]],

	[[Difficulté: Facile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	kleptod = [[Difficulté: Difficile
Resistance: Faible
Agilité: Très Élevée
Potentiel de combat: Faible
Style de jeu conseillé: Discrétion et embuscades

apperçu:
]],

	ciagent = [[Difficulté: Moyenne
Resistance: Très Élevée
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	sciassistant = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Normale
Potentiel de combat: Faible
Style de jeu conseillé: 

apperçu:
]],

	sci = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Normale
Potentiel de combat: Faible
Style de jeu conseillé: 

apperçu:
]],

	seniorsci = [[Difficulté: Facile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	headsci = [[Difficulté: Facile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	guard = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	lightguard = [[Difficulté: Difficile
Resistance: Faible
Agilité: Très Élevée
Potentiel de combat: Faible
Style de jeu conseillé: 

apperçu:
]],

	heavyguard = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Faible
Potentiel de combat: Élevé
Style de jeu conseillé: 

apperçu:
]],

	specguard = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Faible
Potentiel de combat: Très Élevé
Style de jeu conseillé: 

apperçu:
]],

	chief = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	guardmedic = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Faible
Style de jeu conseillé: Support et soins

apperçu:
]],

	cispy = [[Difficulté: Très Difficile
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	ntf_1 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	ntf_2 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	ntf_3 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	ntfmedic = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Faible
Style de jeu conseillé: 

apperçu:
]],

	ntfcom = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Très Élevée
Potentiel de combat: Élevé
Style de jeu conseillé: 

apperçu:
]],

	ntfsniper = [[Difficulté: Difficile
Resistance: Normale
Agilité: Normale
Potentiel de combat: Élevé
Style de jeu conseillé: Gardez vos distances 

apperçu:
]],

	alpha1 = [[Difficulté: Moyenne
Resistance: Extrême
Agilité: Très Élevée
Potentiel de combat: Élevé
Style de jeu conseillé: 

apperçu:
]],

	alpha1sniper = [[Difficulté: Difficile
Resistance: Extrême
Agilité: Extrême
Potentiel de combat: Élevé
Style de jeu conseillé: 

apperçu:
]],

	ci = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Élevée
Potentiel de combat: Normal
Style de jeu conseillé: 

apperçu:
]],

	cicom = [[Difficulté: Moyenne
Resistance: Très Élevée
Agilité: Élevée
Potentiel de combat: Élevé
Style de jeu conseillé: 

apperçu:
]],
	--2500hp - normal
	--160 speed - normal
	SCP023 = [[Difficulté: Difficile
Resistance: Faible
Agilité: Élevée
Dégâts: Mort instantanée
Style de jeu conseillé:

Overview:
]],

	SCP049 = [[Difficulté: Difficile
Résistance: Faible
Agilité: Élevée
Damage: Mort instantanée après 3 attaques
Style de jeu conseillé: Creer des zombies

Overview:
]],

	SCP0492 = [[]],

	SCP066 = [[Difficulté: Normale
Resistance: Élevée
Agilité: Normale
Damage: Faible (Dégâts de zone)
Style de jeu conseillé: 

Overview:
]],

	SCP096 = [[Difficulté: Difficile
Resistance: Élevée
Agilité: Très Faible / Extreme en étant enragé
Damage: Mort instantanée
Style de jeu conseillé: 

Overview:
]],

	SCP106 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Faible
Damage: Moyens / Mort instantanée dans la dimension de poche
Style de jeu conseillé:

Overview:
]],

	SCP173 = [[Difficulté: Facile
Resistance: Extrême
Agilité: Super Extreme
Dégâts: Mort instantanée
Style de jeu conseillé:

Overview:
]],

	SCP457 = [[Difficulté: Facile
Resistance: Normale
Agilité: Normale
Dégâts: Moyenne / Du feu peut être répandu
Style de jeu conseillé:

Overview:
]],

	SCP682 = [[Difficulté: Difficile
Resistance: Super Extreme
Agilité: Normal
Dégâts: Elevés
Style de jeu conseillé:

Overview:
]],

	SCP8602 = [[Difficulté: Moyenne
Resistance: Élevée
Agilité: Élevée
Dégâts: Faibles / Élevés (Attaque puissante)
Style de jeu conseillé:

Overview:
]],

	SCP939 = [[Difficulté: Moyenne
Resistance: Normale
Agilité: Élevée
Dégâts: Moyens
Style de jeu conseillé:

Overview:
]],

	SCP966 = [[Difficulté: Moyenne
Resistance: Faible
Agilité: Élevée
Dégâts: Faible / Saignement
Style de jeu conseillé:

Overview:
]],

	SCP3199 = [[Difficulté: Très Difficile
Resistance: Faible
Agilité: Très Élevée
Dégâts: Faibles / Moyens
Style de jeu conseillé:

Overview:
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "Super Vision",
		info = "La luminosité de votre vue est augmentée\nLes endroits sombres ne seront plus un problème"
	}
}

local wep = {}

wep.SCP023 = {
	editMode1 = "Clique Gauche pour placer un spectre",
	editMode2 = "Clique Droit - Annuler, R - Effectuer une rotation",
	preys = "Proies disponibles: %i",
	attack = "Prochaine attaque: %s",
	trapActive = "Un piège est actif!",
	trapInactive = "Clique Droit pour placer un piège",
	upgrades = {
		attack1 = {
			name = "Soif I",
			info = "Votre cooldown d'attaque est réduit de 20 secondes",
		},
		attack2 = {
			name = "Soif II",
			info = "Votre cooldown d'attaque est réduit de 20 secondes supplémentaires\n\t• Réduction totale: 40s",
		},
		attack3 = {
			name = "Soif III",
			info = "Votre cooldown d'attaque est réduit de 20 secondes supplémentaires\n\t• Réduction totale: 60s",
		},
		trap1 = {
			name = "Mauvais présage I",
			info = "Le Cooldown de vos pièges est réduit de 40 secondes",
		},
		trap2 = {
			name = "Mauvais Présage II",
			info = "Le Cooldown de vos pièges est réduit de 20 secondes supplémentaires \nLa distance de mouvement du spectre est augmenté de 25 unités",
		},
		trap3 = {
			name = "Mauvais Présage III",
			info = "La distance de mouvement du spectre est augmenté de 25 unités supplémentaires \n\t• Augmentation totale: 50 unités",
		},
		hp = {
			name = "Mâle Alpha I",
			info = "Vous gagnez 1000 points de vie (Maximum de PV gagnable sur ce SCP) et 10% de protection contre les balles, Parcontre le cooldown des pièges est augmenté de 30 secondes",
		},
		speed = {
			name = "Mâle Alpha II",
			info = "Vous gagnez 10% de vitesse de mouvement et 15% de protection contre les balles, Parcontre le cooldown des pièges est augmenté de 30s\n\t• Protection totale contre les balles: 25%, Augmentation totale du cooldown: 60s",
		},
		alt = {
			name = "Mâle Alpha III",
			info = "Votre cooldown d'attaque est réduit de 30 secondes et votre protection contre les balles augmente de 15% supplémentaires, Cependant vous ne pouvez plus utiliser vos pièges\n\t• Protection totale contre les balles: 40%",
		},
	}
}

wep.SCP049 = {
	surgery = "Opération en cours",
	surgery_failed = "Échec de l'opération !",
	zombies = {
		normal = "Zombie Standard",
		light = "Zombie Léger",
		heavy = "Zombie Lourd"
	},
	upgrades = {
		cure1 = {
			name = "Je Suis Le Remède I",
			info = "Donne une protection de 40% contre les balles",
		},
		cure2 = {
			name = "Je Suis Le Remède II",
			info = "Régénère 300HP every 180 seconds",
		},
		merci = {
			name = "Acte De Miséricorde",
			info = "Le Cooldown de votre attaque principale est réduit de 2.5 secondes\nVous n'appliquez plus l'effet 'Verouillage des portes' aux humains proches",
		},
		symbiosis1 = {
			name = "Symbiose I",
			info = "Après une opération réussie, Vous êtes soignés de 10% de votre vie maximum",
		},
		symbiosis2 = {
			name = "Symbiose II",
			info = "Après une opération réussie, Vous êtes soignés de 15% de votre vie maximum\nLes SCP 049-2 a proximité sont soignés de 10% de leurs points de vie",
		},
		symbiosis3 = {
			name = "Symbiose III",
			info = "Après une opération réussie, Vous êtes soignés de 20% de votre vie maximum\nLes SCP 049-2 a proximité sont soignés de 20% de leurs points de vie",
		},
		hidden = {
			name = "Potentiel Caché",
			info = "Vous gagnez 1 jeton pour chaque opération réussie\nChaque token augmente les points de vie de vos zombies de 5%\n\t• Cette abilité affecte uniquement les zombies crées après l'obtention de chaque jeton",
		},
		trans = {
			name = "Transfusion",
			info = "Vos zombies ont une augmentation de leurs points de vie de 15%\nVos zombies récupèrent 20% des dégâts infligés en points de vie\n\t• Cette abilitée affecte seulement les nouveaux sombies crées",
		},
		rm = {
			name = "Mesures radicales",
			info = "Quand ce sera possible, 2 zombies seront crée a partir d'un même corps \n\t• If only 1 spectator is available, you create only 1 zombie\n\t• Both zombies are of the same type\n\t• Second zombie has HP reduced by 50%\n\t• Second zombie has damage reduced by 25%",
		},
		doc1 = {
			name = "Precision chirurgicale I",
			info = "Le temps d'opération est réduit de 5 secondes",
		},
		doc2 = {
			name = "Precision chirurgicale II",
			info = "Le temps d'opération est réduit de 5 secondes supplémentaires\n\t• Réduction totale: 10s",
		},
	}
}

wep.SCP0492 = {
	too_far = "Vous devenez plus faible!"
}

wep.SCP066 = {
	wait = "Prochaine attaque: %is",
	ready = "Attaque prête!",
	chargecd = "Temps de recharge du dash: %is",
	upgrades = {
		range1 = {
			name = "Résonance I",
			info = "Le rayon de la portée de l'attaque est augmenté de 75",
		},
		range2 = {
			name = "Résonance II",
			info = "Le rayon de la portée de l'attaque est augmenté de 75\n\t• Augmentation totale: 150",
		},
		range3 = {
			name = "Résonance III",
			info = "Le rayon de la portée de l'attaque est augmenté de 75\n\t• Augmentation totale: 225",
		},
		damage1 = {
			name = "Basse I",
			info = "Les Dégâts sont de 112.5%, en contrepartie le rayon est réduit a 90%",
		},
		damage2 = {
			name = "Basse II",
			info = "Les Dégâts sont de 135%, en contrepartie le rayon est réduit a 75%",
		},
		damage3 = {
			name = "Basse III",
			info = "Les Dégâts sont de 200%, en contrepartie le rayon est réduit a 50%",
		},
		def1 = {
			name = "Negation Wave I",
			info = "Quand vous jouez de la musique, les dégâts subis sont réduits de 10%",
		},
		def2 = {
			name = "Negation Wave II",
			info = "Quand vous jouez de la musique, les dégâts subis sont réduits de 25%",
		},
		charge = {
			name = "Dash",
			info = "Débloque la capacité d'effectuer un dash en avant en appuyant sur votre touche de rechargement\n\t• Cooldown de l'abilité: 20s",
		},
		sticky = {
			name = "Collant",
			info = "Après avoir dashé sur un humain, vous êtes collé a lui pendant les 10 prochaines secondes",
		}
	}
}

wep.SCP096 = {
	charges = "Nombre de charges de régénération: %i",
	regen = "Nombre de points de vie régénérés par charge: %i",
	upgrades = {
		sregen1 = {
			name = "Esprit calme I",
			info = "Vous récupérez une charge de régération toutes les 4 secondes eu lieu de 5"
		},
		sregen2 = {
			name = "Esprit calme II",
			info = "Une charge de régénération vous soigne de 6 points de vie au lieu de 5"
		},
		sregen3 = {
			name = "Esprit calme III",
			info = "Votre taux de régénération est 66% plus rapide"
		},
		kregen1 = {
			name = "Hannibal I",
			info = "Vous vous régénérez de 90 points de vie pour chaque personne tuée"
		},
		kregen2 = {
			name = "Hannibal II",
			info = "Vous vous régénérez de 90 points de vie (en plus du niveau I ) pour chaque personne tuée\n\t• Régénération totale: 180HP"
		},
		hunt1 = {
			name = "Timidité I",
			info = "Votre zone de chasse est augmentée jusqu'a 4250 unités"
		},
		hunt2 = {
			name = "Timidité II",
			info = "Votre zone de chasse est augmentée jusqu'a 5500 unités"
		},
		hp = {
			name = "Goliath",
			info = "Votre vie maximum est augmentée jusqu'a 4000 HP\n\t• Vos points de vie en eux mêmes ne sont pas augmentés , seulement leur maximum"
		},
		def = {
			name = "Persistant",
			info = "Vous avez une protection contre les balles de 30%"
		}
	}
}

wep.SCP106 = {
	swait = "Cooldown de l'abilité spéciale: %is",
	sready = "Abilité spéciale prête!",
	upgrades = {
		cd1 = {
			name = "Marche Du Néant I",
			info = "Le cooldown de l'abilité spéciale est réduit de  15 secondes"
		},
		cd2 = {
			name = "Marche Du Néant II",
			info = "Le cooldown de l'abilité spéciale est réduit de  15 secondes supplémentaires\n\t• Cooldown total: 30s"
		},
		cd3 = {
			name = "Marche Du Néant III",
			info = "Le cooldown de l'abilité spéciale est réduit de  15 secondes supplémentaires\n\t• Cooldown total: 45s"
		},
		tpdmg1 = {
			name = "Touché Pourrissant I",
			info = "Après t'être téléporté, augmente les dégâts de 15 pendant 10 secondes"
		},
		tpdmg2 = {
			name = "Touché Pourrissant II",
			info = "Après t'être téléporté, augmente les dégâts de 20 pendant 20 secondes"
		},
		tpdmg3 = {
			name = "Touché Pourrissant III",
			info = "Après t'être téléporté, augmente les dégâts de 25 pendant 30 secondes"
		},
		tank1 = {
			name = "Pocket Shield I",
			info = "Obtenez 20% de protection contre les balles, en revanche vous serez 10% plus lent"
		},
		tank2 = {
			name = "Pocket Shield II",
			info = "Obtenez 20% de protection supplémentaires contre les balles, en revanche vous serez 10% plus lent (en plus du niveau I)\n\t• Protection totale: 40%\n\t• Ralentissement total: 20%"
		},
	}
}

wep.SCP173 = {
	swait = "Special ability cooldown: %is",
	sready = "Special ability is ready!",
	upgrades = {
		specdist1 = {
			name = "Spectre I",
			info = "La distance de votre abilité spéciale est augmentée de 500 unités supplémentaires"
		},
		specdist2 = {
			name = "Spectre II",
			info = "La distance de votre abilité spéciale est augmentée de 700 unités supplémentaires\n\t• Augmentation totale: 1200"
		},
		specdist3 = {
			name = "Spectre III",
			info = "La distance de votre abilité spéciale est augmentée de 800 unités supplémentaires\n\t• Augmentation totale: 2000"
		},
		boost1 = {
			name = "Sanguinaire I",
			info = "Chaque fois que vous tuez un humain, vous récupéréz 150 Points de vie et le cooldown de votre abilité spéciale est réduit de 10%"
		},
		boost2 = {
			name = "Sanguinaire II",
			info = "Chaque fois que vous tuez un humain, vous récupéréz 300 Points de vie et le cooldown de votre abilité spéciale est réduit de 25%"
		},
		boost3 = {
			name = "Sanguinaire III",
			info = "Chaque fois que vous tuez un humain, vous récupéréz 500 Points de vie et le cooldown de votre abilité spéciale est réduit de 50%"
		},
		prot1 = {
			name = "Peau de Metal I",
			info = "Vous soigne de 1000 Points de vie et vous donne 10% de protection contre les balles"
		},
		prot2 = {
			name = "Concrete Skin II",
			info = "Vous soigne de 1000 Points de vie et vous donne 10% de protection supplémentaire contre les balles\n\t• Protection totale: 20%"
		},
		prot3 = {
			name = "Concrete Skin III",
			info = "Vous soigne de 1000 Points de vie et vous donne 20% de protection supplémentaire contre les balles\n\t• Protection totale: 40%"
		},
	},
	back = "Vous pouvez maintenir la touche R pour revenir a votre position initiale",
}

wep.SCP457 = {
	swait = "Cooldown de l'abilité spéciale: %is",
	sready = "Abilité spéciale prête!",
	placed = "Pièges activés: %i/%i",
	nohp = "Pas assez de points de vie!",
	upgrades = {
		fire1 = {
			name = "Torche Humaine I",
			info = "Le rayon de brûlure augmente de 25"
		},
		fire2 = {
			name = "Torche Humaine II",
			info = "Les dégâts de brûlure augmentent de 0.5"
		},
		fire3 = {
			name = "Torche Humaine III",
			info = "Le rayon de brûlure augmente de 50 (en plus du niveau I) et les dégâts de brûlure augmentent de 0.5\n\t• Augmentation totale du rayon: 75\n\t• Augmentation totale des dégâts: 1"
		},
		trap1 = {
			name = "Petite Suprise I",
			info = "Vos pièges restent activés jusqu'a 4 secondes et brûlent 1 seconde en plus"
		},
		trap2 = {
			name = "Petite Suprise II",
			info = "Vos pièges restent activés jusqu'a 5 secondes, brûlent 1 seconde en plus et leurs dégâts sont augmentés de 0.5\n\t• Augmentation du temps de brûlure total: 2s"
		},
		trap3 = {
			name = "Petite Suprise III",
			info = "Vos pièges brûlent 1 seconde de plus et leurs dégâts sont augmentés de 0.5\n\t• Augmentation du temps de brûlure total: 3s\n\t• Augmentation totale des dégâts: 1"
		},
		heal1 = {
			name = "Casse-croute Grillé I",
			info = "Vous récupérez 1 point de vie en plus pour chaque dégât de brûlure infligé"
		},
		heal2 = {
			name = "Casse-croute Grillé II",
			info = "Vous récupérez 1 point de vie en plus pour chaque dégât de brûlure infligé\n\t• Augmentation totale de la régénération: 2"
		},
		speed = {
			name = "Flammes rapides",
			info = "Votre vitesse augmente de 10%"
		}
	}
}

wep.SCP682 = {
	swait = "Cooldown de l'abilité spéciale: %is",
	sready = "Abilité spéciale prête!",
	s_on = "Vous êtes immunisé contre tout type de dégat! %is",
	upgrades = {
		time1 = {
			name = "Indestructible I",
			info = "La durée de votre abilité spéciale augmente de  2.5 secondes\n\t• Durée totale: 12.5s"
		},
		time2 = {
			name = "Indestructible II",
			info = "La durée de votre abilité spéciale augmente de  2.5 secondes supplémentaires\n\t• Durée totale: 15 secondes"
		},
		time3 = {
			name = "Indestructible III",
			info = "La durée de votre abilité spéciale augmente de  2.5 secondes supplémentaires\n\t• Durée totale: 17.5 secondes"
		},
		prot1 = {
			name = "Adaptation I",
			info = "Les dégâts subis par balle sont réduits de 10%"
		},
		prot2 = {
			name = "Adaptation II",
			info = "Les dégâts subis par balle sont réduits de 15% supplémentaires\n\t• Réduction totale: 25%"
		},
		prot3 = {
			name = "Adaptation III",
			info = "Les dégâts subis par balle sont réduits de 15% supplémentaires\n\t• Réduction totale: 40%"
		},
		speed1 = {
			name = "Ruée Enragée I",
			info = "Après l'utilisation de votre abilité, vous gagnez un boost de vitesse de mouvement de 10% jusqu'a ce que vous prenez des dégâts"
		},
		speed2 = {
			name = "Ruée Enragée II",
			info = "Après l'utilisation de votre abilité, vous gagnez un boost de vitesse de mouvement de 20% jusqu'a ce que vous prenez des dégâts"
		},
		ult = {
			name = "Regeneration",
			info = "5 secondes après avoir reçu des dégâts, vous régénère de 5% de votre vie"
		},
	}
}

wep.SCP8602 = {
	upgrades = {
		charge11 = {
			name = "Brutalité I",
			info = "Les dégâts des attaques puissantes sont augmentés de 5"
		},
		charge12 = {
			name = "Brutalité II",
			info = "Les dégâts des attaques puissantes sont augmentés de 10\n\t• Augmentation totale des dégâts: 15"
		},
		charge13 = {
			name = "Brutalité III",
			info = "Les dégâts des attaques puissantes sont augmentés de 10 (en plus du niveau II)\n\t• Augmentation totale des dégâts: 25"
		},
		charge21 = {
			name = "Charge I",
			info = "la portée de votre attaque puissante est augmenté de 15"
		},
		charge22 = {
			name = "Charge II",
			info = "la portée de votre attaque puissante est augmenté de 15 (en plus du niveau I)\n\t• Augmentation total de la portée: 30"
		},
		charge31 = {
			name = "Douleure Partagée",
			info = "Quand vous effecturez une attaque puissante, tout ceux qui seront proche du point d'impact receveront 20% des dégâts"
		},
	}
}

wep.SCP939 = {
	upgrades = {
		heal1 = {
			name = "Soif De Sang I",
			info = "Vos attaques vous régénèrent au minimum 22.5 HP (jusqu'a 30 maximum)"
		},
		heal2 = {
			name = "Soif De Sang II",
			info = "Vos attaques vous régénèrent au minimum 37.5 HP (jusqu'a 50 maximum)"
		},
		heal3 = {
			name = "Soif De Sang III",
			info = "Vos attaques vous régénèrent au minimum 52.5 HP (jusqu'a 70 maximum)"
		},
		amn1 = {
			name = "Souffle Mortel I",
			info = "Le rayon de votre poison est augmenté de 100"
		},
		amn2 = {
			name = "Lethal Breath II",
			info = "Votre poison fait maintenant: 1.5 dmg/s"
		},
		amn3 = {
			name = "Lethal Breath III",
			info = "Le rayon de votre poison est augmenté de 125 les dégâts de votre poison est augmenté à : 3 dmg/s"
		},
	}
}

wep.SCP966 = {
	upgrades = {
		lockon1 = {
			name = "Frénésie I",
			info = "Le temps d'attaque est réduit à 2.5s"
		},
		lockon2 = {
			name = "Frénésie II",
			info = "Le temps d'attaque est réduit à 2s"
		},
		dist1 = {
			name = "Appel Du Chasseur I",
			info = "Le rayon d'attaque est augmenté de 15"
		},
		dist2 = {
			name = "Appel Du Chasseur II",
			info = "La portée d'attaque est augmenté de 15 (en plus du niveau I)\n\t• Augmentation totale de la portée: 30"
		},
		dist3 = {
			name = "Appel Du Chasseur III",
			info = "La portée d'attaque est augmenté de 15 (en plus du niveau II)\n\t• Augmentation totale de la portée: 45"
		},
		dmg1 = {
			name = "Griffes Acérées I",
			info = "Les dégâts de chaque attaque sont augmentés de 5"
		},
		dmg2 = {
			name = "Griffes Acérées II",
			info = "Les dégâts de chaque attaque sont augmentés de 5\n\t• Augmentation totale des dégâts: 10"
		},
		bleed1 = {
			name = "Blessures Profondes I",
			info = "Vos attaques ont 25% de chances d'infliger des saignements de niveau supérieur"
		},
		bleed2 = {
			name = "Blessures Profondes II",
			info = "Vos attaques ont 50% de chances d'infliger des saignements de niveau supérieur"
		},
	}
}

wep.SCP3199 = {
	special = "Attaque spéciale prête! Appuyez sur Clique Droit",
	upgrades = {
		regen1 = {
			name = "Goût Du Sang I",
			info = "Régénère 2 Points De Vie par seconde pendant la frénésie"
		},
		regen2 = {
			name = "Goût Du Sang II",
			info = "La régénération est augmentée de 10% par jeton."
		},
		frenzy1 = {
			name = "Jeu Du Chasseur I",
			info = "Votre maximum de jeton est augmenté de 1\nLa durée de la frénésie est augmenté de 20%"
		},
		frenzy2 = {
			name = "Jeu Du Chasseur II",
			info = "Votre maximum de jeton est augmenté de 1\nLa durée de la frénésie est augmenté de 30%\nVotre attaque spéciale est désactivée\n\t• Augmentation totale des jetons de frénésie: 2\n\t• Augmentation totale de la durée de la frénésie: 50%"
		},
		ch = {
			name = "Furie Aveugle",
			info = "Votre vitesse est augmenté de 25%\nVous ne pouvez plus ressentir de battement cardiaque des humains proches"
		},
		egg1 = {
			name = "Encore une",
			info = "Vous creez un nouvel oeuf inactif a l'achat de cette amélioration\n\t• L'oeuf ne sera pas crée si il n'y a pas de place sur la map"
		},
		egg2 = {
			name = "Héritage",
			info = "Un des oeufs inactifs sera activé a l'achat de cette amélioration\n\t• Cela ne fera rien si il n'y a pas d'oeuf inactif sur la map"
		},
		egg3 = {
			name = "Oeuf De Paques",
			info = "Vôtre temps de respawn est réduit à 20 seconds"
		},
	}
}

wep.SCP714 = {
	name = "SCP 714"
}

wep.HOLSTER = {
	name = "Holster",
}

wep.ID = {
	name = "ID",
	pname = "Nom:",
	server = "Serveur:",
}

wep.CAMERA = {
	name = "Système De Surveillance",
	showname = "Cameras",
	info = "Les caméras vous permettent de voir ce qui se passe dans la fondation.\nElles vous permettent également de scanner les SCP et de transmettre leurs informations à votre canal radio actuel",
}

wep.RADIO = {
	name = "Radio",
}

wep.NVG = {
	name = "NVG",
	info = "Lunettes De Vision Nocturnes - Appareil qui rend les zones sombres plus lumineuses et les zones lumineuses encore plus lumineuses.\nDes fois vous pouvez voir des choses anormales a travers elles."
}

wep.NVGPLUS = {
	name = "Enhanced NVG",
	showname = "NVG+",
	info = "Version améliorée du NVG, Vous pouvez l'utiliser et avoir un autre objet en main.\nMalheureusement la batterie ne dure que 10 secondes"
}

wep.ACCESS_CHIP = {
	name = "Puce d'accès",
	cname = "Puce d'accès - %s",
	showname = "Puce",
	pickupname = "Puce",
	clearance = "Niveau d'accréditation: %i",
	hasaccess = "Donne l'accès à:",
	NAMES = {
		general = "General",
		jan1 = "Concierge",
		jan = "Concierge",
		jan2 = "Concierge Confirmé",
		acc = "Comptable",
		log = "Logisticien",
		sci1 = "Chercheur de niveau 1",
		sci2 = "Chercheur de niveau 2",
		sci3 = "Chercheur de niveau 3",
		spec = "Spécialiste Du Confinement",
		guard = "Sécurité",
		chief = "Chef De Sécurité",
		mtf = "MTF",
		com = "Commandant MTF",
		hacked3 = "Piratée 3",
		hacked4 = "Piratée 4",
		hacked5 = "Piratée 5",
		director = "Directeur Du Site",
		o5 = "O5"
	},
	ACCESS = {
		GENERAL = "General",
		SAFE = "Safe",
		EUCLID = "Euclide",
		KETER = "Keter",
		OFFICE = "Office",
		MEDBAY = "MedBay",
		GENERAL = "General",
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
	none = "Aucune",
	chip = "Puce installée: %s",
	clearance = "Niveau d'accréditation: %i",
	SCREEN = {
		loading = "Chargelent",
		name = "Omnitool v4.78",
		installing = "Installation d'une nouvelle puce...",
		ejecting = "Éjection d'une puce...",
		ejectwarn = "Êtes vous sur de vouloir éjecter cette puce?",
		ejectconfirm = "Re-appuyez pour confirmer...",
		chip = "Puce installée:",
	},
}

wep.KEYCARD = {
	author = "danx91",
	instructions = "Accès:",
	ACC = {
		"SAFE",
		"EUCLIDE",
		"KETER",
		"Checkpoints",
		"OMEGA Warhead",
		"Accès Général",
		"Gate A",
		"Gate B",
		"Armurerie",
		"Femur Breaker",
		"Electrical Center",
	},
	STATUS = {
		"Accrédité",
		"Non accrédité",
	},
	NAMES = {
		"Carte de niveau 1",
		"Carte de niveau 2",
		"Carte de niveau 3",
		"Carte de Chercheur",
		"Carte de Garde MTF",
		"Carte de Commandant MTF",
		"Carte OMNI",
		"Carte Sécurité de Checkpoint",
		"Carte piratée de l'Insurrection Du Chaos",
	},
}

wep.MEDKIT = {
	name = "Kit De Soin (Utilisations restantes: %d)",
	showname = "Kit De Soin",
	pickupname = "Kit De Soin",
}

wep.MEDKITPLUS = {
	name = "Kit De Soin Amélioré (Utilisations restantes: %d)",
	showname = "Kit De Soin+",
	pickupname = "Kit De Soin+",
}

wep.TASER = {
	name = "Taser"
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

wep.weapon_stunstick = "Stunstick"

lang.WEAPONS = wep

registerLanguage( lang, "french", "fr" )
setLanguageFlag( "french", LANGUAGE.EQ_LONG_TEXT )
