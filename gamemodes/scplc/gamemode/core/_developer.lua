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
			debugoverlay.Text( v + v_off, dk_str, 0.51, false )
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
			debugoverlay.Text( v[1] + v_off, v[2], 0.51, false )
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
Trace stuff
---------------------------------------------------------------------------]]
/*local MASKS = {
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

local MASKS2 = {
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