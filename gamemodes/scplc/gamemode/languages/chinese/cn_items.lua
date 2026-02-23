local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "保安背心"
vest.heavyguard = "重型防护护甲"
vest.specguard = "安保主管护甲"
vest.guard_medic = "医疗安保护甲"
vest.ntf = "九尾狐士兵护甲"
vest.mtf_medic = "九尾狐医疗兵护甲"
vest.ntfcom = "九尾狐指挥官护甲"
vest.alpha1 = "MTF 阿尔法-1 护甲"
vest.ci = "混沌分裂者士兵护甲"
vest.cicom = "混沌分裂者指挥官护甲"
vest.cimedic = "混沌分裂者医疗兵护甲"
vest.goc = "GOC士兵护甲"
vest.gocmedic = "GOC医疗兵护甲"
vest.goccom = "GOC指挥官护甲"
vest.fire = "防火服"
vest.electro = "特斯拉服"
vest.hazmat = "防护服"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "火焰抗性"
dmg.SHOCK = "电击抗性"
dmg.BULLET = "子弹抗性"
dmg.FALL = "摔伤抗性"
dmg.POISON = "毒抗性"

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
wep.BACKPACK = {
	name = "背包",
	info = "允许你携带更多物品",
	size = "型号: ",
	NAMES = {
		small = "小型背包",
		medium = "中型背包",
		large = "大型背包",
		huge = "巨型背包",
	}
}
--TODO: New SCP translations

wep.SCP500 = {
	name = "SCP 500",
	death_info = "你被SCP500噎死了",
	text_used = "你一吞下这片药丸就感觉好多了",
}

wep.SCP714 = {
	name = "SCP 714"
}

wep.SCP1025 = {
	name = "SCP 1025",
	diseases = {
		arrest = "心脏骤停",
		mental = "精神疾病",
		asthma = "哮喘",
		blindness = "失明",
		hemo = "血友病",
		oste = "骨质疏松症",

		adhd = "多动症",
		throm = "血小板增多症",
		urbach = "罕见的遗传性疾病",

		gas = "臌胀",
	},
	descriptions = {
		arrest = "心脏骤停是由于心脏不能有效地泵送而导致的突然血流量损失。症状包括意识丧失和呼吸异常或缺失。有些人可能会在心脏骤停前立即出现胸痛、呼吸急促或恶心。单臂辐射性疼痛是一种常见症状，长期不适和全身虚弱也是如此。如果在几分钟内不治疗，通常会导致死亡。",
		asthma = "哮喘是一种肺部呼吸道的长期炎症性疾病。其特征是症状多变且反复出现，可逆性气流阻塞，以及容易引发支气管痉挛。症状包括喘息、咳嗽、胸闷和呼吸急促。这些情况可能每天发生几次，也可能每周发生几次。",
		blindness = "失明.也称为视力障碍或视力丧失，是指视力下降到无法通过眼镜等常规手段解决的程度。有些人还包括那些因为没有眼镜或隐形眼镜而视力下降的人。失明一词是指完全或几乎完全的视力丧失。",
		hemo = "血友病（也称为出血性疾病）是一种主要遗传的遗传性疾病，会损害身体形成血栓的能力，而血栓是止血所需的过程。这会导致人们受伤后出血时间更长，容易出现瘀伤，关节或大脑出血的风险增加。特征性症状随严重程度的不同而不同。一般症状为内部或外部出血。",
		oste = "骨质疏松症是一种全身性骨骼疾病，其特征是骨量低，骨组织微观结构恶化导致骨脆性，从而增加骨折风险。这是老年人骨折的最常见原因。通常骨折的骨头包括脊椎的椎骨、前臂的骨头和臀部。在骨折发生之前，通常没有任何症状。",
		
		adhd = "注意力缺陷/多动障碍（ADHD）是一种神经发育障碍，其特征是注意力不集中、精力过多、注意力过度集中和冲动，否则不适合一个人的年龄。一些患有多动症的人也表现出难以调节情绪或执行功能问题。此外，它还与其他精神障碍有关。",
		throm = "血小板增多症是血液中血小板（血小板）计数高的一种情况。血小板计数高并不一定意味着有任何临床问题，可以通过常规全血计数来检测。然而，重要的是要引出完整的病史，以确保血小板计数的增加不是由二次过程引起的。",
		urbach = "Urbach-Wie病是一种非常罕见的隐性遗传病。这种疾病的症状因人而异。Urbach-Wieth病显示双侧颞叶内侧对称钙化。这些钙化经常影响杏仁核。杏仁核被认为参与处理与生物学相关的刺激和情绪长期记忆，尤其是与恐惧相关的刺激。",
	},
	death_info_arrest = "你死于心脏骤停"
}

