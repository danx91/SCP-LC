--[[-------------------------------------------------------------------------
Language: Chinese
Date: 12.08.2021
Translated by: Luke (aka xiaobai)
---------------------------------------------------------------------------]]

local lang = {}

lang.self = "Chinese" --Language name (not translated)
lang.self_en = "Chinese" --Language name (in english)

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "你可能在下一轮被选为SCP",
	scpwait = "你必须等待 %i 回合才能以 SCP 的身份进行游戏",
	abouttostart = "游戏将在 %i 秒后开始!",
	kill = "你获得了 %d 分 敌方团队 %s 敌方名字 %s！",
	kill_n = "你击杀了 %s: %s!",
	assist = "你获得了 %d 分，因为你协助玩家杀死了 %s",
	rdm = "你失去了 %d 分 因为你杀死了 %s: %s!",
	acc_denied = "访问被拒绝",
	acc_granted = "允许访问",
	acc_omnitool = "需要读卡器才能开启这扇门",
	device_noomni = "操作此设备需要读卡器",
	elevator_noomni = "启动此电梯需要读卡器",
	acc_wrong = "执行此操作需要更高等级的权限芯片",
	rxpspec = "你在服务器上游玩获得 %i 点经验！",
	rxpplay = "因为你还活着因此你获得了 %i 点经验！",
	rxpplus = "因为你超强的生存能力因此你获得了 %i 点经验！",
	roundxp = "你的积分换的了 %i 点经验",
	gateexplode = "A门爆破时间：%i",
	explodeterminated = "A门爆破已中止",
	r106used = "SCP 106 重新收容程序每回合只能启动一次",
	r106eloiid = "停止运行 ELO-IID 电磁场来启动 SCP 106 重新收容程序",
	r106sound = "打开设施广播来吸引 SCP 106 返回到收容室",
	r106human = "需要有人进入收容间才能启动 SCP 106 重新收容程序",
	r106already = "SCP 106 已被重新收容",
	r106success = "你因成功重新收容 SCP 106 而获得了 %i 点经验",
	vestpickup = "你穿上了护甲",
	vestdrop = "你脱掉了护甲",
	hasvest = "你已经拥有一个护甲！你可以打开你的物品栏脱掉它",
	escortpoints = "你因护送你的目标而获得 %i 分",
	femur_act = "大腿粉碎机启动...",
	levelup = "你升级了! 你当前的等级是：%i",
	healplayer = "你因治疗其他人而获得 %i 分",
	detectscp = "你因使用监控探头发现 SCP 而获得了 %i 分",
	winxp = "你获得 %i 经验，因为你的阵营赢了这回合",
	winalivexp = "你获得 %i 经验，因为你的阵营赢了这回合",
	upgradepoints = "你获得了新的技能提升点！ 按“%s”打开 SCP 技能升级面板",
	omega_detonation = "欧米伽核弹将在 %i 秒内爆炸。 立即到地面或前往核爆避难所避难！",
	alpha_detonation = "阿尔法核弹将在 %i 秒内爆炸。 立即进入设施内部或立即离开设施！",
	alpha_card = "你已插入阿尔法核弹钥匙卡",
	destory_scp = "你因消灭 SCP 项目而获得 %i 分！",
	afk = "你现在正在挂机。 随着时间的流逝，你将不会再获得经验！",
	afk_end = "你已不在挂机",
	overload_cooldown = "等待 %i 后可以破门",
	advanced_overload = "这个门非常坚固请 %i 后重新尝试",
	lockdown_once = "设施封锁每回合只能激活一次！",
	dailybonus = "剩余每日奖励: %i 经验\n下一次重置时间: %s",
	xp_goc_device = "成功部署GOC装备，您获得了%i 经验!",
	goc_device_destroyed = "你因破坏GOC装备而获得%i分!",
	goc_detonation = "欧米伽和阿尔法弹头在 %i 秒内爆炸。立即进行撤离设施或进入避难所",
	fuserating = "你需要一个额定值更高的保险丝！",
	nofuse = "你需要保险丝来使用这个设备",
	nopower = "你按下了按钮，但什么也没发生。。。",
	nopower_omni = "你插入了读卡器，但什么都没发生。。。",
	docs = "你获得了 %i 分因为带走了 %i 基金会重要情报",
	docs_pick = "您获得了SCP基金会的机密文件-带着逃跑以获得奖励",
	gaswarn = "即将消毒区域: %s",
}

