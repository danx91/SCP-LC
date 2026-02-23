local lang = LANGUAGE

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
