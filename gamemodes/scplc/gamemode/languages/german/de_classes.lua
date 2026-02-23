local lang = LANGUAGE

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
local teams = {}
lang.TEAMS = teams

teams.SPEC = "Zuschauer"
teams.CLASSD = "D-Klasse"
teams.SCI = "Wissenschaftler"
teams.MTF = "MTF"
teams.CI = "CI"
teams.SCP = "SCP"

--[[-------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------]]
local classes = {}
lang.CLASSES = classes

classes.unknown = "Unbekannt"

classes.SCP023 = "SCP 023"
classes.SCP049 = "SCP 049"
classes.SCP0492 = "SCP 049-2"
classes.SCP066 = "SCP 066"
classes.SCP096 = "SCP 096"
classes.SCP106 = "SCP 106"
classes.SCP173 = "SCP 173"
classes.SCP457 = "SCP 457"
classes.SCP076 = "SCP 076"
classes.SCP682 = "SCP 682"
classes.SCP8602 = "SCP 860-2"
classes.SCP939 = "SCP 939"
classes.SCP966 = "SCP 966"
classes.SCP3199 = "SCP 3199"
classes.SCP24273 = "SCP 2427-3"

classes.classd = "Class D"
classes.veterand = "Class D Veteran"
classes.kleptod = "Class D Kleptomaniac"
classes.ciagent = "CI Agent"

classes.sciassistant = "Scientist Assistant"
classes.sci = "Wissenschaftler"
classes.seniorsci = "Senior Wissenschaftler"
classes.headsci = "Leitender Wissenschaftler"
classes.technician = "Techniker"

classes.guard = "Security Guard"
classes.chief = "Security Chief"
classes.lightguard = "Light Security Guard"
classes.heavyguard = "Heavy Security Guard"
classes.specguard = "Security Guard Specialist"
classes.guardmedic = "Security Guard Medic"
classes.tech = "Security Guard Technician"
classes.cispy = "CI Spion"

classes.ntf_1 = "MTF NTF - SMG"
classes.ntf_2 = "MTF NTF - Schrotflinte"
classes.ntf_3 = "MTF NTF - Gewehr"
classes.ntfcom = "MTF NTF Commander"
classes.jugernaut = "Juggernaut"
classes.ntfsniper = "MTF NTF Scharfschütze"
classes.ntfmedic = "MTF NTF Medic"
classes.alpha1 = "MTF Alpha-1"
classes.alpha1sniper = "MTF Alpha-1 Schütze"
classes.ci = "Chaos Insurgency"
classes.cicom = "Chaos Insurgency Commander"

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
local generic_classd = [[- Entkomme aus der Facility
- Vermeide Personal- und SCPs
- Kooperiere mit anderen]]

local generic_sci = [[- Entkomme aus der Facility
- Vermeide D-Klassen und SCPs
- Kooperiere Mit Wachen und MTFs]]

local generic_guard = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Höre auf Deinen Vorgesetzten]]

local generic_ntf = [[- Betrete die Facility
- Helfe den restlichen Mitarbeitern in der Facility
- Lass keine  D-Klassen und SCPs entkommen]]

local generic_scp = [[- Entkomme aus der Facility
- Töte jeden, den du triffst
-  Kooperiere mit anderen SCPs]]

local generic_scp_friendly = [[- Entkomme aus der Facility
- Du darfst mit Menschen kooperieren
- Kooperiere mit anderen SCPs]]

