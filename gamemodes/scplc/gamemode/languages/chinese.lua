--[[-------------------------------------------------------------------------
Language: Chinese
Date: 12.08.2021
Translated by: xiaobai
Updated in day 12.08.2021 by: Zaptyp (https://steamcommunity.com/id/Zaptyp/)
---------------------------------------------------------------------------]]

local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "你可能在下一轮被选为SCP",
	scpwait = "你必须等待 %i 回合才能以 SCP 的身份进行游戏",
	abouttostart = "游戏将在 %i 秒后开始！",
	kill = "你获得了 %d 分 敌方团队 %s 敌方名字 %s！",
	assist = "你获得了 %d 分，因为你协助玩家杀死了 %s ",
	rdm = "你失去了 %d 分，因为你杀死了 %s ",
	acc_denied = "拒绝访问",
	acc_granted = "允许访问",
	acc_omnitool = "需要读卡器才能开启这扇门",
	device_noomni = "操作此设备需要读卡器",
	elevator_noomni = "启动此电梯需要读卡器",
	acc_wrong = "执行此操作需要级别更高的权限芯片",
	rxpspec = "你在服务器上游玩获得 %i 点经验！",
	rxpplay = "因为你还活着因此你获得了 %i 点经验！",
	rxpplus = "因为你超强的生存能力因此你获得了 %i 点经验！",
	roundxp = "你的积分换的了 %i 点经验",
	gateexplode = "A门爆破时间：%i",
	explodeterminated = "A门爆破已停止 ",
	r106used = "SCP 106 重新收容程序每回合只能启动一次",
	r106eloiid = "停止运行 ELO-IID 电磁场来启动 SCP 106 重新收容程序",
	r106sound = "打开设施广播来吸引 SCP 106 回到收容间",
	r106human = "需要玩家进入收容间才能启动 SCP 106 重新收容程序",
	r106already = "SCP 106 已被重新收容",
	r106success = "你因成功重新收容 SCP 106 而获得了 %i 点经验",
	vestpickup = "你穿上了护甲",
	vestdrop = "你脱掉了护甲",
	hasvest = "你穿上了一个护甲！你可以打开你的物品栏脱掉它",
	escortpoints = "你因护送你的目标而获得 %i 点数",
	femur_act = "大腿粉碎机启动...",
	levelup = "你升级了！ 你当前的等级是：%i",
	healplayer = "你因治疗其他玩家而获得 %i 点数",
	detectscp = "你因使用监控探头发现 SCP 而获得了 %i 分",
	winxp = "你获得 %i 经验，因为你的初始团队赢得了比赛",
	winalivexp = "你获得 %i 经验，因为你的团队赢得了比赛",
	upgradepoints = "你获得了新的技能提升点！ 按“%s”打开 SCP 技能升级面板",
	prestigeup = "玩家 %s 获得了更高的声望！ 他目前的声望等级是：%i",
	omega_detonation = "欧米伽核弹将在 %i 秒内爆炸。 立即到地面或前往核爆避难所避难！",
	alpha_detonation = "阿尔法核弹将在 %i 秒内爆炸。 立即进入设施内部或立即离开设施！",
	alpha_card = "你已插入阿尔法核弹钥匙卡",
	destory_scp = "你因消灭 SCP 项目而获得 %i 分！",
	afk = "你现在正在挂机。 随着时间的流逝，你将不会再获得经验！",
	afk_end = "你已不在挂机",
}

lang.NFailed = "无法使用密钥访问 NRegistry：%s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "你逃离了设施！",
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
}

lang.NCFailed = "无法使用密钥访问 NCRegistry：%s"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "拾起"
hud.class = "角色"
hud.team = "团队"
hud.prestige_points = "分数"
hud.hp = "生命值"
hud.stamina = "体力值"
hud.sanity = "理智值"
hud.xp = "经验值"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "鼠标左键 - 选择"
lang.eq_rmb = "鼠标右键 - 丢弃"
lang.eq_hold = "摁住鼠标左键 - 移动物品"
lang.eq_vest = "护甲"
lang.eq_key = "按 '%s' 打开物品栏"

lang.info = "信息"
lang.author = "作者"
lang.mobility = "机动性"
lang.weight = "重量"
lang.protection = "防御性"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "护送",
	gatea = "爆破A门"
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
effects.deep_wounds = "裂口"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "职业查看栏"
lang.preview = "预览"
lang.random = "随机"
lang.price = "价格"
lang.buy = "购买"
lang.refound = "退款"
lang.none = "没有"
lang.refounded = "所有被取消的等级的点数已退回。你获得%d个点数。"

lang.details = {
	details = "详情",
	name = "姓名",
	team = "团队",
	price = "点数价格",
    walk_speed = "走路速度",
    run_speed = "跑步速度",
    chip = "权限卡等级",
    persona = "伪装ID",
    weapons = "武器",
    class = "级别",
    hp = "血量",
    speed = "速度",
	health = "健康值",
	sanity = "理智值"
}

lang.headers = {
	support = "支援部队",
	classes = "设施人员",
	scp = "异常们"
}

