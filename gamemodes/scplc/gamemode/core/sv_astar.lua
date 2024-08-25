local heuristic_functions = {
	euclidean = function( a, b )
		return a:Distance( b )
	end,
	euclidean2d = function( a, b )
		return a:Distance2D( b )
	end,
	manhattan = function( a, b )
		local diff = a - b
		return math.abs( diff.x ) + math.abs( diff.y ) + math.abs( diff.z )
	end,
	manhattan2d = function( a, b )
		local diff = a - b
		return math.abs( diff.x ) + math.abs( diff.y )
	end
}

local heuristic_function

local function get_cost( a, b )
	return heuristic_function( a:GetCenter(), b:GetCenter() )
end

local function reconstruct_path( path, current )
	local final_path = { current }

	local current_id = current:GetID()
	while path[current_id] do
		current_id = path[current_id]
		table.insert( final_path, 1, navmesh.GetNavAreaByID( current_id ) )
	end

	return final_path
end

--[[---------------------------------------------------------------------------
SLCDrawNavArea( area )

Debug function that draw CNavArea

@param		[CNavArea]		area				CNavArea to draw

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function SLCDrawNavArea( area )
	local pos = area:GetCenter()
	local size = Vector( area:GetSizeX(), area:GetSizeY() )
	
	debugoverlay.Sphere( pos, 8, 10, Color( 0, 255, 0, 0 ), true )
	debugoverlay.Box( pos, -size / 2, size / 2, 10, Color( 0, 255, 0, 0 ) )
end

--[[---------------------------------------------------------------------------
SLCAStar( start, goal, h )

A* search algorithm
Based on: https://en.wikipedia.org/wiki/A*_search_algorithm

@param		[Vector/CNavArea]		start		Starting point
@param		[Vector/CNavArea]		goal		Goal point
@param		[string/function]		h			Heuristic cost function, if not present defaults to euclidean norm
@param		[function]				test		2 adjecent CNavAreas are passed as arguments. Return true to allow, false to disallow. Always allowed if not specified
@param		[number]				max			Maximum number of iterations. Unlimited if not specified

@return		[nil/boolean/table]		-			nil if invalid params, false if not possible, true if start == goal, table of CNavAreas on success
---------------------------------------------------------------------------]]--
function SLCAStar( start, goal, h, test, max )
	if isvector( start ) then
		start = navmesh.GetNearestNavArea( start )
	end

	if isvector( goal ) then
		goal = navmesh.GetNearestNavArea( goal )
	end

	if !start or !goal then return end

	if isstring( h ) then
		h = heuristic_functions[h]
	end

	if !h then
		h = heuristic_functions.euclidean
	end

	if !isfunction( h ) then return end
	heuristic_function = h

	if start == goal then return true end

	start:ClearSearchLists()
	start:AddToOpenList()
	start:SetCostSoFar( 0 )
	start:SetTotalCost( get_cost( start, goal ) )
	start:UpdateOnOpenList()

	local path = {}
	local iters = 0

	while !start:IsOpenListEmpty() do
		iters = iters + 1
		if max and iters > max then
			return false
		end

		local current = start:PopOpenList()
		if current == goal then
			return reconstruct_path( path, current )
		end

		current:AddToClosedList()

		for i, v in ipairs( current:GetAdjacentAreas() ) do
			if test and !test( current, v ) then continue end

			local current_cost = current:GetCostSoFar() + get_cost( current, v )
			if current_cost < v:GetCostSoFar() or !v:IsOpen() and !v:IsClosed() then
				v:SetCostSoFar( current_cost )
				v:SetTotalCost( current_cost + get_cost( v, goal ) )

				if v:IsOpen() then
					v:UpdateOnOpenList()
				else
					v:AddToOpenList()
				end

				path[v:GetID()] = current:GetID()
			end
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
Helper function to draw calculated path in developer mode
---------------------------------------------------------------------------]]
function SLCDrawPath( path, t )
	debugoverlay.Sphere( path[1], 4, t or 10, Color( 0, 255, 0, 0 ), true )
	debugoverlay.Text( path[1], 1, t or 10, false )

	for i = 2, #path do
		debugoverlay.Sphere( path[i], 8, t or 10, Color( 0, 255, 0, 0 ), true )
		debugoverlay.Line( path[i - 1], path[i], t or 10, Color( 0, 255, 0, 0 ), false )
		debugoverlay.Text( path[i], i, t or 10, false )
	end
end

--[[---------------------------------------------------------------------------
SLCCalculatePath( start, goal, h, test, bounds, offset, mask )

Calculate path using A* algorithm

@param		[Vector/CNavArea]		start			Starting point
@param		[Vector/CNavArea]		goal			Goal point
@param		[string/function]		h				Heuristic cost function, if not present defaults to euclidean norm
@param		[function]				test			2 adjecent CNavAreas are passed as arguments. Return true to allow, false to disallow. Always allowed if not specified
@param		[Vector]				bounds			Bounds to test collision with world. Defaults to Vector( 8, 8, 8 )
@param		[number]				offset			Z axis offset to test path collision with world. Defaults to 32
@param		[MASK_*]				mask			Mask used to test path collision with world. Defaults to MASK_SOLID_BRUSHONLY

@return		[nil/boolean/table]		-				nil if invalid params, false if not possible, true if start == goal, table of Vectors on success
---------------------------------------------------------------------------]]--
function SLCCalculatePath( start, goal, h, test, max, bounds, offset, mask )
	local navs = SLCAStar( start, goal, h, test, max )
	if !istable( navs ) then return navs end

	local len = #navs
	local path = {}
	
	path[1] = navs[1]:GetClosestPointOnArea( start )
	path[len + 2] = navs[len]:GetClosestPointOnArea( goal )

	for i = 2, len + 1 do
		path[i] = navs[i - 1]:GetCenter()
	end

	bounds = bounds or Vector( 8, 8, 8 )
	offset = Vector( 0, 0, offset or 32 )

	local trace_tab = {}
	trace_tab.mask = mask or MASK_SOLID_BRUSHONLY
	trace_tab.mins = -bounds
	trace_tab.maxs = bounds
	trace_tab.output = trace_tab

	for i = 2, len + 1 do
		local new = navs[i - 1]:GetClosestPointOnArea( ( path[i - 1] + path[i + 1] ) / 2 )

		trace_tab.start = path[i - 1] + offset
		trace_tab.endpos = new + offset
		util.TraceHull( trace_tab )

		if !trace_tab.Hit then
			path[i] = new
			continue
		end

		local lerp = LerpVector( 0.3, new, path[i] )

		trace_tab.start = path[i - 1] + offset
		trace_tab.endpos = lerp + offset
		util.TraceHull( trace_tab )

		if !trace_tab.Hit then
			path[i] = lerp
		end
	end

	if DEVELOPER_MODE and !DEV_NO_PATH then
		SLCDrawPath( path )
	end

	DEV_NO_PATH = false

	return path
end

function SLCPathLength( path )
	local len = #path
	if len < 2 then return end

	local result = 0
	local prev = path[1]

	for i = 2, len do
		local cur = path[i]
		result = result + prev:Distance( cur )
		prev = cur
	end

	return result
end