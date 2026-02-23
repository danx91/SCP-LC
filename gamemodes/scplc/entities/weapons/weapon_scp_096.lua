SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-096"

SWEP.HoldType		= "normal"

SWEP.ScoreOnKill	= true

SWEP.RegePreparing = 4
SWEP.RageStun = 3
SWEP.RageCooldown = 8

SWEP.SpecialCooldown = 120

SWEP.RegenTransition = 2
SWEP.RegenStacksDelay = 10
SWEP.RegenHealDelay = 0.333
SWEP.RegenHeal = 10

SWEP.ChaseSound = "scp_lc/scp/096/chase.ogg"
SWEP.TriggeredSound = "scp_lc/scp/096/triggered.ogg"

if SERVER then
	util.AddNetworkString( "SLCSCP096Targets" )
end

/*
0	ragdoll					24		ACT_DIERAGDOLL --nothing
10	IDLE_STIMULATED			78		ACT_IDLE_STIMULATED --standing up, arms to head
9	IDLE_AGITATED			79		ACT_IDLE_AGITATED -worse version of angry
5	IDLETORUN				505		ACT_IDLETORUN --pretty useless, stay -> run

3	COWER					61		ACT_COWER --covering head
8	IDLE_RELAXED			77		ACT_IDLE_RELAXED --standing up

1	idle					1		ACT_IDLE --idle
4	walk					6		ACT_WALK --walk
6	RUN						10		ACT_RUN --run arms back
7	RUN_CROUCH				12		ACT_RUN_CROUCH --run arms forward
2	CROUCHIDLE				46		ACT_CROUCHIDLE --sit
11	IDLE_ANGRY				76		ACT_IDLE_ANGRY --idle angry
12	GESTURE_MELEE_ATTACK1	139		ACT_GESTURE_MELEE_ATTACK1 --run to short attack
13	GESTURE_FLINCH_HEAD		150		ACT_GESTURE_FLINCH_HEAD --run to meele attacks
*/

SWEP.ActTranslate = {
	[ACT_MP_STAND_IDLE] = ACT_IDLE,
	[ACT_MP_WALK] = ACT_WALK,
	[ACT_MP_RUN] = ACT_RUN,
	[ACT_MP_CROUCH_IDLE] = ACT_IDLE,
	[ACT_MP_CROUCHWALK] = ACT_WALK,
	[ACT_MP_JUMP] = ACT_IDLE,
}

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
	
	self:NetworkVar( "Int", "Targets" )
	self:NetworkVar( "Int", "RegenStacks" )
	self:NetworkVar( "Float", "PassiveCooldown" )
	self:NetworkVar( "Float", "Regen" )
	self:NetworkVar( "Float", "Rage" )
	self:NetworkVar( "Float", "Lunge" )

end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP096" )
	self:InitializeHUD()

	self.NextRegenStack = CurTime() + self.RegenStacksDelay
	self.Targets = {}
	self.TargetsPositions = {}
	self.DamageLog = {}
	self.HaloTable = {}
	self.EntityCache = {}
end

SWEP.NextRegenStack = 0
SWEP.NextRegenTick = 0
SWEP.NextPassive = 0
SWEP.NextScream = 0
SWEP.KillTimeLimit = 0

local attack_trace = {}
attack_trace.mask = CONTENTS_SOLID
attack_trace.output = attack_trace

local breach_trace = {}
breach_trace.mins = Vector( -12, -12, -32 )
breach_trace.maxs = Vector( 12, 12, 32 )
breach_trace.mask = MASK_SOLID_BRUSHONLY //bit.bor( CONTENTS_HITBOX, CONTENTS_MONSTER, CONTENTS_MOVEABLE, CONTENTS_GRATE, CONTENTS_WINDOW, CONTENTS_SOLID, CONTENTS_PLAYERCLIP, CONTENTS_MONSTERCLIP )
breach_trace.output = breach_trace

