--[[-------------------------------------------------------------------------
Language: Polish
Date: 30.07.2024
Translated by: 
Slusher (https://steamcommunity.com/id/Slusheer/)
alski (https://steamcommunity.com/profiles/76561198179611206/)
---------------------------------------------------------------------------]]

local lang = {}

lang.self = "Polski"
lang.self_en = "Polish"

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Możesz zostać SCP w następnej rundzie (%ix szansa)",
	scpwait = "Musisz poczekać %i rundy aby zagrać jako SCP",
	abouttostart = "Gra rozpocznie się za %i sekund!",
	kill = "Otrzymujesz %d punktów za zabójstwo %s: %s!",
	kill_n = "Zabiłeś %s: %s!",
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
	r106sound = "Uruchom transmisję dźwięku, aby rozpocząć procedurę zabezpieczania SCP 106",
	r106human = "W klatce musi znajdować się żywy człowiek, aby rozpocząć procedurę zabezpieczania SCP 106",
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
	omega_detonation = "Detonacja głowicy OMEGA za %i sekund. Wyjdź na powierzchnię lub natychmiastowo udaj się do schronu!",
	alpha_detonation = "Detonacja głowicy ALPHA za %i sekund. Wejdź do placówki lub natychmiastowo udaj się do ewakuacji!",
	alpha_card = "Włożyłeś kartę nuklearną głowicy ALPHA",
	destory_scp = "Otrzymujesz %i punktów za zniszczenie podmiotu SCP!",
	afk = "Jesteś AFK. Nie będziesz się respił ani otrzymywał expa",
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
	property_dmg = "Straciłeś %d punktów za zniszczenie własności Fundacji!",
	unknown_cmd = "Nieznane polecenie: %s"
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
	stat_0492 = "Gracze zmasakrowani przez zombie: %i",
	stat_058 = "Gracze zabici przez SCP-058: %i",
	stat_066 = "Gracze zabici przez głośną muzykę: %i",
	stat_096 = "Gracze zabici przez SCP 096: %i",
	stat_106 = "Gracze przeteleportowani do wymiaru łuzowego: %i",
	stat_173 = "Złamane karki przez SCP 173: %i",
	stat_457 = "Spaleni gracze: %i",
	stat_682 = "Gracze zabici przez SCP 682: %i",
	stat_8602 = "Gracze przybici do ściany przez SCP 860-2: %i",
	stat_939 = "Ofiary SCP 939: %i",
	stat_966 = "Gracze rozszarpani przez SCP 966: %i",
	stat_3199 = "Zabójstwa dokonane przez SCP 3199: %i",
	stat_24273 = "Osoby osądzone przez SCP 2427-3: %i",
	stat_omega_warhead = "Głowica OMEGA została zdetonowana",
	stat_alpha_warhead = "Głowica ALPHA została zdetonowana",
	stat_goc_warhead = "Urządzenie GOC zostało aktywowane",
}

lang.NCFailed = "Nie udało się uzyskać dostępu do NCRegistry z kluczem: %s"

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
main_menu.model_precache_text = "Modele są wstępnie buforowane automatycznie, gdy jest to wymagane, ale dzieje się to podczas rozgrywki, więc może powodować lekkie ścinki. Aby tego uniknąć, możesz je teraz wstępnie buforować ręcznie.\nTwoja gra może się chwilowo zawiesić podczas tego procesu!"
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
eq.multiplier = "Mnożnik obrażeń"
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
effects.doorlock = "Blokowanie drzwi"
effects.amnc227 = "AMN-C227"
effects.insane = "Szaleństwo"
effects.gas_choke = "Duszenie"
effects.radiation = "Radiacja"
effects.deep_wounds = "Głębokie rany"
effects.poison = "Trucizna"
effects.heavy_bleeding = "Silne krwawienie"
effects.spawn_protection = "Ochrona początkowa"
effects.fracture = "Złamanie"
effects.decay = "Rozkład"
effects.scp_chase = "Pościg"
effects.human_chase = "Ucieczka"
effects.expd_rubber_bones = "Eksperymentalny Efekt"
effects.expd_stamina_tweaks = "Eksperymentalny Efekt"
effects.expd_revive = "Eksperymentalny Efekt"
effects.expd_recovery = "Regeneracja"
effects.electrical_shock = "Porażenie prądem"
effects.scp009 = "SCP-009"
effects.scp106_withering = "Obumieranie"
effects.scp966_effect = "Wyczerpanie"
effects.scp966_mark = "Znak Śmierci"

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
lang.prestige_warn = "Zaraz osiągniesz prestiż. Ten proces zresetuje Twój poziom, XP, punkty odblokowania klasy i odblokowane klasy, a ty otrzymasz 1 punkt prestiżu.\n\nOSTRZEŻENIE: Tej akcji nie można cofnąć!"
lang.none = "Brak"
lang.refunded = "Wszystkie usunięte klasy zostały zwrócone. Otrzymałeś %d punktów prestiżu."
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

	panels = {
		binds = "Klawiatura",
		general_config = "Ogólne ustawienia",
		hud_config = "Konfiguracja HUD-u",
		performance_config = "Wydajność",
		scp_config = "Ustawienia SCP",
		skins = "Skórki GUI",
		reset = "Reset trybu gry",
		cvars = "Edytor ConVarów",
	},

	binds = {
		eq_button = "Ekwipunek",
		upgrade_tree_button = "Drzewko umiejętności SCP",
		ppshop_button = "Przeglądaj klasy",
		settings_button = "Ustawienia trybu gry",
		scp_special = "Specjalne umiejętności SCP"
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
		hud_lq = "Obrazy i wielokąty o niskiej jakości (jeśli to możliwe)",
		hud_image_poly = "Obrazy zamiast wielokątów (jeśli to możliwe)",
		hud_windowed_mode = "Przesunięcie HUD (dla trybu okienkowego)",
		hud_avoid_roman = "Unikaj cyfr rzymskich",
		hud_escort = "Pokaż strefy eskorty",
		hud_timer_always = "Zawsze pokazuj czas",
		hud_stamina_always = "Zawsze pokazuj wytrzymałość",
		eq_instant_desc = "Natychmiastowy opis przedmiotu w EQ",
		scp106_spots = "Zawsze pokazuj miejsca teleportacji SCP-106",

		cvar_slc_support_optout = "Zrezygnuj z grania jako wsparcie",
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

		hud_skin_main_options = {
			custom = "Niestandardowy",
			default = "Domyślny",
			legacy = "Przestarzały",
		}
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
		feature = "Dodatki"
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
	skill_not_ready = "Umiejętność nie jest jeszcze gotowa!",
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
	escape2 = "Uciekłeś podczas odliczania wybuchu Alpha",
	escape3 = "Przeżyłeś w schronie przeciwwybuchowym",
	escorted = "Zostałeś odeskortowany",
	killed_by = "Zostałeś zabity przez: %s",
	suicide = "Popełniłeś samobójstwo",
	unknown = "Przyczyna twojej śmierci jest nieznana",
	hazard = "Zostałeś zabity przez zagrożenie",
	alpha_mia = "Ostatnia znana lokalizacja: Powierzchnia",
	omega_mia = "Ostatnia znana lokalizacja: Placówka",
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
	idle = "Głowica ALPHA jest bezczynna\n\nCzekam na kody nuklearne...",
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

misc.font = {
	name = "Czcionki",
	content = [[Nie udało się załadować niestandardowej czcionki trybu gry! Powrót do czcionki systemowej...
To problem z gmodem i nie mogę go naprawić. Aby to naprawić, musisz ręcznie usunąć niektóre pliki.
Przejdź do 'steamapps/common/GarrysMod/garrysmod/cache/workshop/resource/fonts' i usuń następujące pliki: 'impacted.ttf', 'ds-digital.ttf' and 'unispace.ttf']],
	ok = "OK"
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
vest.cicom = "Pancerz dowódcy CI"
vest.cimedic = "Pancerz medyka CI"
vest.goc = "Pancerz GOC"
vest.gocmedic = "Pancerz medyka GOC"
vest.goccom = "Pancerz dowódcy GOC"
vest.fire = "Kamizelka ognioodporna"
vest.electro = "Kamizelka przeciwporażeniowa"
vest.hazmat = "Hazmat"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Obrażenia od ognia"
dmg.SHOCK = "Obrażenia elektryczne"
dmg.BULLET = "Obrażenia od pocisków"
dmg.FALL = "Obrażenia od upadku"
dmg.POISON = "Obrażenia od trucizny"

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.unknown = "Nieznana"

teams.SPEC = "Obserwatorzy"
teams.CLASSD = "Klasa D"
teams.SCI = "Naukowcy"
teams.GUARD = "Ochrona"
teams.MTF = "MTF"
teams.CI = "CI"
teams.GOC = "GOC"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
lang.UNK_CLASSES = { 
	CLASSD = "Nieznana Klasa D",
	SCI = "Nieznany Naukowiec",
	GUARD = "Nieznany Ochroniarz",
	MTF = "Nieznany MTF",
	CI = "Nieznany CI",
	GOC = "Nieznany GOC"
}

local classes = {}
lang.CLASSES = classes

classes.unknown = "Nieznana"
classes.spectator = "Obserwator"

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

classes.classd = "Klasa D"
classes.veterand = "Weteran Klasy D"
classes.kleptod = "Kleptoman Klasy D"
classes.contrad = "Klasa D z kontrabandą"
classes.ciagent = "Agent CI"
classes.expd = "Eksperymentalna Klasa D"
classes.classd_prestige = "Krawiec Klasy D"

classes.sciassistant = "Asystent naukowca"
classes.sci = "Naukowiec"
classes.seniorsci = "Starszy naukowiec"
classes.headsci = "Główny naukowiec"
classes.contspec = "Specjalista zabezpieczeń"
classes.sci_prestige = "Uciekinier klasy D"

classes.guard = "Ochroniarz"
classes.chief = "Szef ochrony"
classes.lightguard = "Lekki ochroniarz"
classes.heavyguard = "Ciężki ochroniarz"
classes.specguard = "Specjalista ochrony"
classes.guardmedic = "Ochroniarz sanitariusz"
classes.tech = "Technik ochrony"
classes.cispy = "Szpieg CI"
classes.lightcispy = "Lekki Szpieg CI"
classes.heavycispy = "Ciężki Szpieg CI"
classes.guard_prestige = "Inżynier Ochrony"

classes.ntf_1 = "MTF NTF - PM"
classes.ntf_2 = "MTF NTF - STRZELBA"
classes.ntf_3 = "MTF NTF - KARABIN"
classes.ntfcom = "Dowódca MTF NTF"
classes.ntfsniper = "Snajper MTF NTF"
classes.ntfmedic = "Medyk MTF NTF"
classes.alpha1 = "MTF Alfa-1"
classes.alpha1sniper = "Strzelec Wyborowy MTF Alfa-1"
classes.alpha1medic = "Medyk MTF Alpha-1"
classes.alpha1com = "Dowódca MTF Alpha-1"
classes.ci = "Chaos Insurgency"
classes.cisniper = "Snajper Chaos Insurgency"
classes.cicom = "Dowódca Chaos Insurgency"
classes.cimedic = "Medyk Chaos Insurgency"
classes.cispec = "Specjalista Chaos Insurgency"
classes.ciheavy = "Ciężka jednostka Chaos Insurgency"
classes.goc = "Żołnierz GOC"
classes.gocmedic = "Medyk GOC"
classes.goccom = "Dowódca GOC"

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
local generic_classd = [[- Ucieknij z placówki
- Unikaj personelu i obiektów SCP
- Współpracuj z innymi]]

local generic_sci = [[- Ucieknij z placówki
- Unikaj Klasy D i obiektów SCP
- Współpracuj z ochroną i jednostką MTF]]

local generic_guard = [[- Uratuj naukowców
- Zlikwiduj wszystkie obiekty Klasy D i SCP
- Słuchaj swojego przełożonego]]

local generic_cispy = [[- Udawaj, że jesteś ochroniarzem
- Pomóż pozostałemu personelowi klasy D
- Sabotażuj działania ochrony]]

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

	contrad = generic_classd,

	ciagent = [[- Eskortuj Personel Klasy D
- Unikaj personelu i obiektów SCP
- Współpracuj z innymi]],

	expd = [[- Ucieknij z placówki
- Unikaj personelu i obiektów SCP
- Przeszedłeś dziwne eksperymenty]],

	classd_prestige = [[- Ucieknij z placówki
- Unikaj personelu i obiektów SCP
- Możesz kraść ubrania z martwych ciał]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	contspec = generic_sci,

	sci_prestige = [[- Ucieknij z placówki
- Unikaj personelu i obiektów SCP
- Ukradłeś ubrania i identyfikator naukowca]],

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

cispy = generic_cispy,

lightcispy = generic_cispy,

heavycispy = generic_cispy,

guard_prestige = [[- Uratuj naukowców
- Zlikwiduj wszystkie obiekty Klasy D i SCP
- Możesz tymczasowo zablokować drzw]],

ntf_1 = generic_ntf,

ntf_2 = generic_ntf,

ntf_3 = generic_ntf,

	ntfmedic = [[- Pomóż personelowi wewnątrz placówki
- Nie pozwól uciec obiektom Klasy D i SCP
- Wspieraj swoją jednostkę leczeniem]],

	ntfcom = [[- Pomóż personelowi wewnątrz placówki
- Nie pozwól uciec obiektom Klasy D i SCP
- Wydawaj rozkazy innym sojusznikom]],

	ntfsniper = [[- Pomóż personelowi wewnątrz placówki
- Nie pozwól uciec obiektom Klasy D i SCP
- Wspieraj swoją drużynę zza pleców]],

	alpha1 = [[- Chroń placówkę za wszelką cenę
- Zatrzymaj obiekty Klasy D i SCP
- Jesteś upoważniony do ]].."[ZMIENIONO]",

	alpha1medic = [[- Chroń placówkę za wszelką cenę
- Wspieraj swoją jednostkę leczeniem
- Jesteś upoważniony do ]].."[REDACTED]",

	alpha1com = [[- Chroń placówkę za wszelką cenę
- Wydawaj rozkazy innym sojusznikom
- Jesteś upoważniony do ]].."[REDACTED]",

	alpha1sniper = [[- Chroń placówkę za wszelką cenę
- Zatrzymaj obiekty Klasy D i SCP
- Jesteś upoważniony do ]].."[ZMIENIONO]",

	ci = [[- Pomóż Personelowi Klasy D
- Wyeliminuj personel placówki
- Słuchaj swojego przełożonego]],

	cisniper = [[- Pomóż Personelowi Klasy D
- Wyeliminuj personel placówki
- Ochroniaj swój zespół od tyłu]],

	cicom = [[- Pomóż Personelowi Klasy D
- Wyeliminuj personel placówki
- Wydawaj rozkazy innym sojusznikom]],

	cimedic = [[- Pomóż Personelowi Klasy D
- Wspieraj swoją jednostkę leczeniem
- Słuchaj swojego przełożonego]],

	cispec = [[- Pomóż Personelowi Klasy D
- Wspieraj CI swoim działkiem
- Słuchaj swojego przełożonego]],

	ciheavy = [[- Pomóż Personelowi Klasy D
- Zapewniaj ogień osłaniający
- Słuchaj swojego przełożonego]],

	goc = [[- Zniszcz podmioty SCP
- Zlokalizuj i aktywuj urzadzenie GOC
- Słuchaj swojego przełożonego]],

	gocmedic = [[- Zniszcz podmioty SCP
- Wspieraj swoją jednostkę leczeniem
- Słuchaj swojego przełożonego]],

	goccom = [[- Zniszcz podmioty SCP
- Zlokalizuj i aktywuj urzadzenie GOC
- Wydawaj rozkazy żołnierzom GOC]],

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
Potencjał bojowy: Niski
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

contrad = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Średni
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI

Przegląd:
Klasa z przemyconą bronią. Wykorzystają tą broń mądrze, nie wytrzyma ona zbyt wiele.
]],

	ciagent = [[Poziom trudności: Średni
Wytrzymałość: Bardzo wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Uzbrojony w paralizator. Jako agent CI udziel pomocy klasie D i współpracuj z nimi. Możesz eskortować członków klasy D.
]],

	expd = [[Poziom trudności: ?
Wytrzymałość: ?
Zwinność: ?
Potencjał bojowy: ?
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI

Przegląd:
Klasa, która przeszła kilka dziwnych eksperymentów wewnątrz placówki. Kto wie, co było przedmiotem ty badań...
]],

	classd_prestige = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Wysoki
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI

Przegląd:
Wygląda jak klasa podstawowa, ale ma możliwość kradzieży ubrań z martwych ciał. Współpracuj z innymi, aby stawić czoła obiektom SCP i personelowi obiektu. Członkowie CI mogą Cię eskortować.

Pomysłodawca: Mr.Kiełbasa (zwycięzca konkursu)
]],

	sciassistant = [[Poziom trudności: Średni
Wytrzymałość: Niska
Zwinność: Niska
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
Jeden z naukowców. Masz wyższy poziom dostępu. Znalazłeś również prymitywną broń. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

	headsci = [[Poziom trudności: Łatwy
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo wysoka
Potencjał bojowy: Niski
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: Ochronę, Wsparcie MTF

Przegląd:
Najlepszy z naukowców. Masz wyższą użyteczność oraz wysokie HP. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

	contspec = [[Poziom trudności: Średni
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo wysoka
Potencjał bojowy: Niski
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: Ochronę, Wsparcie MTF

Przegląd:
Jeden z naukowców o wysokiej użyteczności i wysokim HP, ma również najwyższy poziom dostępu. Współpracuj z personelem placówki i trzymaj się z dala od obiektów SCP. Możesz być eskortowany przez oddział MTF.
]],

sci_prestige = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Średni
Czy może uciec: Tak
Czy może eskortować: Nie
Eskortowany przez: CI

Przegląd:
Uciekinier klasy D, który włamał się do szafy jakiegoś naukowca i ukradł ubrania oraz dowód osobisty. Udawaj naukowca i współpracuj z klasą D i CI.

Pomysłodawca: Artieusz (zwycięzca konkursu)
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

	cispy = [[Poziom trudności: Bardzo Trudny
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Szpieg CI. Wysoka użyteczność. Spróbuj wtopić się w ochroniarzy i pomóż klasie D.
]],

lightcispy = [[Poziom trudności: Bardzo Trudny
Wytrzymałość: Niska
Zwinność: Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Lekki szpieg CI. Wysoka użyteczność. Spróbuj wmieszać się w grupę ochroniarzy i pomóc klasie D.
]],

	heavycispy = [[Poziom trudności: Bardzo Trudny
Wytrzymałość: Wysoka
Zwinność: Niska
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Class D
Eskortowany przez: Nikogo

Przegląd:
Ciężki szpieg CI. Niższa użyteczność, lepszy pancerz i większe zdrowie. Spróbuj wmieszać się w grupę ochroniarzy i pomóc klasie D.
]],

	guard_prestige = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Scientists
Eskortowany przez: Nikogo

Przegląd:
Jeden ze strażników. Posiada urządzenie, które może tymczasowo zablokować drzwi w ich obecnym stanie. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zabić SCP i klasę D. Możesz eskortować Naukowców.

Pomysłodawca: F"$LAYER (zwycięzca konkursu)
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
Jednostka MTF Alpha-1. Mocno opancerzona, bardzo użyteczna jednostka, uzbrojona w karabin wyborowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

alpha1medic = [[Poziom trudności: Trudny
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alpha-1.  Mocno opancerzona, bardzo użyteczna jednostka, zapewnia leczenie. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	alpha1com = [[Poziom trudności: Trudny
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alpha-1. Mocno opancerzona, bardzo użyteczna jednostka, wydaje rozkazy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ci = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki.
]],

cisniper = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do obiektu, pomóż klasie D i zabij personel obiektu. Osłaniaj swój zespół.
]],

	cicom = [[Poziom trudności: Średni
Wytrzymałość: Bardzo wysoka
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wyższy potencjał bojowy. Wejdź do placówki, pomóż klasie D i zabij personel placówki.
]],
	
	cimedic = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Normalny
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki. Zaczynasz z apteczką.
]],

	cispec = [[Poziom trudności: Średni
Wytrzymałość: Średnio-wysoka
Zwinność: Średnio-wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki. Możesz rozstawić działko.
]],

ciheavy = [[Poziom trudności: Średni
Wytrzymałość: Średnio-wysoka
Zwinność: Średnio-wysoka
Potencjał bojowy: Bardzo wysoki
Czy może uciec: Nie
Czy może eskortować: Tylko klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki. Jesteś w posiadaniu ciężkiego karabinu maszynowego.
]],

	goc = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Nie
Eskortowany przez: Nikogo

Przegląd:
Podstawowy żołnierz GOC. Użyj swojego tableta, aby znaleźć urządzenie GOC a następnie dostarcz je i aktywuj. Po pomyślnym aktywowaniu ucieknij do schronu.
]],

	gocmedic = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Nie
