--[[-------------------------------------------------------------------------
Materials, colors, etc.
---------------------------------------------------------------------------]]
local mat_move = Material( "slc/hud/skin_default/move.png", "smooth" )
local mat_hand = Material( "slc/hud/skin_default/hand.png", "smooth" )
local mat_id = Material( "slc/hud/skin_default/id.png", "smooth" )
local mat_vest = Material( "slc/hud/skin_default/vest.png", "smooth" )
local mat_enabled = Material( "slc/hud/skin_default/gear.png", "smooth" )
local mat_swap = Material( "slc/hud/skin_default/swap.png", "smooth" )
local mat_combine = Material( "slc/hud/skin_default/combine.png", "smooth" )

local def_swep = surface.GetTextureID( "weapons/swep" )

local color_white = Color( 255, 255, 255 )
local select_color = Color( 255, 210, 0 )

--[[-------------------------------------------------------------------------
EQ
---------------------------------------------------------------------------]]
local function create_eq()
	if IsValid( EQ ) then
		EQ:Remove()
	end

	local h = ScrH()
	local eq_h = math.ceil( h * 0.325 )
	local eq_pad = math.ceil( eq_h * 0.04 )

	local panel = vgui.Create( "DPanel" )
	EQ = panel

	panel.Padding = eq_pad
	panel.Items = {}
	panel.LastTransition = 0

	panel:SetTall( eq_h )
	panel:DockPadding( eq_pad, 0, eq_pad, eq_pad )

	panel.Paint = function( this, pw, ph )
		surface.SetDrawColor( 0, 0, 0, 175 )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( 175, 175, 175 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	panel.PerformLayout = function( this, pw, ph )
		this.Actions:SetWide( pw * 0.5 )
		this.Actions:SetPos( this:GetX() + pw + eq_pad, this:GetY() )

		this.Actions.DX = pw + eq_pad

		local title_h = this.Title:GetTall()
		this.Move:SetSize( pw - eq_pad * 2, title_h + eq_pad )
		this.Move:SetPos( eq_pad, 0 )
		this.Move.DraggableHeight = title_h

		this.BasicEQ:SetWide( ( this.BasicEQ:GetTall() - eq_pad * 2 ) / 3 + eq_pad )
		this.EQ:SizeToContents()
	end

	panel.SizeToContents = function( this )
		this:SetWide( this.BasicEQ:GetWide() + this.EQ:GetWide() + eq_pad )
	end

	local actions = vgui.Create( "DPanel" )
	panel.Actions = actions

	actions:DockPadding( eq_pad, 0, eq_pad, eq_pad )
	actions:MakePopup()
	actions:SetKeyboardInputEnabled( false )
	actions:Hide()

	actions.Linked = true

	actions.Think = function( this )
		if !IsValid( panel ) then
			this:Remove()
		end
	end

	actions.Paint = function( this, pw, ph )
		surface.SetDrawColor( 0, 0, 0, 175 )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( 175, 175, 175 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	actions.PerformLayout = function( this, pw, ph )
		local header_h = this.Header:GetTall()
		this.Move:SetSize( pw - eq_pad * 2, header_h + eq_pad )
		this.Move:SetPos( eq_pad, 0 )
		this.Move.DraggableHeight = header_h
	end

	actions.SizeToContents = function( this )
		local total_h = this.Header:GetTall() + eq_pad
		local any = false

		for i, v in ipairs( this.List:GetChildren() ) do
			if v:IsMarkedForDeletion() then continue end

			total_h = total_h + v:GetTall() + eq_pad
			any = true
		end

		if !any then
			this:SetTall( 0 )
			return
		end

		local max_h = panel:GetTall()
		if total_h > max_h then
			total_h = max_h
		end

		this:SetTall( total_h )
	end

	local a_header = vgui.Create( "DLabel", actions )
	actions.Header = a_header

	a_header:Dock( TOP )
	a_header:DockMargin( 0, 0, 0, eq_pad )

	a_header:SetFont( "SCPHUDSmall" )
	a_header:SetTextColor( color_white )
	a_header:SetText( LANG.EQ.actions )

	a_header:SizeToContents()

	a_header.Paint = function( this, pw, ph )
		surface.SetDrawColor( 125, 125, 125 )
		surface.DrawLine( 0, ph - 1, pw * 0.5, ph - 1 )
	end

	local a_list = vgui.Create( "DPanel", actions )
	actions.List = a_list

	a_list:Dock( FILL )
	a_list:SetPaintBackground( false )

	a_list.PerformLayout = function( this, pw, ph )
		local full_h = panel:GetTall()
		local item_h = math.Clamp( full_h / #this:GetChildren(), 16, full_h * 0.175 )
		for i, v in ipairs( this:GetChildren() ) do
			v:SetTall( item_h )
		end
	end

	local a_move = vgui.Create( "DefaultEQ.MoveButton", actions )
	actions.Move = a_move

	a_move:BindPanel( actions )

	a_move.OnMove = function( this, nx, ny )
		actions.Linked = false
	end

	a_move.FinishMove = function( this )
		if actions:Within( panel ) then
			actions.Linked = true
			actions:SetPos( panel:GetX() + panel:GetWide() + eq_pad, panel:GetY() )
		end
	end
	--[[-------------------------------------------------------------------------
	Header
	---------------------------------------------------------------------------]]
	local title = vgui.Create( "DLabel", panel )
	panel.Title = title

	title:Dock( TOP )
	title:DockMargin( 0, 0, 0, eq_pad )

	title:SetFont( "SCPHUDSmall" )
	title:SetTextColor( color_white )
	title:SetText( LANG.EQ.eq )

	title:SizeToContents()

	title.Paint = function( this, pw, ph )
		surface.SetDrawColor( 125, 125, 125 )
		surface.DrawLine( 0, ph - 1, pw * 0.333, ph - 1 )
	end

	local main_move = vgui.Create( "DefaultEQ.MoveButton", panel )
	panel.Move = main_move

	main_move:BindPanel( panel )

	main_move.OnMove = function( this, nx, ny )
		if !actions.Linked then return end

		actions:SetPos( nx + actions.DX, ny )
	end

	--[[-------------------------------------------------------------------------
	Basic EQ
	---------------------------------------------------------------------------]]
	local basic_eq = vgui.Create( "DPanel", panel )
	panel.BasicEQ = basic_eq

	basic_eq:Dock( LEFT )
	//basic_eq:DockMargin( 0, 0, 0, 0 )

	basic_eq.Paint = function( this, pw, ph )
		surface.SetDrawColor( 125, 125, 125 )
		surface.DrawLine( pw - 1, 0, pw - 1, ph )
	end

	basic_eq.PerformLayout = function( this, pw, ph )
		this.Holster:SetTall( this.Holster:GetWide() )
		this.ID:SetTall( this.ID:GetWide() )
		this.Armor:SetTall( this.Armor:GetWide() )
	end

	local holster = vgui.Create( "DefaultEQ.BasicButton", basic_eq )
	basic_eq.Holster = holster

	holster:Dock( TOP )
	holster:DockMargin( 0, 0, eq_pad, 0 )
	holster:SetMaterial( mat_hand )
	panel.Items[0] = holster

	local id = vgui.Create( "DefaultEQ.BasicButton", basic_eq )
	basic_eq.ID = id

	id:Dock( TOP )
	id:DockMargin( 0, eq_pad, eq_pad, eq_pad )
	id:SetMaterial( mat_id )
	panel.Items[-1] = id

	id.RebuildDescription = function( this )
		local id_text = MarkupBuilder()
		id_text:PushFont( "SCPHUDSmall" )

		local ply = LocalPlayer()
		local t = ply:SCPTeam()
		local c = ply:SCPClass()
		local t_name = SCPTeams.GetName( t )
		local t_color = SCPTeams.GetColor( t )

		if this.Item then
			id_text:Print( LANG.EQ.id ):Print( "\n" )
		else
			id_text:Print( LANG.EQ.no_id ):Print( "\n" )
		end

		id_text:Print( string.rep( "-", 32 ) ):Print( "\n" )

		id_text:Print( LANG.EQ.class ):Print( LANG.CLASSES[c] or c, t_color ):Print( "\n" )
		id_text:Print( LANG.EQ.team ):Print( LANG.TEAMS[t_name] or t_name, t_color ):Print( "\n" )

		local pc, pt = ply:SCPPersona()
		if pc != c or pt != t then
			local pt_name = SCPTeams.GetName( pt )
			local pt_color = SCPTeams.GetColor( pt )

			id_text:Print( string.rep( "-", 32 ) ):Print( "\n" )
			id_text:Print( LANG.EQ.p_class ):Print( LANG.CLASSES[pc] or pc, pt_color ):Print( "\n" )
			id_text:Print( LANG.EQ.p_team ):Print( LANG.TEAMS[pt_name] or pt_name, pt_color ):Print( "\n" )
		end

		local allies = SCPTeams.GetAllies( t )
		if #allies > 0 then
			id_text:Print( string.rep( "-", 32 ) ):Print( "\n" )
			id_text:Print( LANG.EQ.allies ):Print( "\n" )

			for i, v in ipairs( allies ) do
				local a_name = SCPTeams.GetName( v )
				id_text:Print("    • "):Print( LANG.TEAMS[a_name] or a_name, SCPTeams.GetColor( v ) ):Print("\n")
			end
		end

		this.Tooltip = markup.Parse( id_text:ToString(), ScrW() * 0.333 )
	end

	local vest = vgui.Create( "DefaultEQ.BasicButton", basic_eq )
	basic_eq.Armor = vest
	
	vest:Dock( TOP )
	vest:DockMargin( 0, 0, eq_pad, 0 )
	vest:SetMaterial( mat_vest )

	vest.OldThink = vest.Think
	vest.OldPaint = vest.Paint

	vest.Think = function( this )
		this:OldThink()

		local has_vest = LocalPlayer():GetVest() > 0
		this:SetEnabled( has_vest )

		if !this.Tooltip and has_vest then
			this:RebuildDescription()
		end
	end

	vest.Paint = function( this, pw, ph )
		this:OldPaint( pw, ph )

		local ply = LocalPlayer()
		local vest_id = ply:GetVest()
		if vest_id <= 0 then return end

		local data = VEST.GetData( vest_id )
		if data.durability < 0 then return end

		local dur = ply:GetVestDurability()
		if dur < 0 then return end

		if dur <= 0 then
			surface.SetDrawColor( 255, 0, 0, 10 )
			surface.DrawRect( 0, 0, pw, ph )
			return
		end

		surface.SetDrawColor( 200, 30, 75 )
		surface.DrawRect( 1, ph - 5, pw - 2, 4 )

		surface.SetDrawColor( 75, 30, 200 )
		surface.DrawRect( 1, ph - 5, ( pw - 2 ) * dur / data.durability, 4 )
	end

	vest.DoClick = function( this )
		this:SetCursor( "arrow" )
		this:SetEnabled( false )
		this.Tooltip = nil

		LocalPlayer():SetVest( 0 )

		net.Start( "DropVest" )
		net.SendToServer()
	end

	vest.RebuildDescription = function( this )
		local ply = LocalPlayer()
		local vest_id = ply:GetVest()

		if vest_id == 0 then
			this:SetCursor( "arrow" )
			this.Tooltip = nil
			return
		end
		
		this:SetCursor( "hand" )

		local data = VEST.GetData( vest_id )
		local dur = ply:GetVestDurability()

		local vest_text = MarkupBuilder()
		vest_text:PushFont( "SCPHUDSmall" )

		local vest_name = VEST.GetName( vest_id )
		vest_name = LANG.VEST[vest_name] or vest_name

		vest_text:Print( vest_name ):Print( "\n" )
		vest_text:Print( string.rep( "-", 32 ) ):Print( "\n" )

		if data and data.durability >= 0 and dur >= 0 then
			local pct = dur / data.durability
			vest_text:Print( LANG.EQ.durability ):Print( math.ceil( pct * 100 ).."%\n", Color( math.floor( 200 * ( 1 - pct ) ), math.floor( 200 * pct ), 30 ) )
		end

		vest_text:Print( LANG.EQ.mobility ):Print( math.floor( data.mobility * 100 ).."%\n", Color( 200, 200, 30 ) )
		vest_text:Print( LANG.EQ.weight ):Print( data.weight.." "..LANG.EQ.weight_unit, Color( 200, 200, 30 ) ):Print( "\n" )
		vest_text:Print( LANG.EQ.multiplier ):Print( "\n" )

		for k, v in pairs( data.damage ) do
			if data.HIDE[k] then continue end
			
			local dmg_name = VEST.TranslateDamage( k )
			vest_text:Print( "    • "..( LANG.DMG[dmg_name] or dmg_name )..": " )
				:Print( math.Round( v * 100, 1 ).."%", v < 1 and Color( 30, 200, 30 ) or Color( 200, 30, 30 ) ):Print( "\n" )
		end

		this.Tooltip = markup.Parse( vest_text:ToString(), ScrW() * 0.333 )
	end

	local function eq_layout( this, pw, ph )
		for i, v in ipairs( this:GetChildren() ) do
			v:SetWide( v:GetTall() )
		end
	end

	--[[-------------------------------------------------------------------------
	EQ
	---------------------------------------------------------------------------]]
	local eq = vgui.Create( "DPanel", panel )
	panel.EQ = eq

	eq:Dock( LEFT )

	eq.Paint = function( this, pw, ph )
		//surface.SetDrawColor( 125, 125, 125 )
		//surface.DrawLine( pw - 1, 0, pw - 1, ph )
	end

	eq.PerformLayout = function( this, pw, ph )
		local row_h = ( ph - eq_pad ) * 0.5
		panel.RowHeight = row_h

		this.UpperEQ:SetTall( row_h )
		this.LowerEQ:SetTall( row_h )
	end

	eq.SizeToContents = function( this )
		this:SetWide( ( this:GetTall() - eq_pad ) * 0.5 * 3 + eq_pad * 4 )
	end

	local upper_eq = vgui.Create( "DPanel", eq )
	eq.UpperEQ = upper_eq

	upper_eq:Dock( TOP )
	upper_eq:SetPaintBackground( false )
	upper_eq.PerformLayout = eq_layout

	local lower_eq = vgui.Create( "DPanel", eq )
	eq.LowerEQ = lower_eq

	lower_eq:Dock( BOTTOM )
	lower_eq:SetPaintBackground( false )
	lower_eq.PerformLayout = eq_layout

	for i = 1, 6 do
		local item = vgui.Create( "DefaultEQ.ItemButton", i <= 3 and upper_eq or lower_eq )
		panel.Items[i] = item

		item.ID = i

		item:Dock( LEFT )
		item:DockMargin( eq_pad, 0, 0, 0 )
		item:SetZPos( ( i - 1 ) % 3 )
	end

	--[[-------------------------------------------------------------------------
	Utility functions
	---------------------------------------------------------------------------]]
	panel.UpdateItems = function( this )
		UpdatePlayerEQ()

		holster:BindItem( "item_slc_holster" )
		id:BindItem( "item_slc_id" )

		vest:RebuildDescription()

		for i, v in ipairs( panel.Items ) do
			v:BindItem( INVENTORY[i] )
		end
	end

	panel.UpdateActions = function( this )
		a_list:Clear()

		for i, v in ipairs( EQ_ACTIONS ) do
			if v.can_see != true and ( !isfunction( v.can_see ) or !v.can_see() ) then continue end

			local action = vgui.Create( "DefaultEQ.ActionButton", a_list )

			action:Dock( TOP )
			action:DockMargin( 0, 0, 0, eq_pad )
			action:BindAction( v )
		end

		a_list:InvalidateLayout( true )
		actions:SizeToContents()
	end

	panel.ClearBind = function( this, pnl, code )
		for i, v in ipairs( LocalPlayer():GetWeapons() ) do
			if pnl.Item == v or v.eq_bind != code then continue end
			v.eq_bind = nil
		end
	end

	panel:InvalidateLayout( true )
	panel:SizeToContents()
	panel:Center()
	panel:MakePopup()
	panel:SetKeyboardInputEnabled( false )
	panel:Hide()
end

AddGUISkin( "eq", "default", {
	create = function()
		create_eq()
		
		hook.Add( "SLCLanguageChanged", "EQ.Default.Lang", function()
			create_eq()
		end )

		hook.Add( "PlayerButtonDown", "DefaultEQ.ButtonDown", function( ply, btn )
			if !IsFirstTimePredicted() or EQ:IsVisible() or btn < KEY_0 or btn > KEY_9 then return end
			if hook.Run( "SLCCanUseBind", "eq_loadout" ) == false then return end

			for i, v in ipairs( ply:GetWeapons() ) do
				if v and v.eq_bind == btn then
					input.SelectWeapon( v )
					break
				end
			end
		end )
	end,
	remove = function()
		EQ:Remove()
		hook.Remove( "SLCLanguageChanged", "EQ.Default.Lang" )
		hook.Remove( "PlayerButtonDown", "DefaultEQ.ButtonDown" )
	end,
	show =  function()
		if !EQ:IsVisible() and EQ.SavedMouseX and EQ.SavedMouseY then
			input.SetCursorPos( EQ.SavedMouseX, EQ.SavedMouseY )
		end

		EQ:UpdateItems()
		EQ:UpdateActions()
		EQ:Show()
		EQ.Actions:Show()
	end,
	hide = function()
		if !EQ:IsVisible() or IsValid( EQ.BACKPACK ) and !EQ.BACKPACK.Removed then return end
		
		dragndrop.StopDragging()

		EQ.SavedMouseX = gui.MouseX()
		EQ.SavedMouseY = gui.MouseY()
		EQ:Hide()
		EQ.Actions:Hide()
	end,
	open_backpack = function()
		if IsValid( EQ.BACKPACK ) then
			EQ.BACKPACK.Removed = true
			EQ.BACKPACK:Remove()
		end

		EQ.BACKPACK = vgui.Create( "DefaultEQ.Backpack" )
	end,
	close_backpack = function()
		if IsValid( EQ.BACKPACK ) then
			EQ.BACKPACK.Removed = true
			EQ.BACKPACK:Remove()
		end

		if !input.IsButtonDown( GetBindButton( "eq_button" ) ) then
			HideGUIElement( "eq" )
		end
	end,
	is_visible = function()
		return EQ:IsVisible()
	end,
} )

--[[-------------------------------------------------------------------------
Move button
---------------------------------------------------------------------------]]
local PANEL = {}

PANEL.DraggableHeight = 0

function PANEL:Init()
	self:SetText( "" )
	self:SetCursor( "arrow" )

	local image = vgui.Create( "DPanel", self )
	self.Image = image

	image:SetCursor( "hand" )

	image.Paint = function( this, pw, ph )
		this:NoClipping( false )

		surface.SetDrawColor( 175, 175, 175 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	
		surface.SetMaterial( mat_move )
		surface.DrawTexturedRect( pw * 0.125, ph * 0.125, pw * 0.75, ph * 0.75 )

		this:NoClipping( true )
	end

	image.OnMousePressed = function( this, code )
		self:OnMousePressed( code, true )
	end
end

function PANEL:Think()
	if !self.Moving then return end

	if !input.IsMouseDown( MOUSE_LEFT ) then
		self.Moving = false

		if self.FinishMove then
			self:FinishMove()
		end

		return
	end

	local mx, my = input.GetCursorPos()
	local new_x, new_y = math.Clamp( mx + self.DX, 0, ScrW() - self.MovePanel:GetWide() ), math.Clamp( my + self.DY, 0, ScrH() - self.MovePanel:GetTall() )
	self.MovePanel:SetPos( new_x, new_y )

	if self.OnMove then
		self:OnMove( new_x, new_y )
	end
end

function PANEL:PerformLayout( w, h )
	local size = h * 0.6
	self.Image:SetSize( size, size )
	self.Image:SetPos( w - size, h * 0.2 )
end

function PANEL:Paint( w, h )
	
end

function PANEL:OnMousePressed( code, override )
	if !self.MovePanel or code != MOUSE_LEFT then return end

	local _, my = self:ScreenToLocal( 0, gui.MouseY() )
	if !override and self.DraggableHeight > 0 and my > self.DraggableHeight then return end

	self.Moving = true
	self.DX = self.MovePanel:GetX() - gui.MouseX()
	self.DY = self.MovePanel:GetY() - gui.MouseY()
end

function PANEL:BindPanel( pnl )
	self.MovePanel = pnl
end

vgui.Register( "DefaultEQ.MoveButton", PANEL, "DButton" )

--[[-------------------------------------------------------------------------
Basic Button
---------------------------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
	self:SetText( "" )
	self:SetCursor( "arrow" )
end

function PANEL:HoveredButtonDown( code )
	if !IsFirstTimePredicted() or hook.Run( "SLCCanUseBind", "eq_loadout" ) == false then return end
	if code < KEY_0 or code > KEY_9 or !IsValid( self.Item ) then return end
	if self.Item.Selectable == false /*and self.Item.Toggleable == false*/ then return end

	
	if self.Item:GetClass() == "item_slc_backpack" or self.Item.eq_bind == code then
		self.Item.eq_bind = nil
	else
		EQ:ClearBind( self, code )
		self.Item.eq_bind = code
	end
end

function PANEL:RebuildDescription()
	if !IsValid( self.Item ) then return end

	local desc = MarkupBuilder()
	desc:PushFont( "SCPHUDSmall" )

	local tab = LANG.WEAPONS[self.Item:GetClass()]
	local wep_name = istable( tab ) and tab.name or isstring( tab ) and tab

	if !wep_name then
		wep_name = self.Item.PrintName or self.Item.GetPrintName and self.Item:GetPrintName() or LANG.eq_unknown
	end

	desc:Print( wep_name ):Print( "\n" )

	if self.Item.Stacks and self.Item.Stacks > 1 then
		desc:Print(LANG.EQ.count..": "):Print( self.Item:GetCount(), Color( 200, 200, 30 ) ):Print( "\n" )
	end

	if self.Item.BuildDescription then
		desc:Print( string.rep( "-", 32 ) ):Print( "\n" )
		self.Item:BuildDescription( desc )
	elseif self.Item.Info then
		desc:Print( string.rep( "-", 32 ) ):Print( "\n" )
		desc:Print( self.Item.Info )
	end

	self.Tooltip = markup.Parse( desc:ToString(), ScrW() * 0.333 )
end

vgui.Register( "DefaultEQ.ButtonBase", PANEL, "DButton" )

--[[-------------------------------------------------------------------------
Basic Button
---------------------------------------------------------------------------]]
PANEL = {}

PANEL.HoverTime = false

function PANEL:Think()
	if self:IsHovered() then
		local instant = GetSettingsValue( "eq_instant_desc" )

		if self.HoverTime == 0 then
			self.HoverTime = RealTime()
		elseif instant or self.HoverTime < RealTime() - 0.5 then
			SLCToolTip( self.Tooltip )
		end
	else
		self.HoverTime = 0
	end
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.DrawRect( 0, 0, w, h )

	local wep = self.Item
	local is_active = wep and wep == LocalPlayer():GetActiveWeapon()

	if is_active then
		surface.SetDrawColor( 255, 210, 0 )
	elseif self:IsEnabled() then
		surface.SetDrawColor( 175, 175, 175 )
	else
		surface.SetDrawColor( 110, 110, 110 )
	end

	surface.DrawOutlinedRect( 0, 0, w, h )

	if !self.Material then return end

	if !is_active and self:IsHovered() and self:IsEnabled() then
		surface.SetDrawColor( 100, 100, 100, 75 )
		surface.DrawRect( 0, 0, w, h )
	end

	if self:IsEnabled() then
		surface.SetDrawColor( 255, 210, 0 )
	else
		surface.SetDrawColor( 90, 90, 90 )
	end

	surface.SetMaterial( self.Material )
	surface.DrawTexturedRect( h * 0.1, h * 0.1, h * 0.8, h * 0.8 )

	if IsValid( wep ) and wep.eq_bind then
		surface.SetDrawColor( 75, 75, 75 )
		draw.NoTexture()

		surface.DrawPoly( {
			{ x = 1, y = 1 },
			{ x = 1 + h * 0.4, y = 1 },
			{ x = 1, y = 1 + h * 0.4 },
		} )

		draw.Text{
			text = wep.eq_bind - KEY_0,
			pos = { h * 0.015, -h * 0.015 },
			font = "SCPHUDVSmall",
			color = select_color,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end
end

function PANEL:DoClick()
	if !self.ItemClass then return end

	local wep = LocalPlayer():GetWeapon( self.ItemClass )
	if !IsValid( wep ) then return end

	input.SelectWeapon( wep )
end

function PANEL:SetMaterial( mat )
	self.Material = mat
end

function PANEL:BindItem( class )
	local wep = LocalPlayer():GetWeaponByBase( class )
	if !IsValid( wep ) then
		self:SetCursor( "arrow" )
		self:SetEnabled( false )

		self.Item = nil
		self.ItemClass = nil
		self.Tooltip = nil

		self:RebuildDescription()
		return
	end

	self:SetEnabled( true )
	self:SetCursor( "hand" )

	self.Item = wep
	self.ItemClass = wep:GetClass()

	self:RebuildDescription()
end

vgui.Register( "DefaultEQ.BasicButton", PANEL, "DefaultEQ.ButtonBase" )

--[[-------------------------------------------------------------------------
Item Button
---------------------------------------------------------------------------]]
PANEL = {}

PANEL.ItemButton = true
PANEL.HoverTime = false
PANEL.Transition = 0
PANEL.Backpack = false

function PANEL:Init()
	self:Receiver( "SLCEQ", self.OnDrop )
end

function PANEL:Think()
	if self:IsHovered() and !dragndrop.IsDragging() and IsValid( self.Item ) then
		local instant = GetSettingsValue( "eq_instant_desc" )

		if self.HoverTime == 0 then
			self.HoverTime = RealTime()
			self:RebuildDescription()
		elseif instant or self.HoverTime < RealTime() - 0.5 then
			SLCToolTip( self.Tooltip )
		end
	else
		self.HoverTime = 0
	end

	UpdatePlayerEQ()

	if self.Item and !IsValid( self.Item ) then
		INVENTORY[self.ID] = nil
		self:BindItem( nil )
	elseif self.Item != INVENTORY[self.ID] then
		self:BindItem( INVENTORY[self.ID] )
	end
end

function PANEL:Paint( w, h )
	if !self.PaintingDragging then
		surface.SetDrawColor( 0, 0, 0, 100 )
		surface.DrawRect( 0, 0, w, h )
	end

	local ct = CurTime()
	local ply = LocalPlayer()
	local active_wep = ply:GetActiveWeapon()
	local is_active = self.Item and self.Item == active_wep

	if is_active then
		surface.SetDrawColor( 255, 210, 0 )
	else
		surface.SetDrawColor( 175, 175, 175 )
	end

	if !self.PaintingDragging then
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	if !self.ItemClass then
		local is_dragged_active = self.DropHovered and ( self.DropHovered.Item == active_wep or self.DropHovered.Item.Toggleable and self.DropHovered.Item:GetEnabled() )
		if self.DropHovered and ( !self.Backpack or self.DropHovered.ItemClass != "item_slc_backpack" and !is_dragged_active ) then
			surface.SetMaterial( mat_swap )
			surface.SetDrawColor( 175, 175, 175 )
			surface.DrawTexturedRect( w * 0.2, h * 0.2, w * 0.6, h * 0.6 )
		end

		self.DropHovered = nil
		return
	end

	if ( !is_active or dragndrop.IsDragging() ) and !self.PaintingDragging and self:IsHovered() then
		surface.SetDrawColor( 100, 100, 100, 75 )
		surface.DrawRect( 0, 0, w, h )
	end

	local wep = self.Item
	local wep_tab = INVENTORY_TEXTURES_OVERRIDE[self.ItemClass] or wep

	if self.Transition > ct then
		surface.SetAlphaMultiplier( math.TimedSinWave( 1, 0, 1 ) )
	end

	local icon = wep_tab.SelectIcon or wep_tab.WepSelectIcon
	if icon and icon != def_swep then
		draw.WepSelectIcon( icon, 0, 0, h, wep_tab.SelectColor )
	elseif wep_tab.SelectFont then
		local font = INVENTORY_FONTS_OVERRIDE[wep_tab.SelectFont] or wep_tab.SelectFont
		local dy = h * 0.5

		if font == "SCPCSSIcons" then
			dy = dy + h * 0.25
		end

		draw.Text{
			text = wep_tab.IconLetter or wep_tab.ShowName or wep_tab.PrintName,
			pos = { h * 0.5, dy },
			font = font,
			color = wep_tab.SelectColor or select_color,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	else
		draw.WepSelectIcon( def_swep, 0, 0, h, wep_tab.SelectColor )
	end

	surface.SetAlphaMultiplier( 1 )

	is_active = is_active or IsValid( self.Item ) and self.Item.Toggleable and self.Item:GetEnabled()

	if self.DropHovered and self.DropHovered != self and IsValid( self.DropHovered.Item ) and self.Transition < ct then
		local backpack = self.Backpack or self.DropHovered.Backpack
		local is_dragged_active = self.DropHovered.Item == active_wep or self.DropHovered.Item.Toggleable and self.DropHovered.Item:GetEnabled()
		if !backpack or ( self.ItemClass != "item_slc_backpack" and self.DropHovered.ItemClass != "item_slc_backpack" and !is_dragged_active and !is_active ) then
			if !backpack and IsValid( self.Item ) and self.Item.DragAndDrop and self.Item:DragAndDrop( self.DropHovered.Item, true ) then
				surface.SetMaterial( mat_combine )
			else
				surface.SetMaterial( mat_swap )
			end

			surface.SetDrawColor( 175, 175, 175 )
			surface.DrawTexturedRect( w * 0.2, h * 0.2, w * 0.6, h * 0.6 )
		end
	end

	self.DropHovered = nil

	if self.PaintingDragging then return end

	if self:IsDragging() and !self.PaintingDragging then
		local hovered = vgui.GetHoveredPanel()
		if hovered and hovered != self and hovered.ItemButton and hovered.Transition < ct then
			local backpack = self.Backpack or hovered.Backpack
			local is_other_active = hovered.Item == active_wep or IsValid( hovered.Item ) and hovered.Item.Toggleable and hovered.Item:GetEnabled()
			if !backpack or ( self.ItemClass != "item_slc_backpack" and hovered.ItemClass != "item_slc_backpack" and !is_active and !is_other_active ) then
				if !backpack and IsValid( hovered ) and IsValid( hovered.Item ) and hovered.Item.DragAndDrop and hovered.Item:DragAndDrop( self.Item, true ) then
					surface.SetMaterial( mat_combine )
				else
					surface.SetMaterial( mat_swap )
				end

				surface.SetDrawColor( 175, 175, 175 )
				surface.DrawTexturedRect( w * 0.2, h * 0.2, w * 0.6, h * 0.6 )
			end
		end
	end

	if wep.eq_bind then
		surface.SetDrawColor( 75, 75, 75 )
		draw.NoTexture()

		surface.DrawPoly( {
			{ x = 1, y = 1 },
			{ x = 1 + h * 0.25, y = 1 },
			{ x = 1, y = 1 + h * 0.25 },
		} )

		draw.Text{
			text = wep.eq_bind - KEY_0,
			pos = { h * 0.015, -h * 0.015 },
			font = "SCPHUDVSmall",
			color = select_color,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	if wep.Stacks and wep.Stacks > 1 then
		draw.Text{
			text = wep:GetCount(),
			pos = { h * 0.96, h },
			font = "SCPHUDSmall",
			color = select_color,
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		}
	end

	if wep.Toggleable and wep:GetEnabled() then
		PushFilters( TEXFILTER.LINEAR )
			surface.SetMaterial( mat_enabled )
			surface.SetDrawColor( 155, 155, 155, 155 )
			surface.DrawTexturedRect( h * 0.75 - 2, 2, h * 0.25, h * 0.25 )
		PopFilters()
	end

	if wep.HasBattery then
		local pct = wep:GetBattery() * 0.01

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( h * 0.85 + 2 - 2, h * 0.7 + 2 - 2, h * 0.15 - 4, h * 0.3 - 4 )

		surface.SetDrawColor( 255 * ( 1 - pct ), 255 * pct, 0 )
		surface.DrawRect( h * 0.85 + 4 - 2, h * 0.7 + 4 - 2 + ( h * 0.3 - 8 ) * ( 1 - pct ), h * 0.15 - 8, ( h * 0.3 - 8 ) * pct )
	end

	if wep.Durability and wep.Durability > 0 then
		local pct = math.Clamp( wep:GetDurability() / wep.Durability, 0, 1 )

		surface.SetDrawColor( 200, 30, 75 )
		surface.DrawRect( 1, h - 5, w - 2, 4 )

		surface.SetDrawColor( 75, 30, 200 )
		surface.DrawRect( 1, h - 5, ( w - 2 ) * pct, 4 )
	end
end

function PANEL:DoClick()
	if self.Backpack or !IsValid( self.Item ) or self.Transition > CurTime() then return end

	input.SelectWeapon( self.Item )
end

function PANEL:DoRightClick()
	if self.Backpack or !IsValid( self.Item ) or self.Item.Droppable == false or self.Transition > CurTime() then return end

	net.Start( "DropWeapon" )
		net.WriteString( self.ItemClass )
	net.SendToServer()

	if !self.Item.Stacks or self.Item.Stacks <= 1 or self.Item:GetCount() <= 1 then
		if self.Item.RemoveStack then self.Item:RemoveStack() end
		//INVENTORY[self.ID] = nil
		//self:BindItem( nil )
	end
end

function PANEL:OnDrop( tab, dropped )
	local dragged = tab[1]

	if !dropped then
		self.DropHovered = dragged
		return
	end

	local ct = CurTime()
	local ply = LocalPlayer()
	local active_wep = ply:GetActiveWeapon()
	local backpack = self.Backpack or dragged.Backpack

	if self.Transition > ct or dragged.Transition > ct then return end

	if !self.ItemClass then
		if backpack and ( dragged.ItemClass == "item_slc_backpack" or dragged.Item == active_wep or dragged.Item.Toggleable and dragged.Item:GetEnabled() ) then return end

		local from = dragged.ID
		local to = self.ID

		local from_item = INVENTORY[from]
		local to_item = INVENTORY[to]

		INVENTORY[to] = from_item
		INVENTORY[from] = nil

		//print( "EQ Move (1)", from_item, from, "<=>", to_item, to, "BP?", backpack )

		if backpack then 
			local transition = EQ.LastTransition
			if transition < ct then
				transition = ct
			end
	
			transition = transition + CVAR.slc_time_swapping:GetFloat()
			EQ.LastTransition = transition
			ply:SetProperty( "inventory_transition", transition )

			self.Transition = transition
		end

		net.Start( "SLCMoveItem" )
			net.WriteUInt( from, 8 )
			net.WriteString( IsValid( from_item ) and from_item:GetClass() or "" )
			net.WriteUInt( to, 8 )
			net.WriteString( IsValid( to_item ) and to_item:GetClass() or "" )
		net.SendToServer()
	elseif self != dragged then
		if !backpack and self.Item.DragAndDrop and self.Item:DragAndDrop( dragged.Item ) != false then
			net.Start( "WeaponDnD" )
				net.WriteEntity( dragged.Item )
				net.WriteEntity( self.Item )
			net.SendToServer()
		else
			if backpack and ( self.ItemClass == "item_slc_backpack" or dragged.ItemClass == "item_slc_backpack" ) then return end
			if backpack and ( self.Item == active_wep or dragged.Item == active_wep ) then return end
			if backpack and (
				IsValid( self.Item ) and self.Item.Toggleable and self.Item:GetEnabled() or dragged.Item == active_wep or
				IsValid( dragged.Item ) and dragged.Item.Toggleable and dragged.Item:GetEnabled() or dragged.Item == active_wep
			) then return end

			local from = dragged.ID
			local to = self.ID

			local from_item = INVENTORY[from]
			local to_item = INVENTORY[to]

			INVENTORY[to] = from_item
			INVENTORY[from] = to_item
			//print( "EQ Move (2)", from_item, from, "<=>", to_item, to, "BP?", backpack )

			if backpack then
				local transition = EQ.LastTransition
				if transition < ct then
					transition = ct
				end
		
				transition = transition + CVAR.slc_time_swapping:GetFloat()
				EQ.LastTransition = transition
				ply:SetProperty( "inventory_transition", transition )
				
				self.Transition = transition
				dragged.Transition = transition
			end

			net.Start( "SLCMoveItem" )
				net.WriteUInt( from, 8 )
				net.WriteString( IsValid( from_item ) and from_item:GetClass() or "" )
				net.WriteUInt( to, 8 )
				net.WriteString( IsValid( to_item ) and to_item:GetClass() or "" )
			net.SendToServer()
		end
	end
end

local PANEL_META = FindMetaTable( "Panel" )
function PANEL:DragMousePress( code )
	if self.Transition > CurTime() then return end
	PANEL_META.DragMousePress( self, code )
end

function PANEL:BindItem( item )
	if !IsValid( item ) then
		self:SetCursor( "arrow" )

		if self.m_DragSlot then
			self.m_DragSlot = nil
		end

		self.Item = nil
		self.ItemClass = nil
		self.Tooltip = nil

		return
	end

	self:SetCursor( "hand" )
	self:Droppable( "SLCEQ" )

	self.Item = item
	self.ItemClass = item:GetClass()

	self:RebuildDescription()
end

vgui.Register( "DefaultEQ.ItemButton", PANEL, "DefaultEQ.ButtonBase" )

--[[-------------------------------------------------------------------------
Action Button
---------------------------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
	self:SetText( "" )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 125 )
	surface.DrawRect( 0, 0, w, h )

	if self:IsHovered() and !input.IsMouseDown( MOUSE_LEFT ) then
		surface.SetDrawColor( 100, 100, 100, 75 )
		surface.DrawRect( 0, 0, w, h )
	end

	surface.SetDrawColor( 175, 175, 175 )
	surface.DrawOutlinedRect( 0, 0, w, h )

	local data = self.Action
	if !data then return end

	local ico_marg = math.ceil( h * 0.1 )
	local ico_h = h - ico_marg * 2

	if data.material then
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( data.material )
		surface.DrawTexturedRect( ico_marg, ico_marg, ico_h, ico_h )
	end

	local ct = CurTime()
	if data.cooldown and data.cd_time and data.cooldown > ct and data.cd_time > 0 then
		draw.NoTexture()
		surface.SetDrawColor( 0, 0, 0, 235 )
		surface.DrawCooldownRectCW( ico_marg, ico_marg, ico_h, ico_h, ( data.cooldown - ct ) / data.cd_time )
	end

	surface.SetDrawColor( 175, 175, 175 )
	surface.DrawOutlinedRect( ico_marg, ico_marg, ico_h, ico_h )

	draw.SimpleText( LANG.eq_buttons[data.name] or data.name, "SCPHUDSmall", ico_h + ico_marg * 2, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function PANEL:DoClick()
	if !self.Action then return end

	local cb = self.Action.callback
	if isfunction( cb ) then
		cb( self.Action, self.Action.args )
	end
end

function PANEL:BindAction( action )
	self.Action = action
end

vgui.Register( "DefaultEQ.ActionButton", PANEL, "DButton" )

--[[-------------------------------------------------------------------------
Backpack
---------------------------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
	self.Padding = EQ.Padding

	self.Rows = {}
	self.Items = {}

	local move = vgui.Create( "DefaultEQ.MoveButton", self )
	self.Move = move

	move:BindPanel( self )

	move.FinishMove = function( this )
		EQ.BPX = self:GetX() + self:GetWide() * 0.5
		EQ.BPY = self:GetY() + self:GetTall() * 0.5
	end

	local header = vgui.Create( "DLabel", self )
	self.Header = header

	header:Dock( TOP )
	//header:DockMargin( 0, 0, 0, self.Padding )

	header:SetFont( "SCPHUDSmall" )
	header:SetTextColor( color_white )
	header:SetText( LANG.EQ.backpack )

	header:SizeToContents()

	header.Paint = function( this, pw, ph )
		surface.SetDrawColor( 125, 125, 125 )
		surface.DrawLine( 0, ph - 1, pw * 0.5, ph - 1 )
	end

	self:DockPadding( self.Padding, 0, self.Padding, self.Padding )

	self:CreateSlots()
	self:InvalidateLayout()

	self:SizeToContents()

	if EQ.BPX and EQ.BPY then
		local pw, ph = self:GetSize()
		local pos_x = math.Clamp( EQ.BPX - pw * 0.5, 0, ScrW() - pw )
		local pos_y = math.Clamp( EQ.BPY - ph * 0.5, 0, ScrH() - ph )

		self:SetPos( pos_x, pos_y )
	else
		self:Center()
	end

	self:MakePopup()
end

function PANEL:Think()
	if !EQ:IsVisible() or !IsValid( LocalPlayer():GetWeapon( "item_slc_backpack" ) ) then
		self:Remove()
	end
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 175 )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( 175, 175, 175 )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function PANEL:PerformLayout( w, h )
	local header_h = self.Header:GetTall()

	self.Move:SetSize( w - self.Padding * 2, header_h + self.Padding )
	self.Move:SetPos( self.Padding, 0 )
	self.Move.DraggableHeight = header_h
end

function PANEL:SizeToContents()
	self:InvalidateLayout( true )

	local rows = #self.Rows

	local total_w = self.Padding + ( self.Rows[1]:GetTall() + self.Padding ) * math.ceil( #self.Items / #self.Rows )
	local total_h = self.Header:GetTall() + self.Padding + ( self.Rows[1]:GetTall() + self.Padding ) * rows

	self:SetSize( total_w, total_h )
end

function PANEL:OnRemove()
	if self.Removed then return end

	self.Removed = true
	RunGUISkinFunction( "eq", "close_backpack" )
end

function PANEL:CreateSlots()
	local bp = LocalPlayer():GetWeapon( "item_slc_backpack" )
	if !IsValid( bp ) then return end

	local size = bp:GetSize()
	local rows = 1

	if size > 8 then
		rows = 3
	elseif size > 3 then
		rows = 2
	end

	local perrow = math.ceil( size / rows )

	for i = 1, rows do
		local row = vgui.Create( "DPanel", self )
		self.Rows[i] = row

		row:Dock( TOP )
		row:DockMargin( 0, self.Padding, 0, 0 )
		row:SetTall( EQ.RowHeight )
		row:SetPaintBackground( false )

		row.PerformLayout = function( this, pw, ph )
			local total_w = 0

			for _, v in ipairs( this:GetChildren() ) do
				local ch = v:GetTall()
				v:SetWide( ch )
				total_w = total_w + ch
			end

			if this.Incomplete then
				local margin = pw - total_w - ( #this:GetChildren() - 1 ) * self.Padding
				this:GetChildren()[1]:DockMargin( margin * 0.5, 0, self.Padding, 0 )
			end
		end

		for j = 1, perrow do
			local item = vgui.Create( "DefaultEQ.ItemButton", row )
			local bp_id = table.insert( self.Items, item )

			item.ID = 6 + bp_id
			item.Backpack = true

			item:Dock( LEFT )
			item:DockMargin( 0, 0, self.Padding, 0 )
			item:SetZPos( j - 1 )

			item:BindItem( INVENTORY[item.ID] )

			if bp_id >= size then
				row.Incomplete = true
				break
			end
		end
	end
end

vgui.Register( "DefaultEQ.Backpack", PANEL, "DPanel" )