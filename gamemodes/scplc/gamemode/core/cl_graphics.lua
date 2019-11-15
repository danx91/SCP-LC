local mat_cache = {}

/*---------------------------------------------------------------------------
GetMaterial( name, args )

Gets and caches material, if material doesn't exist, uses 'null' material.
Use command 'slc_mat_clear_cache' to clear material cache

@param 		[string] 		name 		Path to the material
@param 		[string] 		args 		PNG parameters

@return 	[IMaterial] 	material 	Requested material
---------------------------------------------------------------------------*/
function GetMaterial( name, args )
	if mat_cache[name] then
		return mat_cache[name]
	end

	local mat = Material( name, args )

	if mat:IsError() then
		mat = Material( "null" )
	end

	mat_cache[name] = mat
	return mat
end

concommand.Add( "slc_mat_clear_cache", function()
	mat_cache = {}
end )

/*---------------------------------------------------------------------------
surface.DrawRing( x, y, radius, thick, angle, segments, fill, rotation )

Draws ring with specified radius, thickness, etc. in specified position.
You have to set draw color with surface.SetDrawColor() and remove current
texture by calling draw.NoTexture()

@param 		[number] 		x 			X coordinate of the ring center
@param 		[number] 		y 			Y coordinate of the ring center
@param  	[number] 		radius  	Distance from center to place where ring begins
@param 		[number] 		thick 		Thickness of ring
@param 		[number] 		angle 		360 by default - use it if you want only part of ring
@param  	[number] 		segments  	How many segments to draw - more segments = smoother ring
										If this value is lower than 3, ring will not appear
@param 		[number] 		fill 		Number from 0 to 1, specifies visible part of the ring
										1(default) - whole ring is visible, 0 - ring is invisible
@param 		[number] 		rotation 	Rotation of the ring, by deafult 0

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
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

/*---------------------------------------------------------------------------
surface.DrawRingDC( x, y, radius, thick, angle, segments, fill, rotation, dist, func )

Works like surface.DrawRing, but you can specify distance between segments of ring and
function that will be called before each segment is drawn - for example to set color of next segment

@param 		[number] 		x 			X coordinate of the ring center
@param 		[number] 		y 			Y coordinate of the ring center
@param  	[number] 		radius  	Distance from center to place where ring begins
@param 		[number] 		thick 		Thickness of ring
@param 		[number] 		angle 		360 by default - use it if you want only part of ring
@param  	[number] 		segments  	How many segments to draw - more segments = smoother ring
										If this value is lower than 3, ring will not appear
@param 		[number] 		fill 		Number from 0 to 1, specifies visible part of the ring
										1(default) - whole ring is visible, 0 - ring is invisible
@param 		[number] 		rotation 	Rotation of the ring, by deafult 0
@param 		[number] 		dist 	 	Distance in degrees between each ring segment
@param 		[function] 		func 	 	Called before each segment is drawn

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
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

/*-------------------------------------------------------------------------
surface.DrawSubTexturedRect( x, y, w, h, subx, suby, subw, subh, txw, txh )

Draws rectangle using only part of texture

@param 		[number] 		x 			X coordinate of rectangle
@param 		[number] 		y 			Y coordinate of rectangle
@param  	[number] 		w 		  	Width of rectangle
@param 		[number] 		h 	 		Height of rectangle
@param 		[number] 		subx 		X coordinate of sub-texture
@param  	[number] 		suby 	  	Y coordinate of sub-texture
@param 		[number] 		subw 		Width of sub-texture
@param 		[number] 		subh 		Height of sub-texture
@param 		[number] 		txw 	 	Width of texture
@param 		[number] 		txh 	 	Height of texture

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
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

/*-------------------------------------------------------------------------
surface.DrawFilledCircle( x, y, radius, seg )

Draws filled circle

@param 		[number] 		x 			X coordinate of circle
@param 		[number] 		y 			Y coordinate of circle
@param  	[number] 		radius 		Radius of circle
@param 		[number] 		seg			Segments to draw - more segments = smoother circle, but less performance

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
function surface.DrawFilledCircle( x, y, radius, seg )
	seg = math.Round( seg )
	local verts = {}

	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( verts, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	end

	surface.DrawPoly( verts )
end

/*-------------------------------------------------------------------------
surface.DrawTriangle( x, y, height, rotation )

Draws triangle, in fact it draws 'circle' but with only 3 segments

@param 		[number] 		x 			X coordinate of triangle
@param 		[number] 		y 			Y coordinate of triangle
@param  	[number] 		height 		height (distance to each vertex from center)
@param 		[number] 		rotaion 	Rotation of triangle

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
function surface.DrawTriangle( x, y, height, rotation )
	rotation = rotation or 0
	local verts = {}

	for i = 0, 2 do
		local ang  = math.rad( i * 120 + rotation )
		table.insert( verts, { x = x + math.sin( ang ) * height, y = y + math.cos( ang ) * height } )
	end

	surface.DrawPoly( verts )
end

/*-------------------------------------------------------------------------
surface.DrawDifference( v1, v2 )

Draws difference between two polygons

@param 		[table] 		v1 			Data of first polygon (same as surface.DrawPoly)
@param 		[table] 		v2 			Data of second polygon (same as surface.DrawPoly)

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
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

/*-------------------------------------------------------------------------
surface.DrawCooldownCircleCW( x, y, radius, pct, pctstep )

Draws clockwise circle cooldown timer

@param 		[number] 		x 			X coordinate of center
@param 		[number] 		y 			Y coordinate of center
@param  	[number] 		radius 		Radius of circle
@param 		[number] 		pct 		Percentage of cooldown
@param 		[number] 		pctstep 	Step of draw - more steps = better quality and worse performance

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
function surface.DrawCooldownCircleCW( x, y, radius, pct, pctstep )
	pct = math.Clamp( 1 - pct, 0, 1 )

	local verts = {}
	table.insert( verts, { x = x, y = y } )

	local nbreak = false
	local todraw = math.ceil( ( 1 - pct ) / pctstep )
	for i = 0, todraw do
		local ang = 2 * math.pi * pct
		table.insert( verts, { x = x + math.sin( ang ) * radius, y = y - math.cos( ang ) * radius } )

		if nbreak then
			break
		end

		pct = pct + pctstep

		if pct > 1 then
			pct = 1
			nbreak = true
		end
	end

	surface.DrawPoly( verts )
end

/*-------------------------------------------------------------------------
surface.DrawCooldownCircleCCW( x, y, radius, pct, pctstep )

Draws counterclockwise circle cooldown timer

@param 		[number] 		x 			X coordinate of center
@param 		[number] 		y 			Y coordinate of center
@param  	[number] 		radius 		Radius of circle
@param 		[number] 		pct 		Percentage of cooldown
@param 		[number] 		pctstep 	Step of draw - more steps = better quality and worse performance

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
function surface.DrawCooldownCircleCCW( x, y, radius, pct, pctstep )
	pct = math.Clamp( pct, 0, 1 )

	local verts = {}

	table.insert( verts, { x = x, y = y } )

	local nbreak = false
	local npct = 0
	local todraw = math.ceil( pct / pctstep )
	for i = 0, todraw do
		local ang = 2 * math.pi * npct
		table.insert( verts, { x = x + math.sin( ang ) * radius, y = y - math.cos( ang ) * radius } )

		if nbreak then
			break
		end

		npct = npct + pctstep

		if npct > pct then
			npct = pct
			nbreak = true
		end
	end

	surface.DrawPoly( verts )
end

/*-------------------------------------------------------------------------
surface.DrawCooldownRectCW( x, y, width, height, pct )

Draws clockwise rectangle cooldown timer

@param 		[number] 		x 			X coordinate of rectangle
@param 		[number] 		y 			Y coordinate of rectangle
@param  	[number] 		width 		Width of rectangle
@param  	[number] 		height 		Height of rectangle
@param 		[number] 		pct 		Percentage of cooldown

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
function surface.DrawCooldownRectCW( x, y, width, height, pct )
	pct = math.Clamp( 1 - pct, 0, 1 )

	if pct == 1 then
		surface.DrawRect( x, y, width, height )
		return
	end

	local hw = width * 0.5
	local hh = height * 0.5

	local verts = {}

	table.insert( verts, { x = x + hw, y = y + hh } )

	local ang = 2 * math.pi * pct

	local nx = math.sin( ang )
	local ny = -math.cos( ang )

	local len = math.max( math.abs( nx ), math.abs( ny ) )

	if len < 1 then
		nx = nx / len
		ny = ny / len
	end

	table.insert( verts, { x = x + ( 1 + nx ) * hw, y = y + ( 1 + ny ) * hh } )

	if pct <= 0.125 then table.insert( verts, { x = x + width, y = y } ) end
	if pct <= 0.375 then table.insert( verts, { x = x + width, y = y + height } ) end
	if pct <= 0.625 then table.insert( verts, { x = x, y = y + height } ) end
	if pct <= 0.875 then table.insert( verts, { x = x, y = y } ) end

	table.insert( verts, { x = x + hw, y = y } )

	surface.DrawPoly( verts )
end

/*-------------------------------------------------------------------------
surface.DrawCooldownRectCCW( x, y, width, height, pct )

Draws counterclockwise rectangle cooldown timer

@param 		[number] 		x 			X coordinate of rectangle
@param 		[number] 		y 			Y coordinate of rectangle
@param  	[number] 		width 		Width of rectangle
@param  	[number] 		height 		Height of rectangle
@param 		[number] 		pct 		Percentage of cooldown

@return 	[nil] 			- 		  	-
---------------------------------------------------------------------------*/
function surface.DrawCooldownRectCCW( x, y, width, height, pct )
	pct = math.Clamp( pct, 0, 1 )

	if pct == 1 then
		surface.DrawRect( x, y, width, height )
		return
	end

	local hw = width * 0.5
	local hh = height * 0.5

	local verts = {}

	table.insert( verts, { x = x + hw, y = y + hh } )
	table.insert( verts, { x = x + hw, y = y } )

	if pct >= 0.125 then table.insert( verts, { x = x + width, y = y } ) end
	if pct >= 0.375 then table.insert( verts, { x = x + width, y = y + height } ) end
	if pct >= 0.625 then table.insert( verts, { x = x, y = y + height } ) end
	if pct >= 0.875 then table.insert( verts, { x = x, y = y } ) end

	local ang = 2 * math.pi * pct

	local nx = math.sin( ang )
	local ny = -math.cos( ang )

	local len = math.max( math.abs( nx ), math.abs( ny ) )

	if len < 1 then
		nx = nx / len
		ny = ny / len
	end

	table.insert( verts, { x = x + ( 1 + nx ) * hw, y = y + ( 1 + ny ) * hh } )

	surface.DrawPoly( verts )
