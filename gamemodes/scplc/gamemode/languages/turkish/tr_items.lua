local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
Vests
---------------------------------------------------------------------------]]
local vest = {}
lang.VEST = vest

vest.guard = "Güvenlik Görevlisi Yeleği"
vest.heavyguard = "Ağır Güvenlik Yeleği"
vest.specguard = "Uzman Güvenlik Yeleği"
vest.guard_medic = "Sıhhıyeci Yeleği"
vest.ntf = "MTF NTF Yeleği"
vest.mtf_medic = "MTF NTF Sıhhıyeci Yeleği"
vest.ntfcom = "MTF NTF Komutan Yeleği"
vest.alpha1 = "MTF Alfa-1 Yeleği"
vest.ci = "Kaos İsyancısı Yeleği"
vest.fire = "Alev Koruması Yeleği"
vest.electro = "Elektrik Koruması Yeleği"

local dmg = {}
lang.DMG = dmg

dmg.BURN = "Alev Hasarı"
dmg.SHOCK = "Elektrik Hasarı"
dmg.BULLET = "Mermi Hasarı"
dmg.FALL = "Düşme Hasarı"

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
wep.SCP714 = {
	name = "SCP 714"
}

wep.HOLSTER = {
	name = "Kılıf",
}

wep.ID = {
	name = "ID",
	pname = "Name:",
	server = "Server:",
}

wep.CAMERA = {
	name = "Gözetim Sistemi",
	showname = "Kameralar",
	info = "Kameralar tesiste ne olup bittiğini görmeni sağlar.\nAyrıca SCP'leri tarama ve bu bilgiyi mevcut radyo kanalınıza iletme yeteneği sağlar.",
}

wep.RADIO = {
	name = "Radio",
}

wep.NVG = {
	name = "GGG",
	info = "Gece Görüş Gözlüğü - Karanlık alanları daha parlak hale getiren ve parlak alanları daha da parlak hale getiren cihaz.\nBazı anormal varlıklar görebilirsiniz."
}

wep.NVGPLUS = {
	name = "GGGG",
	showname = "GGG+",
	info = "Gelişmiş gece görüş gözlüğü, elinde başka eşyalar varken kullanabilmeni sağlar.\nMalesef bataryası sadece 10 saniye dayanır."
}

wep.ACCESS_CHIP = {
	name = "Erişim Çipi",
	cname = "Erişim Çipi - %s",
	showname = "ÇİP",
	pickupname = "ÇİP",
	clearance = "Erişim SeviEveti: %i",
	hasaccess = "Erişme izni verir:",
	NAMES = {
		general = "Genel",
		jan1 = "Hademe",
		jan = "Hademe",
		jan2 = "Kıdemli Hademe",
		acc = "Muhasebeci",
		log = "Lojistikçi",
		sci1 = "Araştırmacı Seviye 1",
		sci2 = "Araştırmacı Seviye 2",
		sci3 = "Araştırmacı Seviye 3",
		spec = "Containment Specialist",
		guard = "Güvenlik",
		chief = "Güvenlik Amiri",
		mtf = "MTF",
		com = "MTF Kumandan",
		hacked3 = "Hacked 3",
		hacked4 = "Hacked 4",
		hacked5 = "Hacked 5",
		director = "Site Yöneticisi",
		o5 = "O5"
	},
	ACCESS = {
		GENERAL = "Genel",
		SAFE = "Safe",
		EUCLID = "Euclid",
		KETER = "Keter",
		OFFICE = "Ofis",
		MEDBAY = "MedBay",
		CHECKPOINT_LCZ = "Kontrol Noktası LCZ-HCZ",
		CHECKPOINT_EZ = "Kontrol Noktası EZ-HCZ",
		WARHEAD_ELEVATOR = "Savaş Başlığı Asansör",
		EC = "Elektrik Merkezi",
		ARMORY = "Cephanelik",
		GATE_A = "Geçit A",
		GATE_B = "Geçit B",
		FEMUR = "Uyluk Kırıcı",
		ALPHA = "Alfa Savaş Başlığı",
		OMEGA = "Omega Savaş Başlığı",
		PARTICLE = "Parçacık Topu",
	},
}

wep.OMNITOOL = {
	name = "Omnitool",
	cname = "Omnitool - %s",
	showname = "OMNITOOL",
	pickupname = "OMNITOOL",
	Yok = "YOK",
	chip = "Yüklü Çip: %s",
	clearance = "Erişim SeviEveti: %i",
	SCREEN = {
		loading = "Yükleniyor",
		name = "Omnitool v4.78",
		installing = "Yeni çip yükleniyor...",
		ejecting = "Erişim çipi çıkartılıyor...",
		ejectwarn = "Çipi çıkarmak istediğine emin misin?",
		ejectconfirm = "Onaylamak için bir daha basın...",
		chip = "Yüklü Çip:",
	},
}

wep.KEYCARD = {
	author = "danx91",
	instructions = "Erişim:",
	ACC = {
		"SAFE",
		"EUCLID",
		"KETER",
		"Kontrol Noktası",
		"OMEGA Savaş Başlığı",
		"Genel Erişim",
		"Geçit A",
		"Geçit B",
		"Armory",
		"UYLUK KIRICI",
		"EC",
	},
	STATUS = {
		"ERİŞİM",
		"ERİŞİM YOK",
	},
	NAMES = {
		"Kart Level 1",
		"Kart Level 2",
		"Kart Level 3",
		"Araştırmacı Kartı",
		"MTF Bekçi Kartı",
		"MTF Kumandan Kartı",
		"Kart Seviye OMNI",
		"Kontrol Noktası Bekçi Kartı",
		"Hacklenmiş Kaos İsyancısı Kartı",
	},
}

wep.MEDKIT = {
	name = "Medkit (Kalan kullanım: %d)",
	showname = "Medkit",
	pickupname = "Medkit",
}

wep.MEDKITPLUS = {
	name = "Büyük Medkit (Kalan kullanım: %d)",
	showname = "Medkit+",
	pickupname = "Medkit+",
}

wep.TASER = {
	name = "Şok Tabancası"
}

wep.FLASHLIGHT = {
	name = "Fener"
}

wep.BATTERY = {
	name = "Batarya"
}

wep.GASMASK = {
	name = "Gaz Maskesi"
}

wep.TURRET = {
	name = "Taret",
	pickup = "Al",
	MODES = {
		off = "Devre dışı bırak",
		filter = "Filtre",
		all = "Herşeyi hedefle",
		supp = "Bastırma Ateşi"
	}
}

wep.ALPHA_CARD1 = {
	name = "ALFA Savaş Başlığı Kodları #1"
}

wep.ALPHA_CARD2 = {
	name = "ALFA Savaş Başlığı Kodları #2"
}

wep.weapon_stunstick = "Şoksopası"