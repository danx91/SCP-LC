local draw_escort_zones

--[[-------------------------------------------------------------------------
HUD Scaling
---------------------------------------------------------------------------]]
local last_width = ScrW()
local scaled_fonts_built = false

HUD_SCALES = {
	vbig = 1.1,
	big = 1.05,
	normal = 1,
	small = 0.9,
	vsmall = 0.8,
	imretard = 0.6,
}

local hudscalecvar = CreateClientConVar( "cvar_slc_hud_scale", 1, true )

cvars.AddChangeCallback( "cvar_slc_hud_scale", function( name, old, new )
	print( "HUD scale changed! Rebuilding fonts..." )

	scaled_fonts_built = false
end, "HUDChangeCallback" )

concommand.Add( "slc_hud_scale", function( ply, cmd, args )
	local size = args[1]

	if !size or size == "" or !HUD_SCALES[size] then
		print( "Unknown HUD size! Available sizes: vbig, big, normal, small, vsmall, imretard" )
		return
	end

	RunConsoleCommand( "cvar_slc_hud_scale", HUD_SCALES[size] )
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tbl = {}

	for k, v in pairs( HUD_SCALES ) do
		if string.find( k, args ) then
			table.insert( tbl, cmd.." "..k )
		end
	end

	return tbl
end )

hook.Add( "SLCRegisterSettings", "SLCHUDSettings", function()
	local tab = {}

	for k, v in pairs( HUD_SCALES ) do
		table.insert( tab, k )
	end

	table.sort( tab, function( a, b )
		return HUD_SCALES[a] < HUD_SCALES[b]
	end )

	RegisterSettingsEntry( "cvar_slc_hud_scale", "dropbox", "!CVAR", {
		list = tab,
		parse = function( value )
			value = tonumber( value )
			for k, v in pairs( HUD_SCALES ) do
				if v == value then
					return k
				end
			end
		end,
		callback = function( value )
			RunConsoleCommand( "slc_hud_scale", value )
			return true
		end,
	}, "hud_config" )

	RegisterSettingsEntry( "hud_draw_crosshair", "switch", true, nil, "hud_config" )
	RegisterSettingsEntry( "hud_hl2_crosshair", "switch", false, nil, "hud_config" )
	RegisterSettingsEntry( "hud_timer_always", "switch", false, nil, "hud_config" )
	RegisterSettingsEntry( "hud_stamina_always", "switch", false, nil, "hud_config" )

	RegisterSettingsEntry( "hud_windowed_mode", "switch", false, nil, "skins" )
	RegisterSettingsEntry( "hud_escort", "switch", true, {
		callback = function( value, name )
			if value then
				hook.Add( "PostDrawOpaqueRenderables", "SLCEscortZones", draw_escort_zones )
			else
				hook.Remove( "PostDrawOpaqueRenderables", "SLCEscortZones" )
			end
		end
	} )
end )

function GetHUDScale()
	return hudscalecvar:GetFloat()
end

--[[-------------------------------------------------------------------------
Hide HL2 HUD
---------------------------------------------------------------------------]]
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudWeaponSelection = true,
	CHudSuitPower = true,
	CHudDamageIndicator = true,
	CHudPoisonDamageIndicator = true,
	//CHudCrosshair = true,
}

function GM:HUDShouldDraw( name )
	if hide[name] then return false end
	if name == "CHudCrosshair" and ( !GetSettingsValue( "hud_draw_crosshair" ) or !GetSettingsValue( "hud_hl2_crosshair" ) ) then return false end

	return true
end

function GM:DrawDeathNotice( x, y )

end

--[[-------------------------------------------------------------------------
HUDPaint
---------------------------------------------------------------------------]]
local MATS = {
	button = Material( "slc/hud/key.png", "smooth" ),
	escape_blocked = Material( "slc/hud/escape_blocked.png", "smooth" ),
	escort_marker = Material( "slc/misc/escort_marker.png", "smooth" ),
}

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
	hint = Color( 150, 150, 150, 255 ),
	text_red = Color( 255, 100, 100, 200 ),
	escape_blocked = Color( 255, 0, 0, 255 ),
}

SCPMarkers = {}
HUDDrawSpawnInfo = 0
hud_disabled = false
HUDDrawInfo = false
HUDBlink = 1
HUDNextBlink = 0
HUDPickupHint = false
HUDSpectatorInfo = false

SLC_HUD_END_X = 0

