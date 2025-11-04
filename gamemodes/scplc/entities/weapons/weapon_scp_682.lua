SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-682"

SWEP.HoldType		= "normal"

SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage 	= true

SWEP.BasicCooldown = 2
SWEP.BasicDamage = 30
SWEP.BasicRange = 80

SWEP.BiteCooldown = 20
SWEP.BiteDamageMin = 1
SWEP.BiteDamageMax = 90
SWEP.BiteAngle = math.pi * 2 / 5 -- 2/5pi = 72 deg
SWEP.BiteAngleCos = math.cos( SWEP.BiteAngle / 2 ) --Don't change! - used for hit detection (dot >= BiteAngleCos)
SWEP.BiteRangeMin = 30
SWEP.BiteRangeMax = 140
SWEP.PrepareTime = 3
SWEP.PrepareSpeed = 0.35

SWEP.ChargeCooldown = 90

SWEP.DefaultShield = 900
SWEP.ShieldCooldown = 60

local STATE_NONE = 0
local STATE_STUNNED = 1

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Bool", "Charging" )
	self:NetworkVar( "Int", "State" )
	self:NetworkVar( "Float", "ShieldCooldown" )
	self:NetworkVar( "Float", "Shield" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP682" )
	self:InitializeHUD()

	self:SetShieldCooldown( CurTime() + 90 )
end

function SWEP:TranslateActivity( act )
	if act == ACT_MP_WALK or act == ACT_MP_RUN then
		return controller.IsEnabled( self:GetOwner() ) and ACT_HL2MP_RUN or ACT_HL2MP_WALK
	end

	if self.ActivityTranslate[act] != nil then
		return self.ActivityTranslate[act]
	end

	return -1
end

local trace_tab = {}
trace_tab.mins = Vector( -12, -12, -32 )
trace_tab.maxs = Vector( 12, 12, 32 )
trace_tab.mask = bit.bor( CONTENTS_HITBOX, CONTENTS_MONSTER, CONTENTS_MOVEABLE, CONTENTS_GRATE, CONTENTS_WINDOW, CONTENTS_SOLID, CONTENTS_PLAYERCLIP, CONTENTS_MONSTERCLIP )
trace_tab.output = trace_tab

local trace_offset = Vector( 0, 0, 48 )
local class_whitelist = {
	prop_ragdoll = true
}

local collision_group_whitelist = {
	[COLLISION_GROUP_WEAPON] = true,
	[COLLISION_GROUP_DEBRIS] = true,
	[COLLISION_GROUP_DEBRIS_TRIGGER] = true,
	[COLLISION_GROUP_WORLD] = true,
}

SWEP.NextThinkTime = 0
SWEP.NextRegen = 0
function SWEP:Think()
	local owner = self:GetOwner()
	
	if CLIENT and self:GetCharging() and !controller.IsEnabled( owner ) then
		controller.Start( owner, "scp682_charge" )
	end
	
	owner:UpdateHold( self, "scp682_bite" )

	if CLIENT then return end

	self:ShieldThink()
	self:ChargeThink()
end

function SWEP:ShieldThink()
	local ct = CurTime()
	local owner = self:GetOwner()
	local shield_cd = self:GetShieldCooldown()

	if shield_cd > 0 and shield_cd < ct then
		self:SetShieldCooldown( 0 )

		if self:HasUpgrade( "shield_c" ) then
			self:SetShield( owner:GetMaxHealth() )
		else
			self:SetShield( self.DefaultShield * self:GetUpgradeMod( "shield", 1 ) )
		end
	elseif shield_cd > 0 and self:HasUpgrade( "shield_b" ) and self.NextRegen <= ct then
		self.NextRegen = self.NextRegen + 1

		if self.NextRegen <= ct then
			self.NextRegen = ct + 1
		end

		owner:AddHealth( self:GetUpgradeMod( "shield_regen" ) )
	end
end

function SWEP:ChargeThink()
	local ct = CurTime()
	local owner = self:GetOwner()

	if !self:GetCharging() and !controller.IsEnabled( owner ) then return end
	
	local start = owner:GetPos() + trace_offset
	local ang = owner:GetAngles()
	ang.p = 0
	ang.r = 0

	trace_tab.start = start
	trace_tab.endpos = start + ang:Forward() * 50
	trace_tab.filter = owner

	owner:LagCompensation( true )
	util.TraceHull( trace_tab )
	owner:LagCompensation( false )

	if !trace_tab.Hit or trace_tab.HitNormal.z >= 0.5 then return end

	local ent = trace_tab.Entity
	if IsValid( ent ) then
		if self.EntityCache[ent] then return end
		self.EntityCache[ent] = true

		if ent.SCPIgnore or collision_group_whitelist[ent:GetCollisionGroup()] then return end

		if ( ent.SCPBreakable or ent:GetClass() == "func_breakable" ) and self.FullSpeed then
			ent:TakeDamage( ent:Health(), owner )
			return
		end

		local door_ent = ent
		if door_ent:GetClass() == "prop_dynamic" then
			door_ent = door_ent:GetParent()
		end
		
		local class = door_ent:GetClass()
		if class_whitelist[class] then return end
		if ( class == "func_door" or class == "func_door_rotating" ) and
			( self.FullSpeed and DestroyDoor( door_ent, owner:GetAngles() ) or IsDoorDestroyed( door_ent ) ) then return end

		if ent:IsPlayer() then
			if !self:CanTargetPlayer( ent ) then return end

			ent:SetVelocity( trace_tab.Normal * 500 )
			
			local dmg = DamageInfo()
			dmg:SetAttacker( owner )
			
			if self.FullSpeed then
				dmg:SetDamageType( DMG_DIRECT )
				dmg:SetDamage( ent:Health() )
			else
				dmg:SetDamageType( DMG_CRUSH )
				dmg:SetDamage( owner:GetVelocity():Length() / 15 )
			end

			ent:TakeDamageInfo( dmg )

			if !ent:Alive() and IsValid( ent._RagEntity ) and IsValid( ent._RagEntity:GetPhysicsObject() ) then
				ent._RagEntity:GetPhysicsObject():SetVelocity( trace_tab.Normal * 3000 )
			end

			return
		end
	end

	controller.Stop( owner )
	self:SetCharging( false )
	self:SetNextSpecialAttack( ct + self.ChargeCooldown * self:GetUpgradeMod( "charge_cd", 1 ) )

	util.ScreenShake( trace_tab.HitPos, 10, 40, 2, 800, true )
	owner:EmitSound( "SCP682.Impact" )

	self:SetNextPrimaryFire( ct + 10 )

	if self:GetNextSecondaryFire() - 10 < ct then
		self:SetNextSecondaryFire( ct + 10 )
	end

	self:SetState( STATE_STUNNED )
	owner:DisableControls( "scp682_stun", CAMERA_MASK )
	owner:PushSpeed( 0.4, 0.4, -1, "SLC_SCP682Penalty", 1 )
	
	owner:AddTimer( "SCP682ChargeStun", 4 * self:GetUpgradeMod( "charge_stun", 1 ), 1, function()
		self:SetState( STATE_NONE )
		owner:StopDisableControls( "scp682_stun" )
		owner:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
	end )

	owner:AddTimer( "SCP682ChargeSlow", 10 * self:GetUpgradeMod( "charge_stun", 1 ), 1, function()
		owner:PopSpeed( "SLC_SCP682Penalty" )
	end )

	owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, owner:LookupSequence( "stun" ), 0, false )
