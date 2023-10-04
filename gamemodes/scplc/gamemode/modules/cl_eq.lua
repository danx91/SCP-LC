function GM:HUDDrawPickupHistory()
end

function GM:HUDWeaponPickedUp( weapon )
	if IsValid( weapon ) and weapon:GetClass() == "item_slc_keycard" then
		if weapon.Think then
			weapon:Think()
		end
	end

	UpdatePlayerEQ()
end

function GM:HUDItemPickedUp( itemName )
end

function GM:HUDAmmoPickedUp( itemName, amount )
end

local button_next = false
local next_frame = false
local button_hold = 0
local holdid = nil
local function Button( x, y, w, h, id )
	local mx, my = input.GetCursorPos()
	if mx >= x and mx <= x + w and my >= y and my <= y + h then
		local rt = RealTime()
		if input.IsMouseDown( MOUSE_LEFT ) then
			if button_hold == 0 then
				button_hold = rt + 0.2
				holdid = id
				return 1 --HOVER
			elseif button_hold <= rt then
				if holdid and holdid != id then
					return 1 --HOVER
				end

				return 4 --HOLD
			end
		elseif input.IsMouseDown( MOUSE_RIGHT ) then
			if button_next then
				button_next = false
				return 3 --RMB
			else
				return 1 --HOVER
			end
		else
			if button_hold != 0 and button_hold > rt then
				if button_next then
					button_next = false
					button_hold = 0
					return 2 --LMB
				end
			end

			if next_frame then
				next_frame = false
				button_next = true
				button_hold = 0
				holdid = nil
			end

			return 1 --HOVER
		end
	end

	return 0
end

local MATS = {
	vest = Material( "slc/items/vest.png" ),
	gear = Material( "slc/hud/gear.png" ),
}

local TEXTURES = {
	weapon_stunstick = { SelectFont = "SCPHLIcons", IconLetter = "n" },
	weapon_crowbar = { SelectFont = "SCPHLIcons", IconLetter = "c" }
}

EQ_OVERRIDE_FONTS = {
	CW_SelectIcons = "SCPCSSIcons",
}

local SHOW_WEP_INFO = nil

local WEAPONS = {}
local EQ = {
	cols = 4,
	rows = 2,
	size = 0.075,
	offset = 0.0075
}

EQ.slots = EQ.cols * EQ.rows

local blur = Material( "pp/blurscreen" )
local recomputed = false

local draw_eq = false
local close_eq = false
local fast_close = false
local fast_open = false
local alpha = 1

local nav_font = "SCPHUDSmall"

/*local show = function()
	local t = LocalPlayer():SCPTeam()
	return t == TEAM_MTF or t == TEAM_CI
end*/

local cmd_func = function( this, cmd )
	slc_cmd.Run( cmd )
	this.cooldown = slc_cmd.GetPlayerCooldown( LocalPlayer(), cmd )
	this.cd_time = slc_cmd.GetCommandCooldown( cmd )
end

local ACTIONS = {
	{
		name = "escort",
		material = GetMaterial( "slc/hud/escort.png" ),
		can_see = function()
			return SCPTeams.CanEscort( LocalPlayer():SCPTeam(), true )
		end,
		callback = cmd_func,
		args = "slc_escort"
	},
	{
		name = "gatea",
		material = GetMaterial( "slc/hud/explosion.png" ),
		can_see = function()
			local class_data = GetClassData( LocalPlayer():SCPClass() )
			return class_data and class_data.support
		end,
		callback = cmd_func,
		args = "slc_destroy_gatea"
	},
}

