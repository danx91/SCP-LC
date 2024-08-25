SWEP.Base 					= "item_slc_base"
SWEP.Language 				= "MEDKIT"

SWEP.WorldModel				= "models/mishka/models/firstaidkit.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel 	= false

SWEP.Primary.Automatic 		= true
SWEP.Secondary.Automatic 	= true

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/medkit.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.scp914upgrade = "item_slc_medkitplus"

SWEP.HealDmg 	= 40
SWEP.HealRand 	= 10
SWEP.Charges 	= 3
SWEP.MaxCharges = 3
SWEP.HealTime 	= 3

SWEP.HealCooldown 	= 0

SWEP.Skin = 0

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Charges", "Int" )
	self:AddNetworkVar( "HealEnd", "Float" )

	self:SetCharges( self.Charges )

	if CLIENT then
		self:NetworkVarNotify( "Charges", function( ent, name, old, new )
			self.PrintName = string.format( self.Lang.name, new )
		end )
	end
end

function SWEP:Initialize()
	self:CallBaseClass( "Initialize" )

	if CLIENT then
		self.ShowName = self.Lang.showname
		self.PrintName = string.format( self.Lang.name, self:GetCharges() )
	end

	self:SetSkin( self.Skin or 0 )
end

function SWEP:Equip()
	if CLIENT then
		self.PrintName = string.format( self.Lang.name, self:GetCharges() )
	end

	self:StopHeal( 0.5 )
end

function SWEP:OnDrop()
	self:StopHeal( 0.5 )
end

function SWEP:Think()
	if CLIENT then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "medkit_heal" ) and ( !self:IsValidHealTarget( self.HealTarget ) or ROUND.post ) then
		self:StopHeal()
		return
	end

	local status = owner:UpdateHold( self, "medkit_heal" )
	if status == true then
		local target = self.HealTarget
		self:StopHeal()

		local rnd = math.random() * 2 - 1
		local heal = self.HealDmg + math.ceil( self.HealRand * rnd )

		local override = hook.Run( "SLCScaleHealing", target, owner, heal )
		if isnumber( override ) then
			heal = override
		end

		local hp = math.min( target:Health() + heal, target:GetMaxHealth() )
		target:SetHealth( hp )
		hook.Run( "SLCHealed", target, owner, heal )

		local charges = self:GetCharges() - 1
		self:SetCharges( charges )

		if target != owner then
			owner:AddFrags( 1 )
			PlayerMessage( "healplayer$1", owner )
		end

		if charges <= 0 then
			self:Remove()
		end
	elseif status == false then
		self:StopHeal()
	end
end

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.post or self.HealCooldown > CurTime() then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "medkit_heal" ) then return end

	self:Heal( owner, IN_ATTACK )
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.post or self.HealCooldown > CurTime() then return end

	local owner = self:GetOwner()

	local start = owner:GetShootPos()
	local trace = util.TraceHull{
		start = start,
		endpos = start + owner:GetAimVector() * 50,
		filter = owner,
		mins = Vector( -8, -8, -8 ),
		maxs = Vector( 8, 8, 8 )
	}

	if owner:IsHolding( self, "medkit_heal" ) then
		if trace.Entity != self.HealTarget then
			self:StopHeal()
			return
		end
	else
		self:Heal( trace.Entity, IN_ATTACK2 )
	end
end

function SWEP:StopHeal( time )
	if CLIENT then return end

	self:PopSpeed()
	self.HealCooldown = CurTime() + ( time or 3 )

	self.HealTarget = nil
	self:SetHealEnd( 0 )

	local owner = self:GetOwner()

	if IsValid( owner ) then
		owner:InterruptHold( self, "medkit_heal" )
	elseif IsValid( self.LastOwner ) then
		self.LastOwner:InterruptHold( self, "medkit_heal" )
	end
end

function SWEP:PopSpeed()
	if IsValid( self.HealTarget ) then
		self.HealTarget:PopSpeed( "SLC_Medkit" )
	end

	local owner = self:GetOwner()
	if IsValid( owner ) then
		owner:PopSpeed( "SLC_Medkit" )
	elseif IsValid( self.LastOwner ) then
		self.LastOwner:PopSpeed( "SLC_Medkit" )
	end
end

function SWEP:IsValidHealTarget( ply )
	return IsValid( ply ) and ply:IsPlayer() and ply:Alive() and ply:IsHuman()
end

function SWEP:Heal( ply, key )
	if !self:IsValidHealTarget( ply ) then return end
	
	local owner = self:GetOwner()
	if hook.Run( "SLCCanHeal", ply, owner, "medkit" ) == false then return end
	if hook.Run( "SLCNeedHeal", ply, owner, "medkit" ) != true and ply:GetMaxHealth() - ply:Health() < 10 then return end

	if SERVER then
		self.LastOwner = owner
		owner:PushSpeed( 0.2, 0.2, -1, "SLC_Medkit" )

		if ply != owner then
			ply:PushSpeed( 0.2, 0.2, -1, "SLC_Medkit" )
		end
	end
	
	self.HealTarget = ply

	owner:StartHold( self, "medkit_heal", key, self.HealTime )
	self:SetHealEnd( CurTime() + self.HealTime )
end

function SWEP:DrawHUD()
	if hud_disabled then return end

	local heal_end = self:GetHealEnd()
	local ct = CurTime()
	if heal_end > ct then
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawRing( ScrW() * 0.5, ScrH() * 0.5, 30, 6, 360, 40, 1 - ( heal_end - ct ) / self.HealTime )
	end
end