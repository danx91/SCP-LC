SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-939"

SWEP.HoldType		= "normal"

SWEP.Secondary.Automatic = true

SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage 	= true

SWEP.AuraRadius = 130

SWEP.AttackCooldown = 2
SWEP.AttackDamage = 30
SWEP.AttackAngle = math.pi / 4
SWEP.AttackAngleCos = math.cos( SWEP.AttackAngle / 2 ) --Don't change
SWEP.AttackRange = 75

SWEP.TrailDamage = 1
SWEP.TrailRadius = 130
SWEP.TrailDuration = 4
SWEP.TrailStacksRate = 10
SWEP.MaxTrailStacks = 8

SWEP.SpecialCooldown = 90
SWEP.SpecialRadius = 1200
SWEP.SpecialRate = 1.5
SWEP.SpecialTimes = 8

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "PassiveStacks", "Int" )
	self:AddNetworkVar( "NextPassive", "Float" )
	self:AddNetworkVar( "Reveal", "Float" )

end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP939" )
	self:InitializeHUD()

	self.Trail = List()
end

SWEP.NextPassiveAMN = 0
function SWEP:Think()
	if CLIENT then return end

	self:PlayerFreeze()

	local ct = CurTime()
	local owner = self:GetOwner()

	if self.NextPassiveAMN < ct then
		self.NextPassiveAMN = ct + 0.5

		local owner_pos = owner:GetPos()
		local aura_radius = self.AuraRadius * self:GetUpgradeMod( "aura_radius", 1 )
		local aura_dmg = self:GetUpgradeMod( "aura_damage", 0 )

		for i, v in ipairs( FindInCylinder( owner_pos, aura_radius, -32, 96, nil, MASK_SOLID_BRUSHONLY, player.GetAll() ) ) do
			if v == owner or !self:CanTargetPlayer( v ) then continue end

			v:ApplyEffect( "amnc227", owner, aura_dmg )
		end

		local trail_radius = self.TrailRadius * self:GetUpgradeMod( "trail_radius", 1 )
		local trail_dmg = self.TrailDamage + self:GetUpgradeMod( "trail_dmg", 0 )

		local oldest = self.Trail:Head()
		if oldest and oldest.die_time <= ct then
			self.Trail:PopFront()
		end

		for v in self.Trail:Iter() do
			local filter = {}

			for i, ply in ipairs( FindInCylinder( v.pos, trail_radius, -32, 64, nil, MASK_SOLID_BRUSHONLY, player.GetAll() ) ) do
				if filter[ply] or ply == owner or !self:CanTargetPlayer( ply ) then continue end
	
				filter[ply] = true
				ply:ApplyEffect( "amnc227", owner, trail_dmg )
			end
		end
	end

	local passive = self:GetNextPassive()
	local stacks = self:GetPassiveStacks()
	local stacks_max = math.ceil( self.MaxTrailStacks * self:GetUpgradeMod( "trail_stacks", 1 ) )

	if passive < ct and stacks < stacks_max then
		local cd = self.TrailStacksRate * self:GetUpgradeMod( "trail_rate", 1 )
		passive = passive + cd

		if passive < ct then
			passive = ct + cd
		end

		self:SetNextPassive( passive )
		self:SetPassiveStacks( stacks + 1 )
	end
end

