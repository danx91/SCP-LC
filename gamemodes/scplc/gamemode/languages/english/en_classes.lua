local lang = LANGUAGE

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.unknown = "Unknown"

teams.SPEC = "Spectators"
teams.CLASSD = "Class D"
teams.SCI = "Scientists"
teams.GUARD = "Security"
teams.MTF = "MTF"
teams.CI = "CI"
teams.GOC = "GOC"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
lang.UNK_CLASSES = { 
	CLASSD = "Unknown Class D",
	SCI = "Unknown Scientist",
	GUARD = "Unknown Guard",
	MTF = "Unknown MTF",
	CI = "Unknown CI",
	GOC = "Unknown GOC"
}

local classes = {}
lang.CLASSES = classes

classes.unknown = "Unknown"
classes.spectator = "Spectator"

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

classes.classd = "Class D"
classes.veterand = "Class D Veteran"
classes.kleptod = "Class D Kleptomaniac"
classes.contrad = "Class D with Contraband"
classes.ciagent = "CI Agent"
classes.expd = "Experimental Class D"
classes.classd_prestige = "Class D Tailor"

classes.sciassistant = "Scientist Assistant"
classes.sci = "Scientist"
classes.seniorsci = "Senior Scientist"
classes.headsci = "Head Scientist"
classes.contspec = "Containment Specialist"
classes.sci_prestige = "Class D Escapee"

classes.guard = "Security Guard"
classes.chief = "Security Chief"
classes.lightguard = "Light Security Guard"
classes.heavyguard = "Heavy Security Guard"
classes.specguard = "Security Guard Specialist"
classes.guardmedic = "Security Guard Medic"
classes.tech = "Security Guard Technician"
classes.cispy = "CI Spy"
classes.lightcispy = "Light CI Spy"
classes.heavycispy = "Heavy CI Spy"
classes.guard_prestige = "Security Guard Engineer"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Shotgun"
classes.ntf_3 = "MTF NTF - Rifle"
classes.ntfcom = "MTF NTF Commander"
classes.ntfsniper = "MTF NTF Sniper"
classes.ntfmedic = "MTF NTF Medic"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Marksman"
classes.alpha1medic = "MTF Alpha-1 Medic"
classes.alpha1com = "MTF Alpha-1 Commander"
classes.ci = "Chaos Insurgency"
classes.cisniper = "Chaos Insurgency Marksman"
classes.cicom = "Chaos Insurgency Commander"
classes.cimedic = "Chaos Insurgency Medic"
classes.cispec = "Chaos Insurgency Specialist"
classes.ciheavy = "Chaos Insurgency Heavy Unit"
classes.goc = "GOC Soldier"
classes.gocmedic = "GOC Medic"
classes.goccom = "GOC Commander"

local classes_id = {}
lang.CLASSES_ID = classes_id

classes_id.ntf_1 = "MTF NTF"
classes_id.ntf_2 = "MTF NTF"
classes_id.ntf_3 = "MTF NTF"

--[[-------------------------------------------------------------------------
Class Info - NOTE: Each line is limited to 48 characters!
Screen is designed to hold max of 5 lines of text and THERE IS NO internal protection!
Note that last (5th) line should be shorter to prevent text overlapping (about 38 characters)
---------------------------------------------------------------------------]]
local generic_classd = [[- Escape from the facility
- Avoid staff and SCP objects
- Cooperate with others]]

local generic_sci = [[- Escape from the facility
- Avoid Class D and SCP objects
- Cooperate with guards and MTFs]]

local generic_guard = [[- Rescue scientists
- Terminate all Class D and SCPs
- Listen to your supervisor]]

local generic_cispy = [[- Pretend to be a guard
- Help remaining Class D Personnel
- Sabotage security actions]]

