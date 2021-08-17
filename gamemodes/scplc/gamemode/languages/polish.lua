--[[-------------------------------------------------------------------------
Language: Polish
Date: 12.08.2021
Translated by: Slusher, alski
Updated by: Zaptyp (https://steamcommunity.com/id/Zaptyp/)
---------------------------------------------------------------------------]]

local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Możesz zostać wybrany jako SCP w następnej rundzie",
	scpwait = "Musisz poczekać %i rund aby zagrać jako SCP",
	abouttostart = "Gra rozpocznie się za %i sekund!",
	kill = "Otrzymujesz %d punktów za zabójstwo %s: %s!",
	assist = "Otrzymujesz %d punktów za asystę w zabójstwie gracza: %s!",
	rdm = "Tracisz %d punktów za zabójstwo %s: %s!",
	acc_denied = "Brak dostępu",
	acc_granted = "Dostęp przyznany",
	acc_omnitool = "Do obsługi tych drzwi wymagany jest Omnitool",
	device_noomni = "Do obsługi tego urządzenia wymagany jest Omnitool",
	elevator_noomni = "Do obsługi tej windy wymagany jest Omnitool",
	acc_wrong = "Do wykonania tej czynności wymagany jest wyższy poziom dostępu",
	rxpspec = "Otrzymujesz %i doświadczenia za grę na tym serwerze!",
	rxpplay = "Otrzymujesz %i doświadczenia za pozostanie przy życiu w rundzie!",
	rxpplus = "Otrzymujesz %i doświadczenia za przeżycie ponad połowy rundy!",
	roundxp = "Otrzymujesz %i doświadczenia za zdobyte punkty",
	gateexplode = "Czas do wybuchu Gate A: %i",
	explodeterminated = "Wybuch Gate A zakończony",
	r106used = "Procedura zabezpieczenia SCP 106 może zostać uruchomiona tylko raz na rundę",
	r106eloiid = "Wyłącz elektromagnes ELO-IID, aby rozpocząć procedurę zabezpieczania SCP 106",
	r106sound = "Uruchom transmisję dźwięku, aby rozpocząć procedurę zatrzymania SCP 106",
	r106human = "W klatce musi znajdować się żywy człowiek, aby rozpocząć procedurę zabezpieczenia SCP 106",
	r106already = "SCP 106 jest już zabezpieczony",
	r106success = "Otrzymujesz %i punktów za zabezpieczenie SCP 106!",
	vestpickup = "Podniosłeś pancerz",
	vestdrop = "Upuściłeś pancerz",
	hasvest = "Masz już pancerz na sobie! Użyj swojego EQ, aby ją upuścić",
	escortpoints = "Otrzymujesz %i punktów za eskortę sojuszników",
	femur_act = "Femur Breaker został aktywowany...",
	levelup = "Awansowałeś! Twój aktualny poziom: %i",
	healplayer = "Otrzymujesz %i punktów za leczenie innych graczy",
	detectscp = "Otrzymujesz %i punktów za wykrycie SCP",
	winxp = "Otrzymujesz %i doświadczenia ponieważ twoja początkowa drużyna wygrała rundę",
	winalivexp = "Otrzymujesz %i doświadczenia ponieważ twoja drużyna wygrała rundę",
	upgradepoints = "Otrzymałeś punkt ulepszeń! Naciśnij '%s' aby otworzyć menu ulepszeń SCP",
	prestigeup = "Gracz %s zdobył wyższy poziom prestiżu! Obecny poziom prestiżu: %i",
	omega_detonation = "Detonacja głowicy OMEGA za %i sekund. Wyjdź na powierzchnię lub natychmiastowo udaj się do schronu!",
	alpha_detonation = "Detonacja głowicy ALPHA za %i sekund. Wejdź do placówki lub natychmiastowo udaj się do ewakuacji!",
	alpha_card = "Włożyłeś kartę nuklearną głowicy ALPHA",
	destory_scp = "Otrzymujesz %i punktów za zniszczenie podmiotu SCP!",
	afk = "Jesteś AFK. Nie będziesz się respił ani otrzymywał expa",
	afk_end = "Nie jesteś już AFK",
	overload_cooldown = "Poczekaj %i sekund aby przeciążyć te drzwi!",
	advanced_overload = "Te drzwi wydają się być za mocne! Spróbuj ponownie za %i sekund",
	lockdown_once = "Blokada placówki może być aktywowana tylko raz na runde",
}

lang.NFailed = "Nie udało się uzyskać dostępu do NRegistry z kluczem: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "Uciekłeś!",
	escapeinfo = "Dobra robota! Uciekłeś w %s",
	escapexp = "Otrzymujesz %i doświadczenia",
	escort = "Zostałeś odeskortowany!",
	roundend = "Runda zakończona!",
	nowinner = "Brak zwycięzcy w tej rundzie!",
	roundnep = "Niewystarczająca liczba graczy!",
	roundwin = "Zwycięzca rundy: %s",
	roundwinmulti = "Zwycięzcy rundy: [RAW]",
	shelter_escape = "Przeżyłeś eksplozję w schronie przeciwwybuchowym",
	alpha_escape = "Uciekłeś przed wybuchem głowicy ALPHA",

	mvp = "MVP: %s z wynikiem: %i",
	stat_kill = "Zabici gracze: %i",
	stat_rdm = "Zabójstwa RDM: %i",
	stat_rdmdmg = "Obrażenia RDM: %i",
	stat_dmg = "Zadane obrażenia: %i",
	stat_bleed = "Obrażenia od krwawienia: %i",
	stat_106recontain = "SCP 106 został zabezpieczony",
	stat_escapes = "Graczy uciekło: %i",
	stat_escorts = "Graczy odeskortowano: %i",
	stat_023 = "Nagłe zgony spowodowane przez SCP 023: %i",
	stat_049 = "Gracze \"wyleczeni\" przez SCP 049: %i",
	stat_066 = "Gracze zabici przez głośną muzykę SCP 066: %i",
	stat_096 = "Gracze zabici przez SCP 096: %i",
	stat_106 = "Gracze przeteleportowani do wymiaru łuzowego: %i",
	stat_173 = "Złamane karki przez SCP 173: %i",
	stat_457 = "Podpaleni gracze: %i",
	stat_682 = "Gracze zabici przez SCP 682: %i",
	stat_8602 = "Gracze przybici do ściany przez SCP 860-2: %i",
	stat_939 = "Dusze SCP 939: %i",
	stat_966 = "Gracze przecięci przez SCP 966: %i",
	stat_3199 = "Zabójstwa dokonane przez SCP 3199: %i",
	stat_24273 = "Osoby osądzone przez SCP 2427-3: %i",
	stat_omega_warhead = "Głowica OMEGA została zdetonowana",
	stat_alpha_warhead = "Głowica ALPHA została zdetonowana",
}

lang.NCFailed = "Nie udało się uzyskać dostępu do NCRegistry z kluczem: %s"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "Podnieś"
hud.class = "Klasa"
hud.team = "Drużyna"
hud.prestige_points = "Punkty prestiżu"
hud.hp = "HP"
hud.stamina = "ENERGIA"
hud.sanity = "PSYCHIKA"
hud.xp = "PD"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "LPM - Wybierz"
lang.eq_rmb = "PPM - Upuść"
lang.eq_hold = "Przytrzymaj LPM - Przenieś"
lang.eq_vest = "Pancerz"
lang.eq_key = "Naciśnij '%s' aby otworzyć EQ"

lang.info = "Informacje"
lang.author = "Autor"
lang.mobility = "Mobilność"
lang.weight = "Waga"
lang.protection = "Ochrona"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "Eskortuj",
	gatea = "Detonuj Gate A"
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "perm"
effects.bleeding = "Krwawienie"
effects.doorlock = "Blokowanie drzwi"
effects.amnc227 = "AMN-C227"
effects.insane = "Szaleństwo"
effects.gas_choke = "Duszenie"
effects.radiation = "Radiacja"
effects.deep_wounds = "Głębokie rany"
effects.heavy_bleeding = "Silne krwawienie"
effects.weak_bleeding = "Słabe krwawienie"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Katalog klas"
lang.preview = "Podgląd"
lang.random = "Losowo"
lang.price = "Cena"
lang.buy = "Kup"
lang.refound = "Zwróć"
lang.none = "Brak"
lang.refounded = "Wszystkie usunięte klasy zostały zwrócone. Otrzymałeś %d punktów prestiżu."

