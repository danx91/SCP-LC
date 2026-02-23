--[[-------------------------------------------------------------------------
Materials, colors, etc.
---------------------------------------------------------------------------]]
local mat_list = Material( "slc/hud/skin_default/scoreboard.png", "smooth" )
local mat_header = Material( "slc/hud/skin_default/scoreboard_header.png", "smooth" )
local mat_item = Material( "slc/hud/skin_default/scoreboard_item.png", "smooth" )
local mat_speaker1 = Material( "slc/hud/skin_default/speaker1.png", "smooth" )
local mat_speaker2 = Material( "slc/hud/skin_default/speaker2.png", "smooth" )
local mat_speaker3 = Material( "slc/hud/skin_default/speaker3.png", "smooth" )
local mat_muted = Material( "slc/hud/skin_default/muted.png", "smooth" )
local mat_muteall = Material( "slc/hud/skin_default/mute_all.png", "smooth" )
local mat_unmuteall = Material( "slc/hud/skin_default/unmute_all.png", "smooth" )

local list_ratio = mat_list:Width() / mat_list:Height()
local header_ratio = mat_header:Width() / mat_header:Height()
local item_ratio = mat_item:Width() / mat_item:Height()

local color_white = Color( 255, 255, 255 )

local header_items = {
	{ text = "playername", size = 0.25, font = "SCPHUDSmall", func = function( ply ) return ply:Nick() end, paint = function( this, pw, ph )
		local parent = this:GetParent()
		if !IsValid( parent.Player ) then return end

		local plvl = parent.Player:GetPrestigeLevel()
		if plvl <= 0 then return end

		if plvl > 10 then
			plvl = 10
		end

		this:SetTextInset( 0, -ph * 0.2 )

		//this:NoClipping( false )
		draw.SimpleText( string.rep( "★", plvl ), "SCPHUDESmall", pw * 0.5, ph, HSVToColor( CurTime() * 90 % 360, 1, 1 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		//this:NoClipping( true )
	end },
	{ text = "badges", size = -1, font = "SCPHUDMedium" }, --fill, docking order is reversed after this!
	{ text = "ping", size = 0.09, font = "SCPNumbersMedium", func = function( ply ) return ply:Ping() end },
	{ text = "level", size = 0.09, font = "SCPNumbersMedium", func = function( ply ) return ply:PlayerLevel() end },
	{ text = "score", size = 0.09, font = "SCPNumbersMedium", func = function( ply )
		local lp = LocalPlayer()

		if IsValid( ply ) and ( ply == lp or !lp:Alive() ) then
			return  math.Clamp( ply:Frags(), 0, 9999 )
		end

		return "--"
	end },
}

--[[-------------------------------------------------------------------------
Scoreboard
---------------------------------------------------------------------------]]
/*local function debug_paint( this )
	this:DrawOutlinedRect()
end*/

local function create_player( ply, parent, marg )
	local lp = LocalPlayer()

	local item = vgui.Create( "DPanel", parent )
	item:Dock( TOP )

	item.Player = ply
	item.Elements = {}
	item.ElementsName = {}

	item.Color = Color( 255, 255, 255 )
	item._Color = item.Color

	/*item.Think = function( this )
		if !IsValid( this.Player ) then
			this:Remove()
		end
	end*/

	item.Paint = function( this, pw, ph )
		surface.SetDrawColor( this.Color )
		surface.SetMaterial( mat_item )
		surface.DrawTexturedRect( 0, 0, pw, ph )

		/*local plvl = this.Player:GetPrestigeLevel()
		if plvl <= 0 then return end

		this:NoClipping( false )
		draw.SimpleText( string.rep( "★", plvl ), "SCPHUDSmall", pw * 0.05, ph * 0.8, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		this:NoClipping( true )*/
		//this:DrawOutlinedRect()
	end

	item.PerformLayout = function( this, pw, ph )
		local square_size = this.Avatar:GetTall()
		this.Avatar:SetWide( square_size )
		this.Volume:SetWide( square_size )

		local space_left = pw - square_size * 2

		for i, v in ipairs( header_items ) do
			this.Elements[i]:SetWide( space_left * v.size )
		end
	end

	item.Update = function( this )
		local sorting, color = ScoreboardPlayerData( ply )

		this:SetZPos( sorting * 1500 - ( lp:Alive() and ply:PlayerLevel() or ply:Frags() ) )
		this.Color = color or this._Color

		this.ElementsName.badges:CreateBadges()
	end

	local avatar = vgui.Create( "SLCAvatar", item )
	item.Avatar = avatar

	avatar:Dock( LEFT )
	avatar:DockMargin( 0, 0, marg, 0 )
	avatar:SetSteamID( ply:SteamID64(), 184 )

	avatar.OnMousePressed = function( this, code )
		if code == MOUSE_LEFT then
			ply:ShowProfile()
		elseif code == MOUSE_RIGHT then
			local m = DermaMenu()

			m:AddOption( LANG.scoreboard_actions.copy_name, function()
				local nick = ply:Nick()
				SetClipboardText( nick )
				print( nick )
			end )

			m:AddOption( LANG.scoreboard_actions.copy_sid, function()
				local sid = ply:SteamID()
				SetClipboardText( sid )
				print( sid )
			end )

			m:AddOption( LANG.scoreboard_actions.copy_sid64, function()
				local sid = ply:SteamID64()
				SetClipboardText( sid )
				print( sid )
			end )

			m:AddOption( LANG.scoreboard_actions.open_profile, function()
				ply:ShowProfile()
			end )

			m:Open()
		end
	end

	local volume = vgui.Create( "DButton", item )
	item.Volume = volume

	volume:Dock( RIGHT )
	volume:SetText( "" )

	volume.Paint = function( this, pw, ph )
		if !IsValid( ply ) then return end

		surface.SetDrawColor( 255, 255, 255 )

		if ply == lp then
			local all = true

			for i, v in ipairs( player.GetAll() ) do
				if v:IsMuted() or v == lp then continue end

				all = false
				break
			end

			surface.SetMaterial( all and mat_unmuteall or mat_muteall )
		else
			if ply:IsMuted() then
				surface.SetMaterial( mat_muted )
			else
				local vol = ply:GetVoiceVolumeScale()
				if vol > 0.66 then
					surface.SetMaterial( mat_speaker3 )
				elseif vol > 0.33 then
					surface.SetMaterial( mat_speaker2 )
				else
					surface.SetMaterial( mat_speaker1 )
				end
			end
		end

		surface.DrawTexturedRect( 0, 0, pw, ph )
	end

	volume.DoClick = function( this )
		if ply == lp then
			local all = true

			for i, v in ipairs( player.GetAll() ) do
				if v:IsMuted() or v == lp then continue end

				all = false
				break
			end

			for i, v in ipairs( player.GetAll() ) do
				if v == lp then continue end
				v:SetMuted( !all )
			end
		else
			if input.IsButtonDown( KEY_LCONTROL ) then
				ply:SetMuted( !ply:IsMuted() )
			else
				if IsValid( SCOREBOARD.VolumeSlider ) then
					local rem = SCOREBOARD.VolumeSlider.Panel == item
					SCOREBOARD.VolumeSlider:Remove()

					if rem then return end
				end

				SCOREBOARD.VolumeSlider = vgui.Create( "DefaultScoreboard.VolumeSlider" )
				SCOREBOARD.VolumeSlider:SetPanel( item )
			end
		end
	end

	volume.DoRightClick = function( this )
		if ply == lp then return end
		ply:SetMuted( !ply:IsMuted() )
	end

	local function create_badges( this )
		this:Clear()
		this.List = {}

		this.Prestige = ply:GetPrestigeLevel()

		local badges = ScoreboardPlayerBadges( ply )
		for i, v in ipairs( badges ) do
			local badge = vgui.Create( "DefaultScoreboard.Badge", this )
			this.List[i] = badge

			badge:Dock( LEFT )
			badge:SetBadge( v[1], v[2] )
		end
	end

	local function layout_badges( this, pw, ph )
		local badge_h = ph * 0.5
		local badge_marg = ( ph - badge_h ) * 0.5

		this:DockPadding( badge_marg, badge_marg, 0, badge_marg )

		local total_w = badge_marg
		for i, v in ipairs( this.List ) do
			v:DockMargin( 0, 0, badge_marg, 0 )
			total_w = total_w + badge_marg + v:GetWide()
		end

		if total_w > pw then
			for i, v in ipairs( this.List ) do
				v:Collapse()
			end
		end
	end

	local docking = LEFT

	for i, v in ipairs( header_items ) do
		local elem = vgui.Create( "DLabel", item )
		item.Elements[i] = elem
		item.ElementsName[v.text] = elem

		if v.size == -1 then
			elem:Dock( FILL )
			docking = RIGHT
		else
			elem:Dock( docking )
		end

		elem:DockMargin( 0, 0, marg, 0 )
		elem:SetMouseInputEnabled( true )

		elem:SetContentAlignment( 5 )
		elem:SetFont( v.font )
		elem:SetTextColor( color_white )
		elem:SetText( "" )

		elem.Think = function( this )
			if !v.func or !IsValid( ply ) then return end

			local txt = v.func( ply )
			if this:GetText() == txt then return end

			this:SetText( txt )
		end

		elem.Paint = v.paint

		if v.text == "badges" then
			elem.CreateBadges = create_badges
			elem.PerformLayout = layout_badges
		end

		//elem.Paint = debug_paint
	end

	return item
end

local function create_scoreboard()
	if IsValid( SCOREBOARD ) then
		SCOREBOARD:Remove()
	end

	local h = ScrH()

	local list_h = math.floor( h * 0.8 )
	local list_w = math.floor( list_h * list_ratio )
	local header_h = math.floor( list_w / header_ratio )
	local item_dock_margin = math.floor( list_w * 0.008 )

	local item_w = list_w - item_dock_margin * 2
	local item_h = math.floor( item_w / item_ratio )
	local item_marg = math.floor( item_h * 0.175 )
	local item_padding = math.floor( item_w * 0.02 )

	local panel = vgui.Create( "DPanel" )
	SCOREBOARD = panel

	panel:SetSize( list_w, list_h )
	panel:Center()
	panel:MakePopup()
	panel:SetKeyboardInputEnabled( false )
	panel:Hide()

	panel:DockPadding( 0, 0, 0, list_h * 0.01 )

	panel.Paint = function( this, pw, ph )
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat_list )
		surface.DrawTexturedRect( 0, 0, pw, ph )

		//local x, y = this:LocalToScreen( 0, 0 )
		//render.SetScissorRect( x, y, x + pw, y + ph - 8, true )
	end

	//panel.PaintOver = function( this, pw, ph )
		//render.SetScissorRect( 0, 0, 0, 0, false )
	//end

	local header = vgui.Create( "DPanel", panel )
	header:Dock( TOP )
	header:SetTall( header_h )

	header.Paint = function( this, pw, ph )
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat_header )
		surface.DrawTexturedRect( 0, 0, pw, ph )
	end

	local header_padding = item_dock_margin + item_padding + ( item_h - item_marg * 2 )
	header:DockPadding( header_padding, 0, header_padding, 0 )

	local header_space = list_w - header_padding * 2 + item_marg * 4
	local docking = LEFT

	for i, v in ipairs( header_items ) do
		local elem = vgui.Create( "DLabel", header )

		if v.size == -1 then
			elem:Dock( FILL )
			docking = RIGHT
		else
			elem:Dock( docking )
		end

		elem:DockMargin( i == 1 and item_marg or 0, 0, item_marg, 0 )

		elem:SetWide( header_space * v.size )
		elem:SetContentAlignment( 5 )
		elem:SetFont( "SCPHUDMedium" )
		elem:SetTextColor( color_white )
		elem:SetText( LANG.scoreboard[v.text] or "!lang" )

		//elem.Paint = debug_paint
	end

	local players = vgui.Create( "DScrollPanel", panel )
	players:Dock( FILL )
	players:GetVBar():SetWide( 0 )

	players.List = {}

	players.Paint = function( this, pw, ph ) end

	local old_wheel = players.OnMouseWheeled
	players.OnMouseWheeled = function( this, delta )
		if IsValid( panel.VolumeSlider ) then
			panel.VolumeSlider:Remove()
		end

		old_wheel( this, delta )
	end

	panel.UpdatePlayers = function( this )
		for i, v in ipairs( player.GetAll() ) do
			if IsValid( players.List[v] ) then continue end

			local ply = create_player( v, players, item_marg )
			players.List[v] = ply

			ply:SetTall( item_h )
			ply:DockMargin( item_dock_margin, 0, item_dock_margin, 0 )
			ply:DockPadding( item_padding, item_marg, item_padding, item_marg )
		end

		for k, v in pairs( players.List ) do
			/*if !IsValid( v ) then
				players.List[k] = nil
			end*/

			if !IsValid( k ) then
				players.List[k]:Remove()
				players.List[k] = nil
			else
				v:Update()
			end
		end
	end
