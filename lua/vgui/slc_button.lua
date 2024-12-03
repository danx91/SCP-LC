local PANEL = {}

PANEL.Text = ""
PANEL.DrawText = ""
PANEL.Font = "DermaDefault"
PANEL.Color = Color( 0, 150, 0 )
PANEL.Warning = 0

function PANEL:Init()
	self.BaseClass.SetText( self, "" )
	self.Marg = ScrH() * 0.02
end

function PANEL:Think()
	if self.Warning == 0 or self.Warning > RealTime() then return end
	self.Warning = 0

	if !self:IsEnabled() then return end
	self:SetCursor( "hand" )
end

function PANEL:Paint( w, h )
	local warn = self.Warning - RealTime()
	local color = self.Color
	local clr = 0.75

	if !self:IsEnabled() or warn > 0 then
		clr = 0.5
	elseif self:IsHovered() then
		clr = 1
	end

	if self.Background then
		local c = self.Background
		surface.SetDrawColor( c.r * clr, c.g * clr, c.b * clr )
	else
		surface.SetDrawColor( color.r * clr * 0.5, color.g * clr * 0.5, color.b * clr * 0.5 )
	end

	surface.DrawRect( 0, 0, w, h )

	local off = h * 0.075
	self.DrawOffset = off

	surface.SetDrawColor( color.r * clr, color.g * clr, color.b * clr )
	surface.DrawRect( 0, 0, w  - off, h - off )

	local text = self.DrawText

	if warn > 0 then
		text = math.ceil( warn )
	end

	draw.SimpleText( text, self.Font, w * 0.5 - off * 0.5, h * 0.5 - off * 0.5, self:IsEnabled() and Color( 255, 255, 255 ) or Color( 150, 150, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:PerformLayout( w, h )
	local max_w = w - self.Marg * 2 + 8
	
	surface.SetFont( self.Font )
	if !self.ForceText and self.Text != "" and surface.GetTextSize( self.Text ) > max_w then
		self.DrawText = self.Text.."..."

		while surface.GetTextSize( self.DrawText ) > max_w do
			self.DrawText = string.sub( self.DrawText, 1, -5 ).."..."

			if self.DrawText == "..." then
				break
			end
		end
	else
		self.DrawText = self.Text
	end
end

function PANEL:OnMousePressed( code )
	if self.Warning != 0 then return end
	self.BaseClass.OnMousePressed( self, code )
end

function PANEL:SetEnabled( b )
	self.BaseClass.SetEnabled( self, b )
	self:SetCursor( b and "hand" or "arrow" )
end

function PANEL:SetText( txt, force )
	self.Text = txt
	self.ForceText = !!force

	self:InvalidateLayout()
end

function PANEL:SetFont( font )
	self.Font = font

	self:InvalidateLayout()
end

function PANEL:SetColor( color )
	self.Color = color
end

function PANEL:SetWarning( num )
	self.Warning = RealTime() + num
	self:SetCursor( "arrow" )
end

function PANEL:SizeToContents()
	surface.SetFont( self.Font )

	local tw, th = surface.GetTextSize( self.Text )
	local marg = self.Marg * 2

	self:SetSize( tw + marg, th + marg )
end

vgui.Register( "SLCButton", PANEL, "DButton" )