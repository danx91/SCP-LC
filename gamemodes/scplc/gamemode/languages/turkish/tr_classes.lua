local lang = LANGUAGE

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
