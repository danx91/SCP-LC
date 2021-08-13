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
hud.prestige_points = "Prestij Puanları"
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
lang.refound = "İade"
lang.Yok = "Yok"
lang.refounded = "Tüm kaldırılan sınıflar iade edildi. %d prestij puanı kazandın."

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

	SCP023 = generic_scp,

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
	classd = [[Sen D Sınıfı personelsin
Amacın tesisten kaçmak
Diğerleriyle işbirliği yap ve kartları ara
Beware of facility staff and SCPs]],

	veterand = [[You are Class D Veteran
Your objective is to escape from the facility
Cooperate with others
Beware of facility staff and SCPs]],

	kleptod = [[You are Class D Kleptomaniac
Your objective is to escape from the facility
You stole something from the staff
Beware of facility staff and SCPs]],

	ciagent = [[You are CI Agent
Your objective is to protect Class D Personnel
Escort them to the exit
Beware of facility staff and SCPs]],

	sciassistant = [[You are Scientist Assistant
Your objective is to escape from the facility
Cooperate with other scientists and Güvenlik staff
Beware of Chaos Insurgency and SCPs]],

	sci = [[You are Scientist
Your objective is to escape from the facility
Cooperate with other scientists and Güvenlik staff
Beware of Chaos Insurgency and SCPs]],

	seniorsci = [[You are Senior Scientist
Your objective is to escape from the facility
Cooperate with other scientists and Güvenlik staff
Beware of Chaos Insurgency and SCPs]],

	headsci = [[You are Head Scientist
Your objective is to escape from the facility
Cooperate with other scientists and Güvenlik staff
Beware of Chaos Insurgency and SCPs]],

	guard = [[You are Güvenlik Guard
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs]],

	lightguard = [[You are Güvenlik Guard
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs]],

	heavyguard = [[You are Güvenlik Guard
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs]],

	specguard = [[You are Güvenlik Guard Specialist
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs]],

	chief = [[You are Güvenlik Chief
Your objective is to rescue all scientist
Kill all Class D Personnel and SCPs]],

	guardmedic = [[You are Güvenlik Guard Medic
Your objective is to rescue all scientist
Use your medkit to help your temmates
Kill all Class D Personnel and SCPs]],

	tech = [[You are Güvenlik Technician
Your objective is to rescue all scientist
You can place portable turret
Kill all Class D Personnel and SCPs]],

	cispy = [[You are CI Spy
Your objective is to help Class D Personnel
Pretend to be a Güvenlik guard]],

	ntf_1 = [[You are MTF NTF
Help staff inside facility
Don't let Class D Personnel and SCPs escape]],

	ntf_2 = [[You are MTF NTF
Help staff inside facility
Don't let Class D Personnel and SCPs escape]],

	ntf_3 = [[You are MTF NTF
Help staff inside facility
Don't let Class D Personnel and SCPs escape]],

	ntfmedic = [[You are MTF NTF Medic
Help staff inside facility
Use your medkit to help other MTFs]],

	ntfcom = [[You are MTF NTF Commander
Help staff inside facility
Don't let Class D Personnel and SCPs escape]],

	ntfsniper = [[You are MTF NTF Sniper
Protect your team from a distance
Don't let Class D Personnel and SCPs escape]],

	alpha1 = [[You are MTF Alpha 1
You work directly for O5 Council
Protect foundation at all cost
Your mission is to [REDACTED] ]],

	alpha1sniper = [[You are MTF Alpha 1 Marksman
You work directly for O5 Council
Protect foundation at all cost
Your mission is to [REDACTED] ]],

	ci = [[You are Chaos Insurgency Soldier
Help Class D Personnel
Kill MTFs and other facility staff]],

	cicom = [[You are Chaos Insurgency Commander
Help Class D Personnel
Kill MTFs and other facility staff]],
	
	SCP023 = [[You are SCP 023
Your objective is to escape from the facility
You will kill one of the people who saw you
Click RMB to place spectre]],

	SCP049 = [[You are SCP 049
Your objective is to escape from the facility
Your touch is deadly to humans
You can perform surgery to "cure" people]],

	SCP0492 = [[You are SCP 049-2
Your objective is to escape from the facility
Listen to SCP 049's orders and protect him]],

	SCP066 = [[You are SCP 066
Your objective is to escape from the facility
You can play Çok loud music]],

	SCP096 = [[You are SCP 096
Your objective is to escape from the facility
You become enraged when someone looks at you
You can regenerate HP by pressing R]],

	SCP106 = [[You are SCP 106
Your objective is to escape from the facility
You can go through doors and teleport to the selected location

LMB: Teleport humans to pocket dimension
RMB: Mark teleport destination
R: Teleport]],

	SCP173 = [[You are SCP 173
Your objective is to escape from the facility
You can't move while someone is watching you
Your special ability teleports you to the nearby human]],

	SCP457 = [[You are SCP 457
Your objective is to escape from the facility
You are burning and you will ignite eÇokthing
near you
You can place up to 5 fire traps]],

	SCP682 = [[You are SCP 682
Your objective is to escape from the facility
You have a lot of health
Your special ability makes you immune to any Hasar]],

	SCP8602 = [[You are SCP 860-2
Your objective is to escape from the facility
If you attack someone near wall, you will
nail him to wall and deal huge Hasar]],

	SCP939 = [[You are SCP 939
Your objective is to escape from the facility
You can talk with humans]],

	SCP966 = [[You are SCP 966
Your objective is to escape from the facility
You are invisible]],

	SCP3199 = [[You are SCP 3199
Your objective is to escape from the facility
You are agile and deadly hunter
You can sense heartbeat of nearby humans]],
}*/
--[[-------------------------------------------------------------------------
END OF UNUSED PART
---------------------------------------------------------------------------]]

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
	
	SCP023 = [[Zorluk: Zor
Dayanıklılık: Düşük
Çeviklik: Yüksek
Hasar: Anında Ölüm
Overview:
Kapılardan geçebilirsin. Birisi seni görürse listene eklenir.Belirli bir süre sonra listendeki kişilerden birinin yanına ışınlanır ve onu ölene kadar yakarsın. Bir klon yerleştirebilirsin.
]],

	SCP049 = [[Zorluk: Zor
Dayanıklılık: Düşük
Çeviklik: Yüksek
Hasar: 3 saldırıdan sonra anında ölüm

Overview:
Bir oyuncuyu öldürmek için 3 kere saldır. Cesetlerden zombi yaratabilirsin (r tuşu).
]],

	SCP0492 = [[]],

	SCP066 = [[Zorluk: Orta
Dayanıklılık: Yüksek
Çeviklik: Normal
Hasar: Düşük / Alan Hasarı

Overview:
Yakındaki oyunculara hasar veren yüksek sesli bir müzik çalarsın.
]],

	SCP096 = [[Zorluk: Zor
Dayanıklılık: Yüksek
Çeviklik: Çok Düşük / Öfkeliyken Aşırı 
Hasar: Anında Ölüm
Overview:
Biri seni gördüğünde öfekelenirsin. Öfke halindeyken aşırı hızlanırsın ve hedeflerini öldürebilirsin.
]],

	SCP106 = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Düşük
Hasar: Orta / Cep boyutunda anında ölüm

Overview:
Kapıların içinden geçebilirsin. Birini cep boyutuna göndermek için saldır. Cep boyutundayken hedeflerini anında öldürürsün.
]],

	SCP173 = [[Zorluk: Kolay
Dayanıklılık: Aşırı
Çeviklik: Super Aşırı
Hasar: Anında Ölüm
Overview:
Aşırı hızlısın, ama birisi seni görürken hareket edemezsin. Yakındaki oyuncuları otomatik olarak öldürürsün. Menzildeki bir oyuncuya ışınlanmak için özel yeteneğini kullanabilirsin.
]],

	SCP457 = [[Zorluk: Kolay
Dayanıklılık: Normal
Çeviklik: Normal
Hasar: Orta / Alev yayılabilir

Overview:
Yanıyorsun ve etraftakileri yakabiliyorsun. Birisi üstüne bastığında devreye girent uzaklar koyabilirsin.
]],

	SCP682 = [[Zorluk: Zor
Dayanıklılık: Super Aşırı
Çeviklik: Normal
Hasar: Yüksek

Overview:
Aşırı dayanıklı ve ölümcül. Kısa süreliğine hasar bağışıklılığı kazanmak için özel yeteneğini kullan.
]],

	SCP8602 = [[Zorluk: Orta
Dayanıklılık: Yüksek
Çeviklik: Yüksek
Hasar: Düşük / Yüksek (Güçlü saldırı)

Overview:
Birisi duvara yakınsa, onu duvara vurabilirsin, bu yüksek hasar verir. Ayrıca biraz can kaybedersin.
]],

	SCP939 = [[Zorluk: Orta
Dayanıklılık: Normal
Çeviklik: Yüksek
Hasar: Orta

Overview:
Görünmez, zehirli bir iz bırakırsın. Zehirlenen oyuncular sağ ve sol fare tuşlarını kullanamaz.
]],

	SCP966 = [[Zorluk: Orta
Dayanıklılık: Düşük
Çeviklik: Yüksek
Hasar: Düşük / Kanama

Overview:
Görünmezsin. Saldırıların daima kanama uygular.
]],

	SCP24273 = [[Zorluk: Zor
Dayanıklılık: Normal
Çeviklik: Normal
Hasar: Yüksek / Zihin kontrolü sırasında anında öldürme

Overview:
İlk çarptığın rakibe hasar verecek şekilde atılabilirsin. Özel yeteneğin bir oyuncuyu kısa sürelğine kontrol etmeni sağlar. Kontrol edilen kişiyi sana getirmek, onu anında öldürmeni sağlar. Zihin kontrolü sırasında intihar etmek canını azaltır.
]],

	SCP3199 = [[Zorluk: Çok Zor
Dayanıklılık: Düşük
Çeviklik: Çok Yüksek
Hasar: Düşük / Orta

Overview:
Oyunculara saldırmak sana çılgınlık verir ve onlara ağır yara uygularsın. Çılgınlıktayken, daha hızlı hareket edersin ve yakındaki oyuncuları görebilirsin. Bir saldırı kaçırmak veya zaten ağır yaralı birine saldırmak, çılgınlığı durdurur ve ceza uygular. 5 çılgınlık yüküne sahip olmak özel yeteneğini kullanmanı sağlar. Özel yeteneğin kısa bir süre hazırlandıktan sonra bir oyuncuyu öldürmeni sağlar.
]],
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

wep.SCP023 = {
	editMode1 = "Hayalet yerleştirmek için sol fare tuşuna tıkla",
	editMode2 = "Sağ fare tuşu - iptal, R - Döndür",
	preys = "Mevcut kurban: %i",
	attack = "Sonraki saldırı: %s",
	trapActive = "Tuzak aktif!",
	trapInactive = "Tuzak kurmak için sağ fare tuşuna tıkla",
	upgrades = {
		attack1 = {
			name = "Şehvet I",
			info = "Saldırı bekleme süren 20 saniye azalır",
		},
		attack2 = {
			name = "Şehvet II",
			info = "Saldırı bekleme süren 20 saniye azalır\n\t• Toplam azalma: 40s",
		},
		attack3 = {
			name = "Şehvet III",
			info = "Saldırı bekleme süren 20 saniye azalır\n\t• Toplam azalma: 60s",
		},
		trap1 = {
			name = "Kötü Kehanet I",
			info = "Tuzak bekleme süren 40 saniyeye düşer",
		},
		trap2 = {
			name = "Kötü Kehanet II",
			info = "Tuzak bekleme süren 20 saniyeye düşer\nHayalet yol alma mesafesi 25 birim artar",
		},
		trap3 = {
			name = "Kötü Kehanet III",
			info = "Hayalet yol alma mesafesi 25 birim artar\n\t• Toplam artış: 50 birim",
		},
		hp = {
			name = "Alfa Erkek I",
			info = "1000HP (ayrıca max HP) ve 10% mermi koruması kazanırsın, ama tuzak bekleme süren 30 saniye artar",
		},
		speed = {
			name = "Alfa Erkek II",
			info = "10% hareket hızı ve 15% mermi koruması kazanırsın, ama tuzak bekleme süren 30 saniye artar\n\t• Toplam koruma: 25%, toplam bekleme süresi artışı: 60s",
		},
		alt = {
			name = "Alfa Erkek III",
			info = "Saldırı beklemen 30 saniye azalır ve 15% mermi koruması kazanırsın, ama artık tuzak kullanamazsın\n\t• Toplam koruma: 40%",
		},
	}
}

wep.SCP049 = {
	surgery = "Ameliyat ediliyor",
	surgery_failed = "Ameliyat başarısız!",
	zombies = {
		Normal = "Standard Zombi",
		light = "Hafif Zombi",
		heavy = "Ağır Zombi"
	},
	upgrades = {
		cure1 = {
			name = "Ben Tedaviyim I",
			info = "40% mermi koruması kazan",
		},
		cure2 = {
			name = "Ben Tedaviyim II",
			info = "Her 180 saniyede 300HP yenile",
		},
		merci = {
			name = "Merhamet",
			info = "Saldırı beklemen 2,5 saniye azaldı\nArtık yakındaki insalara 'Kapı Kilidi' efekti uygulamıyorsun",
		},
		symbiosis1 = {
			name = "Ortakyaşam I",
			info = "Ameliyat yaptıktan sonra 10% azami can iyileş",
		},
		symbiosis2 = {
			name = "Ortakyaşam II",
			info = "Ameliyat yaptıktan sonra 15% azami can iyileş\nYakındaki SCP 049-2 ler azami canlarının 10% si kadar iyileşir",
		},
		symbiosis3 = {
			name = "Ortakyaşam III",
			info = "Ameliyat yaptıktan sonra 15% azami can iyileş\nYakındaki SCP 049-2 ler azami canlarının 10% si kadar iyileşir",
		},
		hidden = {
			name = "Gizli Potansiyel",
			info = "Her başarılı ameliyat başına bir yük kazanırsın\nHer yük zombiler canını 5% artırır\n\t• Bu efekt sadece yeni yaratılan zombilerde geçerlidir",
		},
		trans = {
			name = "Nakil",
			info = "Your zombies have their HP increased by 15%\nZombilerin %20 can çalma kazanır\n\t• Bu efekt sadece yeni yaratılan zombilerde geçerlidir",
		},
		rm = {
			name = "Radikal Tedavi",
			info = "Mümkün olduğunda 1 cesetten 2 zombi yaratırsın\n\t• Sadece bir izleyici varsa, bir zombi yaratırsın\n\t• İki zombi de aynı tiptedir\n\t• İkinci zombinin canı 50% daha azdır\n\t• İkinci zombinin hasarı 25% daha düşüktür",
		},
		doc1 = {
			name = "Cerrahi Hassasiyet I",
			info = "Ameliyat süresi 5s azalır",
		},
		doc2 = {
			name = "Cerrahi Hassasiyet II",
			info = "Ameliyat süresi 5s azalır\n\t• Toplam azalma: 10s",
		},
	}
}

wep.SCP0492 = {
	too_far = "Güçsüzleşmeye başlıyorsun!"
}

wep.SCP066 = {
	wait = "Sonraki saldırı: %is",
	ready = "Saldırı hazır!",
	chargecd = "Atılma bekleme süresi: %is",
	upgrades = {
		range1 = {
			name = "Rezonans I",
			info = "Hasar alanı 75 artar",
		},
		range2 = {
			name = "Rezonans II",
			info = "Hasar alanı 75 artar\n\t• Toplam artış: 150",
		},
		range3 = {
			name = "Rezonans III",
			info = "Hasar alanı 75 artar\n\t• Toplam artış: 225",
		},
		damage1 = {
			name = "Bass I",
			info = "Hasar 112,5% olur, menzil 90% e düşer",
		},
		damage2 = {
			name = "Bass II",
			info = "Hasar 135% olur, menzil 75% e düşer",
		},
		damage3 = {
			name = "Bass III",
			info = "Hasar 200% olur, menzil 50% e düşer",
		},
		def1 = {
			name = "Olumsuzluk Dalgası I",
			info = "Müzik çalarken 10% hasar engellersin",
		},
		def2 = {
			name = "Olumsuzluk Dalgası II",
			info = "Müzik çalarken 25% hasar engellersin",
		},
		charge = {
			name = "Atıl",
			info = "R tuşu ile ileri atılma özelliği açılır\n\t• Bekleme süresi: 20s",
		},
		sticky = {
			name = "Yapışkan",
			info = "Bir insana atıldıktan sonra ona 10s yapışık kalırsın",
		}
	}
}

wep.SCP096 = {
	charges = "İyileşme şarjı: %i",
	regen = "Can yenileniyor - şarj: %i",
	upgrades = {
		sregen1 = {
			name = "Sakin Ruh I",
			info = "5 saniye yerine 4 saniyede bir rejenerasyon şarjı kazanırsın"
		},
		sregen2 = {
			name = "Sakin Ruh II",
			info = "Rejenerasyon şarjı seni 5 yerine 6HP iyileştirir"
		},
		sregen3 = {
			name = "Sakin Ruh III",
			info = "Rejenerasyon hızın 66% artar"
		},
		kregen1 = {
			name = "Hannibal I",
			info = "Başarılı her öldürme için fazladan 90 HP yenilenir"
		},
		kregen2 = {
			name = "Hannibal II",
			info = "Başarılı her öldürme için fazladan 90 HP yenilenir\n\t• Toplam iyileşme: 180HP"
		},
		hunt1 = {
			name = "Utangaç I",
			info = "Avlanma alanı 4250 ye çıkarıldı"
		},
		hunt2 = {
			name = "Utangaç II",
			info = "Avlanma alanı 5500 e çıkarıldı"
		},
		hp = {
			name = "Goliath",
			info = "Maksimum HP 4000 HP'ye çıkarılır\n\t• Mevcut canın artmaz"
		},
		def = {
			name = "Kalıcı",
			info = "Mermilere karşı 30% hasar azaltma kazanırsın"
		}
	}
}

wep.SCP106 = {
	swait = "Özel yetenek bekleme süresi: %is",
	sready = "Özel saldırı hazır!",
	upgrades = {
		cd1 = {
			name = "Boşluk Yürüyüşü I",
			info = "Özel yetenek bekleme süresi 15 saniye azalır"
		},
		cd2 = {
			name = "Boşluk Yürüyüşü II",
			info = "Özel yetenek bekleme süresi 15 saniye azalır\n\t• Toplam azalma: 30s"
		},
		cd3 = {
			name = "Boşluk Yürüyüşü III",
			info = "Özel yetenek bekleme süresi 15 saniye azalır\n\t• Toplam azalma: 45s"
		},
		tpdmg1 = {
			name = "Çürüten Dokunuş I",
			info = "Işınlandıktan sonra 10 saniye boyunca 15 hasar kazan"
		},
		tpdmg2 = {
			name = "Çürüten Dokunuş II",
			info = "Işınlandıktan sonra 20 saniye boyunca 20 hasar kazan"
		},
		tpdmg3 = {
			name = "Çürüten Dokunuş III",
			info = "Işınlandıktan sonra 30 saniye boyunca 25 hasar kazan"
		},
		tank1 = {
			name = "Cep Kalkanı I",
			info = "%20 mermi hasar azaltması kazan, ama %10 yavaş öldürürsün"
		},
		tank2 = {
			name = "Cep Kalkanı II",
			info = "%20 mermi hasar azaltması kazan, ama %10 yavaş öldürürsün\n\t• Toplam koruma: 40%\n\t• Toplam yavaşlama: 20%"
		},
	}
}

wep.SCP173 = {
	swait = "Özel yetenek bekleme süresi: %is",
	sready = "Özel saldırı hazır!",
	upgrades = {
		specdist1 = {
			name = "Hayalet I",
			info = "Özel yetenek mesafesi 500 artar"
		},
		specdist2 = {
			name = "Hayalet II",
			info = "Özel yetenek mesafesi 700 artar\n\t• Toplam artış: 1200"
		},
		specdist3 = {
			name = "Hayalet III",
			info = "Özel yetenek mesafesi 800 artar\n\t• Toplam artış: 2000"
		},
		boost1 = {
			name = "Kanasusamış I",
			info = "Her insan öldürdüğünde 150HP kazanırsın ve özel yeteneğinin bekleme süresi 15% azalır"
		},
		boost2 = {
			name = "Kanasusamış II",
			info = "Her insan öldürdüğünde 300HP kazanırsın ve özel yeteneğinin bekleme süresi 25% azalır"
		},
		boost3 = {
			name = "Kanasusamış III",
			info = "Her insan öldürdüğünde 500HP kazanırsın ve özel yeteneğinin bekleme süresi 50% azalır"
		},
		prot1 = {
			name = "Beton Kaplama I",
			info = "Anında 1000HP iyileş ve mermilere karşı 10% hasar azaltma kazan"
		},
		prot2 = {
			name = "Beton Kaplama II",
			info = "Anında 1000 can iyileş ve mermilere karşı 10% hasar azaltma kazan\n\t• Toplam koruma: 20%"
		},
		prot3 = {
			name = "Beton Kaplama III",
			info = "Anında 1000 can iyileş ve mermilere karşı 20% hasar azaltma kazan\n\t• Toplam koruma: 40%"
		},
	},
	back = "Önceki pozisyonuna dönmek için R ye basılı tutabilirsin",
}

wep.SCP457 = {
	swait = "Özel yetenek bekleme süresi: %is",
	sready = "Özel saldırı hazır!",
	placed = "Akfitf Tuzaklar: %i/%i",
	nohp = "Yetersiz HP!",
	upgrades = {
		fire1 = {
			name = "Canlı Meşale I",
			info = "Yakma çapın 25 artar"
		},
		fire2 = {
			name = "Canlı Meşale II",
			info = "Yakma hasarın 0.5 artar"
		},
		fire3 = {
			name = "Canlı Meşale III",
			info = "Yakma çapın 50 artar ve yakma hasarın 0.5 artar\n\t• Toplam çap artışı: 75\n\t• Toplam hasar artışı: 1"
		},
		trap1 = {
			name = "Küçük Sürpriz I",
			info = "Tuzak süren 4 dakikaya yükselir ve tuzaklar 1 saniye fazladan yakar"
		},
		trap2 = {
			name = "Küçük Sürpriz II",
			info = "Tuzak süren 5 dakikaya yükselir ve tuzaklar 1 saniye fazladan yakar ve hasarı 0.5 artar\n\t• Toplam yanma süresi artışı: 2s"
		},
		trap3 = {
			name = "Küçük Sürpriz III",
			info = "Tuzaklar 1 saniye fazladan yakar ve hasarı 0.5 artar\n\t• Toplam yanma süresi artışı: 3s\n\t• Toplam hasar artışı: 1"
		},
		heal1 = {
			name = "Cızırtılı Atıştırmalık I",
			info = "İnsanları yakmak seni fazladan 1 can iyileştirir"
		},
		heal2 = {
			name = "Cızırtılı Atıştırmalık II",
			info = "İnsanları yakmak seni fazladan 1 can iyileştirir\n\t• Toplam iyileşme artışı: 2"
		},
		speed = {
			name = "Hızlı Ateş",
			info = "Hızın 10% artar"
		}
	}
}

wep.SCP682 = {
	swait = "Özel yetenek bekleme süresi: %is",
	sready = "Özel saldırı hazır!",
	s_on = "Hasara karşı bağışıklısın! %is",
	upgrades = {
		time1 = {
			name = "Kırılmamış I",
			info = "Özel yetenek süren 2.5s uzar\n\t• Toplam süre: 12.5s"
		},
		time2 = {
			name = "Kırılmamış II",
			info = "Özel yetenek süren 2.5s uzar\n\t• Toplam süre: 15s"
		},
		time3 = {
			name = "Kırılmamış III",
			info = "Özel yetenek süren 2.5s uzar\n\t• Toplam süre: 17.5s"
		},
		prot1 = {
			name = "Adaptation I",
			info = "10% daha az mermi hasarı alırsın"
		},
		prot2 = {
			name = "Adaptation II",
			info = "15% daha az mermi hasarı alırsın\n\t• Toplam hasar azaltması: 25%"
		},
		prot3 = {
			name = "Adaptation III",
			info = "15% daha az mermi hasarı alırsın\n\t• Toplam hasar azaltması: 40%"
		},
		speed1 = {
			name = "Öfkeli Hücum I",
			info = "Özel yetenek kullandıktan sonra, hasar alana kadar 10% hareket hızı kazan"
		},
		speed2 = {
			name = "Öfkeli Hücum II",
			info = "Özel yetenek kullandıktan sonra, hasar alana kadar 20% hareket hızı kazan"
		},
		ult = {
			name = "Rejenerasyon",
			info = "Hasar aldıktan 5 saniye sonra, 5% eksik can yenilersin"
		},
	}
}

wep.SCP8602 = {
	upgrades = {
		charge11 = {
			name = "Vahşet I",
			info = "Güçlü saldırı hasarı 5 artar"
		},
		charge12 = {
			name = "Vahşet II",
			info = "Güçlü saldırı hasarı 10 artar\n\t• Toplam artış: 15"
		},
		charge13 = {
			name = "Vahşet III",
			info = "Güçlü saldırı hasarı 10 artar\n\t• Toplam artış: 25"
		},
		charge21 = {
			name = "Hücum I",
			info = "Güçlü saldırı menzili 15 artar"
		},
		charge22 = {
			name = "Hücum II",
			info = "Güçlü saldırı menzili 15 artar\n\t• Toplam menzil artışı: 30"
		},
		charge31 = {
			name = "Paylaşılan Acı",
			info = "Güçlü saldırı gerçekleştirdiğinde, etraftaki herkes hasarın 20% sini alır"
		},
	}
}

wep.SCP939 = {
	upgrades = {
		heal1 = {
			name = "Kanasusamış I",
			info = "Saldırıların seni en az 22.5HP iyileştirir (30a kadar)"
		},
		heal2 = {
			name = "Kanasusamış II",
			info = "Saldırıların seni en az 37.5HP iyileştirir (50ye kadar)"
		},
		heal3 = {
			name = "Kanasusamış III",
			info = "Saldırıların seni en az 52.5HP iyileştirir (70e kadar)"
		},
		amn1 = {
			name = "Ölümcül Nefes I",
			info = "Zehir çapın 100 arttı"
		},
		amn2 = {
			name = "Ölümcül Nefes II",
			info = "Zehrin artık hasar veriyor: 1.5 hasar/s"
		},
		amn3 = {
			name = "Ölümcül Nefes III",
			info = "Zehir çapın 125 ve hasarı 3 hasar/s olur"
		},
	}
}

wep.SCP966 = {
	upgrades = {
		lockon1 = {
			name = "Çılgınlık I",
			info = "Saldırı için gereken süre 2.5s ye düşer"
		},
		lockon2 = {
			name = "Çılgınlık II",
			info = "Saldırı için gereken süre 2s ye düşer"
		},
		dist1 = {
			name = "Avcının Çağrısı I",
			info = "Saldırı menzili 15 artar"
		},
		dist2 = {
			name = "Avcının Çağrısı II",
			info = "Saldırı menzili 15 artar\n\t• Toplam menzil artışı: 30"
		},
		dist3 = {
			name = "Avcının Çağrısı III",
			info = "Saldırı menzili 15 artar\n\t• Toplam menzil artışı: 45"
		},
		dmg1 = {
			name = "Keskin Pençeler I",
			info = "Saldırı hasarı 5 artar"
		},
		dmg2 = {
			name = "Keskin Pençeler II",
			info = "Saldırı hasarı 5 artar\n\t• Toplam hasar artışı: 10"
		},
		bleed1 = {
			name = "Derin Yaralar I",
			info = "Saldırıların %25 ihtimalle yüksek seviye kanama uygular"
		},
		bleed2 = {
			name = "Derin Yaralar II",
			info = "Saldırıların %50 ihtimalle yüksek seviye kanama uygular"
		},
	}
}

wep.SCP24273 = {
	mind_control = "Zihin kontrolü hazır! Sağ fare tuşunu kullan",
	mind_control_cd = "Zihin kontrolü hazır bekleme süresinde! Bekle: %is",
	dash = "Saldırı hazır!",
	dash_cd = "Saldırı bekleme süresinde! Bekle: %is",
	upgrades = {
		dash1 = {
			name = "Acımasız Hücum I",
			info = "Saldırı bekleme süren 1 saniye azalır ve gücü 15% artar"
		},
		dash2 = {
			name = "Acımasız Hücum II",
			info = "Saldırıdan sonra ceza süren 1 saniye azalır and hız cezası 40% den 25%'ye düşer"
		},
		dash3 = {
			name = "Acımasız Hücum III",
			info = "Saldırı hasarın 50 artar"
		},
		mc11 = {
			name = "Devamlı Avcı I",
			info = "Zihin kontrol süren 10 saniye uzar, ama bekleme süresi 20s artar"
		},
		mc12 = {
			name = "Devamlı Avcı II",
			info = "Zihin kontrol süren 10 saniye uzar, ama bekleme süresi 25s artar\n\t• Total duration increase: 20s\n\t• Total cooldown increase: 45s"
		},
		mc21 = {
			name = "Sabırsız Avcı I",
			info = "Zihin kontrol süren 5 saniye azalır, ama bekleme süresi 10s azalır"
		},
		mc22 = {
			name = "Sabırsız Avcı II",
			info = "Zihin kontrol süren 10 saniye azalır, ama bekleme süresi 15s azalır"
		},
		mc3 = {
			name = "Devrilmez Avcı",
			info = "Zihin kontrolü sırasında 50% hasar azaltma kazan"
		},
		mc13 = {
			name = "Mutlak Yargı",
			info = "Zihin kontrolü sırasında kurbanını öldürmek, bekleme süresini 40% azaltır. Zihin kontrol mesafesi 1000 birim artar"
		},
		mc23 = {
			name = "Kızıl Yargı",
			info = "Zihin kontrolü sırasında kurbanını öldürmek, seni 400HP iyileştirir. Zihin kontrol mesafesi 500 birim artar"
		},
	}
}

wep.SCP3199 = {
	special = "Özel saldırı hazır! Sağ fare tuşuna bas",
	upgrades = {
		regen1 = {
			name = "Kan Tadı I",
			info = "Çılgınlık durumundayken saniyede 2 can yenile"
		},
		regen2 = {
			name = "Kan Tadı II",
			info = "Can yenilemesi çılgınlınlık seviyesi başına %10 artar"
		},
		frenzy1 = {
			name = "Avcının Oyunu I",
			info = "Çılgınlık seviyen 1 artar\nÇılgınlık süren %20 artar"
		},
		frenzy2 = {
			name = "Avcının Oyunu II",
			info = "Çılgınlık seviyen 1 artar\nÇılgınlık süren %30 artar\nÖzel saldırın devre dışı bırakılır\n\t• Toplam çılgınlık seviyesi artışı: 2\n\t• Toplam süre artışı: 50%"
		},
		ch = {
			name = "Kör Öfke",
			info = "25% hızlanırsın\nYou can Artık insanların kalp atışlarını tespit edemezsin"
		},
		egg1 = {
			name = "Bir Diğeri",
			info = "Bu yükseltmeyi aldığında haritada 1 inaktif yumurta oluşturursun\n\t• Eğer haritada yumurta için boş yer yok ise yumurta oluşturulmaz"
		},
		egg2 = {
			name = "Legacy",
			info = "Bu yükseltme alındığın inaktif bir yumurta aktifleştirilecektir\n\t• Eğer haritada inaktif yumurta yoksa bir işe yaramaz"
		},
		egg3 = {
			name = "Sürpriz Yumurta",
			info = "Canlanma süren 20 saniyeye iner"
		},
	}
}

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
		GENERAL = "Genel",
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

registerLanguage( lang, "turkish", "tr", "turk", "turkce" )
setLanguageFlag( "turkish", LANGUAGE.EQ_LONG_TEXT )
