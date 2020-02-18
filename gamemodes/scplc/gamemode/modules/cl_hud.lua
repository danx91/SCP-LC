--[[-------------------------------------------------------------------------
This part of code was requested by "HUD is too big!11!!!1!"" users
---------------------------------------------------------------------------]]
local hudscales = {
	normal = 1,
	small = 0.9,
	vsmall = 0.75,
	imretard = 0.5,
}

local hudscalecvar = CreateClientConVar( "cvar_slc_hud_scale", 1, true )

concommand.Add( "slc_hud_scale", function( ply, cmd, args )
	local size = args[1]

	if !size or size == "" or !hudscales[size] then
		print( "Unknown HUD size! Available sizes: normal, small, vsmall, imretard" )
		return
	end

	RunConsoleCommand( "cvar_slc_hud_scale", hudscales[size] )
end )
--[[-------------------------------------------------------------------------
End of useless code
---------------------------------------------------------------------------]]

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
	mag = Material( "slc_hud/magicon.png" ),
	ammo = Material( "slc_hud/ammoicon.png" ),
	battery = Material( "slc_hud/battery.png" ),
	blink = Material( "slc_hud/blink" ),
	sprint = Material( "slc_hud/sprint" ),
	hp = Material( "slc_hud/hp" ),
	sanity = Material( "slc_hud/sanityicon.png" ),
	xp = Material( "slc_hud/xpicon.png" ),
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
	next_frame = true
	local w, h = ScrW(), ScrH()

	if w != last_width then
		print( "Screen resolution changed! Rebuilding fonts..." )
		last_width = w
		RebuildFonts()
	end

	for i, v in rpairs( SCPMarkers ) do
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

	if HUDDrawSpawnInfo > CurTime() and !ROUND.post then
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
	local drawtarget = IsValid( spectarget ) and ROUND.active
	local pnum = player.GetCount()
	local showtime = pnum > 1 and ROUND.active

	local scale = hudscalecvar:GetFloat()
	if !isspec and scale < 1 then
		local mx = Matrix()

		mx:Translate( Vector( 0, h * ( 1 - scale ), 0 ) )
		mx:Scale( Vector( scale, scale, 1 ) )

		cam.PushModelMatrix( mx )
	end

	surface.SetMaterial( MATS.blur )

	render.UpdateScreenEffectTexture()
	MATS.blur:SetFloat( "$blur", 8 )

	if !recomputed then
		recomputed = true
		MATS.blur:Recompute()
	end

	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	draw.NoTexture()

	local start = h * 0.01

	if !isspec then
		--surface.DrawRect( start - 2, h * 0.765 - 2, w * 0.3 + 4, h * 0.225 + 4 )
		surface.DrawPoly{
			{ x = start - 2, y = h * 0.75 - 2 },
			{ x = start + w * 0.275 + 2, y = h * 0.75 - 2 },
			{ x = start + w * 0.35 + 3, y = h * 0.99 + 2 },
			{ x = start - 2, y = h * 0.99 + 2 }
		}
	else
		if drawtarget then
			surface.DrawRect( w * 0.4 - 2, h * 0.06 + 8, w * 0.2 + 4, h * 0.05 + 4 )
		end

		if showtime then
			surface.DrawRect( w * 0.45 - 2, 8, w * 0.1 + 4, h * 0.05 + 4 )
		end
	end

	if scale == 1 then
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
				{ x = start, y = h * 0.75 },
				{ x = start + w * 0.275, y = h * 0.75 },
				{ x = start + w * 0.35, y = h * 0.99 },
				{ x = start, y = h * 0.99 }
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
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( 0, 0, w, h )

		render.SetStencilEnable( false )
		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
	else
		surface.SetDrawColor( Color( 0, 0, 0, 235 ) )
	end

	if !isspec then
		draw.NoTexture()
		surface.DrawPoly{
			{ x = start, y = h * 0.75 },
			{ x = start + w * 0.275, y = h * 0.75 },
			{ x = start + w * 0.35, y = h * 0.99 },
			{ x = start, y = h * 0.99 }
		}
	else
		if drawtarget then
			surface.DrawRect( w * 0.4, h * 0.06 + 10, w * 0.2, h * 0.05 )
		end

		if showtime then
			surface.DrawRect( w * 0.45, 10, w * 0.1, h * 0.05 )
		end
	end

	local time = ROUND.time > 0 and string.ToMinutesSeconds( ROUND.time - CurTime() ) or "00:00"

	if isspec then
		if drawtarget then
			draw.LimitedText{
				text = string.sub( spectarget:Nick(), 1, 36 ),
				pos = {  w * 0.5, 10 + h * 0.085 },
				color = Color( 255, 255, 255, 100 ),
				font = "SCPHUDBig",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = w * 0.2 - start,
			}
		end

		if showtime then
			draw.Text{
				text = time,
				pos = {  w * 0.5, 10 + h * 0.025 },
				color = Color( 255, 255, 255, 100 ),
				font = "SCPHUDBig",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		return
	end

	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawRect( start + w * 0.025, h * 0.795, w * 0.235, 2 )

	draw.LimitedText{
		text = string.sub( ply:Nick(), 1, 24 ),
		pos = { start + w * 0.0875, h * 0.773 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPHUDBig",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		max_width = w * 0.175 - start
	}

	surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
	surface.DrawRect( start + w * 0.175, h * 0.76, 2, h * 0.025 )

	draw.Text{
		text = string.sub( time, 1, 23 ),
		pos = { start + w * 0.225, h * 0.773 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPNumbersBig",
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
		{ start + w * 0.01, h * 0.81 },
		{ start + w * 0.275, h * 0.81 },
		{ start + w * 0.275 + xoffset, h * 0.845 },
		{ start + w * 0.01 + xoffset, h * 0.845 },
	} )

	local bar_out = SimpleMatrix( 2, 4, {
		{ start + w * 0.01 - 4, h * 0.81 - 2 },
		{ start + w * 0.275 + 2, h * 0.81 - 2 },
		{ start + w * 0.275 + xoffset + 4, h * 0.845 + 2 },
		{ start + w * 0.01 + xoffset - 2, h * 0.845 + 2 },
	} )

	local bar_offset = SimpleMatrix( 2, 4, {
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
		{ xoffset + cxo, h * 0.05 },
	} )

	local xico = ratio * ( h * 0.025 )

	local ico = SimpleMatrix( 2, 4, {
		{ start + w * 0.015, h * 0.815 },
		{ start + w * 0.025, h * 0.815 },
		{ start + w * 0.025 + xico, h * 0.84 },
		{ start + w * 0.015 + xico, h * 0.84 },
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

	local cur = HUDNextBlink - CurTime()
	if HUDBlink > 0 and cur > 0 then
		local width = cur / HUDBlink * w * 0.255

		draw.NoTexture()	
		surface.DrawPoly{
			{ x = start + w * 0.015, y = h * 0.815 },
			{ x = start + w * 0.015 + width, y = h * 0.815 },
			{ x = start + w * 0.015 + width + xico, y = h * 0.84 },
			{ x = start + w * 0.015 + xico, y = h * 0.84 },
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

		if mxButton( bar, bw, bh ) > 0 then
			shownum = stamina
			maxshow = 100
			showtext = LANG.HUD.stamina
		end
	end

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial( MATS.sprint )
	surface.DrawTexturedRect( h * -0.005 + w * 0.1475 + 2 * (xoffset + cxo), h * 0.9125, h * 0.03, h * 0.03 )

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
			{ x = start + w * 0.01 - 4, y = h * 0.86 - 2 },
			{ x = start + w * 0.01 - 4 + xoffset, y = h * 0.86 - 2 },
			{ x = start + w * 0.01 - 4 + xo, y = h * 0.945 + 2 },
			{ x = start + w * 0.01 - 4, y = h * 0.945 + 2 },
		}
		surface.DrawPoly( bat )

		draw.Text{
			text = battery.."%",
			pos = { start + w * 0.01, h * 0.945 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPNumbersSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_BOTTOM,
		}

		PushFilters( TEXFILTER.LINEAR )
			surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
			surface.SetMaterial( MATS.battery )
			surface.DrawTexturedRect( h * -0.02 + w * 0.01 + xo * 0.5 - 4, h * 0.94, h * 0.06, h * 0.06 )
		PopFilters()
	end

	--AMMO
	if IsValid( wep ) and wep:GetMaxClip1() > 0 then
		PushFilters( TEXFILTER.LINEAR )
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.SetMaterial( MATS.ammo )
			surface.DrawTexturedRect( start + w * 0.075, h * 0.9575, h * 0.025, h * 0.025 )

			draw.Text{
				text = string.sub( ply:GetAmmoCount( wep:GetPrimaryAmmoType() ), 1, 23 ),
				pos = { start + w * 0.1, h * 0.97 },
				color = Color( 255, 255, 255, 100 ),
				font = "SCPNumbersBig",
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.SetMaterial( MATS.mag )
			surface.DrawTexturedRect( start + w * 0.21, h * 0.9575, h * 0.025, h * 0.025 )

			draw.Text{
				text = string.sub( wep:Clip1(), 1, 23 ),
				pos = { start + w * 0.235, h * 0.97 },
				color = Color( 255, 255, 255, 100 ),
				font = "SCPNumbersBig",
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

		PopFilters()
	end

	--More info
	if HUDDrawInfo or HUDDrawSpawnInfo > CurTime() or ROUND.post then
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		draw.NoTexture()

		surface.DrawPoly{
			{ x = start + w * 0.285 - 3, y = h * 0.75 - 2 },
			{ x = start + w * 0.55 + 2 + h * 0.03, y = h * 0.75 - 2 },
			{ x = start + w * 0.625 + 3 + h * 0.03, y = h * 0.99 + 2 },
			{ x = start + w * 0.36 - 2, y = h * 0.99 + 2 }
		}

		if scale == 1 then
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
				{ x = start + w * 0.285, y = h * 0.75 },
				{ x = start + w * 0.55 + h * 0.03, y = h * 0.75 },
				{ x = start + w * 0.625 + h * 0.03, y = h * 0.99 },
				{ x = start + w * 0.36, y = h * 0.99 }
			}

			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilPassOperation( STENCIL_REPLACE )

			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.DrawTexturedRect( 0, 0, w, h )

			render.SetStencilEnable( false )
			surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		else
			surface.SetDrawColor( Color( 0, 0, 0, 235 ) )
		end

		draw.NoTexture()
		surface.DrawPoly{
			{ x = start + w * 0.285, y = h * 0.75 },
			{ x = start + w * 0.55 + h * 0.03, y = h * 0.75 },
			{ x = start + w * 0.625 + h * 0.03, y = h * 0.99 },
			{ x = start + w * 0.36, y = h * 0.99 }
		}

		local start = h * 0.01 + w * 0.285

		local _, th = draw.Text{
			text = LANG.HUD.class..":",
			pos = { start + w * 0.02, h * 0.75 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDVSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}

		local class = ply:SCPClass()
		draw.LimitedText{
			text = LANG.CLASSES[class] or class,
			pos = { start + w * 0.04, h * 0.75 + th * 0.75 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
			max_width = w * 0.1125
		}
		
		local _, th = draw.Text{
			text = LANG.HUD.team..":",
			pos = { start + w * 0.1525, h * 0.75 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDVSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}

		local tname = SCPTeams.getName( ply:SCPTeam() )
		draw.LimitedText{
			text = LANG.TEAMS[tname] or tname,
			pos = { start + w * 0.1725, h * 0.75 + th * 0.75 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDMedium",
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
			{ start, h * 0.81 },
			{ start + w * 0.265, h * 0.81 },
			{ start + w * 0.265 + xoffset, h * 0.845 },
			{ start + xoffset, h * 0.845 },
		} )

		local bar_out = SimpleMatrix( 2, 4, {
			{ start - 4, h * 0.81 - 2 },
			{ start + w * 0.265 + 2, h * 0.81 - 2 },
			{ start + w * 0.265 + xoffset + 4, h * 0.845 + 2 },
			{ start + xoffset - 2, h * 0.845 + 2 },
		} )

		local ico = SimpleMatrix( 2, 4, {
			{ start + ixo + w * 0.004, h * 0.815 },
			{ start + ixo + w * 0.014, h * 0.815 },
			{ start + ixo + w * 0.014 + xico, h * 0.84 },
			{ start + ixo + w * 0.004 + xico, h * 0.84 },
		} )

		--SANITY
		draw.NoTexture()
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

		local san = ply:GetSanity()
		local maxsan = ply:GetMaxSanity()
		local segments = math.min( math.ceil( san / maxsan * 20 ), 20 )

		local nico = SimpleMatrix( 2, 4, ico )

		for i = 1, segments do
			surface.SetDrawColor( Color( 100, 100, 150, 175 ) )

			surface.DrawPoly( nico:ToPoly() )
			nico = nico + ico_offset
		end

		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.SetMaterial( MATS.sanity )
		surface.DrawTexturedRect( start + w * 0.1325 - h * 0.015, h * 0.8125, h * 0.03, h * 0.03 )

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
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

		local xp = ply:SCPExp()
		local maxxp = CVAR.levelxp:GetInt()
		if xp > 0 then
			local s = start + xoffset + cxo + ixo + w * 0.004
			local width = w * 0.257 * ( xp / maxxp )

			draw.NoTexture()
			surface.SetDrawColor( Color( 175, 152, 0, 175 ) )
			surface.DrawPoly{
				{ x = s, y = h * 0.865 },
				{ x = s + width, y = h * 0.865 },
				{ x = s + width + xico, y = h * 0.89 },
				{ x = s + xico, y = h * 0.89 },
			}
		end

		if mxButton( bar, bw, bh ) > 0 then
			shownum = xp
			maxshow = maxxp
			showtext = LANG.HUD.xp
		end

		PushFilters( TEXFILTER.LINEAR )
			surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
			surface.SetMaterial( MATS.xp )
			surface.DrawTexturedRect( start + xoffset + cxo + w * 0.1325 - h * 0.02, h * 0.8575, h * 0.04, h * 0.04 )
		PopFilters()

		draw.Text{
			text = LANG.HUD.prestige_points..":\t"..ply:SCPPrestigePoints(),
			pos = { start + (cxo + xoffset) * 2 + w * 0.01, h * 0.91 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	if maxshow > 0 then
		local text = string.format( "%i / %i  %s", shownum, maxshow, showtext or "" )
		local tw, th = draw.TextSize( text, "SCPHUDSmall" )

		local x, y = input.GetCursorPos()

		x = x + 5
		y = y + 5

		surface.SetDrawColor( Color( 180, 180, 180, 255 ) )
		surface.DrawRect( x - 2, y - 2, tw + 12, th + 12 )

		surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
		surface.DrawRect( x, y, tw + 8, th + 8 )

		draw.Text{
			text = text,
			pos = { x + 4, y + 4 },
			color = Color( 200, 200, 200, 255 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	if !isspec and scale < 1 then
		cam.PopModelMatrix()
	end

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

		local text = LANG.HUD.pickup

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

	--From base gamemode
	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
end

function GM:DrawOverlay()
	//local w, h = ScrW(), ScrH()	
end

local dishudnf = false
local wasdisabled = false

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