SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-049"

SWEP.HoldType		= "normal"
SWEP.UseCustomDT 	= true

SWEP.DisableDamageEvent = true

SWEP.PassiveRadius = 2000 ^ 2

SWEP.SurgeryTime = 15

SWEP.ChokeCooldown = 20
SWEP.ChokeProtectedCooldown = 5
SWEP.ChokeRate = 12.5
SWEP.ChokeStopDamage = 75
SWEP.ChokeSlow = 0.6
SWEP.ChokeSlowTime = 3

SWEP.BoostCooldown = 90
SWEP.BoostDuration = 10
SWEP.BoostSpeed = 1.2
SWEP.BoostRadius = 600

SCP049_ZOMBIE_TYPES = {
	{ name = "normal", speed = 1, health = 1, damage = 1, primary = "light", secondary = "heavy", material = nil },
	{ name = "assassin", speed = 1.4, health = 0.5, damage = 1.25, primary = "light", secondary = "rapid", material = nil },
	{ name = "boomer", speed = 0.9, health = 1.3, damage = 1.5, primary = "heavy", secondary = "explode", material = nil },
	{ name = "heavy", speed = 0.8, health = 1.6, damage = 0.75, primary = "heavy", secondary = "shot", material = nil },
}

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Int", "Surgeries" )
	self:NetworkVar( "Int", "Nearby" )
	self:NetworkVar( "Float", "Surgery" )
	self:NetworkVar( "Float", "Choke" )
	self:NetworkVar( "Float", "Boost" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP049" )
	self:InitializeHUD()

	self:SetChoke( -1 )
	self.Zombies = {}
	self.ChokeProgress = {}

	for i, v in ipairs( SCP049_ZOMBIE_TYPES ) do
		if v.name == "normal" then continue end

		self.Data["cap_"..v.name] = 1
		self.Data["num_"..v.name] = 1
	end
end

SWEP.NextProtectionTick = 0
function SWEP:Think()
	if CLIENT or ROUND.preparing then return end

	if ROUND.post then
		if self.ChokeTarget then
			self:StopChoke()
		end	

		return
	end

	if self.ChokeTarget and ( !IsValid( self.ChokeTarget ) or !self.ChokeTarget:CheckSignature( self.ChokeTargetSignature ) ) then
		self:StopChoke()
	end
	
	local owner = self:GetOwner()

	local target = self.ChokeTarget
	if target then
		owner:SetPos( self.ChokeOwnerPosition )
		target:SetPos( self.ChokeHoldPosition )
		target:SetEyeAngles( self.ChokeHoldAngle )

		local choke = self:GetChoke() + self.ChokeRate * self:GetUpgradeMod( "choke_rate", 1 ) * FrameTime()
		self:SetChoke( choke )
		self.ChokeProgress[target][1] = choke

		if choke > 100 then
			self:StopChoke()

			local dmg = DamageInfo()
			dmg:SetDamage( target:Health() )
			dmg:SetDamageType( DMG_DIRECT )
			dmg:SetAttacker( owner )

			target:TakeDamageInfo( dmg )
		end
	end

	local ct = CurTime()
	if self.NextProtectionTick <= ct then
		self.NextProtectionTick = self.NextProtectionTick + 0.5

		if self.NextProtectionTick < ct then
			self.NextProtectionTick = ct + 0.5
		end

		local nearby = 0
		local pos = owner:GetPos()

		for i, v in ipairs( player.GetAll() ) do
			if v:SCPClass() != CLASSES.SCP0492 or v:GetPos():DistToSqr( pos ) > self.PassiveRadius then continue end
	
			local wep = v:GetSCPWeapon()
			if !IsValid( wep ) or wep:GetSCP049() != owner then continue end
	
			wep:EnableProtection()
			nearby = nearby + 1
		end

		self:SetNearby( nearby )
	end

	local surgery = self:GetSurgery()
	if surgery > 0 then
		if surgery < ct then
			self:FinishSurgery()
		elseif !IsValid( self.SurgeryTarget ) then
			self:StopSurgery()
		end
	end
end

function SWEP:OnRemove()
	if CLIENT then return end
	self:StopChoke()
end

local attack_trace = {}
attack_trace.mins = Vector( -4, -4, -4 )
attack_trace.maxs = Vector( 4, 4, 4 )
attack_trace.mask = MASK_SHOT
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetSurgery() > ct or self:GetChoke() >= 0 then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	local pos = owner:GetShootPos()

	attack_trace.start = pos
	attack_trace.endpos = pos + owner:GetAimVector() * 65
	attack_trace.filter = owner

	owner:LagCompensation( true )
	local tr = util.TraceLine( attack_trace )
	owner:LagCompensation( false )

	local ent = tr.Entity
	if !IsValid( ent ) then return end
	
	if !ent:IsPlayer() then
		self:SCPDamageEvent( ent, 50 )
		self:SetNextPrimaryFire( ct + 1 )
		return
	end

	if !self:CanTargetPlayer( ent ) then return end

	if ent:CheckHazmat( 150 ) then
		self:SetNextPrimaryFire( ct + self.ChokeProtectedCooldown )
		owner:EmitSound( "SCP049.RemoveProtection" )
		return
	elseif ent:GetSCP714() then
		self:SetNextPrimaryFire( ct + self.ChokeProtectedCooldown )
		owner:EmitSound( "SCP049.RemoveProtection" )
		ent:PlayerDropWeapon( "item_scp_714" )
		return
	end

	local progress = self.ChokeProgress[ent]
	if !progress or !ent:CheckSignature( progress[2] ) then
		progress = { 0, ent:TimeSignature() }
		self.ChokeProgress[ent] = progress
	end

	self:SetChoke( progress[1] )
	self.ChokeTarget = ent
	self.ChokeTargetSignature = ent:TimeSignature()
	self.ChokeTargetPosition = ent:GetPos()
	self.ChokeOwnerPosition = owner:GetPos()
	self.ChokeDamage = 0
	
	owner:EmitSound( "SCP049.Attack" )
	owner:DisableControls( "scp049_attack" )

	ent:DisableControls( "scp049_attack" )
	ent:SetMoveType( MOVETYPE_NONE )

	local ang = owner:EyeAngles()
	ang.p = -30
	ang.r = 0

	self.ChokeHoldPosition = owner:GetPos() + ang:Forward() * 33 - Vector( 0, 0, 8 )
	owner:SetEyeAngles( ang )
	ent:SetPos( self.ChokeHoldPosition )

	ang.p = 0
	ang.y = ang.y + 180

	self.ChokeHoldAngle = ang
	ent:SetEyeAngles( ang )
	SuppressHostEvents( NULL )
	ent:DoCustomAnimEvent( PLAYERANIMEVENT_CUSTOM_SEQUENCE, 9049001 )
	SuppressHostEvents( owner )

	ent:TakeDamage( 1, owner, owner )
end

local color_ok = "<color=0,200,0>"
local color_bad = "<color=200,0,0>"

function SWEP:Reload()
	if SERVER or ROUND.preparing or ROUND.post then return end
	if self:GetSurgery() >= CurTime() or self:GetChoke() >= 0 then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "scp049_surgery" ) then return end

	local pos = owner:GetShootPos()
	local ent = util.TraceLine( {
		start = pos,
		endpos = pos + owner:GetAimVector() * 75,
		filter = owner,
		mask = MASK_SHOT
	} ).Entity

	if !IsValid( ent ) or ent:GetClass() != "prop_ragdoll" or ent:GetNWInt( "team", TEAM_SCP ) == TEAM_SCP or ent:GetNWBool( "invalid_ragdoll", false ) then return end

	owner:StartHold( self, "scp049_surgery", IN_RELOAD, 0, function()
		CloseWheelMenu()
	end, true )

	local options = {}

	for i, v in ipairs( SCP049_ZOMBIE_TYPES ) do
		local num = self.Data["num_"..v.name]
		local cap = self.Data["cap_"..v.name]

		local ok = !num or num > 0
		local txt = ""

		if num and cap then
			if num > cap then
				cap = num
			end

			txt = "\n("..( ok and color_ok or color_bad )..num.."</color>/"..cap..")"
		end

		table.insert( options, {
			mat = v.material,
			name = self.Lang.zombies[v.name] or v.name,
			desc = self.Lang.zombies_desc[v.name]..txt,
			disabled = !ok,
			data = i
		} )
	end

	OpenWheelMenu( options, function( selected )
		if !selected then return end
		net.Ping( "SCP049Surgery", selected )
	end, function()
		return !IsValid( self ) or owner:UpdateHold( self, "scp049_surgery" ) != nil
	end )
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetSurgery() >= ct or self:GetChoke() >= 0 then return end

	local owner = self:GetOwner()
	self:SetNextSpecialAttack( ct + self.BoostCooldown * self:GetUpgradeMod( "buff_cd", 1 ) )

	local duration = self.BoostDuration * self:GetUpgradeMod( "buff_dur", 1 )
	local power = self.BoostSpeed * self:GetUpgradeMod( "buff_power", 1 )

	self:SetBoost( ct + duration )
	owner:PushSpeed( power, power, -1, "SLC_SCP049Boost", 1 )

	local pos = owner:GetPos()
	local radius = ( self.BoostRadius * self:GetUpgradeMod( "buff_radius", 1 ) ) ^ 2

	for i, v in ipairs( player.GetAll() ) do
		if v:SCPClass() != CLASSES.SCP0492 or v:GetPos():DistToSqr( pos ) > radius then continue end

		local wep = v:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetSCP049() != owner then continue end

		wep:EnableBoost( duration, power )
	end

	owner:AddTimer( "SCP049Boost", duration, 1, function()
		owner:PopSpeed( "SLC_SCP049Boost" )
	end )