local generic_ntf = [[- Get to the facility
- Help the remaining staff inside
- Don't let Class D and SCPs escape]]

local generic_scp = [[- Escape from the facility
- Kill everyone you meet
- Cooperate with other SCPs]]

local generic_scp_friendly = [[- Escape from the facility
- You may cooperate with humans
- Cooperate with other SCPs]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	contrad = generic_classd,

	ciagent = [[- Escort Class D members
- Avoid staff and SCP objects
- Cooperate with others]],

	expd = [[- Escape from the facility
- Avoid staff and SCP objects
- You underwent some strange experiments]],

	classd_prestige = [[- Escape from the facility
- Avoid staff and SCP objects
- You can steal clothes from dead bodies]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	contspec = generic_sci,

	sci_prestige = [[- Escape from the facility
- Avoid staff and SCP objects
- You stole clothes and ID of scientist]],

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Rescue scientists
- Terminate all Class D and SCPs
- Give orders to other guards]],

	guardmedic = [[- Rescue scientists
- Terminate all Class D and SCPs
- Support other guards with your medkit]],

	tech = [[- Rescue scientists
- Terminate all Class D and SCPs
- Support other guards with your turret]],

	cispy = generic_cispy,

	lightcispy = generic_cispy,

	heavycispy = generic_cispy,

	guard_prestige = [[- Rescue scientists
- Terminate all Class D and SCPs
- You can temporarily block doors]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- Help the remaining staff inside
- Support other NTFs with your medkit
- Don't let Class D and SCPs escape]],

	ntfcom = [[- Help the remaining staff inside
- Don't let Class D and SCPs escape
- Give orders to other NTFs]],

	ntfsniper = [[- Help the remaining staff inside
- Don't let Class D and SCPs escape
- Protect your team from behind]],

	alpha1 = [[- Protect foundation at all cost
- Stop SCPs and Class D
- You are authorized to ]].."[REDACTED]",

	alpha1sniper = [[- Protect foundation at all cost
- Stop SCPs and Class D
- You are authorized to ]].."[REDACTED]",

	alpha1medic = [[- Protect foundation at all cost
- Support your unit with healing
- You are authorized to ]].."[REDACTED]",

	alpha1com = [[- Protect foundation at all cost
- Give orders to your unit
- You are authorized to ]].."[REDACTED]",

	ci = [[- Help Class D Personnel
- Eliminate all facility staff
- Listen to your supervisor]],

	cisniper = [[- Help Class D Personnel
- Eliminate all facility staff
- Protect your team from behind]],

	cicom = [[- Help Class D Personnel
- Eliminate all facility staff
- Give orders to other CIs]],

	cimedic = [[- Help Class D Personnel
- Help other CIs with your medkit
- Listen to your supervisor]],

	cispec = [[- Help Class D Personnel
- Support CIs with your turret
- Listen to your supervisor]],

	ciheavy = [[- Help Class D Personnel
- Provide covering fire
- Listen to your supervisor]],

	goc = [[- Destroy all SCPs
- Locate and deploy GOC device
- Listen to your supervisor]],

	gocmedic = [[- Destroy all SCPs
- Help GOC soldiers with your medkit
- Listen to your supervisor]],

	goccom = [[- Destroy all SCPs
- Locate and deploy GOC device
- Give orders to GOC soldiers]],

	SCP023 = generic_scp,

	SCP049 = [[- Escape from the facility
- Cooperate with other SCPs
- Cure people]],

	SCP0492 = [[]],

	SCP066 = generic_scp_friendly,

	SCP058 = generic_scp,

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
	classd = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Basic class. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.
]],

	veterand = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
More advanced class. You have basic access in facility. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.
]],

	kleptod = [[Difficulty: Hard
Toughness: Low
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
High utility class. Starts with one random item. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.
]],

	contrad = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Class with contraband weapon. Use it wisely because this weapon isn't durable.
]],

	ciagent = [[Difficulty: Medium
Toughness: Very High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Armed with taser CI unit. Provide help to Class D and cooperate with them. You can escort Class D members.
]],

	expd = [[Difficulty: ?
Toughness: ?
Agility: ?
Combat potential: ?
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Class that underwent some strange experiments inside the facility. Who knows what was the subject of said experiments...
]],

	classd_prestige = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Looks just like basic class, but has ability to steal clothes from dead bodies. Cooperate with others to face SCPs and facility staff. You can be escorted by CI members.

