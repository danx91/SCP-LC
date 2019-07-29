--[[-------------------------------------------------------------------------
General functions
---------------------------------------------------------------------------]]
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

--[[-------------------------------------------------------------------------
String builder
---------------------------------------------------------------------------]]
StringBuilder = {}

function StringBuilder:New( init )
	local t = setmetatable( {}, { __index = StringBuilder, __tostring = function( obj ) return obj.str end } )

	t.New = function() end

	if isstring( init ) then
		t.str = init
	elseif istable( init ) and isstring( init.str ) then
		t.str = init.str
	elseif init then
		t.str = tostring( init )
	else
		t.str = ""
	end

	return t
end

function StringBuilder:append( str, ... )
	self.str = self.str..tostring( str )

	if ... then
		local tab = {...}
		for i = 1, #tab do
			self.str = self.str..tostring( tab[i] )
		end
	end
end

function StringBuilder:print( str, ... )
	if str then
		self:append( str, ... )
	end

	self.str = self.str.."\n"
end

function StringBuilder:trim( endonly )
	if endonly then
		self.str = string.match( self.str, "^(.-)%s*$" )
	else
		self.str = string.match( self.str, "^%s*(.-)%s*$" )
	end
end

setmetatable( StringBuilder, { __call = StringBuilder.New } )