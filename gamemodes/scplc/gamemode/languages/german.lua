--[[-------------------------------------------------------------------------
Language: German
Date: 14.07.2021
Translated by: Justinnn
---------------------------------------------------------------------------]]

local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Du kannst in der nächsten Runde SCP werden",
	scpwait = "Du musst %i Runden warten bevor du wieder SCP werden kannst",
	abouttostart = "Das Spiel startet in %i Sekunden!",
	kill = "Du hast %d Punkte für das Töten von %s: %s erhalten!",
	assist = "Du hast %d Punkte für das assistieren bei der Tötung von denn Spieler: %s erhalten!",
	rdm = "Du hast %d Punkte für das Töten von %s: %s verloren!",
	acc_denied = "Zugriff verweigert",
	acc_granted = "Zugriff akzeptiert",
	acc_omnitool = "Ein Omnitool wird benötigt, um diese Tür zu öffnen",
	device_noomni = "Ein Omnitool wird benötigt, um dieses Gerät zu nutzen",
	elevator_noomni = "Ein Omnitool wird benötigt, um diesen Fahrstuhl zu nutzen",
	acc_wrong = "Für diese Aktion ist eine höhere Freigabestufe erforderlich",
	rxpspec = "Du hast %i XP für das Spielen auf diesem Server erhalten!",
	rxpplay = "Du hast %i XP erhalten, weil du in der Runde noch lebst!",
	rxpplus = "Du hast %i XP erhalten, weil du mehr als die Hälfte der Runde überlebt hast!",
	roundxp = "Du hast %i XP für Deine Punkte erhalten",
	gateexplode = " Explosion von Gate A in  %i Sekunden",
	explodeterminated = "Die Zerstörung von Gate A wurde beendet",
	r106used = "SCP 106 Recontain-Prozedur kann nur einmal pro Runde ausgelöst werden",
	r106eloiid = "Du musst den ELO-IID-Elektromagneten aus schalten, um den SCP 106-Recontain-Vorgang zu starten",
	r106sound = "Du musst Sound Transmission aktivieren, um die Recontain-Prozedur von SCP 106 zu starten",
	r106human = "Ein lebender Mensch muss  In der Zelle von SCP 106 sein, um die Recontain-Prozedur von SCP 106 zu starten",
	r106already = "SCP 106 wurde recontaint",
	r106success = "Du hast %i Punkte für die Wiedereindämmung von SCP 106 erhalten!",
	vestpickup = "Du hast die Weste aufgehoben",
	vestdrop = "Du hast deine Weste fallen lassen",
	hasvest = "Du hast bereits Weste! Verwende Deinen Inventar, um Deine aktuelle Weste fallen zu lassen",
	escortpoints = "Du hast %i Punkte erhalten, weil du deine Verbündeten eskortiert hast",
	femur_act = "Femur Breaker aktiviertt...",
	levelup = "Du bist aufgestiegen! Dein aktuelles Level ist: %i",
	healplayer = "Du hast %i Punkte für die Heilung anderer Spieler erhalten",
	detectscp = "Du hast %i Punkte für das Aufspüren von SCPs erhalten",
	winxp = "Du hast %i XP erhalten, weil dein erstes Team das Spiel gewonnen hat",
	winalivexp = "Du hast %i XP erhalten, weil dein Team das Spiel gewonnen hat",
	upgradepoints = "Du hast neue Upgrade-Punkte erhalten! Drücke '%s', um das SCP-Upgrade-Menü zu öffnen",
	prestigeup = "Spieler %s hat ein höheres Prestige! Sein aktuelles Prestige-Level ist: %i",
	omega_detonation = "OMEGA Warhead Detonation in %i Sekunden. Gehe an die Oberfläche oder begebe dich sofort zum Sprengbunker in der LCZ!",
	alpha_detonation = "ALPHA Warhead Detonation in %i Sekunden. Betrete  die Facility oder begebe Dich sofort zur Evakuierung!",
	alpha_card = "Du hast ein Nuklearcode eingesetzt",
	destory_scp = "Du hast %i Punkte für die Zerstörung von einen SCP-Objekt erhalten!",
	afk = "Du bist AFK. Du wirst nicht spawnen und im Laufe der Zeit keine XP erhalten!",
	afk_end = "Du bist nicht mehr AFK!",
}

lang.NFailed = "Zugriff auf NRegistry mit den Schlüssel %s fehlgeschlagen"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "Du bist entkommen!",
	escapeinfo = "Gut gemacht! Du bist in %s entkommen",
	escapexp = "Du hast %i XP erhalten",
	escort = "Du wurdest begleitet!",
	roundend = "Runde beendet!",
	nowinner = "Es gibt keinen Sieger in dieser Runde!",
	roundnep = "Es sind nicht genug Spieler da!",
	roundwin = "Rundensieger: %s",
	roundwinmulti = "Rundensieger: [RAW]",
	shelter_escape = "Du hast die Explosion im Sprengbunker überlebt",
	alpha_escape = "Du bist entkommen, bevor der Alpha Warhead explodiert ist",

	mvp = "MVP: %s mit Punktzahl: %i",
	stat_kill = "Getötete Spieler: %i",
	stat_rdm = "RDM Tötungen: %i",
	stat_rdmdmg = "RDM-Schaden: %i",
	stat_dmg = "Verursachter Schaden: %i",
	stat_bleed = "Blutungsschaden: %i",
	stat_106recontain = "SCP 106 wurde recontaint",
	stat_escapes = "Entkommende Spieler: %i",
	stat_escorts = "Begleitete Spieler: %i",
	stat_023 = "Plötzliche Todesfälle durch SCP 023: %i",
	stat_049 = "Infizierte Personen: %i",
	stat_066 = "Played masterpieces: %i",
	stat_096 = "Spieler von SCP 096 getötet: %i",
	stat_106 = "Spieler, die zur Pocket Dimension teleportiert wurden: %i",
	stat_173 = "Genicke gebrochen: %i",
	stat_457 = "Verbrannte Spieler: %i",
	stat_682 = "Spieler von einem Reptil getötet: %i",
	stat_8602 = "An die Wand genagelte Spieler: %i",
	stat_939 = "Beute von SCP 939: %i",
	stat_966 = "Heimtückische Schnitte: %i",
	stat_3199 = "Tode durch SCP 3199: %i",
	stat_24273 = "Von SCP 2427-3 gesteuerte Personen: %i",
	stat_omega_warhead = "Omega-Warhead wurde gezündet",
	stat_alpha_warhead = "Alpha-Warhead wurde gezündet",
}

lang.NCFailed = "Zugriff auf NRegistry mit den Schlüssel %s fehlgeschlagen"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "Aufheben"
hud.class = "Klasse"
hud.team = "Team"
hud.prestige_points = "Prestige Points"
hud.hp = "HP"
hud.stamina = "Ausdauer"
hud.sanity = "Verstand"
hud.xp = "XP"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "LMB - Auswählen"
lang.eq_rmb = "RMB - Weg werfen"
lang.eq_hold = "Halte LMB - Gegenstand verschieben"
lang.eq_vest = "Weste"
lang.eq_key = "Drücke '%s' um dein Inventar zu öffnen"

