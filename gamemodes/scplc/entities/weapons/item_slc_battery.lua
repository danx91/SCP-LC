SWEP.Base 		= "item_slc_base"
SWEP.Droppable 	= true
SWEP.Language 	= "BATTERY"

SWEP.WorldModel 			= "models/mishka/models/battery.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= true

SWEP.SelectFont = "SCPHUDMedium"
SWEP.Stacks 	= 3
SWEP.Selectable = false

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

/*concommand.Add( "spawnbat", function( ply, cmd, args )
	local bat = ents.Create( "item_slc_battery" )
	bat:SetPos( ply:GetEyeTrace().HitPos )
	bat:Spawn()
end )*/