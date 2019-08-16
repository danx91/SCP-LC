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
    roundxp = "You received %i experience for your points",
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
    winxp = "You received %i experience because your initial team won the game",
    winalivexp = "You received %i experience because your team won the game",
    upgradepoints = "You received new upgrade point(s)! Press '%s' to open SCP upgrade menu",
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
Effects
---------------------------------------------------------------------------]]
local effects = {}

effects.permanent = "perm"
effects.bleeding = "Bleeding"
effects.doorlock = "Door Lock"
effects.amnc227 = "AMN-C227"

lang.EFFECTS = effects

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
    tester = "Tester",
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
    tree = "%s UPGRADE TREE",
    points = "Points",
    cost = "Cost",
    owned = "Owned",
    requiresall = "Requires",
    requiresany = "Requires any"
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
classes.SCP457 = "SCP 457"
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
Escort them to the exit
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

    SCP173 = [[You are SCP 173
Your objective is to escape from the facility
You can't move while someone is watching you
Your special ability teleports you to the nearby human]],

    SCP457 = [[You are SCP 457
Your objective is to escape from the facility
You are burning and you will ignite everything
near you
You can place up to 5 fire traps]],

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
You can talk with humans]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
    nvmod = {
        name = "Extra Vision",
        info = "Brightness of your vision is increased\nDark areas will no longer stop you"
    }
}

local wep = {}

wep.SCP106 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
    upgrades = {
        cd1 = {
            name = "Void Walk I",
            info = "Special ability cooldown is reduced by 15s"
        },
        cd2 = {
            name = "Void Walk II",
            info = "Special ability cooldown is reduced by 15s\n\t• Total cooldown: 30s"
        },
        cd3 = {
            name = "Void Walk III",
            info = "Special ability cooldown is reduced by 15s\n\t• Total cooldown: 45s"
        },
        tpdmg1 = {
            name = "Decaying Touch I",
            info = "After teleport gain 15 damage for 10s"
        },
        tpdmg2 = {
            name = "Decaying Touch II",
            info = "After teleport gain 20 damage for 20s"
        },
        tpdmg3 = {
            name = "Decaying Touch III",
            info = "After teleport gain 25 damage for 30s"
        },
        tank1 = {
            name = "Pocket Shield I",
            info = "Get 20% bullet damage protection, but you will be 10% slower"
        },
        tank2 = {
            name = "Pocket Shield II",
            info = "Get 20% bullet damage protection, but you will be 10% slower\n\t• Total protection: 40%\n\t• Total slow: 20%"
        },
    }
}

wep.SCP173 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
    upgrades = {
        specdist1 = {
            name = "Wraith I",
            info = "Your special ability distance is increased by 500"
        },
        specdist2 = {
            name = "Wraith II",
            info = "Your special ability distance is increased by 700\n\t• Total increase: 1200"
        },
        specdist3 = {
            name = "Wraith III",
            info = "Your special ability distance is increased by 800\n\t• Total increase: 2000"
        },
        boost1 = {
            name = "Bloodthirster I",
            info = "Each time you kill human you will gain 150 HP and your special ability cooldown will be decreased by 10%"
        },
        boost2 = {
            name = "Bloodthirster II",
            info = "Each time you kill human you will gain 300 HP and your special ability cooldown will be decreased by 25%"
        },
        boost3 = {
            name = "Bloodthirster III",
            info = "Each time you kill human you will gain 500 HP and your special ability cooldown will be decreased by 50%"
        },
        prot1 = {
            name = "Concrete Skin I",
            info = "Instantly heal 1000 HP and get 10% protection against bullet wounds"
        },
        prot2 = {
            name = "Concrete Skin II",
            info = "Instantly heal 1000 HP and get 10% protection against bullet wounds\n\t• Total protection: 20%"
        },
        prot3 = {
            name = "Concrete Skin III",
            info = "Instantly heal 1000 HP and get 20% protection against bullet wounds\n\t• Total protection: 40%"
        },
    },
    back = "You can hold R to back to previous position",
}

