--[[-------------------------------------------------------------------------
Locals
---------------------------------------------------------------------------]]
local ease_out, ease_in_out
//local main_poly, main_outline_poly
--[[-------------------------------------------------------------------------
Colors
---------------------------------------------------------------------------]]
local color_white = Color( 255, 255, 255 )
local color_pulse = Color( 255, 255, 255 ) --Don't change! It's changed by code anyway
local color_blink = Color( 175, 175, 175 )
local color_sanity = Color( 79, 82, 235 )
local color_extra_hp = Color( 160, 230, 40 )

--[[-------------------------------------------------------------------------
Materials
---------------------------------------------------------------------------]]
local mat_main = Material( "slc/hud/skin_default/hud_main.png", "smooth" )
local mat_waiting = Material( "slc/hud/skin_default/hud_waiting.png", "smooth" )
local mat_time = Material( "slc/hud/skin_default/hud_time.png", "smooth" )
local mat_target = Material( "slc/hud/skin_default/hud_target.png", "smooth" )
local mat_ammo = Material( "slc/hud/skin_default/ammo3.png", "smooth" )
local mat_stamina = Material( "slc/hud/skin_default/hud_stamina.png", "smooth" )
local mat_stamina_bar = Material( "slc/hud/skin_default/hud_stamina_bar.png", "smooth" )
local mat_hp_out = Material( "slc/hud/skin_default/health_out.png", "smooth" )
local mat_hp_bar = Material( "slc/hud/skin_default/health_bar.png", "smooth" )
local mat_battery = Material( "slc/hud/skin_default/battery.png", "smooth" )
local mat_no_battery = Material( "slc/hud/skin_default/no_battery.png", "smooth" )
local mat_battery_1 = Material( "slc/hud/skin_default/battery_1.png", "smooth" )
local mat_battery_2 = Material( "slc/hud/skin_default/battery_2.png", "smooth" )
local mat_battery_3 = Material( "slc/hud/skin_default/battery_3.png", "smooth" )
local mat_battery_4 = Material( "slc/hud/skin_default/battery_4.png", "smooth" )
local mat_eye = Material( "slc/hud/skin_default/eye.png", "smooth" )
local mat_sanity = Material( "slc/hud/skin_default/sanity.png", "smooth" )
local mat_sprint = Material( "slc/hud/skin_default/sprint.png", "smooth" )

local main_ratio = mat_main:Width() / mat_main:Height()
local waiting_ratio = mat_waiting:Width() / mat_waiting:Height()
local time_ratio = mat_time:Width() / mat_time:Height()
local target_ratio = mat_target:Width() / mat_target:Height()
local stamina_ratio = mat_stamina:Width() / mat_stamina:Height()
local battery_ratio = mat_battery:Width() / mat_battery:Height()
local ammo_ratio = mat_ammo:Width() / mat_ammo:Height()
local ammo_to_main_ratio = mat_ammo:Height() / mat_main:Height()

--[[-------------------------------------------------------------------------
Convenience function to check if cursor is within specified bounds
---------------------------------------------------------------------------]]
/*local function mouse_within( x, y, w, h, mx, my )
	mx = mx or gui.MouseX()
	my = my or gui.MouseY()

	return mx >= x and mx <= x + w and my >= y and my <= y + my
end*/

--[[-------------------------------------------------------------------------
HUD functions
---------------------------------------------------------------------------]]
local function pre_draw_hud()
	--Empty
end