lang.details = {
	details = "Szczegóły",
	name = "Nazwa",
	team = "Drużyna",
	price = "Ilość punktów prestiżu",
	walk_speed = "Szybkość chodzenia",
	run_speed = "Szybkość biegania",
	chip = "Chip dostępu",
	persona = "Fałszywa tożsamość",
	weapons = "Bronie",
	class = "Klasa",
	hp = "Życie",
	speed = "Szybkość",
	health = "Życie",
	sanity = "Psychika"
}

lang.headers = {
	support = "WSPARCIE",
	classes = "KLASY",
	scp = "SCP"
}

lang.view_cat = {
	classd = "Klasa D",
	sci = "Naukowcy",
	mtf = "Ochrona",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alfa-1",
	ci = "Chaos Insurgency",
}

--[[-------------------------------------------------------------------------
Settings
---------------------------------------------------------------------------]]
lang.settings = {
	settings = "Ustawienia trybu gry",

	none = "NONE",
	press_key = "> Wciśnij przycisk <",
	client_reset = "Przywróć ustawienia domyślne klienta",
	server_reset = "Przywróć ustawienia domyślne serwera",

	client_reset_desc = "Zaraz zresetujesz swoje WSZYSTKIE ustawienia w tym trybie gry.\nTej czynności nie można cofnąć!",
	server_reset_desc = "Ze względów bezpieczeństwa nie możesz tutaj zresetować ustawień serwera.\nAby zresetować serwer do ustawień domyślnych, wpisz 'slc_factory_reset' w konsoli serwera i postępuj zgodnie z instrukcjami.\nUważaj, tej czynności nie da się cofnąć i zresetuje WSZYSTKO!",

	popup_ok = "OK",
	popup_cancel = "ANULUJ",
	popup_continue = "KONTYNUUJ",

	panels = {
		binds = "Klawiszologia",
		reset = "Reset trybu gry",
		cvars = "ConVars Editor",
	},

	binds = {
		eq_button = "Ekwipunek",
		upgrade_tree_button = "Drzewko umiejętności SCP",
		ppshop_button = "Przeglądaj klasy",
		settings_button = "Ustawienia trybu gry",
		scp_special = "Specjalne umiejętności SCP"
	}
}

lang.gamemode_config = {
	loading = "Ładowanie...",

	categories = {
		general = "Ogólne",
		round = "Runda",
		xp = "XP",
		support = "Support",
		warheads = "Warheads",
		afk = "AFK",
		time = "Czas",
		premium = "Premium",
		scp = "SCP",
	}
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Unconnected"

lang.scoreboard = {
	name = "Tablica wyników",
	playername = "Nazwa",
	ping = "Ping",
	prestige = "Prestiż",
	level = "Poziom",
	score = "Wynik",
	ranks = "Rangi",
}

lang.ranks = {
	author = "Autor",
	vip = "VIP",
	tester = "Tester",
	contributor = "Contributor",
	translator = "Tłumacz",
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
	tree = "%s DRZEWKO ULEPSZEŃ",
	points = "Punkty ulepszeń",
	cost = "Koszt",
	owned = "Posiadane",
	requiresall = "Wymaga",
	requiresany = "Wymaga dowolnego",
	blocked = "Blokowane przez"
}

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
local scp_hud = {}
lang.SCPHUD = scp_hud

scp_hud.skill_not_ready = "Umiejętność nie jest jeszcze gotowa!"
scp_hud.skill_cant_use = "Umiejętność nie może być teraz użyta!"

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "Nazwa",
	class = "Klasa",
	team = "Drużyna",
	status = "Status",
	objectives = "Cele",
	details = "Szczegóły",
	registry_failed = "Błąd info_screen_registry"
}

lang.info_screen_registry = {
	escape_time = "Uciekłeś w %s minut",
	escape_xp = "Otrzymałeś %s doświadczenia",
	escape1 = "Uciekłeś z placówki",
	escape2 = "Uciekłeś podczas odliczania wybuchu Alpha",
	escape3 = "Przeżyłeś w schronie przeciwwybuchowym",
	escorted = "Zostałeś odeskortowany",
	killed_by = "Zostałeś zabity przez: %s",
	suicide = "Popełniłeś samobójstwo",
	unknown = "Przyczyna twojej śmierci jest nieznana",
	hazard = "Zostałeś zabity przez zagrożenie",
	alpha_mia = "Ostatnia znana lokalizacja: Powierzchnia",
	omega_mia = "Ostatnia znana lokalizacja: Placówka",
}

lang.info_screen_type = {
	alive = "Żywy",
	escaped = "Uciekłeś",
	dead = "Martwy",
	mia = "Zaginiony w akcji",
	unknown = "Nieznany",
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
lang.nothing = "Nothing"
lang.exit = "Wyjdź"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "Zawartość trybu",
	msg = [[Wygląda na to, że brakuje ci addonów. Może to powodować błędy, takie jak brak tekstur, modeli, dźwięków i może zepsuć ci radość z gry.
Nie masz %i addonów z %i. Czy chciałbyś je pobrać?? (Możesz pobrać je przez gre lub zrobić to samemu poprzez stronę na workshopie.)]],
	no = "Nie",
	download = "Pobierz teraz",
	workshop = "Pokaż stronę na workshopie",
	downloading = "Pobieranie",
	mounting = "Montowanie",
	idle = "Czekam na pobieranie...",
	processing = "Przetwarzany addon: %s\nStatus: %s",
	cancel = "Anuluj"
}

misc.omega_warhead = {
	idle = "Głowica OMEGA jest bezczynna\n\nOczekiwanie na sygnał...",
	waiting = "Głowica OMEGA jest bezczynna\n\nSygnał zaakceptowany!\nOczekiwanie na drugi sygnał...",
	failed = "Głowica OMEGA jest zablokowana\n\nNie wykryto drugiego sygnału!\nCzekaj %is",
	no_remote = "Aktywacja głowicy OMEGA nie powiodła się\n\nNie udało się nawiązać połączenia z głowicą!\t",
	active = "Głowica OMEGA aktywowana\n\nNatychmiastowo przystąp do ewakuacji!\nDetonacja za %.2fs",
}

misc.alpha_warhead = {
	idle = "Głowica ALPHA jest bezczynna\n\nCzekam na kody nuklearne...",
	ready = "Głowica ALPHA jest bezczynna\n\nKody zaakceptowane!\nOczekiwanie na aktywację...",
	no_remote = "Aktywacja głowicy ALPHA nie powiodła się\n\nNie udało się nawiązać połączenia z głowicą!\t",
	active = "Głowica ALPHA aktywowana\n\nNatychmiastowo przystąp do ewakuacji!\nDetonacja za %.2fs",
}

misc.buttons = {
	MOUSE1 = "LPM",
	MOUSE2 = "PPM",
	MOUSE3 = "ŚPM",
}

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "Pancerz ochroniarza"
vest.heavyguard = "Pancerz ciężkiego ochroniarza"
vest.specguard = "Pancerz specjalisty ochrony"
vest.guard_medic = "Pancerz sanitariusza ochrony"
vest.ntf = "Pancerz MTF NTF"
vest.mtf_medic = "Pancerz medyka MTF NTF"
vest.ntfcom = "Pancerz dowódcy MTF NTF"
vest.alpha1 = "Pancerz MTF Alfa-1"
vest.ci = "Pancerz Chaos Insurgency"
vest.fire = "Kamizelka ognioodporna"
vest.electro = "Kamizelka przeciwporażeniowa"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Obrażenia od ognia"
dmg.SHOCK = "Obrażenia elektryczne"
dmg.BULLET = "Obrażenia od pocisków"
dmg.FALL = "Obrażenia od upadku"

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "Obserwatorzy"
teams.CLASSD = "Klasa D"
teams.SCI = "Naukowcy"
teams.MTF = "MTF"
teams.CI = "CI"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "Nieznana"

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
classes.SCP24273 = "SCP 2427-3"

classes.classd = "Klasa D"
classes.veterand = "Weteran Klasy D"
classes.kleptod = "Kleptoman Klasy D"
classes.ciagent = "Agent CI"

classes.sciassistant = "Asystent naukowca"
classes.sci = "Naukowiec"
classes.seniorsci = "Starszy naukowiec"
classes.headsci = "Główny naukowiec"

classes.guard = "Ochroniarz"
classes.chief = "Szef ochrony"
classes.lightguard = "Lekki ochroniarz"
classes.heavyguard = "Ciężki ochroniarz"
classes.specguard = "Specjalista ochrony"
classes.guardmedic = "Ochroniarz sanitariusz"
classes.tech = "Technik ochrony"
classes.cispy = "Szpieg CI"

