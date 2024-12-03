SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-3199"

SWEP.ViewModel 			= "models/weapons/alski/scp3199arms.mdl"
SWEP.ShouldDrawViewModel = true

SWEP.HoldType 			= "melee"

SWEP.DisableDamageEvent = true

SWEP.AttackCooldown = 1.8
SWEP.AttackDamage = 12
SWEP.AttackDamageMultiplier = 0.06

SWEP.FrenzyDuration = 22
SWEP.FrenzySpeed = 1.05
SWEP.FrenzySpeedMultiplier = 0.001
SWEP.FrenzyPenalty = 0.2
SWEP.FrenzyPenaltyStacks = 0.25
SWEP.FrenzyDetect = 1700

SWEP.SpecialCooldown = 30
SWEP.SpecialDamage = 20
SWEP.SpecialBaseSlow = 0.2
SWEP.SpecialSlowCap = 0.1
SWEP.SpecialSlow = 0.015
SWEP.SpecialSlowDuration = 6
SWEP.SpecialThreshold = 5
SWEP.SpecialBleed = 12

SWEP.EggTime = 5
SWEP.MaxEggs = 5
SWEP.EggsProtection = 0.15
SWEP.EggsProtectionMax = 0.75
SWEP.RespawnTime = 45

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "EggReady", "Bool" )
	self:AddNetworkVar( "TotalStacks", "Int" )
	self:AddNetworkVar( "FrenzyStacks", "Int" )
	self:AddNetworkVar( "TotalEggs", "Int" )
	self:AddNetworkVar( "Frenzy", "Float" )
	self:AddNetworkVar( "EggTime", "Float" )
	self:AddNetworkVar( "RespawnTime", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP3199" )
	self:InitializeHUD()

	self:SetEggReady( true )
end

SWEP.NextIdle = 0
SWEP.NextFrenzyRegen = 0
SWEP.NextTransmit = 0
SWEP.NextEggCheck = 0
function SWEP:Think()
	self:PlayerFreeze()
	self:SwingThink()

	local ct = CurTime()
	local owner = self:GetOwner()

	if self.NextIdle <= ct then
		local vm = owner:GetViewModel()
		local seq, time = vm:LookupSequence( "idlearms" )

		self.NextIdle = ct + time
		vm:SendViewModelMatchingSequence( seq )
	end

	if CLIENT then return end

	if !self.Eggs then
		self.Eggs = {
			SpawnSCP3199Egg( owner )
		}

		self:CheckEggs()
	end

	if self.NextEggCheck < ct then
		self:CheckEggs()
	end

	local frenzy = self:GetFrenzy()
	if frenzy != 0 and frenzy < ct then
		self:StopFrenzy( false )
	elseif frenzy >= ct then
		if self.NextFrenzyRegen <= ct then
			self.NextFrenzyRegen = self.NextFrenzyRegen + 1

			if self.NextFrenzyRegen < ct then
				self.NextFrenzyRegen = ct + 1
			end

			owner:AddHealth( math.ceil( self:GetTotalStacks() / 3 ) )
		end

		if self.NextTransmit <= ct then
			self.NextTransmit = ct + 1
	
			local pos = owner:GetPos()
			local tab = {}
	
			local radius = ( self.FrenzyDetect * self:GetUpgradeMod( "passive_radius", 1 ) ) ^ 2
	
			for i, v in ipairs( player.GetAll() ) do
				if !self:CanTargetPlayer( v ) or v:HasEffect( "deep_wounds" ) or pos:DistToSqr( v:GetPos() ) > radius then continue end
				
				local cpos = v:GetPos() + v:OBBCenter()
				table.insert( tab, {
					x = cpos.x,
					y = cpos.y,
					z = cpos.z
				} )
			end
	
			if #tab > 0 then
				net.SendTable( "SCP3199Frenzy", tab, owner )
			end
		end
	end
end

local paths = {
	[1] = {
		Vector( 0, 8, -2 ),
		Vector( 0, -8, 3 ),
		-20,
		20,
	},
	[2] = {
		Vector( 0, -8, -2 ),
		Vector( 0, 8, 3 ),
		20,
		-20,
	},
	/*spec = {
		Vector( 0, 0, 0 ),
		Vector( 10, 0, 0 ),
		0,
		0,
	},*/
}

local mins, maxs = Vector( -1, -1, -1 ), Vector( 1, 1, 1 )
//local mins_str, maxs_str = Vector( -1, -6, -6 ), Vector( 1, 6, 6 )

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	self:SetNextPrimaryFire( ct + self.AttackCooldown * self:GetUpgradeMod( "attack_cd", 1 ) )

	local owner = self:GetOwner()
	owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )

	local vm = owner:GetViewModel()
	local seq = self.LastAttackSequence == 1 and 2 or 1
	self.LastAttackSequence = seq

	local dur = vm:SequenceDuration( seq )

	self.NextIdle = ct + dur
	vm:SendViewModelMatchingSequence( seq )

	local any_hit = false
	local hit_wounded = false
	local ent_filter = {}
	local path = paths[seq]

	self:SwingAttack( {
		path_start = path[1],
		path_end = path[2],
		fov_start = path[3],
		fov_end = path[4],
		delay = 0.2,
		duration = 0.25,
		num = 8,
		dist_start = 75,
		dist_end = 50,
		mins = mins,
		maxs = maxs,
		on_start = function()
			self:EmitSound( "SCP3199.Miss" )
		end,
		callback = function( trace, id, center )
			if trace.HitWorld then
				self:EmitSound( "SCP3199.Hit" )
				return true, id < 4 and {
					distance = 65,
					bounds = 2.5,
				}
			end

			local ent = trace.Entity
			if !IsValid( ent ) or ent_filter[ent] then return end

			ent_filter[ent] = true

			if !ent:IsPlayer() then
				self:EmitSound( "SCP3199.Hit" )

				if SERVER then
					SuppressHostEvents( NULL )
					self:SCPDamageEvent( ent, 50 )
					SuppressHostEvents( owner )
				end

				return true
			end

			self:EmitSound( "Bounce.Flesh" )

			if CLIENT or !self:CanTargetPlayer( ent ) then return end

			local total_stacks = self:GetTotalStacks()
			local dmg_mult = self:GetUpgradeMod( "attack_dmg", 1 ) + ( self.AttackDamageMultiplier + self:GetUpgradeMod( "attack_dmg_stacks", 0 ) ) * total_stacks
			local has_deep_wounds = ent:HasEffect( "deep_wounds" )

			if has_deep_wounds then
				dmg_mult = dmg_mult * 0.25
			end

			SuppressHostEvents( NULL )
			ent:TakeDamage( self.AttackDamage * dmg_mult, owner, owner )
			SuppressHostEvents( owner )

			local frenzy = self:GetFrenzy()
			local frenzy_stacks = self:GetFrenzyStacks()
			if frenzy == 0 or !has_deep_wounds then
				any_hit = true
				ent:ApplyEffect( "deep_wounds" )

				frenzy_stacks = frenzy_stacks + 1

				local max_stacks = 5 + self:GetUpgradeMod( "frenzy_max", 0 )
				if frenzy_stacks > max_stacks then
					frenzy_stacks = max_stacks
				else
					local speed = self.FrenzySpeed + ( self.FrenzySpeedMultiplier + self:GetUpgradeMod( "frenzy_speed_stacks", 0 ) ) * total_stacks
					owner:PushSpeed( speed, speed, -1, "SLC_SCP3199Frenzy"..frenzy_stacks, 1 )
				end

				self:SetFrenzyStacks( frenzy_stacks )
				self:SetTotalStacks( total_stacks + 1 )
				self:SetFrenzy( CurTime() + self.FrenzyDuration * self:GetUpgradeMod( "frenzy_duration", 1 ) )
				self:AddScore( 1 )
			elseif frenzy > 0 and has_deep_wounds then
				hit_wounded = true
			end
		end,
		on_end = function()
			if SERVER and !any_hit and self:GetFrenzy() > 0 then
				self:StopFrenzy( hit_wounded )
			end
		end 
	} )
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetFrenzy() < ct or self:GetFrenzyStacks() < self.SpecialThreshold then return end

	self:SetNextSecondaryFire( ct + self.SpecialCooldown )
	self:StopFrenzy( false )

	local owner = self:GetOwner()
	local stacks = self:GetTotalStacks()

	local dmg = self.SpecialDamage * self:GetUpgradeMod( "special_dmg", 1 )
	local slow = math.Clamp( 1 - self.SpecialBaseSlow - ( self.SpecialSlow + self:GetUpgradeMod( "special_slow", 0 ) ) * stacks, self.SpecialSlowCap, 1 )
	local slow_dur = self.SpecialSlowDuration * self:GetUpgradeMod( "special_slow_duration", 1 )
	local bleed = math.floor( stacks / self.SpecialBleed )

	if bleed > 3 then
		bleed = 3
	end

	for i, v in ipairs( player.GetAll() ) do
		if v:HasEffect( "deep_wounds" ) and self:CanTargetPlayer( v ) then
			v:TakeDamage( dmg, ower, owner )

			v:PushSpeed( slow, slow, -1, "SLC_SCP3199Slow", 1 )
			v:AddTimer( "SCP3199Slow", slow_dur, 1, function()
				v:PopSpeed( "SLC_SCP3199Slow" )
			end )

			if bleed > 0 then
				v:ApplyEffect( "bleeding", bleed, owner )
			end
		end
	end
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post or !self:GetEggReady() then return end

	local ct = CurTime()
	if self:GetEggTime() >= ct or self:GetFrenzy() > 0 then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() or owner:Crouching() then return end

	self:CheckEggs()
	if #self.Eggs >= self.MaxEggs then
		self:HUDNotify( "eggs_max" )
		return
	end

	self:SetEggTime( CurTime() + self.EggTime )

	owner:AddTimer( "SCP3199Egg", 5, 1, function()
		self:CheckEggs()
		if #self.Eggs >= self.MaxEggs then
			self:HUDNotify( "eggs_max" )
			return
		end

		self:SetEggTime( 0 )
		self:SetEggReady( false )

		local egg = ents.Create( "slc_3199_egg" )
		if IsValid( egg ) then
			egg:SetPos( owner:GetPos() )
			egg:SetOwner( owner )
			egg:Spawn()

			table.insert( self.Eggs, egg )
			self:CheckEggs()
		end
	end )
