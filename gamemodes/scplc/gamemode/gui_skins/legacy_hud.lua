--[[-------------------------------------------------------------------------
Locals
---------------------------------------------------------------------------]]
local MATS = {
	blur = Material( "pp/blurscreen" ),
	mag = Material( "slc/hud/magicon.png", "smooth" ),
	ammo = Material( "slc/hud/ammoicon.png", "smooth" ),
	battery = Material( "slc/hud/battery.png", "smooth" ),
	blink = Material( "slc/hud/blink" ),
	sprint = Material( "slc/hud/sprint" ),
	hp = Material( "slc/hud/hp" ),
	sanity = Material( "slc/hud/sanityicon.png", "smooth" ),
	xp = Material( "slc/hud/xpicon.png", "smooth" ),
}

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
	text_white = Color( 255, 255, 255, 100 ),
	gray_bg = Color( 150, 150, 150, 100 ),
	black_bg = Color( 0, 0, 0, 150 ),
	stamina = Color( 150, 175, 0, 175 ),
	stamina_alt = Color( 75, 125, 25, 75 ),
	sanity = Color( 100, 100, 150, 175 ),
	xp = Color( 175, 152, 0, 175 ),
	hover_bg = Color( 180, 180, 180, 255 ),
	hover_fg = Color( 20, 20, 20, 255 ),
	hover_text = Color( 200, 200, 200, 255 ),
}

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

local function mxButton( mx, w, h )
	return button( mx:Get( 1, 1 ), mx:Get( 2, 1 ), w, h )
end

local function SpecInfoText( x, y, text, w )
	draw.LimitedText{
		text = text,
		pos = {  x, y },
		color = COLOR.text_white,
		font = "SCPHUDMedium",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_CENTER,
		max_width = w,
	}
end

local recomputed = false

local last_extra = 0
local shownum = 0
local maxshow = 0
local showtext

local function pre()
	next_frame = true

	shownum = 0
	maxshow = 0
	showtext = nil

	SLC_HUD_END_X = ScrW() * 0.315 * GetHUDScale() * 0.8 + ScrH() * 0.01 + 3
end

