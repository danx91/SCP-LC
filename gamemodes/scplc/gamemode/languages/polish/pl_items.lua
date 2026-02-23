local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

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
Weapons
---------------------------------------------------------------------------]]
wep.SCP009 = {
	name = "SCP-009",
}

wep.SCP500 = {
	name = "SCP-500",
	death_info = "Udławiłeś się SCP-500",
	text_used = "Jak tylko połknąłeś SCP-500, to poczułeś się lepiej",
}

wep.SCP714 = {
	name = "SCP-714"
}

wep.SCP1025 = {
	name = "SCP-1025",
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

wep.CCTV = {
	name = "Monitoring",
	showname = "Kamery",
	info = "Kamery pozwalają zobaczyć, co dzieje się w placówce.\nZapewniają również możliwość skanowania obiektów SCP i przesyłania tych informacji na aktualny kanał radiowy",
	scanning = "Skanowanie...",
	scan_info = "Przytrzymaj [%s] aby skanować SCP",
	map_info = "Przytrzymaj [%s] aby otworzyć mapę",
	scan_cd = "Poczekaj przed kolejnym skanem...",
	no_signal = "Brak sygnału...",
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
		tesla = "Wyłącz tesle",
		intercom = "Interkom",
		vent = "Wentylacja gazu",
	},
	actions = {
		scan = "Skanowanie placówki...",
		tesla = "Wyłączanie tesli...",
		intercom = "Interkom aktywny...",
		vent = "Wentylacja aktywna...",
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

wep.EPHEDRINE = {
	name = "Efedryna",
	info = "Zapewnia małe przyśpieszenie na krótki czas",
}

wep.EPHEDRINE_BIG = {
	name = "Duża Efedryna",
	info = "Zapewnia duże przyśpieszenie na krótki czas",
}

wep.HEMOSTATIC = {
	name = "Hemostatyk",
	info = "Przez krótki okres wszystkie krwawienia będą szybko znikać",
}

wep.HEMOSTATIC_BIG = {
	name = "Duży Hemostatyk",
	info = "Przez długi okres wszystkie krwawienia będą szybko znikać",
}

wep.ANTIDOTE = {
	name = "Antidotum",
	info = "Przez krótki okres wszystkie trucizny będą szybko znikać",
}

wep.ANTIDOTE_BIG = {
	name = "Duże Antidotum ",
	info = "Przez długi okres wszystkie trucizny będą szybko znikać",
}

wep.POISON = {
	name = "Trucizna",
	info = "Powoduje poważne obrażenia w czasie",
}

wep.POISON_BIG = {
	name = "Duża Trucizna",
	info = "Powoduje śmiertelne obrażenia w czasie",
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
	id_time = "Pozostały czas skradzionego ID",
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

wep.SNAV = {
	name = "S-NAV",
	low_battery = "Brak Baterii",
	no_signal = "Brak Komunikacji",
}

wep.SNAV_ULT = {
	name = "S-NAV ULTIMATE",
	showname = "S-NAV+",
	low_battery = "Brak Baterii",
	no_signal = "Brak Komunikacji",
}

wep.__slc_ammo = "Amunicja"

wep.CROWBAR = {
	name = "Łom",
}
wep.STUNSTICK = {
	name = "Pałka",
}