function GM:HUDPaint()
	local w, h = ScrW(), ScrH()
	local scale = GetHUDScale()

	if !scaled_fonts_built then
		scaled_fonts_built = true
		print( "Building HUD fonts..." )

		RebuildScaledFonts( scale )
	end

	if w != last_width then
		last_width = w
		print( "Screen resolution changed! Rebuilding fonts..." )

		RebuildFonts()
		RebuildScaledFonts( scale )

		hook.Run( "SLCResolutionChanged", w, h )
	end

	if hook.Run( "HUDShouldDraw", "scplc.hud" ) == false then return end

	local ply = LocalPlayer()

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

			local _, th = draw.Text( {
				text = v.data.name,
				font = "SCPHUDSmall",
				color = COLOR.text_red,
				pos = { scr.x, scr.y + 10 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )

			draw.Text( {
				text = math.Round( v.data.pos:Distance( ply:GetPos() ) * 0.01905 ) .. "m", --1m = 52.49 units --REVIEW 0.0254 (1m = 39.37 units)?
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

	--[[-------------------------------------------------------------------------
	ESCAPE_TIMER
	---------------------------------------------------------------------------]]
	if !ROUND.post then
		if ESCAPE_STATUS != 0 then
			local y = h * 0.2
			local s = w * 0.075
			local x = ( w - s ) * 0.5

			if ESCAPE_STATUS == 1 then
				draw.Text{
					text = LANG.HUD.escaping,
					pos = { w * 0.5, y - h * 0.02 },
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
					local f = (ESCAPE_TIMER - CurTime()) / 20

					surface.SetDrawColor( COLOR.white )
					draw.NoTexture()
					surface.DrawCooldownHollowRectCW( x + diff, y + diff, a, a, s * 0.075, f, HRCSTYLE_RECT_SOLID )
				cam.PopModelMatrix()

				draw.Text{
					text = math.Round(ESCAPE_TIMER - CurTime()),
					pos = { cx, cy },
					color = COLOR.white,
					font = "SCPHUDVBig",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			elseif ESCAPE_STATUS == 2 then
				draw.Text{
					text = LANG.HUD.escape_blocked,
					pos = { w * 0.5, y - h * 0.02 },
					color = COLOR.escape_blocked,
					font = "SCPHUDVBig",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_BOTTOM,
				}

				surface.SetDrawColor( COLOR.white )
				surface.SetMaterial( MATS.escape_blocked )
				surface.DrawTexturedRect( x, y, s, s )

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

	--[[-------------------------------------------------------------------------
	Draw HUD
	---------------------------------------------------------------------------]]
	if hud_disabled then return end
	hook.Run( "SLCPreDrawHUD" )
	hook.Run( "SLCDrawHUD" )

	local admin_mode = ply:GetAdminMode()
	if ply:SCPTeam() == TEAM_SPEC and !admin_mode then
		hook.Run( "SLCPostDrawHUD" )
		return
	end

	--[[-------------------------------------------------------------------------
	Pickup hint
	---------------------------------------------------------------------------]]
	if HUDPickupHint and !IsValid( HUDPickupHint ) then
		HUDPickupHint = nil
	end

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

		if !HUDPickupHintMsg then
			surface.SetDrawColor( COLOR.hint )
			surface.SetMaterial( MATS.button )
			surface.DrawTexturedRect( w * 0.49 - tw * 0.5, h * 0.75 - th * 0.5 - w * 0.01, w * 0.02 + tw, w * 0.02 + th )

			draw.Text{
				text = key,
				pos = { w * 0.5, h * 0.75 - th * 0.1 },
				color = COLOR.white,
				font = "SCPHUDBig",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

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

		local _, hth = draw.Text{
			text = text,
			pos = { w * 0.5, h * 0.75 - th - w * 0.02 },
			color = COLOR.white,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		if HUDPickupHintMsg then
			draw.Text{
				text = LANG.pickup_msg[HUDPickupHintMsg] or HUDPickupHintMsg,
				pos = { w * 0.5, h * 0.75 - th - w * 0.02 + hth },
				color = COLOR.text_red,
				font = "SCPHUDMedium",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		HUDPickupHint = nil
		HUDPickupHintMsg = nil
	end

	--From base gamemode
	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )

	hook.Run( "SLCPostDrawHUD" )

	--[[-------------------------------------------------------------------------
	Crosshair
	---------------------------------------------------------------------------]]
	if !GetSettingsValue( "hud_draw_crosshair" ) then return true end
	if GetSettingsValue( "hud_hl2_crosshair" ) then return end

	local wep = ply:GetActiveWeapon()
	if admin_mode or IsValid( wep ) and ( !wep:IsScripted() or wep.DrawCrosshair == true and ( !wep.DoDrawCrosshair or wep:DoDrawCrosshair() != true ) ) then
		DrawSLCCrossHair( w / 2, h / 2 )
	end
end

--[[-------------------------------------------------------------------------
DrawOverlay
---------------------------------------------------------------------------]]
local function create_bar( x, y, w, h, xoff )
	return {
		{ x = x, y = y },
		{ x = x + w, y = y },
		{ x = x + w + xoff, y = y + h },
		{ x = x + xoff, y = y + h },
	}
end

local show_xp, show_lvl, show_maxxp, cur_xp, current_segment, next_anim, should_close
local show_text, fade_time, drop_time, text_alpha

local fade_dur = 1
local drop_dur = 0.2

function GM:DrawOverlay()
	local w, h = ScrW(), ScrH()
	local ply = LocalPlayer()
	if !ply.FullyLoaded then return end

	--[[-------------------------------------------------------------------------
	XP Bar
	---------------------------------------------------------------------------]]
	if ROUND.post then
		if HUDXPSummary then
			local rt = RealTime()

			if !HUDXPSummaryData then
				HUDXPSummaryData = {}

				local sum = 0

				for k, v in pairs( HUDXPSummary ) do
					sum = sum + v[1]
				end

				//local req = CVAR.slc_xp_level:GetInt()
				//local inc = CVAR.slc_xp_increase:GetInt()
				show_xp = ply:PlayerXP()
				show_lvl = ply:PlayerLevel()
				show_maxxp = ply:RequiredXP( show_lvl ) //req + inc * show_lvl

				while sum > 0 do
					local rem = math.min( sum, show_xp + 1 )
					
					if rem <= show_xp then
						show_xp = show_xp - rem
					else
						show_lvl = show_lvl - 1
						show_maxxp = ply:RequiredXP( show_lvl ) //req + inc * show_lvl
						show_xp = show_xp + show_maxxp - rem
					end

					sum = sum - rem
				end

				cur_xp = 0
				current_segment = 1
				next_anim = rt + 1.5

				should_close = false

				show_text = nil
				text_alpha = 0

				if show_xp > 0 then
					HUDXPSummaryData[1] = {
						color = XPSUMMARY_COLORS.base,
						start_pos = 0,
						end_pos = show_xp / show_maxxp
					}

					current_segment = 2
				end
			end

			if next_anim <= rt then
				if should_close then
					should_close = false
					HUDXPSummary = nil
					HUDXPSummaryData = nil

					return
				end

				local tab = HUDXPSummary[1]
				if tab then
					local data = HUDXPSummaryData[current_segment]
					if !data then
						cur_xp = 0
						drop_time = nil
						show_text = ( LANG.XP_BAR[tab[2]] or tab[2] )..": "..tab[1].." XP"

						local prev_pos = current_segment > 1 and HUDXPSummaryData[current_segment - 1].end_pos or 0

						data = {
							start_pos = prev_pos,
							end_pos = prev_pos,
							color = XPSUMMARY_COLORS[tab[2]] or XPSUMMARY_COLORS.general
						}

						HUDXPSummaryData[current_segment] = data
					end

					cur_xp = cur_xp + math.ceil( RealFrameTime() * 2500 )
					data.end_pos = math.Clamp( data.start_pos + cur_xp / show_maxxp, 0, 1 )

					if show_xp + cur_xp > show_maxxp then
						local diff = show_xp + cur_xp - show_maxxp

						tab[1] = tab[1] - cur_xp + diff

						show_xp = 0
						show_lvl = show_lvl + 1
						show_maxxp = ply:RequiredXP( show_lvl ) //CVAR.slc_xp_level:GetInt() + CVAR.slc_xp_increase:GetInt() * show_lvl
						cur_xp = diff

						current_segment = 1

						data = {
							start_pos = 0,
							end_pos = diff / show_maxxp,
							color = data.color
						}

						HUDXPSummaryData = { data }
					end

					if cur_xp >= tab[1] then
						table.remove( HUDXPSummary, 1 )

						show_xp = show_xp + tab[1]
						current_segment = current_segment + 1
						cur_xp = 0

						next_anim = rt + 1.25
						drop_time = rt + drop_dur
					end
				else
					should_close = true
					next_anim = rt + 3
				end
			elseif !show_text and next_anim - rt <= fade_dur then
				local tab = HUDXPSummary[1]
				if tab then
					show_text = ( LANG.XP_BAR[tab[2]] or tab[2] )..": "..tab[1].." XP"
					fade_time = rt + fade_dur
					text_alpha = 0
				end
			end

			if show_text and fade_time then
				text_alpha = 1 - ( fade_time - rt ) / fade_dur
			end

			local bar_w = w * 0.325
			local bar_h = h * 0.03
			local bar_x = w * 0.5 - bar_w * 0.5
			local bar_y = h * 0.666

			local ratio = 0.4663 --angle 115 deg = -ctg(115) = 0.4663
			local xoffset = bar_h * ratio

			local bar = create_bar( bar_x, bar_y, bar_w, bar_h, xoffset )

			local r2 = 2 * ratio
			local bar_out = {
				{ x = bar_x - 2 - r2, y = bar_y - 2 },
				{ x = bar_x + bar_w + 2 - r2, y = bar_y - 2 },
				{ x = bar_x + bar_w + xoffset + 2 + r2, y = bar_y + bar_h + 2 },
				{ x = bar_x + xoffset - 2 + r2, y = bar_y + bar_h + 2 },
			}

			draw.NoTexture()
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawDifference( bar, bar_out )

			for i, v in ipairs( HUDXPSummaryData ) do
				surface.SetDrawColor( v.color )
				surface.DrawPoly( create_bar( bar_x + bar_w * v.start_pos, bar_y, bar_w * ( v.end_pos - v.start_pos ), bar_h, xoffset ) )
			end

			if text_alpha > 0 then
				local drop_y = 0

				if drop_time then
					if drop_time > rt then
						drop_y = ( 1 - (drop_time - rt ) / drop_dur ) * bar_h
					else
						drop_time = nil
						text_alpha = 0
						show_text = nil
					end
				end

				render.SetScissorRect( bar_x, bar_y - h * 0.05, bar_x + bar_w, bar_y, true )
					draw.SimpleText( show_text, "SCPHUDMedium", bar_x, bar_y + drop_y, Color( 255, 255, 255, 255 * text_alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				render.SetScissorRect( 0, 0, 0, 0, false )
			end

			draw.SimpleText( show_lvl, "SCPHUDVBig", bar_x - w * 0.01, bar_y + bar_h * 0.5, COLOR.white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			surface.SetFont( "SCPHUDBig" )
			local max_w = surface.GetTextSize( show_maxxp )

			local text_x, text_y =  bar_x + xoffset, bar_y + bar_h + h * 0.01
			local _, th = draw.SimpleText( show_xp + math.ceil( cur_xp ), "SCPHUDBig", text_x, text_y, COLOR.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			local slash_w = draw.SimpleText( " / ", "SCPHUDBig", text_x + max_w, text_y + th * 0.1, COLOR.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( show_maxxp, "SCPHUDMedium", text_x + max_w + slash_w, text_y + th * 0.333, COLOR.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	end

	--[[-------------------------------------------------------------------------
	AFK Warning
	---------------------------------------------------------------------------]]
	local is_afk = ply:IsAFK()
	if is_afk or SLCAFKWarning then
		local lang = LANG.AFK
		local ww, wh = w * 0.4, h * 0.2
		local wx, wy = ( w - ww ) * 0.5, h * 0.3

		if math.floor( RealTime() ) % 2 == 0 then
			surface.SetDrawColor( 120, 60, 60 )
		else
			surface.SetDrawColor( 140, 80, 80 )
		end

		surface.DrawRect( wx, wy, ww, wh )

		surface.SetDrawColor( 200, 200, 200 )
		surface.DrawOutlinedRect( wx, wy, ww, wh )

		local dy = wy + wh * 0.05
		local _, th = draw.SimpleText( is_afk and lang.afk or lang.afk_warn, "SCPHUDBig", wx + ww * 0.5, dy, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		dy = dy + th + wh * 0.05

		if !is_afk then
			_, th = draw.SimpleText( lang.slay_warn, "SCPHUDSmall", wx + ww * 0.5, dy, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			dy = dy + th
		else
			_, th = draw.SimpleText( lang.afk_msg, "SCPHUDSmall", wx + ww * 0.5, dy, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			dy = dy + th
		end

		_, th = draw.SimpleText( lang.afk_action, "SCPHUDSmall", wx + ww * 0.5, wy + wh - wh * 0.05, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	end
end

local dishudnf = false
local wasdisabled = false

function GM:SLCShouldDrawSCPHUD()
	return !hud_disabled and !HUDDrawingInfo /*and !ROUND.preparing*/ and !ROUND.post
end

function DisableHUDNextFrame()
	dishudnf = true
end

hook.Add( "Think", "SCPHUDThink", function()
	if dishudnf then
		if !hud_disabled then
			wasdisabled = hud_disabled
			hud_disabled = true
			ShowGUIElement( "hud" )
		end

		dishudnf = false
	elseif hud_disabled and wasdisabled == false then
		hud_disabled = false
		HideGUIElement( "hud" )
	end
end )

--[[-------------------------------------------------------------------------
Crosshair
---------------------------------------------------------------------------]]
function DrawSLCCrossHair( x, y )
	local h = ScrH()
	local d = math.ceil( h * 0.005 )
	local l = math.ceil( h * 0.005 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.DrawRect( x - d - l, y - 1, l, 1 )
	surface.DrawRect( x + d, y - 1, l, 1 )
	surface.DrawRect( x - 1, y - d - l, 1, l )
	surface.DrawRect( x - 1, y + d, 1, l )

	surface.SetDrawColor( 0, 0, 0 )
	surface.DrawOutlinedRect( x - d - l - 1, y - 2, l + 2, 3 )
	surface.DrawOutlinedRect( x + d - 1, y - 2, l + 2, 3 )
	surface.DrawOutlinedRect( x - 2, y - d - l - 1, 3, l + 2 )
	surface.DrawOutlinedRect( x - 2, y + d - 1, 3, l + 2 )
end

--[[-------------------------------------------------------------------------
Escape zones
---------------------------------------------------------------------------]]

local function draw_stripped_box( x, y, w, h, len, dist, thick ) 
	local x_num = math.floor( ( w - dist * 4 ) / len )
	local x_len = ( w - dist - thick * 2 ) / x_num

	local y_num = math.floor( ( h - dist * 4 ) / len )
	local y_len = ( h - dist - thick * 2 ) / y_num

	surface.DrawRect( x, y, thick, thick )
	surface.DrawRect( x, y + h - thick, thick, thick )
	surface.DrawRect( x + w - thick, y, thick, thick )
	surface.DrawRect( x + w - thick, y + h - thick, thick, thick )

	local x_start = x + dist + thick
	local y_start = y + dist + thick
	local y_end = y + h - thick
	local x_end = x + w - thick
	local x_d = x_len - dist
	local y_d = y_len - dist

	for i = 0, x_num - 1 do
		surface.DrawRect( x_start + i * x_len, y, x_d, thick )
		surface.DrawRect( x_start + i * x_len, y_end, x_d, thick )
	end

	for i = 0, y_num - 1 do
		surface.DrawRect( x, y_start + i * y_len, thick, y_d )
		surface.DrawRect( x_end, y_start + i * y_len, thick, y_d )
	end
end

local angle_zero = Angle( 0 )
function draw_escort_zones()
	local ply = LocalPlayer()
	local t = ply:SCPTeam()

	local teams = {}

	if SCPTeams.CanEscort( t, true ) then
		teams[t] = true
	end

	for i, v in ipairs( SCPTeams.GetEscortedBy( t ) ) do
		teams[v] = true
	end

	local color = SCPTeams.GetColor( t )
	local done = {}

	for k, v in pairs( teams ) do
		local pos = _G["POS_ESCORT_"..SCPTeams.GetName( k )] or POS_ESCORT
		if done[pos] then continue end
		done[pos] = true

		local p_mid = ( pos[1] + pos[2] ) / 2
		p_mid.z = pos[1].z + 10

		local dist = ply:GetPos():Distance( p_mid )
		if dist > 1000 then continue end

		local alpha = math.Clamp( ( 1000 - dist ) / 500, 0, 1 )
		local alpha2 = math.Clamp( ( dist - 200 ) / 200, 0, 1 )

		local dx = p_mid.x - pos[1].x
		local dy = p_mid.y - pos[1].y

		surface.SetAlphaMultiplier( alpha )

		cam.Start3D2D( p_mid, pos[3] or angle_zero, 1 )
			surface.SetDrawColor( color )
			draw_stripped_box( -dx, -dy, dx * 2, dy * 2, 30, 10, 8 )
		cam.End3D2D()

		local ang = Angle( 0, 0, 90 )
		
		ang.y = ( ply:GetPos() - p_mid ):Angle().y + 90

		if alpha2 < alpha then
			surface.SetAlphaMultiplier( alpha2 )
		end

		cam.Start3D2D( p_mid + Vector( 0, 0, 80 ), ang, 0.333 )
			surface.SetDrawColor( 255, 255, 255, 100 )
			surface.SetMaterial( MATS.escort_marker )
			surface.DrawTexturedRect( -10, 30, 20, 200 )

			draw.SimpleText( LANG.MISC.escort_zone, "SCPHUDVBig", 0, 0, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()

		surface.SetAlphaMultiplier( 1 )
	end
end

hook.Add( "SLCSettingsLoaded", "SLCEscortZones", function()
	if !GetSettingsValue( "hud_escort" ) then return end
	hook.Add( "PostDrawOpaqueRenderables", "SLCEscortZones", draw_escort_zones )
end )