local attack_offset = Vector( 0, 0, 32 )
local attack_trace = {}
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local owner_pos = owner:GetPos()
	local owner_ang = owner:GetAngles()
	
	owner_ang.p = 0
	owner_ang.r = 0

	local forward = owner_ang:Forward()

	attack_trace.start = owner_pos + attack_offset
	attack_trace.mask = MASK_SOLID_BRUSHONLY
	attack_trace.filter = owner

	local dmg = self.AttackDamage * self:GetUpgradeMod( "attack_dmg", 1 )
	local range = ( self.AttackRange * self:GetUpgradeMod( "attack_range", 1 ) ) ^ 2
	local bleed = self:HasUpgrade( "attack3" )
	local any = false

	owner:LagCompensation( true )
	for i, v in ipairs( player.GetAll() ) do
		if v == owner or !self:CanTargetPlayer( v ) then continue end

		local pos = v:GetPos()
		local diff = pos - owner_pos

		if math.abs( diff.z ) > 48 then continue end

		local dist = diff:Length2DSqr()
		diff:Normalize()

		if dist > range or forward:Dot( diff ) < self.AttackAngleCos then continue end

		attack_trace.endpos = pos + attack_offset
		util.TraceLine( attack_trace )

		if attack_trace.Hit then continue end

		local dmg_info = DamageInfo()

		dmg_info:SetAttacker( owner )
		dmg_info:SetDamage( dmg )

		if bleed then
			dmg_info:SetDamageType( DMG_SLASH )
		end

		v:TakeDamageInfo( dmg_info )
		any = true
	end
	owner:LagCompensation( false )

	local cd = self.AttackCooldown * self:GetUpgradeMod( "attack_cd", 1 )

	if any then
		owner:EmitSound( "SCP939.Attack" )
		self:SetNextPrimaryFire( ct + cd )
		return
	end

	attack_trace.start = owner:GetShootPos()
	attack_trace.endpos = attack_trace.start + owner:GetAimVector() * 75
	attack_trace.mask = MASK_SHOT
	util.TraceLine( attack_trace )

	if !attack_trace.Hit then return end

	local ent = attack_trace.Entity
	if !IsValid( ent ) or ent:IsPlayer() then return end

	owner:EmitSound( "SCP939.Attack" )
	self:SetNextPrimaryFire( ct + cd )
	self:SCPDamageEvent( ent, 50 )
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local stacks = self:GetPassiveStacks()
	if stacks <= 0 then return end

	local owner = self:GetOwner()
	local pos = owner:GetPos()
	local radius = ( self.TrailRadius * self:GetUpgradeMod( "trail_radius", 1 ) * 0.75 ) ^ 2

	local prev = self.Trail:Tail()
	if prev and prev.pos:Distance2DSqr( pos ) <= radius then return end

	local ct = CurTime()
	self:SetNextSecondaryFire( ct + 0.25 )
	self:SetPassiveStacks( stacks - 1 )

	self.Trail:PushBack( {
		pos = pos,
		die_time = ct + self.TrailDuration * self:GetUpgradeMod( "trail_life", 1 )
	} )
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	self:SetNextSpecialAttack( CurTime() + self.SpecialCooldown * self:GetUpgradeMod( "special_cd", 1 ) + self.SpecialTimes * self.SpecialRate )

	local empty_filter = RecipientFilter()
	local owner = self:GetOwner()
	local radius = ( self.SpecialRadius * self:GetUpgradeMod( "special_radius", 1 ) ) ^ 2

	owner:AddTimer( "SCP939Special", self.SpecialRate, math.ceil( self.SpecialTimes * self:GetUpgradeMod( "special_times", 1 ) ), function()
		if !IsValid( self ) then return end

		local pos = owner:GetPos()

		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > radius then continue end

			v:EmitSound( "AlyxEMP.Stop", 100, 100, 1, CHAN_STATIC, SND_STOP, 0, empty_filter )
		end
	end )
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "939" )
end

--[[-------------------------------------------------------------------------
Net
---------------------------------------------------------------------------]]
local scp939_sounds = {}

if SERVER then
	util.AddNetworkString( "SCP939Sound" )
end

if CLIENT then
	net.Receive( "SCP939Sound", function( len )
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP939 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		local pos = net.ReadVector()
		local lvl = net.ReadFloat()
		local vol = net.ReadFloat()

		table.insert( scp939_sounds, {
			pos = pos,
			radius = 5,
			max_radius = lvl / 75 * 150,
			max_thickness = vol * 6,
			thickness = 0,
		} )
	end )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP939") TransmitSCPHooks()
SCPHook( "SCP939", "StartCommand", function( ply, cmd )
	if ply:HasEffect( "amnc227" ) then
		cmd:RemoveKey( IN_ATTACK )
		cmd:RemoveKey( IN_ATTACK2 )
	end
end )

if SERVER then
	SCPHook( "SCP939", "EntityEmitSound", function( data )
		if data.Volume == 0 then return end
	
		local pos = data.Pos or IsValid( data.Entity ) and data.Entity:GetPos()
		if !pos then return end

		local n = 1
		local tab = {}
	
		for i, v in ipairs( player.GetAll() ) do
			if v:SCPClass() != CLASSES.SCP939 or !v:TestPVS( pos ) then continue end
	
			tab[n] = v
			n = n + 1
		end
	
		if n == 1 then return end
	
		net.Start( "SCP939Sound" )
			net.WriteVector( pos )
			net.WriteFloat( data.SoundLevel )
			net.WriteFloat( data.Volume )
		net.Send( tab )
	end )
