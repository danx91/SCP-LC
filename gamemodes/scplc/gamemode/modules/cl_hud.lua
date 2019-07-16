local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudWeaponSelection = true,
}

hook.Add( "HUDShouldDraw", "HideDefaultHUD", function( name )
	if hide[name] then return false end
end )

function GM:DrawDeathNotice( x,  y )
end

local MATS = {
	blur = Material( "pp/blurscreen" ),
	mag = Material( "hud_scp/magicon.png" ),
	ammo = Material( "hud_scp/ammoicon.png" ),
	battery = Material( "hud_scp/battery.png" ),
	blink = Material( "hud_scp/blink" ),
	sprint = Material( "hud_scp/sprint" ),
	hp = Material( "hud_scp/hp" ),
}

local ammo_color = {
	Color( 255, 255, 255, 200 ),
	Color( 200, 200, 255, 200 ),
	Color( 200, 255, 200, 200 ),
	Color( 255, 200, 200, 200 ),
}

SCPMarkers = {}
HUDDrawSpawnInfo = 0
hud_disabled = false
HUDDrawInfo = false
HUDBlink = 1
HUDNextBlink = 0
HUDPickupHint = false

local recomputed = false
local last_width = ScrW()

function GM:HUDPaint()
	local w, h = ScrW(), ScrH()

	if w != last_width then
		print( "Screen resolution changed! Rebuilding fonts..." )
		last_width = w
		RebuildFonts()
	end

	for i, v in ipairs( SCPMarkers ) do
		local scr = v.data.pos:ToScreen()

		if scr.visible then
			surface.SetDrawColor( Color( 255, 100, 100, 200 ) )
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
				color = Color( 255, 100, 100, 200 ),
				pos = { scr.x, scr.y + 10 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )

			draw.Text( {
				text = math.Round( v.data.pos:Distance( LocalPlayer():GetPos() ) * 0.019 ) .. "m",
				font = "SCPHUDSmall",
				color = Color( 255, 100, 100, 200 ),
				pos = { scr.x, scr.y + 10 + th },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )
		end

		if v.time < CurTime() then
			table.remove( SCPMarkers, i )
		end
	end

	if HUDDrawSpawnInfo > CurTime() then
		local ply = LocalPlayer()

		local team = ply:SCPTeam()
		local class = ply:SCPClass()
		local color = SCPTeams.getColor( team )

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
	end

	if hud_disabled then return end
	local ply = LocalPlayer()

	local isspec = ply:SCPTeam() == TEAM_SPEC
	local spectarget = ply:GetObserverTarget()
	local targetvalid = IsValid( spectarget )

	surface.SetMaterial( MATS.blur )

	render.UpdateScreenEffectTexture()
	MATS.blur:SetFloat( "$blur", 8 )

	if !recomputed then
		recomputed = true
		MATS.blur:Recompute()
	end

	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	draw.NoTexture()

	if !isspec then
		--surface.DrawRect( h * 0.01 - 2, h * 0.765 - 2, w * 0.3 + 4, h * 0.225 + 4 )
		surface.DrawPoly{
			{ x = h * 0.01 - 2, y = h * 0.75 - 2 },
			{ x = h * 0.01 + w * 0.275 + 2, y = h * 0.75 - 2 },
			{ x = h * 0.01 + w * 0.35 + 3, y = h * 0.99 + 2 },
			{ x = h * 0.01 - 2, y = h * 0.99 + 2 }
		}
	elseif targetvalid then
		surface.DrawRect( w * 0.4 - 2, 8, w * 0.2 + 4, h * 0.05 + 4 )
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
		//surface.DrawRect( h * 0.01, h * 0.765, w * 0.3, h * 0.225 )
		surface.DrawPoly{
			{ x = h * 0.01, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.275, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.35, y = h * 0.99 },
			{ x = h * 0.01, y = h * 0.99 }
		}
	elseif targetvalid then
		surface.DrawRect( w * 0.4, 10, w * 0.2, h * 0.05 )
	end

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	surface.SetMaterial( MATS.blur )
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.DrawTexturedRect( 0, 0, w, h )

	render.SetStencilEnable( false )

	surface.SetDrawColor( Color( 0, 0, 0, 150 ) )

	if !isspec then
		draw.NoTexture()
		surface.DrawPoly{
			{ x = h * 0.01, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.275, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.35, y = h * 0.99 },
			{ x = h * 0.01, y = h * 0.99 }
		}
	elseif targetvalid then
		surface.DrawRect( w * 0.4, 10, w * 0.2, h * 0.05 )
	end

	if targetvalid then
		draw.LimitedText{
			text = string.sub( spectarget:Nick(), 1, 36 ),
			pos = {  w * 0.5, 10 + h * 0.025 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.2 - h * 0.01,
		}
	end

	if isspec then return end

	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawRect( h * 0.01 + w * 0.025, h * 0.795, w * 0.235, 2 )

	draw.LimitedText{
		text = string.sub( ply:Nick(), 1, 24 ),
		pos = { h * 0.01 + w * 0.0875, h * 0.773 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPHUDBig",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		max_width = w * 0.175 - h * 0.01
	}

	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawRect( h * 0.01 + w * 0.175, h * 0.76, 2, h * 0.025 )

	local time = ROUND.time > 0 and string.ToMinutesSeconds( ROUND.time - CurTime() ) or "00:00"

	draw.Text{
		text = string.sub( time, 1, 23 ),
		pos = { h * 0.01 + w * 0.225, h * 0.773 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPNumbersBig",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	local ratio = (w * 0.075) / (h * 0.24)
	local xoffset = ratio * h * 0.035
	local cxo = ratio * h * 0.015

	local bar = SimpleMatrix( 2, 4, {
		{ h * 0.01 + w * 0.01, h * 0.81 },
		{ h * 0.01 + w * 0.275, h * 0.81 },
		{ h * 0.01 + w * 0.275 + xoffset, h * 0.845 },
		{ h * 0.01 + w * 0.01 + xoffset, h * 0.845 },
	} )

	local bar_out = SimpleMatrix( 2, 4, {
		{ h * 0.01 + w * 0.01 - 4, h * 0.81 - 2 },
		{ h * 0.01 + w * 0.275 + 2, h * 0.81 - 2 },
		{ h * 0.01 + w * 0.275 + xoffset + 4, h * 0.845 + 2 },
		{ h * 0.01 + w * 0.01 + xoffset - 2, h * 0.845 + 2 },
	} )

	local bar_offset = SimpleMatrix( 2, 4, {
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
	} )

	local xico = ratio * ( h * 0.025 )

	local ico = SimpleMatrix( 2, 4, {
		{ h * 0.01 + w * 0.015, h * 0.815 },
		{ h * 0.01 + w * 0.025, h * 0.815 },
		{ h * 0.01 + w * 0.025 + xico, h * 0.84 },
		{ h * 0.01 + w * 0.015 + xico, h * 0.84 },
	} )

	local ico_offset = SimpleMatrix( 2, 4, {
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
		{ w * 0.013, 0 },
	} )

	draw.NoTexture()

	--BLINK
	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	/*local nico = SimpleMatrix( 2, 4, ico )
	local segments = ( HUDNextBlink - CurTime() ) / HUDBlink * 20

	if segments > 0 then
		surface.SetDrawColor( Color( 125, 125, 125, 175 ) )
		for i = 1, segments do
			surface.DrawPoly( nico:ToPoly() )
			nico = nico + ico_offset
		end
	end*/

	local cur = HUDNextBlink - CurTime()
	if HUDBlink > 0 and cur > 0 then
		local width = cur / HUDBlink * w * 0.265

		draw.NoTexture()	
		surface.DrawPoly{
			{ x = h * 0.01 + w * 0.015, y = h * 0.815 },
			{ x = h * 0.01 + w * 0.005 + width, y = h * 0.815 },
			{ x = h * 0.01 + w * 0.005 + width + xico, y = h * 0.84 },
			{ x = h * 0.01 + w * 0.015 + xico, y = h * 0.84 },
		}
	end

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial( MATS.blink )
	surface.DrawTexturedRect( h * -0.01 + w * 0.1475, h * 0.8075, h * 0.04, h * 0.04 )

	--HP
	bar = bar + bar_offset
	bar_out = bar_out + bar_offset
	ico = ico + bar_offset

	draw.NoTexture()
	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	local hp = ply:Health()
	local maxhp = ply:GetMaxHealth()

	local hpperseg = maxhp / 20
	local segments = math.min( math.ceil( hp / maxhp * 20 ), 20 )

	local intense = 1 - segments + hp / hpperseg
	local nico = SimpleMatrix( 2, 4, ico )

	if intense > 1 then
		intense = 1
	end

	for i = 1, segments do
		if i == segments then
			surface.SetDrawColor( Color( 175, 0, 25, 175 * intense ) )
		else
			surface.SetDrawColor( Color( 175, 0, 25, 175 ) )
		end

		surface.DrawPoly( nico:ToPoly() )
		nico = nico + ico_offset
	end

	surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
	surface.SetMaterial( MATS.hp )
	surface.DrawTexturedRect( h * -0.005 + w * 0.1475 + xoffset + cxo, h * 0.8625, h * 0.03, h * 0.03 )
	
	//surface.SetDrawColor( Color( 150, 150, 150, 100 ) )

	--STAMINA
	bar = bar + bar_offset
	bar_out = bar_out + bar_offset
	ico = ico + bar_offset

	draw.NoTexture()
	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

	if ply.Stamina then
		local stamina = ply.Stamina
		local segments = math.min( math.ceil( stamina * 0.2 ), 20 )

		//local intense = 1 //- segments + stamina / 5
		local nico = SimpleMatrix( 2, 4, ico )

		for i = 1, segments do
			if ply.Exhausted then
				surface.SetDrawColor( Color( 75, 125, 25, 75 ) )
			else
				surface.SetDrawColor( Color( 150, 175, 0, 175 ) )
			end

			surface.DrawPoly( nico:ToPoly() )
			nico = nico + ico_offset
		end
	end

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial( MATS.sprint )
	surface.DrawTexturedRect( h * -0.005 + w * 0.1475 + 2 * (xoffset + cxo), h * 0.9125, h * 0.03, h * 0.03 )

	--BATTERY
	if false then --TODO battery
		local battery = 76
		local pct = battery / 100

		draw.NoTexture()
		surface.SetDrawColor( Color( (1 - pct) * 200, pct * 200, 0, 50 ) )

		local xo = ratio * ( h * 0.12 )
		local bat = {
			{ x = h * 0.01 + w * 0.01 - 4, y = h * 0.86 - 2 },
			{ x = h * 0.01 + w * 0.01 - 4 + xoffset, y = h * 0.86 - 2 },
			{ x = h * 0.01 + w * 0.01 - 4 + xo, y = h * 0.945 + 2 },
			{ x = h * 0.01 + w * 0.01 - 4, y = h * 0.945 + 2 },
		}
		surface.DrawPoly( bat )

		draw.Text{
			text = battery.."%",
			pos = { h * 0.01 + w * 0.01, h * 0.945 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPNumbersSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_BOTTOM,
		}

		render.PushFilterMag( TEXFILTER.LINEAR )
		render.PushFilterMin( TEXFILTER.LINEAR )

		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.SetMaterial( MATS.battery )
		surface.DrawTexturedRect( h * -0.02 + w * 0.01 + xo * 0.5 - 4, h * 0.94, h * 0.06, h * 0.06 )

		render.PopFilterMag()
		render.PopFilterMin()
	end

	--AMMO
	local wep = ply:GetActiveWeapon()

	if IsValid( wep ) and wep:GetMaxClip1() > 0 then
		render.PushFilterMag( TEXFILTER.LINEAR )
		render.PushFilterMin( TEXFILTER.LINEAR )

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( MATS.ammo )
		surface.DrawTexturedRect( h * 0.01 + w * 0.075, h * 0.9575, h * 0.025, h * 0.025 )

		draw.Text{
			text = string.sub( ply:GetAmmoCount( wep:GetPrimaryAmmoType() ), 1, 23 ),
			pos = { h * 0.01 + w * 0.1, h * 0.97 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPNumbersBig",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( MATS.mag )
		surface.DrawTexturedRect( h * 0.01 + w * 0.21, h * 0.9575, h * 0.025, h * 0.025 )

		draw.Text{
			text = string.sub( wep:Clip1(), 1, 23 ),
			pos = { h * 0.01 + w * 0.235, h * 0.97 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPNumbersBig",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}

		render.PopFilterMag()
		render.PopFilterMin()
	end

	--Hint
	if HUDPickupHint then
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

		surface.SetDrawColor( Color( 115, 115, 115, 215 ) )
		--surface.SetDrawColor( Color( 175, 175, 175, 255 ) )
		surface.DrawRect( w * 0.485 - tw * 0.5, h * 0.75 - th * 0.5 - w * 0.015, w * 0.03 + tw, w * 0.03 + th )

		surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
		--surface.SetDrawColor( Color( 125, 125, 125, 255 ) )
		surface.DrawRect( w * 0.49 - tw * 0.5, h * 0.75 - th * 0.5 - w * 0.01, w * 0.02 + tw, w * 0.02 + th )

		draw.Text{
			text = key,
			pos = { w * 0.5, h * 0.75 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		local text = LANG.pickup

		local t = type( HUDPickupHint )
		if t == "table" or  t == "Weapon" then
			if HUDPickupHint.PrintName then
				text = HUDPickupHint.PrintName
			elseif HUDPickupHint.GetPrintName then
				text = HUDPickupHint:GetPrintName()
			end
		end

		draw.Text{
			text = text,
			pos = { w * 0.5, h * 0.75 - th - w * 0.02 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		HUDPickupHint = nil
	end

	--More info
	if HUDDrawInfo or HUDDrawSpawnInfo > CurTime() then
		--render.UpdateScreenEffectTexture()
		surface.SetMaterial( MATS.blur )

		/*render.UpdateScreenEffectTexture()
		MATS.blur:SetFloat( "$blur", 8 )

		if !recomputed then
			recomputed = true
			MATS.blur:Recompute()
		end*/

		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		draw.NoTexture()

		surface.DrawPoly{
			{ x = h * 0.01 + w * 0.285 - 3, y = h * 0.75 - 2 },
			{ x = h * 0.01 + w * 0.625 + 2, y = h * 0.75 - 2 },
			{ x = h * 0.01 + w * 0.7 + 3, y = h * 0.99 + 2 },
			{ x = h * 0.01 + w * 0.36 - 2, y = h * 0.99 + 2 }
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
			{ x = h * 0.01 + w * 0.285, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.625, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.7, y = h * 0.99 },
			{ x = h * 0.01 + w * 0.36, y = h * 0.99 }
		}

		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilPassOperation( STENCIL_REPLACE )

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( 0, 0, w, h )

		render.SetStencilEnable( false )

		draw.NoTexture()
		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		surface.DrawPoly{
			{ x = h * 0.01 + w * 0.285, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.625, y = h * 0.75 },
			{ x = h * 0.01 + w * 0.7, y = h * 0.99 },
			{ x = h * 0.01 + w * 0.36, y = h * 0.99 }
		}

		--TODO
		--SANITY
		/*draw.Text{
			text = string.sub( wep:Clip1(), 1, 23 ),
			pos = { h * 0.01 + w * 0.235, h * 0.97 },
			color = Color( 255, 255, 255, 100 ),
			font = "bShopImpactMedium",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}*/

		--EXP

		--INFO CLASS
		--INFO LEVEL
		--

		draw.Text{
			text = "DEV INFO:",
			pos = { w * 0.36, h * 0.775 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.Text{
			text = "xp: "..ply:SCPExp(),
			pos = { w * 0.4, h * 0.8 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
		draw.Text{
			text = "team: "..ply:SCPTeam().." ["..SCPTeams.getName( ply:SCPTeam() ).."]",
			pos = { w * 0.4, h * 0.825 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
		draw.Text{
			text = "class: "..ply:SCPClass(),
			pos = { w * 0.4, h * 0.85 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	--surface.SetDrawColor( Color( math.TimedSinWave( 0.5, 0, 255 ), math.TimedSinWave( 0.1, 0, 255 ), math.TimedSinWave( 0.25, 0, 255 ), 255 ) )
	--surface.SetMaterial( MATS.watermark )
	--surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, h * 0.25 * math.TimedSinWave( 0.5, 1, 2 ), h * 0.25 * math.TimedSinWave( 0.75, 1, 2 ), math.TimedSinWave( 0.25, -45, 45 ) )

	//local wep = ply:GetActiveWeapon()

	-- if IsValid( wep ) then
	-- 	local maxammo = 27

	-- 	local clip = wep:GetMaxClip1()
	-- 	if clip < 1 then return end

	-- 	local cmul = clip

	-- 	local rot = math.deg( math.atan( ratio ) )

	-- 	render.PushFilterMag( TEXFILTER.LINEAR )
	-- 	render.PushFilterMin( TEXFILTER.LINEAR )

	-- 	surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
	-- 	surface.SetMaterial( MATS.bullet )
	-- 	for i = 1, maxammo  do
	-- 		surface.DrawTexturedRectRotated( h * 0.01 + w * 0.01 + 3 * xoffset + 2 * cxo + h * (i * 0.0175), h * 0.97, h * 0.035, h * 0.035, rot )
	-- 	end

	-- 	render.PopFilterMag()
	-- 	render.PopFilterMin()
	-- end

	--From base gamemode
	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
end

function GM:DrawOverlay()
	local w, h = ScrW(), ScrH()	
end

local dishudnf = false
local wasdisabled = false

function DisableHUDNextFrame()
	dishudnf = true
end

hook.Add( "Tick", "SCPHUDTick", function()
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