end

function SWEP:TranslateActivity( act )
	if self:GetChoke() >= 0 then
		return ACT_HL2MP_IDLE_PISTOL
	end

	if self.ActivityTranslate[act] != nil then
		return self.ActivityTranslate[act]
	end

	return -1
end

function SWEP:StopChoke()
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end
	
	owner:StopDisableControls( "scp049_attack" )

	if IsValid( self.ChokeTarget ) then
		self.ChokeTarget:StopDisableControls( "scp049_attack" )
		self.ChokeTarget:SetPos( self.ChokeTargetPosition )
		self.ChokeTarget:SetMoveType( MOVETYPE_WALK )

		SuppressHostEvents( NULL )
		self.ChokeTarget:DoCustomAnimEvent( PLAYERANIMEVENT_CUSTOM_SEQUENCE, 9049002 )
		SuppressHostEvents( owner )
	end

	self:SetNextPrimaryFire( CurTime() + self.ChokeCooldown * self:GetUpgradeMod( "choke_cd", 1 ) )
	self:SetChoke( -1 )
	self.ChokeTarget = nil
	self.ChokeTargetSignature = nil
	self.ChokeTargetPosition = nil
	self.ChokeOwnerPosition = nil
	self.ChokeHoldPosition = nil
	self.ChokeHoldAngle = nil

	local slow = self.ChokeSlow * self:GetUpgradeMod( "choke_slow", 1 )
	owner:PushSpeed( slow, slow, -1, "SLC_SCP049Choke", 1 )
	owner:AddTimer( "SCP049ChokeSlow", self.ChokeSlowTime, 1, function()
		owner:PopSpeed( "SLC_SCP049Choke" )
	end )