lang.view_cat = {
	classd = "D级人员",
	sci = "科研人员",
	mtf = "机动特遣队",
	mtf_ntf = "九尾狐",
	mtf_alpha = "MTF 阿尔法-1",
	ci = "混沌分裂者",
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "未连接"

lang.scoreboard = {
	name = "记分板",
	playername = "名字",
	ping = "延迟",
	prestige = "声望",
	level = "等级",
	score = "分数",
	ranks = "权限",
}

lang.ranks = {
	author = "作者",
	vip = "VIP",
	tester = "测试员",
	contributor = "合作者",
	translator = "翻译",
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
}

lang.info_screen_type = {
	alive = "幸存",
	escaped = "逃脱",
	dead = "死亡",
	mia = "在行动中失踪",
	unknown = "未知",
}

lang.info_screen_macro = {
	time = function( args )
		local t = tonumber( args[1] )
		return t and string.ToMinutesSeconds( t ) or "--:--"
	end
}

--[[-------------------------------------------------------------------------
Generic
---------------------------------------------------------------------------]]
lang.nothing = "无"
lang.exit = "出口"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "游戏模式内容",
	msg = [[It looks like you don't have some addons. It may cause errors like missing content (textures/models/sounds) and may break your gameplay experience.
You don't have %i addons out of %i. Would you like to download it now? (you can either download it through game or do it manually on workshop page)]],
	no = "不",
	download = "正在下载",
	workshop = "显示创意工坊",
	downloading = "下载中",
	mounting = "安装中",
	processing = "处理插件中: %s\n状态: %s",
	cancel = "取消"
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

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "保安背心"
vest.heavyguard = "重型防护护甲"
vest.specguard = "安保主管护甲"
vest.guard_medic = "医疗护甲"
vest.ntf = "九尾狐小队队员护甲"
vest.mtf_medic = "九尾狐小队队医护甲"
vest.ntfcom = "九尾狐小队指挥官护甲"
vest.alpha1 = "MTF 阿尔法 护甲"
vest.ci = "混沌分裂者护甲"
vest.fire = "防火服"
vest.electro = "特斯拉服"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "火焰抗性"
dmg.SHOCK = "电击抗性"
dmg.BULLET = "子弹抗性"
dmg.FALL = "摔伤抗性"

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "观众"
teams.CLASSD = "D级人员"
teams.SCI = "科研人员"
teams.MTF = "机动特遣队"
teams.CI = "混沌分裂者"
teams.SCP = "异常"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "Unknown"

classes.SCP023 = "SCP 023"
classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
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
classes.ciagent = "CI特工"

classes.sciassistant = "科学家助理"
classes.sci = "科学家"
classes.seniorsci = "资深科学家"
classes.headsci = "首席科学家"

classes.guard = "警卫"
classes.chief = "安全主管"
classes.lightguard = "轻装安保人员"
classes.heavyguard = "重装安保人员"
classes.specguard = "保安专员"
classes.guardmedic = "安保医护人员"
classes.tech = "保安技术员"
classes.cispy = "CI间谍"

classes.ntf_1 = "MTF NTF - 侦察步兵"
classes.ntf_2 = "MTF NTF - 镇暴步兵"
classes.ntf_3 = "MTF NTF - 步枪兵"
classes.ntfcom = "MTF NTF指挥官"
classes.ntfsniper = "MTF NTF狙击手"
classes.ntfmedic = "MTF NTF 队医"
classes.alpha1 = "MTF 阿尔法-1"
classes.alpha1sniper = "MTF 阿尔法-1 狙击手"
classes.ci = "混沌分裂者"
classes.cicom = "混沌分裂指挥官"

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
- 听你的主管]]

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

	ciagent = [[- 护送 D 级成员
- 避开工作人员和SCP
- 与他人合作]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

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

	ci = [[- 帮助 D 级人员
- 干掉所有保安和九尾狐
- 听你的老大的话]],

	cicom = [[- 帮助 D 级人员
- 干掉所有保安和九尾狐
- 给其他 CI 发号施令]],

	SCP023 = generic_scp,

	SCP049 = [[- 逃离设施
- 与其他SCP合作
- 治愈其他人]],

	SCP0492 = [[]],

	SCP066 = generic_scp_friendly,

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

--[[-------------------------------------------------------------------------
DON'T EDIT - UNUSED
---------------------------------------------------------------------------]]
/*lang.CLASS_INFO = {
	classd = [[你是D级人员
你的目标是逃离设施
与其他DD合作，寻找钥匙卡
小心这里的保安和 SCP]],

	veterand = [[你是D级老兵
你的目标是逃离设施
与其他DD合作,帮助新来的DD
提防设施工作人员和 SCP]],

	kleptod = [[你是D级盗窃狂
你的目标是逃离设施
你偷了保安人员的东西
提防保安和 SCP]],

	ciagent = [[你是 CI 卧底
你的目标是保护 D 级人员
护送他们到出口
提防设施保安和 SCP]],

	sciassistant = [[你是科学家助理
你的目标是逃离设施
与其他科学家和安全人员合作
当心混沌分裂者和SCP]],

	sci = [[你是科学家
你的目标是逃离设施
与其他科学家和安全人员合作
当心混沌分裂者和SCP]],

	seniorsci = [[你是高级科学家
你的目标是逃离设施
与其他科学家和安全人员合作
当心混沌分裂者和SCP]],

	headsci = [[你是首席科学家
你的目标是逃离设施
与其他科学家和安全人员合作
当心混沌分裂者和SCP]],

	guard = [[你是保安
你的目标是拯救所有科学家
杀死所有 D 级人员和 SCP]],

	lightguard = [[你是保安
你的目标是拯救所有科学家
杀死所有 D 级人员和 SCP]],

	heavyguard = [[你是保安
你的目标是拯救所有科学家
杀死所有 D 级人员和 SCP]],

	specguard = [[你是保安专家
你的目标是拯救所有科学家
杀死所有 D 级人员和 SCP]],

	chief = [[你是安全主管
你的目标是拯救所有科学家
杀死所有 D 级人员和 SCP]],

	guardmedic = [[你是保安医生
你的目标是拯救所有科学家
使用您的医疗箱来帮助您的队友
杀死所有 D 级人员和 SCP]],

	tech = [[你是安全技术员
你的目标是拯救所有科学家
您可以放置​​便携式炮塔
杀死所有 D 级人员和 SCP]],

	cispy = [[你是CI间谍
你的目标是帮助 D 级人员
冒充保安]],

	ntf_1 = [[你是保安专家
你的目标是拯救所有科学家
杀死所有 D 级人员和 SCP]],

	ntf_2 = [[你是MTF NTF
帮助设施内的员工
不要让 D 级人员和 SCP 逃脱]],

	ntf_3 = [[你是MTF NTF
帮助设施内的员工
不要让 D 级人员和 SCP 逃脱]],

	ntfmedic = [[你是 MTF NTF 医疗兵
帮助设施内的员工
使用您的医疗箱来帮助其他 MTF]],

	ntfcom = [[你是 MTF NTF 指挥官
帮助设施内的员工
不要让 D 级人员和 SCP 逃脱]],

	ntfsniper = [[你是 MTF NTF 狙击手
远距离保护您的团队
不要让 D 级人员和 SCP 逃脱]],

	alpha1 = [[你是 MTF Alpha 1
你直接为 O5 议会工作
不惜一切代价保护基础
你的任务是[数据删除] ]],

	alpha1sniper = [[是 MTF Alpha 1 射手
你直接为 O5 议会工作
不惜一切代价保护基础
你的任务是[数据删除] ]]

	ci = [[你是混沌分裂者士兵
帮助 D 级人员
杀死 MTF 和其他设施工作人员]],

	cicom = [[你是混沌分裂者指挥官
帮助 D 级人员
杀死 MTF 和其他设施工作人员]],
	
	SCP023 = [[你是SCP 023
你的目标是逃离设施
你会杀死每一个见过你的人
点击RMB放置陷阱]],

	SCP049 = [[你是SCP 049
你的目标是逃离设施
你的触摸对人类是致命的
你可以通过手术来“治愈”病人]],

	SCP0492 = [[你是SCP 049-2
你的目标是逃离设施
听从SCP 049的命令并保护他]],

	SCP066 = [[你是SCP 066
你的目标是逃离设施
您可以播放非常响亮的音乐]],

	SCP096 = [[你是SCP 096
你的目标是逃离设施
当有人看着你时，你会变得愤怒
您可以通过按 R 来恢复 HP]],

	SCP106 = [[是SCP 106
你的目标是逃离设施
您可以穿过门并传送到选定的位置

LMB：将人类传送到口袋维度
RMB：标记传送目的地
R: 传送]],

	SCP173 = [[你是SCP 173
你的目标是逃离设施
当有人看着你时你不能移动
你的特殊能力将你传送到附近的人类]],

	SCP457 = [[[你是SCP 457
你的目标是逃离设施
你在燃烧，你会点燃一切
在你旁边
你最多可以放置 5 个火焰陷阱]],

	SCP682 = [[你是SCP 682
你的目标是逃离设施
你的生命值很高
你的特殊能力使你对任何伤害免疫]],

	SCP8602 = [[你是SCP 860-2
你的目标是逃离设施
如果你攻击靠近墙壁的人，你会
将他钉在墙上并造成巨大伤害]],

	SCP939 = [[你是SCP 939
你的目标是逃离设施
你可以和人交谈]],

	SCP966 = [[你是SCP 966
你的目标是逃离设施
你是隐形的]],

	SCP3199 = [[你是SCP 3199
你的目标是逃离设施
你是敏捷而致命的猎人
你可以感觉到附近人类的心跳]],
}*/
--[[-------------------------------------------------------------------------
END OF UNUSED PART
---------------------------------------------------------------------------]]

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
MTF Alpha-1 单位。 重装甲、高实用性单位，配备步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
]],

	alpha1sniper = [[操作难度: 难
健壮程度: 超级强壮
灵活性: 敏捷
作战能力: 特种兵级别
能否逃脱: 否
能否护送: 科研人员
能被谁护送: 无

Overview:
MTF Alpha-1 单位。 重装甲，高实用性单位，装备神射手步枪。 进入设施并保护它。 帮助里面的工作人员杀死SCP和D级。
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
	
	SCP023 = [[操作难度: 难
健壮程度: 差
灵活性: 灵活
伤害类型: 秒杀

Overview:
你可以穿过墙壁。 如果有人看到你，他们就会被列入你的名单。 偶尔你会传送到名单上的一名玩家并将他们烧死。 您可以放置您的克隆。
]],

	SCP049 = [[操作难度: 难
健壮程度: 差
灵活性: 灵活
伤害类型: 三次攻击后死亡

Overview:
攻击玩家 3 次以杀死他们。 你可以用身体创建僵尸。
]],

	SCP0492 = [[]],

	SCP066 = [[操作难度: 中等
健壮程度: 强壮
灵活性: 普通
伤害类型: 群体伤害（弱）

Overview:
您播放非常响亮的音乐，会是你周围玩家的耳朵遭受打击。
]],

	SCP096 = [[操作难度: 难
健壮程度: 强壮
灵活性: 超级迟钝（看脸前），闪电侠（看脸后）
伤害类型: 秒杀

Overview:
如果有人看到你，你会变得愤怒。 愤怒时，你跑得非常快，你可以杀死你的目标。
]],

	SCP106 = [[操作难度: 中等
健壮程度: 普通
灵活性: 迟钝
伤害类型: 拉进口袋里造成普通伤害

Overview:
你可以穿过墙壁。 攻击某人将他们传送到口袋维度。 在口袋维度时，您会立即杀死目标。
]],

	SCP173 = [[操作难度: 简单
健壮程度: 超级强壮
灵活性: 闪电侠+
伤害类型: 秒杀

Overview:
你速度极快，但如果有人看到你，你就无法移动。 你会自动杀死附近的玩家。 您可以使用特殊攻击传送到范围内的一名玩家。 
]],

	SCP457 = [[操作难度: 简单
健壮程度: 普通
灵活性: 普通
伤害类型: 烧伤他人并使其传火

Overview:
你在燃烧，你可以燃烧附近的玩家。 您还可以放置陷阱，当有人踩到它们时会激活它们。
]],

	SCP682 = [[操作难度: 难
健壮程度: 几乎不死
灵活性: 普通
伤害类型: 致残

Overview:
极其艰难和致命。 使用特殊能力在短时间内获得伤害免疫。
]],

	SCP8602 = [[操作难度: 中等
健壮程度: 强壮
灵活性: 灵活
伤害类型: 短距离射“钉”

Overview:
如果有人靠近墙壁，你可以将他们钉在这堵墙上，对他们造成巨大伤害。 你也会失去一些健康。
]],

	SCP939 = [[操作难度: 中等
健壮程度: 普通
灵活性: 灵活
伤害类型: 咬伤

Overview:
你留下一团无形的毒云。 闻到的玩家不能使用LMB和RMB。
]],

	SCP966 = [[操作难度: 中等
健壮程度: 差
灵活性: 灵活
伤害类型: 抓伤

Overview:
你是隐形的。 你的攻击总是会造成流血。
]],

	SCP24273 = [[操作难度: 难
健壮程度: 普通
灵活性: 普通
伤害类型: 精神控制时靠近本体秒死

Overview:
您可以向前冲刺对第一个击中的玩家造成伤害。 特殊能力可让您在短时间内控制其他玩家。 将受控制的玩家带到您身边，您将可以立即杀死他。 在控制玩家的同时自杀会导致健康损失。 
]],

	SCP3199 = [[操作难度: 非常困难
健壮程度: 差
灵活性: 敏捷
伤害类型: 抓伤+

Overview:
攻击玩家会让你狂暴并造成很深的伤口。 在狂暴状态下，您的移动速度会稍快一些，并且可以看到附近玩家的位置。 错过一次攻击或攻击已经有很深伤口的玩家，停止狂暴并施加惩罚。 拥有至少 5 个狂暴标记可以让您使用特殊攻击。 经过短暂的准备，特殊攻击会杀死玩家。
]],
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "夜视仪",
		info = "你的视野亮度增加\n黑暗区域将不再阻止你"
	}
}