local breach_offset = Vector( 0, 0, 48 )
local class_whitelist = {
	prop_ragdoll = true
}

function SWEP:Think()
	if CLIENT or ROUND.preparing then return end

	local ct = CurTime()
	local owner = self:GetOwner()

	local regen = self:GetRegen()
	if regen == 0 then
		if self.NextRegenStack <= ct then
			local stack_delay = self.RegenStacksDelay * self:GetUpgradeMod( "regen_stacks", 1 )
	
			self.NextRegenStack = self.NextRegenStack + stack_delay
	
			if self.NextRegenStack <= ct then
				self.NextRegenStack = ct + stack_delay
			end
	
			self:SetRegenStacks( self:GetRegenStacks() + 1 )
		end
	else
		local stacks = self:GetRegenStacks()
		if regen < 0 and -regen < ct then
			self:SetRegen( 0 )
			owner:StopDisableControls( "scp096_regen" )

			self.NextRegenStack = ct + self.RegenStacksDelay * self:GetUpgradeMod( "regen_stacks", 1 )
		elseif regen > 0 and regen < ct and self.NextRegenTick <= ct then
			self.NextRegenTick = self.NextRegenTick + self.RegenHealDelay

			if self.NextRegenTick <= ct then
				self.NextRegenTick = ct +  self.RegenHealDelay
			end

			local hp = owner:Health()
			local max_hp = owner:GetMaxHealth()

			stacks = stacks - 1
			hp = hp + math.ceil( self.RegenHeal * self:GetUpgradeMod( "regen_mult", 1 ) )

			local stop = false

			if hp > max_hp then
				stop = true
				hp = max_hp
			elseif stacks <= 0 then
				stop = true
			end

			if stop then
				self:SetRegen( -ct - self.RegenTransition )
			end

			owner:SetHealth( hp )
			self:SetRegenStacks( stacks )
		end

		return
	end

	local rage = self:GetRage()
	if rage < 0 then
		if -rage < ct then
			self:SetRage( 0 )
			owner:Freeze( false )
		end

		return
	end

	local lunge = self:GetLunge()
	if lunge > ct then
		local ang = owner:EyeAngles()
		ang.p = 0
		ang.r = 0

		owner:SetVelocity( ang:Forward() * 200 + Vector( 0, 0, 1 ) )
	elseif lunge > 0 then
		self:StopRage()
	end

	if self:GetPassiveCooldown() >= ct then return end

	if self.NextPassive <= ct then
		self.NextPassive = self.NextPassive + 0.25

		if self.NextPassive <= ct then
			self.NextPassive = ct + 0.25
		end

		for i, v in ipairs( player.GetAll() ) do
			if istable( self.Targets[v] ) or !self:CanTargetPlayer( v ) then continue end

			if IsBlockingEscape( owner, v ) then
				self:AddTarget( v )
			elseif owner:TestVisibility( v, nil, true, 36 ) then
				self.Targets[v] = ( self.Targets[v] or 0 ) + 1
				if self.Targets[v] < 3 then continue end

				self:AddTarget( v )
			else
				self.Targets[v] = nil
				continue
			end
		end
	end
	
	if rage <= 0 or rage >= ct or !self.RageReady then return end
	if !self:CheckTargets() then return end

	if self.NextScream < ct then
		self.NextScream = ct + 10
		owner:EmitSound( "SCP096.Scream" )
	end

	if self.KillTimeLimit > 0 and self.KillTimeLimit < ct then
		self:StopRage()
		return
	end

	if ROUND.post then return end

	local kill_limit = self:GetUpgradeMod( "multi", 1 )
	local owner_pos = owner:GetPos()
	local owner_center = owner_pos + owner:OBBCenter()

	for ply, tab in pairs( self.Targets ) do
		local ply_pos = ply:GetPos()
		if !istable( tab ) or owner_pos:DistToSqr( ply_pos ) > 3200 then continue end

		attack_trace.start = owner_center
		attack_trace.endpos = ply_pos + ply:OBBCenter()

		if util.TraceLine( attack_trace ).Hit then continue end

		local dmg = DamageInfo()
		dmg:SetAttacker( owner )
		dmg:SetDamageType( DMG_DIRECT )
		dmg:SetDamage( ply:Health() )

		ply:TakeDamageInfo( dmg )
		owner:EmitSound( "SCP096.Attack" )

		if self.KillTimeLimit == 0 then
			self.KillTimeLimit = ct + self:GetUpgradeMod( "multi_time", 1 )
		end

		self.RageKills = self.RageKills + 1

		if self.RageKills >= kill_limit or lunge != 0 then
			self:StopRage( ply )
			return
		end
	end

	if !owner:HasEffect( "scp_chase" ) then return end

	local start = owner_pos + breach_offset
	local ang = owner:GetAngles()
	ang.p = 0
	ang.r = 0

	breach_trace.start = start
	breach_trace.endpos = start + ang:Forward() * 25
	breach_trace.filter = owner

	util.TraceHull( breach_trace )

	if !breach_trace.Hit or breach_trace.HitNormal.z >= 0.5 then return end

	local ent = breach_trace.Entity
	if !IsValid( ent ) then return end
	if self.EntityCache[ent] then return end

	self.EntityCache[ent] = true

	local door_ent = ent
	if door_ent:GetClass() == "prop_dynamic" then
		door_ent = door_ent:GetParent()
	end
	
	local class = door_ent:GetClass()
	if class_whitelist[class] then return end
	if class != "func_door" and class != "func_door_rotating" or IsDoorDestroyed( door_ent ) then return end

	if !DestroyDoor( door_ent, owner:GetAngles() ) then
		self.EntityCache[ent] = nil
	end