Eskortowany przez: Nikogo

Przegląd:
Podstawowy żołnierz GOC. Użyj swojego tableta, aby znaleźć urządzenie GOC a następnie dostarcz je i aktywuj. Po pomyślnym aktywowaniu ucieknij do schronu. Posiadasz apteczkę.
]],

	goccom = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Nie
Eskortowany przez: Nikogo

Przegląd:
Podstawowy żołnierz GOC. Użyj swojego tableta, aby znaleźć urządzenie GOC a następnie dostarcz je i aktywuj. Po pomyślnym aktywowaniu ucieknij do schronu. Posiadasz granaty dymne.
]],

SCP0492 = [[Ogólnie:
Zombie stworzony przez SCP-049. Występuje w jednym z następujących typów:

Normalny zombie:
Trudność: Łatwa | Wytrzymałość: Zwykła | Zwinność: Zwykła | Obrażenia: Zwykłe
Przyzwoity wybór ze zrównoważonymi statystykami

Zabójca zombie:
Trudność: Średnia | Wytrzymałość: Niska | Zwinność: Wysoka | Obrażenia: Zwykłe/Wysokie
Najszybszy, ale ma najniższe zdrowie i obrażenia

Wybuchające zombie:
Trudność: Średnia | Wytrzymałość: Wysoka | Zwinność: Niska | Obrażenia: Zwykłe/Wysokie
Niska prędkość ruchu, ale ma wysokie zdrowie i największe obrażenia

Spitting zombie:
Trudność: Średnia | Wytrzymałość: Wysoka | Zwinność: Niska | Obrażenia: Zwykłe/Wysokie
Najwolniejszy typ zombie, ale zadaje duże obrażenia i najwięcej zdrowia
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "Wzmocnienie na powierzchni",
		info = "Otrzymujesz regenerację zdrowia na powierzchni (skaluje się z pozostałym czasem rundy) i uzyskujesz potężną ochronę przed obrażeniami na niezablokowanej ucieczce lub podczas dogrywki"
	}
}

lang.CommonSkills = {
	c_button_overload = {
		name = "Przeciążenie",
		dsc = "Umożliwia przeciążenie większości zamkniętych drzwi. Przeciążone drzwi otwierają się (lub zamykają) na krótki okres czasu."
	},
	c_dmg_mod = {
		name = "Ochrona przed obrażeniami",
		dsc = "Aktualna ochrona: [mod]\n\nOchrona ta nie dotyczy obrażeń otrzymanych bezpośrednio. Uwzględnia jedynie modyfikatory skalowania czasu i zewnętrzne wzmocnienia. Modyfikatory danych SCP nie są uwzględnione!"
	},
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	skills = {
		_overview = { "passive", "drain", "clone", "hunt" },
		drain = {
			name = "Wysysanie energii",
			dsc = "Zacznij wysysać energię od pobliskich graczy. Jeśli wszyscy gracze opuszczą obszar umiejętności, zdolność się wyłączy",
		},
		clone = {
			name = "Klon",
			dsc = "Umieść sobowtóra, który będzie naśladował działanie twojej zdolności pasywnej (w tym ulepszeń). Klon będzie wędrował i ścigał pobliskich graczy",
		},
		hunt = {
			name = "Polowanie",
			dsc = "Natychmiast zabij jedną z twoich ofiar lub osoby w ich pobliżu i teleportuj się do ich ciała",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Kolizja z graczami powoduje ich podpalenie",
		},
		drain_bar = {
			name = "Wysysanie",
			dsc = "Pozostały czas działania zdolności wysysania",
		},
	},

	upgrades = {
		parse_description = true,

		passive = {
			name = "Żarzący się Węgielek",
			info = "Ulepsza twoją zdolność pasywną, zwiększając obrażenia od palenia o [+burn_power]",
		},
		invis1 = {
			name = "Niewidzialny Płomień I",
			info = "Usprawnia twoją zdolność pasywną\n\t• Znikasz dla odległych graczy\n\t• Gracze, którzy cię nie widzą, nie będą dodawani do polowania\n\t• To ulepszenie dotyczy również twojego klona\n\t• Stajesz się całkowicie niewidzialny [invis_range] jednostek dalej",
		},
		invis2 = {
			name = "Niewidzialny Płomień II",
			info = "Ulepsza twoją niewidzialność\n\t• Stajesz się całkowicie niewidzialny [invis_range] jednostek dalej",
		},
		prot1 = {
			name = "Niezniszczalny Ogień I",
			info = "Usprawnia twoją zdolność pasywną, zapewniając ochronę przed obrażeniami od kul o [-prot]",
		},
		prot2 = {
			name = "Niezniszczalny Ogień II",
			info = "Ulepsza twoją ochronę przed kulami do [-prot]",
		},
		drain1 = {
			name = "Wysysanie Mocy I",
			info = "Ulepsza twoją zdolność wysysania\n\t• Czas trwania zwiększony o [+drain_dur]\n\t• Maksymalna odległość zwiększona o [+drain_dist]",
		},
		drain2 = {
			name = "Wysysanie Mocy II",
			info = "Ulepsza twoją zdolność wysysania\n\t• Szybkość wysysania zwiększona o [/drain_rate]\n\t• Leczenie za [%drain_heal] wyssanej energii",
		},
		drain3 = {
			name = "Wysysanie Mocy III",
			info = "Ulepsza twoją zdolność wysysania\n\t• Czas trwania zwiększony o [+drain_dur]\n\t• Maksymalna odległość zwiększona o [+drain_dist]",
		},
		drain4 = {
			name = "Wysysanie Mocy IV",
			info = "Ulepsza twoją zdolność wysysania\n\t• Szybkość wysysania zwiększona o [/drain_rate]\n\t• Leczenie za [%drain_heal] wyssanej energii",
		},
		hunt1 = {
			name = "Niezniszczalny Ogień I",
			info = "Wzmacnia twoją zdolność polowania\n\t• Czas odnowienia skrócony o [-hunt_cd]",
		},
		hunt2 = {
			name = "Niezniszczalny Ogień II",
			info = "Wzmacnia twoją zdolność polowania\n\t• Czas odnowienia skrócony o [-hunt_cd]\n\t• Zasięg wyszukiwania losowej ofiary zwiększony o [+hunt_range]",
		},
	}
}

