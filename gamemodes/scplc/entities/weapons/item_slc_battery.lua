SWEP.Base 		= "item_slc_base"
SWEP.Droppable 	= true
SWEP.Language 	= "BATTERY"

SWEP.WorldModel 			= "models/mishka/models/battery.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= true

SWEP.SelectFont = "SCPHUDMedium"
SWEP.Stacks 	= 3

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end