lang.NFailed = "无法使用密钥访问 NRegistry %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "你逃离了设施",
	escapeinfo = "干得好！ 你在 %s 逃离了设施",
	escapexp = "你获得了 %i 经验",
	escort = "你被护送离开了！",
	roundend = "游戏回合结束！ ",
	nowinner = "这一回合没有获胜方！",
	roundnep = "玩家人数不够！",
	roundwin = "回合获胜方是：%s",
	roundwinmulti = "本回合获胜者：[RAW]",
	shelter_escape = "你在核爆避难所中幸存了下来",
	alpha_escape = "你在核弹爆炸前逃走了",

	mvp = "本轮最佳：%s，得分：%i",
	stat_kill = "被杀死的玩家：%i",
	stat_rdm = "误杀：%i",
	stat_rdmdmg = "误伤伤害：%i",
	stat_dmg = "造成的伤害：%i",
	stat_bleed = "流血伤害：%i",
	stat_106recontain = "SCP 106 已被重新收容",
	stat_escapes = "逃脱的玩家数：%i",
	stat_escorts = "被护送的玩家数：%i",
	stat_023 = "被 023 变成灰烬的人数：%i",
	stat_049 = "被治愈人数：%i",
	stat_066 = "演奏了天籁之音：%i",
	stat_096 = "看了 096 的脸被分尸的人数: %i",
	stat_106 = "传送到快乐老家的人数：%i",
	stat_173 = "扭断的脖子的人数：%i",
	stat_457 = "烧死的人数：%i",
	stat_682 = "咬死的人数: %i",
	stat_8602 = "被钉在墙上的人数：%i",
	stat_939 = "被吃掉声音的人数: %i",
	stat_966 = "被暗杀的人数: %i",
	stat_3199 = "化为养分的人数：%i",
	stat_24273 = "被 SCP 2427-3 干掉的人：%i",
	stat_omega_warhead = "欧米伽核弹已被引爆",
	stat_alpha_warhead = "阿尔法核弹已被引爆",
	stat_goc_warhead = "GOC设备已激活",
}

lang.NCFailed = "无法使用密钥访问 NCRegistry: %s"


--[[-------------------------------------------------------------------------
Main menu
---------------------------------------------------------------------------]]
local main_menu = {}
lang.MenuScreen = main_menu

main_menu.start = "开始"
main_menu.settings = "设置"
main_menu.precache = "预制模型"
main_menu.credits = "说明"
main_menu.quit = "退出"

main_menu.quit_server = "真的要退出服务器"
main_menu.quit_server_confirmation = "你确定吗?"
main_menu.model_precache = "预制模型"
main_menu.model_precache_text = "当需要时，模型会自动预缓存，但这种情况发生在游戏过程中，因此可能会导致滞后峰值。为了避免这种情况，您现在可以手动预切它们。\n在这个过程中，你的游戏可能会冻结！"
main_menu.yes = "是"
main_menu.no = "不"
main_menu.all = "预制模型"
main_menu.cancel = "取消"


main_menu.credits_text = [[游戏模式创建者 ZGFueDkx (aka danx91)
游戏模式基于SCP并在CC BY-SA 3.0协议

创建菜单动画 Madow

模型:
	Alski - guards, omnitool, turret and more
	
贴图:
	Foer - Workshop logo and few other graphics
	SCP Containment Breach

声音:
	SCP Containment Breach

主要翻译人员:
	Chinese - Luke
	German - Justinnn
	Korean - joon00
	Polish - Slusher, Alski
	Russian - Deiryn, berry
	Turkish - Akane

特别感谢:
	1000 Shells for help with models
	PolishLizard for hosting test server
]]
--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "拾起"
hud.class = "角色"
hud.team = "团队"
hud.class_points = "分数"
hud.hp = "生命值"
hud.stamina = "体力值"
hud.sanity = "理智值"
hud.xp = "经验值"
hud.extra_hp = "额外生命值"

hud.escaping = "逃脱..."
hud.escape_blocked = "逃脱被中止!"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "左键 - 选择"
lang.eq_rmb = "右键 - 丢弃"
lang.eq_hold = "摁住左键 - 移动物品"
lang.eq_vest = "护甲"
lang.eq_key = "按 '%s' 打开物品栏"
lang.eq_unknown = "未知物品"
lang.eq_backpack = "背包"
lang.eq_swapping = "交换物品"

