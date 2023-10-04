SWEP.Base 				= "item_slc_syringe"
SWEP.Language			= "ADRENALINE"

SWEP.Color 				= Vector( 0.4, 0.6, 1 )
SWEP.InjectSpeed		= 1.2
SWEP.SelfInjectSpeed	= 1.1
SWEP.BoostTime			= 15

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/adrenaline.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:CanUseOn( target, owner )
	if !target:Alive() or !target:IsHuman() then return end
	if hook.Run( "SLCCanHeal", target, owner, "adrenaline" ) == false then return end

	return true
end

function SWEP:UsedOn( target, owner )
	if CLIENT then return end

	local time = target:GetStaminaBoost() - CurTime()
	if time < 0 then
		time = 0
	end

	time = time + self.BoostTime

	target:SetStaminaBoost( CurTime() + time )
	target:SetStaminaBoostDuration( time )
end