end

/*-------------------------------------------------------------------------
draw.MultilineText( x, y, text, font, color, maxWidth, margin, dist, align, maxRows, simulate, calcW )

Draws multiline text with parameters: maximum width, maximum rows count, margin and distance.
Function can be used to simulate drawing and get final text params

@param 		[number] 		x 			X coordinate of text
@param 		[number] 		y 			Y coordinate of text
@param  	[string] 		text 		Text to draw
@param 		[string] 		font 		Font to use
@param 		[Color] 		color 		Color of text
@param  	[number] 		maxWidth 	Maximum width of text
@param 		[number] 		margin 		Margin of text
@param 		[number] 		dist 		Distance between text rows
@param 		[number] 		align 		Text align on X axis (TEXT_ALIGN_ enum)
@param 		[number] 		maxRows 	Maximum amount of rows
@param 		[boolean] 		simulate 	Don't draw text but calculate height of text
@param 		[boolean] 		calcW 		If true, width of text will be also calculated instead of returning maxWidth

@return 	[number] 		height 		Final height of text including margin and distance
			[number]		width 		Width of the widest line. If simulate == true and calcW == false, maxWidth will be returned instead
---------------------------------------------------------------------------*/
function draw.MultilineText( x, y, text, font, color, maxWidth, margin, dist, align, maxRows, simulate, calcW )
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
	local maxw = 0

	for i = 1, n do
		local tw = 0

		if !simulate then
			tw = draw.Text{
				text = final[i],
				pos = { x + margin, y + margin + height * ( i - 1 ) },
				color = color,
				font = font,
				xalign = align,
				yalign = TEXT_ALIGN_TOP,
			}
		elseif calcW then
			tw = surface.GetTextSize( final[i] )
		end

		if tw > maxw then
			maxw = tw
		end
	end

	return margin + height * n, maxw --TODO margin * 2?
end

/*-------------------------------------------------------------------------
draw.LimitedText( tab )

Draws text, but obeys maximum width

@param 		[table] 		tab 		text data
{
	[number]		x 			X position of text
	[number]		y 			Y position of text
	[string]		text 		Text to draw
	[string]		font 		Font to use
	[Color]			color 		Color of text
	[number]		max_width 	Maximum width of text
	[number]		xalign 		Text align on X axis (TEXT_ALIGN_ enum)
	[number]		yalign 		Text align on Y axis (TEXT_ALIGN_ enum)
}

@return 	[number] 		width 		Width of drawn text
			[number]		height 		Height of drawn text
---------------------------------------------------------------------------*/
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

/*_VGUIC = _VGUIC or vgui.Create
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
end*/