wep.SCP457 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
    placed = "Active traps: %i/%i",
    nohp = "Not enough HP!",
    upgrades = {
        fire1 = {
            name = "Live Torch I",
            info = "Your burn radius is increased by 25"
        },
        fire2 = {
            name = "Live Torch II",
            info = "Your burn damage is increased by 0.5"
        },
        fire3 = {
            name = "Live Torch III",
            info = "Your burn radius is increased by 50 and your burn damage is increased by 0.5\n\t• Total radius increase: 75\n\t• Total damage increase: 1"
        },
        trap1 = {
            name = "Little Surprise I",
            info = "Trap lifetime is increased to 4 minuses and will burn 1s longer"
        },
        trap2 = {
            name = "Little Surprise II",
            info = "Trap lifetime is increased to 5 minuses and will burn 1s longer and its damage is increased by 0.5\n\t• Total burn time increase: 2s"
        },
        trap3 = {
            name = "Little Surprise III",
            info = "Trap will burn 1s longer and its damage is increased by 0.5\n\t• Total burn time increase: 3s\n\t• Total damage increase: 1"
        },
        heal1 = {
            name = "Sizzling Snack I",
            info = "Burning people will heal you for additional 1 health"
        },
        heal2 = {
            name = "Sizzling Snack II",
            info = "Burning people will heal you for additional 1 health\n\t• Total heal increase: 2"
        },
        speed = {
            name = "Fast Fire",
            info = "Your speed is increased by 10%"
        }
    }
}

wep.SCP682 = {
    swait = "Special ability cooldown: %is",
    sready = "Special ability is ready!",
    s_on = "You are immune to any damage! %is",
    upgrades = {
        time1 = {
            name = "Unbroken I",
            info = "Your special ability duration is increased by 2.5s\n\t• Total duration: 12.5s"
        },
        time2 = {
            name = "Unbroken II",
            info = "Your special ability duration is increased by 2.5s\n\t• Total duration: 15s"
        },
        time3 = {
            name = "Unbroken III",
            info = "Your special ability duration is increased by 2.5s\n\t• Total duration: 17.5s"
        },
        prot1 = {
            name = "Adaptation I",
            info = "You take 10% less bullet damage"
        },
        prot2 = {
            name = "Adaptation II",
            info = "You take 15% less bullet damage\n\t• Total damage reduce: 25%"
        },
        prot3 = {
            name = "Adaptation III",
            info = "You take 15% less bullet damage\n\t• Total damage reduce: 40%"
        },
        speed1 = {
            name = "Furious Rush I",
            info = "After using special ability, gain 10% movement speed until receiving damage"
        },
        speed2 = {
            name = "Furious Rush II",
            info = "After using special ability, gain 20% movement speed until receiving damage"
        },
        ult = {
            name = "Regeneration",
            info = "5 seconds after receiving damage, regenerate 5% of missing health"
        },
    }
}

wep.SCP8602 = {
    upgrades = {
        charge11 = {
            name = "Brutality I",
            info = "Damage of strong attack is increased by 5"
        },
        charge12 = {
            name = "Brutality II",
            info = "Damage of strong attack is increased by 10\n\t• Total damage increase: 15"
        },
        charge13 = {
            name = "Brutality III",
            info = "Damage of strong attack is increased by 10\n\t• Total damage increase: 25"
        },
        charge21 = {
            name = "Charge I",
            info = "Range of strong attack is increased by 15"
        },
        charge22 = {
            name = "Charge II",
            info = "Range of strong attack is increased by 15\n\t• Total range increase: 30"
        },
        charge31 = {
            name = "Shared Pain",
            info = "When you perform strong attack, everyone nerby impact point will receive 20% of the original damage"
        },
    }
}

wep.SCP939 = {
    upgrades = {
        heal1 = {
            name = "Bloodlust I",
            info = "Your attacks heal you for at least 22.5 HP (up to 30)"
        },
        heal2 = {
            name = "Bloodlust II",
            info = "Your attacks heal you for at least 37.5 HP (up to 50)"
        },
        heal3 = {
            name = "Bloodlust III",
            info = "Your attacks heal you for at least 52.5 HP (up to 70)"
        },
        amn1 = {
            name = "Lethal Breath I",
            info = "Your posion radius is increased to 100"
        },
        amn2 = {
            name = "Lethal Breath II",
            info = "Your poison now deals damage: 2.5 dmg/s"
        },
        amn3 = {
            name = "Lethal Breath III",
            info = "Your posion radius is increased to 125 and your poison damage is increased to 5 dmg/s"
        },
    }
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

wep.FLASHLIGHT = {
    name = "Flashlight"
}

wep.BATTERY = {
    name = "Battery"
}

wep.weapon_stunstick = "Stunstick"

lang.WEAPONS = wep

registerLanguage( lang, "english", "en", "default" )
