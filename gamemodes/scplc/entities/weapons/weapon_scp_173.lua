SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-173"

SWEP.HoldType		= "normal"

SWEP.ScoreOnKill	= true

SWEP.HorrorDistance	= 300
SWEP.HorrorDelay	= 10

SWEP.MoveDist		= 200
SWEP.KillDist		= 40

SWEP.GasCooldown	= 60
SWEP.GasDistance	= 600

SWEP.StealthDuration = 10
SWEP.StealthCooldown = 90
SWEP.StealthInnerRange = 200 * 200
SWEP.StealthOuterRange = 1500 * 1500

SWEP.DecoyCooldown 	= 50
SWEP.DecoyLimit 	= 1

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
	
	self:AddNetworkVar( "Freeze", "Bool" )
	self:AddNetworkVar( "InStealth", "Bool" )
	self:AddNetworkVar( "Statue", "Entity" )
	self:AddNetworkVar( "Stealth", "Float" )
	self:AddNetworkVar( "NextDecoy", "Float" )
	self:AddNetworkVar( "Decoys", "Int" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP173" )
	self:InitializeHUD()

	if CLIENT then return end

	local statue = ents.Create( "slc_173_statue" )
	if IsValid( statue ) then
		statue:Spawn()

		statue:SetNoDraw( true )
		statue:SetSolid( SOLID_NONE )
		self:DeleteOnRemove( statue )
		self:SetStatue( statue )
	end

	self.Decoys = {}
	self:SetDecoys( 1 )
end

local kill_offset = Vector( 0, 0, 32 )

local kill_trace = {}
kill_trace.mask = MASK_SHOT
kill_trace.output = kill_trace

SWEP.NextBackup = 0
SWEP.BackupPosition = nil
SWEP.NextBackupPosition = nil
function SWEP:Think()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local statue = self:GetStatue()
	if !IsValid( statue ) then return end

	local owner = self:GetOwner()
	local ct = CurTime()

	/*if self.NextBackup <= ct then
		self.NextBackup = CurTime() + 0.75

		local phys = owner:GetPhysicsObject()
		if IsValid( phys ) and phys:IsPenetrating() then
			owner:SetPos( self.BackupPosition )
			self.NextBackup = CurTime() + 3
		end

		self.BackupPosition = self.NextBackupPosition
		self.NextBackupPosition = owner:GetPos()
	end*/

	if statue:GetOwner() == NULL then
		statue:SetOwner( self:GetOwner() )
		statue:SetPos( owner:GetPos() )
	end

	if self:HasUpgrade( "decoy2" ) then
		local cd = self:GetNextDecoy()
		local decoys = self:GetDecoys()
		local max_decoys = self.DecoyLimit + self:GetUpgradeMod( "decoy_max", 0 )

		if cd == 0 then
			self:SetNextDecoy( CurTime() + self.DecoyCooldown * self:GetUpgradeMod( "decoy_cd", 1 ) )
		elseif cd < ct and decoys < max_decoys then
			self:SetDecoys( decoys + 1 )

			if decoys + 1 >= max_decoys then
				self:SetNextDecoy( 0 )
			else
				self:SetNextDecoy( CurTime() + self.DecoyCooldown * self:GetUpgradeMod( "decoy_cd", 1 ) )
			end
		end
	end

	if self:GetStealth() > ct and owner:IsInZone( ZONE_FLAG_RESTRICT173 ) then
		self:SetStealth( 0 )
	end

	if self:GetInStealth() then
		if self:GetStealth() < ct then
			self:DisableStealth()
		end

		return
	end
	
	if !self.KillerEntity then
		self.KillerEntity = owner
	end
	
	local horror_dist = self.HorrorDistance * self:GetUpgradeMod( "horror_dist", 1 )
	horror_dist = horror_dist * horror_dist

	local test_ent = self:GetFreeze() and statue or owner
	local test_pos = test_ent:GetPos()
	local freeze = false

	for i, v in ipairs( player.GetAll() ) do
		local team = v:SCPTeam()
		if !v:Alive() or team == TEAM_SPEC or team == TEAM_SCP or v:GetBlink() or !test_ent:TestVisibility( v ) then continue end

		freeze = true

		local next_horror = v:GetProperty( "SCP173NextHorror", 0 )
		if next_horror < ct and test_pos:DistToSqr( v:GetPos() ) < horror_dist then
			v:SetProperty( "SCP173NextHorror", ct + self.HorrorDelay )
			v:TakeSanity( 15 * self:GetUpgradeMod( "horror_sanity", 1 ), SANITY_TYPE.ANOMALY )
			TransmitSound( "scp_lc/scp/173/horror/horror"..math.random( 0, 9 )..".ogg", true, v )
		end
	end

	if self.RestrictFreeze then
		if freeze then
			self.RestrictFreeze = false
		else
			return
		end
	end

	self:SetFreeze( freeze )

	if freeze != self.WasFreezed then
		self:UpdateFreeze( freeze )
		return
	end

	if freeze then return end

	self:KillThink()
end

function SWEP:UpdateFreeze( freeze, restrict )
	local owner = self:GetOwner()
	local statue = self:GetStatue()

	if !freeze then
		owner:EmitSound( "SCP173.Rattle" )
		owner.N173Step = CurTime() + 0.9

		statue:MoveTo( owner:GetPos(), function()
			if !IsValid( self ) then return end

			self:KillThink()
		end, function()
			if !IsValid( self ) then return end

			if !self:GetInStealth() then
				owner:SetNoDraw( false )
				owner:SetSolid( SOLID_BBOX )
			end

			statue:SetNoDraw( true )
			statue:SetSolid( SOLID_NONE )

			self.KillerEntity = owner
		end )

		if self:GetStealth() == -1 then
			self:EnableStealth()
		end
	else
		owner:SetNoDraw( true )
		owner:SetSolid( SOLID_NONE )

		statue:SetNoDraw( false )
		statue:SetSolid( SOLID_BBOX )

		statue:SetMove( false )
		statue:SetPos( owner:GetPos() )
		statue:SetAngles( Angle( 0, owner:GetAngles().y, 0 ) )
		statue:SetOnGround( false )

		self.KillerEntity = statue
	end

	self.WasFreezed = freeze

	if restrict then
		self.RestrictFreeze = true
	end
end

function SWEP:KillThink()
	local owner = self:GetOwner()
	local killer_pos = self.KillerEntity:GetPos()

	kill_trace.filter = self.KillerEntity
	kill_trace.start = self.KillerEntity:GetPos() + kill_offset

	local kill_dist = self.KillDist * self:GetUpgradeMod( "snap_dist", 1 )
	kill_dist = kill_dist * kill_dist

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( killer_pos ) > kill_dist then continue end

		kill_trace.endpos = v:EyePos() + kill_offset

		util.TraceLine( kill_trace )
		if kill_trace.Entity != v then continue end

		local dmg = DamageInfo()
		dmg:SetAttacker( owner )
		dmg:SetDamageType( DMG_DIRECT )
		dmg:SetDamage( v:Health() )

		v:TakeDamageInfo( dmg )
		v:EmitSound( "SCP173.Snap" )
	end
end

local gas_offset = Vector( 0, 0, 16 )
local gas_angle = Angle( 0, 0, 0 )

local gas_trace = {}
gas_trace.mask = MASK_SOLID_BRUSHONLY
gas_trace.output = gas_trace

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post or self:GetInStealth() then return end
	
	self:SetNextPrimaryFire( CurTime() + self.GasCooldown * self:GetUpgradeMod( "gas_cd", 1 ) )

	local emit_ent = self:GetFreeze() and self:GetStatue() or self:GetOwner()
	local emit_pos = emit_ent:GetPos() + gas_offset

	ParticleEffect( "SLCSmoke", emit_pos, gas_angle )

	gas_trace.start = emit_pos

	local gas_dist = ( self.GasDistance * self:GetUpgradeMod( "gas_dist", 1 ) ) ^ 2

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( emit_pos ) > gas_dist then continue end

		gas_trace.endpos = v:GetPos() + gas_offset

		util.TraceLine( gas_trace )

		if !gas_trace.Hit then
			v:ApplyEffect( "gas_choke" )
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post or self:GetInStealth() or self:GetFreeze() then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	if self:HasUpgrade( "decoy2" ) then
		local decoys = self:GetDecoys()
		if decoys <= 0 then return end
		self:SetNextSecondaryFire( CurTime() + 0.5 )
		self:SetDecoys( decoys - 1 )
	else
		self:SetNextSecondaryFire( CurTime() + self.DecoyCooldown * self:GetUpgradeMod( "decoy_cd", 1 ) )
	end

	for i, v in rpairs( self.Decoys ) do
		if !IsValid( v ) or v.Attacked then
			table.remove( self.Decoys, i )
		end
	end

	if #self.Decoys >= self.DecoyLimit + self:GetUpgradeMod( "decoy_max", 0 ) then
		local oldest = table.remove( self.Decoys, 1 )
		oldest:Remove()
	end

	local decoy = ents.Create( "slc_173_decoy" )
	if !IsValid( decoy ) then return end

	decoy:Spawn()
	decoy:SetPos( owner:GetPos() )
	decoy:SetAngles( Angle( 0, owner:GetAngles().y, 0 ) )
	self:DeleteOnRemove( decoy )

	table.insert( self.Decoys, decoy )
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post or self:GetOwner():IsInZone( ZONE_FLAG_RESTRICT173 ) then return end

	if self:GetStealth() > CurTime() then
		self:SetStealth( 0 )
	end

	if self:GetInStealth() then return end

	if self:GetFreeze() then
		self:SetStealth( -1 )
	else
		self:EnableStealth()
	end
end

function SWEP:EnableStealth()
	local ct = CurTime()

	self:SetStealth( ct + self.StealthDuration * self:GetUpgradeMod( "stealth_dur", 2 ) )
	self:SetNextSpecialAttack( ct + 3 )

	self:SetInStealth( true )

	local owner = self:GetOwner()
	owner:SetNoDraw( true )
	owner:SetSolid( SOLID_NONE )
	owner:SetCustomCollisionCheck( true )
end

function SWEP:DisableStealth()
	local owner = self:GetOwner()
	local pos = owner:GetPos()

	local any_can_see = false
	local all_out = true

	if self.DoorColliding then
		self.DoorColliding = false
		return
	end

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) then continue end

		local dist = v:GetPos():DistToSqr( pos )
		if dist < self.StealthInnerRange then return end

		local visible = owner:TestVisibility( v )
		if visible and !v:GetBlink() then return end

		if dist <= self.StealthOuterRange then
			all_out = false
		end

		if visible then
			any_can_see = true
		end
	end

	if any_can_see and !owner:IsInZone( ZONE_FLAG_RESTRICT173 ) then
		owner:SetCustomCollisionCheck( false )
		self:SetNextSpecialAttack( CurTime() + self.StealthCooldown * self:GetUpgradeMod( "stealth_cd", 1 ) )
		self:SetInStealth( false )
		self:UpdateFreeze( true, true )
	elseif all_out then
		owner:SetCustomCollisionCheck( false )
		self:SetNextSpecialAttack( CurTime() + self.StealthCooldown * self:GetUpgradeMod( "stealth_cd", 1 ) )
		self:SetInStealth( false )
		self:UpdateFreeze( false )
	end
