DEVELOPER_MODE = false --REMOVE!

INFO_SCREEN_DURATION = 10
PRE_BREACH_DURATION = 5 --Not used!

XPSUMMARY_ORDER = {
	"cmd",
	"general",
	"round",
	"escape",
	"win",
	"score",
	"vip",
	"daily",
}

XPSUMMARY_COLORS = {
	base = Color( 134, 115, 60 ),
	general = Color( 175, 152, 0, 255 ),
	score = Color( 39, 92, 170, 255 ),
	vip = Color( 89, 29, 104 ),
	daily = Color( 38, 116, 30 ),
	cmd = Color( 0, 0, 0, 255 ),
}

XPSUMMARY_COLORS.round = XPSUMMARY_COLORS.score
XPSUMMARY_COLORS.escape = XPSUMMARY_COLORS.score
XPSUMMARY_COLORS.win = XPSUMMARY_COLORS.score