end

AddGUISkin( "scoreboard", "default", {
	create = function()
		create_scoreboard()
		
		hook.Add( "SLCLanguageChanged", "Scoreboard.Default.Lang", function()
			create_scoreboard()
		end )
	end,
	remove = function()
		SCOREBOARD:Remove()
		hook.Remove( "SLCLanguageChanged", "Scoreboard.Default.Lang" )
	end,
	show =  function()
		SCOREBOARD:UpdatePlayers()
		SCOREBOARD:Show()
	end,
	hide = function()
		SCOREBOARD:Hide()
	end,
} )

--[[-------------------------------------------------------------------------
Badge
---------------------------------------------------------------------------]]
local mat_badge_l = Material( "slc/hud/skin_default/badge_left.png", "smooth" )
local mat_badge_r = Material( "slc/hud/skin_default/badge_right.png", "smooth" )

local PANEL = {}

PANEL.Collapsed = false
PANEL.Expanded = false
PANEL.Expand = 0

function PANEL:Init()

end

function PANEL:Think()
	if !self.Collapsed then return end

	self.Expand = math.Approach( self.Expand, self.Expanded and 1 or 0, RealFrameTime() * 2 )

	local diff = self.FullWidth - self:GetTall()
	self:SetWide( self:GetTall() + diff * self.Expand )
