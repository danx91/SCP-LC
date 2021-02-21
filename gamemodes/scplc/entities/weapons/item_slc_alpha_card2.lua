SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "ALPHA_CARD2"

SWEP.WorldModel		= "models/slc/nuclear_card.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.Selectable = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/nuclear_card.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end