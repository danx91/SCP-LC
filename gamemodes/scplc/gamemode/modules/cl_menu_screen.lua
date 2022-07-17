local color_white = Color( 255, 255, 255 )
local color_inactive = Color( 155, 155, 155 )

local logo_mat = GetMaterial( "slc/logo.png" )
local logo_ratio = logo_mat:Height() / logo_mat:Width()

local grad = Material( "vgui/gradient-l" )
local bezier = math.CubicBezierYFromX( 0.42, 0, 0.58, 1, 0.0001 )

local function add_button( text, func, pnl, dock )
	local btn = vgui.Create( "DButton", pnl )
	table.insert( pnl.Buttons, btn )

	btn:SetText( "" )
	btn:Dock( dock or TOP )
	
	btn.DoClick = function( this )
		if func and this:IsEnabled() and !IsValid( pnl.LockIfValid ) then
			func()
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

		local tw = draw.SimpleText( text, "SCPHUDMedium", pw * 0.01, ph / 2, enabled and color_white or color_inactive, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 255, 255, 255, 80 )
		surface.SetMaterial( grad )
		surface.DrawTexturedRect( 0, ph - 8, tw + (pw - tw) * ( bezier( this.pct ) * 0.9 + 0.1 ), 2 )
	end

	return btn
end

local ls_mat = {}

for i = 1, 4 do
	ls_mat[i] = GetMaterial( "slc/ls/"..i..".png" )
end

function OpenMenuScreen()
	if IsValid( SLCMenuScreen ) then SLCMenuScreen:Remove() end
	if DEVELOPER_MODE then return end

	local url = "https://github.com/danx91/scp-lc-menu-videos/raw/main/vid"..math.random(4)..".webm"

	SLCMenuScreen = vgui.Create( "HTML" )

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

	SLCMenuScreen.PaintOver = function( this, pw, ph )
		local _, th = draw.SimpleText( "SFM animations created by Madow", "SCPHUDSmall", w - 16, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( "Gamemode created by ZGFueDkx (danx91)", "SCPHUDSmall", w - 16, h - th, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
	end

	SLCMenuScreen:MakePopup()

	local lang = LANG.MenuScreen

	local pnl = vgui.Create( "DPanel", SLCMenuScreen )
	pnl:SetPos( h * 0.1, h * 0.1 )
	pnl:SetSize( w * 0.25, h * 0.55 )

	pnl.Paint = function( this, pw, ph )
		draw.RoundedBox( 16, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
	end

	pnl.PerformLayout = function( this, pw, ph )
		this.Logo:SetTall( h * 0.1 )
		this.Logo:DockMargin( pw * 0.1, 0, 0, ph * 0.075 )

		for k, v in pairs( this.Buttons ) do
			v:DockMargin( pw * 0.075, 0, pw * 0.25, ph * 0.05 )
			v:SetTall( ph * 0.075 )
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
	local sbt = add_button( lang.start, function()
		SLCMenuScreen:Remove()
		MakePlayerReady()
	end, pnl )

	sbt:SetEnabled( false )

	sbt.Think = function( this )
		if !this:IsEnabled() and _SLCPlayerReady then
			this:SetEnabled( true )
		end
	end

	--Settings button
	add_button( lang.settings, function()
		OpenSettingsWindow()
		pnl.LockIfValid = SLC_SETTINGS_WINDOW
		SLC_SETTINGS_WINDOW.Think = function( this )
			if !this:HasFocus() and !IsValid( SLC_POPUP ) then
				this:MakePopup()
			end
		end
	end, pnl )

	--Precache button
	local pre = add_button( lang.precache, function()
		SLCPopup( lang.model_precache, lang.model_precache_text, false, function( i )
			if i == 1 then
				local models = {}

				for _, v in pairs( GetAllClasses() ) do
					if isstring( v.model ) then
						table.insert( models, v.model )
					elseif istable( v.model ) then
						for _, mdl in pairs( v.model ) do
							table.insert( models, mdl )
						end
					end
				end

				for k, v in pairs( file.Find( BASE_LUA_PATH.."/entities/weapons/*.lua", "LUA" ) ) do
					local wep = weapons.GetStored( string.sub( v, 1, -5 ) )
					if wep and wep.WorldModel and wep.WorldModel != "" then
						table.insert( models, wep.WorldModel )
					end
				end

				local pre = vgui.Create( "DPanel" )
				pnl.LockIfValid = pre

				pre:SetSize( w, h )
				pre:SetPos( 0, 0 )
				pre:MakePopup()
				pre:SetDrawOnTop( true )

				local cur = ""
				local index = 0
				local max = #models

				pre.Paint = function( this, pw, ph )
					surface.SetDrawColor( 0, 0, 0 )
					surface.DrawRect( 0, 0, pw, ph )

					draw.SimpleText( math.Round( index / max * 100 ).."%", "SCPHUDSmall", pw / 2, ph * 0.48, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

					surface.SetDrawColor( 255, 255, 255 )
					surface.DrawOutlinedRect( pw * 0.333, ph * 0.5, pw * 0.333, ph * 0.0075 )
					surface.DrawRect( pw * 0.333, ph * 0.5, pw * 0.333 * index / max, ph * 0.0075 )

					draw.SimpleText( cur, "SCPHUDSmall", pw / 2, ph * 0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				pre.Think = function( this )
					if index >= max then
						this:Remove()
						return
					end

					index = index + 1
					cur = models[index]

					util.PrecacheModel( cur )
				end
			end
		end, lang.all, lang.cancel )

		pnl.LockIfValid = SLC_POPUP
	end, pnl )

	pre:SetEnabled( false )

	--Credits button
	add_button( lang.credits, function()
		local credpnl = vgui.Create( "DScrollPanel" )
		pnl.LockIfValid = credpnl

		credpnl:SetSize( w * 0.4, h * 0.66 )
		credpnl:SetPos( w * 0.4, h * 0.17 )
		credpnl:MakePopup()

		local placeholder = vgui.Create( "DPanel", credpnl )
		placeholder:Dock( TOP )

		local dm = w * 0.012
		placeholder:DockMargin( dm, dm, dm, dm )
		placeholder.Paint = function() end

		credpnl.Paint = function( this, pw, ph )
			draw.RoundedBox( 16, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )

			local th, _, feed = draw.MultilineText( 0, credpnl.VBar:GetOffset(), lang.credits_text, "SCPHUDSmall", color_white, pw, pw * 0.03, 0, TEXT_ALIGN_LEFT, nil, false, false, this.Feed )
			if !this.Feed then
				placeholder:SetTall( th )
				this.Feed = feed
			end
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
			draw.RoundedBox( 15, 0, 0, pw, ph, Color( 100, 100, 100, 255 ) )
		end

		grip.Paint = function( this, pw, ph )
			draw.RoundedBox( 15, 2, 2, pw - 4, ph - 4, Color( 40, 40, 40, 255 ) )
		end
	end, pnl )

	--Quit button
	add_button( lang.quit, function()
		SLCPopup( lang.quit_server, lang.quit_server_confirmation, false, function( i )
			if i == 1 then
				RunConsoleCommand( "disconnect" )
			end
		end, lang.yes, lang.no )

		pnl.LockIfValid = SLC_POPUP
	end, pnl, BOTTOM )
end