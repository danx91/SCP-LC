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

local nav_font_override

/*local show = function()
	local t = LocalPlayer():SCPTeam()
	return t == TEAM_MTF or t == TEAM_CI
end*/

local cmd_func = function( cmd )
	LocalPlayer():ConCommand( cmd )
end

local ACTIONS = {
	{ "escort", GetMaterial( "null" ), function()
		return SCPTeams.CanEscort( LocalPlayer():SCPTeam(), true )
	end, cmd_func, "slc_escort" },

	{ "gatea", GetMaterial( "null" ), function()
		local class_data = GetClassData( LocalPlayer():SCPClass() )
		return class_data and class_data.support
	end, cmd_func, "slc_destroy_gatea" },
}

EQ.slots = EQ.cols * EQ.rows

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

	surface.SetDrawColor( 0, 0, 0, 125 )
	surface.DrawRect( x, y, size, size )

	local vest = LocalPlayer():GetVest()

	if vest > 0 then
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

		if btn > 0 then
			local data = VEST.GetData( vest )
			if data then
				local info = StringBuilder()

				info:print( "\t", LANG.mobility, ":   ", math.floor( data.mobility * 100 ), "%" )
				info:print( "\t", LANG.weight, ":   ", data.weight, " ", LANG.weight_unit )
				info:print( "\t", LANG.protection, ":" )

				for k, v in pairs( data.damage ) do
					if !data.HIDE[k] then
						local name = VEST.TranslateDamage( k )
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

