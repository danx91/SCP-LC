SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-8602"

SWEP.HoldType		= "normal"

SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage 	= true

SWEP.PassiveCooldown = 1
SWEP.MaxOverheal = 1200
SWEP.DetectDuration = 180

SWEP.PrimaryCooldown = 4
SWEP.PrimaryDamage = 25

SWEP.DefenseTime = 8
SWEP.DefenseCooldown = 20
SWEP.DefenseReduction = 0.6
SWEP.DefenseSlow = 0.65
SWEP.DefenseRange = 300
SWEP.DefenseWidth = 90
SWEP.DefenseDamageMultiplier = 0.2

SWEP.ChargeTime = 15
SWEP.ChargeCooldown = 30
SWEP.ChargeSpeed = 2.2
SWEP.ChargeDamage = 18
SWEP.ChargePinDamage = 70
SWEP.ChargePinRange = 190

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Float", "Charge" )
	self:NetworkVar( "Float", "Overheal" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP8602" )
	self:InitializeHUD()

	self.DetectedPlayers = {}
end

local punch_angles = { Angle( -10, -5, 0 ), Angle( 10, 5, 0 ), Angle( -10, 5, 0 ), Angle( 10, -5, 0 ) }
local punch_angles_len = #punch_angles

local charge_trace = {}
charge_trace.mins = Vector( -8, -8, -24 )
charge_trace.maxs = Vector( 8, 8, 24 )
charge_trace.mask = MASK_SHOT
charge_trace.output = charge_trace

local charge_trace_offset = Vector( 0, 0, 48 )

SWEP.NextPassive = 0
SWEP.DefenseDashTime = 0
function SWEP:Think()
	local owner = self:GetOwner()
	owner:UpdateHold( self, "scp8602_def" )

	if CLIENT then return end

	local ct = CurTime()

	if self.NextPassive <= ct then
		local cd = self.PassiveCooldown * self:GetUpgradeMod( "passive_rate", 1 )
		self.NextPassive = self.NextPassive + cd

		if self.NextPassive < ct then
			self.NextPassive = ct + cd
		end

		local dur = self.DetectDuration * self:GetUpgradeMod( "detect_time", 1 )
		local affected = 0

		for i, v in ipairs( SLCZones.GetPlayersInZone( ZONE_FOREST ) ) do
			if !self:CanTargetPlayer( v ) or v:GetSCP714() or v:CheckHazmat( 30, true ) then continue end

			self.DetectedPlayers[v] = ct + dur
			affected = affected + 1

			if v:GetSanity() >= 2 then
				v:TakeSanity( 2 )
			else
				v:TakeDamage( 1, owner, owner )
			end
		end

		if affected > 0 then
			self:AddScore( affected * 3 )

			local max_hp = owner:GetMaxHealth()
			local hp = owner:Health() + affected * 12

			if hp > max_hp then
				local overheal = self:GetOverheal() + hp - max_hp
				local max_overheal = self.MaxOverheal * self:GetUpgradeMod( "overheal", 1 )
				if overheal > max_overheal then
					overheal = max_overheal
				end
				
				self:SetOverheal( overheal )

				hp = max_hp
			end

			owner:SetHealth( hp )
		end

		local transmit = {}

		for ply, time in pairs( self.DetectedPlayers ) do
			if time <= ct then
				self.DetectedPlayers[ply] = nil
			else
				local pos = ply:GetPos() + ply:OBBCenter()
				table.insert( transmit, {
					x = pos.x,
					y = pos.y,
					z = pos.z,
				} )
			end
		end

		if #transmit > 0 then
			net.SendTable( "SCP8602Detect", transmit, owner )
		end
	end

	if self.DefenseDashTime >= ct then
		owner:SetVelocity( self.DefenseDashDirection * 200 )

		if owner:GetPos():DistToSqr( self.DefenseDashStart ) >= self.DefenseDashLength then
			self.DefenseDashTime = 0
			owner:SetVelocity( -owner:GetVelocity() )
		end
	end

	local charge = self:GetCharge()
	if charge > ct then
		local start = owner:GetPos() + charge_trace_offset
		local ang = owner:GetAngles()
		ang.p = 0
		ang.r = 0

		local dir = ang:Forward()

		charge_trace.start = start
		charge_trace.endpos = start + dir * 33
		charge_trace.filter = owner

		owner:LagCompensation( true )
		util.TraceHull( charge_trace )
		owner:LagCompensation( false )

		local ent = charge_trace.Entity
		if charge_trace.Hit and IsValid( ent ) and ent:IsPlayer() and self:CanTargetPlayer( ent ) then
			self:SetCharge( 0 )
			self:SetNextSpecialAttack( ct + self.ChargeCooldown * self:GetUpgradeMod( "charge_cd", 1 ) )

			local range = self.ChargePinRange * self:GetUpgradeMod( "charge_range", 1 )
			local pct = 1 - ( charge - ct ) / ( self.ChargeTime * self:GetUpgradeMod( "charge_time", 1 ) )

			local wall_trace = util.TraceLine( {
				start = charge_trace.HitPos,
				endpos = charge_trace.HitPos + dir * ( 24 + range * pct ),
				mask = MASK_SOLID_BRUSHONLY,
			} )

			local hit_wall = wall_trace.Hit and math.abs( wall_trace.HitNormal.z ) < 0.5
			local has_upgrade = self:HasUpgrade( "charge3" )

			if hit_wall or has_upgrade and pct >= 0.8 then
				owner:EmitSound( "SCP8602.ImpactHard" )
				ent:TakeDamage( self.ChargePinDamage * self:GetUpgradeMod( "charge_pin_dmg", 1 ), owner, owner )

				owner:SetVelocity( dir * 800 )
				ent:SetVelocity( dir * 800 )

				if has_upgrade and hit_wall then
					ent:ApplyEffect( "fracture" )
				end
			else
				owner:EmitSound( "SCP8602.ImpactSoft" )
				owner:ViewPunch( punch_angles[SLCRandom( punch_angles_len )] )

				ent:TakeDamage( self.ChargeDamage * self:GetUpgradeMod( "charge_dmg", 1 ), owner, owner )
			end
		end
	elseif charge != 0 then
		self:SetCharge( 0 )
		self:SetNextSpecialAttack( ct + self.ChargeCooldown * self:GetUpgradeMod( "charge_cd", 1 ) )
	end
end

local attack_trace = {}
attack_trace.mins = Vector( -8, -8, -8 )
attack_trace.maxs = Vector( 8, 8, 8 )
attack_trace.mask = MASK_SHOT
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if !self:CanAttack() then return end

	local owner = self:GetOwner()

	attack_trace.start = owner:GetShootPos()
	attack_trace.endpos = attack_trace.start + owner:GetAimVector() * 70
	attack_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceHull( attack_trace )
	owner:LagCompensation( false )

	local ent = attack_trace.Entity
	if !attack_trace.Hit or !IsValid( ent ) then return end

	local is_player = ent:IsPlayer()
	if is_player and !self:CanTargetPlayer( ent ) then return end

	self:SetNextPrimaryFire( CurTime() + self.PrimaryCooldown * self:GetUpgradeMod( "primary_cd", 1 ) )

	self:EmitSound( "SCP8602.ImpactSoft" )
	owner:ViewPunch( punch_angles[SLCRandom( punch_angles_len )] )

	if CLIENT then return end

	if ent:IsPlayer() then
		local dmg = self.PrimaryDamage * self:GetUpgradeMod( "primary_dmg", 1 )
		ent:TakeDamage( SLCRandom( dmg - 5, dmg + 5 ), owner, owner )
	else
		self:SCPDamageEvent( ent, 50 )
	end
end

function SWEP:SecondaryAttack()
	if !self:CanAttack() then return end

	local owner = self:GetOwner()
	local time = self.DefenseTime * self:GetUpgradeMod( "def_time", 1 )

	self.MitigatedDamage = 0

	owner:StartHold( self, "scp8602_def", IN_ATTACK2, time, function()
		if CLIENT then return end
		self:PerformDefenseAttack()
	end, true )
end

function SWEP:SpecialAttack()
	if CLIENT or !self:CanAttack() then return end

	local ct = CurTime()
	self:SetCharge( ct + self.ChargeTime * self:GetUpgradeMod( "charge_time", 1 ) )
end

function SWEP:CanAttack()
	if ROUND.preparing or ROUND.post then return false end

	if self:GetCharge() >= CurTime() then return false end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "scp8602_def" ) then return false end

	return true