end

local attack_trace = {}
attack_trace.mins = Vector( -8, -8, -8 )
attack_trace.maxs = Vector( 8, 8, 8 )
attack_trace.mask = MASK_SHOT
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end

	local owner = self:GetOwner()
	if controller.IsEnabled( owner ) or owner:IsHolding( self, "scp682_bite" ) then return end

	self:SetNextPrimaryFire( CurTime() + self.BasicCooldown * self:GetUpgradeMod( "prim_cd", 1 ) )
	owner:SetAnimation( PLAYER_ATTACK1 )

	attack_trace.start = owner:GetShootPos()
	attack_trace.endpos = attack_trace.start + owner:GetAimVector() * self.BasicRange
	attack_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceHull( attack_trace )
	owner:LagCompensation( false )

	if attack_trace.HitWorld then
		self:EmitSound( "npc/zombie/claw_strike3.wav" )
		return
	end

	local ent = attack_trace.Entity
	if IsValid( ent ) then 
		self:EmitSound( "npc/zombie/claw_strike3.wav" )
		if CLIENT then return end

		if ent:IsPlayer() then
			if !self:CanTargetPlayer( ent ) then return end
			ent:TakeDamage( self.BasicDamage + self:GetUpgradeMod( "prim_dmg", 0 ), owner, owner )

			if self:HasUpgrade( "attack_3" ) then
				ent:ApplyEffect( "bleeding", owner )
			end
		else
			self:SCPDamageEvent( ent, 50 )
		end
	else
		self:EmitSound( "SCP682.AttackMiss" )
	end