lang.info = "信息"
lang.author = "作者"
lang.mobility = "机动性"
lang.weight = "重量"
lang.vest_multiplier = "伤害抗性"
lang.durability = "耐久度"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "护送",
	gatea = "爆破A门"
}

lang.pickup_msg = {
	max_eq = "你的背包满了",
	cant_stack = "这个东西你不能再带了!",
	has_already = "您已经拥有此物品",
	same_type = "您已经有相同类型的物品",
	one_weapon = "你只能携带一把枪",
	goc_only = "只有GOC才能携带"
}

--[[-------------------------------------------------------------------------
XP Bar
---------------------------------------------------------------------------]]
lang.XP_BAR = {
	general = "经验",
	round = "游玩服务器",
	escape = "逃离设施",
	score = "回合中获得的分",
	win = "赢得本轮比赛",
	vip = "VIP 额外奖励",
	daily = "每日奖励",
	cmd = "未知力量",
}

--[[-------------------------------------------------------------------------
AFK Warning
---------------------------------------------------------------------------]]
lang.AFK = {
	afk = "你目前在 挂机!",
	afk_warn = "挂机 警告",
	slay_warn = "你即将被处死并被标记为挂机！",
	afk_msg = "随着时间的推移，你不会复活和获得经验值",
	afk_action = "-- 按下任意键来返回游戏 --",
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "灼烧"
effects.bleeding = "流血"
effects.doorlock = "门锁"
effects.amnc227 = "AMN-C227"
effects.insane = "精神失常"
effects.gas_choke = "窒息"
effects.radiation = "辐射"
effects.deep_wounds = "伤口"
effects.poison = "毒素"
effects.heavy_bleeding = "大出血"
effects.weak_bleeding = "小出血"
effects.spawn_protection = "出生保护"
effects.fracture = "骨折"
effects.decay = "衰弱"
effects.scp_chase = "追逐"
effects.human_chase = "追逐"
effects.expd_rubber_bones = "实验影响"
effects.expd_stamina_tweaks = "实验影响"
effects.expd_revive = "实验效应"
effects.expd_recovery = "恢复"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "职业查看栏"
lang.preview = "预览"
lang.random = "随机"
lang.buy = "购买"
lang.refund = "退款"
lang.none = "没有"
lang.refunded = "已退还所有点数已删除的角色. 你收到了 %d 点数"
lang.tierlocked = "你必须购买前一层的每个角色才能解锁该层角色（也包括其他阵营的角色）"

lang.details = {
	details = "详情",
	name = "姓名",
	tier = "转生点",
	team = "团队",
	walk_speed = "走路速度",
    run_speed = "跑步速度",
    chip = "权限卡等级",
    persona = "伪装ID",
	loadout = "主要武器",
    weapons = "物品",
    class = "级别",
    hp = "血量",
    speed = "速度",
	health = "健康值",
	sanity = "理智值",
	slots = "支援",
	no_select = "无法在游戏里面生成",
}

lang.headers = {
	support = "支援部队",
	classes = "设施人员",
	scp = "SCPs"
}

lang.view_cat = {
	classd = "D级人员",
	sci = "科研人员",
	guard = "安全部队",
	mtf_ntf = "机动特遣队-九尾狐",
	mtf_alpha = "MTF 阿尔法-1",
	ci = "混沌分裂者",
	goc = "全球超自然联盟",
}

local l_weps = {
	pistol = "手枪",
	smg = "冲锋枪",
	rifle = "步枪",
	shotgun = "散弹枪",
}

local l_tiers = {
	low = "低层",
	mid = "中层",
	high = "高层",
}

lang.loadouts = {
	grenade = "随机手榴弹",
	pistol_all = "随机手枪",
	smg_all = "随机 冲锋枪",
	rifle_all = "随机 步枪",
	shotgun_all = "随机 散弹枪",
}

for k_wep, wep in pairs( l_weps ) do
	for k_tier, tier in pairs( l_tiers ) do
		lang.loadouts[k_wep.."_"..k_tier] = tier.." "..wep
	end
end

--[[-------------------------------------------------------------------------
Settings
---------------------------------------------------------------------------]]
lang.settings = {
	settings = "游戏 设置",

	none = "无",
	press_key = "> 按下任意键 <",
	client_reset = "将客户端设置重置为默认值",
	server_reset = "将服务器设置重置为默认值",

	client_reset_desc = "您即将在此游戏模式中重置所有设置.\n此操作无法撤消",
	server_reset_desc = "由于安全原因，您无法在此处重置服务器设置.\n要将服务器重置为默认设置，请输入 'slc_factory_reset' 在服务器控制台中，并按照说明操作.\n小心，此操作无法撤消，将重置所有内容！",

	popup_ok = "OK",
	popup_cancel = "取消",
	popup_continue = "继续",

	panels = {
		binds = "绑定设置",
		general_config = "常规配置",
		scp_config = "SCP 配置",
		skins = "GUI皮肤",
		reset = "重置游戏模式",
		cvars = "ConVars编辑器",
	},

	binds = {
		eq_button = "背包设置",
		upgrade_tree_button = "SCP技能树",
		ppshop_button = "角色查看器",
		settings_button = "游戏设置",
		scp_special = "SCP特殊能力"
	},

	config = {
		search_indicator = "显示搜索进度",
		scp_hud_skill_time = "显示SCP技能冷却时间",
		smooth_blink = "启用平滑鼠标",
		scp_hud_overload_cd = "显示过载冷却",
		any_button_close_search = "按任意按钮关闭搜索菜单",
		hud_hitmarker = "显示命中标记",
		hud_damage_indicator = "显示伤害提示",
		scp_hud_dmg_mod = "显示SCP收到的伤害",
		scp_nvmod = "SCP时提高屏幕亮度",
		dynamic_fov = "动态FOV",
		hud_draw_crosshair = "绘制十字线",
		hud_hl2_crosshair = "传统HL2十字线",

		cvar_slc_language = "语言",
		cvar_slc_hud_scale = "HUD比例",
		cvar_slc_hud_scale_options = {
			normal = "正常",
			big = "大",
			vbig = "非常大",
			small = "小",
			vsmall = "非常小",
			imretard = "微小",
		},
	},
}

lang.gamemode_config = {
	loading = "加载...",

	categories = {
		general = "普通",
		round = "回合",
		xp = "XP",
		support = "支援刷新",
		warheads = "弹头",
		afk = "AFK",
		time = "时间",
		premium = "转生点",
		scp = "SCP",
		gas = "消毒",
		feature = "特性"
	}
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "未连接"

lang.scoreboard = {
	name = "记分板",
	playername = "名字",
	ping = "延迟",
	level = "等级",
	score = "分数",
	ranks = "权限",
}

lang.ranks = {
	superadmin = "超级管理员",
	admin = "管理",
	author = "作者",
	vip = "VIP",
	contributor = "贡献者",
	translator = "翻译",
	tester = "测试人员",
	patron = "赞助者",
	hunter = "Bug 猎人"
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
    tree = "%s 技能树",
    points = "技能点",
    cost = "花费",
    owned = "已拥有",
    requiresall = "需要",
    requiresany = "需要任何",
	blocked = "无法执行"
}

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
lang.SCPHUD = {
	skill_not_ready = "技能尚未准备好!",
	skill_cant_use = "技能现在无法使用!",
	overload_cd = "下一次过载: ",
	overload_ready = "过载准备就绪",
	damage_scale = "承受伤害"
}

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "名字",
	class = "角色",
	team = "阵营",
	status = "状态",
	objectives = "目标",
	details = "详情",
	registry_failed = "info_screen_registry failed"
}

lang.info_screen_registry = {
	escape_time = "你在 %s 分钟内逃离了设施",
	escape_xp = "你获得了 %s 经验",
	escape1 = "你逃离了设施",
	escape2 = "你在核弹爆炸倒计时期间逃跑了",
	escape3 = "你在核弹避难所的中幸存下来",
	escorted = "您已被护送",
	killed_by = "你被杀了：%s",
	suicide = "你自杀了",
	unknown = "你的死因未知",
	hazard = "你被异常杀死了",
	alpha_mia = "最后已知位置：地面",
	omega_mia = "最后已知位置：设施",
	killer_t = "击杀你的玩家阵营：%s"
}

lang.info_screen_type = {
	alive = "存活",
	escaped = "逃脱",
	dead = "死亡",
	mia = "在行动中失踪",
	unknown = "未知",
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "没什么"
lang.exit = "退出"
lang.default = "默认"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "游戏模式内容",
	status = "状态",
	auto_check = "自动运行",
	slist = {
		"有问题",
		"检查",
		"安装",
		"下载",
		"检查完毕",
	},
	btn_workshop = "创意工坊合集",
	btn_download = "下载",
	btn_check = "检查并下载",
	allok = "所有插件都已安装！",
	nsub_warn = "你没有一些需要的插件！请使用创意工坊下载它们。检查控制台以查看缺少哪些插件。",
	disabled_warn = "某些必需的插件已禁用！游戏为您安装了它，但有些内容可能仍然丢失。请前往菜单并启用禁用的插件（控制台中的列表）。",
	missing = "缺少插件",
	disabled = "禁用的插件",
}

misc.omega_warhead = {
	idle = "欧米伽核弹闲置中\n\n等待指令...",
	waiting = "欧米伽核弹等待\n\n接受输入\n等待第二次输入...",
	failed = "欧米伽核弹已被锁定\n\n未检测到第二个指令输入！\nWait %is",
	no_remote = "欧米伽核弹启动失败\n\n无法与核弹建立连接！\t",
	active = "欧米伽核弹已启动\n\n请立即撤离！\n中的爆炸 %.2fs",
}

misc.alpha_warhead = {
	idle = "阿尔法核弹闲置中\n\n等待核弹代码...",
	ready = "阿尔法核弹闲置中\n\n接受核弹代码！\n等待激活...",
	no_remote = "阿尔法核弹启动失败\n\n无法与核弹建立连接！\t",
	active = "阿尔法核弹已启动成功\n\n请立即撤离！\n在爆炸 %.2fs",
}

misc.zones = {
	lcz = "轻收容",
	hcz = "重收容",
	ez = "办公区",
}

misc.buttons = {
	MOUSE1 = "左键",
	MOUSE2 = "右键",
	MOUSE3 = "中键",
}

misc.inventory = {
	unsearched = "未搜寻",
	search = "按 [%s] 搜索",
	unknown_chip = "未知芯片",
	name = "名称",
	team = "团队",
	death_time = "死亡时间",
	time = {
		[0] = "刚才",
		"大约一分钟前",
		"大约两分钟前",
		"大约三分钟前",
		"大约四分钟前",
		"大约五分钟前",
		"大约六分钟前",
		"大约七分钟前",
		"大约八分钟前",
		"大约九分钟前",
		"大约十分钟前",
		long = "十多分钟前",
	},
}

misc.font = {
	name = "字体",
	content = [[游戏模式字体加载失败！回退到系统字体...
这是gmod问题，我无法修复。要修复它，你必须手动删除一些文件.
前往 'steamapps/common/GarrysMod/garrysmod/cache/workshop/resource/fonts' 并删除以下文件: 'impacted.ttf', 'ds-digital.ttf' 和 'unispace.ttf']],
	ok = "好"
}
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
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.unknown = "未知"

teams.SPEC = "观众"
teams.CLASSD = "D级人员"
teams.SCI = "科研人员"
teams.GUARD = "安全部队"
teams.MTF = "机动特遣队"
teams.CI = "混沌分裂者"
teams.GOC = "全球超自然联盟"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
lang.UNK_CLASSES = { 
	CLASSD = "未知D级人员",
	SCI = "未知研究员",
	GUARD = "未知安保",
}

local classes = {}
lang.CLASSES = classes

classes.unknown = "未知"

classes.SCP023 = "SCP 023"
classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
classes.SCP058 = "SCP 058"
classes.SCP066 = "SCP 066"
classes.SCP096 = "SCP 096"
classes.SCP106 = "SCP 106"
classes.SCP173 = "SCP 173"
classes.SCP457 = "SCP 457"
classes.SCP682 = "SCP 682"
classes.SCP8602 = "SCP 860-2"
classes.SCP939 = "SCP 939"
classes.SCP966 = "SCP 966"
classes.SCP3199 = "SCP 3199"
classes.SCP24273 = "SCP 2427-3"

classes.classd = "普通D级"
classes.veterand = "D级老手"
classes.kleptod = "D级小偷"
classes.contrad = "D级走私者"
classes.ciagent = "CI特工"
classes.expd = "实验D级"

classes.sciassistant = "科学家助理"
classes.sci = "科学家"
classes.seniorsci = "资深科学家"
classes.headsci = "首席科学家"
classes.contspec = "病毒专家"

classes.guard = "警卫"
classes.chief = "安全主管"
classes.lightguard = "轻装安保人员"
classes.heavyguard = "重装安保人员"
classes.specguard = "保安专员"
classes.guardmedic = "安保医护人员"
classes.tech = "保安技术员"
classes.cispy = "CI间谍"

classes.ntf_1 = "MTF 九尾狐 - 侦察步兵"
classes.ntf_2 = "MTF 九尾狐 - 镇暴步兵"
classes.ntf_3 = "MTF 九尾狐 - 步枪兵"
classes.ntfcom = "MTF 九尾狐指挥官"
classes.ntfsniper = "MTF 九尾狐狙击手"
classes.ntfmedic = "MTF 九尾狐队医"
classes.alpha1 = "MTF 阿尔法-1"
classes.alpha1sniper = "MTF 阿尔法-1 狙击手"
classes.alpha1medic = "MTF 阿尔法-1 医疗兵"
classes.alpha1com = "MTF 阿尔法-1 指挥官"
classes.ci = "混沌分裂者"
classes.cicom = "混沌分裂指挥官"
classes.cimedic = "混沌分裂医疗兵"
classes.cispec = "混沌分裂专家t"
classes.ciheavy = "混沌分裂重装"
classes.goc = "全球超自然联盟士兵"
classes.gocmedic = "全球超自然联盟医疗兵"
classes.goccom = "全球超自然联盟指挥官"

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
local generic_classd = [[- 逃离设施
- 避开保安和SCP项目
- 与他人合作]]

local generic_sci = [[- 逃离设施
- 避开 D 级和 SCP 
- 与守卫和 MTF 合作]]

local generic_guard = [[- 救援科学家
- 处决所有 D 级和 SCP
- 听你的主管的命令]]

local generic_ntf = [[- 到达设施
- 帮助里面剩下的员工
- 不要让 D 级和 SCP 逃脱]]

local generic_scp = [[- 逃离设施
- 杀死你遇到的每个人
- 与其他SCP合作]]

local generic_scp_friendly = [[- 逃离设施
- 你可以与人类合作
- 与其他SCP合作]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	contrad = generic_classd,

	ciagent = [[- 护送 D 级成员
- 避开工作人员和SCP
- 与他人合作]],

	expd = [[- 逃离设施
- 避开设施人员和SCP对象
- 你经历了一些奇怪的实验]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	contspec = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- 救援科学家
- 处决所有 D 级和 SCP
- 向其他守卫下达命令]],

	guardmedic = [[- 救援科学家
- 处决所有 D 级和 SCP
- 用你的医疗箱帮助其他守卫]],

	tech = [[- 救援科学家
- 处决所有 D 级和 SCP
- 用你的炮塔支援其他守卫]],

	cispy = [[- 假装是保安
- 帮助剩余的 D 级人员
- 破坏安全行动]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- 帮助里面剩下的研究员
- 使用您的 medkit 支持其他 NTF
- 不要让 D 级和 SCP 逃脱]],

	ntfcom = [[- 帮助里面剩下的研究员
- 不要让 D 级和 SCP 逃脱
- 向其他NTF下达命令]],

	ntfsniper = [[- 帮助里面剩下的研究员
- 不要让 D 级和 SCP 逃脱
- 从背后保护您的团队]],

	alpha1 = [[- 不惜一切代价保护设施
- 消灭 SCP 和 D 级
- 给其他九尾狐发号施令]].."[数据删除]",

	alpha1sniper = [[- 不惜一切代价保护设施
- 消灭 SCP 和 D 级
-  给其他九尾狐发号施令]].."[数据删除]",

	alpha1medic = [[- 不惜一切代价保护设施
- 为你的部队提供治疗支持
- 您有权理 ]].."[数据删除]",

	alpha1com = [[- 不惜一切代价保护设施
- 向你的部队下达命令
- 您有权理 ]].."[数据删除]",

	ci = [[- 帮助 D 级人员
- 干掉所有保安和九尾狐
- 听指挥官指令行事]],

	cicom = [[- 帮助 D 级人员
- 干掉所有保安和九尾狐
- 给其他 CI 发号施令]],

	cimedic = [[- 帮助 D 级人员
- 使用您的药包帮助其他CI
- 听指挥官指令行事]],

	cispec = [[- 帮助 D 级人员
- 使用您的炮塔支援你的队友
- 听指挥官指令行事]],

	ciheavy = [[- 帮助 D 级人员
- 提供火力掩护
- 听指挥官指令行事]],

	goc = [[- 销毁所有SCP
- 定位并部署GOC设备
- 听指挥官指令行事]],

	gocmedic = [[- 销毁所有SCP
- 使用您的医疗包帮助GOC士兵
- 听指挥官指令行事]],

	goccom = [[- 销毁所有SCP
- 定位并部署GOC设备
- 给其他 GOC 发号施令]],

	SCP023 = generic_scp,

	SCP049 = [[- 逃离设施
- 与其他SCP合作
- 治愈其他人]],

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
	classd = [[操作难度：简单
健壮程度：普通
灵活性：普通
作战能力：差
能否逃脱：能
可护送人员：无
能被谁护送：混沌分裂者

Overview:
普通D级。 与他人合作来面对 SCP 和设施工作人员。 您可以由混沌分裂者成员护送离开。
]],

	veterand = [[操作难度: 简单
健壮程度: 强壮
灵活性: 灵活
作战能力: 普通
能否逃脱: 能
可护送人员: 无
能被谁护送: 混沌分裂者

Overview:
老手D级。 你在设施中有基本的访问权限。 与他人合作以面对 SCP 和设施工作人员。 您可以由混沌分裂者成员护送离开。
]],

	kleptod = [[操作难度: 难
健壮程度: 弱不禁风
灵活性: 敏捷
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 混沌分裂者

Overview:
小偷D级。 从一件随机物品开始。 与他人合作以面对 SCP 和设施工作人员。 您可以由混沌分裂者成员护送离开。
]],

	contrad = [[操作难度: 中等
健壮程度: 普通
灵活性: 普通
作战能力: 普通
能否逃脱: 能
可护送人员: 无
能被谁护送: 混沌分裂者

Overview:
使用违禁武器。明智地使用它，因为这种武器不耐用。
]],

	ciagent = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 普通
