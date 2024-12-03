local PANEL = {}

local color_white = Color( 255, 255, 255 )
local btn_color = Color( 150, 150, 150 )

AccessorFunc( PANEL, "b_Keep", "Keep", FORCE_BOOL )
AccessorFunc( PANEL, "b_Blur", "Blur", FORCE_BOOL )

function PANEL:Init()
	self.Marg = ScrH() * 0.0125

	local label = vgui.Create( "DLabel", self )
	self.Name = label

	label:Dock( TOP )

	label:SetText( "SLCPopup" )
	label:SetFont( "SCPHUDSmall" )
	label:SetColor( color_white )
	label:SetContentAlignment( 4 )

	label.Paint = function( this, pw, ph )
		surface.SetDrawColor( 0, 0, 0, 155 )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( 55, 55, 55, 255 )
		surface.DrawLine( 0, ph - 1, pw, ph - 1 )
	end

	local buttons = vgui.Create( "Panel", self )
	self.Buttons = buttons

	buttons:Dock( BOTTOM )

	buttons:SetTall( ScrH() * 0.06 )
	buttons:DockPadding( 0, self.Marg, self.Marg, self.Marg )

	buttons.Paint = function( this, pw, ph )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawLine( pw * 0.2, 0, pw * 0.9, 0 )
	end

	buttons.PerformLayout = function( this, pw, ph )
		local tab = this:GetChildren()
		local len = #tab
		local max_w = ( pw - ( len - 1 ) * self.Marg ) / len
		local min_w = pw * 0.1

		for i = 1, len do
			local btn = tab[i]

			btn:SizeToContents()

			local wide = btn:GetWide()

			if wide > max_w then
				btn:SetWide( max_w )
			elseif wide < min_w then
				btn:SetWide( min_w )
			end
		end
	end

	local mask = vgui.Create( "Panel" )
	mask:SetPos( 0, 0 )
	mask:SetSize( ScrW(), ScrH() )
	mask:SetPaintBackgroundEnabled( false )
	
	mask.Think = function( this )
		if !IsValid( self ) then
			this:Remove()
		end
	end

	mask:MakePopup()

	self:SetSize( 256, 128 + label:GetTall() + buttons:GetTall() )
	self:Center()
	self:MakePopup()
end

function PANEL:Think()
	if self:HasFocus() then
		if !self.HadFocus then
			self.HadFocus = true
		end
	elseif self.HadFocus then
		if self:GetKeep() then
			self:MakePopup()
		else
			if self.Callback and self.Callback( 0, self, nil ) then
				self:MakePopup()
				return
			end

			self:Remove()
		end
	end
end

local blur = Material( "pp/blurscreen" )

PANEL.BlurScale = 0
function PANEL:Paint( w, h )
	render.UpdateScreenEffectTexture()

	self.BlurScale = math.Approach( self.BlurScale, 1, RealFrameTime() / 0.75 )

	blur:SetTexture( "$basetexture", render.GetScreenEffectTexture() )
	blur:SetFloat( "$blur", 6 )

	DisableClipping( true )
		render.SetBlend( self.BlurScale )
			render.SetMaterial( blur )
			render.DrawScreenQuad()
		render.SetBlend( 1 )

		local x, y = self:GetPos()
		surface.SetDrawColor( 0, 0, 0, 75 * self.BlurScale )
		surface.DrawRect( -x, -y, ScrW(), ScrH() )
	DisableClipping( false )

	surface.SetDrawColor( 16, 16, 16, 205 )
	surface.DrawRect( 0, 0, w, h )

	if self.Markup then
		self.Markup:Draw( self.Marg, self.Name:GetTall() + self.Marg )
	end
end

function PANEL:PaintOver( w, h )
	surface.SetDrawColor( 125, 125, 125, 255 )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function PANEL:PerformLayout( w, h )
	
end

function PANEL:OnRemove()
	timer.Simple( 0.25, function()
		if IsValid( SLC_POPUP ) or #SLC_POPUP_QUEUE == 0 then return end

		SLC_POPUP = vgui.Create( "SLCPopup" )
		SLC_POPUP:SetData( table.remove( SLC_POPUP_QUEUE, 1 ) )
	end )
end

function PANEL:SetName( name )
	self.Name:SetText( name )

	local _, nh = self.Name:GetTextSize()
	self.Name:SetTall( nh + self.Marg )
	self.Name:SetTextInset( self.Marg, 0 )

	self:UpdateSize()
end

function PANEL:SetText( text )
	self.Markup = markup.Parse( text, ScrW() * 0.5 )

	self:UpdateSize()
end

function PANEL:UpdateSize()
	if !self.Markup then return end

	local w = self.Markup:GetWidth() + 2 * self.Marg
	local h = self.Markup:GetHeight() + self.Marg * 2 + self.Name:GetTall() + self.Buttons:GetTall()

	local min_w = ScrW() * 0.333
	local min_h = ScrH() * 0.2

	self:SetSize( w > min_w and w or min_w, h > min_h and h or min_h )
	self:Center()
end

function PANEL:SetOptions( options )
	self.Buttons:Clear()

	for i, v in ipairs( options ) do
		local btn = vgui.Create( "SLCButton", self.Buttons )
		
		btn:Dock( RIGHT )
		btn:DockMargin( self.Marg, 0, 0, 0 )

		if istable( v ) then
			btn:SetText( v[1] )
			btn:SetColor( v.color or btn_color )

			if v.warn then
				btn:SetWarning( 5 )
			end
		else
			btn:SetText( v )
			btn:SetColor( btn_color )
		end

		btn:SetFont( "SCPHUDVSmall" )

		btn.DoClick = function( this )
			if self.Callback and self.Callback( i, self, this ) then
				return
			end

			self:Remove()
		end
	end
end

function PANEL:SetData( data )
	self:SetName( data.name )
	self:SetText( data.text )
	self:SetKeep( !!data.keep )
	self:SetOptions( data.options )

	self.Callback = data.callback

	if data.callback then
		data.callback( -1 )
	end
end

vgui.Register( "SLCPopup", PANEL, "DPanel" )