lang.info = "Informationen"
lang.author = "Autor"
lang.mobility = "Mobilität"
lang.weight = "Gewicht"
lang.protection = "Schutz"

lang.weight_unit = "KG"
lang.eq_buttons = {
	escort = "Eskortieren",
	gatea = "Gate A  zerstören"
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "Dauerhaft"
effects.bleeding = "Blutung"
effects.doorlock = "Türschloss"
effects.amnc227 = "AMN-C227"
effects.insane = "Wahnsinnig"
effects.gas_choke = "Husten"
effects.radiation = "Strahlung"
effects.deep_wounds = "Tiefe Wunden"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Klassen"
lang.preview = "Vorschau"
lang.random = "Zufällig"
lang.price = "Preis"
lang.buy = "Kaufen"
lang.refound = "Rückerstattung"
lang.none = "Keiner"
lang.refounded = "Alle entfernten Klassen wurden zurückerstattet. Du hast %d Prestigepunkte erhalten."

lang.details = {
	details = "Einzelheiten",
	name = "Name",
	team = "Team",
	price = "Prestigepunkte Preis",
	walk_speed = "Gehgeschwindigkeit",
	run_speed = "Laufgeschwindigkeit",
	chip = "Zugangschip",
	persona = "Gefälschte ID",
	weapons = "Waffen",
	class = "Klasse",
	hp = "Leben",
	speed = "Geschwindigkeit",
	health = "Leben",
	sanity = "Verstand"
}

lang.headers = {
	support = "Unterstüzung",
	classes = "Klassen",
	scp = "SCPs"
}

lang.view_cat = {
	classd = "D-Klassen",
	sci = "Wissenschaftler",
	mtf = "Sicherheit",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alpha-1",
	ci = "Chaos Insurgency",
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Nicht verbunden"

lang.scoreboard = {
	name = "Scoreboard",
	playername = "Name",
	ping = "Ping",
	prestige = "Prestige",
	level = "Level",
	score = "Punkte",
	ranks = "Ränge",
}

lang.ranks = {
	author = "Autor",
	vip = "VIP-Spieler",
	tester = "Tester",
	contributor = "Mitwirkender",
	translator = "Übersetzer",
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
	tree = "%s VERBESSERUNGSMENÜ",
	points = "Punkte",
	cost = "Kosten",
	owned = "Im Besitz",
	requiresall = "Benötigt",
	requiresany = "Benötigt alle",
	blocked = "Blockiert von"
}

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "Name",
	class = "Klasse",
	team = "Team",
	status = "Status",
	objectives = "Ziele",
	details = "Einzelheiten",
	registry_failed = "info_screen_registry fehlgeschlagen"
}

lang.info_screen_registry = {
	escape_time = "Du bist in %s Minuten entkommen",
	escape_xp = "Du hast %s XP erhalten",
	escape1 = "Du bist aus der Facility entkommen",
	escape2 = "Du bist während des Warhead-Countdowns entkommen",
	escape3 = "Du hast im Sprengbunker überlebt",
	escorted = "Du wurdest begleitet",
	killed_by = "Du wurdest getötet von: %s",
	suicide = "Du hast Selbstmord begangen",
	unknown = "Die Todesursache ist unbekannt",
	hazard = "Du wurdest durch Gefahr getötet",
	alpha_mia = "Letzter bekannter Standort: Oberfläche",
	omega_mia = "Letzter bekannter Standort: Facility",
}

lang.info_screen_type = {
	alive = "Am Leben",
	escaped = "Entkommen",
	dead = "Verstorben",
	mia = "In Aktion verpasst",
	unknown = "Unbekannt",
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
lang.nothing = "Nichts"
lang.exit = "Ausgang"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "Inhalt des Spielmodus",
	msg = [[Es sieht so aus, als ob Du keine Addons hast. Dies kann Fehler wie fehlende Inhalte (Texturen/Modelle/Sounds) verursachen und dein Spielerlebnis beeinträchtigen.
Du hast keine %i Addons von %i. Möchtest Du es jetzt herunterladen? (Du, kannst es entweder über das Spiel herunterladen oder manuell auf der Workshop-Seite)]],
	no = "Nein",
	download = "Jetzt downloaden",
	workshop = "Workshop-Seite anzeigen",
	downloading = "Wird heruntergeladen",
	mounting = "Mounting",
	idle = "Warten auf Download...",
	processing = "Addon wird verarbeitet: %s\nStatus: %s",
	cancel = "Abrechen"
}

misc.omega_warhead = {
	idle = "OMEGA Warhead ist im Leerlauf\n\nWarten auf Eingabe...",
	waiting = "OMEGA Warhead ist im Leerlauf\n\nEingabe akzeptiert!\nWarten auf zweite Eingabe...",
	failed = "OMEGA Warhead ist gesperrt\n\nKeine zweite Eingabe erkannt!\nWarte %is",
	no_remote = "OMEGA-Gefechtskopf fehlgeschlagen\n\nVerbindung zum Gefechtskopf konnte nicht hergestellt werden!\t",
	active = "OMEGA-Gefechtskopf ist aktiviert\n\nFahre sofort mit der Evakuierung fort!\nDetonation in %.2fs",
}

misc.alpha_warhead = {
	idle = "ALPHA Warhead ist im Leerlauf\n\nWarten auf Nuklearcodes...",
	ready = "ALPHA Warhead ist im Leerlauf\n\nCodes wurden akzeptiert!\nWarten auf Aktivierung...",
	no_remote = "ALPHA-Gefechtskopf fehlgeschlagen\n\nVerbindung zum Gefechtskopf konnte nicht hergestellt werden!\t",
	active = "ALPHA-Gefechtskopf ist aktiviert\n\nFahre sofort mit der Evakuierung fort!\nDetonation in %.2fs",
}

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
vest.ntf_com = "MTF NTF Commander Weste"
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
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "Zuschauer"
teams.CLASSD = "D-Klasse"
teams.SCI = "Wissenschaftler"
teams.MTF = "MTF"
teams.CI = "CI"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "Unbekannt"

classes.SCP023 = "SCP 023"
classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
classes.SCP066 = "SCP 066"
classes.SCP096 = "SCP 096"
classes.SCP106 = "SCP 106"
classes.SCP173 = "SCP 173"
classes.SCP457 = "SCP 457"
classes.SCP076 = "SCP 076"
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
classes.sci = "Wissenschaftler"
classes.seniorsci = "Senior Wissenschaftler"
classes.headsci = "Leitender Wissenschaftler"
classes.technician = "Techniker"

classes.guard = "Security Guard"
classes.chief = "Security Chief"
classes.lightguard = "Light Security Guard"
classes.heavyguard = "Heavy Security Guard"
classes.specguard = "Security Guard Specialist"
classes.guardmedic = "Security Guard Medic"
classes.tech = "Security Guard Technician"
classes.cispy = "CI Spion"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Schrotflinte"
classes.ntf_3 = "MTF NTF - Gewehr"
classes.ntfcom = "MTF NTF Commander"
classes.jugernaut = "Juggernaut"
classes.ntfsniper = "MTF NTF Scharfschütze"
classes.ntfmedic = "MTF NTF Medic"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Schütze"
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
local generic_classd = [[- Entkomme aus der Facility
- Vermeide Personal- und SCPs
- Kooperiere mit anderen]]

local generic_sci = [[- Entkomme aus der Facility
- Vermeide D-Klassen und SCPs
- Kooperiere Mit Wachen und MTFs]]

local generic_guard = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Höre auf Deinen Vorgesetzten]]

