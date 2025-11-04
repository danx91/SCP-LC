DEVELOPER_MODE = false --IMPORTANT: Set to false before publishing or running public server!

INFO_SCREEN_DURATION = 10

--[[-------------------------------------------------------------------------
SCP Buff - only applies when upgrade is bought
	Heal - heal for damage dealt to other players
	Regen - regenration of health lost due to bullet damage
---------------------------------------------------------------------------]]
SCP_BUFF_DEF = 0.25 -- % defense gained outside
SCP_BUFF_FLAT = 1 -- flat defense gained outside

SCP_BUFF_TICK = 0.333 -- delay between heal/regen ticks
SCP_BUFF_HEAL_RATE = 25 -- hp healed per tick (heal)
SCP_BUFF_REGEN_RATE = 10 -- hp recovered per tick (regen)
SCP_BUFF_REGEN_TIME = 5 -- time outside fight to start regen

SCP_BUFF_HEAL_MIN = 0.1 -- minimual heal amount (will be also scaled by SCP buff_scale)
SCP_BUFF_HEAL_MAX = 1 -- maximal heal amount (will be also scaled by SCP buff_scale)
SCP_BUFF_REGEN_MIN = 0.15 -- minimual regen amount (will be also scaled by SCP buff_scale)
SCP_BUFF_REGEN_MAX = 0.75 -- maximal regen amount (will be also scaled by SCP buff_scale)
SCP_BUFF_REGEN_CAP = 0.9 -- absolute cap of regen (not scaled)

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