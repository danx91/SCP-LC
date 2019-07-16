function RebuildFonts()
	surface.CreateFont( "SCPHUDVSmall", {
		font = "Impacted",
		size = ScrW() * 0.015,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	surface.CreateFont( "SCPHUDSmall", {
		font = "Impacted",
		size = ScrW() * 0.0175,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	surface.CreateFont( "SCPHUDMedium", {
		font = "Impacted",
		size = ScrW() * 0.021,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	surface.CreateFont( "SCPHUDBig", {
		font = "Impacted",
		size = ScrW() * 0.0275,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	surface.CreateFont( "SCPHUDVBig", {
		font = "Impacted",
		size = ScrW() * 0.035,
		antialias = true,
		weight = 500,
		extended = true,
	} )

	surface.CreateFont( "SCPNumbersBig", {
		font = "DS-Digital",
		size = ScrW() * 0.02,
		antialias = true,
		weight = 500,
	} )

	surface.CreateFont( "SCPNumbersSmall", {
		font = "DS-Digital",
		size = ScrW() * 0.015,
		antialias = true,
		weight = 500,
	} )

	surface.CreateFont( "SCPHLIcons", {
		font = "HalfLife2",
		size = ScrW() * 0.05,
		antialias = true,
	} )

	surface.CreateFont( "SCPCSSIcons", {
		font = "csd",
		size = ScrW() * 0.06,
		antialias = true,
	} )

	timer.Simple( 0, function()
		hook.Run( "RebuildFonts" )
	end )
end

RebuildFonts()