end

function SWEP:OnRemove()
	if SERVER then
		self:ResetState()
	end
end

function SWEP:TranslateActivity( act )
	if self:GetLunge() > CurTime() then
		return ACT_RUN_CROUCH
	end

	return self.ActTranslate[act] or -1
end

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end
	
	local rage = self:GetRage()
	local ct = CurTime()

	if rage <= 0 or rage >= ct or self:GetLunge() > 0 then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	owner:DisableControls( "scp096_lunge" )
	owner:SetVelocity( Vector( 0, 0, 100 ) )
	owner:SetPos( owner:GetPos() + Vector( 0, 0, 5 ) )
	self:SetLunge( ct + 0.5 )
end

function SWEP:Reload()
	if CLIENT or ROUND.preparing or ROUND.post then return end
	if self:GetRage() != 0 then return end

	local ct = CurTime()
	local regen = self:GetRegen()
	local owner = self:GetOwner()

	if regen == 0 and self:GetRegenStacks() > 0 and owner:Health() < owner:GetMaxHealth() then
		owner:DisableControls( "scp096_regen", IN_RELOAD )
		self:SetRegen( ct + self.RegenTransition )
	elseif regen > 0 and regen < ct then
		self:SetRegen( -ct - self.RegenTransition )
	end
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end
	
	local ct = CurTime()
	local rage = self:GetRage()
	if rage <= 0 or rage >= ct then return end
	if !self:CheckTargets() then return end

	self:SetRegenStacks( self:GetRegenStacks() + math.ceil( self:GetTargets() * 10 * self:GetUpgradeMod( "spec_mult", 1 ) ) )

	local sanity = self:GetUpgradeMod( "sanity" )
	if sanity then
		for k, v in pairs( self.Targets ) do
			if !istable( v ) then continue end

			k:TakeSanity( sanity, SANITY_TYPE.ANOMALY )
		end
	end

	self:SetRage( 0 )
	self:ResetState()

	self:SetNextSpecialAttack( ct + self.SpecialCooldown )
end