lang.CLASS_OBJECTIVES = {
	classd = generic_classd,

	veterand = generic_classd,

	kleptod = generic_classd,

	ciagent = [[-  Eskortiere D-Klassen
- Vermeide Personal- und SCPs
- Kooperiere mit anderen]],

	sciassistant = generic_sci,

	sci = generic_sci,

	seniorsci = generic_sci,

	headsci = generic_sci,

	technician = generic_sci,

	guard = generic_guard,

	lightguard = generic_guard,

	heavyguard = generic_guard,

	specguard = generic_guard,

	chief = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Erteile anderen Wachen Befehle]],

	guardmedic = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Unterstütze andere Wachen mit deinem Medkit]],

	tech = [[- Rette alle Wissenschaftler und eskortiere sie
- Terminiere alle D-Klassen und SCPs
- Unterstütze andere Wachen mit deinem Turm]],

	cispy = [[- Gib vor, eine Wache zu sein
- Helfe denn verbleibenden D-Klassen
- Du darfst alle Wachen töten]],

	ntf_1 = generic_ntf,

	ntf_2 = generic_ntf,

	ntf_3 = generic_ntf,

	ntfmedic = [[- Helfe den restlichen Mitarbeitern in der Facility
- Unterstütze andere NTFs mit Deinen Medkit
- Lass keine  D-Klassen und SCPs entkommen]],

	ntfcom = [[- Helfe den restlichen Mitarbeitern in der Facility
- Lass keine  D-Klassen und SCPs entkommen
- Erteile anderen NTFs Befehle]],

	ntfsniper = [[- Helfe den restlichen Mitarbeitern in der Facility
- Lass keine  D-Klassen und SCPs entkommen
- Schütze dein Team von hinten]],

	alpha1 = [[- Du musst die Foundation um jeden Preis schützen
- Stoppe SCPs und Klasse D
- Du bist berechtigt denn Befehl für, ]].."[REDACTED] zu geben",

	alpha1sniper = [[- Du musst die Foundation um jeden Preis schützen
- Stoppe SCPs und Klasse D
- Du bist berechtigt denn Befehl für, ]].."[REDACTED] zu geben",

	ci = [[- Helfen dem D-Klassen und eskortiere sie
- Töte alle Mitarbeiter der Facility
- Höre auf Deinen Vorgesetzten]],

	cicom = [[- Helfen dem D-Klassen und eskortiere sie
- Töte alle Mitarbeiter der Facility
- Erteile anderen CI Befehle]],

	SCP023 = generic_scp,

	SCP049 = [[- Entkomme aus der Facility
- Kooperiere mit anderen SCPs
- Infiziere alle leichen mit R]],

	SCP0492 = [[- Entkomme aus der Facility
- Höre auf 049 und bleibe in seiner nähe
- Kooperiere mit anderen SCPs]],

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
	classd = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Niemand
