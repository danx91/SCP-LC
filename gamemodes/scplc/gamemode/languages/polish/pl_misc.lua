local lang = LANGUAGE

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Możesz zostać SCP w następnej rundzie (%ix szansa)",
	scpwait = "Musisz poczekać %i rundy aby zagrać jako SCP",
	abouttostart = "Gra rozpocznie się za %i sekund!",
	kill = "Otrzymujesz %d punktów za zabójstwo %s: %s!",
	kill_rdm = "Tracisz %d punktów za zabójstwo %s: %s!",
	kill_n = "Zabiłeś %s: %s!",
	assist = "Otrzymujesz %d punktów za asystę w zabójstwie gracza: %s!",
	assist_rdm = "Tracisz %d punktów za asystę w zabójstwie gracza: %s!",
	kill_supp = "Otrzymujesz %d punktów za pomoc w zabójstwie gracza %s!",
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
	r106used = "Procedura zabezpieczenia SCP-106 może zostać uruchomiona tylko raz na rundę",
	r106eloiid = "Wyłącz elektromagnes ELO-IID, aby rozpocząć procedurę zabezpieczania SCP-106",
	r106sound = "Uruchom transmisję dźwięku, aby rozpocząć procedurę zabezpieczania SCP-106",
	r106human = "W klatce musi znajdować się żywy człowiek, aby rozpocząć procedurę zabezpieczania SCP-106",
	r106already = "SCP-106 jest już zabezpieczony",
	r106success = "Otrzymujesz %i punktów za zabezpieczenie SCP-106!",
	vestpickup = "Podniosłeś pancerz",
	vestdrop = "Upuściłeś pancerz",
	hasvest = "Masz już pancerz na sobie! Użyj swojego EQ, aby go upuścić",
	escortpoints = "Otrzymujesz %i punktów za eskortę sojuszników",
	femur_act = "Femur Breaker został aktywowany...",
	levelup = "Awansowałeś! Twój aktualny poziom: %i",
	healplayer = "Otrzymujesz %i punktów za leczenie innych graczy",
	detectscp = "Otrzymujesz %i punktów za wykrycie SCP",
	upgradepoints = "Otrzymałeś punkt ulepszeń! Naciśnij '%s' aby otworzyć menu ulepszeń SCP",
	omega_detonation = "Detonacja głowicy OMEGA za %i sekund. Wyjdź na powierzchnię lub natychmiastowo udaj się do schronu!",
	alpha_detonation = "Detonacja głowicy ALPHA za %i sekund. Wejdź do placówki lub natychmiastowo udaj się do ewakuacji!",
	alpha_card = "Włożyłeś kartę nuklearną głowicy ALPHA",
	destory_scp = "Otrzymujesz %i punktów za zniszczenie podmiotu SCP!",
	afk = "Jesteś AFK. Nie będziesz się odradzał ani otrzymywał expa",
	afk_end = "Nie jesteś już AFK",
	overload_cooldown = "Poczekaj %i sekund aby przeciążyć te drzwi!",
	advanced_overload = "Te drzwi wydają się być za mocne! Spróbuj ponownie za %i sekund",
	lockdown_once = "Blokada placówki może być aktywowana tylko raz na runde",
	dailybonus = "Pozostały dzienny bonus: %i XP\nNastępny reset za: %s",
	xp_goc_device = "Otrzymujesz %i doświadczenia za pomyślne uruchomienie urządzenia GOC",
	goc_device_destroyed = "Otrzymujesz %i punktów za zniszczenie urządzenia GOC!",
	goc_detonation = "Detonacja głowic ALPHA i OMEGA za %i sekund. Natychmiast udaj się do punktu ewakuacji albo schronu!",
	fuserating = "Potrzebujesz mocniejszego bezpiecznika!",
	nofuse = "Aby móc korzystać z tego urządzenia, potrzebny jest bezpiecznik",
	cantremfuse = "Bezpiecznik przegrzewa się – jest zbyt gorący, aby go wyjąć!",
	fusebroken = "Bezpiecznik jest uszkodzony i przyspawany w miejscu!",
	nopower = "Nacisnąłeś przycisk, ale nic się nie stało...",
	nopower_omni = "Przyłożyłeś omnitool do czytnika, ale nic się nie stało...",
	docs = "Otrzymałeś %i punktów za ucieczkę z %i dokumentami",
	docs_pick = "Zdobyłeś cenne dokumenty Fundacji SCP - ucieknij z nimi, aby otrzymać nagrodę!",
	gaswarn = "Dekontaminacja %s za 60 sekund",
	queue_alive = "Jesteś żywy",
	queue_not = "Nie jesteś w kolejce do wsparcia!",
	queue_low = "Znajdujesz się w kolejce wsparcia o niskim priorytecie!",
	queue_pos = "Twoja pozycja w kolejce wsparcia: %i",
	support_optout = "Nie pojawiłeś się jako wsparcie, ponieważ zrezygnowałeś. Możesz to zmienić w !settings",
	zombie_optout = "Nie pojawiłeś się jako SCP-049-2, ponieważ zrezygnowałeś. Możesz to zmienić w !settings",
	preparing_classd = "Zostałeś Klasą D ponieważ dołaczyłeś podczas rozgrzewki. Możesz to zmienić w !settings",
	property_dmg = "Straciłeś %d punktów za zniszczenie własności Fundacji!",
	unknown_cmd = "Nieznane polecenie: %s",
	tailor_success = "Udało ci się ukraść identyfikator. Uważaj, niedługo straci on swoją ważność!",
	tailor_fail = "Nie udało ci się znależć identyfikatora tej osoby!",
	tailor_end = "Ukradziony identyfikator stracił ważność!",
	karma = "Twoja ocena karmy: %s"
}

