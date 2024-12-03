DEVELOPER_MODE = false --IMPORTANT: Set to false before publishing or running public server!

INFO_SCREEN_DURATION = 10

--[[-------------------------------------------------------------------------
SCP Buff
---------------------------------------------------------------------------]]
SCP_BUFF_DEF = 0.25
SCP_BUFF_FLAT = 1

SCP_BUFF_TICK = 0.333
SCP_BUFF_HEAL_RATE = 25
SCP_BUFF_REGEN_RATE = 10
SCP_BUFF_REGEN_TIME = 5

SCP_BUFF_HEAL_MIN = 0.1
SCP_BUFF_HEAL_MAX = 1
SCP_BUFF_REGEN_MIN = 0.2
SCP_BUFF_REGEN_MAX = 0.75

--[[-------------------------------------------------------------------------
XP Summary
---------------------------------------------------------------------------]]
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