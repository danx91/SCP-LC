local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
    scpready = "Możesz zostać wybrany jako SCP w następnej rundzie",
    scpwait = "Musisz poczekać %i rund, aby móc grać jako SCP",
    abouttostart = "Gra rozpocznie się za 10 sekund!",
    kill = "Otrzymałeś %d punkty za zabicie %s: %s!",
    rdm = "Przegrałeś %d punkty za zabicie %s: %s!",
    acc_nocard = "Do obsługi tych drzwi wymagana jest karta dostępu",
    acc_wrongcard = "Do obsługi tych drzwi wymagana jest karta o wyższym poziomie uprawnień",
    acc_deny = "Brak dostępu",
    acc_granted = "Dostęp przyznany",
    device_nocard = "Do obsługi tego urządzenia wymagana jest karta dostępu",
    rxpspec = "Otrzymałeś %i doświadczenie za gre na tym serwerze!",
    rxpplay = "Otrzymałeś %i doświadczenie za pozostanie przy życiu w rundzie!",
    rxpplus = "Otrzymałeś %i doświadczenie za przetrwanie ponad połowy rundy!",
    roundxp = "Otrzymałeś %i doświadczenie za swoje punkty",
    gateexplode = "Czas do Wybuchu BRAMY A: %i",
    explodeterminated = "Zniszczenie Bramy A  zostało zakończone",
    r106used = "Procedura zabezpieczania SCP 106 może zostać uruchomiona tylko raz na rundę",
    r106eloiid = "Wyłącz elektromagnes ELO-IID, aby rozpocząć procedurę zabezpieczania SCP 106",
    r106sound = "Włącz transmisję dźwięku, aby rozpocząć procedurę zabezpieczania SCP 106",
    r106human = "W klatce wymagany jest żywy człowiek, aby rozpocząć procedurę ponownego zebezpieczania SCP 106",
    r106already = "SCP 106 jest już zabezpieczony",
    r106success = "Otrzymałeś %i punkty za zabezpieczenie SCP 106!",
    vestpickup = "Podniosłeś kamizelkę",
    vestdrop = "Upuściłeś kamizelkę",
    hasvest = "Masz już kamizelkę! Użyj EQ, aby go upuścić",
    escortpoints = "Otrzymałeś %i punkty za eskortowanie sojuszników",
    femur_act = "Aktywowany Łamacz kości udowej ...",
    levelup = "Gracz %s awansował! Jego obecny poziom to: %i",
    healplayer = "Otrzymałeś %i punkty za uzdrowienie innego gracza",
    detectscp = "Otrzymałeś %i punkty za wykrycie SCP",
    winxp = "Otrzymałeś %i doświadczenie, ponieważ Twoja początkowa drużyna wygrała grę",
    winalivexp = "Otrzymałeś %i doświadczenie, ponieważ Twoja drużyna wygrała grę",
    upgradepoints = "Otrzymałeś nowe punkty aktualizacji! naciśnij '%s' aby otworzyć menu aktualizacji SCP",
}

lang.NFailed = "Nie można uzyskać dostępu do rejestru za pomocą klucza: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
    escaped = "Uciekłeś z placówki!",
    escapeinfo = "Dobra robota! Uciekłeś %s",
    escapexp = "Otrzymałeś %i doświadczenia",
    escort = "Zostałeś eskortowany!",
    roundend = "Runda zakończona!",
    nowinner = "Brak zwycięzcy w tej rundzie!",
    roundnep = "Za mało graczy!",
    roundwin = "Zwycięzca rundy: %s",
    roundwinmulti = "Zwycięzcy rundy: [RAW]",

    mvp = "MVP: %s z wynikiem: %i",
    stat_kill = "Gracze zabici: %i",
    stat_rdm = "RDM Zabici: %i",
    stat_rdmdmg = "RDM Obrażenia: %i",
    stat_dmg = "Zadane obrażenia: %i",
    stat_escapes = "Gracze uciekli: %i",
    stat_escorts = "Gracze eskortowali: %i",
    stat_066 = "Zagrał niesamowicie: %i",
    stat_106 = "Gracze teleportowani do Świata łzowego: %i",
    stat_173 = "Skręcone karki: %i",
    stat_457 = "Spaleni gracze: %i",
    stat_682 = "Gracze zabici przez zarośniętego gada: %i",
    stat_8602 = "Gracze przybici do ściany: %i",
    stat_939 = "Ofiary SCP-939: %i",
}

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}

