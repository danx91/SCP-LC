--[[-------------------------------------------------------------------------
Language: Korean
Created Date: 25.12.2021
Last Update: 02.04.2022
Translated by: joon00 (https://steamcommunity.com/profiles/76561198155974087)
---------------------------------------------------------------------------]]

local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "다음 라운드에서 SCP로 플레이할 수 있습니다",
	scpwait = "SCP로 플레이하려면 %i 라운드를 더 플레이해야 합니다",
	abouttostart = "게임이 %i 초 후에 시작됩니다!",
	kill = "플레이어를 사살하여 라운드 점수를 %d 얻었습니다! %s: %s",
	assist = "플레이어 사살 도움으로 %d 얻었습니다: %s",
	rdm = "플레이어를 사살하여 라운드 점수를 %d 잃었습니다! %s: %s",
	acc_denied = "접근 거부됨",
	acc_granted = "접근 허가됨",
	acc_omnitool = "이 문을 열려면 접근 제어기가 필요합니다",
	device_noomni = "이 장치를 사용할려면 접근 제어기가 필요합니다",
	elevator_noomni = "이 엘레베이터를 이용할려면 접근 제어기가 필요합니다",
	acc_wrong = "이 작업에는 더 높은 접근 권한이 필요합니다",
	rxpspec = "서버를 플레이하는 동안 %i 경험치를 얻었습니다!",
	rxpplay = "라운드에서 살아남고있어 %i 경험치를 얻었습니다!",
	rxpplus = "라운드 시간의 절반동안 살아남아 %i 경험치를 얻었습니다!",
	roundxp = "당신의 라운드 점수에 따라 %i 경험치를 받았습니다",
	gateexplode = "게이트 A 폭파까지: %i초",
	explodeterminated = "게이트 A가 성공적으로 파괴되었습니다",
	r106used = "SCP 106 재격리 절차는 라운드당 한번만 가능합니다",
	r106eloiid = "SCP 106 재격리 절차 시작을 위해 ELO-IID 전자기장을 비활성화합니다",
	r106sound = "SCP 106 재격리 절차를 위해 시설 방송을 활성화합니다",
	r106human = "SCP 106 재격리 절차를 시작할려면 살아있는 인간이 컨테이너 안에 있어야합니다",
	r106already = "SCP 106 가 이미 재격리되었습니다",
	r106success = "SCP 106 재격리로 라운드 점수를 %i 얻었습니다!",
	vestpickup = "조끼를 착용함",
	vestdrop = "조끼를 벗음",
	hasvest = "이미 조끼를 착용중입니다! 인벤토리에서 조끼를 먼저 벗어야합니다",
	escortpoints = "아군을 호송하여 라운드 점수를 %i 얻었습니다",
	femur_act = "대퇴골 분쇄기가 작동됨...",
	levelup = "레벨이 올랐습니다! 현재 레벨: %i",
	healplayer = "다른 플레이어를 치료하여 라운드 점수를 %i 얻었습니다",
	detectscp = "SCP를 발견하여 라운드 점수를 %i 얻었습니다",
	winxp = "시작할때 당신의 진영이 승리하여 %i 경험치를 얻었습니다",
	winalivexp = "당신의 진영이 승리하여 %i 경험치를 얻었습니다",
	upgradepoints = "새 업그레이드 포인트를 얻었습니다! '%s' 키를 눌러 사용하세요",
	prestigeup = " %s 님이 명성을 얻었습니다! 해당 플레이어의 명성 레벨: %i",
	omega_detonation = "OMEGA 핵탄두 폭발까지 %i 초 남았습니다. 즉시 지상으로 탈출하거나 방공호로 대피하세요!",
	alpha_detonation = "ALPHA 핵탄두 폭발까지 %i 초 남았습니다. 시설 내부로 대피하십시오!",
	alpha_card = "ALPHA 핵탄두 제어 카드를 삽입했습니다",
	destory_scp = "SCP 개체를 제거하여 라운드 점수를 %i 얻었습니다!",
	afk = "현재 잠수 상태입니다. 스폰 및 XP 흭득을 할 수 없습니다!",
	afk_end = "잠수 상태가 해제되었습니다.",
	overload_cooldown = "이 출입 장치의 과부하까지 %i 초 남았습니다!",
	advanced_overload = "이 문은 과부화 상태입니다! %i 초 뒤에 다시 시도하세요",
	lockdown_once = "시설 폐쇄는 라운드당 한번만 가능합니다!",
}