end

function SWEP:StartSurgery( option )
	if ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetSurgery() >= ct or self:GetChoke() >= 0 then return end

	local owner = self:GetOwner()

	local pos = owner:GetShootPos()
	local ent = util.TraceLine( {
		start = pos,
		endpos = pos + owner:GetAimVector() * 85,
		filter = owner,
		mask = MASK_SHOT
	} ).Entity

	if !IsValid( ent ) or ent:GetClass() != "prop_ragdoll" or !ent.Data or ent.Data.team == TEAM_SCP or ent.Data.invalid then return end

	local ztype = SCP049_ZOMBIE_TYPES[option]
	if ztype then
		local num = self.Data["num_"..ztype.name]
		if num and num <= 0 then return end
	end

	self.SurgeryType = option
	self.SurgeryTarget = ent
	self:SetSurgery( ct + self.SurgeryTime - self:GetUpgradeMod( "surgery_time", 0 ) )
end

function SWEP:StopSurgery()
	self.SurgeryType = nil
	self.SurgeryTarget = nil
	self:SetSurgery( 0 )
	self:HUDNotify( "surgery_failed" )
end

function SWEP:FinishSurgery()
	if ROUND.preparing or ROUND.post then return end

	local ent = self.SurgeryTarget
	if !IsValid( ent ) then
		self:StopSurgery()
		return
	end

	local stats = SCP049_ZOMBIE_TYPES[self.SurgeryType]
	if !stats or !ent.Data or ent.Data.team == TEAM_SCP or ent.Data.invalid then
		self:StopSurgery()
		return
	end

	local ply = ent:GetOwner()
	local low = false

	if !IsValid( ply ) or !ply:IsValidSpectator( true, true ) or ply:GetInfoNum( "cvar_slc_zombie_optout", 0 ) == 1 then
		local unused = {}
		local unused_low = {}

		repeat
			ply, low = QueueRemove( true )
			if IsValid( ply ) then
				if ply:GetInfoNum( "cvar_slc_zombie_optout", 0 ) == 0 then
					break
				end

				table.insert( low and unused_low or unused, ply )
			end
		until ply == NULL

		for i, v in ipairs( unused ) do
			QueueInsert( v, true )
		end

		for i, v in ipairs( unused_low ) do
			QueueInsertSuicide( v, true )
		end
	end

	if !IsValid( ply ) then
		self:StopSurgery()
		return
	end

	local num = self.Data["num_"..stats.name]
	local cap = self.Data["cap_"..stats.name]

	if num and cap then
		num = num - 1
		cap = cap - 1

		if num < 0 then num = 0 end
		if cap < 0 then cap = 0 end

		self.Data["num_"..stats.name] = num
		self.Data["cap_"..stats.name] = cap
	end

	for i, v in ipairs( SCP049_ZOMBIE_TYPES ) do
		if v.name == "normal" or v.name == stats.name then continue end

		local v_cap = self.Data["cap_"..v.name]

		if stats.name == "normal" then
			self.Data["num_"..v.name] = math.Clamp( self.Data["num_"..v.name] + 1, 0, v_cap )
		else
			self.Data["cap_"..v.name] = v_cap + 1
		end
	end

	local owner = self:GetOwner()
	local model, skin = self:TranslateZombieModel( ply, ent )
	local surg = self:GetSurgeries()

	local hp = stats.health * ( 1 + self:GetUpgradeMod( "stacks_hp", 0 ) * surg )
	local dmg = stats.damage * ( 1 + self:GetUpgradeMod( "stacks_dmg", 0 ) * surg )

	GetSCP( "SCP0492" ):SetupPlayer( ply, true, owner:GetPos() + Vector( 0, 0, 8 ), owner,
		self.SurgeryType, hp, stats.speed, dmg, self:GetUpgradeMod( "zombie_ls", 0 ), model, skin )
	
	ent:Remove()
	self.SurgeryType = nil
	self.SurgeryTarget = nil
	self:SetSurgery( 0 )
	self:SetSurgeries( surg + 1 )
	self:AddScore( 1 )
	owner:AddFrags( 2 )
	AddRoundStat( "049" )

	if !self:HasUpgrade( "surgery_heal" ) then return end

	local self_heal = self:GetUpgradeMod( "surgery_heal" )
	local zombie_heal = self:GetUpgradeMod( "surgery_zombie_heal" )

	owner:AddHealth( self_heal )

	local pos = owner:GetPos()
	for i, v in ipairs( player.GetAll() ) do
		if v:SCPClass() != CLASSES.SCP0492 or v:GetPos():DistToSqr( pos ) > self.PassiveRadius then continue end

		local wep = v:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetSCP049() != owner then continue end
		v:AddHealth( zombie_heal )
	end