lang.NFailed = "Nie udało się uzyskać dostępu do NRegistry z kluczem: %s"

--[[-------------------------------------------------------------------------
Round Stats
---------------------------------------------------------------------------]]
lang.ROUND_STATS = {
	recontain106 = "SCP-106 has been recontained",
	omega_warhead = "Omega warhead has been detonated",
	alpha_warhead = "Alpha warhead has been detonated",
	goc_warhead = "GOC device has been activated",

	total_kills = "Zabici gracze: %i",
	total_rdms = "Zabójstwa RDM: %i",
	total_damage = "Zadane obrażenia: %i",
	total_rdm_damage = "Obrażenia RDM: %i",
	total_escapes = "Łącznie uciekinierów: %i",
	total_escorts = "Łącznie odeskortowanych: %i",

	bleeding = "Obrażenia od krwawienia: %i",
	poison = "Obrażenia od trucizny: %i",

	scp_023 = "Gracze zabici przez SCP-023: %i",
	scp_049 = "Gracze wyleczeni przez SCP-049: %i",
	scp_0492 = "Gracze zmasakrowani przez zombie: %i",
	scp_058 = "Gracze zabici przez SCP-058: %i",
	scp_066 = "Ilość zagranych arcydzieł przez SCP-066: %i",
	scp_096 = "Gracze zabici przez nieśmiałego typa: %i",
	scp_106 = "Gracze przeteleportowani do wymiaru łuzowego: %i",
	scp_173 = "Złamane karki: %i",
	scp_457 = "Gracze spaleni żywcem przez SCP-457: %i",
	scp_682 = "Gracze zabici przez przerośniętego jaszczura: %i",
	scp_8602 = "Gracze zabici przez SCP-860-2: %i",
	scp_939 = "Ofiary SCP-939: %i",
	scp_966 = "Uspani gracze: %i",
	scp_3199 = "Zabójstwa dokonane przez SCP-3199: %i",
	scp_24273 = "Osądy wydane przez SCP-2427-3: %i",
}

local team_groups = {
	scp = "SCP",
	staff = "personel",
	classd_ci = "buntowników",
	goc = "GOC",
}

local stat_types = {
	_kills = "Zabójstwa przez ",
	_rdm = "RDMy przez ",
	_dmg = "Obrażenia zadane przez ",
	_rdmdmg = "Obrazenia bratobójcze ",
	_escape = "Eskorty przez ",
	_escort = "Odeskortowani ",
}

for group, name in pairs( team_groups ) do
	for suffix, text in pairs( stat_types ) do
		lang.ROUND_STATS[group..suffix] = text..name..": %i"
	end
end

--[[-------------------------------------------------------------------------
Round Summary
---------------------------------------------------------------------------]]
lang.ROUND_SUMMARY = {
	round_end = "Koniec rundy!",
	no_winner = "Brak zwucięzców w tej rundzie!",
	score = "Wynik",
	mvp = "MVP",
	no_stats = "Brak statystyk do pokazania",
	skip = "Naciśnij [%s] aby pominąć podsumowanie"
}