能否逃脱: 无
可护送人员: D级人员
能被谁护送: 无

Overview:
配备泰瑟枪。 向D级人员提供帮助并与他们合作。 你可以护送D级人员。
]],

	expd = [[操作难度: ?
健壮程度: ?
灵活性: ?
作战能力: ?
能否逃脱: 不能
可护送人员: D级
能被谁护送: 无

Overview:
在设施内进行了一些奇怪实验的D。谁知道实验发生了什么。。。
]],

	sciassistant = [[操作难度: 中等
健壮程度: 普通
灵活性: 普通
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

Overview:
普通科学家。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	sci = [[操作难度: 中的
健壮程度: 普通
灵活性: 普通
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

Overview:
科学家之一。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	seniorsci = [[操作难度: 简单
健壮程度: 强壮
灵活性: 灵活
作战能力: 普通
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

Overview:
科学家之一。 您拥有更高的访问级别。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	headsci = [[操作难度: 简单
健壮程度: 强壮
灵活性: 灵活
作战能力: 普通
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

Overview:
最高级的科学家。 你有更好的能力和血量。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	contspec = [[操作难度: 中等
健壮程度: 强壮
灵活性: 灵活
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

Overview:
其中一位拥有高实用性和HP的科学家，也拥有最高的访问级别。与设施工作人员合作远离SCP您可以由机动特遣队成员护送。
]],

	guard = [[操作难度：简单
健壮程度: 普通
灵活性: 普通
作战能力: 普通
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
普通保安。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	lightguard = [[操作难度：难
健壮程度: 弱不禁风
灵活性: 敏捷
作战能力: 差
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
守卫之一。 实用性高，没有盔甲，生命值较低。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	heavyguard = [[操作难度: 中等
健壮程度: 强壮
灵活性: 迟钝
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
守卫之一。 更低的速度，更好的装甲和更高的健康。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	specguard = [[操作难度: 难
健壮程度: 强壮
灵活性: 迟钝
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
守卫之一。 没有那么强的护甲，但有更高的健康和强大的战斗潜力。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	chief = [[操作难度: 简单
健壮程度: 普通
灵活性: 普通
作战能力: 普通
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
守卫之一。 战斗力稍好，有泰瑟枪。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	guardmedic = [[操作难度: 难
健壮程度: 强壮
灵活性: 灵活
作战能力: 差
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
守卫之一。 你有医疗箱和泰瑟枪。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	tech = [[操作难度: 难
健壮程度: 普通
灵活性: 普通
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
守卫之一。 有可放置的炮塔，有 3 种开火模式（在炮塔上按住 E 以查看其菜单）。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	cispy = [[操作难度: 非常困难
健壮程度: 普通
灵活性: 灵活
作战能力: 普通
能否逃脱: 否
可护送人员：D级人员
能被谁护送: 无

Overview:
尝试融入保安人员并帮助D级人员。
]],

	ntf_1 = [[操作难度: 中等
健壮程度: 普通
灵活性: 灵活
作战能力: 普通
能否逃脱: 否
可护送人员: 科研人员
能被谁护送：无

Overview:
MTF NTF 单位。 配备冲锋枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	ntf_2 = [[操作难度: 中等
健壮程度: 普通
灵活性: 灵活
作战能力: 普通
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF NTF 单位。 用霰弹枪武装。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	ntf_3 = [[操作难度: 中等
健壮程度: 普通
灵活性: 灵活
作战能力: 普通
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF NTF 单位。 手持步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],


	ntfmedic = [[操作难度: 难
健壮程度: 强壮
灵活性: 灵活
作战能力: 差
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF NTF 单位。 手持手枪，有医疗包。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。 
]],

	ntfcom = [[操作难度: 难
健壮程度: 强壮
灵活性: 敏捷
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF NTF 单位。 手持射手步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	ntfsniper = [[操作难度: 难
健壮程度: 普通
灵活性: 普通
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF NTF 单位。 装备狙击步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	alpha1 = [[操作难度: 中等
健壮程度: 超越人类
灵活性: 敏捷
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF Alpha-1佩戴重型装甲,配备步枪,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级。
]],

	alpha1sniper = [[操作难度: 难
健壮程度: 超级强壮
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF Alpha-1佩戴重型装甲,装备神射手步枪,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级。
]],

	alpha1medic = [[操作难度: 难
健壮程度: 超级强壮
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF Alpha-1佩戴重型装甲,可以给其他人提供治疗,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级。
]],

	alpha1com = [[操作难度: 难
健壮程度: 超级强壮
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

Overview:
MTF Alpha-1佩戴重型装甲,给设施武装单位下达命令,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级.
]],

	ci = [[操作难度: 中等
健壮程度: 强壮
灵活性: 灵活
作战能力: 普通
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

Overview:
混沌分裂者单位。 进入设施并帮助 D 级人员并杀死设施工作人员。
]],

	cicom = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

Overview:
混沌分裂者单位。 更高的战斗力。 进入设施，帮助 D 级人员并杀死设施工作人员。
]],

	cimedic = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

Overview:
混沌分裂者单位,更高的战斗力,进入设施.使用您的药包帮助其他CI 帮助 D 级人员并杀死设施工作人员。
]],

	cispec = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

Overview:
混沌分裂者单位,更高的战斗力,进入设施.帮助 D 级人员并杀死设施工作人员
]],

	ciheavy = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

Overview:
混沌分裂者单位,更高的战斗力,进入设施.提供火力压制 帮助 D 级人员并杀死设施工作人员
]],

	goc = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 高
能否逃脱: 无
可护送人员: 无
能被谁护送: 无

Overview:
全球超自然联盟的士兵。销毁所有SCP，使用您的个人平板电脑定位之前传送到设施的GOC设备，然后部署并保护它。成功部署设备后逃脱。
]],

	gocmedic = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 高
能否逃脱: 无
可护送人员: 无
能被谁护送: 无

Overview:
全球超自然联盟的医疗兵。销毁所有SCP，使用你的医疗包帮助队友,使用您的个人平板电脑定位之前传送到设施的GOC设备，然后部署并保护它。成功部署设备后逃脱
]],

	goccom = [[操作难度: 中等
健壮程度: 超级强壮
灵活性: 灵活
作战能力: 高
能否逃脱: 无
可护送人员: 无
能被谁护送: 无

Overview:
全球超自然联盟的指挥官。带领你的队伍,销毁所有SCP，使用您的个人平板电脑定位之前传送到设施的GOC设备，然后部署并保护它。成功部署设备后逃脱
]],

--TODO: New SCP translations
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "buff",
		info = "在地面上时获得被动治疗（与剩余回合时间成比例），在非阻挡逃生或赛后获得极端伤害保护"
	}
}

local wep = {}
lang.WEAPONS = wep

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
		jan1 = "门卫",
		jan = "门卫",
		jan2 = "高级 门卫",
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
		goc = "GOC骇入装置",
	},
	SHORT = {
		general = "一般",
		jan1 = "门卫",
		jan = "门卫",
		jan2 = "高级 门卫",
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
		GENERAL = "一般",
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

RegisterLanguage( lang, "chinese", "cn", "zh-CN" )