local wep = {}
lang.WEAPONS = wep

wep.SCP023 = {
	editMode1 = "按 LMB 放置陷阱",
	editMode2 = "RMB - 取消，R - 旋转",
	preys = "可用猎物：%i",
	attack = "下一次攻击：%s",
	trapActive = "陷阱已激活！",
	trapInactive = "按RMB放置陷阱",
	upgrades = {
		attack1 = {
			name = "快速冷却一",
			info = "你的攻击冷却时间减少 20 秒",
		},
		attack2 = {
			name = "快速冷却二",
			info = "你的攻击冷却时间减少 20 秒\n\t• 总冷却时间：40 秒",
		},
		attack3 = {
			name = "快速冷却三",
			info = "你的攻击冷却时间减少 20 秒\n\t• 总冷却时间：60 秒",
		},
		trap1 = {
			name = "幽灵陷阱一",
			info = "你的陷阱冷却时间减少到 40 秒",
		},
		trap2 = {
			name = "幽灵陷阱二",
			info = "你的陷阱冷却时间减少到 20 秒\n幽灵移动距离增加 25 ",
		},
		trap3 = {
			name = "幽灵陷阱三",
			info = "幽灵移动距离增加 25 个单位\n\t• 总增加：50 ",
		},
		hp = {
			name = "肉体强化一",
			info = "你获得 1000 HP（也是最大 HP）和 10% 的子弹保护，但陷阱冷却时间增加 30 秒",
		},
		speed = {
			name = "肉体强化二",
			info = "你获得 10% 移动速度和额外 15% 子弹防护，但陷阱冷却时间增加 30 秒\n\t• 总防护：25%，总冷却时间增加：60 秒",
		},
		alt = {
			name = "肉体强化三",
			info = "你的攻击冷却时间减少 30 秒，你获得 15% 的子弹防护，但你不能再使用你的陷阱\n\t• 总防护：40%",
		},
	}
}