end

SWEP.FOVIncrease = 0
function SWEP:TranslateFOV( fov )
	if self:GetFrenzy() != 0 then
		self.FOVIncrease = math.Approach( self.FOVIncrease, 10, FrameTime() * 10 )
	elseif self.FOVIncrease > 0 then
		self.FOVIncrease = math.Approach( self.FOVIncrease, 0, FrameTime() * 10 )
	end

	if self.FOVIncrease > 0 then
		return fov + self.FOVIncrease
	end
end

function SWEP:StopFrenzy( wrong )
	local ct = CurTime()
	local owner = self:GetOwner()

	for i = 1, self:GetFrenzyStacks() do
		owner:PopSpeed( "SLC_SCP3199Frenzy"..i )
	end

	self:SetFrenzy( 0 )
	self:SetFrenzyStacks( 0 )
	self:SetNextPrimaryFire( ct + 5 )
	self:SetNextSpecialAttack( ct + 5 )

	if wrong then
		self:SetTotalStacks( math.floor( self:GetTotalStacks() * ( 1 - self.FrenzyPenaltyStacks ) ) )
	end

	owner:PushSpeed( self.FrenzyPenalty, self.FrenzyPenalty, -1, "SLC_SCP3199Penalty", 1 )
	owner:AddTimer( "SCP3199Penalty", 5, 1, function()
		owner:PopSpeed( "SLC_SCP3199Penalty" )
	end )
