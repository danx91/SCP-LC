SLC_SETTINGS = {}
local DEFAULT_SETTINGS = {}
local WINDOW_PANELS = {}

local MATS = {
	blur = Material( "pp/blurscreen" ),
	exit = Material( "slc/hud/exit.png", "smooth" ),
	reset = Material( "slc/hud/refresh.png", "smooth" ),
	fade = Material( "vgui/gradient-l" ),
}

local COLOR = {
	white = Color( 255, 255, 255 ),
	black = Color( 0, 0, 0 ),
	inactive = Color( 125, 125, 125 ),
	border = Color( 175, 175, 175 ),
	hover = Color( 75, 75, 75, 200 ),
	selected = Color( 115, 115, 115, 25 ),
	conflict = Color( 225, 50, 50 ),
	vbar = Color( 75, 75, 75 ),
 	vbar_grip = Color( 125, 125, 125 ),
}

--[[-------------------------------------------------------------------------
Local functions
---------------------------------------------------------------------------]]
local function translateButton( button )
	if !isstring( button ) then return end

	local t, key = string.match( button, "(%a+):(.+)" )
	if t and key then
		key = string.lower( key )

		if t == "key" then
			key = string.match( key, "key_(w+)" ) or key
			return input.GetKeyCode( key ), key, nil
		elseif t == "code" then
			local num_key = tonumber( key )
			if num_key then
				return num_key, input.GetKeyName( num_key ), nil
			end
		elseif t == "bind" then
			local bind_key = input.LookupBinding( key )
			if bind_key then
				return input.GetKeyCode( bind_key ), bind_key, key
			end

			return nil, nil, key
		end
	end
end

local function checkForConflicts()
	for name1, bind1 in pairs( SLC_SETTINGS ) do
		if bind1.stype == "bind" then
			bind1.key_conflict = false

			for name2, bind2 in pairs( SLC_SETTINGS ) do
				if bind1 != bind2 and bind2.stype == "bind" then
					if bind1.key_code and bind2.key_code and bind1.key_code == bind2.key_code then
						bind1.key_conflict = true
						break
					end
				end
			end
		end
	end
end

local function processSettingsEntry( k )
	local v = SLC_SETTINGS[k]
	if v then
		if v.cvar then
			v.value = v.cvar:GetString()
		end

		if v.stype == "bind" then
			v.key_conflict = false

			local code, key, bind = translateButton( v.value )
			if code and key then
				v.key_code = code
				v.key = key
			else
				v.key_code = nil
				v.key = nil
			end

			v.bind = bind
		elseif v.stype == "switch" then
			v.value = tobool( v.value )
		elseif v.stype == "dropbox" and v.data.parse then
			v.value = v.data.parse( v.value )
		end
	end
end

local function processAllSettings()
	for k, v in pairs( SLC_SETTINGS ) do
		processSettingsEntry( k )
	end

	checkForConflicts()
end

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function GetSettingsEntry( name )
	return SLC_SETTINGS[name]
end

function GetSettingsValue( name )
	return SLC_SETTINGS[name] and SLC_SETTINGS[name].value
end

function GetBindButton( name )
	local v = SLC_SETTINGS[name]
	if v and v.stype == "bind" then
		return v.key_code, v.key
	end
end

function SaveSettings()
	local tab = {}

	for k, v in pairs( SLC_SETTINGS ) do
		tab[k] = v.value
	end

	file.Write( "slc/client_settings.json", util.TableToJSON( tab ) )
end

local settingsID = 1
function RegisterSettingsEntry( name, stype, default, data, panel )
	local cvar

	if default == "!CVAR" then
		cvar = GetConVar( name )
		if !cvar then
			ErrorNoHalt( "ConVar not found! ", name )
			return
		end

		default = cvar:GetDefault()
	end

	SLC_SETTINGS[name] = {
		id = settingsID,
		name = name,
		stype = stype,
		default = default,
		data = data,
		panel = panel,
		cvar = cvar,
		//value = nil,
	}

	settingsID = settingsID + 1
end

function AddSettingsPanel( name, fn, show, z )
	table.insert( WINDOW_PANELS, { name = name, create = fn, show = show, z = z } )
end

