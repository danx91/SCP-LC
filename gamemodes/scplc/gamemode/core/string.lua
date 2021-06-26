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
StringTable --TODO do it better
---------------------------------------------------------------------------]]
StringTable = {}

function StringTable:New( rows, cols, data )
	local st = setmetatable( {}, { __index = StringTable } )

	st.New = function() end

	data = data or {}
	st.Data = {}
	st.Content = {}
	st.Columns = {}
	st.Dim = { rows, cols }

	for i = 1, rows do
		st.Data[i] = {}

		for j = 1, cols do
			if !st.Data[i][j] then
				local d = data[i] and data[i][j] or 1
				st.Data[i][j] = d

				if d > 1 then
					for k = 1, d - 1 do
						if j + k > cols then
							st.Data[i][j] = k
							break
						end

						st.Data[i][j + k] = 0
					end
				end
			end
		end
	end

	return st
end

function StringTable:Insert( x, y, text, format )
	if x > 0 or y > 0 and x <= self.Dim[2] and y <= self.Dim[1] then
		self.Content[y] = self.Content[y] or {}

		self.Content[y][x] = { " "..tostring( text ).." ", format }
	end
end

function StringTable:CalcColumns()
	local cols = {}

	for y = 1, self.Dim[1] do
		for x = 1, self.Dim[2] do
			cols[x] = cols[x] or 0

			if self.Data[y][x] == 1 then
				local len = self.Content[y][x] and string.len( self.Content[y][x][1] )
				if len and ( !cols[x] or cols[x] < len ) then
					cols[x] = len
				end
			end
		end
	end

	for y = 1, self.Dim[1] do
		for x = 1, self.Dim[2] do
			local size = self.Data[y][x]
			if size > 1 then
				local len = self.Content[y][x][1] and string.len( self.Content[y][x][1] )
				local cl = cols[x]

				for i = 1, size - 1 do
					cl = cl + cols[x + i]
				end

				if len and ( !cols[x] or cl < len ) then
					cols[x + size - 1] = cols[x + size - 1] + len - cl
				end
			end
		end
	end

	self.Columns = cols
end

function StringTable:Get( prt )
	self:CalcColumns()

	local len = 2
	local c = 0
	for k, v in pairs( self.Columns ) do
		len = len + v
		c = c + 1
	end

	local sep = string.rep( "-", len + c - 1 )

	local str = sep

	if prt then
		print( sep )
	end

	for i = 1, self.Dim[1] do
		local row = self:GetRow( i )

		if prt then
			print( row )
			print( sep )
		else
			str = str.."\n"..row.."\n"..sep
		end
	end

	return str
end

function StringTable:GetRow( y )
	local col = "|"

	for x = 1, self.Dim[2] do
		local len = self.Data[y][x]
		if len > 0 then
			local w = self.Columns[x] or 0

			if len > 1 then
				for i = 1, len - 1 do
					w = w + self.Columns[x + i] or 0
				end

				w = w + len - 1
			end

			local cont_tab = self.Content[y] and self.Content[y][x]
			local content = cont_tab and self.Content[y][x][1] or ""
			local align = false

			if cont_tab and cont_tab[2] then
				align = string.match( cont_tab[2], "[%<%>%&][%<%>%&]" )
			end

			if align == "<>" then
				local dif = w - string.len( content )

				local left = math.floor( dif * 0.5 )
				local right = dif - left

				local str = string.format( "%%%is%s", w - right, string.rep( " ", right ) )
				col = col..string.format( str, content ).."|"
			else
				local str = string.format( "%%%s%is", align == "<&" and "-" or "", w )
				col = col..string.format( str, content ).."|"
			end
		end
	end

	return col
end

function StringTable:Print()
	self:Get( true )
end

setmetatable( StringTable, { __call = StringTable.New } )