lang.NFailed = "NRegistry 접근에 실패함: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "당신은 탈출했습니다!",
	escapeinfo = "잘하셨습니다! 탈출까지 걸린 시간 %s",
	escapexp = "탈출하여 %i 경험치를 얻었습니다",
	escort = "당신은 호송되었습니다!",
	roundend = "라운드 종료!",
	nowinner = "무승부!",
	roundnep = "플레이어가 부족합니다!",
	roundwin = "라운드 승자: %s",
	roundwinmulti = "승리한 진영: [RAW]",
	shelter_escape = "방공호에 있어 폭발로부터 살아남았습니다!",
	alpha_escape = "폭발전에 탈출하였습니다",

	mvp = "MVP: %s 의 점수: %i",
	stat_kill = "사망한 플레이어: %i",
	stat_rdm = "RDM 사살: %i",
	stat_rdmdmg = "RDM 피해량: %i",
	stat_dmg = "받은 피해량: %i",
	stat_bleed = "출혈 피해량: %i",
	stat_106recontain = "SCP 106 가 재격리됨",
	stat_escapes = "탈출한 플레이어: %i",
	stat_escorts = "호송된 플레이어: %i",
	stat_023 = "SCP 023 이 죽인 사람: %i",
	stat_049 = "'치료'된 사람: %i",
	stat_066 = "걸작을 들은 사람: %i",
	stat_096 = "부끄럼쟁이에게 죽은 사람: %i",
	stat_106 = "시공의 폭풍 방문객 수: %i",
	stat_173 = "목이 꺾인 사람: %i",
	stat_457 = "불타없어진 사람: %i",
	stat_682 = "거대한 파충류한테 죽은 사람: %i",
	stat_8602 = "벽에 박혀버린 사람: %i",
	stat_939 = "엉덩이가 찰진 사람: %i",
	stat_966 = "예쁘게 잘린 사람: %i",
	stat_3199 = "SCP 3199 에게 암살당한 사람: %i",
	stat_24273 = "SCP 2427-3 에게 심판당한 사람: %i",
	stat_omega_warhead = "오메가 핵탄두가 폭발함",
	stat_alpha_warhead = "알파 핵탄두가 폭발함",
}

lang.NCFailed = "NCRegistry 접근에 실패함: %s"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "줍기"
hud.class = "클래스"
hud.team = "진영"
hud.prestige_points = "명성 점수"
hud.hp = "HP"
hud.stamina = "스테미너"
hud.sanity = "정신력"
hud.xp = "XP"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "좌 클릭 - 선택"
lang.eq_rmb = "우 클릭 - 버리기"
lang.eq_hold = "좌 클릭 유지 - 옮기기"
lang.eq_vest = "조끼"
lang.eq_key = "'%s' 키를 눌러 인벤토리를 엽니다"

lang.info = "정보"
lang.author = "제작"
lang.mobility = "기동성"
lang.weight = "무게"
lang.protection = "방호력"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "호위 요청",
	gatea = "게이트 A 폭파"
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "영구"
effects.bleeding = "출혈"
effects.doorlock = "문 잠김"
effects.amnc227 = "AMN-C227"
effects.insane = "정신붕괴"
effects.gas_choke = "호흡곤란"
effects.radiation = "방사능 노출"
effects.deep_wounds = "깊은 상처"
effects.heavy_bleeding = "심각한 출혈"
effects.weak_bleeding = "약한 출혈"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "클래스 뷰어"
lang.preview = "미리보기"
lang.random = "무작위"
lang.price = "가격"
lang.buy = "구매"
lang.refund = "환불"
lang.none = "없음"
lang.refunded = "제거된 모든 클래스들이 환불됨. %d 명성 점수를 얻음."

lang.details = {
	details = "세부정보",
	name = "이름",
	team = "진영",
	price = "필요한 명성 점수",
	walk_speed = "걷는 속도",
	run_speed = "달리는 속도",
	chip = "접근 권한",
	persona = "가짜 ID",
	weapons = "무기",
	class = "클래스",
	hp = "체력",
	speed = "속도",
	health = "체력",
	sanity = "정신력"
}

lang.headers = {
	support = "지원 병력",
	classes = "시설 인력",
	scp = "SCP"
}

lang.view_cat = {
	classd = "D계급 인원",
	sci = "과학자",
	mtf = "시설 경비",
	mtf_ntf = "특무부대 Epsilon-11",
	mtf_alpha = "특무부대 Alpha-1",
	ci = "혼돈의 반란",
}