end

function SWEP:SecondaryAttack()
	if ROUND.preparing or ROUND.post then return end

	local owner = self:GetOwner()
	if controller.IsEnabled( owner ) or owner:IsHolding( self, "scp682_bite" ) then return end

	owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_SECONDARY, 1001 )

	local time = self.PrepareTime
	owner:StartHold( self, "scp682_bite", IN_ATTACK2, time, function()
		self:PerformBiteAttack()
	end, true )
end

local bite_offset = Vector( 0, 0, 32 )
local bite_trace = {}
bite_trace.mask = MASK_SOLID_BRUSHONLY
bite_trace.output = bite_trace

function SWEP:PerformBiteAttack()
	local ct = CurTime()
	self:SetNextSecondaryFire( ct + self.BiteCooldown )
	
	if self:GetNextPrimaryFire() - 2.5 < ct then
		self:SetNextPrimaryFire( ct + 2.5 )
	end

	if self:GetNextSpecialAttack() - 2.5 < ct then
		self:SetNextSpecialAttack( ct + 2.5 )
	end

	local owner = self:GetOwner()
	owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_SECONDARY, 1002 )
	//owner:DoAnimationEvent( ACT_SPECIAL_ATTACK2 )
	owner:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE )

	self:EmitSound( "SCP682.Bite" )

	if CLIENT then return end

	owner:DisableControls( "scp682_bite" )

	owner:AddTimer( "SCP682Bite", 1.75, 1, function()
		owner:StopDisableControls( "scp682_bite" )
	end )

	local pct = owner:HoldProgress( self, "scp682_bite" )
	local pos = owner:GetPos()
	local ang = owner:GetAngles()
	
	ang.p = 0
	ang.r = 0
	local forward = ang:Forward()
	
	local dmg = math.Map( pct, 0, 1, self.BiteDamageMin, self.BiteDamageMax )
	local has_upgrade = self:HasUpgrade( "attack_3" )

	local min_range_square = self.BiteRangeMin ^ 2
	local max_range_square = math.Map( pct, 0, 1, self.BiteRangeMin, self.BiteRangeMax * self:GetUpgradeMod( "sec_range", 1 ) ) ^ 2
	local max_dot = self.BiteAngleCos

	bite_trace.start = pos + bite_offset
	bite_trace.filter = owner

	owner:LagCompensation( true )

	for i, v in ipairs( player.GetAll() ) do
		if v == owner or !self:CanTargetPlayer( v ) then continue end

		local ply_pos = v:GetPos()
		local diff = ply_pos - pos
		if math.abs( diff.z ) > 48 then continue end

		diff:Normalize()
		local dist_sqr = ply_pos:Distance2DSqr( pos )

		if dist_sqr < min_range_square or dist_sqr > max_range_square or forward:Dot( diff ) < max_dot then continue end

		bite_trace.endpos = ply_pos + bite_offset
		util.TraceLine( bite_trace )

		if bite_trace.Hit then continue end

		v:TakeDamage( dmg, owner, owner )

		if has_upgrade then
			v:ApplyEffect( "bleeding", owner )

			if pct >= 1 and !v:HasEffect( "fracture" ) then
				v:ApplyEffect( "fracture" )
			end
		end
	end

	owner:LagCompensation( false )
end

function SWEP:SpecialAttack()
	local owner = self:GetOwner()
	if CLIENT or ROUND.preparing or ROUND.post or !owner:IsOnGround() or !self:HasUpgrade( "charge_1" ) or owner:IsHolding( self, "scp682_bite" ) then return end
	
	self.FullSpeed = false

	if self:GetCharging() then
		local ct = CurTime()
		self:SetCharging( false )
		self:SetNextSpecialAttack( ct + self.ChargeCooldown * self:GetUpgradeMod( "charge_cd", 1 ) )
		self:SetNextPrimaryFire( ct + 3 )

		if self:GetNextSecondaryFire() - 3 < ct then
			self:SetNextSecondaryFire( ct + 3 )
		end

		return
	end

	self.EntityCache = {}
	owner:EmitSound( "SCP682.Roar" )

	owner:DoAnimationEvent( ACT_GESTURE_FLINCH_RIGHTARM )
	owner:DisableControls( "scp682_charge" )
	
	local dur = owner:SequenceDuration( owner:SelectWeightedSequence( ACT_GESTURE_FLINCH_RIGHTARM ) )
	self:SetNextSpecialAttack( CurTime() + dur + 5 )
	
	owner:AddTimer( "SCP682Charge", dur, 1, function()
		owner:StopDisableControls( "scp682_charge" )

		self:SetCharging( true )
		controller.Start( owner, "scp682_charge" )
	end )
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "682" )
end

