SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-058"

SWEP.HoldType		= "melee"

SWEP.ViewModel		= "models/player/alski/scp/SCP_058VM.mdl"

SWEP.DisableDamageEvent = true
SWEP.ShouldDrawViewModel = true
SWEP.ScoreOnDamage = true

SWEP.AttackCooldown = 2.5
SWEP.AttackSlowTime = 1.5

SWEP.StackGainRate = 15
SWEP.ShotCooldown = 4
SWEP.ShotDamage = 35
SWEP.ShotSplashRadius = 96
SWEP.ShotMinDistance = 200 ^ 2

SWEP.ExplosionRadius = 600
SWEP.ExplosionDamage = 200
SWEP.ExplosionSlowTime = 3

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
	
	self:AddNetworkVar( "Explode", "Bool" )
	self:AddNetworkVar( "ShotStacks", "Int" )
	self:AddNetworkVar( "NextStack", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP058" )
	self:InitializeHUD()
end

SWEP.AttackSlow = 0
function SWEP:Think()
	self:SwingThink()
	
	if !SERVER then return end

	self:PlayerFreeze()

	local ct = CurTime()
	local owner = self:GetOwner()

	if self.AttackSlow != 0 and self.AttackSlow < ct then
		self.AttackSlow = 0
		owner:PopSpeed( "SLC_SCP058AttackSlow", true )
	end

	local max_stacks = self:GetUpgradeMod( "stacks", 4 )
	local stacks = self:GetShotStacks()

	if stacks < max_stacks then
		local ns = self:GetNextStack()

		if ns == 0 then
			self:SetNextStack( ct + self.StackGainRate * self:GetUpgradeMod( "regen_rate", 1 ) )
		elseif ns <= ct then
			self:SetNextStack( 0 )
			self:SetShotStacks( stacks + 1 )
		end
	elseif self:GetNextStack() != 0 then
		self:SetNextStack( 0 )
	end
end

local path_start = Vector( 0, 0, 10 )
local path_end = Vector( 10, 0, -2 )
local mins = Vector( -2, -5, -2 )
local maxs = Vector( 2, 5, 2 )

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	
	self:SetNextPrimaryFire( ct + self.AttackCooldown - self:GetUpgradeMod( "prim_cd", 0 ) )

	owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )

	local vm = owner:GetViewModel()
	if IsValid( vm ) then
		local speed = 1.2
		local seq = vm:LookupSequence( "attack1" )

		vm:ResetSequenceInfo()
		vm:SendViewModelMatchingSequence( seq )
		vm:SetPlaybackRate( speed )
	end

	self:EmitSound( "npc/zombie/claw_miss1.wav" )
	
	self:SwingAttack( {
		path_start = path_start,
		path_end = path_end,
		duration = 0.6,
		num = 6,
		dist_start = 20,
		dist_end = 60,
		mins = mins,
		maxs = maxs,
		callback = function( trace )
			local ent = trace.Entity
			if !trace.Hit or !IsValid( ent ) then return end
			if SERVER and ent:IsPlayer() and self:CanTargetPlayer( ent ) then
				owner:PushSpeed( 0.75, 0.75, -1, "SLC_SCP058AttackSlow", 1 )
				self.AttackSlow = ct + self.AttackSlowTime

				SuppressHostEvents( NULL )
				ent:TakeDamage( 20 + self:GetUpgradeMod( "prim_dmg", 0 ), owner, owner )
				SuppressHostEvents( owner )

				if self:GetUpgradeMod( "primary_poison" ) == true then
					local pdmg = self:GetUpgradeMod( "pp_dmg", 0 )

					if self:GetUpgradeMod( "pp_insta2" ) == true and !ent:HasEffect( "poison" ) then
						ent:ApplyEffect( "poison", 2, owner, pdmg )
					else
						ent:ApplyEffect( "poison", owner, pdmg )
					end
				end
			elseif SERVER then
				SuppressHostEvents( NULL )
				self:SCPDamageEvent( ent, 50 )
				SuppressHostEvents( owner )
			end

			self:EmitSound( "npc/zombie/claw_strike3.wav" )
			return true
		end
	} )
end

local shot_trace = {}
shot_trace.mask = MASK_SHOT
shot_trace.output = shot_trace

