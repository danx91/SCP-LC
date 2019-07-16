local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
    scpready = "You can be selected as SCP in next round",
    scpwait = "You have to wait %s rounds to be able to play as SCP",
    abouttostart = "Game will start in 10 seconds!",
    kill = "You received %d points for killing %s: %s!",
    rdm = "You lost %d points for killing %s: %s!",
    acc_nocard = "A keycard is required to operate this door",
    acc_wrongcard = "A keycard with higher clearence level is required to operate this door",
    acc_deny = "Access denied",
    acc_granted = "Access granted",
    device_nocard = "A keycard is required to operate this device",
    rxpspec = "You received %i experience for playing on this server!",
    rxpplay = "You received %i experience for staying alive in the round!",
    rxpplus = "You received %i experience for surviving more than half of the round!",
    roundxp = "You received %i experience for you points",
    gateexplode = "Time to Gate A explosion: %i",
    explodeterminated = "Gate A destruction has been terminated",
    r106used = "SCP 106 recontain procedure can be triggered only once per round",
    r106eloiid = "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure",
    r106sound = "Enable sound transmission in order to start SCP 106 recontain procedure",
    r106human = "Alive human is required in cage in order to start SCP 106 recontain procedure",
    r106already = "SCP 106 is already recontained",
    r106success = "You received %i points for recontaining SCP 106!",
    vestpickup = "You picked up vest",
    vestdrop = "You dropped your vest",
    hasvest = "You already has vest! Use your EQ to drop it",
    escortpoints = "You received %i points for escroting your allies",
    femur_act = "Femur Breaker activated...",
    levelup = "Player %s leveled up! His current level: %i",
    healplayer = "You received %i points for healing other player",
    detectscp = "You received %i points for detecting SCPs",
}

lang.NFailed = "Filed to access NRegistry with key: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
    escaped = "You escaped!",
    escapeinfo = "Good job! You escaped in %s",
    escapexp = "You received %i experience",
    escort = "You have been escorted!",
    roundend = "Round ended!",
    timesup = "Time's up!",
    roundnep = "Not enough players!",
    roundwin = "Round winner: %s",
    roundwinmulti = "Round winners: [RAW]",
}

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
lang.pickup = "Pickup"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "LMB - Select"
lang.eq_rmb = "RMB - Drop"
lang.eq_hold = "Hold LMB - Move item"
lang.eq_vest = "Vest"
lang.eq_key = "Press '%s' to open EQ"

lang.info = "Informations"
lang.author = "Author"
lang.mobility = "Mobility"
lang.weight = "Weight"
lang.protection = "Protection"

lang.weight_unit = "kg" --imperial units are useless!

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Class Viewer"
lang.preview = "Preview"
lang.random = "Random"

lang.details = {
    details = "Details",
    name = "Name",
    team = "Team",
    level = "Required Level",
    walk_speed = "Walk Speed",
    run_speed = "Run Speed",
    chip = "Access Chip",
    persona = "Fake ID",
    weapons = "Weapons",
    class = "Class",
}

lang.headers = {
    support = "SUPPORT",
    classes = "CLASSES",
    scp = "SCPs"
}

lang.view_cat = {
    classd = "Class D",
    sci = "Scientists",
    mtf = "MTF",
    ci = "CI",
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Unconnected"

lang.scoreboard = {
    name = "Scoreboard",
    playername = "Name",
    ping = "Ping",
    prestige = "Prestige",
    level = "Level",
    score = "Score",
    ranks = "Ranks",
}

lang.ranks = {
    author = "Author",
    vip = "VIP",
}

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}

vest.guard = "Security Guard Vest"
vest.chief = "Security Chief Vest"
vest.private = "MTF Private Vest"
vest.sergeant = "MTF Sergeant Vest"
vest.lieutenant = "MTF Lieutenant Vest"
vest.alpha1 = "MTF Alpha 1 Vest"
vest.medic = "MTF Medic Vest"
vest.ntf = "MTF NTF Vest"
vest.ci = "Chaos Insurgency Vest"
vest.fire = "Fireproof Vest"
vest.electro = "Electroproof Vest"

lang.VEST = vest

local dmg = {}

dmg.BURN = "Fire Damage"
dmg.SHOCK = "Electrical Damage"
dmg.BULLET = "Bullet Damage"
dmg.FALL = "Fall Damage"

