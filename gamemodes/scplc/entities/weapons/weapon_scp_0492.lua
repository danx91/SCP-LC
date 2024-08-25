SWEP.Base 				= "weapon_scp_base"
SWEP.PrintName			= "SCP-049-2"

SWEP.HoldType 			= "knife"

SWEP.ViewModel 			= "models/weapons/v_zombiearms.mdl"

SWEP.ShouldDrawViewModel = true
SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage = true

SWEP.SkillCooldowns = {
	light = 1.25,
	heavy = 4,
	rapid = 20,
	explode = 999,
	shot = 12
}

SWEP.LightAttackDamage = { 15, 25 }
SWEP.HeavyAttackDamage = { 40, 50 }
SWEP.RapidAttackDamage = { 15, 20 }

SWEP.ExplosionDamage = 125
SWEP.ExplosionRadius = 250
SWEP.ExplosionTime = 10
SWEP.ExplosionSpeed = 1.4

SWEP.ShotDamage = 25
SWEP.ShotRadius = 100 ^ 2

SWEP.Overloads = 1
SWEP.DamageMultiplier = 1
SWEP.LifeSteal = 0

local icon_overrides = {}

if CLIENT then
	icon_overrides[1] = { GetMaterial( "slc/hud/upgrades/scp/0492/light.png", "smooth" ), GetMaterial( "slc/hud/upgrades/scp/0492/heavy.png", "smooth" ) }
	icon_overrides[2] = { GetMaterial( "slc/hud/upgrades/scp/0492/light.png", "smooth" ), GetMaterial( "slc/hud/upgrades/scp/0492/rapid.png", "smooth" ) }
	icon_overrides[3] = { GetMaterial( "slc/hud/upgrades/scp/0492/heavy.png", "smooth" ), GetMaterial( "slc/hud/upgrades/scp/0492/explode.png", "smooth" ) }
	icon_overrides[4] = { GetMaterial( "slc/hud/upgrades/scp/0492/heavy.png", "smooth" ), GetMaterial( "slc/hud/upgrades/scp/0492/shot.png", "smooth" ) }
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
	
	self:AddNetworkVar( "SCP049", "Entity" )
	self:AddNetworkVar( "SCP049Position", "Vector" )
	self:AddNetworkVar( "ZombieType", "Int" )
	self:AddNetworkVar( "Protection", "Float" )
	self:AddNetworkVar( "Boost", "Float" )
	self:AddNetworkVar( "BoostDuration", "Float" )

	self:AddNetworkVar( "Explode", "Float" )

	self:NetworkVarNotify( "ZombieType", function( ent, name, old, new )
		if CLIENT then return end

		local zombie = SCP049_ZOMBIE_TYPES[new]
		if !zombie then return end

		ent.ZombieData = zombie
	end )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP0492" )

	if CLIENT then
		local zombie_type = self:GetZombieType()
		local zombie = SCP049_ZOMBIE_TYPES[zombie_type]
		if !zombie then return end

		self.ZombieData = zombie

		self:InitializeHUD( "SCP0492_"..zombie.name )

		local overrides = icon_overrides[zombie_type]
		if overrides then
			self.UpgradeIconsOverride = {
				primary1 = overrides[1],
				primary2 = overrides[1],
				secondary1 = overrides[2],
				secondary2 = overrides[2],
			}
		end
	end
end

SWEP.NextIdle = 0
SWEP.Next049Update = 0
function SWEP:Think()
	self:SwingThink()

	local ct = CurTime()
	if self.NextIdle < ct then
		local vm = self:GetOwner():GetViewModel()
		local seq, time = vm:LookupSequence( "ACT_VM_IDLE" )

		self.NextIdle = ct + time
		vm:SendViewModelMatchingSequence( seq )
	end

	if CLIENT then return end
	
	if self.Next049Update <= ct and self:GetProtection() < ct then
		self.Next049Update = ct + 1

		local scp = self:GetSCP049()
		if !IsValid( scp ) then return end

		if !scp:Alive() or scp:SCPTeam() != TEAM_SCP then
			self:SetSCP049( NULL )
			return
		end

		self:SetSCP049Position( scp:GetPos() )
		self:RemoveAllDecals()
	end

	local explode = self:GetExplode()
	if explode > 0 and explode < ct then
		self:SetExplode( 0 )
		self:Explode()
	end