--[[-------------------------------------------------------------------------
Round intro
---------------------------------------------------------------------------]]
lang.ROUND_INFO = {
	round_type = "Typ rundy",
	round_modifiers = "Modyfikatory",
	round_rules = "Zasady",
	round_rules_long = "Aktywne zasady rundy",

	no_modifiers = "Brak modyfikatorów",
	no_modifiers_desc = "W tej rundzie nie ma aktywnych modyfikatorów - wszystkie wartości pozostają na podstawowym poziomie.",

	no_rules = "Brak zasad",
	no_rules_desc = "Brak specjalnych zasad rozgrywki w tej rundzie.",

	modifier_levels = {
		unchanged = "Bez zmian",
		vlow = "Bardzo niski",
		low = "Niski",
		normal_up = "Normalny (+)",
		normal_down = "Normalny (-)",
		high = "Wysoki",
		vhigh = "Bardzo wysoki",
	},
}

--[[-------------------------------------------------------------------------
Round modifiers
---------------------------------------------------------------------------]]
lang.ROUND_TYPES = {
	["default"] = {
		name = "Containment Breach",
		desc = MarkupBuilder()
			:Print( "Jest to " ):Print( "standardowa runda", Color( 200, 200, 0 ) ):Print( ", która dosztarcza zbalansowanej rozgrywki. Ta runda nie posiada żadnych specjalnych zmian." )
			:ToString(),
	},
	["multi"] = {
		name = "MultiBreach",
		desc = MarkupBuilder()
			:Print( "Jest to " ):Print( "runda MultiBreach", Color( 200, 200, 0 ) ):Print( ". Posiada takie same zasady jak " ):Print( "stadardowa runda", Color( 200, 200, 0 ) )
			:Print( " ale " ):Print( "wszystkie SCP są takie same", Color( 200, 200, 0 ) ):Print( "." )
			:ToString(),
	},
}

--[[-------------------------------------------------------------------------
Round modifiers
---------------------------------------------------------------------------]]
lang.ROUND_MODIFIERS = {
	["loot-value"] = {
		name = "Wartość lootu",
		desc = MarkupBuilder()
			:Print( "Ten modyfikator zmienia ilość " ):Print( "luźnych przedmiotów", Color( 200, 200, 0 ) ):Print( " oraz " ):Print( "przedmiotów w kontenerach", Color( 200, 200, 0 ) )
			:Print( "." )
			:ToString(),
	},
	["health-value"] = {
		name = "Wartość zdrowia",
		desc = MarkupBuilder()
			:Print( "Ten modyfikator zmienia wartosć " ):Print( "zdrowia", Color( 200, 200, 0 ) ):Print( " dla wszystkich klas, w tym SCP" )
			:ToString(),
	},
	["light-value"] = {
		name = "Poziom oświetlenia",
		desc = MarkupBuilder()
			:Print( "Ten modyfikator zmienia " ):Print( "jasność oświetlenia", Color( 200, 200, 0 ) ):Print( " na całej mapie." )
			:ToString(),
	},
	["time-value"] = {
		name = "Anomalia czasowa",
		desc = MarkupBuilder()
			:Print( "Ten modyfikator wpłwa na " ):Print( "prędkość czasu", Color( 200, 200, 0 ) ):Print( " podczas trwania całej rundy." )
			:ToString(),
	},
	["gravity-value"] = {
		name = "Anomalia grawitacyjna",
		desc = MarkupBuilder()
			:Print( "Ten modyfikator wpływa na " ):Print( "siłę grawitacji", Color( 200, 200, 0 ) ):Print( " na całej mapie." )
			:ToString(),
	},
}

--[[-------------------------------------------------------------------------
Round rules
---------------------------------------------------------------------------]]
lang.ROUND_RULES = {
	["melee-only"] = {
		name = "Broń biała",
		desc = MarkupBuilder()
			:Print( "Podczas tej rundy, cała " ):Print( "broń zasięgowa", Color( 200, 200, 0 ) ):Print( " jest zastąpiona " ):Print( "bronią białą", Color( 200, 200, 0 ) )
			:Print( ". Ta zasada wpływa zarówno na początkowe przedmioty klas, przedmioty na mapie oraz przedmioty w kontenerach." )
			:ToString(),
	},
	["lifesteal-only"] = {
		name = "Kradzież życia",
		desc = MarkupBuilder()
			:Print( "Podczas tej rundy, całe " ):Print( "leczenie jest wyłączone", Color( 200, 200, 0 ) ):Print( " dla wszystkich graczy (poza SCP)." )
			:Print( " Dodatkowo, "):Print( "zadawanie poprawnych obrażeń leczy o procent wartości zadanych obrażeń", Color( 200, 200, 0 )  )
			:Print( " (SCP są wykluczone w obie strony)." )
			:ToString(),
	},
	["no-armor"] = {
		name = "Brak pancerzy",
		desc = MarkupBuilder()
			:Print( "Ta zasada " ):Print( "usuwa wszystkie pancerze", Color( 200, 200, 0 ) ):Print( ". Dotyczy to zarówno ekwipunku klas jak i przedmiotów na mapie." )
			:ToString(),
	},
	["disable-tesla"] = {
		name = "Wyłączone tesle",
		desc = MarkupBuilder()
			:Print( "Wszytkie tesle są " ):Print( "wyłączone", Color( 200, 200, 0 ) ):Print( " w tej rundzie." )
			:ToString(),
	},
}

