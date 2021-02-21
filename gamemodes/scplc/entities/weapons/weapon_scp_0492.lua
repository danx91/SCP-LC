SWEP.Base 				= "weapon_scp_base"
SWEP.PrintName			= "SCP-049-2"

SWEP.ViewModel 			= "models/weapons/v_zombiearms.mdl"
SWEP.ShouldDrawViewModel= true

SWEP.HoldType 			= "knife"

SWEP.PrimarySpeed 		= 1.4
SWEP.AttackDelay 		= 0.1

SWEP.SecondarySpeed 	= 0.85
SWEP.StrongDelay 		= 0.8

SWEP.SoundMiss 			= "npc/zombie/claw_miss1.wav"
SWEP.SoundHitWall		= "npc/zombie/claw_strike1.wav"
SWEP.SoundHitPrimary	= "npc/zombie/claw_strike2.wav"
SWEP.SoundHitSecondary	= "npc/zombie/claw_strike3.wav"

function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "SCP049" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP0492" )
end

SWEP.NAttack = 0
function SWEP:PrimaryAttack()
	if self.NAttack > CurTime() then return end
	self.NAttack = CurTime() + self.AttackDelay

	self:DoAttack( false )
end

function SWEP:SecondaryAttack()
	if self.NAttack > CurTime() then return end
	self.NAttack = CurTime() + self.StrongDelay

	self:DoAttack( true )
end

SWEP.NextIdle = 0
--SWEP.AT = "NA"
function SWEP:Think()
	if self.NextIdle < CurTime() then
		local vm = self:GetOwner():GetViewModel()
		local seq, time = vm:LookupSequence( "ACT_VM_IDLE" )

		self.NextIdle = CurTime() + time
		vm:SendViewModelMatchingSequence( seq )
		--self.AT = "IDLE"
	end
end

function SWEP:DoAttack( strong )
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	local act, speed

	if strong then
		act = ACT_VM_SECONDARYATTACK
		speed = self.SecondarySpeed

		owner:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
		--self.AT = "SECONDARY"
	else
		act = ACT_VM_HITCENTER
		speed = self.PrimarySpeed

		owner:SetAnimation( PLAYER_ATTACK1 )
		--self.AT = "PRIMARY"
	end

	local seq = vm:SelectWeightedSequence( act )
	local dur = vm:SequenceDuration( seq ) / speed

	self.NAttack = self.NAttack + dur
	self.NextIdle = CurTime() + dur

	vm:ResetSequenceInfo()
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( speed )

	if SERVER then
		timer.Simple( dur * 0.25, function()
			if IsValid( self ) and self:CheckOwner() then
				self:ApplyDamage( strong )
			end
		end )
	end
end

SWEP.DamageMult = 1
SWEP.LifeSteal = 0
function SWEP:ApplyDamage( strong )
	local owner = self:GetOwner()

	owner:LagCompensation( true )

	local tr = util.TraceHull{
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * 75,
		filter = owner,
		mask = MASK_SHOT,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 )
	}

	owner:LagCompensation( false )

	local ent = tr.Entity
	if IsValid( ent ) then
		if ent:IsPlayer() then
			if strong then
				self:EmitSound( self.SoundHitSecondary )
			else
				self:EmitSound( self.SoundHitPrimary )
			end

			if ent:SCPTeam() != TEAM_SCP and ent:SCPTeam() != TEAM_SPEC then
				local dmginfo = DamageInfo()

				dmginfo:SetAttacker( owner )
				dmginfo:SetDamageType( DMG_SLASH )

				local dmg = ( strong and math.random( 50, 80 ) or math.random( 20, 40 ) ) * self.DamageMult
				dmginfo:SetDamage( dmg )

				ent:TakeDamageInfo( dmginfo )

				if self.LifeSteal > 0 then
					owner:AddHealth( math.ceil( dmg * self.LifeSteal ) )
				end

			end
		else
			self:EmitSound( self.SoundHitWall )
			self:SCPDamageEvent( ent, strong and 100 or 50 )
		end
	elseif tr.Hit then
		self:EmitSound( self.SoundHitWall )
	else
		self:EmitSound( self.SoundMiss )
	end
end

if SERVER then
	hook.Add( "EntityTakeDamage", "SLCSCP0492Debuff", function( target, info )
		if IsValid( target ) and target:IsPlayer() and target:SCPClass() == CLASSES.SCP0492 then
			local shouldScale = true
			local wep = target:GetWeapon( "weapon_scp_0492" )
			if IsValid( wep ) then
				local SCP049 = wep:GetSCP049()
				if IsValid( SCP049 ) and SCP049:SCPClass() == CLASSES.SCP049 then
					if target:GetPos():DistToSqr( SCP049:GetPos() ) <= 4000000 then
						shouldScale = false
					end
				end
			end

			if shouldScale then
				info:ScaleDamage( 3 )
			end
		end
	end )

	/*hook.Add( "DoPlayerDeath", "SCP0492Kill", function( ply, attacker, info )
		if attacker:IsPlayer() and attacker:SCPClass() == CLASSES.SCP0492 then
		 	AddRoundStat( "0492" )
		end
	end )*/
end

function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	local shouldDraw = true
	local owner = self:GetOwner()
	local SCP049 = self:GetSCP049()
	if IsValid( SCP049 ) and SCP049:SCPClass() == CLASSES.SCP049 then
		if owner:GetPos():DistToSqr( SCP049:GetPos() ) <= 4000000 then
			shouldDraw = false
		end
	end

	if shouldDraw then
		draw.Text{
			text = self.Lang.too_far,
			pos = { ScrW() * 0.5, ScrH() * 0.98 },
			color = Color( 255, 0, 0, 255 ),
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	/*draw.Text{
		text = "Time: "..string.format( "%.3f", math.max( self.NextIdle - CurTime(), 0 ) ),
		pos = { 10, 10 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
	}

	draw.Text{
		text = self.AT,
		pos = { 10, 30 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
	}

		draw.Text{
		text = "Attack in: "..string.format( "%.3f", math.max( self.NAttack - CurTime(), 0 ) ),
		pos = { 10, 50 },
		color = Color( 255, 255, 255, 100 ),
		font = "SCPHUDVSmall",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
	}*/
end