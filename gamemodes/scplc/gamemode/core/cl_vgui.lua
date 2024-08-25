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