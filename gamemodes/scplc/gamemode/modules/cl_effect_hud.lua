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

	local ply = LocalPlayer()
	if !ply.EFFECTS then return end

	local effects = {}

	for i, v in ipairs( ply.EFFECTS ) do
		local eff = EFFECTS.effects[v.name]
		if eff and !eff.hide then
			table.insert( effects, v )
		end
	end

	local ec = #effects
	local hide = ec > 5
	local showtext

	local start_x = w * 0.97
	local start_y = h * 0.55
	
	local size = w * 0.025
	local margin = w * 0.01

	local use_roman = !GetSettingsValue( "hud_avoid_roman" )
	for i = 1, math.min( ec, 5 ) do
		local effect = effects[i]
		local reg = EFFECTS.registry[effect.name.."_"..effect.tier]
		local eff = EFFECTS.effects[effect.name]

		if hide and i == 5 then
			draw.Text{
				text = ( ec - 4 ).."+",
				pos = { w * 0.9824, start_y + ( size + margin ) * ( i - 1 ) + w * 0.0125 },
				font = "SCPHUDMedium",
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}

			local btn = button( start_x, start_y + ( size + margin ) * ( i - 1 ), size, size )

			if btn > 0 then
				showtext = {}

				for j = 5, ec do
					local n_effect = effects[j]
					local n_eff = EFFECTS.effects[n_effect.name]

					local name = LANG.EFFECTS[n_eff.lang or n_effect.name] or n_eff.lang or n_effect.name
					local tier = n_eff.tiers > 1 and ( use_roman and ToRoman( n_effect.tier ) or n_effect.tier ) or ""
					local time = n_effect.endtime == -1 and LANG.EFFECTS.permanent or math.floor( n_effect.endtime - CurTime() )

					table.insert( showtext, name.." "..tier.." ("..time..")" )
				end
			end
		else
			if reg.icon then
				surface.SetDrawColor( color_25 )
				surface.DrawRect( start_x, start_y + ( size + margin ) * ( i - 1 ), size, size )

				PushFilters( TEXFILTER.LINEAR )

				surface.SetDrawColor( reg.color or color_white )
				surface.SetMaterial( reg.icon )
				surface.DrawTexturedRect( start_x + 2, start_y + ( size + margin ) * ( i - 1 ) + 2, size - 4, size - 4 )

				PopFilters()
			end

			if effect.endtime != -1 then
				local timepct = ( effect.endtime - CurTime() ) / ( effect.duration or eff.duration )

				surface.SetDrawColor( color_black235 )
				draw.NoTexture()
				surface.DrawCooldownRectCCW( start_x, start_y + ( size + margin ) * ( i - 1 ), size, size, 1 - timepct )
			end

			local btn = button( start_x, start_y + ( size + margin ) * ( i - 1 ), size, size )

			if btn > 0 then
				local name = LANG.EFFECTS[eff.lang or effect.name] or eff.lang or effect.name
				local tier = eff.tiers > 1 and ( use_roman and ToRoman( effect.tier ) or effect.tier ) or ""
				local time = effect.endtime == -1 and LANG.EFFECTS.permanent or math.floor( effect.endtime - CurTime() )

				showtext = name.." "..tier.." ("..time..")"
			end
		end

		surface.SetDrawColor( color_white175 )
		surface.DrawOutlinedRect( start_x - 1, start_y + ( size + margin ) * ( i - 1 ) - 1, size + 2, size + 2 )
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

		if my + fh + 10 > h then
			my = h - fh - 10
		end

		surface.SetDrawColor( color_white )
		surface.DrawRect( mx - maxw - 17, my - 1, maxw + 18, fh + 10 )

		surface.SetDrawColor( color_25 )
		surface.DrawRect( mx - maxw - 16, my, maxw + 16, fh + 8 )

		local cury = my + 4
		for i = 1, #showtext do
			local _, th = draw.Text{
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

hook.Add( "SLCRegisterSettings", "SLCEffectsHUD", function()
	RegisterSettingsEntry( "hud_avoid_roman", "switch", false, nil, "hud_config" )
end )