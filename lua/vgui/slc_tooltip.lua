local PANEL = {}

PANEL.Text = ""

function PANEL:Init()
	self:SetColor( Color( 255, 255, 255 ) )
	self:SetFont( "SCPHUDSmall" )
	self:SetContentAlignment( 5 )
	self:SetDrawOnTop( true )
end

function PANEL:Paint( w, h )
	self:CalcPosition()

	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( 150, 150, 150, 255 )
	surface.DrawOutlinedRect( 0, 0, w, h )

	//draw.SimpleText( self.Text, self.Font, w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:PerformLayout( w, h )
	//local tw, th = draw.TextSize( self.Text, self.Font )
	local tw, th = self:GetContentSize()
	self:SetSize( tw + 16, th + 8 )
end

function PANEL:CalcPosition()
	if !IsValid( self.Panel ) then
		self:Remove()
		return
	end

	local x, y = input.GetCursorPos()
	local w, h = self:GetSize()

	x = math.Clamp( x + 4, 2, ScrW() - w - 2 )
	y = math.Clamp( y - h - 4, 2, ScrH() - h - 2 )

	self:SetPos( x, y )
end

function PANEL:SetText( txt )
	self.Text = txt or ""
	self:InvalidateLayout()
	self.BaseClass.SetText( self, txt )
end

function PANEL:OpenForPanel( pnl )
	self.Panel = pnl

	if pnl.TooltipFont then self:SetFont( pnl.TooltipFont ) end
	if pnl.TooltipColor then self:SetColor( pnl.TooltipColor ) end

	self:SetVisible( false )
	
	timer.Simple( 0.5, function()
		if !IsValid( self ) or !IsValid( self.Panel ) then return end
		self:SetVisible( true )
		self:CalcPosition()
	end )
end

function PANEL:Close()
	self:Remove()
end

vgui.Register( "SLCTooltip", PANEL, "DLabel" )