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

function SWEP:HandleUpgrade( mode, num_mode, exit, ply )
	local new_ent

	if num_mode < 2 then
		self:Remove()
	elseif num_mode == 2 then
		new_ent = "item_slc_adrenaline"
	elseif num_mode == 3 then
		new_ent = "item_slc_morphine_big"
	else
		new_ent = math.random( 2 ) == 1 and "item_slc_morphine_big" or "item_slc_adrenaline_big"
	end

	if !new_ent then return end

	local new = ents.Create( new_ent )
	if IsValid( new ) then
		self:Remove()
		new:SetPos( exit )
		new:Spawn()
	end
end