end

function SWEP:CheckEggs()
	local num = 0

	for i, v in rpairs( self.Eggs ) do
		if IsValid( v ) and !IsValid( v.Locked ) then
			num = num + 1
		else
			table.remove( self.Eggs, i )
		end
	end

	self:SetTotalEggs( num )
	self.NextEggCheck = CurTime() + 1
end

function SWEP:EggRespawn()
	self:CheckEggs()

	local total = self:GetTotalEggs()
	if total <= 0 then return end

	local owner = self:GetOwner()
	local egg = self.Eggs[math.random( total )]
	
	self:StopFrenzy( false )
	self:SetRespawnTime( CurTime() + self.RespawnTime )

	owner:CreatePlayerRagdoll( true )

	local pos = egg:GetPos()
	owner:SetPos( pos )

	owner:AddTimer( "SCP3199EggPos", 0.2, 5, function()
		owner:SetPos( pos )
	end )

	owner:SetNoDraw( true )
	owner:SetSolid( SOLID_NONE )
	owner:DisableControls( "scp3199_respawn", CAMERA_MASK )

	egg:SetOwner( owner )
	egg.Locked = owner
	egg.LockedSignature = owner:TimeSignature()

	owner:AddTimer( "SCP3199Respawn", self.RespawnTime, 1, function()
		if !IsValid( egg ) then
			if !self:EggRespawn() then
				owner:SkipNextSuicide()
				owner:Kill()
			end

			return
		end

		owner:SetNoDraw( false )
		owner:SetSolid( SOLID_BBOX )
		owner:StopDisableControls( "scp3199_respawn" )
		owner:SetHealth( owner:GetMaxHealth() )

		egg:Remove()
	end )

	return true
