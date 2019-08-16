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
		if input.IsMouseDown( MOUSE_LEFT ) then
			if button_hold == 0 then
				button_hold = CurTime() + 0.2
				holdid = id
				return 1 --HOVER
			elseif button_hold <= CurTime() then
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
			if button_hold != 0 and button_hold > CurTime() then
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

local TEXTURES = {
	weapon_stunstick = { SelectFont = "SCPHLIcons", IconLetter = "n" },
	weapon_crowbar = { SelectFont = "SCPHLIcons", IconLetter = "c" }
}

local OVERRIDE_FONTS = {
	CW_SelectIcons = "SCPCSSIcons",
}

local SHOW_WEP_INFO = nil

local WEAPONS = {}
local EQ = {
	cols = 4,
	rows = 2,
	size = 0.085,
	offset = 0.0075
}

EQ.slots = EQ.cols * EQ.rows

local mat_vest = Material( "slc_hud/vest.png" )
local function drawVest( x, y, size )
	surface.SetDrawColor( 150, 150, 150, 50 )

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	surface.DrawRect( x, y, size, size )

	render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.DrawRect( x - 2, y - 2, size + 4, size + 4 )

	render.SetStencilEnable( false )

	surface.SetDrawColor( Color( 0, 0, 0, 125 ) )
	surface.DrawRect( x, y, size, size )

	local vest = LocalPlayer():GetVest()

	if vest > 0 then
		render.PushFilterMag( TEXFILTER.LINEAR )
		render.PushFilterMin( TEXFILTER.LINEAR )

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( mat_vest )
		surface.DrawTexturedRect( x + size * 0.1, y + size * 0.1, size * 0.8, size * 0.8 )

		render.PopFilterMag()
		render.PopFilterMin()

		local btn = Button( x, y, size, size )
		if btn == 1 then
			surface.SetDrawColor( Color( 50, 50, 50, 75 ) )
			surface.DrawRect( x, y, size, size )
		elseif btn == 2 or btn == 3 then
			net.Start( "DropVest" )
			net.SendToServer()
		end

		if btn > 0 then
			local data = VEST.getData( vest )
			if data then
				local info = StringBuilder()

				info:print( "\t", LANG.mobility, ":   ", math.floor( data.mobility * 100 ), "%" )
				info:print( "\t", LANG.weight, ":   ", data.weight, " ", LANG.weight_unit )
				info:print( "\t", LANG.protection, ":" )

				for k, v in pairs( data.damage ) do
					if !data.HIDE[k] then
						local name = VEST.translateDamage( k )
						info:print( "\t\t", LANG.DMG[name] or name, ":   ", 100 - math.ceil( v * 100 ), "%" )
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
end

local function drawWepSelectIcon( ico, cx, cy, size, color )
	local ico_w, ico_h 

	if isnumber( ico ) then
		ico_w, ico_h = surface.GetTextureSize( ico )
		surface.SetTexture( ico )
	else
		ico_w = ico:Width()
		ico_h = ico:Height()
		surface.SetMaterial( ico )
	end

	if ico_w > ico_h then
		ico_h = size * ico_h / ico_w
		ico_w = size
	elseif ico_h > ico_w then
		ico_w = size * ico_w / ico_h
		ico_h = size
	end

	render.PushFilterMag( TEXFILTER.LINEAR )
	render.PushFilterMin( TEXFILTER.LINEAR )

	surface.SetDrawColor( color or Color( 255, 255, 255, 255 ) )
	surface.DrawTexturedRect( cx + size * 0.5 - ico_w * 0.5, cy + size * 0.5 - ico_h * 0.5, ico_w, ico_h )

	render.PopFilterMag()
	render.PopFilterMin()
end

