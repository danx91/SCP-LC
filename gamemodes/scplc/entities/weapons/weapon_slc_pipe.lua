SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "PIPE"

SWEP.ViewModel 		= "models/slusher/pipe/c_pipe.mdl"
SWEP.WorldModel 	= "models/slusher/pipe/w_pipe.mdl"
SWEP.UseHands 		= true

SWEP.Primary.Automatic = true

SWEP.HoldType 		= "melee"

SWEP.Group			= "melee"

SWEP.AttackSpeed 	= 1.6
SWEP.AttackDamage 	= { 15, 21 }
SWEP.HitsPerLevel 	= 3

if CLIENT then
	SWEP.WepSelectIcon = Material( "weapons/slusher/hm_pipe.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", "NextIdle" )
	self:NetworkVar( "Float", "Attack" )

	self:NetworkVar( "Int", "Hits" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	self:SetHits( self.HitsPerLevel * 4 )
	self:SetBodygroup( 0, 0 )
end

function SWEP:Think()
	local vm = self:GetOwner():GetViewModel()
	local ct = CurTime()
	local idle = self:GetNextIdle()

	if idle < ct then
		vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_IDLE ) )
		self:SetNextIdle( ct + vm:SequenceDuration() / vm:GetPlaybackRate() )

		if self:GetHits() <= 0 then
			//self:EmitSound( "Weapon_Crowbar.Melee_HitWorld" )
			self:EmitSound( "Plastic_Barrel.Break" )
			if CLIENT then return end

			self:Remove()
		end
	end

	local attack = self:GetAttack()
	if attack > 0 and attack < ct then
		self:SetAttack( 0 )
		self:DoAttack()
	end
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_DRAW ) )
	vm:SetPlaybackRate( 1 )

	local dur = vm:SequenceDuration() / vm:GetPlaybackRate()
	self:SetNextPrimaryFire( CurTime() + dur )
	self:SetNextIdle( CurTime() + dur )

	local bg = math.Clamp( 4 - math.ceil( self:GetHits() / self.HitsPerLevel ), 0, 3 )
	self:SetBodygroup( 0, bg )
	vm:SetBodygroup( 0, bg )

	return true
end

function SWEP:Holster()
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local vm = owner:GetViewModel()
	if !IsValid( vm ) then return end

	vm:SetBodygroup( 0, 0 )
	return self:GetHits() > 0
end

function SWEP:OnDrop()
	if SERVER and self:GetHits() <= 0 then
		self:Remove()
	end
end

function SWEP:PrimaryAttack()
	local ct = CurTime()
	local owner = self:GetOwner()

	owner:SetAnimation( PLAYER_ATTACK1 )

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_HITCENTER ) )
	vm:SetPlaybackRate( self.AttackSpeed )

	local dur = vm:SequenceDuration() / self.AttackSpeed
	self:SetNextPrimaryFire( ct + dur + 0.1 )
	self:SetNextIdle( ct + dur )
	
	self:SetAttack( ct + dur * 0.3 )
	self:EmitSound( "Weapon_Crowbar.Single" )
end

function SWEP:SecondaryAttack()

end

local trace_tab = {}
trace_tab.mins = Vector( -6, -6, -4 )
trace_tab.maxs = Vector( 6, 6, 4 )
trace_tab.mask = MASK_SHOT_HULL
trace_tab.output = trace_tab

function SWEP:DoAttack()
	local owner = self:GetOwner()
	local start = owner:GetShootPos()
	local aim = owner:GetAimVector()

	trace_tab.start = start
	trace_tab.endpos = start + aim * 65
	trace_tab.filter = owner

	owner:LagCompensation( true )

	util.TraceLine( trace_tab )

	if !IsValid( trace_tab.Entity ) then
		util.TraceHull( trace_tab )
	end

	owner:LagCompensation( false )

	if trace_tab.Hit then
		local hits = self:GetHits() - 1
		self:SetHits( hits )

		local bg = math.Clamp( 4 - math.ceil( hits / self.HitsPerLevel ), 0, 3 )
		self:SetBodygroup( 0, bg )
		owner:GetViewModel():SetBodygroup( 0, bg )

		if hits <= 0 then
			self.PreventDropping = true
		end
	end

	local ent = trace_tab.Entity

	if !IsValid( ent ) then
		if trace_tab.Hit then
			self:EmitSound( "Weapon_Crowbar.Melee_HitWorld" )
		end

		return
	end

	if ent:IsPlayer() then
		util.Decal( "Impact.Flesh", trace_tab.HitPos + trace_tab.HitNormal * 20, trace_tab.HitPos - trace_tab.HitNormal * 20, owner )
		self:EmitSound( "Weapon_Crowbar.Melee_Hit" )
	else
		self:EmitSound( "Weapon_Crowbar.Melee_HitWorld" )
	end

	if CLIENT then return end

	local dmg = DamageInfo()

	dmg:SetAttacker( owner )
	dmg:SetInflictor( self )

	dmg:SetDamage( SLCRandom( self.AttackDamage[1], self.AttackDamage[2] ) )
	dmg:SetDamageType( DMG_CLUB )

	SuppressHostEvents( NULL )
	ent:TakeDamageInfo( dmg )
	SuppressHostEvents( owner )
end

AddWeaponLoadout( "weapon_slc_pipe", nil, "melee_low" )
MarkAsWeapon( "weapon_slc_pipe" )