wep.HOLSTER = {
	name = "空手",
	info = "用这个来隐藏你的物品",
}

wep.ID = {
	name = "ID",
	pname = "名字:",
	server = "服务器:",
}

wep.CAMERA = {
	name = "监控系统",
	showname = "摄像头",
	info = "摄像头可以让你看到设施里发生的事情\n它还为您提供了扫描SCP并将此信息传输到\n当前无线电信道的能力",
	scanning = "扫描...",
	scan_info = "按 [%s] 扫描SCP",
}

wep.RADIO = {
	name = "对讲机",
}

wep.NVG = {
	name = "NVG",
	info = "夜视仪-使黑暗区域更亮.\n有时你可以透过它们看到异常的东西"
}

wep.NVGPLUS = {
	name = "增强型NVG",
	showname = "NVG+",
	info = "NVG的增强版，允许您在手持其他物品时使用.\n不幸的是，电池只能使用10秒"
}

wep.THERMAL = {
	showname = "热成像夜视仪",
	name = "热成像夜视仪"
}

wep.ACCESS_CHIP = {
	name = "插入芯片",
	cname = "插入芯片 - %s",
	showname = "芯片",
	pickupname = "芯片",
	clearance = "许可级别: %i",
	hasaccess = "授予访问权限:",
	NAMES = {
		general = "一般",
		jan1 = "清洁工",
		jan = "清洁工",
		jan2 = "高级 清洁工",
		acc = "会计师",
		log = "后勤人员",
		sci1 = "研究一级",
		sci2 = "研究二级",
		sci3 = "研究三级",
		spec = "收容专家",
		guard = "安保人员",
		chief = "安保主管",
		mtf = "MTF",
		com = "MTF 指挥官",
		hacked3 = "骇入装置等级三",
		hacked4 = "骇入装置等级四",
		hacked5 = "骇入装置等级五",
		director = "站点主管",
		o5 = "O5",
		goc = "GOC骇入装置",
	},
	SHORT = {
		general = "通常",
		jan1 = "清洁工",
		jan = "清洁工",
		jan2 = "高级 清洁工",
		acc = "会计师",
		log = "后勤人员",
		sci1 = "研究一级",
		sci2 = "研究二级",
		sci3 = "研究三级",
		spec = "收容专家",
		guard = "安全",
		chief = "安全主管",
		mtf = "MTF",
		com = "MTF 指挥官",
		hacked3 = "骇入装置等级三",
		hacked4 = "骇入装置等级四",
		hacked5 = "骇入装置等级五",
		director = "站点主管",
		o5 = "O5",
		goc = "GOC 骇入装置",
	},
	ACCESS = {
		GENERAL = "通常",
		SAFE = "SAFE",
		EUCLID = "EUCLID",
		KETER = "KETER",
		OFFICE = "办公室",
		MEDBAY = "医疗室",
		CHECKPOINT_LCZ = "检查点 LCZ-HCZ",
		CHECKPOINT_EZ = "检查点 EZ-HCZ",
		WARHEAD_ELEVATOR = "弹头电梯",
		EC = "电闸中心",
		ARMORY = "Armory",
		GATE_A = "A大门",
		GATE_B = "B大门",
		GATE_C = "C大门",
		FEMUR = "大腿粉碎机",
		ALPHA = "阿尔法弹头",
		OMEGA = "欧米茄弹头",
		PARTICLE = "粒子炮",
	},
}