function SWEP:AddTarget( ply )
	if ROUND.post then return end

	local owner = self:GetOwner()
	local pos = ply:GetPos()
	local dist = owner:GetPos():Distance( pos ) + 1000

	self.Targets[ply] = { ply:TimeSignature(), pos, dist * dist, 0 }

	if self:GetRage() != 0 then return end

	TransmitSound( self.TriggeredSound, true, ply )

	owner:Freeze( true )
	self:SetRage( CurTime() + self.RegePreparing )
	self.RageReady = false

	owner:AddTimer( "SCP096RagePreparing", self.RegePreparing, 1, function()
		self:SetNextPrimaryFire( CurTime() + 3 )

		owner:SetSCPChase( true )
		owner:Freeze( false )
		owner:PushSpeed( 290, 290, -1, "SLC_SCP096Rage", 1 )

		self.RageReady = true
		self.RageKills = 0
		self.KillTimeLimit = 0
	end )
end

SWEP.NextNetwork = 0
function SWEP:CheckTargets()
	local ct = CurTime()
	local owner = self:GetOwner()
	local pos = owner:GetPos()

	local count = 0

	for ply, tab in pairs( self.Targets ) do
		if !IsValid( ply ) then
			self.Targets[ply] = nil
			continue
		elseif !istable( tab ) then
			continue
		elseif !ply:CheckSignature( tab[1] ) then
			self.Targets[ply] = nil
			continue
		end

		if tab[4] < ct then
			tab[4] = ct + 12
			TransmitSound( self.ChaseSound, true, ply )
		end

		local ply_pos = ply:GetPos()
		local origin = tab[2]
		local radius = tab[3]
		if ply_pos:DistToSqr( pos ) > radius and ( ply_pos:DistToSqr( origin ) > radius or pos:DistToSqr( origin ) > radius ) then
			self.Targets[ply] = nil
			continue
		end

		count = count + 1
	end

	if count == 0 then
		if self.RageKills > 0 then
			self:StopRage()
			return false
		elseif self:GetLunge() == 0 then
			self:SetRage( 0 )
			self:ResetState()
		end
	end

	self:SetTargets( count )

	if count > 0 and self.NextNetwork < ct then
		self.NextNetwork = ct + 0.5

		net.Start( "SLCSCP096Targets" )
		net.WriteUInt( count, 8 )

		for ply, _ in pairs( self.Targets ) do
			net.WritePlayer( ply )
			net.WriteVector( ply:GetPos() + ply:OBBCenter() )
		end

		net.Send( owner )
	end

	return count > 0
end

function SWEP:ResetState()
	for ply, _ in pairs( self.Targets ) do
		TransmitSound( self.ChaseSound, false, ply )
	end

	self.DamageLog = {}
	self.EntityCache = {}
	self.Targets = {}
	self.RageKills = 0
	self.KillTimeLimit = 0

	self:SetPassiveCooldown( CurTime() + self.RageCooldown )
	self:SetTargets( 0 )
	self:SetLunge( 0 )

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end
	
	owner:PopSpeed( "SLC_SCP096Rage", true )
	owner:StopSound( "SCP096.Scream" )
	owner:StopSound( "SCP096.Maul" )
	owner:StopDisableControls( "scp096_lunge" )

	owner:SetSCPChase( false )
	owner:InvalidateChase( true )
end

