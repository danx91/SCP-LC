SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-058"

SWEP.HoldType		= "melee"

SWEP.ViewModel		= "models/player/alski/scp/SCP_058VM.mdl"
//SWEP.ViewModelFOV	= 80
SWEP.ShouldDrawViewModel = true
SWEP.ScoreOnDamage = true

SWEP.AttackSlow = 0

function SWEP:SetupDataTables()
	self:AddNetworkVar( "ShotStacks", "Int" )
	self:AddNetworkVar( "NextStack", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP058" )
	self:InitializeHUD( "scp058" )

	self:SetShotStacks( 4 )
end

function SWEP:Think()
	self:PlayerFreeze()
	self:SwingThink()

	local ct = CurTime()
	local owner = self:GetOwner()

	if SERVER then
		if self.AttackSlow != 0 and self.AttackSlow < ct then
			self.AttackSlow = 0
			owner:PopSpeed( "SCP058AttackSlow", true )
		end

		local max_stacks = self:GetUpgradeMod( "stacks" ) or 4
		local stacks = self:GetShotStacks()
		if stacks < max_stacks then
			local ns = self:GetNextStack()

			if ns == 0 then
				self:SetNextStack( ct + 15 / ( self:GetUpgradeMod( "regen_rate" ) or 1 ) )
			elseif ns <= ct then
				self:SetNextStack( 0 )
				self:SetShotStacks( stacks + 1 )
			end
		elseif self:GetNextStack() != 0 then
			self:SetNextStack( 0 )
		end
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
	
	self:SetNextPrimaryFire( ct + 2.5 - ( self:GetUpgradeMod( "prim_cd" ) or 0 ) )

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
				owner:PushSpeed( 0.75, 0.75, -1, "SCP058AttackSlow", 1 )
				self.AttackSlow = ct + 1.5

				local dmg = DamageInfo()

				dmg:SetAttacker( owner )
				dmg:SetDamageType( DMG_GENERIC )
				dmg:SetDamage( 20 + ( self:GetUpgradeMod( "prim_dmg" ) or 0 ) )

				SuppressHostEvents( NULL )
				ent:TakeDamageInfo( dmg )
				SuppressHostEvents( owner )

				if self:GetUpgradeMod( "primary_poison" ) == true then
					local pdmg = self:GetUpgradeMod( "pp_dmg" ) or 0

					if self:GetUpgradeMod( "pp_inta2" ) == true and !ent:HasEffect( "poison" ) then
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

function SWEP:SecondaryAttack()
	if ROUND.preparing or ROUND.post then return end

	if self:GetShotStacks() < 1 then return end
	self:SetShotStacks( self:GetShotStacks() - 1 )

	local ct = CurTime()
	local owner = self:GetOwner()

	if self:GetUpgradeMod( "shot_mode" ) == 2 then
		self:SetNextSecondaryFire( ct + 0.25 )
	else
		self:SetNextSecondaryFire( ct + 4 + ( self:GetUpgradeMod( "shot_cd" ) or 0 ) )
	end

	owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )

	if SERVER then
		owner:PushSpeed( 0.75, 0.75, -1, "SCP058AttackSlow", 1 )
		self.AttackSlow = ct + 1.5

		local pos = owner:GetPos()

		local ent = ents.Create( "slc_058_projectile" )
		ent:SetPos( pos + Vector( 0, 0, 45 ) )
		ent:SetAngles( owner:GetAimVector():Angle() )
		ent:SetOwner( owner )

		ent:SetSpeed( 16 * ( self:GetUpgradeMod( "shot_speed" ) or 1 ) )
		ent:SetSize( self:GetUpgradeMod( "shot_size" ) or 1 )

		local poison = self:GetUpgradeMod( "shot_poison" )
		local pdmg = self:GetUpgradeMod( "sp_dmg" ) or 0
		local mode = self:GetUpgradeMod( "shot_mode" )

		if mode == 1 then
			ent:SetEffectName( nil )
		elseif poison then
			ent:SetEffectName( "SLCPBSplash" )
		end

		ent.OnHit = function( proj, trace )
			if IsValid( self ) and IsValid( owner ) then
				if !mode then
					local damage = 40 * ( self:GetUpgradeMod( "shot_damage" ) or 1 )

					if trace.HitPos:DistToSqr( pos ) < 40000 then --200 ^ 2
						damage = damage * 0.5
					end

					local direct
					if IsValid( trace.Entity ) and trace.Entity:IsPlayer() and self:CanTargetPlayer( trace.Entity ) then
						direct = trace.Entity

						local dmg = DamageInfo()
						dmg:SetAttacker( owner )
						dmg:SetDamageType( DMG_GENERIC )
						dmg:SetDamage( damage )

						trace.Entity:TakeDamageInfo( dmg )

						if poison then
							trace.Entity:ApplyEffect( "poison", owner, pdmg )
						end
					end

					for i, v in ipairs( ents.FindInSphere( trace.HitPos + trace.HitNormal * 10, 96 * proj:GetSize() ) ) do
						if v:IsPlayer() and self:CanTargetPlayer( v ) then
							local tr = util.TraceLine{
								start = trace.HitPos,
								endpos = v:WorldSpaceCenter(),
								filter = direct,
								mask = MASK_SHOT,
							}

							if tr.Entity == v and v != direct then
								local dmg = DamageInfo()
								dmg:SetAttacker( owner )
								dmg:SetDamageType( DMG_GENERIC )
								dmg:SetDamage( damage * 0.75 )

								v:TakeDamageInfo( dmg )

								if poison then
									v:ApplyEffect( "poison", owner, pdmg )
								end
							end
						end
					end
				elseif mode == 1 then
					local cloud = ents.Create( "slc_poison_cloud" )
					if IsValid( cloud ) then
						cloud:SetPos( trace.HitPos + trace.HitNormal * 45 * proj:GetSize() )
						cloud:SetOwner( owner )
						cloud:SetSize( proj:GetSize() )
						cloud:SetPoisonDamage( pdmg )
						cloud:SetDamage( self:GetUpgradeMod( "cloud_damage" ) or 0 )
						cloud:SetDuration( 20 * ( self:GetUpgradeMod( "cloud_dur" ) or 1 ) + 2 )

						cloud:Spawn()
					end
				elseif mode == 2 then
					if IsValid( trace.Entity ) and trace.Entity:IsPlayer() and self:CanTargetPlayer( trace.Entity ) then
						if trace.HitPos:DistToSqr( pos ) >= 40000 or math.random( 30 ) <= 10 then --200 ^ 2 TEST poison 33% dist < 200m
							trace.Entity:ApplyEffect( "poison", owner, pdmg )
						end
					end
				end
			end
		end

		ent:Spawn()
	end
