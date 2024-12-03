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
local eq = {}
lang.EQ = eq

eq.eq = "物品栏"  
eq.actions = "动作"  
eq.backpack = "背包"  
eq.id = "这是你的ID，向他人展示它可以表明你的职业和队伍" 
eq.no_id = "你没有ID"  
eq.class = "你的职业："  
eq.team = "你的队伍："  
eq.p_class = "你的伪装职业："  
eq.p_team = "你的伪装队伍："  
eq.allies = "你的盟友："  
eq.durability = "耐久度："  
eq.mobility = "移动性："  
eq.weight = "重量："  
eq.weight_unit = "公斤"  
eq.multiplier = "伤害倍数："  
eq.count = "数量"  
  
lang.eq_unknown = "未知物品"  
lang.durability = "耐久度"  
lang.info = "信息"




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
	guard = "安保部队",
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
		general = "一般",
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
	hazard = "你被SCP杀死了",
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


misc.intercom = {
	name = "广播",
	idle = "广播已就绪",
	active = "广播正在运行\n\n剩余时间: %is",
	cooldown = "广播正在冷却\n\n剩余时间: %is",
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

classes.classd = "D级人员"
classes.veterand = "D级人员-老手子"
classes.kleptod = "D级人员-小偷"
classes.contrad = "D级人员-暴徒"
classes.ciagent = "CI特工"
classes.classd_prestige = "D级人员-窃皮者"
classes.expd = "D级人员-实验体"

classes.sciassistant = "科学家助理"
classes.sci = "科学家"
classes.seniorsci = "高级科学家"
classes.headsci = "首席科学家"
classes.contspec = "收容专家"
classes.sci_prestige = "D级人员-伪装者"

classes.guard = "新进安保"
classes.chief = "安保主管"
classes.lightguard = "轻装安保"
classes.lightcispy = "轻装CI间谍"
classes.heavyguard = "重装安保"
classes.heavycispy = "重装CI间谍"
classes.specguard = "特殊保安"
classes.guardmedic = "安保医护"
classes.tech = "保安炮塔专员"
classes.cispy = "CI间谍"
classes.guard_prestige = "安保工程师"


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
classes.cispec = "混沌分裂工程师"
classes.ciheavy = "混沌分裂重装"
classes.cisniper ="混沌分裂者狙击手"

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
- 与安保和 MTF 合作]]

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
- 向其他安保下达命令]],

	guardmedic = [[- 救援科学家
- 处决所有 D 级和 SCP
- 用你的医疗箱帮助其他安保]],

	tech = [[- 救援科学家
- 处决所有 D 级和 SCP
- 用你的炮塔支援其他安保]],

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
血量：一般
灵活性：一般
作战能力：差
能否逃脱：能
可护送人员：无
能被谁护送：混沌分裂者

人物介绍:
一般D级。 与他人合作来面对 SCP 和设施工作人员。 您可以由混沌分裂者成员护送离开。
]],

	veterand = [[操作难度: 简单
血量: 强壮
灵活性: 灵活
作战能力: 一般
能否逃脱: 能
可护送人员: 无
能被谁护送: 混沌分裂者

人物介绍:
老手D级。 你在设施中有基本的访问权限。 与他人合作以面对 SCP 和设施工作人员。 您可以由混沌分裂者成员护送离开。
]],

	kleptod = [[操作难度: 难
血量: 弱不禁风
灵活性: 敏捷
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 混沌分裂者

人物介绍:
小偷D级。 从一件随机物品开始。 与他人合作以面对 SCP 和设施工作人员。 您可以由混沌分裂者成员护送离开。
]],

	contrad = [[操作难度: 中等
血量: 一般
灵活性: 一般
作战能力: 一般
能否逃脱: 能
可护送人员: 无
能被谁护送: 混沌分裂者

人物介绍:
使用违禁武器。明智地使用它，因为这种武器不耐用。
]],

	ciagent = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 一般
能否逃脱: 无
可护送人员: D级人员
能被谁护送: 无

人物介绍:
配备泰瑟枪。 向D级人员提供帮助并与他们合作。 你可以护送D级人员。
]],

	expd = [[操作难度: ?
血量: ?
灵活性: ?
作战能力: ?
能否逃脱: 不能
可护送人员: D级
能被谁护送: 无

人物介绍:
在设施内进行了一些奇怪实验的D。谁知道实验发生了什么。。。
]],