local function draw_admin_text( txt, dx, dy )
	return draw.SimpleText( txt, "SCPHUDMedium", dx, dy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

local function draw_admin_hud()
	local target = LocalPlayer():GetObserverTarget()
	if !IsValid( target ) then return end

	local w, h = ScrW(), ScrH()
	
	local admin_w = w * 0.3
	local admin_h = h * 0.5
	local mat_h = admin_w / target_ratio

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_target )
	surface.DrawTexturedRect( ( w - admin_w ) * 0.5, ( h - admin_h ) * 0.5, admin_w, mat_h )
	surface.DrawTexturedRectRotated( w * 0.5, ( h + admin_h - mat_h ) * 0.5, admin_w, mat_h, 180 )

	local _, th
	local dx, dy = ( w - admin_w ) * 0.5 + w * 0.04, ( h - admin_h ) * 0.5 + h * 0.02

	_, th = draw_admin_text( "Nick: "..target:Nick(), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "HP: "..target:Health().." / "..target:GetMaxHealth(), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "Score: "..target:Frags(), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "Player ID: "..target:UserID(), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "SteamID: "..target:SteamID(), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "SteamID64: "..target:SteamID64(), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "Level: "..target:SCPLevel().."  ( "..target:SCPExp().." XP )", dx, dy ) dy = dy + th
	_, th = draw_admin_text( "Active: "..tostring( target:IsActive() ), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "Premium: "..tostring( target:IsPremium() ), dx, dy ) dy = dy + th
	_, th = draw_admin_text( "Class: "..target:SCPClass().."  ( "..SCPTeams.GetName( target:SCPTeam() ).." )", dx, dy ) dy = dy + th

	local pc, pt = target:SCPPersona()
	_, th = draw_admin_text( "Fake ID: "..pc.."  ( "..SCPTeams.GetName( pt ).." )", dx, dy ) dy = dy + th
end