end

SWEP.NAttack = 0
function SWEP:PrimaryAttack()
	if !self.ZombieData or ROUND.preparing or !IsFirstTimePredicted() then return end

	local ct = CurTime()
	local primary = self.ZombieData.primary
	local cd = self.SkillCooldowns[primary] or 5
	self:SetNextPrimaryFire( ct + cd * self:GetUpgradeMod( "primary_cd", 1 ) )

	local secondary_cd = ct + self:DoAttack( primary == "heavy", self:GetUpgradeMod( "primary_dmg", 1 ) )

	if self:GetNextSecondaryFire() < secondary_cd then
		self:SetNextSecondaryFire( secondary_cd )
	end
end

function SWEP:SecondaryAttack()
	if !self.ZombieData or ROUND.preparing or !IsFirstTimePredicted() then return end

	local ct = CurTime()
	local secondary = self.ZombieData.secondary
	
	if secondary == "heavy" then
		local primary_cd = ct + self:DoAttack( true, self:GetUpgradeMod( "secondary_dmg", 1 ) )
		if self:GetNextPrimaryFire() < primary_cd then
			self:SetNextPrimaryFire( primary_cd )
		end
	elseif secondary == "rapid" then
		local primary_cd = ct + self:DoRapidAttack()
		if self:GetNextPrimaryFire() < primary_cd then
			self:SetNextPrimaryFire( primary_cd )
		end
	elseif secondary == "explode" then
		self:TriggerExplosion()
	elseif secondary == "shot" then
		self:Shoot()
	end

	local cd = self.SkillCooldowns[secondary] or 5
	self:SetNextSecondaryFire( ct + cd * self:GetUpgradeMod( "secondary_cd", 1 ) )
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

function SWEP:DoAttack( strong, mod )
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	local seq, speed

	if strong then
		seq = vm:SelectWeightedSequence( ACT_VM_SECONDARYATTACK )
		speed = 0.9

		owner:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
	else
		seq = self.LastSeq == 2 and 3 or 2
		speed = 1.6

		owner:SetAnimation( PLAYER_ATTACK1 )
	end

	local dur = vm:SequenceDuration( seq ) / speed

	self.LastSeq = seq
	self.NAttack = self.NAttack + dur
	self.NextIdle = CurTime() + dur

	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( speed )

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
			self:EmitSound( "SCP0492.Miss" )
		end,
		callback = function( tr, num )
			if !self:CheckOwner() then return end

			local ent = tr.Entity
			if IsValid( ent ) then
				if ent_filter[ent] then return end

				if !ent:IsPlayer() then
					self:EmitSound( "SCP0492.HitWall" )
					
					if SERVER then
						SuppressHostEvents( NULL )
						self:SCPDamageEvent( ent, strong and 100 or 50 )
						SuppressHostEvents( owner )
					end

					return true
				end

				ent_filter[ent] = true

				self:EmitSound( strong and "SCP0492.HitStrong" or "SCP0492.HitWeak" )

				if CLIENT or !self:CanTargetPlayer( ent ) then return end
				local dmginfo = DamageInfo()

				dmginfo:SetAttacker( owner )
				dmginfo:SetDamageType( DMG_SLASH )

				local dmg_tab = strong and self.HeavyAttackDamage or self.LightAttackDamage
				local dmg = math.random( dmg_tab[1], dmg_tab[2] ) * ( self.DamageMultiplier + mod - 1 )
				dmginfo:SetDamage( dmg )

				SuppressHostEvents( NULL )
				ent:TakeDamageInfo( dmginfo )
				SuppressHostEvents( owner )

				if self.LifeSteal > 0 then
					owner:AddHealth( math.ceil( dmg * self.LifeSteal ) )
				end

				return strong
			elseif tr.Hit then
				self:EmitSound( "SCP0492.HitWall" )

				return true, num < 4 and {
					distance = 60,
					bounds = 1.5,
				}
			end
		end
	} )

	return dur