end

local defense_offset = Vector( 0, 0, 32 )
local defense_trace = {}
defense_trace.mask = MASK_SOLID_BRUSHONLY
defense_trace.output = defense_trace
function SWEP:PerformDefenseAttack()
	local ct = CurTime()
	self:SetNextSecondaryFire( ct + self.DefenseCooldown * self:GetUpgradeMod( "def_cooldown", 1 ) )
	
	local dmg = self.MitigatedDamage * self.DefenseDamageMultiplier * self:GetUpgradeMod( "def_mult", 1 )
	local owner = self:GetOwner()
	local pct = owner:HoldProgress( self, "scp8602_def" )
	local width = self.DefenseWidth * 0.5 * self:GetUpgradeMod( "def_width", 1 )
	local range = self.DefenseRange * pct * self:GetUpgradeMod( "def_range", 1 )

	local owner_pos = owner:GetPos()
	local ang = owner:GetAngles()
	ang.p = 0
	ang.r = 0

	local forward = ang:Forward()
	local right = ang:Right()

	self.DefenseDashDirection = forward
	self.DefenseDashTime = ct + 1
	self.DefenseDashLength = range ^ 2
	self.DefenseDashStart = owner_pos

	if dmg <= 0 then return end

	defense_trace.start = owner_pos + defense_offset

	local rect_a = owner_pos + right * width
	local rect_b = owner_pos - right * width
	local rect_c = rect_b + forward * range
	local rect_d = rect_a + forward * range

	owner:LagCompensation( true )
	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) then continue end

		local pos = v:GetPos()
		if !pos:WithinRotatedRect( rect_a, rect_b, rect_c, rect_d ) or math.abs( pos.z - owner_pos.z ) > 48 then continue end

		defense_trace.endpos = pos + defense_offset
		util.TraceLine( defense_trace )

		if defense_trace.Hit then continue end

		v:TakeDamage( dmg, owner, owner )
	end
	owner:LagCompensation( false )
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "8602" )
end

