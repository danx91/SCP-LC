--[[-------------------------------------------------------------------------
Replace table.Random
Copied and modified from: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L166-L177
---------------------------------------------------------------------------]]
function table.Random( t )
	local rk = SLCRandom( 1, table.Count( t ) )
	local i = 1
	for k, v in pairs( t ) do
		if i == rk then return v, k end
		i = i + 1
	end
end

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function PopulateTable( num, fill )
	local tab = {}

	for i = 1, num do
		tab[i] = fill or i
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

function ShuffleTable( tab )
	for i = #tab, 2, -1 do
		local j = SLCRandom( 1, i )
		tab[i], tab[j] = tab[j], tab[i]
	end
end