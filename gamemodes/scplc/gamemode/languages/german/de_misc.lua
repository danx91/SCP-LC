local lang = LANGUAGE

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