end

SCPHook( "SCP939", "SLCScreenMod", function( clr )
	local ply = LocalPlayer()

	if ply:HasEffect( "amnc227" ) then
		DrawMotionBlur( 0.1, 1, 0.01 )

		clr.colour = 0.5
		clr.contrast = clr.contrast + 0.5
		clr.brightness = clr.brightness - 0.01
	elseif ply:SCPClass() == CLASSES.SCP939 then
		clr.mul_r = 0
		clr.mul_g = 0
		clr.mul_b = 0
		clr.add_r = 0
		clr.add_g = 0
		clr.add_b = 0

		clr.brightness = 2
		clr.contrast = 0.35
		clr.colour = 0
		clr.inv = 1

		return true
	end
end )

SCPHook( "SCP939", "SLCPostScreenMod", function()
	local ply = LocalPlayer()
	if ply:SCPClass() != CLASSES.SCP939 then return end

	DrawSobel( 0.01 )

	return true
end )

SCPHook( "SCP939", "CanPlayerSeePlayer", function( ply, target )
	if ply:SCPClass() != CLASSES.SCP939 then return end
	return target:SCPTeam() == TEAM_SCP
end )

local quality = 30
local propagation_speed = 150
local color_none = Color( 0, 0, 0, 0 )
SCPHook( "SCP939", "PostDrawTranslucentRenderables", function()
	local ply = LocalPlayer()
	if ply:SCPClass() != CLASSES.SCP939 then return end

	for i, v in rpairs( scp939_sounds ) do
		v.radius = v.radius + propagation_speed * FrameTime()

		local f = 1 - v.radius / v.max_radius

		v.thickness = v.max_thickness * f

		if f <= 0 then
			table.remove( scp939_sounds, i )
		end
	end

	render.SetColorMaterial()

	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_ALWAYS )

	render.SetStencilTestMask( 255 )
	render.SetStencilWriteMask( 255 )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilZFailOperation( STENCIL_INCR )
	for i, v in ipairs( scp939_sounds ) do
		render.DrawSphere( v.pos, v.radius - v.thickness, quality, quality, color_none )
	end

	render.SetStencilZFailOperation( STENCIL_DECR )
	for i, v in ipairs( scp939_sounds ) do
		render.DrawSphere( v.pos, -v.radius + v.thickness, quality, quality, color_none )
	end

	render.SetStencilZFailOperation( STENCIL_INCR )
	for i, v in ipairs( scp939_sounds ) do
		render.DrawSphere( v.pos, -v.radius - v.thickness, quality, quality, color_none )
	end

	render.SetStencilZFailOperation( STENCIL_DECR )
	for i, v in ipairs( scp939_sounds ) do
		render.DrawSphere( v.pos, v.radius + v.thickness, quality, quality, color_none )
	end

	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.SetStencilCompareFunction( STENCIL_LESSEQUAL )

	render.DrawScreenQuad()

	render.SetStencilEnable( false )
end )

--[[-------------------------------------------------------------------------
AMN-C227
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "amnc227", {
	duration = 3,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/amn-c227.png" ) }
	},
	cantarget = scp_spec_hazard_filter( 10 ),
	begin = function( self, ply, tier, args, refresh, decrease )
		self.args[1] = args[1] --attacker
		self.args[3] = args[1]:TimeSignature()

		if args[2] and ( !self.args[2] or args[2] > self.args[2] ) then
			self.args[2] = args[2]
		end
	end,
	think = function( self, ply, tier, args )
		if SERVER then
			if !args[2] or ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

			local att = args[1]
			local dmg = DamageInfo()

			dmg:SetDamage( args[2] )
			dmg:SetDamageType( DMG_POISON )

			if IsValid( att ) and att:CheckSignature( args[3] ) then
				dmg:SetAttacker( att )
			end

			ply:TakeDamageInfo( dmg )
		end
	end,
	wait = 1.5,
} )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/939/passive.png", "smooth" )
	icons.attack = GetMaterial( "slc/hud/upgrades/scp/939/attack.png", "smooth" )
	icons.trail = GetMaterial( "slc/hud/upgrades/scp/939/trail.png", "smooth" )
	icons.special = GetMaterial( "slc/hud/upgrades/scp/939/special.png", "smooth" )
