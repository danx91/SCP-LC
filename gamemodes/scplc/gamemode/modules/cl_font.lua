function RebuildFonts()
	local font = SLC_PRIMARY_FONT or "Impacted"
	local font_digit = SLC_DIGITS_FONT or "DS-Digital"
	local font_info = SLC_INFO_FONT or "unispace"

	local size_prim = SLC_PRIMARY_FONT_SIZE or 1
	local size_digit = SLC_DIGITS_FONT_SIZE or 1
	local size_info = SLC_INFO_FONT_SIZE or 1
	local w = ScrW()

	SLCCreateFont( "SCPHUDESmall", {
		font = font,
		size = w * 0.01 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	}, 4 )

	SLCCreateFont( "SCPHUDVSmall", {
		font = font,
		size = w * 0.015 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	}, 4 )

	SLCCreateFont( "SCPHUDSmall", {
		font = font,
		size = w * 0.0175 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	}, 4 )

	SLCCreateFont( "SCPHUDMedium", {
		font = font,
		size = w * 0.021 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	}, 4 )

	SLCCreateFont( "SCPHUDBig", {
		font = font,
		size = w * 0.0275 * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	}, 4 )

	SLCCreateFont( "SCPHUDVBig", {
		font = font,
		size = w * 0.035 * size_prim,
		antialias = true,
		weight = 500,
		extended = true
	}, 4 )

	SLCCreateFont( "SCPNumbersBig", {
		font = font_digit,
		size = w * 0.02 * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPNumbersMedium", {
		font = font_digit,
		size = w * 0.0175 * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPNumbersSmall", {
		font = font_digit,
		size = w * 0.015 * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPNumbersVSmall", {
		font = font_digit,
		size = w * 0.012 * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPInfoScreenBig", {
		font = font_info,
		size = w * 0.04 * size_info,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPInfoScreenMedium", {
		font = font_info,
		size = w * 0.0325 * size_info,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPInfoScreenSmall", {
		font = font_info,
		size = w * 0.015 * size_info,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPHLIcons", {
		font = "HalfLife2",
		size = w * 0.04,
		antialias = true,
	} )

	SLCCreateFont( "SCPCSSIcons", {
		font = "csd",
		size = w * 0.05,
		antialias = true,
	} )

	SLCCreateFont( "SCPCSSIconsSmall", {
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

	SLCCreateFont( "SCPScaledHUDVSmall", {
		font = font,
		size = w * 0.017 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPScaledHUDVSmall_Blur", {
		font = font,
		size = w * 0.017 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
		blursize = 4,
	} )

	SLCCreateFont( "SCPScaledHUDSmall", {
		font = font,
		size = w * 0.020 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPScaledHUDSmall_Blur", {
		font = font,
		size = w * 0.020 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
		blursize = 4,
	} )

	SLCCreateFont( "SCPScaledHUDMedium", {
		font = font,
		size = w * 0.025 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPScaledHUDBig", {
		font = font,
		size = w * 0.03 * scale * size_prim,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	SLCCreateFont( "SCPScaledNumbersVBig", {
		font = font_digit,
		size = w * 0.028 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPScaledNumbersBig", {
		font = font_digit,
		size = w * 0.023 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPScaledNumbersMedium", {
		font = font_digit,
		size = w * 0.02 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )

	SLCCreateFont( "SCPScaledNumbersSmall", {
		font = font_digit,
		size = w * 0.017 * scale * size_digit,
		antialias = true,
		weight = 500,
	} )
end

BlurOutlineFonts = {}
function SLCCreateFont( name, tab, bo_size )
	if bo_size then
		tab.blursize = 0
	end

	surface.CreateFont( name, tab )

	if bo_size then
		local n = name.."_bo"

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

		SLCLegacyPopup( LANG.MISC.font.name, LANG.MISC.font.content, false, nil, LANG.MISC.font.ok )
	end
end )