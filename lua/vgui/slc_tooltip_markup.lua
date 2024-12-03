local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled( true )
end

PANEL.WasHovered = false
function PANEL:Think()
	if self:IsHovered() then
		if !self.WasHovered then
			self.WasHovered = true
			self:Update()
		end

		SLCToolTip( self.Object )
	elseif self.WasHovered then
		self.WasHovered = false
	end
end

function PANEL:PerformLayout( w, h )
	self:SetWide( h )
end

local info = Material( "slc/vgui/info.png", "smooth" )
function PANEL:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( info )

	surface.DrawTexturedRect( 0, 0, w, h )
end

function PANEL:SetText( text )
	self.Object = markup.Parse( tostring( text ), ScrW() * 0.333 )
end

function PANEL:Update()

end

vgui.Register( "SLCTooltipMarkup", PANEL, "Panel" )