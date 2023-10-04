local PANEL = {}

local color_white = Color( 255, 255, 255 )

function PANEL:Init()
	self.Options = {}

	self:SetContentAlignment( 4 )
	self:SetColor( color_white )
	self:SetFont( "SCPHUDSmall" )
	self:SetTextInset( 8, 0 )

	//self:NoClipping( true )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255 )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function PANEL:PerformLayout( w, h )

end

local color_vbar = Color( 75, 75, 75, 255 )
local color_vbar_grip = Color( 125, 125, 125, 255 )
function PANEL:DoClick()
	if IsValid( self.DropMenu ) then
		self.DropMenu:Remove()
	else
		local x, y = self:LocalToScreen( 0, 0 )
		local w, h = self:GetSize()
		local sh = ScrH()

		local cont = vgui.Create( "DPanel", self )
		cont:SetPos( x, y )
		cont:SetSize( w, math.min( h * math.min( #self.Options, 5 ), sh - y - h ) )
		cont:SetPaintBackground( false )
		cont:MakePopup()

		cont.Think = function( this )
			if !this:HasHierarchicalFocus() then
				if this.HadFocus then
					this:Remove()
				end
			else
				this.HadFocus = true
			end
		end

		local close = vgui.Create( "DButton", cont )
		close:Dock( TOP )
		close:SetTall( h )
		close:SetText( "" )
		close:SetPaintBackground( false )

		close.DoClick = function( this )
			cont:Remove()
		end

		local pnl = vgui.Create( "DScrollPanel", cont )
		self.DropMenu = pnl

		pnl:Dock( FILL )
		pnl:GetCanvas():DockPadding( 4, 4, 4, 4 )
		pnl:DockPadding( 0, 2, 2, 2 )

		pnl.VBar:SetHideButtons( true )
		pnl.VBar:SetWide( 6 )
	
		pnl.VBar.Paint = function( this, pw, ph )
			draw.RoundedBox( 15, 0, 0, pw, ph, color_vbar )
		end
	
		pnl.VBar.btnGrip.Paint = function( this, pw, ph )
			draw.RoundedBox( 15, 1, 1, pw - 2, ph - 2, color_vbar_grip )
		end

		pnl.Paint = function( this, pw, ph )
			surface.SetDrawColor( 25, 25, 25, 235 )
			surface.DrawRect( 0, 0, pw, ph )

			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 0, pw, ph )
		end

		for i, v in ipairs( self.Options ) do
			local btn = vgui.Create( "DButton", pnl )
			btn:Dock( TOP )
			btn:DockMargin( 0, h * 0.05, 0, 0 )
			btn:SetTall( h )
			btn:SetContentAlignment( 4 )
			btn:SetText( v[2] )
			btn:SetFont( "SCPHUDSmall" )
			btn:SetColor( color_white )
			btn:SetTextInset( 8, 0 )

			btn.ID = i
			btn.Value = v[1]

			btn.Paint = function( this, pw, ph )
				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawOutlinedRect( 0, 0, pw, ph )
			end

			btn.DoClick = function( this )
				cont:Remove()

				self:SetText( this:GetText() )
				self:OnSelect( this.ID, this.Value )
			end
		end
	end
end

function PANEL:SetOptions( options )
	self.Options = {}

	for i, v in ipairs( options ) do
		if istable( v ) then
			self.Options[i] = v
		else
			self.Options[i] = { v, v }
		end
	end
end

function PANEL:SetActive( option )
	for i, v in ipairs( self.Options ) do
		if v[1] == option then
			self:SetText( v[2] )
			return
		end
	end

	self:SetText( option )
end

function PANEL:OnSelect( id, value )

end

vgui.Register( "SLCDropbox", PANEL, "DButton" )