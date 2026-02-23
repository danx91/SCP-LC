local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
SCPs
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "Renforcement extérieur",
		info = "Octroie une régénération a la surface, lorsque ne prenant pas de dégâts pendant un moment. De plus, offre également une réduction des dégâts lorsque positionné sur la plateforme d'évacuation"
	}
}

lang.CommonSkills = {
	c_button_overload = {
		name = "Surcharge",
		dsc = "Vous permet de surcharger les portes pour les ouvrir/fermer. "
	},
	c_dmg_mod = {
		name = "Protection aux dégats",
		dsc = "Protection actuelle: [mod]\n\nCeci est la protection contre les dégats non directs reçus. Il ne prend en compte que le modificateur de dégats et le renforcement extérieur. Les modificateurs spécifiques aux SCP ne sont pas inclus!"
	},
}

wep.SCP023 = {
	skills = {
		_overview = { "passive", "drain", "clone", "hunt" },
		drain = {
			name = "Vol d'Énergie",
			dsc = "Vole l'endurance des joueurs proches. Si les joueurs quittent le champ d'action, place l'abilité en cooldown",
		},
		clone = {
			name = "Clone",
			dsc = "Place un clone qui possède les mêmes passifs que vous. Le clone se promènera et poursuivra les joueurs à proximité",
		},
		hunt = {
			name = "Chasse",
			dsc = "Tuez instantanément l'une de vos proies ou une personne à proximité et téléportez-vous vers son corps",
		},
		passive = {
			name = "Passif",
			dsc = "Entrer en collision avec des joueurs les font prendre feu",
		},
		drain_bar = {
			name = "Vol",
			dsc = "Temps restant sur votre abilité de vol d'énergie",
		},
	},

	upgrades = {
		parse_description = true,

		passive = {
			name = "Braise Incandescente",
			info = "Augmente les dégâts de votre brûlure passive de [+burn_power]",
		},
		invis1 = {
			name = "Flamme Invisible I",
			info = "Octroie une invisibilité\n\t• Vous disparaissez aux yeux des joueurs assez lointains\n\t• Les joueurs ne pouvant pas vous voir ne seront pas ajoutés a votre liste de proies\n\t• Cette amélioration fonctionne aussi sur le clone\n\t• Vous devenez invisible a partir de [invis_range] unités de distance",
		},
		invis2 = {
			name = "Flamme Invisible II",
			info = "Améliore votre invisibilité\n\t• Vous devenez invisible a partir de [invis_range] unités de distance",
		},
		prot1 = {
			name = "Feu Immortel I",
			info = "Octroie [-prot] de protection aux dégats par balle",
		},
		prot2 = {
			name = "Undying Fire II",
			info = "Améliore la protection a [-prot]",
		},
		drain1 = {
			name = "Détournement I",
			info = "Améliore votre abilité de vol\n\t• Durée augmentée de [+drain_dur]\n\t• Distance maximale augmentée de [+drain_dist]",
		},
		drain2 = {
			name = "Détournement II",
			info = "Améliore votre abilité de vol\n\t• Puissance du vol augmentée de [/drain_rate]\n\t• Soigne vos PV de [%drain_heal] de l'endurance volée",
		},
		drain3 = {
			name = "Détournement III",
			info = "Améliore votre abilité de vol\n\t• Durée augmentée de [+drain_dur]\n\t• Distance maximale augmentée de [+drain_dist]",
		},
		drain4 = {
			name = "Détournement IV",
			info = "Améliore votre abilité de vol\n\t• Puissance du vol augmentée de [/drain_rate]\n\t• Soigne vos PV de [%drain_heal] de l'endurance volée",
		},
		hunt1 = {
			name = "Ardeur Infinie I",
			info = "Améliore votre capacité de chasse\n\t• Cooldown réduit de [-hunt_cd]",
		},
		hunt2 = {
			name = "Ardeur Infinie II",
			info = "Améliore votre capacité de chasse\n\t• Cooldown réduit de [-hunt_cd]\n\t• Rayon de recherche de proies aléatoires augmenté de [+hunt_range]",
		},
	}
}

wep.SCP049 = {
	zombies = {
		normal = "Zombie Classique",
		assassin = "Zombie Assassin",
		boomer = "Zombie Djihadiste",
		heavy = "Zombie Caillasseur",
	},
	zombies_desc = {
	normal = "Un zombie standard\n\t• Possède des attaques légères et lourdes\n\t• Choix décent avec des statistiques équilibrées",
    assassin = "Un zombie assassin\n\t• Possède une attaque légère et une capacité d'attaque rapide\n\t• Le plus rapide, mais a les points de vie et les dégâts les plus faibles",
    boomer = "Un zombie lourd et explosif\n\t• Possède une capacité d'attaque et d'explosion importante\n\t• Faible vitesse de déplacement, mais a une santé élevée et des dégâts plus élevés",
    heavy = "Un zombie lourd et crachant\n\t• Possède de lourdes capacités d'attaque et de tir\n\t• Le type de zombie le plus lent, mais il a des dégâts élevés et le plus de santé",
	},
	skills = {
		_overview = { "passive", "choke", "surgery", "boost" },
		surgery_failed = "Surgery failed!",

		choke = {
			name = "Touché Du Docteur",
			dsc = "Étranglez un joueur jusqu'a la mort. Peut être interrompu en encaissant assez de dégats",
		},
		surgery = {
			name = "Opération",
			dsc = "Éffectue une opération sur un cadavre pour le transformer en SCP-049-2. Recevoir des dégats annule l'opération",
		},
		boost = {
			name = "Soulèvement!",
			dsc = "Octroie des boost a vous ainsi que tout les SCP-049-2 ",
		},
		passive = {
			name = "Passif",
			dsc = "Les zombies a proximité gagnent une protection aux dégats par balle",
		},
		choke_bar = {
			name = "Touché Du Docteur",
			dsc = "Lorsque remplie, la cible meurt",
		},
		surgery_bar = {
			name = "Opération",
			dsc = "Temps restant de l'opération",
		},
		boost_bar = {
			name = "Soulèvement!",
			dsc = "Temps restant du boost",
		},
	},

	upgrades = {
		parse_description = true,

		choke1 = {
			name = "Touché Du Docteur I",
			info = "Améliore votre étranglement\n\t• Cooldown reduit de [-choke_cd]\n\t• Seuil de dégats augmenté de [+choke_dmg]",
		},
		choke2 = {
			name = "Touché Du Docteur II",
			info = "Améliore votre étranglement\n\t• Vitesse d'étranglement augmentée de [+choke_rate]\n\t• Ralentissement après étranglement réduit de [-choke_slow]",
		},
		choke3 = {
			name = "Touché Du Docteur III",
			info = "UAméliore votre étranglement\n\t• Cooldown reduit de [-choke_cd]\n\t• Seuil de dégats augmenté de [+choke_dmg]\n\t• Vitesse d'étranglement augmentée de [+choke_rate]",
		},
		buff1 = {
			name = "Soulèvement I",
			info = "Améliore votre boost\n\t• Cooldown réduit de [-buff_cd]\n\t• Durée augmentée de [+buff_dur]",
		},
		buff2 = {
			name = "Soulèvement II",
			info = "Améliore votre boost\n\t• Rayon augmenté de [+buff_radius]\n\t• Puissance augmentée de [+buff_power]",
		},
		surgery_cd1 = {
			name = "Précision Chirurgicale I",
			info = "Réduit le temps d'opération de [surgery_time]s\n\t• Cette amélioration est cumulable avec une autre",
		},
		surgery_cd2 = {
			name = "Précision Chirurgicale II",
			info = "Réduit le temps d'opération de [surgery_time]s\n\t• Cette amélioration est cumulable avec une autre",
		},
		surgery_heal = {
			name = "Transplantation",
			info = "Améliore votre opération\n\t• Après chaque chirurgie vous récupérez [surgery_heal] HP\n\t• les zombies a proximité récupèrent [surgery_zombie_heal] HP",
		},
		surgery_dmg = {
			name = "Chirurgien Ultime",
			info = "Encaisser des dégats n'arrête plus l'opération ",
		},
		surgery_prot = {
			name = "Main de Maitre",
			info = "Pendant une opération, gagnez [-surgery_prot] de protection contre les dégats par balle",
		},
		zombie_prot = {
			name = "L'infirmier",
			info = "Gagnez des protection contre les balles pour chaque zombie proche de vous\n\t• Protection pour chaque zombie proche: [%zombie_prot]\n\t• Protection maximale: [%zombie_prot_max]",
		},
		zombie_lifesteal = {
			name = "Soif De Sang I",
			info = "Les zombies gagnent [%zombie_ls] vol de vie sur leurs attaques",
		},
		stacks_hp = {
			name = "Injection De Stéroïdes",
			info = "Lorsqu'un zombie est crée, ses HP sont augmentés de [%stacks_hp] pour chaque chirurgie précédente",
		},
		stacks_dmg = {
			name = "Thérapie Radicale",
			info = "Lorsqu'un zombie est crée, ses dégats sont augmentés de [%stacks_dmg] pour chaque chirurgie précédente",
		},
		zombie_heal = {
			name = "Soif De Sang II",
			info = "Vous vous soignez de [%zombie_heal] des dégats infligés par les zombies proche de vous",
		}
	}
}