local function drawVest( x, y, size )
	surface.SetDrawColor( 150, 150, 150, 50 )
	surface.DrawOutlinedRect( x - 2, y - 2, size + 4, size + 4, 2 )

	surface.SetDrawColor( 0, 0, 0, 125 )
	surface.DrawRect( x, y, size, size )

	local ply = LocalPlayer()
	local vest = ply:GetVest()

	if vest > 0 then
		local data = VEST.GetData( vest )

		//render.PushFilterMag( TEXFILTER.LINEAR )
		//render.PushFilterMin( TEXFILTER.LINEAR )
		PushFilters( TEXFILTER.LINEAR )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( MATS.vest )
		surface.DrawTexturedRect( x + size * 0.1, y + size * 0.1, size * 0.8, size * 0.8 )

		//render.PopFilterMag()
		//render.PopFilterMin()
		PopFilters()

		local btn = Button( x, y, size, size )
		if btn == 1 then
			surface.SetDrawColor( 50, 50, 50, 50 )
			surface.DrawRect( x, y, size, size )
		elseif btn == 2 or btn == 3 then
			net.Start( "DropVest" )
			net.SendToServer()
		end

		local dur = ply:GetVestDurability()
		if data and data.durability >= 0 and dur >= 0 then
			local pct = math.Clamp( dur / data.durability, 0, 1 )
	
	
			local dy = y + size - 4
			local dw = math.floor( size * pct )
	
			surface.SetDrawColor( 75, 30, 200 )
			surface.DrawRect( x, dy, dw, 4 )
	
			surface.SetDrawColor( 200, 30, 75 )
			surface.DrawRect( x + dw, dy, size - dw, 4 )
		end

		if data and btn > 0 then
			local info = StringBuilder()

			if data and data.durability >= 0 and dur >= 0 then
				info:print( "\t", LANG.durability, ":   ", math.ceil( dur / data.durability * 100 ), "%" )
			end

			info:print( "\t", LANG.mobility, ":   ", math.floor( data.mobility * 100 ), "%" )
			info:print( "\t", LANG.weight, ":   ", data.weight, " ", LANG.weight_unit )
			info:print( "\t", LANG.vest_multiplier, ":" )

			for k, v in pairs( data.damage ) do
				if !data.HIDE[k] then
					local name = VEST.TranslateDamage( k )
					info:print( "\t\t", LANG.DMG[name] or name, ":   ", math.ceil( v * 100 ), "%" )
				end
			end

			info:trim( true )

			SHOW_WEP_INFO = {
				PrintName = LANG.VEST[data.name] or data.name,
				Info = tostring( info )
			}
		end
	end
end

local backpack_bounds = {}

local function translateBackpack( mx, my )
	for i = 1, LocalPlayer():GetBackpack() do
		local data = backpack_bounds[i]
		if !data then continue end

		if mx >= data.x and mx <= data.x + data.size and my >= data.y and my <= data.y + data.size then
			return EQ.slots + i
		end
	end
end