--[[-------------------------------------------------------------------------
Spectator HUD
---------------------------------------------------------------------------]]
local function spec_hud()
	local w, h = ScrW(), ScrH()
	local ply = LocalPlayer()

	local spectarget = ply:GetObserverTarget()
	local drawtarget = IsValid( spectarget ) and ROUND.active
	local showtime = ROUND.active

	surface.SetMaterial( MATS.blur )

	render.UpdateScreenEffectTexture()
	MATS.blur:SetFloat( "$blur", 8 )

	if !recomputed then
		recomputed = true
		MATS.blur:Recompute()
	end

	surface.SetDrawColor( COLOR.gray_bg )
	draw.NoTexture()
	
	local start = h * 0.01

	local sh = h
	local sw = w

	if drawtarget then
		surface.DrawRect( w * 0.4 - 2, h * 0.06 + 8, w * 0.2 + 4, h * 0.05 + 4 )
	end

	if showtime then
		surface.DrawRect( w * 0.45 - 2, 8, w * 0.1 + 4, h * 0.05 + 4 )
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

	if drawtarget then
		surface.DrawRect( w * 0.4, h * 0.06 + 10, w * 0.2, h * 0.05 )
	end

	if showtime then
		surface.DrawRect( w * 0.45, 10, w * 0.1, h * 0.05 )
	end

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )

	surface.SetMaterial( MATS.blur )
	surface.SetDrawColor( COLOR.white )
	surface.DrawTexturedRect( 0, 0, sw, sh )

	render.SetStencilEnable( false )
	surface.SetDrawColor( COLOR.black_bg )

	if drawtarget then
		surface.DrawRect( w * 0.4, h * 0.06 + 10, w * 0.2, h * 0.05 )
	end

	if showtime then
		surface.DrawRect( w * 0.45, 10, w * 0.1, h * 0.05 )
	end

	local td = ROUND.time - CurTime()
	local time = td > 0 and string.ToMinutesSeconds( td ) or "00:00"

	if drawtarget then
		draw.LimitedText{
			text = string.sub( spectarget:Nick(), 1, 36 ),
			pos = {  w * 0.5, 10 + h * 0.085 },
			color = COLOR.text_white,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.2 - start,
		}

		if HUDSpectatorInfo then
			if SLCAuth.HasAccess( ply, "slc spectateinfo" ) then
				surface.SetDrawColor( 150, 150, 150, 255 )
				surface.DrawRect( w * 0.35 - 1, h * 0.25 - 1, w * 0.3 + 2, h * 0.5 + 2 )

				surface.SetDrawColor( 40, 40, 40, 255 )
				surface.DrawRect( w * 0.35, h * 0.25, w * 0.3, h * 0.5 )

				local dx, max_w = w * 0.35 + 8, w * 0.3 - 16
				SpecInfoText( dx, h * 0.27, "Nick: "..spectarget:Nick(), max_w )
				SpecInfoText( dx, h * 0.3, "Player ID: "..spectarget:UserID() )
				SpecInfoText( dx, h * 0.33, "SteamID: "..spectarget:SteamID() )
				SpecInfoText( dx, h * 0.36, "SteamID64: "..( spectarget:SteamID64() or "-" ) )
				SpecInfoText( dx, h * 0.39, "Level: "..spectarget:SCPLevel().."   |   XP: "..spectarget:SCPExp() )
				SpecInfoText( dx, h * 0.42, "Active: "..tostring( spectarget:IsActive() ).."   |   AFK: "..tostring( spectarget:IsAFK() ) )
				SpecInfoText( dx, h * 0.45, "Premium: "..tostring( spectarget:IsPremium() ) )
				SpecInfoText( dx, h * 0.48, "Team: "..SCPTeams.GetName( spectarget:SCPTeam() ) )
				SpecInfoText( dx, h * 0.51, "Class: "..spectarget:SCPClass(), max_w )

				local pc, pt = spectarget:SCPPersona()
				SpecInfoText( dx, h * 0.54, "Fake ID: "..SCPTeams.GetName( pt )..", "..pc, max_w )
				SpecInfoText( dx, h * 0.57, "HP: "..spectarget:Health().." / "..spectarget:GetMaxHealth() )
			end
		end
	end

	if showtime then
		draw.Text{
			text = time,
			pos = {  w * 0.5, 10 + h * 0.025 },
			color = COLOR.text_white,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
end

--[[-------------------------------------------------------------------------
Normal HUD
---------------------------------------------------------------------------]]
local function hud()
	local w, h = ScrW(), ScrH()
	local scale = GetHUDScale() * 0.8

	local ply = LocalPlayer()
	local isspec = ply:SCPTeam() == TEAM_SPEC

	if isspec then return end

	surface.SetMaterial( MATS.blur )

	render.UpdateScreenEffectTexture()
	MATS.blur:SetFloat( "$blur", 8 )

	if !recomputed then
		recomputed = true
		MATS.blur:Recompute()
	end

	surface.SetDrawColor( COLOR.gray_bg )
	draw.NoTexture()

	local start = h * 0.01

	local sh = h
	local sw = w
	local addy = 0

	w = w * scale
	h = h * scale

	addy = sh - h

	surface.DrawPoly{
		{ x = start - 2, y = h * 0.75 - 2 + addy },
		{ x = start + w * 0.275 + 2, y = h * 0.75 - 2 + addy },
		{ x = start + w * 0.35 + 3, y = h * 0.99 + 2 + addy },
		{ x = start - 2, y = h * 0.99 + 2 + addy }
	}

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	surface.DrawPoly{
		{ x = start, y = h * 0.75 + addy },
		{ x = start + w * 0.275, y = h * 0.75 + addy },
		{ x = start + w * 0.35, y = h * 0.99 + addy },
		{ x = start, y = h * 0.99 + addy }
	}

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )

	surface.SetMaterial( MATS.blur )
	surface.SetDrawColor( COLOR.white )
	surface.DrawTexturedRect( 0, 0, sw, sh )

	render.SetStencilEnable( false )
	surface.SetDrawColor( COLOR.black_bg )

	draw.NoTexture()
	surface.DrawPoly{
		{ x = start, y = h * 0.75 + addy },
		{ x = start + w * 0.275, y = h * 0.75 + addy },
		{ x = start + w * 0.35, y = h * 0.99 + addy },
		{ x = start, y = h * 0.99 + addy }
	}

	local td = ROUND.time - CurTime()
	local time = td > 0 and string.ToMinutesSeconds( td ) or "00:00"

	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawRect( start + w * 0.025, h * 0.795 + addy, w * 0.235, 2 )

	draw.LimitedText{
		text = string.sub( ply:Nick(), 1, 24 ),
		pos = { start + w * 0.0875, h * 0.773 + addy },
		color = COLOR.text_white,
		font = "SCPScaledHUDMedium",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		max_width = w * 0.175 - start
	}

	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawRect( start + w * 0.175, h * 0.76 + addy, 2, h * 0.025 )

	draw.Text{
		text = time,
		pos = { start + w * 0.225, h * 0.773 + addy },
		color = COLOR.text_white,
		font = "SCPScaledNumbersMedium",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	local bw = w * 0.265
	local bh = h * 0.035

	local ratio = ( w * 0.075 ) / ( h * 0.24 )
	local xoffset = ratio * h * 0.035
	local cxo = ratio * h * 0.015
	//local ixo = ratio * h * 0.005

	local bar = SimpleMatrix( 2, 4, {
		{ start + w * 0.01, h * 0.81 + addy },
		{ start + w * 0.275, h * 0.81 + addy },
		{ start + w * 0.275 + xoffset, h * 0.845 + addy },
		{ start + w * 0.01 + xoffset, h * 0.845 + addy },
	} )

	local bar_out = SimpleMatrix( 2, 4, {
		{ start + w * 0.01 - 4, h * 0.81 - 2 + addy },
		{ start + w * 0.275 + 2, h * 0.81 - 2 + addy },
		{ start + w * 0.275 + xoffset + 4, h * 0.845 + 2 + addy },
		{ start + w * 0.01 + xoffset - 2, h * 0.845 + 2 + addy },
	} )

	local bar_offset = SimpleMatrix( 2, 4, {
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
	} )

	local xico = ratio * ( h * 0.025 )

	local ico = SimpleMatrix( 2, 4, {
		{ start + w * 0.015, h * 0.815 + addy },
		{ start + w * 0.025, h * 0.815 + addy },
		{ start + w * 0.025 + xico, h * 0.84 + addy },
		{ start + w * 0.015 + xico, h * 0.84 + addy },
	} )

	local ico_offset = SimpleMatrix( 2, 4, {
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
	} )

	draw.NoTexture()

	--BLINK
	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	local cur = HUDNextBlink - CurTime()
	if HUDBlink > 0 and cur > 0 then
		local width = math.min( cur / HUDBlink, 1 ) * w * 0.255

		draw.NoTexture()
		surface.DrawPoly{
			{ x = start + w * 0.015, y = h * 0.815 + addy },
			{ x = start + w * 0.015 + width, y = h * 0.815 + addy },
			{ x = start + w * 0.015 + width + xico, y = h * 0.84 + addy },
			{ x = start + w * 0.015 + xico, y = h * 0.84 + addy },
		}
	end

	surface.SetDrawColor( COLOR.white )
	surface.SetMaterial( MATS.blink )
	surface.DrawTexturedRect( h * -0.01 + w * 0.1475, h * 0.8075 + addy, h * 0.04, h * 0.04 )

	--HP
	bar = bar + bar_offset
	bar_out = bar_out + bar_offset
	ico = ico + bar_offset

	draw.NoTexture()
	surface.SetDrawColor( COLOR.gray_bg )
	local hp_out_poly = bar_out:ToPoly()
	surface.DrawDifference( bar:ToPoly(), hp_out_poly )

	
	local hp = ply:Health()
	local maxhp = ply:GetMaxHealth()
	local extra_hp = ply:GetExtraHealth()
	local max_extra_hp = ply:GetMaxExtraHealth()
	local extra = extra_hp > 0 and max_extra_hp > 0 or last_extra > 0

	local hpperseg = maxhp / 20
	local hp_segments = math.min( math.ceil( hp / maxhp * 20 ), 20 )

	local intense = 1 - hp_segments + hp / hpperseg
	local nico = SimpleMatrix( 2, 4, ico )

	if intense > 1 then
		intense = 1
	end

	if extra then
		render.SetStencilPassOperation( STENCIL_REPLACE )
	
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilReferenceValue( 1 )
	
		render.SetStencilEnable( true )
	end

	for i = 1, hp_segments do
		if i == hp_segments then
			surface.SetDrawColor( 175, 0, 25, 175 * intense )
		else
			surface.SetDrawColor( 175, 0, 25, 175 )
		end

		surface.DrawPoly( nico:ToPoly() )
		nico = nico + ico_offset
	end

	if extra then
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilPassOperation( STENCIL_KEEP )

		local f = extra_hp / max_extra_hp

		if last_extra != last_extra then --NaN protection
			last_extra = f
		end

		last_extra = Lerp( RealFrameTime() * 4, last_extra, f )

		surface.SetDrawColor( 255, 150, 150 )
		surface.DrawRect( hp_out_poly[1].x, hp_out_poly[1].y, ( hp_out_poly[3].x - hp_out_poly[1].x ) * last_extra, hp_out_poly[3].y - hp_out_poly[1].y )

		render.SetStencilEnable( false )
	end

	surface.SetDrawColor( COLOR.text_white )
	surface.SetMaterial( MATS.hp )
	surface.DrawTexturedRect( h * -0.005 + w * 0.1475 + xoffset + cxo, h * 0.8625 + addy, h * 0.03, h * 0.03 )

	if mxButton( bar, bw, bh ) > 0 then
		if extra then
			shownum = extra_hp
			maxshow = max_extra_hp
			showtext = LANG.HUD.extra_hp
		else
			shownum = hp
			maxshow = maxhp
			showtext = LANG.HUD.hp
		end
	end

	//surface.SetDrawColor( Color( 150, 150, 150, 100 ) )

	--STAMINA
	bar = bar + bar_offset
	bar_out = bar_out + bar_offset
	ico = ico + bar_offset

	
	draw.NoTexture()
	surface.SetDrawColor( COLOR.gray_bg )
	
	local stm_out_poly = bar_out:ToPoly()
	surface.DrawDifference( bar:ToPoly(), stm_out_poly )
	
	local stamina = ply:GetStamina()
	local max_stamina = ply:GetMaxStamina()
	local boost = ply:GetStaminaBoost() > CurTime()

	local segments = math.Clamp( math.ceil( stamina / max_stamina * 20 ), 0, 20 )

	//local intense = 1 //- segments + stamina / 5
	local nico = SimpleMatrix( 2, 4, ico )

	if boost then
		render.SetStencilPassOperation( STENCIL_REPLACE )
	
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilReferenceValue( 1 )
	
		render.SetStencilEnable( true )
	end
	
	if ply:GetExhausted() then
		surface.SetDrawColor( COLOR.stamina_alt )
	else
		surface.SetDrawColor( COLOR.stamina )
	end

	for i = 1, segments do
		surface.DrawPoly( nico:ToPoly() )
		nico = nico + ico_offset
	end

	if boost then
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilPassOperation( STENCIL_KEEP )

		local f = ( ply:GetStaminaBoost() - CurTime() ) / ply:GetStaminaBoostDuration()

		surface.SetDrawColor( 125, 135, 255 )
		surface.DrawRect( stm_out_poly[1].x, stm_out_poly[1].y, ( stm_out_poly[3].x - stm_out_poly[1].x ) * f, stm_out_poly[3].y - stm_out_poly[1].y )

		render.SetStencilEnable( false )
	end

	if mxButton( bar, bw, bh ) > 0 then
		shownum = stamina
		maxshow = max_stamina
		showtext = LANG.HUD.stamina
	end

	surface.SetDrawColor( COLOR.white )
	surface.SetMaterial( MATS.sprint )
	surface.DrawTexturedRect( h * -0.005 + w * 0.1475 + 2 * (xoffset + cxo), h * 0.9125 + addy, h * 0.03, h * 0.03 )

	local wep = ply:GetActiveWeapon()

	--BATTERY
	if IsValid( wep ) and wep.HasBattery then
		local battery = wep:GetBattery()

		if battery < 0 then
			battery = 0
		end

		local pct = battery / 100

		draw.NoTexture()
		surface.SetDrawColor( (1 - pct) * 200, pct * 200, 0, 50 )

		local xo = ratio * ( h * 0.12 )
		local bat = {
			{ x = start + w * 0.01 - 4, y = h * 0.86 - 2 + addy },
			{ x = start + w * 0.01 - 4 + xoffset, y = h * 0.86 - 2 + addy },
			{ x = start + w * 0.01 - 4 + xo, y = h * 0.945 + 2 + addy },
			{ x = start + w * 0.01 - 4, y = h * 0.945 + 2 + addy },
		}
		surface.DrawPoly( bat )

		draw.Text{
			text = battery.."%",
			pos = { start + w * 0.01, h * 0.945 + addy },
			color = COLOR.text_white,
			font = "SCPScaledNumbersSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_BOTTOM,
		}

		PushFilters( TEXFILTER.LINEAR )
			surface.SetDrawColor( COLOR.text_white )
			surface.SetMaterial( MATS.battery )
			surface.DrawTexturedRect( h * -0.02 + w * 0.01 + xo * 0.5 - 4, h * 0.94 + addy, h * 0.06, h * 0.06 )
		PopFilters()
	end

	--AMMO
	if IsValid( wep ) and ( wep:GetMaxClip1() > 0 or wep.GetCustomClip ) then
		PushFilters( TEXFILTER.LINEAR )
			if !wep.GetCustomClip then
				surface.SetDrawColor( COLOR.white )
				surface.SetMaterial( MATS.ammo )
				surface.DrawTexturedRect( start + w * 0.075, h * 0.9575 + addy, h * 0.025, h * 0.025 )

				draw.Text{
					text = string.sub( ply:GetAmmoCount( wep:GetPrimaryAmmoType() ), 1, 23 ),
					pos = { start + w * 0.1, h * 0.97 + addy },
					color = COLOR.text_white,
					font = "SCPScaledNumbersMedium",
					xalign = TEXT_ALIGN_LEFT,
					yalign = TEXT_ALIGN_CENTER,
				}
			end

			surface.SetDrawColor( COLOR.white )
			surface.SetMaterial( MATS.mag )
			surface.DrawTexturedRect( start + w * 0.21, h * 0.9575 + addy, h * 0.025, h * 0.025 )

			draw.Text{
				text = string.sub( wep.GetCustomClip and wep:GetCustomClip() or wep:Clip1(), 1, 23 ),
				pos = { start + w * 0.235, h * 0.97 + addy },
				color = COLOR.text_white,
				font = "SCPScaledNumbersMedium",
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

		PopFilters()
	end
end

--[[-------------------------------------------------------------------------
Additional HUD
---------------------------------------------------------------------------]]
local function a_hud()
	local w, h = ScrW(), ScrH()
	local scale = GetHUDScale() * 0.8
	local ply = LocalPlayer()

	local start = h * 0.01

	local sh = h
	local sw = w
	local addy = 0

	w = w * scale
	h = h * scale

	addy = sh - h

	surface.SetDrawColor( COLOR.gray_bg )
	draw.NoTexture()

	surface.DrawPoly{
		{ x = start + w * 0.285 - 3, y = h * 0.75 - 2 + addy },
		{ x = start + w * 0.55 + 2 + h * 0.03, y = h * 0.75 - 2 + addy },
		{ x = start + w * 0.625 + 3 + h * 0.03, y = h * 0.99 + 2 + addy },
		{ x = start + w * 0.36 - 2, y = h * 0.99 + 2 + addy }
	}

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	surface.SetMaterial( MATS.blur )

	surface.DrawPoly{
		{ x = start + w * 0.285, y = h * 0.75 + addy },
		{ x = start + w * 0.55 + h * 0.03, y = h * 0.75 + addy },
		{ x = start + w * 0.625 + h * 0.03, y = h * 0.99 + addy },
		{ x = start + w * 0.36, y = h * 0.99 + addy }
	}

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.SetDrawColor( COLOR.white )
	surface.DrawTexturedRect( 0, 0, sw, sh )

	render.SetStencilEnable( false )
	surface.SetDrawColor( COLOR.black_bg )

	draw.NoTexture()
	surface.DrawPoly{
		{ x = start + w * 0.285, y = h * 0.75 + addy },
		{ x = start + w * 0.55 + h * 0.03, y = h * 0.75 + addy },
		{ x = start + w * 0.625 + h * 0.03, y = h * 0.99 + addy },
		{ x = start + w * 0.36, y = h * 0.99 + addy }
	}

	local bw = w * 0.265
	local bh = h * 0.035

	start = h * 0.01 + w * 0.285
	local ratio = ( w * 0.075 ) / ( h * 0.24 )
	local xoffset = ratio * h * 0.035
	local cxo = ratio * h * 0.015
	local ixo = ratio * h * 0.005
	local xico = ratio * ( h * 0.025 )

	local ico_offset = SimpleMatrix( 2, 4, {
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
	} )

	local bar_offset = SimpleMatrix( 2, 4, {
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
	} )

	local _, th = draw.Text{
		text = LANG.HUD.class..":",
		pos = { start + w * 0.02, h * 0.75 + addy },
		color = COLOR.text_white,
		font = "SCPScaledHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
	}

	local class = ply:SCPClass()
	draw.LimitedText{
		text = LANG.CLASSES[class] or class,
		pos = { start + w * 0.04, h * 0.75 + th * 0.75 + addy },
		color = COLOR.text_white,
		font = "SCPScaledHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
		max_width = w * 0.1125
	}

	local _, th = draw.Text{
		text = LANG.HUD.team..":",
		pos = { start + w * 0.1525, h * 0.75 + addy },
		color = COLOR.text_white,
		font = "SCPScaledHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
	}

	local tname = SCPTeams.GetName( ply:SCPTeam() )
	draw.LimitedText{
		text = LANG.TEAMS[tname] or tname,
		pos = { start + w * 0.1725, h * 0.75 + th * 0.75 + addy },
		color = COLOR.text_white,
		font = "SCPScaledHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
		max_width = w * 0.1025
	}

	local xo = ratio * h * 0.06
	start = start + xo + h * 0.015

	/*local hh = h * 0.91
	surface.SetDrawColor( Color( 255, 0, 0 ) )
	surface.DrawLine( 0, hh, w, hh )*/

	/*local xx = start + w * 0.1325 - h * 0.02
	surface.SetDrawColor( Color( 255, 0, 0 ) )
	surface.DrawLine( xx, 0, xx, h )*/

	local bar = SimpleMatrix( 2, 4, {
		{ start, h * 0.81 + addy },
		{ start + w * 0.265, h * 0.81 + addy },
		{ start + w * 0.265 + xoffset, h * 0.845 + addy },
		{ start + xoffset, h * 0.845 + addy },
	} )

	local bar_out = SimpleMatrix( 2, 4, {
		{ start - 4, h * 0.81 - 2 + addy },
		{ start + w * 0.265 + 2, h * 0.81 - 2 + addy },
		{ start + w * 0.265 + xoffset + 4, h * 0.845 + 2 + addy },
		{ start + xoffset - 2, h * 0.845 + 2 + addy },
	} )

	local ico = SimpleMatrix( 2, 4, {
		{ start + ixo + w * 0.004, h * 0.815 + addy },
		{ start + ixo + w * 0.014, h * 0.815 + addy },
		{ start + ixo + w * 0.014 + xico, h * 0.84 + addy },
		{ start + ixo + w * 0.004 + xico, h * 0.84 + addy },
	} )

	--SANITY
	draw.NoTexture()
	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	local san = ply:GetSanity()
	local maxsan = ply:GetMaxSanity()
	local segments = math.min( math.ceil( san / maxsan * 20 ), 20 )

	local nico = SimpleMatrix( 2, 4, ico )

	for i = 1, segments do
		surface.SetDrawColor( COLOR.sanity )

		surface.DrawPoly( nico:ToPoly() )
		nico = nico + ico_offset
	end

	surface.SetDrawColor( COLOR.text_white )
	surface.SetMaterial( MATS.sanity )
	surface.DrawTexturedRect( start + w * 0.1325 - h * 0.015, h * 0.8125 + addy, h * 0.03, h * 0.03 )

	if mxButton( bar, bw, bh ) > 0 then
		shownum = san
		maxshow = maxsan
		showtext = LANG.HUD.sanity
	end

	bar = bar + bar_offset
	bar_out = bar_out + bar_offset
	ico = ico + bar_offset

	--XP
	draw.NoTexture()
	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	local xp = ply:SCPExp()
	local maxxp = ply:RequiredXP() //CVAR.slc_xp_level:GetInt() + CVAR.slc_xp_increase:GetInt() * ply:SCPLevel()
	if xp > 0 then
		local s = start + xoffset + cxo + ixo + w * 0.004

		local pct = ( xp / maxxp )

		if pct > 1 then
			pct = 1
		end

		local width = w * 0.257 * pct

		draw.NoTexture()
		surface.SetDrawColor( COLOR.xp )
		surface.DrawPoly{
			{ x = s, y = h * 0.865 + addy },
			{ x = s + width, y = h * 0.865 + addy },
			{ x = s + width + xico, y = h * 0.89 + addy },
			{ x = s + xico, y = h * 0.89 + addy },
		}
	end

	if mxButton( bar, bw, bh ) > 0 then
		shownum = xp
		maxshow = maxxp
		showtext = LANG.HUD.xp
	end

	PushFilters( TEXFILTER.LINEAR )
		surface.SetDrawColor( COLOR.text_white )
		surface.SetMaterial( MATS.xp )
		surface.DrawTexturedRect( start + xoffset + cxo + w * 0.1325 - h * 0.02, h * 0.8575 + addy, h * 0.04, h * 0.04 )
	PopFilters()

	draw.Text{
		text = LANG.HUD.class_points..":\t"..ply:SCPClassPoints(),
		pos = { start + (cxo + xoffset) * 2 + w * 0.01, h * 0.91 + addy },
		color = COLOR.text_white,
		font = "SCPScaledHUDSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
	}
end

--[[-------------------------------------------------------------------------
Post HUD
---------------------------------------------------------------------------]]
local function post()
	if maxshow > 0 then
		local text = string.format( "%i / %i  %s", shownum, maxshow, showtext or "" )
		//local tw, th = draw.TextSize( text, smallFontOverride or "SCPHUDSmall" )
		local tw, th = draw.TextSize( text, "SCPScaledHUDSmall" )

		local x, y = input.GetCursorPos()

		x = x + 5
		y = y + 5

		surface.SetDrawColor( COLOR.hover_bg )
		surface.DrawRect( x - 2, y - 2, tw + 12, th + 12 )

		surface.SetDrawColor( COLOR.hover_fg )
		surface.DrawRect( x, y, tw + 8, th + 8 )

		draw.Text{
			text = text,
			pos = { x + 4, y + 4 },
			color = COLOR.hover_text,
			font = "SCPScaledHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end
end

local function draw_all()
	local ply = LocalPlayer()

	pre()

	if ply:SCPTeam() == TEAM_SPEC then
		spec_hud()
	else
		hud()
	end

	if HUDDrawInfo or ROUND.post then
		HUDDrawingInfo = true
		a_hud()
	else
		HUDDrawingInfo = false
	end

	post()
end

AddGUISkin( "hud", "legacy", {
	create = function()
		hook.Add( "SLCDrawHUD", "HUD.Legacy.Paint", draw_all )
	end,
	remove = function()
		hook.Remove( "SLCDrawHUD", "HUD.Legacy.Paint" )
	end,
	show =  nil,
	hide = nil,
} )