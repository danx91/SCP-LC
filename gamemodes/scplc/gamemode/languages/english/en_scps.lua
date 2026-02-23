local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS
--[[-------------------------------------------------------------------------
SCPs
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "Outside buff",
		info = "Receive additional bullet protection and enable healing and regeneration when on surface.\n\t• Additional bullet defense: [%def]\n\t• Additional flat bullet defense: [flat] dmg\n\t• Once on surface heal for [buff_hp] HP in a short time\n\t• When out of combat, quickly recover [%regen_min] - [%regen_max] (time scaled) of received bullet damage\n\t• Dealing damage heals you for [%heal_min] - [%heal_max] (time scaled) of dealt damage\n\t• Returning back to the facility voids all active healings",
		parse_description = true,
	}
}

lang.CommonSkills = {
	c_button_overload = {
		name = "Overload",
		dsc = "Allows you to overload most of locked doors. Overloaded doors open (or close) for a short period of time"
	},
	c_dmg_mod = {
		name = "Damage protection",
		dsc = "Current protection: [mod]\nCurrent flat protection: [flat]\n\nThis is the protection against received bullet damage. It takes into account only modificators of time scaling and outside buff. SCP specific modificators are not included!\n\nOutside buff: [buff]",
		dmg = "DMG",
		not_bought = "Not bought",
		not_surface = "Disabled inside the facility",
		buff = "\n   • Current recovery: %s of received bullet damage\n   • Current heal: %s of dealt damage",
	},
}

wep.SCP023 = {
	skills = {
		_overview = { "passive", "drain", "clone", "hunt" },
		drain = {
			name = "Stamina Drain",
			dsc = "Start draining stamina from nearby players. If all players leave area, ability is instantly put on cooldown",
		},
		clone = {
			name = "Clone",
			dsc = "Place clone that will mimic work of your passive (including upgrades). Clone will wander around and chase nearby players",
		},
		hunt = {
			name = "Hunt",
			dsc = "Instantly kill one of your preys or people near them and teleport to their body",
		},
		passive = {
			name = "Passive",
			dsc = "Colliding with players ignites them. You also don't collide with doors",
		},
		drain_bar = {
			name = "Drain",
			dsc = "Remaining time of drain ability",
		},
	},

	upgrades = {
		parse_description = true,

		passive = {
			name = "Incandescent Ember",
			info = "Upgrades your passive ability increasing burning damage by [+burn_power]",
		},
		invis1 = {
			name = "Invisible Flame I",
			info = "Enhances your passive ability\n\t• You fade away for distant players\n\t• Players who can't see you, won't be added to hunt preys\n\t• This upgrade also applies to your clone\n\t• You become fully invisible [invis_range] units away",
		},
		invis2 = {
			name = "Invisible Flame II",
			info = "Upgrades your invisibility\n\t• You become fully invisible [invis_range] units away",
		},
		prot1 = {
			name = "Undying Fire I",
			info = "Enhances your passive ability by providing [-prot] bullet damage protection",
		},
		prot2 = {
			name = "Undying Fire II",
			info = "Upgrades your protection against bullets to [-prot]",
		},
		drain1 = {
			name = "Power Drain I",
			info = "Upgrades your drain ability\n\t• Duration increased by [+drain_dur]\n\t• Maximum distance increased by [+drain_dist]",
		},
		drain2 = {
			name = "Power Drain II",
			info = "Upgrades your drain ability\n\t• Drain rate increased by [/drain_rate]\n\t• Heal for [%drain_heal] drained stamina",
		},
		drain3 = {
			name = "Power Drain III",
			info = "Upgrades your drain ability\n\t• Duration increased by [+drain_dur]\n\t• Maximum distance increased by [+drain_dist]",
		},
		drain4 = {
			name = "Power Drain IV",
			info = "Upgrades your drain ability\n\t• Drain rate increased by [/drain_rate]\n\t• Heal for [%drain_heal] drained stamina",
		},
		hunt1 = {
			name = "Endless Flame I",
			info = "Empowers your hunt ability\n\t• Cooldown reduced by [-hunt_cd]",
		},
		hunt2 = {
			name = "Endless Flame II",
			info = "Empowers your hunt ability\n\t• Cooldown reduced by [-hunt_cd]\n\t• Random prey search radius increased by [+hunt_range]",
		},
	}
}

wep.SCP049 = {
	zombies = {
		normal = "Standard Zombie",
		assassin = "Assassin Zombie",
		boomer = "Exploding Zombie",
		heavy = "Spiting Zombie",
	},
	zombies_desc = {
		normal = "A standard zombie\n\t• Has both light and heavy attacks\n\t• Decent choice with balanced statistics",
		assassin = "An assassin zombie\n\t• Has light attack and rapid attack ability\n\t• The fastest one with decent damage, but has the lowest health",
		boomer = "An exploding heavy zombie\n\t• Has heavy attack and explode ability\n\t• Low movement speed, but has high health and highest damage",
		heavy = "A spiting heavy zombie\n\t• Has heavy attack and shot ability\n\t• The slowest zombie type with low damage, but has the most health",
	},
	skills = {
		_overview = { "passive", "choke", "surgery", "boost" },
		surgery_failed = "Surgery failed!",

		choke = {
			name = "Doctor's Touch",
			dsc = "Choke player to death. This ability can be interrupted by receiving enough damage",
		},
		surgery = {
			name = "Surgery",
			dsc = "Perform surgery on the body turning it into SCP-049-2 instance. Receiving damage interrupts surgery",
		},
		boost = {
			name = "Rise!",
			dsc = "Provides boost to you and all nearby SCP-049-2 instances",
		},
		passive = {
			name = "Passive",
			dsc = "Zombies near you gain bullet damage protection",
		},
		choke_bar = {
			name = "Doctor's Touch",
			dsc = "When full, target dies",
		},
		surgery_bar = {
			name = "Surgery",
			dsc = "Remaining time of the surgery",
		},
		boost_bar = {
			name = "Rise!",
			dsc = "Remaining time of the boost",
		},
	},

	upgrades = {
		parse_description = true,

		choke1 = {
			name = "Doctor's Touch I",
			info = "Upgrades your choke ability\n\t• Cooldown reduced by [-choke_cd]\n\t• Damage threshold increased by [+choke_dmg]",
		},
		choke2 = {
			name = "Doctor's Touch II",
			info = "Upgrades your choke ability\n\t• Choke speed increased by [+choke_rate]\n\t• Slow after choke reduced by [-choke_slow]",
		},
		choke3 = {
			name = "Doctor's Touch III",
			info = "Upgrades your choke ability\n\t• Cooldown reduced by [-choke_cd]\n\t• Damage threshold increased by [+choke_dmg]\n\t• Choke speed increased by [+choke_rate]",
		},
		buff1 = {
			name = "Rise I",
			info = "Upgrades your boost ability\n\t• Cooldown reduced by [-buff_cd]\n\t• Boost duration increased by [+buff_dur]",
		},
		buff2 = {
			name = "Rise II",
			info = "Upgrades your boost ability\n\t• Boost radius increased by [+buff_radius]\n\t• Boost power increased by [+buff_power]",
		},
		surgery_cd1 = {
			name = "Surgical Precision I",
			info = "Reduces surgery time by [surgery_time]s\n\t• This upgrade is stackable",
		},
		surgery_cd2 = {
			name = "Surgical Precision II",
			info = "Reduces surgery time by [surgery_time]s\n\t• This upgrade is stackable",
		},
		surgery_heal = {
			name = "Transplantation",
			info = "Upgrades your surgery ability\n\t• After surgery you heal for [surgery_heal] HP\n\t• After surgery all zombies nearby heal for [surgery_zombie_heal] HP",
		},
		surgery_dmg = {
			name = "Unstoppable Surgery",
			info = "Receiving damage no longer stops surgery",
		},
		surgery_prot = {
			name = "Steady Hand",
			info = "During surgery gain [-surgery_prot] bullet protection",
		},
		zombie_prot = {
			name = "The Nurse",
			info = "Gain bullet damage protection for each SCP-049-2 nearby\n\t• Protection for each zombie nearby: [%zombie_prot]\n\t• Maximum protection: [%zombie_prot_max]",
		},
		zombie_lifesteal = {
			name = "Transfusion I",
			info = "Zombies gain [%zombie_ls] life steal on basic attacks",
		},
		stacks_hp = {
			name = "Steroids Injection",
			info = "When creating zombie, their health is increased by [%stacks_hp] for each prior surgery",
		},
		stacks_dmg = {
			name = "Radical Therapy",
			info = "When creating zombie, their damage is increased by [%stacks_dmg] for each prior surgery",
		},
		zombie_heal = {
			name = "Transfusion II",
			info = "You heal for [%zombie_heal] of any damage dealt by zombies nearby",
		}
	}
}