end

function SWEP:OnPlayerKilled( ply )
	self:SetEggReady( true )
	AddRoundStat( "3199" )
end

function SWEP:OnUpgradeBought( name, active, group )
	if SERVER and name == "egg" then
		table.insert( self.Eggs, SpawnSCP3199Egg( self:GetOwner() ) )
		self:CheckEggs()
	end
end

local heart = Material( "slc/hud/scp/3199/heart.png", "smooth" )

SWEP.FrenzyDetectDraw = 0
function SWEP:DrawSCPHUD()
	local frenzy = self:GetFrenzy()
	if frenzy == 0 then return end

	local ct = CurTime()
	if self.FrenzyDetectDraw < ct then return end

	local w = ScrW()
	local t = self.FrenzyDetectDraw - ct

	surface.SetDrawColor( 255, 255, 255, 255 * t )
	surface.SetMaterial( heart )

	local size = w * 0.02

	for i, v in ipairs( self.FrenzyDetectTable ) do
		local pos = Vector( v.x, v.y, v.z ):ToScreen()
		if pos.visible then
			surface.DrawTexturedRect( pos.x - size * 0.5, pos.y - size * 0.5, size, size )
		end
	end
end

--[[-------------------------------------------------------------------------
Net
---------------------------------------------------------------------------]]
if SERVER then
	net.AddTableChannel( "SCP3199Frenzy" )
end

if CLIENT then
	net.ReceiveTable( "SCP3199Frenzy", function( data )
		local ply = LocalPlayer()

		ply:EmitSound( "SLCPlayer.Heartbeat" )

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep.FrenzyDetectDraw = CurTime() + 1
		wep.FrenzyDetectTable = data
	end )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP3199") TransmitSCPHooks()
SCPHook( "SCP3199", "EntityTakeDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP3199 then return end
	
	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) then return end
	if wep:GetRespawnTime() >= CurTime() then return true end

	if dmg:IsDamageType( DMG_BULLET ) then
		wep:CheckEggs()
		local prot = 1 - math.Clamp( wep:GetTotalEggs() * wep.EggsProtection, 0, wep.EggsProtectionMax )
		if prot < 1 then
			dmg:ScaleDamage( prot )
		end
	end
end )

