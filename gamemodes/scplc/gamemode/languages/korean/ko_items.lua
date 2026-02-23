local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

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
Weapons
---------------------------------------------------------------------------]]
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