end

function PANEL:OnMousePressed( code )
	if !self.Collapsed or code != MOUSE_LEFT then return end
	self.Expanded = !self.Expanded

	for i, v in ipairs( self:GetParent().List ) do
		if v == self then continue end
		v.Expanded = false
	end
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( self.Color )

	surface.SetMaterial( mat_badge_l )
	surface.DrawTexturedRect( 0, 0, h, h )

	surface.SetMaterial( mat_badge_r )
	surface.DrawTexturedRect( w - h, 0, h, h )

	if !self.Collapsed or self.Expand == 1 then
		draw.SimpleText( self.Text, "SCPHUDSmall", w * 0.5, h * 0.5 - 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function PANEL:SizeToContents()
	local tw = draw.TextSize( self.Text, "SCPHUDSmall" )
	self:SetWide( tw )
end

function PANEL:SetBadge( name, color )
	self.Text = LANG.ranks[name] or name
	self.Color = color

	self:SizeToContents()

	local w = self:GetWide() + self:GetTall()
	self:SetWide( w )
	self.FullWidth = w
end

function PANEL:Collapse()
	if self.Collapsed then return end

	self.Collapsed = true
	self.Expanded = false
	self.Expand = 0
	self:SetWide( self:GetTall() )
end

vgui.Register( "DefaultScoreboard.Badge", PANEL, "DPanel" )

--[[-------------------------------------------------------------------------
Volume Slider
---------------------------------------------------------------------------]]
local mat_slider = Material( "slc/hud/skin_default/slider.png", "smooth" )
local mat_knob = Material( "slc/hud/skin_default/knob.png", "smooth" )

local slider_ratio = mat_slider:Width() / mat_slider:Height()

PANEL = {}

function PANEL:Init()
	self.Slider = vgui.Create( "DPanel", self )
	self.Slider:Dock( FILL )

	self.Slider.Paint = function( this, pw, ph )
		draw.RoundedBox( ph * 0.5, 0, ph * 0.45, pw, ph * 0.1, color_white )
	end

	self.Slider.OnMousePressed = function( this, code )
		if code != MOUSE_LEFT then return end

		local max = this:GetWide()
		local x = math.Clamp( this:ScreenToLocal( gui.MouseX(), 0 ), 0, max )

		self.Knob:SetX( this:GetX() + x - self.Knob:GetWide() * 0.5 )
		self.Knob.Dragging = true

		local val = x / max
		self.Panel.Player:SetVoiceVolumeScale( val )
		self.Panel.Player:SetMuted( val == 0 )
	end

	self.Knob = vgui.Create( "DButton", self )
	self.Knob:NoClipping( true )
	self.Knob:SetText( "" )

	self.Knob.Paint = function( this, pw, ph )
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat_knob )
		surface.DrawTexturedRect( 0, 0, pw, ph )
	end

	self.Knob.Think = function( this )
		if !this.Dragging then return end
		if !input.IsMouseDown( MOUSE_LEFT ) then
			this.Dragging = false
			return
		end

		local max = self.Slider:GetWide()
		local x = math.Clamp( self.Slider:ScreenToLocal( gui.MouseX(), 0 ), 0, max )
		
		this:SetX( self.Slider:GetX() + x - this:GetWide() * 0.5 )

		local val = x / max
		self.Panel.Player:SetVoiceVolumeScale( val )
		self.Panel.Player:SetMuted( val == 0 )
	end

	self.Knob.OnMousePressed = function( this, code )
		if code != MOUSE_LEFT then return end
		this.Dragging = true
	end