wep.SCP0492 = {
	skills = {
		prot = {
			name = "Protection",
			dsc = "Vous gagnez des réduction de dégats en étant proche de SCP-049",
		},
		boost = {
			name = "Boost",
			dsc = "Indique lorsque le boost de SCP-049 est actif sur vous",
		},
		light_attack = {
			name = "Attaque Légère",
			dsc = "Éffectue une attaque légère",
		},
		heavy_attack = {
			name = "Attaque Lourde",
			dsc = "Éffectue une attaque lourde",
		},
		rapid = {
			name = "Attaque Rapide",
			dsc = "Éffectue une attaque rapide",
		},
		shot = {
			name = "Tir",
			dsc = "Envoie un projectile blessant",
		},
		explode = {
			name = "Explosion",
			dsc = "Activez la lorsque vous avez moins de 50 HP. Vous rend temporairement immortel et augmente votre vitesse. Après une courte période, vous explosez blessant tout le monde dans une zone restreinte",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Durée restante du boost",
		},
		explode_bar = {
			name = "Explode",
			dsc = "Temps restant avant l'explosion",
		},
	},

	upgrades = {
		parse_description = true,

		primary1 = {
			name = "Attaque Principale I",
			info = "Améliore votre attaque principale\n\t• Cooldown réduit de [-primary_cd]",
		},
		primary2 = {
			name = "Attaque Principale II",
			info = "Améliore votre attaque principale\n\t• Cooldown réduit de [-primary_cd]\n\t• Dégats augmentés de [+primary_dmg]",
		},
		secondary1 = {
			name = "Attaque Secondaire I",
			info = "Améliore votre attaque secondaire\n\t• Dégats augmentés de [+secondary_dmg]",
		},
		secondary2 = {
			name = "Attaque Secondaire II",
			info = "Améliore votre attaque secondaire\n\t• Dégats augmentés de [+secondary_dmg]\n\t• Cooldown réduit de [-secondary_cd]",
		},
		overload = {
			name = "Surcharge",
			info = "Augmente le nombre de surcharges de [overloads]",
		},
		buff = {
			name = "Soulèvement!",
			info = "Améliore votre protection et le boost de SCP-049\n\t• Pouvoir de protection: [%+prot_power]\n\t• Pouvoir du boost: [++buff_power]",
		},
	}
}

wep.SCP058 = {
	skills = {
		_overview = { "primary_attack", "shot", "explosion" },
		primary_attack = {
			name = "Attaque principale",
			dsc = "Attaque juste en face de vous a l'aide de votre dard. Peut appliquer un empoisonnement si l'amélioration adéquate est débloquée.",
		},
		shot = {
			name = "Tir",
			dsc = "Tir un projectile dans la direction ou vous regardez.",
		},
		explosion = {
			name = "Explosion",
			dsc = "Release burst of corrupted blood dealing massive damage to targets nearby",
		},
		shot_stacks = {
			name = "Tirs restants",
			dsc = "Vous montre combien de tirs vous pouvez effectuer. Certaines amélioration peuvent varier le cooldown ou le nombre maximal par exemple.",
		},
	},

	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Dard Vénimeux I",
			info = "Applique un empoisonnement sur votre attaque principale"
		},
		attack2 = {
			name = "Dard Vénimeux II",
			info = "Augmente les dégâts d'attaque principale, les dégâts du poison, et réduit le cooldown.\n\t• Ajoute [prim_dmg] dégâts aux attaques\n\t• Attack poison deals [pp_dmg] Dégâts\n\t• Le cooldown est réduit de [prim_cd]s"
		},
		attack3 = {
			name = "Dard Vénimeux III",
			info = "Augmente les dégâts du poison et réduit le cooldown.\n\t• Si la cible n'est pas empoisonée, applique 2 stacks de poison\n\t• Attack poison deals [pp_dmg] Dégâts\n\t• Cooldown is reduced by [prim_cd]s"
		},
		shot = {
			name = "Sang Contaminé",
			info = "Applique un empoisonnement sur vos tirs"
		},
		shot11 = {
			name = "Surtension I",
			info = "Augmente les dégats, la taille du projectile, le cooldown. Ralentit le projectile\n\t• Dégats augmentés de [+shot_damage]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]\n\t• Cooldown augmenté de [shot_cd]s"
		},
		shot12 = {
			name = "Surge II",
			info = "Augmente les dégats, la taille du projectile, le cooldown. Ralentit le projectile\n\t• Dégats augmentés de [+shot_damage]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]\n\t• Cooldown augmenté de [shot_cd]s"
		},
		shot21 = {
			name = "Brume Sanglante I",
			info = "Les tirs laissent une brûme a l'impact, blessant et empoisonnant toute personne a son contact.\n\t• Les dégâts du tir sont retirés\n\t• La brûme inflige [cloud_damage] dégâts a son contact\n\t• Le poison appliqué par la brûme inflige [sp_dmg] dégats\n\t• Stacks limités à [stacks]\n\t• Cooldown augmenté de [shot_cd]s\n\t• Vitesse de récupération: [/+regen_rate]"
		},
		shot22 = {
			name = "Brume Sanglante II",
			info = "Renforce la brume.\n\t• La brûme inflige [cloud_damage] dégâts a son contact\n\t• Le poison appliqué par la brûme inflige [sp_dmg] dégâts\n\t• Les tirs sont récupérés a une vitesse de: [/+regen_rate]"
		},
		shot31 = {
			name = "Tir Rapide I",
			info = "Vous permet de tirer vite en maintenant le bouton de tir\n\t• Débloque la capacité de tir rapide\n\t• Les dégâts des tirs sont retirés\n\t• Stacks limités à [stacks]\n\t• Vitesse de récupération: [/+regen_rate]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]"
		},
		shot32 = {
			name = "Tir Rapide II",
			info = "Augmente le maximum de stacks et la vitesse de tir\n\t• Stacks limités a à[stacks]\n\t• Vitesse de récupération: [/+regen_rate]\n\t• Changement de la taille: [++shot_size]\n\t• Changement de la vitesse: [++shot_speed]"
		},
		exp1 = {
			name = "Explosion",
			info = "Débloque la capacité d'exploser, infligeant des Dégâts massifs lorsque votre santé diminue pour la première fois en dessous de chaque multiple de 1000 PV."
		},
		exp2 = {
			name = "Soufle Toxique",
			info = "Améliore votre abilité d'explosion\n\t• Applique 2 stacks de poison\n\t• Multiplicateur du rayon: [+explosion_radius]"
		},
	}
}