local indicator = Material( "slc/hud/scp/8602/indicator.png", "smooth" )

SWEP.DetectTime = 0
function SWEP:DrawSCPHUD()
	local ct = CurTime()
	if self.DetectTime < ct then return end

	local w = ScrW()
	local t = self.DetectTime - ct

	surface.SetDrawColor( 255, 255, 255, 255 * t )
	surface.SetMaterial( indicator )

	local size = w * 0.02

	for i, v in ipairs( self.DetectTable ) do
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
	net.AddTableChannel( "SCP8602Detect" )
end

if CLIENT then
	net.ReceiveTable( "SCP8602Detect", function( data )
		local ply = LocalPlayer()

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep.DetectTime = CurTime() + 1
		wep.DetectTable = data
	end )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP8602") TransmitSCPHooks()
SCPHook( "SCP8602", "EntityTakeDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP8602 then return end

	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) or !target:IsHolding( wep, "scp8602_def" ) then return end
	
	local pre = dmg:GetDamage()

	local f = target:HoldProgress( wep, "scp8602_def" )
	dmg:ScaleDamage( math.Map( f, 0, 1, 1, 1 - wep.DefenseReduction * wep:GetUpgradeMod( "def_prot", 1 )  ) )

	wep.MitigatedDamage = wep.MitigatedDamage + pre - dmg:GetDamage()
end )

