local lang = LANGUAGE

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