wep.SCP066 = {
	skills = {
		_overview = { "eric", "music", "dash", "boost" },
		not_threatened = "Vous n'êtes pas assez menacé pour attaquer!",

		music = {
			name = "Symphony No. 2",
			dsc = "Si vous vous sentez menacé, vous pouvez emettre une puissante musique",
		},
		dash = {
			name = "Dash",
			dsc = "Foncez en avant. Si vous touchez un joueur, vous y serez collé pendant une courte période",
		},
		boost = {
			name = "Boost",
			dsc = "Obtiens l'un des 3 boosts actuellement actifs. Après utilisation, il sera remplacé par le suivant. La puissance de tous les boosts augmente avec chaque accumulation passive (limitée à [cap] stacks).\n\nBoost actuel : [boost]\n\nBoost de vitesse : [speed]\nBoost de défense contre les balles : [def]\nBoost de régénération : [regen]",
			buffs = {
				"Vitesse",
				"Défense contre les balles",
				"Regneration",
			},
		},
		eric = {
			name = "Eric?",
			dsc = "Vous demandez aux joueurs non armés s'ils sont Eric. Obtenez un stack de passif à chaque fois",
		},
		music_bar = {
			name = "Symphony No. 2",
			dsc = "Temps restant de cette abilité",
		},
		dash_bar = {
			name = "Detach time",
			dsc = "Temps restant avant de vous détacher",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Temps restant de cette abilité",
		},
	},

	upgrades = {
		parse_description = true,

		eric1 = {
			name = "Eric? I",
			info = "Réduit le cooldown du passif de [-eric_cd]",
		},
		eric2 = {
			name = "Eric? II",
			info = "Réduit le cooldown du passif de [-eric_cd]",
		},
		music1 = {
			name = "Symphonie No. 2 I",
			info = "Améliore votre attaque principale\n\t• Cooldown diminué de [-music_cd]\n\t• Portée augmentée de [+music_range]",
		},
		music2 = {
			name = "Symphonie No. 2 II",
			info = "Améliore votre attaque principale\n\t• Cooldown diminué de [-music_cd]\n\t• Portée augmentée de [+music_range]",
		},
		music3 = {
			name = "Symphonie No. 2 III",
			info = "Améliore votre attaque principale\n\t• Dégâts augmentés de [+music_damage]",
		},
		dash1 = {
			name = "Dash I",
			info = "Améliore votre capacité de dash\n\t• Cooldown diminué de [-dash_cd]\n\t• Vous restez [+detach_time] plus longtemps sur votre cible",
		},
		dash2 = {
			name = "Dash II",
			info = "Améliore votre capacité de dash\n\t• Cooldown diminué de [-dash_cd]\n\t• Vous restez [+detach_time] plus longtemps sur votre cible",
		},
		dash3 = {
			name = "Dash III",
			info = "Améliore votre capacité de dash\n\t• Lorsque vous êtes attaché à une cible, vous pouvez réutiliser cette capacité pour vous détacher\n\t• En vous détachant, vous pouvez vous attacher à un autre joueur\n\t• Vous ne pouvez pas vous attacher au même joueur plus d'une fois par utilisation de cette capacité",
		},
		boost1 = {
			name = "Boost I",
			info = "Améliore votre capacité de boost\n\t• Cooldown diminué de [-boost_cd]\n\t• Durée augmentée de [+boost_dur]",
		},
		boost2 = {
			name = "Boost II",
			info = "Améliore votre capacité de boost\n\t• Cooldown diminué de [-boost_cd]\n\t• Puissance augmentée de [+boost_power]",
		},
		boost3 = {
			name = "Boost III",
			info = "Améliore votre capacité de boost\n\t• Cooldown diminué de [-boost_cd]\n\t• Puissance augmentée de [+boost_power]",
		},
	}
}

wep.SCP096 = {
	skills = {
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {
			name = "Assaut Foudroyant",
			dsc = "Projetez-vous vers l'avant pendant la rage. Met instantanément fin à la rage. Vous ne consommerez pas de corps après la charge.",
		},
		regen = {
			name = "Regeneration",
			dsc = "Asseyez-vous et convertissez les stacks de régénération en santé",
		},
		special = {
			name = "Fin De La Chasse",
			dsc = "Arrêtez la rage. Obtenez des stacks de régénération pour chaque cible active",
		},
		passive = {
			name = "Passif",
			dsc = "Si quelqu'un vous regarde, vous entrez en rage. Vous tuez instantanément les joueurs qui vous ont mis en rage",
		},
	},

	upgrades = {
		parse_description = true,

		rage = {
			name = "Colère",
			info = "Recevoir [rage_dmg] en [rage_time] secondes d'un seul joueur vous mettra en rage",
		},
		heal1 = {
			name = "Devoration I",
			info = "Après avoir tué la cible, dévorez le corps de la cible et obtenez une protection contre les balles pendant la durée\n\t• Guérison par tick : [heal]\n\t• Ticks de guérison : [heal_ticks]\n\t• Protection contre les dégâts des balles : [-prot]",
		},
		heal2 = {
			name = "Devoration II",
			info = "Améliore votre capacité de dévoration\n\t• Guérison par tick : [heal]\n\t• Ticks de guérison : [heal_ticks]\n\t• Protection contre les dégâts des balles : [-prot]",
		},
		multi1 = {
			name = "Rage Infinie I",
			info = "Vous permet de tuer plusieurs cibles pendant une période limitée après le premier kill lors de la rage\n\t• Cibles maximum : [multi]\n\t• Limite de temps : [multi_time] secondes\n\t• Dégâts des balles après avoir tué la première cible augmentés de [+prot]",
		},
		multi2 = {
			name = "Rage Infinie II",
			info = "Vous permet de tuer encore plus de cibles pendant la rage\n\t• Cibles maximum : [multi]\n\t• Limite de temps : [multi_time] secondes\n\t• Dégâts des balles après avoir tué la première cible augmentés de [+prot]",
		},
		regen1 = {
			name = "Pleurs De Desespoir I",
			info = "Améliore votre capacité de régénération\n\t• Guérison augmentée de [+regen_mult]",
		},
		regen2 = {
			name = "Pleurs De Desespoir II",
			info = "Améliore votre capacité de régénération\n\t• Taux de gain des stacks augmenté de [/regen_stacks]",
		},
		regen3 = {
			name = "Pleurs de Desespoir III",
			info = "Améliore votre capacité de régénération\n\t• Guérison augmentée de [+regen_mult]\n\t• Taux de gain des stacks augmenté de [/regen_stacks]",
		},
		spec1 = {
			name = "Misericorde I",
			info = "Améliore votre capacité spéciale et ajoute un drain de santé mentale\n\t• Obtenez [+spec_mult] stacks supplémentaires\n\t• Drain de santé mentale : [sanity]",
		},
		spec2 = {
			name = "Misericorde II",
			info = "Améliore votre capacité spéciale\n\t• Obtenez [+spec_mult] stacks supplémentaires\n\t• Drain de santé mentale : [sanity]",
		},
	}
}