function SWEP:StopRage( ent )
	local ct = CurTime()
	local rage = self:GetRage()

	if rage == 0 or rage >= ct then return end

	local owner = self:GetOwner()
	local stun_time = self.RageStun

	self.Healing = false
	owner:Freeze( true )

	local heal_hp = self:GetUpgradeMod( "heal" )
	if ent and heal_hp and self:GetLunge() == 0 then
		self.Healing = true

		owner:DoAnimationEvent( ACT_GESTURE_FLINCH_HEAD )

		local heal_ticks = self:GetUpgradeMod( "heal_ticks" )
		local dur = owner:SequenceDuration( owner:SelectWeightedSequence( ACT_GESTURE_FLINCH_HEAD ) )

		if dur > stun_time then
			stun_time = dur
		end

		owner:AddHealth( heal_hp )

		owner:AddTimer( "SCP096Heal", dur / heal_ticks, heal_ticks, function( this, n )
			if n == heal_ticks or !IsValid( self ) or !self:CheckOwner() then return end

			owner:AddHealth( heal_hp )
			owner:EmitSound( "SCP096.Maul" )
		end, function( this )
			if !IsValid( self ) then return end

			self.Healing = false

			if IsValid( ent ) and IsValid( ent._RagEntity ) then
				ent._RagEntity:Remove()
			end
		end )
	end

	self:SetRage( -ct - stun_time )
	self:ResetState()

	local vel = owner:GetVelocity()
	if vel:LengthSqr() > 2500 then
		owner:SetVelocity( -vel )
	end
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "096" )
end

local regen_offet = Vector( 0, 0, -24 )
local rage_offet = Vector( 0, 0, -28 )
local regen_pitch = 45
local rege_pitch = 75

SWEP.RageStunFrac = 0
function SWEP:CalcView( ply, pos, ang, fov )
	local regen = self:GetRegen()
	local ct = CurTime()

	if regen != 0 then
		local f = 0

		if regen > 0 then
			f = math.Clamp( 1 - ( regen - ct ) / self.RegenTransition, 0, 1 )
		else
			f = math.Clamp( ( -regen - ct ) / self.RegenTransition, 0, 1 )
		end

		pos = pos + regen_offet * f
		ang.p = Lerp( f, ang.p, regen_pitch )

		return pos, ang
	end

	local rage = self:GetRage()
	if rage < 0 then
		self.RageStunFrac = math.Approach( self.RageStunFrac, 1, FrameTime() * 1.75 )
	else
		self.RageStunFrac = math.Approach( self.RageStunFrac, 0, FrameTime() * 2 )
	end

	if self.RageStunFrac > 0 then
		pos = pos + rage_offet * self.RageStunFrac
		ang.p = Lerp( self.RageStunFrac, ang.p, rege_pitch )
		return pos, ang
	end
end

SWEP.TargetsDieTime = 0
function SWEP:DrawSCPHUD()
	if self.TargetsDieTime <= CurTime() then return end

	surface.SetDrawColor( 255, 0, 0 )

	for i, v in ipairs( self.Targets ) do
		if !IsValid( v.ply ) then return end

		if v.ply:IsDormant() then
			local scr = v.pos:ToScreen()
			if !scr.visible then continue end

			SLCDrawRing( scr.x, scr.y, 6, 2)
		else
			table.insert( self.HaloTable, v.ply )
		end
	end
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP096") TransmitSCPHooks()
SCPHook( "SCP096", "EntityTakeDamage", function( ent, dmg )
	if CLIENT or dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP096 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local rage = wep:GetRage()
	if ( rage >= 0 or !wep.Healing ) and ( rage <= 0 or wep.KillTimeLimit == 0 ) then return end

	local prot = wep:GetUpgradeMod( "prot" )
	if !prot then return end

	dmg:ScaleDamage( prot )
end )

SCPHook( "SCP096", "SLCChase", function( ply, by )
	if by:SCPClass() != CLASSES.SCP096 then return end

	local wep = by:GetSCPWeapon()
	if !IsValid( wep ) then return end

	return !wep.Targets[ply]
end )

SCPHook( "SCP096", "PostEntityTakeDamage", function( ent, dmg )
	if !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP096 then return end

	local ct = CurTime()
	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetRage() < 0 or wep:GetPassiveCooldown() >= ct or wep:GetRegen() != 0 then return end

	local attacker = dmg:GetAttacker()
	if !IsValid( attacker ) or !attacker:IsPlayer() or attacker == ent or !wep:HasUpgrade( "rage" ) then return end
	
	if !wep.DamageLog[attacker] or wep.DamageLog[attacker][2] < ct then
		wep.DamageLog[attacker] = { 0, ct + wep:GetUpgradeMod( "rage_time" ) }
	end
	
	wep.DamageLog[attacker][1] = wep.DamageLog[attacker][1] + dmg:GetDamage()

	if wep.DamageLog[attacker][1] >= wep:GetUpgradeMod( "rage_dmg" ) then
		wep.DamageLog[attacker] = nil
		wep:AddTarget( attacker )
	end
end )