wep.SCP0492 = {
	skills = {
		prot = {
			name = "Protection",
			dsc = "You gain some damage protection when near SCP-049",
		},
		boost = {
			name = "Boost",
			dsc = "Indicates whenever SCP-049 boost is active on you",
		},
		light_attack = {
			name = "Light Attack",
			dsc = "Perform a light attack",
		},
		heavy_attack = {
			name = "Heavy Attack",
			dsc = "Perform a heavy attack",
		},
		rapid = {
			name = "Rapid Attack",
			dsc = "Perform a rapid attack",
		},
		shot = {
			name = "Shot",
			dsc = "Shot damaging projectile",
		},
		explode = {
			name = "Explode",
			dsc = "Enables when you have 50 HP or less. Gain ability to become unkillable and gain speed boost. After short time, you will explode dealing damage in small radius",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Remaining boost time",
		},
		explode_bar = {
			name = "Explode",
			dsc = "Remaining time to an explosion",
		},
	},

	upgrades = {
		parse_description = true,

		primary1 = {
			name = "Primary Attack I",
			info = "Upgrades your primary attack\n\t• Cooldown reduced by [-primary_cd]",
		},
		primary2 = {
			name = "Primary Attack II",
			info = "Upgrades your primary attack\n\t• Cooldown reduced by [-primary_cd]\n\t• Damage increased by [+primary_dmg]",
		},
		secondary1 = {
			name = "Secondary Attack I",
			info = "Upgrades your secondary attack\n\t• Damage increased by [+secondary_dmg]",
		},
		secondary2 = {
			name = "Secondary Attack II",
			info = "Upgrades your secondary attack\n\t• Damage increased by [+secondary_dmg]\n\t• Cooldown reduced by [-secondary_cd]",
		},
		overload = {
			name = "Overload",
			info = "Grants additional [overloads] button overloads",
		},
		buff = {
			name = "Rise!",
			info = "Empowers your protection and SCP-049 boost\n\t• Protection power: [%+prot_power]\n\t• Boost power: [++buff_power]",
		},
	}
}

wep.SCP058 = {
	skills = {
		_overview = { "primary_attack", "shot", "explosion" },
		primary_attack = {
			name = "Primary attack",
			dsc = "Attack with your sting directly in front of you. Applies poison if an appropriate upgrade is bought",
		},
		shot = {
			name = "Shot",
			dsc = "Shots projectile in your aim direction. Projectile will move in ballistic curve. Shot related upgrades affect cooldown, speed, size and effects of this ability",
		},
		explosion = {
			name = "Explode",
			dsc = "Release burst of corrupted blood dealing massive damage to targets nearby",
		},
		shot_stacks = {
			name = "Shot stacks",
			dsc = "Show stored amount of shots. Various shot related upgrades affect maximum amount and cooldown time",
		},
	},

	upgrades = {
		parse_description = true,

		attack1 = {
			name = "Poisonous Sting I",
			info = "Adds poison to primary attacks"
		},
		attack2 = {
			name = "Poisonous Sting II",
			info = "Buffs attack damage, poison damage and decreases cooldown\n\t• Adds [prim_dmg] damage to attacks\n\t• Attack poison deals [pp_dmg] damage\n\t• Cooldown is reduced by [prim_cd]s"
		},
		attack3 = {
			name = "Poisonous Sting III",
			info = "Buffs poison damage and decreases cooldown\n\t• If target is not poisoned, instantly apply 2 stacks of poison\n\t• Attack poison deals [pp_dmg] damage\n\t• Cooldown is reduced by [prim_cd]s"
		},
		shot = {
			name = "Corrupted Blood",
			info = "Adds poison to shot attacks"
		},
		shot11 = {
			name = "Surge I",
			info = "Increases damage and projectile size but also increases cooldown and slows down projectile\n\t• Projectile damage increased by [+shot_damage]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]\n\t• Cooldown increased by [shot_cd]s"
		},
		shot12 = {
			name = "Surge II",
			info = "Increases damage and projectile size but also increases cooldown and slows down projectile\n\t• Projectile damage increased by [+shot_damage]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]\n\t• Cooldown increased by [shot_cd]s"
		},
		shot21 = {
			name = "Bloody Mist I",
			info = "Shot leaves mist on impact, hurting and poisoning everyone who touches it.\n\t• Direct and splash damage is removed\n\t• Cloud deals [cloud_damage] damage on contact\n\t• Poison inflicted by cloud deals [sp_dmg] damage\n\t• Shot stacks limited to [stacks]\n\t• Cooldown increased by [shot_cd]s\n\t• Stacks gain rate: [/+regen_rate]"
		},
		shot22 = {
			name = "Bloody Mist II",
			info = "Buffs mist left by shots.\n\t• Cloud deals [cloud_damage] damage on contact\n\t• Poison inflicted by cloud deals [sp_dmg] damage\n\t• Stacks gain rate: [/+regen_rate]"
		},
		shot31 = {
			name = "Multishot I",
			info = "Allows you to shot at rapid speed while holding attack button\n\t• Unlock ability of rapid shooting\n\t• Direct and splash damage is removed\n\t• Shot stacks limited to [stacks]\n\t• Stacks gain rate: [/+regen_rate]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]"
		},
		shot32 = {
			name = "Multishot II",
			info = "Increases maximum stacks and buffs shot speed\n\t• Shot stacks limited to [stacks]\n\t• Stacks gain rate: [/+regen_rate]\n\t• Projectile size change: [++shot_size]\n\t• Projectile speed change: [++shot_speed]"
		},
		exp1 = {
			name = "Aortal Burst",
			info = "Unlocks explode ability that deals massive damage to nearby targets. This ability activates when your health decreases below each multiple of 1000 HP for the first time. If bought when below 1000 HP, first received damage activates this ability. Previous thresholds can't be reached (even with healing)"
		},
		exp2 = {
			name = "Toxic Blast",
			info = "Buffs your explode ability\n\t• Applies 2 stacks of poison\n\t• Radius increased by [+explosion_radius]"
		},
	}
}

