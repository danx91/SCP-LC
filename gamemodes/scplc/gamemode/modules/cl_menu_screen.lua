local color_white = Color( 255, 255, 255 )
local color_inactive = Color( 155, 155, 155 )
local color_black125 = Color( 0, 0, 0, 125 )
local color_black250 = Color( 0, 0, 0, 250 )
local color_light = Color( 100, 100, 100, 255 )
local color_dark = Color( 40, 40, 40, 255 )

local logo_mat = GetMaterial( "slc/logo.png", "smooth" )
local logo_ratio = logo_mat:Height() / logo_mat:Width()

local grad = Material( "vgui/gradient-l" )
local bezier = SLCEase.ease_in_out

local function add_button( text, func, pnl, dock )
	local btn = vgui.Create( "DButton", pnl )
	table.insert( pnl.Buttons, btn )

	btn:SetText( "" )
	btn:Dock( dock or TOP )
	
	btn.DoClick = function( this )
		if func and this:IsEnabled() and !IsValid( pnl.LockIfValid ) then
			func( this )
		end
	end

	btn.pct = 0
	btn.Paint = function( this, pw, ph )
		local delta = -1

		local enabled = this:IsEnabled() and !IsValid( pnl.LockIfValid )

		if enabled and this:IsHovered() then
			delta = 1
		end

		this.pct = math.Clamp( this.pct + delta * RealFrameTime() * 5, 0, 1 )

		local tw = draw.SimpleText( LANG.MenuScreen[text] or text, "SCPHUDMedium", pw * 0.01, ph / 2, enabled and color_white or color_inactive, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 255, 255, 255, 80 )
		surface.SetMaterial( grad )
		surface.DrawTexturedRect( 0, ph - 8, tw + (pw - tw) * ( bezier( this.pct ) * 0.9 + 0.1 ), 2 )
		//this:DrawOutlinedRect()
	end

	return btn
end

local ls_mat = {}

for i = 1, 4 do
	ls_mat[i] = GetMaterial( "slc/ls/"..i..".png", "smooth" )
end

