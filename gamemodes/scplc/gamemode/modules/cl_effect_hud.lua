local roman_tab = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X" }

local button_next = false
local next_frame = false
local function button( x, y, w, h )
	local mx, my = input.GetCursorPos()
	if mx >= x and mx <= x + w and my >= y and my <= y + h then
		if input.IsMouseDown( MOUSE_LEFT )then
			
			if button_next then
				button_next = false
				return 2 --LMB
			end

			return 1 --HOVER
		elseif input.IsMouseDown( MOUSE_RIGHT ) then
			if button_next then
				button_next = false
				return 3 --RMB
			end

			return 1 --HOVER
		else
			if next_frame then
				next_frame = false
				button_next = true
			end

			return 1 --HOVER
		end
	end

	return 0
end

local color_white = Color( 255, 255, 255, 255 )
local color_25 = Color( 25, 25, 25, 255 )
local color_black235 = Color( 0, 0, 0, 235 )
local color_white175 = Color( 255, 255, 255, 175 )

local function DrawEffectsHUD()
	next_frame = true
	local w, h = ScrW(), ScrH()

	if !LocalPlayer().EFFECTS then LocalPlayer().EFFECTS = {} end
	if !LocalPlayer().EFFECTS then return end

	local effects = LocalPlayer().EFFECTS
	local ec = #effects

	local hide = ec > 5
	local showtext

	for i = 1, math.min( ec, 5 ) do
		local effect = effects[i]
		local reg = EFFECTS.registry[effect.name.."_"..effect.tier]
		local eff = EFFECTS.effects[effect.name]

		surface.SetDrawColor( color_white175 )
		surface.DrawOutlinedRect( w * 0.97 - 1, h * 0.55 + w * 0.035 * ( i - 1 ) - 1, w * 0.025 + 2, w * 0.025 + 2 )

		if hide and i == 5 then
			draw.Text{
				text = (ec - 4).."+",
				pos = { w * 0.9824, h * 0.55 + w * 0.035 * ( i - 1 ) + w * 0.0125 },
				font = "SCPHUDMedium",
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}

			local btn = button( w * 0.97, h * 0.55 + w * 0.035 * ( i - 1 ), w * 0.025, w * 0.025 )

			if btn > 0 then
				showtext = {}

				for j = 5, ec do
					local name = LANG.EFFECTS[effect.name] or effect.name
					local tier = eff.tiers > 1 and roman_tab[effect.tier] or ""
					local time = effect.endtime == -1 and LANG.EFFECTS.permanent or math.floor( effect.endtime - CurTime() )

					table.insert( showtext, name.." "..tier.." ("..time..")" )
				end
			end
		else
			local ico = reg.icon
			if ico then
				surface.SetDrawColor( color_25 )
				surface.DrawRect( w * 0.97, h * 0.55 + w * 0.035 * ( i - 1 ), w * 0.025, w * 0.025 )

				render.PushFilterMin( TEXFILTER.LINEAR )
				render.PushFilterMag( TEXFILTER.LINEAR )

				surface.SetDrawColor( reg.color or color_white )
				surface.SetMaterial( ico )
				surface.DrawTexturedRect( w * 0.97 + 2, h * 0.55 + w * 0.035 * ( i - 1 ) + 2, w * 0.025 - 4, w * 0.025 - 4 )

				render.PopFilterMin()
				render.PopFilterMag()
			end

			if effect.endtime != -1 then
				local timepct = ( effect.endtime - CurTime() ) / eff.duration

				surface.SetDrawColor( color_black235 )
				draw.NoTexture()
				surface.DrawCooldownRectCCW( w * 0.97, h * 0.55 + w * 0.035 * ( i - 1 ), w * 0.025, w * 0.025, 1 - timepct, 0.05 )
			end

			local btn = button( w * 0.97, h * 0.55 + w * 0.035 * ( i - 1 ), w * 0.025, w * 0.025 )

			if btn > 0 then
				local name = LANG.EFFECTS[effect.name] or effect.name
				local tier = eff.tiers > 1 and roman_tab[effect.tier] or ""
				local time = effect.endtime == -1 and LANG.EFFECTS.permanent or math.floor( effect.endtime - CurTime() )

				showtext = name.." "..tier.." ("..time..")"
			end
		end
	end

	if showtext then
		local mx, my = input.GetCursorPos()

		surface.SetFont( "SCPHUDMedium" )

		if !istable( showtext ) then
			showtext = { showtext }
		end

		local maxw = 0
		local fh = 0

		for i = 1, #showtext do
			local tw, th = surface.GetTextSize( showtext[i] )
			fh = fh + th

			if tw > maxw then
				maxw = tw
			end
		end

		surface.SetDrawColor( color_white )
		surface.DrawRect( mx - maxw - 17, my - 1, maxw + 18, fh + 10 )

		surface.SetDrawColor( color_25 )
		surface.DrawRect( mx - maxw - 16, my, maxw + 16, fh + 8 )

		local cury = my + 4
		for i = 1, #showtext do
			local tw, th = draw.Text{
				text = showtext[i],
				pos = { mx - 8, cury },
				font = "SCPHUDMedium",
				color = color_white,
				xalign = TEXT_ALIGN_RIGHT,
				yalign = TEXT_ALIGN_TOP,
			}

			cury = cury + th
		end
	end
end

hook.Add( "DrawOverlay", "SCPEffectHUD", DrawEffectsHUD )