hud.pickup = "Podniosłeś"
hud.class = "Klasa"
hud.team = "Drużyna"
hud.prestige_points = "Punkty Prestiżu"
hud.hp = "HP"
hud.stamina = "STAMINA"
hud.sanity = "PSYCHIKA"
hud.xp = "XP"

lang.HUD = hud

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "LMB - wybierz"
lang.eq_rmb = "RMB - Upuśc"
lang.eq_hold = "Przytrzymaj LMB - Przenieś element"
lang.eq_vest = "Kamizelka"
lang.eq_key = "naciśnij '%s' aby otworzyć EQ"

lang.info = "Informacje"
lang.author = "Autor"
lang.mobility = "Mobilność"
lang.weight = "Waga"
lang.protection = "Ochrona"

lang.weight_unit = "kg"

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}

effects.permanent = "perm"
effects.bleeding = "Krwawienie"
effects.doorlock = "Zamek od drzwi"
effects.amnc227 = "AMN-C227"
effects.insane = "Szalony"
effects.gas_choke = "Zadławienie"

lang.EFFECTS = effects

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Przeglądarka klas"
lang.preview = "Zapowiedź"
lang.random = "Losowy"
lang.price = "cena"
lang.buy = "Kup"

lang.details = {
    details = "Detale",
    name = "Imię",
    team = "Zespół",
    price = "Cena punktów Prestiżu",
    walk_speed = "Prędkość chodzenia",
    run_speed = "Prędkość biegania",
    chip = "Chip dostępu",
    persona = "Fałszywy dowód tożsamości",
    weapons = "Bronie",
    class = "Klasa",
    hp = "Życie",
    speed = "Prędkość"
}

lang.headers = {
    support = "WSPRACIE",
    classes = "KLASY",
    scp = "SCP"
}

lang.view_cat = {
    classd = "Klasa D",
    sci = "Naukowcy",
    mtf = "MFO",
    ci = "CI",
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Niepołączony"

lang.scoreboard = {
    name = "Tablica wyników",
    playername = "Nick",
    ping = "Ping",
    prestige = "Prestiż",
    level = "Level",
    score = "Punkty",
    ranks = "Ranking",
}

lang.ranks = {
    author = "Autor",
    vip = "VIP",
    tester = "Tester",
    countbob = "Hrabia Bob"
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
    tree = "%s DRZEWO ULEPSZEŃ",
    points = "Punkty",
    cost = "Koszt",
    owned = "Posiadasz",
    requiresall = "Wymaga",
    requiresany = "Wymaga dowolnego"
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "Nic"

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}

vest.guard = "Kamizelka ochronna"
vest.chief = "Kamizelka szefa ochrony"
vest.private = "Kamizelka prywatna MFO"
vest.sergeant = "Kamizelka Sierżanta MFO"
vest.lieutenant = "Kamizelka porucznika MFO"
vest.alpha1 = "Kamizelka MFO Alpha 1"
vest.medic = "Kamizelka medyczna MFO"
vest.ntf = "Kamizelka MFO NFO"
vest.ci = "Kamizelka Rebelii Chaosu"
vest.fire = "Kamizelka ognioodporna"
vest.electro = "Kamizelka elektroszczelna"

lang.VEST = vest

local dmg = {}

dmg.BURN = "Obrażenia od ognia"
dmg.SHOCK = "Obrażenia od prądu"
dmg.BULLET = "Obrażenie od pocisku"
dmg.FALL = "Obrażenia od upadku"

lang.DMG = dmg

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}

teams.SPEC = "Obserwator"
teams.CLASSD = "Klasa D"
teams.SCI = "Naukowiec"
teams.MTF = "MFO"
teams.CI = "CI"
teams.SCP = "SCP"

lang.TEAMS = teams


--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}

classes.unknown = "Nieznany"

classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
classes.SCP066 = "SCP 066"
classes.SCP106 = "SCP 106"
classes.SCP173 = "SCP 173"
classes.SCP457 = "SCP 457"
classes.SCP682 = "SCP 682"
classes.SCP8602 = "SCP 860-2"
classes.SCP939 = "SCP 939"
classes.SCP966 = "SCP 966"

classes.classd = "Klasa D"
classes.veterand = "Class D Weteran"
classes.kleptod = "Class D Kleptoman"
classes.ciagent = "CI Agent"

