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

function SLCZones.AddZone( name, flag )
	if SLCZones.ZONES[name] then return end

	_G["ZONE_"..string.upper( name )] = name
	SLCZones.ZONES[name] = flag or 0
	table.insert( SLCZones.ALL, name )
end

function SLCZones.GetAll()
	return SLCZones.ALL
end

function SLCZones.HasFlag( zone, flag )
	if !SLCZones.ZONES[zone] then return end 

	return bit.band( SLCZones.ZONES[zone], flag ) == flag
end

function SLCZones.GetPlayersInZone( zone )
	if !SLCZones.ZONES[zone] then return end 

	local tab = {}

	for k, v in pairs( player.GetAll() ) do
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

	for k, v in pairs( SLCZones.ALL ) do
		if SLCZones.HasFlag( v, flag ) then
			zones[v] = true
			any = true
		end
	end

	if !any then
		return {}
	end

	local tab = {}

	for k, v in pairs( player.GetAll() ) do
		for z, _ in pairs( zones ) do
			if v:IsInZone( z ) then
				table.insert( tab, v )
				break
			end
		end
	end

	return tab
end

function SLCZones.IsInZone( vec, zone )
	local tab = MAP_ZONES[zone]
	if !tab then return false end

	local t_type = type( tab )
	if t_type == "function" then
		return tab( vec )
	elseif t_type == "table" then
		for k, v in pairs( tab ) do
			if vec:WithinAABox( v[1], v[2] ) then
				return true
			end
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:IsInZone( name )
	return SLCZones.IsInZone( self:GetPos(), name )
end

--[[-------------------------------------------------------------------------
Default zones
---------------------------------------------------------------------------]]
SLCZones.AddZone( "surface", ZONE_FLAG_SURFACE )
SLCZones.AddZone( "pd", ZONE_FLAG_ANOMALY )
SLCZones.AddZone( "lcz", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "hcz", ZONE_FLAG_FACILITY )
SLCZones.AddZone( "ez", ZONE_FLAG_FACILITY )