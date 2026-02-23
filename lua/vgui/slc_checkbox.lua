local PANEL = {}

AccessorFunc( PANEL, "b_State", "State", FORCE_BOOL )

PANEL.Radio = false
PANEL.Font = "DermaDefault"

function PANEL:Init()
	self.State = false

	self.Button = vgui.Create( "DButton", self )
	self.Button:Dock( LEFT )
	self.Button:SetText( "" )
	self.Button:DockMargin( 0, 0, 16, 0 )

	self.Button.Paint = function( this, pw, ph )
		surface.SetDrawColor( 255, 255, 255 )

		if self.Radio then
			local s = pw < ph and pw or ph
			local s2 = s * 0.5

			SLCDrawRing( s2, s2, s2, 1 )

			if self.b_State then
				SLCDrawCircle( s2, s2, s2 - 3 )
			end
		else
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			if self.b_State then
				surface.DrawRect( 3, 3, pw - 6, ph - 6 )
			end
		end
	end

	self.Button.DoClick = function( this )
		if self.Radio then
			if !self.b_State then
				for k, v in pairs( self.RadioTab.Buttons ) do
					v:SetState( false )
				end

				self.b_State = true
				self.RadioTab.Selected = self.RadioID
			end
		else
			self.b_State = !self.b_State
			self:OnUpdate( self.b_State )
		end
	end

	self.Label = vgui.Create( "DLabel", self )
	self.Label:Dock( FILL )
	self.Label:SetContentAlignment( 4 )
	self.Label:SetColor( Color( 255, 255, 255 ) )
	self.Label:SetFont( self.Font )
end

function PANEL:PerformLayout( w, h )
	self.Button:SetWide( h )
end

function PANEL:SizeToContents()
	self.Label:SizeToContents()

	local lw, lh = self.Label:GetSize()

	self:SetWide( self.Button:GetWide() + lw + 16 )
	self:SetTall( lh )
end

function PANEL:Paint( w, h )
	
end

function PANEL:SetText( text )
	self.Label:SetText( text )
end

function PANEL:SetFont( font )
	self.Label:SetFont( font )
	self.Font = font

	self:InvalidateLayout()
end

function PANEL:SetRadio( b, id, tab )
	if !b then
		self.Radio = false
		self.RadioID = nil
		self.RadioTab = nil

		return
	end

	if !id or !tab then return end

	self.Radio = true
	self.RadioID = id
	self.RadioTab = tab

	if !tab.Buttons then
		tab.Buttons = {}
	end

	if !table.HasValue( tab.Buttons, self ) then
		table.insert( tab.Buttons, self )
	end
end

function PANEL:OnUpdate( val )

end


vgui.Register( "SLCCheckbox", PANEL, "Panel" )