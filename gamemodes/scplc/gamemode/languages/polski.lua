local lang = {}

lang.NRegistry = {
	scpready = "Możesz zostać wybrany jako SCP w następnej rundzie",
	scpwait = "Musisz poczekać %s runde(y) aby móc zagrać jako SCP"
}

lang.NFailed = "Nie udało się uzyskać wartości NRegistry: %s"

lang.eq_tip = "LPM - Wybierz | PPM - Wyrzuć"
lang.eq_open = "Naciśnij '%s' aby otworzyć nowy ekwipunek!"

/*lang.starttexts = {
	ROLE_SCPSantaJ = {
		"Jesteś SCP-SANTA-J",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś Świętym Mikołajem! Rozdawaj wszystkim prezenty!",
		"Wesołych Świąt i Szczęśliwego Nowego Roku!",
		"To jest specialny SCP dostępny tylko przez ograniczony czas!"}
	},
	ROLE_SCP173 = {
		"Jesteś SCP - 173",
		{"Twoim celem jest ucieczka z placówki",
		"Nie możesz sie ruszać jeśli ktoś się na ciebie patrzy",
		"Pamiętaj, ludzie mrugają",
		"PPM aktywuje specjalną moc: możesz oślepić wszystkich w około"}
	},
	ROLE_SCP096 = {
		"Jesteś SCP - 096",
		{"Twoim celem jest ucieczka z placówki",
		"Ruszasz się niezwykle szybko gdy ktoś patrzy",
		"Możesz krzyczeć klikając PPM"}
	},
	ROLE_SCP066 = {
		"Jesteś SCP - 066",
		{"Twoim celem jest ucieczka z placówki",
		"Potrafisz wytworzyć naprawdę głośną muzykę",
		"LPM - atak, PPM - możesz rozbijać szyby"}
	},
	ROLE_SCP106 = {
		"Jesteś SCP - 106",
		{"Twoim celem jest ucieczka z placówki",
		"Jeśli klikniesz na kogoś, przeteleportujesz go do wymiaru łuzowego"}
	},
	ROLE_SCP966 = {
		"Jesteś SCP-966",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś widzialny tylko przez noktowizor",
		"Zadajesz obszarowe obrażenia gdy stoisz blisko ludzi",
		"A także dezorientujesz ich"}
	},
	ROLE_SCP939 = {
		"Jesteś SCP-939",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś szybki i silny",
		"Możesz oszukać swoje ofiary używając czatu głosowego",
		"LPM - atakujesz, PPM - zmieniasz czat głosowy"}
	},
	ROLE_SCP682 = {
		"Jesteś SCP-682",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś Gadem Trudnym-Do-Zniszczenia",
		"Zabijasz natychmiast, ale jesteś bardzo wolny",
		"Pod PPM masz specjalną umiejętność"}
	},
	ROLE_SCP457 = {
		"Jesteś SCP-457",
		{"Twoim celem jest ucieczka z placówki",
		"Zawsze się palisz",
		"Jeśli będziesz blisko kogoś, zaczniesz go podpalać"}
	},
	ROLE_SCP999 = {
		"Jesteś SCP-999",
		{"Twoim celem jest ucieczka z placówki",
		"Możesz uzdrowić kogo chcesz",
		"Musisz współpracować z innym personelem lub SCP"}
	},
	ROLE_SCP689 = {
		"Jesteś SCP-689",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś ekstremalnie wolny, ale również zabójczy",
		"Możesz zabić każdego kto cię zobaczył",
		"Po zabiciu pojawiasz się na zwłokach ofiary, aby zobaczyło ciebie więcej ludzi",
		"LPM - atak, PPM - możesz rozbijać szyby"}
	},
	ROLE_SCP082 = {
		"Jesteś SCP-082",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś kanibalem z maczetą",
		"Jeżeli kogoś zranisz spowolnisz go",
		"Jak kogoś zabijesz to zyskasz trochę zdrowia"}
	},
	ROLE_SCP023 = {
		"Jesteś SCP-023",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś wilkiem podpalającym każdego obok kogo przejdziesz",
		"Podpalając kogoś troche się leczysz",
		"LPM - atak, PPM - kosztem zycia zyskujesz prędkość"}
	},
	ROLE_SCP1471 = {
		"Jesteś SCP-1471-A",
		{"Twoim celem jest ucieczka z placówki",
		"Możesz przeteleportować się do swojej ofiary",
		"LPM - atak, PPM - aby się teleportować"}
	},
	ROLE_SCP1048A = {
		"Jesteś SCP-1048-A",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś podobny do niegroźnego SCP 1048",
		"Ale wykonany jesteś z ludzkich uszu",
		"LPM - aby wytworzyć głośny krzyk"}
	},
	ROLE_SCP1048B = {
		"Jesteś SCP-1048-B",
		{"Twoim celem jest ucieczka z placówki",
		"Zabij wszystkich"}
	},
	ROLE_SCP8602 = {
		"Jesteś SCP-860-2",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś leśnym potworem",
		"Jeżeli zaatakujesz kogoś blisko sciany to szarżujesz na niego"}
	},
	ROLE_SCP049 = {
		"Jesteś SCP - 049",
		{"Twoim celem jest ucieczka z placówki",
		"Jak dotkniesz kogoś, to stanie się SCP-049-2"}
	},
	ROLE_SCP0492 = {
		"Jesteś SCP-049-2",
		{"Twoim celem jest ucieczka z placówki",
		"Pomagaj SCP-049"}
	},
	ROLE_SCP076 = {
		"Jesteś SCP-076-2",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś szybki i masz mało zdrowia",
		"Będziesz się odradzać dopóki ktoś nie zniszczy SCP-076-1"}
	},
	ROLE_SCP957 = {
		"Jesteś SCP-957",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś odporniejszy na ataki, ale śmierć SCP-957-1 zada ci obrażenia",
		"Użyj LPM aby zadać obszarowe obrażenia w czasie",
		"Po zaatakowaniu kogoś ty i SCP-957-1 zostaniecie lekko uzrdowieni"}
	},
	ROLE_SCP9571 = {
		"Zostałeś SCP-957-1",
		{"Twoim celem jest zwabienie twoich towarzyszy do SCP-957",
		"Twoja wizja jest ograniczona i możesz się komunikować z SCP-957",
		"Nikt nie wie, że jesteś SCP nie daj się zdemaskować",
		"Jeżeli zginiesz SCP-957 otrzyma obrażenia"}
	},
	ROLE_SCP0082 = {
		"Jesteś SCP-008-2",
		{"Twoim celem jest zarażenie wszystkich MTF i D",
		"Jeśli zabijesz kogoś to stanie się 008-2"}
	},
	ROLE_RES = {
		"Jesteś naukowcem",
		{"Twoim celem jest ucieczka z placówki",
		"Szukaj pomocy i spróbuj wydostać się z placówki",
		"Uważaj na klasę D, mogą próbować cię zabić"}
	},
	ROLE_MEDIC = {
		"Jesteś medykiem",
		{"Twoim celem jest ucieczka z placówki",
		"Szukaj pomocy i spróbuj wydostać się z placówki",
		"Uważaj na klasę D, mogą próbować cię zabić",
		"Jeśli ktoś będzie potrzebował leczenia to go ulecz"}
	},
	ROLE_NO3 = {
		"Jesteś naukowcem poziomu 3",
		{"Twoim celem jest ucieczka z placówki",
		"Jesteś tu od dawna i znasz placówke jak nikt inny",
		"Uważaj na klasę D, mogą próbować cię zabić",
		"Dzięki radiu możesz się komunikować z ochroną"}
	},
	ROLE_CLASSD = {
		"Jesteś personelem Klasy D",
		{"Twoim celem jest ucieczka z placówki",
		"Pomagaj swoim kolegom, samemu masz nikłe szanse na przeżycie",
		"Szukaj kart dostępu i uważaj na MTF i obiekty SCP"}
	},
	ROLE_VETERAN = {
		"Jesteś weteranem Klasy D",
		{"Twoim celem jest ucieczka z placówki",
		"Pomagaj swoim kolegom, samemu masz nikłe szanse na przeżycie",
		"Szukaj kart dostępu i uważaj na MTF i obiekty SCP"}
	},
	ROLE_CIC = {
		"Jesteś agentem Chaos Insurgency",
		{"Twoim celem jest pomóc Klasie D",
		"Ty zajmujesz się ich organizacją",
		"Uważaj na MTF i obiekty SCP, oraz czekaj na wsparcie kolegów z CI"}
	},
	ROLE_SECURITY = {
		"Jesteś Ochroniarzem",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D",
		"Eskortuj ich do lądowiska",
		"Musisz zabić każdego kto ci przeszkodzi",
		"Słuchaj się swojego Dowódcy i wykonuj jego polecenia"}
	},
	ROLE_CSECURITY = {
		"Jesteś Dowódcą Ochroniarzy",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D",
		"Eskortuj ich do lądowiska",
		"Wydawaj polecenia ochroniarzom ci przydzielonym"}
	},
	ROLE_MTFGUARD = {
		"Jesteś Ochroniarzem MTF",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D",
		"Eskortuj ich do lądowiska",
		"Musisz zabić każdego kto ci przeszkodzi",
		"Słuchaj się swojego Dowódcy i wykonuj jego polecenia"}
	},
	ROLE_MTFMEDIC = {
		"Jesteś Medykiem MTF",
		{"Twoim celem jest wspieranie innych ochroniarzy i naukowców",
		"Jeśli będą ranni to ich ulecz",
		"Słuchaj się swojego Dowódcy i wykonuj jego polecenia"}
	},
	ROLE_MTFL = {
		"Jesteś Porucznikiem MTF",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D",
		"Eskortuj ich do lądowiska",
		"Musisz zabić każdego kto ci przeszkodzi",
		"Słuchaj się Dowódcy i wykonuj jego polecenia",
		"Jeśli Dowódca przydzieli ci ochroniarzy to wydawaj im polecenia",
		"Jeśli Dowódca zginie to przejmij dowodzenie"}
	},
	ROLE_HAZMAT = {
		"Jesteś specjalnym żołnierzem MTF",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D",
		"Eskortuj ich do lądowiska",
		"Musisz zabić każdego kto ci przeszkodzi",
		"Słuchaj się Dowódcy i wykonuj jego polecenia"}
	},
	ROLE_MTFNTF = {
		"Jesteś agentem MTF Jednostki Nine-Tailed Fox",
		{"Twoim celem jest znalezienie wszystkich naukowców i eliminacja Klasy D",
		"Eskortuj ich do lądowiska",
		"Musisz zabić każdego kto ci przeszkodzi",
		"Wejdź do placówki i pomóż ochroniarzom",
		"Jeśli jest jakiś Dowódca to wykonuj jego polecenia"}
	},
	ROLE_MTFCOM = {
		"Jesteś Dowódcą MTF",
		{"Twoim celem jest znalezienie wszystkich naukowców",
		"Eskortuj ich do lądowiska",
		"Musisz zabić każdego kto ci przeszkodzi",
		"Wydawaj polecenia ochroniarzom"}
	},
	ROLE_SD = {
		"Jesteś Dyrektorem Placówki",
		{"Twoim celem jest wydawanie poleceń",
		"Jeśli jest jakiś Dowódca MTF lub Dowódca Ochrony to wydawaj im polecenia",
		"Zrób co w swojej mocy by uchronić placówke"}
	},
	ROLE_O5 = {
		"Jesteś Członkiem Rady O5",
		{"Posiadasz nieograniczony dostęp do wszystkiego",
		"Jesteś tutaj najważniejszy, wydawaj polecenia",
		"Zrób cokolwiek, aby uchronić dobre imię fundacji oraz bezpieczeństwo świata"}
	},
	ROLE_CHAOS = {
		"Jesteś żołnierzem Chaos Insurgency",
		{"Twoim celem jest zabicie ochroniarzy MTF",
		"Jeśli znajdziesz personel Klasy D eskortuj go do lądowiska",
		"Zabij każdego kto ci przeszkodzi"}
	},
	ROLE_CHAOSCOM = {
		"Jesteś Dowódcą Chaos Insurgency",
		{"Twoim celem jest wydawanie poleceń żołnierzom CI",
		"Musicie zabić wszystkich ochroniarzy MTF",
		"Zróbcie jak największy chaos w placówce"}
	},
	ROLE_CHAOSSPY = {
		"Jesteś szpiegiem Chaos Insurgency",
		{"Twoim celem jest zabicie ochroniarzy MTF",
		"Będą myśleć, że jesteś z nimi",
		"Jeśli znajdziesz personel Klasy D eskortuj go do lądowiska"}
	},
	ROLE_SPEC = {
		"Jesteś Obserwatorem",
		{'Użyj komendy "br_spectate" żeby wrócić'}
	},
	ADMIN = {
		"Jesteś w trybie administratora",
		{'Użyj komendy "br_admin_mode" aby wrócić do gry w następnej rundzie'}
	},
	ROLE_INFECTD = {
		"Jesteś Presonelem Klasy D",
		{'To jest runda specialna "infekcja"',
		"Musisz współpracować z MTF aby zatrzymać zarazę",
		"Jeżeli zostaniesz zabity przez zombi staniesz się jednym z nich"}
	},
	ROLE_INFECTMTF = {
		"Jesteś ochroniarzem MTF",
		{'To jest runda specialna "infekcja"',
		"Musisz współpracować z Klasą D aby zatrzymać zarazę",
		"Jeżeli zostaniesz zabity przez zombi staniesz się jednym z nich"}
	},
}*/