end

function PANEL:PerformLayout( w, h )
	local sh = h * 0.4
	local marg_h = ( h - sh ) * 0.5
	local marg_w = w * 0.1
	local btn_size = h * 0.2

	self.Slider:DockMargin( marg_w, marg_h, marg_w, marg_h )

	self.Knob:SetSize( btn_size, btn_size )
	self.Knob:SetPos( self.Slider:GetX() + self.Slider:GetWide() * self.Panel.Player:GetVoiceVolumeScale() - self.Knob:GetWide() * 0.5, ( h - btn_size ) * 0.5 )
end

function PANEL:Think()
	if !IsValid( SCOREBOARD ) or !IsValid( self.Panel ) or !SCOREBOARD:IsVisible() then
		self:Remove()
	end
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_slider )
	surface.DrawTexturedRect( 0, 0, w, h )
end

function PANEL:SetPanel( pnl )
	self.Panel = pnl
	local pnl_h = pnl:GetTall()
	local pnl_w = pnl_h * slider_ratio
	local sx, sy = pnl:LocalToScreen( 0, 0 )

	self:SetPos( sx + pnl:GetWide() + ScrW() * 0.005, sy + pnl_h * 0.05 )
	self:SetSize( pnl_w, pnl_h * 0.9 )
	self:MakePopup()
	self:SetKeyboardInputEnabled( false )
end

vgui.Register( "DefaultScoreboard.VolumeSlider", PANEL, "DPanel" )