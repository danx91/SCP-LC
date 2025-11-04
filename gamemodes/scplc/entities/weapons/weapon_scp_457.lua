SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-457"

SWEP.HoldType		= "normal"

SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage 	= true

SWEP.PassiveDamage = 2
SWEP.PassiveRadius = 100
SWEP.PassiveFuel = 0.3

SWEP.FireballCost = 30
SWEP.FireballCooldown = 8
SWEP.FireballDamage = 2

SWEP.TrapCost = 20
SWEP.MaxTraps = 4
SWEP.TrapCooldown = 5
SWEP.TrapLifeTime = 180
SWEP.TrapBurnTime = 2
SWEP.TrapBurnDamage = 3

SWEP.IgniteCooldown = 30
SWEP.IgniteCost = 5
SWEP.IgniteRate = 0.8

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Int", "Traps" )
	self:NetworkVar( "Float", "Fuel" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP457" )
	self:InitializeHUD()

	self:SetFuel( 100 )
	self.Traps = {}
end

SWEP.NextDamage = 0
SWEP.NextTrapCheck = 0
SWEP.NextIgniteTick = 0
function SWEP:Think()
	if CLIENT then return end

	local owner = self:GetOwner()
	local ct = CurTime()

	if owner:WaterLevel() > 0 then
		if self.NextDamage < ct and owner:Health() > 1 then
			self.NextDamage = self.NextDamage + 0.1

			if self.NextDamage < ct then
				self.NextDamage = ct + 0.1
			end

			owner:TakeDamage( 10, owner, owner )
		end
	elseif !owner:IsBurning() then
		local rad = self.PassiveRadius * self:GetUpgradeMod( "fire_radius", 1 )
		local dmg = self.PassiveDamage * self:GetUpgradeMod( "fire_dmg", 1 )

		local fire = owner:Burn( -3, rad, owner, dmg )
		fire:SetShouldHurtOwner( false )
		fire:SetShouldHurtParent( false )
	end

	if self.NextTrapCheck < ct then
		self.NextTrapCheck = ct + 1

		for i, v in rpairs( self.Traps ) do
			if IsValid( v ) then continue end
			table.remove( self.Traps, i )
		end

		self:SetTraps( #self.Traps )
	end

	if self.IgniteActive and self.NextIgniteTick < ct then
		local cd = self.IgniteRate * self:GetUpgradeMod( "ignite_rate", 1 )
		self.NextIgniteTick = self.NextIgniteTick + cd

		if self.NextIgniteTick < ct then
			self.NextIgniteTick = ct + cd
		end

		self:IgniteTick()
	end
end

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local fuel = self:GetFuel()
	local cost = math.ceil( self.FireballCost * self:GetUpgradeMod( "fireball_cost", 1 ) )

	if fuel < cost then return end

	local owner = self:GetOwner()
	local fireball = ents.Create( "slc_457_fireball" )
	if !IsValid( fireball ) then return end

	fireball:SetPos( owner:GetShootPos() )
	fireball:SetAngles( owner:GetAimVector():Angle() )
	fireball:SetOwner( owner )
	fireball:SetSpeed( 320 * self:GetUpgradeMod( "fireball_speed", 1 ) )
	fireball:SetDamage( self.FireballDamage * self:GetUpgradeMod( "fireball_dmg", 1 ) )
	fireball:SetSize( self:GetUpgradeMod( "fireball_size", 1 ) )
	fireball:Spawn()

	owner:EmitSound( "SCP457.Fireball" )

	self:SetNextPrimaryFire( CurTime() + self.FireballCooldown * self:GetUpgradeMod( "fireball_cd", 1 ) )
	self:SetFuel( fuel - cost )
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local fuel = self:GetFuel()
	local cost = math.ceil( self.TrapCost * self:GetUpgradeMod( "trap_cost", 1 ) )

	if fuel < cost then return end

	local owner = self:GetOwner()
	local start = owner:GetShootPos()
	local tr = util.TraceLine{
		start = start,
		endpos = start + owner:GetAimVector() * 150,
		mask = MASK_SOLID_BRUSHONLY
	}

	if !tr.Hit or tr.HitNormal.z < 0.35 then return end

	for i, v in pairs( ents.FindInSphere( tr.HitPos, 125 ) ) do
		if string.find( v:GetName(), "elev_" ) then return end
	end

	if #self.Traps >= self.MaxTraps + self:GetUpgradeMod( "trap_max", 0 ) then
		local oldest = table.remove( self.Traps, 1 )
		if IsValid( oldest ) then
			oldest:Remove()
		end
	end

	local trap = ents.Create( "slc_457_trap" )
	if !IsValid( trap ) then return end

	trap:SetPos( tr.HitPos )
	trap:SetOwner( owner )
	trap:SetLifeTime( self.TrapLifeTime * self:GetUpgradeMod( "trap_time", 1 ) )
	trap:SetBurnTime( self.TrapBurnTime )
	trap:SetDamage( self.TrapBurnDamage * self:GetUpgradeMod( "trap_dmg", 1 ) )
	trap:Spawn()

	table.insert( self.Traps, trap )

	self:SetNextSecondaryFire( CurTime() + self.TrapCooldown )
	self:SetFuel( fuel - cost )
	self:SetTraps( #self.Traps )
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post or self.IgniteActive then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	local fuel = self:GetFuel()
	if fuel < self.IgniteCost * self:GetUpgradeMod( "ignite_cost", 1 ) then return end

	self.IgniteFlames = nil
	self.IgniteFlamesZ = nil
	self.IgniteOrigin = owner:GetPos()
	self.IgniteRing = 0
	self.IgniteActive = true
	self:SetNextSpecialAttack( CurTime() + self.IgniteCooldown )
end

local fire_trace = {}
fire_trace.mask = MASK_SOLID_BRUSHONLY
fire_trace.output = fire_trace

local offset = Vector( 0, 0, 96 )
local function calc_flame( start, endpos )
	fire_trace.start = start + offset
	fire_trace.endpos = endpos + offset
	if util.TraceLine( fire_trace ).Hit then return end

	fire_trace.start = endpos + offset
	fire_trace.endpos = endpos - offset

	local tr = util.TraceLine( fire_trace )
	if !tr.Hit then return end

	return tr.HitPos
end

function SWEP:GenerateFlames()
	
end

function SWEP:IgniteTick()
	self.IgniteRing = self.IgniteRing + 1

	local fuel = self:GetFuel()
	local cost = self.IgniteCost * self:GetUpgradeMod( "ignite_cost", 1 )
	local any = false

	local ring = self.IgniteRing
	local num = ring * ( 4 + self:GetUpgradeMod( "ignite_flames", 0 ) )
	local step = math.pi * 2 / num

	local tab = {}
	self.IgniteFlames = tab

	for i = 0, num - 1 do
		local dir = Vector( math.cos( step * i ), math.sin( step * i ), 0 )
		local pos = self.IgniteOrigin + dir * 100 * ring

		local calc = calc_flame( self.IgniteOrigin, pos )
		if !calc then continue end

		local fire = ents.Create( "slc_entity_fire" )
		fire:SetPos( calc )
		fire:SetOwner( self:GetOwner() )
		fire:SetBurnTime( 1.5, 5 )
		fire:SetFireRadius( self.PassiveRadius * self:GetUpgradeMod( "fire_radius", 1 ) )
		fire:SetFireDamage( self.PassiveDamage * self:GetUpgradeMod( "fire_dmg", 1 ) )
		fire:Spawn()

		any = true
		fuel = fuel - cost

		if fuel < 0 then
			fuel = 0
			break
		end
	end

	self:SetFuel( fuel )

	if !any or fuel == 0 then
		self.IgniteActive = false
	end
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "457" )
end

function SWEP:OnUpgradeBought( name, active, group )
	if SERVER and group == "passive" then
		self:GetOwner():StopBurn() --Reset burning to apply new modifiers
	elseif name == "fuel" then
		self:SetFuel( self:GetFuel() + self:GetUpgradeMod( "fuel" ) )
	end
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP457") TransmitSCPHooks()
SCPHook( "SCP457", "EntityTakeDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP457 then return end
	if dmg:IsDamageType( DMG_BURN ) then return true end
end )

SCPHook( "SCP457", "SLCFireOnBurnPlayer", function( fire, target, dmg )
	local owner = fire:GetOwner()
	if !owner:IsPlayer() or owner:SCPClass() != CLASSES.SCP457 then return end

	local wep = owner:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local dmg_num = dmg:GetDamage()
	wep:SetFuel( wep:GetFuel() + math.ceil( dmg_num * wep.PassiveFuel * wep:GetUpgradeMod( "fire_fuel", 1 ) ) )

	local heal = wep:GetUpgradeMod( "fire_heal" )
	if heal then
		owner:AddHealth( math.ceil( dmg_num * heal ) )
	end
end )

SCPHook( "SCP457", "SLCPlayerFootstep", function( ply, foot, snd )
	if ply:SCPClass() == CLASSES.SCP457 then return true end
end )

if CLIENT then
	--Can't use SCPHook because it is added too late
	hook.Add( "SLCOnEntityIgnited", "SCP457", function( ent, fire )
		if ent != LocalPlayer() or ent:SCPClass() != CLASSES.SCP457 then return end
		fire:SetDontCreateParticles( true )
		fire.DontCreateParticlesOverride = true
	end )

	--Remove blood
	SCPHook( "SCP457", "ScalePlayerDamage", function( ply, group, dmg )
		if IsValid( ply ) and ply:SCPClass() == CLASSES.SCP457 then return true end
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/457/passive.png", "smooth" )
	icons.fireball = GetMaterial( "slc/hud/upgrades/scp/457/fireball.png", "smooth" )
	icons.trap = GetMaterial( "slc/hud/upgrades/scp/457/trap.png", "smooth" )
	icons.ignite = GetMaterial( "slc/hud/upgrades/scp/457/ignite.png", "smooth" )
end

DefineUpgradeSystem( "scp457", {
	grid_x = 5,
	grid_y = 4,
	upgrades = {
		{ name = "passive1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { fire_radius = 1.1, fire_fuel = 1.2 }, icon = icons.passive, active = true, group = "passive" },
		{ name = "passive2", cost = 1, req = { "passive1" }, reqany = false, pos = { 1, 2 },
			mod = { fire_radius = 1.25, fire_dmg = 1.15 }, icon = icons.passive, active = true, group = "passive" },
		{ name = "passive3", cost = 2, req = { "passive2" }, reqany = false, pos = { 1, 3 },
			mod = { fire_fuel = 1.5, fire_dmg = 1.25 }, icon = icons.passive, active = true, group = "passive" },
		{ name = "passive_heal1", cost = 1, req = { "passive1" }, reqany = false, pos = { 2, 2 },
			mod = { fire_heal = 0.1 }, icon = icons.passive },
		{ name = "passive_heal2", cost = 2, req = { "passive_heal1" }, reqany = false, pos = { 2, 3 },
			mod = { fire_heal = 0.25 }, icon = icons.passive },

		{ name = "fireball1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { fireball_cd = 0.75, fireball_speed = 1.1, fireball_cost = 0.85 }, icon = icons.fireball },
		{ name = "fireball2", cost = 2, req = { "fireball1" }, reqany = false, pos = { 3, 2 },
			mod = { fireball_dmg = 1.15, fireball_size = 1.2, fireball_cost = 0.67 }, icon = icons.fireball },
		{ name = "fireball3", cost = 2, req = { "fireball2" }, reqany = false, pos = { 3, 3 },
			mod = { fireball_cd = 0.4, fireball_speed = 1.3, fireball_dmg = 1.5 }, icon = icons.fireball },

		{ name = "trap1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { trap_max = 1, trap_cost = 0.9, trap_time = 1.1 }, icon = icons.trap },
		{ name = "trap2", cost = 2, req = { "trap1" }, reqany = false, pos = { 4, 2 },
			mod = { trap_max = 2, trap_dmg = 1.3, trap_time = 1.3 }, icon = icons.trap },
		{ name = "trap3", cost = 2, req = { "trap2" }, reqany = false, pos = { 4, 3 },
			mod = { trap_cost = 0.75, trap_dmg = 1.75, trap_time = 1.6 }, icon = icons.trap },

		{ name = "ignite1", cost = 2, req = {}, reqany = false, pos = { 5, 1 },
			mod = { ignite_rate = 0.66, ignite_flames = 1 }, icon = icons.ignite },
		{ name = "ignite2", cost = 2, req = { "ignite1" }, reqany = false, pos = { 5, 2 },
			mod = { ignite_cost = 0.75, ignite_flames = 2 }, icon = icons.ignite },

		{ name = "fuel", cost = 1, req = {}, reqany = false, pos = { 5, 3 },
			mod = { fuel = 200 }, icon = icons.passive, active = true },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 5, 4 }, mod = {}, active = false },
	},
	rewards = { --23 + 1 points -> 60% = 14 (-1 base) = 13 points
		_auto = { 13, 100 }
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local color_green = Color( 25, 200, 45 )

	local hud = SCPHUDObject( "SCP457", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "fireball" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/457/fireball.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
		:SetActiveFunction( function( swep )
			return swep:GetFuel() >= math.ceil( swep.FireballCost * swep:GetUpgradeMod( "fireball_cost", 1 ) )
		end )
		:SetParser( function( swep, lang )
			return {
				cost = MarkupBuilder.StaticPrint( math.ceil( swep.FireballCost * swep:GetUpgradeMod( "fireball_cost", 1 ) ), color_green )
			}
		end )

	hud:AddSkill( "trap" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/457/trap.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetTextFunction( "GetTraps" )
		:SetActiveFunction( function( swep )
			return swep:GetFuel() >= math.ceil( swep.TrapCost * swep:GetUpgradeMod( "trap_cost", 1 ) )
		end )
		:SetParser( function( swep, lang )
			return {
				cost = MarkupBuilder.StaticPrint( math.ceil( swep.TrapCost * swep:GetUpgradeMod( "trap_cost", 1 ) ), color_green )
			}
		end )

	hud:AddSkill( "ignite" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/457/ignite.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetActiveFunction( function( swep )
			return swep:GetFuel() >= swep.IgniteCost * swep:GetUpgradeMod( "ignite_cost", 1 )
		end )
		:SetParser( function( swep, lang )
			return {
				cost = MarkupBuilder.StaticPrint( math.ceil( swep.IgniteCost * swep:GetUpgradeMod( "ignite_cost", 1 ) ), color_green )
			}
		end )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/457/passive.png", "smooth" )
		:SetTextFunction( function( swep )
			return math.floor( swep:GetFuel() )
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "SCP457.Fireball",
	volume = 1,
	level = 75,
	pitch = { 90, 110 },
	sound = "ambient/fire/mtov_flame2.wav",
	channel = CHAN_STATIC,
} )