Idea by: Mr.Kiełbasa (contest winner)
]],

	sciassistant = [[Difficulty: Medium
Toughness: Low
Agility: Low
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
Basic class. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	sci = [[Difficulty: Medium
Toughness: Normal
Agility: Normal
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	seniorsci = [[Difficulty: Easy
Toughness: High
Agility: High
Combat potential: Normal
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists. You have higher access level. You've also found a primitive weapon. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	headsci = [[Difficulty: Easy
Toughness: Very High
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
Best of the scientists. You have higher utility and HP. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	contspec = [[Difficulty: Medium
Toughness: Very High
Agility: Very High
Combat potential: Low
Can escape: Yes
Can escort: None
Escorted by: Security, MTF

Overview:
One of the scientists with high utility and HP, also have best access level. Cooperate with facility staff and stay away from SCPs. You can be escorted by MTFs members.
]],

	sci_prestige = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: Medium
Can escape: Yes
Can escort: None
Escorted by: CI

Overview:
Runaway Class D who broke into some scientist's closet and stole clothes and ID. Pretend to be a scientist and cooperate with Class D and CI.

Idea by: Artieusz (contest winner)
]],

	guard = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
Basic security guard. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	lightguard = [[Difficulty: Hard
Toughness: Low
Agility: High
Combat potential: Low
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. High utility, no armor and lower health. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	heavyguard = [[Difficulty: Medium
Toughness: High
Agility: Low
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Lower utility, better armor and higher health. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	specguard = [[Difficulty: Hard
Toughness: High
Agility: Low
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Not so high utility, higher health and strong combat potential. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	chief = [[Difficulty: Easy
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Slightly better combat potential, has taser. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	guardmedic = [[Difficulty: Hard
Toughness: High
Agility: High
Combat potential: Low
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. You have medkit and taser. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	tech = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Has placeable turret, with 3 fire modes (Hold E on turret to see its menu). Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.
]],

	cispy = [[Difficulty: Very Hard
Toughness: Normal
Agility: Normal
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
CI spy. Try to blend in Security Guards and help Class D.
]],

	lightcispy = [[Difficulty: Very Hard
Toughness: Low
Agility: High
Combat potential: Low
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Light CI spy. High utility. Try to blend in Security Guards and help Class D.
]],

	heavycispy = [[Difficulty: Very Hard
Toughness: High
Agility: Low
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Heavy CI spy. Lower utility, better armor and higher health. Try to blend in Security Guards and help Class D.
]],

	guard_prestige = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
One of the guards. Has device that can temporarily block doors in their current state. Utilize your weapon and tools to help other staff members and to kill SCPs and Class D. You can escort Scientists.

Idea by: F"$LAYER (contest winner)
]],

	ntf_1 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with SMG. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntf_2 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with shotgun. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntf_3 = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntfmedic = [[Difficulty: Hard
Toughness: High
Agility: High
Combat potential: Low
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with pistol, has medkit. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntfcom = [[Difficulty: Hard
Toughness: High
Agility: Very High
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with marksman rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ntfsniper = [[Difficulty: Hard
Toughness: Normal
Agility: Normal
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF NTF Unit. Armed with sniper rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1 = [[Difficulty: Medium
Toughness: Extreme
Agility: Very High
Combat potential: High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavly armored, high utility unit, armed with rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1sniper = [[Difficulty: Hard
Toughness: Very High
Agility: Very High
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavily armored, high utility unit, armed with marksman rifle. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1medic = [[Difficulty: Hard
Toughness: Very High
Agility: Very High
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavily armored, high utility unit, provides heal. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	alpha1com = [[Difficulty: Hard
Toughness: Very High
Agility: Very High
Combat potential: Very High
Can escape: No
Can escort: Scientists
Escorted by: None

Overview:
MTF Alpha-1 Unit. Heavily armored, high utility unit. Get into facility and secure it. Help staff inside and kill SCPs and Class D.
]],

	ci = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff.
]],

	cisniper = [[Difficulty: Medium
Toughness: Normal
Agility: High
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. Cover your team.
]],

	cicom = [[Difficulty: Medium
Toughness: Very High
Agility: High
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Higher combat potential. Get into facility, help Class D and kill facility staff.
]],

	cimedic = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: Normal
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. You spawn with medkit
]],

	cispec = [[Difficulty: Medium
Toughness: Medium/High
Agility: Medium/High
Combat potential: High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. You can place turret.
]],

	ciheavy = [[Difficulty: Medium
Toughness: Medium/High
Agility: Medium/High
Combat potential: Very High
Can escape: No
Can escort: Class D
Escorted by: None

Overview:
Chaos Insurgency unit. Get into facility and help Class D and kill facility staff. You are in possession of heavy machine gun.
]],

	goc = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: High
Can escape: No
Can escort: No
Escorted by: None

Overview:
Basic Global Occult Coalition soldier. Destroy all SCPs, use your personal tablet to locate GOC device that was earlier delivered to the facility then deploy and protect it. Escape to the evacuation shelter after successfully deploying the device.
]],

	gocmedic = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: High
Can escape: No
Can escort: No
Escorted by: None

Overview:
Basic Global Occult Coalition soldier. Destroy all SCPs, use your personal tablet to locate GOC device that was earlier delivered to the facility then deploy and protect it. Escape to the evacuation shelter after successfully deploying the device. You spawn with the medkit.
]],

	goccom = [[Difficulty: Medium
Toughness: High
Agility: High
Combat potential: Very High
Can escape: No
Can escort: No
Escorted by: None

Overview:
Basic Global Occult Coalition soldier. Destroy all SCPs, use your personal tablet to locate GOC device that was earlier delivered to the facility then deploy and protect it. Escape to the evacuation shelter after successfully deploying the device. You have smoke grenades.
]],

	SCP0492 = [[General:
A zombie created by SCP-049. Comes as one of following types:

Normal zombie:
Difficulty: Easy | Toughness: Normal | Agility: Normal | Damage: Normal
A decent choice with balanced statistics

Assasin zombie:
Difficulty: Hard | Toughness: Low | Agility: Very High | Damage: High
The fastest one with decent damage, but has the lowest health. Has rapid attack.

Exploding zombie:
Difficulty: Hard | Toughness: High | Agility: Low | Damage: Very High
Low movement speed, but has high health and highest damage. Explodes when killed.

Spitting zombie:
Difficulty: Medium | Toughness: Very High | Agility: Very Low | Damage: Low
The slowest zombie type with lowest damage, but has the most health. Can shoot projectiles.
]],
}
