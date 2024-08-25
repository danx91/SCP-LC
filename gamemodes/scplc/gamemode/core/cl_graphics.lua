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

	if !mat or mat:IsError() then
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

	//local segmentstodraw = {}
	local segang = angle / segments
	local bigradius = radius + thick

	//local lastsin = 0 --TODO optimize
	//local lastcos = 0

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

	//local segmentstodraw = {}
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

	/*for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( verts, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	end*/

	table.insert( verts, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		local sin, cos = math.sin( a ), math.cos( a )
		table.insert( verts, { x = x + sin * radius, y = y + cos * radius, u = sin / 2 + 0.5, v = cos / 2 + 0.5 } )
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
		local h = istable( height ) and height[i + 1] or height
		local ang  = math.rad( i * -120 + rotation )
		table.insert( verts, { x = x + math.sin( ang ) * h, y = y + math.cos( ang ) * h } )
	end

	surface.DrawPoly( verts )
end


--[[---------------------------------------------------------------------------
surface.PolyRoundedRect( x, y, w, h, r, seg )

Description

@param		[number]		x					X position
@param		[number]		y					Y position
@param		[number]		w					Width
@param		[number]		h					Height
@param		[number]		r					Radius

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function surface.PolyRoundedRect( x, y, w, h, r, output )
	r = math.min( r, w / 2, h / 2 )

	if r < 0 then
		r = 0
	end

	local seg = math.ceil( r / 10 ) + 3
	local verts = output or {}

	if r == 0 then
		verts[1] = { x = x + w, y = y }
		verts[2] = { x = x + w, y = y + h }
		verts[3] = { x = x, y = y + h }
		verts[4] = { x = x, y = y }
	else
		for i = 0, seg - 1 do
			local ang = ( i / ( seg - 1 ) ) * math.pi / 2
			local sin, cos = 1 - math.sin( ang ), 1 - math.cos( ang )

			verts[i + 1] = { x = x + w - sin * r, y = y + cos * r }
			verts[i + 1 + seg] = { x = x + w - cos * r, y = y + h - sin * r }
			verts[i + 1 + seg * 2] = { x = x + sin * r, y = y + h - cos * r }
			verts[i + 1 + seg * 3] = { x = x + cos * r, y = y + sin * r }
		end
	end

	if output then return end

	surface.DrawPoly( verts )
end

function surface.OutlinedRoundedRect( x, y, w, h, r, t )
	local v1, v2 = {}, {}
	surface.PolyRoundedRect( x, x, w, h, r, v1 )
	surface.PolyRoundedRect( x + t, x + t, w - t * 2, h - t * 2, r - t, v2 )
	
	draw.NoTexture()
	surface.DrawDifference( v1, v2 )
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

--[[-------------------------------------------------------------------------
surface.DrawCooldownHollowRectCW( x, y, width, height, pct )
---------------------------------------------------------------------------]]
local DIRECTION_UP, DIRECTION_DOWN, DIRECTION_LEFT, DIRECTION_RIGHT = 1, 2, 3, 4

HRCSTYLE_RECT_SOLID = 1
HRCSTYLE_TRIANGLE_STATIC = 2
HRCSTYLE_TRIANGLE_DYNAMIC = 3

local function HRCSegment( x, y, direction, short, long, pct, mode )
	local f = short / long
	local x_dir, y_dir

	if direction == DIRECTION_UP then
		x_dir = 1
		y_dir = 1
		//x = x + short
	elseif direction == DIRECTION_RIGHT then
		x_dir = -1
		y_dir = 1
		//y = y + short
	elseif direction == DIRECTION_DOWN then
		x_dir = -1
		y_dir = -1
		//x = x - short
	elseif direction == DIRECTION_LEFT then
		x_dir = 1
		y_dir = -1
		//y = y - short
	else
		return
	end

	local alt = x_dir * y_dir == -1

	if mode == 1 then
		if alt then
			surface.DrawPoly( {
				{ x = x, y = y },
				{ x = x, y = y + long * pct * y_dir },
				{ x = x + short * x_dir, y = y + long * pct * y_dir },
				{ x = x + short * x_dir, y = y }
			} )
		else
			surface.DrawPoly( {
				{ x = x, y = y },
				{ x = x + long * pct * x_dir, y = y },
				{ x = x + long * pct * x_dir, y = y + short * y_dir },
				{ x = x, y = y + short * y_dir }
			} )
		end
	else
		local t1f = pct < f and pct / f or 1
		local t1s = short * t1f

		local t1sx = t1s * x_dir
		local t1sy = t1s * y_dir

		if alt then
			if mode == 2 then
				surface.DrawPoly( {
					{ x = x, y = y },
					{ x = x, y = y + t1sy },
					{ x = x + t1sx, y = y + t1sy }
				} )
			else
				surface.DrawPoly( {
					{ x = x, y = y },
					{ x = x, y = y + t1sy },
					{ x = x + short * x_dir, y = y + short * y_dir }
				} )
			end
		else
			if mode == 2 then
				surface.DrawPoly( {
					{ x = x, y = y },
					{ x = x + t1sx, y = y },
					{ x = x + t1sx, y = y + t1sy }
				} )
			else
				surface.DrawPoly( {
					{ x = x, y = y },
					{ x = x + t1sx, y = y },
					{ x = x + short * x_dir, y = y + short * y_dir }
				} )
			end
		end

		if pct > f then
			if alt then
				y = y + short * y_dir
			else
				x = x + short * y_dir
			end

			local t2f = pct < 1 - f and ( pct - f ) / ( 1 - 2 * f ) or 1
			local t2s = ( long - 2 * short ) * t2f

			local t2sy = t2s * y_dir

			if alt then
				surface.DrawPoly( {
					{ x = x, y = y },
					{ x = x, y = y + t2sy },
					{ x = x + short * x_dir, y = y + t2sy },
					{ x = x + short * x_dir, y = y }
				} )
			else
				surface.DrawPoly( {
					{ x = x, y = y },
					{ x = x + t2s * x_dir, y = y },
					{ x = x + t2s * x_dir, y = y + short * y_dir },
					{ x = x, y = y + short * y_dir }
				} )
			end

			if pct > 1 - f then
				if alt then
					y = y + ( long - 2 * short ) * y_dir
				else
					x = x + ( long - 2 * short ) * y_dir
				end

				local t3f = pct < 1 and ( pct - 1 + f ) / f or 1
				local t3s = short * t3f

				local t3sx = t3s * x_dir
				local t3sy = t3s * y_dir

				if alt then
					if mode == 2 then
						surface.DrawPoly( {
							{ x = x, y = y },
							{ x = x, y = y + t3sy },
							{ x = x + short * ( 1 - t3f ) * x_dir, y = y + t3sy },
							{ x = x + short * x_dir, y = y }
						} )
					else
						surface.DrawPoly( {
							{ x = x, y = y },
							{ x = x, y = y + t3sy },
							{ x = x + short * x_dir, y = y },
						} )
					end
				else
					if mode == 2 then
						surface.DrawPoly( {
							{ x = x, y = y },
							{ x = x + t3sx, y = y },
							{ x = x + t3sx, y = y + short * ( 1 - t3f ) * y_dir },
							{ x = x, y = y + short * y_dir }
						} )
					else
						surface.DrawPoly( {
							{ x = x, y = y },
							{ x = x + t3sx, y = y },
							{ x = x, y = y + short * y_dir },
						} )
					end
				end
			end
		end
	end
end

function surface.DrawCooldownHollowRectCW( x, y, width, height, thick, pct, style )
	pct = math.Clamp( pct, 0, 1 )
	style = style or 1

	x = x - thick
	y = y - thick

	local tw = width + thick * 2
	local th = height + thick * 2

	if pct > 0 then
		if style == 1 then
			HRCSegment( x + thick, y, DIRECTION_UP, thick, width + thick, pct < 0.25 and pct / 0.25 or 1, style )
		else
			HRCSegment( x, y, DIRECTION_UP, thick, tw, pct < 0.25 and pct / 0.25 or 1, style )
		end

		if pct > 0.25 then
			if style == 1 then
				HRCSegment( x + tw, y + thick, DIRECTION_RIGHT, thick, height + thick, pct < 0.5 and ( pct - 0.25 ) / 0.25 or 1, style )
			else
				HRCSegment( x + tw, y, DIRECTION_RIGHT, thick, th, pct < 0.5 and ( pct - 0.25 ) / 0.25 or 1, style )
			end

			if pct > 0.5 then
				if style == 1 then
					HRCSegment( x + tw - thick, y + th, DIRECTION_DOWN, thick, width + thick, pct < 0.75 and ( pct - 0.5 ) / 0.25 or 1, style )
				else
					HRCSegment( x + tw, y + th, DIRECTION_DOWN, thick, tw, pct < 0.75 and ( pct - 0.5 ) / 0.25 or 1, style )
				end

				if pct > 0.75 then
					if style == 1 then
						HRCSegment( x, y + th - thick, DIRECTION_LEFT, thick, height + thick, pct < 1 and ( pct - 0.75 ) / 0.25 or 1, style )
					else
						HRCSegment( x, y + th, DIRECTION_LEFT, thick, th, pct < 1 and ( pct - 0.75 ) / 0.25 or 1, style )
					end
				end
			end
		end
	end
end

--[[---------------------------------------------------------------------------
draw.MultilineText( x, y, text, font, color, maxWidth, margin, dist, align, maxRows, simulate, calcW, justify )

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
@param		[table]			feed		If set, will use this data without spliting text

@return 	[number] 		height 		Final height of text including margin and distance
			[number]		width 		Width of the widest line. If simulate == true and calcW == false, maxWidth will be returned instead
---------------------------------------------------------------------------]]--
function draw.MultilineText( x, y, text, font, color, maxWidth, margin, dist, align, maxRows, simulate, calcW, feed )
	align = align or TEXT_ALIGN_LEFT
	maxWidth = maxWidth - 2 * margin

	surface.SetFont( font )

	local _, fh = surface.GetTextSize( "W" )
	local height = fh + ( dist or 0 )

	local final = feed or {}

	if !feed then
		for i, v in ipairs( string.Split( text , "\n" ) ) do
			local w, _ = surface.GetTextSize( v )

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
							//print( "LONG", string.sub( cur_txt, 0, max_c - 3 - 3 ).."..." )
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
	end

	local n = #final
	if maxRows and maxRows < n then
		n = maxRows
	end

	if simulate and !calcW then
		return margin * 2 + height * n, maxWidth, final
	end

	local maxw = 0
	local justify = false

	if align == "justify" then
		justify = true
		align = TEXT_ALIGN_LEFT
		maxw = maxWidth
	end

	for i = 1, n do
		local tw = 0

		if !simulate then
			if justify and i != n then --TODO save justify data
				local total_w = surface.GetTextSize( string.gsub( final[i], " ", "" ) )
				local words = string.Explode( " ", final[i] )
				local word_count = #words - 1

				if word_count > 0 and total_w < maxWidth then
					local free_space = maxWidth - total_w

					local per_word = math.floor( free_space / word_count )
					local left = math.floor( free_space - per_word * word_count )

					local cur_x = x + margin
					for wi, word in ipairs( words ) do
						local text_w = draw.Text{
							text = word,
							pos = { cur_x, y + margin + height * ( i - 1 ) },
							color = color,
							font = font,
							xalign = TEXT_ALIGN_LEFT,
							yalign = TEXT_ALIGN_TOP,
						}

						cur_x = cur_x + text_w + per_word + ( wi <= left and 1 or 0 )
					end
				else
					draw.Text{
						text = final[i],
						pos = { x + margin, y + margin + height * ( i - 1 ) },
						color = color,
						font = font,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_TOP,
					}
				end
			else
				local xoffset = 0

				if align == TEXT_ALIGN_LEFT then
					xoffset = margin
				elseif align == TEXT_ALIGN_RIGHT then
					xoffset = -margin
				end

				tw = draw.Text{
					text = final[i],
					pos = { x + xoffset, y + margin + height * ( i - 1 ) },
					color = color,
					font = font,
					xalign = align,
					yalign = TEXT_ALIGN_TOP,
				}
			end
		elseif calcW then
			tw = surface.GetTextSize( final[i] )
		end

		if tw > maxw then
			maxw = tw
		end
	end

	return margin * 2 + height * n, maxw, final
end

/*-------------------------------------------------------------------------
draw.SimulateMultilineText( text, font, maxWidth, margin, dist, maxRows, calcW )

Helper function, simplified form of draw.MultilineText for simulation purposes

@param  	[string] 		text 		Text to draw
@param 		[string] 		font 		Font to use
@param  	[number] 		maxWidth 	Maximum width of text
@param 		[number] 		margin 		Margin of text
@param 		[number] 		dist 		Distance between text rows
@param 		[number] 		maxRows 	Maximum amount of rows
@param 		[boolean] 		calcW 		If true, width of text will be also calculated instead of returning maxWidth

@return 	[number] 		height 		Final height of text including margin and distance
			[number]		width 		Width of the widest line. If simulate == true and calcW == false, maxWidth will be returned instead
---------------------------------------------------------------------------*/
function draw.SimulateMultilineText( text, font, maxWidth, margin, dist, maxRows, calcW )
	return draw.MultilineText( 0, 0, text, font, nil, maxWidth, margin, dist, nil, maxRows, true, calcW )
end

GLITCH_VERTICAL = 0
GLITCH_HORIZONTAL = 1

function util.GlitchData( seg, scale, color_r, color_g, color_b )
	local data = {}

	for i = 1, seg do
		data[i] = {
			offset = ( math.random() * 2 - 1 ) * scale
		}

		if color_r then
			data[i].color = Color( math.random( color_r, 255 ), math.random( color_g or color_r, 255 ), math.random( color_b or color_r, 255 ) )
		end
	end

	return data
end

function draw.Glitch( x, y, w, h, mode, data )
	if mode == GLITCH_VERTICAL then
		local xseg = #data
		local step_u = 1 / xseg
		local step_x = math.Round( w / xseg )

		for i = 1, xseg do
			local tab = data[i]

			if tab.color then
				surface.SetDrawColor( tab.color )
			end

			surface.DrawTexturedRectUV( x + step_x * ( i - 1 ), y + tab.offset * h, step_x, h, step_u * ( i - 1 ), 0, step_u * i, 1 )
		end
	elseif mode == GLITCH_HORIZONTAL then
		local yseg = #data
		local step_v = 1 / yseg
		local step_y = math.Round( h / yseg )

		for i = 1, yseg do
			local tab = data[i]

			if tab.color then
				surface.SetDrawColor( tab.color )
			end

			surface.DrawTexturedRectUV( x + tab.offset * w, y + step_y * ( i - 1 ), w, step_y, 0, step_v * ( i - 1 ), 1, step_v * i )
		end
	end
end

function draw.GlitchToTexture( texture, target, mode, data, clear, r, g, b, a )
	render.PushRenderTarget( target )
		if clear then
			render.Clear( r or 0, g or 0, b or 0, a or 255, true, true )
		end

		cam.Start2D()
			surface.SetDrawColor( 255, 255, 255, 255 )

			if isnumber( texture ) then
				surface.SetTexture( texture )
			else
				surface.SetMaterial( texture )
			end
			
			draw.Glitch( 0, 0, target:Width(), target:Height(), mode, data )
		cam.End2D()
	render.PopRenderTarget()
end

local color_white = Color( 255, 255, 255, 255 )
function draw.WepSelectIcon( ico, cx, cy, size, color )
	local ico_w, ico_h 

	if isnumber( ico ) then
		ico_w, ico_h = surface.GetTextureSize( ico )
		surface.SetTexture( ico )
	else
		ico_w = ico:Width()
		ico_h = ico:Height()
		surface.SetMaterial( ico )
	end

	if ico_w == ico_h then
		ico_w = size
		ico_h = size
	elseif ico_w > ico_h then
		ico_h = size * ico_h / ico_w
		ico_w = size
	else//elseif ico_h > ico_w then
		ico_w = size * ico_w / ico_h
		ico_h = size
	end

	PushFilters( TEXFILTER.LINEAR )

	surface.SetDrawColor( color or color_white )
	surface.DrawTexturedRect( cx + size * 0.5 - ico_w * 0.5, cy + size * 0.5 - ico_h * 0.5, ico_w, ico_h )

	PopFilters()
end

/*-------------------------------------------------------------------------
draw.BlurOutlinedText( table )



@param  	[table] 		data 		Text data to draw

@return 	[number] 		width 		
			[number]		height 		
---------------------------------------------------------------------------*/
function draw.BlurOutlinedText( tab )

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

function PushFilters( min, mag )
	render.PushFilterMin( min )
	render.PushFilterMag( mag or min )
end

function PopFilters()
	render.PopFilterMin()
	render.PopFilterMag()
end