function SWEP:OnUpgradeBought( name, active, group )
	if group == "shield" then
		if CLIENT then
			self.HUDObject:GetSkill( "shield" ):SetMaterialOverride( active[1] )

			local bar = self.HUDObject:GetBar( "shield_bar" )
			bar:SetMaterialOverride( active[1] )
			bar:SetColorOverride( active[2] )
		end

		if self:GetShield() == self.DefaultShield then
			self:SetShieldCooldown( CurTime() )
		end
	elseif group == "sec" then
		self.CachedPolys = nil
	end
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP682") TransmitSCPHooks()
SCPHook( "SCP682", "SLCPostScaleDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or dmg:IsDamageType( DMG_FALL ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP682 then return end
	if ROUND.preparing and dmg:IsDamageType( DMG_ACID ) then return true end

	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local att = dmg:GetAttacker()
	local valid_att = IsValid( att ) and att:IsPlayer() and att != target

	local ct = CurTime()
	local cd = wep:GetShieldCooldown()
	local apply_cdr = valid_att and cd > ct and wep:HasUpgrade( "shield_2" )

	local shield = wep:GetShield()
	if shield <= 0 then
		if apply_cdr then
			wep:SetShieldCooldown( cd - wep:GetUpgradeMod( "shield_cdr" ) * dmg:GetDamage() )
		end

		return
	end

	local has_b = wep:HasUpgrade( "shield_b" )
	local has_c = wep:HasUpgrade( "shield_c" )
	local has_d = wep:HasUpgrade( "shield_d" )

	local orig = dmg:GetDamage()
	if orig <= 0 then return end

	local to_block = orig

	if has_d then
		to_block = math.ceil( to_block * wep:GetUpgradeMod( "shield_pct" ) )
	end

	if to_block > orig then
		to_block = orig
	end

	if to_block > shield then
		to_block = shield
	end
	
	shield = shield - to_block

	local new_dmg = orig - to_block

	dmg:SetDamage( new_dmg )
	wep:SetShield( shield )

	if apply_cdr and new_dmg > 0 then
		wep:SetShieldCooldown( cd - wep:GetUpgradeMod( "shield_cdr" ) * new_dmg )
	end

	local owner = wep:GetOwner()

	local inflictor = dmg:GetInflictor()
	if has_d and valid_att and wep:CanTargetPlayer( att ) and ( !IsValid( inflictor ) or inflictor:GetClass() != "slc_turret" ) then
		att:TakeDamage( to_block * wep:GetUpgradeMod( "reflect_pct" ), owner, owner )
	end

	if ( !has_b and !has_c and !has_d or shield == 0 ) and cd == 0 then
		wep:SetShieldCooldown( ct + wep.ShieldCooldown * wep:GetUpgradeMod( "shield_cd", 1 ) )

		if has_c then
			local new_max = owner:GetMaxHealth() - wep:GetUpgradeMod( "shield_hp" )
			if new_max < 100 then
				new_max = 100
			end

			owner:SetMaxHealth( new_max )

			if owner:Health() > new_max then
				owner:SetHealth( new_max )
			end
		end
	end

	if shield == 0 then
		if wep:HasUpgrade( "shield_1" ) then
			local speed = wep:GetUpgradeMod( "shield_speed_pow" )
			owner:PushSpeed( speed, speed, -1, "SLC_SCP682Boost" )

			owner:AddTimer( "SCP682Boost", wep:GetUpgradeMod( "shield_speed_dur" ), 1, function()
				owner:PopSpeed( "SLC_SCP682Boost" )
			end )
		end

		//owner:DoAnimationEvent( ACT_GESTURE_BIG_FLINCH )
		timer.Simple( 0, function() --Jump out of prediction
			owner:DoCustomAnimEvent( PLAYERANIMEVENT_CUSTOM_GESTURE_SEQUENCE, 1001 )
		end )
	end
end )