classes.ntf_1 = "MTF NTF - PM"
classes.ntf_2 = "MTF NTF - STRZELBA"
classes.ntf_3 = "MTF NTF - KARABIN"
classes.ntfcom = "Dowódca MTF NTF"
classes.ntfsniper = "Snajper MTF NTF"
classes.ntfmedic = "Medyk MTF NTF"
classes.alpha1 = "MTF Alfa-1"
classes.alpha1sniper = "Strzelec Wyborowy MTF Alfa-1"
classes.ci = "Chaos Insurgency"
classes.cicom = "Dowódca Chaos Insurgency"

--[[-------------------------------------------------------------------------
Class Info - NOTE: Each line is limited to 48 characters!
Screen is designed to hold max of 5 lines of text and THERE IS NO internal protection!
Note that last (5th) line should be shorter to prevent text overlaping (about 38 characters)
---------------------------------------------------------------------------]]
local generic_classd = [[- Ucieknij z placówki
- Unikaj personelu i obiektów SCP
- Współpracuj z innymi]]

local generic_sci = [[- Ucieknij z placówki
- Unikaj Klasy D i obiektów SCP
- Współpracuj z ochroną i jednostką MTF]]

local generic_guard = [[- Uratuj naukowców
- Zlikwiduj wszystkie obiekty Klasy D i SCP
- Słuchaj swojego przełożonego]]

local generic_ntf = [[- Dostań się do placówki
- Pomóż pozostałym pracownikom w środku
- Nie pozwól uciec obiektom Klasy D i SCP]]

local generic_scp = [[- Ucieknij z placówki
- Zabij wszystkich których spotkasz
- Współpracuj z innymi SCP]]

local generic_scp_friendly = [[- Ucieknij z placówki
- Możesz współpracować z ludźmi
- Współpracuj z innymi SCP]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	ciagent = [[- Eskortuj Personel Klasy D
- Unikaj personelu i obiektów SCP
- Współpracuj z innymi]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Uratuj naukowców
- Zlikwiduj wszystkie obiekty Klasy D i SCP
- Wydawaj rozkazy innym ochroniarzom]],

	guardmedic = [[- Uratuj naukowców
- Zlikwiduj wszystkie obiekty Klasy D i SCP
- Wspieraj innych ochroniarzy swoją apteczką]],

	tech = [[- Uratuj naukowców
- Zlikwiduj wszystkie obiekty Klasy D i SCP
- Wspieraj innych ochroniarzy swoją wieżyczką]],

	cispy = [[- Udawaj ochroniarza
- Pomóż Personelowi Klasy D
- Sabotuj ochroniarzy]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- Pomóż personelowi wewnątrz placówki
- Nie pozwól uciec obiektom Klasy D i SCP
- Wspieraj innych ochroniarzy swoją apteczką]],

	ntfcom = [[- Pomóż personelowi wewnątrz placówki
- Nie pozwól uciec obiektom Klasy D i SCP
- Wydawaj rozkazy innym sojusznikom]],

	ntfsniper = [[- Pomóż personelowi wewnątrz placówki
- Nie pozwól uciec obiektom Klasy D i SCP
- Wspieraj swoją drużynę zza pleców]],

	alpha1 = [[- Chroń placówkę za wszelką cenę
- Zatrzymaj obiekty Klasy D i SC
- Jesteś upoważniony do ]].."[ZMIENIONO]",

	alpha1sniper = [[- Chroń placówkę za wszelką cenę
- Zatrzymaj obiekty Klasy D i SCP
- Jesteś upoważniony do ]].."[ZMIENIONO]",

	ci = [[- Pomóż Personelowi Klasy D
- Wyeliminuj personel placówki
- Słuchaj swojego przełożonego]],

	cicom = [[- Pomóż Personelowi Klasy D
- Wyeliminuj personel placówki
- Wydawaj rozkazy innym sojusznikom]],

	SCP023 = generic_scp,

	SCP049 = [[- Ucieknij z placówki
- Współpracuj z innymi SCP
- "Wylecz" innych]],

	SCP0492 = [[]],

	SCP058 = generic_scp,

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
	classd = [[Poziom trudności: Łatwy
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Niski
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI

Przegląd:
Klasa podstawowa. Współpracuj z innymi, aby stawić czoła SCP i personelowi placówki. Możesz być eskortowany przez członków CI.
]],

	veterand = [[Poziom trudności: Łatwy
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI

Przegląd:
Bardziej zaawansowana klasa. Masz podstawowy dostęp do placówki Współpracuj z innymi, aby stawić czoła SCP i personelowi placówki. Możesz być eskortowany przez żołnierzy CI.
]],

	kleptod = [[Poziom trudności: Trudny
Wytrzymałość: Niska
Zwinność: Bardzo Wysoka
Potencjał bojowy: Niski
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI
Przegląd:
Bardzo użyteczna klasa. Rozpoczynasz z jednym losowym przedmiotem. Współpracuj z innymi, aby stawić czoła SCP i personelowi placówki. Możesz być eskortowany przez żołnierzy CI.
]],

	ciagent = [[Poziom trudności: Średni
Wytrzymałość: Bardzo wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko klase D
Eskortowany przez: Nikogo

Przegląd:
Uzbrojony w paralizator. Jako agent CI udziel pomocy klasie D i współpracuj z nimi. Możesz eskortować członków klasy D.
]],

	sciassistant = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Niski
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: Ochronę, Wsparcie MTF

Przegląd:
Klasa podstawowa. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

	sci = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Niski
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: Ochronę, Wsparcie MTF

Przegląd:
Jeden z naukowców. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

	seniorsci = [[Poziom trudności: Łatwy
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: Ochronę, Wsparcie MTF

Przegląd:
Jeden z naukowców. Masz wyższy poziom dostępu. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

	headsci = [[Poziom trudności: Łatwy
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: Ochronę, Wsparcie MTF

Przegląd:
Najlepszy z naukowców. Masz wyższą użyteczność oraz wysokie HP. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

	guard = [[Poziom trudności: Łatwy
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Podstawowy ochroniarz. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	lightguard = [[Poziom trudności: Trudny
Wytrzymałość: Niska
Zwinność: Bardzo Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Wysoka użyteczność, brak zbroi i mniejsze zdrowie. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	heavyguard = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Niska
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Mniejsza użyteczność, lepszy pancerz i wyższe zdrowie. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	specguard = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Niska
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Niezbyt duża użyteczność, większe zdrowie i silny potencjał bojowy. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	chief = [[Poziom trudności: Łatwy
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Nieco lepszy potencjał bojowy, posiada paralizator. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	guardmedic = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden ze Ochroniarzy. Posiada apteczkę i paralizator. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	tech = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden ze strażników. Ma możliwą do postawienia wieżyczkę z 3 trybami ognia (przytrzymaj E na wieżczce, aby zobaczyć jej menu). Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	cispy = [[Poziom trudności: Bardzo Trundy
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko klase D
Eskortowany przez: Nikogo

Przegląd:
Szpieg CI. Wysoka użyteczność. Spróbuj wtopić się w ochroniarzy i pomóż klasie D.
]],

	ntf_1 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojony w Pistolet Maszynowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntf_2 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w strzelbę. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntf_3 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w karabin. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntfmedic = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w pistolet, posiada apteczkę. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntfcom = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w karabin wyborowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntfsniper = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w karabin snajperski. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	alpha1 = [[Poziom trudności: Średni
Wytrzymałość: Ekstremalna
Zwinność: Bardzo Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alfa-1. Mocno opancerzona, bardzo użyteczna jednostka, uzbrojona w karabin. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	alpha1sniper = [[Poziom trudności: Trudny
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MFO Alpha-1. Mocno opancerzona, bardzo użyteczna jednostka, uzbrojona w karabin wyborowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ci = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko klase D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki.
]],

	cicom = [[Poziom trudności: Średni
Wytrzymałość: Bardzo wysoka
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko klase D
Eskortowany przez: Nikogo

Overview:
Jednostka Rebelii Chaosu. Wyższy potencjał bojowy. Wejdź do placówki, pomóż klasie D i zabij personel placówki.
]],
	
	SCP023 = [[Poziom trudności: Trudny
Wytrzymałość: Niska
Zwinność: Wysoka
Obrażenia: Natychmiast zabija

Przegląd:
Możesz przechodzić przez ściany. Jeśli ktoś cię zobaczy, zostanie umieszczony na Twojej liście. Raz na jakiś czas teleportujesz się do jednego gracza z listy i spalasz go na śmierć. Możesz stawiać swojego klona.
]],

	SCP049 = [[Poziom trudności: Trudny
Wytrzymałość: Niska
Zwinność: Wysoka
Obrażenia: Natychmiast zabija po 3 atakach

Przegląd:
Zaatakuj gracza 3 razy, aby go zabić. Możesz tworzyć zombie z ciał (klawisz przeładowania).
]],

	SCP0492 = [[]],

	SCP066 = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Zwykła
Obrażenia: Niskie / Obszarowe

Przegląd:
Grasz bardzo głośną muzykę, uszkadzając bębenki słuchowe wszystkich graczy w pobliżu.
]],

	SCP058 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Zwykła
Obrażenia: Średnie

Overview:
SCP z elastycznym stylem gry. Może atakować wręcz i strzelać. Posiada różne ulepszenia, które mogą dodać truciznę do ataków, zmodyfikować atak strzału lub odblokować zdolność eksplozji.
]],
	SCP096 = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Bardzo Niska / Ekstremalna kiedy jest rozwścieczony
Obrażenia: Natychmiast zabija

Przegląd:
Jeśli ktoś cię zobaczy, wpadniesz w gniew. Kiedy jesteś wściekły biegasz niezwykle szybko i możesz zabijać swoje cele.
]],

	SCP106 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Niska
Obrażenia: Średnie / Natychmiast zabija w Wymiarze Łuzowym

Przegląd:
Możesz przechodzić przez drzwi. Zaatakuj kogoś, by teleportował ich do wymiaru łuzowego. W wymiarze łuzowym natychmiast zabijasz swoje cele.
]],

	SCP173 = [[Poziom trudności: Łatwy
Wytrzymałość: Ekstremalna
Zwinność: Super Ekstremalna
Obrażenia: Natychmiast zabija

Przegląd:
Jesteś niesamowicie szybki, ale nie możesz się ruszać, jeśli ktoś cię zobaczy. Automatycznie zabijasz pobliskich graczy. Możesz użyć specjalnego ataku, aby teleportować się do jednego gracza w zasięgu.
]],

	SCP457 = [[Poziom trudności: Łatwy
Wytrzymałość: Zwykła
Zwinność: Zwykła
Obrażenia: Średnie / Ogień może się rozprzestrzeniać

Przegląd:
Płoniesz i możesz podpalać pobliskich graczy. Możesz także umieszczać pułapki, które aktywują się, gdy ktoś na nie nadepnie.
]],

	SCP682 = [[Poziom trudności: Trudny
Wytrzymałość: Super Ekstremalna
Zwinność: Zwykła
Obrażenia: Wysokie

Przegląd:
Niezwykle wytrzymały i zabójczy. Użyj specjalnej zdolności, aby zyskać odporność na obrażenia na krótki okres czasu.
]],

	SCP8602 = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Obrażenia: niskie / wysokie (silny atak)

Przegląd:
Jeśli ktoś znajduje się w pobliżu ściany, możesz przgwoździć go do tej ściany, zadając mu ogromne obrażenia. Stracisz też trochę zdrowia.
]],

	SCP939 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Obrażenia: Średnie

Przegląd:
Zostawiasz ślad niewidzialnej, toksycznej chmury. Odurzeni gracze nie mogą używać LPM i PPM.
]],

	SCP966 = [[Poziom trudności: Średni
Wytrzymałość: Niska
Zwinność: Wysoka
Obrażenia: Niskie / Nakłada krwawienie

Przegląd:
Jesteś niewidzialny. Twoje ataki zawsze powodują krwawienie.
]],

	SCP24273 = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Obrażenia: Wysoka / Natychmiastowa śmierć podczas Kontroli Umysłu