local generic_ntf = [[- Betrete die Facility
- Helfe den restlichen Mitarbeitern in der Facility
- Lass keine  D-Klassen und SCPs entkommen]]

local generic_jugernaut = [[- Du musst die Foundation um jeden Preis schützen
- Stoppe SCPs und Klasse D
- Du bist berechtigt denn Befehl für, ]].."[REDACTED] zu geben"

local generic_scp = [[- Entkomme aus der Facility
- Töte jeden, den du triffst
-  Kooperiere mit anderen SCPs]]

local generic_scp_friendly = [[- Entkomme aus der Facility
- Du darfst mit Menschen kooperieren
- Kooperiere mit anderen SCPs]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	ciagent = [[-  Eskortiere D-Klassen
- Vermeide Personal- und SCPs
- Kooperiere mit anderen]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	technician = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Erteile anderen Wachen Befehle]],

	guardmedic = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Unterstütze andere Wachen mit deinem Medkit]],

	tech = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Unterstütze andere Wachen mit deinem Turm]],

	cispy = [[- Gib vor, eine Wache zu sein
- Helfe denn verbleibenden D-Klassen
- Du darfst alle Wachen töten]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- Helfe den restlichen Mitarbeitern in der Facility
- Unterstütze andere NTFs mit Deinen Medkit
- Lass keine  D-Klassen und SCPs entkommen]],

	ntfcom = [[- Helfe den restlichen Mitarbeitern in der Facility
- Lass keine  D-Klassen und SCPs entkommen
- Erteile anderen NTFs Befehle]],

	ntfsniper = [[- Helfe den restlichen Mitarbeitern in der Facility
- Lass keine  D-Klassen und SCPs entkommen
- Schütze dein Team von hinten]],

	alpha1 = [[- Du musst die Foundation um jeden Preis schützen
- Stoppe SCPs und Klasse D
- Du bist berechtigt denn Befehl für, ]].."[REDACTED] zu geben",

	alpha1sniper = [[- Du musst die Foundation um jeden Preis schützen
- Stoppe SCPs und Klasse D
- Du bist berechtigt denn Befehl für, ]].."[REDACTED] zu geben",

	ci = [[- Helfen dem D-Klassen und eskortiere sie
- Töte alle Mitarbeiter der Facility
- Höre auf Deinen Vorgesetzten]],

	cicom = [[- Helfen dem D-Klassen und eskortiere sie
- Töte alle Mitarbeiter der Facility
- Erteile anderen CI Befehle]],

	SCP023 = generic_scp,

	SCP049 = [[- Entkomme aus der Facility
- Kooperiere mit anderen SCPs
- Infiziere alle leichen mit R]],

	SCP0492 = [[- Entkomme aus der Facility
- Höre auf 049 und bleibe in seiner nähe
- Kooperiere mit anderen SCPs]],

	SCP066 = generic_scp_friendly,

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

--[[-------------------------------------------------------------------------
DON'T EDIT - UNUSED
---------------------------------------------------------------------------]]
/*lang.CLASS_INFO = {
	classd = [[Du bist D-Klasse Personal
Deine Aufgabe ist es aus der Facility zu entkommen
Kooperiere mit anderen und suche nach Chips
Vermeide Personal- und SCPs]],

	veterand = [[Du bist D-Klasse Veteran
Deine Aufgabe ist es aus der Facility zu entkommen
Kooperiere mit anderen
Vermeide Personal- und SCPs]],

	kleptod = [[Du bist D-Klasse Kleptomaniac
Deine Aufgabe ist es aus der Facility zu entkommen
Du hast etwas vom Personal gestohlen
Vermeide Personal- und SCPs]],

	ciagent = [[Du bist CI Agent
Dein Ziel ist es D-Klassen zu schützen
Eskortiere D-Klassen zum Ausgang 
Vermeide Personal- und SCPs]],

	sciassistant = [[Du bist Scientist Assistant
Deine Aufgabe ist es aus der Facility zu entkommen
Kooperiere mit anderen Wissenschaftlern und Sicherheitspersonal
Vermeide Personal- und SCPs]],

	sci = [[Du bist Wissenschaftler
Deine Aufgabe ist es aus der Facility zu entkommen
Kooperiere mit anderen Wissenschaftlern und Sicherheitspersonal
Vermeide Personal- und SCPs]],

	seniorsci = [[Du bist Senior Scientist
Deine Aufgabe ist es aus der Facility zu entkommen
Kooperiere mit anderen Wissenschaftlern und Sicherheitspersonal
Vermeide Personal- und SCPs]],

	headsci = [[Du bist Head Scientist
Deine Aufgabe ist es aus der Facility zu entkommen
Kooperiere mit anderen Wissenschaftlern und Sicherheitspersonal
Vermeide Personal- und SCPs]],

	guard = [[Du bist Security Guard
Dein Ziel ist es, alle Wissenschaftler zu retten
Terminiere alle D-Klassen und SCPs]],

	lightguard = [[Du bist Security Guard
Dein Ziel ist es, alle Wissenschaftler zu retten
Terminiere alle D-Klassen und SCPs]],

	heavyguard = [[Du bist Security Guard
Dein Ziel ist es, alle Wissenschaftler zu retten
Terminiere alle D-Klassen und SCPs]],

	specguard = [[Du bist Security Guard Specialist
Dein Ziel ist es, alle Wissenschaftler zu retten
Terminiere alle D-Klassen und SCPs]],

	chief = [[Du bist Security Chief
Dein Ziel ist es, alle Wissenschaftler zu retten
Terminiere alle D-Klassen und SCPs]],

	guardmedic = [[Du bist Security Guard Medic
Dein Ziel ist es, alle Wissenschaftler zu retten
Unterstütze andere Wachen mit deinem Medkit
Terminiere alle D-Klassen und SCPs]],

	tech = [[Du bist Security Technician
Dein Ziel ist es, alle Wissenschaftler zu retten
Unterstütze andere Wachen mit deinem Turm
Terminiere alle D-Klassen und SCPs]],

	cispy = [[Du bist CI Spion
Helfe denn verbleibenden D-Klassen
Du darfst alle Wachen töten]],

	ntf_1 = [[Du bist MTF NTF
Helfe den restlichen Mitarbeitern in der Facility
Lass keine  D-Klassen und SCPs entkommen]],

	ntf_2 = [[Du bist MTF NTF
Helfe den restlichen Mitarbeitern in der Facility
Lass keine  D-Klassen und SCPs entkommen]],

	ntf_3 = [[Du bist MTF NTF
Helfe den restlichen Mitarbeitern in der Facility
Lass keine  D-Klassen und SCPs entkommen]],

	ntfmedic = [[Du bist MTF NTF Medic
Helfe den restlichen Mitarbeitern in der Facility
Unterstütze andere NTFs mit Deinen Medkit]],

	ntfcom = [[Du bist MTF NTF Commander
Helfe den restlichen Mitarbeitern in der Facility
Lass keine  D-Klassen und SCPs entkommen
Erteile anderen NTFs Befehle]],

	ntfsniper = [[Du bist MTF NTF Scharfschütze
Schütze dein Team von hinten
Lass keine  D-Klassen und SCPs entkommen]],

	alpha1 = [[Du bist MTF Alpha 1
Du arbeitest direkt für das O5 Council
Du musst die Foundation um jeden Preis schützen
Ihre Mission ist es, [REDACTED] ]],

	alpha1sniper = [[Du bist MTF Alpha 1 Scharfschütze
You work directly for O5 Council
Protect foundation at all cost
Your mission is to [REDACTED] ]],

	ci = [[Du bist Chaos Insurgency Soldier
Help Class D Personnel
Kill MTFs and other facility staff]],

	cicom = [[Du bist Chaos Insurgency Commander
Help Class D Personnel
Kill MTFs and other facility staff]],
	
	SCP023 = [[Du bist SCP 023
Deine Aufgabe ist es aus der Facility zu entkommen
You will kill one of the people who saw you
Click RMB to place spectre]],

	SCP049 = [[Du bist SCP 049
Deine Aufgabe ist es aus der Facility zu entkommen
Your touch is deadly to humans
You can perform surgery to "cure" people]],

	SCP0492 = [[Du bist SCP 049-2
Deine Aufgabe ist es aus der Facility zu entkommen
Listen to SCP 049's orders and protect him]],

	SCP066 = [[Du bist SCP 066
Deine Aufgabe ist es aus der Facility zu entkommen
You can play very loud music]],

	SCP096 = [[Du bist SCP 096
Deine Aufgabe ist es aus der Facility zu entkommen
You become enraged when someone looks at you
You can regenerate HP by pressing R]],

	SCP106 = [[Du bist SCP 106
Deine Aufgabe ist es aus der Facility zu entkommen
You can go through doors and teleport to the selected location

LMB: Teleport humans to pocket dimension
RMB: Mark teleport destination
R: Teleport]],

	SCP173 = [[Du bist SCP 173
Deine Aufgabe ist es aus der Facility zu entkommen
You can't move while someone is watching you
Your special ability teleports you to the nearby human]],

	SCP457 = [[Du bist SCP 457
Deine Aufgabe ist es aus der Facility zu entkommen
You are burning and you will ignite everything
near you
You can place up to 5 fire traps]],

	SCP682 = [[Du bist SCP 682
Deine Aufgabe ist es aus der Facility zu entkommen
You have a lot of health
Your special ability makes you immune to any damage]],

	SCP8602 = [[Du bist SCP 860-2
Deine Aufgabe ist es aus der Facility zu entkommen
If you attack someone near wall, you will
nail him to wall and deal huge damage]],

	SCP939 = [[Du bist SCP 939
Deine Aufgabe ist es aus der Facility zu entkommen
You can talk with humans]],

	SCP966 = [[Du bist SCP 966
Deine Aufgabe ist es aus der Facility zu entkommen
You are invisible]],

	SCP3199 = [[Du bist 3199
Deine Aufgabe ist es aus der Facility zu entkommen
You are agile and deadly hunter
You can sense heartbeat of nearby humans]],
}*/
--[[-------------------------------------------------------------------------
END OF UNUSED PART
---------------------------------------------------------------------------]]

