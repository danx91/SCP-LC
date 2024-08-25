--[[-------------------------------------------------------------------------
Draw vectors
---------------------------------------------------------------------------]]
if SERVER then
	local a_zero = Angle( 0 )
	local v_off = Vector( 0, 0, 10 )
	local draw_key, dk_str

	concommand.Add( "draw_vectors", function( ply, cmd, args )
		if !args[1] or args[1] == "" then draw_key = nil return end
		dk_str = args[1]
		draw_key = string.Explode( ".", args[1] )
	end )

	timer.Create( "slcdrawvectors", 0.5, 0, function()
		if !draw_key then return end

		local tab = _G
		for i, v in ipairs( draw_key ) do
			tab = tab[v]
			if !istable( tab ) then return end
		end

		for k, v in pairs( tab ) do
			if !isvector( v ) then continue end

			debugoverlay.Axis( v, a_zero, 5, 0.51, true )
			debugoverlay.Text( v, tostring( v ), 0.51, false )
			debugoverlay.Text( v + v_off, dk_str.." ("..tostring( v )..")", 0.51, false )
		end
		
	end )
end

--[[-------------------------------------------------------------------------
Draw item spawns
---------------------------------------------------------------------------]]
if SERVER then
	dev_item_draw_em = {}
	local a_zero = Angle( 0 )
	local v_off = Vector( 0, 0, 10 )
	local filter
	local enabled = false

	concommand.Add( "filter_item_spawns", function( ply, cmd, args )
		if !args[1] or args[1] == "" then filter = nil return end
		filter = args[1]
	end )

	concommand.Add( "draw_item_spawns", function( ply, cmd, args )
		enabled = !enabled
	end )

	timer.Create( "slcdrawem", 0.5, 0, function()
		if !enabled then return end

		for i, v in ipairs( dev_item_draw_em ) do
			if filter and v[2] != filter then continue end
			debugoverlay.Axis( v[1], a_zero, 5, 0.51, true )
			debugoverlay.Text( v[1] + v_off, v[2].." ("..tostring( v[1] )..")", 0.51, false )
		end
		
	end )
end

--[[-------------------------------------------------------------------------
Draw zones
---------------------------------------------------------------------------]]
if SERVER then	
	concommand.Add( "draw_zones", function( ply, cmd, args )
		if !args[1] or args[1] == "" then draw_zones = nil return end
		draw_zones = args[1]
	end )

	timer.Create( "slcdrawzones", 0.5, 0, function()
		if !draw_zones then return end

		local zone = MAP_ZONES[draw_zones]
		if !zone or !istable( zone ) then return end

		for i, v in ipairs( zone ) do
			local orig = ( v[1] + v[2] ) / 2
			local mins = v[1] - orig
			local maxs = v[2] - orig

			debugoverlay.Box( orig, mins, maxs, 0.51, Color( 255, 255, 255, 0 ) )
			debugoverlay.Axis( v[1], Angle( 0 ), 10, 0.51 )
			debugoverlay.Axis( v[2], Angle( 0 ), 10, 0.51 )
		end
	end )
end

--[[-------------------------------------------------------------------------
Traces
---------------------------------------------------------------------------]]
local life = 3
_TraceLine = _TraceLine or util.TraceLine
_TraceHull = _TraceHull or util.TraceHull

function util.TraceLine( tr )
	local res = _TraceLine( tr )

	if tr.output then
		res = tr.output
	end

	
	if _DrawNextTrace then
		_DrawNextTrace = false
		debugoverlay.Line( tr.start, tr.endpos, life, Color( 255, 0, 0 ), false )
		debugoverlay.Line( tr.start, res.HitPos, life, Color( 0, 255, 0 ), false )

		local ent = res.Entity
		if IsValid( ent ) then
			local mins, maxs = ent:GetCollisionBounds()
			debugoverlay.Box( ent:GetPos(), mins, maxs, life, Color( 255, 255, 255, 0 ) )
		end
	end

	return res
end

function util.TraceHull( tr )
	local res = _TraceHull( tr )

	if tr.output then
		res = tr.output
	end

	if _DrawNextTrace then
		_DrawNextTrace = false
		debugoverlay.SweptBox( tr.start, tr.endpos, tr.mins, tr.maxs, Angle( 0 ), life, Color( 255, 0, 0 ) )
		debugoverlay.SweptBox( tr.start, res.HitPos, tr.mins, tr.maxs, Angle( 0 ), life, Color( 0, 255, 0 ) )

		local ent = res.Entity
		if IsValid( ent ) then
			local mins, maxs = ent:GetCollisionBounds()
			debugoverlay.Box( ent:GetPos(), mins, maxs, life, Color( 255, 255, 255, 0 ) )
		end
	end
	
	return res
