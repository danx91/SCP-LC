--[[-------------------------------------------------------------------------
Blocker
---------------------------------------------------------------------------]]
local ps = {
	{ 1, 0, 0, 1 },
	{ -1, 0, 0, 1 },
	{ 0, 1, 1, 0 },
	{ 0, -1, 1, 0 },
}

function GenCubeBlockerData( name, pos, x, y, z, thickness, ex, filter, dest )
	dest = dest or BLOCKERS

	for i = 1, 4 do
		local dim = ps[i]
		if !ex or ex != i then
			table.insert( dest, {
				name = name.."_"..i,
				pos = pos + Vector( ( x / 2 - thickness / 2 ) * dim[1], ( y / 2 - thickness / 2 ) * dim[2], 0 ),
				bounds = {
					Vector( dim[3] == 1 and ( -x / 2 + thickness ) or ( -thickness / 2 ), dim[4] == 1 and ( -y / 2 ) or ( -thickness / 2 ), -z / 2 ),
					Vector( dim[3] == 1 and ( x / 2 - thickness ) or ( thickness / 2 ), dim[4] == 1 and ( y / 2 ) or ( thickness / 2 ), z / 2 ),
				},
				filter = filter,
			} )
		end
	end

	/*table.insert( dest, {
		name = name.."_xp",
		pos = pos + Vector( x / 2 - thickness / 2, 0, 0 ),
		bounds = {
			Vector( -thickness / 2, -y / 2, -z / 2 ),
			Vector(  thickness / 2,  y / 2,  z / 2 ),
		}
	} )

	table.insert( dest, {
		name = name.."_xn",
		pos = pos - Vector( x / 2 - thickness / 2, 0, 0 ),
		bounds = {
			Vector( -thickness / 2, -y / 2, -z / 2 ),
			Vector(  thickness / 2,  y / 2,  z / 2 ),
		}
	} )

	table.insert( dest, {
		name = name.."_yp",
		pos = pos + Vector( 0, y / 2 - thickness / 2, 0 ),
		bounds = {
			Vector( -x / 2 + thickness, -thickness / 2, -z / 2 ),
			Vector(  x / 2 - thickness,  thickness / 2,  z / 2 ),
		}
	} )

	table.insert( dest, {
		name = name.."_yn",
		pos = pos - Vector( 0, y / 2 - thickness / 2, 0 ),
		bounds = {
			Vector( -x / 2 + thickness, -thickness / 2, -z / 2 ),
			Vector(  x / 2 - thickness,  thickness / 2,  z / 2 ),
		}
	} )*/
end

SLC_FILTER_GROUPS = {}

local FilterGroup = {}

function FilterGroup:AddTeam( team )
	self.teams[team] = true

	return self
end

function FilterGroup:AddClass( class )
	self.classes[class] = true
	return self
end

function FilterGroup:AddFunction( func )
	table.insert( self.functions, func )
	return self
end

function FilterGroup:AddCustomCheck( func )
	table.insert( self.custom, func )
	return self
end

function AddFilterGroup( name, base )
	local tab = setmetatable( {
		base = base,
		teams = {},
		classes = {},
		functions = {},
		custom = {},
	}, { __index = FilterGroup } )

	SLC_FILTER_GROUPS[name] = tab
	return tab
end

function GetFilterGroup( name )
	return SLC_FILTER_GROUPS[name]
end

function GetFilterGroupData( name )
	local filter = SLC_FILTER_GROUPS[name]
	if filter then
		local data = {
			teams = filter.teams,
			classes = filter.classes,
			players = {},
			custom = filter.custom,
		}

		for k, func in pairs( filter.functions ) do
			local result = func( name )
			if result then
				for k2, ply in pairs( result ) do
					data.players[ply] = true
				end
			end
		end

		return data
	end
end

AddFilterGroup( "non_human" ):AddTeam( TEAM_SCP )

BLOCKER_WHITELIST = 0
BLOCKER_BLACKLIST = 1

hook.Add( "SLCPreround", "SLCBlocker", function()
	for i, v in ipairs( BLOCKERS ) do
		local blocker = ents.Create( "slc_blocker" )
		if IsValid( blocker ) then
			blocker:SetBlockerID( i )
			blocker:Spawn()
		end
	end
end )