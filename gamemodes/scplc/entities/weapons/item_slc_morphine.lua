SWEP.Base 				= "item_slc_syringe"
SWEP.Language			= "MORPHINE"

SWEP.Color 				= Vector( 0.8, 0.2, 0.2 )
SWEP.InjectSpeed		= 1.3
SWEP.SelfInjectSpeed	= 1.2
SWEP.ExtraHealth		= 30

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/morphine.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:CanUseOn( target, owner )
	if !target:Alive() or !target:IsHuman() then return end
	if hook.Run( "SLCCanHeal", target, owner, "morphine" ) == false then return end

	return true
end

function SWEP:UsedOn( target, owner )
	local extra = target:GetExtraHealth() + self.ExtraHealth
	target:SetExtraHealth( extra )
	target:SetMaxExtraHealth( extra )
	target:SetProperty( "extra_hp_think", CurTime() + 1 )
end