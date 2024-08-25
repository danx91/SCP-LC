--[[-------------------------------------------------------------------------
ZONES
---------------------------------------------------------------------------]]
SLCZones = {
	ZONES = {},
	ALL = {},
}

ZONE_FLAG_FACILITY = bit.lshift( 1, 0 )
ZONE_FLAG_SURFACE = bit.lshift( 1, 1 )
ZONE_FLAG_ANOMALY = bit.lshift( 1, 2 )
ZONE_FLAG_RESTRICT173 = bit.lshift( 1, 3 )
ZONE_FLAG_SAFE = bit.lshift( 1, 4 )

ZONE_LAST_FLAG = 4

function SLCZones.AddZone( name, flag )
	if SLCZones.ZONES[name] then return end

	_G["ZONE_"..string.upper( name )] = name
	SLCZones.ZONES[name] = flag or 0
	table.insert( SLCZones.ALL, name )
end

function SLCZones.GetAll()
	return SLCZones.ALL
end

function SLCZones.AddFlag( zone, flag )
	if !SLCZones.ZONES[zone] then return end

	SLCZones.ZONES[zone] = bit.bor( SLCZones.ZONES[zone], flag )
end

function SLCZones.HasFlag( zone, flag )
	if !SLCZones.ZONES[zone] then return end 

	return bit.band( SLCZones.ZONES[zone], flag ) == flag
end

function SLCZones.GetPlayersInZone( zone )
	if !SLCZones.ZONES[zone] then return end 

	local tab = {}

	for i, v in ipairs( player.GetAll() ) do
		if v:IsInZone( zone ) then
			table.insert( tab, v )
		end
	end

	return tab
end

function SLCZones.GetPlayersByFlag( flag )
	if !isnumber( flag ) then return end 

	local zones = {}
	local any = false

	for _, v in ipairs( SLCZones.ALL ) do
		if SLCZones.HasFlag( v, flag ) then
			table.insert( zones, v )
			any = true
		end
	end

	if !any then
		return {}
	end

	local tab = {}

	for _, v in ipairs( player.GetAll() ) do
		for _, zone in ipairs( zones ) do
			if v:IsInZone( zone ) then
				table.insert( tab, v )
				break
			end
		end
	end

	return tab
end

function SLCZones.IsInZone( vec, zone )
	if isnumber( zone ) then
		return SLCZones.IsInZoneByFlag( vec, zone )
	end

	local tab = MAP_ZONES[zone]
	if !tab then return false end

	local t_type = type( tab )
	if t_type == "function" then
		return tab( vec )
	elseif t_type == "table" then
		for i, v in ipairs( tab ) do
			if vec:WithinAABox( v[1], v[2] ) then
				return true
			end
		end
	end

	return false
end

function SLCZones.IsInZoneByFlag( vec, flag )
	for _, v in ipairs( SLCZones.ALL ) do
		if !SLCZones.HasFlag( v, flag ) then continue end
		
		if SLCZones.IsInZone( vec, v ) then
			return true
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
Entity functions
---------------------------------------------------------------------------]]
local ENTITY = FindMetaTable( "Entity" )

function ENTITY:IsInZone( zone )
	if isstring( zone ) then
		return SLCZones.IsInZone( self:GetPos(), zone )
	elseif isnumber( zone ) then
		return SLCZones.IsInZoneByFlag( self:GetPos(), zone )
	end

	return false
end


--[[-------------------------------------------------------------------------
Default zones
---------------------------------------------------------------------------]]
SLCZones.AddZone( "surface", bit.bor( ZONE_FLAG_SURFACE, ZONE_FLAG_RESTRICT173 ) )
SLCZones.AddZone( "pd", ZONE_FLAG_ANOMALY )
SLCZones.AddZone( "lcz", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "hcz", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "ez", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "warhead", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "scp106", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "restrict173", ZONE_FLAG_RESTRICT173 )
SLCZones.AddZone( "scp914", bit.bor( ZONE_FLAG_SAFE, ZONE_FLAG_RESTRICT173 ) )
SLCZones.AddZone( "forest", ZONE_FLAG_ANOMALY )