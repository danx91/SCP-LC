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
	str = tostring( str )
	self.str = self.str..str

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

function StringBuilder:trim( e )
	if e then
		self.str = string.match( self.str, "^(.-)%s*$" )
	else
		self.str = string.match( self.str, "^%s*(.-)%s*$" )
	end
end

setmetatable( StringBuilder, { __call = StringBuilder.New } )