end

function SWEP:DoRapidAttack()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	
	local speed = 4
	local attacks = 8
	local dur = vm:SequenceDuration( 2 ) / speed

	if CLIENT then
		return dur * attacks + 0.5
	end

	self:DoFastAttack( dur, speed, 0 )
	owner:AddTimer( "SCP0492_Rapid", dur, attacks - 1, function( this, n )
		self:DoFastAttack( dur, speed, n )
	end )

	return dur * attacks + 0.5
end

local fast_attack_trace = {}
fast_attack_trace.mins = Vector( -2, -2, -2 )
fast_attack_trace.maxs = Vector( 2, 2, 2 )
fast_attack_trace.mask = MASK_SHOT
fast_attack_trace.output = fast_attack_trace

function SWEP:DoFastAttack( dur, speed, n )
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	owner:SetAnimation( PLAYER_ATTACK1 )

	vm:ResetSequenceInfo()
	vm:SendViewModelMatchingSequence( n % 2 == 0 and 2 or 3 )
	vm:SetPlaybackRate( speed )

	self.NextIdle = CurTime() + dur

	local start = owner:GetShootPos()
	fast_attack_trace.start = start
	fast_attack_trace.endpos = start + owner:GetAimVector() * 60
	fast_attack_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceHull( fast_attack_trace )
	owner:LagCompensation( false )

	if !fast_attack_trace.Hit then
		owner:EmitSound( "SCP0492.Miss" )
		return
	end

	local ent = fast_attack_trace.Entity
	if !IsValid( ent ) or !ent:IsPlayer() then
		owner:EmitSound( "SCP0492.HitWall" )
		return
	end

	owner:EmitSound( "SCP0492.HitWeak" )

	if !self:CanTargetPlayer( ent ) then return end

	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( owner )
	dmginfo:SetDamageType( DMG_SLASH )

	local dmg = math.random( self.RapidAttackDamage[1], self.RapidAttackDamage[2] ) * ( self.DamageMultiplier + self:GetUpgradeMod( "secondary_dmg", 1 ) - 1 )
	dmginfo:SetDamage( dmg )

	ent:TakeDamageInfo( dmginfo )

	if self.LifeSteal > 0 then
		owner:AddHealth( math.ceil( dmg * self.LifeSteal ) )
	end
end

function SWEP:Shoot()
	if CLIENT then return end

	local owner = self:GetOwner()
	local projectile = ents.Create( "slc_0492_projectile" )
	projectile:SetPos( owner:GetShootPos() )
	projectile:SetAngles( owner:GetAimVector():Angle() )
	projectile:SetOwner( owner )
	projectile:Spawn()

	projectile.OnHit = function( this, tr )
		if !IsValid( self ) or !self:CheckOwner() then return end

		local pos = tr.HitPos
		for i, v in ipairs( player.GetAll() ) do
			if v:GetPos():DistToSqr( pos ) > self.ShotRadius or !self:CanTargetPlayer( v ) then continue end

			v:TakeDamage( self.ShotDamage * self:GetUpgradeMod( "secondary_dmg", 1 ), owner, owner )
		end
	end
end

function SWEP:TriggerExplosion()
	local owner = self:GetOwner()
	if owner:Health() > 50 then return end

	local ct = CurTime()
	self:SetNextPrimaryFire( ct + 999 )
	self:SetNextSecondaryFire( ct + 999 )
	self:SetExplode( ct + self.ExplosionTime )

	if SERVER then
		owner:PushSpeed( self.ExplosionSpeed, self.ExplosionSpeed, -1, "SLC_SCP0492Explosion" )
	end
end