wep.SCP066 = {
	skills = {
		_overview = { "eric", "music", "dash", "boost" },
		not_threatened = "You don't feel threatened enough to attack!",

		music = {
			name = "Symphony No. 2",
			dsc = "If you feel threatened, you can emit loud music",
		},
		dash = {
			name = "Dash",
			dsc = "Dash forward. If you hit player, you will stick to them for a short time. Use again to detach",
		},
		boost = {
			name = "Boost",
			dsc = "Get one of 3 boosts that is currently active. After use it will be replaced by the next one. Power of all boosts increases with each passive stack (capped at [cap] stacks).\n\nCurrent boost: [boost]\n\nSpeed boost: [speed]\nBullet defense boost: [def]\nRegeneration boost: [regen]",
			buffs = {
				"Speed",
				"Bullet defense",
				"Regeneration",
			},
		},
		eric = {
			name = "Eric?",
			dsc = "You ask unarmed players if they are Eric. Get one passive stack each time",
		},
		music_bar = {
			name = "Symphony No. 2",
			dsc = "Remaining time of this ability",
		},
		dash_bar = {
			name = "Detach time",
			dsc = "Remaining time of being attached to this target",
		},
		boost_bar = {
			name = "Boost",
			dsc = "Remaining time of this ability",
		},
	},

	upgrades = {
		parse_description = true,

		eric1 = {
			name = "Eric? I",
			info = "Reduces passive cooldown by [-eric_cd]",
		},
		eric2 = {
			name = "Eric? II",
			info = "Reduces passive cooldown by [-eric_cd]",
		},
		music1 = {
			name = "Symphony No. 2 I",
			info = "Upgrades your primary attack\n\t• Cooldown decreased by [-music_cd]\n\t• Range increased by [+music_range]",
		},
		music2 = {
			name = "Symphony No. 2 II",
			info = "Upgrades your primary attack\n\t• Cooldown decreased by [-music_cd]\n\t• Range increased by [+music_range]",
		},
		music3 = {
			name = "Symphony No. 2 III",
			info = "Upgrades your primary attack\n\t• Damage increased by [+music_damage]",
		},
		dash1 = {
			name = "Dash I",
			info = "Upgrades your dash ability\n\t• Cooldown decreased by [-dash_cd]\n\t• You can stay [+detach_time] longer on your target",
		},
		dash2 = {
			name = "Dash II",
			info = "Upgrades your dash ability\n\t• Cooldown decreased by [-dash_cd]\n\t• You can stay [+detach_time] longer on your target",
		},
		dash3 = {
			name = "Dash III",
			info = "Upgrades your dash ability\n\t• While usning this ability again, you will jump off instead of detaching\n\t• While jumping off, you can attach to another player\n\t• You can't stick to the same player you just jumped off",
		},
		boost1 = {
			name = "Boost I",
			info = "Upgrades your boost ability\n\t• Cooldown decreased by [-boost_cd]\n\t• Duration increased by [+boost_dur]",
		},
		boost2 = {
			name = "Boost II",
			info = "Upgrades your boost ability\n\t• Cooldown decreased by [-boost_cd]\n\t• Power increased by [+boost_power]",
		},
		boost3 = {
			name = "Boost III",
			info = "Upgrades your boost ability\n\t• Duration increased by [+boost_dur]\n\t• Power increased by [+boost_power]",
		},
	}
}

wep.SCP096 = {
	skills = {
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {
			name = "Lunge",
			dsc = "Lunge forward while in rage. Instantly ends rage. You won't eat body after lunge",
		},
		regen = {
			name = "Regeneration",
			dsc = "Sit in place and convert regeneration stacks to health",
		},
		special = {
			name = "Hunt's Over",
			dsc = "Stop rage. Get regeneration stacks for each active target",
		},
		passive = {
			name = "Passive",
			dsc = "If someone looks at you, you become enraged. You instantly kill players who enraged you",
		},
	},

	upgrades = {
		parse_description = true,

		rage = {
			name = "Anger",
			info = "Receiving [rage_dmg] damage in [rage_time] seconds from single player will enrage you",
		},
		heal1 = {
			name = "Devour I",
			info = "After killing target, devour target's body and gain bullet protection for duration\n\t• Heal per tick: [heal]\n\t• Heal ticks: [heal_ticks]\n\t• Bullet damage protection: [-prot]",
		},
		heal2 = {
			name = "Devour II",
			info = "Upgrades your devour\n\t• Heal per tick: [heal]\n\t• Heal ticks: [heal_ticks]\n\t• Bullet damage protection: [-prot]",
		},
		multi1 = {
			name = "Endless Rage I",
			info = "Allows you to kill multiple targets while in rage for a limited time after first kill\n\t• Maximum targets: [multi]\n\t• Time limit: [multi_time] seconds\n\t• Received bullet damage after killing first target increased by [+prot]",
		},
		multi2 = {
			name = "Endless Rage II",
			info = "Allows you to kill even more targets while in rage\n\t• Maximum targets: [multi]\n\t• Time limit: [multi_time] seconds\n\t• Received bullet damage after killing first target increased by [+prot]",
		},
		regen1 = {
			name = "Cry of Despair I",
			info = "Upgrades your regeneration ability\n\t• Heal increased by [+regen_mult]",
		},
		regen2 = {
			name = "Cry of Despair II",
			info = "Upgrades your regeneration ability\n\t• Stacks gain rate increased by [/regen_stacks]",
		},
		regen3 = {
			name = "Cry of Despair III",
			info = "Upgrades your regeneration ability\n\t• Heal increased by [+regen_mult]\n\t• Stacks gain rate increased by [/regen_stacks]",
		},
		spec1 = {
			name = "Mercy I",
			info = "Upgrades your special ability and adds sanity drain\n\t• Gain [+spec_mult] more stacks\n\t• Sanity drain: [sanity]",
		},
		spec2 = {
			name = "Mercy II",
			info = "Upgrades your special ability\n\t• Gain [+spec_mult] more stacks\n\t• Sanity drain: [sanity]",
		},
	}
}