Przegląd:
Możesz doskoczyć do przodu, aby zadać obrażenia pierwszemu trafionemu graczowi. Specjalna zdolność pozwala przez krótki czas sterować innym graczem. Sprowadzenie do ciebie kontrolowanego gracza pozwoli ci natychmiast go zabić. Popełnienie samobójstwa podczas kontrolowania gracza spowoduje utratę zdrowia.
]],

	SCP3199 = [[Poziom trudności: Bardzo Trundy
Wytrzymałość: Niska
Zwinność: Bardzo Wysoka
Obrażenia: niskie / średnie

Przegląd:
Atakowanie gracza wywołuje szał i zadaje głębokie rany. W szale poruszasz się nieco szybciej i możesz zobaczyć lokalizację pobliskich graczy. Chybienie ataku lub atakowanie gracza, który ma już głębokie rany, zatrzymuje szaleństwo i nakłada karę. Posiadanie co najmniej 5 żetonów szału pozwala na użycie ataku specjalnego. Atak specjalny zabija gracza po krótkim przygotowaniu.
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "Polepszona wizja",
		info = "Jasność twojej wizji jest zwiększona\nCiemne obszary już cię nie powstrzymają"
	}
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	editMode1 = "Naciśnij LPM, aby umieścić widmo",
	editMode2 = "PPM - Anuluj, R - Obróć",
	preys = "Dostępne ofiary: %i",
	attack = "Następny atak: %s",
	trapActive = "Pułapka jest aktywna!",
	trapInactive = "Naciśnij PPM, aby umieścić pułapkę",
	upgrades = {
		attack1 = {
			name = "Żądza I",
			info = "Czas odnowienia twojego ataku zostaje skrócony o 20 sekund",
		},
		attack2 = {
			name = "Żądza II",
			info = "Czas odnowienia twojego ataku zostaje skrócony o 20 sekund\n\t• Całkowity czas odnowienia: 40s",
		},
		attack3 = {
			name = "Żądza III",
			info = "Czas odnowienia twojego ataku zostaje skrócony o 20 sekunds\n\t• Całkowity czas odnowienia: 60s",
		},
		trap1 = {
			name = "Zły znak I",
			info = "Czas odnowienia twojej pułapki zostaje skrócony do 40 sekund",
		},
		trap2 = {
			name = "Zły znak II",
			info = "Czas odnowienia twojej pułapki zostaje skrócony do 20 sekund\nOdległość podróży widma zostaje zwiększona o 25 jednostek",
		},
		trap3 = {
			name = "Zły znak III",
			info = "Odległość podróży widma zostaje zwiększona o 25 jednostek\n\t• Całkowity wzrost: 50 jednostek",
		},
		hp = {
			name = "Samiec alfa I",
			info = "Zyskujesz 1000 HP (maksymalne HP również) i 10% ochrony przed pociskami, ale czas odnowienia pułapki wydłuża się o 30 sekund",
		},
		speed = {
			name = "Samiec alfa II",
			info = "Zyskujesz 10% prędkości ruchu i dodatkowe 15% ochrony przed pociskami, ale czas odnowienia pułapki wydłuża się o 30 sekund\n\t• Całkowita ochrona: 25%, Całkowite wydłużenie czasu odnowienia: 60 s",
		},
		alt = {
			name = "Samiec alfa III",
			info = "Czas odnowienia ataku zostaje skrócony o 30 sekund i zyskujesz 15% ochrony przed pociskami, ale nie możesz już używać swojej pułapki\n\t• Całkowita ochrona: 40% ",
		},
	}
}

wep.SCP049 = {
	surgery = "Przeprowadzanie operacji",
	surgery_failed = "Operacja się nie powiodła!",
	zombies = {
		normal = "Standardowy Zombie",
		light = "Lekki Zombie",
		heavy = "Ciężki Zombie",
	},
	upgrades = {
		cure1 = {
			name = "Jestem \"lekarstwem\" I",
			info = "Uzyskaj 40% ochronę przed pociskami",
		},
		cure2 = {
			name = "Jestem \"lekarstwem\" II",
			info = "Odzyskaj 300 HP co 180 sekund",
		},
		merci = {
			name = "Akt Miłosierdzia",
			info = "Czas odnowienia podstawowego ataku zostaje skrócony o 2,5 sekundy\nNie nakładasz już efektu „Blokady drzwi” na pobliskich ludzi",
		},
		symbiosis1 = {
			name = "Symbioza I",
			info = "Po wykonaniu operacji zostaniesz wyleczony o 10% maksymalnego zdrowia",
		},
		symbiosis2 = {
			name = "Symbioza II",
			info = "Po wykonaniu operacji zostajesz wyleczony o 15% maksymalnego zdrowia\nPobliskie SCP 049-2 są leczone o 10% ich maksymalnego zdrowia",
		},
		symbiosis3 = {
			name = "Symbioza III",
			info = "Po wykonaniu operacji zostajesz wyleczony o 20% maksymalnego zdrowia\nPobliskie SCP 049-2 są leczone o 20% ich maksymalnego zdrowia",
		},
		hidden = {
			name = "Ukryty potencjał",
			info = "Otrzymujesz 1 ładunek za każdą udaną operację\nKażdy ładunek zwiększa HP zombie o 5%\n\t• Ta umiejętność działa tylko na nowo powstałe zombie",
		},
		trans = {
			name = "Transfuzja",
			info = "Twoje zombie mają zwiększone HP o 15%\nTwoje zombie zyskują 20% kradzieży życia\n\t • Ta umiejętność działa tylko na nowo powstałe zombie",
		},
		rm = {
			name = "Radykalna terapia",
			info = "Gdy tylko jest to możliwe, tworzysz 2 zombie z 1 ciała\n\t• Jeśli dostępny jest tylko 1 obserwator, tworzysz tylko 1 zombie\n\t• Oba zombie są tego samego typu\n\t• HP drugiego zombie jest zmniejszone o 50%\n\t• Obrażenia drugiego zombie są zmniejszone o 25%",
		},
		doc1 = {
			name = "Chirurgiczna precyzja I",
			info = "Czas operacji skraca się o 5 sekund",
		},
		doc2 = {
			name = "Chirurgiczna precyzja II",
			info = "SCzas operacji skraca się o 5 sekund\n\t• Całkowite skrócenie czasu operacji: 10s",
		},
	}
}