SCPHook( "SCP096", "CalcMainActivity", function ( ply, vel )
	if ply:SCPClass() != CLASSES.SCP096 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local ct = CurTime()

	local regen = wep:GetRegen()
	if regen > 0 then
		ply:SetCycle( math.Clamp( 1 - ( regen - ct ) / wep.RegenTransition, 0, 1 ) * 0.5 )
		return ACT_COWER, -1
	elseif regen < 0 then
		ply:SetCycle( math.Clamp( ( -regen - ct ) / wep.RegenTransition, 0, 1 ) * 0.5 )
		return ACT_COWER, -1
	end

	local rage = wep:GetRage()
	if rage > ct then
		ply:SetPlaybackRate( 0.5 )
		return ACT_IDLE_ANGRY, -1
	elseif rage < 0 then
		//if wep:GetLunge() == 0 and wep:HasUpgrade( "heal1" ) then
			//return ACT_GESTURE_FLINCH_HEAD, -1
		//else
			ply:SetCycle( math.Clamp( ( wep.RageStun + rage + ct ) / ply:SequenceDuration( ply:SelectWeightedSequence( ACT_GESTURE_MELEE_ATTACK1 ) ), 0, 1 ) * 0.9 )
			return ACT_GESTURE_MELEE_ATTACK1, -1
		//end
	end
end )

SCPHook( "SCP096", "SLCMovementAnimSpeed", function( ply, vel, speed, len, movement )
	if ply:SCPClass() != CLASSES.SCP096 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetRage() != 0 then return end

	return ply:Crouching() and 1.5 or 2.2, true
end )

SCPHook( "SCP096", "SLCPlayerFootstep", function( ply, foot, snd )
	if ply:SCPClass() != CLASSES.SCP096 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end
	if wep:GetRage() != 0 then return true end
end )

SCPHook( "SCP096", "SLCFootstepParams", function( ply, st, vel, crouch )
	if ply:SCPClass() != CLASSES.SCP096 then return end

	local units = 65

	if crouch then
		units = units - 30
	end

	return units
end )