wep.SCP106 = {
	cancel = "Press [%s] to cancel",

	skills = {
		_overview = { "passive", "withering", "teleport", "trap" },
		withering = {
			name = "Withering",
			dsc = "Inflict withering effect on target. Withering gradually slow target over time. Attacking target who is inside Pocket Dimension instantly kills them\n\nEffect duration [dur]\nMaximum slow: [slow]",
		},
		trap = {
			name = "Trap",
			dsc = "Place trap on the wall. When trap activates, target is slowed and you can use this ability again to instantly teleport to that trap",
		},
		teleport = {
			name = "Teleport",
			dsc = "Use to place teleport spot. Holding this ability near existing teleport spot, allows you to select teleport destination, release button to teleport to selected spot",
		},
		passive = {
			name = "Teeth Collection",
			dsc = "Bullets can't kill you, but they can temporarily knock you down, also you can pass through doors. Touching player, teleports them to Pocket Dimension. Each player teleported to Pocket Dimension grants one tooth. Collected teeth empower your withering ability",
		},
		teleport_cd = {
			name = "Teleport",
			dsc = "Shows cooldown of teleport spot",
		},
		passive_bar = {
			name = "Teeth Collection",
			dsc = "When this bar reaches zero, you will be knocked down",
		},
		trap_bar = {
			name = "Trap",
			dsc = "Shows how long trap will remain active"
		}
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Teeth Collection I",
			info = "Upgrades your passive ability\n\t• Increases damage required to knock you down by [+passive_dmg]\n\t• Reduces knock down stun by [-passive_cd]",
		},
		passive2 = {
			name = "Teeth Collection II",
			info = "Upgrades your passive ability\n\t• Increases damage required to knock you down by [+passive_dmg]\n\t• Damage dealt to players increased by [+teleport_dmg]",
		},
		passive3 = {
			name = "Teeth Collection III",
			info = "Upgrades your passive ability\n\t• Increases damage required to knock you down by [+passive_dmg]\n\t• Reduces knock down stun by [-passive_cd]\n\t• Damage dealt to players increased by [+teleport_dmg]",
		},
		withering1 = {
			name = "Withering I",
			info = "Upgrades your withering ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Effect base duration increased by [+withering_dur]",
		},
		withering2 = {
			name = "Withering II",
			info = "Upgrades your withering ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Effect base slow increased by [+withering_slow]",
		},
		withering3 = {
			name = "Withering III",
			info = "Upgrades your withering ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Effect base duration increased by [+withering_dur]\n\t• Effect base slow increased by [+withering_slow]",
		},
		tp1 = {
			name = "Teleport I",
			info = "Upgrades your teleport ability\n\t• Maximum spots increased by [spot_max]\n\t• Spot cooldown decreased by [-spot_cd]",
		},
		tp2 = {
			name = "Teleport II",
			info = "Upgrades your teleport ability\n\t• Maximum spots increased by [spot_max]\n\t• Teleport cooldown decreased by [-tp_cd]",
		},
		tp3 = {
			name = "Teleport III",
			info = "Upgrades your teleport ability\n\t• Maximum spots increased by [spot_max]\n\t• Spot cooldown decreased by [-spot_cd]\n\t• Teleport cooldown decreased by [-tp_cd]",
		},
		trap1 = {
			name = "Trap I",
			info = "Upgrades your trap ability\n\t• Trap cooldown decreased by [-trap_cd]\n\t• Trap life time increased by [+trap_life]",
		},
		trap2 = {
			name = "Trap II",
			info = "Upgrades your trap ability\n\t• Trap cooldown decreased by [-trap_cd]\n\t• Trap life time increased by [+trap_life]",
		},
	}
}

local scp173_prot = {
	name = "Reinforced Concrete",
	info = "• Gain [%prot] bullet damage reduction\n• This ability stacks with other skills of the same type",
}

