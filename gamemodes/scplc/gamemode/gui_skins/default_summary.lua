--[[-------------------------------------------------------------------------
Colors
---------------------------------------------------------------------------]]
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )
local color_winners = {
	Color( 255, 204,  51 ),
	Color( 192, 198, 208 ),
	Color( 186, 120,  58 ),
}

--[[-------------------------------------------------------------------------
Materials
---------------------------------------------------------------------------]]
local mat_badge = Material( "slc/hud/skin_default/hud_time.png", "smooth" )
local mat_progress_left = Material( "slc/hud/skin_default/badge_left.png", "smooth" )
local mat_progress_right = Material( "slc/hud/skin_default/badge_right.png", "smooth" )

local badge_ratio = mat_badge:Width() / mat_badge:Height()

/*local ROUND_SUMMARY = {
	winners = {
		{ "scp", 189 },
		{ "staff", 86 },
		{ "classd_ci", 12 },
	},
	-- stats = {},
	-- mvp = {nil, 0},
	mvp = { Entity( 1 ), 69 },
	stats = {
		{ "recontain106", true },
		{ "scp_kills", 13 },
		{ "staff_dmg", 2137 },
		{ "classd_ci_rdm", 7 },
		{ "scp_682", 8 },
		{ "scp_173", 21 },
	},
	duration = 10,
}*/

local winners_positions = { 0, -1, 1 }