--[[-------------------------------------------------------------------------
Settings
---------------------------------------------------------------------------]]
lang.settings = {
	settings = "게임모드 설정",

	none = "없음",
	press_key = "> 키를 누르세요 <",
	client_reset = "클라이언트 설정 초기화",
	server_reset = "서버 설정 초기화",

	client_reset_desc = "당신은 게임모드의 모든 클라이언트 설정을 초기화할려고 합니다.\n이 작업은 되돌릴 수 없습니다!",
	server_reset_desc = "보안상의 이유 여기서 서버 설정을 초기화할 수 없습니다.\n서버 설정을 초기화할려면, 콘솔창에 'slc_factory_reset' 를 입력하고 절차를 따르십시오.\n이 작업은 취소할 수 없으며 모든 것이 재설정되므로 주의하십시오!",

	popup_ok = "예",
	popup_cancel = "취소",
	popup_continue = "계속",

	panels = {
		binds = "단축키",
		reset = "게임모드 초기화",
		cvars = "게임모드 설정편집",
	},

	binds = {
		eq_button = "인벤토리",
		upgrade_tree_button = "SCP 특성 업그레이드",
		ppshop_button = "클래스 뷰어",
		settings_button = "게임모드 설정",
		scp_special = "SCP 특수 능력"
	}
}

lang.gamemode_config = {
	loading = "불러오는 중...",

	categories = {
		general = "일반",
		round = "라운드",
		xp = "XP",
		support = "지원",
		warheads = "핵탄두",
		afk = "잠수",
		time = "시간",
		premium = "프리미엄",
		scp = "SCP",
	}
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "미연결"

lang.scoreboard = {
	name = "스코어보드",
	playername = "이름",
	ping = "핑",
	prestige = "명성",
	level = "레벨",
	score = "점수",
	ranks = "등급",
}

lang.ranks = {
	author = "제작자",
	vip = "VIP",
	tester = "테스터",
	contributor = "기여자",
	translator = "번역자",
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
	tree = "%s 업그레이드 메뉴",
	points = "남은 포인트",
	cost = "요구 포인트",
	owned = "소유중",
	requiresall = "다음이 필요함",
	requiresany = "다음이 필요함",
	blocked = "다음에 의해 막힘"
}

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
local scp_hud = {}
lang.SCPHUD = scp_hud

scp_hud.skill_not_ready = "능력이 아직 준비되지 않았습니다!"
scp_hud.skill_cant_use = "지금은 능력을 사용할 수 없습니다!"

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "실험체",
	class = "클래스",
	team = "소속",
	status = "상태",
	objectives = "목표",
	details = "세부 정보",
	registry_failed = "info_screen_registry 오류"
}

lang.info_screen_registry = {
	escape_time = "당신은 %s 분만에 탈출하였습니다",
	escape_xp = "당신은 %s 경험치를 얻었습니다",
	escape1 = "당신은 시설을 탈출하였습니다",
	escape2 = "핵탄두 폭발 카운트 중 탈출하였습니다",
	escape3 = "방공호에서 폭발로부터 살아남았습니다",
	escorted = "당신은 호송되었습니다",
	killed_by = "당신을 사살한 플레이어: %s",
	suicide = "당신은 자살하였습니다",
	unknown = "당신이 죽은 이유를 알 수 없습니다",
	hazard = "당신은 생화학적 피해로 사망하였습니다",
	alpha_mia = "마지막 목격 장소: 지상",
	omega_mia = "마지막 목격 장소: 시설 내부",
}

lang.info_screen_type = {
	alive = "생존",
	escaped = "탈출",
	dead = "사망",
	mia = "실종",
	unknown = "알 수 없음",
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
lang.nothing = "없음"
lang.exit = "나가기"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "게임모드 컨텐츠",
	msg = [[게임모드 필수 애드온 일부가 없는 것으로 보입니다. 이러한 경우 (텍스쳐/모델/사운드) 가 없어 게임 플레이 환경에 문제가 생길 수 있습니다
현재 %i 개의 애드온이 %i 개의 애드온 중에서 확인되지 않습니다. 지금 바로 설치하시겠습니까? (이 방법을 통해 설치하거나 창작마당에서 설치할 수도 있습니다)]],
	no = "아니요",
	download = "다운로드",
	workshop = "창작마당 열기",
	downloading = "다운로드중",
	mounting = "마운팅중",
	idle = "다운로드를 기다리는 중...",
	processing = "애드온 처리중: %s\n진행상황: %s",
	cancel = "취소"
}

misc.omega_warhead = {
	idle = "OMEGA 핵탄두 대기중\n\n입력을 기다리는 중...",
	waiting = "OMEGA 핵탄두 대기중\n\n입력 승인됨!\n두번째 입력을 기다리는 중...",
	failed = "OMEGA 핵탄두 활성화 실패\n\n두번째 입력에 실패함!\n%i 초 동안 대기하십시오",
	no_remote = "OMEGA 핵탄두 활성화 실패\n\n핵탄두와 연결에 실패했습니다!\t",
	active = "OMEGA 핵탄두 활성화\n\n즉시 대피하십시오!\n폭파까지 %.2f 초",
}