wep.SCP049 = {
	zombies = {
		normal = "Standardowy Zombie",
		assassin = "Zombie Zabójca",
		boomer = "Wybuchający Zombie",
		heavy = "Plujący Zombie",
	},
	zombies_desc = {
		normal = "Standardowy zombie\n\t• Posiada zarówno lekkie, jak i ciężkie ataki\n\t• Dobry wybór z zrównoważonymi statystykami",
		assassin = "Zombie zabójca\n\t• Posiada lekki atak i umiejętność szybkiego ataku\n\t• Najszybszy, ale ma najniższe zdrowie i obrażenia",
		boomer = "Wybuchający ciężki zombie\n\t• Posiada ciężki atak i zdolność wybuchu\n\t• Niska prędkość ruchu, ale ma dużo zdrowia i największe obrażenia",
		heavy = "Plujący ciężki zombie\n\t• Posiada ciężki atak i zdolność strzału\n\t• Najwolniejszy typ zombie, ale ma wysokie obrażenia i najwięcej zdrowia",
	},
	skills = {
		_overview = { "passive", "choke", "surgery", "boost" },
		surgery_failed = "Operacja nieudana!",

		choke = {
			name = "Dotyk Doktora",
			dsc = "Dusi gracza na śmierć. Ta zdolność może zostać przerwana przez otrzymanie wystarczającej ilości obrażeń",
		},
		surgery = {
			name = "Operacja",
			dsc = "Wykonaj operację na ciele, przekształcając je w SCP-049-2. Otrzymanie obrażeń przerywa operację",
		},
		boost = {
			name = "Powstań!",
			dsc = "Zapewnia wzmocnienie tobie i wszystkim pobliskim instancjom SCP-049-2",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Zombie znajdujące się w pobliżu zyskują ochronę przed obrażeniami od kul",
		},
		choke_bar = {
			name = "Dotyk Doktora",
			dsc = "Gdy jest pełny, cel umiera",
		},
		surgery_bar = {
			name = "Operacja",
			dsc = "Pozostały czas operacji",
		},
		boost_bar = {
			name = "Powstań!",
			dsc = "Pozostały czas wzmocnienia",
		},
	},

	upgrades = {
		parse_description = true,

		choke1 = {
			name = "Dotyk Doktora I",
			info = "Ulepsza twoją zdolność duszenia\n\t• Czas odnowienia skrócony o [-choke_cd]\n\t• Próg obrażeń zwiększony o [+choke_dmg]",
		},
		choke2 = {
			name = "Dotyk Doktora II",
			info = "Ulepsza twoją zdolność duszenia\n\t• Szybkość duszenia zwiększona o [+choke_rate]\n\t• Spowolnienie po duszeniu zmniejszone o [-choke_slow]",
		},
		choke3 = {
			name = "Dotyk Doktora III",
			info = "Ulepsza twoją zdolność duszenia\n\t• Czas odnowienia skrócony o [-choke_cd]\n\t• Próg obrażeń zwiększony o [+choke_dmg]\n\t• Szybkość duszenia zwiększona o [+choke_rate]",
		},
		buff1 = {
			name = "Powstań I",
			info = "Ulepsza twoją zdolność wzmacniania\n\t• Czas odnowienia skrócony o [-buff_cd]\n\t• Czas trwania wzmocnienia zwiększony o [+buff_dur]",
		},
		buff2 = {
			name = "Powstań II",
			info = "Ulepsza twoją zdolność wzmacniania\n\t• Zasięg wzmocnienia zwiększony o [+buff_radius]\n\t• Moc wzmocnienia zwiększona o [+buff_power]",
		},
		surgery_cd1 = {
			name = "Precyzja Chirurgiczna I",
			info = "Skraca czas operacji o [surgery_time]s\n\t• To ulepszenie jest kumulatywne",
		},
		surgery_cd2 = {
			name = "Precyzja Chirurgiczna II",
			info = "Skraca czas operacji o [surgery_time]s\n\t• To ulepszenie jest kumulatywne",
		},
		surgery_heal = {
			name = "Transplantacja",
			info = "Ulepsza twoją zdolność operacji\n\t• Po operacji leczysz się o [surgery_heal] HP\n\t• Po operacji wszystkie pobliskie zombie leczą się o [surgery_zombie_heal] HP",
		},
		surgery_dmg = {
			name = "Niepowstrzymana operacja",
			info = "Otrzymywanie obrażeń nie przerywa już operacji",
		},
		surgery_prot = {
			name = "Stabilna Ręka",
			info = "Podczas operacji zyskujesz ochronę przed kulami [-surgery_prot]",
		},
		zombie_prot = {
			name = "Pielęgniarka",
			info = "Zyskujesz ochronę przed kulami za każdego pobliskiego SCP-049-2\n\t• Ochrona za każdego pobliskiego zombie: [%zombie_prot]\n\t• Maksymalna ochrona: [%zombie_prot_max]",
		},
		zombie_lifesteal = {
			name = "Transfuzja I",
			info = "Zombie zyskują [%zombie_ls] kradzieży życia na podstawowych atakach",
		},
		stacks_hp = {
			name = "Zastrzyk Sterydów",
			info = "Podczas tworzenia zombie ich zdrowie zwiększa się o [%stacks_hp] za każdą poprzednią operację",
		},
		stacks_dmg = {
			name = "Radykalna Terapia",
			info = "Podczas tworzenia zombie ich obrażenia zwiększają się o [%stacks_dmg] za każdą poprzednią operację",
		},
		zombie_heal = {
			name = "Transfuzja II",
			info = "Leczysz się o [%zombie_heal] dowolnych obrażeń zadanych przez pobliskie zombie",
		}
	}
}

wep.SCP0492 = {
	skills = {
		prot = {
			name = "Ochrona",
			dsc = "Zyskujesz ochronę przed obrażeniami, gdy jesteś blisko SCP-049",
		},
		boost = {
			name = "Wzmocnienie",
			dsc = "Wskazuje, kiedy wzmocnienie SCP-049 jest aktywne na tobie",
		},
		light_attack = {
			name = "Lekki Atak",
			dsc = "Wykonaj lekki atak",
		},
		heavy_attack = {
			name = "Ciężki Atak",
			dsc = "Wykonaj ciężki atak",
		},
		rapid = {
			name = "Szybki Atak",
			dsc = "Wykonaj szybki atak",
		},
		shot = {
			name = "Strzał",
			dsc = "Wystrzel pocisk zadający obrażenia",
		},
		explode = {
			name = "Wybuch",
			dsc = "Aktywuje się, gdy masz 50 HP lub mniej. Zyskujesz zdolność stania się nieśmiertelnym oraz zwiększenie prędkości. Po krótkim czasie wybuchasz, zadając obrażenia w małym promieniu",
		},
		boost_bar = {
			name = "Wzmocnienie",
			dsc = "Pozostały czas wzmocnienia",
		},
		explode_bar = {
			name = "Wybuch",
			dsc = "Pozostały czas do wybuchu",
		},
	},

	upgrades = {
		parse_description = true,

		primary1 = {
			name = "Atak Podstawowy I",
			info = "Ulepsza twój główny atak\n\t• Czas odnowienia skrócony o [-primary_cd]",
		},
		primary2 = {
			name = "Atak Podstawowy II",
			info = "Ulepsza twój główny atak\n\t• Czas odnowienia skrócony o [-primary_cd]\n\t• Obrażenia zwiększone o [+primary_dmg]",
		},
		secondary1 = {
			name = "Atak Wtórny I",
			info = "Ulepsza twój atak wtórny\n\t• Obrażenia zwiększone o [+secondary_dmg]",
		},
		secondary2 = {
			name = "Atak Wtórny II",
			info = "Ulepsza twój atak wtórny\n\t• Obrażenia zwiększone o [+secondary_dmg]\n\t• Czas odnowienia skrócony o [-secondary_cd]",
		},
		overload = {
			name = "Przeciążenie",
			info = "Zapewnia dodatkowe [overloads] przeciążenia przycisków",
		},
		buff = {
			name = "Powstań!",
			info = "Wzmacnia twoją ochronę i wzmocnienie SCP-049\n\t• Moc ochrony: [%+prot_power]\n\t• Moc wzmocnienia: [++buff_power]",
		},
	}
}