--[[-------------------------------------------------------------------------
Open window
---------------------------------------------------------------------------]]
function OpenSettingsWindow()
	if IsValid( SLC_SETTINGS_WINDOW ) then return end
	processAllSettings()

	local w, h = ScrW(), ScrH()

	local window = vgui.Create( "DFrame" )
	SLC_SETTINGS_WINDOW = window

	window:SetSize( w * 0.75, h * 0.8 )
	window:SetTitle( "" )

	window:ShowCloseButton( false )
	window:SetDraggable( false )

	window:Center()
	window:MakePopup()

	window:DockPadding( 0, 0, 0, 0 )

	window.Paint = function( self, pw, ph )
		render.UpdateScreenEffectTexture()
		MATS.blur:SetFloat( "$blur", 8 )

		if !recomputed then
			recomputed = true
			MATS.blur:Recompute()
		end

		surface.SetDrawColor( COLOR.border )
		surface.DisableClipping( true )
		surface.DrawRect( -1, -1,  pw + 2, ph + 2 )
		surface.DisableClipping( false )

		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.blur )
		surface.DrawTexturedRect( -w * 0.125, -h * 0.1, w, h )

		surface.SetDrawColor( 0, 0, 0, 175 )
		surface.DrawRect( 0, 0, pw, ph )
	end

	local upper_pnl = vgui.Create( "DPanel", window )
	upper_pnl:SetTall( h * 0.035 )
	upper_pnl:Dock( TOP )
	upper_pnl:DockMargin( 0, 0, 0, 0 )

	upper_pnl.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.black )
		surface.DrawRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.settings.settings,
			pos = { pw * 0.01, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	local close_btn = vgui.Create( "DButton", upper_pnl )
	close_btn:SetWide( w * 0.02 )
	close_btn:Dock( RIGHT )
	close_btn:DockMargin( 0, h * 0.007, w * 0.007, h * 0.007 )
	close_btn:SetText( "" )

	close_btn.Paint = function( self, pw, ph )
		draw.RoundedBox( 6, 0, 0, pw, ph, Color( 255, 0, 0, 150 ) )

		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.exit )
		surface.DrawTexturedRect( pw * 0.5 - h * 0.008, ph * 0.5 - h * 0.007, h * 0.0175, h * 0.0175 )
	end

	close_btn.DoClick = function( self )
		window:Close()
	end

	local side_menu = vgui.Create( "DScrollPanel", window )
	side_menu:SetWide( w * 0.15 )
	side_menu:Dock( LEFT )
	side_menu:DockMargin( w * 0.01, w * 0.01, 0, w * 0.01 )
	side_menu:GetCanvas():DockPadding( 0, w * 0.005, w * 0.005, w * 0.005 )

	//side_menu:GetVBar():SetWide( 0 )
	side_menu.VBar:SetHideButtons( true )
	side_menu.VBar:SetWide( 8 )

	side_menu.VBar.Paint = function( this, pw, ph )
		draw.RoundedBox( 15, 0, 0, pw, ph, COLOR.vbar )
	end

	side_menu.VBar.btnGrip.Paint = function( this, pw, ph )
		draw.RoundedBox( 15, 1, 1, pw - 2, ph - 2, COLOR.vbar_grip )
	end

	side_menu.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.border )
		surface.DrawLine( pw - 1, 0, pw - 1, ph )
		//surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	local main_panel = vgui.Create( "DScrollPanel", window )
	main_panel:Dock( FILL )
	main_panel:DockMargin( w * 0.01, w * 0.01, w * 0.01, w * 0.01 )
	main_panel:GetCanvas():DockPadding( 0, w * 0.005, w * 0.005, w * 0.005 )

	//main_panel:GetVBar():SetWide( 0 )
	main_panel.VBar:SetHideButtons( true )
	main_panel.VBar:SetWide( 8 )

	main_panel.VBar.Paint = function( this, pw, ph )
		draw.RoundedBox( 15, 0, 0, pw, ph, COLOR.vbar )
	end

	main_panel.VBar.btnGrip.Paint = function( this, pw, ph )
		draw.RoundedBox( 15, 1, 1, pw - 2, ph - 2, COLOR.vbar_grip )
	end

	main_panel.Paint = function( self, pw, ph )
	end

	table.sort( WINDOW_PANELS, function( a, b )
		return ( a.z or 0 ) > ( b.z or 0 )
	end )

	for i, v in ipairs( WINDOW_PANELS ) do
		if v.show == nil or v.show ==true or isfunction( v.show ) and v.show() then
			local btn = vgui.Create( "DButton", side_menu )
			btn:SetTall( h * 0.05 )
			btn:Dock( TOP )
			btn:SetText( "" )

			btn.Paint = function( self, pw, ph )
				if i == main_panel.SelectedMenu then
					surface.SetDrawColor( COLOR.selected )
					surface.SetMaterial( MATS.fade )
					surface.DrawTexturedRect( 0, 0, pw * 0.75, ph )
				end

				if self:IsHovered() then
					surface.SetDrawColor( COLOR.hover )
					surface.SetMaterial( MATS.fade )
					surface.DrawTexturedRect( 0, 0, pw * 0.9, ph )
				end

				if i == main_panel.SelectedMenu then
					surface.SetDrawColor( COLOR.white )
					//surface.DrawLine( 0, ph - 1, pw * 0.8, ph - 1 )
					surface.SetMaterial( MATS.fade )
					surface.DrawTexturedRect( 0, ph - 1, pw * 0.8, 1 )
				else
					surface.SetDrawColor( COLOR.inactive )
					//surface.DrawLine( 0, ph - 1, pw * 0.8, ph - 1 )
					surface.SetMaterial( MATS.fade )
					surface.DrawTexturedRect( 0, ph - 1, pw * 0.8, 1 )
				end

				draw.Text{
					text = LANG.settings.panels[v.name] or v.name,
					pos = { pw * 0.01, ph * 0.5 },
					font = "SCPHUDSmall",
					color = COLOR.white,
					xalign = TEXT_ALIGN_LEFT,
					yalign = TEXT_ALIGN_CENTER,
				}
			end

			btn.DoClick = function( self )
				if main_panel.SelectedMenu != i then
					main_panel:Clear()

					main_panel.SelectedMenu = i
					main_panel.SelectedMenuName = v.name

					v.create( main_panel )
				end
			end
		end
	end

	local first = WINDOW_PANELS[1]
	if first then
		main_panel.SelectedMenu = 1
		main_panel.SelectedMenuName = first.name
		first.create( main_panel )
	end

	return window