end

DefineUpgradeSystem( "scp939", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "attack1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { attack_cd = 0.9, attack_dmg = 1.3 }, icon = icons.attack },
		{ name = "attack2", cost = 1, req = { "attack1" }, reqany = false, pos = { 1, 2 },
			mod = { attack_cd = 0.7, attack_range = 1.1 }, icon = icons.attack },
		{ name = "attack3", cost = 3, req = { "attack2" }, reqany = false, pos = { 1, 3 },
			mod = { attack_dmg = 1.5, attack_range = 1.25 }, icon = icons.attack },

		{ name = "passive1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { aura_radius = 1.1, aura_damage = 1 }, icon = icons.passive },
		{ name = "passive2", cost = 2, req = { "passive1" }, reqany = false, pos = { 2, 2 },
			mod = { aura_radius = 1.2, aura_damage = 2 }, icon = icons.passive },
		{ name = "passive3", cost = 2, req = { "passive2" }, reqany = false, pos = { 2, 3 },
			mod = { aura_radius = 1.4, aura_damage = 3 }, icon = icons.passive },

		{ name = "trail1", cost = 1, req = { "passive1" }, reqany = false, pos = { 3, 2 },
			mod = { trail_radius = 1.25, trail_rate = 0.8 }, icon = icons.trail },
		{ name = "trail2", cost = 2, req = { "trail1" }, reqany = false, pos = { 3, 3 },
			mod = { trail_dmg = 1, trail_stacks = 1.5 }, icon = icons.trail },
		{ name = "trail3a", cost = 2, req = { "trail2" }, block = { "trail3b", "trail3c" }, reqany = false, pos = { 2, 4 },
			mod = { trail_life = 3.33, trail_radius = 1.5 }, icon = icons.trail },
		{ name = "trail3b", cost = 2, req = { "trail2" }, block = { "trail3a", "trail3c" }, reqany = false, pos = { 3, 4 },
			mod = { trail_stacks = 6 }, icon = icons.trail },
		{ name = "trail3c", cost = 2, req = { "trail2" }, block = { "trail3a", "trail3b" }, reqany = false, pos = { 4, 4 },
			mod = { trail_rate = 0.2 }, icon = icons.trail },

		{ name = "special1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { special_cd = 0.75, special_radius = 1.15 }, icon = icons.special },
		{ name = "special2", cost = 1, req = { "special1" }, reqany = false, pos = { 4, 2 },
			mod = { special_cd = 0.5, special_times = 1.5 }, icon = icons.special },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 3 }, mod = {}, active = false },
	},
	rewards = { --17 + 1 points -> 60% = 11 (-1 base) = 10 points
		{ 75, 1 },
		{ 150, 1 },
		{ 225, 1 },
		{ 300, 1 },
		{ 400, 1 },
		{ 500, 1 },
		{ 600, 1 },
		{ 750, 1 },
		{ 900, 1 },
		{ 1100, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP939", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "primary" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/939/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "trail" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/939/trail.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetTextFunction( "GetPassiveStacks" )

	hud:AddSkill( "special" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/939/special.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/939/passive.png", "smooth" )
		:SetCooldownFunction( "GetNextPassive" )

	hud:AddBar( "special_bar" )
		:SetMaterial( "slc/hud/scp/939/special.png", "smooth" )
		:SetColor( Color( 90, 225, 40 ) )
		:SetTextFunction( function( swep )
			local cd = swep.SpecialCooldown
			local time = ( swep:GetNextSpecialAttack() - cd - CurTime() )

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			local cd = swep.SpecialCooldown

			return ( swep:GetNextSpecialAttack() - cd - CurTime() ) / ( swep.SpecialTimes * swep.SpecialRate )
		end )
		:SetVisibleFunction( function( swep )
			local cd = swep.SpecialCooldown
			return swep:GetNextSpecialAttack() - cd > CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "SCP939.Attack",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "scp_lc/scp/939/attack.ogg",
	channel = CHAN_STATIC,
} )