local projectile_offset = Vector( 0, 0, 45 )
function SWEP:SecondaryAttack()
	if ROUND.preparing or ROUND.post then return end

	if self:GetShotStacks() < 1 then return end
	self:SetShotStacks( self:GetShotStacks() - 1 )

	local ct = CurTime()
	local owner = self:GetOwner()

	local mode = self:GetUpgradeMod( "shot_mode" )
	if mode == 2 then
		self:SetNextSecondaryFire( ct + 0.25 )
	else
		self:SetNextSecondaryFire( ct + self.ShotCooldown + self:GetUpgradeMod( "shot_cd", 0 ) )
	end

	owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )

	if SERVER then
		owner:PushSpeed( 0.75, 0.75, -1, "SLC_SCP058AttackSlow", 1 )
		self.AttackSlow = ct + self.AttackSlowTime

		local owner_pos = owner:GetPos()

		local projectile = ents.Create( "slc_058_projectile" )
		projectile:SetPos( owner_pos + projectile_offset )
		projectile:SetAngles( owner:GetAimVector():Angle() )
		projectile:SetOwner( owner )

		projectile:SetSpeed( 16 * self:GetUpgradeMod( "shot_speed", 1 ) )
		projectile:SetSize( self:GetUpgradeMod( "shot_size", 1 ) )

		local poison = self:GetUpgradeMod( "shot_poison" )
		local pdmg = self:GetUpgradeMod( "sp_dmg", 0 )

		if mode == 1 then
			projectile:SetEffectName( nil )
		elseif poison then
			projectile:SetEffectName( "SLCPBSplash" )
		end

		projectile.OnHit = function( proj, trace )
			if !IsValid( self ) or !self:CheckOwner() then return end

			if !mode then
				local damage = self.ShotDamage * self:GetUpgradeMod( "shot_damage", 1 )

				if trace.HitPos:DistToSqr( owner_pos ) < self.ShotMinDistance then
					damage = damage * 0.4
				end

				local direct
				if IsValid( trace.Entity ) and trace.Entity:IsPlayer() and self:CanTargetPlayer( trace.Entity ) then
					direct = trace.Entity

					direct:TakeDamage( damage, owner, owner )

					if poison and !direct:CheckHazmat( 100 ) then
						direct:ApplyEffect( "poison", owner, pdmg )
					end
				end

				local radius = ( self.ShotSplashRadius * proj:GetSize() ) ^ 2
				local hit_pos = trace.HitPos + trace.HitNormal * 10

				shot_trace.start = trace.HitPos
				shot_trace.filter = direct

				for i, v in ipairs( player.GetAll() ) do
					local pos = v:GetPos()
					if pos:DistToSqr( hit_pos ) > radius or !self:CanTargetPlayer( v ) then continue end

					shot_trace.endpos = pos + v:OBBCenter()
					util.TraceLine( shot_trace )

					if shot_trace.Entity != v or v == direct then continue end

					v:TakeDamage( damage * 0.75, owner, owner )

					if poison and !v:CheckHazmat( 75 ) then
						v:ApplyEffect( "poison", owner, pdmg )
					end
				end
			elseif mode == 1 then
				local cloud = ents.Create( "slc_poison_cloud" )
				if IsValid( cloud ) then
					cloud:SetPos( trace.HitPos + trace.HitNormal * 45 * proj:GetSize() )
					cloud:SetOwner( owner )
					cloud:SetSize( proj:GetSize() )
					cloud:SetPoisonDamage( pdmg )
					cloud:SetDamage( self:GetUpgradeMod( "cloud_damage" ) )
					cloud:SetDuration( 20 * self:GetUpgradeMod( "cloud_dur", 1 ) + 2 )
					cloud:Spawn()
				end
			elseif mode == 2 then
				local ent = trace.Entity

				if !IsValid( ent ) or !ent:IsPlayer() or !self:CanTargetPlayer( ent ) or ent:CheckHazmat( 60 ) then return end
				if trace.HitPos:DistToSqr( owner_pos ) < self.ShotMinDistance and math.random( 3 ) != 1 then return end

				ent:ApplyEffect( "poison", owner, pdmg )
			end
		end

		projectile:Spawn()
	end
end

local explosion_trace = {}
explosion_trace.mask = MASK_SOLID_BRUSHONLY
explosion_trace.output = explosion_trace

