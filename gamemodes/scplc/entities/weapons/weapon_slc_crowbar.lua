SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "CROWBAR"

SWEP.ViewModel 		= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel 	= "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV	= 56

SWEP.Primary.Automatic = true

SWEP.HoldType 		= "melee"
SWEP.Group			= "melee"

SWEP.AttackSpeed 	= 1
SWEP.AttackDamage 	= { 20, 8 }
SWEP.AttackDelay 	= { 0.75, 1.5 }
SWEP.StaminaCost	= 7.5

if CLIENT then
	SWEP.SelectFont = "SCPHLIcons"
	SWEP.IconLetter = "c"
end

function SWEP:SetupDataTables()
	self:AddNetworkVar( "NextIdle", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	self:SwingThink()

	local vm = self:GetOwner():GetViewModel()
	local ct = CurTime()
	local idle = self:GetNextIdle()

	if idle < ct then
		vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_IDLE ) )
		self:SetNextIdle( ct + vm:SequenceDuration() / vm:GetPlaybackRate() )
	end
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_DRAW ) )
	vm:SetPlaybackRate( 2 )

	local dur = vm:SequenceDuration() / vm:GetPlaybackRate()
	local cd = CurTime() + dur
	self:SetNextPrimaryFire( cd )
	self:SetNextIdle( cd )

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnDrop()
	self.SwingAttackData = nil
end

SWEP.AttackPathStart = Vector( 0, 6, 5 )
SWEP.AttackPathEnd = Vector( 0, -4, -6 )
SWEP.AttackFOVStart = -5
SWEP.AttackFOVEnd = 20
SWEP.AttackMins = Vector( -1, -1, -1 )
SWEP.AttackMaxs = Vector( 1, 1, 1 )
SWEP.AttackRangeStart = 70
SWEP.AttackRangeEnd = 35
SWEP.AttackFallbackRange = 65
SWEP.AttackFallbackBounds = 1.5

function SWEP:PrimaryAttack()
	local ct = CurTime()
	local owner = self:GetOwner()

	if owner:GetExhausted() then return end

	local stamina = owner:GetStamina()
	if stamina < self.StaminaCost then return end
	owner:SetStamina( stamina - self.StaminaCost )
	owner.StaminaRegen = ct + 1.5

	local dur = self:PlayActivity( ACT_VM_MISSCENTER, self.AttackSpeed )
	self:SetNextPrimaryFire( ct + dur * math.Map( stamina, owner:GetMaxStamina(), 0, self.AttackDelay[1], self.AttackDelay[2] ) )

	owner:DoAttackEvent()

	self:SwingAttack( {
		path_start = self.AttackPathStart,
		path_end = self.AttackPathEnd,
		fov_start = self.AttackFOVStart,
		fov_end = self.AttackFOVEnd,
		duration = dur * 0.25,
		num = 8,
		dist_start = self.AttackRangeStart,
		dist_end = self.AttackRangeEnd,
		mins = self.AttackMins,
		maxs = self.AttackMaxs,
		on_start = function()
			self:EmitSound( "Weapon_Crowbar.Single" )
		end,
		callback = function( tr, num, center )
			local ent = tr.Entity
			if !IsValid( ent ) and num < 3 then
				if center then
					self:EmitSound( "Weapon_Crowbar.Melee_Hit" )
					self:PlayActivity( ACT_VM_HITCENTER, self.AttackSpeed )

					if SERVER then
						self:DispatchImpactTrace( tr, DMG_CLUB )
					end

					return
				end

				return true, {
					distance = self.AttackFallbackRange,
					bounds = self.AttackFallbackBounds,
				}
			end
			
			if ent:IsPlayer() then
				util.Decal( "Impact.Flesh", tr.HitPos + tr.HitNormal * 20, tr.HitPos - tr.HitNormal * 20, owner )
			end

			self:EmitSound( "Weapon_Crowbar.Melee_Hit" )
			self:PlayActivity( ACT_VM_HITCENTER, self.AttackSpeed )

			if SERVER then
				self:DispatchImpactTrace( tr, DMG_CLUB )

				local dmg = DamageInfo()

				dmg:SetAttacker( owner )
				dmg:SetInflictor( self )

				dmg:SetDamage( math.Map( stamina, owner:GetMaxStamina(), 0, self.AttackDamage[1], self.AttackDamage[2] ) )
				dmg:SetDamageType( DMG_CLUB )

				SuppressHostEvents( NULL )
				ent:TakeDamageInfo( dmg )
				SuppressHostEvents( owner )
			end

			return true
		end
	} )
end

function SWEP:SecondaryAttack()

end

function SWEP:PlayActivity( act, speed )
	local owner = self:GetOwner()

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( act ) )
	vm:SetPlaybackRate( speed )

	local dur = vm:SequenceDuration() / speed
	self:SetNextIdle( CurTime() + dur )

	return dur
end

AddLoadout( "weapon_slc_crowbar", nil, "melee_mid" )
MarkAsWeapon( "weapon_slc_crowbar" )