SCPHook( "SCP3199", "SLCPostScaleDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP3199 then return end
	
	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) then return end
	if wep:GetRespawnTime() >= CurTime() then return true end
	if dmg:GetDamage() < target:Health() then return end

	return wep:EggRespawn()
end )

SCPHook( "SCP3199", "StartCommand", function( ply, cmd )
	if ply:SCPClass() != CLASSES.SCP3199 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetEggTime() < CurTime() then return end

	cmd:ClearMovement()
	cmd:ClearButtons()
	cmd:SetButtons( IN_DUCK )
end )

SCPHook( "SCP3199", "SLCMovementAnimSpeed", function( ply, vel, speed, len, movement )
	if ply:SCPClass() != CLASSES.SCP3199 then return end

	local n = len / 75
	if n < 1.5 then
		n = 1.5
	end

	return n, true
end )

SCPHook( "SCP3199", "PreDrawViewModel", function( vm, ply, wep )
	if ply:SCPClass() != CLASSES.SCP3199 then return end
	if !IsValid( wep ) or wep:GetClass() != "weapon_scp_3199" or wep:GetRespawnTime() < CurTime() then return end

	return true
end )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.frenzy = GetMaterial( "slc/hud/upgrades/scp/3199/frenzy.png", "smooth" )
	icons.attack = GetMaterial( "slc/hud/upgrades/scp/3199/attack.png", "smooth" )
	icons.special = GetMaterial( "slc/hud/upgrades/scp/3199/special.png", "smooth" )
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/3199/passive.png", "smooth" )
	icons.egg = GetMaterial( "slc/hud/upgrades/scp/3199/egg.png", "smooth" )
end