function SWEP:SpecialAttack()
	if CLIENT or ROUND.post or !self:GetExplode() then return end

	self:SetExplode( false )

	local owner = self:GetOwner()
	local owner_pos = owner:GetPos()
	local radius_mul = self:GetUpgradeMod( "explosion_radius", 1 )
	local radius = self.ExplosionRadius * radius_mul
	local use_poison = self:GetUpgradeMod( "explosion_poison" )

	local eff = EffectData()

	eff:SetOrigin( owner_pos )
	eff:SetRadius( radius_mul )

	util.Effect( "slc_058_explosion", eff, true, true )
	owner:EmitSound( "SCP058.Explosion" )

	local cd = CurTime() + self.ExplosionSlowTime
	self:SetNextPrimaryFire( cd )
	self:SetNextSecondaryFire( cd )

	owner:PushSpeed( 0.3, 0.3, -1, "SLC_SCP058AttackSlow", 1 )
	self.AttackSlow = cd

	explosion_trace.start = owner_pos
	explosion_trace.filter = owner

	for i, v in ipairs( player.GetAll() ) do
		if v == owner or !self:CanTargetPlayer( v ) then continue end

		local target_pos = v:GetPos()
		local dist = target_pos:Distance( owner_pos )
		if dist >= radius then continue end

		explosion_trace.endpos = target_pos + v:OBBCenter()
		util.TraceLine( explosion_trace )

		if explosion_trace.Hit then continue end

		local dmg = DamageInfo()

		dmg:SetAttacker( owner )
		dmg:SetDamageType( DMG_BLAST )
		dmg:SetDamage( self.ExplosionDamage * ( 1 - dist / radius ) )

		v:TakeDamageInfo( dmg )

		if use_poison and !v:CheckHazmat( 200 ) then
			v:ApplyEffect( "poison", 2, owner, 0 )
		end
	end
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "058" )
end

function SWEP:OnUpgradeBought( name, active, group )
	if CLIENT and group then
		local skill = self.HUDObject:GetSkill( group )
		if skill then
			skill:SetMaterialOverride( Material( active, "smooth" ) )
		end
	end

	if name == "shot31" then
		self.Secondary.Automatic = true
	elseif name == "exp1" then
		if SERVER then
			self.ExplosionThreshold = math.max( math.floor( self:GetOwner():Health() / 1000 ), 1 )
		end
	end
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP058") TransmitSCPHooks()
SCPHook( "SCP058", "SLCMovementAnimSpeed", function( ply, vel, speed, len, movement )
	if ply:SCPClass() == CLASSES.SCP058 then
		local n = len / 56

		if n < 1.5 then
			n = 1.5
		end

		return 3, true
	end
end )

SCPHook( "SCP058", "PostEntityTakeDamage", function( ent, dmg, took )
	if !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP058 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) or !wep.ExplosionThreshold then return end

	local threshold_id = math.floor( ent:Health() / 1000 )
	if threshold_id < 0 then return end

	if threshold_id < wep.ExplosionThreshold then
		wep.ExplosionThreshold = threshold_id
		wep:SetExplode( true )
	end
end )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.attack = GetMaterial( "slc/hud/upgrades/scp/058/poison_attack.png", "smooth" )
	icons.poison_shot = GetMaterial( "slc/hud/upgrades/scp/058/poison_shot.png", "smooth" )
	icons.shot = GetMaterial( "slc/hud/upgrades/scp/058/shot.png", "smooth" )
	icons.cloud = GetMaterial( "slc/hud/upgrades/scp/058/cloud.png", "smooth" )
	icons.multishot = GetMaterial( "slc/hud/upgrades/scp/058/multi_shot.png", "smooth" )
	icons.explosion1 = GetMaterial( "slc/hud/upgrades/scp/058/explosion1.png", "smooth" )
	icons.explosion2 = GetMaterial( "slc/hud/upgrades/scp/058/explosion2.png", "smooth" )
end