SCPHook( "SCP682", "SLCScaleSpeed", function( ply, mod )
	if ply:SCPClass() != CLASSES.SCP682 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or !ply:IsHolding( wep, "scp682_bite" ) then return end
	
	local f = ply:HoldProgress( wep, "scp682_bite" )

	mod[1] = mod[1] * math.Map( f, 0, 1, 0.75, wep.PrepareSpeed * wep:GetUpgradeMod( "sec_speed", 1 ) )
end )

SCPHook( "SCP682", "CalcMainActivity", function( ply, vel )
	if ply:SCPClass() != CLASSES.SCP682 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local state = wep:GetState()
	if state == STATE_NONE then return end

	if state == STATE_STUNNED then
		return ACT_INVALID, ply:LookupSequence( "stun" )
	end
end )

SCPHook( "SCP682", "DoAnimationEvent", function( ply, event, data )
	if ply:SCPClass() != CLASSES.SCP682 then return end

	if event == PLAYERANIMEVENT_CUSTOM_GESTURE_SEQUENCE and data == 1001 then
		ply:AnimRestartGesture( GESTURE_SLOT_FLINCH, ACT_GESTURE_BIG_FLINCH, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_FLINCH, 0.6 )

		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY and data == 1001 then
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence( "prepare_custom1" ), 0, false )
		ply:AnimSetGestureWeight( GESTURE_SLOT_ATTACK_AND_RELOAD, 0.65 )

		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY and data == 1002 then
		ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
		
		return ACT_INVALID
	end
end )

SCPHook( "SCP682", "SLCMovementAnimSpeed", function( ply, vel, speed, len, movement )
	if ply:SCPClass() != CLASSES.SCP682 or !controller.IsEnabled( ply ) then return end
	return 1 + math.Clamp( len - 160, 0, 300 ) / 400, true
end )

SCPHook( "SCP682", "SLCPlayerFootstep", function( ply, foot, snd )
	if ply:SCPClass() != CLASSES.SCP682 then return end
	ply:EmitSound( "SCP682.Step" )
	return true
end )

SCPHook( "SCP682", "SLCFootstepParams", function( ply, st, vel, crouch )
	if ply:SCPClass() != CLASSES.SCP682 then return end

	local units = controller.IsEnabled( ply ) and 85 or 50
	local len = vel:Length()

	if len > 125 then
		units = units + len / 5
	end

	if crouch then
		units = units - 20
	end

	return units
end )

local function gen_polys( r1, r2, ang, offset, steps )
	local step_ang = ang / ( steps - 1 )

	local p1 = { { x = 0, y = 0 } }
	local p2 = { { x = 0, y = 0 } }

	for i = 0, steps - 1 do
		local sin = math.sin( i * step_ang + offset )
		local cos = -math.cos( i * step_ang + offset )

		p1[i + 2] = {x = sin * r1, y = cos * r1}
		p2[i + 2] = {x = sin * r2, y = cos * r2}
	end

	return { p1, p2 }
end

