local PANEL = {}

function PANEL:Paint( w, h )
	render.ClearStencil()
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 1 )

	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.SetStencilCompareFunction( STENCIL_NEVER )

	render.SetStencilEnable( true )

	draw.NoTexture()
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawFilledCircle( w / 2, h / 2, w / 2, self.Quality or 24 )

	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilCompareFunction( STENCIL_EQUAL )
end

function PANEL:PaintOver( w, h )
	render.SetStencilEnable( false )
end

vgui.Register( "SLCAvatar", PANEL, "AvatarImage" )