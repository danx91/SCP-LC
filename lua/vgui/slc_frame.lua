local PANEL = {}

local MATS = {
	exit = Material( "slc/vgui/exit.png", "smooth" ),
	refresh = Material( "slc/vgui/refresh.png", "smooth" ),
	u_gradient = Material( "vgui/gradient-u" ),
}

local color_white = Color( 255, 255, 255 )
local exit_r = MATS.exit:Width() / MATS.exit:Height()
local target_ratio = 16 / 9

AccessorFunc( PANEL, "s_FrameTitle", "FrameTitle", FORCE_STRING )

function PANEL:Init()
	self.Initialized = true

	self:SetDeleteOnClose( true )
	self:ShowCloseButton( false )
	self:SetDraggable( false )

	self:SetTitle( "" )
	self:DockPadding( 0, 0, 0, 0 )

	local header = vgui.Create( "DPanel", self )
	self.Header = header

	header:Dock( TOP )
	
	header.Paint = function( this, pw, ph )
		surface.SetDrawColor( 0, 0, 0, 240 )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( 155, 155, 155, 25 )
		surface.DrawLine( 0, ph - 1, pw, ph - 1 )

		draw.SimpleText( self.s_FrameTitle, "SLCFrame.Big", 8, ph * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	header.PerformLayout = function( this, pw, ph )
		local marg = ph * 0.2

		this.Exit:SetWide( exit_r * this.Exit:GetTall() )
		this.Exit:DockMargin( 0, marg, marg, marg )
	end

	local exit = vgui.Create( "DButton", header )
	header.Exit = exit

	exit:SetText( "" )
	exit:Dock( RIGHT )

	exit.Paint = function( this, pw, ph )
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( MATS.exit )
		surface.DrawTexturedRect( 0, 0, pw, ph )
	end

	exit.DoClick = function( this )
		self:Close()
	end

	local nav = vgui.Create( "DPanel", self )
	self.Nav = nav

	nav:Dock( TOP )

	nav.Paint = function( this, pw, ph )
		surface.SetDrawColor( 0, 0, 0, 125 )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( 155, 155, 155, 25 )
		surface.DrawLine( 0, ph - 1, pw, ph - 1 )
	end

	nav.PerformLayout = function( this, pw, ph )
		for i, v in ipairs( this.Buttons ) do
			if !v.BaseWide then v.BaseWide = v:GetWide() end
			v:SetWide( v.BaseWide + pw * 0.015 )
			//v:UpdateMark()
		end
	end

	local root = vgui.Create( "SLCPageLoader", self )
	self.Root = root

	root:Dock( FILL )

	local w, h = ScrW(), ScrH() --1920, 1200
	
	if w / h < target_ratio then --taller screen - sacle with width
		h = w / target_ratio
	else --longer screen - sacle with height
		w = h * target_ratio
	end

	self:SetSize( w * 0.8, h * 0.8 )
	self:Center()
	self:MakePopup()
end

function PANEL:PerformLayout( w, h )
	self.Header:SetTall( h * 0.045 )
	self.Nav:SetTall( h * 0.0425 )

	local pad = h * 0.02
	self.Root:DockPadding( pad, pad, pad, pad )
end

function PANEL:Paint( w, h )
	if self.PaintBackground and self:PaintBackground( w, h ) == true then return end

	if !self.Background then
		surface.SetDrawColor( 40, 38, 42 )
		surface.DrawRect( 0, 0, w, h )

		return
	end

	surface.SetDrawColor( 255, 255, 255 )
	surface.DrawTexturedRectKeepRatio( 0, 0, w, h, self.Background )
end

function PANEL:PaintOver( w, h )
	surface.SetDrawColor( 155, 155, 155, 175 )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function PANEL:OnKeyCodePressed( code )
	if code != KEY_F5 then return end
	self.Root:Reload()
end

function PANEL:LoadPage( id, data )
	self.Root:LoadPage( id, data )
end

function PANEL:Reload( data )
	self.Root:Reload( data )
end

function PANEL:SetHandler( handler )
	self.Handler = handler

	local root = self.Root
	root.Handler = handler

	local nav = self.Nav
	nav.Buttons = {}

	nav:Clear()

	local mark = vgui.Create( "DPanel", nav )
	nav.Mark = mark

	mark:SetVisible( false )
	mark:SetTall( 3 )
	mark:SetZPos( 1000 )

	mark.ColorR, mark.ColorG, mark.ColorB, mark.ColorA = Color( 128, 128, 128, 0 ):Unpack()
	mark._Color = Color( 125, 175, 25, 215 )

	mark.Paint = function( this, pw, ph )
		surface.SetDrawColor( this.ColorR, this.ColorG, this.ColorB, this.ColorA )
		surface.DrawRect( 0, 0, pw, ph )
	end

	mark.SetColor = function( this, r, g, b, a )
		this.ColorR = r
		this.ColorG = g
		this.ColorB = b
		this.ColorA = a
	end

	for k, v in pairs( handler:GetButtons() ) do
		local btn = vgui.Create( "DButton", nav )
		table.insert( nav.Buttons, btn )

		btn.Name = v.name
		btn.PageID = v.page_id
		btn.PageObject = v.page_obj
		btn.Action = v.action
		btn.Color = v.color
		btn.Fill = 0

		/*if v.PageID == ( handler.Index or "index" ) then
			index_btn = btn
		end*/

		btn:Dock( LEFT )
		btn:SetText( v.name )
		btn:SetFont( "SLCFrame.Small" )
		btn:SetColor( color_white )
		
		btn:SizeToContents()

		local ease = SLCEase.ease_in_out

		btn.Paint = function( this, pw, ph )
			local speed = 6
			local delta = -1

			if this:IsEnabled() and this:IsHovered() and !this.Lock then
				delta = 1
			end

			this.Fill = math.Clamp( this.Fill + delta * speed * RealFrameTime(), 0, 1 )

			if this.Fill > 0 then
				if this.PageID and this.PageID == root.ActivePage then
					if this.PageObject and !this.PageObject.DisableRefresh then
						local pct = ease( this.Fill )
						
						this:SetTextInset( 0, ph * pct )

						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( MATS.refresh )
						surface.DrawTexturedRect( pw * 0.5 - ph * 0.25, ph * pct - ph * 0.75, ph * 0.5, ph * 0.5 )
					end
				else
					surface.SetDrawColor( 75, 75, 75, 255 )
					surface.SetMaterial( MATS.u_gradient )
					surface.DrawTexturedRect( 0, 0, pw, ph * ease( this.Fill ) * 0.7 )
				end
			else
				this:SetTextInset( 0, 0 )
			end

			if this.PageID and this.PageID == root.ActivePage then
				surface.SetDrawColor( 0, 0, 0, 75 )
				surface.DrawRect( 0, 0, pw, ph )

				//surface.SetDrawColor( 125, 175, 25, 215 )
				//surface.DrawRect( 0, ph - 3, pw, 3 )
			end

			surface.SetDrawColor( 255, 255, 255, 25 )
			surface.DrawLine( 0, 0, 0, ph )
			surface.DrawLine( pw - 1, 0, pw - 1, ph )
		end

		btn.DoClick = function( this )
			if this.Lock then return end

			if this.Action then
				this.Action( this, self )
			elseif self.Failed or this.PageID != root.ActivePage then
				self:LoadPage( this.PageID )
				this.Fill = 0
			elseif this.PageObject and !this.PageObject.DisableRefresh then
				self:LoadPage( this.PageID )
			end

			this:UpdateMark()
			this.Lock = true
		end

		btn.OnCursorExited = function( this )
			this.Lock = false
		end

		btn.PerformLayout = function( this )
			if mark.Button != this then
				this:UpdateMark()
			end
		end

		btn.UpdateMark = function( this )
			if root.ActivePage != this.PageID then return end
			
			mark.Button = this

			local len = 0.35
			
			if mark:IsVisible() then
				mark:SizeTo( this:GetWide(), -1, len )
				mark:MoveTo( this:GetX(), nav:GetTall() - mark:GetTall(), len )
			else
				mark:SetVisible( true )
				mark:SetWide( this:GetWide() )
				mark:SetPos( this:GetX(), nav:GetTall() - mark:GetTall() )
				mark:AlphaTo( 255, 0.2 )

				len = len * 0.5
			end

			local new_color = this.Color or mark._Color
			local old_color = Color( mark.ColorR, mark.ColorG, mark.ColorB, mark.ColorA )

			local anim = mark:NewAnimation( len )

			anim.Think = function( tab, pnl, f )
				pnl:SetColor(
					old_color.r + ( new_color.r - old_color.r ) * f,
					old_color.g + ( new_color.g - old_color.g ) * f,
					old_color.b + ( new_color.b - old_color.b ) * f,
					old_color.a + ( new_color.a - old_color.a ) * f
				)
			end

			anim.OnEnd = function( tab, pnl )
				pnl:SetColor( new_color:Unpack() )
			end
		end
	end

	self:LoadPage( handler.Index or "index" )
end

vgui.Register( "SLCFrame", PANEL, "DFrame" )