end

function SWEP:TranslateZombieModel( ply, rag )
	local team = ply:GetProperty( "last_team" )
	local class = ply:GetProperty( "last_class" )

	if team == TEAM_CLASSD or class == CLASSES.CIAGENT then
		return "models/player/alski/scp049-2.mdl", SLCRandom( 0, 4 )
	elseif team == TEAM_MTF then
		if SLCRandom( 1, 2 ) == 1 then
			return "models/player/alski/scp049-2mtf.mdl", SLCRandom( 0, 4 )
		else
			return "models/player/alski/scp049-2mtf2.mdl", SLCRandom( 0, 4 )
		end
	elseif team == TEAM_SCI then
		return "models/player/alski/scp049-2_scientist.mdl", SLCRandom( 0, 4 )
	elseif team == TEAM_GUARD or class == CLASSES.CISPY then
		return "models/player/alski/049-2_security.mdl", SLCRandom( 0, 4 ) * 5 + rag:GetSkin()
	end
end

function SWEP:OnUpgradeBought( name, active, group )
	if name == "zombie_lifesteal" then
		local owner = self:GetOwner()
		for i, v in ipairs( player.GetAll() ) do
			if v:SCPClass() != CLASSES.SCP0492 then continue end

			local wep = v:GetSCPWeapon()
			if !IsValid( wep ) or wep:GetSCP049() != owner then continue end

			wep.LifeSteal = self:GetUpgradeMod( "zombie_ls", 0 )
		end
	end
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP049") TransmitSCPHooks()
SCPHook( "SCP049", "EntityTakeDamage", function( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP049 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	if wep:GetSurgery() >= CurTime() then
		local prot = wep:GetUpgradeMod( "surgery_prot" )
		if prot then
			dmg:ScaleDamage( prot )
		end
	end

	if wep:HasUpgrade( "zombie_prot" ) then
		local prot = wep:GetUpgradeMod( "zombie_prot" ) * wep:GetNearby()
		local prot_max = wep:GetUpgradeMod( "zombie_prot_max" )

		if prot > prot_max then
			prot = prot_max
		end

		dmg:ScaleDamage( 1 - prot )
	end
end )

SCPHook( "SCP049", "PostEntityTakeDamage", function( ent, dmg )
	if !IsValid( ent ) or !ent:IsPlayer() then return end

	local attacker = dmg:GetAttacker()
	if IsValid( attacker ) and attacker:IsPlayer() and attacker:SCPClass() == CLASSES.SCP0492 then
		local wep = attacker:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetProtection() < CurTime() then return end

		local scp = wep:GetSCP049()
		if !IsValid( scp ) or scp:SCPClass() != CLASSES.SCP049 then return end

		local scp_wep = scp:GetSCPWeapon()
		if !IsValid( scp_wep ) then return end

		local heal = scp_wep:GetUpgradeMod( "zombie_heal" )
		if !heal then return end

		scp:AddHealth( math.ceil( dmg:GetDamage() * heal ) )

		return
	end

	if ent:SCPClass() != CLASSES.SCP049 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	if wep:GetSurgery() > CurTime() and !wep:HasUpgrade( "surgery_dmg" ) then
		wep:StopSurgery()
	end

	if !IsValid( wep.ChokeTarget ) then return end

	wep.ChokeDamage = wep.ChokeDamage + dmg:GetDamage()
	if wep.ChokeDamage >= wep.ChokeStopDamage * wep:GetUpgradeMod( "choke_dmg", 1 ) then
		wep:StopChoke()
	end
end )

SCPHook( "SCP049", "DoAnimationEvent", function( ply, event, data )
	if event != PLAYERANIMEVENT_CUSTOM_SEQUENCE then return end

	if data == 9049001 then
		ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_HL2MP_SWIM_IDLE_FIST, false )
		return ACT_INVALID
	elseif data == 9049002 then
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
		return ACT_INVALID
	end
end )

