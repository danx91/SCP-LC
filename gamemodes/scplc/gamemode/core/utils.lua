--[[-------------------------------------------------------------------------
rpairs
---------------------------------------------------------------------------]]
local function rpairs_iter( tab, i )
	i = i - 1
	local v = tab[i]

	if v then
		return i, v
	end
end

function rpairs( tab, i )
	return rpairs_iter, tab, (i or #tab) + 1
end

--[[-------------------------------------------------------------------------
Tables
---------------------------------------------------------------------------]]
function PopulateTable( num )
	local tab = {}

	for i = 1, num do
		tab[i] = i
	end

	return tab
end

function CreateLookupTable( tab, alt )
	local result = {}

	for k, v in pairs( tab ) do
		if alt then
			result[v] = k
		else
			result[v] = true
		end
	end

	return result
end

function RoundTable( tab )
	for k, v in pairs( tab ) do
		if istable( v ) then
			RoundTable( v )
		elseif isnumber( v ) then
			tab[k] = math.Round( v )
		end
	end
end

function AddTables( tab1, tab2 )
	for k, v in pairs( tab2 ) do
		if tab1[k] and istable( v ) then
			AddTables( tab1[k], v )
		else
			tab1[k] = v
		end
	end
end

--[[-------------------------------------------------------------------------
General functions
---------------------------------------------------------------------------]]
local rep = {
	["%#"] = "?h",
	["%$"] = "?d",
	["%["] = "?o",
	["%]"] = "?c",
	["%."] = "?t",
	["%;"] = "?s",
	["%:"] = "?n",
	["%,"] = "?m",
}
function EscapeMessage( msg )
	msg = string.gsub( msg, "?", "?q" )

	for k, v in pairs( rep ) do
		msg = string.gsub( msg, k, v )
	end

	return msg
end

function RestoreMessage( msg )
	for k, v in pairs( rep ) do
		msg = string.gsub( msg, v, k )
	end

	return string.gsub( msg, "?q", "?" )
end

//local esc = EscapeMessage( "$Alski?" )
//print( esc, RestoreMessage( esc ) )

function FindInCylinder( orig, radius, zmin, zmax, filter, mask, feed )
	local result = {}
	radius = radius * radius

	if filter then
		if !istable( filter ) then
			filter = { filter }
		end

		local f = filter
		filter = {}

		for i = 1, #f do
			filter[f[i]] = true
		end
	end

	for k, v in pairs( feed or ents.GetAll() ) do
		if !filter or filter[v:GetClass()] then
			local pos = v:GetPos() + v:OBBCenter()
			local zdist = pos.z - orig.z
			if zdist >= zmin and zdist <= zmax then
				if math.pow( pos.x - orig.x, 2 ) + math.pow( pos.y - orig.y, 2 ) <= radius then
					if mask then
						local trace = util.TraceLine( {
							start = orig,
							endpos = pos,
							mask = mask,
						} )

						if trace.Hit then
							continue
						end

					end

					table.insert( result, v )
				end
			end
		end
	end

	return result
end