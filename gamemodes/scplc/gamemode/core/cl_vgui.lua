local PANEL = FindMetaTable( "Panel" )

function PANEL:Within( other )
	if self == other then
		return true
	end

	local sx, sy, sw, sh = self:GetBounds()
	local ox, oy, ow, oh = other:GetBounds()

	return sx < ox + ow and sx + sw > ox and sy < oy + oh and sy + sh > oy
end

hook.Add( "PlayerButtonDown", "SLCVGUIVButtonDown", function( ply, btn )
	local pnl = vgui.GetHoveredPanel()
	if IsValid( pnl ) and pnl.HoveredButtonDown then
		pnl:HoveredButtonDown( btn )
	end
end )

function vgui.QuickPanel( parent, dock, dbg )
	local pnl = vgui.Create( "DPanel", parent )

	pnl:Dock( dock or TOP )
	pnl.Paint = dbg and function( _, pw, ph ) surface.SetDrawColor( 255, 255, 255 ) surface.DrawOutlinedRect( 0, 0, pw, ph ) end or function() end
	
	return pnl
end

function vgui.QuickLabel( text, parent, dock, font, color, copy )
	local label = vgui.Create( "DLabel", parent )

	label:Dock( dock or TOP )
	label:SetFont( font or "SLCFrame.Medium" )
	label:SetColor( color or Color( 255, 255, 255 ) )

	if isstring( text ) then
		label:SetText( text )
	elseif istable( text ) then
		label:SetText( text[1] )

		text[2]:Then( function( new )
			if !IsValid( label ) then return end
			label:SetText( new )
		end )
	else
		label:SetText( "Text" )
	end

	label:SizeToContents()

	if !copy then return label end

	local copy_txt = isstring( copy ) and copy or "Copied!"

	label:SetMouseInputEnabled( true )
	label.OnMousePressed = function( this, code )
		if this.Copy or code != MOUSE_LEFT then return end
		this.Copy = true
		
		local old = this:GetText()
		this:SetText( copy_txt )

		SetClipboardText( old )

		timer.Simple( 1, function()
			if !IsValid( this ) then return end
			this.Copy = false

			if this:GetText() != copy_txt then return end
			this:SetText( old )
		end )
	end

	return label
end

local steamworks_player_info
function vgui.NickLabel( sid, parent, dock, font, color, copy )
	if !steamworks_player_info then
		steamworks_player_info = SLCPromisify( steamworks.RequestPlayerInfo )
	end

	local name

	local ply = player.GetBySteamID64( sid )
	if IsValid( ply ) then
		name = ply:Nick()
	else
		name = {
			sid,
			steamworks_player_info( sid )
		}
	end

	return vgui.QuickLabel( name, parent, dock, font, color, copy )
end

function vgui.QuickMarkup( text, align, parent, dock, dbg )
	dock = dock or TOP

	local pnl = vgui.Create( "DPanel", parent )

	pnl:Dock( dock )
	
	pnl.Raw = text or ""

	pnl.PerformLayout = function( this, pw, ph )
		if this.Raw == "" then
			this.Markup = nil
			return
		end

		this.Markup = markup.Parse( this.Raw, pw )
	end

	pnl.SizeToContents = function( this )
		if !this.Markup then return end
		
		pnl:SetTall( this.Markup:GetHeight() + ( this.YOffset or 0 ) )
	end

	pnl.Paint = function( this, pw, ph )
		if dbg then
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 0, pw, ph )
		end

		if !this.Markup then return end

		if dock == FILL then
			this.Markup:Draw( this.XOffset or 0, ph * 0.5 + ( this.YOffset or 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, nil, a )
		else
			this.Markup:Draw( this.XOffset or 0, this.YOffset or 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, nil, a )
		end
	end
	
	pnl.SetText = function( this, t )
		this.Raw = t
		this:InvalidateLayout( true )
	end

	return pnl
end

function vgui.DebugPaint( _, w, h )
	surface.SetDrawColor( 255, 255, 255 )
	surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end