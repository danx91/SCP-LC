SWEP.Base 		= "item_slc_base"
SWEP.Language 	= "BATTERY"

SWEP.WorldModel 			= "models/mishka/models/battery.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= true

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/battery.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

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