end

function SWEP:MakeExplosion()
	local owner = self:GetOwner()
	local pos = owner:GetPos()
	local radius_mul = self:GetUpgradeMod( "explosion_radius" ) or 1
	local radius = 600 * radius_mul
	local use_poison = self:GetUpgradeMod( "explosion_poison" )
	local damage = 250

	local eff = EffectData()

	eff:SetOrigin( pos )
	eff:SetRadius( radius_mul )

	util.Effect( "slc_058_explosion", eff, true, true )
	owner:EmitSound( "SLC.058Explosion" )

	local ct = CurTime()
	self:SetNextPrimaryFire( ct + 2.5 )
	self:SetNextSecondaryFire( ct + 2.5 )

	owner:PushSpeed( 0.3, 0.3, -1, "SCP058AttackSlow", 1 )
	self.AttackSlow = ct + 2

	for k, v in pairs( ents.FindInSphere( pos, radius ) ) do
		if IsValid( v ) and v:IsPlayer() and self:CanTargetPlayer( v ) then
			local tr = util.TraceLine{
				start = pos,
				endpos = v:WorldSpaceCenter(),
				filter = owner,
				mask = MASK_SHOT,
			}

			if tr.Entity == v then
				local dmg = DamageInfo()

				dmg:SetAttacker( owner )
				dmg:SetDamageType( DMG_BLAST )
				dmg:SetDamage( damage * ( 1 - v:GetPos():Distance( pos ) / radius ) )

				v:TakeDamageInfo( dmg )

				if use_poison then
					v:ApplyEffect( "poison", 2, owner, 0 )
				end
			end
		end
	end
end

function SWEP:DrawSCPHUD()
	/*draw.Text( {
		text = self:GetShotStacks(),
		pos = { ScrW() * 0.5, ScrH() * 0.94 },
		font = "SCPHUDSmall",
		color = Color( 255, 0, 0 ),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})*/
end

function SWEP:OnUpgradeBought( name, info, group )
	if name == "shot31" then
		self.Secondary.Automatic = true
	elseif name == "exp1" then
		if SERVER then
			self.ExplosionHPTab = {}

			for i = 1, math.floor( self:GetOwner():Health() / 1000 ) do
				self.ExplosionHPTab[i] = false
			end
		end
	end
end

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
	if IsValid( ent ) and ent:IsPlayer() then
		if ent:SCPClass() == CLASSES.SCP058 then
			local wep = ent:GetWeapon( "weapon_scp_058" )
			if IsValid( wep ) and wep.ExplosionHPTab then
				local hp = ent:Health()
				local chpt = math.floor( ( hp + dmg:GetDamage() ) / 1000 )
				if wep.ExplosionHPTab[chpt] == false and math.floor( hp / 1000 ) < chpt then
					wep.ExplosionHPTab[chpt] = true
					wep:MakeExplosion()
				end
			end
		end
	end