local explosion_trace = {}
explosion_trace.mask = MASK_SOLID_BRUSHONLY
explosion_trace.output = explosion_trace
function SWEP:Explode()
	local owner = self:GetOwner()
	local pos = owner:GetPos()

	local eff = EffectData()

	eff:SetOrigin( pos )
	eff:SetRadius( 1 )

	util.Effect( "slc_0492_explosion", eff, true, true )
	owner:EmitSound( "SCP058.Explosion" )

	explosion_trace.filter = owner
	explosion_trace.start = pos

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) then continue end

		local target_pos = v:GetPos()
		local dist = target_pos:Distance( pos ) / self.ExplosionRadius
		if dist > 1 then continue end

		explosion_trace.endpos = target_pos
		util.TraceLine( explosion_trace )

		if explosion_trace.Hit then continue end

		local dmg = DamageInfo()
		dmg:SetDamageType( DMG_BLAST )
		dmg:SetDamage( self.ExplosionDamage * self:GetUpgradeMod( "secondary_dmg", 1 ) * ( 1 - dist ) )
		dmg:SetAttacker( owner )

		v:TakeDamageInfo( dmg )
	end

	local dmg = DamageInfo()
	dmg:SetDamageType( DMG_DIRECT )
	dmg:SetDamage( owner:Health() )

	if IsValid( self.LastAttacker ) then
		dmg:SetAttacker( self.LastAttacker )
	end

	owner:TakeDamageInfo( dmg )
end

function SWEP:EnableProtection()
	self:SetProtection( CurTime() + 1 )
end

function SWEP:EnableBoost( duration, power )
	self:SetBoost( CurTime() + duration )
	self:SetBoostDuration( duration )

	power = power * self:GetUpgradeMod( "buff_power", 1 )

	local owner = self:GetOwner()
	owner:PushSpeed( power, power, -1, "SLC_SCP0492Boost", 1 )
	owner:AddTimer( "SCP0492Boost", duration, 1, function()
		owner:PopSpeed( "SLC_SCP0492Boost" )
	end )
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "0492" )
end

function SWEP:OnUpgradeBought( name, active, group )
	if name == "overload" then
		self.Overloads = self.Overloads + self:GetUpgradeMod( "overloads" )
		self:GetOwner():SetSCPDisableOverload( false )
	end
end