lang.DMG = dmg

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}

teams.SPEC = "Spectators"
teams.CLASSD = "Class D"
teams.SCI = "Scientists"
teams.MTF = "MTF"
teams.CI = "CI"
teams.SCP = "SCP"

lang.TEAMS = teams


--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}

classes.unknown = "Unknown"

classes.SCP106 = "SCP 106"
classes.SCP173 = "SCP 173"
classes.SCP682 = "SCP 682"
classes.SCP8602 = "SCP 860-2"
classes.SCP939 = "SCP 939"

classes.classd = "Class D"
classes.veterand = "Class D Veteran"
classes.kleptod = "Class D Kleptomaniac"
classes.ciagent = "CI Agent"

classes.sciassistant = "Scientist Assistant"
classes.sci = "Scientist"
classes.seniorsci = "Senior Scientist"
classes.headsci = "Head Scientist"

classes.guard = "Security Guard"
classes.chief = "Security Chief"
classes.private = "MTF Private"
classes.sergeant = "MTF Sergeant"
classes.lieutenant = "MTF Lieutenant"
classes.alpha1 = "MTF Alpha 1"
classes.medic = "MTF Medic"
classes.cispy = "CI Spy"

classes.ntf = "MTF NTF"
classes.ntfcom = "MTF NTF Commander"
classes.ntfsniper = "MTF NTF Sniper"
classes.ci = "Chaos Insurgency"
classes.cicom = "Chaos Insurgency Commander"

lang.CLASSES = classes

