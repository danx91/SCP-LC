--[[-------------------------------------------------------------------------
Language: Türkçe
Date: 12.08.2021
Translated by: ๖̶̶̶ζ͜͡Akane
Updated in day 12.08.2021 by: Zaptyp (https://steamcommunity.com/id/Zaptyp/)
---------------------------------------------------------------------------]]

local lang = {}

--[[-------------------------------------------------------------------------
NRegistry
---------------------------------------------------------------------------]]
lang.NRegistry = {
	scpready = "Bir sonraki tur SCP olarak seçilebilirsin",
	scpwait = "%i tur sonra yeniden scp olarak seçilebileceksin",
	abouttostart = "Oyun %i saniye içinde başlayacak!",
	kill = "%d puan kazandın %s öldürdüğün için: %s!",
	assist = "Asist yaptığın için %d puan kazandın! : %s!",
	rdm = " %d puan kaybettin %s öldürdüğün için: %s!",
	acc_denied = "Erişim reddedildi",
	acc_granted = "Erişim verildi",
	acc_omnitool = "Bu kapıyı kullanmak için bir OmniTool gerekmektedir",
	device_noomni = "Bu aleti kullanmak için bir OmniTool gerekmektedir",
	elevator_noomni = "Bu asansörü kullanmak için bir OmniTool gerekmektedir",
	acc_wrong = "Bu hareketi gerçekleştirmek için daha yüksek yetki seviEveti gerekmektedir",
	rxpspec = "Bu sunucuda oynadığın için %i deneyim puanı kazandın!",
	rxpplay = "Tur boyunca canlı kaldığın için %i deneyim puanı kazandın!",
	rxpplus = "Turun yarısından fazla hayatta kaldığın için %i deneyim puanı kazandın!",
	roundxp = "Puanların için %i deneyim puanı kazandın!",
	gateexplode = "Geçit A patlamasına kalan süre: %i",
	explodeterminated = "Geçit A yok edilmesi sona erdi",
	r106used = "SCP 106 zaptetme protokolü tur başına bir kez kullanılabilir",
	r106eloiid = "106 zaptetme protokolünü başlatmak için ELO-IID elektromıknatısını devre dışı bırakın",
	r106sound = "106 zaptetme protokolünü başlatmak için ses iletimini aktifleştirin",
	r106human = "106 zaptetme protokolü için hücrede canlı bir insan bulunması gerekmektedir",
	r106already = "SCP 106 zaten zaptedilmiş durumda",
	r106success = "106 zaptetme işleminden dolayı %i puan kazandın",
	vestpickup = "Yeleği aldın",
	vestdrop = "Yeleği bıraktın",
	hasvest = "Zaten yeleğin var! Bırakmak için envanterini kullan",
	escortpoints = "Müttefiklerine refakat ettiğin için %i puan kazandın",
	femur_act = "Uyluk Kırıcı aktifleştirildi...",
	levelup = "Seviye atladın! Mevcut seviyen: %i",
	healplayer = "Bir oyuncuyu iyileştirdiğin için %i deneyim puanı kazandın!",
	detectscp = "SCP tespit ettiğin için %i deneyim puanı kazandın!",
	winxp = "Önceki takımın oyunu kazandığı için %i deneyim puanı kazandın!",
	winalivexp = "Takımın oyunu kazandığı için %i deneyim puanı kazandın!",
	upgradepoints = "Yeni yükseltme puanı kazandın! SCP yükseltme menüsü için '%s' tuşuna bas",
	prestigeup = "Player %s earned Yükseker prestige! Their current prestige level: %i",
	omega_detonation = "OMEGA Savaş Başlığı patlaması %i içinde gerçekleşecek. Yüzeye çık veya hemen bir sığınağa gir!",
	alpha_detonation = "ALFA Savaş Başlığı patlaması %i içinde gerçekleşecek. Tesise girin veya hemen tahliye olun!",
	alpha_card = "Alfa Savaş Başlığı nükleer kartını yerleştirdin",
	destory_scp = "Bir SCP öldürdüğün için %i puan kazandın!",
}

lang.NFailed = "Failed to access NRegistry with key: %s"

--[[-------------------------------------------------------------------------
NCRegistry
---------------------------------------------------------------------------]]
lang.NCRegistry = {
	escaped = "Kaçtın!",
	escapeinfo = "İyi iş! %s de kaçtın",
	escapexp = "%i deneyim puanı aldın",
	escort = "Refakat edildin!",
	roundend = "Tur bitti!",
	nowinner = "Bu tur kazanan yok!",
	roundnep = "Yeterli oyuncu yok!",
	roundwin = "Tur galibi: %s",
	roundwinmulti = "Tur galibi: [RAW]",
	shelter_escape = "Sığınakta patlamadan hayatta kaldın",
	alpha_escape = "Savaş başlığı patlamadan önce kaçtın",

	mvp = "MVP: %s skoru: %i",
	stat_kill = "Players killed: %i",
	stat_rdm = "RDM öldürmeleri: %i",
	stat_rdmdmg = "RDM Hasar: %i",
	stat_dmg = "Verilen hasar: %i",
	stat_bleed = "Kanama hasar: %i",
	stat_106recontain = "SCP 106 zaptedildi",
	stat_escapes = "Kaçan oyuncular: %i",
	stat_escorts = "Refakat edilen oyuncular: %i",
	stat_023 = "SCP 023'den kaynaklanan ölümler: %i",
	stat_049 = "Tedavi edilmiş insanlar: %i",
	stat_066 = "Çalınan şaheserler: %i",
	stat_096 = "Utangaç adam tarafından öldürülen kişiler: %i",
	stat_106 = "Cep boyutuna ışınlanan insanlar: %i",
	stat_173 = "Kırılmış boyunlar: %i",
	stat_457 = "Yakılan kişiler: %i",
	stat_682 = "Aşırı büyümüş kertenkele tarafından öldürülen kişiler: %i",
	stat_8602 = "Duvara çivilenen oyuncular: %i",
	stat_939 = "SCP 939 kurbanları: %i",
	stat_966 = "Sinsi Kesikler: %i",
	stat_3199 = "SCP 3199 tarafından yapılan suikastlar: %i",
	stat_24273 = "SCP 2427-3 tarafından yargılanan insanlar: %i",
}

lang.NCFailed = "Failed to access NCRegistry with key: %s"

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local hud = {}
lang.HUD = hud

hud.pickup = "Al"
hud.class = "Sınıf"
hud.team = "Takım"
hud.class_points = "Prestij Puanları"
hud.hp = "HP"
hud.stamina = "STAMINA"
hud.sanity = "Akıl Sağlığı"
hud.xp = "XP"

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
lang.eq_lmb = "Sol Fare Tuşu - Seç"
lang.eq_rmb = "Sağ Fare Tuşu  - Bırak"
lang.eq_hold = "Sol Fare Tuşu Basılı Tut - Eşya kıpırdat"
lang.eq_vest = "Yelek"
lang.eq_key = "Press '%s' to open EQ"

lang.info = "Detaylar"
lang.author = "Üretici"
lang.mobility = "Mobilite"
lang.weight = "Ağırlık"
lang.protection = "Koruma"

lang.weight_unit = "kg"
lang.eq_buttons = {
	escort = "Refakat",
	gatea = "A Geçidini Yok Et"
}

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
local effects = {}
lang.EFFECTS = effects

effects.permanent = "perm"
effects.bleeding = "Kanama"
effects.doorlock = "Kapı Kilidi"
effects.amnc227 = "AMN-C227"
effects.insane = "Deli"
effects.gas_choke = "Boğulma"
effects.radiation = "Radyasyon"
effects.deep_wounds = "Derin Yara"

--[[-------------------------------------------------------------------------
Class viewer
---------------------------------------------------------------------------]]
lang.classviewer = "Sınıf Görüntüleyicisi"
lang.preview = "Önizleme"
lang.random = "Rastgele"
lang.price = "Fiyat"
lang.buy = "Satın Al"
lang.refund = "İade"
lang.Yok = "Yok"
lang.refunded = "Tüm kaldırılan sınıflar iade edildi. %d prestij puanı kazandın."

lang.details = {
	details = "Detaylar",
	name = "İsim",
	team = "Takım",
	price = "Prestij Puanı Fiyatı",
	walk_speed = "Yürüme Hızı",
	run_speed = "Koşma Hızı",
	chip = "Erişim Çipi",
	persona = "Sahte ID",
	weapons = "Silahlar",
	class = "Sınıf",
	hp = "Can",
	speed = "Hız",
	health = "Can",
	sanity = "Akıl Sağlığı"
}

lang.headers = {
	support = "DESTEK",
	classes = "SINIFLAR",
	scp = "SCP'ler"
}

lang.view_cat = {
	classd = "D Sınıfı",
	sci = "Araştırmacı",
	mtf = "Güvenlik",
	mtf_ntf = "MTF Epsilon-11",
	mtf_alpha = "MTF Alpha-1",
	ci = "Kaos İsyancısı",
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
lang.unconnected = "Bağlantı kesildi"

lang.scoreboard = {
	name = "Skor Tablosu",
	playername = "İsim",
	ping = "Ping",
	prestige = "Prestigj",
	level = "Seviye",
	score = "Skor",
	ranks = "Rütbe",
}

lang.ranks = {
	author = "Yaratıcı",
	vip = "VIP",
	tester = "Tester",
	contributor = "Katkıda Bulunan",
	translator = "Çevirmen",
}

--[[-------------------------------------------------------------------------
Upgrades
---------------------------------------------------------------------------]]
lang.upgrades = {
	tree = "%s YÜKSELTME AĞACI",
	points = "Puanlar",
	cost = "Bedel",
	owned = "Sahip",
	requiresall = "Gerekiyor",
	requiresany = "Herhangi birini gerektirir",
	blocked = "Engellendi"
}

--[[-------------------------------------------------------------------------
Info screen
---------------------------------------------------------------------------]]
lang.info_screen = {
	subject = "Özne",
	class = "Sınıf",
	team = "Takım",
	status = "Durum",
	objectives = "Objektifler",
	details = "Detaylar",
	registry_failed = "info_screen_registry failed"
}

lang.info_screen_registry = {
	escape_time = "%s dakikada kaçtın",
	escape_xp = "%s deneyim kazandın",
	escape1 = "Tesisten kaçtın",
	escape2 = "Savaş Başlığı gerisayımı sırasında kaçtın",
	escape3 = "Sığınakta hayatta kaldın",
	escorted = "Refakat edildin",
	killed_by = "Tarafından öldürüldün: %s",
	suicide = "İntihar ettin",
	unknown = "Ölüm sebebi bilinmiyor",
	hazard = "Tehlikeli atık tarafından öldürüldün",
	alpha_mia = "Son bilinen konum: Yüzey",
	omega_mia = "Son bilinen konum: Tesis",
}

lang.info_screen_type = {
	alive = "Canlı",
	escaped = "Kaçtı",
	dead = "Öldü",
	mia = "Olaylar ortasında kayboldu",
	unknown = "Bilinmiyor",
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
lang.nothing = "Yok"
lang.exit = "Çıkış"

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
local misc = {}
lang.MISC = misc

misc.content_checker = {
	title = "Oyun Modu içeriği",
	msg = [[Görünüşe göre bazı eklentilerin eksik. Bu eksik içerik gibi hatalara sebep olabilir (kaplamalar/modeller/sesler) ve oyun deneyimini bozabilir.
 %i eklentiye sahip değilsin, %i eklenti içerisinde. Şimdi indirmek istermisin? (oyun içi indirebilir veya atölye aracılığıyla indirebilirsin)]],
	no = "Hayır",
	download = "Şimdi indir",
	workshop = "Atölye sayfasını göster",
	downloading = "İndiriliyor",
	mounting = "Mounting",
	processing = "Eklenti işleniyor: %s\nDurum: %s",
	cancel = "İptal"
}

misc.omega_warhead = {
	idle = "OMEGA Savaş Başlığı beklemede\n\nGiriş bekleniyor...",
	waiting = "OMEGA Savaş Başlığı beklemede\n\nGiriş kabul edildi!\nİkinci giriş bekleniyor...",
	failed = "OMEGA Savaş Başlığı kilitli\n\nİkinci giriş tespit edilmedi!\n%i s bekle",
	no_remote = "OMEGA Savaş Başlığı başarısız\n\nSavaş başlığına bağlanma işlemi başarısız!\t",
	active = "OMEGA Savaş Başlığı harekete geçti\n\nHemen tahliye işlemini başlatın!\nPatlama saniye içerisinde %.2fs",
}

misc.alpha_warhead = {
	idle = "ALFA Savaş Başlığı beklemede\n\nWaiting for nuclear codes...",
	ready = "ALFA Savaş Başlığı beklemede\n\nKodlar kabul edildi!\nAktivasyon bekleniyor...",
	no_remote = "ALFA Savaş Başlığı başarısız\n\nSavaş başlığına bağlanma işlemi başarısız!\t",
	active = "ALFA Savaş Başlığı harekete geçti\n\nHemen tahliye işlemini başlatın!\nPatlama saniye içerisinde %.2fs",
}

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
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "İzleyici"
teams.CLASSD = "D Sınıfı"
teams.SCI = "Araştırmacı"
teams.MTF = "MTF"
teams.CI = "Kaos İsyancısı"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "Bilinmiyor"

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

classes.classd = "D Sınıfı"
classes.veterand = "Kıdemli D Sınıfı"
classes.kleptod = "D Sınıfı Kleptoman"
classes.ciagent = "Kaos Ajanı"

classes.sciassistant = "Araştırmacı Asistanı"
classes.sci = "Araştırmacı"
classes.seniorsci = "Kıdemli Araştırmacı"
classes.headsci = "Baş Araştırmacı"

classes.guard = "Güvenlik Görevlisi"
classes.chief = "Güvenlik Amiri"
classes.lightguard = "Hafif Güvenlik Görevlisi"
classes.heavyguard = "Ağır Güvenlik Görevlisi"
classes.specguard = "Uzman Güvenlik Görevlisi"
classes.guardmedic = "Güvenlik Görevlisi Sıhhiye"
classes.tech = "Teknisyen Güvenlik Görevlisi"
classes.cispy = "Kaos Ajanı"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Pompalı Tüfek"
classes.ntf_3 = "MTF NTF - Tüfek"
classes.ntfcom = "MTF NTF Komutanı"
classes.ntfsniper = "MTF NTF Keskin Nişancı"
classes.ntfmedic = "MTF NTF Sıhhiye"
classes.alpha1 = "MTF Alfa-1"
classes.alpha1sniper = "MTF Alfa-1 Nişancı"
classes.ci = "Kaos İsyancısı"
classes.cicom = "Kaos İsyancısı Komutanı"

--[[-------------------------------------------------------------------------
Class Info - NOTE: Each line is limited to 48 characters!
Screen is designed to hold max of 5 lines of text and THERE IS no internal protection!
Note that last (5th) line should be shorter to prevent text overlaping (about 38 characters)
---------------------------------------------------------------------------]]
local generic_classd = [[- Tesisten kaç
- Personel ve SCP'lerden kaçın
- Diğerleriyle işbirliği yap]]

local generic_sci = [[- Tesisten kaç
- D Sınıfı ve SCP'lerden kaçın
- MTF ve Güvenlik ile işbirliği yap]]

local generic_guard = [[- Araştırmacıları kurtar
- Tüm D sınıfı ve SCP'leri imha et
- Liderin emirlerine uy]]

local generic_ntf = [[- Tesise gir
- İçerideki personellere yardım et
- D Sınıfı ve SCP'lerin kaçmasına izin verme]]

local generic_scp = [[- Tesisten kaç
- Gördüğün herkesi öldür
- Diğer SCP'ler ile işbirliği yap]]

local generic_scp_friendly = [[- Tesisten kaç
- İnsanlarla işbirliği yapabilirsin
- Diğer SCP'ler ile işbirliği yap]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	ciagent = [[- D Sınıfı personele refakat et
- Personel ve SCP'lerden kaçın
- Diğerleriyle işbirliği yap]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Araştırmacıları kurtar
- Tüm D sınıfı ve SCP'leri imha et
- Diğer personele emir ver]],

	guardmedic = [[- Araştırmacıları kurtar
- Tüm D sınıfı ve SCP'leri imha et
- Medkitin ile diğer personele yardımcı ol]],

	tech = [[- Araştırmacıları kurtar
- Tüm D sınıfı ve SCP'leri imha et
- Taretin ile diğer personele yardımcı ol]],

	cispy = [[- Bir güvenlik gibi davran
- Kalan D Sınıfı personele yardım et
- Güvenlik görevlerini sabote et]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- İçerideki personellere yardım et
- Medkitin ile diğer NTF'lere yardımcı ol
- D Sınıfı ve SCP'lerin kaçmasına izin verme]],

	ntfcom = [[- İçerideki personellere yardım et
- D Sınıfı ve SCP'lerin kaçmasına izin verme
- Give orders to other NTFs]],

	ntfsniper = [[- İçerideki personellere yardım et
- D Sınıfı ve SCP'lerin kaçmasına izin verme
- Takımını arkadan kolla]],

	alpha1 = [[- Vakfı ne pahasına olursa olsun koru
- SCP ve D Sınıfı personeli durdur
- Yetkilerin ]].."[GİZLENMİŞ]",

	alpha1sniper = [[- Vakfı ne pahasına olursa olsun koru
- SCP ve D Sınıfı personeli durdur
- Yetkilerin ]].."[GİZLENMİŞ]",

	ci = [[- D Sınıfı personellere yardım et
- Tüm personelleri öldür
- Liderin emirlerine uy]],

	cicom = [[- D Sınıfı personellere yardım et
- Tüm personelleri öldür
- Diğer isyancılara emir ver]],

	SCP023 = generic_scp,

	SCP049 = [[- Tesisten kaç
- Diğer SCP'ler ile işbirliği yap
- İnsanları tedavi et]],

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

lang.CLASS_DESCRIPTION = {
	classd = [[Zorluk: Kolay
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Düşük
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Kaos İsyancısı

Overview:
Basit sınıf. SCP ve tesis görevlilerine karşı diğerleriyle işbirliği yap. Kaos isyancıları tarafından refakat edilebilirsin.
]],

	veterand = [[Zorluk: Kolay
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Kaos İsyancısı

Overview:
Daha gelişmiş sınıf. Tesiste basit erişimin var. SCP ve tesis görevlilerine karşı diğerleriyle işbirliği yap. Kaos isyancıları tarafından refakat edilebilirsin.
]],

	kleptod = [[Zorluk: Zor
Dayanıklılık: Düşük
Çeviklik: Çok Yüksek
Savaş Potansiyeli: Düşük
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Kaos İsyancısı

Overview:
Yüksek nitelikli sınıf. Rastgele bir eşya ile başlar. SCP ve tesis görevlilerine karşı diğerleriyle işbirliği yap. Kaos isyancıları tarafından refakat edilebilirsin.
]],

	ciagent = [[Zorluk: Orta
Dayanıklılık: Çok Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: D Sınıfı Personel
Refakatçi: Yok

Overview:
Şok tabancası vardır. D Sınıfı personele yardımcı ol. D Sınıfı personellere refakat edebilirsin.
]],

	sciassistant = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Düşük
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Güvenlik,MTF

Overview:
Basit sınıf. Tesis görevlileriyle işbirliği yap ve SCP'lerden kaçın. MTF üyeleri tarafından refakat edilebilirsin.
]],

	sci = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Düşük
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Güvenlik, MTF

Overview:
Araştırmacılardan biri. Tesis görevlileriyle işbirliği yap ve SCP'lerden kaçın. MTF üyeleri tarafından refakat edilebilirsin.
]],

	seniorsci = [[Zorluk: Kolay
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Güvenlik, MTF

Overview:
Araştırmacılardan biri. Daha yüksek seviye erişim kartına sahip. Tesis personeli ile işbirliği yap ve SCP'lerden kaçın. MTF üyeleri tarafından refakat edilebilirsin.
]],

	headsci = [[Zorluk: Kolay
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Evet
Refakat edebilir: Yok
Refakatçi: Güvenlik, MTF

Overview:
En yüksek yetkili araştırmacı. Yüksek işlev ve yüksek canlı. Tesis personeli ile işbirliği yap ve SCP'lerden kaçın. MTF üyeleri tarafından refakat edilebilirsin.
]],

	guard = [[Zorluk: Kolay
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Basit güvenlik görevlisi. Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin..
]],

	lightguard = [[Zorluk: Zor
Dayanıklılık: Düşük
Çeviklik: Çok Yüksek
Savaş Potansiyeli: Düşük
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Güvenlik görevlilerinden biri. Yüksek işlevli, zırhı yok ve düşük canlı. Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin.
]],

	heavyguard = [[Zorluk: Orta
Dayanıklılık: Yüksek
Çeviklik: Düşük
Savaş Potansiyeli: Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Güvenlik görevlilerinden biri. Daha düşük işlevli, daha iyi zırh ve daha yüksek can. Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin.
]],

	specguard = [[Zorluk: Zor
Dayanıklılık: Yüksek
Çeviklik: Düşük
Savaş Potansiyeli: Çok Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Güvenlik görevlilerinden biri. Fazla işlevsel değil, yüksek can ve yüksek savaş potansiyeli. Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin.
]],

	chief = [[Zorluk: Kolay
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Güvenlik görevlilerinden biri. Biraz daha yüksek savaş potansiyeli, şok tabancasına sahip. Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin.
]],

	guardmedic = [[Zorluk: Zor
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Düşük
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Güvenlik görevlilerinden biri. Medkit ve şok tabancasına sahipsin. Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin.
]],

	tech = [[Zorluk: Zor
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
Güvenlik görevlilerinden biri. Yerleştirilebilir tarete sahip, 3 ateş modeli vardır (Menüyü görmek için taretin üstünde E'ye bas). Diğer personeller yardım etmek ve SCP ile D Sınıfı personeli öldürmek için silahlarını ve aletlerini kullan. Araştırmacılara refakat edebilirsin.
]],

	cispy = [[Zorluk: Çok Zor
Dayanıklılık: Normal
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: D Sınıfı Personel
Refakatçi: Yok

Overview:
Kaos isyancısı ajanı. Yüksek işlevli. Güvenlik görevlerilerine karış ve D Sınıfı personele yardım et.
]],

	ntf_1 = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF NTF Unit. SMG'ye sahip. Tesise gir ve koru. İçerideki personele yardom et ve D Sınıfı ile SCPleri öldür.
]],

	ntf_2 = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF NTF Unit. Pompalı tüfeğe sahip. Tesise gir ve koru. İçerideki personele yardom et ve D Sınıfı ile SCPleri öldür.
]],

	ntf_3 = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF NTF Unit. Tüfeğe sahip. Tesise gir ve koru. İçerideki personele yardom et ve D Sınıfı ile SCPleri öldür.
]],

	ntfmedic = [[Zorluk: Zor
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Düşük
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF NTF Unit. Tabancaya sahip, medkiti var. Tesise gir ve koru. İçerideki personele yardom et ve D Sınıfı ile SCPleri öldür.
]],

	ntfcom = [[Zorluk: Zor
Dayanıklılık: Yüksek
Çeviklik: Çok Yüksek
Savaş Potansiyeli: Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF NTF Birimi. Nişancı tüfeğine sahip. Tesise gir ve koru. İçerideki personele yardom et ve D Sınıfı ile SCP'leri öldür.
]],

	ntfsniper = [[Zorluk: Zor
Dayanıklılık: Normal
Çeviklik: Normal
Savaş Potansiyeli: Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF NTF Birliği. Keskin nişancı tüfeğine sahip. Tesise gir ve koru. Personele yardım et ve D Sınıfı ile SCP'leri öldür.
]],

	alpha1 = [[Zorluk: Orta
Dayanıklılık: Aşırı
Çeviklik: Çok Yüksek
Savaş Potansiyeli: Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok

Overview:
MTF Alpha-1 Birimi. Ağır zırhlı, yüksek işlevli birim, tüfeğe sahip. Tesise gir ve koru. Personele yardım et ve D Sınıfı ile SCP'leri öldür.
]],

	alpha1sniper = [[Zorluk: Zor
Dayanıklılık: Çok Yüksek
Çeviklik: Çok Yüksek
Savaş Potansiyeli: Çok Yüksek
Kaçabilir: Hayır
Refakat edebilir: Araştırmacı
Refakatçi: Yok
Overview:
MTF Alpha-1 Unit. Ağır zırhlı, yüksek işlevsel birim, nişancı tüfeğine sahip. Tesise gir ve koru. Personele yardım et ve D Sınıfı ile SCP'leri öldür.
]],

	ci = [[Zorluk: Orta
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Normal
Kaçabilir: Hayır
Refakat edebilir: D Sınıfı Personel
Refakatçi: Yok
Overview:
Kaos isyancısı birliği. Tesise gir, D Sınıflarına yardım et ve tesis personelini öldür.
]],

	cicom = [[Zorluk: Orta
Dayanıklılık: Çok Yüksek
Çeviklik: Yüksek
Savaş Potansiyeli: Yüksek
Kaçabilir: Hayır
Refakat edebilir: D Sınıfı Personel
Refakatçi: Yok

Overview:
Kaos isyancısı birliği. Yüksek Savaş Potansiyeli. Tesise gir, D Sınıflarına yardım et ve tesis personelini öldür.
]],
	
--TODO: New SCP translations
}

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	nvmod = {
		name = "Extra Görüş",
		info = "Görüş parlaklığın artar\nKaranlık alanlar artık seni durduramaz!"
	}
}

local wep = {}
lang.WEAPONS = wep

--TODO: New SCP translations

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

RegisterLanguage( lang, "turkish", "tr", "turk", "turkce" )
SetLanguageFlag( "turkish", LANGUAGE.EQ_LONG_TEXT )