if CLIENT then
	SCPHook( "SCP682", "ScalePlayerDamage", function( ply, group, dmg )
		if !IsValid( ply ) or ply:SCPClass() != CLASSES.SCP682 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetShield() <= 0 then return end

		return true --Remove blood when shield is up
	end )

	local draw_offset = Vector( 0, 0, 6 )
	SCPHook( "SCP682", "PostDrawTranslucentRenderables", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP682 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or !ply:IsHolding( wep, "scp682_bite" ) then return end

		local f = ply:HoldProgress( wep, "scp682_bite" )

		local ang = ply:GetAngles()
		ang.p = 0
		ang.r = 0

		local pos = ply:GetPos() + draw_offset
		
		ang.y = ang.y - 90

		local offset = -wep.BiteAngle / 2
		local steps = 10
		local r1 = wep.BiteRangeMin
		local r2 = wep.BiteRangeMax * wep:GetUpgradeMod( "sec_range", 1 )

		local polys = wep.CachedPolys
		if !polys then
			polys = gen_polys( r1, r2, wep.BiteAngle, offset, steps )
			wep.CachedPolys = polys
		end

		local poly
		if f == 1 then
			poly = polys[2]
		else
			poly = { { x = 0, y = 0 } }
			
			local r3 = r1 + ( r2 - r1 ) * f
			local step_ang = wep.BiteAngle / ( steps - 1 )

			for i = 0, steps - 1 do
				local sin = math.sin( i * step_ang + offset )
				local cos = -math.cos( i * step_ang + offset )
		
				poly[i + 2] = {x = sin * r3, y = cos * r3}
			end
		end
		
		cam.Start3D2D( pos, ang, 1 )
			draw.NoTexture()
			surface.SetDrawColor( 225, 35, 35, 20 )

			render.ClearStencil()

			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )

			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.SetStencilFailOperation( STENCIL_REPLACE )

			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilReferenceValue( 1 )

			render.SetStencilEnable( true )

			surface.DrawPoly( polys[1] )

			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilCompareFunction( STENCIL_NOTEQUAL )

			surface.DrawPoly( polys[2] )

			surface.SetDrawColor( 225, 35, 35, 60 )
			surface.DrawPoly( poly )

			render.SetStencilEnable( false )
		cam.End3D2D()
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.shield = GetMaterial( "slc/hud/upgrades/scp/682/shield.png", "smooth" )
	icons.shield_a = GetMaterial( "slc/hud/upgrades/scp/682/shield_a.png", "smooth" )
	icons.shield_b = GetMaterial( "slc/hud/upgrades/scp/682/shield_b.png", "smooth" )
	icons.shield_c = GetMaterial( "slc/hud/upgrades/scp/682/shield_c.png", "smooth" )
	icons.shield_d = GetMaterial( "slc/hud/upgrades/scp/682/shield_d.png", "smooth" )
	icons.attack1 = GetMaterial( "slc/hud/upgrades/scp/682/attack1.png", "smooth" )
	icons.attack2 = GetMaterial( "slc/hud/upgrades/scp/682/attack2.png", "smooth" )
	icons.attack3 = GetMaterial( "slc/hud/upgrades/scp/682/attack3.png", "smooth" )
	icons.charge = GetMaterial( "slc/hud/upgrades/scp/682/charge.png", "smooth" )
end