wep.SCP0492 = {
	too_far = "Stajesz się słabszy!"
}

wep.SCP066 = {
	wait = "Następny atak za: %is",
	ready = "Atak gotowy!",
	chargecd = "Czas odnowienia doskoku: %is",
	upgrades = {
		range1 = {
			name = "Rezonans I",
			info = "Zasięg obrażeń zostaje zwiększony o 75",
		},
		range2 = {
			name = "Rezonans II",
			info = "Zasięg obrażeń zostaje zwiększony o 75\n\t• Całkowity wzrost: 150",
		},
		range3 = {
			name = "Rezonans III",
			info = "Zasięg obrażeń zostaje zwiększony o 75\n\t• Całkowity wzrost: 225",
		},
		damage1 = {
			name = "Bass I",
			info = "Obrażenia zwiększone do 112,5%, ale zasięg zmniejszony do 90%",
		},
		damage2 = {
			name = "Bass II",
			info = "Obrażenia zwiększone do 135%, ale zasięg zmniejszony do 75%",
		},
		damage3 = {
			name = "Bass III",
			info = "Obrażenia zwiększone do 200%, ale zasięg zmniejszony do 50%",
		},
		def1 = {
			name = "Fala negacji I",
			info = "Podczas puszczania muzyki negujesz 10% nadchodzących obrażeń",
		},
		def2 = {
			name = "Fala negacji II",
			info = "Podczas puszczania muzyki negujesz 25% nadchodzących obrażeń",
		},
		charge = {
			name = "Doskok",
			info = "Odblokowuje możliwość doskoku do przodu, naciskając klawisz przeładowania\n\t• Czas odnowienia umiejętności: 20 s",
		},
		sticky = {
			name = "Lepki",
			info = "Po wskoczeniu w człowieka trzymasz się go przez następne 10 sekund",
		}
	}
}

wep.SCP058 = {
	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Jadowite żądło I",
			info = "Dodaje truciznę do podstawowego ataku"
		},
		attack2 = {
			name = "Jadowite żądło II",
			info = "Zwiększa obrażenia trucizny i skraca czas odnowienia ataku. \n\t• Dodaje [prim_dmg] obrażeń do ataku\n\t• Atak trucizną zadaje [pp_dmg] obrażeń\n\t• Czas odnowienia zostaje zmniejszony o [prim_cd]s"
		},
		attack3 = {
			name = "Jadowite żądło III",
			info = "Zwiększa obrażenia trucizny i skraca czas odnowienia ataku.\n\t• Jeśli cel nie jest zatruty, natychmiast nakłada 2 stosy trucizny\n\t• Atak trucizną zadaje [pp_dmg] obrażeń\n\t• Czas odnowienia zostaje zmniejszony o [prim_cd]s"
		},
		shot = {
			name = "Skorumpowana Krew",
			info = "Dodaje truciznę do ataków strzałami"
		},
		shot11 = {
			name = "Surge I",
			info = "Zwiększa obrażenia i rozmiar pocisku, ale także wydłuża czas odnowienia i spowalnia pocisk\n\t• Mnożnik obrażeń od pocisków zostaje zwiększony do: [shot_damage]\n\t• Mnożnik wielkości pocisku zostaje zwiększony do: [shot_size]\n\t• Mnożnik prędkości pocisku zostaje zwiększony do: [shot_size]\n\t• Całkowity czas odnowienia zwiększony o [shot_cd]s"
		},
		shot12 = {
			name = "Surge II",
			info = "Zwiększa obrażenia i rozmiar pocisku, ale także wydłuża czas odnowienia i spowalnia pocisk\n\t• Efekt trucizny zostaje usunięty\n\t• Mnożnik obrażeń od pocisków zostaje zwiększony do: [shot_damage]\n\t• Mnożnik wielkości pocisku zostaje zwiększony do: [shot_size]\n\t• Mnożnik prędkości pocisku zostaje zwiększony do: [shot_size]\n\t• Całkowity czas odnowienia zwiększony o [shot_cd]s"
		},
		shot21 = {
			name = "Krwawa mgła I",
			info = "Strzał pozostawia po uderzeniu mgłę, raniąc i zatruwając każdego, kto jej dotknie.\n\t• Usuwane są obrażenia bezpośrednie i obszarowe\n\t• Obrażenia chmury wynoszą: [cloud_damage] obrażeń przy kontakcie\n\t• Trucizna zadawana przez chmure wynosi: [sp_dmg] obrażeń\n\t• Stosy strzałów ograniczone do [stacks]\n\t• Czas odnowienia zwiększony o [shot_cd]s\n\t• Stosy są generowane przy mnożniku: [regen_rate]"
		},
		shot22 = {
			name = "Krwawa mgła II",
			info = "Podkręca obrażenia zadawane przez mgłe.\n\t• Obrażenia chmury wynoszą: [cloud_damage] obrażeń przy kontakcie\n\t• Trucizna zadawana przez chmure: [sp_dmg] obrażeń\n\t• Stosy są generowane przy mnożniku: [regen_rate]"
		},
		shot31 = {
			name = "Multishot I",
			info = "Pozwala na strzelanie z dużą prędkością podczas trzymania przycisku ataku.\n\t• Odblokowuje możliwość szybkiego oddawania strzałów\n\t• Usuwane są obrażenia bezpośrednie i obszarowe\n\t• Stosy strzałów ograniczone do [stacks]\n\t• Stosy są generowane przy mnożniku: [regen_rate]\n\t• Mnożnik wielkości pocisku zostaje zwiększony do: [shot_size]\n\t• Mnożnik prędkości pocisku zostaje zwiększony do: [shot_size]"
		},
		shot32 = {
			name = "Multishot II",
			info = "Zwiększa maksymalne stosy i poprawia prędkość strzału.\n\t• Stosy strzałów ograniczone do [stacks]\n\t• Stosy są generowane przy mnożniku: [regen_rate]\n\t• Mnożnik wielkości pocisku zostaje zwiększony do: [shot_size]\n\t• Mnożnik prędkości pocisku zostaje zwiększony do: [shot_size]"
		},
		exp1 = {
			name = "Aortal Burst",
			info = "Odblokowuje umiejętność eksplozji zadającej ogromne obrażenia, gdy ilość hp spadnie poniżej 1000 po raz pierwszy"
		},
		exp2 = {
			name = "Toksyczny wybuch",
			info = "Zwiększa twoją zdolność do eksplozji\n\t• Stosuje 2 stosy trucizny\n\t• Mnożnik promienia zostaje zwiększony do: [explosion_radius]"
		},
	}
}

wep.SCP096 = {
	charges = "Ładunki regeneracji: %i",
	regen = "Regenerowanie HP - ładunki: %i",
	upgrades = {
		sregen1 = {
			name = "Spokojny duch I",
			info = "Zyskujesz jeden ładunek regeneracji co 4 sekundy zamiast 5 sekund"
		},
		sregen2 = {
			name = "Spokojny duch II",
			info = "Twoje ładunki regeneracyjne leczą cię za 6 HP zamiast 5 HP"
		},
		sregen3 = {
			name = "Spokojny duch III",
			info = "Twoja regeneracja jest o 66% szybsza"
		},
		kregen1 = {
			name = "Hannibal I",
			info = "Po udanym zabiciu regenerujesz dodatkowe 90 HP"
		},
		kregen2 = {
			name = "Hannibal II",
			info = "Po udanym zabiciu regenerujesz dodatkowe 90 HP\n\t• Całkowity wzrost leczenia: 180 HP"
		},
		hunt1 = {
			name = "Nieśmiały I",
			info = "Obszar polowań został zwiększony do 4250 jednostek"
		},
		hunt2 = {
			name = "Nieśmiały II",
			info = "Obszar polowań został zwiększony do 5500 jednostek"
		},
		hp = {
			name = "Goliat",
			info = "Twoje maksymalne zdrowie zostanie zwiększone do 4000 HP\n\t• Twoje obecne zdrowie nie jest zwiększone"
		},
		def = {
			name = "Uporczywy",
			info = "Zyskujesz 30% ochrony przed pociskami"
		}
	}
}