SCPHook( "SCP049", "StartCommand", function( ply, cmd )
	if ply:SCPClass() != CLASSES.SCP049 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetSurgery() <= CurTime() then return end

	cmd:ClearMovement()
	cmd:ClearButtons()
	cmd:SetButtons( IN_DUCK )
end )

SCPHook( "SCP049", "SLCEscapeMultiplier", function( tab, mult )
	local scp049 = nil
	local zombies = {}
	local z_len = 0

	for i, v in ipairs( tab ) do
		local class = v:SCPClass()
		if class == CLASSES.SCP049 then
			mult.bonus_mult[v] = 0.75
			scp049 = v
		elseif class == CLASSES.SCP0492 then
			z_len = z_len + 1
			mult.skip_count[v] = z_len % 3 != 2
			mult.bonus_mult[v] = 0.75
			table.insert( zombies, v )
		end
	end

	if !scp049 and z_len <= 0 then return end

	local scp_alive = false
	local total_z = 0

	for i, v in ipairs( player.GetAll() ) do
		local class = v:SCPClass()
		if class == CLASSES.SCP049 then
			scp_alive = true
		elseif class == CLASSES.SCP0492 then
			total_z = total_z + 1
		end
	end

	if scp049 and total_z > 0 then
		local lower_limit = math.ClampMap( total_z, 2, 5, 1, 0.25 )

		mult[scp049] = math.ClampMap( z_len, 0, total_z, lower_limit, 1.25 )
	end

	if z_len > 0 then
		local z_mul
		
		if total_z == 1 then
			z_mul = 0.1
		else
			local upper_limit = scp_alive and 1 or math.ClampMap( total_z, 1, 5, 0.1, 1 )
			z_mul = math.Map( z_len, 1, total_z, 0.1, upper_limit )
		end

		if scp049 then
			z_mul = z_mul + 0.25
		elseif scp_alive then
			z_mul = z_mul - 0.5

			if z_mul < 0 then
				z_mul = 0
			end
		end

		for i, v in ipairs( zombies ) do
			mult[v] = z_mul
		end
	end
end )

