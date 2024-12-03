SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-023"

SWEP.HoldType		= "fist"

SWEP.ScoreOnDamage	= true

SWEP.PassiveCooldown = 10
SWEP.PassiveRadius = 40 ^ 2
SWEP.PassiveDamage = 2

SWEP.DrainCooldown = 45
SWEP.DrainDuration = 10
SWEP.DrainRadius = 300
SWEP.DrainRate = 0.66

SWEP.CloneCooldown = 180

SWEP.HuntCooldown = 130
SWEP.HuntRandomRadius = 750

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
	
	self:AddNetworkVar( "Preys", "Int" )
	self:AddNetworkVar( "InvisRadius", "Int" )
	self:AddNetworkVar( "PassiveCooldown", "Float" )
	self:AddNetworkVar( "Drain", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP023" )
	self:InitializeHUD()

	self.Preys = {}
end

SWEP.NextDrain = 0
SWEP.NextPassive = 0

function SWEP:Think()
	if CLIENT or ROUND.post then return end

	self:PlayerFreeze()
	
	if ROUND.preparing then
		return
	end
	
	local ct = CurTime()
	local owner = self:GetOwner()
	local pos = owner:GetPos()

	if self.NextPassive <= ct and self:GetPassiveCooldown() < ct then
		self.NextPassive = self.NextPassive + 0.25

		if self.NextPassive <= ct then
			self.NextPassive = self.NextPassive + 0.25
		end

		local burn_dmg = self.PassiveDamage * self:GetUpgradeMod( "burn_power", 1 )
		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > self.PassiveRadius or v:IsBurning() then continue end

			v:Burn( 1.25, 0, owner, burn_dmg )
		end

		local invis_radius = self:GetInvisRadius()
		invis_radius = invis_radius * invis_radius

		for i, v in ipairs( player.GetAll() ) do
			if self.Preys[v] or !self:CanTargetPlayer( v ) or invis_radius > 0 and v:GetPos():DistToSqr( pos ) > invis_radius or !owner:TestVisibility( v ) then continue end

			self:AddPrey( v )
		end

		self:CheckPreys()
	end

	local drain = self:GetDrain()
	if drain != 0 and drain < ct then
		self:SetDrain( 0 )
		self:SetNextPrimaryFire( ct + self.DrainCooldown )
		owner:PopSpeed( "SLC_SCP023Drain", true )
	elseif drain >= ct and self.NextDrain <= ct then
		local drain_tick = self.DrainRate * self:GetUpgradeMod( "drain_rate", 1 )
		self.NextDrain = self.NextDrain + drain_tick

		if self.NextDrain <= ct then
			self.NextDrain = ct + drain_tick
		end

		local drain_radius = self.DrainRadius * self:GetUpgradeMod( "drain_dist", 1 )
		local any = false
		local drained = 0

		drain_radius = drain_radius * drain_radius

		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > drain_radius then continue end

			any = true

			local stamina = v:GetStamina() - 3
			drained = drained + 3

			if stamina <= 0 then
				drained = drained + stamina
				stamina = 0
			end

			v:SetStamina( stamina )
			v.StaminaRegen = ct + 1.5
		end

		if !any then
			self:SetDrain( 1 )
		end

		local heal = self:GetUpgradeMod( "drain_heal", 0 )
		if drained > 0 and heal > 0 then
			owner:AddHealth( math.ceil( drained * heal ) )
		end
	end
end

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetDrain() > 0 then return end

	local owner = self:GetOwner()
	local pos = owner:GetPos()

	local radius = self.DrainRadius * self:GetUpgradeMod( "drain_dist", 1 )
	radius = radius * radius

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > radius then continue end

		self:SetDrain( ct + self.DrainDuration * self:GetUpgradeMod( "drain_dur", 1 ) )
		owner:PushSpeed( 0.8, 0.8, -1, "SLC_SCP023Drain", 1 )

		return
	end
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	if IsValid( self.Clone ) then
		self.Clone:Remove()
	end

	local clone = ents.Create( "slc_023_clone" )
	if !IsValid( clone ) then return end

	self:SetNextSecondaryFire( CurTime() + self.CloneCooldown )

	self.Clone = clone

	clone:SetPos( owner:GetPos() )
	clone:Spawn()
	
	clone.OwnerSignature = owner:TimeSignature()
	clone:SetOwner( owner )
	clone:SetInvisRadius( self:GetInvisRadius() )
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end
	if !self:CheckPreys() then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local outside = owner:IsInZone( ZONE_SURFACE )
	local preys = {}

	for k, v in pairs( self.Preys ) do
		if k:IsInZone( ZONE_FLAG_ANOMALY ) or outside != k:IsInZone( ZONE_SURFACE ) then continue end
		table.insert( preys, k )
	end

	local preys_len = #preys
	if preys_len == 0 then
		self:SetNextSpecialAttack( ct + 5 )
		return
	end

	local prey = preys[math.random( preys_len )]
	local prey_pos = prey:GetPos()
	local rng_radius = self.HuntRandomRadius * self:GetUpgradeMod( "hunt_range", 1 )
	rng_radius = rng_radius * rng_radius

	local new_preys = {}
	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( prey_pos ) > rng_radius or v:GetSCP714() or v:IsInSafeSpot() then continue end

		table.insert( new_preys, v )
	end

	self:SetNextSpecialAttack( ct + 5 )

	local new_prey = new_preys[math.random( #new_preys )]
	if !new_prey then return end
	
	owner:Blink( 0, 0.5 )

	timer.Simple( 0.4, function()
		if !IsValid( self ) or !IsValid( new_prey ) or !self:CheckOwner() then return end

		owner:SetPos( new_prey:GetPos() )
		new_prey:Burn( -1, 0, owner, 5, true, true, true )

		for k, v in pairs( self.Preys ) do
			k:StopAmbient( "023" )
		end

		self.Preys = {}
		self:SetPreys( 0 )
		self:SetNextSpecialAttack( 0 )
		self:SetPassiveCooldown( CurTime() + self.PassiveCooldown )
	end )
end

function SWEP:AddPrey( ply )
	if self.Preys[ply] then return end

	local pre = table.Count( self.Preys )
	self.Preys[ply] = ply:TimeSignature()

	ply:PlayAmbient( "023", true, false, function( p )
		return !IsValid( self )
	end )

	if pre > 0 then return end

	self:SetNextSpecialAttack( CurTime() + self.HuntCooldown * self:GetUpgradeMod( "hunt_cd", 1 ) )
end

function SWEP:CheckPreys()
	local count = 0
	for k, v in pairs( self.Preys ) do
		if !IsValid( k ) then
			self.Preys[k] = nil
		elseif !k:CheckSignature( v ) then
			self.Preys[k] = nil
			k:StopAmbient( "023" )
		else
			count = count + 1
		end
	end

	self:SetPreys( count )

	if count == 0 then
		self:SetNextSpecialAttack( 0 )
		return false
	end

	return true
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "023" )
end

function SWEP:OnUpgradeBought( name, active, group )
	local radius = self:GetUpgradeMod( "invis_range", 0 )

	self:SetInvisRadius( radius )

	if IsValid( self.Clone ) then
		self.Clone:SetInvisRadius( radius )
	end
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP023") TransmitSCPHooks()
SCPHook( "SCP023", "ShouldCollide", function ( ent1, ent2 )
	if ent1:IsPlayer() and ent1:SCPClass() == CLASSES.SCP023 or ent2:IsPlayer() and ent2:SCPClass() == CLASSES.SCP023 then
		if ent1.ignorecollide106 or ent2.ignorecollide106 then
			return false
		end
	end
end )

SCPHook( "SCP023", "EntityTakeDamage", function ( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP023 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local mod = wep:GetUpgradeMod( "prot" )
	if !mod then return end

	dmg:ScaleDamage( mod )
end )

if CLIENT then
	SCPHook( "SCP023", "CanPlayerSeePlayer", function( lp, ply )
		if ply:SCPClass() != CLASSES.SCP023 or lp:SCPTeam() == TEAM_SCP then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		local invis_dist = wep:GetInvisRadius()
		if invis_dist == 0 then return end

		local dist = lp:GetPos():Distance( ply:GetPos() )
		if dist >= invis_dist then return false end

		local a = ( invis_dist - dist ) / 200
		if a > 1 then a = 1 end

		ply:SetColor( Color( 255, 255, 255, 146 + 109 * a ) )
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/023/passive.png", "smooth" )
	icons.invis = GetMaterial( "slc/hud/upgrades/scp/023/invis.png", "smooth" )
	icons.prot = GetMaterial( "slc/hud/upgrades/scp/023/prot.png", "smooth" )
	icons.drain = GetMaterial( "slc/hud/upgrades/scp/023/drain.png", "smooth" )
	icons.clone = GetMaterial( "slc/hud/upgrades/scp/023/clone.png", "smooth" )
	icons.hunt = GetMaterial( "slc/hud/upgrades/scp/023/hunt.png", "smooth" )
end

DefineUpgradeSystem( "scp023", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "passive", cost = 1, req = {}, reqany = false, pos = { 1.5, 1 },
			mod = { burn_power = 1.5 }, icon = icons.passive, active = false },

		{ name = "invis1", cost = 1, req = { "passive" }, block = { "prot1" }, reqany = false, pos = { 1, 2 },
			mod = { invis_range = 800 }, icon = icons.invis, active = true },
		{ name = "invis2", cost = 3, req = { "invis1" }, reqany = false, pos = { 1, 3 },
			mod = { invis_range = 400 }, icon = icons.invis, active = true },

		{ name = "prot1", cost = 2, req = { "passive" }, block = { "invis1" }, reqany = false, pos = { 2, 2 },
			mod = { prot = 0.8 }, icon = icons.prot, active = false },
		{ name = "prot2", cost = 2, req = { "prot1" }, reqany = false, pos = { 2, 3 },
			mod = { prot = 0.6 }, icon = icons.prot, active = false },

		{ name = "drain1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { drain_dur = 1.25, drain_dist = 1.15 }, icon = icons.drain, active = false },
		{ name = "drain2", cost = 2, req = { "drain1" }, reqany = false, pos = { 3, 2 },
			mod = { drain_rate = 0.8, drain_heal = 0.8 }, icon = icons.drain, active = false },
		{ name = "drain3", cost = 2, req = { "drain2" }, reqany = false, pos = { 3, 3 },
			mod = { drain_dur = 1.6, drain_dist = 1.4 }, icon = icons.drain, active = false },
		{ name = "drain4", cost = 2, req = { "drain3" }, reqany = false, pos = { 3, 4 },
			mod = { drain_rate = 0.5, drain_heal = 1.75 }, icon = icons.drain, active = false },

		{ name = "hunt1", cost = 2, req = {}, reqany = false, pos = { 4, 1 },
			mod = { hunt_cd = 0.9 }, icon = icons.hunt, active = false },
		{ name = "hunt2", cost = 2, req = { "hunt1" }, reqany = false, pos = { 4, 2 },
			mod = { hunt_cd = 0.75, hunt_range = 1.5 }, icon = icons.hunt, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --16 + 1 points -> ~60% = 11 (-1 base) = 10 points
		{ 50, 1 },
		{ 100, 1 },
		{ 175, 1 },
		{ 250, 1 },
		{ 350, 1 },
		{ 450, 1 },
		{ 600, 1 },
		{ 750, 1 },
		{ 950, 1 },
		{ 1200, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP023", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "drain" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/023/drain.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
		:SetActiveFunction( function( swep )
			return swep:GetDrain() == 0
		end )

	hud:AddSkill( "clone" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/023/clone.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	hud:AddSkill( "hunt" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/023/hunt.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetTextFunction( "GetPreys" )
		:SetActiveFunction( function( swep )
			return swep:GetPreys() > 0
		end )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/023/passive.png", "smooth" )
		:SetCooldownFunction( "GetPassiveCooldown" )

	hud:AddBar( "drain_bar" )
		:SetMaterial( "slc/hud/scp/023/drain.png", "smooth" )
		:SetColor( Color( 45, 55, 120 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetDrain() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time, 1 ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetDrain() - CurTime() ) / ( swep.DrainDuration * swep:GetUpgradeMod( "drain_dur", 1 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetDrain() > 0
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
AddAmbient( "023", "sound/scp_lc/scp/023/ambient.ogg", nil, nil, 0.25, 135 )