wep.SCP106 = {
	cancel = "Press [%s] to cancel",

	skills = {
		_overview = { "passive", "wither", "teleport", "trap" },
		withering = {
			name = "Deperissement",
			dsc = "Infligez un effet de dépérissement à la cible. Le dépérissement ralentit progressivement la cible au fil du temps. Attaquer une cible qui se trouve dans la Dimension de Poche la tue instantanément\n\nDurée de l'effet : [dur]\nRalentissement maximal : [slow]",
		},
		trap = {
			name = "Piège",
			dsc = "Placez un piège sur le mur. Lorsque le piège s'active, la cible est ralentie et vous pouvez réutiliser cette capacité pour vous téléporter instantanément à ce piège.",
		},
		teleport = {
			name = "Teleportation",
			dsc = "Utilisez pour placer un point de téléportation. Lorsque maintenu près d'un point de téléportation existant, vous pouvez sélectionner la destination de la téléportation. Relâchez pour vous téléporter au point sélectionné.",
		},
		passive = {
			name = "Collection De Dents",
			dsc = "Les balles ne peuvent pas vous tuer, mais elles peuvent vous assommer temporairement. De plus, vous pouvez passer à travers les portes. Toucher un joueur le téléporte dans la Dimension de Poche. Chaque joueur téléporté dans la Dimension de Poche vous accorde une dent. Les dents collectées renforcent votre capacité de dépérissement.",
		},
		teleport_cd = {
			name = "Teleportation",
			dsc = "Affiche le cooldown du point de téléportation",
		},
		passive_bar = {
			name = "Collection De Dents",
			dsc = "Lorsque cette barre atteint zéro, vous serez assommé.",
		},
		trap_bar = {
			name = "Piège",
			dsc = "Indique la durée d'activation du piège"
		}
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Collection De Dents I",
			info = "Améliore votre capacité passive\n\t• Augmente les dégâts nécessaires pour vous assommer de [+passive_dmg]\n\t• Réduit l'étourdissement de l'assommement de [-passive_cd]",
		},
		passive2 = {
			name = "Collection De Dents II",
			info = "Améliore votre capacité passive\n\t• Augmente les dégâts nécessaires pour vous assommer de [+passive_dmg]\n\t• Dégâts infligés aux joueurs augmentés de [+teleport_dmg]",
		},
		passive3 = {
			name = "Collection De Dents III",
			info = "Améliore votre capacité passive\n\t• Augmente les dégâts nécessaires pour vous assommer de [+passive_dmg]\n\t• Réduit l'étourdissement de l'assommement de [-passive_cd]\n\t• Dégâts infligés aux joueurs augmentés de [+teleport_dmg]",
		},
		withering1 = {
			name = "Deperissement I",
			info = "Améliore votre capacité de dépérissement\n\t• Cooldown diminué de [-attack_cd]\n\t• Durée de base de l'effet augmentée de [+withering_dur]",
		},
		withering2 = {
			name = "Deperissement II",
			info = "Améliore votre capacité de dépérissement\n\t• Cooldown diminué de [-attack_cd]\n\t• Ralentissement de base de l'effet augmenté de [+withering_slow]",
		},
		withering3 = {
			name = "Deperissement III",
			info = "Améliore votre capacité de dépérissement\n\t• Cooldown diminué de [-attack_cd]\n\t• Durée de base de l'effet augmentée de [+withering_dur]\n\t• Ralentissement de base de l'effet augmenté de [+withering_slow]",
		},
		tp1 = {
			name = "Teleportation I",
			info = "Améliore votre capacité de téléportation\n\t• Nombre maximal de points augmenté de [spot_max]\n\t• Cooldown des points diminué de [-spot_cd]",
		},
		tp2 = {
			name = "Teleportation II",
			info = "Améliore votre capacité de téléportation\n\t• Nombre maximal de points augmenté de [spot_max]\n\t• Cooldown de téléportation diminué de [-tp_cd]",
		},
		tp3 = {
			name = "Teleportation III",
			info = "Améliore votre capacité de téléportation\n\t• Nombre maximal de points augmenté de [spot_max]\n\t• Cooldown des points diminué de [-spot_cd]\n\t• Cooldown de téléportation diminué de [-tp_cd]",
		},
		trap1 = {
			name = "Piège I",
			info = "Améliore votre capacité de piège\n\t• Cooldown du piège diminué de [-trap_cd]\n\t• Durée de vie du piège augmentée de [+trap_life]",
		},
		trap2 = {
			name = "Piège II",
			info = "Améliore votre capacité de piège\n\t• Cooldown du piège diminué de [-trap_cd]\n\t• Durée de vie du piège augmentée de [+trap_life]",
		},
	}
}

local scp173_prot = {
	name = "Béton Armé",
	info = "Obtenez une réduction des dégâts de balle de [%prot]\n• Cette capacité se cumule avec d'autres compétences du même type",
}

wep.SCP173 = {
	restricted = "Restreint!",

	skills = {
		_overview = { "gas", "decoy", "stealth" },
		gas = {
			name = "Gaz",
			dsc = "Émettez un nuage de gaz irritant qui ralentira, obscurcira la vision et augmentera la fréquence de clignement des joueurs à proximité.",
		},
		decoy = {
			name = "Leurre",
			dsc = "Placez un leurre qui distraira et drainera la santé mentale des joueurs.",
		},
		stealth = {
			name = "Furtivité",
			dsc = "Entrez en mode furtif. En mode furtif, vous êtes invisible et vous pouvez passer à travers les portes. De plus, vous devenez invulnérable aux dégâts (les dégâts de zone comme les explosions peuvent encore vous atteindre), mais vous ne pouvez pas infliger de dégâts aux joueurs et vous ne pouvez pas interagir avec le monde.",
		},
		looked_at = {
			name = "Pas Bouger!",
			dsc = "S'illumine si une personne vous regarde.",
		},
		next_decoy = {
			name = "Stacks De Leurres",
			dsc = "Nombre de leurres disponibles",
		},
		stealth_bar = {
			name = "Furtivité",
			dsc = "Temps restant de furtivité.",
		},
	},

	upgrades = {
		parse_description = true,

		horror_a = {
			name = "Présence Écrasante",
			info = "Le rayon d'horreur est augmenté de [+horror_dist]",
		},
		horror_b = {
			name = "Présence Inquiétante",
			info = "Le drain de santé mentale d'horreur est augmenté de [+horror_sanity]",
		},
		attack_a = {
			name = "Tueur Rapide",
			info = "Le rayon de mise à mort est augmenté de [+snap_dist]",
		},
		attack_b = {
			name = "Tueur Agile",
			info = "Le rayon de déplacement est augmenté de [+move_dist]",
		},
		gas1 = {
			name = "Gaz I",
			info = "Le rayon de gaz est augmenté de [+gas_dist]",
		},
		gas2 = {
			name = "Gaz II",
			info = "Le rayon de gaz est augmenté de [+gas_dist] et le cooldown du gaz est réduit de [-gas_cd]",
		},
		decoy1 = {
			name = "Leurre I",
			info = "Le cooldown du leurre est réduit de [-decoy_cd]",
		},
		decoy2 = {
			name = "Leurre II",
			info = "Le cooldown du leurre est réduit à 0,5s\n• Le cooldown original s'applique aux stacks de leurres\n• La limite des leurres est augmentée de [decoy_max].",
		},
		stealth1 = {
			name = "Furtivité I",
			info = "Le cooldown de la furtivité est réduit de [-stealth_cd]",
		},
		stealth2 = {
			name = "Furtivité II",
			info = "Le cooldown de la furtivité est réduit de [-stealth_cd]\n• La durée de la furtivité est augmentée de [+stealth_dur]",
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
            name = "Boule de Feu",
            dsc = "Coût en carburant : [cost]\nTirez une boule de feu qui avancera jusqu'à ce qu'elle entre en collision avec quelque chose",
        },
        trap = {
            name = "Piège",
            dsc = "Coût en carburant : [cost]\nPlacez un piège qui enflammera les joueurs qui le touchent",
        },
        ignite = {
            name = "Rage Intérieure",
            dsc = "Coût en carburant : [cost] pour chaque feu généré\nLibérez des vagues de flammes autour de vous. La portée de cette capacité est illimitée et chaque anneau de feu supplémentaire consomme plus de carburant. Cette capacité ne peut pas être interrompue",
        },
        passive = {
            name = "Passif",
            dsc = "Vous enflammez tous ceux que vous touchez. Enflammer un joueur ajoute du carburant",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Torche Vivante I",
            info = "Améliore votre capacité passive\n\t• Rayon de feu augmenté de [+fire_radius]\n\t• Gain de carburant augmenté de [+fire_fuel]",
        },
        passive2 = {
            name = "Torche Vivante II",
            info = "Améliore votre capacité passive\n\t• Rayon de feu augmenté de [+fire_radius]\n\t• Dégâts de feu augmentés de [+fire_dmg]",
        },
        passive3 = {
            name = "Torche Vivante III",
            info = "Améliore votre capacité passive\n\t• Gain de carburant augmenté de [+fire_fuel]\n\t• Dégâts de feu augmentés de [+fire_dmg]",
        },
        passive_heal1 = {
            name = "Flamme de Vie I",
            info = "Vous vous soignez de [%fire_heal] des dégâts causés par le feu de l'une de vos capacités",
        },
        passive_heal2 = {
            name = "Flamme de Vie II",
            info = "Vous vous soignez de [%fire_heal] des dégâts causés par le feu de l'une de vos capacités",
        },
        fireball1 = {
            name = "Balle Aux Prisonniers I",
            info = "Améliore votre capacité de boule de feu\n\t• Cooldown diminué de [-fireball_cd]\n\t• Vitesse augmentée de [+fireball_speed]\n\t• Coût en carburant diminué de [-fireball_cost]",
        },
        fireball2 = {
            name = "Balle Aux Prisonniers II",
            info = "Améliore votre capacité de boule de feu\n\t• Dégâts augmentés de [+fireball_dmg]\n\t• Taille augmentée de [+fireball_size]\n\t• Coût en carburant diminué de [-fireball_cost]",
        },
        fireball3 = {
            name = "Balle Aux Prisonniers III",
            info = "Améliore votre capacité de boule de feu\n\t• Cooldown diminué de [-fireball_cd]\n\t• Dégâts augmentés de [+fireball_dmg]\n\t• Vitesse augmentée de [+fireball_speed]",
        },
        trap1 = {
            name = "C'est un Piège ! I",
            info = "Améliore votre capacité de piège\n\t• Pièges supplémentaires : [trap_max]\n\t• Coût en carburant diminué de [-trap_cost]\n\t• Durée de vie augmentée de [+trap_time]",
        },
        trap2 = {
            name = "C'est un Piège ! II",
            info = "Améliore votre capacité de piège\n\t• Pièges supplémentaires : [trap_max]\n\t• Dégâts augmentés de [+trap_dmg]\n\t• Durée de vie augmentée de [+trap_time]",
        },
        trap3 = {
            name = "C'est un Piège ! III",
            info = "Améliore votre capacité de piège\n\t• Coût en carburant diminué de [-trap_cost]\n\t• Dégâts augmentés de [+trap_dmg]\n\t• Durée de vie augmentée de [+trap_time]",
        },
        ignite1 = {
            name = "Rage Intérieure I",
            info = "Améliore votre capacité de rage intérieure\n\t• Taux de vague augmenté de [/ignite_rate]\n\t• Le premier anneau génère [ignite_flames] flammes supplémentaires",
        },
        ignite2 = {
            name = "Rage Intérieure II",
            info = "Améliore votre capacité de rage intérieure\n\t• Coût en carburant diminué de [-ignite_cost]\n\t• Le premier anneau génère [ignite_flames] flammes supplémentaires",
        },
        fuel = {
            name = "Livraison de Carburant !",
            info = "Obtenez instantanément [fuel] carburant",
        }
	}
}

