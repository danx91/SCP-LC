SWEP.PrintName			= "Entity Remover"

SWEP.ViewModelFOV 		= 56

SWEP.Droppable				= false

SWEP.DrawCrosshair			= true
SWEP.ViewModel				= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel				= "models/weapons/w_toolgun.mdl"
SWEP.IconLetter				= "Remover"
SWEP.SelectFont				= "SCPHUDMedium"
SWEP.HoldType 				= "normal"


function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() then return end

	local owner = self:GetOwner()
	local tr = owner:GetEyeTrace()
	local ent = tr.Entity
	if !IsValid( ent ) then return end

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	fxdata = EffectData()
	fxdata:SetEntity( self )
	fxdata:SetAttachment( 1 )
	fxdata:SetStart( owner:GetShootPos() )
	fxdata:SetOrigin( tr.HitPos )
	fxdata:SetNormal( tr.HitNormal )

	util.Effect( "tooltracer", fxdata )
	self:EmitSound( "Airboat.FireGunRevDown" )

	if !SERVER then return end
	ent:Remove()
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end