local def_wep = surface.GetTextureID( "weapons/swep" )
local drag = 0
local function drawItem( i, wx, wy, size, offset )
	//local w, h = ScrW(), ScrH()

	local mx, my = input.GetCursorPos()

	local grid_x = ( i - 1 ) % EQ.cols + 1
	local grid_y = math.floor( ( i - 1 ) / EQ.cols ) + 1

	local cx = wx + grid_x * offset + ( grid_x - 1 ) * size
	local cy = wy + grid_y * offset + ( grid_y - 1 ) * size
	
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

	surface.SetDrawColor( 0, 0, 0, 125 )
	surface.DrawRect( cx, cy, size, size )

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
	end

	local btn = 0

	if drag == 0 or drag == i then
		btn = Button( cx, cy, size, size, i )
	end

	if btn == 1 then
		surface.SetDrawColor( 50, 50, 50, 50 )
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
		local font = OVERRIDE_FONTS[c_wep.SelectFont] or c_wep.SelectFont
		local fy = cy + size * 0.5

		if font == "SCPCSSIcons" then
			fy = fy + size * 0.25
		end

		draw.Text{
			text = c_wep.IconLetter or c_wep.ShowName or c_wep.PrintName,
			pos = { cx + size * 0.5, fy },
			font = font,
			color = c_wep.SelectColor or Color( 255, 210, 0, 255 ),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	else
		draw.WepSelectIcon( def_wep, cx, cy, size, c_wep.SelectColor )
	end

	if wep.Stacks and wep.Stacks > 1 then
		draw.Text{
			text = wep:GetCount(),
			pos = { cx + size * 0.95, cy + size * 0.975 },
			font = "SCPHUDMedium",
			color = c_wep.SelectColor or Color( 255, 210, 0, 255 ),
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		}
	end

	if wep.Toggleable and wep:GetEnabled() then
		PushFilters( TEXFILTER.LINEAR )
			surface.SetMaterial( MATS.gear )
			surface.SetDrawColor( 155, 155, 155, 155 )
			surface.DrawTexturedRect( cx + size * 0.75 - 2, cy + 2, size * 0.25, size * 0.25 )
		PopFilters()
	end

	if wep.HasBattery then
		local pct = wep:GetBattery() * 0.01

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( cx + size * 0.85 + 2 - 2, cy + size * 0.7 + 2 - 2, size * 0.15 - 4, size * 0.3 - 4 )

		surface.SetDrawColor( Color( 255 * ( 1 - pct ), 255 * pct, 0 ) )
		surface.DrawRect( cx + size * 0.85 + 4 - 2, cy + size * 0.7 + 4 - 2 + ( size * 0.3 - 8 ) * ( 1 - pct ), size * 0.15 - 8, ( size * 0.3 - 8 ) * pct )
	end

	if drag != i and LocalPlayer():GetActiveWeapon() == wep then
		surface.SetDrawColor( 0, 0, 175, 175 )
		surface.DrawOutlinedRect( cx + 1, cy + 1, size - 2, size - 2 )
		surface.DrawOutlinedRect( cx + 2, cy + 2, size - 4, size - 4 )
	end
end

local function drawSideButton( x, y, w, h, offset, tab )
	local btn = Button( x, y, w, h )

	if btn == 1 then
		surface.SetDrawColor( 50, 50, 50, 50 )
		surface.DrawRect( x, y, w, h )
	elseif btn == 2 or btn == 3 then
		local cb = tab[4]
		if isfunction( cb ) then
			cb( unpack( tab, 5 ) )
		end
	end

	if tab[2] then
		surface.SetMaterial( tab[2] )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( x + 2, y + 2, h - 4, h - 4 )
		surface.DrawTexturedRect( x + 2, y + 2, h - 4, h - 4 )

		x = x + h
		w = w - h
	end

	draw.LimitedText{
		text = LANG.eq_buttons[tab[1]] or tab[1],
		pos = { x + w * 0.5, y + h * 0.5 },
		font = "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		max_width = w,
	}
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
			alpha = math.max( alpha - 4 * RealFrameTime(), 0 )
		end
	else
		if alpha < 1 then
			alpha = math.min( alpha + 4 * RealFrameTime(), 1 )
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

	local width = ( size + offset ) * EQ.cols + offset
	local height = ( size + offset ) * EQ.rows + h * 0.04

	local wx, wy = w * 0.5 - width * 0.5, h * 0.5 - height * 0.5

	local vest_width = size + 2 * offset
	local vest_height = size + offset + h * 0.04 --vest_width + h * 0.04 - offset
	local vest_x = wx - vest_width - w * 0.01

	local b_x = wx + width + w * 0.01
	local b_y = wy
	local b_w = w * 0.2
	local b_h = h * 0.075

	surface.SetDrawColor( Color( 150 * alpha, 150 * alpha, 150 * alpha, 100 ) )
	surface.DrawRect( vest_x - 2, wy - 2, vest_width + 4, vest_height + 4 )
	surface.DrawRect( wx - 2, wy - 2, width + 4, height + 4 )

	local cache = {}
	for i, v in ipairs( ACTIONS ) do
		local r = v[3] == true or isfunction( v[3] ) and v[3]()
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
		pos = { vest_x + vest_width * 0.5, wy + vest_height - 0.02 * h },
		font = "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
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
		pos = { wx + w * 0.01, wy + height - 0.02 * h },
		font = nav_font_override or "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = LANG.eq_hold,
		pos = { w * 0.5, wy + height - 0.02 * h },
		font = nav_font_override or "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = LANG.eq_rmb,
		pos = { wx + width - w * 0.01, wy + height - 0.02 * h },
		font = nav_font_override or "SCPHUDMedium",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_CENTER,
	}

	for i = 1, EQ.slots do
		if i != drag then
			drawItem( i, wx, wy, size, offset )
		end
	end

	if drag > 0 then
		drawItem( drag, wx, wy, size, offset )
	end

	if SHOW_WEP_INFO and !close_eq then
		local mx, my = input.GetCursorPos()

		local color = Color( 0, 0, 0, 240 )
		local author = SHOW_WEP_INFO.Author
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

			if author and author != "" then
				local tmp = surface.GetTextSize( LANG.author..": "..author ) + w * 0.02

				if tmp > info_width then
					info_width = tmp
				end
			end

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
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.38
		}

		if author and author != "" then
			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, info_width, h * 0.05 )
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
			surface.DrawRect( mx, cur_y, info_width, h * 0.05 )
			cur_y = cur_y + h * 0.05

			draw.Text{
				text = LANG.info..":",
				pos = { mx + w * 0.01, cur_y - h * 0.02 },
				font = "SCPHUDMedium",
				color = Color( 255, 255, 255, 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

			local text_height = draw.MultilineText( mx + w * 0.015, cur_y, info, "SCPHUDMedium", nil, w * 0.375, 0, 0, TEXT_ALIGN_LEFT, nil, true )

			surface.SetDrawColor( color )
			surface.DrawRect( mx, cur_y, info_width, text_height )

			draw.MultilineText( mx + w * 0.015, cur_y, info, "SCPHUDMedium", Color( 255, 255, 255, 255 ), w * 0.375, 0, 0, TEXT_ALIGN_LEFT )

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

function UpdatePlayerEQ()
	local player_weapons = LocalPlayer():GetWeapons()

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

			for j = 1, EQ.slots do
				if !WEAPONS[j] then
					first_empty = j --get first empty slot
					break
				end
			end

			if first_empty > 0 then
				WEAPONS[first_empty] = wep --insert item
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
	HUDDrawInfo = true
	
	UpdatePlayerEQ()
	close_eq = false
	draw_eq = true

	if lcx > 0 and lcy > 0 then
		input.SetCursorPos( lcx, lcy )
	end

	gui.EnableScreenClicker( true )

	if bit.band( LANG_FLAGS, LANGUAGE.EQ_LONG_TEXT ) == LANGUAGE.EQ_LONG_TEXT then
		nav_font_override = "SCPHUDVSmall"
	else
		nav_font_override = nil
	end
end

function HideEQ()
	HUDDrawInfo = false

	if draw_eq then
		drag = 0
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

function GetLocalWeapons()
	return WEAPONS
end