wep.SCP682 = {
	skills = {
		_overview = { "primary", "secondary", "charge", "shield" },
		primary = {
            name = "Attaque Basique",
            dsc = "Attaquez avec votre patte directement devant vous en infligeant des dégâts mineurs",
        },
        secondary = {
            name = "Morsure",
            dsc = "Maintenez la touche pour préparer une attaque puissante qui infligera des dégâts importants dans une zone en forme de cône devant vous",
        },
        charge = {
            name = "Charge",
            dsc = "Après un court délai, chargez vers l'avant et devenez inarrêtable. À pleine vitesse, tuez tout le monde sur votre chemin et gagnez la capacité de franchir la plupart des portes. Cette compétence doit être débloquée dans l'arbre de compétences",
        },
        shield = {
            name = "Bouclier",
            dsc = "Bouclier qui absorbera tous les dégâts non directs/de chute. Cette capacité est affectée par les améliorations achetées dans votre arbre de compétences",
        },
        shield_bar = {
            name = "Bouclier",
            dsc = "Quantité actuelle de bouclier qui absorbera tous les dégâts non directs/de chute",
        },
	},

	upgrades = {
		parse_description = true,

		shield_a = {
            name = "Bouclier Renforcé",
            info = "Améliore la puissance de votre bouclier\n\t• Puissance du bouclier : [%shield]\n\t• Temps de recharge : [%shield_cd]",
        },
        shield_b = {
            name = "Bouclier de Régénération",
            info = "Modifie la puissance de votre bouclier\n\t• Puissance du bouclier : [%shield]\n\t• Temps de recharge : [%shield_cd]\n\t• Le temps de recharge commence après que le bouclier soit complètement épuisé\n\t• Lorsque le bouclier est en recharge, régénérez [shield_regen] PV/s",
        },
        shield_c = {
            name = "Bouclier de Sacrifice",
            info = "Modifie la puissance de votre bouclier\n\t• Temps de recharge : [%shield_cd]\n\t• Le temps de recharge commence après que le bouclier soit complètement épuisé\n\t• La puissance de votre bouclier est égale à votre PV maximum\n\t• Lorsqu'il est brisé, vous perdez [shield_hp] PV maximum",
        },
        shield_d = {
            name = "Bouclier Réfléchissant",
            info = "Modifie la puissance de votre bouclier\n\t• Puissance du bouclier : [%shield]\n\t• Temps de recharge : [%shield_cd]\n\t• Le temps de recharge commence après que le bouclier soit complètement épuisé\n\t• Votre bouclier bloque seulement [%shield_pct] des dégâts\n\t• [%reflect_pct] des dégâts bloqués sont réfléchis vers l'attaquant",
        },

        shield_1 = {
            name = "Bouclier I",
            info = "Ajoute des effets à votre bouclier. Une fois complètement brisé, recevez un bonus de vitesse de déplacement de [+shield_speed_pow] pour [shield_speed_dur] secondes",
        },
        shield_2 = {
            name = "Bouclier II",
            info = "Ajoute des effets à votre bouclier. Une fois complètement brisé, recevez un bonus de vitesse de déplacement de [+shield_speed_pow] pour [shield_speed_dur] secondes. De plus, chaque point de dégât reçu réduit le temps de recharge du bouclier de [shield_cdr] secondes",
        },

        attack_1 = {
            name = "Coup Renforcé",
            info = "Améliore votre attaque basique\n\t• Temps de recharge réduit de [-prim_cd]\n\t• Dégâts augmentés de [prim_dmg]",
        },
        attack_2 = {
            name = "Morsure Renforcée",
            info = "Améliore votre morsure\n\t• Portée augmentée de [+sec_range]\n\t• Vitesse de déplacement pendant la préparation augmentée de [+sec_speed]",
        },
        attack_3 = {
            name = "Coup Impitoyable",
            info = "Améliore à la fois l'attaque basique et la morsure\n\t• Les deux attaques infligent des saignements\n\t• L'attaque de morsure inflige une fracture lorsqu'elle est complètement chargée",
        },

        charge_1 = {
            name = "Charge",
            info = "Débloque la capacité de charge",
        },
        charge_2 = {
            name = "Charge Impitoyable",
            info = "Renforce la capacité de charge\n\t• Temps de recharge réduit de [-charge_cd]\n\t• La durée de l'étourdissement et du ralentissement est réduite de [-charge_stun]",
        },
	}
}