wep.SCP049 = {
	surgery = "进行手术",
	surgery_failed = "手术失败!",
	zombies = {
		normal = "标准丧尸",
		light = "疾速丧尸",
		heavy = "肉甲丧尸"
	},
	upgrades = {
		cure1 = {
			name = "血肉保护一",
			info = "获得 40% 的子弹保护",
		},
		cure2 = {
			name = "血肉保护二",
			info = "每 180 秒回复 300HP",
		},
		merci = {
			name = "对敌人的怜悯",
			info = "主要攻击冷却时间减少 2.5 秒\n你不再对附近的人类施加“门锁”效果",
		},
		symbiosis1 = {
			name = "同甘一",
			info = "进行手术后，您将恢复最大生命值的 10%",
		},
		symbiosis2 = {
			name = "同甘二",
			info = "进行手术后，你会被治愈 15% 的最大生命值\n附近的 SCP 049-2 个体被治愈其最大生命值的 10%",
		},
		symbiosis3 = {
			name = "同甘三",
			info = "手术后，你的生命值将恢复其最大生命值的 20%\n附近的 SCP 049-2 个体生命值将被恢复其最大生命值的 20%",
		},
		hidden = {
			name = "双赢",
			info = "每次手术成功获得 1 个标记\n每个标记使僵尸的生命值提高 5%\n\t• 此能力仅影响新创建的僵尸",
		},
		trans = {
			name = "慷慨",
			info = "你的僵尸生命值增加 15%\n你的僵尸获得 20% 的生命偷取\n\t• 此能力只影响新创建的僵尸",
		},
		rm = {
			name = "一分为二",
			info = "只要有可能，你就用 1 个尸体制造 2 个僵尸\n\t• 如果只有 1 个旁观者可用，则只创建 1 个僵尸\n\t• 两个僵尸的类型相同\n\t• 第二个僵尸的生命值降低 降低 50%\n\t• 第二个僵尸的伤害降低了 25%",
		},
		doc1 = {
			name = "高明的医术一",
			info = "手术时间缩短5s",
		},
		doc2 = {
			name = "高明的医术二",
			info = "手术时间缩短 5s\n\t• 手术总时间减少：10s",
		},
	}
}

