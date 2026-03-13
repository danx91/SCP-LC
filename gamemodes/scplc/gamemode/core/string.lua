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

--[[-------------------------------------------------------------------------
StringTable
---------------------------------------------------------------------------]]
StringTable = {}
StringTable.__index = StringTable

setmetatable( StringTable, {
	__call = function( class, ... )
		local obj = setmetatable( {}, class )
		if obj.Initialize then obj:Initialize( ... ) end
		return obj
	end
} )

function StringTable:Initialize( split )
	self.Split = split or false

	self.Columns = {}
	self.Rows = { {} }

	self.NumColumns = 0
end

function StringTable:AddColumn( name, specifier, flags, length, precision )
	if type( name ) != "string" then argerror( 1, "AddColumn", "string", type( name ) ) end
	if type( specifier ) != "string" then argerror( 2, "AddColumn", "string", type( specifier ) ) end

	name = utf8.force( tostring( name ) )

	flags = flags or "-"

	local name_len = utf8.len( name )

	if !length or length < name_len then
		length = name_len
	end

	local no_length = "%"..flags

	if precision then
		no_length = no_length.."."..precision
	end

	no_length = no_length..specifier

	table.insert( self.Columns, {
		specifier = specifier,
		flags = flags,
		length = length,
		precision = precision,
		no_length = no_length,
		pad_right = !!string.find( flags, "-", 1, true ),
	} )

	self.NumColumns = self.NumColumns + 1

	self.Rows[1][self.NumColumns] = name

	return self
end

function StringTable:AddRow( ... )
	local args = { ... }
	local len = #args

	assert( len == self.NumColumns, string.format( "AddRow arguments count must match columns count (expected %i, got %i)", self.NumColumns, len ) )

	for i, v in ipairs( args ) do
		if isstring( v ) then
			v = utf8.force( v )
			args[i] = v
		end

		local column = self.Columns[i]
		local arg_len = utf8.len( string.format( column.no_length, v ) )

		if arg_len > column.length then
			column.length = arg_len
		end
	end

	table.insert( self.Rows, args )

	return self
end

function StringTable:ParseRow( num )
	local row = self.Rows[num]
	if !row then return "" end

	local header = num == 1
	local format = "|"

	for i, v in ipairs( self.Columns ) do
		format = format.." %"..v.flags..v.length

		if !header and v.precision then
			format = format.."."..v.precision
		end

		format = format..( header and "s" or v.specifier )

		local cell = row[i]
		if isstring( cell ) then
			local correction = string.len( cell ) - utf8.len( cell )
			if correction > 0 then
				format = format..string.rep( " ", correction )
			end
		end

		format = format.." |"
	end

	return string.format( format.."\n", unpack( row ) )
end

function StringTable:ToString( dest )
	if self.NumColumns <= 0 then
		if dest then
			dest[1] = ""
			return dest
		end

		return ""
	end

	local total_length = 1

	for i, v in ipairs( self.Columns ) do
		total_length = total_length + v.length + 3
	end

	local border = string.rep( "-", total_length ).."\n"
	local separator = "|"..string.rep( "-", total_length - 2 ).."|\n"

	local current = border
	local current_len = string.len( current )

	local last = #self.Rows
	for i = 1, last do
		local tmp = self:ParseRow( i )

		if i == last then
			tmp = tmp..border
		elseif i == 1 or self.Split then
			tmp = tmp..separator
		end

		local tmp_len = string.len( tmp )
		if current_len + tmp_len > 4096 then
			if dest then
				table.insert( dest, current )
				current = tmp
				current_len = tmp_len
			else
				return current.."..."
			end
		else
			current = current..tmp
			current_len = current_len + tmp_len
		end
	end

	if dest then
		table.insert( dest, current )
		return dest
	end

	return current
end

function StringTable:Print()
	for i, v in ipairs( self:ToString( {} ) ) do
		Msg( v.."\n" )
	end
end

StringTable.__tostring = StringTable.ToString

--[[-------------------------------------------------------------------------
General functions
---------------------------------------------------------------------------]]
function string.ExactLength( str, len, alignRight )
	local sl = string.len( str )

	if sl == len then
		return str
	elseif sl > len then
		return string.sub( str, 1, len )
	else
		local s = string.rep( " ", len - sl )

		if alignRight then
			return s..str
		else
			return str..s
		end
	end
end

function string.SplitThousands( number, separator )
	local format = "%1"..( separator or " " )

	local left, num, right = string.match( number, "^([^%d]*%d)(%d*)(.-)$" )
	return left..num:reverse():gsub( "(%d%d%d)", format ):reverse()..right
	//return left..string.reverse( string.gsub( string.reverse( num ), "(%d%d%d)", format ) )..right
end

function string.UUID()
	return string.gsub( "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function( c )
		return string.format( "%x", c == "x" and SLCRandom( 0x00, 0x0f ) or SLCRandom( 0x08, 0x0b ) )
	end )
end