wep.SCP106 = {
	swait = "Czas odnowienia umiejętności specjalnej: %is",
	sready = "Specjalna umiejętność jest gotowa!",
	upgrades = {
		cd1 = {
			name = "Spacer pustki I",
			info = "Czas odnowienia zdolności specjalnej zostaje skrócony o 15 sekund"
		},
		cd2 = {
			name = "Spacer pustki II",
			info = "Czas odnowienia zdolności specjalnej zostaje skrócony o 15 sekund\n\t• Całkowity czas odnowienia: 30 s"
		},
		cd3 = {
			name = "Spacer pustki III",
			info = "Czas odnowienia zdolności specjalnej zostaje skrócony o 15 sekund\n\t• Całkowity czas odnowienia: 45 s"
		},
		tpdmg1 = {
			name = "Rozkładający dotyk I",
			info = "Po teleportacji zyskujesz 15 dodatkowych obrażeń na 10 s"
		},
		tpdmg2 = {
			name = "Rozkładający dotyk II",
			info = "Po teleportacji zyskujesz 20 dodatkowych obrażeń na 20 s"
		},
		tpdmg3 = {
			name = "Rozkładający dotyk III",
			info = "Po teleportacji zyskujesz 25 dodatkowych obrażeń na 30 s"
		},
		tank1 = {
			name = "Tarcza łuzowa I",
			info = "Uzyskaj 20% ochrony przed pociskami, ale będziesz o 10% wolniejszy"
		},
		tank2 = {
			name = "Tarcza łuzowa II",
			info = "Uzyskaj 20% ochrony przed pociskami, ale będziesz o 10% wolniejszy\n\t• Całkowita ochrona: 40%\n\t• Całkowite spowolnienie: 20%"
		},
	}
}

wep.SCP173 = {
	swait = "Czas odnowienia umiejętności specjalnej: %is",
	sready = "Specjalna umiejętność jest gotowa!",
	upgrades = {
		specdist1 = {
			name = "Widmo I",
			info = "Zasięg twojej umiejętności specjalnej zostaje zwiększony o 500"
		},
		specdist2 = {
			name = "Widmo II",
			info = "Zasięg twojej umiejętności specjalnej zostaje zwiększony o 700\n\t• Całkowity wzrost: 1200"
		},
		specdist3 = {
			name = "Widmo III",
			info = "Zasięg twojej umiejętności specjalnej zostaje zwiększony o 800\n\t• Całkowity wzrost: 2000"
		},
		boost1 = {
			name = "Pragnienie krwi I",
			info = "Za każdym razem, gdy zabijesz człowieka, zyskasz 150 HP, a czas odnowienia zdolności specjalnej zostanie skrócony o 10%"
		},
		boost2 = {
			name = "Pragnienie krwi II",
			info = "Za każdym razem, gdy zabijesz człowieka, zyskasz 300 HP, a czas odnowienia zdolności specjalnej zostanie skrócony o 25%"
		},
		boost3 = {
			name = "Pragnienie krwi III",
			info = "Za każdym razem, gdy zabijesz człowieka, zyskasz 500 HP, a czas odnowienia zdolności specjalnej zostanie skrócony o 50%"
		},
		prot1 = {
			name = "Betonowa skóra I",
			info = "Natychmiast leczy 1000 HP i zapewnia 10% ochrony przed pociskami"
		},
		prot2 = {
			name = "Betonowa skóra II",
			info = "Natychmiast leczy 1000 HP i zapewnia 10% ochrony przed pociskami\n\t• Całkowita ochrona: 20%"
		},
		prot3 = {
			name = "Betonowa skóra III",
			info = "Natychmiast leczy 1000 HP i zapewnia 20% ochrony przed pociskami\n\t• Total protection: 40%"
		},
	},
	back = "Możesz przytrzymać R, aby wrócić do poprzedniej pozycji",
}

wep.SCP457 = {
	swait = "Czas odnowienia umiejętności specjalnej: %is",
	sready = "Specjalna umiejętność jest gotowa!",
	placed = "Aktywne pułapki: %i/%i",
	nohp = "Za mało HP!",
	upgrades = {
		fire1 = {
			name = "Ludzka pochodnia I",
			info = "Twój zasięg palenia zostaje zwiększony o 25"
		},
		fire2 = {
			name = "Ludzka pochodnia II",
			info = "Twoje obrażenia od ognia zostają zwiększone o 0,5"
		},
		fire3 = {
			name = "Ludzka pochodnia III",
			info = "Twój zasięg palenia jest zwiększony o 50, a twoje obrażenia od ognia o 0,5\n\t• Całkowity wzrost zasięgu: 75\n\t• Całkowity wzrost obrażeń: 1"
		},
		trap1 = {
			name = "Mała niespodzianka I",
			info = "Żywotność pułapki jest zwiększona do 4 minut i będzie się palić 1 s dłużej"
		},
		trap2 = {
			name = "Mała niespodzianka II",
			info = "Trwałość pułapki jest zwiększona do 5 minut i będzie się palić 1 s dłużej, a jej obrażenia zwiększone o 0,5\n\t• Całkowity wzrost czasu palenia: 2s"
		},
		trap3 = {
			name = "Mała niespodzianka III",
			info = "Pułapka będzie się palić 1 s dłużej, a jej obrażenia zostaną zwiększone o 0,5\n\t• Całkowity wzrost czasu palenia: 3 s\n\t• Całkowity wzrost obrażeń: 1"
		},
		heal1 = {
			name = "Skwiercząca przekąska I",
			info = "Płonący ludzie przywracają ci 1 punkt zdrowia"
		},
		heal2 = {
			name = "Skwiercząca przekąska II",
			info = "Płonący ludzie przywracają ci 1 punkt zdrowia\n\t• Całkowity wzrost leczenia: 2"
		},
		speed = {
			name = "Szybki ogień",
			info = "Twoja prędkość wzrasta o 10%"
		}
	}
}

wep.SCP682 = {
	swait = "Czas odnowienia umiejętności specjalnej: %is",
	sready = "Specjalna umiejętność jest gotowa!",
	s_on = "Jesteś odporny na wszelkie obrażenia! %is",
	upgrades = {
		time1 = {
			name = "Niezłomny I",
			info = "Czas trwania twojej zdolności specjalnej wydłuża się o 2,5 s\n\t• Całkowity czas trwania: 12,5 s"
		},
		time2 = {
			name = "Niezłomny II",
			info = "Czas trwania twojej zdolności specjalnej wydłuża się o 2,5 s\n\t• Całkowity czas trwania: 15 s"
		},
		time3 = {
			name = "Niezłomny III",
			info = "Czas trwania twojej zdolności specjalnej wydłuża się o 2,5 s\n\t• Całkowity czas trwania: 17,5 s"
		},
		prot1 = {
			name = "Dostosowanie I",
			info = "Otrzymujesz 10% mniej obrażeń od kul"
		},
		prot2 = {
			name = "Dostosowanie II",
			info = "Otrzymujesz 15% mniej obrażeń od kul\n\t• Całkowita redukcja obrażeń: 25%"
		},
		prot3 = {
			name = "Dostosowanie III",
			info = "Otrzymujesz 15% mniej obrażeń od kul\n\t• Całkowita redukcja obrażeń: 40%"
		},
		speed1 = {
			name = "Wściekły pośpiechI",
			info = "Po użyciu umiejętności specjalnej zyskujesz 10% prędkości ruchu do momentu otrzymania obrażeń"
		},
		speed2 = {
			name = "Wściekły pośpiech II",
			info = "Po użyciu umiejętności specjalnej zyskujesz 20% prędkości ruchu do momentu otrzymania obrażeń"
		},
		ult = {
			name = "Regeneracja",
			info = "5 sekund po otrzymaniu obrażeń regeneruje 5% brakującego zdrowia"
		},
	}
}