classes.sciassistant = "Asystent naukowy"
classes.sci = "Naukowiec"
classes.seniorsci = "Starszy naukowiec"
classes.headsci = "Główny naukowiec"

classes.guard = "Ochroniarz"
classes.chief = "Szef bezpieczeństwa"
classes.private = "Prywatny MFO"
classes.sergeant = "Sierżant MFO"
classes.lieutenant = "Porucznik MFO"
classes.alpha1 = "MFO Alpha 1"
classes.medic = "Medyk MFO"
classes.cispy = "CI Szpieg"

classes.ntf = "MFO NFO"
classes.ntfcom = "MFO NFO Dowódca"
classes.ntfsniper = "MFO NFO Snajper"
classes.ci = "Rebelia Chaosu"
classes.cicom = "Dowódca Rebeli Chaosu"

lang.CLASSES = classes

--[[-------------------------------------------------------------------------
Class Info
---------------------------------------------------------------------------]]
lang.CLASS_INFO = {
    classd = [[Jesteś personelem klasy D.
Twoim celem jest ucieczka z ośrodka
Współpracuj z innymi i szukaj kart dostępu
Uwaga na personel fundacji i SCP]],

    veterand = [[Jesteś weteranem klasy D.
Twoim celem jest ucieczka z ośrodka
Współpracuj z innymi i szukaj kart dostępu
Uwaga na personel fundacji i SCP]],

    kleptod = [[Jesteś kleptomanem klasy D.
Twoim celem jest ucieczka z ośrodka
Współpracuj z innymi i szukaj kart dostępu
Uwaga na personel fundacji i SCP]],

    ciagent = [[Jesteś agentem CI
Twoim celem jest ochrona personelu klasy D.
Eskortuj ich do wyjścia
Uwaga na personel placówki i SCP]],

    sciassistant = [[Jesteś asystentem naukowym
Twoim celem jest ucieczka z placówki
Współpracuj z innymi naukowcami i pracownikami ochrony
Uważaj na Rebelie chaosu i SCP]],

    sci = [[Jesteś naukowcem
Twoim celem jest ucieczka z placówki
Współpracuj z innymi naukowcami i pracownikami ochrony
Uważaj na Rebelie chaosu i SCP]],

    seniorsci = [[Jesteś starszym naukowcem
Twoim celem jest ucieczka z placówki
Współpracuj z innymi naukowcami i pracownikami ochrony
Uważaj na Rebelie chaosu i SCP]],

    headsci = [[Jesteś głównym naukowcem
Twoim celem jest ucieczka z placówki
Współpracuj z innymi naukowcami i pracownikami ochrony
Uważaj na Rebelie chaosu i SCP]],

    guard = [[Jesteś ochroniarzem
Twoim celem jest uratowanie wszystkich naukowców
Zabij wszystkich pracowników klasy D i SCP]],

    chief = [[Jesteś szefem bezpieczeństwa
Twoim celem jest uratowanie wszystkich naukowców
Zabij wszystkich pracowników klasy D i SCP]],

    private = [[Jesteś prywatnym MFO
Twoim celem jest uratowanie wszystkich naukowców
Zabij wszystkich pracowników klasy D i SCP]],

    sergeant = [[Jesteś sierżantem MFO
Twoim celem jest uratowanie wszystkich naukowców
Zabij wszystkich pracowników klasy D i SCP]],

    lieutenant = [[Jesteś porucznikiem MFO
Twoim celem jest uratowanie wszystkich naukowców
Zabij wszystkich pracowników klasy D i SCP]],

    alpha1 = [[Jesteś MFO Alpha 1
Pracujesz bezpośrednio dla Rady O5
Chroń Fundacje za wszelką cenę
Twoim zadaniem jest [ZMIENIONO] ]],

    medic = [[Jesteś Medykiem MFO
Twoim celem jest uratowanie wszystkich naukowców i
zabij wszystkich pracowników klasy D i SCP
Użyj swojego zestawu medycznego, aby pomóc innym MFO]],

    cispy = [[Jesteś CI Szpiegiem
Twoim celem jest pomoc personelowi klasy D.
Udawaj, że jesteś ochroniarzem]],

    ntf = [[Jesteś MFO NFO
Pomóż MFO w ośrodku
Nie pozwól uciec personelowi klasy D i SCP]],

    ntfcom = [[Jesteś dowódcą MFO NFO
Pomóż MFO w ośrodku
Nie pozwól uciec personelowi klasy D i SCP]],

    ntfsniper = [[Jesteś snajperem MFO NFO
Pomóż MFO w ośrodku
Nie pozwól uciec personelowi klasy D i SCP]],

    ci = [[Jesteś Żołnierzem Rebeli Chaosu
Pomoc personelowi klasy D.
Zabij MTF i innych pracowników fundacji]],

    cicom = [[Jesteś Dowódcą Rebeli Chaosu
Pomoc personelowi klasy D.
Zabij MTF i innych pracowników fundacji]],
    
    SCP049 = [[Jesteś SCP 049 "Plagą"
Twoim celem jest ucieczka z ośrodka
Twój dotyk jest śmiertelny dla ludzi
Możesz wykonać operację, aby „wyleczyć” ludzi]],

    SCP0492 = [[Jesteś SCP 049-2
Twoim celem jest ucieczka z ośrodka
Słuchaj rozkazów SCP 049 i chroń go]],

    SCP066 = [[Jesteś SCP 066
Twoim celem jest ucieczka z ośrodka
Możesz odtwarzać bardzo głośną muzykę
Gdy ktoś powie że nie jest Erickiem]],

    SCP106 = [[Jesteś SCP 106
Twoim celem jest ucieczka z ośrodka
Możesz przejść przez drzwi i teleportować się do wybranej lokalizacji
LMB: Teleportuj ludzi do Łzowego
RMB: Zaznacz cel teleportacji
R: Teleportacja]],

    SCP173 = [[Jesteś SCP 173
Twoim celem jest ucieczka z ośrodka
Nie możesz się ruszyć, gdy ktoś cię obserwuje
Twoja specjalna umiejętność teleportuje cię do pobliskiego człowieka]],

    SCP457 = [[Jesteś SCP 457
Twoim celem jest ucieczka z ośrodka
Palisz się i wszystko zapalasz
blisko Ciebie
Możesz umieścić do 5 pułapek ognia]],

    SCP682 = [[Jesteś SCP 682
Twoim celem jest ucieczka z ośrodka
Masz dużo zdrowia i nienawidzisz wszystkiego
Twoja specjalna umiejętność czyni cię odpornym na wszelkie obrażenia]],

    SCP8602 = [[Jesteś SCP 860-2
Twoim celem jest ucieczka z ośrodka
Jeśli zaatakujesz kogoś w pobliżu ściany, to przybijesz go
przybij go do ściany i zadaj ogromne obrażenia]],

    SCP939 = [[Jesteś SCP 939
Twoim celem jest ucieczka z ośrodka
Możesz rozmawiać z ludźmi ale jesteś ślepy
Za to masz doskonał słuch]],

    SCP966 = [[Jesteś SCP 966
Twoim celem jest ucieczka z ośrodka
Jesteś niewidzialny]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
    nvmod = {
        name = "Extra widzienie",
        info = "Zwiększona jasność twojej wizji\nCiemne obszary już Cię nie zatrzymają"
    }
}

local wep = {}

wep.SCP049 = {
    surgery = "Wykonywanie operacji",
    surgery_failed = "Operacja się nie powiodła!",
    zombies = {
        normal = "Standardowy Zombie",
        light = "Szybki Zombie",
        heavy = "Ciężki Zombie"
    },
    upgrades = {
        cure1 = {
            name = "Jestem lekarstwem I",
            info = "Uzyskaj 40% ochrony przed pociskami",
        },
        cure2 = {
            name = "Jestem lekarstwem II",
            info = "Zdobądź 300 HP co 180 sekund",
        },
        merci = {
            name = "Akt Miłosierdzia",
            info = "Czas odnowienia ataku podstawowego zostaje skrócony o 2,5 sekundy\nNie nakładasz już efektu „Blokada drzwi” na pobliskich ludzi",
        },
        symbiosis1 = {
            name = "Symbioza I",
            info = "Po operacji leczysz się o 2,5% maksymalnego zdrowia",
        },
        symbiosis2 = {
            name = "Symbioza II",
            info = "Po przeprowadzeniu operacji leczysz się o 5% maksymalnego zdrowia\nWystąpienia SCBY 049-2 w pobliżu są leczone o 2,5% maksymalnego zdrowia",
        },
        symbiosis3 = {
            name = "Symbioza III",
            info = "Po przeprowadzeniu operacji leczysz się o 7,5% maksymalnego zdrowia\nWystąpienia SCP 049-2 w pobliżu są leczone o 5% maksymalnego zdrowia",
        },
        hidden = {
            name = "Ukryty potencjał",
            info = "Zyskujesz 1 żeton za każdą udaną operację\nKażdy żeton zwiększa HP zombie o 2,5%\n\t• Ta umiejętność wpływa tylko na nowo utworzone zombie",
        },
        trans = {
            name = "Transfuzja",
            info = "Twoje zombie mają zwiększone HP o 15%\nZombie zyskujesz 10% kradzieży życia\n\t• Ta umiejętność działa tylko na nowo utworzone zombie",
        },
        rm = {
            name = "Radykalne środki",
            info = "Gdy tylko jest to możliwe, tworzysz 2 zombie z 1 ciała\n\t• Jeśli dostępny jest tylko 1 obserwator, tworzysz tylko 1 zombie\n\t• Oba zombie są tego samego typu\n\t• Drugi zombie ma zmniejszone HP o 50%\n\t• Drugi zombie ma obrażenia zmniejszone o 25%",
        },
        doc1 = {
            name = "Precyzja chirurgiczna I",
            info = "Czas operacji zmniejsza się o 5s",
        },
        doc2 = {
            name = "Precyzja chirurgiczna II",
            info = "Czas operacji jest skrócony o 5s\n\t• Skrócenie całkowitego czasu operacji: 10s",
        },
    }
}

wep.SCP0492 = {
    too_far = "Stajesz się słabszy!"
}

wep.SCP066 = {
    wait = "Następny atak: %is",
    ready = "Atak jest gotowy!",
    chargecd = "Czas odnowienia ładunku: %is",
    upgrades = {
        range1 = {
            name = "Rezonans I",
            info = "Promień obrażeń zostaje zwiększony o 75",
        },
        range2 = {
            name = "Rezonans II",
            info = "Promień obrażeń zostaje zwiększony o 75\n\t• Całkowity wzrost: 150",
        },
        range3 = {
            name = "Rezonans III",
            info = "Promień obrażeń zostaje zwiększony o 75\n\t• Całkowity wzrost: 225",
        },
        damage1 = {
            name = "Bass I",
            info = "Obrażenia zwiększono do 112,5%, ale promień zmniejszono do 90%",
        },
        damage2 = {
            name = "Bass II",
            info = "Obrażenia zwiększono do 135%, ale promień zmniejszono do 75%",
        },
        damage3 = {
            name = "Bass III",
            info = "Obrażenia zwiększono do 200%, ale promień zmniejszono do 50%",
        },
        def1 = {
            name = "Fala Negacji I",
            info = "Podczas odtwarzania muzyki negujesz 10% otrzymywanych obrażeń",
        },
        def2 = {
            name = "Fala Negacji II",
            info = "Podczas odtwarzania muzyki negujesz 25% otrzymywanych obrażeń",
        },
        charge = {
            name = "Doskok",
            info = "Odblokowuje umiejętność doskakiwania do przodu, naciskając klawisz przeładowania\n\t• Czas odnowienia umiejętności: 20s",
        },
        sticky = {
            name = "Lepki",
            info = "Po wskoczeniu w człowieka trzymasz się go przez następne 10 sekund",
        }
    }
}

wep.SCP106 = {
    swait = "Czas odnowienia umiejętności specjalnej: %is",
    sready = "Specjalna zdolność jest gotowa!",
    upgrades = {
        cd1 = {
            name = "Chodzenie I",
            info = "Czas odnowienia umiejętności specjalnej skraca się o 15 sekund"
        },
        cd2 = {
            name = "Chodzenie II",
            info = "Czas odnowienia umiejętności specjalnej jest skrócony o 15 s\n\t• Całkowity czas odnowienia: 30 s"
        },
        cd3 = {
            name = "Chodzenie III",
            info = "Czas odnowienia umiejętności specjalnej jest skrócony o 15s\n\t• Całkowity czas odnowienia: 45s"
        },
        tpdmg1 = {
            name = "Gnijący dotyk I",
            info = "Po teleportacji zyskujesz 15 dodatkowych obrażeń na 10s"
        },
        tpdmg2 = {
            name = "Gnijący dotyk II",
            info = "Po teleportacji zyskujesz 20 dodatkowych obrażeń na 20s"
        },
        tpdmg3 = {
            name = "Gnijący dotyk III",
            info = "Po teleportacji zyskujesz 25 dodatkowych obrażeń na 30s"
        },
        tank1 = {
            name = "Tarcza Łzowa I",
            info = "Uzyskaj 20% ochrony przed pociskami, ale będziesz o 10% wolniejszy"
        },
        tank2 = {
            name = "Tarcza Łzowa II",
            info = "Uzyskaj 20% ochrony przed pociskami, ale będziesz o 10% wolniejszy\n\t• Całkowita ochrona: 40%\n\t• Całkowite wolne: 20%"
        },
    }
}

wep.SCP173 = {
    swait = "Czas odnowienia umiejętności specjalnej: %is",
    sready = "Specjalna zdolność jest gotowa!",
    upgrades = {
        specdist1 = {
            name = "Widmo I",
            info = "Twoja odległość umiejętności specjalnej jest zwiększona o 500"
        },
        specdist2 = {
            name = "Widmo II",
            info = "Twoja odległość umiejętności specjalnej została zwiększona o 700\n\t• Całkowity wzrost: 1200"
        },
        specdist3 = {
            name = "Widmo III",
            info = "Twoja odległość umiejętności specjalnej została zwiększona o 800\n\t• Całkowity wzrost: 2000"
        },
        boost1 = {
            name = "Krwiopijec I",
            info = "Za każdym razem, gdy zabijesz człowieka, zyskasz 150 HP, a czas odnowienia umiejętności specjalnych zostanie skrócony o 10%"
        },
        boost2 = {
            name = "Krwiopijec II",
            info = "Za każdym razem, gdy zabijesz człowieka, zyskasz 300 HP, a czas odnowienia umiejętności specjalnej zostanie skrócony o 25%"
        },
        boost3 = {
            name = "Krwiopijec III",
            info = "Za każdym razem, gdy zabijesz człowieka, zyskasz 500 HP, a czas odnowienia umiejętności specjalnych zostanie skrócony o 50%"
        },
        prot1 = {
            name = "Betonowa skóra I",
            info = "Natychmiastowo ulecz 1000 HP i uzyskaj 10% ochrony przed ranami postrzałowymi"
        },
        prot2 = {
            name = "Betonowa skóra II",
            info = "Natychmiastowo ulecz 1000 HP i uzyskaj 10% ochrony przed ranami postrzałowymi\n\t• Całkowita ochrona: 20%"
        },
        prot3 = {
            name = "Betonowa skóra III",
            info = "Natychmiastowo ulecz 1000 HP i uzyskaj 20% ochrony przed ranami postrzałowymi\n\t• Całkowita ochrona: 40%"
        },
    },
    back = "Możesz przytrzymać R, aby wrócić do poprzedniej pozycji",
}

wep.SCP457 = {
    swait = "Czas odnowienia umiejętności specjalnej: %is",
    sready = "Specjalna zdolność jest gotowa!",
    placed = "Aktywne pułapki: %i/%i",
    nohp = "Za mało HP!",
    upgrades = {
        fire1 = {
            name = "Żywa pochodnia I",
            info = "Twój promień spalania zostaje zwiększony o 25"
        },
        fire2 = {
            name = "Żywa pochodnia II",
            info = "Obrażenia od poparzenia są zwiększone o 0,5"
        },
        fire3 = {
            name = "Żywa pochodnia III",
            info = "Twój promień palenia zostaje zwiększony o 50, a obrażenia od spalania zwiększone o 0,5\n\t• Całkowity wzrost promienia: 75\n\t• Całkowity wzrost obrażeń: 1"
        },
        trap1 = {
            name = "Mała niespodzianka I",
            info = "Żywotność pułapki wydłuża się do 4 minusów i spala 1 sekundę dłużej"
        },
        trap2 = {
            name = "Mała niespodzianka II",
            info = "Żywotność pułapki wydłuża się do 5 minut i spala 1 sekundę dłużej, a zadawane przez nią obrażenia są zwiększane o 0,5\n\t• Całkowity wzrost czasu spalania: 2 s"
        },
        trap3 = {
            name = "Mała niespodzianka III",
            info = "Pułapka spala 1 s dłużej, a zadawane przez nią obrażenia są zwiększane o 0,5\n\t• Całkowity wzrost czasu spalania: 3 s\n\t• Całkowity wzrost obrażeń: 1"
        },
        heal1 = {
            name = "Skwiercząca Przekąska I.",
            info = "Podpaleni ludzie wyleczy cię o 1 dodatkowe zdrowie"
        },
        heal2 = {
            name = "Skwiercząca Przekąska II",
            info = "Płonący ludzie wyleczą cię za dodatkowe 1 zdrowie\n\t• Całkowity wzrost leczenia: 2"
        },
        speed = {
            name = "Szybki ogień",
            info = "Twoja prędkość została zwiększona o 10%"
        }
    }
}

wep.SCP682 = {
    swait = "Czas odnowienia umiejętności specjalnej: %is",
    sready = "Specjalna zdolność jest gotowa!",
    s_on = "Jesteś odporny na wszelkie obrażenia! %is",
    upgrades = {
        time1 = {
            name = "Nieprzerwany I",
            info = "Czas trwania umiejętności specjalnej wydłuża się o 2,5 s\n\t• Całkowity czas trwania: 12,5 s"
        },
        time2 = {
            name = "Nieprzerwany II",
            info = "Czas trwania umiejętności specjalnej wydłuża się o 2,5 s\n\t• Całkowity czas trwania: 15 s"
        },
        time3 = {
            name = "Nieprzerwany III",
            info = "Czas trwania umiejętności specjalnej jest wydłużony o 2,5 s\n\t• Całkowity czas trwania: 17,5 s"
        },
        prot1 = {
            name = "Adaptacja I",
            info = "Otrzymujesz 10% mniej obrażeń od pocisku"
        },
        prot2 = {
            name = "Adaptacja II",
            info = "Otrzymujesz 15% mniej obrażeń pociskami\n\t• Całkowite zmniejszenie obrażeń: 25%"
        },
        prot3 = {
            name = "Adaptacja III",
            info = "Otrzymujesz 15% mniej obrażeń pociskami\n\t• Całkowite zmniejszenie obrażeń: 40%"
        },
        speed1 = {
            name = "Wściekły pośpiech I",
            info = "Po użyciu umiejętności specjalnej zyskuj 10% prędkości ruchu, aż do otrzymania obrażeń"
        },
        speed2 = {
            name = "Wściekły pośpiech II",
            info = "Po użyciu umiejętności specjalnej zyskuj 20% prędkości ruchu do momentu otrzymania obrażeń"
        },
        ult = {
            name = "Regeneracja",
            info = "5 sekund po otrzymaniu obrażeń zregeneruj 5% brakującego zdrowia"
        },
    }
}

wep.SCP8602 = {
    upgrades = {
        charge11 = {
            name = "Brutalność I",
            info = "Obrażenia silnego ataku są zwiększone o 5"
        },
        charge12 = {
            name = "Brutalność II",
            info = "Obrażenia silnego ataku są zwiększone o 10\n\t• Całkowity wzrost obrażeń: 15"
        },
        charge13 = {
            name = "Brutalność III",
            info = "Obrażenia silnego ataku są zwiększone o 10\n\t• Całkowity wzrost obrażeń: 25"
        },
        charge21 = {
            name = "Ładunek I",
            info = "Zasięg silnego ataku zostaje zwiększony o 15"
        },
        charge22 = {
            name = "Ładunek II",
            info = "Zasięg silnego ataku zostaje zwiększony o 15\n\t• Całkowity wzrost zasięgu: 30"
        },
        charge31 = {
            name = "Wspólny ból",
            info = "Kiedy wykonasz silny atak, każdy punkt uderzenia w pobliżu osoba otrzyma 20% pierwotnych obrażeń"
        },
    }
}

wep.SCP939 = {
    upgrades = {
        heal1 = {
            name = "Żądza Krwi I",
            info = "Twoje ataki leczą cię za co najmniej 22,5 HP (do 30)"
        },
        heal2 = {
            name = "Żądza Krwi II",
            info = "Twoje ataki leczą cię za co najmniej 37,5 HP (do 50)"
        },
        heal3 = {
            name = "Żądza Krwi III",
            info = "Twoje ataki leczą cię za co najmniej 52,5 HP (do 70)"
        },
        amn1 = {
            name = "Śmiertelny oddech I",
            info = "Twój promień trucizny jest zwiększony do 100"
        },
        amn2 = {
            name = "Śmiertelny oddech II",
            info = "Twoja trucizna zadaje teraz obrażenia: 1,5 dmg/s"
        },
        amn3 = {
            name = "Śmiertelny oddech III",
            info = "Twój promień trucizny jest zwiększony do 125, a obrażenia od trucizny zwiększone do 3 dmg/s"
        },
    }
}

wep.SCP966 = {
    upgrades = {
        lockon1 = {
            name = "Szał I",
            info = "Czas wymagany do ataku został skrócony do 2,5 s"
        },
        lockon2 = {
            name = "Szał II",
            info = "Czas wymagany do ataku jest skrócony do 2 sekund"
        },
        dist1 = {
            name = "Wezwać łowce I",
            info = "Zasięg ataku zostaje zwiększony o 15"
        },
        dist2 = {
            name = "Wezwać łowce II",
            info = "Zasięg ataku zostaje zwiększony o 15\n\t• Całkowity wzrost zasięgu: 30"
        },
        dist3 = {
            name = "Wezwać łowce III",
            info = "Zasięg ataku zostaje zwiększony o 15\n\t• Całkowity wzrost zasięgu: 45"
        },
        dmg1 = {
            name = "Ostre pazury I",
            info = "Obrażenia od ataku są zwiększone o 5"
        },
        dmg2 = {
            name = "Ostre pazury II",
            info = "Obrażenia od ataku są zwiększone o 5\n\t• Całkowity wzrost obrażeń: 10"
        },
        bleed1 = {
            name = "Głębokie rany I",
            info = "Twoje ataki mają 25% szansy na spowodowanie krwawienia wyższego poziomu"
        },
        bleed2 = {
            name = "Głębokie rany II",
            info = "Twoje ataki mają 50% szansy na spowodowanie krwawienia wyższego poziomu"
        },
    }
}

wep.SCP714 = {
    name = "SCP 714"
}

wep.HOLSTER = {
    name = "Kabura",
}

wep.ID = {
    author = "Kerry, Tłumaczenie: Zabójca997",
    name = "ID",
    pname = "Nick:",
    server = "Serwer:",
}

wep.CAMERA = {
    name = "Monitoring",
    showname = "Aparaty fotograficzne",
    info = "Kamery pozwalają zobaczyć, co dzieje się w obiekcie.\nDają także możliwość skanowania SCP i przesyłania tych informacji do bieżącego kanału radiowego",
}

wep.RADIO = {
    name = "Radio",
}

wep.NVG = {
    name = "NVG",
    info = "Gogle noktowizyjne - urządzenie, które rozjaśnia ciemne obszary i jeszcze bardziej rozjaśnia jasne obszary.\nCzasami można przez nie dostrzec anomalne rzeczy."
}

wep.NVGPLUS = {
    name = "Ulepszony NVG",
    showname = "NVG+",
    info = "Ulepszona wersja NVG pozwala na używanie jej podczas trzymania innych przedmiotów w rękach.\nNiestety bateria wystarcza tylko na 10 sekund"
}

wep.KEYCARD = {
    author = "danx91, Tłumaczenie: Zabójca997",
    instructions = "Dostęp:",
    ACC = {
        "BEZPIECZNY",
        "EUCLID",
        "KETER",
        "Punkty kontrolne",
        "Głowica OMEGA",
        "Ogólny dostęp",
        "Brama A",
        "Brama B",
        "Zbrojownia",
        "Łamacz kości piszczela",
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
        "karta naukowca",
        "Karta ochronny MFO",
        "Karta Dowądzącego MFO",
        "Karta poziomu OMNI",
        "Karta Punktu kontrolnego ochrony",
        "Karta hakowania CI",
    },
}

wep.MEDKIT = {
    name = "Apteczka (Pozostało: %d)",
    showname = "Zestaw medyczny",
}

wep.MEDKITPLUS = {
    name = "Duża Apteczka (Pozostało: %d)",
    showname = "Zestaw medyczny+",
}

wep.TASER = {
    name = "paralizator"
}

wep.FLASHLIGHT = {
    name = "Latarka"
}

wep.BATTERY = {
    name = "Baterie"
}

wep.GASMASK = {
    name = "Maska gazowa"
}

wep.weapon_stunstick = "Pałka"

lang.WEAPONS = wep

registerLanguage( lang, "polish", "pl", )