end

--[[-------------------------------------------------------------------------
Base hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCGamemodeLoaded", "SLCSettings", function()
	hook.Run( "SLCRegisterSettings" )

	for k, v in pairs( SLC_SETTINGS ) do
		if v.cvar then continue end
		DEFAULT_SETTINGS[k] = v.default
	end

	local data = {}

	if !file.Exists( "slc/client_settings.json", "data" ) then
		file.Write( "slc/client_settings.json", util.TableToJSON( DEFAULT_SETTINGS ) )
	else
		local tab = util.JSONToTable( file.Read( "slc/client_settings.json" ) )
		if tab then
			data = tab
		else
			print( "Client settings file is corrupted!" )
		end
	end

	for k, v in pairs( SLC_SETTINGS ) do
		if data[k] != nil then
			v.value = data[k]
		else
			v.value = v.default
		end
		
		processSettingsEntry( k )
	end

	checkForConflicts()
	//PrintTable( SLC_SETTINGS )
	SaveSettings()
end )

hook.Add( "SLCRegisterSettings", "SLCBaseSettings", function()
	RegisterSettingsEntry( "eq_button", "bind", "bind:+menu" )
	RegisterSettingsEntry( "upgrade_tree_button", "bind", "bind:+zoom" )
	RegisterSettingsEntry( "ppshop_button", "bind", "key:F1" )
	RegisterSettingsEntry( "settings_button", "bind", "none" )
end )

hook.Add( "SLCFactoryReset", "SLCSettingsReset", function()
	for k, v in pairs( SLC_SETTINGS ) do
		if v.cvar then continue end
		v.value = v.default
	end

	SaveSettings()
	processAllSettings()
end )

--[[-------------------------------------------------------------------------
Binds panel
---------------------------------------------------------------------------]]
AddSettingsPanel( "binds", function( parent )
	local binds = {}

	for k, v in pairs( SLC_SETTINGS ) do
		if v.stype == "bind" and ( !v.panel or v.panel == "binds" ) then
			table.insert( binds, { name = k, data = v } )
		end
	end

	table.sort( binds, function( a, b ) return a.data.id < b.data.id end )

	local w, h = ScrW(), ScrH()
	for i, v in ipairs( binds ) do
		local pnl = vgui.Create( "DPanel", parent )
		pnl:SetTall( h * 0.07 )
		pnl:Dock( TOP )
		pnl:DockMargin( 0, h * 0.01, 0, 0 )

		pnl.Paint = function( self, pw, ph )
			surface.SetDrawColor( COLOR.border )
			surface.DrawLine( 0, ph - 1, pw, ph - 1 )
		end

		local options_margin = w * 0.006
		local options = vgui.Create( "DPanel", pnl )
		options:SetWide( h * 0.16 )
		options:Dock( RIGHT )
		options:DockPadding( options_margin, options_margin, options_margin, options_margin )

		options.Paint = function( self, pw, ph ) end

		local btn_width = h * 0.07 - options_margin * 1.5

		local clear_btn
		local reset_btn = vgui.Create( "DButton", options )
		reset_btn:SetWide( btn_width )
		reset_btn:Dock( LEFT )
		reset_btn:SetText( "" )
		reset_btn.Paint = function( self, pw, ph )
			if self:IsEnabled() and self:IsHovered() then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			if !self:IsEnabled() then
				surface.SetDrawColor( COLOR.inactive )
			end

			local ico_size = pw * 0.4
			surface.SetMaterial( MATS.reset )
			surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
		end
		reset_btn.DoClick = function( self )
			v.data.value = v.data.default

			processSettingsEntry( v.name )
			checkForConflicts()
			SaveSettings()

			reset_btn:SetEnabled( v.data.value != v.data.default )
			clear_btn:SetEnabled( v.data.value != "none" )
		end

		local rb_enabled = reset_btn.SetEnabled
		reset_btn.SetEnabled = function( self, enabled )
			self:SetCursor( enabled and "hand" or "arrow" )
			rb_enabled( self, enabled )
		end

		reset_btn:SetEnabled( v.data.value != v.data.default )

		clear_btn = vgui.Create( "DButton", options )
		clear_btn:SetWide( btn_width )
		clear_btn:Dock( RIGHT )
		clear_btn:SetText( "" )
		clear_btn.Paint = function( self, pw, ph )
			if self:IsEnabled() and self:IsHovered() then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			if !self:IsEnabled() then
				surface.SetDrawColor( COLOR.inactive )
			end

			local ico_size = pw * 0.4
			surface.SetMaterial( MATS.exit )
			surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
		end
		clear_btn.DoClick = function( self )
			v.data.value = "none"

			processSettingsEntry( v.name )
			checkForConflicts()
			SaveSettings()

			reset_btn:SetEnabled( v.data.value != v.data.default )
			clear_btn:SetEnabled( v.data.value != "none" )
		end

		local cb_enabled = clear_btn.SetEnabled
		clear_btn.SetEnabled = function( self, enabled )
			self:SetCursor( enabled and "hand" or "arrow" )
			cb_enabled( self, enabled )
		end

		clear_btn:SetEnabled( v.data.value != "none" )

		local binder = vgui.Create( "DBinder", pnl )
		binder:SetWide( w * 0.15 )
		binder:Dock( RIGHT )
		binder:DockMargin( options_margin, options_margin, options_margin, options_margin )
		binder:SetText( "" )

		binder.SetText = function() end
		binder.DoRightClick = function() end

		binder.Paint = function( self, pw, ph )
			if self:IsHovered() or self.Trapping then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			local b_text = ""
			local b_color = COLOR.white

			if self.Trapping then
				b_text = LANG.settings.press_key
			else
				b_text = v.data.key and string.upper( v.data.key ) or LANG.settings.none

				if v.data.bind then
					b_text = b_text.."  /  "..v.data.bind
				end

				if v.data.key_conflict then
					b_color = COLOR.conflict
				end
			end

			draw.Text{
				text = b_text,
				pos = { pw * 0.5, ph * 0.5 },
				font = "SCPHUDSmall",
				color = b_color,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		binder.OnChange = function( self, value )
			if value != v.data.key_code and value != MOUSE_LEFT and value != MOUSE_RIGHT then
				if !value or value == 66 then
					v.data.value = "none"
				else
					local name = input.GetKeyName( value )
					if name then
						v.data.value = "key:"..name
					else
						v.data.value = "code:"..value
					end
				end

				reset_btn:SetEnabled( v.data.value != v.data.default )
				clear_btn:SetEnabled( v.data.value != "none" )

				processSettingsEntry( v.name )
				checkForConflicts()
				SaveSettings()
			end
		end

		local name = vgui.Create( "DPanel", pnl )
		name:Dock( FILL )
		name:DockMargin( options_margin, options_margin, options_margin, options_margin )

		name.Paint = function( self, pw, ph )
			//surface.SetDrawColor( COLOR.white )
			//surface.DrawOutlinedRect( 0, 0, pw, ph )

			draw.Text{
				text = LANG.settings.binds[v.name] or v.name,
				pos = { 0, ph * 0.5 },
				font = "SCPHUDMedium",
				color = COLOR.white,
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
	end
end, nil, 10000 )

--[[-------------------------------------------------------------------------
General config
---------------------------------------------------------------------------]]
local color_white = Color( 255, 255, 255 )
local color_gray = Color( 155, 155, 155 )
function AddConfigControl( parent, data, marg )
	if data.stype == "switch" then
		marg = marg * 1.5

		local inner
		local switch = vgui.Create( "DButton", parent )
		switch:SetText( "" )
		switch:Dock( RIGHT )
		switch:DockMargin( marg, marg, marg, marg )
		switch:SetWide( ScrW() * 0.066 )

		switch.color = data.value and Color( 0, 175, 0 ) or Color( 175, 0, 0 )

		switch.Paint = function( this, pw, ph )
			draw.RoundedBox( 8, 0, 0, pw, ph, color_white )
			draw.RoundedBox( 8, 1, 1, pw - 2, ph - 2, this.color )
		end

		switch.DoClick = function( this )
			inner:DoClick()
		end

		inner = vgui.Create( "DButton", switch )
		inner:SetText( "" )
		inner:SetPos( 0, 0 )

		switch.state = data.value

		inner.DoClick = function( this )
			if this.anim then return end

			switch.state = !switch.state
			data.value = switch.state

			this.anim = true

			local anim = this:NewAnimation( 0.25, 0, -1, function( tab, pnl )
				this.anim = false
			end)

			anim.Think = function( tab, pnl, f )
				if !switch.state then
					f = 1 - f
				end

				switch.color = Color( 175 * ( 1 - f ), 175 * f, 0 )

				pnl:SetPos( switch:GetWide() * 0.5 * f )
			end

			processSettingsEntry( switch.state )
			SaveSettings()
		end

		inner.Paint = function( this, pw, ph )
			draw.RoundedBox( 8, 1, 1, pw - 2, ph - 2, color_gray )
		end

		switch.PerformLayout = function( this, pw, ph )
			this:SetWide( ph * 2 )
			inner:SetSize( ph, ph )

			if this.state then
				inner:SetPos( ph, 0 )
			end
		end
	elseif data.stype == "dropbox" then
		local w = ScrW()

		local options = {}

		for i, v in ipairs( data.data.list or {} ) do
			if istable( v ) then
				options[i] = v
			else
				local tab = LANG.settings.config[data.name.."_options"]
				options[i] = { v, tab and tab[v] or v }
			end
		end

		local dropbox = vgui.Create( "SLCDropbox", parent )
		dropbox:Dock( RIGHT )
		dropbox:DockMargin( marg, marg, marg, marg )
		dropbox:SetWide( w * 0.15 )
		dropbox:SetOptions( options )
		dropbox:SetActive( data.value )

		dropbox.OnSelect = function( this, id, value )
			data.value = value

			if data.data.callback then
				if data.data.callback( value ) == true then return end
			end

			if data.cvar then
				data.cvar:SetString( value )
			end
		end
	end
end

local order = {
	dropbox = 1,
	switch = 3,
}

function AddConfigPanel( panel_name, sort, def )
	AddSettingsPanel( panel_name, function( parent )
		local tab = {}

		for k, v in pairs( SLC_SETTINGS ) do
			if order[v.stype] and ( def and !v.panel or v.panel == panel_name ) then
				table.insert( tab, { name = k, data = v, sorting = order[v.stype] } )
			end
		end

		table.sort( tab, function( a, b )
			if a.sorting != b.sorting then
				return a.sorting < b.sorting
			end

			return a.data.id < b.data.id
		end )

		local w, h = ScrW(), ScrH()
		local options_margin = w * 0.006

		for i, v in ipairs( tab ) do
			local pnl = vgui.Create( "DPanel", parent )
			pnl:SetTall( h * 0.06 )
			pnl:Dock( TOP )
			pnl:DockMargin( 0, h * 0.01, 0, 0 )

			pnl.Paint = function( this, pw, ph )
				surface.SetDrawColor( COLOR.border )
				surface.DrawLine( 0, ph - 1, pw, ph - 1 )
			end

			AddConfigControl( pnl, v.data, options_margin )

			local name = vgui.Create( "DPanel", pnl )
			name:Dock( FILL )
			name:DockMargin( options_margin, options_margin, options_margin, options_margin )
			name.Paint = function( this, pw, ph )
				draw.Text{
					text = LANG.settings.config[v.name] or v.name,
					pos = { 0, ph * 0.5 },
					font = "SCPHUDSmall",
					color = COLOR.white,
					xalign = TEXT_ALIGN_LEFT,
					yalign = TEXT_ALIGN_CENTER,
				}
			end
		end
	end, nil, sort )
end

AddConfigPanel( "general_config", 9000, true )

--[[-------------------------------------------------------------------------
Reset panel
---------------------------------------------------------------------------]]
AddSettingsPanel( "reset", function( parent )
	local w, h = ScrW(), ScrH()

	local side_panel_left = vgui.Create( "DPanel", parent )
	side_panel_left:SetWide( w * 0.15 )
	side_panel_left:Dock( LEFT )
	side_panel_left.Paint = function() end

	local side_panel_right = vgui.Create( "DPanel", parent )
	side_panel_right:SetWide( w * 0.15 )
	side_panel_right:Dock( RIGHT )
	side_panel_right.Paint = function() end

	local client_btn = vgui.Create( "DButton", parent )
	client_btn:SetTall( h * 0.075 )
	client_btn:Dock( TOP )
	client_btn:DockMargin( 0, h * 0.075, 0, 0 )
	client_btn:SetText( "" )

	client_btn.Paint = function( self, pw, ph )
		if self:IsHovered() then
			surface.SetDrawColor( COLOR.hover )
			surface.DrawRect( 0, 0, pw, ph )
		end

		surface.SetDrawColor( COLOR.white )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.settings.client_reset,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.conflict,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	client_btn.DoClick = function( self )
		SLCPopupIfEmpty( LANG.settings.client_reset, LANG.settings.client_reset_desc, true, function( i )
			if i == 1 then
				SLC_SETTINGS_WINDOW:Close()
				hook.Run( "SLCFactoryReset" )
			end	
		end, LANG.settings.popup_continue, LANG.settings.popup_cancel )
	end

	if LocalPlayer():IsSuperAdmin() then
		local server_btn = vgui.Create( "DButton", parent )
		server_btn:SetTall( h * 0.075 )
		server_btn:Dock( TOP )
		server_btn:DockMargin( 0, h * 0.2, 0, 0 )
		server_btn:SetText( "" )

		server_btn.Paint = function( self, pw, ph )
			if self:IsHovered() then
				surface.SetDrawColor( COLOR.hover )
				surface.DrawRect( 0, 0, pw, ph )
			end

			surface.SetDrawColor( COLOR.white )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			draw.Text{
				text = LANG.settings.server_reset,
				pos = { pw * 0.5, ph * 0.5 },
				font = "SCPHUDMedium",
				color = COLOR.conflict,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		server_btn.DoClick = function( self )
			SLCPopupIfEmpty( LANG.settings.server_reset, LANG.settings.server_reset_desc, true, nil, LANG.settings.popup_ok )
		end
	end
end, nil, 100 )

/*timer.Simple( 0.1, function()
	if IsValid( SLC_SETTINGS_WINDOW ) then SLC_SETTINGS_WINDOW:Close() end
	OpenSettingsWindow()
end )*/