--[[-------------------------------------------------------------------------
Class Info
---------------------------------------------------------------------------]]
lang.CLASS_INFO = {
    classd = [[You are Class D Personnel
Your objective is to escape from the facility
Cooperate with others and look for keycards
Beware of MTFs and SCPs - they want to kill you]],

    veterand = [[You are Class D Veteran
Your objective is to escape from the facility
Cooperate with others
Beware of MTFs and SCPs - they want to kill you]],

    kleptod = [[You are Class D Kleptomaniac
Your objective is to escape from the facility
You stole something from the staff
Beware of MTFs and SCPs - they want to kill you]],

    ciagent = [[You are CI Agent
Your objective is to protect Class D Personnel
Escort them to the esxit
Beware of MTFs and SCPs - they want to kill you]],

    sciassistant = [[You are Scientist Assistant
Your objective is to escape from the facility
Cooperate with other scientists and security staff
Beware of Chaos Insurgency and SCPs - they want to kill you]],

    sci = [[You are Scientist
Your objective is to escape from the facility
Cooperate with other scientists and security staff
Beware of Chaos Insurgency and SCPs - they want to kill you]],

    seniorsci = [[You are Senior Scientist
Your objective is to escape from the facility
Cooperate with other scientists and security staff
Beware of Chaos Insurgency and SCPs - they want to kill you]],

    headsci = [[You are Head Scientist
Your objective is to escape from the facility
Cooperate with other scientists and security staff
Beware of Chaos Insurgency and SCPs - they want to kill you]],

    guard = [[You are Security Guard
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs
Cooperate with others and listen security chief]],

    chief = [[You are Security Chief
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs
Cooperate with others, listen to MTFs
Give orders to guards]],

    private = [[You are MTF Private
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs
Cooperate with others, listen to your superiors]],

    sergeant = [[You are MTF Sergeant
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs
Cooperate with others, listen to your superiors
Give orders to subordinates]],

    lieutenant = [[You are MTF Lieutenant
Your objective is to rescue all scientist and
kill all Class D Personnel and SCPs
Cooperate with others, listen to your superiors
Give orders to subordinates]],

    alpha1 = [[You are MTF Alpha 1
You work directly for O5 Council
Protect foundation at all cost
Your mission is to [REDACTED]
Give orders to staff]],

    medic = [[You are MTF Medic
Your objective is to rescue all scientist and
kill all Class D Personnel and SCPs
Cooperate with others, listen to your superiors
Use your medkit to help other MTFs]],

    cispy = [[You are CI Spy
Your objective is to help Class D Personnel
Pretend to be a security guard]],

    ntf = [[You are MTF NTF
Help MTFs inside facility
Don't let Class D Personnel and SCPs escape]],

    ntfcom = [[You are MTF NTF Commander
Help MTFs inside facility
Don't let Class D Personnel and SCPs escape
Give orders to other NTFs]],

    ntfsniper = [[You are MTF NTF Sniper
Protect you team from a distance
Don't let Class D Personnel and SCPs escape]],

    ci = [[You are Chaos Insurgency Soldier
Help Class D Personnel
Kill MTFs and other facility staff]],

    cicom = [[You are Chaos Insurgency Commander
Help Class D Personnel
Kill MTFs and other facility staff
Give orders to oyher CI soldiers]],

    SCP106 = [[You are SCP 106
Your objective is to escape from the facility
You can go through doors and teleport to the selected location

LMB: Teleport humans to pocket dimension
RMB: Mark teleport destination
R: Teleport]],

    SCP173 = [[You are SCP 106
Your objective is to escape from the facility
You can't move while someone is watching you
You special ability moves you back to location
where you were 10s earlier]],

    SCP682 = [[You are SCP 682
Your objective is to escape from the facility
You have a lot of health
Your special ability makes you immune to any damage]],

    SCP8602 = [[You are SCP 860-2
Your objective is to escape from the facility
If you attack someone near wall, you will
nail him to wall and deal huge damage]],

    SCP939 = [[You are SCP 939
Your objective is to escape from the facility
You can talk with ]],
}
/*lang.starttexts = {
    ROLE_SCPSantaJ = {
        "You are the SCP-SANTA-J",
        {"Your objective is to escape the facility",
        "You are Santa Claus! Give gifts to everyone!",
        "Merry Christmas and Happy New Year",
        "This is special SCP available only in Christmas event!"}
    },
    ROLE_SCP173 = {
        "You are the SCP-173",
        {"Your objective is to escape the facility",
        "You cannot move when someone is looking at you",
        "Remember, humans are blinking",
        "You have a special ability on RMB: blind everyone around you"}
    },
    ROLE_SCP096 = {
        "You are the SCP-096",
        {"Your objective is to escape the facility",
        "You move extremely fast when somebody is looking",
        "You can scream by using RMB"}
    },
    ROLE_SCP066 = {
        "You are the SCP-066",
        {"Your objective is to escape the facility",
        "You can play VERY loud sound",
        "LMB - attack, RMB - you can destroy windows"}
    },
    ROLE_SCP106 = {
        "You are the SCP-106",
        {"Your objective is to escape the facility",
        "When you touch someone, they will teleport",
        "to your pocket dimension"}
    },
    ROLE_SCP966 = {
        "You are the SCP-966",
        {"Your objective is to escape the facility",
        "You are invisible, humans can only see you using a nvg",
        "You hurt humans when you are near them",
        "You also disorientate them"}
    },
    ROLE_SCP682 = {
        "You are the SCP-682",
        {"Your objective is to escape the facility",
        "You are a Hard-to-Destroy Reptile",
        "You kill people instantly, although you are very slow",
        "You have a special ability on RMB"}
    },
    ROLE_SCP457 = {
        "You are the SCP-457",
        {"Your objective is to escape then facility",
        "You are always burning",
        "If you are close enough to a human, you will burn them"}
    },
    ROLE_SCP049 = {
        "You are the SCP-049",
        {"Your objective is to escape the facility",
        "If you use your special ability on someone, they will become SCP-049-2"}
    },
    ROLE_SCP689 = {
        "You are the SCP-689",
        {"Your objective is to escape the facility",
        "You are extremly slow, but also deadly",
        "You can kill anyone who look at you",
        "After you kill someone, you appear on the body",
        "LMB - attack, RMB - destroy windows"}
    },
    ROLE_SCP939 = {
        "You are the SCP-939",
        {"Your objective is to escape the facility",
        "Your are fast and strong",
        "You can deceive your targets by talking in their voice chat",
        "LMB - attack, RMB - change voice chat"}
    },
    ROLE_SCP999 = {
        "You are the SCP-999",
        {"Your objective is to escape the facility",
        "You can heal anybody you want",
        "You have to co-operate with other personnel or SCPs"}
    },
    ROLE_SCP082 = {
        "You are the SCP-082",
        {"Your objective is to escape the facility",
        "You are a cannibal with a machete",
        "Your attacks reduces your target's stamina",
        "When you kill somebody you will gain health"}
    },
    ROLE_SCP023 = {
        "You are the SCP-023",
        {"Your objective is to escape the facility",
        "You are a wolf and you ignite everyone who goes through you",
        "Igniting others regenerate your health",
        "LMB - attack, RMB - you gain speed but you lose heath"}
    },
    ROLE_SCP1471 = {
        "You are the SCP-1471-A",
        {"Your objective is to escape the facility",
        "You can teleport yourself to your target",
        "LMB - attack, RMB - teleport to your target"}
    },
    ROLE_SCP1048A = {
        "You are the SCP-1048-A",
        {"Your objective is to escape the facility",
        "You look like SCP-1048, but you are made entirely out of human ears",
        "You emit a very loud scream"}
    },
    ROLE_SCP1048B = {
        "You are the SCP-1048-B",
        {"Your objective is to escape the facility",
        "Kill'em all"}
    },
    ROLE_SCP8602 = {
        "You are the SCP-860-2",
        {"Your objective is to escape the facility",
        "You are forest monster",
        "When you attack somebody near wall you charging on him"}
    },
    ROLE_SCP0492 = {
        "You are the SCP-049-2",
        {"Your objective is to escape the facility",
        "Cooperate with SCP-049 to kill more people"}
    },
    ROLE_SCP076 = {
        "You are the SCP-076-2",
        {"Your objective is to escape the facility",
        "You are fast and you have low HP",
        "You will be respawning until somebody destroy SCP-076-1"}
    },
    ROLE_SCP957 = {
        "You are the SCP-957",
        {"Your objective is to escape the facility",
        "You receive less damage, but on SCP-957-1 death you will receive damage",
        "Use LMB to deal AOE damage",
        "After attack, you and SCP-957-1 will receive some health"}
    },
    ROLE_SCP9571 = {
        "You are the SCP-957-1",
        {"Your objective is bring your friends to SCP-957",
        "Your vision is limited and you can talk with SCP-957",
        "Nobody knows that you are SCP, don't get exposed",
        "If you die, SCP-957 will receive damage"}
    },
    ROLE_SCP0082 = {
        "You are the SCP-008-2",
        {"Your objective is to infect every MTF and D",
        "If you kill someone, they will become 008-2 aswell"}
    },
}*/

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
local wep = {}

wep.SCP106 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
}

wep.SCP173 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
}

wep.SCP682 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
    s_on = "You are immune to any damage! %is",
}

wep.SCP939 = {
}

wep.HOLSTER = {
    name = "Holster",
}

wep.ID = {
    author = "Kerry",
    name = "ID",
    pname = "Name:",
    server = "Server:",
}

wep.CAMERA = {
    name = "Surveillance System",
    showname = "Cameras",
    info = "Cameras allow you to see what is happening in the facility.\nThey also provide you an ability to scan SCPs and transmit this information to your current radio channel",
}

wep.RADIO = {
    name = "Radio",
}

wep.NVG = {
    name = "NVG"
}

wep.KEYCARD = {
    author = "danx91",
    instructions = "Access:",
    ACC = {
        "SAFE",
        "EUCLID",
        "KETER",
        "Checkpoints",
        "OMEGA Warhead",
        "General Access",
        "Gate A",
        "Gate B",
        "Armory",
        "Femur Breaker",
        "EC",
    },
    STATUS = {
        "ACCESS",
        "NO ACCESS",
    },
    NAMES = {
        "Keycard Level 1",
        "Keycard Level 2",
        "Keycard Level 3",
        "Researcher Keycard",
        "MTF Guard Keycard",
        "MTF Commander Keycard",
        "Keycard Level OMNI",
        "Checkpoint Security Keycard",
        "Hacked CI Keycard",
    },
}

wep.MEDKIT = {
    name = "Medkit (Charges Left: %d)",
    showname = "Medkit",
}

wep.MEDKITPLUS = {
    name = "Big Medkit (Charges Left: %d)",
    showname = "Medkit+",
}

wep.TASER = {
    name = "Taser"
}

wep.weapon_stunstick = "Stunstick"

lang.WEAPONS = wep

registerLanguage( lang, "english", "en", "default" )
