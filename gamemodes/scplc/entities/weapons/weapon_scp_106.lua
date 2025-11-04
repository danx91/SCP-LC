SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-106"

SWEP.HoldType		= "normal"

SWEP.TrapAlert = "npc/ichthyosaur/snap_miss.wav"

SWEP.SoundRadius = 800
SWEP.PassiveDamage = 1400
SWEP.PassiveCooldown = 60
SWEP.TeleportDistance = 40
SWEP.TeleportDamage = 15
SWEP.TeleportSpeed = 1.2

SWEP.WitheringDuration = 10
SWEP.WitheringSlow = 0.2
SWEP.WitheringDurationTeeth = 0.4
SWEP.WitheringSlowTeeth = 0.015

SWEP.AttackCooldown = 40
SWEP.AttackCooldownPD = 5

SWEP.TrapCooldown = 120
SWEP.TrapTPTime = 5
SWEP.TrapLifeTime = 300
SWEP.TrapSpeed = 2

SWEP.SpotCooldown = 30
SWEP.TeleportCooldown = 45
SWEP.MaxSpots = 8
SWEP.SpotDrawDuration = 1

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Bool", "PlacingTrap" )
	self:NetworkVar( "Int", "Teeth" )
	self:NetworkVar( "Float", "PassiveDamage" )
	self:NetworkVar( "Float", "NextSpot" )
	self:NetworkVar( "Float", "PassiveCooldown" )
	self:NetworkVar( "Float", "TrapTime" )
	self:NetworkVar( "Float", "TeleportSequence" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP106" )
	self:InitializeHUD()

	self:SetPassiveDamage( self.PassiveDamage * self:GetUpgradeMod( "passive_dmg", 1 ) )

	self.Spots = {}
	self.SoundPlayers = {}
	self.PlayerTeleportCD = {}
end

function SWEP:OnRemove()
	self:RemoveGhostEntity()
end

function SWEP:Think()
	self:SoundThink()
	self:TrapThink()
	self:SpotThink()

	local ct = CurTime()
	if CLIENT or self:GetTeleportSequence() >= ct then return end

	local owner = self:GetOwner()
	local passive = self:GetPassiveCooldown()

	if passive == 0 then
		local dmg = self:GetPassiveDamage()
		local pos = owner:GetPos()

		if dmg <= 0 then
			self:SetPassiveCooldown( ct + self.PassiveCooldown * self:GetUpgradeMod( "passive_cd", 1 ) )
			owner:DisableControls( "scp106_penalty", CAMERA_MASK )

			SuppressHostEvents( NULL )
			self:TeleportSequence( POS_POCKETD[SLCRandom( #POS_POCKETD )], false )
			SuppressHostEvents( owner )

			util.Decal( "Decal106", pos + Vector( 0, 0, 8 ), pos - Vector( 0, 0, 8 ), owner )

			return
		end

		if owner:IsInZone( ZONE_PD ) or self:GetTeleportSequence() >= ct then return end

		local max_dist = self.TeleportDistance ^ 2

		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > max_dist then continue end

			local cd = self.PlayerTeleportCD[v]
			if cd and cd >= ct then continue end

			self.PlayerTeleportCD[v] = ct + 1

			if v:CheckHazmat( 60 ) then continue end

			v:TakeDamage( self.TeleportDamage * self:GetUpgradeMod( "teleport_dmg", 1 ), owner, owner )

			if v:Alive() then
				SendToPocketDimension( v, owner )
			end

			self:AddScore( 1 )
			self:SetTeeth( self:GetTeeth() + 1 )
			AddRoundStat( "106" )
		end

		return
	end

	if passive < ct then
		self:SetPassiveCooldown( 0 )
		self:SetPassiveDamage( self.PassiveDamage * self:GetUpgradeMod( "passive_dmg", 1 ) )
		owner:StopDisableControls( "scp106_penalty" )
	end
end

SWEP.NextSoundTick = 0
function SWEP:SoundThink()
	if CLIENT then return end

	local ct = CurTime()

	if self.NextSoundTick > ct then return end
	self.NextSoundTick = ct + 1

	local owner = self:GetOwner()
	local pos = owner:GetPos()
	local radius = self.SoundRadius ^ 2

	for i, v in ipairs( player.GetAll() ) do
		local status = self:CanTargetPlayer( v ) and v:GetPos():DistToSqr( pos ) <= radius

		if status and !self.SoundPlayers[v] then
			v:PlayAmbient( "106", true, false, function( ply )
				return !IsValid( self ) or !self.SoundPlayers[ply]
			end )
		end

		self.SoundPlayers[v] = status
	end
end

local color_ok = Color( 100, 255, 100, 150 )
local color_bad = Color( 255, 100, 100, 150 )
function SWEP:TrapThink()
	if SERVER or !self:GetPlacingTrap() or !IsValid( self.GhostEntity ) then return end

	local valid, pos, ang = self:GetTrapPosition()

	pos = pos + ang:Forward() * 2
	ang.p = ang.p + 90

	self.GhostEntity:SetColor( valid and color_ok or color_bad )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( ang )
end

SWEP.ShowSpots = 0
function SWEP:SpotThink()
	if SERVER then return end

	self.SelectedSpot = nil
	self.CurrentSpot = nil

	local ct = CurTime()

	if self.ShowSpots < ct then
		self.LastCurrentSpot = nil
	end

	local owner = self:GetOwner()
	local owner_pos = owner:GetPos()

	local len = 0
	local spots = {}
	local current_surf

	for i, v in ipairs( ents.GetAll() ) do
		if v:GetClass() != "slc_106_spot" or v:GetOwner() != owner then continue end

		if v:GetPos():DistToSqr( owner_pos ) < 2500 then
			self.CurrentSpot = v
			self.LastCurrentSpot = v
			current_surf = v:IsInZone( ZONE_SURFACE )
		else
			len = len + 1
			spots[len] = v
		end
	end

	local eye_pos = owner:EyePos()
	local forward = owner:EyeAngles():Forward()
	local best_dot = -1
	local best_spot

	for i = 1, len do
		local v = spots[i]
		if v:IsInZone( ZONE_SURFACE ) != current_surf then continue end

		local diff = v:GetPos() - eye_pos
		diff:Normalize()

		local dot = diff:Dot( forward )
		if dot < 0.9 then continue end

		if dot > best_dot then
			best_dot = dot
			best_spot = v
		end
	end

	if !self.CurrentSpot then
		self.SpotHolding = false
		return
	end

	self.ShowSpots = ct + self.SpotDrawDuration

	if !self.SpotHolding then return end
	self.SelectedSpot = best_spot

	if !input.IsKeyDown( GetBindButton( "scp_special" ) ) then
		if self.SelectedSpot then
			net.Ping( "SCP106Teleport", self.SelectedSpot:EntIndex() )
		end
		
		self.SelectedSpot = nil
		self.SpotHolding = false
	end
end

local attack_trace = {}
attack_trace.mins = Vector( -4, -4, -4 )
attack_trace.maxs = Vector( 4, 4, 4 )
attack_trace.mask = MASK_SHOT
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post or !self:CanAttack() then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local inpd = owner:IsInZone( ZONE_PD )

	attack_trace.start = owner:GetShootPos()
	attack_trace.endpos = attack_trace.start + owner:GetAimVector() * ( inpd and 75 or 175 )
	attack_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceLine( attack_trace )

	if !attack_trace.Hit then
		util.TraceHull( attack_trace )
	end
	owner:LagCompensation( false )

	if !attack_trace.Hit then return end

	local ent = attack_trace.Entity
	if !IsValid( ent ) then return end

	if !ent:IsPlayer() then
		if attack_trace.start:Distance( attack_trace.endpos ) * attack_trace.Fraction > 75 then return end

		self:SetNextPrimaryFire( ct + 3 )
		self:SCPDamageEvent( ent, 50 )

		return
	end

	if !self:CanTargetPlayer( ent ) then return end

	if inpd then
		self:SetNextPrimaryFire( ct + self.AttackCooldownPD )

		local dmg = DamageInfo()

		dmg:SetAttacker( owner )
		dmg:SetDamage( ent:Health() )
		dmg:SetDamageType( DMG_DIRECT )

		ent:TakeDamageInfo( dmg )
	else
		self:SetNextPrimaryFire( ct + self.AttackCooldown * self:GetUpgradeMod( "attack_cd", 1 ) )
		self:ApplyWithering( ent )
	end
end

function SWEP:SecondaryAttack()
	if ROUND.preparing or ROUND.post then return end
	if !self:CanAttack() and !self:GetPlacingTrap() then return end

	local ct = CurTime()
	local owner = self:GetOwner()

	if self:GetTrapTime() >= ct then
		if CLIENT or !owner:IsOnGround() then return end
		self:SetTrapTime( 0 )

		local cd = self.LastTrapCD or 0
		if cd < ct + 1 then
			cd = ct + 1
		end

		self:SetNextSecondaryFire( cd )

		if !IsValid( self.LastTrap ) then return end

		local pos = owner:GetPos()
		util.Decal( "Decal106", pos + Vector( 0, 0, 8 ), pos - Vector( 0, 0, 8 ), owner )
		
		SuppressHostEvents( NULL )
		self:TeleportSequence( self.LastTrap:GetGroundPos(), self.LastTrap:GetAngles(), self.TrapSpeed )
		SuppressHostEvents( owner )

		self.LastTrap = nil

		return
	end

	if self:GetPlacingTrap() then
		self:SetPlacingTrap( false )
		self:RemoveGhostEntity()

		if CLIENT then return end

		local valid, pos, ang, gp = self:GetTrapPosition()
		if !valid then
			self:SetNextSecondaryFire( ct + 1 )
			return
		end

		self:SetNextSecondaryFire( ct + self.TrapCooldown * self:GetUpgradeMod( "trap_cd", 2 ) )

		local trap = ents.Create( "slc_106_trap" )
		if !IsValid( trap ) then return end

		trap:SetPos( pos + ang:Forward() * 2 )

		ang.p = ang.p + 90
		trap:SetAngles( ang )
		trap:SetOwner( owner )
		trap:SetDieTime( ct + self.TrapLifeTime * self:GetUpgradeMod( "trap_life", 1 ) )
		trap:SetGroundPos( gp )
		trap:Spawn()
	else
		self:SetNextSecondaryFire( ct + 1 )
		self:SetPlacingTrap( true )
		self:RemoveGhostEntity()

		if CLIENT then
			self.GhostEntity = ClientsideModel( "models/slc/scp106_teleport/portal_wall.mdl", RENDERGROUP_TRANSLUCENT )
			self.GhostEntity:SetMaterial( "models/debug/debugwhite" )
			self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
		end
	end
end

function SWEP:Reload()
	if !self:GetPlacingTrap() then return end

	self:SetNextSecondaryFire( CurTime() + 1 )
	self:SetPlacingTrap( false )
	self:RemoveGhostEntity()
end

local spot_offset = Vector( 0, 0, 2 )
local spot_trace_offset = Vector( 0, 0, 4 )
local spot_bounds = 32
local spot_trace = {}
spot_trace.mask = MASK_SOLID_BRUSHONLY
spot_trace.output = spot_trace

function SWEP:SpecialAttack()
	if ROUND.preparing or ROUND.post or !self:CanAttack() then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	local ct = CurTime()

	if CLIENT then
		if self.CurrentSpot then
			self.SpotHolding = true
		end

		return
	end

	if self:GetNextSpot() > ct then return end

	local num_spots = self:CheckSpots()
	local pos = owner:GetPos()

	for i, v in ipairs( self.Spots ) do
		if v:GetPos():DistToSqr( pos ) < 10000 then return end
	end

	local prev_z

	for y = -1, 1 do
		for x = -1, 1 do
			spot_trace.start = pos + Vector(  x * spot_bounds, y * spot_bounds, 0 ) + spot_trace_offset
			spot_trace.endpos = spot_trace.start - spot_trace_offset * 2

			util.TraceLine( spot_trace )
			
			if !spot_trace.Hit or spot_trace.HitNormal.z != 1 or ( prev_z and spot_trace.HitPos.z != prev_z ) then
				return
			end

			prev_z = spot_trace.HitPos.z
		end
	end

	if num_spots >= self.MaxSpots + self:GetUpgradeMod( "spot_max", 0 ) then
		local spot = table.remove( self.Spots, 1 )

		if IsValid( spot ) then
			spot:Remove()
		end
	end

	self:SetNextSpecialAttack( ct + 1 )
	self:SetNextSpot( ct + self.SpotCooldown * self:GetUpgradeMod( "spot_cd", 1 ) )

	local spot = ents.Create( "slc_106_spot" )
	if !IsValid( spot ) then return end

	spot:SetPos( pos + spot_offset )
	spot:SetOwner( owner )
	spot:Spawn()

	table.insert( self.Spots, spot )
	owner:EmitSound( "SCP106.Place" )
end

function SWEP:CanAttack()
	return !self:GetPlacingTrap() and self:GetPassiveCooldown() == 0 and self:GetTeleportSequence() < CurTime()
end

function SWEP:DamagePassive( dmg )
	local ct = CurTime()
	if self:GetPassiveCooldown() >= ct then return end

	self:SetPassiveDamage( self:GetPassiveDamage() - dmg )
end

function SWEP:ApplyWithering( target )
	local teeth = self:GetTeeth()
	local dur = self.WitheringDuration * self:GetUpgradeMod( "withering_dur", 1 ) + self.WitheringDurationTeeth * teeth
	local slow = self.WitheringSlow * self:GetUpgradeMod( "withering_slow", 1 ) + self.WitheringSlowTeeth * teeth

	if slow > 0.8 then
		slow = 0.8
	end

	target:ApplyEffect( "scp106_withering", 1, dur, slow )
end

function SWEP:TrapTriggered( trap, ent )
	self.LastTrapCD = self:GetNextSecondaryFire()
	self:SetNextSecondaryFire( 0 )
	self:SetTrapTime( CurTime() + self.TrapTPTime )
	self:ApplyWithering( ent )
	self.LastTrap = trap

	TransmitSound( self.TrapAlert, true, self:GetOwner(), 0.4 )
end

function SWEP:SpotTeleport( idx )
	if !idx then return end

	local ent = Entity( idx )
	if !IsValid( ent ) or ent:GetClass() != "slc_106_spot" then return end

	local owner = self:GetOwner()
	if ent:GetOwner() != owner or owner:IsInZone( ZONE_SURFACE ) != ent:IsInZone( ZONE_SURFACE ) then return end

	local pos = owner:GetPos()
	local valid = false

	self:CheckSpots()

	for i, v in ipairs( self.Spots ) do
		if v != ent and v:GetPos():DistToSqr( pos ) < 2500 then
			valid = true
			break
		end
	end

	if !valid then return end

	local dur = self:TeleportSequence( ent:GetPos(), false, self.TeleportSpeed, self.TeleportSpeed )
	self:SetNextSpecialAttack( CurTime() + self.TeleportCooldown * self:GetUpgradeMod( "tp_cd", 1 ) + dur )
end

local fade_color = Color( 0, 0, 0 )
function SWEP:TeleportSequence( dest, wall, despawn_speed, spawn_speed )
	local owner = self:GetOwner()

	despawn_speed = despawn_speed or 1
	spawn_speed = spawn_speed or 1

	local despawn_name = "scp_106_despawn_1"
	local seq_despawn, dur_despawn = owner:LookupSequence( despawn_name )
	if seq_despawn == -1 then dur_despawn = 4.3 end
	
	dur_despawn = dur_despawn / despawn_speed
	
	local spawn_name = wall and "scp_106_spawn_wall" or "scp_106_spawn_floor"
	local seq_sapwn, dur_spawn = owner:LookupSequence( spawn_name )
	if seq_sapwn == -1 then dur_spawn = wall and 1.2 or 4.3 end

	dur_spawn = dur_spawn

	local total = dur_despawn + dur_spawn / spawn_speed

	if wall then
		owner:SetEyeAngles( wall )
	end

	self:SetTeleportSequence( CurTime() + total )
	owner:DisableControls( "scp106_tp" )
	
	owner:PlaySequence( seq_despawn, false, despawn_speed )

	owner:AddTimer( "SCP106FinishTPSound", dur_despawn - 2, 1, function()
		owner:EmitSound( "SCP106.Disappear" )
	end )

	owner:AddTimer( "SCP106FinishTPFade", dur_despawn - 0.75, 1, function()
		owner:ScreenFade( SCREENFADE.OUT, fade_color, 0.5, 0.25 )
	end )

	owner:AddTimer( "SCP106FinishTP", dur_despawn, 1, function()
		owner:ScreenFade( SCREENFADE.IN, fade_color, 1, 0.25 )
		owner:SetPos( dest )
		owner:PlaySequence( seq_sapwn, false, spawn_speed )
		owner:EmitSound( "SCP106.Teleport" )
	end )

	owner:AddTimer( "SCP106EnableMovement", total, 1, function()
		owner:StopDisableControls( "scp106_tp" )
	end )

	return total
end

local trap_trace = {}
trap_trace.mask = bit.bor( CONTENTS_SOLID, CONTENTS_PLAYERCLIP )
trap_trace.output = trap_trace

local trap_bounds_x = 20
local trap_bounds_y = 32
/*local trap_patterns = {
	{ 1, 1, -1, -1 },
	{ -1, 1, 1, -1 }
}*/

function SWEP:GetTrapPosition()
	local owner = self:GetOwner()

	trap_trace.start = owner:GetShootPos()
	trap_trace.endpos = trap_trace.start + owner:GetAimVector() * 80

	util.TraceLine( trap_trace )

	local pos = trap_trace.HitPos
	local normal = trap_trace.HitNormal

	if !trap_trace.Hit or math.abs( normal.z ) > 0.1 then
		return false, pos, ( -owner:GetAimVector() ):Angle()
	end
	
	local angle = normal:Angle()

	local up = angle:Up()
	local right = angle:Right()
	local all_ok = true

	trap_trace.start = pos + normal * 32
	trap_trace.endpos = trap_trace.start - up * 64

	util.TraceLine( trap_trace )

	if !trap_trace.Hit then
		return false, pos, normal:Angle()
	end

	local ground_pos = trap_trace.HitPos
	trap_trace.start = ground_pos
	trap_trace.endpos = ground_pos

	util.TraceEntity( trap_trace, owner )

	if trap_trace.Hit then
		return false, pos, normal:Angle()
	end

	for y = -1, 1 do
		for x = -1, 1 do
			trap_trace.start = pos + right * x * trap_bounds_x + up * y * trap_bounds_y + normal * 4
			trap_trace.endpos = trap_trace.start - normal * 8

			util.TraceLine( trap_trace )
			
			if !trap_trace.Hit or trap_trace.HitNormal != normal then
				all_ok = false
				break
			end
		end

		if !all_ok then break end
	end

	/*for i, v in ipairs( trap_patterns ) do
		trap_trace.start = pos + right * trap_bounds_x * v[1] + up * trap_bounds_y * v[2] + normal * 16
		trap_trace.endpos = pos + right * trap_bounds_x * v[3] + up * trap_bounds_y * v[4] + normal * 16

		util.TraceLine( trap_trace )

		if trap_trace.Hit then
			all_ok = false
			break
		end
	end*/

	return all_ok, pos, angle, ground_pos
end

function SWEP:CheckSpots()
	local num = 0

	for i, v in rpairs( self.Spots ) do
		if !IsValid( v ) then
			table.remove( self.Spots, i )
		else
			num = num + 1
		end
	end

	return num
end

function SWEP:RemoveGhostEntity()
	if CLIENT and IsValid( self.GhostEntity ) then
		self.GhostEntity:Remove()
	end
end

SWEP.ThirdPersonDistance = 0
function SWEP:CalcView( ply, pos, ang, fov, view )
	if self:GetTeleportSequence() < CurTime() then
		if self.ThirdPersonDistance <= 0 then return end

		self.ThirdPersonDistance = self.ThirdPersonDistance - FrameTime() * 2

		if self.ThirdPersonDistance < 0 then
			self.ThirdPersonDistance = 0
		end
	elseif self.ThirdPersonDistance < 1 then
		self.ThirdPersonDistance = self.ThirdPersonDistance + FrameTime() * 2

		if self.ThirdPersonDistance > 1 then
			self.ThirdPersonDistance = 1
		end
	end

	ang.p = 30
	CalcThirdPersonView( ply, view, 120 * self.ThirdPersonDistance, ang )
end

local color_white = Color( 255, 255, 255 )
function SWEP:DrawSCPHUD()
	if !self:GetPlacingTrap() then return end

	local btn = string.upper( input.LookupBinding( "reload" ) or "RELOAD" )
	draw.SimpleText( string.format( self.Lang.cancel, btn ), "SCPHUDMedium", ScrW() * 0.5, ScrH() * 0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP106") TransmitSCPHooks()
SCPHook( "SCP106", "SLCPostScaleDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP106 then return end
	if dmg:IsDamageType( DMG_RADIATION ) or dmg:IsDamageType( DMG_POISON ) or dmg:IsDamageType( DMG_BLAST ) or dmg:IsDamageType( DMG_FALL ) then return end

	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) then return end

	wep:DamagePassive( dmg:GetDamage() )
	ApplyDamageHUDEvents( target, dmg )

	return true
end )

if CLIENT then
	SCPHook( "SCP106", "ScalePlayerDamage", function( ply, group, dmg )
		if !IsValid( ply ) or ply:SCPClass() != CLASSES.SCP106 then return end
		return true
	end )
end

SCPHook( "SCP106", "ShouldCollide", function ( ent1, ent2 )
	if ent1:IsPlayer() and ent1:SCPClass() == CLASSES.SCP106 or ent2:IsPlayer() and ent2:SCPClass() == CLASSES.SCP106 then
		if ent1.ignorecollide106 or ent2.ignorecollide106 then
			return false
		end
	end
end )

if SERVER then
	net.ReceivePing( "SCP106Teleport", function( data, ply )
		if ply:SCPClass() != CLASSES.SCP106 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep:SpotTeleport( tonumber( data ) )
	end )
end

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "scp106_withering", {
	duration = 15,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/scp/106/withering.png" ) },
	},
	cantarget = function( ply )
		if !scp_spec_filter( ply ) then return false end
		if ply:GetSCP714() then return false end

		return !ply:CheckHazmat( 75, true )
	end,
	begin = function( self, ply, tier, args, refresh, decrease )
		self.duration = args[1]

		ply.SLCSCP106WitheringSlow = args[2]
		ply.SLCSCP106WitheringSlowPct = 0

		AddRoundHook( "SLCScaleSpeed", "SCP106Withering"..ply:SteamID64(), function( pl, mod )
			if pl != ply or !pl.SLCSCP106WitheringSlow then return end

			if IsFirstTimePredicted() then
				pl.SLCSCP106WitheringSlowPct = math.Approach( pl.SLCSCP106WitheringSlowPct, 1, FrameTime() * 0.1 )
			end

			mod[1] = mod[1] * ( 1 - pl.SLCSCP106WitheringSlow * pl.SLCSCP106WitheringSlowPct )
		end )
	end,
	finish = function( self, ply, tier, args, interrupt, all )
		RemoveRoundHook( "SLCScaleSpeed", "SCP106Withering"..ply:SteamID64() )
	end,
} )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/106/passive.png", "smooth" )
	icons.withering = GetMaterial( "slc/hud/upgrades/scp/106/withering.png", "smooth" )
	icons.tp = GetMaterial( "slc/hud/upgrades/scp/106/teleport.png", "smooth" )
	icons.trap = GetMaterial( "slc/hud/upgrades/scp/106/trap.png", "smooth" )
end

DefineUpgradeSystem( "scp106", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "passive1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { passive_dmg = 1.2, passive_cd = 0.85 }, icon = icons.passive},
		{ name = "passive2", cost = 1, req = { "passive1" }, reqany = false, pos = { 1, 2 },
			mod = { passive_dmg = 1.4, teleport_dmg = 1.25 }, icon = icons.passive },
		{ name = "passive3", cost = 3, req = { "passive2" }, reqany = false, pos = { 1, 3 },
			mod = { passive_dmg = 1.6, passive_cd = 0.6, teleport_dmg = 1.6 }, icon = icons.passive },

		{ name = "withering1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { attack_cd = 0.9, withering_dur = 1.3 }, icon = icons.withering },
		{ name = "withering2", cost = 1, req = { "withering1" }, reqany = false, pos = { 2, 2 },
			mod = { attack_cd = 0.75, withering_slow = 1.2 }, icon = icons.withering },
		{ name = "withering3", cost = 3, req = { "withering2" }, reqany = false, pos = { 2, 3 },
			mod = { attack_cd = 0.5, withering_dur = 2, withering_slow = 1.5 }, icon = icons.withering },

		{ name = "tp1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { spot_max = 2, spot_cd = 0.7 }, icon = icons.tp },
		{ name = "tp2", cost = 1, req = { "tp1" }, reqany = false, pos = { 3, 2 },
			mod = { spot_max = 4, tp_cd = 0.8 }, icon = icons.tp },
		{ name = "tp3", cost = 3, req = { "tp2" }, reqany = false, pos = { 3, 3 },
			mod = { spot_max = 8, spot_cd = 0.3, tp_cd = 0.6 }, icon = icons.tp },

		{ name = "trap1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { trap_cd = 0.85, trap_life = 1.2 }, icon = icons.trap },
		{ name = "trap2", cost = 1, req = { "trap1" }, reqany = false, pos = { 4, 2 },
			mod = { trap_cd = 0.65, trap_life = 1.5 }, icon = icons.trap },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --17 + 1 points -> 60% = 11 (-1 base) = 10 points
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 1 },
		{ 5, 1 },
		{ 7, 1 },
		{ 9, 1 },
		{ 12, 1 },
		{ 15, 1 },
		{ 18, 1 },
		{ 22, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local color_green = Color( 25, 200, 45 )

	local hud = SCPHUDObject( "SCP106", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "withering" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/106/withering.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
		:SetParser( function( swep, lang )
			local teeth = swep:GetTeeth()
			local dur = swep.WitheringDuration * swep:GetUpgradeMod( "withering_dur", 1 ) + swep.WitheringDurationTeeth * teeth
			local slow = swep.WitheringSlow * swep:GetUpgradeMod( "withering_slow", 1 ) + swep.WitheringSlowTeeth * teeth

			if slow > 0.8 then
				slow = 0.8
			end

			return {
				dur = MarkupBuilder.StaticPrint( dur.."s", color_green ),
				slow = MarkupBuilder.StaticPrint( math.Round( slow * 100, 1 ).."%", color_green ),
			}
		end )

	hud:AddSkill( "trap" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/106/trap.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	hud:AddSkill( "teleport" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/106/teleport.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/106/passive.png", "smooth" )
		:SetCooldownFunction( "GetPassiveCooldown" )
		:SetTextFunction( "GetTeeth" )

	hud:AddSkill( "teleport_cd" )
		:SetMaterial( "slc/hud/scp/106/teleport.png", "smooth" )
		:SetCooldownFunction( "GetNextSpot" )

	hud:AddBar( "passive_bar" )
		:SetMaterial( "slc/hud/scp/106/passive.png", "smooth" )
		:SetColor( Color( 250, 65, 250 ) )
		:SetTextFunction( function( swep )
			local hp = swep:GetPassiveDamage()
			if hp < 0 then
				hp = 0
			end

			return math.Round( hp )
		end )
		:SetProgressFunction( function( swep )
			return swep:GetPassiveDamage() / ( wep.PassiveDamage  * swep:GetUpgradeMod( "passive_dmg", 1 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetPassiveDamage() > 0
		end )

	hud:AddBar( "trap_bar" )
		:SetMaterial( "slc/hud/scp/106/shield.png", "smooth" )
		:SetColor( Color( 230, 190, 110 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			return math.Round( this.last_time or 0 ).."s"
		end )
		:SetProgressFunction( function( swep, hud_obj, this )
			local time = swep:GetTrapTime() - CurTime()
			if time > 0 then
				this.last_time = time
			end

			return ( this.last_time or 0 ) / swep.TrapTPTime
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetTrapTime() >= CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Declas
---------------------------------------------------------------------------]]
game.AddDecal( "Decal106", "decals/decal106" )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
AddAmbient( "106", "sound/scp_lc/scp/106/chase.ogg", nil, nil, 0.25, 30, 2 )

sound.Add( {
	name = "SCP106.Place",
	volume = 0.75,
	level = 75,
	pitch = 100,
	sound = "scp_lc/scp/106/place.ogg",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP106.Disappear",
	volume = 0.9,
	level = 80,
	pitch = 100,
	sound = "scp_lc/scp/106/disappear.ogg",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP106.Teleport",
	volume = 1,
	level = 85,
	pitch = 100,
	sound = "scp_lc/scp/106/tp.ogg",
	channel = CHAN_STATIC,
} )