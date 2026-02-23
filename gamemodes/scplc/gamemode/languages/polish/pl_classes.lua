local lang = LANGUAGE

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

classes.SCP023 = "SCP-023"
classes.SCP049 = "SCP-049"
classes.SCP0492 = "SCP-049-2"
classes.SCP058 = "SCP-058"
classes.SCP066 = "SCP-066"
classes.SCP096 = "SCP-096"
classes.SCP106 = "SCP-106"
classes.SCP173 = "SCP-173"
classes.SCP457 = "SCP-457"
classes.SCP682 = "SCP-682"
classes.SCP8602 = "SCP-860-2"
classes.SCP939 = "SCP-939"
classes.SCP966 = "SCP-966"
classes.SCP3199 = "SCP-3199"
classes.SCP24273 = "SCP-2427-3"

classes.classd = "Klasa D"
classes.veterand = "Weteran Klasy D"
classes.kleptod = "Kleptoman Klasy D"
classes.contrad = "Klasa D z Kontrabandą"
classes.ciagent = "Agent CI"
classes.expd = "Eksperymentalna Klasa D"
classes.classd_prestige = "Krawiec Klasy D"

classes.sciassistant = "Asystent Naukowca"
classes.sci = "Naukowiec"
classes.seniorsci = "Starszy Naukowiec"
classes.headsci = "Główny Naukowiec"
classes.contspec = "Specjalista Zabezpieczeń"
classes.sci_prestige = "Uciekinier Klasy D"