DefineUpgradeSystem( "scp682", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "shield_a", cost = 2, req = {}, block = { "shield_b", "shield_c", "shield_d" }, reqany = false, pos = { 1, 1 }, // Empowered
			mod = { shield = 1.6, shield_cd = 1.15 }, icon = icons.shield_a, active = { icons.shield_a }, group = "shield" },
		{ name = "shield_b", cost = 2, req = {}, block = { "shield_a", "shield_c", "shield_d" }, reqany = false, pos = { 1, 2 }, // Regen
			mod = { shield = 0.8, shield_cd = 1.4, shield_regen = 6 }, icon = icons.shield_b, active = { icons.shield_b, Color( 20, 157, 20 ) }, group = "shield" },
		{ name = "shield_c", cost = 2, req = {}, block = { "shield_a", "shield_b", "shield_d" }, reqany = false, pos = { 1, 3 }, // Sacri
			mod = { shield_cd = 0.5, shield_hp = 500 }, icon = icons.shield_c, active = { icons.shield_c, Color( 183, 0, 0 ) }, group = "shield" },
		{ name = "shield_d", cost = 2, req = {}, block = { "shield_a", "shield_b", "shield_c" }, reqany = false, pos = { 1, 4 }, // Refelct
			mod = { shield = 0.6, shield_cd = 1.25, shield_pct = 0.4, reflect_pct = 0.35 }, icon = icons.shield_d, active = { icons.shield_d, Color( 173, 0, 163 ) }, group = "shield" },

		{ name = "shield_1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { shield_speed_pow = 1.2, shield_speed_dur = 20 }, icon = icons.shield, active = false },
		{ name = "shield_2", cost = 2, req = { "shield_1" }, reqany = false, pos = { 2, 2 }, icon = icons.shield,
			mod = { shield_speed_pow = 1.5, shield_speed_dur = 60, shield_cdr = 0.02 }, active = false },

		{ name = "attack_1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { prim_cd = 0.6, prim_dmg = 10 }, icon = icons.attack1, active = false },
		{ name = "attack_2", cost = 2, req = {}, reqany = false, pos = { 4, 1 },
			mod = { sec_range = 1.2, sec_speed = 1.15 }, icon = icons.attack2, active = true, group = "sec" },
		{ name = "attack_3", cost = 3, req = { "attack_1", "attack_2" }, reqany = false, pos = { 3.5, 2 },
			mod = {}, icon = icons.attack3, active = false },

		{ name = "charge_1", cost = 1, req = {}, reqany = false, pos = { 3, 3 },
			mod = {}, icon = icons.charge, active = false },
		{ name = "charge_2", cost = 1, req = { "charge_1" }, reqany = false, pos = { 3, 4 }, icon = icons.charge,
			mod = { charge_cd = 0.6, charge_stun = 0.5 }, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --13 + 1 points -> 60% = 10 (-1 base) = 9 points
		{ 75, 1 },
		{ 150, 1 },
		{ 250, 1 },
		{ 350, 1 },
		{ 450, 1 },
		{ 550, 1 },
		{ 700, 1 },
		{ 850, 1 },
		{ 1050, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP682", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "primary" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/682/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "secondary" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/682/bite.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	hud:AddSkill( "charge" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/682/charge.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetActiveFunction( function( swep )
			return swep:HasUpgrade( "charge_1" )
		end )

	hud:AddSkill( "shield" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/682/shield.png", "smooth" )
		:SetCooldownFunction( "GetShieldCooldown" )

	hud:AddBar( "shield_bar" )
		:SetMaterial( "slc/hud/scp/682/shield.png", "smooth" )
		:SetColor( Color( 110, 40, 205) )
		:SetTextFunction( function( swep )
			return math.Round( swep:GetShield() )
		end )
		:SetProgressFunction( function( swep )
			local max_shield

			if swep:HasUpgrade( "shield_c" ) then
				max_shield = swep:GetOwner():GetMaxHealth()
			else
				max_shield = swep.DefaultShield * swep:GetUpgradeMod( "shield", 1 )
			end

			return swep:GetShield() / max_shield
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetShield() > 0
		end )
end

--[[-------------------------------------------------------------------------
Charge controller
---------------------------------------------------------------------------]]
controller.Register( "scp682_charge", {
	StartCommand = function( self, ply, cmd )
		if !self.Angle then
			self.Angle = cmd:GetViewAngles()
		end

		local ang = cmd:GetViewAngles()
		local diff = ang - self.Angle
		diff:Normalize()

		local abs_diff = math.sqrt( diff.y * diff.y + diff.p * diff.p )
		local max_diff = 18 * FrameTime()

		if abs_diff > max_diff then
			diff:Div( abs_diff / max_diff, max_diff )
		end

		self.Angle:Add( diff )

		cmd:SetViewAngles( self.Angle )
		cmd:ClearButtons()
		cmd:ClearMovement()
	end,
	Move = function( self, ply, mv )
		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		if !self.Speed then
			self.Speed = 0
		end

		local max_speed = 600
		local charging = wep:GetCharging()

		if charging and self.Speed < max_speed then
			self.Speed = self.Speed + 325 * FrameTime()
			self.FullSpeed = false

			if self.Speed > max_speed then
				self.Speed = max_speed
				wep.FullSpeed = true
			end
		elseif !charging then
			self.Speed = self.Speed - 400 * FrameTime()
			self.FullSpeed = false

			if self.Speed < 0 then
				self.Speed = 0
				self:Stop()
			end
		end
		
		local ang = mv:GetAngles()
		ang.p = 0
		ang.r = 0

		local vel = ang:Forward() * self.Speed 

		if !self.Gravity then
			self.Gravity = Vector( 0 )
		end

		if ply:IsOnGround() then
			self.Gravity:Zero()
		else
			self.Gravity = self.Gravity + physenv.GetGravity() * FrameTime()
		end

		mv:SetVelocity( vel + self.Gravity )
	end,
} )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "SCP682.Roar",
	volume = 1,
	level = 90,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/682/roar.ogg",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP682.AttackMiss",
	volume = 1,
	level = 75,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/682/attack_miss.ogg",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP682.Bite",
	volume = 1,
	level = 75,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/682/bite.ogg",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP682.Impact",
	volume = 1,
	level = 85,
	pitch = 100,
	sound = "ambient/levels/outland/OL03Railcar_Imp01.wav",
	channel = CHAN_STATIC,
} )

AddSounds( "SCP682.Step", "scp_lc/scp/682/footstep_%i_n.ogg", 80, 0.8, { 90, 110 }, CHAN_STATIC, 1, 2 )