local function draw_phase1( total_w, draw_y )
	local w, h = ScrW(), ScrH()
	local scale = 1 //GetHUDScale()

	local center_x = w * 0.5
	local margin = total_w * 0.05

	local badges_h = h * 0.2 * scale
	local badge_w = badges_h * 0.5 * badge_ratio
	local badge_max_w = total_w / 3 - margin * 2

	if badge_w > badge_max_w then
		badge_w = badge_max_w
	end

	local badge_mat_h = badge_w / badge_ratio
	local badge_offset_x = badge_w + margin
	local badge_offset_y = badge_mat_h * 0.5
	local logo_size = badge_w * 0.4

	local tw, th

	if !istable( ROUND_SUMMARY.winners ) or #ROUND_SUMMARY.winners == 0 then
		tw, th = draw.OutlinedText( LANG.ROUND_SUMMARY.no_winner, "SCPHUDMedium", center_x, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
		draw_y = draw_y + th
	else
		local badge_end = draw_y

		for i, v in ipairs( ROUND_SUMMARY.winners ) do
			if i > 3 then break end
			local group = v[1]
			local score = v[2]

			local pos = winners_positions[i]
			local mat = GetMaterial( "slc/teams/group_"..group..".png", "smooth" )

			local badge_x = center_x + badge_offset_x * pos
			local badge_place_offset = ( i == 1 and 0 or 1 ) * margin
			local badge_y = draw_y + badge_place_offset

			surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial( mat_badge )
			surface.DrawTexturedRectRotated( badge_x, badge_y + badge_offset_y, badge_w, badge_mat_h, 180 )

			tw, th = draw.OutlinedText( "#"..i, "SCPHUDBig", badge_x, badge_y, color_winners[i], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			badge_y = badge_y + th

			tw, th = draw.OutlinedText( LANG.TEAM_GROUPS[group] or group, "SCPHUDVSmall", badge_x, badge_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			badge_y = badge_y + th + 8

			surface.SetMaterial( mat )
			surface.DrawTexturedRect( badge_x - logo_size * 0.5, badge_y, logo_size, logo_size )
			badge_y = badge_y + logo_size + 8

			tw, th = draw.OutlinedText( LANG.ROUND_SUMMARY.score, "SCPHUDVSmall", badge_x, badge_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			badge_y = badge_y + th

			tw, th = draw.OutlinedText( score, "SCPHUDMedium", badge_x, badge_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			badge_y = badge_y + th - badge_offset_y + 8

			surface.SetMaterial( mat_badge )
			surface.DrawTexturedRectRotated( badge_x, badge_y, badge_w, badge_mat_h, 0 )

			badge_y = badge_y + badge_offset_y

			if i == 1 then badge_end = badge_y end
		end

		draw_y = badge_end
	end

	draw_y = draw_y + margin * 0.333

	if ROUND_SUMMARY.mvp and IsValid( ROUND_SUMMARY.mvp[1] ) then
		local mvp = ROUND_SUMMARY.mvp[1]
		local score = ROUND_SUMMARY.mvp[2]
		local avatar_mat = AvatarMaterial( mvp )
		local avatar_r = badge_w * 0.24

		tw, th = draw.OutlinedText( LANG.ROUND_SUMMARY.mvp, "SCPHUDBig", center_x, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
		draw_y = draw_y + th

		surface.SetDrawColor( 255, 255, 255, 255 )
		SLCDrawCircle( center_x, draw_y + avatar_r, avatar_r, 1, 0, avatar_mat, 2, 255, 255, 255 )
		draw_y = draw_y + avatar_r

		tw, th = draw.OutlinedText( mvp:Nick(), "SCPHUDMedium", center_x - avatar_r - 16, draw_y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, color_black, 2, 2 )
		tw, th = draw.OutlinedText( LANG.ROUND_SUMMARY.score, "SCPHUDSmall", center_x + avatar_r + 16, draw_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, color_black, 2, 2 )
		tw, th = draw.OutlinedText( score, "SCPHUDMedium", center_x + avatar_r + 16 + tw * 0.5, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )

		draw_y = draw_y + avatar_r
	else
		draw_y = draw_y + margin
	end

	return draw_y
end

local function draw_phase2( total_w, draw_y )
	local w, h = ScrW(), ScrH()
	local center_x = w * 0.5

	draw_y = draw_y + h * 0.03

	local _, th

	if #ROUND_SUMMARY.stats == 0 then
		_, th = draw.OutlinedText( LANG.ROUND_SUMMARY.no_stats, "SCPHUDMedium", center_x, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 2 )
		draw_y = draw_y + th

		return draw_y
	end

	for i, stat in ipairs( ROUND_SUMMARY.stats ) do
		local stat_id = stat[1]
		local stat_value = stat[2]

		local stat_text = string.format( LANG.ROUND_STATS[stat_id] or stat_id, stat_value )

		_, th = draw.OutlinedText( stat_text, "SCPHUDSmall", center_x, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 2 )
		draw_y = draw_y + th
	end

	return draw_y
end

local function draw_progress( pct, total_w, draw_y )
	pct = math.Clamp( pct, 0, 1 )

	local center_x = ScrW() * 0.5
	local cap_size = 16
	local bar_size = 8

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_progress_left )
	surface.DrawTexturedRect( center_x - total_w * 0.5, draw_y, cap_size, cap_size )

	surface.SetMaterial( mat_progress_right )
	surface.DrawTexturedRect( center_x + total_w * 0.5 - cap_size, draw_y, cap_size, cap_size )

	local bar_w = ( total_w - 8 ) * pct
	draw.RoundedBox( bar_size, center_x - bar_w * 0.5, draw_y + cap_size * 0.5 - bar_size * 0.5, bar_w, bar_size, color_white )

	return draw_y + cap_size
end

local fade_time = 0.5
local trans_time = 0.5
local lowest

local function draw_summary()
	if !ROUND_SUMMARY then return end

	local w, h = ScrW(), ScrH()
	local scale = 1 //GetHUDScale()

	local total_w = w * 0.5 * scale
	local draw_y = h * 0.075

	local start_time = ROUND_SUMMARY.start_time
	local duration = ROUND_SUMMARY.duration
	local half_duration = duration / 2

	local ct = CurTime()
	local elapsed = ct - start_time

	local old_mult = surface.GetAlphaMultiplier()

	local global_alpha = math.Clamp( math.min(
		elapsed / fade_time,
		( duration - elapsed ) / fade_time
	), 0, 1 )

	surface.SetAlphaMultiplier( global_alpha )

	local _, th = draw.OutlinedText( LANG.ROUND_SUMMARY.round_end, "SCPHUDBig", w * 0.5, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
	draw_y = draw_y + th + 8

	if duration < 3 then return end


	if !lowest then
		surface.SetAlphaMultiplier( 0 )
		lowest = math.max(
			draw_phase1( total_w, draw_y ),
			draw_phase2( total_w, draw_y )
		)
	end

	local first_alpha = math.Clamp( math.min(
		elapsed / fade_time,
		( half_duration - elapsed ) / trans_time + 0.5
	), 0, 1 )

	surface.SetAlphaMultiplier( SLCEase.ease_in_out( first_alpha ) )
	if first_alpha > 0 then
		draw_phase1( total_w, draw_y )
	end

	local second_alpha = math.Clamp( math.min(
		( elapsed - half_duration ) / trans_time + 0.5,
		( duration - elapsed ) / fade_time
	), 0, 1 )

	surface.SetAlphaMultiplier( SLCEase.ease_in_out( second_alpha ) )
	if second_alpha > 0 then
		draw_phase2( total_w, draw_y )
	end

	surface.SetAlphaMultiplier( global_alpha )

	draw_y = draw_progress( ( elapsed / half_duration ) % 1, total_w, lowest + 16 )

	local _, skip_bind = GetBindButton( "skip_summary_button" )
	if skip_bind then
		local skip_text = string.format( LANG.ROUND_SUMMARY.skip, string.upper( skip_bind ) )
		draw.OutlinedText( skip_text, "SCPHUDVSmall", w * 0.5, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
	end

	surface.SetAlphaMultiplier( old_mult )

	if elapsed > duration then
		HideGUIElement( "round_summary" )
	end
end

AddGUISkin( "round_summary", "default", {
	create = nil,
	remove = function()
		hook.Remove( "HUDPaint", "SLCDefaultRoundSummary" )
	end,
	show =  function()
		if !ROUND_SUMMARY then return end

		lowest = nil
		ROUND_SUMMARY.start_time = CurTime()
		ROUND_SUMMARY.skip = false

		hook.Add( "HUDPaint", "SLCDefaultRoundSummary", draw_summary )
	end,
	hide = function()
		hook.Remove( "HUDPaint", "SLCDefaultRoundSummary" )
	end,
	skip = function()
		if !ROUND_SUMMARY then return end

		local ct = CurTime()
		ROUND_SUMMARY.start_time = CurTime() - ROUND_SUMMARY.duration * ( ct - ROUND_SUMMARY.start_time > ROUND_SUMMARY.duration * 0.5 and 1 or 0.5 ) - 0.1
	end,
} )