classes.guard = "Ochroniarz"
classes.chief = "Szef Ochrony"
classes.lightguard = "Lekki Ochroniarz"
classes.heavyguard = "Ciężki Ochroniarz"
classes.specguard = "Specjalista Ochrony"
classes.guardmedic = "Ochroniarz Sanitariusz"
classes.tech = "Technik Ochrony"
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
classes.alpha1medic = "Medyk MTF Alfa-1"
classes.alpha1com = "Dowódca MTF Alfa-1"
classes.ci = "Chaos Insurgency"
classes.cisniper = "Snajper Chaos Insurgency"
classes.cicom = "Dowódca Chaos Insurgency"
classes.cimedic = "Medyk Chaos Insurgency"
classes.cispec = "Specjalista Chaos Insurgency"
classes.ciheavy = "Ciężka Jednostka Chaos Insurgency"
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
- Możesz tymczasowo zablokować drzwi]],

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
- Jesteś upoważniony do ]].."[ZMIENIONO]",

	alpha1com = [[- Chroń placówkę za wszelką cenę
- Wydawaj rozkazy innym sojusznikom
- Jesteś upoważniony do ]].."[ZMIENIONO]",

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
- Zlokalizuj i aktywuj urządzenie GOC
- Słuchaj swojego przełożonego]],

	gocmedic = [[- Zniszcz podmioty SCP
- Wspieraj swoją jednostkę leczeniem
- Słuchaj swojego przełożonego]],

	goccom = [[- Zniszcz podmioty SCP
- Zlokalizuj i aktywuj urządzenie GOC
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
Czy może eskortować: Klasę D
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
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Podstawowy ochroniarz. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	lightguard = [[Poziom trudności: Trudny
Wytrzymałość: Niska
Zwinność: Bardzo Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Wysoka użyteczność, brak zbroi i mniejsze zdrowie. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	heavyguard = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Niska
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Mniejsza użyteczność, lepszy pancerz i wyższe zdrowie. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	specguard = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Niska
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Niezbyt duża użyteczność, większe zdrowie i silny potencjał bojowy. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	chief = [[Poziom trudności: Łatwy
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden z Ochroniarzy. Nieco lepszy potencjał bojowy, posiada paralizator. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	guardmedic = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden ze Ochroniarzy. Posiada apteczkę i paralizator. Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	tech = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jeden ze strażników. Ma możliwą do postawienia wieżyczkę z 3 trybami ognia (przytrzymaj E na wieżczce, aby zobaczyć jej menu). Wykorzystaj swoją broń i narzędzia, aby pomóc innym członkom personelu oraz zneutralizować obiekty SCP i klasy D. Możesz eskortować naukowców.
]],

	cispy = [[Poziom trudności: Bardzo Trudny
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Klasę D
Eskortowany przez: Nikogo

Przegląd:
Szpieg CI. Wysoka użyteczność. Spróbuj wtopić się w ochroniarzy i pomóż klasie D.
]],

lightcispy = [[Poziom trudności: Bardzo Trudny
Wytrzymałość: Niska
Zwinność: Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Klasę D
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
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojony w Pistolet Maszynowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntf_2 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w strzelbę. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntf_3 = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w karabin. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntfmedic = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Niski
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w pistolet, posiada apteczkę. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntfcom = [[Poziom trudności: Trudny
Wytrzymałość: Wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w karabin wyborowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ntfsniper = [[Poziom trudności: Trudny
Wytrzymałość: Zwykła
Zwinność: Zwykła
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF NTF. Uzbrojona w karabin snajperski. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	alpha1 = [[Poziom trudności: Średni
Wytrzymałość: Ekstremalna
Zwinność: Bardzo Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alfa-1. Mocno opancerzona, bardzo użyteczna jednostka, uzbrojona w karabin. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	alpha1sniper = [[Poziom trudności: Trudny
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alfa-1. Mocno opancerzona, bardzo użyteczna jednostka, uzbrojona w karabin wyborowy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

alpha1medic = [[Poziom trudności: Trudny
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alfa-1.  Mocno opancerzona, bardzo użyteczna jednostka, zapewnia leczenie. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	alpha1com = [[Poziom trudności: Trudny
Wytrzymałość: Bardzo wysoka
Zwinność: Bardzo Wysoka
Potencjał bojowy: Bardzo Wysoki
Czy może uciec: Nie
Czy może eskortować: Naukowców
Eskortowany przez: Nikogo

Przegląd:
Jednostka MTF Alfa-1. Mocno opancerzona, bardzo użyteczna jednostka, wydaje rozkazy. Wejdź do placówki i zabezpiecz ją. Pomóż personelowi w środku i zneutralizuj SCP i klasę D.
]],

	ci = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Średni
Czy może uciec: Nie
Czy może eskortować: Klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki.
]],

cisniper = [[Poziom trudności: Średni
Wytrzymałość: Zwykła
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do obiektu, pomóż klasie D i zabij personel obiektu. Osłaniaj swój zespół.
]],

	cicom = [[Poziom trudności: Średni
Wytrzymałość: Bardzo wysoka
Zwinność: Wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wyższy potencjał bojowy. Wejdź do placówki, pomóż klasie D i zabij personel placówki.
]],
	
	cimedic = [[Poziom trudności: Średni
Wytrzymałość: Wysoka
Zwinność: Wysoka
Potencjał bojowy: Normalny
Czy może uciec: Nie
Czy może eskortować: Klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki. Zaczynasz z apteczką.
]],

	cispec = [[Poziom trudności: Średni
Wytrzymałość: Średnio-wysoka
Zwinność: Średnio-wysoka
Potencjał bojowy: Wysoki
Czy może uciec: Nie
Czy może eskortować: Klasę D
Eskortowany przez: Nikogo

Przegląd:
Jednostka Rebelii Chaosu. Wejdź do placówki, pomóż klasie D i zabij personel placówki. Możesz rozstawić działko.
]],

ciheavy = [[Poziom trudności: Średni
Wytrzymałość: Średnio-wysoka
Zwinność: Średnio-wysoka
Potencjał bojowy: Bardzo wysoki
Czy może uciec: Nie
Czy może eskortować: Klasę D
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
Trudność: Trudny | Wytrzymałość: Niska | Zwinność: Bardzo Wysoka | Obrażenia: Wysokie
Najszybszy z dużymi obrażeniami, ale ma najniższe zdrowie. Posiada szybki atak.

Wybuchające zombie:
Trudność: Trudny | Wytrzymałość: Wysoka | Zwinność: Niska | Obrażenia: Bardzo Wysokie
Niska prędkość ruchu, ale ma wysokie zdrowie i największe obrażenia. Wybucha po śmierci.

Plujący zombie:
Trudność: Średnia | Wytrzymałość: Bardzo Wysoka | Zwinność: Bardzo Niska | Obrażenia: Niskie
Najwolniejszy typ zombie z niskimi obrażeniami, ale ma najwięcej zdrowia. Może strzelać pociskami.
]],
}
