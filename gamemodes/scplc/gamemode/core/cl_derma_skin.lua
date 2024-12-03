local draw = draw
local surface = surface
local Color = Color

SKIN = {}

SKIN.PrintName		= "SCP: Lost Control Derma Skin"
SKIN.Author			= "ZGFueDkx"
SKIN.DermaVersion	= 1

SKIN.colTextEntryBackground		= Color( 25, 25, 25 )
SKIN.colTextEntryBorder			= Color( 75, 75, 75 )

SKIN.colTextEntryText			= Color( 240, 240, 240 )
SKIN.colTextEntryTextHighlight	= Color( 155, 225, 240 )
SKIN.colTextEntryTextCursor		= Color( 225, 225, 225 )
SKIN.colTextEntryTextPlaceholder= Color( 128, 128, 128 )


function SKIN:PaintTextEntry( panel, w, h )
	draw.RoundedBox( 8, 0, 0, w, h, panel.BorderColorOverride or self.colTextEntryBorder )
	draw.RoundedBox( 8, 1, 1, w - 2, h - 2, panel.BackgroundColorOverride or self.colTextEntryBackground )

	if ( panel.GetPlaceholderText && panel.GetPlaceholderColor && panel:GetPlaceholderText() && panel:GetPlaceholderText():Trim() != "" && panel:GetPlaceholderColor() && ( !panel:GetText() || panel:GetText() == "" ) ) then

		local oldText = panel:GetText()

		local str = panel:GetPlaceholderText()
		if ( str:StartsWith( "#" ) ) then str = str:sub( 2 ) end
		str = language.GetPhrase( str )

		panel:SetText( str )
		panel:DrawTextEntryText( panel:GetPlaceholderColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
		panel:SetText( oldText )

		return
	end

	panel:DrawTextEntryText( panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
end

derma.DefineSkin( "scplc", "SCP: Lost Control", SKIN )