function OpenMenuScreen()
	if IsValid( SLCMenuScreen ) then SLCMenuScreen:Remove() end
	if LocalPlayer().IsActive and LocalPlayer():IsActive() then return end

	local url = "https://github.com/danx91/scp-lc-menu-videos/raw/main/vid"..SLCRandom( 4 )..".webm"

	SLCMenuScreen = vgui.Create( "HTML" )

	if system.IsWindows() then
		SLCMenuScreen:SetHTML(
[[<!DOCTYPE html>
<style type="text/css">
html, body {
	width: 100%;
	height:100%;
    overflow:hidden;
}
#vid{
  position: fixed;
  top: 50%;
  left: 50%;
  -webkit-transform: translateX(-50%) translateY(-50%);
  transform: translateX(-50%) translateY(-50%);
  min-width: 100%;
  min-height: 100%;
  width: 100%;
  z-index: -1000;
  overflow: hidden;
}
</style>
<html>
 <head>
  <meta charset="utf-8">
  <title>loop</title>
 </head>
 <body>
  <video id="vid" video autobuffer autoplay loop>
    <source id = "webm" src="]]..url..[[" type='video/webm'>
  </video>
 </body>
</html>]] )
	end

	local w, h = ScrW(), ScrH()

	SLCMenuScreen:SetSize( ScrW() + 8, ScrH() + 8 )
	SLCMenuScreen:SetPos( -8, -8 )

	local mat = table.Random( ls_mat )

	SLCMenuScreen.Paint = function( this, pw, ph )
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( 0, 0, pw, ph )
	end

	SLCMenuScreen.DebugNotif = RealTime() + 30

	SLCMenuScreen.PaintOver = function( this, pw, ph )
		local offset_y = GetSettingsValue( "hud_windowed_mode" ) and h * 0.0225 or 0

		local _, th = draw.SimpleText( "SFM animations created by Madow", "SCPHUDSmall", w - 16, h - offset_y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( "Gamemode created by ZGFueDkx (danx91)", "SCPHUDSmall", w - 16, h - th - offset_y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

		if this.DebugNotif < RealTime() then
			draw.SimpleText( "Stuck on this screen? Write slc_menu_debug in console", "SCPHUDSmall", 16, h - offset_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
	end

	SLCMenuScreen:MakePopup()

	local lang = LANG.MenuScreen

	local pnl = vgui.Create( "DPanel", SLCMenuScreen )
	pnl:SetPos( h * 0.1, h * 0.1 )
	pnl:SetSize( w * 0.25, h * 0.6 )

	pnl.Paint = function( this, pw, ph )
		draw.RoundedBox( 32, 1, 1, pw - 2, ph - 2, color_black125 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.OutlinedRoundedRect( 0, 0, pw, ph, 32, 1 )
	end

	pnl.PerformLayout = function( this, pw, ph )
		this.Logo:SetTall( h * 0.08 )
		this.Logo:DockMargin( pw * 0.1, 0, 0, ph * 0.075 )

		for k, v in pairs( this.Buttons ) do
			v:DockMargin( pw * 0.075, 0, pw * 0.1, ph * 0.025 )
			v:SetTall( ph * 0.07 )
		end
	end

	local logo = vgui.Create( "DPanel", pnl )
	pnl.Logo = logo

	logo:Dock( TOP )
	
	logo.Paint = function( this, pw, ph )
		local dh = pw * logo_ratio

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( logo_mat )
		surface.DrawTexturedRect( 0, ph / 2 - dh / 2, pw, dh )
	end

	pnl.Buttons = {}

	--Start button
	local sbt = add_button( "start", function()
		SLCMenuScreen:Remove()
		MakePlayerReady()
	end, pnl )

	sbt:SetEnabled( false )

	sbt.Think = function( this )
		this:SetEnabled( _SLCPlayerReady and ( SLC_CONTENT.status == SCS_DONE or SLC_CONTENT.status == SCS_WAITING ) )
	end

	--Settings button
	add_button( "settings", function()
		OpenSettingsWindow()
		pnl.LockIfValid = SLC_SETTINGS_WINDOW
		SLC_SETTINGS_WINDOW.Think = function( this )
			if !this:HasFocus() and !IsValid( SLC_POPUP ) and !IsValid( SLC_SETTINGS_WINDOW ) then
				this:MakePopup()
			end
		end
	end, pnl )

	--Precache button
	local pre_btn = add_button( "precache", function( btn )
		SLCLegacyPopup( lang.model_precache, lang.model_precache_text, false, function( i )
			if i == 1 then
				btn:SetEnabled( false )
				BuildPrecacheList()

				local pre = vgui.Create( "DPanel" )
				pnl.LockIfValid = pre

				pre:SetSize( w, h )
				pre:SetPos( 0, 0 )
				pre:MakePopup()
				pre:SetDrawOnTop( true )

				pre.Paint = function( this, pw, ph )
					local progress, current = PrecacheProgress()

					surface.SetDrawColor( 0, 0, 0 )
					surface.DrawRect( 0, 0, pw, ph )

					draw.SimpleText( math.Round( progress * 100 ).."%", "SCPHUDSmall", pw / 2, ph * 0.48, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

					surface.SetDrawColor( 255, 255, 255 )
					surface.DrawOutlinedRect( pw * 0.333, ph * 0.5, pw * 0.333, ph * 0.0075 )
					surface.DrawRect( pw * 0.333, ph * 0.5, pw * 0.333 * progress, ph * 0.0075 )

					draw.SimpleText( current or "-", "SCPHUDSmall", pw / 2, ph * 0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				pre.Think = function( this )
					if !PrecacheNext() then
						this:Remove()
						return
					end
				end
			end
		end, lang.all, lang.cancel )

		pnl.LockIfValid = SLC_POPUP
	end, pnl )

	pre_btn:SetEnabled( CVAR.slc_sv_precache:GetInt() == 1 )

	--Credits button
	add_button( "credits", function()
		local credpnl = vgui.Create( "DScrollPanel" )
		pnl.LockIfValid = credpnl

		credpnl:SetSize( w * 0.4, h * 0.66 )
		credpnl:SetPos( w * 0.4, h * 0.17 )
		credpnl:MakePopup()

		local placeholder = vgui.Create( "DPanel", credpnl )
		placeholder:Dock( TOP )

		local dm = w * 0.012
		placeholder:DockMargin( dm, dm, dm, dm )
		placeholder.Paint = nil

		local credits_markup = markup.Parse( "<font=SCPHUDSmall>"..lang.credits_text.."</font>", credpnl:GetWide() - 16 )
		placeholder:SetTall( credits_markup:GetHeight() + 8 )

		credpnl.Paint = function( this, pw, ph )
			draw.RoundedBox( 16, 1, 1, pw - 2, ph - 2, color_black250 )

			surface.SetDrawColor( 255, 255, 255 )
			surface.OutlinedRoundedRect( 0, 0, pw, ph, 16, 1 )

			credits_markup:Draw( 8, 4 + credpnl.VBar:GetOffset(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255, TEXT_ALIGN_LEFT )
		end

		credpnl.Think = function( this )
			if this:HasFocus() then
				this.HadFocus = true
			elseif this.HadFocus then
				this:Remove()
			end
		end

		local vbar = credpnl.VBar
		local grip = vbar.btnGrip

		vbar:SetHideButtons( true )
		vbar:SetWide( 10 )
		
		local m = h * 0.01
		vbar:DockMargin( 0, m, m, m )
		vbar.Paint = function( this, pw, ph )
			draw.RoundedBox( 15, 0, 0, pw, ph, color_light )
		end

		grip.Paint = function( this, pw, ph )
			draw.RoundedBox( 15, 2, 2, pw - 4, ph - 4, color_dark )
		end
	end, pnl )

	--Quit button
	add_button( "quit", function()
		SLCLegacyPopup( lang.quit_server, lang.quit_server_confirmation, false, function( i )
			if i == 1 then
				RunConsoleCommand( "disconnect" )
			end
		end, lang.yes, lang.no )

		pnl.LockIfValid = SLC_POPUP
	end, pnl, BOTTOM )

	local marg = h * 0.015

	local content = vgui.Create( "DPanel", SLCMenuScreen )
	content:SetPos( pnl:GetX() + pnl:GetWide() + h * 0.1, h * 0.1 )
	content:SetSize( w * 0.45, h * 0.4 )

	content.Paint = function( this, pw, ph )
		draw.RoundedBox( 32, 1, 1, pw - 2, ph - 2, color_black125 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.OutlinedRoundedRect( 0, 0, pw, ph, 32, 1 )
	end

	content.PerformLayout = function( this, pw, ph )
		this.Buttons:SetTall( ph * 0.09 )
		this.Buttons:DockMargin( pw * 0.1, 0, pw * 0.1, ph * 0.03 )

		this.Checkbox:SetTall( ph * 0.07 )
		this.Checkbox:DockMargin( pw * 0.1, 0, pw * 0.1, ph * 0.03 )
	end

	local auto = cookie.GetNumber( "slc_auto_content_check", 1 ) != 0

	local btn_cont = vgui.Create( "DPanel", content )
	content.Buttons = btn_cont
	btn_cont:Dock( BOTTOM )

	btn_cont.Paint = function( this, pw, ph ) end

	btn_cont.PerformLayout = function( this, pw, ph )
		this.Download:SetWide( pw * 0.475 )
		this.Workshop:SetWide( pw * 0.475 )
	end

	local btn_dnw = vgui.Create( "DButton", btn_cont )
	btn_cont.Download = btn_dnw
	btn_dnw:Dock( LEFT )

	btn_dnw:SetText( "" )
	btn_dnw:SetEnabled( false )
	btn_dnw.Text = ""

	btn_dnw.Think = function( this )
		this.Text = LANG.MISC.content_checker.btn_check

		local status = SLC_CONTENT.status
		if status == SCS_WAITING then
			this:SetEnabled( true )
		/*else
			this.Text = clang.btn_download
			this:SetEnabled( status == SCS_DONE and #SLC_CONTENT.info.nsub > 0 )*/
		end
	end

	btn_dnw.Paint = function( this, pw, ph )
		draw.SimpleText( this.Text, "SCPHUDVSmall", pw * 0.5, ph * 0.5, this:IsEnabled() and color_white or color_light, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	btn_dnw.DoClick = function( this )
		this:SetEnabled( false )

		local status = SLC_CONTENT.status
		if status == SCS_WAITING then
			CheckContent()
		/*elseif status == SCS_DONE and #SLC_CONTENT.info.nsub > 0 then
			DownloadAddons()*/
		end
	end

	local btn_ws = vgui.Create( "DButton", btn_cont )
	btn_cont.Workshop = btn_ws
	btn_ws:Dock( RIGHT )

	btn_ws:SetText( "" )

	btn_ws.Paint = function( this, pw, ph )
		draw.SimpleText( LANG.MISC.content_checker.btn_workshop, "SCPHUDVSmall", pw * 0.5, ph * 0.5, this:IsEnabled() and color_white or color_light, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	btn_ws.DoClick = function( this )
		gui.OpenURL( "https://steamcommunity.com/sharedfiles/filedetails/?id="..SLC_CONTENT_WORKSHOP_ID )
	end

	local cb = vgui.Create( "SLCCheckbox", content )
	content.Checkbox = cb
	cb:Dock( BOTTOM )

	cb:SetFont( "SCPHUDVSmall" )
	cb:SetText( "Auto" )
	cb:SetState( auto )

	cb.Think = function( this )
		this:SetText( LANG.MISC.content_checker.auto_check )
	end

	cb.OnUpdate = function( this, new )
		cookie.Set( "slc_auto_content_check", new and 1 or 0 )
	end

	local status_pnl = vgui.Create( "DPanel", content )
	status_pnl:Dock( FILL )

	status_pnl.Paint = function( this, pw, ph )
		local clang = LANG.MISC.content_checker
		local status = SLC_CONTENT.status
		local p_show, p_cur, p_max, p_txt = false, 0, 0
		local cy = marg
		local tw, th

		tw, th = draw.SimpleText( clang.title, "SCPHUDMedium", pw * 0.5, cy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		cy = cy + th

		tw, th = draw.SimpleText( clang.status..":  "..( clang.slist[status] or "" ), "SCPHUDMedium", marg, cy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		cy = cy + th * 1.15

		if status == SCS_CHECKING then
			p_show = true
			p_cur = SLC_CONTENT.info.nok + SLC_CONTENT.info.ok
			p_max = #SLC_CONTENT.registry
		elseif status == SCS_MOUNTING or status == SCS_DOWNLOADING then
			p_show = true
			p_cur = SLC_CONTENT.progress.current
			p_max = SLC_CONTENT.progress.total
			p_txt = SLC_CONTENT.progress.name
		elseif status == SCS_DONE then
			if SLC_CONTENT.info.nok > 0 then
				local txt = ""

				if SLC_CONTENT.info.was_nsub > 0 then
					txt = txt..clang.nsub_warn
				end

				if SLC_CONTENT.info.was_disabled > 0 then
					txt = txt..clang.disabled_warn
				end

				th = draw.MultilineText( marg, cy, txt, "SCPHUDVSmall", color_white, pw - marg * 2, 0, 0, TEXT_ALIGN_LEFT )
				cy = cy + th * 1.15
				tw, th = draw.SimpleText( clang.missing..":  "..SLC_CONTENT.info.was_nsub, "SCPHUDVSmall", marg, cy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				cy = cy + th
				tw, th = draw.SimpleText( clang.disabled..":  "..SLC_CONTENT.info.was_disabled, "SCPHUDVSmall", marg, cy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				cy = cy + th
			else
				tw, th = draw.SimpleText( clang.allok, "SCPHUDVSmall", marg, cy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				cy = cy + th
			end
		end

		if p_show then
			local p_m = pw * 0.1
			local p_h = ph * 0.075
			local dy = cy + ( ph - cy ) / 2 - p_h * 0.5
			local f = math.Clamp( p_cur / p_max, 0, 1 )

			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( p_m, dy, pw - p_m * 2, p_h )
			surface.DrawRect( p_m, dy, ( pw - p_m * 2 ) * f, p_h )

			tw, th = draw.SimpleText( " / ", "SCPHUDSmall", pw * 0.5, dy + p_h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( p_cur, "SCPHUDSmall", pw * 0.5 - tw * 0.5, dy + p_h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( p_max, "SCPHUDSmall", pw * 0.5 + tw * 0.5, dy + p_h, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

			if p_txt then
				draw.SimpleText( p_txt, "SCPHUDSmall", pw * 0.5, dy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			end
		end
	end

	if auto then
		CheckContent()
	end
end

concommand.Add( "slc_menu_debug", function()
	if !IsValid( SLCMenuScreen ) then return end

	cookie.Set( "slc_auto_content_check", 0 )
	SLCMenuScreen:Remove()
	MakePlayerReady()

	SLCLegacyPopup( "DEBUG", "Debug command has been used!\nMenu has been closed and content downloader has been dsabled!\n\nIf you used this command because you got stuck on menu, pleas report it to the gamemode author providing description what happened." )
end )