end )

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
	grid_y = 3,
	upgrades = {
		{ name = "attack1", icon = icons.attack, cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { primary_poison = true }, active = false },
		{ name = "attack2", icon = icons.attack, cost = 2, req = { "attack1" }, reqany = false,  pos = { 1, 2 }, mod = { prim_dmg = 10, pp_dmg = 0.25, prim_cd = 0.5 }, active = false },
		{ name = "attack3", icon = icons.attack, cost = 4, req = { "attack2" }, reqany = false,  pos = { 1, 3 }, mod = { prim_dmg = 20, pp_dmg = 0.5, prim_cd = 1, pp_inta2 = true }, active = false },

		{ name = "shot", icon = icons.poison_shot, cost = 3, req = {}, reqany = false,  pos = { 3, 1 }, mod = { shot_poison = true }, active = false },

		{ name = "shot11", icon = icons.shot, cost = 3, req = { "shot" }, reqany = false, block = { "shot21", "shot31" },  pos = { 2, 2 }, mod = { shot_damage = 1.4, shot_speed = 0.9, shot_size = 1.3, shot_cd = 1 }, active = false },
		{ name = "shot12", icon = icons.shot, cost = 4, req = { "shot11" }, reqany = false,  pos = { 2, 3 }, mod = { shot_damage = 2, shot_speed = 0.75, shot_size = 1.75, shot_cd = 2, shot_poison = false }, active = false },

		{ name = "shot21", icon = icons.cloud, cost = 3, req = { "shot" }, reqany = false, block = { "shot11", "shot31" },  pos = { 3, 2 }, mod = { shot_mode = 1, cloud_damage = 5, sp_dmg = 0.75, shot_speed = 0.9, shot_size = 1.1, stacks = 3, shot_cd = 5, regen_rate = 0.9 }, active = false },
		{ name = "shot22", icon = icons.cloud, cost = 4, req = { "shot21" }, reqany = false,  pos = { 3, 3 }, mod = { cloud_damage = 10, cloud_dur = 1.5, sp_dmg = 1.5, shot_speed = 0.75, shot_size = 1.3, regen_rate = 0.75 }, active = false },

		{ name = "shot31", icon = icons.multishot, cost = 3, req = { "shot" }, reqany = false, block = { "shot11", "shot21" },  pos = { 4, 2 }, mod = { shot_mode = 2, shot_speed = 1.1, shot_size = 0.85, stacks = 6, regen_rate = 1.5 }, active = true },
		{ name = "shot32", icon = icons.multishot, cost = 4, req = { "shot31" }, reqany = false,  pos = { 4, 3 }, mod = { shot_speed = 1.25, shot_size = 0.6, stacks = 8, regen_rate = 2.2 }, active = false },

		{ name = "exp1", icon = icons.explosion1, cost = 2, req = {}, reqany = false,  pos = { 5, 1 }, mod = {}, active = true },
		{ name = "exp2", icon = icons.explosion2, cost = 2, req = { "exp1" }, reqany = false,  pos = { 5, 2 }, mod = { explosion_poison = true, explosion_radius = 1.5 }, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false,  pos = { 5, 3 }, mod = {}, active = false },
	},
	rewards = { --13+1
		{ 100, 1 },
		{ 200, 1 },
		{ 300, 1 },
		{ 400, 1 },
		{ 500, 1 },
		{ 600, 1 },
		{ 700, 1 },
		{ 800, 1 },
		{ 900, 1 },
		{ 1000, 1 },
		{ 1100, 1 },
		{ 1200, 1 },
		{ 1300, 1 },
	}
} )

InstallUpgradeSystem( "scp058", SWEP )

if CLIENT then
	DefineSCPHUD( "scp058",  {
		name = "SCP058",
		skills = {
			{
				name = "primary_attack",
				pos = 1,
				cooldown = "GetNextPrimaryFire",
				button = "attack",
				material = "slc/hud/scp/058/attack2.png",
			},
			{
				name = "shot",
				pos = 2,
				cooldown = "GetNextSecondaryFire",
				button = "attack2",
				active = function( swep )
					return swep:GetShotStacks() > 0
				end,
				material = "slc/hud/scp/058/shot.png",
			},
			{
				name = "shot_stacks",
				pos = 4,
				cooldown = "GetNextStack",
				text = "GetShotStacks",
				material = "slc/hud/scp/058/shot.png",
			},
		}
	} )
end

sound.Add{
	name = "SLC.058Explosion",
	volume = 1,
	level = 125,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/058/explode.wav",
	channel = CHAN_STATIC,
}