wep.SCP8602 = {
	skills = {
		_overview = { "passive", "primary", "defense", "charge" },
		primary = {
            name = "Attaque",
            dsc = "Effectuer une attaque de base",
        },
        defense = {
            name = "Posture Défensive",
            dsc = "Maintenez pour activer. En maintenant, vous gagnez de la protection au fil du temps mais vous êtes également ralenti. Relâchez pour foncer en avant et infliger des dégâts égaux à [dmg_ratio] des dégâts atténués. Cette capacité n'a pas de limite de durée",
        },
        charge = {
            name = "Charge",
            dsc = "Gagnez de la vitesse au fil du temps et infligez des dégâts au premier joueur devant vous. Si le joueur attaqué est suffisamment proche d'un mur, épinglez-le contre ce mur pour augmenter les dégâts",
        },
        passive = {
            name = "Passif",
            dsc = "Vous voyez les joueurs à l'intérieur de votre forêt et pendant un certain temps après qu'ils en soient sortis. Les joueurs à l'intérieur de la forêt perdent de la santé mentale, s'ils n'ont plus de santé mentale, ils perdent de la santé à la place. Soignez-vous avec la santé mentale/santé des joueurs à l'intérieur de la forêt. Cette guérison peut dépasser votre santé maximale",
        },
        overheal_bar = {
            name = "Soin Excédentaire",
            dsc = "Santé excédentaire soignée",
        },
        defense_bar = {
            name = "Défense",
            dsc = "Puissance de protection actuelle",
        },
        charge_bar = {
            name = "Charge",
            dsc = "Temps de charge restant",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Forêt Dense I",
            info = "Améliore votre capacité passive\n\t• Soin excédentaire maximal augmenté de [+overheal]\n\t• Taux passif augmenté de [/passive_rate]\n\t• Temps de détection des joueurs augmenté de [+detect_time]",
        },
        passive2 = {
            name = "Forêt Dense II",
            info = "Améliore votre capacité passive\n\t• Soin excédentaire maximal augmenté de [+overheal]\n\t• Taux passif augmenté de [/passive_rate]\n\t• Temps de détection des joueurs augmenté de [+detect_time]",
        },
        primary = {
            name = "Simple mais Dangereux",
            info = "Améliore votre attaque de base\n\t• Temps de recharge réduit de [-primary_cd]\n\t• Dégâts augmentés de [+primary_dmg]",
        },
        def1a = {
            name = "Armure Rapide",
            info = "Modifie votre capacité de posture défensive\n\t• Temps d'activation réduit de [-def_time]\n\t• Temps de recharge augmenté de [+def_cooldown]",
        },
        def1b = {
            name = "Armure Rapide",
            info = "Modifie votre capacité de posture défensive\n\t• Temps d'activation augmenté de [+def_time]\n\t• Temps de recharge réduit de [-def_cooldown]",
        },
        def2a = {
            name = "Longue Charge",
            info = "Modifie votre capacité de posture défensive\n\t• Distance maximale de la charge augmentée de [+def_range]\n\t• Largeur de la charge réduite de [-def_width]",
        },
        def2b = {
            name = "Charge Maladroite",
            info = "Modifie votre capacité de posture défensive\n\t• Distance maximale de la charge réduite de [-def_range]\n\t• Largeur de la charge augmentée de [+def_width]",
        },
        def3a = {
            name = "Armure Lourde",
            info = "Modifie votre capacité de posture défensive\n\t• Protection maximale augmentée de [+def_prot]\n\t• Ralentissement maximal augmenté de [+def_slow]",
        },
        def3b = {
            name = "Armure Légère",
            info = "Modifie votre capacité de posture défensive\n\t• Protection maximale réduite de [-def_prot]\n\t• Ralentissement maximal réduit de [-def_slow]",
        },
        def4 = {
            name = "Armure Efficace",
            info = "Améliore votre capacité de posture défensive\n\t• Multiplicateur de conversion des dégâts augmenté de [+def_mult]",
        },
        charge1 = {
            name = "Charge I",
            info = "Améliore votre capacité de charge\n\t• Temps de recharge réduit de [-charge_cd]\n\t• Durée augmentée de [+charge_time]\n\t• Dégâts de base augmentés de [+charge_dmg]",
        },
        charge2 = {
            name = "Charge II",
            info = "Améliore votre capacité de charge\n\t• Portée augmentée de [+charge_range]\n\t• Durée augmentée de [+charge_time]\n\t• Dégâts d'épingle augmentés de [+charge_pin_dmg]",
        },
        charge3 = {
            name = "Charge III",
            info = "Améliore votre capacité de charge\n\t• Vitesse augmentée de [+charge_speed]\n\t• Dégâts de base augmentés de [+charge_dmg]\n\t• Épingler un joueur contre un mur lui brise les os",
        },
	}
}

wep.SCP939 = {
	skills = {
		_overview = { "passive", "primary", "trail", "special" },
		primary = {
            name = "Attaque",
            dsc = "Mordez tout le monde dans une zone en forme de cône devant vous",
        },
        trail = {
            name = "ANM-C227",
            dsc = "Maintenez la touche enfoncée pour laisser une traînée ANM-C227 derrière vous",
        },
        special = {
            name = "Détection",
            dsc = "Commencez à détecter les joueurs autour de vous",
        },
        passive = {
            name = "Passif",
            dsc = "Vous ne pouvez pas voir les joueurs, mais vous pouvez voir les ondes sonores. Vous avez une aura ANM-C227 autour de vous",
        },
        special_bar = {
            name = "Détection",
            dsc = "Temps de détection restant",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Aura I",
            info = "Améliore votre capacité passive\n\t• Rayon de l'aura augmenté de [+aura_radius]\n\t• Dégâts de l'aura augmentés de [aura_damage]",
        },
        passive2 = {
            name = "Aura II",
            info = "Améliore votre capacité passive\n\t• Rayon de l'aura augmenté de [+aura_radius]\n\t• Dégâts de l'aura augmentés de [aura_damage]",
        },
        passive3 = {
            name = "Aura III",
            info = "Améliore votre capacité passive\n\t• Rayon de l'aura augmenté de [+aura_radius]\n\t• Dégâts de l'aura augmentés de [aura_damage]",
        },
        attack1 = {
            name = "Morsure I",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Dégâts augmentés de [+attack_dmg]",
        },
        attack2 = {
            name = "Morsure II",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Portée augmentée de [+attack_range]",
        },
        attack3 = {
            name = "Morsure III",
            info = "Améliore votre capacité d'attaque\n\t• Dégâts augmentés de [+attack_dmg]\n\t• Portée augmentée de [+attack_range]\n\t• Vos attaques ont une chance d'appliquer un saignement",
        },
        trail1 = {
            name = "Amnésie I",
            info = "Améliore votre capacité ANM-C227\n\t• Rayon augmenté de [+trail_radius]\n\t• Taux de génération de stacks augmenté de [/trail_rate]",
        },
        trail2 = {
            name = "Amnésie II",
            info = "Améliore votre capacité ANM-C227\n\t• Dégâts augmentés de [trail_dmg]\n\t• Nombre maximum de stacks augmenté de [+trail_stacks]",
        },
        trail3a = {
            name = "Amnésie III A",
            info = "Améliore votre capacité ANM-C227\n\t• Durée de vie de la traînée augmentée de [+trail_life]\n\t• Rayon augmenté de [+trail_radius]",
        },
        trail3b = {
            name = "Amnésie III B",
            info = "Améliore votre capacité ANM-C227\n\t• Nombre maximum de stacks augmenté de [+trail_stacks]",
        },
        trail3c = {
            name = "Amnésie III C",
            info = "Améliore votre capacité ANM-C227\n\t• Taux de génération de stacks augmenté de [/trail_rate]",
        },
        special1 = {
            name = "Écholocalisation I",
            info = "Améliore votre capacité spéciale\n\t• Temps de recharge réduit de [-special_cd]\n\t• Rayon augmenté de [+special_radius]",
        },
        special2 = {
            name = "Écholocalisation II",
            info = "Améliore votre capacité spéciale\n\t• Temps de recharge réduit de [-special_cd]\n\t• Durée augmentée de [+special_times]",
        },
	}
}

