local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
SCPs
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "Wzmocnienie na powierzchni",
		info = "Zyskaj dodatkową orchronę przed pociskami oraz odblokuj leczenie i regenerację, kiedy jesteś na powierzchni\n\t• Dodatkowa ochrona przed pociskami: [%def]\n\t• Dodatkowa ochrona przed pociskami: [flat] dmg\n\t• Po wyjściu na powierzchnię, wylecz [buff_hp] HP w krótkim czasie\n\t• Poza walką, odzyskaj [%regen_min] - [%regen_max] (skalowane z czasem) otrzymanych obrażeń od pocisków\n\t• Zadawnie obrażeń leczy cię za [%heal_min] - [%heal_max] (skalowane z czasem) zadanych obrażeń\n\t• Powrót do placówki całkowicie anuluje wszystkie leczenia",
		parse_description = true,
	}
}

lang.CommonSkills = {
	c_button_overload = {
		name = "Przeciążenie",
		dsc = "Umożliwia przeciążenie większości zamkniętych drzwi. Przeciążone drzwi otwierają się (lub zamykają) na krótki okres czasu."
	},
	c_dmg_mod = {
		name = "Ochrona przed obrażeniami",
		dsc = "Aktualna ochrona: [mod]\nDodatkowa ochrona: [flat]\n\nOchrona ta dotyczy obrażeń od pocisków. Uwzględnia jedynie modyfikatory skalowania czasu i wzmocnienie na powierzchni. Modyfikatory specyficzne dla danego SCP nie są uwzględnione!\n\nWzmocnienie: [buff]",
		dmg = "DMG",
		not_bought = "Nie kupione",
		not_surface = "Wyłączone w placówce",
		buff = "\n   • Obecna regeneracja: %s otrzymanych obrażeń od pocisków\n   • Obecne leczenie: %s zadanych obrazeń",
	},
}

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
			name = "Umiejętność Pasywna",
			dsc = "Kontakt z graczami powoduje ich podpalenie. Dodatkowo nie posiadasz kolizji z drzwiami",
		},
		drain_bar = {
			name = "Wysysanie",
			dsc = "Pozostały czas wysysania",
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
		assassin = "Zombie zabójca\n\t• Posiada lekki atak i umiejętność szybkiego ataku\n\t• Najszybszy, duże obrażenia, ale ma najniższe zdrowie",
		boomer = "Wybuchający ciężki zombie\n\t• Posiada ciężki atak i zdolność wybuchu\n\t• Niska prędkość ruchu, ale ma dużo zdrowia i największe obrażenia",
		heavy = "Plujący ciężki zombie\n\t• Posiada ciężki atak i zdolność strzału\n\t• Najwolniejszy typ zombie z niskimi obrażeniami, ale ma najwięcej zdrowia",
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
			name = "Umiejętność Pasywna",
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
			info = "Ulepsza twoją zdolność wzmocnienia\n\t• Czas odnowienia skrócony o [-buff_cd]\n\t• Czas trwania wzmocnienia zwiększony o [+buff_dur]",
		},
		buff2 = {
			name = "Powstań II",
			info = "Ulepsza twoją zdolność wzmocnienia\n\t• Zasięg wzmocnienia zwiększony o [+buff_radius]\n\t• Moc wzmocnienia zwiększona o [+buff_power]",
		},
		surgery_cd1 = {
			name = "Chirurgiczna Precyzja I",
			info = "Skraca czas operacji o [surgery_time]s\n\t• To ulepszenie jest kumulatywne",
		},
		surgery_cd2 = {
			name = "Chirurgiczna Precyzja II",
			info = "Skraca czas operacji o [surgery_time]s\n\t• To ulepszenie jest kumulatywne",
		},
		surgery_heal = {
			name = "Transplantacja",
			info = "Ulepsza twoją zdolność operacji\n\t• Po operacji leczysz się o [surgery_heal] HP\n\t• Po operacji wszystkie pobliskie zombie leczą się o [surgery_zombie_heal] HP",
		},
		surgery_dmg = {
			name = "Niepowstrzymana Operacja",
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
			name = "Atak Dodatkowy I",
			info = "Ulepsza twój atak dodatkowy\n\t• Obrażenia zwiększone o [+secondary_dmg]",
		},
		secondary2 = {
			name = "Atak Dodatkowy II",
			info = "Ulepsza twój atak dodatkowy\n\t• Obrażenia zwiększone o [+secondary_dmg]\n\t• Czas odnowienia skrócony o [-secondary_cd]",
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
			dsc = "Rzuć się do przodu. Jeśli trafisz gracza, przykleisz się do niego na krótki czas. Użyj ponownie aby się odkleić",
		},
		boost = {
			name = "Dopalacz",
			dsc = "Zdobądź jeden z 3 dopalaczy, który jest obecnie aktywny. Po użyciu zostanie zastąpiony przez kolejny. Moc wszystkich dopalaczy wzrasta wraz z każdym ładunkiem pasywnym (ograniczona do [cap] ładunków).\n\nObecny dopalacz: [boost]\n\nDopalacz szybkości: [speed]\nDopalacz obrony przed kulami: [def]\nDopalacz regeneracji: [regen]",
			buffs = {
				"Szybkość",
				"Obrona przed kulami",
				"Regeneracja",
			},
		},
		eric = {
			name = "Eric?",
			dsc = "Pytasz nieuzbrojonych graczy, czy są Erikiem. Za każdym razem zdobywasz jeden ładunek pasywny",
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
			info = "Ulepsza twoją zdolność skakania\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Możesz pozostać [+detach_time] dłużej na swoim celu",
		},
		dash2 = {
			name = "Skok II",
			info = "Ulepsza twoją zdolność skakania\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Możesz pozostać [+detach_time] dłużej na swoim celu",
		},
		dash3 = {
			name = "Skok III",
			info = "Ulepsza twoją zdolność skakania\n\t• Użycie tej umiejętności będąc przyczepionym sprawi, że wyskoczysz zamiast się odczepić\n\t• Podczas wyskoku, możesz przyczepić się do innego gracza\n\t• Nie możesz przyczepić się spowrotem do gracza, z którego wyskoczyłeś",
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
			dsc = "Rzuć się do przodu podczas gniewu. Natychmiast kończy gniew. Nie będziesz jadł ciała po szarży",
		},
		regen = {
			name = "Regeneracja",
			dsc = "Usiądź w miejscu i zamień ładunki regeneracji na zdrowie",
		},
		special = {
			name = "Koniec Polowania",
			dsc = "Zatrzymaj gniew. Zdobądź ładunki regeneracji za każdy aktywny cel",
		},
		passive = {
			name = "Umiejętność Pasywna",
			dsc = "Jeśli ktoś na ciebie patrzy, wpadasz w gniew. Natychmiast zabijasz graczy, którzy cię rozwścieczyli",
		},
	},

	upgrades = {
		parse_description = true,

		rage = {
			name = "Gniew",
			info = "Otrzymanie [rage_dmg] obrażeń w [rage_time] sekund od jednego gracza wprawia cię w gniew",
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
			info = "Pozwala na zabicie wielu celów w gniewie przez ograniczony czas po pierwszym zabiciu\n\t• Maksymalna liczba celów: [multi]\n\t• Limit czasowy: [multi_time] sekund\n\t• Otrzymywane obrażenia od kul, po zabiciu pierwszego celu, zwiększone o [+prot]",
		},
		multi2 = {
			name = "Niekończący się Gniew II",
			info = "Pozwala na zabicie jeszcze więcej celów w gniewie\n\t• Maksymalna liczba celów: [multi]\n\t• Limit czasowy: [multi_time] sekund\n\t• Otrzymywane obrażenia od kul, po zabiciu pierwszego celu, zwiększone o [+prot]",
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
			dsc = "Użyj, aby umieścić punkt teleportacji. Stojąc blisko istniejącego punktu teleportacji, możesz przytrzymać klawisz, aby wybrać miejsce docelowe. Puść klawisz, aby teleportować się do wybranego miejsca",
		},
		passive = {
			name = "Kolekcja Zębów",
			dsc = "Kule nie mogą cię zabić, ale mogą tymczasowo cię powalić, możesz także przechodzić przez drzwi. Dotknięcie gracza teleportuje go do Kieszonkowego Wymiaru. Każdy gracz teleportowany do Kieszonkowego Wymiaru przyznaje jeden ząb. Zebrane zęby wzmacniają twoją umiejętność obumierania",
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
	name = "Żelbeton",
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
			dsc = "Umieść wabik, który będzie rozpraszał i wysysał psychikę graczy",
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
			info = "Wysysanie psychiki przez horror jest zwiększone o [+horror_sanity]",
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
			name = "Umiejętność Pasywna",
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
			dsc = "Zyskuj prędkość z czasem i zadaj obrażenia pierwszemu graczowi przed sobą. Jeśli zaatakowany gracz jest wystarczająco blisko ściany, przybij go do tej ściany i wykonaj silny atak",
		},
		passive = {
			name = "Umiejętność Pasywna",
			dsc = "Widzisz gracza w swoim lesie i przez jakiś czas po jego opuszczeniu. Gracze w lesie tracą psychikę, jeśli mają brak psychiki, tracą zdrowie. Leczenie za psycjikę/zdrowie zabrane od graczy w lesie. To leczenie może przekroczyć twoje maksymalne zdrowie",
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
			name = "Gęsty Las I",
			info = "Ulepsza twoją pasywną zdolność\n\t• Maksymalne nadleczenie zwiększone o [+overheal]\n\t• Szybkość pasywna zwiększona o [/passive_rate]\n\t• Czas wykrywania gracza zwiększony o [+detect_time]",
		},
		passive2 = {
			name = "Gęsty Las II",
			info = "Ulepsza twoją pasywną zdolność\n\t• Maksymalne nadleczenie zwiększone o [+overheal]\n\t• Szybkość pasywna zwiększona o [/passive_rate]\n\t• Czas wykrywania gracza zwiększony o [+detect_time]",
		},
		primary = {
			name = "Prosty ale Niebezpieczny",
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
			info = "Ulepsza twoją zdolność szarży\n\t• Zasięg zwiększony o [+charge_range]\n\t• Czas trwania zwiększony o [+charge_time]\n\t• Obrażenia przybicia zwiększone o [+charge_pin_dmg]",
		},
		charge3 = {
			name = "Szarża III",
			info = "Ulepsza twoją zdolność szarży\n\t• Prędkość zwiększona o [+charge_speed]\n\t• Powyżej 80% trwania szarży, każde trafienie liczy się jako silny atak\n\t• Przybicie gracza do ściany łamie jego kości",
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
			name = "Umiejętność Pasywna",
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
			dsc = "Wykonaj podstawowy atak. Możesz atakować tylko graczy z co najmniej 10 ładunkami zmęczenia. Atakowani gracze tracą część ładunków zmęczenia. Efekty tego ataku zależą od drzewka umiejętności",
		},
		channeling = {
			name = "Kanałowanie",
			dsc = "Kanałuj zdolność wybraną w drzewku umiejętności",
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
			name = "Doskok / Kamuflaż",
			dsc = "\nSędzia:\nRusz naprzód, zadając obrażenia wszystkim na swojej drodze\n\nProkurator:\nAktywuj kamuflaż. Podczas kamuflażu jesteś mniej widoczny. Używanie umiejętności, poruszanie się lub otrzymywanie obrażeń przerywa go",
		},
		secondary = {
			name = "Przesłuchanie / Nadzór",
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
			name = "Przesłuchanie",
			dsc = "Pozostały czas przesłuchania",
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
			name = "Doskok I",
			info = "Ulepsza twoją zdolność doskoku\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Obrażenia zwiększone o [+dash_dmg]",
		},
		dash2 = {
			name = "Doskok II",
			info = "Ulepsza twoją zdolność doskoku\n\t• Czas odnowienia zmniejszony o [-dash_cd]\n\t• Obrażenia zwiększone o [+dash_dmg]",
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
			name = "Przesłuchanie I",
			info = "Ulepsza twoją zdolność przesłuchania\n\t• Czas odnowienia zmniejszony o [-drain_cd]\n\t• Czas trwania zmniejszony o [-drain_dur]",
		},
		drain2 = {
			name = "Przesłuchanie II",
			info = "Ulepsza twoją zdolność przesłuchania\n\t• Czas odnowienia zmniejszony o [-drain_cd]\n\t• Czas trwania zmniejszony o [-drain_dur]",
		},
		spect1 = {
			name = "Nadzór I",
			info = "Ulepsza twoją zdolność nadzoru\n\t• Czas odnowienia zmniejszony o [-spect_cd]\n\t• Czas trwania zwiększony o [+spect_dur]\n\t• Ochrona przed obrażeniami od kul zwiększona do [%spect_prot]",
		},
		spect2 = {
			name = "Nadzór II",
			info = "Ulepsza twoją zdolność nadzoru\n\t• Czas odnowienia zmniejszony o [-spect_cd]\n\t• Czas trwania zwiększony o [+spect_dur]\n\t• Ochrona przed obrażeniami od kul zwiększona do [%spect_prot]",
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
			name = "Atak",
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
			name = "Umiejętność Pasywna",
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
			info = "Ulepsza twoją umiejętność ataku\n\t• Czas odnowienia skrócony o [-attack_cd]\n\t• Obrażenia zwiększone o [+attack_dmg]",
		},
		attack2 = {
			name = "Ostre Pazury II",
			info = "Ulepsza twoją umiejętność ataku\n\t• Czas odnowienia skrócony o [-attack_cd]\n\t• Obrażenia zwiększone o [%attack_dmg_stacks] za każdy ładunek pasywny",
		},
		attack3 = {
			name = "Ostre Pazury III",
			info = "Ulepsza twoją umiejętność ataku\n\t• Obrażenia zwiększone o [+attack_dmg]\n\t• Obrażenia zwiększone o [%attack_dmg_stacks] za każdy ładunek pasywny",
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