DefineUpgradeSystem( "scp3199", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "frenzy1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { frenzy_duration = 1.5, frenzy_max = 1 }, icon = icons.frenzy },
		{ name = "frenzy2", cost = 2, req = { "frenzy1" }, reqany = false, pos = { 1, 2 },
			mod = { frenzy_max = 2, frenzy_speed_stacks = 0.001 }, icon = icons.frenzy },
		{ name = "frenzy3", cost = 2, req = { "frenzy2" }, reqany = false, pos = { 1, 3 },
			mod = { frenzy_duration = 2, frenzy_speed_stacks = 0.002  }, icon = icons.frenzy },

		{ name = "attack1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { attack_cd = 0.66, attack_dmg = 1.1 }, icon = icons.attack },
		{ name = "attack2", cost = 2, req = { "attack1" }, reqany = false, pos = { 2, 2 },
			mod = { attack_cd = 0.3, attack_dmg_stacks = 0.02 }, icon = icons.attack },
		{ name = "attack3", cost = 3, req = { "attack2" }, reqany = false, pos = { 2, 3 },
			mod = { attack_dmg = 1.25, attack_dmg_stacks = 0.04 }, icon = icons.attack },

		{ name = "special1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { special_dmg = 1.15, special_slow = 0.005, special_slow_duration = 1.2 }, icon = icons.special },
		{ name = "special2", cost = 2, req = { "special1" }, reqany = false, pos = { 3, 2 },
			mod = { special_dmg = 1.4, special_slow = 0.01, special_slow_duration = 1.4 }, icon = icons.special },

		{ name = "passive", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { passive_radius = 1.5 }, icon = icons.passive },

		{ name = "egg", cost = 3, req = {}, reqany = false, pos = { 4, 2.5 },
			mod = {}, icon = icons.egg, active = true },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --18 + 1 points -> 60% = 11 (-1 base) = 10 points
		{ 2, 1 },
		{ 4, 1 },
		{ 6, 1 },
		{ 9, 1 },
		{ 12, 1 },
		{ 15, 1 },
		{ 18, 1 },
		{ 22, 1 },
		{ 26, 1 },
		{ 31, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local color_green = Color( 25, 200, 45 )

	local hud = SCPHUDObject( "SCP3199", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "primary" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/3199/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "special" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/3199/special.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetActiveFunction( function( swep )
			return swep:GetFrenzyStacks() >= swep.SpecialThreshold
		end )
		:SetTextFunction( "GetFrenzyStacks" )
		:SetParser( function( swep, lang )
			return {
				tokens = MarkupBuilder.StaticPrint( swep.SpecialThreshold, color_green ),
			}
		end )

	hud:AddSkill( "egg" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/3199/egg.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetActiveFunction( function( swep )
			return swep:GetEggReady() and swep:GetFrenzy() == 0
		end )
		:SetTextFunction( function( swep )
			return ( math.Clamp( swep:GetTotalEggs() * swep.EggsProtection, 0, swep.EggsProtectionMax ) * 100 ).."%"
		end )
		:SetParser( function( swep, lang )
			return {
				prot = MarkupBuilder.StaticPrint( ( swep.EggsProtection * 100 ).."%", color_green ),
				cap = MarkupBuilder.StaticPrint( ( swep.EggsProtectionMax * 100 ).."%", color_green ),
				eggs = MarkupBuilder.StaticPrint( swep:GetTotalEggs(), color_green ),
				max = MarkupBuilder.StaticPrint( swep.MaxEggs, color_green ),
			}
		end )

	hud:AddSkill( "passive" )
		:SetMaterial( "slc/hud/scp/3199/passive.png", "smooth" )
		:SetOffset( 0.5 )
		:SetTextFunction( "GetTotalStacks" )
		:SetParser( function( swep, lang )
			local stacks = swep:GetTotalStacks()
			local dmg = ( swep.AttackDamageMultiplier + swep:GetUpgradeMod( "attack_dmg_stacks", 0 ) ) * stacks * 100
			local speed = ( swep.FrenzySpeedMultiplier + swep:GetUpgradeMod( "frenzy_speed_stacks", 0 ) ) * stacks * 100
			local slow = math.Clamp( ( swep.SpecialSlow + swep:GetUpgradeMod( "special_slow", 0 ) ) * stacks, 0, 1 - swep.SpecialSlowCap - swep.SpecialBaseSlow ) * 100
			local bleed = math.Clamp( math.floor( stacks / swep.SpecialBleed ), 0, 3 )
			local heal = math.ceil( stacks / 3 )

			return {
				dmg = MarkupBuilder.StaticPrint( dmg.."%", color_green ),
				speed = MarkupBuilder.StaticPrint( speed.."%", color_green ),
				slow = MarkupBuilder.StaticPrint( slow.."%", color_green ),
				bleed = MarkupBuilder.StaticPrint( bleed, color_green ),
				heal = MarkupBuilder.StaticPrint( heal, color_green ),
				penalty = MarkupBuilder.StaticPrint( ( swep.FrenzyPenaltyStacks * 100 ).."%", color_green ),
			}
		end )

	hud:AddBar( "frenzy_bar" )
		:SetMaterial( "slc/hud/scp/3199/frenzy.png", "smooth" )
		:SetColor( Color( 240, 194, 45 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetFrenzy() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetFrenzy() - CurTime() ) / ( swep.FrenzyDuration * swep:GetUpgradeMod( "frenzy_duration", 1 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetFrenzy() > 0
		end )

	hud:AddBar( "egg_bar" )
		:SetMaterial( "slc/hud/scp/3199/egg.png", "smooth" )
		:SetColor( Color( 15, 69, 90 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetEggTime() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetEggTime() - CurTime() ) / swep.EggTime
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetEggTime() > 0
		end )

	hud:AddBar( "respawn_bar" )
		:SetMaterial( "slc/hud/scp/3199/egg.png", "smooth" )
		:SetColor( Color( 95, 140, 140 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetRespawnTime() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetRespawnTime() - CurTime() ) / swep.RespawnTime
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetRespawnTime() > CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add{
	name = "SCP3199.Miss",
	sound = "npc/zombie/claw_miss1.wav",
	volume = 1,
	level = 75,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP3199.Hit",
	sound = "npc/zombie/claw_strike1.wav",
	volume = 1,
	level = 75,
	pitch = 100,
	channel = CHAN_STATIC,
}