lang.CLASS_DESCRIPTION = {
	classd = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Niemand
Eskortiert von: CI
Überblick:
Elementare Klasse. Kooperiere mit anderen, um SCPs und Personal der Einrichtung zusammen zu kämpfen. Du kannst von CI Mitglieder eskortiert werden.
]],

	veterand = [[Schwierigkeit: Leicht
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Ja
Kann eskortieren: Niemand
Eskortiert von: CI
Überblick:
Mehr fortschrittliche Klasse. Du hast elementaren Zugriff in der Einrichtung. Kooperiere mit anderen, um SCPs und Personal der Einrichtung zusammen zu kämpfen. Du kannst von CI Mitglieder eskortiert werden.
]],

	kleptod = [[Schwierigkeit: Hoch
Zähigkeit: Niedrig
Beweglichkeit: Sehr Groß
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Niemand
Eskortiert von: CI
Überblick:
Klasse mit hohem Nutzwert. Beginnt mit ein zufälligen Gegenstand. Kooperiere mit anderen, um SCPs und Personal der Einrichtung zusammen zu kämpfen. Du kannst von CI Mitglieder eskortiert werden.
]],

	ciagent = [[Schwierigkeit: Mittel
Zähigkeit: Sehr Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: D-Class
Eskortiert von: Niemand
Überblick:
Bewaffnet mit ein Taser CI Einheit. Stell D-Klasse Hilfe zur Verfügung und kooperiere mit denen. Du kannst D-Klasse eskortieren.
]],

	sciassistant = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Elementare Klasse. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	sci = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Einer der Wissenschaftler. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	seniorsci = [[Schwierigkeit: Leicht
Zähigkeit: Hoch
Beweglichkeit: Hoch
Kampf Potenzial: Normal
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Einer der Wissenschaftler. Du hast höheren Zugriff Level. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	headsci = [[Schwierigkeit: Leicht
Zähigkeit: Hoch
Beweglichkeit: Hoch
Kampf Potenzial: Normal
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Der Beste von Wissenschaftler. Du hast höhere Nützlichkeit und HP. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	guard = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Elementarer Sicherheitsbeamter. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	lightguard = [[Schwierigkeit: Hoch
Zähigkeit: Niedrig
Beweglichkeit: Sehr Groß
Kampf Potenzial: Niedrig
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Große Nützlichkeit, aber keine Rüstung und wenig HP. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	heavyguard = [[Schwierigkeit: Mittel
Zähigkeit: Groß
Beweglichkeit: Niedrig
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Weniger Nützlichkeit, aber bessere Rüstung und mehr HP. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	specguard = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Niedrig
Kampf Potenzial: Sehr Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Nicht so große Nützlichkeit, mehr HP und großes Kampf Potenzial. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	chief = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Ein bisschen größere Nützlichkeit und hat ein Taser. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	guardmedic = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Niedrig
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Hat ein medkit und ein Taser. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	tech = [[Schwierigkeit: Hoch
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Hat plazierbare Sentry mit 3 Feuermoduse (Halte E auf der Sentry um die Menu zu sehen). Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	cispy = [[Schwierigkeit: Sehr Hoch
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Class D
Eskortiert von: Niemand
Überblick:
CI Spion. Große Nützlichkeit. Versuche zwischen Sicherheitsbeamter zu mischen und helfe D-Klass.
]],

	ntf_1 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein SMG. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntf_2 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein Shotgun. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntf_3 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein Gewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntfmedic = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Niedrig
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat eine Pistole und ein Medkit. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntfcom = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Sehr Groß
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein Scharfschützengewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntfsniper = [[Schwierigkeit: Hoch
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat eine Sniper. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	alpha1 = [[Schwierigkeit: Mittel
Zähigkeit: Extrem Groß
Beweglichkeit: Sehr Groß
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF Álpha-1 Einheit. Schwer gerüstet mit sehr großen Nützlichkeit, hat ein Gewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	alpha1sniper = [[Schwierigkeit: Hoch
Zähigkeit: Sehr Groß
Beweglichkeit: Sehr Groß
Kampf Potenzial: Sehr Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF Álpha-1 Einheit. Schwer gerüstet mit sehr großen Nützlichkeit, hat ein Scharfschützgewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ci = [[Schwierigkeit: Mittel
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Class D
Eskortiert von: Niemand
Überblick:
Chaos Insurgency Einheit. Gerate in die Einrichtung und helfe D-Class und töte Mitarbeiter von der Einrichtung.
]],

	cicom = [[Schwierigkeit: Mittel
Zähigkeit: Sehr Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Class D
Eskortiert von: Niemand
Überblick:
Chaos Insurgency Einheit. Höheres Kampf Potenzial. Gerate in die Einrichtung und helfe D-Class und töte Mitarbeiter von der Einrichtung.
]],

SCP023 = [[Schwierigkeit: Hoch
Zähigkeit: Niedrig
Beweglichkeit: Groß
Schaden: Sofortiges Tod

Überblick:
Du kannst durch Wände durchgehen. Wenn jemand dich sieht, wird er auf deine Liste gesetzt. Abundzu kannst du zu einen der Spieler auf der Liste teleportieren und diese zum Tod brennen. Du kannst dein Klon setzen.
]],

	SCP049 = [[Schwierigkeit: Hoch
Zähigkeit: Niedrig
Beweglichkeit: Groß
Schaden: Sofortiges Tod nach 3 Attacken

Überblick:
Kämpfe ein Spieler drei Mal um diesen zu töten. Du kannst Zombies von den Leichen machen (benutze reload key).
]],

	SCP0492 = [[]],

	SCP066 = [[Schwierigkeit: Mittel
Zähigkeit: Groß
Beweglichkeit: Normal
Schaden: Niedrig / durch AOE
	
Überblick:
Du spielst sehr laute Musik, die alle Spieler neben dich schadet.
]],

	SCP096 = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Sehr niedrig / Extrem groß wenn wütend
Schaden: Sofortiges Tod

Überblick:
Wenn jemand dich sieht, bekommst du wütend. Während du wütend bist, kannst du ubermäßig schnell rennen und du kannst dein Ziel töten.
]],

	SCP106 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Niedrig
Schaden: Mittel / Sofortiges Tod in Pocket Dimension
		
Überblick:
Du kannst durch Wände durchgehen. Greif jemand an, um ihn in die Pocket Dimesion abzuschicken. Während diese in der Pocket Dimension sind, sterben diese sofort bei den Fallen.		
]],

	SCP173 = [[Schwierigkeit: Leicht
Zähigkeit: Extrem Groß
Beweglichkeit: Super Extrem Groß
Schaden: Sofortiges Tod

Überblick:
Du bist äußerst und übermäßig schnell, aber du kannst nicht bewegen wenn jemand dich sieht. Du tötest automatisch Spieler neben dir. Du kannst eine Spezielle Attacke benutzen, um zu einen Spieler in Reichweite zu teleportieren.
]],

	SCP457 = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Schaden: Mittel / Feuer kann weiter verbreiten

Überblick:
Du brennst und du kannst Spieler neben dir auch brennen. Du stellst Fallen, die den Opfer brennen, wenn dieser auf der Falle draufsteht.
]],

	SCP682 = [[Schwierigkeit: Hoch
Zähigkeit: Super Duper Extrem
Beweglichkeit: Normal
Schaden: Hoch

Überblick:
Extrem Robust und tödlich. Benutze deine spezielle Fähigkeit um Schaden-Immunity auf eine kurze Zeit zu bekommen.
]],

	SCP8602 = [[Schwierigkeit: Mittel
Zähigkeit: Groß
Beweglichkeit: Groß
Schaden: Niedrig / Groß (strong attack)

Überblick:
Wenn jemand neben einer Wand steht, kannst du ihn gegen diese Wand anheften, um massiven Schaden auf Ihn freizusetzen. Du wirst auch bisschen HP verlieren.
]],

	SCP939 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Schaden: Mittel

Überblick:
Du hinterlässt eine Spur von einer unsichtbaren, giftigen Wolke. Vergifteten Spieler können LMB und RMB nicht benutzen.
]],

	SCP966 = [[Schwierigkeit: Mittel
Zähigkeit: Niedrig
Beweglichkeit: Groß
Schaden: Niedrig/Bluten

Überblick:
Du bist unsichtbar. Deine Attacken verursachen Bluten.
]],

	SCP24273 = [[Schwierigkeit: Hoch
Zähigkeit: Normal
Beweglichkeit: Normal
Schaden: Groß / Sofortiges Tod während Mind Control

Überblick:
Du kannst nach vorne stürmen, um Schaden zu den ersten angegriffenen Spieler freizugeben. Spezielle Fähigkeit lässt dich einen anderen Spieler zu steuern für eine kurze Zeit. Wenn du den Spieler zu dich bringst, kannst du Ihn sofort töten. Wenn man Selbstmord während der Kontrolle begeht, verlierst du HP.
]],

	SCP3199 = [[Schwierigkeit: Sehr Hoch
Zähigkeit: Niedrig
Beweglichkeit: Sehr Groß
Schaden: Niedrig / Mittel
	
Überblick:
Wenn du denn Spieler attackierst, kriegst du Wahnsinn und gibst Ihn große Wunden. Während du wahnsinnig bist, kannst du schneller bewegen und den Ort der Spieler neben dich sehen. Wenn du eine attacke vermisst oder du einen Spieler attackierst der schon tiefe Wunden hat, verlierst du das Wahnsinn und kriegst eine Strafe. Wenn du mindestens 5 Wahnsinn-Tokens hast, kannst du die Spezielle attacke benutzen. Spezielle Attacke tötet den Spieler nach kurzer Zeit.
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "Zusätzliche Sicht",
		info = "Die Helligkeit Deiner Sicht wird erhöht\nDunkle Bereiche werden Dich nicht mehr aufhalten"
	}
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	editMode1 = "Drücke LMB, um das Modell zu platzieren",
	editMode2 = "RMB - Abbrechen, R - Drehen",
	preys = "Verfügbare Beute: %i",
	attack = "Nächster Angriff: %s",
	trapActive = "Falle ist aktiv!",
	trapInactive = "Drücke RMB, um die Falle zu platzieren",
	upgrades = {
		attack1 = {
			name = "Lust I",
			info = "Die Abklingzeit von Angriffen wird um 20 Sekunden verringert",
		},
		attack2 = {
			name = "Lust II",
			info = "Die Abklingzeit von Angriffen wird um 20 Sekunden verringert\n\t• Gesamtabklingzeit: 40s",
		},
		attack3 = {
			name = "Lust III",
			info = "Die Abklingzeit von Angriffen wird um 20 Sekunden verringert\n\t• Gesamtabklingzeit: 60s",
		},
		trap1 = {
			name = "Bad Omen I",
			info = "Die Abklingzeit deiner Falle wird auf 40 Sekunden reduziert",
		},
		trap2 = {
			name = "Bad Omen II",
			info = "Die Abklingzeit deiner Falle wird auf 20 Sekunden reduziert.\nDie Reichweite von deiner Falle wird um 25 Einheiten erhöht",
		},
		trap3 = {
			name = "Bad Omen III",
			info = "Die Reichweit von deiner FAllee wird um 25 Einheiten erhöht\n\t• Gesamtzunahme: 50 Einheiten",
		},
		hp = {
			name = "Alpha male I",
			info = "Du erhältst 1000 HP (auch maximale HP) und 10% Kugelschutz, aber die Abklingzeit der Fallen wird um 30 Sekunden erhöht",
		},
		speed = {
			name = "Alpha male II",
			info = "Du erhältst 10 % Bewegungsgeschwindigkeit und zusätzlich 15 % Kugelschutz, aber die Abklingzeit der Fallen wird um 30 Sekunden erhöht\n\t• Gesamtschutz: 25 %, Erhöhung der Gesamtabklingzeit: 60 s",
		},
		alt = {
			name = "Alpha male III",
			info = "Die Abklingzeit deines Angriffs wird um 30 Sekunden verringert und du erhältst 15 % Kugelschutz, aber du kannst deine Falle nicht mehr verwenden\n\t• Gesamtschutz: 40 %",
		},
	}
}

wep.SCP049 = {
	surgery = " Operation durchführen",
	surgery_failed = "Operation fehlgeschlagen!",
	zombies = {
		normal = "Standard-Zombie",
		light = "Leichter Zombie",
		heavy = "Schwerer Zombie"
	},
	upgrades = {
		cure1 = {
			name = "I am the Cure I",
			info = "Erhalte 40% Kugelschutz",
		},
		cure2 = {
			name = "I am the Cure II",
			info = "Stellt alle 180 Sekunden 300HP wieder her",
		},
		merci = {
			name = "Act of Mercy",
			info = "Die Abklingzeit des Primärangriffs wird um 2,5 Sekunden verringert\nDu wendest den Türschloss-Effekt nicht mehr auf Menschen in der Nähe an",
		},
		symbiosis1 = {
			name = "Symbiosis I",
			info = "Nach der Operation bist Du um 10 % deiner maximalen Gesundheit geheilt",
		},
		symbiosis2 = {
			name = "Symbiosis II",
			info = "Nach der Operation bist Du um 10 % deiner maximalen Gesundheit geheilt\nIn der Nähe befindliche SCP 049-2-Instanzen werden um 20 % ihrer maximalen Gesundheit geheilt",
		},
		symbiosis3 = {
			name = "Symbiosis III",
			info = "Nach der Operation bist Du um 20 % deiner maximalen Gesundheit geheilt\nIn der Nähe befindliche SCP 049-2-Instanzen werden um 20 % ihrer maximalen Gesundheit geheilt",
		},
		hidden = {
			name = "Hidden Potential",
			info = "Du erhältst 1 Marker für jede erfolgreiche Operation\nJeder Marker erhöht die HP von Zombies um 5%\n\t• Diese Fähigkeit betrifft nur neu erstellte Zombies",
		},
		trans = {
			name = "Transfusion",
			info = "Du erhältst 1 Marker für jede erfolgreiche Operation\nJeder Marker erhöht die HP von Zombies um 5%\n\t• Diese Fähigkeit betrifft nur neu erstellte Zombies",
		},
		rm = {
			name = "Radical Therapy",
			info = "Wann immer es möglich ist, erschaffst du 2 Zombies aus 1 Körper\n\t• Wenn nur 1 Zuschauer verfügbar ist, erschaffst du nur 1 Zombie\n\t• Beide Zombies sind vom gleichen Typ\n\t• Zweiter Zombie hat HP reduziert HP um 50 %\n\t• Der Schaden des zweiten Zombies wurde um 25 % verringert.",
		},
		doc1 = {
			name = "Surgical Precision I",
			info = "Die Operationszeit wird um 5s verkürzt",
		},
		doc2 = {
			name = "Surgical Precision II",
			info = "Die Operationszeit wird um 5 s verkürzt\n\t• Die gesamte Operationszeit verkürzt sich: 10 s",
		},
	}
}

wep.SCP0492 = {
	too_far = "Du bist zu weit weg von SCP049"
}

wep.SCP066 = {
	wait = "Nächster Angriff: %is",
	ready = "Angriff ist bereit!",
	chargecd = "Abklingzeit: %is",
	upgrades = {
		range1 = {
			name = "Resonance I",
			info = "Schadensradius wird um 75 erhöht",
		},
		range2 = {
			name = "Resonance II",
			info = "Schadensradius wird um 75 erhöht\n\t• Gesamterhöhung: 150",
		},
		range3 = {
			name = "Resonance III",
			info = "Schadensradius wird um 75 erhöht\n\t• Gesamterhöhung: 225",
		},
		damage1 = {
			name = "Bass I",
			info = "Der Schaden wird auf 112,5% erhöht, aber der Radius wird auf 90% reduziert",
		},
		damage2 = {
			name = "Bass II",
			info = "Der Schaden wird auf 135% erhöht, aber der Radius wird auf 75% reduziert",
		},
		damage3 = {
			name = "Bass III",
			info = "Der Schaden wird auf 200 % erhöht, aber der Radius wird auf 50 % reduziert",
		},
		def1 = {
			name = "Negation Wave I",
			info = "Während du Musik abspielst, nimmst du 10 % des eingehenden Schadens auf",
		},
		def2 = {
			name = "Negation Wave II",
			info = "Während du Musik abspielst, nimmst du 25 % des eingehenden Schadens auf",
		},
		charge = {
			name = "Dash",
			info = "Schaltet die Fähigkeit frei, durch Drücken der Nachladetaste vorwärts zu stürmen\n\t• Abklingzeit der Fähigkeit: 20s",
		},
		sticky = {
			name = "Sticky",
			info = "Nachdem du in den Menschen hineingestürzt bist, bleibst du die nächsten 10 Sekunden bei ihnen",
		}
	}
}

wep.SCP096 = {
	charges = "Regenerationspunkte: %i",
	regen = "Regeneration von HP - Punkte: %i",
	upgrades = {
		sregen1 = {
			name = "Calm Spirit I",
			info = "Du erhältst alle 4 Sekunden eine Regenerationsladung statt alle 5 Sekunden"
		},
		sregen2 = {
			name = "Calm Spirit II",
			info = "Deine Regenerationsladungen heilen dich um 6 HP statt um 5 HP"
		},
		sregen3 = {
			name = "Calm Spirit III",
			info = "Deine Regenerationsrate ist 66 % schneller"
		},
		kregen1 = {
			name = "Hannibal I",
			info = "Du regenerierst zusätzliche 90 HP für einen erfolgreichen Kill"
		},
		kregen2 = {
			name = "Hannibal II",
			info = "Du regenerierst zusätzliche 90 HP für einen erfolgreichen Kill\n\t• Gesamtheilungssteigerung: 180HP"
		},
		hunt1 = {
			name = "Shy I",
			info = "Sichtfeld wird auf 4250 Einheiten erhöht"
		},
		hunt2 = {
			name = "Shy II",
			info = "Sichtfeld wird auf 5500 Einheiten erhöht"
		},
		hp = {
			name = "Goliath",
			info = "Deine maximale Gesundheit wird auf 4000 HP erhöht\n\t• Deine aktuelle Gesundheit wird nicht erhöht"
		},
		def = {
			name = "Persistent",
			info = "Du erhältst 30% Kugelschutz"
		}
	}
}

wep.SCP106 = {
	swait = "Abklingzeit der Spezialfähigkeit: %is",
	sready = "Spezialfähigkeit ist bereit!",
	upgrades = {
		cd1 = {
			name = "Void Walk I",
			info = "Die Abklingzeit von Spezialfähigkeiten wird um 15 Sekunden verringert"
		},
		cd2 = {
			name = "Void Walk II",
			info = "Die Abklingzeit von Spezialfähigkeiten wird um 15 Sekunden verringert\n\t• Gesamtabklingzeit: 30 Sek."
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
	swait = "Abklingzeit der Spezialfähigkeit: %is",
	sready = "Spezialfähigkeit ist bereit!",
	upgrades = {
		specdist1 = {
			name = "Wraith I",
			info = "Die Distanz eurer Spezialfähigkeit is um 500 erweitert"
		},
		specdist2 = {
			name = "Wraith II",
			info = "Die Distanz eurer Spezialfähigkeit is um 700 erweitert\n\t• Totale Distanz: 1200"
		},
		specdist3 = {
			name = "Wraith III",
			info = "Die Distanz eurer Spezialfähigkeit is um 800 erweitert\n\t• Totale Distanz: 2000"
		},
		boost1 = {
			name = "Bloodthirster I",
			info = "Jedes Mal du einen Mensch tötest, kriegst du 150 HP und die Abklingszeit von der Spezialfähighkeit wird um 10% verringert"
		},
		boost2 = {
			name = "Bloodthirster II",
			info = "Jedes Mal du einen Mensch tötest, kriegst du 300 HP und die Abklingszeit von der Spezialfähighkeit wird um 25% verringert"
		},
		boost3 = {
			name = "Bloodthirster III",
			info = "Jedes Mal du einen Mensch tötest, kriegst du 500 HP und die Abklingszeit von der Spezialfähighkeit wird um 50% verringert"
		},
		prot1 = {
			name = "Concrete Skin I",
			info = "Heile sofort 1000 HP und bekomme 10% Schutz gegen Schusswunden"
		},
		prot2 = {
			name = "Concrete Skin II",
			info = "Heile sofort 1000 HP und bekomme 10% Schutz gegen Schusswunden\n\t• Totaler Schutz: 20%"
		},
		prot3 = {
			name = "Concrete Skin III",
			info = "Heile sofort 1000 HP und bekomme 20% Schutz gegen Schusswunden\n\t• Totaler Schutz: 40%"
		},
	},
	back = "Du kannst R halten um auf deine vorherige Position zu kommen",
}

wep.SCP457 = {
	swait = "Spezialfähigkeit Abklingszeit: %is",
	sready = "Spezialfähigkeit ist bereit!",
	placed = "Aktive Fallen: %i/%i",
	nohp = "Nicht genug HP!",
	upgrades = {
		fire1 = {
			name = "Live Torch I",
			info = "Dein Brenn-Radius ist um 25 vergrößert"
		},
		fire2 = {
			name = "Live Torch II",
			info = "Dein Brenn-Schaden ist um 0.5 vergrößert"
		},
		fire3 = {
			name = "Live Torch III",
			info = "Dein Brenn-Radius ist um 50 vergrößert und dein Brenn-Schaden ist um 0.5 vergrößert\n\t• Totaler Radius Vergrößerung: 75\n\t• Totaler Schaden Vergrößerung: 1"
		},
		trap1 = {
			name = "Little Surprise I",
			info = "Fallen-Lebensdauer wird um 4 Minuten vergrößert und wird 1s mehr brennen"
		},
		trap2 = {
			name = "Little Surprise II",
			info = "Fallen-Lebensdauer wird um 5 Minuten vergrößert und wird 1s mehr brennen und sein Schaden ist um 0.5 vergrößert\n\t• Totale Brenn-Zeit Vergrößerung: 2s"
		},
		trap3 = {
			name = "Little Surprise III",
			info = "Trap will burn 1s longer and its damage is increased by 0.5\n\t• Total burn time increase: 3s\n\t• Total damage increase: 1"
		},
		heal1 = {
			name = "Sizzling Snack I",
			info = "Brennende Spieler werden Dich um 1 HP mehr heilen"
		},
		heal2 = {
			name = "Sizzling Snack II",
			info = "Brennende Spieler werden Dich um 1 HP mehr heilen\n\t• Totale Heil Vergrößerung: 2"
		},
		speed = {
			name = "Fast Fire",
			info = "Deine Geschwindigkeit ist um 10% vergrößert"
		}
	}
}

wep.SCP682 = {
	swait = "Spezialfähigkeit Abklingszeit: %is",
	sready = "Spezialfähigkeit ist bereit!",
	s_on = "Du bist für jeden Schaden unverwundbar! %is",
	upgrades = {
		time1 = {
			name = "Unbroken I",
			info = "Deine Spezialfähigkeit Dauer ist um 2.5s vergrößert\n\t• Totale Dauer: 12.5s"
		},
		time2 = {
			name = "Unbroken II",
			info = "Deine Spezialfähigkeit Dauer ist um 2.5s vergrößert\n\t• Totale Dauer: 15s"
		},
		time3 = {
			name = "Unbroken III",
			info = "Deine Spezialfähigkeit Dauer ist um 2.5s vergrößert\n\t• Totale Dauer: 17.5s"
		},
		prot1 = {
			name = "Adaptation I",
			info = "Du kriegst 10% weniger Schusswunden"
		},
		prot2 = {
			name = "Adaptation II",
			info = "Du kriegst 15% weniger Schusswunden\n\t• Totale Schusswunden Reduktion: 25%"
		},
		prot3 = {
			name = "Adaptation III",
			info = "Du kriegst 15% weniger Schusswunden\n\t• Totale Schusswunden Reduktion: 40%"
		},
		speed1 = {
			name = "Furious Rush I",
			info = "Nachdem die Spezialfähigkeit benutzt wird, kriegst Du 10% mehr Geschwindigkeit bis du Schaden bekommst"
		},
		speed2 = {
			name = "Furious Rush II",
			info = "Nachdem die Spezialfähigkeit benutzt wird, kriegst Du 20% mehr Geschwindigkeit bis du Schaden bekommst"
		},
		ult = {
			name = "Regeneration",
			info = "5 Sekunden nachdem du Schaden bekommen hast, regeneriere 5% von fehlenden Leben"
		},
	}
}

wep.SCP8602 = {
	upgrades = {
		charge11 = {
			name = "Brutality I",
			info = "Schaden von der Starken Attacke ist um 5 vergrößert"
		},
		charge12 = {
			name = "Brutality II",
			info = "Schaden von der Starken Attacke ist um 10 vergrößert\n\t• Totaler Schaden Vergrößerung: 15"
		},
		charge13 = {
			name = "Brutality III",
			info = "Schaden von der Starken Attacke ist um 10 vergrößert\n\t• Totaler Schaden Vergrößerung: 25"
		},
		charge21 = {
			name = "Charge I",
			info = "Reichweite von der Starken Attacke ist um 15 vergrößert"
		},
		charge22 = {
			name = "Charge II",
			info = "Reichweite von der Starken Attacke ist um 15 vergrößert\n\t• Totale Reichweite Vergrößerung: 30"
		},
		charge31 = {
			name = "Shared Pain",
			info = "Wenn du deine Starke Attacke ausführst, kriegt jeder daneben 20% von Gesamtschaden"
		},
	}
}

wep.SCP939 = {
	upgrades = {
		heal1 = {
			name = "Bloodlust I",
			info = "Deine Attacken heilen dich mindestens für 22.5 HP (bis zu 30)"
		},
		heal2 = {
			name = "Bloodlust II",
			info = "Deine Attacken heilen dich mindestens für 37.5 HP (bis zu 50)"
		},
		heal3 = {
			name = "Bloodlust III",
			info = "Deine Attacken heilen dich mindestens für 52.5 HP (bis zu 70)"
		},
		amn1 = {
			name = "Lethal Breath I",
			info = "Der Radius deines Giftes ist um 100 vergrößert"
		},
		amn2 = {
			name = "Lethal Breath II",
			info = "Dein Gift macht jetzt Schaden: 1.5 dmg/s"
		},
		amn3 = {
			name = "Lethal Breath III",
			info = "Dein Gift Radius ist um 125 vergrößert und dein Gift Schaden um 3 dmg/s vergrößert"
		},
	}
}

wep.SCP966 = {
	upgrades = {
		lockon1 = {
			name = "Frenzy I",
			info = "Zeit gebraucht für Attacke ist zu 2.5s reduziert"
		},
		lockon2 = {
			name = "Frenzy II",
			info = "Zeit gebraucht für Attacke ist zu 2s reduziert"
		},
		dist1 = {
			name = "Call of the Hunter I",
			info = "Radius deiner Attacke ist zu 15 vergrößert"
		},
		dist2 = {
			name = "Call of the Hunter II",
			info = "Radius deiner Attacke ist zu 15 vergrößert\n\t• Totale Radius Vergrößerung: 30"
		},
		dist3 = {
			name = "Call of the Hunter III",
			info = "Radius deiner Attacke ist zu 15 vergrößert\n\t• Totale Radius Vergrößerung: 45"
		},
		dmg1 = {
			name = "Sharp Claws I",
			info = "Schaden deiner Attacke ist auf 5 vergrößert"
		},
		dmg2 = {
			name = "Sharp Claws II",
			info = "Schaden deiner Attacke ist auf 5 vergrößert\n\t• Total Schaden Vergrößerung: 10"
		},
		bleed1 = {
			name = "Deep Wounds I",
			info = "Deine Attacken haben 25% mehr chance um größere Stufe von Blutung zu machen"
		},
		bleed2 = {
			name = "Deep Wounds II",
			info = "Deine Attacken haben 50% mehr chance um größere Stufe von Blutung zu machen"
		},
	}
}

wep.SCP24273 = {
	mind_control = "Mind Control ist bereit! Presse RMB",
	mind_control_cd = "Mind Control ist auf Abklingszeit! Warte: %is",
	dash = "Attacke ist fertig!",
	dash_cd = "Attack ist auf Abklingszeit! Warte: %is",
	upgrades = {
		dash1 = {
			name = "Ruthless Charge I",
			info = "Deine Attack-Abklingszeit wird auf 1 Sekunde verkürztY und seine Kraft wird auf 15% vergrößert"
		},
		dash2 = {
			name = "Ruthless Charge II",
			info = "Die Strafzeit nach dem Angriff wird um 0,5 Sekunden reduziert und die Geschwindigkeitsstrafe von 50 % auf 35 % reduziert"
		},
		dash3 = {
			name = "Ruthless Charge III",
			info = "Dein Attack-Schaden wird auf 50 vergrößert"
		},
		mc11 = {
			name = "Persistent Hunter I",
			info = "Mind Control Dauer wird auf 10s vergrößert, aber die Abklingszeit wird auch auf 20s vergrößert"
		},
		mc12 = {
			name = "Persistent Hunter II",
			info = "Mind Control Dauer wird auf 10s vergrößert, aber die Abklingszeit wird auch auf 25s vergrößert\n\t• Totale Dauer Vergrößerung: 20s\n\t• Totale Abklingszeit Vergrößerung: 45s"
		},
		mc21 = {
			name = "Impatient Hunter I",
			info = "Mind Control Dauer wird auf 5s reduziert, aber die Abklingszeit wird auch auf 10s kleiner"
		},
		mc22 = {
			name = "Impatient Hunter II",
			info = "Mind Control Dauer wird auf 10s reduziert, aber die Abklingszeit wird 15s kleiner"
		},
		mc3 = {
			name = "Unbroken Hunter",
			info = "Während der Mind Control bekommst Du 50% Schutz gegen alle Arten von Schaden"
		},
		mc13 = {
			name = "Strict Judge",
			info = "Wenn Du das Opfer während Mind Control tötest, verringert die Abklingszeit auf 40%. Mind Control Reichweite ist auf 1000 units größer"
		},
		mc23 = {
			name = "Crimson Judge",
			info = "Wenn Du das Opfer während Mind Control tötest, heilst Du auf 400 HP. Mind Control Reichweite ist auf 500 units größer"
		},
	}
}

wep.SCP3199 = {
	special = "Spezialfähigkeit ist bereit! Presse RMB",
	upgrades = {
		regen1 = {
			name = "Taste of Blood I",
			info = "Regeneriere 2 HP pro Sekunde während zu wütend bist"
		},
		regen2 = {
			name = "Taste of Blood II",
			info = "Regeneration ratio ist um 10% vergrößert für jeder Raserei-Token"
		},
		frenzy1 = {
			name = "Hunter's Game I",
			info = "Maximal Raserei-Token ist um 1 vergrößert\nDeine Raserei Dauer ist um 20% vergrößert"
		},
		frenzy2 = {
			name = "Hunter's Game II",
			info = "Maximal Raserei-Token ist um 1 vergrößert\nDeine Raserei Dauer ist um 30% vergrößert\nDeine Spezialfähigkeit ist ausgeschaltet\n\t• Total Raserei-Token Vergrößerung: 2\n\t• Total Dauer Vergrößerung: 50%"
		},
		ch = {
			name = "Blind Fury",
			info = "Deine Geschwindigkeit ist um 25% vergrößert\nDu kannst aber nicht die Herzschläge der Menschen neben an nicht hören"
		},
		egg1 = {
			name = "Another One",
			info = "Du wirst extra ein neues Ei legen wenn du diesen Upgrade kaufst\n\t• Das Ei kann nicht erstellt, wenn es kein freien Platz gibt für ein Ei in dieser Karte"
		},
		egg2 = {
			name = "Legacy",
			info = "Einer der inaktiven Eien wird aktiviert wenn dieser Upgrade wird gekauft\n\t• Dieses wird kein Effekt haben wenn es kein inaktives Ei auf der Karte gibt"
		},
		egg3 = {
			name = "Easter Egg",
			info = "Deine Respawn-Zeit wurde zu 20 Sekunden verkürzt"
		},
	}
}

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

registerLanguage( lang, "german", "deutsch", "de" )
setLanguageFlag( "german", LANGUAGE.EQ_LONG_TEXT )