wep.SCP0492 = {
	too_far = "你开始变得虚弱！"
}

wep.SCP066 = {
	wait = "下一次攻击：%is",
	ready = "攻击准备好了！",
	chargecd = "冷却时间：%is",
	upgrades = {
		range1 = {
			name = "死亡半径 I",
			info = "伤害半径增加 75",
		},
		range2 = {
			name = "死亡半径 II",
			info = "伤害半径增加 75\n\t• 总增加：150",
		},
		range3 = {
			name = "死亡半径 III",
			info = "伤害半径增加 75\n\t• 总增加：225",
		},
		damage1 = {
			name = "低音炮 I",
			info = "伤害增加到 112.5%，但半径减少到 90%",
		},
		damage2 = {
			name = "低音炮 II",
			info = "伤害增加到 135%，但半径减少到 75%",
		},
		damage3 = {
			name = "低音炮 III",
			info = "伤害增加到 200%，但半径减少到 50%",
		},
		def1 = {
			name = "音乐就是力量 I",
			info = "播放音乐时，你可以抵消 10% 的伤害",
		},
		def2 = {
			name = "音乐就是力量 II",
			info = "播放音乐时，你可以抵消 25% 的伤害",
		},
		charge = {
			name = "小短腿",
			info = "通过按下重新加载键解锁向前冲刺的能力\n\t• 技能冷却时间：20 秒",
		},
		sticky = {
			name = "火车王",
			info = "冲入人群后，你在接下来的10秒内非常NB",
		}
	}
}

