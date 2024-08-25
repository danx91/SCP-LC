SWEP.Base 				= "item_slc_base"
SWEP.Language 			= "GLASS_KNIFE"

SWEP.ViewModel 			= "models/slusher/glass_knife/c_glass_knife.mdl"
SWEP.WorldModel 		= "models/slusher/glass_knife/w_glass_knife.mdl"
SWEP.UseHands 			= true

SWEP.HoldType 			= "knife"

SWEP.Group				= "melee"

SWEP.AttackSpeed 		= 1
SWEP.AttackDamage 		= 15
SWEP.StrongAttackDamage = 25
SWEP.Hits 				= 9

if CLIENT then
	SWEP.WepSelectIcon = Material( "weapons/slusher/hm_glass_knife.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()	
	self:AddNetworkVar( "NextIdle", "Float" )
	self:AddNetworkVar( "ComboTime", "Float" )

	self:AddNetworkVar( "Hits", "Int" )
	self:AddNetworkVar( "Combo", "Int" )

end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	self:SetHits( self.Hits )
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
	vm:SetPlaybackRate( 1 )

	local dur = vm:SequenceDuration() / vm:GetPlaybackRate()
	self:SetNextPrimaryFire( CurTime() + dur )
	self:SetNextIdle( CurTime() + dur )

	self:EmitSound( "Weapon_Knife.Deploy" )

	return true
end

function SWEP:Holster()
	return true
end

local paths = {
	[3] = {
		Vector( 0, -4, 6 ),
		Vector( 0, 4, -10 ),
		25,
		-25,
	},
	[4] = {
		Vector( 0, 4, 6 ),
		Vector( 0, -4, -10 ),
		-25,
		25,
	},
	[5] = {
		Vector( 0, 4, 0 ),
		Vector( 25, 4, 0 ),
		0,
		0,
	},
}

local mins, maxs = Vector( -2, -2, -2 ), Vector( 2, 2, 2 )
local str_mins, str_maxs = Vector( -4, -4, -4 ), Vector( 4, 4, 4 )

function SWEP:PrimaryAttack()
	local ct = CurTime()
	local owner = self:GetOwner()

	owner:SetAnimation( PLAYER_ATTACK1 )

	local combo = self:GetCombo()
	if combo > 0 and self:GetComboTime() < ct then
		combo = 0
	end

	local seq = combo + 3
	local strong = seq == 5

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( self.AttackSpeed )

	local dur = vm:SequenceDuration() / self.AttackSpeed
	self:SetNextPrimaryFire( ct + dur + 0.1 )
	self:SetNextIdle( ct + dur )
	
	self:SetCombo( ( combo + 1 ) % 3 )
	self:SetComboTime( ct + dur + 0.75 )

	local ent_filter = {}
	local path = paths[seq]
	self:SwingAttack( {
		path_start = path[1],
		path_end = path[2],
		fov_start = path[3],
		fov_end = path[4],
		delay = 0.3,
		duration = 0.1,
		num = 6,
		distance = strong and 30 or 60,
		mins = strong and str_mins or mins,
		maxs = strong and str_maxs or maxs,
		on_start = function()
			self:EmitSound( "WeaponFrag.Throw" )
		end,
		callback = function( tr, num )
			local ent = tr.Entity
			if IsValid( ent ) then
				if ent_filter[ent] then return end
				ent_filter[ent] = true
				
				if ent:IsPlayer() then
					self:EmitSound( "Weapon_Knife.Hit" )

					local eff = EffectData()
					eff:SetOrigin( tr.HitPos )
					eff:SetNormal( tr.HitNormal )
					util.Effect( "BloodImpact", eff )
				else
					self:EmitSound( "Weapon_Knife.HitWall" )
				end

				if SERVER then
					local dmg = DamageInfo()

					dmg:SetAttacker( owner )
					dmg:SetInflictor( self )

					dmg:SetDamage( strong and self.StrongAttackDamage or self.AttackDamage )
					dmg:SetDamageType( DMG_SLASH )

					SuppressHostEvents( NULL )
					ent:TakeDamageInfo( dmg )
					SuppressHostEvents( owner )
				end

				if num > 0 then
					local hits = self:GetHits() - 1
					self:SetHits( hits )

					if hits <= 0 then
						self:DestroyWeapon( tr.HitPos )
						return true
					end
				end

				return strong
			elseif tr.Hit then
				self:EmitSound( "Weapon_Knife.HitWall" )

				if num > 0 then
					local hits = self:GetHits() - 1
					self:SetHits( hits )

					if hits <= 0 then
						self:DestroyWeapon( tr.HitPos )
						return true
					end
				end

				self:SetNextIdle( CurTime() )

				return true, !strong and num < 3 and {
					distance = 60,
					bounds = 1.5,
				}
			end
		end
	} )
end

function SWEP:SecondaryAttack()

end

function SWEP:DestroyWeapon( pos )
	self:EmitSound( "Glass.BulletImpact" )

	if CLIENT then
		local eff = EffectData()
		eff:SetOrigin( pos )
		eff:SetNormal( -self:GetOwner():GetAimVector() )
		util.Effect( "GlassImpact", eff )
	else
		self:Remove()
	end
end

AddLoadout( "weapon_slc_glass_knife", nil, "melee_low" )
MarkAsWeapon( "weapon_slc_glass_knife" )