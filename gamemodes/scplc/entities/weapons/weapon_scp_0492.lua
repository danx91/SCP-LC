SWEP.Base 				= "weapon_scp_base"
SWEP.PrintName			= "SCP-049-2"

SWEP.ViewModel 			= "models/weapons/v_zombiearms.mdl"
//SWEP.ViewModel 			= "models/player/alski/scp049-2classdarms.mdl"
SWEP.ShouldDrawViewModel= true

SWEP.HoldType 			= "knife"

SWEP.PrimarySpeed 		= 1.6
SWEP.AttackDelay 		= 0.1

SWEP.SecondarySpeed 	= 0.9
SWEP.StrongDelay 		= 0.8

SWEP.SoundMiss 			= "npc/zombie/claw_miss1.wav"
SWEP.SoundHitWall		= "npc/zombie/claw_strike1.wav"
SWEP.SoundHitPrimary	= "npc/zombie/claw_strike2.wav"
SWEP.SoundHitSecondary	= "npc/zombie/claw_strike3.wav"

function SWEP:SetupDataTables()
	self:AddNetworkVar( "SCP049", "Entity" )
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
function SWEP:Think()
	self:SwingThink()

	if self.NextIdle < CurTime() then
		local vm = self:GetOwner():GetViewModel()
		local seq, time = vm:LookupSequence( "ACT_VM_IDLE" )

		self.NextIdle = CurTime() + time
		vm:SendViewModelMatchingSequence( seq )
	end
end

local paths = {
	[2] = {
		Vector( 0, 8, -7 ),
		Vector( 0, -8, 5 ),
		-20,
		20,
	},
	[3] = {
		Vector( 0, -8, -7 ),
		Vector( 0, 8, 5 ),
		20,
		-20,
	},
	[4] = {
		Vector( 0, 2, 10 ),
		Vector( 0, -2, -15 ),
		0,
		0,
	},
}

local mins, maxs = Vector( -1, -1, -1 ), Vector( 1, 1, 1 )
local mins_str, maxs_str = Vector( -2, -2, -2 ), Vector( 2, 2, 2 )

SWEP.DamageMult = 1
SWEP.LifeSteal = 0

function SWEP:DoAttack( strong )
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	local seq, speed

	if strong then
		seq = vm:SelectWeightedSequence( ACT_VM_SECONDARYATTACK )
		speed = self.SecondarySpeed

		owner:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
	else
		seq = self.LastSeq == 2 and 3 or 2
		speed = self.PrimarySpeed

		owner:SetAnimation( PLAYER_ATTACK1 )
	end

	local dur = vm:SequenceDuration( seq ) / speed

	self.LastSeq = seq
	self.NAttack = self.NAttack + dur
	self.NextIdle = CurTime() + dur

	//vm:ResetSequenceInfo()
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( speed )

	//if !SERVER then return end

	local ent_filter = {}
	local path = paths[seq]
	self:SwingAttack( {
		path_start = path[1],
		path_end = path[2],
		fov_start = path[3],
		fov_end = path[4],
		delay = strong and 0.6 or 0.3,
		duration = 0.3,
		num = 8,
		dist_start = 70,
		dist_end = 50,
		mins = strong and mins_str or mins,
		maxs = strong and maxs_str or maxs,
		on_start = function()
			self:EmitSound( self.SoundMiss )
		end,
		callback = function( tr, num )
			if !self:CheckOwner() then return end

			local ent = tr.Entity
			if IsValid( ent ) then
				if ent_filter[ent] then return end
				if ent:IsPlayer() then
					ent_filter[ent] = true

					if strong then
						self:EmitSound( self.SoundHitSecondary )
					else
						self:EmitSound( self.SoundHitPrimary )
					end

					if CLIENT or !self:CanTargetPlayer( ent ) then return end
					local dmginfo = DamageInfo()

					dmginfo:SetAttacker( owner )
					dmginfo:SetDamageType( DMG_SLASH )

					local dmg = ( strong and math.random( 40, 50 ) or math.random( 15, 25 ) ) * self.DamageMult
					dmginfo:SetDamage( dmg )

					SuppressHostEvents( NULL )
					ent:TakeDamageInfo( dmginfo )
					SuppressHostEvents( owner )

					if self.LifeSteal > 0 then
						owner:AddHealth( math.ceil( dmg * self.LifeSteal ) )
					end

					return strong
				else
					self:EmitSound( self.SoundHitWall )
					
					if SERVER then
						SuppressHostEvents( NULL )
						self:SCPDamageEvent( ent, strong and 100 or 50 )
						SuppressHostEvents( owner )
					end

					return true
				end
			elseif tr.Hit then
				self:EmitSound( self.SoundHitWall )
				//local vm = self:GetOwner():GetViewModel()
				//vm:ResetSequence( vm:LookupSequence( "idle" ) )
				return true, num < 4 and {
					distance = 60,
					bounds = 1.5,
				}
			end
		end
	} )
end

if SERVER then
	SCPHook( "SCP0492", "EntityTakeDamage", function( target, info )
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

	SCPHook( "SCP0492", "SLCButtonOverloaded", function( ply, btn, adv )
		if ply:SCPClass() == CLASSES.SCP0492 then
			ply:SetSCPDisableOverload( true )
		end
	end )

	/*SCPHook( "SCP0492", "DoPlayerDeath", function( ply, attacker, info )
		if attacker:IsPlayer() and attacker:SCPClass() == CLASSES.SCP0492 then
		 	AddRoundStat( "0492" )
		end
	end )*/
end

local color_red = Color( 255, 0, 0 )
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
			color = color_red,
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