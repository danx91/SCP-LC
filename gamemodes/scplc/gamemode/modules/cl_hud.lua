local hudscales = {
	vbig = 1.1,
	big = 1.05,
	normal = 1,
	default = 1,
	small = 0.9,
	vsmall = 0.8,
	imretard = 0.6,
}

local hudscalecvar = CreateClientConVar( "cvar_slc_hud_scale", 1, true )

concommand.Add( "slc_hud_scale", function( ply, cmd, args )
	local size = args[1]

	if !size or size == "" or !hudscales[size] then
		print( "Unknown HUD size! Available sizes: vbig, big, normal, small, vsmall, imretard" )
		return
	end

	RunConsoleCommand( "cvar_slc_hud_scale", hudscales[size] )
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tbl = {}

	for k, v in pairs( hudscales ) do
		if string.find( k, args ) then
			table.insert( tbl, cmd.." "..k )
		end
	end

	return tbl
end )

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudWeaponSelection = true,
	CHudSuitPower = true,
}

hook.Add( "HUDShouldDraw", "HideDefaultHUD", function( name )
	if hide[name] then return false end
end )

function GM:DrawDeathNotice( x,  y )
end

local MATS = {
	blur = Material( "pp/blurscreen" ),
	mag = Material( "slc/hud/magicon.png" ),
	ammo = Material( "slc/hud/ammoicon.png" ),
	battery = Material( "slc/hud/battery.png" ),
	blink = Material( "slc/hud/blink" ),
	sprint = Material( "slc/hud/sprint" ),
	hp = Material( "slc/hud/hp" ),
	sanity = Material( "slc/hud/sanityicon.png" ),
	xp = Material( "slc/hud/xpicon.png" ),
	escape_blocked = Material( "slc/hud/escape_blocked.png" )
}

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
	text_white = Color( 255, 255, 255, 100 ),
	text_red = Color( 255, 100, 100, 200 ),
	escape_blocked = Color( 255, 0, 0, 255 ),
	gray_bg = Color( 150, 150, 150, 100 ),
	black_bg = Color( 0, 0, 0, 150 ),
	hp_bar = Color( 175, 0, 25, 175 ),
	stamina = Color( 150, 175, 0, 175 ),
	stamina_alt = Color( 75, 125, 25, 75 ),
	sanity = Color( 100, 100, 150, 175 ),
	xp = Color( 175, 152, 0, 175 ),
	hover_bg = Color( 180, 180, 180, 255 ),
	hover_fg = Color( 20, 20, 20, 255 ),
	hover_text = Color( 200, 200, 200, 255 ),
	hint1 = Color( 115, 115, 115, 215 ),
	hint2 = Color( 150, 150, 150, 255 ),
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

SCPMarkers = {}
HUDDrawSpawnInfo = 0
EscapeStatus = 0
EscapeTimer = 0
hud_disabled = false
HUDDrawInfo = false
HUDBlink = 1
HUDNextBlink = 0
HUDPickupHint = false
HUDSpectatorInfo = false

local recomputed = false
local last_width = ScrW()