/*lang.ROLES = {}

lang.ROLES.ADMIN = "TRYB ADMINISTRATORA"
lang.ROLES.ROLE_INFECTD = "Personel Klasy D"
lang.ROLES.ROLE_INFECTMTF = "MTF"

lang.ROLES.ROLE_SCPSantaJ = "SCP-SANTA-J"
lang.ROLES.ROLE_SCP173 = "SCP-173"
lang.ROLES.ROLE_SCP106 = "SCP-106"
lang.ROLES.ROLE_SCP049 = "SCP-049"
lang.ROLES.ROLE_SCP096 = "SCP-096"
lang.ROLES.ROLE_SCP066 = "SCP-066"
lang.ROLES.ROLE_SCP682 = "SCP-682"
lang.ROLES.ROLE_SCP082 = "SCP-082"
lang.ROLES.ROLE_SCP689 = "SCP-689"
lang.ROLES.ROLE_SCP457 = "SCP-457"
lang.ROLES.ROLE_SCP999 = "SCP-999"
lang.ROLES.ROLE_SCP939 = "SCP-939"
lang.ROLES.ROLE_SCP0492 = "SCP-049-2"
lang.ROLES.ROLE_SCP0082 = "SCP-008-2"
lang.ROLES.ROLE_SCP966 = "SCP-966"
lang.ROLES.ROLE_SCP023 = "SCP-023"
lang.ROLES.ROLE_SCP076 = "SCP-076-2"
lang.ROLES.ROLE_SCP1471 = "SCP-1471-A"
lang.ROLES.ROLE_SCP1048A = "SCP-1048-A"
lang.ROLES.ROLE_SCP1048B = "SCP-1048-B"
lang.ROLES.ROLE_SCP8602 = "SCP-860-2"
lang.ROLES.ROLE_SCP957 = "SCP-957"
lang.ROLES.ROLE_SCP9571 = "SCP-957-1"

lang.ROLES.ROLE_RES = "Naukowiec"
lang.ROLES.ROLE_MEDIC = "Medyk"
lang.ROLES.ROLE_NO3 = "Naukowiec Poziomu 3"

lang.ROLES.ROLE_CLASSD = "Personel Klasy D"
lang.ROLES.ROLE_VETERAN = "Weteran Klasy D"
lang.ROLES.ROLE_CIC = "Agent CI"

lang.ROLES.ROLE_SECURITY = "Ochroniarz"
lang.ROLES.ROLE_MTFGUARD = "Ochroniarz MTF"
lang.ROLES.ROLE_MTFMEDIC = "Medyk MTF"
lang.ROLES.ROLE_MTFL = "Porucznik MTF"
lang.ROLES.ROLE_HAZMAT = "MTF SCU"
lang.ROLES.ROLE_MTFNTF = "MTF NTF"
lang.ROLES.ROLE_CSECURITY = "Dowódca ochroniarzy"
lang.ROLES.ROLE_MTFCOM = "Dowódca MTF"
lang.ROLES.ROLE_SD = "Dyrektor Placówki"
lang.ROLES.ROLE_O5 = "Członek rady O5"

lang.ROLES.ROLE_CHAOSSPY = "Szpieg CI"
lang.ROLES.ROLE_CHAOS = "Żołnierz CI"
lang.ROLES.ROLE_CHAOSCOM = "Dowódca CI"
lang.ROLES.ROLE_SPEC = "Obserwator"

lang.author = "Autor"
lang.helper = "Asystent"
lang.originator = "Pomysłodawca"*/

