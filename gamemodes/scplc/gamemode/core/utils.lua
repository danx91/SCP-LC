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

--[[-------------------------------------------------------------------------
Wheel menu
---------------------------------------------------------------------------]]
local wheel_visible = false
local wheel_options = {}
local wheel_cb
function OpenWheelMenu( options, cb )
	if wheel_visible then return end

	wheel_options = { { "exit", LANG.nothing, "" } }
	for i, v in ipairs( options ) do
		table.insert( wheel_options, { v[1], v[2], v[3] } )
	end

	wheel_cb = cb
	wheel_visible = true
	gui.EnableScreenClicker( true )
end

function CloseWheelMenu()
	if !wheel_visible then return end

	local x, y = input.GetCursorPos()
	local ca = math.deg( math.atan2( x - ScrW() * 0.5, -y + ScrH() * 0.5 ) )

	if ca < 0 then
		ca = 360 + ca
	end

	local selected = math.floor( ca * #wheel_options / 360 ) + 1

	if wheel_cb then
		wheel_cb( wheel_options[selected][3] )
	end

	wheel_visible = false
	wheel_options = {}
	gui.EnableScreenClicker( false )
end

hook.Add( "HUDPaint", "SLCWheelMenu", function()
	if !wheel_visible then return end

	local w, h = ScrW(), ScrH()

	local x, y = input.GetCursorPos()
	local ca = math.deg( math.atan2( x - w * 0.5, -y + h * 0.5 ) )

	if ca < 0 then
		ca = 360 + ca
	end

	local seg = #wheel_options
	local ang = 360 / seg
	local segang = ang - 4
	for i = 1, seg do
		draw.NoTexture()
		surface.SetDrawColor( Color( 200, 200, 200 ) )
		surface.DrawRing( w * 0.5, h * 0.5, w * 0.099, w * 0.057, segang + 2, 40, 1, 1 + ang * (i - 1) )

		local selected =ca > ang * (i - 1) and ca <= ang * i

		if selected then
			surface.SetDrawColor( Color( 100, 100, 100 ) )
		else
			surface.SetDrawColor( Color( 50, 50, 50 ) )
		end

		surface.DrawRing( w * 0.5, h * 0.5, w * 0.1, w * 0.055, segang, 40, 2, 2 + ang * (i - 1) )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.SetMaterial( GetMaterial( wheel_options[i][1] ) )

		local dist = w * 0.1275
		local a = math.rad( ang * 0.5 + ang * (i - 1) )
		local dx, dy = math.sin( a ) * dist, -math.cos( a ) * dist

		local size = w * 0.035
		surface.DrawTexturedRect( w * 0.5 + dx - size * 0.5, h * 0.5 + dy - size * 0.5, size, size )

		if selected then
			draw.LimitedText{
				text = wheel_options[i][2],
				pos = { w * 0.5, h * 0.5 },
				color = Color( 255, 255, 255, 100 ),
				font = "SCPHUDSmall",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
	end
end )

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