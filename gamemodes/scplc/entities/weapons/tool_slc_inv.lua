SWEP.Base 			= "item_slc_base"
SWEP.PrintName		= "Inventory Checker"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.DrawCrosshair = false

SWEP.Droppable = false

SWEP.IconLetter			= "Inv"
SWEP.SelectFont			= "SCPHUDMedium"

function SWEP:Initialize()
	
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local owner = self:GetOwner()
	local tr = owner:GetEyeTrace()
	local ent = tr.Entity

	if !tr.Hit or !IsValid( ent ) or !ent:IsPlayer() then return end

	owner:ChatPrint( "Target: "..ent:Nick() )
	for i, v in ipairs( ent:GetWeapons() ) do
		owner:ChatPrint( v:GetClass() )
	end
end