wep.SCP058 = {
	skills = {
		_overview = { "primary_attack", "shot", "explosion" },
		primary_attack = {
			name = "Atak podstawowy",
			dsc = "Atakuj swoim żądłem bezpośrednio przed sobą. Zadaje truciznę, jeśli odpowiednie ulepszenie zostało zakupione",
		},
		shot = {
			name = "Strzał",
			dsc = "Wystrzeliwuje pocisk w kierunku celowania. Pocisk porusza się po trajektorii balistycznej. Ulepszenia związane ze strzałem wpływają na czas odnowienia, prędkość, rozmiar i efekty tej zdolności",
		},
		explosion = {
			name = "Eksplozja",
			dsc = "Uwalnia wybuch skażonej krwi, zadając ogromne obrażenia pobliskim celom",
		},
		shot_stacks = {
			name = "Ładunki strzałów",
			dsc = "Pokazuje zmagazynowaną ilość strzałów. Różne ulepszenia związane ze strzałami wpływają na maksymalną ilość i czas odnowienia",
		},
	},

	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Trujące Żądło I",
			info = "Dodaje truciznę do ataków podstawowych",
		},
		attack2 = {
			name = "Trujące Żądło II",
			info = "Zwiększa obrażenia ataku, obrażenia trucizny i skraca czas odnowienia\n\t• Dodaje [prim_dmg] obrażeń do ataków\n\t• Trucizna ataku zadaje [pp_dmg] obrażeń\n\t• Czas odnowienia skrócony o [prim_cd]s",
		},
		attack3 = {
			name = "Trujące Żądło III",
			info = "Zwiększa obrażenia trucizny i skraca czas odnowienia\n\t• Jeśli cel nie jest zatruty, natychmiast nakłada 2 ładunki trucizny\n\t• Trucizna ataku zadaje [pp_dmg] obrażeń\n\t• Czas odnowienia skrócony o [prim_cd]s",
		},
		shot = {
			name = "Skażona Krew",
			info = "Dodaje truciznę do ataków strzałem",
		},
		shot11 = {
			name = "Fala I",
			info = "Zwiększa obrażenia i rozmiar pocisku, ale także zwiększa czas odnowienia i spowalnia pocisk\n\t• Obrażenia pocisku zwiększone o [+shot_damage]\n\t• Zmiana rozmiaru pocisku: [++shot_size]\n\t• Zmiana prędkości pocisku: [++shot_speed]\n\t• Czas odnowienia zwiększony o [shot_cd]s",
		},
		shot12 = {
			name = "Fala II",
			info = "Zwiększa obrażenia i rozmiar pocisku, ale także zwiększa czas odnowienia i spowalnia pocisk\n\t• Obrażenia pocisku zwiększone o [+shot_damage]\n\t• Zmiana rozmiaru pocisku: [++shot_size]\n\t• Zmiana prędkości pocisku: [++shot_speed]\n\t• Czas odnowienia zwiększony o [shot_cd]s",
		},
		shot21 = {
			name = "Krwawa Mgła I",
			info = "Strzał pozostawia mgłę po uderzeniu, raniąc i trując każdego, kto ją dotknie.\n\t• Usunięte bezpośrednie i rozpryskowe obrażenia\n\t• Chmura zadaje [cloud_damage] obrażeń przy kontakcie\n\t• Trucizna zadawana przez chmurę zadaje [sp_dmg] obrażeń\n\t• Ładunki strzałów ograniczone do [stacks]\n\t• Czas odnowienia zwiększony o [shot_cd]s\n\t• Tempo zdobywania ładunków: [/+regen_rate]",
		},
		shot22 = {
			name = "Krwawa Mgła II",
			info = "Zwiększa efektywność mgły pozostawionej przez strzały.\n\t• Chmura zadaje [cloud_damage] obrażeń przy kontakcie\n\t• Trucizna zadawana przez chmurę zadaje [sp_dmg] obrażeń\n\t• Tempo zdobywania ładunków: [/+regen_rate]",
		},
		shot31 = {
			name = "Wielostrzał I",
			info = "Pozwala na szybkie strzelanie przy trzymaniu przycisku ataku\n\t• Odblokowuje zdolność szybkiego strzelania\n\t• Usunięte bezpośrednie i rozpryskowe obrażenia\n\t• Ładunki strzałów ograniczone do [stacks]\n\t• Tempo zdobywania ładunków: [/+regen_rate]\n\t• Zmiana rozmiaru pocisku: [++shot_size]\n\t• Zmiana prędkości pocisku: [++shot_speed]",
		},
		shot32 = {
			name = "Wielostrzał II",
			info = "Zwiększa maksymalne ładunki i przyspiesza strzelanie\n\t• Ładunki strzałów ograniczone do [stacks]\n\t• Tempo zdobywania ładunków: [/+regen_rate]\n\t• Zmiana rozmiaru pocisku: [++shot_size]\n\t• Zmiana prędkości pocisku: [++shot_speed]",
		},
		exp1 = {
			name = "Wybuch Aorty",
			info = "Odblokowuje zdolność eksplozji, która zadaje ogromne obrażenia pobliskim celom. Ta zdolność aktywuje się, gdy twoje zdrowie spada poniżej każdego wielokrotności 1000 HP po raz pierwszy. Jeśli kupione, gdy masz poniżej 1000 HP, pierwsze otrzymane obrażenia aktywują tę zdolność. Poprzednie progi nie mogą być osiągnięte (nawet przy leczeniu)",
		},
		exp2 = {
			name = "Toksyczny Wybuch",
			info = "Wzmacnia twoją zdolność eksplozji\n\t• Nakłada 2 ładunki trucizny\n\t• Promień zwiększony o [+explosion_radius]",
		},
	}
}

wep.SCP066 = {
	skills = {
		_overview = { "eric", "music", "dash", "boost" },
		not_threatened = "Nie czujesz się zagrożony, aby atakować!",

		music = {
			name = "Symfonia nr 2",
			dsc = "Jeśli czujesz się zagrożony, możesz emitować głośną muzykę",
		},
		dash = {
			name = "Skok",
			dsc = "Rzuć się do przodu. Jeśli trafisz gracza, przykleisz się do niego na krótki czas",
		},
		boost = {
			name = "Dopalacz",
			dsc = "Zdobądź jeden z 3 dopalaczy, który jest obecnie aktywny. Po użyciu zostanie zastąpiony przez kolejny. Moc wszystkich dopalaczy wzrasta wraz z każdym ładunkiem (ograniczona do [cap] ładunków).\n\nObecny dopalacz: [boost]\n\nDopalacz szybkości: [speed]\nDopalacz obrony przed kulami: [def]\nDopalacz regeneracji: [regen]",
			buffs = {
				"Szybkość",
				"Obrona przed kulami",
				"Regeneracja",
			},
		},
		eric = {
			name = "Eric?",
			dsc = "Pytasz nieuzbrojonych graczy, czy są Erikiem. Za każdym razem zdobywasz jeden ładunek",
		},
		music_bar = {
			name = "Symfonia nr 2",
			dsc = "Pozostały czas tej zdolności",
		},
		dash_bar = {
			name = "Czas odłączenia",
			dsc = "Pozostały czas przyczepienia do celu",
		},
		boost_bar = {
			name = "Dopalacz",
			dsc = "Pozostały czas tej zdolności",
		},
	},

	upgrades = {
		parse_description = true,

		eric1 = {
			name = "Eric? I",
			info = "Zmniejsza czas odnowienia umiejętności pasywnej o [-eric_cd]",
		},
		eric2 = {
			name = "Eric? II",
			info = "Zmniejsza czas odnowienia umiejętności pasywnej o [-eric_cd]",
		},
		music1 = {
			name = "Symfonia nr 2 I",
			info = "Ulepsza twój atak podstawowy\n\t• Czas odnowienia zmniejszony o [-music_cd]\n\t• Zasięg zwiększony o [+music_range]",
		},
		music2 = {
			name = "Symfonia nr 2 II",
			info = "Ulepsza twój atak podstawowy\n\t• Czas odnowienia zmniejszony o [-music_cd]\n\t• Zasięg zwiększony o [+music_range]",
		},
		music3 = {
			name = "Symfonia nr 2 III",
			info = "Ulepsza twój atak podstawowy\n\t• Obrażenia zwiększone o [+music_damage]",
		},
		dash1 = {
			name = "Skok I",
			info = "Ulepsza twoją zdolność skakania\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Pozostajesz [+detach_time] dłużej na swoim celu",
		},
		dash2 = {
			name = "Skok II",
			info = "Ulepsza twoją zdolność skakania\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Pozostajesz [+detach_time] dłużej na swoim celu",
		},
		dash3 = {
			name = "Skok III",
			info = "Ulepsza twoją zdolność skakania\n\t• Gdy jesteś przyczepiony do celu, możesz ponownie użyć tej zdolności, aby się odczepić\n\t• Podczas odczepiania, możesz przyczepić się do innego gracza\n\t• Nie możesz przyczepić się do tego samego gracza więcej niż raz podczas jednego użycia tej zdolności",
		},
		boost1 = {
			name = "Dopalacz I",
			info = "Ulepsza twoją zdolność dopalacza\n\t• Czas odnowienia zmniejszony o [-boost_cd]\n\t• Czas trwania zwiększony o [+boost_dur]",
		},
		boost2 = {
			name = "Dopalacz II",
			info = "Ulepsza twoją zdolność dopalacza\n\t• Czas odnowienia zmniejszony o [-boost_cd]\n\t• Moc zwiększona o [+boost_power]",
		},
		boost3 = {
			name = "Dopalacz III",
			info = "Ulepsza twoją zdolność dopalacza\n\t• Czas trwania zwiększony o [+boost_dur]\n\t• Moc zwiększona o [+boost_power]",
		},
	}
}

wep.SCP096 = {
	skills = {
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {
			name = "Szarża",
			dsc = "Rzuć się do przodu w gniewie. Natychmiast kończy gniew. Nie będziesz jadł ciała po szarży",
		},
		regen = {
			name = "Regeneracja",
			dsc = "Usiądź w miejscu i zamień ładunki regeneracji na zdrowie",
		},
		special = {
			name = "Koniec polowania",
			dsc = "Zatrzymaj gniew. Zdobądź ładunki regeneracji za każdy aktywny cel",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Jeśli ktoś na ciebie patrzy, wpadasz w gniew. Natychmiast zabijasz graczy, którzy cię rozwścieczyli",
		},
	},

	upgrades = {
		parse_description = true,

		rage = {
			name = "Gniew",
			info = "Otrzymanie [rage_dmg] w [rage_time] sekund od jednego gracza wprawia cię w gniew",
		},
		heal1 = {
			name = "Pożeranie I",
			info = "Po zabiciu celu, pożeraj ciało celu i zyskaj ochronę przed kulami na czas trwania\n\t• Leczenie na tick: [heal]\n\t• Ticki leczenia: [heal_ticks]\n\t• Ochrona przed obrażeniami od kul: [-prot]",
		},
		heal2 = {
			name = "Pożeranie II",
			info = "Ulepsza twoje pożeranie\n\t• Leczenie na tick: [heal]\n\t• Ticki leczenia: [heal_ticks]\n\t• Ochrona przed obrażeniami od kul: [-prot]",
		},
		multi1 = {
			name = "Niekończący się Gniew I",
			info = "Pozwala na zabicie wielu celów w gniewie przez ograniczony czas po pierwszym zabiciu\n\t• Maksymalna liczba celów: [multi]\n\t• Limit czasowy: [multi_time] sekund\n\t• Ochrona przed obrażeniami od kul po zabiciu pierwszego celu zwiększona o [+prot]",
		},
		multi2 = {
			name = "Niekończący się Gniew II",
			info = "Pozwala na zabicie jeszcze więcej celów w gniewie\n\t• Maksymalna liczba celów: [multi]\n\t• Limit czasowy: [multi_time] sekund\n\t• Ochrona przed obrażeniami od kul po zabiciu pierwszego celu zwiększona o [+prot]",
		},
		regen1 = {
			name = "Krzyk Rozpaczy I",
			info = "Ulepsza twoją zdolność regeneracji\n\t• Leczenie zwiększone o [+regen_mult]",
		},
		regen2 = {
			name = "Krzyk Rozpaczy II",
			info = "Ulepsza twoją zdolność regeneracji\n\t• Szybkość zyskiwania ładunków zwiększona o [/regen_stacks]",
		},
		regen3 = {
			name = "Krzyk Rozpaczy III",
			info = "Ulepsza twoją zdolność regeneracji\n\t• Leczenie zwiększone o [+regen_mult]\n\t• Szybkość zyskiwania ładunków zwiększona o [/regen_stacks]",
		},
		spec1 = {
			name = "Łaska I",
			info = "Ulepsza twoją specjalną zdolność i dodaje drenaż zdrowia psychicznego\n\t• Zyskujesz [+spec_mult] więcej ładunków\n\t• Drenaż zdrowia psychicznego: [sanity]",
		},
		spec2 = {
			name = "Łaska II",
			info = "Ulepsza twoją specjalną zdolność\n\t• Zyskujesz [+spec_mult] więcej ładunków\n\t• Drenaż zdrowia psychicznego: [sanity]",
		},
	}
}