wep.SCP096 = {
	charges = "再生费用：%i",
	regen = "再生 HP - 费用：%i",
	upgrades = {
		sregen1 = {
			name = "平静的精神 I",
			info = "你每 4 秒获得一次再生费用，而不是 5 秒"
		},
		sregen2 = {
			name = "平静的精神 II",
			info = "你的再生费用为你治疗 6 HP 而不是 5 HP"
		},
		sregen3 = {
			name = "平静的精神 III",
			info = "你的再生速度快了 66%"
		},
		kregen1 = {
			name = "茹毛饮血一",
			info = "成功击杀可额外再生 90 HP"
		},
		kregen2 = {
			name = "茹毛饮血二",
			info = "你为成功击杀而额外恢复 90 HP\n\t• 总治疗量增加：180HP"
		},
		hunt1 = {
			name = "狩猎开始了 I",
			info = "狩猎面积增加到4250个"
		},
		hunt2 = {
			name = "狩猎开始了 II",
			info = "狩猎面积增加到5500个"
		},
		hp = {
			name = "强化",
			info = "你的最大生命值增加到 4000 HP\n\t• 你当前的生命值没有增加"
		},
		def = {
			name = "坚硬之肤",
			info = "你获得 30% 的子弹保护"
		}
	}
}

wep.SCP106 = {
	swait = "特殊能力冷却时间：%is",
	sready = "特殊能力准备就绪！",
	upgrades = {
		cd1 = {
			name = "虚空漫步 I",
			info = "特殊能力冷却时间减少 15 秒"
		},
		cd2 = {
			name = "虚空漫步 II",
			info = "特殊技能冷却时间减少 15 秒\n\t• 总冷却时间：30 秒"
		},
		cd3 = {
			name = "虚空漫步 III",
			info = "特殊技能冷却时间减少 15 秒\n\t• 总冷却时间：45 秒"
		},
		tpdmg1 = {
			name = "衰败之触 I",
			info = "传送后获得 15 额外伤害，持续 10 秒"
		},
		tpdmg2 = {
			name = "衰败之触 II",
			info = "传送后获得 20 额外伤害，持续 20 秒"
		},
		tpdmg3 = {
			name = "衰败之触 III",
			info = "传送后获得 25 额外伤害，持续 30 秒"
		},
		tank1 = {
			name = "伤害腐蚀一",
			info = "获得 20% 的子弹伤害保护，但你会慢 10%"
		},
		tank2 = {
			name = "伤害腐蚀二",
			info = "获得 20% 的子弹伤害保护，但你会慢 10%\n\t• 总保护：40%\n\t• 总慢：20%"
		},
	}
}

wep.SCP173 = {
	swait = "特殊能力冷却时间：%is",
	sready = "特殊能力准备就绪！",
	upgrades = {
		specdist1 = {
			name = "幽灵 I",
			info = "你的特殊能力距离增加 500"
		},
		specdist2 = {
			name = "幽灵 II",
			info = "你的特殊能力距离增加 700\n\t• 总增加：1200"
		},
		specdist3 = {
			name = "幽灵 III",
			info = "你的特殊能力距离增加 800\n\t• 总增加：2000"
		},
		boost1 = {
			name = "嗜血者 I",
			info = "每次击杀人类会获得 150 点生命值，并且你的特殊技能冷却时间会减少 10%"
		},
		boost2 = {
			name = "嗜血者 II",
			info = "每次击杀人类获得300HP，特殊技能冷却时间减少25%"
		},
		boost3 = {
			name = "嗜血者 III",
			info = "每次击杀人类获得 500 生命值，特殊技能冷却时间减少 50%"
		},
		prot1 = {
			name = "混凝土重构一",
			info = "立即恢复 1000 HP 并获得 10% 的子弹伤害保护"
		},
		prot2 = {
			name = "混凝土重构二",
			info = "立即恢复 1000 HP 并获得 10% 的子弹伤害保护\n\t• 总保护：20%"
		},
		prot3 = {
			name = "混凝土重构三",
			info = "立即恢复 1000 HP 并获得 20% 的子弹伤害保护\n\t• 总保护：40%"
		},
	},
	back = "你可以按住 R 回到之前的位置",
}

wep.SCP457 = {
	swait = "特殊能力冷却时间：%is",
	sready = "特殊能力准备就绪！",
	placed = "陷阱：%i/%i",
	nohp = "HP不够！",
	upgrades = {
		fire1 = {
			name = "火炬 I",
			info = "你的燃烧半径增加 25"
		},
		fire2 = {
			name = "火炬 II",
			info = "你的燃烧伤害提高 0.5"
		},
		fire3 = {
			name = "火炬 III",
			info = "你的燃烧半径增加 50，燃烧伤害增加 0.5\n\t• 总半径增加：75\n\t• 总伤害增加：1"
		},
		trap1 = {
			name = "小惊喜 I",
			info = "陷阱寿命增加到 4 分钟，燃烧时间延长 1 秒"
		},
		trap2 = {
			name = "小惊喜 II",
			info = "陷阱寿命增加到 5 分钟，燃烧时间延长 1 秒，伤害增加 0.5\n\t• 总燃烧时间增加：2 秒"
		},
		trap3 = {
			name = "小惊喜 III",
			info = "陷阱燃烧时间延长 1 秒，伤害增加 0.5\n\t• 总燃烧时间增加：3 秒\n\t• 总伤害增加：1"
		},
		heal1 = {
			name = "燃料夺取一",
			info = "燃烧的人会治愈你额外 1 点生命值"
		},
		heal2 = {
			name = "燃料夺取二",
			info = "燃烧的人会为你额外治疗 1 点生命值\n\t• 总治疗量增加：2"
		},
		speed = {
			name = "火车",
			info = "你的速度提高了 10%"
		}
	}
}

