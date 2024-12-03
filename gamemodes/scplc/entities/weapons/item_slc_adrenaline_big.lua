SWEP.Base 				= "item_slc_adrenaline"
SWEP.Language			= "ADRENALINE_BIG"

SWEP.InjectSpeed		= 1
SWEP.SelfInjectSpeed	= 0.9
SWEP.BoostTime			= 30

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/adrenaline.png" )
	SWEP.SelectColor = Color( 0, 123, 255, 255 )
end

function SWEP:HandleUpgrade( mode, exit, ply )
	if mode < 2 then
		self:Remove()
	elseif mode == 2 then
		local new = ents.Create( "item_slc_morphine_big" )
		if IsValid( new ) then
			new:SetPos( exit )
			new:Spawn()
			
			if self.PickupPriority then
				new.PickupPriority = self.PickupPriority
				new.PickupPriorityTime = CurTime() + 10
			end

			self:Remove()
		end
	else
		if self.PickupPriority then
			self.Dropped = CurTime()
			self.PickupPriorityTime = CurTime() + 10
		end

		self:SetPos( exit )
	end
end