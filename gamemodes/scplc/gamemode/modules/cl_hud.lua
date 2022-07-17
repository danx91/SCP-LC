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

cvars.AddChangeCallback( "cvar_slc_hud_scale", function( name, old, new )
	print( "HUD scale changed! Rebuilding fonts..." )

	RebuildScaledFonts( new )
	SLC_HUD_END_X = ScrW() * 0.315 * new + ScrH() * 0.01 + 3
end, "HUDChangeCallback" )

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

function GetHUDScale()
	return hudscalecvar:GetFloat()
end

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudWeaponSelection = true,
	CHudSuitPower = true,
	CHudDamageIndicator = true, --TODO damage indicator (and maybe hit markers?)
}

hook.Add( "HUDShouldDraw", "HideDefaultHUD", function( name )
	if hide[name] then return false end
end )

function GM:DrawDeathNotice( x,  y )
end

local MATS = {
	button = Material( "slc/hud/key.png" ),
	escape_blocked = Material( "slc/hud/escape_blocked.png" ),
}

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
	hint = Color( 150, 150, 150, 255 ),
	text_red = Color( 255, 100, 100, 200 ),
	escape_blocked = Color( 255, 0, 0, 255 ),
}

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

local last_width = ScrW()
local scaled_fonts_built = false

SLC_HUD_END_X = 0

function GM:HUDPaint()
	local w, h = ScrW(), ScrH()
	local scale = GetHUDScale()

	if !scaled_fonts_built then
		scaled_fonts_built = true
		print( "Building HUD fonts..." )

		RebuildScaledFonts( scale )
		SLC_HUD_END_X = w * 0.315 * scale + h * 0.01 + 3
	end

	if w != last_width then
		last_width = w
		print( "Screen resolution changed! Rebuilding fonts..." )

		RebuildFonts()
		RebuildScaledFonts( scale )

		hook.Run( "SLCResolutionChanged", w, h )
	end

	if hook.Run( "HUDShouldDraw", "scplc.hud" ) == false then return end

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
				text = math.Round( v.data.pos:Distance( LocalPlayer():GetPos() ) * 0.019 ) .. "m", --1m = 52.49 units --REVIEW 0.0254 (1m = 39.37 units)?
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
	EscapeTimer
	---------------------------------------------------------------------------]]
	if !ROUND.post then
		if EscapeStatus != 0 then
			local x = w * 0.4625
			local y = h * 0.15
			local s = w * 0.075

			if EscapeStatus == 1 then
				draw.Text{
					text = LANG.HUD.escaping,
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

	--[[-------------------------------------------------------------------------
	Draw HUD
	---------------------------------------------------------------------------]]
	if hud_disabled then return end

	RunGUISkinFunction( "pre_hud" )

	local ply = LocalPlayer()
	RunGUISkinFunction( ply:SCPTeam() == TEAM_SPEC and "spectator_hud" or "hud" )
	if ply:SCPTeam() == TEAM_SPEC then return end

	if HUDDrawInfo or ROUND.post then
		RunGUISkinFunction( "additional_hud" )
	end

	RunGUISkinFunction( "post_hud" )

	--[[-------------------------------------------------------------------------
	Pickup hint
	---------------------------------------------------------------------------]]
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

				local ply = LocalPlayer()
				show_xp = ply:SCPExp()
				show_lvl = ply:SCPLevel()
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

			draw.SimpleText( show_lvl, "SCPHUDVBig", bar_x - w * 0.01, bar_y + bar_h * 0.5, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			surface.SetFont( "SCPHUDBig" )
			local max_w = surface.GetTextSize( show_maxxp )

			local text_x, text_y =  bar_x + xoffset, bar_y + bar_h + h * 0.01
			local _, th = draw.SimpleText( show_xp + math.ceil( cur_xp ), "SCPHUDBig", text_x, text_y, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			local slash_w = draw.SimpleText( " / ", "SCPHUDBig", text_x + max_w, text_y + th * 0.1, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( show_maxxp, "SCPHUDMedium", text_x + max_w + slash_w, text_y + th * 0.333, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	end
end

local dishudnf = false
local wasdisabled = false

function GM:SLCShouldDrawSCPHUD()
	return !hud_disabled and !HUDDrawInfo and !ROUND.preparing and !ROUND.post
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