SCPHook( "SCP8602", "SLCPostScaleDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP8602 then return end

	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) then return end
	
	local overheal = wep:GetOverheal()
	if overheal <= 0 then return end

	local dmg_num = dmg:GetDamage()
	if overheal > dmg_num then
		overheal = overheal - dmg_num
		dmg_num = 0
	else
		dmg_num = dmg_num - overheal
		overheal = 0
	end

	wep:SetOverheal( overheal )
	dmg:SetDamage( dmg_num )

	if dmg_num <= 0 then
		ApplyDamageHUDEvents( target, dmg )
		return true
	end
end )

SCPHook( "SCP8602", "StartCommand", function( ply, cmd )
	if ply:SCPClass() != CLASSES.SCP8602 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or !ply:IsHolding( wep, "scp8602_def" ) then return end

	cmd:RemoveKey( IN_JUMP )
end )

SCPHook( "SCP8602", "SLCScaleSpeed", function( ply, mod )
	if ply:SCPClass() != CLASSES.SCP8602 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end
	
	local charge = wep:GetCharge() - CurTime()

	if ply:IsHolding( wep, "scp8602_def" ) then
		local f = ply:HoldProgress( wep, "scp8602_def" )
		mod[1] = mod[1] * math.Map( f, 0, 1, 1, 1 - wep.DefenseSlow * wep:GetUpgradeMod( "def_slow", 1 ) )
	elseif charge > 0 then
		mod[1] = mod[1] * math.Map( charge / ( wep.ChargeTime * wep:GetUpgradeMod( "charge_time", 1 ) ), 1, 0, 1, wep.ChargeSpeed * wep:GetUpgradeMod( "charge_speed", 1 ) )
	end
end )

