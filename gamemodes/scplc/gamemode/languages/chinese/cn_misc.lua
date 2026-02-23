local lang = LANGUAGE

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