local mat_cache = {}

function GetMaterial( name )
	if mat_cache[name] then
		return mat_cache[name]
	end

	local mat = Material( name )

	if mat:IsError() then
		mat = Material( "null" )
	end

	mat_cache[name] = mat
	return mat
end

concommand.Add( "slc_mat_clear_cache", function()
	mat_cache = {}
end )

function surface.DrawRing( x, y, radius, thick, angle, segments, fill, rotation )
	angle = math.Clamp( angle or 360, 1, 360 )
	fill = math.Clamp( fill or 1, 0, 1 )
	rotation = rotation or 0

	local segmentstodraw = {}
	local segang = angle / segments
	local bigradius = radius + thick

	local lastsin = 0
	local lastcos = 0

	for i = 1, math.Round( segments * fill ) do
		local ang1 = math.rad( rotation + ( i - 1 ) * segang )
		local ang2 = math.rad( rotation + i * segang )

		local sin1 = math.sin( ang1 )
		local cos1 = -math.cos( ang1 )

		local sin2 = math.sin( ang2 )
		local cos2 = -math.cos( ang2 )

		surface.DrawPoly( {
			{ x = x + sin1 * radius, y = y + cos1 * radius },
			{ x = x + sin1 * bigradius, y = y + cos1 * bigradius },
			{ x = x + sin2 * bigradius, y = y + cos2 * bigradius },
			{ x = x + sin2 * radius, y = y + cos2 * radius }
		} )
	end
end

function surface.DrawRingDC( x, y, radius, thick, angle, segments, fill, rotation, dist, func )
	angle = math.Clamp( angle or 360, 1, 360 )
	fill = math.Clamp( fill or 1, 0, 1 )
	rotation = rotation or 0
	dist = dist or 0

	local segmentstodraw = {}
	local segang = ( angle / segments )
	local bigradius = radius + thick

	for i = 1, math.Round( segments * fill ) do
		local ang1 = math.rad( rotation + ( i - 1 ) * segang )
		local ang2 = math.rad( rotation + i * segang - dist )

		local sin1 = math.sin( ang1 )
		local cos1 = -math.cos( ang1 )

		local sin2 = math.sin( ang2 )
		local cos2 = -math.cos( ang2 )

		if func and isfunction( func ) then
			func( i )
		end

		surface.DrawPoly( {
			{ x = x + sin1 * radius, y = y + cos1 * radius },
			{ x = x + sin1 * bigradius, y = y + cos1 * bigradius },
			{ x = x + sin2 * bigradius, y = y + cos2 * bigradius },
			{ x = x + sin2 * radius, y = y + cos2 * radius }
		} )

	end
end

function surface.DrawSubTexturedRect( x, y, w, h, subx, suby, subw, subh, txw, txh )
	local ustart = subx / txw
	local vstart = suby / txh
	local uwidth = subw / txw
	local vwidth = subh / txh

	surface.DrawPoly( {
		{
			x = x,
			y = y,
			u = ustart,
			v = vstart
		},
		{
			x = x + w,
			y = y,
			u = ustart + uwidth,
			v = vstart
		},
		{
			x = x + w,
			y = y + h,
			u = ustart + uwidth,
			v = vstart + vwidth
		},
		{
			x = x,
			y = y + h,
			u = ustart,
			v = vstart + vwidth
		},				
	} )
end

function surface.DrawFilledCircle( x, y, radius, seg )
	seg = math.Round( seg )
	local verts = {}
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( verts, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	end
	surface.DrawPoly( verts )
end

function surface.DrawTriangle( x, y, height, rotation )
	rotation = rotation or 0
	local verts = {}
	for i = 0, 2 do
		local ang  = math.rad( i * 120 + rotation )
		table.insert( verts, { x = x + math.sin( ang ) * height, y = y + math.cos( ang ) * height } )
	end
	surface.DrawPoly( verts )
end

function surface.DrawDifference( v1, v2 )
	render.ClearStencil()

	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_INCR )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )
	
	render.SetStencilEnable( true )

		surface.DrawPoly( v1 )
		surface.DrawPoly( v2 )

		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )

		surface.DrawRect( 0, 0, ScrW(), ScrH() )

	render.SetStencilEnable( false )
end

function draw.MultilineText( x, y, text, font, color, maxWidth, margin, dist, align, maxRows, simulate )
	align = align or TEXT_ALIGN_LEFT
	maxWidth = maxWidth - 2 * margin
	local texts = string.Split( text , "\n" )

	surface.SetFont( font )
	
	local fw, fh = surface.GetTextSize( "W" )
	local height = fh + ( dist or 0 )

	local final = {}

	for i, v in ipairs( texts ) do
		local w, h = surface.GetTextSize( v )

		if w <= maxWidth then
			table.insert( final, v )
		else
			local cur_txt = v
			local last_txt = ""
			local space = 0

			local stack = 0
			repeat
				stack = stack + 1
				
				local index = string.match( cur_txt, "() ", space )

				if index == nil then
					index = string.len( cur_txt ) + 1
				end

				local next_txt = string.sub( cur_txt, 1, index - 1 )
				local cw = surface.GetTextSize( next_txt )

				//print( index, next_txt, cw, maxWidth )

				if cw > maxWidth then
					//print( "greter" )
					if space > 0 then
						table.insert( final, last_txt )
						cur_txt = string.sub( cur_txt, space, string.len( cur_txt ) )
						space = 0
						//print( "INSERT", last_txt )
					else
						local max_c = string.len( cur_txt ) / cw * maxWidth
						table.insert( final, string.sub( cur_txt, 0, max_c - 3 ).."..." )
						//print( "LONG", string.sub( cur_txt, 0, max_c - 3 - 3).."..." )
						break
					end
				elseif cur_txt == next_txt then
					//print( "END", cur_txt )
					table.insert( final, cur_txt )
					break
				else
					space = index + 1
					last_txt = next_txt
				end
			until stack > 250
			if stack > 250 then
				print( "Overflow!!!" )
			end
		end
	end

	local n = maxRows or #final

	if !simulate then
		for i = 1, n do
			draw.Text{
				text = final[i],
				pos = { x + margin, y + margin + height * ( i - 1 ) },
				color = color,
				font = font,
				xalign = align,
				yalign = TEXT_ALIGN_TOP,
			}
		end
	end

	return margin + height * n
end
//function draw.LimitedText( x, y, text, font, color, max_width, xalign, yalign )
function draw.LimitedText( tab )
	tab.text = tostring( tab.text )
	
	if tab.max_width then
		local cur_text = tab.text
		local len = string.len( cur_text )

		surface.SetFont( tab.font )

		while surface.GetTextSize( cur_text ) > tab.max_width do
			len = len - 1

			if len == 0 then
				break
			end

			cur_text = string.sub( cur_text, 1, len )
		end

		tab.text = cur_text
	end

	return draw.Text( tab )
end

function draw.TextSize( text, font )
	surface.SetFont( font )
	
	return surface.GetTextSize( text )
end

_VGUIC = _VGUIC or vgui.Create
VGUIREG = VGUIREG or {}


function vgui.Create( class, parent, name )
	local tmp = _VGUIC( class, parent, name )
	table.insert( VGUIREG, tmp )
	return tmp
end

function RemoveAllDerma()
	for i = 1, #VGUIREG do
		local v = table.remove( VGUIREG, i )
		if IsValid( v ) then
			v:Remove()
		end
	end
end