local classes = {
    _check = false --don't change it
}

//classes.classd = "Class D"

lang.CLASSES = classes

local wep = {}

wep.SCP_0082 = {
	author = "Kanade, edytowane przez danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zarażaj",
	instructions = "LPM aby atakować",
}

wep.SCP_023 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować",
	HUD = {
		lowhealth = "Masz zbyt mało zdrowia",
	},
}

wep.SCP_049 = {
	author = "Kanade",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "'Lecz'",
	instructions = "LPM aby kogos 'uleczyć'",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
	},
}

wep.SCP_076 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować",
}

wep.SCP_096 = {
	author = "Vinrax, edytowane przez danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować",
}

wep.SCP_106 = {
	author = "Kanade, edytowane przez danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby kogoś wysłać do wymiaru łzowego\nPPM aby rozstawić teleport\nR aby się teleportować",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
		teleportReady = "Teleportacja gotowa",
		teleportCD = "Następna teleportacja za"
	},
}

wep.SCP_066 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby puścić muzyke",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
	},
}

wep.SCP_082 = {
	author = "danx91, broń z M9K Specialities",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować",
}

wep.SCP_173 = {
	author = "Kanade",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LMB aby zabić, PPM aby oślepić ofiary",
	HUD = {
		nlook = "Nikt nie patrzy",
		specCD = "Umiejętność specjalna gotowa za",
		specReady = "Umiejęntność specjalna gotowa",
		slook = "Ktoś patrzy",
	},
}