end

--[[-------------------------------------------------------------------------
Lootables
---------------------------------------------------------------------------]]
if SERVER then
	concommand.Add( "loot_regen", function()
		for k, v in pairs( ents.FindByClass( "slc_lootable" ) ) do
			v:Remove()
		end
	
		for k, v in pairs( LOOTABLES ) do
			local ent = ents.Create( "slc_lootable" )
			if IsValid( ent ) then
				ent:SetPos( v.pos )
				ent:Spawn()
	
				ent:GenerateLoot( v.width, v.height, v.loot_pool )
	
				if v.bounds then
					ent:SetCollisionBounds( v.bounds.mins, v.bounds.maxs )
				end
			end
		end
	end )
end

--[[-------------------------------------------------------------------------
More drawing
---------------------------------------------------------------------------]]
hook.Add( "Think", "gastest", function()
	local poslol = {
		/*{ Vector( 2816, 1440, 500 ), Vector( -2600, -500, -1000 ), Color( 255, 255, 255 ) },
		{ Vector( 3250, -2500, 500 ), Vector( -2600, -500, -1000 ), Color( 255, 255, 255 ) },
		{ Vector( 1000, 1440, 500 ), Vector( 1400, 1900, -1000 ), Color( 255, 255, 255 ) },
		{ Vector( 1000, 1440, 500 ), Vector( -2600, 2100, -1000 ), Color( 255, 255, 255 ) },
		{ Vector( 2816, 72, 500 ), Vector( 3250, 824, -1000 ), Color( 255, 255, 255 ) },*/

		/*{ Vector( 3250, -3000, 500 ), Vector( 6500, 1440, -1000 ), Color( 0, 255, 255 ) },
		{ Vector( 1900, 2100, 500 ), Vector( 5500, 1440, -1000 ), Color( 0, 255, 255 ) },
		{ Vector( 2176, 2100, 500 ), Vector( 5500, 2650, -500 ), Color( 0, 255, 255 ) },
		{ Vector( 1536, 3912, 500 ), Vector( 5500, 2650, -500 ), Color( 0, 255, 255 ) },
		{ Vector( 1850, 3912, 500 ), Vector( 3000, 4500, -500 ), Color( 0, 255, 255 ) },
		{ Vector( 1750, 4500, 500 ), Vector( 3000, 5300, -500 ), Color( 0, 255, 255 ) },
		{ Vector( 2816, -500, 500 ), Vector( 3250, 72, -1000 ), Color( 0, 255, 255 ) },
		{ Vector( 2816, 824, 500 ), Vector( 3250, 1440, -1000 ), Color( 0, 255, 255 ) },*/

		/*{ Vector( -3250, 5500, 500 ), Vector( 1536, 2100, -250 ), Color( 255, 0, 255 ) },
		{ Vector( -3250, 3500, 500 ), Vector( -4000, 1700, -250 ), Color( 255, 0, 255 ) },
		{ Vector( 1536, 2100, 500 ), Vector( 2176, 2650, -250 ), Color( 255, 0, 255 ) },
		{ Vector( 1000, 2100, 500 ), Vector( 1900, 1900, -250 ), Color( 255, 0, 255 ) },
		{ Vector( 1536, 3912, 500 ), Vector( 1850, 4500, -250 ), Color( 255, 0, 255 ) },
		{ Vector( 8750, 2300, -600 ), Vector( 3200, 6750, -1500 ), Color( 255, 0, 255 ) },*/
		
		/*{ Vector( 1500, 3760, 500 ), Vector( 4350, 5390, 1200 ), Color( 255, 0, 0 ) },
		{ Vector( 1500, 6500, -250 ), Vector( 4350, 5390, 1200 ), Color( 255, 0, 0 ) },*/
	}

	--[[for k, v in pairs( poslol ) do
		OrderVectors( v[1], v[2] )
		print( string.format( "{ Vector( %i, %i, %i ), Vector( %i, %i, %i ) },", v[1].x, v[1].y, v[1].z, v[2].x, v[2].y, v[2].z ) )
	end
	print( "-----" )]]

	for k, v in pairs( poslol ) do
		local pos1, pos2, col = v[1], v[2], v[3]

		debugoverlay.Axis( pos1, Angle( 0 ), 10, 0.1, true )
		debugoverlay.Axis( pos2, Angle( 0 ), 20, 0.1, true )

		local iz = false
		debugoverlay.Line( Vector( pos1.x, pos1.y, pos1.z ), Vector( pos2.x, pos1.y, pos1.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos2.x, pos1.y, pos1.z ), Vector( pos2.x, pos2.y, pos1.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos2.x, pos2.y, pos1.z ), Vector( pos1.x, pos2.y, pos1.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos1.x, pos2.y, pos1.z ), Vector( pos1.x, pos1.y, pos1.z ), 0.1, col, iz )

		debugoverlay.Line( Vector( pos1.x, pos1.y, pos2.z ), Vector( pos2.x, pos1.y, pos2.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos2.x, pos1.y, pos2.z ), Vector( pos2.x, pos2.y, pos2.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos2.x, pos2.y, pos2.z ), Vector( pos1.x, pos2.y, pos2.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos1.x, pos2.y, pos2.z ), Vector( pos1.x, pos1.y, pos2.z ), 0.1, col, iz )

		debugoverlay.Line( Vector( pos1.x, pos1.y, pos1.z ), Vector( pos1.x, pos1.y, pos2.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos1.x, pos2.y, pos1.z ), Vector( pos1.x, pos2.y, pos2.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos2.x, pos1.y, pos1.z ), Vector( pos2.x, pos1.y, pos2.z ), 0.1, col, iz )
		debugoverlay.Line( Vector( pos2.x, pos2.y, pos1.z ), Vector( pos2.x, pos2.y, pos2.z ), 0.1, col, iz )
	end
end )

