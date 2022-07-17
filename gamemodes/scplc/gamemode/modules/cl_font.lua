function RebuildFonts()
	local font = SLC_PRIMARY_FONT or "Impacted"
	local font_digit = SLC_DIGITS_FONT or "DS-Digital"
	local font_info = SLC_INFO_FONT or "unispace"

	CreateFont( "SCPHUDESmall", {
		font = font,
		size = ScrW() * 0.01,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDVSmall", {
		font = font,
		size = ScrW() * 0.015,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDSmall", {
		font = font,
		size = ScrW() * 0.0175,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDMedium", {
		font = font,
		size = ScrW() * 0.021,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDBig", {
		font = font,
		size = ScrW() * 0.0275,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDVBig", {
		font = font,
		size = ScrW() * 0.035,
		antialias = true,
		weight = 500,
		extended = true
	} )

	CreateFont( "SCPNumbersBig", {
		font = font_digit,
		size = ScrW() * 0.02,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPNumbersSmall", {
		font = font_digit,
		size = ScrW() * 0.015,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPInfoScreenBig", {
		font = font_info,
		size = ScrW() * 0.04,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPInfoScreenMedium", {
		font = font_info,
		size = ScrW() * 0.0325,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPInfoScreenSmall", {
		font = font_info,
		size = ScrW() * 0.015,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHLIcons", {
		font = "HalfLife2",
		size = ScrW() * 0.05,
		antialias = true,
	} )

	CreateFont( "SCPCSSIcons", {
		font = "csd",
		size = ScrW() * 0.06,
		antialias = true,
	} )

	timer.Simple( 0, function()
		hook.Run( "RebuildFonts" )
	end )
end

function RebuildScaledFonts( scale )
	local font = SLC_PRIMARY_FONT or "Impacted"
	local font_digit = SLC_DIGITS_FONT or "DS-Digital"

	CreateFont( "SCPScaledHUDVSmall", {
		font = font,
		size = ScrW() * 0.015 * scale,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledHUDSmall", {
		font = font,
		size = ScrW() * 0.0175 * scale,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledHUDMedium", {
		font = font,
		size = ScrW() * 0.021 * scale,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledHUDBig", {
		font = font,
		size = ScrW() * 0.0275 * scale,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledNumbersBig", {
		font = font_digit,
		size = ScrW() * 0.02 * scale,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPScaledNumbersSmall", {
		font = font_digit,
		size = ScrW() * 0.015 * scale,
		antialias = true,
		weight = 500,
	} )
end

BlurOutlineFonts = {}
function CreateFont( name, tab, bo_size )
	surface.CreateFont( name, tab )

	if bo_size then
		local n = name.."_b"

		tab.blursize = bo_size
		surface.CreateFont( n, tab )

		BlurOutlineFonts[name] = n
	end
end

RebuildFonts()