DefineUpgradeSystem( "scp058", {
	grid_x = 5,
	grid_y = 4,
	upgrades = {
		{ name = "attack1", icon = icons.attack, cost = 1, req = {}, reqany = false,  pos = { 1, 1 },
			mod = { primary_poison = true }, active = false },
		{ name = "attack2", icon = icons.attack, cost = 2, req = { "attack1" }, reqany = false,  pos = { 1, 2 },
			mod = { prim_dmg = 10, pp_dmg = 0.25, prim_cd = 0.5 }, active = false },
		{ name = "attack3", icon = icons.attack, cost = 2, req = { "attack2" }, reqany = false,  pos = { 1, 3 },
			mod = { prim_dmg = 20, pp_dmg = 0.5, prim_cd = 1, pp_insta2 = true }, active = false },

		{ name = "shot", icon = icons.poison_shot, cost = 1, req = {}, reqany = false,  pos = { 3, 1 },
			mod = { shot_poison = true }, active = "slc/hud/scp/058/shot2.png", group = "shot" },

		{ name = "shot11", icon = icons.shot, cost = 2, req = { "shot" }, reqany = false, block = { "shot21", "shot31" },  pos = { 2, 2 },
			mod = { shot_damage = 1.4, shot_speed = 0.9, shot_size = 1.3, shot_cd = 1 }, active = false },
		{ name = "shot12", icon = icons.shot, cost = 2, req = { "shot11" }, reqany = false,  pos = { 2, 3 },
			mod = { shot_damage = 2, shot_speed = 0.75, shot_size = 1.75, shot_cd = 2 }, active = false },

		{ name = "shot21", icon = icons.cloud, cost = 2, req = { "shot" }, reqany = false, block = { "shot11", "shot31" },  pos = { 3, 2 },
			mod = { shot_mode = 1, cloud_damage = 5, sp_dmg = 0.75, shot_speed = 0.9, shot_size = 1.1, stacks = 3, shot_cd = 4, regen_rate = 1.11 }, active = "slc/hud/scp/058/shot3.png", group = "shot" },
		{ name = "shot22", icon = icons.cloud, cost = 2, req = { "shot21" }, reqany = false,  pos = { 3, 3 },
			mod = { cloud_damage = 10, cloud_dur = 1.5, sp_dmg = 1.5, shot_speed = 0.75, shot_size = 1.3, regen_rate = 1.33 }, active = false },

		{ name = "shot31", icon = icons.multishot, cost = 1, req = { "shot" }, reqany = false, block = { "shot11", "shot21" },  pos = { 4, 2 },
			mod = { shot_mode = 2, shot_speed = 1.1, shot_size = 0.85, stacks = 6, regen_rate = 0.66 }, active = "slc/hud/scp/058/shot4.png", group = "shot" },
		{ name = "shot32", icon = icons.multishot, cost = 2, req = { "shot31" }, reqany = false,  pos = { 4, 3 },
			mod = { shot_speed = 1.25, shot_size = 0.6, stacks = 8, regen_rate = 0.45 }, active = false },

		{ name = "exp1", icon = icons.explosion1, cost = 2, req = {}, reqany = false,  pos = { 5, 1 },
			mod = {}, active = true },
		{ name = "exp2", icon = icons.explosion2, cost = 2, req = { "exp1" }, reqany = false,  pos = { 5, 2 },
			mod = { explosion_poison = true, explosion_radius = 1.5 }, active = "slc/hud/scp/058/explosion2.png", group = "explosion" },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false,  pos = { 5, 4 }, mod = {}, active = false },
	},
	rewards = { --13/14 + 1 points -> ~60% = 10 (-1 base) = 9 points
		{ 100, 1 },
		{ 200, 1 },
		{ 300, 1 },
		{ 400, 1 },
		{ 500, 1 },
		{ 650, 1 },
		{ 800, 1 },
		{ 950, 1 },
		{ 1100, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP058", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "primary_attack" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/058/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "shot" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/058/shot1.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetActiveFunction( function( swep )
			return swep:GetShotStacks() > 0
		end )

	hud:AddSkill( "explosion" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/058/explosion1.png", "smooth" )
		:SetVisibleFunction( function( swep )
			return swep:HasUpgrade( "exp1" )
		end )
		:SetActiveFunction( "GetExplode" )
		:SetProgressFunction( function( swep )
			if swep:GetExplode() then return end

			local hp = swep:GetOwner():Health() / 1000
			if hp < 1 then return end

			return 1 - hp + math.floor( hp )
		end )

	hud:AddSkill( "shot_stacks" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/058/shot1.png", "smooth" )
		:SetCooldownFunction( "GetNextStack" )
		:SetTextFunction( "GetShotStacks" )

end

--[[-------------------------------------------------------------------------
Particles
---------------------------------------------------------------------------]]
PrecacheParticleSystem( "SLCBloodSplash" )
PrecacheParticleSystem( "SLCPBSplash" )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add{
	name = "SCP058.Explosion",
	volume = 1,
	level = 110,
	pitch = 110,
	sound = "scp_lc/scp/058/explode.wav",
	channel = CHAN_STATIC,
}