Eskortiert von: CI
Überblick:
Elementare Klasse. Kooperiere mit anderen, um SCPs und Personal der Einrichtung zusammen zu kämpfen. Du kannst von CI Mitglieder eskortiert werden.
]],

	veterand = [[Schwierigkeit: Leicht
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Ja
Kann eskortieren: Niemand
Eskortiert von: CI
Überblick:
Mehr fortschrittliche Klasse. Du hast elementaren Zugriff in der Einrichtung. Kooperiere mit anderen, um SCPs und Personal der Einrichtung zusammen zu kämpfen. Du kannst von CI Mitglieder eskortiert werden.
]],

	kleptod = [[Schwierigkeit: Hoch
Zähigkeit: Niedrig
Beweglichkeit: Sehr Groß
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Niemand
Eskortiert von: CI
Überblick:
Klasse mit hohem Nutzwert. Beginnt mit ein zufälligen Gegenstand. Kooperiere mit anderen, um SCPs und Personal der Einrichtung zusammen zu kämpfen. Du kannst von CI Mitglieder eskortiert werden.
]],

	ciagent = [[Schwierigkeit: Mittel
Zähigkeit: Sehr Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: D-Class
Eskortiert von: Niemand
Überblick:
Bewaffnet mit ein Taser CI Einheit. Stell D-Klasse Hilfe zur Verfügung und kooperiere mit denen. Du kannst D-Klasse eskortieren.
]],

	sciassistant = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Elementare Klasse. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	sci = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Niedrig
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Einer der Wissenschaftler. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	seniorsci = [[Schwierigkeit: Leicht
Zähigkeit: Hoch
Beweglichkeit: Hoch
Kampf Potenzial: Normal
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Einer der Wissenschaftler. Du hast höheren Zugriff Level. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	headsci = [[Schwierigkeit: Leicht
Zähigkeit: Hoch
Beweglichkeit: Hoch
Kampf Potenzial: Normal
Kann flüchten: Ja
Kann eskortieren: Nein
Eskortiert von: MTF, Security
Überblick:
Der Beste von Wissenschaftler. Du hast höhere Nützlichkeit und HP. Kooperiere mit den Einrichtingspersonal und bleib weg von SCPs. Du kannst von MTF Mitglieder eskortiert werden.
]],

	guard = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Elementarer Sicherheitsbeamter. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	lightguard = [[Schwierigkeit: Hoch
Zähigkeit: Niedrig
Beweglichkeit: Sehr Groß
Kampf Potenzial: Niedrig
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Große Nützlichkeit, aber keine Rüstung und wenig HP. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	heavyguard = [[Schwierigkeit: Mittel
Zähigkeit: Groß
Beweglichkeit: Niedrig
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Weniger Nützlichkeit, aber bessere Rüstung und mehr HP. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	specguard = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Niedrig
Kampf Potenzial: Sehr Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Nicht so große Nützlichkeit, mehr HP und großes Kampf Potenzial. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	chief = [[Schwierigkeit: Leicht
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Ein bisschen größere Nützlichkeit und hat ein Taser. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	guardmedic = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Niedrig
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Hat ein medkit und ein Taser. Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	tech = [[Schwierigkeit: Hoch
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
Einer der Sicherheitsbeamter. Hat plazierbare Sentry mit 3 Feuermoduse (Halte E auf der Sentry um die Menu zu sehen). Benutze deine Waffen und Werkzeuge um andere Mitarbeiter zu helfen und die SCPs oder D-Klasse zu töten. Du kannst Wissenschaftler eskortieren.
]],

	cispy = [[Schwierigkeit: Sehr Hoch
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Class D
Eskortiert von: Niemand
Überblick:
CI Spion. Große Nützlichkeit. Versuche zwischen Sicherheitsbeamter zu mischen und helfe D-Klass.
]],

	ntf_1 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein SMG. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntf_2 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein Shotgun. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntf_3 = [[Schwierigkeit: Mittel
Zähigkeit: Normal
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein Gewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntfmedic = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Niedrig
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat eine Pistole und ein Medkit. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntfcom = [[Schwierigkeit: Hoch
Zähigkeit: Groß
Beweglichkeit: Sehr Groß
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat ein Scharfschützengewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ntfsniper = [[Schwierigkeit: Hoch
Zähigkeit: Normal
Beweglichkeit: Normal
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF NTF Einheit. Hat eine Sniper. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	alpha1 = [[Schwierigkeit: Mittel
Zähigkeit: Extrem Groß
Beweglichkeit: Sehr Groß
Kampf Potenzial: Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF Álpha-1 Einheit. Schwer gerüstet mit sehr großen Nützlichkeit, hat ein Gewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	alpha1sniper = [[Schwierigkeit: Hoch
Zähigkeit: Sehr Groß
Beweglichkeit: Sehr Groß
Kampf Potenzial: Sehr Groß
Kann flüchten: Nein
Kann eskortieren: Wissenschaftler
Eskortiert von: Niemand
Überblick:
MTF Álpha-1 Einheit. Schwer gerüstet mit sehr großen Nützlichkeit, hat ein Scharfschützgewehr. Gerate in die Einrichtung und sichere diese. Helfe Mitarbeiter drinnen und töte SCPs und D-Klasse.
]],

	ci = [[Schwierigkeit: Mittel
Zähigkeit: Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Class D
Eskortiert von: Niemand
Überblick:
Chaos Insurgency Einheit. Gerate in die Einrichtung und helfe D-Class und töte Mitarbeiter von der Einrichtung.
]],

	cicom = [[Schwierigkeit: Mittel
Zähigkeit: Sehr Groß
Beweglichkeit: Groß
Kampf Potenzial: Normal
Kann flüchten: Nein
Kann eskortieren: Class D
Eskortiert von: Niemand
Überblick:
Chaos Insurgency Einheit. Höheres Kampf Potenzial. Gerate in die Einrichtung und helfe D-Class und töte Mitarbeiter von der Einrichtung.
]],

--TODO: New SCP translations
}