--[[-------------------------------------------------------------------------
Main menu
---------------------------------------------------------------------------]]
local main_menu = {}
lang.MenuScreen = main_menu

main_menu.start = "Rozpocznij"
main_menu.settings = "Ustawienia"
main_menu.precache = "Załaduj modele"
main_menu.credits = "Autorzy"
main_menu.quit = "Wyjdź"

main_menu.quit_server = "Wyjść z serwera?"
main_menu.quit_server_confirmation = "Jesteś pewien?"
main_menu.model_precache = "Załaduj modele"
main_menu.model_precache_text = "Modele są wstępnie wczytywane automatycznie, gdy jest to wymagane, ale dzieje się to podczas rozgrywki, więc może powodować lekkie ścinki. Aby tego uniknąć, możesz je teraz wstępnie buforować.\nTwoja gra może się chwilowo zawiesić podczas tego procesu!"
main_menu.yes = "Tak"
main_menu.no = "Nie"
main_menu.all = "Załaduj modele"
main_menu.cancel = "Anuluj"


main_menu.credits_text = [[Tryb stworzony przez ZGFueDkx (aka danx91)
Tryb jest oparty na SCP i wydany na licencji CC BY-SA 3.0

Animacje menu są stworzone przez Madow

Modele:
	Alski - strażnicy, omnitool, wieżyczka i nie tylko
	Slusher - SCP-689, drzwi, tablet i nie tylko

Materiały:
	Foer - Logo trybu i kilka innych grafik
	SCP Containment Breach

Dźwięki:
	SCP Containment Breach

Główni tłumacze:
	Chinese - xiaobai
	German - Justinnn
	Korean - joon00
	Polish - Slusher, Alski
	Russian - Deiryn, berry
	Turkish - Akane

Specjalne podziękowania:
	1000 Shells za pomoc z modelami
	PolishLizard za hosting serwera testowego
]]
--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "Podnieś"
hud.class = "Klasa"
hud.team = "Drużyna"
hud.class_points = "Punkty Klas"
hud.prestige_points = "Punkty Prestiżu"
hud.hp = "HP"
hud.stamina = "ENERGIA"
hud.sanity = "PSYCHIKA"
hud.xp = "PD"
hud.extra_hp = "Dodatkowe HP"

hud.escaping = "Uciekanie..."
hud.escape_blocked = "Ucieczka zablokowana!"
hud.waiting = "Oczekiwanie na graczy"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
local eq = {}
lang.EQ = eq

eq.eq = "Ekwipunek"
eq.actions = "Akcje"
eq.backpack = "Plecak"
eq.id = "To jest Twoje ID, pokaż je innym, aby ujawnić swoją klasę i drużynę"
eq.no_id = "Nie posiadasz ID"
eq.class = "Twoja klasa: "
eq.team = "Twoja drużyna: "
eq.p_class = "Twoja fałszywa klasa: "
eq.p_team = "Twoja fałszywa drużyna: "
eq.allies = "Twoi sojusznicy:"
eq.durability = "Wytrzymałość: "
eq.mobility = "Mobilność: "
eq.weight = "Waga: "
eq.weight_unit = "KG"
eq.multiplier = "Mnożnik obrażeń:"
eq.count = "Ilość"

lang.eq_unknown = "Nieznany przedmiot"
lang.durability = "Wytrzymałość"
lang.info = "Informacje"

lang.eq_buttons = {
	escort = "Eskortuj",
	gatea = "Detonuj Gate A"
}

lang.pickup_msg = {
	max_eq = "Twój ekwipunek jest pełny!",
	cant_stack = "Nie możesz nieść większej ilości tego przedmiotu!",
	has_already = "Już posiadasz ten przedmiot!",
	same_type = "Już posiadasz przedmiot tego samego typu!",
	max_type = "Osiągnąłeś limit przedmiotów tego typu!",
	one_weapon = "Możesz nosić tylko jedną broń palną na raz!",
	goc_only = "Tylko jednostki GOC mogą to podnieść!"
}