if CLIENT then
	net.Receive( "SLCSCP096Targets", function( len )
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP096 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep.Targets = {}
		wep.TargetsPositions = {}
		wep.TargetsDieTime = CurTime() + 1.5

		for i = 1, net.ReadUInt( 8 ) do
			wep.Targets[i] = { ply = net.ReadPlayer(), pos = net.ReadVector() }
		end
	end )

	local color_red = Color( 255, 0, 0 )
	SCPHook( "SCP096", "PreDrawHalos", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP096 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or #wep.HaloTable == 0 then return end

		halo.Add( wep.HaloTable, color_red, 3, 3, 1, true, true )
		wep.HaloTable = {}
	end )

	local overlay = GetMaterial( "slc/scp/096overlay" )
	SCPHook( "SCP096", "SLCScreenMod", function( clr )
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP096 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetRage() <= 0 then return end

		surface.SetMaterial( overlay )
		surface.SetDrawColor( 255, 0, 0, 150 )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

		clr.colour = clr.colour
		clr.brightness = clr.brightness
		clr.contrast = clr.contrast + 0.15
		clr.add_g = -0.02
		clr.add_r = -0.0
		clr.add_b = -0.02
		clr.mul_r = 0.2
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/096/passive.png", "smooth" )
	icons.heal = GetMaterial( "slc/hud/upgrades/scp/096/heal.png", "smooth" )
	icons.regen = GetMaterial( "slc/hud/upgrades/scp/096/regen.png", "smooth" )
	icons.special = GetMaterial( "slc/hud/upgrades/scp/096/special.png", "smooth" )
end

DefineUpgradeSystem( "scp096", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "rage", cost = 1, req = {}, reqany = false, pos = { 1.5, 1 },
			mod = { rage_dmg = 100, rage_time = 10 }, icon = icons.passive, active = false },

		{ name = "heal1", cost = 1, req = { "rage" }, block = { "multi1" }, reqany = false, pos = { 1, 2 },
			mod = { heal = 110, heal_ticks = 3, prot = 0.7 }, icon = icons.heal, active = false },
		{ name = "heal2", cost = 2, req = { "heal1" }, reqany = false, pos = { 1, 3 },
			mod = { heal = 100, heal_ticks = 5, prot = 0.35 }, icon = icons.heal, active = false },

		{ name = "multi1", cost = 2, req = { "rage" }, block = { "heal1" }, reqany = false, pos = { 2, 2 },
			mod = { multi = 2, multi_time = 5, prot = 1.4 }, icon = icons.passive, active = false },
		{ name = "multi2", cost = 3, req = { "multi1" }, reqany = false, pos = { 2, 3 },
			mod = { multi = 3, multi_time = 10, prot = 1.9 }, icon = icons.passive, active = false },

		{ name = "regen1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { regen_mult = 1.75 }, icon = icons.regen, active = false },
		{ name = "regen2", cost = 2, req = { "regen1" }, reqany = false, pos = { 3, 2 },
			mod = { regen_stacks = 0.8 }, icon = icons.regen, active = false },
		{ name = "regen3", cost = 2, req = { "regen2" }, reqany = false, pos = { 3, 3 },
			mod = { regen_mult = 2.6, regen_stacks = 0.6 }, icon = icons.regen, active = false },

		{ name = "spec1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { spec_mult = 1.75, sanity = 10 }, icon = icons.special, active = false },
		{ name = "spec2", cost = 2, req = { "spec1" }, reqany = false, pos = { 4, 2 },
			mod = { spec_mult = 3, sanity = 30 }, icon = icons.special, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --12/14 + 1 points -> ~60% = 10 (-1 base) = 9 points
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 1 },
		{ 4, 1 },
		{ 5, 1 },
		{ 6, 1 },
		{ 7, 1 },
		{ 8, 1 },
		{ 10, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP096", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "lunge" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/096/lunge.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
		:SetActiveFunction( function( swep )
			local rage = swep:GetRage()
			return rage > 0 and rage < CurTime()
		end )

	hud:AddSkill( "regen" )
		:SetButton( "reload" )
		:SetMaterial( "slc/hud/scp/096/regen.png", "smooth" )
		:SetCooldownFunction( "GetNextRegen" )
		:SetTextFunction( "GetRegenStacks" )
		:SetActiveFunction( function( swep )
			return swep:GetRegenStacks() > 0
		end )

	hud:AddSkill( "special" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/096/special.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetTextFunction( "GetTargets" )
		:SetActiveFunction( function( swep )
			local rage = swep:GetRage()
			return rage > 0 and rage < CurTime()
		end )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/096/passive.png", "smooth" )
		:SetCooldownFunction( "GetPassiveCooldown" )
		:SetActiveFunction( function( swep )
			local rage = swep:GetRage()
			return rage > 0 and rage < CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add{
	name = "SCP096.Attack",
	volume = 1,
	level = 80,
	pitch = 100,
	sound = "scp_lc/scp/096/attack1.ogg",
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP096.Maul",
	volume = 1,
	level = 80,
	pitch = 100,
	sound = "scp_lc/scp/096/attack2.ogg",
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP096.Scream",
	volume = 1,
	level = 100,
	pitch = 100,
	sound = "scp_lc/scp/096/scream.ogg",
	channel = CHAN_STATIC,
}