wep.SCP8602 = {
	upgrades = {
		charge11 = {
			name = "Brutalność I",
			info = "Obrażenia silnego ataku zostają zwiększone o 5"
		},
		charge12 = {
			name = "Brutalność II",
			info = "Obrażenia silnego ataku zostają zwiększone o 10\n\t• Całkowite zwiększenie obrażeń: 15"
		},
		charge13 = {
			name = "Brutalność III",
			info = "Obrażenia silnego ataku zostają zwiększone o 10\n\t• Całkowite zwiększenie obrażeń: 25"
		},
		charge21 = {
			name = "Szarża I",
			info = "Zasięg silnego ataku zostaje zwiększony o 15"
		},
		charge22 = {
			name = "Szarża II",
			info = "Zasięg silnego ataku zostaje zwiększony o 15\n\t• Całkowite zwiększenie zasięgu: 30"
		},
		charge31 = {
			name = "Wspólny ból",
			info = "Kiedy wykonujesz silny atak, wszyscy w pobliżu punktu uderzenia otrzymają 20% obrażeń"
		},
	}
}

wep.SCP939 = {
	upgrades = {
		heal1 = {
			name = "Żądza krwi I",
			info = "Twoje ataki leczą cię o co najmniej 22,5 HP (do 30)"
		},
		heal2 = {
			name = "Żądza krwi II",
			info = "Twoje ataki leczą cię o co najmniej 37,5 HP (do 50)"
		},
		heal3 = {
			name = "BloodŻądza krwilust III",
			info = "Twoje ataki leczą cię o co najmniej 52,5 HP (do 70)"
		},
		amn1 = {
			name = "Śmiertelny oddech I",
			info = "Twój zasięg trucizny został zwiększony do 100"
		},
		amn2 = {
			name = "Śmiertelny oddech II",
			info = "Twoja trucizna zadaje teraz obrażenia: 1,5 dmg / s"
		},
		amn3 = {
			name = "Śmiertelny oddech III",
			info = "Twój zasięg trucizny zostaje zwiększony do 125, a twoje obrażenia od trucizny zwiększone do 3 dmg / s"
		},
	}
}

wep.SCP966 = {
	upgrades = {
		lockon1 = {
			name = "Szał I",
			info = "Czas potrzebny do ataku jest skrócony do 2,5 s"
		},
		lockon2 = {
			name = "Szał II",
			info = "Czas potrzebny do ataku jest skrócony do 2 s"
		},
		dist1 = {
			name = "Zew łowcy I",
			info = "Zasięg ataku zostaje zwiększony o 15"
		},
		dist2 = {
			name = "Zew łowcy II",
			info = "Zasięg ataku zostaje zwiększony o 15\n\t• Całkowity wzrost zasięgu: 30"
		},
		dist3 = {
			name = "Zew łowcy III",
			info = "Zasięg ataku zostaje zwiększony o 15\n\t• Całkowity wzrost zasięgu: 45"
		},
		dmg1 = {
			name = "Ostre pazury I",
			info = "Obrażenia od ataku zostają zwiększone o 5"
		},
		dmg2 = {
			name = "Ostre pazury II",
			info = "Obrażenia od ataku zostają zwiększone o 5\n\t• Całkowite zwiększenie obrażeń: 10"
		},
		bleed1 = {
			name = "Głębokie rany I",
			info = "Twoje ataki mają 25% szansy na wywołanie krwawienia wyższego poziomu"
		},
		bleed2 = {
			name = "Głębokie rany II",
			info = "Twoje ataki mają 50% szansy na wywołanie krwawienia wyższego poziomu"
		},
	}
}

wep.SCP24273 = {
	mind_control = "Kontrola umysłu jest gotowa! Naciśnij PPM",
	mind_control_cd = "Kontrola umysłu się odnawia! Czas odnowienia: %is",
	dash = "Atak gotowy!",
	dash_cd = "Atak się odnawia! Czas odnowienia: %is",
	upgrades = {
		dash1 = {
			name = "Bezwzględna Szarża I",
			info = "Czas odnowienia twojego ataku zostaje skrócony o 1 sekunde, a jego moc zostaje zwiększona o 15%"
		},
		dash2 = {
			name = "Bezwzględna Szarża II",
			info = "Czas kary po ataku jest zmniejszony o 1 sekundę, a kara do szybkości zmniejszona z 40% do 25%"
		},
		dash3 = {
			name = "Bezwzględna Szarża III",
			info = "Twoje obrażenia od ataku zostają zwiększone o 50"
		},
		mc11 = {
			name = "Wytrwały łowca I",
			info = "Czas trwania kontroli umysłu jest wydłużony o 10 sekund, ale czas odnowienia jest wydłużony o 20 sekund"
		},
		mc12 = {
			name = "Wytrwały łowca II",
			info = "Czas trwania kontroli umysłu jest wydłużony o 10 sekund, ale czas odnowienia jest wydłużony o 25 sekund\n\t• Całkowite wydłużenie czasu trwania: 20s\n\t• Całkowite wydłużenie czasu odnowienia: 45s"
		},
		mc21 = {
			name = "Niecierpliwy łowca I",
			info = "Czas trwania kontroli umysłu zostaje skrócony o 5 sekund, a czas odnowienia skrócony o 10 sekund"
		},
		mc22 = {
			name = "Niecierpliwy łowca II",
			info = "Czas trwania kontroli umysłu zostaje skrócony o 10 sekund, a czas odnowienia skrócony o 15 sekund"
		},
		mc3 = {
			name = "Niezłomny łowca",
			info = "Podczas kontroli umysłu zyskujesz 50% redukcji dla wszystkich rodzajów obrażeń"
		},
		mc13 = {
			name = "Surowy sędzia",
			info = "Zabicie zdobyczy podczas Kontroli Umysłu skraca jej czas odnowienia o 40%. Zasięg kontroli umysłu zostaje zwiększony o 1000 jednostek"
		},
		mc23 = {
			name = "Karmazynowy Sędzia",
			info = "Zabicie zdobyczy podczas Kontroli Umysłu leczy cię o 400 HP. Zasięg kontroli umysłu zostaje zwiększony o 500 jednostek"
		},
	}
}

wep.SCP3199 = {
	special = "Specjalna umiejętność jest gotowa! Naciśnij PPM",
	upgrades = {
		regen1 = {
			name = "Smak krwi I",
			info = "Regeneruje 2 HP na sekundę będąc w Szale"
		},
		regen2 = {
			name = "Smak krwi II",
			info = "Współczynnik regeneracji zdrowia zostaje zwiększony o 10% za każdy ładunek Szału"
		},
		frenzy1 = {
			name = "Gra myśliwego I",
			info = "Twoje maksymalne ładunki Szału są zwiększone o 1\nTwój czas trwania Szału jest zwiększony o 20%"
		},
		frenzy2 = {
			name = "Gra myśliwego II",
			info = "Twoje maksymalne ładunki Szału są zwiększone o 1\nTwój czas trwania Szału jest zwiększony o 30%\nTwój atak specjalny jest wyłączony\n\t• Zwiększenie łącznej liczby ładunków Szału: 2\n\t• Całkowite wydłużenie czasu trwania: 50%"
		},
		ch = {
			name = "Ślepa furia",
			info = "Twoja prędkość wzrasta o 25%\nNie możesz już wykrywać bicia serca pobliskich ludzi"
		},
		egg1 = {
			name = "Kolejny",
			info = "Tworzysz 1 nowe nieaktywne jajko po zakupie tego ulepszenia\n\t• Jajo nie zostanie utworzone, jeśli na mapie nie ma wolnego miejsca na jajko"
		},
		egg2 = {
			name = "Dziedzictwo",
			info = "Jedno z nieaktywnych jaj zostanie aktywowane po zakupie tego ulepszenia\n\t• Nie przyniesie to efektu, jeśli na mapie nie ma nieaktywnego jajka"
		},
		egg3 = {
			name = "Jajko wielkanocne",
			info = "Twój czas odrodzenia został zmniejszony do 20 sekund"
		},
	}
}

wep.SCP500 = {
	name = "SCP 500",
	death_info = "Udławiłeś się SCP 500",
	text_used = "Jak tylko połknąłeś SCP 500, to poczułeś się lepiej",
}

wep.SCP714 = {
	name = "SCP 714"
}