wep.SCP106 = {
	cancel = "Naciśnij [%s], aby anulować",

	skills = {
		_overview = { "passive", "wither", "teleport", "trap" },
		withering = {
			name = "Obumieranie",
			dsc = "Nadaj celowi efekt obumierania. Obumieranie stopniowo spowalnia cel w czasie. Atakowanie celu, który jest wewnątrz Kieszonkowego Wymiaru, natychmiast go zabija\n\nCzas trwania efektu [dur]\nMaksymalne spowolnienie: [slow]",
		},
		trap = {
			name = "Pułapka",
			dsc = "Umieść pułapkę na ścianie. Kiedy pułapka się aktywuje, cel zostaje spowolniony i możesz ponownie użyć tej umiejętności, aby natychmiast teleportować się do tej pułapki",
		},
		teleport = {
			name = "Teleportacja",
			dsc = "Użyj, aby umieścić punkt teleportacji. Trzymając się blisko istniejącego punktu teleportacji, możesz wybrać miejsce docelowe, zwolnij, aby teleportować się do wybranego miejsca",
		},
		passive = {
			name = "Kolekcja Zębów",
			dsc = "Kule nie mogą cię zabić, ale mogą tymczasowo cię powalić, także możesz przechodzić przez drzwi. Dotknięcie gracza teleportuje go do Kieszonkowego Wymiaru. Każdy gracz teleportowany do Kieszonkowego Wymiaru przyznaje jeden ząb. Zebrane zęby wzmacniają twoją umiejętność zwiędnięcia",
		},
		teleport_cd = {
			name = "Teleportacja",
			dsc = "Pokazuje czas odnowienia punktu teleportacji",
		},
		passive_bar = {
			name = "Kolekcja Zębów",
			dsc = "Kiedy ten pasek osiągnie zero, zostaniesz powalony",
		},
		trap_bar = {
			name = "Pułapka",
			dsc = "Pokazuje, jak długo pułapka będzie aktywna",
		}
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Kolekcja Zębów I",
			info = "Ulepsza twoją umiejętność pasywną\n\t• Zwiększa obrażenia wymagane do powalenia cię o [+passive_dmg]\n\t• Skraca czas ogłuszenia po powaleniu o [-passive_cd]",
		},
		passive2 = {
			name = "Kolekcja Zębów II",
			info = "Ulepsza twoją umiejętność pasywną\n\t• Zwiększa obrażenia wymagane do powalenia cię o [+passive_dmg]\n\t• Obrażenia zadawane graczom zwiększone o [+teleport_dmg]",
		},
		passive3 = {
			name = "Kolekcja Zębów III",
			info = "Ulepsza twoją umiejętność pasywną\n\t• Zwiększa obrażenia wymagane do powalenia cię o [+passive_dmg]\n\t• Skraca czas ogłuszenia po powaleniu o [-passive_cd]\n\t• Obrażenia zadawane graczom zwiększone o [+teleport_dmg]",
		},
		withering1 = {
			name = "Obumieranie I",
			info = "Ulepsza twoją umiejętność obumierania\n\t• Skraca czas odnowienia o [-attack_cd]\n\t• Zwiększa podstawowy czas trwania efektu o [+withering_dur]",
		},
		withering2 = {
			name = "Obumieranie II",
			info = "Ulepsza twoją umiejętność obumierania\n\t• Skraca czas odnowienia o [-attack_cd]\n\t• Zwiększa podstawowe spowolnienie efektu o [+withering_slow]",
		},
		withering3 = {
			name = "Obumieranie III",
			info = "Ulepsza twoją umiejętność obumierania\n\t• Skraca czas odnowienia o [-attack_cd]\n\t• Zwiększa podstawowy czas trwania efektu o [+withering_dur]\n\t• Zwiększa podstawowe spowolnienie efektu o [+withering_slow]",
		},
		tp1 = {
			name = "Teleportacja I",
			info = "Ulepsza twoją umiejętność teleportacji\n\t• Maksymalna liczba punktów zwiększona o [spot_max]\n\t• Skraca czas odnowienia punktu o [-spot_cd]",
		},
		tp2 = {
			name = "Teleportacja II",
			info = "Ulepsza twoją umiejętność teleportacji\n\t• Maksymalna liczba punktów zwiększona o [spot_max]\n\t• Skraca czas odnowienia teleportacji o [-tp_cd]",
		},
		tp3 = {
			name = "Teleportacja III",
			info = "Ulepsza twoją umiejętność teleportacji\n\t• Maksymalna liczba punktów zwiększona o [spot_max]\n\t• Skraca czas odnowienia punktu o [-spot_cd]\n\t• Skraca czas odnowienia teleportacji o [-tp_cd]",
		},
		trap1 = {
			name = "Pułapka I",
			info = "Ulepsza twoją umiejętność pułapki\n\t• Skraca czas odnowienia pułapki o [-trap_cd]\n\t• Zwiększa czas życia pułapki o [+trap_life]",
		},
		trap2 = {
			name = "Pułapka II",
			info = "Ulepsza twoją umiejętność pułapki\n\t• Skraca czas odnowienia pułapki o [-trap_cd]\n\t• Zwiększa czas życia pułapki o [+trap_life]",
		},
	}
}

local scp173_prot = {
	name = "Wzmocniony Beton",
	info = "• Zyskujesz redukcję obrażeń od kul o [%prot]\n• Ta umiejętność łączy się z innymi umiejętnościami tego samego typu",
}

wep.SCP173 = {
	restricted = "Ograniczony!",

	skills = {
		_overview = { "gas", "decoy", "stealth" },
		gas = {
			name = "Gaz",
			dsc = "Emituj chmurę drażniącego gazu, która spowolni, ograniczy widoczność i zwiększy częstotliwość mrugania pobliskich graczy",
		},
		decoy = {
			name = "Wabik",
			dsc = "Umieść wabik, który będzie rozpraszał i wysysał poczytalność graczy",
		},
		stealth = {
			name = "Kamuflaż",
			dsc = "Wejdź w tryb kamuflażu. W trybie kamuflażu jesteś niewidzialny i możesz przechodzić przez drzwi. Dodatkowo, stajesz się niewrażliwy na obrażenia (obrażenia obszarowe, takie jak eksplozje, mogą cię nadal dosięgnąć), ale również nie możesz zadawać obrażeń graczom ani wchodzić w interakcje ze światem",
		},
		looked_at = {
			name = "Zamrożenie!",
			dsc = "Pokazuje, czy ktoś na ciebie patrzy",
		},
		next_decoy = {
			name = "Ładunki wabików",
			dsc = "Liczba dostępnych wabików",
		},
		stealth_bar = {
			name = "Kamuflaż",
			dsc = "Pozostały czas umiejętności kamuflażu",
		},
	},

	upgrades = {
		parse_description = true,

		horror_a = {
			name = "Przytłaczająca Obecność",
			info = "Zasięg horroru jest zwiększony o [+horror_dist]",
		},
		horror_b = {
			name = "Niepokojąca Obecność",
			info = "Wysysanie poczytalności przez horror jest zwiększone o [+horror_sanity]",
		},
		attack_a = {
			name = "Szybki Zabójca",
			info = "Zasięg zabójstwa jest zwiększony o [+snap_dist]",
		},
		attack_b = {
			name = "Zwinny Zabójca",
			info = "Zasięg ruchu jest zwiększony o [+move_dist]",
		},
		gas1 = {
			name = "Gaz I",
			info = "Zasięg gazu jest zwiększony o [+gas_dist]",
		},
		gas2 = {
			name = "Gaz II",
			info = "Zasięg gazu jest zwiększony o [+gas_dist] i czas odnowienia gazu jest skrócony o [-gas_cd]",
		},
		decoy1 = {
			name = "Wabik I",
			info = "Czas odnowienia wabika jest skrócony o [-decoy_cd]",
		},
		decoy2 = {
			name = "Wabik II",
			info = "• Czas odnowienia wabika jest skrócony do 0.5s\n• Oryginalny czas odnowienia dotyczy ładunków wabików\n• Limit wabików jest zwiększony o [decoy_max]",
		},
		stealth1 = {
			name = "Kamuflaż I",
			info = "Czas odnowienia kamuflażu jest skrócony o [-stealth_cd]",
		},
		stealth2 = {
			name = "Kamuflaż II",
			info = "• Czas odnowienia kamuflażu jest skrócony o [-stealth_cd]\n• Czas trwania kamuflażu jest zwiększony o [+stealth_dur]",
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
			name = "Kula Ognia",
			dsc = "Koszt paliwa: [cost]\nWystrzel kulę ognia, która będzie podróżować do momentu zderzenia z czymś",
		},
		trap = {
			name = "Pułapka",
			dsc = "Koszt paliwa: [cost]\nUmieść pułapkę, która podpali graczy, którzy ją dotkną",
		},
		ignite = {
			name = "Wewnętrzna Wściekłość",
			dsc = "Koszt paliwa: [cost] za każdą wywołaną falę ognia\nWypuść fale płomieni wokół siebie. Zasięg tej umiejętności jest nieograniczony, a każda kolejna fala ognia zużywa więcej paliwa. Ta umiejętność nie może zostać przerwana",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Podpalasz każdego, kogo dotkniesz. Podpalenie gracza dodaje paliwo",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Żywa Pochodnia I",
			info = "Ulepsza twoją pasywną umiejętność\n\t• Zasięg ognia zwiększony o [+fire_radius]\n\t• Ilość paliwa zyskana zwiększona o [+fire_fuel]",
		},
		passive2 = {
			name = "Żywa Pochodnia II",
			info = "Ulepsza twoją pasywną umiejętność\n\t• Zasięg ognia zwiększony o [+fire_radius]\n\t• Obrażenia od ognia zwiększone o [+fire_dmg]",
		},
		passive3 = {
			name = "Żywa Pochodnia III",
			info = "Ulepsza twoją pasywną umiejętność\n\t• Ilość paliwa zyskana zwiększona o [+fire_fuel]\n\t• Obrażenia od ognia zwiększone o [+fire_dmg]",
		},
		passive_heal1 = {
			name = "Płomień Życia I",
			info = "Leczysz się o [%fire_heal] obrażeń zadanych przez ogień z jakiejkolwiek twojej umiejętności",
		},
		passive_heal2 = {
			name = "Płomień Życia II",
			info = "Leczysz się o [%fire_heal] obrażeń zadanych przez ogień z jakiejkolwiek twojej umiejętności",
		},
		fireball1 = {
			name = "Gra w Zbijaka I",
			info = "Ulepsza twoją umiejętność kuli ognia\n\t• Czas odnowienia skrócony o [-fireball_cd]\n\t• Prędkość zwiększona o [+fireball_speed]\n\t• Koszt paliwa zmniejszony o [-fireball_cost]",
		},
		fireball2 = {
			name = "Gra w Zbijaka II",
			info = "Ulepsza twoją umiejętność kuli ognia\n\t• Obrażenia zwiększone o [+fireball_dmg]\n\t• Rozmiar zwiększony o [+fireball_size]\n\t• Koszt paliwa zmniejszony o [-fireball_cost]",
		},
		fireball3 = {
			name = "Gra w Zbijaka III",
			info = "Ulepsza twoją umiejętność kuli ognia\n\t• Czas odnowienia skrócony o [-fireball_cd]\n\t• Obrażenia zwiększone o [+fireball_dmg]\n\t• Prędkość zwiększona o [+fireball_speed]",
		},
		trap1 = {
			name = "To Pułapka! I",
			info = "Ulepsza twoją umiejętność pułapki\n\t• Dodatkowe pułapki: [trap_max]\n\t• Koszt paliwa zmniejszony o [-trap_cost]\n\t• Czas działania zwiększony o [+trap_time]",
		},
		trap2 = {
			name = "To Pułapka! II",
			info = "Ulepsza twoją umiejętność pułapki\n\t• Dodatkowe pułapki: [trap_max]\n\t• Obrażenia zwiększone o [+trap_dmg]\n\t• Czas działania zwiększony o [+trap_time]",
		},
		trap3 = {
			name = "To Pułapka! III",
			info = "Ulepsza twoją umiejętność pułapki\n\t• Koszt paliwa zmniejszony o [-trap_cost]\n\t• Obrażenia zwiększone o [+trap_dmg]\n\t• Czas działania zwiększony o [+trap_time]",
		},
		ignite1 = {
			name = "Wewnętrzna Wściekłość I",
			info = "Ulepsza twoją umiejętność wewnętrznej wściekłości\n\t• Szybkość fal zwiększona o [/ignite_rate]\n\t• Pierwsza fala wywołuje dodatkowe [ignite_flames] płomienie",
		},
		ignite2 = {
			name = "Wewnętrzna Wściekłość II",
			info = "Ulepsza twoją umiejętność wewnętrznej wściekłości\n\t• Koszt paliwa zmniejszony o [-ignite_cost]\n\t• Pierwsza fala wywołuje dodatkowe [ignite_flames] płomienie",
		},
		fuel = {
			name = "Dostawa Paliwa!",
			info = "Natychmiast zyskujesz [fuel] paliwa",
		}
	}
}