misc.alpha_warhead = {
	idle = "ALPHA 핵탄두 대기중\n\n폭파 코드 입력을 기다리는 중...",
	ready = "ALPHA 핵탄두 대기중\n\n코드 승인됨!\n활성화를 기다리는 중...",
	no_remote = "ALPHA 핵탄두 활성화 실패\n\n핵탄두와 연결에 실패했습니다!\t",
	active = "ALPHA 핵탄두 활성화\n\n즉시 대피하십시오!\n폭파까지 %.2f 초",
}

misc.buttons = {
	MOUSE1 = "좌 클릭",
	MOUSE2 = "우 클릭",
	MOUSE3 = "휠 클릭",
}

misc.inventory = {
    unsearched = "미확인됨", 
}
--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "시설 경비용 조끼"
vest.heavyguard = "무장 경비용 조끼"
vest.specguard = "특수 경비용 조끼"
vest.guard_medic = "시설 의무병용 조끼"
vest.ntf = "특무대 제식 방탄복"
vest.mtf_medic = "특무대 의무병 방탄복"
vest.ntfcom = "특무대 지휘관 방탄복"
vest.alpha1 = "특무대 알파-1 방탄복"
vest.ci = "혼돈의 반란 방탄복"
vest.fire = "방화 조끼"
vest.electro = "절연 조끼"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "화상 피해량"
dmg.SHOCK = "전기 피해량"
dmg.BULLET = "총알 피해량"
dmg.FALL = "추락 피해량"

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "관전자"
teams.CLASSD = "D계급"
teams.SCI = "과학자"
teams.MTF = "MTF"
teams.CI = "혼돈의 반란"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "알 수 없음"

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

classes.classd = "D계급"
classes.veterand = "D계급 장기수"
classes.kleptod = "D계급 절도범"
classes.ciagent = "혼돈의 반란 공작원"

classes.sciassistant = "과학자 조수"
classes.sci = "과학자"
classes.seniorsci = "연구 감독관"
classes.headsci = "박사"

classes.guard = "시설 경비"
classes.chief = "전술대응 담당관"
classes.lightguard = "경무장 경비원"
classes.heavyguard = "무장 경비원"
classes.specguard = "특수 경비원"
classes.guardmedic = "시설 의무병"
classes.tech = "시설 보안 기술자"
classes.cispy = "혼돈의 반란 스파이"

classes.ntf_1 = "구미호 이등병"
classes.ntf_2 = "구미호 돌격병"
classes.ntf_3 = "구미호 소총수"
classes.ntfcom = "구미호 지휘관"
classes.ntfsniper = "구미호 지정사수"
classes.ntfmedic = "구미호 의무병"
classes.alpha1 = "특무대 Alpha-1"
classes.alpha1sniper = "특무대 Alpha-1 지정사수"
classes.ci = "혼돈의 반란"
classes.cicom = "혼돈의 반란 현장지휘관"

local classes_id = {}
lang.CLASSES_ID = classes_id

classes_id.ntf_1 = "구미호"
classes_id.ntf_2 = "구미호"
classes_id.ntf_3 = "구미호"

--[[-------------------------------------------------------------------------
Class Info - NOTE: Each line is limited to 48 characters!
Screen is designed to hold max of 5 lines of text and THERE IS NO internal protection!
Note that last (5th) line should be shorter to prevent text overlaping (about 38 characters)
---------------------------------------------------------------------------]]
local generic_classd = [[- 시설에서 탈출하세요
- 혼돈의 반란과 협력하세요
- 다른 팀은 피하세요]]

local generic_sci = [[- 시설에서 탈출하세요
- MTF와 협력하세요
- 다른 팀은 피하세요]]

local generic_guard = [[- 과학자가 탈출하게 도우세요
- MTF와 협력하세요
- 다른 개체를 모두 무력화시키세요]]

local generic_ntf = [[- 과학자가 탈출하게 도우세요
- 다른 개체를 모두 무력화시키세요]]

local generic_scp = [[- 시설에서 탈출하세요
- 모두를 제거하세요
- 다른 SCP와 협력하세요]]