local indicator = Material( "slc/hud/scp/0492/indicator.png", "smooth" )
local text_color = Color( 255, 25, 25 )
function SWEP:DrawSCPHUD()
	if self:GetProtection() >= CurTime() then return end
	
	local scp = self:GetSCP049()
	if !IsValid( scp ) or !scp:Alive() or scp:SCPTeam() != TEAM_SCP then return end

	local scp_pos = self:GetSCP049Position()
	local our_pos = self:GetOwner():GetPos()
	local dist = math.Round( our_pos:Distance( scp_pos ) * 0.01905 )

	scp_pos.z = 0
	our_pos.z = 0

	local w, h = ScrW(), ScrH()
	local radius = h * 0.45
	local text_radius = h * 0.4
	local ang = ( scp_pos - our_pos ):Angle().y
	local theta_deg = ( LocalPlayer():EyeAngles().y - ang - 90 ) % 360
	local theta = math.rad( theta_deg )

	local sin = math.sin( theta )
	local cos = math.cos( theta )

	surface.SetDrawColor( 225, 25, 25, 200 )
	surface.SetMaterial( indicator )

	local size = w * 0.075
	surface.DrawTexturedRectRotated( w * 0.5 + radius * cos, h * 0.5 + radius * sin, 2 * size, size, -theta_deg - 90 )

	local _, th = draw.SimpleText( "SCP-049", "SCPHUDSmall", w * 0.5 + text_radius * cos, h * 0.5 + text_radius * sin, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( dist.."m", "SCPHUDSmall", w * 0.5 + text_radius * cos, h * 0.5 + text_radius * sin + th, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

//Well, this was experimental version that used ellispe instead of circle, but it is kinda confusing. Uncomment if you want
/*local indicator = Material( "slc/hud/scp/0492/indicator.png", "smooth" )
function SWEP:DrawSCPHUD()
	if self:GetProtection() >= CurTime() then return end

	local scp = self:GetSCP049()
	if !IsValid( scp ) or !scp:Alive() or scp:SCPTeam() != TEAM_SCP then return end

	local scp_pos = self:GetSCP049Position()
	local our_pos = self:GetOwner():GetPos()

	scp_pos.z = 0
	our_pos.z = 0

	local w, h = ScrW(), ScrH()
	local a, b = w * 0.45, h * 0.45
	local ang = ( scp_pos - our_pos ):Angle().y
	local theta = math.rad( ( LocalPlayer():EyeAngles().y - ang - 90 ) % 360 )

	local sin = math.sin( theta )
	local cos = math.cos( theta )

	local radius = a * b / math.sqrt( a * a * sin * sin + b * b * cos * cos )
	local x = radius * cos
	local y = radius * sin

	surface.SetDrawColor( 225, 25, 25, 200 )
	surface.SetMaterial( indicator )

	local rot = math.atan( -b * b * x / ( a * a * y ) )
	if theta > 0 and theta < math.pi then
		rot = rot - math.pi
	end

	local ex, ey = w * 0.5 + x, h * 0.5 + y
	local size = w * 0.075
	surface.DrawTexturedRectRotated( ex, ey, 2 * size, size, -math.deg( rot ) )

	draw.SimpleText( "SCP-049", "SCPHUDSmall", ex, ey, Color( 255, 75, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end*/

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP0492") TransmitSCPHooks()
SCPHook( "SCP0492", "EntityTakeDamage", function( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP0492 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local ct = CurTime()
	if wep:GetExplode() >= ct then return true end
	if wep:GetProtection() < ct then return end

	dmg:ScaleDamage( 0.5 - wep:GetUpgradeMod( "prot_power", 0 ) )
end )

SCPHook( "SCP0492", "SLCPostScaleDamage", function( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP0492 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local ct = CurTime()
	if wep:GetExplode() >= ct then return true end
	if wep.ZombieData.secondary != "explode" or dmg:GetDamage() < ent:Health() then return end

	local attacker = dmg:GetAttacker()
	if IsValid( attacker ) and attacker:IsPlayer() and attacker != ent then
		wep.LastAttacker = attacker
	end

	wep:TriggerExplosion()

	return true
end )

SCPHook( "SCP0492", "PostEntityTakeDamage", function( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP0492 then return end

	local attacker = dmg:GetAttacker()
	if !IsValid( attacker ) or !attacker:IsPlayer() or attacker == ent then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetExplode() >= CurTime() then return end

	wep.LastAttacker = attacker
end )

SCPHook( "SCP0492", "SLCButtonOverloaded", function( ply, btn, adv )
	if ply:SCPClass() != CLASSES.SCP0492 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end

	wep.Overloads = wep.Overloads - 1

	if wep.Overloads <= 0 then
		ply:SetSCPDisableOverload( true )
	end
end )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.tmp = GetMaterial( "slc/hud/upgrades/scp/0492/light.png", "smooth" )
	icons.prot = GetMaterial( "slc/hud/upgrades/scp/0492/prot_buff.png", "smooth" )
	icons.overload = GetMaterial( "slc/hud/scp/door_overload.png", "smooth" )
end

DefineUpgradeSystem( "scp0492", {
	grid_x = 3,
	grid_y = 3,
	upgrades = {
		{ name = "primary1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { primary_cd = 0.8 }, icon = icons.tmp, active = false },
		{ name = "primary2", cost = 1, req = { "primary1" }, reqany = false, pos = { 1, 2 },
			mod = { primary_cd = 0.7, primary_dmg = 1.15 }, icon = icons.tmp, active = false },

		{ name = "secondary1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { secondary_dmg = 1.1 }, icon = icons.tmp, active = false },
		{ name = "secondary2", cost = 1, req = { "secondary1" }, reqany = false, pos = { 3, 2 },
			mod = { secondary_dmg = 1.25, secondary_cd = 0.85 }, icon = icons.tmp, active = false },

		{ name = "overload", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { overloads = 2 }, icon = icons.overload, active = true },

		{ name = "buff", cost = 1, req = { "primary1", "secondary1" }, reqany = false, pos = { 2, 2.5 },
			mod = { prot_power = 0.1, buff_power = 1.15 }, icon = icons.prot, active = false },
	},
	rewards = {
		{ 100, 1 },
		{ 250, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local function add_common( hud )
		hud:SetLanguage( "SCP0492" )

		hud:AddSkill( "prot" )
			:SetOffset( 0.5 )
			:SetMaterial( "slc/hud/scp/0492/prot.png", "smooth" )
			:SetActiveFunction( function( swep )
				return swep:GetProtection() >= CurTime()
			end )

		hud:AddSkill( "boost" )
			:SetMaterial( "slc/hud/scp/0492/buff.png", "smooth" )
			:SetActiveFunction( function( swep )
				return swep:GetBoost() >= CurTime()
			end )

		hud:AddBar( "boost_bar" )
			:SetMaterial( "slc/hud/scp/0492/buff.png", "smooth" )
			:SetColor( Color( 236, 170, 27 ) )
			:SetTextFunction( function( swep )
				local time = swep:GetBoost() - CurTime()
	
				if time < 0 then
					time = 0
				end
				
				return math.Round( time )
			end )
			:SetProgressFunction( function( swep )
				return ( swep:GetBoost() - CurTime() ) / swep:GetBoostDuration()
			end )
			:SetVisibleFunction( function( swep )
				return swep:GetBoost() >= CurTime()
			end )
	end

	local hud_normal = SCPHUDObject( "SCP0492_normal" )
	hud_normal:AddCommonSkills()

	hud_normal:AddSkill( "light_attack" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/0492/light.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud_normal:AddSkill( "heavy_attack" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/0492/heavy.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	add_common( hud_normal )

	local hud_assassin = SCPHUDObject( "SCP0492_assassin" )
	hud_assassin:AddCommonSkills()
	
	hud_assassin:AddSkill( "light_attack" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/0492/light.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
	
	hud_assassin:AddSkill( "rapid" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/0492/rapid.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	add_common( hud_assassin )

	local hud_boomer = SCPHUDObject( "SCP0492_boomer" )
	hud_boomer:AddCommonSkills()
	
	hud_boomer:AddSkill( "heavy_attack" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/0492/heavy.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
	
	hud_boomer:AddSkill( "explode" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/0492/explode.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetActiveFunction( function( swep )
			return swep:GetOwner():Health() <= 50
		end )

	add_common( hud_boomer )

	hud_boomer:AddBar( "explode_bar" )
		:SetMaterial( "slc/hud/scp/0492/explode.png", "smooth" )
		:SetColor( Color( 236, 51, 27 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetExplode() - CurTime()

			if time < 0 then
				time = 0
			end
			
			return math.Round( time )
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetExplode() - CurTime() ) / swep.ExplosionTime
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetExplode() > CurTime()
		end )

	local hud_heavy = SCPHUDObject( "SCP0492_heavy" )
	hud_heavy:AddCommonSkills()
	
	hud_heavy:AddSkill( "heavy_attack" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/0492/heavy.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
	
	hud_heavy:AddSkill( "shot" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/0492/shot.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	add_common( hud_heavy )
end

--[[-------------------------------------------------------------------------
Particles
---------------------------------------------------------------------------]]
PrecacheParticleSystem( "SLC_SCP0492_Shot" )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add{
	name = "SCP0492.Miss",
	sound = "npc/zombie/claw_miss1.wav",
	volume = 1,
	level = 75,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP0492.HitWall",
	sound = "npc/zombie/claw_strike1.wav",
	volume = 1,
	level = 75,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP0492.HitWeak",
	sound = "npc/zombie/claw_strike2.wav",
	volume = 1,
	level = 75,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP0492.HitStrong",
	sound = "npc/zombie/claw_strike3.wav",
	volume = 1,
	level = 75,
	pitch = 100,
	channel = CHAN_STATIC,
}