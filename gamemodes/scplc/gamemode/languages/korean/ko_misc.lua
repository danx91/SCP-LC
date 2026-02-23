local lang = LANGUAGE

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