classd_prestige = [[操作难度: 困难  
血量: 正常  
灵活性: 正常  
作战能力: 高  
能否逃脱: 能  
可护送人员: 无  
能被谁护送: CI 
  
概述：  
看似只是普通的D级人员，但拥有从尸体上偷取衣物的能力。
与他人合作以面对SCP和设施工作人员。你可以由CI成员护送。  
  
创意提供者: Mr.Kiełbasa（竞赛获胜者）  
]],
	sciassistant = [[操作难度: 中等
血量: 一般
灵活性: 一般
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

人物介绍:
一般科学家。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	sci = [[操作难度: 中的
血量: 一般
灵活性: 一般
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

人物介绍:
科学家之一。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	seniorsci = [[操作难度: 简单
血量: 强壮
灵活性: 灵活
作战能力: 一般
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

人物介绍:
科学家之一。 您拥有更高的访问级别。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	headsci = [[操作难度: 简单
血量: 强壮
灵活性: 灵活
作战能力: 一般
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

人物介绍:
最高级的科学家。 你有更好的能力和血量。 与设施工作人员合作并远离 SCP。 您可以由机动特遣队成员护送。
]],

	contspec = [[操作难度: 中等
血量: 强壮
灵活性: 灵活
作战能力: 差
能否逃脱: 能
可护送人员: 无
能被谁护送: 安保人员，机动特遣队

人物介绍:
其中一位拥有高实用性和HP的科学家，也拥有最高的访问级别。与设施工作人员合作远离SCP您可以由机动特遣队成员护送。
]],

sci_prestige = [[难度: 简单  
血量: 低 
灵活性: 高  
作战能力: 差 
能否逃脱: 是  
可护送人员: 无  
能被谁护送: CI
  
概述:  
这是一名冒充科学家的D级人员，他闯入了科学家的更衣室，
偷走了衣服和身份标识。现在，他正试图伪装成科学家，
与D级人员和设施内的普通员工合作。  
  
创意来源: Artieusz (contest winner)  
]],  
	guard = [[操作难度：简单
血量: 一般
灵活性: 一般
作战能力: 一般
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
一般保安。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	lightguard = [[操作难度：难
血量: 弱不禁风
灵活性: 敏捷
作战能力: 差
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
安保之一。 实用性高，没有盔甲，生命值较低。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	heavyguard = [[操作难度: 中等
血量: 强壮
灵活性: 迟钝
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
安保之一。 更低的速度，更好的装甲和更高的健康。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	specguard = [[操作难度: 难
血量: 强壮
灵活性: 迟钝
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
安保之一。 没有那么强的护甲，但有更高的健康和强大的战斗潜力。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	chief = [[操作难度: 简单
血量: 一般
灵活性: 一般
作战能力: 一般
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
安保之一。 战斗力稍好，有泰瑟枪。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	guardmedic = [[操作难度: 难
血量: 强壮
灵活性: 灵活
作战能力: 差
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
安保之一。 你有医疗箱和泰瑟枪。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	tech = [[操作难度: 难
血量: 一般
灵活性: 一般
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
安保之一。 有可放置的炮塔，有 3 种开火模式（在炮塔上按住 E 以查看其菜单）。 利用你的武器和工具帮助其他工作人员并杀死 SCP 和 D 级。你可以护送科学家。
]],

	cispy = [[操作难度: 非常困难
血量: 一般
灵活性: 灵活
作战能力: 一般
能否逃脱: 否
可护送人员：D级人员
能被谁护送: 无

人物介绍:
尝试融入保安人员并帮助D级人员。
]],

lightcispy = [[【操作难度】：非常困难  
【血量】：低  
【灵活性】：高  
【作战能力】：低  
【能否逃脱】：否  
【可护送人员】：D级人员  
【能被谁护送】：无  
  
人物介绍：  
轻装CI间谍。混入安保人员并帮助D级人员。
]],

	heavycispy = [[【操作难度】：非常困难  
【血量】：高  
【灵活性】：低  
【作战能力】：高  
【能否逃脱】：否  
【可护送人员】：D级人员  
【能被谁护送】：无  
  
人物介绍：  
重装CI间谍。拥有更好的护甲和更高的血量。尝试混入保安人员并帮助D级人员。
]],

guard_prestige = [[难度等级：困难
血量：一般
灵活性：一般
作战能力：高
能否逃脱：否
可护送对象：科学家
能被谁护送：无
人物介绍：

安保之一，他配备了一种特殊装置，
能够暂时锁定当前状态下的门，无论是开启还是关闭状态。
这种能力在紧急情况下尤为关键，可以用来封锁SCP的逃脱路径，
或是为其他工作人员创造安全的撤离通道。充分利用手中的武器
协助其他基金会人员，对抗SCP以及D级人员。
灵感来源: F"$LAYER (contest winner)
]],
	ntf_1 = [[操作难度: 中等
血量: 一般
灵活性: 灵活
作战能力: 一般
能否逃脱: 否
可护送人员: 科研人员
能被谁护送：无

人物介绍:
MTF NTF 单位。 配备冲锋枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	ntf_2 = [[操作难度: 中等
血量: 一般
灵活性: 灵活
作战能力: 一般
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF NTF 单位。 使用霰弹枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	ntf_3 = [[操作难度: 中等
血量: 一般
灵活性: 灵活
作战能力: 一般
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF NTF 单位。 手持步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],


	ntfmedic = [[操作难度: 难
血量: 强壮
灵活性: 灵活
作战能力: 差
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF NTF 单位。 手持手枪，有医疗包。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。 
]],

	ntfcom = [[操作难度: 难
血量: 强壮
灵活性: 敏捷
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF NTF 单位。 手持射手步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	ntfsniper = [[操作难度: 难
血量: 一般
灵活性: 一般
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF NTF 单位。 装备狙击步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	alpha1 = [[操作难度: 中等
血量: 超越人类
灵活性: 敏捷
作战能力: 强
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF Alpha-1佩戴重型装甲,配备步枪,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级。
]],

	alpha1sniper = [[操作难度: 难
血量: 高
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF Alpha-1佩戴重型装甲,装备神射手步枪,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级。
]],

	alpha1medic = [[操作难度: 难
血量: 高
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF Alpha-1佩戴重型装甲,可以给其他人提供治疗,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级。
]],

	alpha1com = [[操作难度: 难
血量: 高
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
可护送人员: 科研人员
能被谁护送: 无

人物介绍:
MTF Alpha-1佩戴重型装甲,给设施武装单位下达命令,进入设施并保护设施。帮助里面的设施武装人员杀死SCP和D级.
]],

	ci = [[操作难度: 中等
血量: 强壮
灵活性: 灵活
作战能力: 一般
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

人物介绍:
混沌分裂者单位。 进入设施并帮助 D 级人员并杀死设施工作人员。
]],

	cicom = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

人物介绍:
混沌分裂者单位。 更高的战斗力。 进入设施，帮助 D 级人员并杀死设施工作人员。
]],

	cimedic = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

人物介绍:
混沌分裂者单位,更高的战斗力,进入设施.使用您的药包帮助其他CI 帮助 D 级人员并杀死设施工作人员。
]],

cisniper = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

人物介绍:
混沌分裂者单位,更高的战斗力,进入设施.帮助 D 级人员并杀死设施工作人员
]],

	cispec = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

人物介绍:
混沌分裂者单位,更高的战斗力,进入设施.帮助 D 级人员并杀死设施工作人员
]],

	ciheavy = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 强
能否逃脱: 否
可护送人员: D级人员
能被谁护送: 无

人物介绍:
混沌分裂者单位,更高的战斗力,进入设施.提供火力压制 帮助 D 级人员并杀死设施工作人员
]],

	goc = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 高
能否逃脱: 无
可护送人员: 无
能被谁护送: 无

人物介绍:
全球超自然联盟的士兵。销毁所有SCP，使用您的个人平板电脑定位之前传送到设施的GOC设备，然后部署并保护它。成功部署设备后逃脱。
]],

	gocmedic = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 高
能否逃脱: 无
可护送人员: 无
能被谁护送: 无

人物介绍:
全球超自然联盟的医疗兵。销毁所有SCP，使用你的医疗包帮助队友,使用您的个人平板电脑定位之前传送到设施的GOC设备，然后部署并保护它。成功部署设备后逃脱
]],

	goccom = [[操作难度: 中等
血量: 高
灵活性: 灵活
作战能力: 高
能否逃脱: 无
可护送人员: 无
能被谁护送: 无

人物介绍:
全球超自然联盟的指挥官。带领你的队伍,销毁所有SCP，使用您的个人平板电脑定位之前传送到设施的GOC设备，然后部署并保护它。成功部署设备后逃脱
]],
SCP0492 = [[
由SCP-049创造的僵尸。分为以下类型之一：

普通僵尸：
难度：简单 | 血量：普通 | 敏捷性：普通 | 伤害：普通
一种各项属性均衡的不错选择

刺客僵尸：
难度：中等 | 血量：低 | 敏捷性：高 | 伤害：普通/高
速度最快，但生命值和伤害最低

爆炸僵尸：
难度：中等 | 血量：高 | 敏捷性：低 | 伤害：普通/高
移动速度最慢，但拥有高生命值和最高伤害

吐痰僵尸：
难度：中等 | 血量：高 | 敏捷性：低 | 伤害：普通/高
速度最慢的僵尸类型，但拥有高伤害和最多的生命值
]],
SCP023 = [[
体力汲取
开始从附近的玩家身上汲取体力。如果所有玩家都离开该区域
该能力会立即进入冷却时间
克隆
放置一个克隆体，它会模仿你的被动技能（包括升级效果）。
克隆体会四处游荡并追逐附近的玩家
猎杀
立即杀死你的一个猎物或他们附近的人，并传送到他们的尸体处
被动:与玩家碰撞会点燃他们
]],



SCP066 = [[
Eric？
你问未携带武器的玩家他们是否是Eric.
每次询问都会获得一个被动叠加层。
第二交响曲
当你感到威胁时，可以发出大声的音乐。
冲刺
向前冲刺。如果击中玩家，你会短暂地附着在他们身上。
增益
获得当前激活的三个增益效果中的一个。
使用后，它将被下一个增益效果替换。
每个被动叠加层都会增加所有增益效果的威力
]],

SCP106 = [[
牙齿收集
子弹不能杀死你，但它们可以暂时将你击倒，你还可以穿过门。
触摸玩家会将其传送到口袋维度。
每个被传送到口袋维度的玩家会给予你一个牙齿。
收集的牙齿会增强你的枯萎能力
枯萎
对目标施加枯萎效果。枯萎会逐渐减缓目标的速度。
攻击处于口袋维度内的目标会立即杀死它们。
传送
用来放置传送点。当靠近已有的传送点时，
你可以选择传送目的地，释放以传送到选定位置
陷阱
在墙上放置陷阱。当陷阱被触发时，目标会被减速，
你可以再次使用这个能力立即传送到陷阱位置
]],

SCP173 = [[
毒气
释放刺激性毒气云，减缓附近玩家的速度，
遮挡视线并增加他们的眨眼频率
诱饵
放置诱饵分散玩家注意力并消耗他们的理智
潜行
进入潜行模式。在潜行模式下，你是隐形的，可以穿过门。
此外，你变得无敌（但范围伤害如爆炸仍能对你造成伤害），
但你无法对玩家造成伤害，也无法与世界互动
]],

SCP457 = [[
被动技能
你接触到的所有人都会被点燃。点燃玩家会为你增加燃料，
火球术
消耗一些燃料发射一个火球，它会一直向前飞行直到碰到物体
陷阱
消耗一些燃料放置一个陷阱，触碰到它的玩家会被点燃
怒火中烧
在周围生成一圈火焰波，技能无限范围，
每一圈后续的火焰会消耗更多燃料
]],

SCP682 = [[
基础攻击
用手直接在前方进行攻击，造成少量伤害
撕咬
按住键准备一次强力攻击，将在前方锥形区域内造成大量伤害
冲锋
经过短暂延迟后向前冲锋，变得势不可挡。
当达到全速时，消灭路径上的所有敌人，
并获得穿透大多数门的能力。
此技能需要在升级树中解锁
护盾
护盾可以吸收任何非直接/坠落伤害。
此能力受技能树中购买的升级影响
]],

SCP8602 = [[
被动技能
你能看到进入你森林范围内的玩家，
并在他们离开一段时间后仍能看到。
森林内的玩家会失去理智，如果理智耗尽，则会损失生命值。
从森林内玩家身上获取的理智/生命值可以为你治疗，
这种治疗可以超过你的最大生命值
防御姿态
按住以激活。在按住期间，
随时间获得保护效果，但移动速度也会减慢。
松开后向前冲刺，并对减免的伤害按一定的比例造成等量伤害。
此能力没有持续时间限制
冲锋
随时间增加速度，并对前方第一个玩家造成伤害。
如果被攻击的玩家离墙壁足够近，则将其钉在墙上以增加伤害
]],

SCP939 = [[
被动技能
你看不见玩家，但你可以看见声波。
你周围有ANM-C227光环
啃咬
咬伤你前方锥形区域内的所有人
ANM-C227
按住键位在你身后留下ANM-C227轨迹
探测
开始探测你周围的玩家
]],

SCP966 = [[
疲劳
偶尔会对附近的玩家施加疲劳累积。你每施加一层疲劳累积，也会获得一层被动累积
基础攻击
执行基础攻击。你只能攻击拥有至少10层疲劳累积的玩家。
被攻击的玩家会失去一些疲劳累积。此攻击的效果受技能树影响
引导
引导技能树中选定的能力
死亡标记
标记玩家。被标记的玩家会从附近其他玩家那里转移疲劳累积到自己身上
]],
SCP24273 = [[
法官/检察官
在法官和检察官模式之间切换
法官
你对目标造成的伤害会根据累积的证据增加。
攻击目标会降低证据等级。
攻击拥有满额证据的玩家会立即杀死他们
检察官
你的速度减慢，并且获得子弹伤害保护。
注视玩家可以收集他们的证据
冲刺/伪装
法官
向前冲刺，对路径上的所有人造成伤害
检察官
启用伪装。伪装期间你更难被发现。
使用技能、移动或受到伤害会中断伪装
审查/监视
法官
开始锁定目标玩家一段时间。完全施放后，减速目标并造成伤害。
如果失去视线，技能会被中断，并且你会被减速
检察官
离开你的身体，从附近随机玩家的视角观察。
你的被动技能也会从该玩家的视角生效
审判/幽灵
法官
站在原地，迫使附近的所有人走向你。
结束时，近距离的玩家会受到伤害并被击退
检察官
进入幽灵形态。
在幽灵形态下，你免疫所有伤害（爆炸和直接伤害除外）
]],
SCP3199 = [[
被动
在狂暴状态下，可以看到附近没有深度创伤的玩家的位置。
获得狂暴层数也会获得被动层数
攻击
执行基础攻击。击中目标会激活（或刷新）狂暴状态，
施加深度创伤效果，并获得被动层数和狂暴层数。
超越攻击
在连续数次成功攻击后激活。使用该技能立即结束狂暴状态，
并对所有带有深度创伤的玩家造成伤害。受影响玩家也会被减速
蛋
击杀玩家后可以孵化蛋。
当您受到致命伤害时，将在随机蛋的位置复活。复活会消耗一个蛋。
]],



}


--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "重见天日",
		info = "在地面上时获得被动治疗,与剩余时间正比\n在逃脱时获得极高伤害保护"
	}
}

local wep = {}
lang.WEAPONS = wep

lang.CommonSkills = {  
    c_button_overload = {  
        name = "过载",  
        dsc = "允许你过载大多数上锁的门。过载的门会在短时间内打开（或关闭）"  
    },  
    c_dmg_mod = {  
        name = "伤害防护",  
        dsc = "当前防护：[mod]\n\n这是对接收到的非直接伤害的保护。它仅考虑时间缩放和外部增益的修正器。不包括SCP特定的修正器！"  
    },  
}

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
wep.SCP023 = {  
	skills = {  
		_overview = { "被动", "汲取", "克隆", "猎杀" },  
		drain = {  
			name = "体力汲取",  
			dsc = "开始从附近的玩家身上汲取体力。如果所有玩家都离开该区域，该能力会立即进入冷却时间",  
		},  
		clone = {  
			name = "克隆",  
			dsc = "放置一个克隆体，它会模仿你的被动技能（包括升级效果）的工作。克隆体会四处游荡并追逐附近的玩家",  
		},  
		hunt = {  
			name = "猎杀",  
			dsc = "立即杀死你的一个猎物或他们附近的人，并传送到他们的尸体处",  
		},  
		passive = {  
			name = "被动",  
			dsc = "与玩家碰撞会点燃他们",  
		},  
		drain_bar = {  
			name = "汲取",  
			dsc = "汲取能力的剩余时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive = {  
			name = "炽热余烬",  
			info = "升级你的被动技能，增加燃烧伤害[+burn_power]",  
		},  
		invis1 = {  
			name = "隐形火焰I",  
			info = "增强你的被动技能\n\t• 远离你的玩家将看不见你\n\t• 看不见你的玩家不会被添加到猎杀目标中\n\t• 此升级同样适用于你的克隆体\n\t• 在[invis_range]单位距离外你会完全隐形",  
		},  
		invis2 = {  
			name = "隐形火焰II",  
			info = "升级你的隐形能力\n\t• 在[invis_range]单位距离外你会完全隐形",  
		},  
		prot1 = {  
			name = "不死之火I",  
			info = "通过提供[-prot]的子弹伤害防护来增强你的被动技能",  
		},  
		prot2 = {  
			name = "不死之火II",  
			info = "将你对子弹的防护升级到[-prot]",  
		},  
		drain1 = {  
			name = "能量汲取I",  
			info = "升级你的汲取能力\n\t• 持续时间增加[+drain_dur]\n\t• 最大距离增加[+drain_dist]",  
		},  
		drain2 = {  
			name = "能量汲取II",  
			info = "升级你的汲取能力\n\t• 汲取速率增加[/drain_rate]\n\t• 从汲取的体力中恢复[%drain_heal]的生命值",  
		},  
		drain3 = {  
			name = "能量汲取III",  
			info = "升级你的汲取能力\n\t• 持续时间增加[+drain_dur]\n\t• 最大距离增加[+drain_dist]",  
		},  
		drain4 = {  
			name = "能量汲取IV",  
			info = "升级你的汲取能力\n\t• 汲取速率增加[/drain_rate]\n\t• 从汲取的体力中恢复[%drain_heal]的生命值",  
		},  
		hunt1 = {  
			name = "无尽火焰I",  
			info = "增强你的猎杀能力\n\t• 冷却时间减少[-hunt_cd]",  
		},  
		hunt2 = {  
			name = "无尽火焰II",  
			info = "增强你的猎杀能力\n\t• 冷却时间减少[-hunt_cd]\n\t• 随机猎物搜索半径增加[+hunt_range]",  
		},  
	}  
}
wep.SCP049 = {  
    -- 僵尸类型  
    zombies = {  
        normal = "普通僵尸",  
        assassin = "刺客僵尸",  
        boomer = "爆炸僵尸",  
        heavy = "吐痰僵尸",  
    },  
    -- 僵尸描述  
    zombies_desc = {  
        normal = "一种标准僵尸\n\t• 拥有轻攻击和重攻击\n\t• 属性均衡，是不错的选择",  
        assassin = "一种刺客僵尸\n\t• 拥有轻攻击和快速攻击能力\n\t• 速度最快，但生命值和伤害最低",  
        boomer = "一种爆炸型重型僵尸\n\t• 拥有重攻击和爆炸能力\n\t• 移动速度最慢，但拥有高生命值和最高伤害",  
        heavy = "一种吐痰型重型僵尸\n\t• 拥有重攻击和射击能力\n\t• 速度最慢的僵尸类型，但拥有高伤害和最多的生命值",  
    },  
    -- 技能  
    skills = {  
        _overview = { "passive", "choke", "surgery", "boost" },  
        surgery_failed = "手术失败！",  
  
        choke = {  
            name = "医生的触摸",  
            dsc = "扼喉致死。此技能在受到足够伤害时可以被打断",  
        },  
        surgery = {  
            name = "手术",  
            dsc = "对尸体进行手术，将其转变为SCP-049-2实例。受到伤害会打断手术",  
        },  
        boost = {  
            name = "复苏！",  
            dsc = "为你和所有附近的SCP-049-2实例提供强化",  
        },  
        passive = {  
            name = "被动",  
            dsc = "附近的僵尸获得子弹伤害保护",  
        },  
        choke_bar = {  
            name = "医生的触摸",  
            dsc = "满值时，目标死亡",  
        },  
        surgery_bar = {  
            name = "手术",  
            dsc = "手术的剩余时间",  
        },  
        boost_bar = {  
            name = "复苏！",  
            dsc = "强化的剩余时间",  
        },  
    },  
  
    -- 升级  
    upgrades = {  
        parse_description = true,  
  
        choke1 = {  
            name = "医生的触摸 I",  
            info = "升级你的扼喉能力\n\t• 冷却时间减少[-choke_cd]\n\t• 伤害阈值增加[+choke_dmg]",  
        },  
        choke2 = {  
            name = "医生的触摸 II",  
            info = "升级你的扼喉能力\n\t• 扼喉速度增加[+choke_rate]\n\t• 扼喉后的减速效果减少[-choke_slow]",  
        },  
        choke3 = {  
            name = "医生的触摸 III",  
            info = "升级你的扼喉能力\n\t• 冷却时间减少[-choke_cd]\n\t• 伤害阈值增加[+choke_dmg]\n\t• 扼喉速度增加[+choke_rate]",  
        },  
        buff1 = {  
            name = "复苏 I",  
            info = "升级你的强化能力\n\t• 冷却时间减少[-buff_cd]\n\t• 强化持续时间增加[+buff_dur]",  
        },  
        buff2 = {  
            name = "复苏 II",  
            info = "升级你的强化能力\n\t• 强化范围增加[+buff_radius]\n\t• 强化威力增加[+buff_power]",  
        },  
        surgery_cd1 = {  
            name = "精准手术 I",  
            info = "手术时间减少[surgery_time]秒\n\t• 此升级可叠加",  
        },  
        surgery_cd2 = {  
            name = "精准手术 II",  
            info = "手术时间减少[surgery_time]秒\n\t• 此升级可叠加",  
        },  
        surgery_heal = {  
            name = "移植",  
            info = "升级你的手术能力\n\t• 手术后，你恢复[surgery_heal]点生命值\n\t• 手术后，所有附近的僵尸恢复[surgery_zombie_heal]点生命值",  
        },  
        surgery_dmg = {  
            name = "无法阻挡的手术",  
            info = "受到伤害不再打断手术",  
        },  
        surgery_prot = {  
            name = "稳健之手",  
            info = "手术期间获得[-surgery_prot]的子弹保护",  
        },  
        zombie_prot = {  
            name = "护士",  
            info = "每个附近的SCP-049-2为你提供子弹伤害保护\n\t• 每个附近僵尸提供的保护：[%zombie_prot]\n\t• 最大保护：[%zombie_prot_max]",  
        },  
        zombie_lifesteal = {  
            name = "输血 I",  
            info = "僵尸的普通攻击获得[%zombie_ls]的生命偷取",  
        },  
        stacks_hp = {  
            name = "类固醇注射",  
            info = "创建僵尸时，其生命值根据\n先前的手术次数增加[%stacks_hp]",  
        },  
        stacks_dmg = {  
            name = "激进疗法",  
            info = "创建僵尸时，其伤害根据\n先前的手术次数增加[%stacks_dmg]",  
        },  
        zombie_heal = {  
            name = "输血 II",  
            info = "你从附近僵尸造成的任何伤害中\n恢复[%zombie_heal]的生命值",  
        }  
    }  
}

wep.SCP0492 = {  
    skills = {  
        prot = {  
            name = "防护",  
            dsc = "靠近SCP-049时，你将获得一定的伤害防护",  
        },  
        boost = {  
            name = "增益",  
            dsc = "指示SCP-049的增益效果是否在你身上激活",  
        },  
        light_attack = {  
            name = "轻攻击",  
            dsc = "执行轻攻击",  
        },  
        heavy_attack = {  
            name = "重攻击",  
            dsc = "执行重攻击",  
        },  
        rapid = {  
            name = "速攻",  
            dsc = "执行快速攻击",  
        },  
        shot = {  
            name = "射击",  
            dsc = "发射伤害性投射物",  
        },  
        explode = {  
            name = "自爆",  
            dsc = "当你有50点或更少的生命值时激活。你将变得无法被杀死并获得速度增益。短暂时间后，你将爆炸，对小范围内造成伤害",  
        },  
        boost_bar = {  
            name = "增益条",  
            dsc = "剩余的增益时间",  
        },  
        explode_bar = {  
            name = "自爆条",  
            dsc = "剩余的自爆时间",  
        },  
    },  
  
    upgrades = {  
        parse_description = true,  
  
        primary1 = {  
            name = "主攻击I",  
            info = "升级你的主攻击\n\t• 冷却时间减少[-primary_cd]",  
        },  
        primary2 = {  
            name = "主攻击II",  
            info = "升级你的主攻击\n\t• 冷却时间减少[-primary_cd]\n\t• 伤害增加[+primary_dmg]",  
        },  
        secondary1 = {  
            name = "次攻击I",  
            info = "升级你的次攻击\n\t• 伤害增加[+secondary_dmg]",  
        },  
        secondary2 = {  
            name = "次攻击II",  
            info = "升级你的次攻击\n\t• 伤害增加[+secondary_dmg]\n\t• 冷却时间减少[-secondary_cd]",  
        },  
        overload = {  
            name = "过载",  
            info = "额外获得[overloads]次按钮过载",  
        },  
        buff = {  
            name = "崛起！",  
            info = "增强你的防护和SCP-049的增益\n\t• 防护力量：[%+prot_power]\n\t• 增益力量：[++buff_power]",  
        },  
    }  
}
wep.SCP058 = {  
    -- 技能集合  
    skills = {  
        _overview = { "primary_attack", "shot", "explosion" }, -- 技能概览，包括主攻击、射击和爆炸  
          
        primary_attack = {  
            name = "主攻击",  
            dsc = "使用前方的蜇刺进行攻击。\n如果购买了相应的升级，将附加中毒效果",  
        },  
          
        shot = {  
            name = "射击",  
            dsc = "向瞄准方向发射投射物。投射物将沿弹道曲线移动。\n与射击相关的升级会影响此技能的冷却时间、速度、大小和效果",  
        },  
          
        explosion = {  
            name = "爆炸",  
            dsc = "释放一股被腐蚀的血液，对附近的目标造成大量伤害",  
        },  
          
        shot_stacks = {  
            name = "射击堆叠",  
            dsc = "显示存储的射击数量。各种与射击相关的升级会影响最大数量和冷却时间",  
        },  
    },  
  
    -- 升级集合  
    upgrades = {  
        parse_description = true, -- 是否解析描述信息  
  
        -- 攻击升级  
        attack1 = {  
            name = "毒刺I",  
            info = "为主攻击添加中毒效果",  
        },  
          
        attack2 = {  
            name = "毒刺II",  
            info = "增强攻击伤害、中毒伤害并减少冷却时间\n\t• 攻击伤害增加[prim_dmg]\n\t• 攻击中毒伤害为[pp_dmg]\n\t• 冷却时间减少[prim_cd]秒",  
        },  
          
        attack3 = {  
            name = "毒刺III",  
            info = "增强中毒伤害并减少冷却时间\n\t• 如果目标未中毒，立即施加2层中毒效果\n\t• 攻击中毒伤害为[pp_dmg]\n\t• 冷却时间减少[prim_cd]秒",  
        },  
          
        -- 射击升级  
        shot = {  
            name = "腐血射击",  
            info = "为射击攻击添加中毒效果",  
        },  
          
        shot11 = {  
            name = "激增I",  
            info = "增加伤害和投射物大小\n但也会增加冷却时间并减慢投射物速度\n\t• 投射物伤害增加[+shot_damage]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化[++shot_speed]\n\t• 冷却时间增加[shot_cd]秒",  
        },  
		shot12 = {  
			name = "激流II",  
			info = "增加伤害和投射物大小\n但也会增加冷却时间并减慢投射物速度\n\t• 投射物伤害增加：[+shot_damage]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化：[++shot_speed]\n\t• 冷却时间增加：[shot_cd]秒"  
		}, 
          
        shot21 = {  
            name = "血雾I",  
            info = "射击在撞击时留下迷雾，伤害并中毒接触到的所有人。\n\t• 移除直接伤害和溅射伤害\n\t• 迷雾接触时造成[cloud_damage]伤害\n\t• 迷雾造成的中毒伤害为[sp_dmg]\n\t• 射击堆叠限制为[stacks]\n\t• 冷却时间增加[shot_cd]秒\n\t• 堆叠获取速率：[/+regen_rate]",  
        },  
          
        shot22 = {  
            name = "血雾II",  
            info = "增强射击留下的迷雾效果。\n\t• 迷雾接触时造成[cloud_damage]伤害\n\t• 迷雾造成的中毒伤害为[sp_dmg]\n\t• 堆叠获取速率：[/+regen_rate]",  
        },  
          
        shot31 = {  
            name = "连射I",  
            info = "按住攻击按钮时，可以迅速射击\n\t• 解锁快速射击能力\n\t• 移除直接伤害和溅射伤害\n\t• 射击堆叠限制为[stacks]\n\t• 堆叠获取速率：[/+regen_rate]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化[++shot_speed]",  
        },  
          
        shot32 = {  
            name = "连射II",  
            info = "增加最大堆叠数量和射击速度\n\t• 射击堆叠限制为[stacks]\n\t• 堆叠获取速率：[/+regen_rate]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化[++shot_speed]",  
        },  
          
        -- 爆炸升级  
        exp1 = {  
            name = "主动脉爆裂",  
            info = "解锁爆炸能力\n对附近目标造成大量伤害。\n当生命值首次降至每个1000HP的倍数以下时\n此能力激活。如果购买时生命值已低于1000HP\n则首次受到伤害时激活此能力\n之前的阈值无法再达到（即使通过治疗）",  
        },  
          
        exp2 = {  
            name = "毒爆",  
            info = "增强你的爆炸能力\n\t• 施加2层中毒效果\n\t• 爆炸半径增加[+explosion_radius]",  
        },  
    }  
}

-- wep.SCP066配置  
wep.SCP066 = {  
	-- 技能集合  
	skills = {  
		_overview = { "埃里克", "音乐", "冲刺", "增益" }, -- 技能概览，包括eric、music、dash和boost四个技能  
		not_threatened = "你并未感到足够的威胁来发动攻击！", -- 当未受到足够威胁时的提示  
  
		-- 发出大声音乐的技能  
		music = {  
			name = "第二交响曲",  
			dsc = "当你感到威胁时，可以发出大声的音乐。", -- 技能描述  
		},  
		-- 冲刺技能  
		dash = {  
			name = "冲刺",  
			dsc = "向前冲刺。如果击中玩家，你会短暂地附着在他们身上。", -- 技能描述  
		},  
		-- 增益技能  
		boost = {  
			name = "增益",  
			dsc = "获得当前激活的三个增益效果中的一个。使用后，它将被下一个增益效果替换。每个被动叠加层都会增加所有增益效果的威力（最多可叠加[cap]层）。\n\n当前增益：[boost]\n\n速度增益：[speed]\n子弹防御增益：[def]\n再生增益：[regen]", -- 技能描述，包含多个增益效果和它们的当前状态  
			buffs = { -- 增益效果的列表  
				"速度",  
				"子弹防御",  
				"再生",  
			},  
		},  
		-- 询问玩家是否为Eric的技能  
		eric = {  
			name = "Eric？",  
			dsc = "你问未携带武器的玩家他们是否是Eric。每次询问都会获得一个被动叠加层。", -- 技能描述  
		},  
		-- 音乐技能的持续时间条  
		music_bar = {  
			name = "第二交响曲",  
			dsc = "此技能的剩余时间。", -- 技能条描述  
		},  
		-- 冲刺技能的附着时间条  
		dash_bar = {  
			name = "附着时间",  
			dsc = "附着到目标上的剩余时间。", -- 技能条描述  
		},  
		-- 增益技能的持续时间条  
		boost_bar = {  
			name = "增益",  
			dsc = "此技能的剩余时间。", -- 技能条描述  
		},  
	},  
  
	-- 升级集合  
	upgrades = {  
		parse_description = true, -- 是否解析描述（可能是用于动态生成描述文本）  
  
		-- Eric？技能的第一次升级  
		eric1 = {  
			name = "Eric？I",  
			info = "减少被动技能的冷却时间[-eric_cd]。", -- 升级描述  
		},  
		-- Eric？技能的第二次升级  
		eric2 = {  
			name = "Eric？II",  
			info = "减少被动技能的冷却时间[-eric_cd]。", -- 升级描述（注意：这里与eric1的描述相同，可能是个错误或遗漏，实际游戏中应有不同效果）  
		},  
		-- 第二交响曲技能的第一次升级  
		music1 = {  
			name = "第二交响曲I",  
			info = "升级你的主要攻击\n\t• 冷却时间减少[-music_cd]\n\t• 范围增加[+music_range]。", -- 升级描述  
		},  
		-- 第二交响曲技能的第二次升级  
		music2 = {  
			name = "第二交响曲II",  
			info = "升级你的主要攻击\n\t• 冷却时间减少[-music_cd]\n\t• 范围增加[+music_range]。", -- 升级描述（注意：这里与music1的描述相同，可能是个错误或遗漏，实际游戏中应有不同效果）  
		},  
		-- 第二交响曲技能的第三次升级  
		music3 = {  
			name = "第二交响曲III",  
			info = "升级你的主要攻击\n\t• 伤害增加[+music_damage]。", -- 升级描述  
		},  
		-- 冲刺技能的第一次升级  
		dash1 = {  
			name = "冲刺I",  
			info = "升级你的冲刺能力\n\t• 冷却时间减少[-dash_cd]\n\t• 你在目标上停留的时间增加[+detach_time]。", -- 升级描述  
		},  
		-- 冲刺技能的第二次升级  
		dash2 = {  
			name = "冲刺II",  
			info = "升级你的冲刺能力\n\t• 冷却时间减少[-dash_cd]\n\t• 你在目标上停留的时间增加[+detach_time]。", -- 升级描述（注意：这里与dash1的描述相同，可能是个错误或遗漏，实际游戏中应有不同效果）  
		},  
		-- 冲刺技能的第三次升级  
		dash3 = {  
			name = "冲刺III",  
			info = "升级你的冲刺能力\n\t• 当附着在目标上时，你可以再次使用此技能来跳离\n\t• 在跳离时，你可以附着到另一个玩家身上\n\t• 在单次使用此技能的过程中，你不能再次附着到同一个玩家身上。", -- 升级描述  
		},  
		-- 增益技能的第一次升级  
		boost1 = {  
			name = "增益I",  
			info = "升级你的增益能力\n\t• 冷却时间减少[-boost_cd]\n\t• 持续时间增加[+boost_dur]。", -- 升级描述  
		},  
		-- 增益技能的第二次升级  
		boost2 = {  
			name = "增益II",  
			info = "升级你的增益能力\n\t• 冷却时间减少[-boost_cd]\n\t• 威力增加[+boost_power]。", -- 升级描述  
		},  
		-- 增益技能的第三次升级  
		boost3 = {  
			name = "增益III",  
			info = "升级你的增益能力\n\t• 持续时间增加[+boost_dur]\n\t• 威力增加[+boost_power]。", -- 升级描述  
		},  
	}  
}
wep.SCP096 = {  
	skills = {  
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {  
			name = "猛扑",  
			dsc = "在愤怒状态下向前猛扑。立即结束愤怒状态。猛扑后不会吞噬尸体",  
		},  
		regen = {  
			name = "再生",  
			dsc = "原地坐下，将再生层数转化为生命值",  
		},  
		special = {  
			name = "狩猎结束",  
			dsc = "停止愤怒状态。为每个活跃目标获得再生层数",  
		},  
		passive = {  
			name = "被动",  
			dsc = "如果有人看你，你会变得愤怒。你会立即杀死使你愤怒的玩家",  
		},  
	},  
  
	upgrades = {  
		parse_description = true, -- 解析描述，保留原样，因为这是一个编程指令，不需要翻译  
  
		rage = {  
			name = "愤怒",  
			info = "在[rage_time]秒内从单个玩家那里\n受到[rage_dmg]伤害会让你愤怒",  
		},  
		heal1 = {  
			name = "吞噬I",  
			info = "杀死目标后，吞噬目标的尸体\n并在持续时间内获得子弹防护\n\t• 每刻治疗：[heal]\n\t• 治疗刻数：[heal_ticks]\n\t• 子弹伤害防护：[-prot]",  
		},  
		heal2 = {  
			name = "吞噬II",  
			info = "升级你的吞噬能力\n\t• 每刻治疗：[heal]\n\t• 治疗刻数：[heal_ticks]\n\t• 子弹伤害防护：[-prot]",  
		},  
		multi1 = {  
			name = "无尽愤怒I",  
			info = "在首次击杀后的有限时间内\n允许你在愤怒状态下杀死多个目标\n\t• 最大目标数：[multi]\n\t• 时间限制：[multi_time]秒\n\t• 杀死第一个目标后子弹伤害增加：[+prot]",  
		},  
		multi2 = {  
			name = "无尽愤怒II",  
			info = "允许你在愤怒状态下杀死更多目标\n\t• 最大目标数：[multi]\n\t• 时间限制：[multi_time]秒\n\t• 杀死第一个目标后子弹伤害增加：[+prot]",  
		},  
		regen1 = {  
			name = "绝望之哭I",  
			info = "升级你的再生能力\n\t• 治疗增加：[+regen_mult]",  
		},  
		regen2 = {  
			name = "绝望之哭II",  
			info = "升级你的再生能力\n\t• 层数获得速率增加：[/regen_stacks]",  
		},  
		regen3 = {  
			name = "绝望之哭III",  
			info = "升级你的再生能力\n\t• 治疗增加：[+regen_mult]\n\t• 层数获得速率增加：[/regen_stacks]",  
		},  
		spec1 = {  
			name = "怜悯I",  
			info = "升级你的特殊技能并增加理智消耗\n\t• 获得更多层数：[+spec_mult]\n\t• 理智消耗：[sanity]",  
		},  
		spec2 = {  
			name = "怜悯II",  
			info = "升级你的特殊技能\n\t• 获得更多层数：[+spec_mult]\n\t• 理智消耗：[sanity]",  
		},  
	}  
}

-- SCP106 配置表  
wep.SCP106 = {  
	cancel = "按 [%s] 取消",  -- 取消操作的提示信息  
  
	skills = {  
		_overview = { "passive", "withering", "teleport", "trap" },  -- 技能概览  
		withering = {  
			name = "枯萎",  
			dsc = "对目标施加枯萎效果。枯萎会逐渐减缓目标的速度。攻击处于口袋维度内的目标会立即杀死它们\n\n效果持续时间 [dur]\n最大减速: [slow]",  
		},  
		trap = {  
			name = "陷阱",  
			dsc = "在墙上放置陷阱。当陷阱被触发时，目标会被减速，你可以再次使用这个能力立即传送到陷阱位置",  
		},  
		teleport = {  
			name = "传送",  
			dsc = "用来放置传送点。当靠近已有的传送点时，你可以选择传送目的地，释放以传送到选定位置",  
		},  
		passive = {  
			name = "牙齿收集",  
			dsc = "子弹不能杀死你，但它们可以暂时将你击倒，你还可以穿过门。\n触摸玩家会将其传送到口袋维度。每个被传送到口袋维度的玩家会给予你一个牙齿。收集的牙齿会增强你的枯萎能力",  
		},  
		teleport_cd = {  
			name = "传送",  
			dsc = "显示传送点的冷却时间",  
		},  
		passive_bar = {  
			name = "牙齿收集",  
			dsc = "当这个条达到零时，你会被击倒",  
		},  
		trap_bar = {  
			name = "陷阱",  
			dsc = "显示陷阱将保持激活状态的时间"  
		}  
	},  
  
	upgrades = {  
		parse_description = true,  -- 解析描述信息  
  
		-- 被动技能升级  
		passive1 = {  
			name = "牙齿收集 I",  
			info = "升级你的被动能力\n\t• 增加将你击倒所需的伤害量 [+passive_dmg]\n\t• 减少击倒眩晕时间 [-passive_cd]",  
		},  
		passive2 = {  
			name = "牙齿收集 II",  
			info = "升级你的被动能力\n\t• 增加将你击倒所需的伤害量 [+passive_dmg]\n\t• 对玩家造成的伤害增加 [+teleport_dmg]",  
		},  
		passive3 = {  
			name = "牙齿收集 III",  
			info = "升级你的被动能力\n\t• 增加将你击倒所需的伤害量 [+passive_dmg]\n\t• 减少击倒眩晕时间 [-passive_cd]\n\t• 对玩家造成的伤害增加 [+teleport_dmg]",  
		},  
		-- 枯萎技能升级  
		withering1 = {  
			name = "枯萎 I",  
			info = "升级你的枯萎能力\n\t• 冷却时间减少 [-attack_cd]\n\t• 效果基础持续时间增加 [+withering_dur]",  
		},  
		withering2 = {  
			name = "枯萎 II",  
			info = "升级你的枯萎能力\n\t• 冷却时间减少 [-attack_cd]\n\t• 效果基础减速增加 [+withering_slow]",  
		},  
		withering3 = {  
			name = "枯萎 III",  
			info = "升级你的枯萎能力\n\t• 冷却时间减少 [-attack_cd]\n\t• 效果基础持续时间增加 [+withering_dur]\n\t• 效果基础减速增加 [+withering_slow]",  
		},  
		-- 传送技能升级  
		tp1 = {  
			name = "传送 I",  
			info = "升级你的传送能力\n\t• 最大传送点数量增加 [spot_max]\n\t• 传送点冷却时间减少 [-spot_cd]",  
		},  
		tp2 = {  
			name = "传送 II",  
			info = "升级你的传送能力\n\t• 最大传送点数量增加 [spot_max]\n\t• 传送冷却时间减少 [-tp_cd]",  
		},  
		tp3 = {  
			name = "传送 III",  
			info = "升级你的传送能力\n\t• 最大传送点数量增加 [spot_max]\n\t• 传送点冷却时间减少 [-spot_cd]\n\t• 传送冷却时间减少 [-tp_cd]",  
		},  
		-- 陷阱技能升级  
		trap1 = {  
			name = "陷阱 I",  
			info = "升级你的陷阱能力\n\t• 陷阱冷却时间减少 [-trap_cd]\n\t• 陷阱持续时间增加 [+trap_life]",  
		},  
		trap2 = {  -- 注意：原配置中 trap2 的描述与 trap1 相同，这可能是一个错误或遗漏，实际使用中应予以修正  
			name = "陷阱 II",   
			info = "升级你的陷阱能力\n\t• 陷阱冷却时间减少 [-trap_cd]\n\t• 陷阱持续时间增加 [+trap_life]",  -- 示例信息，实际应根据游戏需求进行填写  
		},  
	
	}  
}

local scp173_prot = {  
	name = "加固混凝土",  
	info = "• 获得[%prot]的子弹伤害减免\n• 此能力与同类型的其他技能叠加",  
}  
  
wep.SCP173 = {  
	restricted = "限制使用！",  
  
	skills = {  
		_overview = { "毒气", "诱饵", "潜行" },  
		gas = {  
			name = "毒气",  
			dsc = "释放刺激性毒气云，减缓附近玩家的速度，遮挡视线并增加他们的眨眼频率",  
		},  
		decoy = {  
			name = "诱饵",  
			dsc = "放置诱饵分散玩家注意力并消耗他们的理智",  
		},  
		stealth = {  
			name = "潜行",  
			dsc = "进入潜行模式。在潜行模式下，你是隐形的，可以穿过门。此外，你变得无敌（但范围伤害如爆炸仍能对你造成伤害），但你无法对玩家造成伤害，也无法与世界互动",  
		},  
		looked_at = {  
			name = "冻结！",  
			dsc = "显示是否有人正在看你",  
		},  
		next_decoy = {  
			name = "诱饵堆叠",  
			dsc = "可用的诱饵数量",  
		},  
		stealth_bar = {  
			name = "潜行",  
			dsc = "潜行能力的剩余时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		horror_a = {  
			name = "压迫性存在",  
			info = "恐怖范围增加[+horror_dist]",  
		},  
		horror_b = {  
			name = "令人不安的存在",  
			info = "恐怖理智消耗增加[+horror_sanity]",  
		},  
		attack_a = {  
			name = "速杀者",  
			info = "击杀范围增加[+snap_dist]",  
		},  
		attack_b = {  
			name = "敏捷杀手",  
			info = "移动范围增加[+move_dist]",  
		},  
		gas1 = {  
			name = "毒气I",  
			info = "毒气范围增加[+gas_dist]",  
		},  
		gas2 = {  
			name = "毒气II",  
			info = "毒气范围增加[+gas_dist]，毒气冷却时间减少[-gas_cd]",  
		},  
		decoy1 = {  
			name = "诱饵I",  
			info = "诱饵冷却时间减少[-decoy_cd]",  
		},  
		decoy2 = {  
			name = "诱饵II",  
			info = "• 诱饵冷却时间减少至0.5秒\n• 原冷却时间适用于诱饵堆叠\n• 诱饵数量上限增加[decoy_max]。",  
		},  
		stealth1 = {  
			name = "潜行I",  
			info = "潜行冷却时间减少[-stealth_cd]",  
		},  
		stealth2 = {  
			name = "潜行II", 
			info = "• 潜行冷却时间减少[-stealth_cd]\n• 潜行持续时间增加[+stealth_dur]",  
		},  
		prot1 = scp173_prot,  
		prot2 = scp173_prot,  
		prot3 = scp173_prot,  
		prot4 = scp173_prot,  
	},  
}

wep.SCP457 = {  
	skills = {  
		_overview = { "被动技能", "火球术", "陷阱", "怒火中烧" },  
		fireball = {  
			name = "火球术",  
			dsc = "消耗：[cost]燃料\n发射一个火球，它会一直向前飞行直到碰到物体",  
		},  
		trap = {  
			name = "陷阱",  
			dsc = "消耗：[cost]燃料\n放置一个陷阱，触碰到它的玩家会被点燃",  
		},  
		ignite = {  
			name = "怒火中烧",  
			dsc = "每生成一圈火焰消耗[cost]燃料\n在你周围释放火焰波。此技能的范围无限，并且每一圈后续的火焰会消耗更多燃料。这个技能无法被打断",  
		},  
		passive = {  
			name = "被动技能",  
			dsc = "你接触到的所有人都会被点燃。点燃玩家会为你增加燃料",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "活体火炬I",  
			info = "升级你的被动技能\n\t• 火焰范围增加[+fire_radius]\n\t• 燃料获取增加[+fire_fuel]",  
		},  
		passive2 = {  
			name = "活体火炬II",  
			info = "升级你的被动技能\n\t• 火焰范围增加[+fire_radius]\n\t• 火焰伤害增加[+fire_dmg]",  
		},  
		passive3 = {  
			name = "活体火炬III",  
			info = "升级你的被动技能\n\t• 燃料获取增加[+fire_fuel]\n\t• 火焰伤害增加[+fire_dmg]",  
		},  
		passive_heal1 = {  
			name = "生命之火I",  
			info = "你从任何技能产生的火焰所造成的伤害中\n恢复[%fire_heal]的生命值",  
		},  
		passive_heal2 = {  
			name = "生命之火II",  
			info = "你从任何技能产生的火焰所造成的伤害中\n恢复[%fire_heal]的生命值",  
		},  
		fireball1 = {  
			name = "躲避球I",  
			info = "升级你的火球术技能\n\t• 冷却时间减少[-fireball_cd]\n\t• 速度增加[+fireball_speed]\n\t• 燃料消耗减少[-fireball_cost]",  
		},  
		fireball2 = {  
			name = "躲避球II",  
			info = "升级你的火球术技能\n\t• 伤害增加[+fireball_dmg]\n\t• 大小增加[+fireball_size]\n\t• 燃料消耗减少[-fireball_cost]",  
		},  
		fireball3 = {  
			name = "躲避球III",  
			info = "升级你的火球术技能\n\t• 冷却时间减少[-fireball_cd]\n\t• 伤害增加[+fireball_dmg]\n\t• 速度增加[+fireball_speed]",  
		},  
		trap1 = {  
			name = "陷阱I",  
			info = "升级你的陷阱技能\n\t• 额外陷阱数量：[trap_max]\n\t• 燃料消耗减少[-trap_cost]\n\t• 持续时间增加[+trap_time]",  
		},  
		trap2 = {  
			name = "陷阱II",  
			info = "升级你的陷阱技能\n\t• 额外陷阱数量：[trap_max]\n\t• 伤害增加[+trap_dmg]\n\t• 持续时间增加[+trap_time]",  
		},  
		trap3 = {  
			name = "陷阱III",  
			info = "升级你的陷阱技能\n\t• 燃料消耗减少[-trap_cost]\n\t• 伤害增加[+trap_dmg]\n\t• 持续时间增加[+trap_time]",  
		},  
		ignite1 = {  
			name = "怒火中烧I",  
			info = "升级你的怒火中烧技能\n\t• 波率增加[/ignite_rate]\n\t• 第一圈火焰额外生成[ignite_flames]个火焰",  
		},  
		ignite2 = {  
			name = "怒火中烧II",  
			info = "升级你的怒火中烧技能\n\t• 燃料消耗减少[-ignite_cost]\n\t• 第一圈火焰额外生成[ignite_flames]个火焰",  
		},  
		fuel = {  
			name = "燃料补给！",  
			info = "立即获得[fuel]燃料",  
		}  
	}  
}

wep.SCP682 = {  
	skills = {  
		_overview = { "主技能", "副技能", "冲锋", "护盾" },  
		primary = {  
			name = "基础攻击",  
			dsc = "用手直接在前方进行攻击，造成少量伤害",  
		},  
		secondary = {  
			name = "撕咬",  
			dsc = "按住键准备一次强力攻击，将在前方锥形区域内造成大量伤害",  
		},  
		charge = {  
			name = "冲锋",  
			dsc = "经过短暂延迟后向前冲锋，变得势不可挡。当达到全速时，消灭路径上的所有敌人，并获得穿透大多数门的能力。此技能需要在升级树中解锁",  
		},  
		shield = {  
			name = "护盾",  
			dsc = "护盾可以吸收任何非直接/坠落伤害。此能力受技能树中购买的升级影响",  
		},  
		shield_bar = {  
			name = "护盾",  
			dsc = "当前护盾量，可以吸收任何非直接/坠落伤害",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		shield_a = {  
			name = "强化护盾",  
			info = "提升你的护盾威力\n\t• 护盾威力：[%shield]\n\t• 冷却时间：[%shield_cd]",  
		},  
		shield_b = {  
			name = "再生护盾",  
			info = "改变你的护盾威力\n\t• 护盾威力：[%shield]\n\t• 冷却时间：[%shield_cd]\n\t• 护盾完全消耗后开始冷却\n\t• 护盾冷却期间，每秒恢复[shield_regen] HP",  
		},  
		shield_c = {  
			name = "牺牲护盾",  
			info = "改变你的护盾威力\n\t• 冷却时间：[%shield_cd]\n\t• 护盾完全消耗后开始冷却\n\t• 你的护盾威力等于你的最大HP\n\t• 护盾破碎时，你失去[shield_hp]最大HP",  
		},  
		shield_d = {  
			name = "反射护盾",  
			info = "改变你的护盾威力\n\t• 护盾威力：[%shield]\n\t• 冷却时间：[%shield_cd]\n\t• 护盾完全消耗后开始冷却\n\t• 你的护盾只阻挡[%shield_pct]的伤害\n\t• [%reflect_pct]的阻挡伤害会反射给攻击者",  
		},  
  
		shield_1 = {  
			name = "护盾I",  
			info = "为你的护盾增加效果。完全破碎后\n获得额外的[+shield_speed_pow]移动速度，持续[shield_speed_dur]秒",  
		},  
		shield_2 = {  
			name = "护盾II",  
			info = "为你的护盾增加效果。完全破碎后\n获得额外的[+shield_speed_pow]移动速度,持续[shield_speed_dur]秒\n每受到1点伤害，护盾冷却时间缩短[shield_cdr]秒",  
		},  
  
		attack_1 = {  
			name = "强化挥击",  
			info = "升级你的基础攻击\n\t• 冷却时间减少[-prim_cd]\n\t• 伤害增加[prim_dmg]",  
		},  
		attack_2 = {  
			name = "强化撕咬",  
			info = "升级你的撕咬\n\t• 范围增加[+sec_range]\n\t• 准备时的移动速度增加[+sec_speed]",  
		},  
		attack_3 = {  
			name = "无情打击",  
			info = "升级基础攻击和撕咬\n\t• 两次攻击都造成流血效果\n\t• 完全蓄力的撕咬攻击造成骨折",  
		},  
  
		charge_1 = {  
			name = "冲锋",  
			info = "解锁冲锋能力",  
		},  
		charge_2 = {  
			name = "残忍冲锋",  
			info = "强化冲锋能力\n\t• 冷却时间减少[-charge_cd]\n\t• 眩晕和减速持续时间减少[-charge_stun]",  
		},  
	}  
}

wep.SCP8602 = {  
	skills = {  
		_overview = { "被动", "主技能", "防御姿态", "冲锋" },  
		primary = {  
			name = "攻击",  
			dsc = "执行基础攻击",  
		},  
		defense = {  
			name = "防御姿态",  
			dsc = "按住以激活。在按住期间，随时间获得保护效果，但移动速度也会减慢。松开后向前冲刺，并对减免的伤害按[dmg_ratio]的比例造成等量伤害。此能力没有持续时间限制",  
		},  
		charge = {  
			name = "冲锋",  
			dsc = "随时间增加速度，并对前方第一个玩家造成伤害。如果被攻击的玩家离墙壁足够近，则将其钉在墙上以增加伤害",  
		},  
		passive = {  
			name = "被动技能",  
			dsc = "你能看到进入你森林范围内的玩家，并在他们离开一段时间后仍能看到。森林内的玩家会失去理智，如果理智耗尽，则会损失生命值。从森林内玩家身上获取的理智/生命值可以为你治疗，这种治疗可以超过你的最大生命值",  
		},  
		overheal_bar = {  
			name = "过量治疗",  
			dsc = "超出最大生命值的生命量",  
		},  
		defense_bar = {  
			name = "防御",  
			dsc = "当前保护强度",  
		},  
		charge_bar = {  
			name = "冲锋",  
			dsc = "剩余冲锋时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "茂密森林I",  
			info = "升级你的被动技能\n\t• 最大过量治疗增加[+overheal]\n\t• 被动速率增加[/passive_rate]\n\t• 玩家探测时间增加[+detect_time]",  
		},  
		passive2 = {  
			name = "茂密森林II",  
			info = "升级你的被动技能\n\t• 最大过量治疗增加[+overheal]\n\t• 被动速率增加[/passive_rate]\n\t• 玩家探测时间增加[+detect_time]",  
		},  
		primary = {  
			name = "简单却危险",  
			info = "升级你的基础攻击\n\t• 冷却时间减少[-primary_cd]\n\t• 伤害增加[+primary_dmg]",  
		},  
		def1a = {  
			name = "迅捷护甲",  
			info = "改变你的防御姿态技能\n\t• 激活时间减少[-def_time]\n\t• 冷却时间增加[+def_cooldown]",  
		},  
		def1b = {  
			name = "急速护甲",  
			info = "改变你的防御姿态技能\n\t• 激活时间增加[+def_time]\n\t• 冷却时间减少[-def_cooldown]",  
		},  
		def2a = {  
			name = "长距离冲刺",  
			info = "改变你的防御姿态技能\n\t• 冲刺最大距离增加[+def_range]\n\t• 冲刺宽度减少[-def_width]",  
		},  
		def2b = {  
			name = "笨拙冲刺",  
			info = "改变你的防御姿态技能\n\t• 冲刺最大距离减少[-def_range]\n\t• 冲刺宽度增加[+def_width]",  
		},  
		def3a = {  
			name = "重甲",  
			info = "改变你的防御姿态技能\n\t• 最大保护强度增加[+def_prot]\n\t• 最大减速效果增加[+def_slow]",  
		},  
		def3b = {  
			name = "轻甲",  
			info = "改变你的防御姿态技能\n\t• 最大保护强度减少[-def_prot]\n\t• 最大减速效果减少[-def_slow]",  
		},  
		def4 = {  
			name = "高效护甲",  
			info = "升级你的防御姿态技能\n\t• 伤害转换倍率增加[+def_mult]",  
		},  
		charge1 = {  
			name = "冲锋I",  
			info = "升级你的冲锋技能\n\t• 冷却时间减少[-charge_cd]\n\t• 持续时间增加[+charge_time]\n\t• 基础伤害增加[+charge_dmg]",  
		},  
		charge2 = {  
			name = "冲锋II",  
			info = "升级你的冲锋技能\n\t• 范围增加[+charge_range]\n\t• 持续时间增加[+charge_time]\n\t• 钉墙伤害增加[+charge_pin_dmg]",  
		},  
		charge3 = {  
			name = "冲锋III",  
			info = "升级你的冲锋技能\n\t• 速度增加[+charge_speed]\n\t• 基础伤害增加[+charge_dmg]\n\t• 将玩家钉在墙上会使其骨折",  
		},  
	}  
}

wep.SCP939 = {  
	skills = {  
		_overview = { "被动", "主动", "尾随", "特殊" },  
		primary = {  
			name = "攻击",  
			dsc = "咬伤你前方锥形区域内的所有人",  
		},  
		trail = {  
			name = "ANM-C227",  
			dsc = "按住键位在你身后留下ANM-C227轨迹",  
		},  
		special = {  
			name = "探测",  
			dsc = "开始探测你周围的玩家",  
		},  
		passive = {  
			name = "被动",  
			dsc = "你看不见玩家，但你可以看见声波。你周围有ANM-C227光环",  
		},  
		special_bar = {  
			name = "探测",  
			dsc = "剩余探测时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "光环I",  
			info = "升级你的被动能力\n\t• 光环半径增加[+aura_radius]\n\t• 光环伤害增加[aura_damage]",  
		},  
		passive2 = {  
			name = "光环II",  
			info = "升级你的被动能力\n\t• 光环半径增加[+aura_radius]\n\t• 光环伤害增加[aura_damage]",  
		},  
		passive3 = {  
			name = "光环III",  
			info = "升级你的被动能力\n\t• 光环半径增加[+aura_radius]\n\t• 光环伤害增加[aura_damage]",  
		},  
		attack1 = {  
			name = "撕咬I",  
			info = "升级你的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 伤害增加[+attack_dmg]",  
		},  
		attack2 = {  
			name = "撕咬II",  
			info = "升级你的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 范围增加[+attack_range]",  
		},  
		attack3 = {  
			name = "撕咬III",  
			info = "升级你的攻击能力\n\t• 伤害增加[+attack_dmg]\n\t• 范围增加[+attack_range]\n\t• 你的攻击有几率造成流血效果",  
		},  
		trail1 = {  
			name = "失忆I",  
			info = "升级你的ANM-C227能力\n\t• 半径增加[+trail_radius]\n\t• 堆叠生成速率增加[/trail_rate]",  
		},  
		trail2 = {  
			name = "失忆II",  
			info = "升级你的ANM-C227能力\n\t• 伤害增加[trail_dmg]\n\t• 最大堆叠数增加[+trail_stacks]",  
		},  
		trail3a = {  
			name = "失忆III A",  
			info = "升级你的ANM-C227能力\n\t• 轨迹持续时间增加[+trail_life]\n\t• 半径增加[+trail_radius]",  
		},  
		trail3b = {  
			name = "失忆III B",  
			info = "升级你的ANM-C227能力\n\t• 最大堆叠数增加[+trail_stacks]",  
		},  
		trail3c = {  
			name = "失忆III C",  
			info = "升级你的ANM-C227能力\n\t• 堆叠生成速率增加[/trail_rate]",  
		},  
		special1 = {  
			name = "回声定位I",  
			info = "升级你的特殊能力\n\t• 冷却时间减少[-special_cd]\n\t• 半径增加[+special_radius]",  
		},  
		special2 = {  
			name = "回声定位II",  
			info = "升级你的特殊能力\n\t• 冷却时间减少[-special_cd]\n\t• 持续时间增加[+special_times]",  
		},  
	}  
}

wep.SCP966 = {  
	fatigue = "疲劳等级：",  
  
	skills = {  
		_overview = { "被动", "攻击", "引导", "标记" },  
		attack = {  
			name = "基础攻击",  
			dsc = "执行基础攻击。你只能攻击拥有至少10层疲劳累积的玩家。被攻击的玩家会失去一些疲劳累积。此攻击的效果受技能树影响",  
		},  
		channeling = {  
			name = "引导",  
			dsc = "引导技能树中选定的能力",  
		},  
		mark = {  
			name = "死亡标记",  
			dsc = "标记玩家。被标记的玩家会从附近其他玩家那里转移疲劳累积到自己身上",  
		},  
		passive = {  
			name = "疲劳",  
			dsc = "偶尔会对附近的玩家施加疲劳累积。你每施加一层疲劳累积，也会获得一层被动累积",  
		},  
		channeling_bar = {  
			name = "引导",  
			dsc = "引导能力的剩余时间",  
		},  
		mark_bar = {  
			name = "死亡标记",  
			dsc = "被标记玩家身上标记的剩余时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "疲劳I",  
			info = "升级你的被动能力\n\t• 被动触发率提高[/passive_rate]",  
		},  
		passive2 = {  
			name = "疲劳II",  
			info = "升级你的被动能力\n\t• 被动触发率提高[/passive_rate]\n\t• 被动范围增加[+passive_radius]",  
		},  
		basic1 = {  
			name = "锋利爪击I",  
			info = "升级你的基础攻击，每[basic_stacks]层被动累积\n增加[%basic_dmg]的伤害\n此外，获得被动累积可解锁：\n\t• [bleed1_thr]层：如果目标未流血，则施加流血效果\n\t• [drop1_thr]层：目标失去的疲劳累积减少至[%drop1]\n\t• [slow_thr]层：目标减速[-slow_power]，持续[slow_dur]秒",  
		},  
		basic2 = {  
			name = "锋利爪击II",  
			info = "升级基础攻击，每[basic_stacks]层被动累积增加[%basic_dmg]的伤害\n此外，获得被动累积可解锁：\n\t• [bleed2_thr]层：击中时施加流血效果\n\t• [drop2_thr]层：目标失去的疲劳累积减少至[%drop2]\n\t• [hb_thr]层：击中时施加严重流血效果，而不是流血效果",  
		},  
		heal = {  
			name = "血液汲取",  
			info = "击中时，每层被动累积每目标疲劳\n累积回复[%heal_rate]生命值",  
		},  
		channeling_a = {  
			name = "无尽疲劳",  
			info = "解锁引导能力，允许你专注于单个目标\n\t• 引导期间禁用被动\n\t• 冷却时间[channeling_cd]秒\n\t• 最大持续时间[channeling_time]秒\n\t• 目标每[channeling_rate]秒获得一层疲劳累积",  
		},  
		channeling_b = {  
			name = "能量汲取",  
			info = "解锁引导能力，允许你从附近玩家身上汲取疲劳累积\n\t• 引导期间禁用被动\n\t• 冷却时间[channeling_cd]秒\n\t• 最大持续时间[channeling_time]秒\n\t• 每[channeling_rate]秒，从所有附近玩家身上转移1层疲劳累积到被动累积中",  
		},  
		channeling = {  
			name = "强化引导",  
			info = "升级你的引导能力\n\t• 引导范围增加[+channeling_range_mul]\n\t• 引导持续时间增加[+channeling_time_mul]",  
		},  
		mark1 = {  
			name = "致命标记I",  
			info = "升级标记能力：\n\t• 累积转移速率增加[/mark_rate]",  
		},  
		mark2 = {  
			name = "致命标记II",  
			info = "升级标记能力：\n\t• 累积转移速率增加[/mark_rate]\n\t• 累积转移范围增加[+mark_range]",  
		},  
	}  
}

wep.SCP24273 = {  
	skills = {  
		_overview = { "切换", "主技能", "副技能", "特殊技能" },  
		primary = {  
			name = "冲刺/伪装",  
			dsc = "\n法官：\n向前冲刺，对路径上的所有人造成伤害\n\n检察官：\n启用伪装。伪装期间你更难被发现。使用技能、移动或受到伤害会中断伪装",  
		},  
		secondary = {  
			name = "审查/监视",  
			dsc = "\n法官：\n开始锁定目标玩家一段时间。完全施放后，减速目标并造成伤害。如果失去视线，技能会被中断，并且你会被减速\n\n检察官：\n离开你的身体，从附近随机玩家的视角观察。你的被动技能也会从该玩家的视角生效",  
		},  
		special = {  
			name = "审判/幽灵",  
			dsc = "\n法官：\n站在原地，迫使附近的所有人走向你。结束时，近距离的玩家会受到伤害并被击退\n\n检察官：\n进入幽灵形态。在幽灵形态下，你免疫所有伤害（爆炸和直接伤害除外）",  
		},  
		change = {  
			name = "法官/检察官",  
			dsc = "\n在法官和检察官模式之间切换\n\n法官：\n你对目标造成的伤害会根据累积的证据增加。攻击目标会降低证据等级。攻击拥有满额证据的玩家会立即杀死他们\n\n检察官：\n你的速度减慢，并且获得子弹伤害保护。注视玩家可以收集他们的证据",  
		},  
		camo_bar = {  
			name = "伪装",  
			dsc = "剩余伪装时间",  
		},  
		spectate_bar = {  
			name = "监视",  
			dsc = "剩余监视时间",  
		},  
		drain_bar = {  
			name = "审查",  
			dsc = "剩余审查时间",  
		},  
		ghost_bar = {  
			name = "幽灵",  
			dsc = "剩余幽灵时间",  
		},  
		special_bar = {  
			name = "审判",  
			dsc = "剩余审判时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		j_passive1 = {  
			name = "严厉法官I",  
			info = "升级你的法官被动技能\n\t• 证据增加的伤害提升至额外[%j_mult]\n\t• 攻击时证据减少至[%j_loss]",  
		},  
		j_passive2 = {  
			name = "严厉法官II",  
			info = "升级你的法官被动技能\n\t• 证据增加的伤害提升至额外[%j_mult]\n\t• 攻击时证据减少至[%j_loss]",  
		},  
		p_passive1 = {  
			name = "地方检察官I",  
			info = "升级你的检察官被动技能\n\t• 子弹保护提升至[%p_prot]\n\t• 减速提升至[%p_slow]\n\t• 每秒证据收集速率提升至[%p_rate]",  
		},  
		p_passive2 = {  
			name = "地方检察官II",  
			info = "升级你的检察官被动技能\n\t• 子弹保护提升至[%p_prot]\n\t• 减速提升至[%p_slow]\n\t• 每秒证据收集速率提升至[%p_rate]",  
		},  
		dash1 = {  
			name = "冲刺I",  
			info = "升级你的冲刺技能\n\t• 冷却时间减少[-dash_cd]\n\t• 伤害增加[+dash_dmg]",  
		},  
		dash2 = {  
			name = "冲刺II",  
			info = "升级你的冲刺技能\n\t• 冷却时间减少[-dash_cd]\n\t• 伤害增加[+dash_dmg]",  
		},  
		camo1 = {  
			name = "伪装I",  
			info = "升级你的伪装技能\n\t• 冷却时间减少[-camo_cd]\n\t• 持续时间增加[+camo_dur]\n\t• 你可以在不中断此技能的情况下移动[camo_limit]单位",  
		},  
		camo2 = {  
			name = "伪装II",  
			info = "升级你的伪装技能\n\t• 冷却时间减少[-camo_cd]\n\t• 持续时间增加[+camo_dur]\n\t• 你可以在不中断此技能的情况下移动[camo_limit]单位",  
		},  
		drain1 = {  
			name = "审查I",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-drain_cd]\n\t• 持续时间减少[-drain_dur]",  
		},  
		drain2 = {  
			name = "审查II",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-drain_cd]\n\t• 持续时间减少[-drain_dur]",  
		},  
		spect1 = {  
			name = "监视I",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-spect_cd]\n\t• 持续时间增加[+spect_dur]\n\t• 子弹伤害保护提升至[%spect_prot]",  
		},  
		spect2 = {  
			name = "监视II",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-spect_cd]\n\t• 持续时间增加[+spect_dur]\n\t• 子弹伤害保护提升至[%spect_prot]",  
		},  
		combo = {  
			name = "最高法院",  
			info = "升级你的审判和幽灵技能\n\t• 审判保护提升至[%special_prot]\n\t• 幽灵持续时间增加[+ghost_dur]",  
		},  
		spec = {  
			name = "审判",  
			info = "升级你的审判技能\n\t• 冷却时间减少[-special_cd]\n\t• 持续时间增加[+special_dur]\n\t• 保护提升至[%special_prot]",  
		},  
		ghost1 = {  
			name = "幽灵I",  
			info = "升级你的幽灵技能\n\t• 冷却时间减少[-ghost_cd]\n\t• 持续时间增加[+ghost_dur]\n\t• 每消耗1份证据，治疗量增加至[ghost_heal]",  
		},  
		ghost2 = {  
			name = "幽灵II",  
			info = "升级你的幽灵技能\n\t• 冷却时间减少[-ghost_cd]\n\t• 持续时间增加[+ghost_dur]\n\t• 每消耗1份证据，治疗量增加至[ghost_heal]",  
		},  
		change1 = {  
			name = "切换I",  
			info = "切换冷却时间减少[-change_cd]",  
		},  
		change2 = {  
			name = "切换II",  
			info = "切换冷却时间减少[-change_cd]。此外，切换模式不再中断伪装技能",  
		},  
	}  
}


wep.SCP3199 = {  
	skills = {  
		_overview = { "被动技能", "主动技能", "特殊技能", "蛋" },  
		eggs_max = "您已达到最大蛋数量！",  
  
		primary = {  
			name = "攻击",  
			dsc = "执行基础攻击。击中目标会激活（或刷新）狂暴状态，施加深度创伤效果，并获得被动层数和狂暴层数。\n对带有深度创伤的目标，攻击伤害会降低。若攻击未命中，则狂暴状态停止。若仅击中带有深度创伤的目标，则狂暴状态停止并施加层数惩罚",  
		},  
		special = {  
			name = "超越攻击",  
			dsc = "在连续[tokens]次成功攻击后激活。使用该技能立即结束狂暴状态，并对所有带有深度创伤的玩家造成伤害。受影响玩家也会被减速",  
		},  
		egg = {  
			name = "蛋",  
			dsc = "击杀玩家后可以孵化蛋。当您受到致命伤害时，将在随机蛋的位置复活。复活会消耗一个蛋。此外，每个蛋提供[prot]点子弹保护（上限为[cap]）\n\n当前蛋数量：[eggs] / [max]",  
		},  
		passive = {  
			name = "被动",  
			dsc = "在狂暴状态下，可以看到附近没有深度创伤的玩家的位置。获得狂暴层数也会获得被动层数。如果攻击仅命中带有深度创伤的玩家，您将失去[penalty]层被动层数。被动层数会升级您的其他能力\n\n在狂暴状态下每秒恢复[heal]点HP\n攻击伤害加成：[dmg]\n狂暴速度加成：[speed]\n特殊攻击额外减速：[slow]\n特殊攻击造成[bleed]级流血效果",  
		},  
		frenzy_bar = {  
			name = "狂暴",  
			dsc = "剩余狂暴时间",  
		},  
		egg_bar = {  
			name = "蛋",  
			dsc = "剩余蛋孵化时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		frenzy1 = {  
			name = "狂暴I",  
			info = "升级您的狂暴能力\n\t• 持续时间增加[+frenzy_duration]\n\t• 最大层数增加[frenzy_max]",  
		},  
		frenzy2 = {  
			name = "狂暴II",  
			info = "升级您的狂暴能力\n\t• 最大层数增加[frenzy_max]\n\t• 每层被动层数使狂暴速度增加[%frenzy_speed_stacks]",  
		},  
		frenzy3 = {  
			name = "狂暴III",  
			info = "升级您的狂暴能力\n\t• 持续时间增加[+frenzy_duration]\n\t• 每层被动层数使狂暴速度增加[%frenzy_speed_stacks]",  
		},  
		attack1 = {  
			name = "锋利爪击I",  
			info = "升级您的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 伤害增加[+attack_dmg]",  
		},  
		attack2 = {  
			name = "锋利爪击II",  
			info = "升级您的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 每层被动层数使伤害增加[%attack_dmg_stacks]",  
		},  
		attack3 = {  
			name = "锋利爪击III",  
			info = "升级您的攻击能力\n\t• 伤害增加[+attack_dmg]\n\t• 每层被动层数使伤害增加[%attack_dmg_stacks]",  
		},  
		special1 = {  
			name = "超越攻击I",  
			info = "升级您的特殊能力\n\t• 伤害增加[+special_dmg]\n\t• 每层被动层数使减速增加[%special_slow]\n\t• 减速持续时间增加[+special_slow_duration]",  
		},  
		special2 = {  
			name = "超越攻击II",  
			info = "升级您的特殊能力\n\t• 伤害增加[+special_dmg]\n\t• 每层被动层数使减速增加[%special_slow]\n\t• 减速持续时间增加[+special_slow_duration]",  
		},  
		passive = {  
			name = "血腥感知",  
			info = "被动检测范围增加[+passive_radius]",  
		},  
		egg = {  
			name = "复活节彩蛋",  
			info = "立即孵化新蛋。\n此能力可以超出蛋的数量限制",  
		},  
	}  
}

RegisterLanguage( lang, "chinese", "cn", "zh-CN" )