if SERVER then
	net.ReceivePing( "SCP049Surgery", function( data, ply )
		if ply:SCPClass() != CLASSES.SCP049 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep:StartSurgery( tonumber( data ) )
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.choke = GetMaterial( "slc/hud/upgrades/scp/049/choke.png", "smooth" )
	icons.buff = GetMaterial( "slc/hud/upgrades/scp/049/buff.png", "smooth" )
	icons.zombify = GetMaterial( "slc/hud/upgrades/scp/049/zombify.png", "smooth" )
	icons.zombie = GetMaterial( "slc/hud/upgrades/scp/049/zombie.png", "smooth" )
	icons.prot = GetMaterial( "slc/hud/upgrades/scp/049/prot.png", "smooth" )
end

DefineUpgradeSystem( "scp049", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "choke1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { choke_cd = 0.9, choke_dmg = 1.4 }, icon = icons.choke, active = false },
		{ name = "choke2", cost = 2, req = { "choke1" }, reqany = false, pos = { 1, 2 },
			mod = { choke_rate = 1.25, choke_slow = 0.8 }, icon = icons.choke, active = false },
		{ name = "choke3", cost = 4, req = { "choke2" }, reqany = false, pos = { 1, 3 },
			mod = { choke_cd = 0.6, choke_dmg = 2.5, choke_rate = 2.2 }, icon = icons.choke, active = false },

		{ name = "buff1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { buff_cd = 0.9, buff_dur = 1.2 }, icon = icons.buff, active = false },
		{ name = "buff2", cost = 2, req = { "buff1" }, reqany = false, pos = { 2, 2 },
			mod = { buff_radius = 1.25, buff_power = 1.2 }, icon = icons.buff, active = false },

		{ name = "surgery_cd1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { surgery_time = 5 }, additive = true, icon = icons.zombify, active = false },
		{ name = "surgery_cd2", cost = 1, req = { "surgery_cd1" }, reqany = false, pos = { 3, 2 },
			mod = { surgery_time = 5 }, additive = true, icon = icons.zombify, active = false },
		{ name = "surgery_heal", cost = 2, req = { "surgery_cd2" }, block = { "surgery_prot" }, reqany = false, pos = { 3, 4 },
			mod = { surgery_heal = 200, surgery_zombie_heal = 50 }, icon = icons.zombify, active = false },
		{ name = "surgery_dmg", cost = 2, req = { "surgery_cd2" }, reqany = false, pos = { 2.5, 3 },
			mod = {}, icon = icons.zombify, active = false },
		{ name = "surgery_prot", cost = 2, req = { "surgery_dmg" }, block = { "surgery_heal", "zombie_prot" }, reqany = false, pos = { 2, 4 },
			mod = { surgery_prot = 0.3 }, icon = icons.prot, active = false },

		{ name = "zombie_prot", cost = 2, req = {}, block = { "surgery_prot" }, reqany = false, pos = { 4, 1 },
			mod = { zombie_prot = 0.05, zombie_prot_max = 0.75 }, icon = icons.prot, active = false },
		{ name = "zombie_lifesteal", cost = 1, req = { "zombie_prot", "surgery_cd1" }, reqany = true, pos = { 4, 2 },
			mod = { zombie_ls = 0.2 }, icon = icons.zombie, active = true },
		{ name = "stacks_hp", cost = 2, req = { "zombie_lifesteal" }, block = { "stacks_dmg" }, reqany = false, pos = { 3.5, 3 },
			mod = { stacks_hp = 0.03 }, icon = icons.zombie, active = false },
		{ name = "stacks_dmg", cost = 2, req = { "zombie_lifesteal" }, block = { "stacks_hp" }, reqany = false, pos = { 4.5, 3 },
			mod = { stacks_dmg = 0.02 }, icon = icons.zombie, active = false },
		{ name = "zombie_heal", cost = 3, req = { "stacks_hp", "stacks_dmg" }, reqany = true, pos = { 4, 4 },
			mod = { zombie_heal = 0.1 }, icon = icons.zombie, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 1, 4 }, mod = {}, active = false },
	},
	rewards = { --21 + 1 points -> 60% = 14 (-1 base) = 13 points
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 1 },
		{ 4, 1 },
		{ 5, 1 },
		{ 6, 1 },
		{ 7, 1 },
		{ 8, 1 },
		{ 9, 1 },
		{ 10, 1 },
		{ 12, 1 },
		{ 14, 1 },
		{ 16, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP049", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "choke" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/049/choke.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "surgery" )
		:SetButton( "reload" )
		:SetMaterial( "slc/hud/scp/049/zombify.png", "smooth" )
		:SetTextFunction( "GetSurgeries" )

	hud:AddSkill( "boost" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/049/buff.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/049/prot.png", "smooth" )
		:SetTextFunction( "GetNearby" )

	hud:AddBar( "choke_bar" )
		:SetMaterial( "slc/hud/scp/049/choke.png", "smooth" )
		:SetColor( Color( 236, 110, 27 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			local choke = swep:GetChoke()
			if choke >= 0 then
				this.last_progress = choke
				return math.Round( choke ).."%"
			elseif this.last_progress then
				return math.Round( this.last_progress ).."%"
			end
		end )
		:SetProgressFunction( function( swep )
			return swep:GetChoke() / 100
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetChoke() >= 0
		end )

	hud:AddBar( "surgery_bar" )
		:SetMaterial( "slc/hud/scp/049/zombify.png", "smooth" )
		:SetColor( Color( 145, 236, 27 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			local time = swep:GetSurgery() - CurTime()
			if time >= 0 then
				this.last_progress = time
				return math.Round( time ).."s"
			elseif this.last_progress then
				return math.Round( this.last_progress ).."s"
			end
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetSurgery() - CurTime() ) / ( swep.SurgeryTime - swep:GetUpgradeMod( "surgery_time", 0 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetSurgery() >= CurTime()
		end )

	hud:AddBar( "boost_bar" )
		:SetMaterial( "slc/hud/scp/049/buff.png", "smooth" )
		:SetColor( Color( 236, 170, 27 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			local time = swep:GetBoost() - CurTime()

			if time < 0 then
				time = 0
			end
			
			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetBoost() - CurTime() ) / swep.BoostDuration
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetBoost() >= CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
AddSounds( "SCP049.Attack", "scp_lc/scp/049/attack%i.ogg", 80, 1, 100, CHAN_STATIC, 0, 7 )
sound.Add{
	name = "SCP049.RemoveProtection",
	sound = "scp_lc/scp/049/remove714_1.ogg",
	volume = 1,
	level = 80,
	pitch = 100,
	channel = CHAN_STATIC,
}