--[[-------------------------------------------------------------------------
(I) Show Speed
---------------------------------------------------------------------------]]
local show_speed = false
local text_color = Color( 255, 255, 255 )
hook.Add( "HUDPaint", "SpeedHUD", function()
	if !show_speed then return end

	local ply = LocalPlayer()
	local speed = ply:GetVelocity()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.75
	local _, h

	_, h = draw.SimpleText( "Speed: "..math.Round( speed:Length(), 1 ), "SCPHUDSmall", x, y, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	y = y + h

	draw.SimpleText( "Speed 2D: "..math.Round( speed:Length2D(), 1 ), "SCPHUDSmall", x, y, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end )

if CLIENT then
	concommand.Add( "show_speed", function()
		show_speed = !show_speed
	end )
end

--[[-------------------------------------------------------------------------
Dump loadouts
---------------------------------------------------------------------------]]
concommand.Add( "loadout_dump", function()
	for name, loadout in pairs( SLC_LOADOUTS ) do
		local txt = name..":"

		for i, v in ipairs( loadout ) do
			txt = txt.." "..v.class..","
		end

		print( txt )
	end
end )

--[[-------------------------------------------------------------------------
Trace stuff
---------------------------------------------------------------------------]]
//268435464

local CONTENTS = {
	"SOLID",-- = 1 << 0,
	"WINDOW",-- = 1 << 1,
	"AUX",-- = 1 << 2,
	"GRATE",-- = 1 << 3,
	"SLIME",-- = 1 << 4,
	"WATER",-- = 1 << 5,
	"BLOCKLOS",-- = 1 << 6,
	"OPAQUE",-- = 1 << 7,
	"TESTFOGVOLUME",-- = 1 << 8,
	"TEAM4",-- = 1 << 9,
	"TEAM3",-- = 1 << 10,
	"TEAM1",-- = 1 << 11,
	"TEAM2",-- = 1 << 12,
	"IGNORE_NODRAW_OPAQUE",-- = 1 << 13,
	"MOVEABLE",-- = 1 << 14,
	"AREAPORTAL",-- = 1 << 15,
	"PLAYERCLIP",-- = 1 << 16,
	"MONSTERCLIP",-- = 1 << 17,
	"CURRENT_0",-- = 1 << 18,
	"CURRENT_90",-- = 1 << 19,
	"CURRENT_180",-- = 1 << 20,
	"CURRENT_270",-- = 1 << 21,
	"CURRENT_UP",-- = 1 << 22,
	"CURRENT_DOWN",-- = 1 << 23,
	"ORIGIN",-- = 1 << 24,
	"MONSTER",-- = 1 << 25,
	"DEBRIS",-- = 1 << 26,
	"DETAIL",-- = 1 << 27,
	"TRANSLUCENT",-- = 1 << 28,
	"LADDER",-- = 1 << 29,
	"HITBOX",-- = 1 << 30,
}

concommand.Add( "trace_contents", function( ply )
	local start = ply:GetShootPos()

	local tr = util.TraceLine( {
		start = start,
		endpos = start + ply:GetAimVector() * 60,
		filter = ply,
		mask = MASK_ALL,
	} )

	print( "Trace resuls", tr.Entity, tr.Contents )

	local mask = tr.Contents
	local i = 1
	local n = 1

	while i <= mask do
		if bit.band( mask, i ) == i then
			print( "\t"..CONTENTS[n] )
		end

		n = n + 1
		i = bit.lshift( i, 1 )
	end
end )

concommand.Add( "split_contents", function( ply, cmd, args )
	local mask = tonumber( args[1] )
	local i = 1
	local n = 1

	while i <= mask do
		if bit.band( mask, i ) == i then
			print( "\t"..CONTENTS[n] )
		end

		n = n + 1
		i = bit.lshift( i, 1 )
	end
end )

/*local CONTENTS = {
	CONTENTS_SOLID = 1,
	CONTENTS_WINDOW = 2,
	CONTENTS_AUX = 4,
	CONTENTS_GRATE = 8,
	CONTENTS_SLIME = 16,
	CONTENTS_WATER = 32,
	CONTENTS_BLOCKLOS = 64,
	CONTENTS_OPAQUE = 128,
	CONTENTS_TESTFOGVOLUME = 256,
	CONTENTS_TEAM4 = 512,
	CONTENTS_TEAM3 = 1024,
	CONTENTS_TEAM1 = 2048,
	CONTENTS_TEAM2 = 4096,
	CONTENTS_IGNORE_NODRAW_OPAQUE = 8192,
	CONTENTS_MOVEABLE = 16384,
	CONTENTS_AREAPORTAL = 32768,
	CONTENTS_PLAYERCLIP = 65536,
	CONTENTS_MONSTERCLIP = 131072,
	CONTENTS_CURRENT_0 = 262144,
	CONTENTS_CURRENT_90 = 524288,
	CONTENTS_CURRENT_180 = 1048576,
	CONTENTS_CURRENT_270 = 2097152,
	CONTENTS_CURRENT_UP = 4194304,
	CONTENTS_CURRENT_DOWN = 8388608,
	CONTENTS_ORIGIN = 16777216,
	CONTENTS_MONSTER = 33554432,
	CONTENTS_DEBRIS = 67108864,
	CONTENTS_DETAIL = 134217728,
	CONTENTS_TRANSLUCENT = 268435456,
	CONTENTS_LADDER = 536870912,
	CONTENTS_HITBOX = 1073741824,
}

local MASKS = {
	MASK_SPLITAREAPORTAL = 48,
	MASK_SOLID_BRUSHONLY = 16395,
	MASK_WATER = 16432,
	MASK_BLOCKLOS = 16449,
	MASK_OPAQUE = 16513,
	MASK_VISIBLE = 24705,
	MASK_DEADSOLID = 65547,
	MASK_PLAYERSOLID_BRUSHONLY = 81931,
	MASK_NPCWORLDSTATIC = 131083,
	MASK_NPCSOLID_BRUSHONLY = 147467,
	MASK_CURRENT = 16515072,
	MASK_SHOT_PORTAL = 33570819,
	MASK_SOLID = 33570827,
	MASK_BLOCKLOS_AND_NPCS = 33570881,
	MASK_OPAQUE_AND_NPCS = 33570945,
	MASK_VISIBLE_AND_NPCS = 33579137,
	MASK_PLAYERSOLID = 33636363,
	MASK_NPCSOLID = 33701899,
	MASK_SHOT_HULL = 100679691,
	MASK_SHOT = 1174421507,
	MASK_ALL = 4294967295,
	MASK_USE = MASK_USE
}

local LOOKUP = CreateLookupTable( MASKS, true )
local LOOKUP2 = CreateLookupTable( MASKS2, true )

function ENT:TestCollision( pos, delta, box, size, mask )
	print( self, mask )

	if LOOKUP2[mask] then
		print( LOOKUP2[mask] )
	end

	if mask == 0 then
		print( "CONTENTS_EMPTY" )
		return
	end

	for i = 32, 0, -1 do
		local pow = 2^i
		if pow <= mask then
			mask = mask - pow
			Msg( LOOKUP[pow].." " )

			if mask == 0 then break end
		end
	end

	print()
end*/

MsgC( Color( 230, 20, 20 ), "# _developer.lua loaded!\n" )