function GM:HUDPaint()
	next_frame = true
	local w, h = ScrW(), ScrH()

	if w != last_width then
		print( "Screen resolution changed! Rebuilding fonts..." )
		last_width = w
		RebuildFonts()
	end

	--[[-------------------------------------------------------------------------
	Markers
	---------------------------------------------------------------------------]]
	for i, v in rpairs( SCPMarkers ) do
		local scr = v.data.pos:ToScreen()

		if scr.visible then
			surface.SetDrawColor( COLOR.text_red )
			//surface.DrawRect( scr.x - 5, scr.y - 5, 10, 10 )
			surface.DrawPoly( {
				{ x = scr.x, y = scr.y - 10 },
				{ x = scr.x + 5, y = scr.y },
				{ x = scr.x, y = scr.y + 10 },
				{ x = scr.x - 5, y = scr.y },
			} )

			local tw, th = draw.Text( {
				text = v.data.name,
				font = "SCPHUDSmall",
				color = COLOR.text_red,
				pos = { scr.x, scr.y + 10 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )

			draw.Text( {
				text = math.Round( v.data.pos:Distance( LocalPlayer():GetPos() ) * 0.019 ) .. "m",
				font = "SCPHUDSmall",
				color = COLOR.text_red,
				pos = { scr.x, scr.y + 10 + th },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )
		end

		if v.time < CurTime() then
			table.remove( SCPMarkers, i )
		end
	end

	if !ROUND.post then
		--[[-------------------------------------------------------------------------
		Spawn info - deprecated
		---------------------------------------------------------------------------]]
		/*if HUDDrawSpawnInfo > CurTime() then
			local ply = LocalPlayer()

			local team = ply:SCPTeam()
			local class = ply:SCPClass()
			local color = SCPTeams.GetColor( team )

			local tw, th = draw.Text{
				text = LANG.CLASSES[class] or class,
				pos = { w * 0.5, h * 0.07 },
				color = color,
				font = "SCPHUDVBig",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			}

			local startinfo = LANG.CLASS_INFO[class]

			if startinfo then
				draw.MultilineText( w * 0.5, h * 0.075 + th, startinfo, "SCPHUDBig", Color( 255, 255, 255 ), w * 0.5, 0, 0, TEXT_ALIGN_CENTER )
			end
		--end*/

		--[[-------------------------------------------------------------------------
		EscapeTimer
		---------------------------------------------------------------------------]]
		/*else*/if EscapeStatus != 0 then
			local x = w * 0.4625
			local y = h * 0.15
			local s = w * 0.075

			if EscapeStatus == 1 then
				draw.Text{
					text = "Escaping...",
					pos = { w * 0.5, y - h * 0.025 },
					color = COLOR.white,
					font = "SCPHUDVBig",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_BOTTOM,
				}

				local a = s * math.sqrt( 2 ) / 2
				local diff = (s - a) / 2
				local s2 = s / 2

				local cx = x + s2
				local cy = y + s2

				local mx = Matrix()

				mx:Translate( Vector( cx, cy ) )
				mx:Rotate( Angle( 0, 45, 0 ) )
				mx:Translate( Vector( -cx, -cy ) )

				cam.PushModelMatrix( mx )
					local f = (EscapeTimer - CurTime()) / 20

					surface.SetDrawColor( COLOR.white )
					draw.NoTexture()
					surface.DrawCooldownHollowRectCW( x + diff, y + diff, a, a, 10, f, HRCSTYLE_RECT_SOLID )
				cam.PopModelMatrix()

				draw.Text{
					text = math.Round(EscapeTimer - CurTime()),
					pos = { cx, cy },
					color = COLOR.white,
					font = "SCPHUDVBig",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			elseif EscapeStatus == 2 then
				draw.Text{
					text = "Escape Blocked!",
					pos = { w * 0.5, y - h * 0.025 },
					color = COLOR.escape_blocked,
					font = "SCPHUDVBig",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_BOTTOM,
				}

				PushFilters( TEXFILTER.LINEAR )
					surface.SetDrawColor( COLOR.white )
					surface.SetMaterial( MATS.escape_blocked )
					surface.DrawTexturedRect( x, y, s, s )
				PopFilters()

				/*draw.Text{
					text = "Someone is blocking escape for your team!",
					pos = { w * 0.5, y + s },
					color = Color( 255, 0, 0 ),
					font = "SCPHUDBig",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_TOP,
				}*/
			end
		end
	end

	if hud_disabled then return end

	local ply = LocalPlayer()

	local isspec = ply:SCPTeam() == TEAM_SPEC
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
	local addy = 0

	local bigFontOverride, mediumFontOverride, smallFontOverride, numbersFontOverride

	if !isspec then
		local scale = hudscalecvar:GetFloat()

		if scale <= 0.9 then
			bigFontOverride = "SCPHUDMedium"
			mediumFontOverride = "SCPHUDVSmall"
			smallFontOverride = "SCPHUDVSmall"
			numbersFontOverride = "SCPNumbersSmall"
		end

		w = w * 0.95 * scale
		h = h * 0.95 * scale

		addy = sh - h
	end

	if !isspec then
		--surface.DrawRect( start - 2, h * 0.765 - 2, w * 0.3 + 4, h * 0.225 + 4 )
		surface.DrawPoly{
			{ x = start - 2, y = h * 0.75 - 2 + addy },
			{ x = start + w * 0.275 + 2, y = h * 0.75 - 2 + addy },
			{ x = start + w * 0.35 + 3, y = h * 0.99 + 2 + addy },
			{ x = start - 2, y = h * 0.99 + 2 + addy }
		}
	else
		if drawtarget then
			surface.DrawRect( w * 0.4 - 2, h * 0.06 + 8, w * 0.2 + 4, h * 0.05 + 4 )
		end

		if showtime then
			surface.DrawRect( w * 0.45 - 2, 8, w * 0.1 + 4, h * 0.05 + 4 )
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

	if !isspec then
		//surface.DrawRect( start, h * 0.765, w * 0.3, h * 0.225 )
		surface.DrawPoly{
			{ x = start, y = h * 0.75 + addy },
			{ x = start + w * 0.275, y = h * 0.75 + addy },
			{ x = start + w * 0.35, y = h * 0.99 + addy },
			{ x = start, y = h * 0.99 + addy }
		}
	else
		if drawtarget then
			surface.DrawRect( w * 0.4, h * 0.06 + 10, w * 0.2, h * 0.05 )
		end

		if showtime then
			surface.DrawRect( w * 0.45, 10, w * 0.1, h * 0.05 )
		end
	end

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )

	surface.SetMaterial( MATS.blur )
	surface.SetDrawColor( COLOR.white )
	surface.DrawTexturedRect( 0, 0, sw, sh )

	render.SetStencilEnable( false )
	surface.SetDrawColor( COLOR.black_bg )

	if !isspec then
		draw.NoTexture()
		surface.DrawPoly{
			{ x = start, y = h * 0.75 + addy },
			{ x = start + w * 0.275, y = h * 0.75 + addy },
			{ x = start + w * 0.35, y = h * 0.99 + addy },
			{ x = start, y = h * 0.99 + addy }
		}
	else
		if drawtarget then
			surface.DrawRect( w * 0.4, h * 0.06 + 10, w * 0.2, h * 0.05 )
		end

		if showtime then
			surface.DrawRect( w * 0.45, 10, w * 0.1, h * 0.05 )
		end
	end

	local td = ROUND.time - CurTime()
	local time = td > 0 and string.ToMinutesSeconds( td ) or "00:00"

	if isspec then
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
				if ULib and ULib.ucl.query( ply, "slc spectateinfo" ) then
					surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
					surface.DrawRect( w * 0.35 - 1, h * 0.25 - 1, w * 0.3 + 2, h * 0.5 + 2 )

					surface.SetDrawColor( Color( 40, 40, 40, 255 ) )
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


					--SpecInfoText( dx, h * 0.7, "To get additional info, type in console:" )
					--SpecInfoText( w * 0.4, h * 0.73, "'slc_playerinfo 5'" )
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

		return
	end

	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawRect( start + w * 0.025, h * 0.795 + addy, w * 0.235, 2 )

	draw.LimitedText{
		text = string.sub( ply:Nick(), 1, 24 ),
		pos = { start + w * 0.0875, h * 0.773 + addy },
		color = COLOR.text_white,
		font = bigFontOverride or "SCPHUDBig",
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
		font =  numbersFontOverride or "SCPNumbersBig",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	local bw = w * 0.265
	local bh = h * 0.035

	local shownum = 0
	local maxshow = 0
	local showtext

	local ratio = (w * 0.075) / (h * 0.24)
	local xoffset = ratio * h * 0.035
	local cxo = ratio * h * 0.015
	local ixo = ratio * h * 0.005

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
		local width = cur / HUDBlink * w * 0.255

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
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	local hp = ply:Health()
	local maxhp = ply:GetMaxHealth()

	local hpperseg = maxhp / 20
	local hp_segments = math.min( math.ceil( hp / maxhp * 20 ), 20 )

	local intense = 1 - hp_segments + hp / hpperseg
	local nico = SimpleMatrix( 2, 4, ico )

	if intense > 1 then
		intense = 1
	end

	for i = 1, hp_segments do
		if i == hp_segments then
			surface.SetDrawColor( Color( 175, 0, 25, 175 * intense ) )
		else
			surface.SetDrawColor( COLOR.hp_bar )
		end

		surface.DrawPoly( nico:ToPoly() )
		nico = nico + ico_offset
	end

	surface.SetDrawColor( COLOR.text_white )
	surface.SetMaterial( MATS.hp )
	surface.DrawTexturedRect( h * -0.005 + w * 0.1475 + xoffset + cxo, h * 0.8625 + addy, h * 0.03, h * 0.03 )

	if mxButton( bar, bw, bh ) > 0 then
		shownum = hp
		maxshow = maxhp
		showtext = LANG.HUD.hp
	end

	//surface.SetDrawColor( Color( 150, 150, 150, 100 ) )

	--STAMINA
	bar = bar + bar_offset
	bar_out = bar_out + bar_offset
	ico = ico + bar_offset

	draw.NoTexture()
	surface.SetDrawColor( COLOR.gray_bg )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	if ply.GetStamina then
		local stamina = ply:GetStamina()
		local max_stamina = ply:GetMaxStamina()

		local segments = math.Clamp( math.ceil( stamina / max_stamina * 20 ), 0, 20 )

		//local intense = 1 //- segments + stamina / 5
		local nico = SimpleMatrix( 2, 4, ico )

		for i = 1, segments do
			if ply.Exhausted then
				surface.SetDrawColor( COLOR.stamina_alt )
			else
				surface.SetDrawColor( COLOR.stamina )
			end

			surface.DrawPoly( nico:ToPoly() )
			nico = nico + ico_offset
		end

		if mxButton( bar, bw, bh ) > 0 then
			shownum = stamina
			maxshow = max_stamina
			showtext = LANG.HUD.stamina
		end
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
		surface.SetDrawColor( Color( (1 - pct) * 200, pct * 200, 0, 50 ) )

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
			font = "SCPNumbersSmall",
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
					font = "SCPNumbersBig",
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
				font = "SCPNumbersBig",
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

		PopFilters()
	end

	--More info
	if HUDDrawInfo /*or HUDDrawSpawnInfo > CurTime()*/ or ROUND.post then
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

		local start = h * 0.01 + w * 0.285

		local _, th = draw.Text{
			text = LANG.HUD.class..":",
			pos = { start + w * 0.02, h * 0.75 + addy },
			color = COLOR.text_white,
			font = "SCPHUDVSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}

		local class = ply:SCPClass()
		draw.LimitedText{
			text = LANG.CLASSES[class] or class,
			pos = { start + w * 0.04, h * 0.75 + th * 0.75 + addy },
			color = COLOR.text_white,
			font = mediumFontOverride or "SCPHUDMedium",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
			max_width = w * 0.1125
		}

		local _, th = draw.Text{
			text = LANG.HUD.team..":",
			pos = { start + w * 0.1525, h * 0.75 + addy },
			color = COLOR.text_white,
			font = "SCPHUDVSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}

		local tname = SCPTeams.GetName( ply:SCPTeam() )
		draw.LimitedText{
			text = LANG.TEAMS[tname] or tname,
			pos = { start + w * 0.1725, h * 0.75 + th * 0.75 + addy },
			color = COLOR.text_white,
			font = mediumFontOverride or "SCPHUDMedium",
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
		local maxxp = CVAR.levelxp:GetInt() + CVAR.levelinc:GetInt() * ply:SCPPrestige()
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
			text = LANG.HUD.prestige_points..":\t"..ply:SCPPrestigePoints(),
			pos = { start + (cxo + xoffset) * 2 + w * 0.01, h * 0.91 + addy },
			color = COLOR.text_white,
			font = smallFontOverride or "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	if maxshow > 0 then
		local text = string.format( "%i / %i  %s", shownum, maxshow, showtext or "" )
		local tw, th = draw.TextSize( text, smallFontOverride or "SCPHUDSmall" )

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
			font = smallFontOverride or "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	w = sw
	h = sh

	--Hint
	if HUDPickupHint then
		if !IsValid( HUDPickupHint ) then
			HUDPickupHint = nil
		end

		local key = input.LookupBinding( "+use" )

		if key then
			key = string.upper( key )
		else
			key = "+use"
		end

		surface.SetFont( "SCPHUDBig" )
		local tw, th = surface.GetTextSize( key )
		if tw < th then
			tw = th
		end

		surface.SetDrawColor( COLOR.hint1 )
		--surface.SetDrawColor( Color( 175, 175, 175, 255 ) )
		surface.DrawRect( w * 0.485 - tw * 0.5, h * 0.75 - th * 0.5 - w * 0.015, w * 0.03 + tw, w * 0.03 + th )

		surface.SetDrawColor( COLOR.hint2 )
		--surface.SetDrawColor( Color( 125, 125, 125, 255 ) )
		surface.DrawRect( w * 0.49 - tw * 0.5, h * 0.75 - th * 0.5 - w * 0.01, w * 0.02 + tw, w * 0.02 + th )

		draw.Text{
			text = key,
			pos = { w * 0.5, h * 0.75 },
			color = COLOR.white,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		local text = LANG.HUD.pickup

		local t = type( HUDPickupHint )
		if t == "table" or  t == "Weapon" then
			if HUDPickupHint.PickupName then
				text = HUDPickupHint.PickupName
			elseif HUDPickupHint.PrintName then
				text = HUDPickupHint.PrintName
			elseif HUDPickupHint.GetPrintName then
				text = HUDPickupHint:GetPrintName()
			end
		end

		draw.Text{
			text = text,
			pos = { w * 0.5, h * 0.75 - th - w * 0.02 },
			color = COLOR.white,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		HUDPickupHint = nil
	end

	--From base gamemode
	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
end

function GM:DrawOverlay()
	//local w, h = ScrW(), ScrH()	
end

local dishudnf = false
local wasdisabled = false

function GM:SLCShouldDrawSCPHUD()
	return !hud_disabled and !HUDDrawInfo /*and HUDDrawSpawnInfo < CurTime()*/ and !ROUND.preparing
end

function DisableHUDNextFrame()
	dishudnf = true
end

hook.Add( "Think", "SCPHUDThink", function()
	if dishudnf then
		if !hud_disabled then
			wasdisabled = hud_disabled
			hud_disabled = true
		end

		dishudnf = false
	elseif hud_disabled and wasdisabled == false then
		hud_disabled = false
	end
end )

--local eyep, posp
--hook.Add( "PostDrawOpaqueRenderables", "cursortest", function()
	/*if vgui.CursorVisible() then
		if input.IsMouseDown( MOUSE_LEFT ) then
			local x, y = input.GetCursorPos()
			local vec = gui.ScreenToVector( x, y )
			//local vec = util.AimVector( LocalPlayer():EyeAngles(), LocalPlayer():GetFOV(), x, y, ScrW(), ScrH() )
			print( vec:Angle() )
			local eye = LocalPlayer():EyePos()
			local pos = eye + vec * 400

			eyep = eye
			posp = pos
		end
	end

	if eyep then
		render.DrawLine( eyep, posp )
	end*/
--end )