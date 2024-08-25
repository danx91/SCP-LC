function RebuildFonts()
	local font = SLC_PRIMARY_FONT or "Impacted"
	local font_digit = SLC_DIGITS_FONT or "DS-Digital"
	local font_info = SLC_INFO_FONT or "unispace"

	local size_prim = SLC_PRIMARY_FONT_SIZE or 1
	local size_digit = SLC_DIGITS_FONT_SIZE or 1
	local size_info = SLC_INFO_FONT_SIZE or 1
	local w = ScrW()

	CreateFont( "SCPHUDESmall", {
		font = font,
		size = w * 0.01 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDVSmall", {
		font = font,
		size = w * 0.015 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDSmall", {
		font = font,
		size = w * 0.0175 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDMedium", {
		font = font,
		size = w * 0.021 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDBig", {
		font = font,
		size = w * 0.0275 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHUDVBig", {
		font = font,
		size = w * 0.035 * size_prim,
		antialias = true,
		weight = 500,
		extended = true
	} )

	CreateFont( "SCPNumbersBig", {
		font = font_digit,
		size = w * 0.02 * size_digit,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPNumbersMedium", {
		font = font_digit,
		size = w * 0.0175 * size_digit,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPNumbersSmall", {
		font = font_digit,
		size = w * 0.015 * size_digit,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPInfoScreenBig", {
		font = font_info,
		size = w * 0.04 * size_info,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPInfoScreenMedium", {
		font = font_info,
		size = w * 0.0325 * size_info,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPInfoScreenSmall", {
		font = font_info,
		size = w * 0.015 * size_info,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPHLIcons", {
		font = "HalfLife2",
		size = w * 0.04,
		antialias = true,
	} )

	CreateFont( "SCPCSSIcons", {
		font = "csd",
		size = w * 0.05,
		antialias = true,
	} )

	CreateFont( "SCPCSSIconsSmall", {
		font = "csd",
		size = w * 0.04,
		antialias = true,
	} )

	timer.Simple( 0, function()
		hook.Run( "RebuildFonts" )
	end )
end

function RebuildScaledFonts( scale )
	local font = SLC_PRIMARY_FONT or "Impacted"
	local font_digit = SLC_DIGITS_FONT or "DS-Digital"

	local size_prim = SLC_PRIMARY_FONT_SIZE or 1
	local size_digit = SLC_DIGITS_FONT_SIZE or 1
	local w = ScrW()

	CreateFont( "SCPScaledHUDVSmall", {
		font = font,
		size = w * 0.017 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledHUDVSmall_Blur", {
		font = font,
		size = w * 0.017 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
		blursize = 4,
	} )

	CreateFont( "SCPScaledHUDSmall", {
		font = font,
		size = w * 0.020 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledHUDSmall_Blur", {
		font = font,
		size = w * 0.020 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
		blursize = 4,
	} )

	CreateFont( "SCPScaledHUDMedium", {
		font = font,
		size = w * 0.025 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledHUDBig", {
		font = font,
		size = w * 0.03 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	CreateFont( "SCPScaledNumbersVBig", {
		font = font_digit,
		size = w * 0.028 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPScaledNumbersBig", {
		font = font_digit,
		size = w * 0.023 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPScaledNumbersMedium", {
		font = font_digit,
		size = w * 0.02 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )

	CreateFont( "SCPScaledNumbersSmall", {
		font = font_digit,
		size = w * 0.017 * scale * size_digit,
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

timer.Simple( 1, function()
	surface.CreateFont( "slc_impacted_test", {
		font = "Impacted",
		size = 16,
	} )

	surface.SetFont( "slc_impacted_test" )
	if surface.GetTextSize( "W" ) != 9 then
		print( "Custom font failed to load! Falling back to Impact.." )

		SLC_PRIMARY_FONT = "Impact"
		SLC_PRIMARY_FONT_SIZE = 0.83

		RebuildFonts()
		RebuildScaledFonts( GetHUDScale() )

		SLCPopup( LANG.MISC.font.name, LANG.MISC.font.content, false, nil, LANG.MISC.font.ok )
	end
end )