local function draw_spectator_hud()
	local w, h = ScrW(), ScrH()
	local scale = GetHUDScale()

	local waiting_h = h * 0.08 * scale
	local waiting_w = waiting_h * waiting_ratio

	if !ROUND.active then
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat_waiting )
		surface.DrawTexturedRect( ( w - waiting_w ) * 0.5, 8, waiting_w, waiting_h )

		local tw = draw.SimpleText( LANG.HUD.waiting, "SCPScaledHUDSmall", w * 0.5, 8 + waiting_h * 0.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( string.rep( ".", math.Round( RealTime() ) % 4 ), "SCPScaledHUDSmall", ( w + tw ) * 0.5, 8 + waiting_h * 0.2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( player.GetCount().." / "..CVAR.slc_min_players:GetInt(), "SCPScaledHUDSmall", w * 0.5, 8 + waiting_h * 0.9, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		return
	end

	local td = ROUND.time - CurTime()
	local time = td > 0 and string.ToMinutesSeconds( td ) or "00:00"

	local time_h = h * 0.06 * scale
	local time_w = time_h * time_ratio

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_time )
	surface.DrawTexturedRect( ( w - time_w ) * 0.5, 8, time_w, time_h )

	draw.SimpleText( time, "SCPScaledHUDMedium", w * 0.5, 8 + time_h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	local ply = LocalPlayer()
	local spectarget = ply:GetObserverTarget()

	if !IsValid( spectarget ) then return end

	local target_h = h * 0.06 * scale
	local target_w = target_h * target_ratio
	local target_y = h - 8 - target_h - ( GetSettingsValue( "hud_windowed_mode" ) and h * 0.0225 or 0 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_target )
	surface.DrawTexturedRect( ( w - target_w ) * 0.5, target_y, target_w, target_h )

	draw.LimitedText{
		text = spectarget:Nick(),
		pos = {  w * 0.5, target_y + target_h * 0.5 },
		color = color_white,
		font = "SCPScaledHUDSmall",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		max_width = target_w * 0.8,
	}
end

local stamina_visible = false
local stamina_pct = 0
local last_stamina = 0
local last_extra_xp = 0

local pulse = 0

local time_visible = false
local time_pct = 0

local function draw_hud()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	local w, h = ScrW(), ScrH()
	local scale = GetHUDScale()
	local ct = CurTime()
	
	local offset_y = GetSettingsValue( "hud_windowed_mode" ) and h * 0.0275 or 0

	local total_h = h * 0.15 * scale
	local total_w = total_h * main_ratio
	local start_x = 8
	local start_y = h - total_h - 8 - offset_y
	local mid_y = start_y + total_h * 0.5

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_main )
	surface.DrawTexturedRect( start_x, start_y, total_w, total_h )

	--[[-------------------------------------------------------------------------
	Nick
	---------------------------------------------------------------------------]]
	draw.LimitedText{
		text = ply:Nick(),
		pos = {  start_x + total_w * 0.4, start_y + total_h * 0.05 },
		color = color_white,
		font = "SCPScaledHUDMedium",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_TOP,
		max_width = total_w * 0.8,
	}

	--[[-------------------------------------------------------------------------
	Health
	---------------------------------------------------------------------------]]
	local hp = ply:Health()
	local max_hp = ply:GetMaxHealth()
	local extra_hp = math.ceil( ply:GetExtraHealth() )
	local max_extra_hp = ply:GetMaxExtraHealth()
	local has_extra_hp = extra_hp > 0 and max_extra_hp > 0 or last_extra_xp > 0

	if hp <  max_hp * ( ply:SCPTeam() == TEAM_SCP and 0.1 or 0.25 ) then
		if pulse <= 0 then
			pulse = 1
		end

		pulse = math.Approach( pulse, 0, RealFrameTime() * 0.5 )
	else
		pulse = 0
	end

	local hp_size = total_h * 0.35
	local hp_x = start_x + total_w * 0.95 - hp_size
	local hp_y = mid_y - hp_size * 0.5

	render.SetScissorRect( hp_x, hp_y + hp_size * ( 1 - hp / max_hp ), hp_x + hp_size, hp_y + hp_size, true )

	surface.SetDrawColor( 195, 30, 30 )
	surface.SetMaterial( mat_hp_bar )
	surface.DrawTexturedRect( hp_x, hp_y, hp_size, hp_size )

	if has_extra_hp then
		local extra_hp_pct = extra_hp / max_extra_hp

		last_extra_xp = Lerp( RealFrameTime() * 4, last_extra_xp, extra_hp_pct )

		if last_extra_xp != last_extra_xp then --NaN protection
			last_extra_xp = extra_hp_pct
		end

		render.SetScissorRect( hp_x, hp_y + hp_size * ( 1 - last_extra_xp ), hp_x + hp_size, hp_y + hp_size, true )

		surface.SetDrawColor( 160, 230, 40 )
		surface.SetMaterial( mat_hp_bar )
		surface.DrawTexturedRect( hp_x, hp_y, hp_size, hp_size )
	end

	render.SetScissorRect( 0, 0, 0, 0, false )

	surface.SetDrawColor( 225, 225, 225 )
	surface.SetMaterial( mat_hp_out )
	surface.DrawTexturedRect( hp_x, hp_y, hp_size, hp_size )

	color_pulse.r = 255
	color_pulse.g = pulse == 0 and 255 or ( 200 - 150 * pulse )
	color_pulse.b = pulse == 0 and 255 or ( 200 - 150 * pulse )

	draw.SimpleText( hp + extra_hp, "SCPScaledNumbersVBig", hp_x - total_w * 0.05, mid_y, has_extra_hp and color_extra_hp or color_pulse, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

	--[[-------------------------------------------------------------------------
	Battery
	---------------------------------------------------------------------------]]
	local has_battery = IsValid( wep ) and wep.HasBattery
	local battery = has_battery and wep:GetBattery() or 0

	if battery < 0 then
		battery = 0
	end

	local bat_h = total_h * 0.25
	local bat_w = bat_h * battery_ratio
	local bat_x = start_x + total_w * 0.05
	local bat_y = mid_y - bat_h * 0.5


	if has_battery then
		local dont_draw = false
		surface.SetDrawColor( 220, 190, 45 )

		if battery == 0 then
			dont_draw = true
		elseif battery <= 25 then
			if battery < 10 and math.floor( RealTime() * 1.5 ) % 2 == 0 then
				dont_draw = true
			else
				surface.SetMaterial( mat_battery_1 )
			end
		elseif battery <= 50 then
			surface.SetMaterial( mat_battery_2 )
		elseif battery <= 75 then
			surface.SetMaterial( mat_battery_3 )
		else
			surface.SetMaterial( mat_battery_4 )
		end

		if !dont_draw then
			surface.DrawTexturedRect( bat_x, bat_y, bat_w, bat_h )
		end

		draw.SimpleText( math.ceil( battery ).."%", "SCPScaledNumbersSmall", bat_x + bat_w + total_w * 0.01, mid_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 225, 225, 225 )
	else
		surface.SetDrawColor( 155, 155, 155, 50 )
	end

	if has_battery and battery == 0 then
		surface.SetMaterial( mat_no_battery )
	else
		surface.SetMaterial( mat_battery )
	end
	
	surface.DrawTexturedRect( bat_x, bat_y, bat_w, bat_h )

	--[[-------------------------------------------------------------------------
	Blink & sanity
	---------------------------------------------------------------------------]]
	local remaining_h = total_h - hp_y - hp_size + start_y --total_h - ((hp_y + hp_size) - start_y)
	local hud_icon_size = remaining_h / 3
	local bar_h = hud_icon_size * 0.5

	local blink_x = start_x + total_w * 0.1
	local blink_y_mid = hp_y + hp_size + hud_icon_size

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_eye )
	surface.DrawTexturedRect( blink_x, blink_y_mid - hud_icon_size * 0.5, hud_icon_size, hud_icon_size )

	local blink_bar_x = blink_x + hud_icon_size + total_w * 0.02
	local blink_bar_w = total_w * 0.9 - blink_bar_x

	local cur_blink = HUDNextBlink - ct
	local blink_pct = math.Clamp( HUDBlink > 0 and cur_blink > 0 and cur_blink / HUDBlink or 1, 0, 1 )

	draw.RoundedBox( bar_h * 0.5, blink_bar_x, blink_y_mid - bar_h * 0.5, blink_bar_w * blink_pct, bar_h, color_blink )

	local sanity_x = start_x + total_w * 0.05
	local sanity_y_mid = blink_y_mid + hud_icon_size

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_sanity )
	surface.DrawTexturedRect( sanity_x, sanity_y_mid - hud_icon_size * 0.5, hud_icon_size, hud_icon_size )

	local sanity_bar_x = sanity_x + hud_icon_size + total_w * 0.02
	local sanity_pct = math.Clamp( ply:GetSanity() / ply:GetMaxSanity(), 0, 1 )

	draw.RoundedBox( bar_h * 0.5, sanity_bar_x, sanity_y_mid - bar_h * 0.5, blink_bar_w * sanity_pct, bar_h, color_sanity )

	--[[-------------------------------------------------------------------------
	Ammo
	---------------------------------------------------------------------------]]
	if IsValid( wep ) and ( wep:GetMaxClip1() > 0 or wep.GetCustomClip ) then
		local ammo_h = total_h * ammo_to_main_ratio - 4
		local ammo_w = ammo_h * ammo_ratio
		local ammo_x = start_x + total_w * 0.847
		local ammo_y = start_y + total_h - ammo_h
		
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat_ammo )
		surface.DrawTexturedRect( ammo_x, ammo_y, ammo_w, ammo_h )
		
		local ammo = wep.GetCustomClip and wep:GetCustomClip() or wep:Clip1()
		local ammo_txt = wep.GetCustomClip and ammo or ( ammo.." / "..ply:GetAmmoCount( wep:GetPrimaryAmmoType() ) )

		draw.SimpleText( ammo_txt, "SCPScaledNumbersSmall", ammo_x + ammo_w * 0.59, ammo_y + ammo_h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		SLC_HUD_END_X = ammo_x + ammo_w
	else
		SLC_HUD_END_X = start_x + total_w
	end

	--[[-------------------------------------------------------------------------
	Stamina
	---------------------------------------------------------------------------]]
	local stamina = ply:GetStamina()
	local max_stamina = ply:GetMaxStamina()
	local boost_time = ply:GetStaminaBoost()
	local boost = boost_time > ct

	last_stamina = Lerp( RealFrameTime() * 6, last_stamina, stamina )
	
	local stamina_h = h * 0.04 * scale
	local stamina_w = stamina_h * stamina_ratio
	local stamina_x = ( w - stamina_w ) * 0.5
	local stamina_y = h - stamina_h - offset_y
	local stamina_alpha = stamina_visible and 255 or 0

	local show = boost or stamina < max_stamina or stamina_pct > 0 and !stamina_visible
	if !show and GetSettingsValue( "hud_stamina_always" ) and ply:GetWalkSpeed() != ply:GetRunSpeed() then
		show = true
	end

	if show and stamina_pct < 1 then
		stamina_pct = math.Approach( stamina_pct, 1, RealFrameTime() / 0.75 )

		if stamina_visible then
			stamina_alpha = Lerp( ease_in_out( stamina_pct ), 0, 255 )
		else
			stamina_alpha = 255
			stamina_y = Lerp( ease_out( stamina_pct ), h, stamina_y )
		end

		if stamina_pct >= 1 then
			stamina_pct = 1
			stamina_visible = true
		end
	elseif !boost and stamina >= max_stamina and stamina_pct > 0 then
		stamina_pct = math.Approach( stamina_pct, 0, RealFrameTime() / 2 )
		stamina_alpha = Lerp( ease_in_out( stamina_pct ), 0, 255 )

		if stamina_pct <= 0 then
			stamina_pct = 0
			stamina_visible = false
		end
	end

	surface.SetDrawColor( 255, 255, 255, stamina_alpha )
	surface.SetMaterial( mat_stamina )
	surface.DrawTexturedRect( stamina_x, stamina_y, stamina_w, stamina_h )

	if stamina_pct > 0 then
		if ply:GetExhausted() then
			surface.SetDrawColor( 170, 125, 0, stamina_alpha * 0.2 )
		else
			surface.SetDrawColor( 75, 125, 25, stamina_alpha * 0.75 )
		end
		surface.SetMaterial( mat_stamina_bar )

		render.SetScissorRect( stamina_x, stamina_y, stamina_x + stamina_w * last_stamina / max_stamina, stamina_y + stamina_h, true )
		surface.DrawTexturedRect( stamina_x, stamina_y, stamina_w, stamina_h )

		if boost then
			surface.SetDrawColor( 40, 115, 225, stamina_alpha * 0.75 )
			render.SetScissorRect( stamina_x, stamina_y, stamina_x + stamina_w * ( boost_time - ct ) / ply:GetStaminaBoostDuration(), stamina_y + stamina_h, true )
			surface.DrawTexturedRect( stamina_x, stamina_y, stamina_w, stamina_h )
		end

		render.SetScissorRect( 0, 0, 0, 0, false )

		local sprint_icon_size = stamina_h * 0.5
		surface.SetDrawColor( 255, 255, 255, stamina_alpha )
		surface.SetMaterial( mat_sprint )
		surface.DrawTexturedRect( stamina_x + ( stamina_w - sprint_icon_size ) * 0.5, stamina_y + ( stamina_h * 0.75 - sprint_icon_size ), sprint_icon_size, sprint_icon_size )
	end

	--[[-------------------------------------------------------------------------
	Time
	---------------------------------------------------------------------------]]
	local time_h = h * 0.06 * scale
	local time_w = time_h * time_ratio
	local time_y = 8
	local time_alpha = time_visible and 1 or 0

	if ( ROUND.preparing or HUDDrawInfo or time_pct > 0 and !time_visible or GetSettingsValue( "hud_timer_always" ) ) and time_pct < 1 then
		time_pct = math.Approach( time_pct, 1, RealFrameTime() / 0.25 )

		if time_visible then
			time_alpha = ease_in_out( time_pct )
		else
			time_alpha = 1
			time_y = Lerp( ease_out( time_pct ), -time_h - 8, time_y )
		end

		if time_pct >= 1 then
			time_pct = 1
			time_visible = true
		end
	elseif !HUDDrawInfo and time_pct > 0 then
		time_pct = math.Approach( time_pct, 0, RealFrameTime() / 0.6 )
		time_alpha = ease_in_out( time_pct )

		if time_pct <= 0 then
			time_pct = 0
			time_visible = false
		end
	end

	if time_pct > 0 then
		local td = ROUND.time - ct
		local time = td > 0 and string.ToMinutesSeconds( td ) or "00:00"

		local old_alpha = surface.GetAlphaMultiplier()
		surface.SetAlphaMultiplier( time_alpha )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat_time )
		surface.DrawTexturedRect( ( w - time_w ) * 0.5, time_y, time_w, time_h )

		draw.SimpleText( time, "SCPScaledHUDMedium", w * 0.5, time_y + time_h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetAlphaMultiplier( old_alpha )
	end
end

local function post_draw_hud()
	--Empty
end

local function draw_all()
	HUDDrawingInfo = false

	pre_draw_hud()
	local ply = LocalPlayer()

	if HUDSpectatorInfo and SLCAuth.HasAccess( ply, "slc spectateinfo" ) then
		draw_admin_hud()
	end

	if ply:SCPTeam() == TEAM_SPEC then
		draw_spectator_hud()
	else
		draw_hud()
	end

	post_draw_hud()
end

AddGUISkin( "hud", "default", {
	create = function()
		ease_out = math.CubicBezierYFromX( 0, 0, 0.58, 1, 0.001 )
		ease_in_out = math.CubicBezierYFromX( 0.42, 0, 0.58, 1, 0.001 )

		hook.Add( "SLCDrawHUD", "HUD.Default.Paint", draw_all )
	end,
	remove = function()
		hook.Remove( "SLCDrawHUD", "HUD.Default.Paint" )
	end,
	show =  nil,
	hide = nil,
} )