wep.SCP682 = {
	skills = {
		_overview = { "primary", "secondary", "charge", "shield" },
		primary = {
			name = "Podstawowy atak",
			dsc = "Atakuj ręką bezpośrednio przed sobą, zadając niewielkie obrażenia",
		},
		secondary = {
			name = "Gryzienie",
			dsc = "Przytrzymaj klawisz, aby przygotować silny atak, który zada duże obrażenia w stożkowatym obszarze przed tobą",
		},
		charge = {
			name = "Szarża",
			dsc = "Po krótkim opóźnieniu szarżujesz do przodu i stajesz się niepowstrzymany. Przy pełnej prędkości zabijasz wszystkich na swojej drodze i zyskujesz zdolność do przełamywania większości drzwi. Ta umiejętność musi zostać odblokowana w drzewku ulepszeń",
		},
		shield = {
			name = "Tarcza",
			dsc = "Tarcza, która absorbuje każde obrażenia inne niż bezpośrednie/upadek. Ta umiejętność jest modyfikowana przez zakupione ulepszenia w twoim drzewku ulepszeń",
		},
		shield_bar = {
			name = "Tarcza",
			dsc = "Aktualna ilość tarczy, która absorbuje każde obrażenia inne niż bezpośrednie/upadek",
		},
	},

	upgrades = {
		parse_description = true,

		shield_a = {
			name = "Wzmocniona Tarcza",
			info = "Ulepsza moc twojej tarczy\n\t• Moc tarczy: [%shield]\n\t• Czas odnowienia: [%shield_cd]",
		},
		shield_b = {
			name = "Regeneracyjna Tarcza",
			info = "Zmienia moc twojej tarczy\n\t• Moc tarczy: [%shield]\n\t• Czas odnowienia: [%shield_cd]\n\t• Czas odnowienia rozpoczyna się po całkowitym wyczerpaniu tarczy\n\t• Gdy tarcza jest w czasie odnowienia, regenerujesz [shield_regen] HP/s",
		},
		shield_c = {
			name = "Tarcza Ofiary",
			info = "Zmienia moc twojej tarczy\n\t• Czas odnowienia: [%shield_cd]\n\t• Czas odnowienia rozpoczyna się po całkowitym wyczerpaniu tarczy\n\t• Moc twojej tarczy jest równa twojemu maksymalnemu HP\n\t• Gdy tarcza pęka, tracisz [shield_hp] maksymalnego HP",
		},
		shield_d = {
			name = "Odbijająca Tarcza",
			info = "Zmienia moc twojej tarczy\n\t• Moc tarczy: [%shield]\n\t• Czas odnowienia: [%shield_cd]\n\t• Czas odnowienia rozpoczyna się po całkowitym wyczerpaniu tarczy\n\t• Twoja tarcza blokuje tylko [%shield_pct] obrażeń\n\t• [%reflect_pct] z zablokowanych obrażeń jest odbijane do atakującego",
		},

		shield_1 = {
			name = "Tarcza I",
			info = "Dodaje efekty do twojej tarczy. Po całkowitym wyczerpaniu tarczy otrzymujesz dodatkowe [+shield_speed_pow] prędkości ruchu na [shield_speed_dur] sekund",
		},
		shield_2 = {
			name = "Tarcza II",
			info = "Dodaje efekty do twojej tarczy. Po całkowitym wyczerpaniu tarczy otrzymujesz dodatkowe [+shield_speed_pow] prędkości ruchu na [shield_speed_dur] sekund. Dodatkowo, każdy 1 punkt otrzymanych obrażeń skraca czas odnowienia tarczy o [shield_cdr] sekund",
		},

		attack_1 = {
			name = "Wzmocniony Zamach",
			info = "Ulepsza twój podstawowy atak\n\t• Czas odnowienia skrócony o [-prim_cd]\n\t• Obrażenia zwiększone o [prim_dmg]",
		},
		attack_2 = {
			name = "Wzmocnione Gryzienie",
			info = "Ulepsza twoje gryzienie\n\t• Zasięg zwiększony o [+sec_range]\n\t• Prędkość ruchu podczas przygotowania zwiększona o [+sec_speed]",
		},
		attack_3 = {
			name = "Bezlitosne Uderzenie",
			info = "Ulepsza zarówno podstawowy atak, jak i gryzienie\n\t• Oba ataki zadają krwawienie\n\t• Atak gryzienia zadaje złamanie, gdy jest w pełni naładowany",
		},

		charge_1 = {
			name = "Szarża",
			info = "Odblokowuje umiejętność szarży",
		},
		charge_2 = {
			name = "Bezlitosna Szarża",
			info = "Wzmacnia umiejętność szarży\n\t• Czas odnowienia skrócony o [-charge_cd]\n\t• Czas ogłuszenia i spowolnienia skrócony o [-charge_stun]",
		}
	}
}

wep.SCP8602 = {
	skills = {
		_overview = { "passive", "primary", "defense", "charge" },
		primary = {
			name = "Atak",
			dsc = "Wykonaj podstawowy atak",
		},
		defense = {
			name = "Postawa Obronna",
			dsc = "Przytrzymaj, aby aktywować. Podczas przytrzymywania zyskujesz ochronę z czasem, ale jesteś również spowolniony. Zwolnij, aby rzucić się do przodu i zadać obrażenia równe [dmg_ratio] pochłoniętych obrażeń. Ta umiejętność nie ma limitu czasu trwania",
		},
		charge = {
			name = "Szarża",
			dsc = "Zyskuj prędkość z czasem i zadaj obrażenia pierwszemu graczowi przed sobą. Jeśli zaatakowany gracz jest wystarczająco blisko ściany, przypnij go do tej ściany, aby zwiększyć obrażenia",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Widzisz gracza w swoim lesie i przez jakiś czas po jego opuszczeniu. Gracze w lesie tracą poczytalność, jeśli nie mają poczytalności, tracą zdrowie. Leczenie za przejętą poczytalność/zdrowie od graczy w lesie. To leczenie może przekroczyć twoje maksymalne zdrowie",
		},
		overheal_bar = {
			name = "Nadleczenie",
			dsc = "Nadleczone zdrowie",
		},
		defense_bar = {
			name = "Obrona",
			dsc = "Aktualna moc ochrony",
		},
		charge_bar = {
			name = "Szarża",
			dsc = "Pozostały czas szarży",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Gęste Lasy I",
			info = "Ulepsza twoją pasywną zdolność\n\t• Maksymalne nadleczenie zwiększone o [+overheal]\n\t• Szybkość pasywna zwiększona o [/passive_rate]\n\t• Czas wykrywania gracza zwiększony o [+detect_time]",
		},
		passive2 = {
			name = "Gęste Lasy II",
			info = "Ulepsza twoją pasywną zdolność\n\t• Maksymalne nadleczenie zwiększone o [+overheal]\n\t• Szybkość pasywna zwiększona o [/passive_rate]\n\t• Czas wykrywania gracza zwiększony o [+detect_time]",
		},
		primary = {
			name = "Proste ale Niebezpieczne",
			info = "Ulepsza twój podstawowy atak\n\t• Czas odnowienia skrócony o [-primary_cd]\n\t• Obrażenia zwiększone o [+primary_dmg]",
		},
		def1a = {
			name = "Zwinna Zbroja",
			info = "Zmienia twoją zdolność obronnej postawy\n\t• Czas aktywacji skrócony o [-def_time]\n\t• Czas odnowienia zwiększony o [+def_cooldown]",
		},
		def1b = {
			name = "Szybka Zbroja",
			info = "Zmienia twoją zdolność obronnej postawy\n\t• Czas aktywacji zwiększony o [+def_time]\n\t• Czas odnowienia skrócony o [-def_cooldown]",
		},
		def2a = {
			name = "Długi Rzut",
			info = "Zmienia twoją zdolność obronnej postawy\n\t• Maksymalny dystans rzutu zwiększony o [+def_range]\n\t• Szerokość rzutu zmniejszona o [-def_width]",
		},
		def2b = {
			name = "Niezgrabny Rzut",
			info = "Zmienia twoją zdolność obronnej postawy\n\t• Maksymalny dystans rzutu zmniejszony o [-def_range]\n\t• Szerokość rzutu zwiększona o [+def_width]",
		},
		def3a = {
			name = "Ciężka Zbroja",
			info = "Zmienia twoją zdolność obronnej postawy\n\t• Maksymalna ochrona zwiększona o [+def_prot]\n\t• Maksymalne spowolnienie zwiększone o [+def_slow]",
		},
		def3b = {
			name = "Lekka Zbroja",
			info = "Zmienia twoją zdolność obronnej postawy\n\t• Maksymalna ochrona zmniejszona o [-def_prot]\n\t• Maksymalne spowolnienie zmniejszone o [-def_slow]",
		},
		def4 = {
			name = "Efektywna Zbroja",
			info = "Ulepsza twoją zdolność obronnej postawy\n\t• Współczynnik konwersji obrażeń zwiększony o [+def_mult]",
		},
		charge1 = {
			name = "Szarża I",
			info = "Ulepsza twoją zdolność szarży\n\t• Czas odnowienia skrócony o [-charge_cd]\n\t• Czas trwania zwiększony o [+charge_time]\n\t• Podstawowe obrażenia zwiększone o [+charge_dmg]",
		},
		charge2 = {
			name = "Szarża II",
			info = "Ulepsza twoją zdolność szarży\n\t• Zasięg zwiększony o [+charge_range]\n\t• Czas trwania zwiększony o [+charge_time]\n\t• Obrażenia przypięcia zwiększone o [+charge_pin_dmg]",
		},
		charge3 = {
			name = "Szarża III",
			info = "Ulepsza twoją zdolność szarży\n\t• Prędkość zwiększona o [+charge_speed]\n\t• Podstawowe obrażenia zwiększone o [+charge_dmg]\n\t• Przypięcie gracza do ściany łamie jego kości",
		},
	}
}

wep.SCP939 = {
	skills = {
		_overview = { "passive", "primary", "trail", "special" },
		primary = {
			name = "Atak",
			dsc = "Ugryź wszystkich w stożkowym obszarze przed sobą",
		},
		trail = {
			name = "ANM-C227",
			dsc = "Przytrzymaj klawisz, aby pozostawić ślad ANM-C227 za sobą",
		},
		special = {
			name = "Detekcja",
			dsc = "Zacznij wykrywać graczy wokół siebie",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Nie widzisz graczy, ale widzisz fale dźwiękowe. Masz aurę ANM-C227 wokół siebie",
		},
		special_bar = {
			name = "Detekcja",
			dsc = "Pozostały czas detekcji",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Aura I",
			info = "Ulepsza twoją pasywną zdolność\n\t• Promień aury zwiększony o [+aura_radius]\n\t• Obrażenia aury zwiększone o [aura_damage]",
		},
		passive2 = {
			name = "Aura II",
			info = "Ulepsza twoją pasywną zdolność\n\t• Promień aury zwiększony o [+aura_radius]\n\t• Obrażenia aury zwiększone o [aura_damage]",
		},
		passive3 = {
			name = "Aura III",
			info = "Ulepsza twoją pasywną zdolność\n\t• Promień aury zwiększony o [+aura_radius]\n\t• Obrażenia aury zwiększone o [aura_damage]",
		},
		attack1 = {
			name = "Ugryzienie I",
			info = "Ulepsza twoją zdolność ataku\n\t• Czas odnowienia skrócony o [-attack_cd]\n\t• Obrażenia zwiększone o [+attack_dmg]",
		},
		attack2 = {
			name = "Ugryzienie II",
			info = "Ulepsza twoją zdolność ataku\n\t• Czas odnowienia skrócony o [-attack_cd]\n\t• Zasięg zwiększony o [+attack_range]",
		},
		attack3 = {
			name = "Ugryzienie III",
			info = "Ulepsza twoją zdolność ataku\n\t• Obrażenia zwiększone o [+attack_dmg]\n\t• Zasięg zwiększony o [+attack_range]\n\t• Twoje ataki mają szansę na wywołanie krwawienia",
		},
		trail1 = {
			name = "Amnezja I",
			info = "Ulepsza twoją zdolność ANM-C227\n\t• Promień zwiększony o [+trail_radius]\n\t• Szybkość generowania ładunków zwiększona o [/trail_rate]",
		},
		trail2 = {
			name = "Amnezja II",
			info = "Ulepsza twoją zdolność ANM-C227\n\t• Obrażenia zwiększone o [trail_dmg]\n\t• Maksymalna liczba ładunków zwiększona o [+trail_stacks]",
		},
		trail3a = {
			name = "Amnezja III A",
			info = "Ulepsza twoją zdolność ANM-C227\n\t• Czas trwania śladu zwiększony o [+trail_life]\n\t• Promień zwiększony o [+trail_radius]",
		},
		trail3b = {
			name = "Amnezja III B",
			info = "Ulepsza twoją zdolność ANM-C227\n\t• Maksymalna liczba ładunków zwiększona o [+trail_stacks]",
		},
		trail3c = {
			name = "Amnezja III C",
			info = "Ulepsza twoją zdolność ANM-C227\n\t• Szybkość generowania ładunków zwiększona o [/trail_rate]",
		},
		special1 = {
			name = "Echolokacja I",
			info = "Ulepsza twoją specjalną zdolność\n\t• Czas odnowienia skrócony o [-special_cd]\n\t• Promień zwiększony o [+special_radius]",
		},
		special2 = {
			name = "Echolokacja II",
			info = "Ulepsza twoją specjalną zdolność\n\t• Czas odnowienia skrócony o [-special_cd]\n\t• Czas trwania zwiększony o [+special_times]",
		},
	}
}