wep.SCP173 = {
	restricted = "Restricted!",

	skills = {
		_overview = { "gas", "decoy", "stealth" },
		gas = {
			name = "Gas",
			dsc = "Emit cloud of irritating gas that will slow down, obscure vision and increase blinking rate of players nearby",
		},
		decoy = {
			name = "Decoy",
			dsc = "Place decoy that will distract and drain sanity of players",
		},
		stealth = {
			name = "Stealth",
			dsc = "Enter stealth mode. In stealth mode you are invisible and you can pass through doors. Additionally, you become invulnerable to damage (AOE damage like explosions can still hit you), but you also can't inflict any damage to players and you can't interact with the world",
		},
		looked_at = {
			name = "Freeze!",
			dsc = "Shows if someone is looking at you",
		},
		next_decoy = {
			name = "Decoy stacks",
			dsc = "Number of available decoys",
		},
		stealth_bar = {
			name = "Stealth",
			dsc = "Remaining time of stealth ability",
		},
	},

	upgrades = {
		parse_description = true,

		horror_a = {
			name = "Overwhelming Presence",
			info = "Horror radius is increased by [+horror_dist]",
		},
		horror_b = {
			name = "Unnerving Presence",
			info = "Horror sanity drain is increased by [+horror_sanity]",
		},
		attack_a = {
			name = "Swift Killer",
			info = "Kill radius is increased by [+snap_dist]",
		},
		attack_b = {
			name = "Agile Killer",
			info = "Move radius is increased by [+move_dist]",
		},
		gas1 = {
			name = "Gas I",
			info = "Gas radius is increased by [+gas_dist]",
		},
		gas2 = {
			name = "Gas II",
			info = "Gas radius is increased by [+gas_dist] and gas cooldown is reduced by [-gas_cd]",
		},
		decoy1 = {
			name = "Decoy I",
			info = "Decoy cooldown is reduced by [-decoy_cd]",
		},
		decoy2 = {
			name = "Decoy II",
			info = "• Decoy cooldown is reduced to 0.5s\n• Original cooldown applies to decoy stacks instead\n• Decoys limit is increased by [decoy_max].",
		},
		stealth1 = {
			name = "Stealth I",
			info = "Stealth cooldown is reduced by [-stealth_cd]",
		},
		stealth2 = {
			name = "Stealth I",
			info = "• Stealth cooldown is reduced by [-stealth_cd]\n• Stealth duration is increased by [+stealth_dur]",
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
			name = "Fireball",
			dsc = "Fuel cost: [cost]\nFire fireball that will travel forward until it collides with something",
		},
		trap = {
			name = "Trap",
			dsc = "Fuel cost: [cost]\nPlace trap that will ignite players that touch it",
		},
		ignite = {
			name = "Inner Rage",
			dsc = "Fuel cost: [cost] for each spawned fire\nRelease waves of flames near you. Range of this ability is unlimited and each subsequent ring of fire consumes more fuel. This ability cannot be interrupted",
		},
		passive = {
			name = "Passive",
			dsc = "You ignite everyone you touch. Igniting player adds fuel",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Living Torch I",
			info = "Upgrades your passive ability\n\t• Fire radius increased by [+fire_radius]\n\t• Fuel gain increased by [+fire_fuel]",
		},
		passive2 = {
			name = "Living Torch II",
			info = "Upgrades your passive ability\n\t• Fire radius increased by [+fire_radius]\n\t• Fire damage increased by [+fire_dmg]",
		},
		passive3 = {
			name = "Living Torch III",
			info = "Upgrades your passive ability\n\t• Fuel gain increased by [+fire_fuel]\n\t• Fire damage increased by [+fire_dmg]",
		},
		passive_heal1 = {
			name = "Flame of Life I",
			info = "You heal for [%fire_heal] damage caused by fire from any of your abilities",
		},
		passive_heal2 = {
			name = "Flame of Life II",
			info = "You heal for [%fire_heal] damage caused by fire from any of your abilities",
		},
		fireball1 = {
			name = "Dodgeball I",
			info = "Upgrades your fireball ability\n\t• Cooldown decreased by [-fireball_cd]\n\t• Speed increased by [+fireball_speed]\n\t• Fuel cost decreased by [-fireball_cost]",
		},
		fireball2 = {
			name = "Dodgeball II",
			info = "Upgrades your fireball ability\n\t• Damage increased by [+fireball_dmg]\n\t• Size increased by [+fireball_size]\n\t• Fuel cost decreased by [-fireball_cost]",
		},
		fireball3 = {
			name = "Dodgeball III",
			info = "Upgrades your fireball ability\n\t• Cooldown decreased by [-fireball_cd]\n\t• Damage increased by [+fireball_dmg]\n\t• Speed increased by [+fireball_speed]",
		},
		trap1 = {
			name = "It's a Trap! I",
			info = "Upgrades your trap ability\n\t• Additional traps: [trap_max]\n\t• Fuel cost decreased by [-trap_cost]\n\t• Lifetime increased by [+trap_time]",
		},
		trap2 = {
			name = "It's a Trap! II",
			info = "Upgrades your trap ability\n\t• Additional traps: [trap_max]\n\t• Damage increased by [+trap_dmg]\n\t• Lifetime increased by [+trap_time]",
		},
		trap3 = {
			name = "It's a Trap! III",
			info = "Upgrades your trap ability\n\t• Fuel cost decreased by [-trap_cost]\n\t• Damage increased by [+trap_dmg]\n\t• Lifetime increased by [+trap_time]",
		},
		ignite1 = {
			name = "Inner Rage I",
			info = "Upgrades your inner rage ability\n\t• Wave rate increased by [/ignite_rate]\n\t• First ring spawns [ignite_flames] additional flames",
		},
		ignite2 = {
			name = "Inner Rage II",
			info = "Upgrades your inner rage ability\n\t• Fuel cost decreased by [-ignite_cost]\n\t• First ring spawns [ignite_flames] additional flames",
		},
		fuel = {
			name = "Fuel Delivery!",
			info = "Instantly gain [fuel] fuel",
		}
	}
}

wep.SCP682 = {
	skills = {
		_overview = { "primary", "secondary", "charge", "shield" },
		primary = {
			name = "Basic attack",
			dsc = "Attack with your hand directly in front of you inflicting minor damage",
		},
		secondary = {
			name = "Bite",
			dsc = "Hold key to prepare a strong attack that will inflict major damage in a cone shaped area in front of you",
		},
		charge = {
			name = "Charge",
			dsc = "After a short delay charge forward and become unstoppable. When on full speed, kill everyone in your path and gain ability to breach most of doors. This skill has to be unlocked in upgrade tree",
		},
		shield = {
			name = "Shield",
			dsc = "Shield that will absorb any non-direct/fall damage. This ability is affected by bought upgrades on your skill tree",
		},
		shield_bar = {
			name = "Shield",
			dsc = "Current amount of shield that will absorb any non-direct/fall damage",
		},
	},

	upgrades = {
		parse_description = true,

		shield_a = {
			name = "Empowered Shield",
			info = "Upgrades power of your shield\n\t• Shield power: [%shield]\n\t• Cooldown: [%shield_cd]",
		},
		shield_b = {
			name = "Regeneration Shield",
			info = "Alters power of your shield\n\t• Shield power: [%shield]\n\t• Cooldown: [%shield_cd]\n\t• Cooldown starts after shield is fully depleted\n\t• When shield is on cooldown, regenerate [shield_regen] HP/s",
		},
		shield_c = {
			name = "Shield of Sacrifice",
			info = "Alters power of your shield\n\t• Cooldown: [%shield_cd]\n\t• Cooldown starts after shield is fully depleted\n\t• Power of your shield is equal to your maximum HP\n\t• When broken, you lose [shield_hp] maximum HP",
		},
		shield_d = {
			name = "Reflective Shield",
			info = "Alters power of your shield\n\t• Shield power: [%shield]\n\t• Cooldown: [%shield_cd]\n\t• Cooldown starts after shield is fully depleted\n\t• Your shield blocks only [%shield_pct] of damage\n\t• [%reflect_pct] of blocked damage is reflected to attacker",
		},

		shield_1 = {
			name = "Shield I",
			info = "Adds effects to your shield. Once fully broken, receive additional [+shield_speed_pow] movement speed for [shield_speed_dur] seconds",
		},
		shield_2 = {
			name = "Shield II",
			info = "Adds effects to your shield. Once fully broken, receive additional [+shield_speed_pow] movement speed for [shield_speed_dur] seconds. Additionally, every 1 point of received damage shortens shield cooldown by [shield_cdr] seconds",
		},

		attack_1 = {
			name = "Empowered Swing",
			info = "Upgrades your basic attack\n\t• Cooldown reduced by [-prim_cd]\n\t• Damage increased by [prim_dmg]",
		},
		attack_2 = {
			name = "Empowered Bite",
			info = "Upgrades your bite\n\t• Range increased by [+sec_range]\n\t• Movement speed while preparing is increased by [+sec_speed]",
		},
		attack_3 = {
			name = "Merciless Strike",
			info = "Upgrades both basic attack and bite\n\t• Both attacks inflict bleeding\n\t• Bite attack inflicts fracture when fully charged",
		},

		charge_1 = {
			name = "Charge",
			info = "Unlocks charge ability",
		},
		charge_2 = {
			name = "Ruthless Charge",
			info = "Empowers charge ability\n\t• Cooldown is reduced by [-charge_cd]\n\t• Stun and slow duration are reduced by [-charge_stun]",
		},
	}
}

