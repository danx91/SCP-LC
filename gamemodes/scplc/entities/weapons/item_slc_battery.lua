SWEP.Base 		= "item_slc_base"
SWEP.Language 	= "BATTERY"

SWEP.WorldModel 			= "models/mishka/models/battery.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.Stacks 	= 3
SWEP.Selectable = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/battery.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end