wep.SCP1025 = {
	name = "SCP 1025",
	diseases = {
		arrest = "Zatrzymanie akcji serca",
		mental = "Choroba psychiczna",
		asthma = "Astma",
		blindness = "Ślepota",
		hemo = "Hemofilia",
		oste = "Osteoporoza",

		adhd = "ADHD",
		throm = "Trombocytemia",
		urbach = "Choroba Urbacha-Wiethego",

		gas = "Tympanity",
	},
	descriptions = {
		arrest = "Zatrzymanie krążenia to nagła utrata przepływu krwi wynikająca z niewydolności serca. Objawy obejmują utratę przytomności i nieprawidłowy lub brak oddechu. Niektóre osoby mogą odczuwać ból w klatce piersiowej, duszności lub mdłości bezpośrednio przed wystąpieniem zatrzymania krążenia. Ból promieniujący do jednego ramienia jest częstym objawem, podobnie jak długotrwałe złe samopoczucie i ogólne osłabienie serca. Jeśli nie jest leczony w ciągu kilku minut, zwykle prowadzi do śmierci.",
		asthma = "Astma jest długotrwałą chorobą zapalną dróg oddechowych w płucach. Charakteryzuje się zmiennymi i nawracającymi objawami, odwracalnym upośledzeniem przepływu powietrza oraz łatwo wyzwalanymi skurczami oskrzeli. Objawy obejmują epizody świszczącego oddechu, kaszlu, ucisku w klatce piersiowej i duszności. Mogą one występować kilka razy dziennie lub kilka razy w tygodniu.",
		blindness = "Upośledzenie wzroku, znane również jako upośledzenie widzenia lub utrata wzroku, to obniżona zdolność widzenia w stopniu powodującym problemy, których nie można rozwiązać za pomocą zwykłych środków, takich jak okulary. Wśród nich są również osoby, które mają obniżoną zdolność widzenia, ponieważ nie mają dostępu do okularów lub soczewek kontaktowych. Termin ślepota jest używany w odniesieniu do całkowitej lub prawie całkowitej utraty wzroku.",
		hemo = "Hemofilia (pisana również jako hemofilia) jest najczęściej dziedziczonym zaburzeniem genetycznym, które upośledza zdolność organizmu do tworzenia skrzepów krwi, procesu niezbędnego do zatrzymania krwawienia. Powoduje to u ludzi dłuższe krwawienie po urazie, łatwe powstawanie siniaków i zwiększone ryzyko krwawienia w stawach lub mózgu. Charakterystyczne objawy różnią się w zależności od stopnia nasilenia. Ogólnie rzecz biorąc, objawami są epizody krwawienia wewnętrznego lub zewnętrznego.",
		oste = "Osteoporoza jest ogólnoustrojowym schorzeniem układu kostnego, charakteryzującym się niską masą kostną, mikroarchitektoniczną degradacją tkanki kostnej prowadzącą do kruchości kości, a w konsekwencji do zwiększenia ryzyka złamań. Jest to najczęstsza przyczyna złamania kości u osób starszych. Kości, które często ulegają złamaniu, to kręgi w kręgosłupie, kości przedramienia i biodra. Do momentu wystąpienia złamania kości zazwyczaj nie występują żadne objawy.",
		
		adhd = "Zespół nadpobudliwości psychoruchowej z deficytem uwagi (ADHD) jest zaburzeniem neurorozwojowym charakteryzującym się nieuwagą, nadmierną energią, nadmiernym skupieniem i impulsywnością, które w innych przypadkach nie są odpowiednie dla wieku danej osoby. Niektóre osoby z ADHD wykazują również trudności z regulacją emocji lub problemy z funkcjami wykonawczymi. Dodatkowo jest ona związana z innymi zaburzeniami psychicznymi.",
		throm = "Trombocytemia jest stanem wysokiej liczby płytek krwi (trombocytów) we krwi. Wysoka liczba płytek krwi nie musi sygnalizować żadnych problemów klinicznych i może być wykryta podczas rutynowego badania pełnej morfologii krwi. Ważne jest jednak, aby zebrać pełny wywiad medyczny, aby upewnić się, że zwiększona liczba płytek krwi nie jest spowodowana procesem wtórnym.",
		urbach = "Choroba Urbacha-Wiethego jest bardzo rzadkim recesywnym zaburzeniem genetycznym. Objawy choroby są bardzo różne u poszczególnych osób. Urbach- Choroba Wiethego wykazuje obustronne symetryczne zwapnienia w przyśrodkowych płatach skroniowych. Zwapnienia te często dotyczą jądra migdałowatego. Uważa się, że migdał jest zaangażowany w przetwarzanie biologicznie istotnych bodźców oraz w emocjonalną pamięć długotrwałą, szczególnie tych związanych z lękiem.",
	},
	death_info_arrest = "Umarłeś z powodu zatrzymania akcji serca"
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
	name = "Monitoring",
	showname = "Kamery",
	info = "Kamery pozwalają zobaczyć, co dzieje się w placówce.\nZapewniają również możliwość skanowania obiektów SCP i przesyłania tych informacji na aktualny kanał radiowy",
}

wep.RADIO = {
	name = "Radio",
}

wep.NVG = {
	name = "NVG",
	info = "Gogle noktowizyjne - urządzenie, które rozjaśnia ciemne obszary i jeszcze bardziej rozjaśnia jasne obszary. \nCzasami można zobaczyć przez nie anomalne rzeczy."
}

wep.NVGPLUS = {
	name = "Ulepszone NVG",
	showname = "NVG+",
	info = "Ulepszona wersja NVG, pozwala na używanie ich podczas trzymania w rękach innych przedmiotów.\nNiestety bateria starcza tylko na 10 sekund"
}

wep.ACCESS_CHIP = {
	name = "Chip dostępu",
	cname = "Chip dostępu - %s",
	showname = "CHIP",
	pickupname = "CHIP",
	clearance = "Poziom dostępu: %i",
	hasaccess = "Zapewnia dostęp do:",
	NAMES = {
		general = "Ogólny",
		jan1 = "Woźny",
		jan = "Woźny",
		jan2 = "Starszy woźny",
		acc = "Księgowy",
		log = "Logistyk",
		sci1 = "Naukowiec poziomu 1",
		sci2 = "Naukowiec poziomu 2",
		sci3 = "Naukowiec poziomu 3",
		spec = "Specjalista zabezpieczeń",
		guard = "Ochroniarz",
		chief = "Szef ochrony",
		mtf = "MTF",
		com = "Dowódca MTF",
		hacked3 = "Zhakowana 3",
		hacked4 = "Zhakowana 4",
		hacked5 = "Zhakowana 5",
		director = "Dyrektor Placówki",
		o5 = "O5"
	},
	ACCESS = {
		GENERAL = "Ogólny",
		SAFE = "Safe",
		EUCLID = "Euclid",
		KETER = "Keter",
		OFFICE = "Biuro",
		MEDBAY = "Ambulatorium",
		CHECKPOINT_LCZ = "Checkpoint LCZ-HCZ",
		CHECKPOINT_EZ = "Checkpoint EZ-HCZ",
		WARHEAD_ELEVATOR = "Winda do głowicy",
		EC = "Centrum elektryczne",
		ARMORY = "Zbrojownia",
		GATE_A = "Gate A",
		GATE_B = "Gate B",
		FEMUR = "Femur Breaker",
		ALPHA = "Głowica Alfa",
		OMEGA = "Głowica Omega",
		PARTICLE = "Działo cząsteczkowe",
	},
}

wep.OMNITOOL = {
	name = "Omnitool",
	cname = "Omnitool - %s",
	showname = "OMNITOOL",
	pickupname = "OMNITOOL",
	none = "NONE",
	chip = "Włożony chip: %s",
	clearance = "Poziom dostępu: %i",
	SCREEN = {
		loading = "Ładowanie",
		name = "Omnitool v4.78",
		installing = "Instalowanie nowego chipu...",
		ejecting = "Wysuwanie chipu dostępu...",
		ejectwarn = "Czy na pewno chcesz wysunąć chip?",
		ejectconfirm = "Naciśnij ponownie, aby potwierdzić...",
		chip = "Zainstalowany chip:",
	},
}

wep.MEDKIT = {
	name = "Apteczka (Pozostało ładunków: %d)",
	showname = "Apteczka",
	pickupname = "Apteczka",
}

wep.MEDKITPLUS = {
	name = "Duża apteczka (Pozostało ładunków: %d)",
	showname = "Apteczka+",
	pickupname = "Apteczka+",
}

wep.TASER = {
	name = "Paralizator"
}

wep.FLASHLIGHT = {
	name = "Latarka"
}

wep.BATTERY = {
	name = "Bateria"
}

wep.GASMASK = {
	name = "Maska gazowa",
	showname = "Maska gazowa"
}

wep.TURRET = {
	name = "Wieżyczka",
	pickup = "Podnieś",
	MODES = {
		off = "Wyłącz",
		filter = "Filtruj personel",
		all = "Celuj we wszystko",
		supp = "Ogień zaporowy"
	}
}

wep.ALPHA_CARD1 = {
	name = "Kod nuklearny głowicy ALPHA nr 1"
}

wep.ALPHA_CARD2 = {
	name = "Kod nuklearny głowicy ALPHA nr 2"
}

wep.weapon_stunstick = "Pałka"

registerLanguage( lang, "polish", "polski", "pl" )