if CLIENT then
	local draw_offset = Vector( 0, 0, 6 )
	SCPHook( "SCP8602", "PostDrawTranslucentRenderables", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP8602 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or !ply:IsHolding( wep, "scp8602_def" ) then return end

		local f = ply:HoldProgress( wep, "scp8602_def" )
		local w = wep.DefenseWidth
		local h = wep.DefenseRange

		local ang = ply:GetAngles()
		ang.p = 0
		ang.r = 0

		local pos = ply:GetPos() + draw_offset
		
		ang.y = ang.y + 90
		
		cam.Start3D2D( pos, ang, 1 )
			surface.SetDrawColor( 225, 35, 35, 20 )
			surface.DrawRect( -w * 0.5, 0, w, h )

			surface.SetDrawColor( 225, 35, 35, 60 )
			surface.DrawRect( -w * 0.5, 0, w, h * f )
		cam.End3D2D()
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/8602/passive.png", "smooth" )
	icons.attack = GetMaterial( "slc/hud/upgrades/scp/8602/attack.png", "smooth" )
	icons.def = GetMaterial( "slc/hud/upgrades/scp/8602/def.png", "smooth" )
	icons.charge = GetMaterial( "slc/hud/upgrades/scp/8602/charge.png", "smooth" )
end

DefineUpgradeSystem( "scp8602", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "passive1", cost = 1, req = {}, reqany = false, pos = { 1, 1 },
			mod = { overheal = 1.5, passive_rate = 0.75, detect_time = 1.25 }, icon = icons.passive },
		{ name = "passive2", cost = 1, req = { "passive1" }, reqany = false, pos = { 1, 2 },
			mod = { overheal = 2, passive_rate = 0.5, detect_time = 1.6 }, icon = icons.passive },

		{ name = "primary", cost = 1, req = {}, reqany = false, pos = { 1, 4 },
			mod = { primary_cd = 0.8, primary_dmg = 1.25 }, icon = icons.attack },


		{ name = "def1a", cost = 1, req = {}, block = { "def1b" }, reqany = false, pos = { 2, 1 },
			mod = { def_time = 0.5, def_cooldown = 1.5 }, icon = icons.def },
		{ name = "def1b", cost = 1, req = {}, block = { "def1a" }, reqany = false, pos = { 3, 1 },
			mod = { def_time = 1.25, def_cooldown = 0.75 }, icon = icons.def },
		{ name = "def2a", cost = 1, req = { "def1a", "def1b" }, block = { "def2b" }, reqany = true, pos = { 2, 2 },
			mod = { def_range = 1.25, def_width = 0.7 }, icon = icons.def },
		{ name = "def2b", cost = 1, req = { "def1a", "def1b" }, block = { "def2a" }, reqany = true, pos = { 3, 2 },
			mod = { def_range = 0.7, def_width = 1.25 }, icon = icons.def },
		{ name = "def3a", cost = 2, req = { "def2a", "def2b" }, block = { "def3b" }, reqany = true, pos = { 2, 3 },
			mod = { def_prot = 1.5, def_slow = 1.3 }, icon = icons.def },
		{ name = "def3b", cost = 2, req = { "def2a", "def2b" }, block = { "def3a" }, reqany = true, pos = { 3, 3 },
			mod = { def_prot = 0.6, def_slow = 0.6 }, icon = icons.def },
		{ name = "def4", cost = 2, req = { "def3a", "def3b" }, reqany = true, pos = { 2.5, 4 },
			mod = { def_mult = 1.5 }, icon = icons.def },
		
		{ name = "charge1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { charge_cd = 0.8, charge_time = 1.4, charge_dmg = 1.3 }, icon = icons.charge },
		{ name = "charge2", cost = 2, req = { "charge1" }, reqany = false, pos = { 4, 2 },
			mod = { charge_range = 1.4, charge_time = 2, charge_pin_dmg = 1.4 }, icon = icons.charge },
		{ name = "charge3", cost = 2, req = { "charge2" }, reqany = false, pos = { 4, 3 },
			mod = { charge_speed = 1.25 }, icon = icons.charge },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --14 + 1 points -> 60% = 9 (-1 base) = 8 points
		{ 100, 1 },
		{ 200, 1 },
		{ 300, 1 },
		{ 450, 1 },
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
	local color_green = Color( 25, 200, 45 )

	local hud = SCPHUDObject( "SCP8602", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "primary" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/8602/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "defense" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/8602/def.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetParser( function( swep, lang )
			return {
				dmg_ratio = MarkupBuilder.StaticPrint( ( swep.DefenseDamageMultiplier * swep:GetUpgradeMod( "def_mult", 1 ) * 100 ).."%", color_green ),
			}
		end )

	hud:AddSkill( "charge" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/8602/charge.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/8602/passive.png", "smooth" )

	hud:AddBar( "overheal_bar" )
		:SetMaterial( "slc/hud/scp/8602/overheal.png", "smooth" )
		:SetColor( Color( 150, 195, 20 ) )
		:SetTextFunction( function( swep )
			return math.Round( swep:GetOverheal() )
		end )
		:SetProgressFunction( function( swep )
			return swep:GetOverheal() / swep.MaxOverheal
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetOverheal() > 0
		end )

	hud:AddBar( "defense_bar" )
		:SetMaterial( "slc/hud/scp/8602/def.png", "smooth" )
		:SetColor( Color( 185, 175, 105 ) )
		:SetTextFunction( function( swep )
			local f = LocalPlayer():HoldProgress( swep, "scp8602_def" )
			if f then
				return math.Round( swep.DefenseReduction * swep:GetUpgradeMod( "def_prot", 1 ) * f * 100 ).."%"
			end
		end )
		:SetProgressFunction( function( swep )
			return LocalPlayer():HoldProgress( swep, "scp8602_def" )
		end )
		:SetVisibleFunction( function( swep )
			return LocalPlayer():IsHolding( swep, "scp8602_def" )
		end )

	hud:AddBar( "charge_bar" )
		:SetMaterial( "slc/hud/scp/8602/charge.png", "smooth" )
		:SetColor( Color( 180, 30, 30) )
		:SetTextFunction( function( swep )
			local time = swep:GetCharge() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time )
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetCharge() - CurTime() ) / ( swep.ChargeTime * swep:GetUpgradeMod( "charge_time", 1 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetCharge() > CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "SCP8602.ImpactSoft",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "npc/antlion/shell_impact3.wav",
	channel = CHAN_STATIC,
} )

AddSounds( "SCP8602.ImpactHard", "scp_lc/scp/8602/attack%i.ogg", 75, 1, 100, CHAN_STATIC, 1, 3 )