local select_color = Color( 255, 210, 0, 255 )
local def_wep = surface.GetTextureID( "weapons/swep" )
local hovered_slot = 0
local drag = 0
local swap = 0
local function drawItem( i, wx, wy, size, offset, override )
	//local w, h = ScrW(), ScrH()

	local eqsize = EQ.slots
	local mx, my = input.GetCursorPos()

	local grid_x = ( i - 1 ) % EQ.cols + 1
	local grid_y = math.floor( ( i - 1 ) / EQ.cols ) + 1
	local ct = CurTime()

	size = math.floor( size )
	local cx = override and override.dx or math.floor( wx + grid_x * offset + ( grid_x - 1 ) * size )
	local cy = override and override.dy or math.floor( wy + grid_y * offset + ( grid_y - 1 ) * size )

	if override or i <= eqsize then
		surface.SetDrawColor( 150, 150, 150, 50 )
		surface.DrawOutlinedRect( cx - 2, cy - 2, size + 4, size + 4, 2 )

		surface.SetDrawColor( 0, 0, 0, 125 )
		surface.DrawRect( cx, cy, size, size )
	end

	local wep = WEAPONS[i]
	if !IsValid( wep ) then
		if drag == i then
			drag = 0
		end

		return
	end

	if drag == i then
		cx = mx - size * 0.5
		cy = my - size * 0.5

		if override then return end
	end

	local btn = 0

	if ( drag == 0 or drag == i ) and swap < ct then
		btn = Button( cx, cy, size, size, i )
	end

	if btn == 1 then
		hovered_slot = i

		surface.SetDrawColor( 50, 50, 50, 50 )
		surface.DrawRect( cx, cy, size, size )

		if drag > 0 then
			local was_bp = drag > EQ.slots
			drag = 0

			local eq_pos = translateBackpack( mx, my )
			if eq_pos then
				was_bp = true
			else
				for y = 1, EQ.rows do
					for x = 1, EQ.cols do
						local itemx = wx + x * offset + ( x - 1 ) * size
						local itemy = wy + y * offset + ( y - 1 ) * size

						if mx >= itemx and mx <= itemx + size and my >= itemy and my <= itemy + size then
							eq_pos = ( y - 1 ) * EQ.cols + x
							break
						end
					end
				end
			end

			if eq_pos and eq_pos != i then
				local drop_wep = WEAPONS[eq_pos]
				local act = LocalPlayer():GetActiveWeapon()
				local wep_class = wep:GetClass()
				local drop_class = drop_wep and drop_wep:GetClass()
				if !was_bp or !( wep.GetEnabled and wep:GetEnabled() or drop_wep and drop_wep.GetEnabled and drop_wep:GetEnabled()
									or wep == act or drop_wep and drop_wep == act or wep_class == "item_slc_holster" or wep_class == "item_slc_id"
									or drop_class and ( drop_class == "item_slc_holster" or drop_class == "item_slc_id" ) ) then
					if was_bp then
						TimeBasedProgressBar( ct, ct + EQ_SWAP_TIME, LANG.eq_swapping )
						swap = ct + EQ_SWAP_TIME
					end

					if drop_wep then
						if drop_wep.DragAndDrop and drop_wep:DragAndDrop( wep ) != false then
							net.Start( "WeaponDnD" )
								net.WriteEntity( wep )
								net.WriteEntity( drop_wep )
							net.SendToServer()
						else
							local tmp = WEAPONS[i]
							WEAPONS[i] = WEAPONS[eq_pos]
							WEAPONS[eq_pos] = tmp
						end
					else
						WEAPONS[eq_pos] = WEAPONS[i]
						WEAPONS[i] = nil
					end
				end
			end
		end
	elseif btn == 2 and !override then
		input.SelectWeapon( wep )
	elseif btn == 3 and !override then
		if wep.Droppable != false and wep.PreventDropping != true then
			net.Start( "DropWeapon" )
				net.WriteString( wep:GetClass() )
			net.SendToServer()

			if !wep.Stacks or wep.Stacks <= 1 or wep:GetCount() <= 1 then
				if wep.RemoveStack then wep:RemoveStack() end
				WEAPONS[i] = nil
			end
		end
	elseif btn == 4 then
		drag = i
	end

	if btn > 0 and drag == 0 then
		SHOW_WEP_INFO = wep
	end

	local c_wep = TEXTURES[wep:GetClass()] or wep

	local s = c_wep.SelectIcon or c_wep.WepSelectIcon
	if s and s != def_wep then
		draw.WepSelectIcon( s, cx, cy, size, c_wep.SelectColor )
	elseif c_wep.SelectFont then
		local font = EQ_OVERRIDE_FONTS[c_wep.SelectFont] or c_wep.SelectFont
		local fy = cy + size * 0.5

		if font == "SCPCSSIcons" then
			fy = fy + size * 0.25
		end

		draw.Text{
			text = c_wep.IconLetter or c_wep.ShowName or c_wep.PrintName,
			pos = { cx + size * 0.5, fy },
			font = font,
			color = c_wep.SelectColor or select_color,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	else
		draw.WepSelectIcon( def_wep, cx, cy, size, c_wep.SelectColor )
	end

	if !override and i != drag and wep.eq_bind then
		surface.SetDrawColor( 75, 75, 75 )
		draw.NoTexture()

		surface.DrawPoly( {
			{ x = cx, y = cy },
			{ x = cx + size * 0.25, y = cy },
			{ x = cx, y = cy + size * 0.25 },
		} )

		draw.Text{
			text = wep.eq_bind - 1,
			pos = { cx + size * 0.015, cy - size * 0.02 },
			font = "SCPHUDVSmall",
			color = c_wep.SelectColor or select_color,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	if wep.Stacks and wep.Stacks > 1 then
		draw.Text{
			text = wep:GetCount(),
			pos = { cx + size * 0.95, cy + size * 0.975 },
			font = "SCPHUDMedium",
			color = select_color,
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		}
	end

	if override then return end

	if drag != i and wep.Toggleable and wep:GetEnabled() then
		PushFilters( TEXFILTER.LINEAR )
			surface.SetMaterial( MATS.gear )
			surface.SetDrawColor( 155, 155, 155, 155 )
			surface.DrawTexturedRect( cx + size * 0.75 - 2, cy + 2, size * 0.25, size * 0.25 )
		PopFilters()
	end

	if drag != i and wep.HasBattery then
		local pct = wep:GetBattery() * 0.01

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( cx + size * 0.85 + 2 - 2, cy + size * 0.7 + 2 - 2, size * 0.15 - 4, size * 0.3 - 4 )

		surface.SetDrawColor( 255 * ( 1 - pct ), 255 * pct, 0 )
		surface.DrawRect( cx + size * 0.85 + 4 - 2, cy + size * 0.7 + 4 - 2 + ( size * 0.3 - 8 ) * ( 1 - pct ), size * 0.15 - 8, ( size * 0.3 - 8 ) * pct )
	end

	if drag != i and wep.Durability and wep.Durability > 0 then
		local pct = math.Clamp( wep:GetDurability() / wep.Durability, 0, 1 )


		local dy = cy + size - 4
		local dw = math.floor( size * pct )

		surface.SetDrawColor( 75, 30, 200 )
		surface.DrawRect( cx, dy, dw, 4 )

		surface.SetDrawColor( 200, 30, 75 )
		surface.DrawRect( cx + dw, dy, size - dw, 4 )
	end

	if drag != i and LocalPlayer():GetActiveWeapon() == wep then
		surface.SetDrawColor( 255, 210, 0, 255)
		surface.DrawOutlinedRect( cx - 2, cy - 2, size + 4, size + 4, 1 )
		//surface.DrawOutlinedRect( cx + 1, cy + 1, size - 2, size - 2 )
	end
end

local color_white = Color( 255, 255, 255 )
local function drawSideButton( x, y, w, h, offset, tab )
	/*x = math.Round( x )
	y = math.Round( y )
	w = math.Round( w )
	h = math.Round( h )*/

	local btn = Button( x, y, w, h )

	if btn == 1 then
		surface.SetDrawColor( 75, 75, 75, 75 )
		surface.DrawRect( x, y, w, h )
	elseif btn == 2 or btn == 3 then
		local cb = tab.callback
		if isfunction( cb ) then
			cb( tab, tab.args )
		end
	end

	local dim = h * 0.8
	local dx, dy = x + h * 0.1 , y + h * 0.1

	if tab.material then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( tab.material )
		surface.DrawTexturedRect( dx, dy, dim, dim )
	end

	local ct = CurTime()
	if tab.cooldown and tab.cd_time and tab.cooldown > ct and tab.cd_time > 0 then
		draw.NoTexture()
		surface.SetDrawColor( 0, 0, 0, 235 )
		surface.DrawCooldownRectCW( dx, dy, dim - 1, dim - 1, ( tab.cooldown - ct ) / tab.cd_time )
	end

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawOutlinedRect( dx, dy, dim, dim, 2 )

	x = x + h
	w = w - h

	draw.LimitedText{
		text = LANG.eq_buttons[tab.name] or tab.name,
		pos = { x + w * 0.5, y + h * 0.5 },
		font = "SCPHUDMedium",
		color = color_white,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		max_width = w,
	}
end

local perrow = 8
local function drawBackpack( x, y, size, offset, txtoff )
	local w, h = ScrW(), ScrH()
	size = size * 0.75
	offset = offset * 0.75

	local ply = LocalPlayer()
	local bpsize = ply:GetBackpack()
	if bpsize == 0 then return end

	local rows = math.ceil( bpsize / perrow )

	local dw = ( size + offset ) * math.min( bpsize, perrow ) + offset
	local dh = ( size + offset ) * rows + txtoff

	local dx = ( w - dw ) * 0.5
	local dy = y - dh - offset

	surface.SetDrawColor( 150 * alpha, 150 * alpha, 150 * alpha, 100 )
	surface.DrawRect( dx - 2, dy - 2, dw + 4, dh + 4 )

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	surface.DrawRect( dx, dy, dw, dh )

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.SetMaterial( blur )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, w, h )

	render.SetStencilEnable( false )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( dx, dy, dw, dh )

	draw.Text{
		text = LANG.eq_backpack,
		pos = { dx + dw * 0.5, dy + dh - txtoff * 0.5 },
		font = nav_font,
		color = color_white,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	for i = 0, bpsize - 1 do
		local row = math.floor( i / perrow ) + 1
		local col = ( i % perrow )
		local rowlen = row < rows and perrow or bpsize - perrow * ( rows - 1 )
		local rowx = dx + ( dw - ( ( size + offset ) * rowlen + offset ) ) * 0.5

		local sx = rowx + offset + ( size + offset ) * col
		local sy = dy + dh - txtoff - ( size + offset ) * row + offset

		/*surface.SetDrawColor( 150, 150, 150, 50 )
		surface.DrawOutlinedRect( sx - 2, sy - 2, size + 4, size + 4, 2 )

		surface.SetDrawColor( 0, 0, 0, 125 )
		surface.DrawRect( sx, sy, size, size )*/
		drawItem( EQ.slots + 1 + i, 0, 0, size, offset, {
			dx = sx,
			dy = sy,
		} )

		backpack_bounds[i + 1] = {
			x = sx,
			y = sy,
			size = size,
		}
	end
end

local function DrawEQ()
	next_frame = true
	SHOW_WEP_INFO = nil

	if !draw_eq then return end

	if close_eq then
		if alpha == 0 or fast_close then
			alpha = 0
			draw_eq = false
			close_eq = false
			return
		else
			alpha = math.max( alpha - 4 * RealFrameTime(), 0 )
		end
	else
		if alpha < 1 then
			alpha = fast_open and 1 or math.min( alpha + 4 * RealFrameTime(), 1 )
		end
	end

	//if !IsValid(  )

	surface.SetAlphaMultiplier( alpha )

	local w, h = ScrW(), ScrH()

	render.UpdateScreenEffectTexture()

	blur:SetFloat( "$blur", 4 )

	if !recomputed then
		recomputed = true
		blur:Recompute()
	end

	local size = EQ.size * w
	local offset = EQ.offset * w
	local txtoff = h * 0.03

	local width = ( size + offset ) * EQ.cols + offset
	local height = ( size + offset ) * EQ.rows + txtoff

	local wx, wy = w * 0.5 - width * 0.5, h * 0.5 - height * 0.5

	local vest_width = size + 2 * offset
	local vest_height = size + offset + txtoff --vest_width + h * 0.04 - offset
	local vest_x = wx - vest_width - w * 0.01

	local b_x = wx + width + w * 0.01
	local b_y = wy
	local b_w = w * 0.2
	local b_h = size * 0.5//h * 0.075

	surface.SetDrawColor( 150 * alpha, 150 * alpha, 150 * alpha, 100 )
	surface.DrawRect( vest_x - 2, wy - 2, vest_width + 4, vest_height + 4 )
	surface.DrawRect( wx - 2, wy - 2, width + 4, height + 4 )

	local cache = {}
	for i, v in ipairs( ACTIONS ) do
		local r = v.can_see == true or isfunction( v.can_see ) and v.can_see()
		cache[i] = r

		if r then
			surface.DrawRect( b_x - 2, b_y - 2, b_w + 4, b_h + 4 )
			b_y = b_y + b_h + offset
		end
	end

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	surface.DrawRect( vest_x, wy, vest_width, vest_height )
	surface.DrawRect( wx, wy, width, height )

	b_y = wy
	for i, v in ipairs( ACTIONS ) do
		if cache[i] then
			surface.DrawRect( b_x, b_y, b_w, b_h )
			b_y = b_y + b_h + offset
		end
	end

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.SetMaterial( blur )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, w, h )

	render.SetStencilEnable( false )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( vest_x, wy, vest_width, vest_height )
	surface.DrawRect( wx, wy, width, height )

	b_y = wy
	for i, v in ipairs( ACTIONS ) do
		if cache[i] then
			surface.DrawRect( b_x, b_y, b_w, b_h )
			b_y = b_y + b_h + offset
		end
	end

	drawVest( vest_x + offset, wy + offset, size )

	draw.Text{
		text = LANG.eq_vest,
		pos = { vest_x + vest_width * 0.5, wy + vest_height - txtoff * 0.5 },
		font = "SCPHUDSmall",
		color = color_white,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	b_y = wy
	for i, v in ipairs( ACTIONS ) do
		if cache[i] then
			drawSideButton( b_x, b_y, b_w, b_h, offset, v )
			b_y = b_y + b_h + offset
		end
	end

	//local keyfont = 

	draw.Text{
		text = LANG.eq_lmb,
		pos = { wx + w * 0.01, wy + height - txtoff * 0.5 },
		font = nav_font,
		color = color_white,
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = LANG.eq_hold,
		pos = { w * 0.5, wy + height - txtoff * 0.5 },
		font = nav_font,
		color = color_white,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = LANG.eq_rmb,
		pos = { wx + width - w * 0.01, wy + height - txtoff * 0.5 },
		font = nav_font,
		color = color_white,
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_CENTER,
	}

	hovered_slot = 0

	for i = 1, EQ.slots do
		if i != drag then
			drawItem( i, wx, wy, size, offset )
		end
	end

	drawBackpack( wx, wy, size, offset, txtoff )

	if drag > 0 then
		drawItem( drag, wx, wy, size, offset )
	end

	if SHOW_WEP_INFO and !close_eq then
		local mx, my = input.GetCursorPos()

		local color = Color( 0, 0, 0, 240 )
		//local author = SHOW_WEP_INFO.Author
		local info = SHOW_WEP_INFO.Info

		local wep_name

		if SHOW_WEP_INFO.GetClass then
			local tab = LANG.WEAPONS[SHOW_WEP_INFO:GetClass()]
			wep_name = istable( tab ) and tab.name or isstring( tab ) and tab
		end

		if !wep_name then
			wep_name = SHOW_WEP_INFO.PrintName or SHOW_WEP_INFO.GetPrintName and SHOW_WEP_INFO:GetPrintName() or LANG.eq_unknown
		end

		if SHOW_WEP_INFO.Stacks and SHOW_WEP_INFO.Stacks > 1 then
			wep_name = wep_name.." ("..SHOW_WEP_INFO:GetCount()..")"
		end

		local info_width = w * 0.4

		surface.SetFont( "SCPHUDMedium" )
		if !info or info == "" then
			info_width = surface.GetTextSize( wep_name ) + w * 0.02

			/*if author and author != "" then
				local tmp = surface.GetTextSize( LANG.author..": "..author ) + w * 0.02

				if tmp > info_width then
					info_width = tmp
				end
			end*/

			if info_width > w * 0.4 then
				info_width = w * 0.4
			end
		end

		if mx + info_width > w then
			mx = w - info_width
		end

		render.SetStencilTestMask( 0xFF )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilPassOperation( STENCIL_REPLACE )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilReferenceValue( 1 )

		render.ClearStencil()
		render.SetStencilEnable( true )


		surface.SetDrawColor( color )
		surface.DrawRect( mx, my, info_width, h * 0.05 )
		local cur_y = my + h * 0.05

		draw.LimitedText{
			text = wep_name,
			pos = { mx + w * 0.01, my + h * 0.025 },
			font = "SCPHUDMedium",
			color = color_white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.38
		}

		/*if author and author != "" then
			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, info_width, h * 0.05 )
			cur_y = cur_y + h * 0.05

			draw.Text{
				text = LANG.author..": "..author,
				pos = { mx + w * 0.01, cur_y - h * 0.025 },
				font = "SCPHUDMedium",
				color = color_white,
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}
		end*/

		if info and info != "" then
			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, info_width, h * 0.05 )
			cur_y = cur_y + h * 0.05

			draw.Text{
				text = LANG.info..":",
				pos = { mx + w * 0.01, cur_y - h * 0.02 },
				font = "SCPHUDMedium",
				color = color_white,
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

			local text_height = draw.MultilineText( mx + w * 0.015, cur_y, info, "SCPHUDMedium", nil, w * 0.375, 0, 0, TEXT_ALIGN_LEFT, nil, true )

			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, info_width, text_height )

			draw.MultilineText( mx + w * 0.015, cur_y, info, "SCPHUDMedium", color_white, w * 0.375, 0, 0, TEXT_ALIGN_LEFT )

			cur_y = cur_y + text_height
		end

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		render.SetStencilPassOperation( STENCIL_KEEP )

		surface.SetDrawColor( 150, 150, 150, 150 )
		surface.DrawRect( mx - 2, my - 2, info_width + 4, cur_y - my + 4 )

		render.SetStencilEnable( false )
	end

	surface.SetAlphaMultiplier( 1 )
end

hook.Add( "DrawOverlay", "SCPEQ", DrawEQ )

hook.Add( "PlayerButtonDown", "SLCEQBinds", function( ply, code )
	if !IsFirstTimePredicted() or hook.Run( "SLCCanUseBind", "eq_loadout" ) == false then return end

	local hovering = draw_eq and !close_eq and drag == 0 and hovered_slot <= EQ.slots and hovered_slot != 0 and WEAPONS[hovered_slot]
	if code == KEY_BACKSPACE and hovering then
		WEAPONS[hovered_slot].eq_bind = nil
	elseif code >= KEY_0 and code <= KEY_9 and hovering then
		for k, v in pairs( WEAPONS ) do
			if v.eq_bind == code then
				v.eq_bind = nil
			end
		end

		WEAPONS[hovered_slot].eq_bind = code
	elseif code >= KEY_0 and code <= KEY_9 and !draw_eq then
		for k, v in pairs( WEAPONS ) do
			if k <= EQ.slots and v.eq_bind == code then
				input.SelectWeapon( v )
				break
			end
		end
	end
end )

function UpdatePlayerEQ()
	local ply = LocalPlayer()
	local player_weapons = ply:GetWeapons()

	local pwep_lookup = CreateLookupTable( player_weapons )
	local cwep_lookup = CreateLookupTable( WEAPONS )

	--remove missing items
	for k, v in pairs( WEAPONS ) do
		if !IsValid( v ) or !pwep_lookup[v] then
			//print( "REMOVING ITEM", v, k )
			WEAPONS[k] = nil
		end
	end

	--add new items
	for i = 1, #player_weapons do
		local wep = player_weapons[i] --iterate over all items in inventory
		//print( "check", wep, i )

		if IsValid( wep ) and !cwep_lookup[wep] then --if weapon is valid and is not present in local inventory
			local first_empty = 0

			for j = 1, EQ.slots + ply:GetBackpack() do
				if !WEAPONS[j] then
					first_empty = j --get first empty slot
					break
				end
			end

			if first_empty > 0 then
				WEAPONS[first_empty] = wep --insert item
				wep.eq_bind = nil
				//print( "ADDING ITEM", wep, first_empty )
			else
				print( "Player has too much items!", #player_weapons.."/"..EQ.slots ) --this should never run
				break
			end
		end
	end
end

local lcx = 0
local lcy = 0
function ShowEQ()
	UpdatePlayerEQ()

	local inv = IsAnyInventoryVisible()
	close_eq = false
	draw_eq = true
	fast_open = inv

	if !inv and lcx > 0 and lcy > 0 then
		input.SetCursorPos( lcx, lcy )
	end

	gui.EnableScreenClicker( true )

	if bit.band( LANG_FLAGS, LANGUAGE.EQ_LONG_TEXT ) == LANGUAGE.EQ_LONG_TEXT then
		nav_font = "SCPHUDVSmall"
	else
		nav_font = "SCPHUDSmall"
	end
end

function HideEQ()
	local inv = IsAnyInventoryVisible()

	if draw_eq then
		drag = 0
		close_eq = true
		fast_close = inv

		if !inv then
			lcx, lcy = input.GetCursorPos()
		end
	end

	gui.EnableScreenClicker( inv )
end

function CanShowEQ()
	if ScoreboardVisible then return end

	local team = LocalPlayer():SCPTeam()
	return team != TEAM_SPEC
end

function IsEQVisible()
	return draw_eq
end

function GetLocalWeapons()
	return WEAPONS
end