end

function SWEP:OnBlink( duration, delay )
	self.RestrictFreeze = false
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "173" )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP173") TransmitSCPHooks()
SCPHook( "SCP173", "EntityTakeDamage", function ( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP173 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local mod = wep:GetUpgradeMod( "prot" )
	if !mod then return end

	dmg:ScaleDamage( mod )
end )

SCPHook( "SCP173", "ShouldCollide", function ( ent1, ent2 )
	local ply

	if ent1:IsPlayer() and ent1:SCPClass() == CLASSES.SCP173 then
		if !ent2.ignorecollide106 then return end
		ply = ent1
	elseif ent2:IsPlayer() and ent2:SCPClass() == CLASSES.SCP173 then
		if !ent1.ignorecollide106 then return end
		ply = ent2
	end

	if !ply then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or !wep:GetInStealth() then return end

	wep.DoorColliding = true
	return false
end )

SCPHook( "SCP173", "PlayerUse", function ( ply, ent )
	if ply:SCPClass() != CLASSES.SCP173 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or ( !wep:GetFreeze() and !wep:GetInStealth() ) then return end

	return false
end )

SCPHook( "SCP173", "Move", function( ply, mv )
	if ply:SCPClass() != CLASSES.SCP173 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or !wep:GetFreeze() then return end

	local statue = wep:GetStatue()
	if !IsValid( statue ) then return end

	local ply_pos = mv:GetOrigin()
	local statue_pos = statue:GetPos()
	local dist = ply_pos:Distance( statue_pos )

	if dist >= wep.MoveDist * wep:GetUpgradeMod( "move_dist", 1 ) then
		local dir = statue_pos - ply_pos
		dir:Normalize()

		mv:SetVelocity( dir * 100 )
		mv:SetForwardSpeed( 0 )
		mv:SetSideSpeed( 0 )
	end
end )

SCPHook( "SCP173", "SLCPlayerFootstep", function( ply, foot, snd )
	if ply:SCPClass() != CLASSES.SCP173 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end

	if wep:GetFreeze() or wep:GetInStealth() then return true end
	
	local ct = CurTime()
	if !ply.Next173Step or ply.Next173Step < ct then
		ply.Next173Step = ct + 0.9
		ply:EmitSound( "SCP173.Rattle" )
	end

	return true
end )

SCPHook( "SCP173", "SLCBlink", function( ply, duration, delay )
	if ply:SCPClass() != CLASSES.SCP173 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end

	wep:OnBlink( duration, delay )
end )

if CLIENT then
	SCPHook( "SCP173", "ScalePlayerDamage", function( ply, group, dmg )
		if !IsValid( ply ) or ply:SCPClass() != CLASSES.SCP173 then return end
		return true
	end )

	local mat_ring = Material( "slc/misc/fade-u.png", "smooth" )
	local ring_color = Color( 255, 0, 0, 40 )

	local steps = 30
	local ang_diff = math.pi * 2 / steps

	SCPHook( "SCP173", "PreDrawEffects", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP173 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or !wep:GetFreeze() then return end

		local statue = wep:GetStatue()
		if !IsValid( statue ) then return end

		render.SetMaterial( mat_ring )

		local pos = statue:GetPos()
		local radius = wep.MoveDist * wep:GetUpgradeMod( "move_dist", 1 )

		local prev_s = 0
		local prev_c = 1
		for i = 1, steps do
			local s = i == steps and 0 or math.sin( ang_diff * i )
			local c = i == steps and 1 or math.cos( ang_diff * i )

			render.DrawQuad(
				Vector( pos.x + prev_s * radius, pos.y + prev_c * radius, pos.z + 30 ),
				Vector( pos.x + s * radius, pos.y + c * radius, pos.z + 30 ),
				Vector( pos.x + s * radius, pos.y + c * radius, pos.z ),
				Vector( pos.x + prev_s * radius, pos.y + prev_c * radius, pos.z ),
				ring_color
			)

			prev_s = s
			prev_c = c
		end
	end )

	local overlay = GetMaterial( "slc/misc/exhaust.png", "smooth" )
	SCPHook( "SCP173", "SLCScreenMod", function( clr )
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP173 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or !wep:GetInStealth() then return end

		clr.colour = 0

		surface.SetMaterial( overlay )
		surface.SetDrawColor( 25, 25, 25, 125 )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	end )

	hook.Add( "SLCGamemodeLoaded", "SCP173ThermoFilter", function()
		SLC_THERMAL_FILTER["models/scp/173.mdl"] = true
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.horror = GetMaterial( "slc/hud/upgrades/scp/173/horror.png", "smooth" )
	icons.freeze = GetMaterial( "slc/hud/upgrades/scp/173/freeze.png", "smooth" )
	icons.gas = GetMaterial( "slc/hud/upgrades/scp/173/gas.png", "smooth" )
	icons.decoy = GetMaterial( "slc/hud/upgrades/scp/173/decoy.png", "smooth" )
	icons.stealth = GetMaterial( "slc/hud/upgrades/scp/173/stealth.png", "smooth" )
	icons.prot = GetMaterial( "slc/hud/upgrades/scp/173/prot.png", "smooth" )
end

DefineUpgradeSystem( "scp173", {
	grid_x = 5,
	grid_y = 4,
	upgrades = {
		{ name = "horror_a", cost = 1, req = {}, block = { "horror_b" }, reqany = false, pos = { 1, 1 },
			mod = { horror_dist = 1.33 }, icon = icons.horror, active = false },
		{ name = "horror_b", cost = 1, req = {}, block = { "horror_a" }, reqany = false, pos = { 2, 1 },
			mod = { horror_sanity = 1.4 }, icon = icons.horror, active = false },
		{ name = "attack_a", cost = 2, req = { "horror_a", "horror_b" }, block = { "attack_b" }, reqany = true, pos = { 1, 2 },
			mod = { snap_dist = 1.2 }, icon = icons.freeze, active = false },
		{ name = "attack_b", cost = 2, req = { "horror_a", "horror_b" }, block = { "attack_a" }, reqany = true, pos = { 2, 2 },
			mod = { move_dist = 1.2 }, icon = icons.freeze, active = false },
		{ name = "prot1", cost = 2, req = { "attack_a", "attack_b" }, reqany = true, pos = { 2, 3 },
			mod = { prot = 0.25 }, icon = icons.prot, active = false, additive = true },

		{ name = "gas1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { gas_dist = 1.15 }, icon = icons.gas, active = false },
		{ name = "gas2", cost = 2, req = { "gas1" }, reqany = false, pos = { 3, 2 },
			mod = { gas_dist = 1.4, gas_cd = 0.8 }, icon = icons.gas, active = false },
		{ name = "prot2", cost = 2, req = { "gas2" }, reqany = false, pos = { 3, 3 },
			mod = { prot = 0.25 }, icon = icons.prot, active = false, additive = true },

		{ name = "decoy1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { decoy_cd = 0.66 }, icon = icons.decoy, active = false },
		{ name = "decoy2", cost = 2, req = { "decoy1" }, reqany = false, pos = { 4, 2 },
			mod = { decoy_max = 2 }, icon = icons.decoy, active = false },
		{ name = "prot3", cost = 1, req = { "decoy2" }, reqany = false, pos = { 4, 3 },
			mod = { prot = 0.25 }, icon = icons.prot, active = false, additive = true },

		{ name = "stealth1", cost = 2, req = {}, reqany = false, pos = { 5, 1 },
			mod = { stealth_cd = 0.9 }, icon = icons.stealth, active = false },
		{ name = "stealth2", cost = 2, req = { "stealth1" }, reqany = false, pos = { 5, 2 },
			mod = { stealth_cd = 0.8, stealth_dur = 1.5 }, icon = icons.stealth, active = false },
		{ name = "prot4", cost = 1, req = { "stealth2" }, reqany = false, pos = { 5, 3 },
			mod = { prot = 0.25 }, icon = icons.prot, active = false, additive = true },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 1, 4 }, mod = {}, active = false },
	},
	rewards = { --19 + 1 points -> ~70% = 14 (-1 base) = 13 points
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 1 },
		{ 4, 1 },
		{ 5, 2 },
		{ 6, 1 },
		{ 7, 1 },
		{ 8, 1 },
		{ 9, 1 },
		{ 10, 1 },
		{ 12, 1 },
		{ 14, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
local restricted_color = Color( 200, 100, 100 )

if CLIENT then
	local hud = SCPHUDObject( "SCP173", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "gas" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/173/gas.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "decoy" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/173/decoy.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetActiveFunction( function( swep )
			return !swep:HasUpgrade( "decoy2" ) or swep:GetDecoys() > 0
		end )

	hud:AddSkill( "stealth" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/173/stealth.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetActiveFunction( function( swep )
			return swep:GetStealth() != -1 and !swep:GetOwner():IsInZone( ZONE_FLAG_RESTRICT173 )
		end )

	hud:AddSkill( "looked_at" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/173/freeze.png", "smooth" )
		:SetActiveFunction( "GetFreeze" )

	hud:AddSkill( "next_decoy" )
		:SetMaterial( "slc/hud/scp/173/decoy.png", "smooth" )
		:SetCooldownFunction( "GetNextDecoy" )
		:SetVisibleFunction( function( swep )
			return swep:HasUpgrade( "decoy2" )
		end )
		:SetActiveFunction( function( swep )
			return swep:GetDecoys() > 0
		end )
		:SetTextFunction( function( swep )
			return swep:GetDecoys()
		end )

	hud:AddBar( "stealth_bar" )
		:SetMaterial( "slc/hud/scp/173/stealth.png", "smooth" )
		:SetColor( Color( 150, 150, 150 ) )
		:SetProgressFunction( function( swep, hud_obj, this )
			if this._restricted then
				return 1
			end

			return ( swep:GetStealth() - CurTime() ) / ( swep.StealthDuration * swep:GetUpgradeMod( "stealth_dur", 2 ) )
		end )
		:SetTextFunction( function( swep, hud_obj, this )
			if this._restricted then
				return swep.Lang.restricted
			end
		end )
		:SetVisibleFunction( function( swep, hud_obj, this )
			local in_stealth = swep:GetInStealth()

			if in_stealth and swep:GetStealth() < CurTime() then
				this:SetColorOverride( restricted_color )
				this._restricted = true
			else
				this:SetColorOverride()
				this._restricted = false
			end

			return in_stealth
		end )
end

--[[-------------------------------------------------------------------------
Particles
---------------------------------------------------------------------------]]
PrecacheParticleSystem( "SLCSmoke" )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
//AddSounds( "SCP173.Horror", "scp_lc/scp/173/horror/horror%i.ogg", 0, 1, 100, CHAN_STATIC, 0, 9 )
AddSounds( "SCP173.Rattle", "scp_lc/scp/173/rattle%i.ogg", 100, 1, 100, CHAN_STATIC, 1, 3 )
AddSounds( "SCP173.Snap", "scp_lc/scp/173/neck_snap%i.ogg", 511, 1, 100, CHAN_STATIC, 1, 3 )