wep.SCP966 = {
	skills = {
		_overview = { "passive", "attack", "channeling", "mark" },
		attack = {
            name = "Attaque basique",
            dsc = "Effectuez une attaque basique. Vous ne pouvez attaquer que les joueurs ayant au moins 10 stacks de fatigue. Les joueurs attaqués perdent quelques stacks de fatigue. Les effets de cette attaque sont affectés par l'arbre de compétences",
        },
        channeling = {
            name = "Canalisation",
            dsc = "Canaliser la capacité sélectionnée dans l'arbre de compétences",
        },
        mark = {
            name = "Marque de la mort",
            dsc = "Marquez un joueur. Les joueurs marqués transféreront les stacks de fatigue des autres joueurs proches vers eux-mêmes",
        },
        passive = {
            name = "Fatigue",
            dsc = "De temps en temps, vous appliquez des stacks de fatigue aux joueurs proches. Vous gagnez également une stack passive pour chaque stack de fatigue appliquée",
        },
        channeling_bar = {
            name = "Canalisation",
            dsc = "Temps restant de la capacité de canalisation",
        },
        mark_bar = {
            name = "Marque de la mort",
            dsc = "Temps restant de la marque sur le joueur marqué",
        },
	},

	upgrades = {
		parse_description = true,

		passive1 = {
            name = "Fatigue I",
            info = "Améliore votre capacité passive\n\t• Taux passif augmenté de [/passive_rate]",
        },
        passive2 = {
            name = "Fatigue II",
            info = "Améliore votre capacité passive\n\t• Taux passif augmenté de [/passive_rate]\n\t• Portée passive augmentée de [+passive_radius]",
        },
        basic1 = {
            name = "Griffes Aiguisées I",
            info = "Améliore votre attaque basique en augmentant les dégâts de [%basic_dmg] pour chaque [basic_stacks] stacks passives. Le gain de stacks passives débloque également :\n\t• [bleed1_thr] stacks : Applique une hémorragie si la cible ne saigne pas\n\t• [drop1_thr] stacks : La perte de stacks de fatigue de la cible est réduite à [%drop1]\n\t• [slow_thr] stacks : La cible est ralentie de [-slow_power] pendant [slow_dur] secondes",
        },
        basic2 = {
            name = "Griffes Aiguisées II",
            info = "Améliore votre attaque basique en augmentant les dégâts de [%basic_dmg] pour chaque [basic_stacks] stacks passives. Le gain de stacks passives débloque également :\n\t• [bleed2_thr] stacks : Applique une hémorragie à l'impact\n\t• [drop2_thr] stacks : La perte de stacks de fatigue de la cible est réduite à [%drop2]\n\t• [hb_thr] stacks : Applique une hémorragie sévère à l'impact au lieu d'une hémorragie",
        },
        heal = {
            name = "Drain de Sang",
            info = "Vous soignez de [%heal_rate] par stack passive par stack de fatigue de la cible à chaque coup",
        },
        channeling_a = {
            name = "Fatigue Infinie",
            info = "Débloque une capacité de canalisation qui vous permet de vous concentrer sur une seule cible\n\t• Passif désactivé pendant la canalisation\n\t• Temps de recharge [channeling_cd] secondes\n\t• Durée maximale [channeling_time] secondes\n\t• La cible gagne un stack de fatigue toutes les [channeling_rate] secondes",
        },
        channeling_b = {
            name = "Drain d'Énergie",
            info = "Débloque une capacité de canalisation qui vous permet de drainer des stacks de fatigue des joueurs proches\n\t• Passif désactivé pendant la canalisation\n\t• Temps de recharge [channeling_cd] secondes\n\t• Durée maximale [channeling_time] secondes\n\t• Chaque [channeling_rate] seconde, transfère 1 stack de fatigue de tous les joueurs proches aux stacks passives",
        },
        channeling = {
            name = "Canalisation Renforcée",
            info = "Améliore votre capacité de canalisation\n\t• Portée de la canalisation augmentée de [+channeling_range_mul]\n\t• Durée de la canalisation augmentée de [+channeling_time_mul]",
        },
        mark1 = {
            name = "Marque Mortelle I",
            info = "Améliore la capacité de marque :\n\t• Taux de transfert de stacks augmenté de [/mark_rate]",
        },
        mark2 = {
            name = "Marque Mortelle II",
            info = "Améliore la capacité de marque :\n\t• Taux de transfert de stacks augmenté de [/mark_rate]\n\t• Portée de transfert de stacks augmentée de [+mark_range]",
        },
	}
}

wep.SCP24273 = {
	skills = {
		_overview = { "change", "primary", "secondary", "special" },
		primary = {
            name = "Dash / Camouflage",
            dsc = "\nJuge :\nFoncez vers l'avant en infligeant des dégâts à tous ceux sur votre chemin\n\nProcureur :\nActivez le camouflage. Pendant le camouflage, vous êtes moins visible. Utiliser des compétences, bouger ou recevoir des dégâts l'interrompt",
        },
        secondary = {
            name = "Examen / Surveillance",
            dsc = "\nJuge :\nCommencez à vous concentrer sur le joueur ciblé pendant un certain temps. Lorsque le sort est entièrement lancé, ralentissez la cible et infligez des dégâts. Si la ligne de vue est perdue, la compétence est interrompue et vous êtes ralenti à la place\n\nProcureur :\nQuittez votre corps et regardez depuis la perspective d'un joueur aléatoire à proximité. Votre passif fonctionne également depuis la perspective de ce joueur",
        },
        special = {
            name = "Jugement / Fantôme",
            dsc = "\nJuge :\nRestez sur place et forcez tous les joueurs à proximité à marcher vers vous. Lorsque c'est terminé, les joueurs à proximité immédiate reçoivent des dégâts et sont repoussés\n\nProcureur :\nEntrez en forme de fantôme. En forme de fantôme, vous êtes immunisé contre tout dommage (sauf les explosions et les dommages directs)",
        },
        change = {
            name = "Juge / Procureur",
            dsc = "\nChangez entre le mode Juge et le mode Procureur\n\nJuge :\nLes dégâts que vous infligez sont augmentés par les preuves accumulées sur la cible. Attaquer la cible réduit le niveau de preuves. Attaquer des joueurs avec des preuves complètes les tue instantanément\n\nProcureur :\nVous êtes ralenti et vous recevez une protection contre les dommages par balles. Regarder les joueurs recueille des preuves contre eux",
        },
        camo_bar = {
            name = "Camouflage",
            dsc = "Temps de camouflage restant",
        },
        spectate_bar = {
            name = "Surveillance",
            dsc = "Temps de surveillance restant",
        },
        drain_bar = {
            name = "Examen",
            dsc = "Temps d'examen restant",
        },
        ghost_bar = {
            name = "Fantôme",
            dsc = "Temps de fantôme restant",
        },
        special_bar = {
            name = "Jugement",
            dsc = "Temps de jugement restant",
        },
	},

	upgrades = {
		parse_description = true,

		j_passive1 = {
            name = "Juge strict I",
            info = "Améliore votre compétence passive de juge\n\t• Les preuves augmentent les dégâts jusqu'à [%j_mult] supplémentaire\n\t• Perte de preuves lors d'une attaque réduite à [%j_loss]",
        },
        j_passive2 = {
            name = "Juge strict II",
            info = "Améliore votre compétence passive de juge\n\t• Les preuves augmentent les dégâts jusqu'à [%j_mult] supplémentaire\n\t• Perte de preuves lors d'une attaque réduite à [%j_loss]",
        },
        p_passive1 = {
            name = "Procureur I",
            info = "Améliore votre compétence passive de procureur\n\t• Protection contre les balles augmentée à [%p_prot]\n\t• Ralentissement augmenté à [%p_slow]\n\t• Taux de collecte de preuves augmenté à [%p_rate] par seconde",
        },
        p_passive2 = {
            name = "Procureur II",
            info = "Améliore votre compétence passive de procureur\n\t• Protection contre les balles augmentée à [%p_prot]\n\t• Ralentissement augmenté à [%p_slow]\n\t• Taux de collecte de preuves augmenté à [%p_rate] par seconde",
        },
        dash1 = {
            name = "Dash I",
            info = "Améliore votre compétence de dash\n\t• Temps de recharge réduit de [-dash_cd]\n\t• Dégâts augmentés de [+dash_dmg]",
        },
        dash2 = {
            name = "Dash II",
            info = "Améliore votre compétence de dash\n\t• Temps de recharge réduit de [-dash_cd]\n\t• Dégâts augmentés de [+dash_dmg]",
        },
        camo1 = {
            name = "Camouflage I",
            info = "Améliore votre compétence de camouflage\n\t• Temps de recharge réduit de [-camo_cd]\n\t• Durée augmentée de [+camo_dur]\n\t• Vous pouvez vous déplacer de [camo_limit] unités sans interrompre cette compétence",
        },
        camo2 = {
            name = "Camouflage II",
            info = "Améliore votre compétence de camouflage\n\t• Temps de recharge réduit de [-camo_cd]\n\t• Durée augmentée de [+camo_dur]\n\t• Vous pouvez vous déplacer de [camo_limit] unités sans interrompre cette compétence",
        },
        drain1 = {
            name = "Examen I",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-drain_cd]\n\t• Durée réduite de [-drain_dur]",
        },
        drain2 = {
            name = "Examen II",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-drain_cd]\n\t• Durée réduite de [-drain_dur]",
        },
        spect1 = {
            name = "Surveillance I",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-spect_cd]\n\t• Durée augmentée de [+spect_dur]\n\t• Protection contre les balles augmentée à [%spect_prot]",
        },
        spect2 = {
            name = "Surveillance II",
            info = "Améliore votre compétence passive de procureur\n\t• Temps de recharge réduit de [-spect_cd]\n\t• Durée augmentée de [+spect_dur]\n\t• Protection contre les balles augmentée à [%spect_prot]",
        },
        combo = {
            name = "Cour Suprême",
            info = "Améliore vos compétences de jugement et de fantôme\n\t• Protection de jugement augmentée à [%special_prot]\n\t• Durée de fantôme augmentée de [+ghost_dur]",
        },
        spec = {
            name = "Jugement",
            info = "Améliore votre compétence de jugement\n\t• Temps de recharge réduit de [-special_cd]\n\t• Durée augmentée de [+special_dur]\n\t• Protection augmentée à [%special_prot]",
        },
        ghost1 = {
            name = "Fantôme I",
            info = "Améliore votre compétence de fantôme\n\t• Temps de recharge réduit de [-ghost_cd]\n\t• Durée augmentée de [+ghost_dur]\n\t• Soin augmenté à [ghost_hel] par 1 preuve consommée",
        },
        ghost2 = {
            name = "Fantôme II",
            info = "Améliore votre compétence de fantôme\n\t• Temps de recharge réduit de [-ghost_cd]\n\t• Durée augmentée de [+ghost_dur]\n\t• Soin augmenté à [ghost_hel] par 1 preuve consommée",
        },
        change1 = {
            name = "Échange I",
            info = "Temps de recharge de changement réduit de [-change_cd]",
        },
        change2 = {
            name = "Échange II",
            info = "Temps de recharge de changement réduit de [-change_cd]. De plus, changer de mode n'interrompt plus la compétence de camouflage",
        },
	}
}