wep.OMNITOOL = {
	name = "读卡器",
	cname = "读卡器 - %s",
	showname = "读卡器",
	pickupname = "读卡器",
	none = "无",
	chip = "已安装的芯片: %s",
	clearance = "权限级别: %i",
	SCREEN = {
		loading = "加载",
		name = "读卡器v4.78",
		installing = "安装新芯片...",
		ejecting = "正在弹出访问芯片...",
		ejectwarn = "你确定要弹出芯片吗？",
		ejectconfirm = "再按一次确认...",
		chip = "已安装芯片:",
	},
}

wep.MEDKIT = {
	name = "医疗包（剩余：%d）",
	showname = "医疗包",
	pickupname = "医疗包",
}

wep.MEDKITPLUS = {
	name = "大医疗包 (剩余: %d)",
	showname = "医疗包+",
	pickupname = "医疗包+",
}

wep.FLASHLIGHT = {
	name = "手电筒"
}

wep.BATTERY = {
	name = "电池"
}

wep.GASMASK = {
	name = "防毒面具"
}

wep.HEAVYMASK = {
	name = "重型防毒面具"
}

wep.FUSE = {
	name = "保险丝",
	name_f = "保险丝 %iA",
}

wep.TURRET = {
	name = "炮塔",
	placing_turret = "放置炮塔",
	pickup = "捡起",
	MODES = {
		off = "禁用",
		filter = "区分己方",
		target = "敌方目标",
		all = "瞄准一切",
		supp = "火力压制",
		scp = "攻击SCP"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALPHA 阿尔法代码 #1"
}

wep.ALPHA_CARD2 = {
	name = "ALPHA 阿尔法代码 #2"
}

wep.COM_TAB = {
	name = "NTF 平板",
	loading = "加载",
	eta = "进度条: ",
	detected = "检测到的人员:",
	tesla_deactivated = "特斯拉已停用: ",
	change = "左键 - 取消",
	confirm = "右键 - 确认",
	options = {
		scan = "设施扫描",
		tesla = "重置特斯拉"
	},
	actions = {
		scan = "扫描设施...",
		tesla = "禁用特斯拉...",
	}
}

wep.CLOTHES_CHANGER = {
	name = "窃皮装置（空手）",
	info = "看起来就像一般的空手一样，对着尸体按住左键来切换你的衣服",
	skill = "窃皮装置",
	wait = "等待",
	ready = "已就绪",
	progress = "正在更换你的衣服",
	vest = "先把你的护甲脱下来再使用窃皮工具"
}


wep.GOC_TAB = {
	name = "GOC 平板",
	info = "GOC平板电脑,包含一个小爆炸物在用户死亡的\n情况下自动摧毁平板电脑",
	loading = "加载",
	status = "状态:",
	dist = "到目标的距离",
	objectives = {
		failed = "入侵装置被破坏",
		nothing = "未知",
		find = "寻找入侵设备",
		deliver = "将设备放到指定位置",
		escort = "护送入侵装置",
		protect = "保护入侵装置",
		escape = "撤离阶段"
	}
}

wep.GOCDEVICE = {
	name = "GOC入侵装置",
	placing = "正在放置GOC入侵设备。。。"
}

wep.DOCUMENT = {
	name = "机密文件",
	info = "可能包含关于SCP、设施和员工的有价值信息的多份文件包",
	types = {

	}
}
wep.DOOR_BLOCKER = {  
	name = "门阻器",  
	info = "对准按钮并长按鼠标左键进行充能。松开鼠标左键以放电并暂时阻止门的使用",  
	skill = "门阻技能",  
	wait = "等待",  
	ready = "就绪",  
	progress = "充电中"  
}
wep.ADRENALINE = {
	name = "肾上腺素",
	info = "短暂提升耐力",
}

wep.ADRENALINE_BIG = {
	name = "加强肾上腺素",
	info = "在相当长的一段时间内提供短暂的耐力提升",
}

wep.MORPHINE = {
	name = "吗啡",
	info = "提供一些随时间减少的临时健康生命值",
}

wep.MORPHINE_BIG = {
	name = "加强吗啡",
	info = "供大量随时间减少的临时生命值",
}

wep.TASER = {
	name = "电击枪"
}

wep.PIPE = {
	name = "金属管"
}

wep.GLASS_KNIFE = {
	name = "玻璃刀"
}

wep.__slc_ammo = "子弹"

wep.weapon_stunstick = "电棒"
wep.weapon_crowbar = "撬棍"