local def_wep = surface.GetTextureID( "weapons/swep" )
local drag = 0
local function drawItem( i, wx, wy, size, offset )
	local w, h = ScrW(), ScrH()

	local mx, my = input.GetCursorPos()

	local x = ( i - 1 ) % EQ.cols + 1
	local y = math.floor( ( i - 1 ) / EQ.cols ) + 1

	local cx = wx + x * offset + ( x - 1 ) * size
	local cy = wy + y * offset + ( y - 1 ) * size
	
	surface.SetDrawColor( 150, 150, 150, 50 )

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	surface.DrawRect( cx, cy, size, size )

	render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.DrawRect( cx - 2, cy - 2, size + 4, size + 4 )

	render.SetStencilEnable( false )

	surface.SetDrawColor( Color( 0, 0, 0, 125 ) )
	surface.DrawRect( cx, cy, size, size )

	local wep = WEAPONS[i]
	if !IsValid( wep ) then return end

	if drag == i then
		cx = mx - size * 0.5
		cy = my - size * 0.5
	end

	local btn = 0

	if drag == 0 or drag == i then
		btn = Button( cx, cy, size, size, i )
	end

	if btn == 1 then
		surface.SetDrawColor( Color( 50, 50, 50, 75 ) )
		surface.DrawRect( cx, cy, size, size )

		if drag > 0 then
			drag = 0

			for y = 1, EQ.rows do
				for x = 1, EQ.cols do
					local itemx = wx + x * offset + ( x - 1 ) * size
					local itemy = wy + y * offset + ( y - 1 ) * size

					if mx >= itemx and mx <= itemx + size and my >= itemy and my <= itemy + size then
						local eq_pos = ( y - 1 ) * EQ.cols + x
						if eq_pos != i then
							local drop_wep = WEAPONS[eq_pos]

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

						break
					end
				end
			end
		end
	elseif btn == 2 then
		input.SelectWeapon( wep )
	elseif btn == 3 then
		if wep.Droppable != false then
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

	if c_wep.WepSelectIcon and c_wep.WepSelectIcon != def_wep then
		drawWepSelectIcon( c_wep.WepSelectIcon, cx, cy, size, c_wep.SelectColor )
	elseif c_wep.SelectFont then
		local font = OVERRIDE_FONTS[c_wep.SelectFont] or c_wep.SelectFont
		local fy = cy + size * 0.5

		if font == "SCPCSSIcons" then
			fy = fy + size * 0.25
		end

		local w, h = draw.Text{
			text = c_wep.IconLetter or c_wep.ShowName or c_wep.PrintName,
			pos = { cx + size * 0.5, fy },
			font = font,
			color = c_wep.SelectColor or Color( 255, 210, 0, 200 ),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	else
		drawWepSelectIcon( def_wep, cx, cy, size, c_wep.SelectColor )
	end

	if wep.Stacks and wep.Stacks > 1 then
		draw.Text{
			text = wep:GetCount(),
			pos = { cx + size * 0.95, cy + size * 0.975 },
			font = "SCPHUDMedium",
			color = c_wep.SelectColor or Color( 255, 210, 0, 200 ),
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		}
	end

	if drag == 0 and LocalPlayer():GetActiveWeapon() == wep then
		surface.SetDrawColor( Color( 0, 0, 175, 255 ) )
		surface.DrawOutlinedRect( cx + 1, cy + 1, size - 2, size - 2 )
		surface.DrawOutlinedRect( cx + 2, cy + 2, size - 4, size - 4 )
	end
end

local blur = Material( "pp/blurscreen" )
local recomputed = false

local draw_eq = false
local close_eq = false
local alpha = 1
local function DrawEQ()
	next_frame = true
	SHOW_WEP_INFO = nil

	if !draw_eq then return end

	if close_eq then
		if alpha == 0 then
			draw_eq = false
			close_eq = false
			return
		else
			alpha = math.max( alpha - 2 * RealFrameTime(), 0 )
		end
	else
		if alpha < 1 then
			alpha = math.min( alpha + 3 * RealFrameTime(), 1 )
		end
	end

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

	local width = ( size + offset ) * EQ.cols + offset
	local height = ( size + offset ) * EQ.rows + h * 0.04

	local wx, wy = w * 0.5 - width * 0.5, h * 0.5 - height * 0.5

	local vest_width = size + 2 * offset
	local vest_height = vest_width + h * 0.04 - offset
	local vest_x = wx - vest_width - w * 0.01

	surface.SetDrawColor( Color( 150 * alpha, 150 * alpha, 150 * alpha, 100 ) )
	surface.DrawRect( vest_x - 2, wy - 2, vest_width + 4, vest_height + 4 )
	surface.DrawRect( wx - 2, wy - 2, width + 4, height + 4 )

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

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.SetMaterial( blur )
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.DrawTexturedRect( 0, 0, w, h )

	render.SetStencilEnable( false )

	surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
	surface.DrawRect( vest_x, wy, vest_width, vest_height )
	surface.DrawRect( wx, wy, width, height )

	for i = 1, EQ.slots do
		if i != drag then
			drawItem( i, wx, wy, size, offset )
		end
	end

	if drag > 0 then
		drawItem( drag, wx, wy, size, offset )
	end

	draw.Text{
		text = LANG.eq_lmb,
		pos = { wx + w * 0.01, wy + height - 0.02 * h },
		font = "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = LANG.eq_hold,
		pos = { w * 0.5, wy + height - 0.02 * h },
		font = "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = LANG.eq_rmb,
		pos = { wx + width - w * 0.01, wy + height - 0.02 * h },
		font = "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_CENTER,
	}

	drawVest( vest_x + offset, wy + offset, size )

	draw.Text{
		text = LANG.eq_vest,
		pos = { vest_x + vest_width * 0.5, wy + vest_height - 0.02 * h },
		font = "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	if SHOW_WEP_INFO then
		local mx, my = input.GetCursorPos()

		local color = Color( 0, 0, 0, 240 )
		local wep_name = "Unknown Weapon"
		local author = SHOW_WEP_INFO.Author
		local info = SHOW_WEP_INFO.Info

		if SHOW_WEP_INFO.PrintName then
			wep_name = SHOW_WEP_INFO.PrintName
		elseif SHOW_WEP_INFO.GetPrintName then
			wep_name = SHOW_WEP_INFO:GetPrintName()
		end

		if SHOW_WEP_INFO.Stacks and SHOW_WEP_INFO.Stacks > 1 then
			wep_name = wep_name.." ("..SHOW_WEP_INFO:GetCount()..")"
		end

		local width = w * 0.4

		surface.SetFont( "SCPHUDMedium" )
		if !info or info == "" then
			width = surface.GetTextSize( wep_name ) + w * 0.02

			if author and author != "" then
				local tmp = surface.GetTextSize( LANG.author..": "..author ) + w * 0.02

				if tmp > width then
					width = tmp
				end
			end

			if width > w * 0.4 then
				width = w * 0.4
			end
		end

		if mx + width > w then
			mx = w - width
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
		surface.DrawRect( mx, my, width, h * 0.05 )
		local cur_y = my + h * 0.05

		draw.LimitedText{
			text = wep_name,
			pos = { mx + w * 0.01, my + h * 0.025 },
			font = "SCPHUDMedium",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.38
		}

		if author and author != "" then
			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, width, h * 0.05 )
			cur_y = cur_y + h * 0.05

			draw.Text{
				text = LANG.author..": "..author,
				pos = { mx + w * 0.01, cur_y - h * 0.025 },
				font = "SCPHUDMedium",
				color = Color( 255, 255, 255, 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		if info and info != "" then
			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, width, h * 0.04 )
			cur_y = cur_y + h * 0.04

			draw.Text{
				text = LANG.info..":",
				pos = { mx + w * 0.01, cur_y - h * 0.02 },
				font = "SCPHUDMedium",
				color = Color( 255, 255, 255, 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

			local height = draw.MultilineText( mx + w * 0.01, cur_y, info, "SCPHUDMedium", nil, w * 0.38, 0, 0, TEXT_ALIGN_LEFT, nil, true )

			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, width, height )

			draw.MultilineText( mx + w * 0.01, cur_y, info, "SCPHUDMedium", Color( 255, 255, 255, 255 ), w * 0.38, 0, 0, TEXT_ALIGN_LEFT )

			cur_y = cur_y + height
		end

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		render.SetStencilPassOperation( STENCIL_KEEP )

		surface.SetDrawColor( Color( 150, 150, 150, 50 ) )
		surface.DrawRect( mx - 2, my - 2, width + 4, cur_y - my + 4 )

		render.SetStencilEnable( false )
	end

	surface.SetAlphaMultiplier( 1 )
end

hook.Add( "DrawOverlay", "SCPEQ", DrawEQ )

function UpdatePlayerEQ()
	local size = EQ.slots
	local weps = LocalPlayer():GetWeapons()

	for i = 1, size do
		local remove = true

		for j = 1, size do
			if WEAPONS[i] == weps[j] then
				remove = false
				break
			end
		end

		if remove then
			WEAPONS[i] = nil
		end
	end

	for i = 1, size do
		local first_empty = 0
		local add = true

		for j = 1, size do
			local wep = WEAPONS[j]

			if !wep and first_empty == 0 then
				first_empty = j
			end

			if wep == weps[i] then
				add = false
				break
			end
		end

		if add and first_empty != 0 then
			WEAPONS[first_empty] = weps[i]
		end
	end
end

local lcx = 0
local lcy = 0
function ShowEQ()
	HUDDrawInfo = true

	UpdatePlayerEQ()
	close_eq = false
	draw_eq = true

	if lcx > 0 and lcy > 0 then
		input.SetCursorPos( lcx, lcy )
	end

	gui.EnableScreenClicker( true )
end

function HideEQ()
	HUDDrawInfo = false

	if draw_eq then
		close_eq = true
		lcx, lcy = input.GetCursorPos()
	end

	gui.EnableScreenClicker( false )
end

function CanShowEQ()
	if ScoreboardVisible then return end

	local team = LocalPlayer():SCPTeam()
	return team != TEAM_SPEC
end

function IsEQVisible()
	return draw_eq
end