wep.SCP966 = {
	fatigue = "Poziom zmęczenia:",

	skills = {
		_overview = { "passive", "attack", "channeling", "mark" },
		attack = {
			name = "Podstawowy atak",
			dsc = "Wykonaj podstawowy atak. Możesz atakować tylko graczy z co najmniej 10 ładunkami zmęczenia. Atakowani gracze tracą część ładunków zmęczenia. Efekty tego ataku zależą od drzewa umiejętności",
		},
		channeling = {
			name = "Kanałowanie",
			dsc = "Kanałuj zdolność wybraną w drzewie umiejętności",
		},
		mark = {
			name = "Znak Śmierci",
			dsc = "Oznacz gracza. Oznaczeni gracze będą przenosić ładunki zmęczenia z innych pobliskich graczy na siebie",
		},
		passive = {
			name = "Zmęczenie",
			dsc = "Od czasu do czasu nakładasz ładunki zmęczenia na pobliskich graczy. Zyskujesz również pasywne ładunki za każdy nałożony ładunek zmęczenia",
		},
		channeling_bar = {
			name = "Kanałowanie",
			dsc = "Pozostały czas kanałowanej zdolności",
		},
		mark_bar = {
			name = "Znak Śmierci",
			dsc = "Pozostały czas znaku na oznaczonym graczu",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Zmęczenie I",
			info = "Ulepsza twoją pasywną zdolność\n\t• Szybkość pasywna zwiększona o [/passive_rate]",
		},
		passive2 = {
			name = "Zmęczenie II",
			info = "Ulepsza twoją pasywną zdolność\n\t• Szybkość pasywna zwiększona o [/passive_rate]\n\t• Zasięg pasywny zwiększony o [+passive_radius]",
		},
		basic1 = {
			name = "Ostre Pazury I",
			info = "Ulepsza twój podstawowy atak, zwiększając obrażenia o [%basic_dmg] za każdy [basic_stacks] pasywny ładunek. Dodatkowo, zyskując pasywne ładunki, odblokowuje:\n\t• [bleed1_thr] ładunków: Nakłada krwawienie, jeśli cel nie krwawi\n\t• [drop1_thr] ładunków: Zmniejsza utratę ładunków zmęczenia celu do [%drop1]\n\t• [slow_thr] ładunki: Cel jest spowolniony o [-slow_power] na [slow_dur] sekund",
		},
		basic2 = {
			name = "Ostre Pazury II",
			info = "Ulepsza twój podstawowy atak, zwiększając obrażenia o [%basic_dmg] za każdy [basic_stacks] pasywny ładunek. Dodatkowo, zyskując pasywne ładunki, odblokowuje:\n\t• [bleed2_thr] ładunków: Nakłada krwawienie przy trafieniu\n\t• [drop2_thr] ładunków: Zmniejsza utratę ładunków zmęczenia celu do [%drop2]\n\t• [hb_thr] ładunków: Nakłada ciężkie krwawienie zamiast krwawienia przy trafieniu",
		},
		heal = {
			name = "Wysysanie Krwi",
			info = "Ulecz [%heal_rate] za każdy pasywny ładunek na każdy ładunek zmęczenia celu przy trafieniu",
		},
		channeling_a = {
			name = "Nieskończone Zmęczenie",
			info = "Odblokowuje zdolność kanałowania, która pozwala skupić się na jednym celu\n\t• Pasywna jest wyłączona podczas kanałowania\n\t• Czas odnowienia [channeling_cd] sekund\n\t• Maksymalny czas trwania [channeling_time] sekund\n\t• Cel zyskuje ładunkek zmęczenia co [channeling_rate] sekund",
		},
		channeling_b = {
			name = "Wysysanie Energii",
			info = "Odblokowuje zdolność kanałowania, która pozwala wysysać ładunki zmęczenia z pobliskich graczy\n\t• Pasywna jest wyłączona podczas kanałowania\n\t• Czas odnowienia [channeling_cd] sekund\n\t• Maksymalny czas trwania [channeling_time] sekund\n\t• Każde [channeling_rate] sekund, przenosi 1 ładunek zmęczenia od wszystkich pobliskich graczy do pasywnych ładunków",
		},
		channeling = {
			name = "Wzmocnione Kanałowanie",
			info = "Ulepsza twoją zdolność kanałowania\n\t• Zasięg kanałowania zwiększony o [+channeling_range_mul]\n\t• Czas trwania kanałowania zwiększony o [+channeling_time_mul]",
		},
		mark1 = {
			name = "Śmiertelny Znak I",
			info = "Ulepsza zdolność oznaczania:\n\t• Szybkość przenoszenia ładunków zwiększona o [/mark_rate]",
		},
		mark2 = {
			name = "Śmiertelny Znak II",
			info = "Ulepsza zdolność oznaczania:\n\t• Szybkość przenoszenia ładunków zwiększona o [/mark_rate]\n\t• Zasięg przenoszenia ładunków zwiększony o [+mark_range]",
		},
	}
}

wep.SCP24273 = {
	skills = {
		_overview = { "change", "primary", "secondary", "special" },
		primary = {
			name = "Szarańcza / Kamuflaż",
			dsc = "\nSędzia:\nRusz naprzód, zadając obrażenia wszystkim na swojej drodze\n\nProkurator:\nAktywuj kamuflaż. Podczas kamuflażu jesteś mniej widoczny. Używanie umiejętności, poruszanie się lub otrzymywanie obrażeń przerywa go",
		},
		secondary = {
			name = "Egzaminacja / Nadzór",
			dsc = "\nSędzia:\nSkup się na wybranym graczu przez jakiś czas. Po pełnym wykonaniu, spowolnij cel i zadaj obrażenia. Jeśli utracisz linię wzroku, umiejętność zostaje przerwana, a ty zostajesz spowolniony\n\nProkurator:\nOpuszcz swoje ciało i patrz z perspektywy losowego pobliskiego gracza. Twoja pasywna zdolność również działa z perspektywy tego gracza",
		},
		special = {
			name = "Wyrok / Duch",
			dsc = "\nSędzia:\nPozostaj na miejscu i zmuszaj wszystkich w pobliżu do zbliżania się do ciebie. Po zakończeniu, gracze w bliskiej odległości otrzymują obrażenia i zostają odrzuceni\n\nProkurator:\nWejdź w formę ducha. W formie ducha jesteś odporny na wszelkie obrażenia (z wyjątkiem wybuchów i bezpośrednich obrażeń)",
		},
		change = {
			name = "Sędzia / Prokurator",
			dsc = "\nZmiana między trybem Sędziego i Prokuratora\n\nSędzia:\nObrażenia, które zadajesz, są zwiększane przez dowody zgromadzone na celu. Atakowanie celu zmniejsza poziom dowodów. Atakowanie graczy z pełnym dowodem natychmiast ich zabija\n\nProkurator:\nJesteś spowolniony i otrzymujesz ochronę przed obrażeniami od kul. Patrzenie na graczy gromadzi dowody przeciwko nim",
		},
		camo_bar = {
			name = "Kamuflaż",
			dsc = "Pozostały czas kamuflażu",
		},
		spectate_bar = {
			name = "Nadzór",
			dsc = "Pozostały czas nadzoru",
		},
		drain_bar = {
			name = "Egzaminacja",
			dsc = "Pozostały czas egzaminacji",
		},
		ghost_bar = {
			name = "Duch",
			dsc = "Pozostały czas formy ducha",
		},
		special_bar = {
			name = "Wyrok",
			dsc = "Pozostały czas wyroku",
		},
	},

	upgrades = {
		parse_description = true,

		j_passive1 = {
			name = "Surowy Sędzia I",
			info = "Ulepsza twoją pasywną zdolność sędziego\n\t• Dowody zwiększają obrażenia do dodatkowych [%j_mult]\n\t• Utrata dowodów przy ataku zmniejszona do [%j_loss]",
		},
		j_passive2 = {
			name = "Surowy Sędzia II",
			info = "Ulepsza twoją pasywną zdolność sędziego\n\t• Dowody zwiększają obrażenia do dodatkowych [%j_mult]\n\t• Utrata dowodów przy ataku zmniejszona do [%j_loss]",
		},
		p_passive1 = {
			name = "Prokurator Rejonowy I",
			info = "Ulepsza twoją pasywną zdolność prokuratora\n\t• Ochrona przed kulami zwiększona do [%p_prot]\n\t• Spowolnienie zwiększone do [%p_slow]\n\t• Szybkość gromadzenia dowodów zwiększona do [%p_rate] na sekundę",
		},
		p_passive2 = {
			name = "Prokurator Rejonowy II",
			info = "Ulepsza twoją pasywną zdolność prokuratora\n\t• Ochrona przed kulami zwiększona do [%p_prot]\n\t• Spowolnienie zwiększone do [%p_slow]\n\t• Szybkość gromadzenia dowodów zwiększona do [%p_rate] na sekundę",
		},
		dash1 = {
			name = "Szarańcza I",
			info = "Ulepsza twoją zdolność szarańczy\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Obrażenia zwiększone o [+dash_dmg]",
		},
		dash2 = {
			name = "Szarańcza II",
			info = "Ulepsza twoją zdolność szarańczy\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Obrażenia zwiększone o [+dash_dmg]",
		},
		camo1 = {
			name = "Kamuflaż I",
			info = "Ulepsza twoją zdolność kamuflażu\n\t• Czas odnowienia zmniejszony o [-camo_cd]\n\t• Czas trwania zwiększony o [+camo_dur]\n\t• Możesz poruszać się [camo_limit] jednostek bez przerywania tej zdolności",
		},
		camo2 = {
			name = "Kamuflaż II",
			info = "Ulepsza twoją zdolność kamuflażu\n\t• Czas odnowienia zmniejszony o [-camo_cd]\n\t• Czas trwania zwiększony o [+camo_dur]\n\t• Możesz poruszać się [camo_limit] jednostek bez przerywania tej zdolności",
		},
		drain1 = {
			name = "Egzaminacja I",
			info = "Ulepsza twoją zdolność pasywną prokuratora\n\t• Czas odnowienia zmniejszony o [-drain_cd]\n\t• Czas trwania zmniejszony o [-drain_dur]",
		},
		drain2 = {
			name = "Egzaminacja II",
			info = "Ulepsza twoją zdolność pasywną prokuratora\n\t• Czas odnowienia zmniejszony o [-drain_cd]\n\t• Czas trwania zmniejszony o [-drain_dur]",
		},
		spect1 = {
			name = "Nadzór I",
			info = "Ulepsza twoją zdolność pasywną prokuratora\n\t• Czas odnowienia zmniejszony o [-spect_cd]\n\t• Czas trwania zwiększony o [+spect_dur]\n\t• Ochrona przed obrażeniami od kul zwiększona do [%spect_prot]",
		},
		spect2 = {
			name = "Nadzór II",
			info = "Ulepsza twoją zdolność pasywną prokuratora\n\t• Czas odnowienia zmniejszony o [-spect_cd]\n\t• Czas trwania zwiększony o [+spect_dur]\n\t• Ochrona przed obrażeniami od kul zwiększona do [%spect_prot]",
		},
		combo = {
			name = "Sąd Najwyższy",
			info = "Ulepsza twoją zdolność wyroku i ducha\n\t• Ochrona wyroku zwiększona do [%special_prot]\n\t• Czas trwania ducha zwiększony o [+ghost_dur]",
		},
		spec = {
			name = "Wyrok",
			info = "Ulepsza twoją zdolność wyroku\n\t• Czas odnowienia zmniejszony o [-special_cd]\n\t• Czas trwania zwiększony o [+special_dur]\n\t• Ochrona zwiększona do [%special_prot]",
		},
		ghost1 = {
			name = "Duch I",
			info = "Ulepsza twoją zdolność ducha\n\t• Czas odnowienia zmniejszony o [-ghost_cd]\n\t• Czas trwania zwiększony o [+ghost_dur]\n\t• Leczenie zwiększone do [ghost_hel] za 1 spożyty dowód",
		},
		ghost2 = {
			name = "Duch II",
			info = "Ulepsza twoją zdolność ducha\n\t• Czas odnowienia zmniejszony o [-ghost_cd]\n\t• Czas trwania zwiększony o [+ghost_dur]\n\t• Leczenie zwiększone do [ghost_hel] za 1 spożyty dowód",
		},
		change1 = {
			name = "Zmiana I",
			info = "Czas odnowienia zmiany skrócony o [-change_cd]",
		},
		change2 = {
			name = "Zmiana II",
			info = "Czas odnowienia zmiany skrócony o [-change_cd]. Dodatkowo, zmiana trybu nie zakłóca już zdolności kamuflażu",
		},
	}
}