wep.SCP3199 = {
	skills = {
		_overview = { "passive", "primary", "special", "egg" },
		eggs_max = "Vous avez déjà le nombre maximum d'œufs !",

        primary = {
            name = "Attaque",
            dsc = "Effectuez une attaque de base. Toucher une cible active (ou rafraîchit) la frénésie, applique l'effet de blessures profondes et accorde un stack passif et un stack de frénésie.\nLes attaques infligent des dégâts réduits aux cibles avec des blessures profondes. Manquer l'attaque arrête la frénésie. Toucher uniquement la cible avec des blessures profondes arrête la frénésie et applique une pénalité de tokens",
        },
        special = {
            name = "Attaque de l'Au-delà",
            dsc = "S'active après [tokens] attaques réussies consécutives. Utilisez pour terminer instantanément la frénésie et endommager tous les joueurs qui ont des blessures profondes. Les joueurs affectés sont également ralentis",
        },
        egg = {
            name = "Œufs",
            dsc = "Après avoir tué un joueur, vous pouvez pondre un œuf. Lorsque vous recevez des dégâts létaux, vous réapparaîtrez à un œuf aléatoire. La réapparition consomme l'œuf. De plus, chaque œuf accorde [prot] de protection contre les balles (plafonné à [cap])\n\nŒufs actuels : [eggs] / [max]",
        },
        passive = {
            name = "Passif",
            dsc = "Pendant la frénésie, voyez l'emplacement des joueurs à proximité sans blessures profondes. Gagner des tokens de frénésie accorde également des tokens passifs. Si votre attaque touche uniquement un joueur avec des blessures profondes, vous perdrez [penalty] de stacks. Les tokens passifs améliorent vos autres compétences\n\nRégénérer [heal] PV par seconde en frénésie\nBonus de dégâts d'attaque : [dmg]\nBonus de vitesse de frénésie : [speed]\nRalenti supplémentaire de l'attaque spéciale : [slow]\nLes attaques spéciales infligent [bleed] niveau(x) de saignement",
        },
        frenzy_bar = {
            name = "Frénésie",
            dsc = "Temps de frénésie restant",
        },
        egg_bar = {
            name = "Œuf",
            dsc = "Temps de pondaison restant",
        },
	},

	upgrades = {
		parse_description = true,

		frenzy1 = {
            name = "Frénésie I",
            info = "Améliore votre capacité de frénésie\n\t• Durée augmentée de [+frenzy_duration]\n\t• Nombre maximum de stacks augmentés de [frenzy_max]",
        },
        frenzy2 = {
            name = "Frénésie II",
            info = "Améliore votre capacité de frénésie\n\t• Nombre maximum de stacks augmentés de [frenzy_max]\n\t• Vitesse de frénésie augmentée de [%frenzy_speed_stacks] par stack passif",
        },
        frenzy3 = {
            name = "Frénésie III",
            info = "Améliore votre capacité de frénésie\n\t• Durée augmentée de [+frenzy_duration]\n\t• Vitesse de frénésie augmentée de [%frenzy_speed_stacks] par stack passif",
        },
        attack1 = {
            name = "Griffes Aiguisées I",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Dégâts augmentés de [+attack_dmg]",
        },
        attack2 = {
            name = "Griffes Aiguisées II",
            info = "Améliore votre capacité d'attaque\n\t• Temps de recharge réduit de [-attack_cd]\n\t• Dégâts augmentés de [%attack_dmg_stacks] par stack passif",
        },
        attack3 = {
            name = "Griffes Aiguisées III",
            info = "Améliore votre capacité d'attaque\n\t• Dégâts augmentés de [+attack_dmg]\n\t• Dégâts augmentés de [%attack_dmg_stacks] par stack passif",
        },
        special1 = {
            name = "Attaque de l'Au-delà I",
            info = "Améliore votre capacité spéciale\n\t• Dégâts augmentés de [+special_dmg]\n\t• Ralenti augmenté de [%special_slow] par stack passif\n\t• Durée du ralenti augmentée de [+special_slow_duration]",
        },
        special2 = {
            name = "Attaque de l'Au-delà II",
            info = "Améliore votre capacité spéciale\n\t• Dégâts augmentés de [+special_dmg]\n\t• Ralenti augmenté de [%special_slow] par stack passif\n\t• Durée du ralenti augmentée de [+special_slow_duration]",
        },
        passive = {
            name = "Sens du Sang",
            info = "Rayon de détection passif augmenté de [+passive_radius]",
        },
        egg = {
            name = "Œuf de Pâques",
            info = "Pond instantanément un nouvel œuf. Cette capacité peut dépasser la limite des œufs",
        },
	}
}