local generic_scp_friendly = [[- 시설에서 탈출하세요
- 인간과 협력하세요
- 또는 SCP와 협력하세요]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	ciagent = [[- D계급 인원의 탈출을 도우세요
- 다른 개체를 모두 무력화시키세요]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- 과학자가 탈출하도록 도우세요
- 다른 개체를 무력화시키세요
- 당신의 부하에게 명령하세요]],

	guardmedic = [[- 과학자가 탈출하도록 도우세요
- 다른 개체를 무력화시키세요
- 아군 경비를 치료하여 도우세요]],

	tech = [[- 과학자가 탈출하도록 도우세요
- 다른 개체를 무력화시키세요
- 아군 경비를 포탑으로 지원하세요]],

	cispy = [[- D계급 인원의 탈출을 도우세요
- 정체를 숨기며 다른 개체를 무력화시키세요
- 시설 보안을 교란시키세요]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- 과학자가 탈출하도록 도우세요
- 아군 세력을 치료하여 도우세요
- 다른 개체를 모두 무력화시키세요]],

	ntfcom = [[- 과학자가 탈출하도록 도우세요
- 다른 개체를 모두 무력화시키세요
- 당신의 부하에게 명령하세요]],

	ntfsniper = [[- 과학자가 탈출하도록 도우세요
- 다른 개체를 모두 무력화시키세요
- 팀의 후방에서 지원하세요]],

	alpha1 = [[- 무슨 수를 써서든 시설을 보호하세요
- 다른 개체를 모두 제거하세요
- 당신의 소속은 ]].."[REDACTED]",

	alpha1sniper = [[- 무슨 수를 써서든 시설을 보호하세요
- 다른 개체를 모두 제거하세요
- 당신의 소속은 ]].."[REDACTED]",

	ci = [[- D계급 인원의 탈출을 도우세요
- 재단 인원을 모두 무력화시키세요
- 현장 지휘관의 지시에 따르세요]],

	cicom = [[- D계급 인원의 탈출을 도우세요
- 재단 인원을 모두 무력화시키세요
- 다른 반군들에게 명령하세요]],

	SCP023 = generic_scp,

	SCP049 = [[- 시설에서 탈출하세요
- 다른 SCP와 협력하세요
- 사람들을 '치료'하세요]],

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
	classd = [[난이도: 쉬움
정신력: 평범함
민첩성: 평범함
무장 여부: 비무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 혼돈의 반란

미리보기:
가장 기본적인 클래스. SCP와 재단 직원을 피해 다른 사람들과 협력해야합니다. 혼돈의 반란에 의해 호송될 수 있습니다.
]],

	veterand = [[난이도: 쉬움
정신력: 높음
민첩성: 빠름
무장 여부: 비무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 혼돈의 반란

미리보기:
오랫동안 시설에 눌러앉아 짬이 생겼습니다. 기본적인 시설 접근 권한을 가지고 있습니다. 다른 죄수들과 협력하고 혼돈의 반란과 합류해야합니다.
]],

	kleptod = [[난이도: 어려움
정신력: 장애
민첩성: 매우 빠름
무장 여부: 경무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 혼돈의 반란

미리보기:
높은 유틸성을 가진 클래스입니다. 시작할 때 랜덤한 아이템을 가지고 시작합니다. 다른 죄수들과 협력하고 혼돈의 반란과 합류해야합니다.
]],

	ciagent = [[난이도: 보통
정신력: 매우 높음
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: D계급 인원
호위 병력: 없음

미리보기:
테이저건으로 무장한 혼돈의 반란 요원입니다. D계급 인원들을 도와 탈출시켜야합니다. D계급 인원을 호송할 수 있습니다.
]],

	sciassistant = [[난이도: 보통
정신력: 평범함
민첩성: 평범함
무장 여부: 경무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 시설 경비, MTF

미리보기:
가장 기본적인 클래스. 재단 인원과 협력하고 SCP를 피해야합니다. MTF에 의해 호송될 수 있습니다.
]],

	sci = [[난이도: 보통
정신력: 평범함
민첩성: 평범함
무장 여부: 경무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 시설 경비, MTF

미리보기:
재단의 소중한 인력인 과학자입니다. 재단 인원과 협력하고 SCP를 피해야합니다. MTF에 의해 호송될 수 있습니다.
]],

	seniorsci = [[난이도: 쉬움
정신력: 높음
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 시설 경비, MTF

미리보기:
재단의 연구에 큰 영향을 주는 연구 감독관입니다. 매우 높은 접근 권한을 가지고 있습니다. 재단 인원과 협력하고 SCP를 피해야합니다. MTF에 의해 호송될 수 있습니다.
]],

	headsci = [[난이도: 쉬움
정신력: 높음
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 가능
호위 가능: 없음
호위 병력: 시설 경비, MTF

미리보기:
재단의 높은 신임을 받는 과학자입니다. 더 높은 유틸성과 체력을 가졌습니다. 재단 인원과 협력하고 SCP를 피해야합니다. MTF에 의해 호송될 수 있습니다.
]],

	guard = [[난이도: 쉬움
정신력: 평범함
민첩성: 평범함
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기본적인 시설의 경비원입니다. 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	lightguard = [[난이도: 어려움
정신력: 장애
민첩성: 매우 빠름
무장 여부: 경무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
경무장한 시설 경비입니다. 일반적인 경비보다 약하지만 빠른 속도를 가졌습니다. 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	heavyguard = [[난이도: 보통
정신력: 높음
민첩성: 매우 느림
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
중무장한 경비원입니다. 방호력이 높고 더 높은 체력을 가졌습니다. 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	specguard = [[난이도: 어려움
정신력: 높음
정신력: 느림
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
특수 경비원입니다. 저위험군 진입에 탁월하고 강력한 무장을 하고있습니다. 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	chief = [[난이도: 쉬움
정신력: 평범함
민첩성: 평범함
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
시설의 전술대응 담당관입니다. 일반 경비보다 강력한 무장을 하고있으며 높은 접근 권한을 가지고있습니다. 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	guardmedic = [[난이도: 어려움
정신력: 높음
민첩성: 빠름
무장 여부: 경무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
시설의 의무병입니다. 기본적으로 의료키트와 테이저건을 가지고 시작합니다. 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	tech = [[난이도: 어려움
정신력: 평범함
민첩성: 평범함
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
시설의 보안 기술자입니다. 설치가능한 자동 포탑을 가지고있습니다 (E 키를 누른 상태를 유지하여 3가지 모드로 변경가능). 재단 인원들을 호위하고 SCP 개체를 제거해야합니다. 과학자를 호송할 수 있습니다.
]],

	cispy = [[난이도: 매우 어려움
정신력: 평범함
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: D계급 인원
호위 병력: 없음

미리보기:
시설 경비로 위장한 혼돈의 반란 스파이입니다. 일반 경비와 똑같이 무장했습니다. 시셜 경비들을 속이고 D계급 인원의 탈출을 도와야합니다.
]],

	ntf_1 = [[난이도: 보통
정신력: 평범함
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 구미호의 부대원입니다. 기관단총으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	ntf_2 = [[난이도: 보통
정신력: 평범함
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 구미호의 부대원입니다. 샷건으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	ntf_3 = [[난이도: 보통
정신력: 평범함
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 구미호의 부대원입니다. 돌격소총으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	ntfmedic = [[난이도: 어려움
정신력: 높음
민첩성: 빠름
무장 여부: 경무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 구미호의 부대원입니다. 권총으로 무장하고 의료키트를 가지고 있습니다 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	ntfcom = [[난이도: 어려움
정신력: 높음
민첩성: 매우 빠름
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 구미호의 지휘관입니다. 지정사수 소총으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	ntfsniper = [[난이도: 어려움
정신력: 평범함
민첩성: 평범함
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 구미호의 부대원입니다. 소총으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	alpha1 = [[난이도: 보통
정신력: 살인적이게 높음
민첩성: 매우 빠름
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 최고 수준인 기동특무부대 알파-1 통칭 붉은 오른손입니다. 매우 강력한 무장을 하고있으며 돌격소총으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	alpha1sniper = [[난이도: 어려움
정신력: 살인적이게 높음
민첩성: 매우 빠름
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: 과학자
호위 병력: 없음

미리보기:
기동특무부대 최고 수준인 기동특무부대 알파-1 통칭 '붉은 오른손'입니다. 매우 강력한 무장을 하고있으며 지정사수 소총으로 무장했습니다. 시설 내부로 진입해 재단 인원들을 보호해야합니다. SCP개체와 D계급 인원은 제거해야합니다.
]],

	ci = [[난이도: 보통
정신력: 높음
민첩성: 빠름
무장 여부: 무장
탈출 가능 여부: 불가능
호위 가능: D계급 인원
호위 병력: 없음

미리보기:
'붉은 오른손' 으로부터 파생된 최고의 앨리트 요원들로 구성된 혼돈의 반란입니다. 이전에는 재단의 소속이었지만 이제는 재단과 적대적입니다. 시설로 진입해 D계급 인원을 생포하고 재단 인원을 제거해야합니다.
]],

	cicom = [[난이도: 보통
정신력: 살인적이게 높음
민첩성: 빠름
무장 여부: 중무장
탈출 가능 여부: 불가능
호위 가능: D계급 인원
호위 병력: 없음

미리보기:
'붉은 오른손' 으로부터 파생된 최고의 앨리트 요원들로 구성된 혼돈의 반란입니다. 매우 강력한 무장을 하고있습니다. 이전에는 재단의 소속이었지만 이제는 재단과 적대적입니다. 시설로 진입해 D계급 인원을 생포하고 재단 인원을 제거해야합니다.
]],

--TODO: New SCP translations
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "사냥꾼의 시야",
		info = "시야가 더 밝게 보입니다\n어둠은 더 이상 당신을 방해하지 못합니다"
	}
}

local wep = {}
lang.WEAPONS = wep

--TODO: New SCP translations

wep.SCP500 = {
	name = "SCP 500",
	death_info = "목에 SCP 500 이 걸려 질식했습니다",
	text_used = "알약을 삼키자 몸이 훨씬 나아진 기분이 듭니다",
}

wep.SCP714 = {
	name = "SCP 714"
}

wep.SCP1025 = {
	name = "SCP 1025",
	diseases = {
		arrest = "심장 마비",
		mental = "정신 질환",
		asthma = "천식",
		blindness = "시력 장애",
		hemo = "혈우병",
		oste = "골다공증",

		adhd = "ADHD",
		throm = "혈소판 증가증",
		urbach = "우르바흐-비테병",

		gas = "팀파나이트",
	},
	descriptions = {
		arrest = "심정지는 심장이 펌프질을 하는 것에 문제가 생겨 혈류가 공급되지 않는 것입니다. 보통 의식 상실 및 호흡 곤란이 징후로 나타납니다. 몇몇 사람들은 심장마비 이전에 가슴 통증, 숨가쁨 또는 메스꺼움을 경험할 수 있습니다. 한쪽 팔에 통증이 퍼지는 것은 장기간의 권태감 및 심장의 전반적인 약화와 마찬가지로 일반적인 증상입니다. 몇 분 이내에 치료를 하지 않으면 대부분 사망에 이르게됩니다.",
		asthma = "천식은 호흡 곤란을 일으키는 염증성 기도 폐쇄 질환입니다. 주로 기침, 색색거리는 소리, 숨이 차는 증상이 반복적으로 나타납니다. 이것은 하루에 몇 번 또는 일주일에 몇 번 발생할 수 있습니다.",
		blindness = "시력 손상 또는 시각 상실이라고도 불리는 시각 장애는 안경과 같은 일반적인 수단으로는 해결할 수 없는 문제일정도로 심각하게 시력이 저하된 것입니다. 실명이라는 용어는 완전히 또는 거의 시력을 상실한 경우에 사용합니다.",
		hemo = "혈우병(헤모필리아)는 X 염색체에 있는 유전자의 선천성 또는 돌연변이로 인해 혈액 내의 응고인자가 부족하게 되어 발생하는 유전 및 출혈성 질환입니다. 혈우병을 경험하는 사람은 부상 후 이전보다 더 오랫동안 출혈이 발생하고 쉽게 멍이 들고 관절이나 뇌출혈 위험이 높아집니다. 환자의 중증에 따라서 증상이 조금씩 다릅니다. 일반적인 증상은 내부 또는 외부의 출혈입니다.",
		oste = "골다공증은 뼈가 얇아지면서 질량이 줄어들고 미세한 구조적 악화로 인해 약해져 결과적으로 골절 위험이 크게 증가하는 전신성 골격 장애입니다. 노인들의 뼈가 부러지는 가장 흔한 원인입니다. 일반적으로 부러지는 뼈는 척추뼈, 팔뚝 뼈 및 엉덩이가 포함됩니다. 뼈가 부러지기 전까지는 일반적으로 증상이 없습니다.",
		
		adhd = "주의력 결핍 과잉 행동 장애(ADHD)는 주의력 결핍, 과잉행동, 충동성이 특징인 신경 발달 장애로 보통 어린 나이에 발병합니다. ADHD 환자는 감정 조절에 어려움을 겪거나 실행 기능에 문제가 생길수 있습니다. 또한, 이것은 다른 정신 질환을 유발할 수도 있습니다.",
		throm = "혈소판 증가증은 혈액 내 혈소판 수가 높은 상태입니다. 높은 혈소판 수는 임상 문제를 나타내는 것은 아니며 일상적인 전체 혈구 수에서 확인할 수 있습니다. 하지만, 혈소판 수 증가가 이차적인 과정으로 인한 것이 아니란 것을 확실히 하기위해선 확실한 의료 진단이 필요합니다.",
		urbach = "우르바흐-비테 증후군은 매우 드문 열성 유전 질환입니다. 증상은 개인에 따라 매우 다양합니다. 우르바흐-비테병은 측두엽 양측에 대칭적인 석회화를 보입니다. 이러한 석회화는 종종 편도체에 영향을 미칩니다. 편도체는 생물학적으로 관련된 자극과 정서적 장기 기억, 특히 공포와 관련된 자극을 처리하는 데 관여하는 것으로 알려졌습니다.",
	},
	death_info_arrest = "갑작스러운 심장 마비로 사망했습니다"
}

wep.HOLSTER = {
	name = "비무장",
}

wep.ID = {
	name = "ID 카드",
	pname = "이름:",
	server = "서버:",
}

wep.CAMERA = {
	name = "감시 장치",
	showname = "감시 카메라",
	info = "시설 내부에서 무슨 일이 일어나는 지 볼 수 있게합니다.\n또한 SCP 개체를 스캔하고 당신의 무전기 채널로 전달합니다.",
}

wep.RADIO = {
	name = "무전기",
}

wep.NVG = {
	name = "NVG",
	info = "적외선 투시경 - 어두운 곳이 밝게 보이도록 합니다.\n일부 SCP 개체를 볼 수도 있습니다."
}

wep.NVGPLUS = {
	name = "NVG+",
	showname = "NVG+",
	info = "고감도의 적외선 투시경입니다, 사용하는 동안 다른 아이템을 들 수 있습니다.\n하지만 배터리 수명의 수명이 매우 짧습니다"
}

wep.ACCESS_CHIP = {
	name = "권한 칩",
	cname = "권한 칩 - %s",
	showname = "권한 칩",
	pickupname = "권한 칩",
	clearance = "권한 등급: %i",
	hasaccess = "출입 가능:",
	NAMES = {
		general = "기본",
		jan1 = "잡역부",
		jan = "청소부",
		jan2 = "청소부2",
		acc = "행정 업무부",
		log = "물류 처리반",
		sci1 = "과학자 조수",
		sci2 = "과학자",
		sci3 = "연구 감독관",
		spec = "격리 전문가",
		guard = "시설 경비",
		chief = "보안 책임자",
		mtf = "MTF",
		com = "MTF 지휘관",
		hacked3 = "혼돈의 반란 장치 3",
		hacked4 = "혼돈의 반란 장치 4",
		hacked5 = "혼돈의 반란 장치 5",
		director = "기지 이사관",
		o5 = "O5"
	},
	ACCESS = {
		GENERAL = "기본",
		SAFE = "안전",
		EUCLID = "유클리드",
		KETER = "케테르",
		OFFICE = "사무실",
		MEDBAY = "의무실",
		CHECKPOINT_LCZ = "저위험군 검문소",
		CHECKPOINT_EZ = "고위험군 검문소",
		WARHEAD_ELEVATOR = "핵탄두실 승강기",
		EC = "전력 센터",
		ARMORY = "무기고",
		GATE_A = "게이트 A",
		GATE_B = "게이트 B",
		FEMUR = "대퇴골 분쇄",
		ALPHA = "Alpha 핵탄두",
		OMEGA = "Omega 핵탄두",
		PARTICLE = "고휘도 방전 포탑",
	},
}

wep.OMNITOOL = {
	name = "접근 제어기",
	cname = "접근 제어기 - %s",
	showname = "접근 제어기",
	pickupname = "접근 제어기",
	none = "없음",
	chip = "설치된 칩: %s",
	clearance = "권한 등급: %i",
	SCREEN = {
		loading = "불러오는 중",
		name = "접근 제어기 v4.78",
		installing = "새로운 칩 설치 중...",
		ejecting = "칩을 분리하는 중...",
		ejectwarn = "설치된 칩을 분리합니까?",
		ejectconfirm = "키를 한번 더 눌러 실행합니다...",
		chip = "설치된 칩:",
	},
}

wep.MEDKIT = {
	name = "의료키트 (남은 사용 횟수: %d)",
	showname = "의료키트",
	pickupname = "의료키트",
}

wep.MEDKITPLUS = {
	name = "대형 의료키트 (남은 사용 횟수: %d)",
	showname = "의료키트+",
	pickupname = "의료키트+",
}

wep.TASER = {
	name = "테이저건"
}

wep.FLASHLIGHT = {
	name = "손전등"
}

wep.BATTERY = {
	name = "배터리"
}

wep.GASMASK = {
	name = "방독면"
}

wep.TURRET = {
	name = "자동 포탑",
	pickup = "회수",
	MODES = {
		off = "비활성화",
		filter = "재단 인원 제외",
		all = "보이는 모든 것을 공격",
		supp = "제압 사격"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALPHA 핵탄두 코드 #1"
}

wep.ALPHA_CARD2 = {
	name = "ALPHA 핵탄두 코드 #2"
}

wep.weapon_stunstick = "진압봉"

RegisterLanguage( lang, "korean", "ko" )
SetLanguageFlag( "korean", LANGUAGE.EQ_LONG_TEXT )