wep.SCP8602 = {
	skills = {
		_overview = { "passive", "primary", "defense", "charge" },
		primary = {
			name = "Attack",
			dsc = "Perform basic attack",
		},
		defense = {
			name = "Defensive Stance",
			dsc = "Hold to activate. While holding, gain protection over time but you are also slowed. Release to dash forward and deal damage equal to [dmg_ratio] of mitigated damage. This ability doesn't have duration limit",
		},
		charge = {
			name = "Charge",
			dsc = "Gain speed over time and deal damage to first player in front of you. If attacked player is close enough to wall, pin them to that and perform strong attack",
		},
		passive = {
			name = "Passive",
			dsc = "You see player inside your forest and for some time after they exit it. Players inside forest lose sanity, if they are out of sanity, they lose health instead. Heal for taken sanity/heath from players inside forest. This healing can exceed your maximum health",
		},
		overheal_bar = {
			name = "Overheal",
			dsc = "Overhealed health",
		},
		defense_bar = {
			name = "Defense",
			dsc = "Current protection power",
		},
		charge_bar = {
			name = "Charge",
			dsc = "Remaining charge time",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Dense Woods I",
			info = "Upgrades your passive ability\n\t• Maximum overheal increased by [+overheal]\n\t• Passive rate increased by [/passive_rate]\n\t• Player detect time increased by [+detect_time]",
		},
		passive2 = {
			name = "Dense Woods II",
			info = "Upgrades your passive ability\n\t• Maximum overheal increased by [+overheal]\n\t• Passive rate increased by [/passive_rate]\n\t• Player detect time increased by [+detect_time]",
		},
		primary = {
			name = "Simple but Dangerous",
			info = "Upgrades your basic attack\n\t• Cooldown decreased by [-primary_cd]\n\t• Damage increased by [+primary_dmg]",
		},
		def1a = {
			name = "Swift Armor",
			info = "Alters your defensive stance ability\n\t• Activation time reduced by [-def_time]\n\t• Cooldown increased by [+def_cooldown]",
		},
		def1b = {
			name = "Rapid Armor",
			info = "Alters your defensive stance ability\n\t• Activation time increased by [+def_time]\n\t• Cooldown decreased by [-def_cooldown]",
		},
		def2a = {
			name = "Long Dash",
			info = "Alters your defensive stance ability\n\t• Dash maximum distance increased by [+def_range]\n\t• Dash width reduced by [-def_width]",
		},
		def2b = {
			name = "Clumsy Dash",
			info = "Alters your defensive stance ability\n\t• Dash maximum distance reduced by [-def_range]\n\t• Dash width increased by [+def_width]",
		},
		def3a = {
			name = "Heavy Armor",
			info = "Alters your defensive stance ability\n\t• Maximum protection increased by [+def_prot]\n\t• Maximum slow increased by [+def_slow]",
		},
		def3b = {
			name = "Light Armor",
			info = "Alters your defensive stance ability\n\t• Maximum protection decreased by [-def_prot]\n\t• Maximum slow reduced by [-def_slow]",
		},
		def4 = {
			name = "Effective Armor",
			info = "Upgrades your defensive stance ability\n\t• Damage conversion multiplier increased by [+def_mult]",
		},
		charge1 = {
			name = "Charge I",
			info = "Upgrades your charge ability\n\t• Cooldown decreased by [-charge_cd]\n\t• Duration increased by [+charge_time]\n\t• Basic damage increased by [+charge_dmg]",
		},
		charge2 = {
			name = "Charge II",
			info = "Upgrades your charge ability\n\t• Range increased by [+charge_range]\n\t• Duration increased by [+charge_time]\n\t• Pin damage increased by [+charge_pin_dmg]",
		},
		charge3 = {
			name = "Charge III",
			info = "Upgrades your charge ability\n\t• Speed increased by [+charge_speed]\n\t• Above 80% of charge progress, any hit counts as strong attack\n\t• Pinning player to wall breaks their bones",
		},
	}
}

wep.SCP939 = {
	skills = {
		_overview = { "passive", "primary", "trail", "special" },
		primary = {
			name = "Attack",
			dsc = "Bite everyone in cone shaped area on front of you",
		},
		trail = {
			name = "ANM-C227",
			dsc = "Hold key to leave ANM-C227 trail behind you",
		},
		special = {
			name = "Detection",
			dsc = "Start detecting players around you",
		},
		passive = {
			name = "Passive",
			dsc = "You can't see players, but you can see sound waves. You have ANM-C227 aura around you",
		},
		special_bar = {
			name = "Detection",
			dsc = "Remaining detection time",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Aura I",
			info = "Upgrades your passive ability\n\t• Aura radius increased by [+aura_radius]\n\t• Aura damage increased by [aura_damage]",
		},
		passive2 = {
			name = "Aura II",
			info = "Upgrades your passive ability\n\t• Aura radius increased by [+aura_radius]\n\t• Aura damage increased by [aura_damage]",
		},
		passive3 = {
			name = "Aura III",
			info = "Upgrades your passive ability\n\t• Aura radius increased by [+aura_radius]\n\t• Aura damage increased by [aura_damage]",
		},
		attack1 = {
			name = "Bite I",
			info = "Upgrades your attack ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Damage increased by [+attack_dmg]",
		},
		attack2 = {
			name = "Bite II",
			info = "Upgrades your attack ability\n\t• Cooldown decreased by [-attack_cd]\n\t• Range increased by [+attack_range]",
		},
		attack3 = {
			name = "Bite III",
			info = "Upgrades your attack ability\n\t• Damage increased by [+attack_dmg]\n\t• Range increased by [+attack_range]\n\t• Your attacks have chance to apply bleeding",
		},
		trail1 = {
			name = "Amnesia I",
			info = "Upgrades your ANM-C227 ability\n\t• Radius increased by [+trail_radius]\n\t• Stacks generation rate increased by [/trail_rate]",
		},
		trail2 = {
			name = "Amnesia II",
			info = "Upgrades your ANM-C227 ability\n\t• Damage increased by [trail_dmg]\n\t• Maximum stacks increased by [+trail_stacks]",
		},
		trail3a = {
			name = "Amnesia III A",
			info = "Upgrades your ANM-C227 ability\n\t• Life time of trail increased by [+trail_life]\n\t• Radius increased by [+trail_radius]",
		},
		trail3b = {
			name = "Amnesia III B",
			info = "Upgrades your ANM-C227 ability\n\t• Maximum stacks increased by [+trail_stacks]",
		},
		trail3c = {
			name = "Amnesia III C",
			info = "Upgrades your ANM-C227 ability\n\t• Stacks generation rate increased by [/trail_rate]",
		},
		special1 = {
			name = "Echolocation I",
			info = "Upgrades your special ability\n\t• Cooldown decreased by [-special_cd]\n\t• Radius increased by [+special_radius]",
		},
		special2 = {
			name = "Echolocation II",
			info = "Upgrades your special ability\n\t• Cooldown decreased by [-special_cd]\n\t• Duration increased by [+special_times]",
		},
	}
}