wep.SCP682 = {
	swait = "特殊能力冷却时间：%is",
	sready = "特殊能力准备就绪！",
	s_on = "你免疫任何伤害！%is",
	upgrades = {
		time1 = {
			name = "不间断 I",
			info = "你的特殊能力持续时间增加 2.5s\n\t• 总持续时间：12.5s"
		},
		time2 = {
			name = "不间断 II",
			info = "你的特殊能力持续时间增加 2.5s\n\t• 总持续时间：15s"
		},
		time3 = {
			name = "不间断 III",
			info = "你的特殊能力持续时间增加 2.5 秒\n\t• 总持续时间：17.5 秒"
		},
		prot1 = {
			name = "适应 I",
			info = "你受到的子弹伤害减少 10%"
		},
		prot2 = {
			name = "适应 II",
			info = "你受到的子弹伤害减少 15%\n\t• 总伤害减免：25%"
		},
		prot3 = {
			name = "适应 III",
			info = "你受到的子弹伤害减少 15%\n\t• 总伤害减免：40%"
		},
		speed1 = {
			name = "狂暴冲刺 I",
			info = "使用特殊能力后，获得10%移动速度直到受到伤害"
		},
		speed2 = {
			name = "狂暴冲刺 II",
			info = "使用特殊能力后，获得20%移动速度直到受到伤害"
		},
		ult = {
			name = "再生",
			info = "受到伤害后 5 秒，恢复已损失生命值的 5%"
		},
	}
}

wep.SCP8602 = {
	upgrades = {
		charge11 = {
			name = "残酷 I",
			info = "强力攻击伤害增加5"
		},
		charge12 = {
			name = "残酷 II",
			info = "强力攻击伤害增加10\n\t• 总伤害增加：15"
		},
		charge13 = {
			name = "残酷 III",
			info = "强力攻击伤害增加10\n\t• 总伤害增加：25"
		},
		charge21 = {
			name = "加强 I",
			info = "强力攻击范围增加15"
		},
		charge22 = {
			name = "加强 II",
			info = "强力攻击范围增加15\n\t• 总范围增加：30"
		},
		charge31 = {
			name = "共同的痛苦",
			info = "当你进行强力攻击时，附近每个撞击点都会受到原始伤害的20%"
		},
	}
}

wep.SCP939 = {
	upgrades = {
		heal1 = {
			name = "嗜血 I",
			info = "你的攻击治疗你至少 22.5 HP（最多 30）"
		},
		heal2 = {
			name = "嗜血 II",
			info = "你的攻击治疗你至少 37.5 HP（最多 50）"
		},
		heal3 = {
			name = "嗜血 III",
			info = "你的攻击治疗你至少 52.5 HP（最多 70）"
		},
		amn1 = {
			name = "致命呼吸 I",
			info = "你的毒药半径增加到 100"
		},
		amn2 = {
			name = "致命呼吸 II",
			info = "你的毒药现在造成伤害：1.5 dmg/s"
		},
		amn3 = {
			name = "致命呼吸 III",
			info = "你的毒药半径增加到 125，你的毒药伤害增加到 3 dmg/s"
		},
	}
}

wep.SCP966 = {
	upgrades = {
		lockon1 = {
			name = "狂乱 I",
			info = "攻击所需时间减少到2.5s"
		},
		lockon2 = {
			name = "狂乱 II",
			info = "攻击所需时间减少到2s"
		},
		dist1 = {
			name = "猎人的召唤 I",
			info = "攻击范围增加15"
		},
		dist2 = {
			name = "猎人的召唤 II",
			info = "攻击范围增加 15\n\t• 总范围增加：30"
		},
		dist3 = {
			name = "猎人的召唤 III",
			info = "攻击范围增加 15\n\t• 总范围增加：45"
		},
		dmg1 = {
			name = "锋利的爪子 I",
			info = "攻击力增加5"
		},
		dmg2 = {
			name = "锋利的爪子 II",
			info = "攻击伤害增加 5\n\t• 总伤害增加：10"
		},
		bleed1 = {
			name = "深深的伤口 I",
			info = "你的攻击有 25% 的几率造成更高等级的流血"
		},
		bleed2 = {
			name = "深深的伤口 II",
			info = "你的攻击有 50% 的几率造成更高等级的流血"
		},
	}
}