wep.SCP3199 = {
	skills = {
		_overview = { "passive", "primary", "special", "egg" },
		eggs_max = "Masz już maksymalną liczbę jajek!",

		primary = {
			name = "Attack",
			dsc = "Wykonaj podstawowy atak. Trafienie celu aktywuje (lub odnawia) szał, nakłada efekt głębokich ran oraz przyznaje ładunek pasywny i ładunek szału.\nAtaki zadają zmniejszone obrażenia celom z głębokimi ranami. Chybienie ataku przerywa szał. Trafienie tylko celu z głębokimi ranami przerywa szał i nakłada karę w ładunkach",
		},
		special = {
			name = "Atak z Zaświatów",
			dsc = "Aktywuje się po [tokens] udanych atakach z rzędu. Użyj, aby natychmiast zakończyć szał i uszkodzić wszystkich graczy, którzy mają głębokie rany. Dotknięci gracze są również spowolnieni",
		},
		egg = {
			name = "Jajka",
			dsc = "Po zabiciu gracza możesz złożyć jajko. Kiedy otrzymasz śmiertelne obrażenia, odrodzisz się przy losowym jajku. Odrodzenie zużywa jajko. Dodatkowo, każde jajko zapewnia [prot] ochrony przed kulami (z limitem [cap])\n\nObecne jajka: [eggs] / [max]",
		},
		passive = {
			name = "Umiejętność pasywna",
			dsc = "Podczas szału widzisz lokalizację pobliskich graczy bez głębokich ran. Zdobywanie ładunków szału również przyznaje ładunki pasywne. Jeśli twój atak trafi tylko gracza z głębokimi ranami, stracisz [penalty] ładunków. Ładunki pasywne ulepszają twoje inne umiejętności\n\nRegeneracja [heal] HP na sekundę podczas szału\nBonus do obrażeń ataku: [dmg]\nBonus do prędkości podczas szału: [speed]\nDodatkowe spowolnienie ataku specjalnego: [slow]\nAtaki specjalne zadają [bleed] poziom(y) krwawienia",
		},
		frenzy_bar = {
			name = "Szał",
			dsc = "Pozostały czas szału",
		},
		egg_bar = {
			name = "Jajko",
			dsc = "Pozostały czas do złożenia jajka",
		},
	},

	upgrades = {
		parse_description = true,

		frenzy1 = {
			name = "Szał I",
			info = "Ulepsza twoją umiejętność szału\n\t• Czas trwania zwiększony o [+frenzy_duration]\n\t• Maksymalne ładunki zwiększone o [frenzy_max]",
		},
		frenzy2 = {
			name = "Szał II",
			info = "Ulepsza twoją umiejętność szału\n\t• Maksymalne ładunki zwiększone o [frenzy_max]\n\t• Prędkość podczas szału zwiększona o [%frenzy_speed_stacks] za każdy ładunek pasywny",
		},
		frenzy3 = {
			name = "Szał III",
			info = "Ulepsza twoją umiejętność szału\n\t• Czas trwania zwiększony o [+frenzy_duration]\n\t• Prędkość podczas szału zwiększona o [%frenzy_speed_stacks] za każdy ładunek pasywny",
		},
		attack1 = {
			name = "Ostre Pazury I",
			info = "Ulepsza twoją umiejętność atakuy\n\t• Czas odnowienia skrócony o [-attack_cd]\n\t• Obrażenia zwiększone o [+attack_dmg]",
		},
		attack2 = {
			name = "Ostre Pazury II",
			info = "Ulepsza twoją umiejętność atakuy\n\t• Czas odnowienia skrócony o [-attack_cd]\n\t• Obrażenia zwiększone o [%attack_dmg_stacks] za każdy ładunek pasywny",
		},
		attack3 = {
			name = "Ostre Pazury III",
			info = "Ulepsza twoją umiejętność atakuy\n\t• Obrażenia zwiększone o [+attack_dmg]\n\t• Obrażenia zwiększone o [%attack_dmg_stacks] za każdy ładunek pasywny",
		},
		special1 = {
			name = "Atak z Zaświatów I",
			info = "Ulepsza twoją umiejętność specjalną\n\t• Obrażenia zwiększone o [+special_dmg]\n\t• Spowolnienie zwiększone o [%special_slow] za każdy ładunek pasywny\n\t• Czas trwania spowolnienia zwiększony o [+special_slow_duration]",
		},
		special2 = {
			name = "Atak z Zaświatów II",
			info = "Ulepsza twoją umiejętność specjalną\n\t• Obrażenia zwiększone o [+special_dmg]\n\t• Spowolnienie zwiększone o [%special_slow] za każdy ładunek pasywny\n\t• Czas trwania spowolnienia zwiększony o [+special_slow_duration]",
		},
		passive = {
			name = "Zmysł Krwi",
			info = "Zwiększona promień pasywnego wykrywania o [+passive_radius]",
		},
		egg = {
			name = "Jajko Wielkanocne",
			info = "Natychmiastowe złożenie nowego jajka. Ta umiejętność może przekroczyć limit jajek",
		},
	}
}

wep.SCP009 = {
	name = "SCP-009",
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
	name = "Dłonie",
	info = "Użyj, aby ukryć aktualnie wyposażony przedmiot"
}

wep.ID = {
	name = "ID",
	pname = "Nazwa:",
	server = "Serwer:",
}

wep.CAMERA = {
	name = "Monitoring",
	showname = "Kamery",
	info = "Kamery pozwalają zobaczyć, co dzieje się w placówce.\nZapewniają również możliwość skanowania obiektów SCP i przesyłania tych informacji na aktualny kanał radiowy",
	scanning = "Skanowanie...",
	scan_info = "Przytrzymaj [%s] aby skanować SCP",
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

wep.THERMAL = {
	showname = "THERMO",
	name = "Termowizja"
}

wep.ACCESS_CHIP = {
	name = "Czip dostępu",
	cname = "Czip dostępu - %s",
	showname = "CZIP",
	pickupname = "CZIP",
	clearance = "Poziom dostępu: %i",
	clearance2 = "Poziom dostępu: ",
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
		o5 = "O5",
		goc = "Zhakowana GOC",
	},
	SHORT = {
		general = "Ogólny",
		jan1 = "Woźny",
		jan = "Woźny",
		jan2 = "Starszy woźny",
		acc = "Księgowy",
		log = "Logistyk",
		sci1 = "Nauk. poz. 1",
		sci2 = "Nauk. poz. 2",
		sci3 = "Nauk. poz. 3",
		spec = "Spec. Zabez.",
		guard = "Ochrona",
		chief = "Szef Ochr.",
		mtf = "MTF",
		com = "Dow. MTF",
		hacked3 = "Zhakowana 3",
		hacked4 = "Zhakowana 4",
		hacked5 = "Zhakowana 5",
		director = "Dyrektor",
		o5 = "O5",
		goc = "GOC",
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
		GATE_A = "Brama A",
		GATE_B = "Brama B",
		GATE_C = "Brama C",
		FEMUR = "Femur Breaker",
		ALPHA = "Głowica Alfa",
		OMEGA = "Głowica Omega",
		PARTICLE = "Działo cząsteczkowe",
	},
}

wep.OMNITOOL = {
	name = "Omnitool",
	cname = "Omnitool - %s",
	showname = "Omnitool",
	pickupname = "Omnitool",
	none = "BRAK",
	chip = "Włożony chip: %s",
	chip2 = "Włożony chip: ",
	clearance = "Poziom dostępu: %i",
	clearance2 = "Poziom dostępu: ",
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

wep.FLASHLIGHT = {
	name = "Latarka"
}

wep.BATTERY = {
	name = "Bateria"
}

wep.GASMASK = {
	name = "Maska gazowa"
}

wep.HEAVYMASK = {
	name = "Ciężka maska gazowa"
}

wep.FUSE = {
	name = "Bezpiecznik",
	name_f = "Bezpiecznik %iA",
}

wep.TURRET = {
	name = "Wieżyczka",
	placing_turret = "Rozkładanie działka",
	pickup_turret = "Podnoszenie działka",
	pickup = "Podnieś",
	MODES = {
		off = "Wyłącz",
		filter = "Filtruj personel",
		target = "Atakuj personel",
		all = "Celuj we wszystko",
		supp = "Ogień zaporowy",
		scp = "Celuj w SCP"
	}
}

wep.ALPHA_CARD1 = {
	name = "Kod nuklearny głowicy ALPHA nr 1"
}

wep.ALPHA_CARD2 = {
	name = "Kod nuklearny głowicy ALPHA nr 2"
}

wep.COM_TAB = {
	name = "Tablet",
	loading = "Ładowanie",
	eta = "ETA: ",
	detected = "Wykryte obiekty:",
	tesla_deactivated = "Tesle nieaktywne: ",
	change = "PPM - zmień",
	confirm = "LPM - zatwierdź",
	options = {
		scan = "Skan placówki",
		tesla = "Wyłącz tesle"
	},
	actions = {
		scan = "Skanowanie placówki...",
		tesla = "Wyłączanie tesli...",
	}
}

wep.GOC_TAB = {
	name = "Tablet GOC",
	info = "Osobisty tablet GOC. Zawiera mały ładunek wybuchowy, który niszczy tablet w przypadku śmierci użytkownika",
	loading = "Ładowanie",
	status = "Status:",
	dist = "Odległość od celu",
	objectives = {
		failed = "Urządzenie zniszczone",
		nothing = "Nieznany",
		find = "Znajdź urządzenie",
		deliver = "Dostarcz urządzenie",
		escort = "Eskortuj urządzenie",
		protect = "Chroń urządzenie",
		escape = "Ucieknij"
	}
}

wep.GOCDEVICE = {
	name = "Urządzenie GOC",
	placing = "Rozkładania urządzenia GOC..."
}

wep.DOCUMENT = {
	name = "Dokumenty",
	info = "Pakiet kilku dokumentów, które mogą zawierać cenne informacje na temat obiektów SCP, placówki i personelu",
	types = {

	}
}

wep.BACKPACK = {
	name = "Plecak",
	info = "Umożliwia przechowywanie większej ilości przedmiotów",
	size = "Wielkość: ",
	NAMES = {
		small = "Mały Plecak",
		medium = "Średni Plecak",
		large = "Duży Plecak",
		huge = "Ogromny Plecak",
	}
}

wep.ADRENALINE = {
	name = "Adrenalina",
	info = "Na krótki okres czasu zapewnia chwilowe zwiększenie wytrzymałości",
}

wep.ADRENALINE_BIG = {
	name = "Duża adrenalina",
	info = "Na znaczny okres czasu zapewnia chwilowe zwiększenie wytrzymałości",
}

wep.MORPHINE = {
	name = "Morfina",
	info = "Zapewnia tymczasowe zdrowie, które z czasem zanika",
}

wep.MORPHINE_BIG = {
	name = "Duża morfina",
	info = "Zapewnia dużo tymczasowego zdrowia, które z czasem zanika",
}

wep.TASER = {
	name = "Paralizator"
}

wep.PIPE = {
	name = "Metalowa rura"
}

wep.GLASS_KNIFE = {
	name = "Szklany nóż"
}

wep.CLOTHES_CHANGER = {
	name = "Zmieniacz ubrań (Dłonie)",
	info = "Działa jak zwykłe dłonie. Dodatkowo pozwala na kradzież ubrań z ciał zwłok. Spójrz na martwe ciało i przytrzymaj LPM, aby użyć",
	skill = "Zmieniacz ubrań",
	wait = "Czekaj",
	ready = "Gotowy",
	progress = "Zamiana ubrań",
	vest = "Zdejmij pancerz aby zmienić ubrania"
}

wep.DOOR_BLOCKER = {
	name = "Bloker Drzwi",
	info = "Wyceluj w przycisk i przytrzymaj LPM, aby naładować. Zwolnij LPM, aby rozładować i tymczasowo zablokować korzystanie z drzwi",
	skill = "Bloker Drzwi",
	wait = "Czekaj",
	ready = "Gotowy",
	progress = "Ładowanie"
}

wep.__slc_ammo = "Amunicja"

wep.weapon_stunstick = "Pałka"
wep.weapon_crowbar = "Łom"

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

snake.score = "Wynik"
snake.high_score = "Rekord"
snake.game_over = "Koniec Gry!"
snake.paused = "Przygotuj się!"
snake.info = "Naciśnij W, A, S lub D, aby rozpocząć"
snake.restart = "Naciśnij spację, aby uruchomić ponownie"

--[[-------------------------------------------------------------------------
Data binds - DO NOT EDIT!
---------------------------------------------------------------------------]]
lang.__binds = {
	["badges"] = "ranks",
}

--[[-------------------------------------------------------------------------
Register language
---------------------------------------------------------------------------]]
RegisterLanguage( lang, "polish", "polski", "pl" )