wep.SCP966 = {
	fatigue = "Fatigue level:",

	skills = {
		_overview = { "passive", "attack", "channeling", "mark" },
		attack = {
			name = "Basic attack",
			dsc = "Perform basic attack. You can only attack players with at least 10 fatigue stacks. Attacked players loses some of fatigue stacks. Effects of this attack are affected by skill tree",
		},
		channeling = {
			name = "Channeling",
			dsc = "Channel ability selected in skill tree",
		},
		mark = {
			name = "Death Mark",
			dsc = "Mark player. Marked players will transfer fatigue stacks from other nearby players to themselves",
		},
		passive = {
			name = "Fatigue",
			dsc = "Once in a while you apply fatigue stacks to nearby players. You also gain passive stack for each applied fatigue stack",
		},
		channeling_bar = {
			name = "Channeling",
			dsc = "Remaining time of channeling ability",
		},
		mark_bar = {
			name = "Death Mark",
			dsc = "Remaining time of mark on marked player",
		},
	},

	upgrades = {
		parse_description = true,

		passive1 = {
			name = "Fatigue I",
			info = "Upgrades your passive ability\n\t• Passive rate increased by [/passive_rate]",
		},
		passive2 = {
			name = "Fatigue II",
			info = "Upgrades your passive ability\n\t• Passive rate increased by [/passive_rate]\n\t• Passive range increased by [+passive_radius]",
		},
		basic1 = {
			name = "Sharp Claws I",
			info = "Upgrades your basic attack increasing damage by [%basic_dmg] for each [basic_stacks] passive stacks. Also gaining passive stacks unlock:\n\t• [bleed1_thr] stacks: Apply bleeding if target is not bleeding\n\t• [drop1_thr] stacks: Target loss of fatigue stacks decreased to [%drop1]\n\t• [slow_thr] stacks: Target is slowed by [-slow_power] for [slow_dur] seconds",
		},
		basic2 = {
			name = "Sharp Claws II",
			info = "Upgrades your basic attack increasing damage by [%basic_dmg] for each [basic_stacks] passive stacks. Also gaining passive stacks unlock:\n\t• [bleed2_thr] stacks: Apply bleeding on hit\n\t• [drop2_thr] stacks: Target loss of fatigue stacks decreased to [%drop2]\n\t• [hb_thr] stacks: Apply heavy bleeding instead of bleeding on hit",
		},
		heal = {
			name = "Blood Drain",
			info = "Heal [%heal_rate] per passive stack per target fatigue stack on hit",
		},
		channeling_a = {
			name = "Endless Fatigue",
			info = "Unlocks channeling ability that will allow you to focus on single target\n\t• Passive is disabled during channeling\n\t• Cooldown [channeling_cd] seconds\n\t• Maximum duration [channeling_time] seconds\n\t• Target will gain fatigue stack once every [channeling_rate] second",
		},
		channeling_b = {
			name = "Energy Drain",
			info = "Unlocks channeling ability that will allow you to drain fatigue charges from nearby players\n\t• Passive is disabled during channeling\n\t• Cooldown [channeling_cd] seconds\n\t• Maximum duration [channeling_time] seconds\n\t• Each [channeling_rate] second, transfer 1 fatigue charge from all nearby players to passive stacks",
		},
		channeling = {
			name = "Empowered Channeling",
			info = "Upgrades your channeling ability\n\t• Channeling range increased by [+channeling_range_mul]\n\t• Channeling duration increased by [+channeling_time_mul]",
		},
		mark1 = {
			name = "Lethal Mark I",
			info = "Upgrades mark ability:\n\t• Stacks transfer rate increased by [/mark_rate]",
		},
		mark2 = {
			name = "Lethal Mark II",
			info = "Upgrades mark ability:\n\t• Stacks transfer rate increased by [/mark_rate]\n\t• Stacks transfer range increased by [+mark_range]",
		},
	}
}

wep.SCP24273 = {
	skills = {
		_overview = { "change", "primary", "secondary", "special" },
		primary = {
			name = "Dash / Camouflage",
			dsc = "\nJudge:\nDash forward dealing damage to everyone on your path\n\nProsecutor:\nEnable camouflage. During camouflage you are less visible. Using skills, moving or receiving damage interrupts it",
		},
		secondary = {
			name = "Examination / Surveillance",
			dsc = "\nJudge:\nStart focusing on targeted player for some time. When fully casted, slow target and deal damage. If line of sight is lost, skill is interrupted and you are slowed instead\n\nProsecutor:\nLeave your body and look from a perspective of random player nerby. Your passive also works from that player's perspective",
		},
		special = {
			name = "Judgement / Ghost",
			dsc = "\nJudge:\nStay in place and force everyone nearby to walk to you. When finished, players in close proximity receive damage and are knocked back\n\nProsecutor:\nEnter ghost form. While in ghost form, you are immune to any damage (except explosions and direct damage)",
		},
		change = {
			name = "Judge / Prosecutor",
			dsc = "\nChange between Judge and Prosecutor mode\n\nJudge:\nDamage you deal is increased by evidence cumulated on target. Attacking target reduces evidence level. Attacking players with full evidence, instantly kills them\n\nProsecutor:\nYou are slowed and you receive bullet damage protection. Looking at players gathers evidence against them",
		},
		camo_bar = {
			name = "Camouflage",
			dsc = "Remaining camouflage time",
		},
		spectate_bar = {
			name = "Surveillance",
			dsc = "Remaining surveillance time",
		},
		drain_bar = {
			name = "Examination",
			dsc = "Remaining examination time",
		},
		ghost_bar = {
			name = "Ghost",
			dsc = "Remaining ghost time",
		},
		special_bar = {
			name = "Judgement",
			dsc = "Remaining judgement time",
		},
	},

	upgrades = {
		parse_description = true,

		j_passive1 = {
			name = "Strict Judge I",
			info = "Upgrades your judge passive ability\n\t• Evidence increases damage up to additional [%j_mult]\n\t• Evidence loss on attack reduced to [%j_loss]",
		},
		j_passive2 = {
			name = "Strict Judge II",
			info = "Upgrades your judge passive ability\n\t• Evidence increases damage up to additional [%j_mult]\n\t• Evidence loss on attack reduced to [%j_loss]",
		},
		p_passive1 = {
			name = "District Attorney I",
			info = "Upgrades your prosecutor passive ability\n\t• Bullet protection increased to [%p_prot]\n\t• Slow increased to [%p_slow]\n\t• Evidence gathering rate increased to [%p_rate] pre second",
		},
		p_passive2 = {
			name = "District Attorney II",
			info = "Upgrades your prosecutor passive ability\n\t• Bullet protection increased to [%p_prot]\n\t• Slow increased to [%p_slow]\n\t• Evidence gathering rate increased to [%p_rate] pre second",
		},
		dash1 = {
			name = "Dash I",
			info = "Upgrades your dash ability\n\t• Cooldown reduced by [-dash_cd]\n\t• Damage increased by [+dash_dmg]",
		},
		dash2 = {
			name = "Dash II",
			info = "Upgrades your dash ability\n\t• Cooldown reduced by [-dash_cd]\n\t• Damage increased by [+dash_dmg]",
		},
		camo1 = {
			name = "Camouflage I",
			info = "Upgrades your camouflage ability\n\t• Cooldown reduced by [-camo_cd]\n\t• Duration increased by [+camo_dur]\n\t• You can move [camo_limit] units without interrupting this ability",
		},
		camo2 = {
			name = "Camouflage II",
			info = "Upgrades your camouflage ability\n\t• Cooldown reduced by [-camo_cd]\n\t• Duration increased by [+camo_dur]\n\t• You can move [camo_limit] units without interrupting this ability",
		},
		drain1 = {
			name = "Examination I",
			info = "Upgrades your examination ability\n\t• Cooldown reduced by [-drain_cd]\n\t• Duration reduced by [-drain_dur]",
		},
		drain2 = {
			name = "Examination II",
			info = "Upgrades your examination passive ability\n\t• Cooldown reduced by [-drain_cd]\n\t• Duration reduced by [-drain_dur]",
		},
		spect1 = {
			name = "Surveillance I",
			info = "Upgrades your surveillance ability\n\t• Cooldown reduced by [-spect_cd]\n\t• Duration increased by [+spect_dur]\n\t• Bullet damage protection increased to [%spect_prot]",
		},
		spect2 = {
			name = "Surveillance II",
			info = "Upgrades your surveillance ability\n\t• Cooldown reduced by [-spect_cd]\n\t• Duration increased by [+spect_dur]\n\t• Bullet damage protection increased to [%spect_prot]",
		},
		combo = {
			name = "Supreme Court",
			info = "Upgrades your judgement and ghost ability\n\t• Judgement protection increased to [%special_prot]\n\t• Ghost duration increased by [+ghost_dur]",
		},
		spec = {
			name = "Judgement",
			info = "Upgrades your judgement ability\n\t• Cooldown reduced by [-special_cd]\n\t• Duration increased by [+special_dur]\n\t• Protection increased to [%special_prot]",
		},
		ghost1 = {
			name = "Ghost I",
			info = "Upgrades your ghost ability\n\t• Cooldown reduced by [-ghost_cd]\n\t• Duration increased by [+ghost_dur]\n\t• Heal increased to [ghost_hel] per 1 consumed evidence",
		},
		ghost2 = {
			name = "Ghost II",
			info = "Upgrades your ghost ability\n\t• Cooldown reduced by [-ghost_cd]\n\t• Duration increased by [+ghost_dur]\n\t• Heal increased to [ghost_hel] per 1 consumed evidence",
		},
		change1 = {
			name = "Swap I",
			info = "Swap cooldown reduced by [-change_cd]",
		},
		change2 = {
			name = "Swap II",
			info = "Swap cooldown reduced by [-change_cd]. Additionally, changing mode no longer interrupts camouflage ability",
		},
	}
}