wep.SCP24273 = {
	mind_control = "精神控制准备就绪！ 按RMB",
	mind_control_cd = "精神控制进入冷却！ 等待%is",
	dash = "攻击准备好了！",
	dash_cd = "攻击进入冷却！ 等待：%is",
	upgrades = {
		dash1 = {
			name = "无情冲锋 I",
			info = "你的攻击冷却时间减少1秒，威力增加15%"
		},
		dash2 = {
			name = "无情冲锋 II",
			info = "攻击后惩罚时间减少0.5秒，速度惩罚从50%降低到35%"
		},
		dash3 = {
			name = "无情冲锋 III",
			info = "你的攻击伤害增加 50"
		},
		mc11 = {
			name = "持久猎手 I",
			info = "你的精神控制持续时间增加 10 秒，但冷却时间增加 20 秒"
		},
		mc12 = {
			name = "持久猎手 II",
			info = "你的精神控制持续时间增加 10 秒，但冷却时间增加 25 秒\n\t• 总持续时间增加：20 秒\n\t• 总冷却时间增加：45 秒"
		},
		mc21 = {
			name = "不耐烦的猎人 I",
			info = "你的精神控制持续时间减少 5 秒，冷却时间减少 10 秒"
		},
		mc22 = {
			name = "不耐烦的猎人 II",
			info = "你的精神控制持续时间减少 10 秒，冷却时间减少 15 秒"
		},
		mc3 = {
			name = "不间断的猎人",
			info = "在精神控制期间，所有类型的伤害降低 50%"
		},
		mc13 = {
			name = "严格的法官",
			info = "在精神控制期间杀死你的猎物，冷却时间减少 40%。 精神控制范围增加 1000 米"
		},
		mc23 = {
			name = "绯红审判官",
			info = "在精神控制期间杀死你的猎物，你会恢复 400 HP。 精神控制范围增加 500 米"
		},
	}
}

wep.SCP3199 = {
	special = "特殊技能准备完毕! 按 RMB",
	upgrades = {
		regen1 = {
			name = "血之滋味 I",
			info = "处于狂暴状态时每秒回复 2 HP"
		},
		regen2 = {
			name = "血之滋味 II",
			info = "每个狂暴标记增加 10% 生命恢复率"
		},
		frenzy1 = {
			name = "猎人的游戏 I",
			info = "你的最大狂暴标记增加 1\n你的狂暴持续时间增加 20%"
		},
		frenzy2 = {
			name = "猎人的游戏 II",
			info = "你的最大狂怒标记增加 1\n你的狂暴持续时间增加 30%\n你的特殊攻击被禁用\n\t• 狂暴标记总数增加：2\n\t• 总持续时间增加：50%"
		},
		ch = {
			name = "盲怒",
			info = "你的速度提高了 25%\n你不能再检测附近人类的心跳"
		},
		egg1 = {
			name = "另一个",
			info = "购买此升级后，您会创建 1 个新的非活动蛋\n\t• 如果地图中没有蛋的空位，则不会创建蛋"
		},
		egg2 = {
			name = "遗产",
			info = "购买此升级后将激活一个非活动蛋\n\t• 这不会有影响，因为地图上没有非活动蛋"
		},
		egg3 = {
			name = "重生",
			info = "你的重生时间减少到 20 秒"
		},
	}
}

wep.SCP714 = {
	name = "SCP 714"
}

wep.HOLSTER = {
	name = "空手",
}

wep.ID = {
	name = "ID",
	pname = "名称:",
	server = "服务器:",
}

wep.CAMERA = {
	name = "监控系统",
	showname = "摄像头",
	info = "你可以通过监控系统观看设施情况\n你可以扫描检测SCP并传输至对讲机频道",
}

wep.RADIO = {
	name = "对讲机",
}

wep.NVG = {
	name = "夜视仪",
	info = "使暗区更亮并使亮区更亮的设备。有时你可以通过它们看到异常的东西"
}

wep.NVGPLUS = {
	name = "加强版夜视仪",
	showname = "夜视仪+",
	info = "夜视仪的增强版,让您可以在手持其他物品的同时使用它。\n可惜电池只能持续 10 秒”"
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
		acc = "Accountant",
		log = "Logistician",
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
		o5 = "O5"
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
		ARMORY = "军械库",
		GATE_A = "A大门",
		GATE_B = "B大门",
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

wep.KEYCARD = {
	author = "danx91",
	instructions = "Access:",
	ACC = {
		"SAFE",
		"EUCLID",
		"KETER",
		"检查点",
		"OMNI核弹",
		"一般访问",
		"A大门",
		"B大门",
		"军械库",
		"大腿骨粉碎机",
		"EC",
	},
	STATUS = {
		"ACCESS",
		"NO ACCESS",
	},
	NAMES = {
		"钥匙卡级别 1",
		"钥匙卡等级 2",
		"钥匙卡等级 3",
		"研究员钥匙卡",
		"MTF 守卫钥匙卡",
		"MTF指挥官钥匙卡",
		"钥匙卡级别 OMNI",
		"检查站安全钥匙卡",
		"混沌分裂者的破译钥匙卡",
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

wep.TASER = {
	name = "电击枪"
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

wep.TURRET = {
	name = "炮塔",
	pickup = "捡起",
	MODES = {
		off = "禁用 ",
		filter = "区分己方",
		all = "瞄准一切",
		supp = "熄火"
	}
}

wep.ALPHA_CARD1 = {
	name = "阿尔法核弹代码 #1"
}

wep.ALPHA_CARD2 = {
	name = "阿尔法核弹代码 #2"
}

wep.weapon_stunstick = "棒棒"

registerLanguage( lang, "chinese", "cn", "zh-CN" )