wep.SCP_420j = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Najlepsze zioło na świecie",
	instructions = "MAN DATS SUM GOOD ASS SHIT",
}

wep.SCP_457 = {
	author = "Kanade",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Podpalaj",
	instructions = "",
}

wep.SCP_500 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Ulecz siebie",
	instructions = "LPM aby użyć, lub zostanie użyte samo gdy powinieneś otrzymać śmiertelny cios",
}

wep.SCP_682 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować, PPM aby użyć umiejętności",
	HUD = {
		attackReady = "Specjalna umiejętność gotowa",
		attackCD = "Specjalna umiejętność gotowa za",
	},
}

wep.SCP_689 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby przenieść się do twojej ofiary",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
		targets = "Cele"
	},
}

wep.SCP_714 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Chroń siebie",
	instructions = "Trzymaj aby użyć",
	HUD = {
		durability = "Wytrzymałość:",
		protect = "Jesteś chroniony",
		protend = "Twoja ochrona się kończy",
	},
}

wep.SCP_8602 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować",
}

wep.SCP_939 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować, PPM aby zmienić czat głosowy",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
		channel = "Obecny czat głosowy:",
	},
}

wep.SCP_957 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby zadać obrażenia obszarowe",
	HUD = {
		rattack = "Atak gotowy",
		nattack = "Następny atak za",
		nsummon = "Zamiana SCP-957-1 za",
		asummon = "SCP-957-1 żyje",
		buffd = "SCP-957-1 jest za daleko!",
		buffe = "Wzmocnienie aktywne",
	},
}