--[[-------------------------------------------------------------------------
XP Bar
---------------------------------------------------------------------------]]
lang.XP_BAR = {
	general = "Ogólne doświadczenie",
	round = "Granie na serwerze",
	escape = "Ucieczka z placówki",
	score = "Punktacja zdobyta podczas rundy",
	win = "Wygranie rundy",
	vip = "Bonus VIP",
	daily = "Bonus dzienny",
	cmd = "Boska moc",
}

--[[-------------------------------------------------------------------------
AFK Warning
---------------------------------------------------------------------------]]
lang.AFK = {
	afk = "Jesteś AFK!",
	afk_warn = "Ostrzeżenie AFK",
	slay_warn = "Niedługo zostaniesz zabity i oznaczony jako AFK!",
	afk_msg = "Nie będziesz się odradzać jako wsparcie oraz na początku rundy!",
	afk_action = "-- Nacisnij dowolny klawisz aby stać się aktywnym --",
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "perm"
effects.bleeding = "Krwawienie"
effects.doorlock = "Blokowanie Drzwi"
effects.amnc227 = "AMN-C227"
effects.insane = "Szaleństwo"
effects.gas_choke = "Duszenie"
effects.radiation = "Radiacja"
effects.deep_wounds = "Głębokie Rany"
effects.poison = "Trucizna"
effects.heavy_bleeding = "Silne Krwawienie"
effects.light_bleeding = "Lekkie Krwawienie"
effects.spawn_protection = "Ochrona Początkowa"
effects.fracture = "Złamanie"
effects.decay = "Rozkład"
effects.scp_chase = "Pościg"
effects.human_chase = "Ucieczka"
effects.expd_all = "Eksperymentalny Efekt"
effects.expd_recovery = "Regeneracja"
effects.electrical_shock = "Porażenie Prądem"
effects.scp009 = "SCP-009"
effects.scp106_withering = "Obumieranie"
effects.scp966_effect = "Wyczerpanie"
effects.scp966_mark = "Znak Śmierci"
effects.ephedrine = "Efedryna"
effects.hemostatic = "Hemostatyk"
effects.antidote = "Antidotum"
effects.poison_syringe = "Trucizna"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Katalog klas"
lang.preview = "Podgląd"
lang.random = "Losowo"
lang.buy = "Kup"
lang.buy_prestige = "Kup za Prestiż"
lang.refund = "Zwróć"
lang.prestige = "Prestiż"
lang.prestige_warn = "Zaraz osiągniesz prestiż. Ten proces zresetuje Twój poziom, XP, punkty klasy i odblokowane klasy, a ty otrzymasz 1 punkt prestiżu.\n\nOSTRZEŻENIE: Tej akcji nie można cofnąć!"
lang.none = "Brak"
lang.refunded = "Wszystkie usunięte klasy zostały zwrócone. Otrzymałeś %d punktów klas."
lang.tierlocked = "Musisz kupić każdą klasę z poprzedniego tieru, aby odblokować klasy z tego tieru (również klasy z innych kategorii)"
lang.xp = "XP"
lang.level = "Poziom"

lang.details = {
	details = "Szczegóły",
	prestige = "Nagroda za Prestiż",
	name = "Nazwa",
	tier = "Tier",
	team = "Drużyna",
	walk_speed = "Szybkość chodzenia",
	run_speed = "Szybkość biegania",
	chip = "Chip dostępu",
	persona = "Fałszywa tożsamość",
	loadout = "Broń główna",
	weapons = "Przedmioty",
	class = "Klasa",
	hp = "Życie",
	speed = "Szybkość",
	health = "Życie",
	sanity = "Psychika",
	slots = "Sloty wsparcia",
	no_select = "Nie pojawia się na początku rundy",
}

lang.headers = {
	support = "WSPARCIE",
	classes = "KLASY",
	scp = "SCP"
}

lang.view_cat = {
	classd = "Klasa D",
	sci = "Naukowcy",
	guard = "Ochrona",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alfa-1",
	ci = "Chaos Insurgency",
	goc = "GOC",
}

local l_weps = {
	pistol = "Pistolet",
	smg = "SMG",
	rifle = "Karabin",
	shotgun = "Strzelba",
	sniper = "Snajperka"
}

local l_tiers = {
	low = "niskiego poziomu",
	mid = "średniego poziomu",
	high = "wysokiego poziomu",
}

lang.loadouts = {
	grenade = "Losowy granat",
	pistol_all = "Losowy pistolet",
	smg_all = "Losowe SMG",
	rifle_all = "Losowy karabin",
	shotgun_all = "Losowa strzelba",
}

for k_wep, wep in pairs( l_weps ) do
	for k_tier, tier in pairs( l_tiers ) do
		lang.loadouts[k_wep.."_"..k_tier] = wep.." "..tier
	end
end

--[[-------------------------------------------------------------------------
Settings
---------------------------------------------------------------------------]]
lang.settings = {
	settings = "Ustawienia trybu gry",

	none = "BRAK",
	press_key = "> Wciśnij przycisk <",
	client_reset = "Przywróć ustawienia domyślne klienta",
	server_reset = "Przywróć ustawienia domyślne serwera",

	client_reset_desc = "Zaraz zresetujesz swoje WSZYSTKIE ustawienia w tym trybie gry.\nTej czynności nie można cofnąć!",
	server_reset_desc = "Ze względów bezpieczeństwa nie możesz tutaj zresetować ustawień serwera.\nAby zresetować serwer do ustawień domyślnych, wpisz 'slc_factory_reset' w konsoli serwera i postępuj zgodnie z instrukcjami.\nUważaj, tej czynności nie da się cofnąć i zresetuje WSZYSTKO!",

	popup_ok = "OK",
	popup_cancel = "ANULUJ",
	popup_continue = "KONTYNUUJ",

	enabled = "Aktywne",
	resource_warn = "Z powodu działania tekstur w Garry's Modzie, te zmiany aktywują się po ponownym dołączeniu na serwer.",

	panels = {
		binds = "Klawiatura",
		general_config = "Ogólne ustawienia",
		hud_config = "Konfiguracja HUD-u",
		performance_config = "Wydajność",
		scp_config = "Ustawienia SCP",
		skins = "Skórki GUI",
		resource_packs = "Paczki zasobów",
		reset = "Reset trybu gry",
		cvars = "Edytor ConVarów",
	},

	binds = {
		eq_button = "Ekwipunek",
		upgrade_tree_button = "Drzewko umiejętności SCP",
		ppshop_button = "Przeglądaj klasy",
		settings_button = "Ustawienia trybu gry",
		scp_special = "Specjalne umiejętności SCP",
		skip_summary_button = "Pomiń podsumowanie rundy",
	},

	config = {
		search_indicator = "Wskaźnik przeszukiwania",
		scp_hud_skill_time = "Pokaż czas odnowienia umiejętności SCP",
		smooth_blink = "Płynne mruganie",
		scp_hud_overload_cd = "Pokaż czas odnowienia przeciążenia",
		any_button_close_search = "Zamknij menu przeszukania dowolnym klawiszem",
		hud_hitmarker = "Hitmarkery",
		hud_hitmarker_mute = "Wycisz hitmarkery",
		hud_damage_indicator = "Wskaźniki obrażeń",
		scp_hud_dmg_mod = "Pokaż modyfikator obrażeń SCP",
		scp_nvmod = "Zwiększ jasność ekranu podczas grania jako SCP",
		dynamic_fov = "Dynamiczny FOV",
		hud_draw_crosshair = "Pokaż celownik",
		hud_hl2_crosshair = "Celownik z HL2",
		hud_lq = "Obrazy i geometria o niskiej jakości (jeśli to możliwe)",
		hud_image_poly = "Obrazy zamiast geometrii (jeśli to możliwe)",
		hud_windowed_mode = "Przesunięcie HUD (dla trybu okienkowego)",
		hud_avoid_roman = "Unikaj cyfr rzymskich",
		hud_escort = "Pokaż strefy eskorty",
		hud_timer_always = "Zawsze pokazuj czas",
		hud_stamina_always = "Zawsze pokazuj wytrzymałość",
		hud_show_round_summary = "Pokaż podsumowanie rundy",
		hud_show_round_info = "Tryb informacji o rundzie",
		hud_round_info_modified = "Ukryj niezmienione modyfikatory w informacji o rundzie",
		eq_instant_desc = "Natychmiastowy opis przedmiotu w EQ",
		scp106_spots = "Zawsze pokazuj miejsca teleportacji SCP-106",

		cvar_slc_support_optout = "Zrezygnuj z grania jako wsparcie",
		cvar_slc_zombie_optout = "Zrezygnuj z grania jako SCP-049-2",
		cvar_slc_preparing_classd = "Zostań Klasą D jeżeli dołączono podczas rozgrzewki",
		cvar_slc_language = "Język",
		cvar_slc_language_options = {
			default = "Domyślny",
		},
		cvar_slc_hud_scale = "Skala HUD",
		cvar_slc_hud_scale_options = {
			normal = "Normalna",
			big = "Duża",
			vbig = "Bardzo duża",
			small = "Mała",
			vsmall = "Bardzo mała",
			imretard = "Minimalna",
		},

		hud_skin_main = "Główny",
		hud_skin_scoreboard = "Tablica wyników",
		hud_skin_hud = "HUD",
		hud_skin_eq = "Ekwipunek",
		hud_skin_round_summary = "Podsumowanie rundy",

		hud_skin_main_options = {
			custom = "Niestandardowy",
			default = "Domyślny",
			legacy = "Przestarzały",
		},

		hud_show_round_info_options = {
			fullscreen = "Pełny ekran",
			side = "Widok boczny",
			hidden = "Ukryte",
		},
	},
}

lang.gamemode_config = {
	loading = "Ładowanie...",

	categories = {
		general = "Ogólne",
		round = "Runda",
		xp = "XP",
		support = "Wsparcie",
		warheads = "Głowice",
		afk = "AFK",
		time = "Czas",
		premium = "Premium",
		scp = "SCP",
		gas = "Gaz",
		feature = "Dodatki",
		minigames = "Minigry",
	}
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Niepołączony"

lang.scoreboard = {
	name = "Tablica wyników",
	playername = "Nazwa",
	ping = "Ping",
	level = "Poziom",
	score = "Wynik",
	ranks = "Rangi",
	badges = "Odznaki",
}

lang.scoreboard_actions = {
	copy_name = "Kopiuj nazwę",
	copy_sid = "Kopiuj SteamID",
	copy_sid64 = "Kopiuj SteamID64",
	open_profile = "Otwórz profil Steam",
}

lang.ranks = {
	superadmin = "Superadmin",
	admin = "Admin",
	author = "Autor",
	vip = "VIP",
	contributor = "Contributor",
	translator = "Tłumacz",
	tester = "Tester",
	patron = "Patron",
	hunter = "Łowca błędów"
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
lang.SCPHUD = {
	skill_not_ready = "Umiejętność się odnawia!",
	skill_cant_use = "Umiejętność nie może być teraz użyta!",
	overload_cd = "Następne przeciążenie: ",
	overload_ready = "Przeciążenie gotowe!",
	damage_scale = "Otrzymane obrażenia"
}

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
	escape2 = "Uciekłeś podczas odliczania głowicy ALPHA",
	escape3 = "Przeżyłeś w schronie przeciwwybuchowym",
	escorted = "Zostałeś odeskortowany",
	killed_by = "Zostałeś zabity przez: %s",
	suicide = "Popełniłeś samobójstwo",
	unknown = "Przyczyna twojej śmierci jest nieznana",
	hazard = "Zostałeś zabity przez zagrożenie",
	alpha_mia = "Ostatnia znana lokalizacja: Powierzchnia",
	omega_mia = "Ostatnia znana lokalizacja: Placówka",
	scp914_death = "Twoje serce zostało zatrzymane przez SCP-914",
	killer_t = "Drużyna twojego zabójcy: %s"
}

lang.info_screen_type = {
	alive = "Żywy",
	escaped = "Uciekłeś",
	dead = "Martwy",
	mia = "Zaginiony w akcji",
	unknown = "Nieznany",
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "Nic"
lang.exit = "Wyjdź"
lang.default = "Domyślny"
lang.yes = "Tak"
lang.no = "Nie"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.escort_zone = "Strefa eskorty"

misc.content_checker = {
	title = "Zawartość trybu",
	status = "Status",
	auto_check = "Uruchamiaj automatycznie",
	slist = {
		"Wyłączony",
		"Sprawdzanie",
		"Montowanie",
		"Pobieranie",
		"Gotowe",
	},
	btn_workshop = "Warsztat Steam",
	btn_download = "Pobierz",
	btn_check = "Sprawdź & Pobierz",
	allok = "Wszystkie dodatki są zainstalowane!",
	nsub_warn = "Nie posiadasz niektórych dodatków! Tryb pobrał i zamontował je dla Ciebie. Jednak, mimo wszystko prosimy o zasubskrybowanie ręcznie wymaganych dodatków. Ich lista znajduje się w konsoli.",
	disabled_warn = "Niektóre z twoich dodatków są wyłączone. Tryb zamontował je tym razem, ale dalej mogą pojawiać się brakujące elementy. Włącz wymagane dodatki w menu głównym (lista w konsoli)",
	missing = "Brakujące dodatki",
	disabled = "Wyłączone dodatki",
}

misc.omega_warhead = {
	idle = "Głowica OMEGA jest bezczynna\n\nOczekiwanie na sygnał...",
	waiting = "Głowica OMEGA jest bezczynna\n\nSygnał zaakceptowany!\nOczekiwanie na drugi sygnał...",
	failed = "Głowica OMEGA jest zablokowana\n\nNie wykryto drugiego sygnału!\nCzekaj %is",
	no_remote = "Aktywacja głowicy OMEGA nie powiodła się\n\nNie udało się nawiązać połączenia z głowicą!\t",
	active = "Głowica OMEGA aktywowana\n\nNatychmiastowo przystąp do ewakuacji!\nDetonacja za %.2fs",
}

misc.alpha_warhead = {
	idle = "Głowica ALPHA jest bezczynna\n\nOczekiwanie na kody nuklearne...",
	ready = "Głowica ALPHA jest bezczynna\n\nKody zaakceptowane!\nOczekiwanie na aktywację...",
	no_remote = "Aktywacja głowicy ALPHA nie powiodła się\n\nNie udało się nawiązać połączenia z głowicą!\t",
	active = "Głowica ALPHA aktywowana\n\nNatychmiastowo przystąp do ewakuacji!\nDetonacja za %.2fs",
}

misc.intercom = {
	name = "Interkom",
	idle = "Interkom jest w gotowości",
	active = "Interkom jest aktywny\n\nPozostały czas: %is",
	cooldown = "Interkom odnawia się\n\nPozostały czas: %is",
}

misc.zones = {
	lcz = "LCZ",
	hcz = "HCZ",
	ez = "EZ",
}

misc.buttons = {
	MOUSE1 = "LPM",
	MOUSE2 = "PPM",
	MOUSE3 = "ŚPM",
}

misc.inventory = {
	unsearched = "Nieprzeszukane",
	search = "Naciśnij [%s] aby przeszukać",
	unknown_chip = "Nieznany chip",
	name = "Nazwa",
	team = "Drużyna",
	death_time = "Czas zgonu",
	time = {
		[0] = "Przed chwilą",
		"Około minuty temu",
		"Około dwie minuty temu",
		"Około trzy minuty temu",
		"Około cztery minut temu",
		"Około pięć minut temu",
		"Około sześć minut temu",
		"Około siedem minut temu",
		"Około osiem minut temu",
		"Około dziewięć minut temu",
		"Około dziesięć minut temu",
		long = "Ponad dziesięć minut temu",
	},
}

misc.karma = {
	vbad = "Bardzo zła",
	bad = "Zła",
	good = "Dobra",
	vgood = "Bardzo dobra",
	perfect = "Wzorowa",
}

misc.font = {
	name = "Czcionki",
	content = [[Nie udało się załadować niestandardowej czcionki trybu gry! Powrót do czcionki systemowej...
To problem z gmodem i nie mogę go naprawić. Aby to naprawić, musisz ręcznie usunąć niektóre pliki.
Przejdź do 'steamapps/common/GarrysMod/garrysmod/cache/workshop/resource/fonts' i usuń następujące pliki: 'impacted.ttf', 'ds-digital.ttf' and 'unispace.ttf']],
	ok = "OK"
}

misc.xp = {
	summary = "Podsumowanie doświadczenia",
	total = "Łącznie",
}

misc.logger = {
	death_log = "Logi śmierci",
	killer = "Zabójca:",
	killer_team = "Drużyna zabójcy:",

	recent_dealt = "Zadane obrażenia (ostatnie %i):",
	recent_taken = "Otrzymane obrażenia (ostatnie %i):",
	top_taken = "Łączne otrzymane obrażenia (największych %i):",

	nick = "Nick",
	damage = "Obrazenia",
	rdm = "RDM",
	total = "Łącznie",
	original = "Oryginalnie",
	defense = "Obrona",
	hp = "HP (przed)"
}

--[[-------------------------------------------------------------------------
Aliases
---------------------------------------------------------------------------]]
misc.commands_aliases = {
	["wycisz"] = "muteall",
	["odcisz"] = "unmuteall",
	["ustawienia"] = "settings",
	["kolejka"] = "queue",
	["wsparcie"] = "queue",
}

--[[-------------------------------------------------------------------------
Pages
---------------------------------------------------------------------------]]
lang.SLCPAGES = {}
lang.SLCPAGES.message = "Wiadomość"
lang.SLCPAGES.error = "Błąd"
lang.SLCPAGES.fatal = "Błąd Krytyczny"

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

snake.score = "Wynik"
snake.high_score = "Rekord"
snake.game_over = "Koniec Gry!"
snake.paused = "Przygotuj się!"
snake.info = "Naciśnij W, A, S lub D, aby rozpocząć"
snake.restart = "Naciśnij spację, aby uruchomić ponownie"