wep.SCP3199 = {
	skills = {
		_overview = { "passive", "primary", "special", "egg" },
		eggs_max = "You already have maximum eggs!",

		primary = {
			name = "Attack",
			dsc = "Perform basic attack. Hitting target activates (or refreshes) frenzy, applies deep wounds effect and grants passive stack and frenzy stack.\nAttacks deal reduced damage to targets with deep wounds. Missing the attack stops frenzy. Hitting only the target with deep wounds stops frenzy and applies tokens penalty",
		},
		special = {
			name = "Attack from Beyond",
			dsc = "Activates after [tokens] successful attacks in a row. Use to instantly end frenzy and damage all players who have deep wounds. Affected players are also slowed",
		},
		egg = {
			name = "Eggs",
			dsc = "After killing player you can spawn egg. When you receive lethal damage, you will respawn at the random egg. Respawning consumes egg. Additionally, each egg grants [prot] bullet protection (capped at [cap])\n\nCurrent eggs: [eggs] / [max]",
		},
		passive = {
			name = "Passive",
			dsc = "While in frenzy see location of nearby players without deep wounds. Gaining frenzy tokens also grant passive tokens. If your attack hits only player with deep wounds, you will lose [penalty] stacks. Passive tokens upgrade your other abilities\n\nRegenerate [heal] HP per second in frenzy\nAttack damage bonus: [dmg]\nFrenzy speed bonus: [speed]\nSpecial attack additional slow: [slow]\nSpecial attacks inflict [bleed] bleed level(s)",
		},
		frenzy_bar = {
			name = "Frenzy",
			dsc = "Remaining frenzy time",
		},
		egg_bar = {
			name = "Egg",
			dsc = "Remaining egg spawn time",
		},
	},

	upgrades = {
		parse_description = true,

		frenzy1 = {
			name = "Frenzy I",
			info = "Upgrades your frenzy ability\n\t• Duration increased by [+frenzy_duration]\n\t• Maximum stacks increased by [frenzy_max]",
		},
		frenzy2 = {
			name = "Frenzy II",
			info = "Upgrades your frenzy ability\n\t• Maximum stacks increased by [frenzy_max]\n\t• Frenzy speed increased by [%frenzy_speed_stacks] per passive stack",
		},
		frenzy3 = {
			name = "Frenzy III",
			info = "Upgrades your frenzy ability\n\t• Duration increased by [+frenzy_duration]\n\t• Frenzy speed increased by [%frenzy_speed_stacks] per passive stack",
		},
		attack1 = {
			name = "Sharp Claws I",
			info = "Upgrades your attack ability\n\t• Cooldown reduced by [-attack_cd]\n\t• Damage increased by [+attack_dmg]",
		},
		attack2 = {
			name = "Sharp Claws II",
			info = "Upgrades your attack ability\n\t• Cooldown reduced by [-attack_cd]\n\t• Damage increased by [%attack_dmg_stacks] per passive stack",
		},
		attack3 = {
			name = "Sharp Claws III",
			info = "Upgrades your attack ability\n\t• Damage increased by [+attack_dmg]\n\t• Damage increased by [%attack_dmg_stacks] per passive stack",
		},
		special1 = {
			name = "Attack from Beyond I",
			info = "Upgrades your special ability\n\t• Damage increased by [+special_dmg]\n\t• Slow increased by [%special_slow] per passive stack\n\t• Slow duration increased by [+special_slow_duration]",
		},
		special2 = {
			name = "Attack from Beyond II",
			info = "Upgrades your special ability\n\t• Damage increased by [+special_dmg]\n\t• Slow increased by [%special_slow] per passive stack\n\t• Slow duration increased by [+special_slow_duration]",
		},
		passive = {
			name = "Blood Sense",
			info = "Passive detection radius increased by [+passive_radius]",
		},
		egg = {
			name = "Easter Egg",
			info = "Instantly spawn new egg. This ability can exceed eggs limit",
		},
	}
}