wep.SCP_966 = {
	author = "Kanade, edytowane przez danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "Zadajesz obrażenia kiedy jesteś blisko ludzi",
}

wep.SCP_999 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Lecz wszystkich",
	instructions = "LPM aby uzdrowić cel, RMB aby uzdrowić wszystkich w pobliżu",
	HUD = {
		healReady = "Leczenie gotowe",
		healCD = "Leczenie sie odnawia. Czekaj",
		ghealReady = "Grupowe leczenie gotowe",
		ghealCD = "Grupowe leczenie sie odnawia. Czekaj",
	},
}

wep.SCP_1048A = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby wytworzyć głośny krzyk",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
	},
}

wep.SCP_1048B = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować",
}

wep.SCP_1471 = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Zabijaj",
	instructions = "LPM aby atakować, PPM aby się przeteleportować",
	HUD = {
		attackReady = "Atak gotowy",
		attackCD = "Następny atak za",
	},
}

wep.SCP_SantaJ = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Dawaj prezenty",
	instructions = "LPM aby dawać prezenty",
	HUD = {
		attackReady = "Gotowy do ataku",
		attackCD = "Następny atak za",
		gtype = "Rodzaj prezentu:",
		explosive = "Wybuchowy",
		healing = "Leczący",
	},
}

wep.MEDKIT = {
	name = "Apteczka (Pozostało ładunków: %d)"
}
wep.KEYCARD = {
	author = "danx91",
	contact = "Popatrz na ten tryb w warsztacie i poszukaj twórców",
	purpose = "Otwiera drzwi które do działania wymagają karty (Przytrzymaj R aby zobaczyć obsługiwane drzwi)",
	instructions = "Obsługiwane drzwi:",
	ACC = {
		"SAFE",
		"EUCLID",
		"KETER",
		"Pkt. Kontrolne",
		"Głowica OMEGA",
		"Dostęp Ogólny",
		"Brama A",
		"Brama B",
		"Zbrojownia",
		"Femur Breaker",
		"EC",
	},
	STATUS = {
		"DOSTĘP",
		"BRAK DOSTĘPU",
	},
	NAMES = {
		"Karta poziomu 1",
		"Karta poziomu 2",
		"Karta poziomu 3",
		"Karta naukowca",
		"Karta strażnika MTF",
		"Karta dowódcy MTF",
		"Karta poziomu OMNI",
		"Karta ochrony pkt. kontrolnych",
		"Zhakowana karta CI",
	},
}

lang.WEAPONS = wep

registerLanguage( lang, "polski", "polish", "pl" )
