--[[-------------------------------------------------------------------------
Language: German
Date: 12.08.2021
Translated by: Justinnn
Updated in day 12.08.2021 by: Zaptyp (https://steamcommunity.com/id/Zaptyp/)
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
hud.class_points = "Prestige Points"
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
lang.refund = "Rückerstattung"
lang.none = "Keiner"
lang.refunded = "Alle entfernten Klassen wurden zurückerstattet. Du hast %d Prestigepunkte erhalten."

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
vest.ntfcom = "MTF NTF Commander Weste"
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

--TODO: New SCP translations
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

--TODO: New SCP translations

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

RegisterLanguage( lang, "german", "deutsch", "de" )
SetLanguageFlag( "german", LANGUAGE.EQ_LONG_TEXT )