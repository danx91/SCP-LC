SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-966"

SWEP.HoldType		= "normal"

SWEP.DisableDamageEvent = true

SWEP.PassiveCooldown = 2
SWEP.PassiveRadius = 400

SWEP.AttackCooldown = 10
SWEP.AttackRange = 75
SWEP.AttackDamageMin = 5
SWEP.AttackDamageMax = 50

SWEP.MarkCooldown = 150
SWEP.MarkDuration = 20
SWEP.MarkRate = 0.9
SWEP.MarkRadius = 850

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
	
	self:NetworkVar( "Int", "LookingAtStacks" )
	self:NetworkVar( "Int", "Stacks" )
	self:NetworkVar( "Float", "NextPassive" )
	self:NetworkVar( "Float", "Channeling" )
	self:NetworkVar( "Float", "MarkTime" )
	self:NetworkVar( "Entity", "ChannelingTarget" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP966" )
	self:InitializeHUD()

	self:SetLookingAtStacks( -1 )
end

SWEP.NextSound = 0
SWEP.NextMarkTick = 0
SWEP.NextChannelingTick = 0

function SWEP:Think()
	if ROUND.preparing or ROUND.post then return end

	if CLIENT then return end

	local owner = self:GetOwner()
	local ct = CurTime()

	if self.NextSound < ct then
		self.NextSound = ct + 20

		owner:EmitSound( "SCP966.Random" )
	end

	local ent = owner:GetEyeTraceNoCursor().Entity
	if IsValid( ent ) and ent:IsPlayer() and self:CanTargetPlayer( ent ) and !ent:GetNoDraw() and hook.Run( "CanPlayerSeePlayer", owner, ent ) != false  then
		self:SetLookingAtStacks( ent:GetEffectTier( "scp966_effect" ) )
	else
		self:SetLookingAtStacks( -1 )
	end

	local channeling_time = self:GetChanneling()
	local next_passive = self:GetNextPassive()

	if next_passive <= ct and channeling_time == 0 then
		local passive_cd = self.PassiveCooldown * self:GetUpgradeMod( "passive_rate", 1 )

		next_passive = next_passive + passive_cd

		if next_passive <= ct then
			next_passive = ct + passive_cd
		end

		self:SetNextPassive( next_passive )

		local stacks = 0
		local owner_pos = owner:GetPos()
		local passive_radius = self.PassiveRadius * self:GetUpgradeMod( "passive_radius", 1 )

		passive_radius = passive_radius * passive_radius

		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( owner_pos ) > passive_radius then continue end

			local is_safe, safe_pos = v:IsInSafeSpot()
			if is_safe and !owner_pos:WithinAABox( safe_pos.mins, safe_pos.maxs ) then return end

			if v:ApplyEffect( "scp966_effect", owner ) then
				stacks = stacks + 1
			end
		end

		self:SetStacks( self:GetStacks() + stacks )
		self:AddScore( stacks )
	end

	if channeling_time != 0 then
		local channeling_a = self:HasUpgrade( "channeling_a" )
		local target = self:GetChannelingTarget()

		if channeling_time < ct or channeling_a and ( !IsValid( target ) or !target:Alive() or !target:CheckSignature( self.ChannelingSignature ) ) then
			self:SetNextPassive( ct + self.PassiveCooldown * self:GetUpgradeMod( "passive_rate", 1 ) )
			self:SetNextSecondaryFire( ct + self:GetUpgradeMod( "channeling_cd" ) )
			self:SetChanneling( 0 )
			self.SetChannelingTarget( NULL )
			self.ChannelingSignature = nil
		elseif self.NextChannelingTick <= ct then
			self.NextChannelingTick = self.NextChannelingTick + self:GetUpgradeMod( "channeling_rate" )

			if self.NextChannelingTick <= ct then
				self.NextChannelingTick = ct + self:GetUpgradeMod( "channeling_rate" )
			end

			local owner_pos = owner:GetPos()
			local range = self:GetUpgradeMod( "channeling_range" ) * self:GetUpgradeMod( "channeling_range_mul", 1 )
			
			range = range * range

			if channeling_a then
				if owner_pos:DistToSqr( target:GetPos() ) > range then
					self:SetChanneling( 1 )
				end

				target:ApplyEffect( "scp966_effect", owner )
				self:SetStacks( self:GetStacks() + 1 )
				self:AddScore( 1 )
			else
				local stacks = 0

				for i, v in ipairs( player.GetAll() ) do
					if !v:Alive() or !v:HasEffect( "scp966_effect" ) or v:GetPos():DistToSqr( owner_pos ) > range then continue end

					v:DecreaseEffect( "scp966_effect" )
					stacks = stacks + 1
				end

				self:SetStacks( self:GetStacks() + stacks )
				self:AddScore( stacks )
			end
		end
	end

	local mark_time = self:GetMarkTime()
	if mark_time != 0 then
		if mark_time < ct or !IsValid( self.MarkedPlayer ) or !self.MarkedPlayer:Alive() or !self.MarkedPlayer:CheckSignature( self.MarkedSignature ) then
			self:SetMarkTime( 0 )
			self.MarkedPlayer = nil
			self.MarkedSignature = nil
		elseif self.NextMarkTick <= ct then
			local mark_tick = self.MarkRate * self:GetUpgradeMod( "mark_rate", 1 )

			self.NextMarkTick = self.NextMarkTick + mark_tick

			if self.NextMarkTick <= ct then
				self.NextMarkTick = ct + mark_tick
			end

			local target_pos = self.MarkedPlayer:GetPos()
			local radius = self.MarkRadius * self:GetUpgradeMod( "mark_range", 1 )
			local stacks = 0

			radius = radius * radius

			for i, v in ipairs( player.GetAll() ) do
				if v == self.MarkedPlayer or !v:Alive() or !v:HasEffect( "scp966_effect" ) or v:GetPos():DistToSqr( target_pos ) > radius then continue end
	
				v:DecreaseEffect( "scp966_effect" )
				stacks = stacks + 1
			end

			if stacks > 0 then
				self.MarkedPlayer:ApplyEffect( "scp966_effect", stacks, owner )
			end
		end
	end
end

local attack_trace = {}
attack_trace.mask = MASK_SHOT
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	local owner = self:GetOwner()

	self:SetNextPrimaryFire( ct + 0.5 )

	attack_trace.start = owner:GetShootPos()
	attack_trace.endpos = attack_trace.start + owner:GetAimVector() * self.AttackRange
	attack_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceLine( attack_trace )
	owner:LagCompensation( false )

	local ent = attack_trace.Entity
	if !IsValid( ent ) then return end

	if !ent:IsPlayer() then
		self:SetNextPrimaryFire( ct + 1.5 )
		self:SCPDamageEvent( ent, 50 )

		return
	end

	if !self:CanTargetPlayer( ent ) then return end

	local ply_stacks = ent:GetEffectTier( "scp966_effect" )
	if ply_stacks < 10 then return end

	local stacks = self:GetStacks()
	local upg1 = self:HasUpgrade( "basic1" )
	local upg2 = self:HasUpgrade( "basic2" )

	local drop = 0.5

	if upg2 and stacks >= self:GetUpgradeMod( "drop2_thr" ) then
		drop = self:GetUpgradeMod( "drop2" )
	elseif upg1 and stacks >= self:GetUpgradeMod( "drop1_thr" ) then
		drop = self:GetUpgradeMod( "drop1" )
	end

	local mult = ( 1 + math.floor( stacks / self:GetUpgradeMod( "basic_stacks", 50 ) ) * self:GetUpgradeMod( "basic_dmg", 0 ) )

	owner:EmitSound( "SCP966.Attack" )
	self:SetNextPrimaryFire( ct + self.AttackCooldown )

	ent:TakeDamage( math.Map( ply_stacks, 10, 99, self.AttackDamageMin, self.AttackDamageMax ) * mult, owner, owner )
	ent:DecreaseEffect( "scp966_effect", math.floor( ply_stacks * drop ) )

	if upg2 and stacks >= self:GetUpgradeMod( "hb_thr" ) then
		ent:ApplyEffect( "heavy_bleeding", owner )
	elseif upg2 and stacks >= self:GetUpgradeMod( "bleed2_thr" ) or upg1 and stacks >= self:GetUpgradeMod( "bleed1_thr" ) and !ent:HasEffect( "bleeding" ) then
		ent:ApplyEffect( "bleeding", owner )
	end

	if upg1 and stacks >= self:GetUpgradeMod( "slow_thr" ) then
		local power = self:GetUpgradeMod( "slow_power" )
		ent:PushSpeed( power, power, -1, "SLC_SCP966Slow", 1 )

		ent:AddTimer( "SCP966Slow", self:GetUpgradeMod( "slow_dur" ), 1, function()
			ent:PopSpeed( "SLC_SCP966Slow", true )
		end )
	end

	local heal = self:GetUpgradeMod( "heal_rate", 0 ) * stacks * ply_stacks
	if heal > 0 then
		owner:AddHealth( math.ceil( heal ) )
	end
end

function SWEP:SecondaryAttack()
	if ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetChanneling() != 0 then return end

	if self:HasUpgrade( "channeling_a" ) then
		local owner = self:GetOwner()

		attack_trace.start = owner:GetShootPos()
		attack_trace.endpos = attack_trace.start + owner:GetAimVector() * self.AttackRange
		attack_trace.filter = owner

		owner:LagCompensation( true )
		util.TraceLine( attack_trace )
		owner:LagCompensation( false )

		local ent = attack_trace.Entity
		if !IsValid( ent ) or !ent:IsPlayer() or !self:CanTargetPlayer( ent ) then return end

		self:SetChannelingTarget( ent )
		self.ChannelingSignature = ent:TimeSignature()
	elseif !self:HasUpgrade( "channeling_b" ) then
		return
	end

	//self:SetNextSecondaryFire( ct + self:GetUpgradeMod( "channeling_cd" ) )
	self:SetChanneling( ct + self:GetUpgradeMod( "channeling_time" ) * self:GetUpgradeMod( "channeling_time_mul", 1 ) )
	self:SetNextPassive( 0 )
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local owner = self:GetOwner()

	attack_trace.start = owner:GetShootPos()
	attack_trace.endpos = attack_trace.start + owner:GetAimVector() * self.AttackRange
	attack_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceLine( attack_trace )
	owner:LagCompensation( false )

	local ent = attack_trace.Entity
	if !IsValid( ent ) or !ent:IsPlayer() or !self:CanTargetPlayer( ent ) then return end

	local ct = CurTime()
	self:SetNextSpecialAttack( ct + self.MarkCooldown + self.MarkDuration )
	self:SetMarkTime( ct + self.MarkDuration )
	self.MarkedPlayer = ent
	self.MarkedSignature = ent:TimeSignature()
	self.NextMarkTick = 0

	ent:ApplyEffect( "scp966_mark" )
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "966" )
end

function SWEP:OnUpgradeBought( name, active, group )
	if CLIENT then
		self.HUDObject:GetSkill( "channeling" ):SetMaterialOverride( active[1] )
		self.HUDObject:GetBar( "channeling_bar" ):SetMaterialOverride( active[1] )
	end
end

local color_white = Color( 255, 255, 255 )
function SWEP:DrawSCPHUD()
	local stacks = self:GetLookingAtStacks()
	if stacks < 0 then return end

	local w, h = ScrW() * 0.5, ScrH() * 0.5

	draw.SimpleText( self.Lang.fatigue.." "..stacks, "SCPHUDSmall", w, h + 16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP966") TransmitSCPHooks()
if CLIENT then
	local mat_ring = Material( "slc/misc/fade-u.png", "smooth" )
	local passive_color = Color( 185, 185, 185, 20 )
	local channeling_color = Color( 125, 125, 255, 20 )
	local channeling_beam = Material( "slc/misc/escort_marker.png", "smooth" )

	local steps = 30
	local ang_diff = math.pi * 2 / steps

	local tmp_color = Color( 0, 0, 0, 255 )

	SCPHook( "SCP966", "PreDrawEffects", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP966 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		local channeling = wep:GetChanneling() != 0
		if channeling and wep:HasUpgrade( "channeling_a" ) then
			local target = wep:GetChannelingTarget()
			if !IsValid( target ) then return end

			local ply_pos = ply:GetPos() + ply:OBBCenter()
			local target_pos = target:GetPos() + target:OBBCenter()
			local max_range = wep:GetUpgradeMod( "channeling_range" ) * wep:GetUpgradeMod( "channeling_range_mul", 1 )
			local dist = ply_pos:Distance( target_pos )
			local f = math.Clamp( dist / max_range, 0, 1 )

			tmp_color.r = f * 255
			tmp_color.g = ( 1 - f ) * 255
			tmp_color.b = 0

			render.SetMaterial( channeling_beam )
			render.DrawBeam( ply_pos, target_pos, 1, 0, 1, tmp_color )

			return
		end

		local pos = ply:GetPos()
		local radius

		if channeling then
			radius = wep:GetUpgradeMod( "channeling_range" ) * wep:GetUpgradeMod( "channeling_range_mul", 1 )
		else
			radius = wep.PassiveRadius * wep:GetUpgradeMod( "passive_radius", 1 )
		end

		render.SetMaterial( mat_ring )

		local prev_s = 0
		local prev_c = 1
		for i = 1, steps do
			local s = i == steps and 0 or math.sin( ang_diff * i )
			local c = i == steps and 1 or math.cos( ang_diff * i )

			render.DrawQuad(
				Vector( pos.x + prev_s * radius, pos.y + prev_c * radius, pos.z + 10 ),
				Vector( pos.x + s * radius, pos.y + c * radius, pos.z + 10 ),
				Vector( pos.x + s * radius, pos.y + c * radius, pos.z ),
				Vector( pos.x + prev_s * radius, pos.y + prev_c * radius, pos.z ),
				channeling and channeling_color or passive_color
			)

			prev_s = s
			prev_c = c
		end
	end )

	SCPHook( "SCP966", "CanPlayerSeePlayer", function( ply, target )
		if target:SCPClass() != CLASSES.SCP966 or ply:SCPTeam() == TEAM_SCP then return end

		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) and wep:GetClass() == "item_slc_nvg" and wep:GetBattery() > 0 then
			return
		end

		local nvgp = ply:GetWeapon( "item_slc_nvgplus" )
		if IsValid( nvgp ) and nvgp:GetEnabled() then
			return
		end

		local thermal = ply:GetWeapon( "item_slc_thermal" )
		if IsValid( thermal ) and thermal:GetEnabled() then
			return
		end

		return false
	end )
end

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "scp966_effect", {
	duration = 10,
	stacks = 2,
	max_tier = 100,
	finish_type = 1,
	tiers = {
		all = { icon = Material( "slc/hud/scp/966/passive.png" ) },
	},
	cantarget = function( ply )
		if !scp_spec_filter( ply ) then return false end
		if ply:GetSCP714() then return false end

		return !ply:CheckHazmat( 10, true )
	end,
	begin = function( self, ply, tier, args, refresh, decrease )
		if tier < 100 then return end

		local dmg = DamageInfo()

		dmg:SetDamage( ply:Health() )
		dmg:SetDamageType( DMG_DIRECT )

		if IsValid( args[1] ) then
			dmg:SetAttacker( args[1] )
		end

		ply:TakeDamageInfo( dmg )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "scp966_mark", {
	duration = SWEP.MarkDuration,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/scp/966/mark.png" ) },
	},
	ignore500 = true,
} )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/966/passive.png", "smooth" )
	icons.attack = GetMaterial( "slc/hud/upgrades/scp/966/attack.png", "smooth" )
	icons.mark = GetMaterial( "slc/hud/upgrades/scp/966/mark.png", "smooth" )
	icons.channeling = GetMaterial( "slc/hud/upgrades/scp/966/channeling.png", "smooth" )
	icons.channeling_a = GetMaterial( "slc/hud/upgrades/scp/966/channeling_a.png", "smooth" )
	icons.channeling_b = GetMaterial( "slc/hud/upgrades/scp/966/channeling_b.png", "smooth" )
	icons.heal = GetMaterial( "slc/hud/upgrades/scp/966/heal.png", "smooth" )
end

DefineUpgradeSystem( "scp966", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "passive1", cost = 2, req = {}, reqany = false, pos = { 1, 1 },
			mod = { passive_rate = 0.85 }, icon = icons.passive, active = false },
		{ name = "passive2", cost = 2, req = { "passive1" }, reqany = false, pos = { 1, 2 },
			mod = { passive_rate = 0.7, passive_radius = 1.25, }, icon = icons.passive, active = false },

		{ name = "basic1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { basic_dmg = 0.025, basic_stacks = 50, drop1 = 0.4, slow_power = 0.8, slow_dur = 10, bleed1_thr = 150,
			drop1_thr = 300, slow_thr = 500 }, icon = icons.attack, active = false },
		{ name = "basic2", cost = 3, req = { "basic1" }, reqany = false, pos = { 2, 2 },
			mod = { basic_dmg = 0.05, basic_stacks = 50, drop2 = 0.25, bleed2_thr = 225, drop2_thr = 750, hb_thr = 1000 }, icon = icons.attack, active = false },

		{ name = "heal", cost = 1, req = { "passive2", "basic2" }, reqany = false, pos = { 1.5, 3 },
			mod = { heal_rate = 0.001 }, icon = icons.heal, active = false },

		{ name = "channeling_a", cost = 2, req = {}, block = { "channeling_b" }, reqany = false, pos = { 3, 1 },
			mod = { channeling_range = 140, channeling_time = 15, channeling_rate = 0.75, channeling_cd = 30 }, icon = icons.channeling_a, active = { icons.channeling_a } },
		{ name = "channeling_b", cost = 3, req = {}, block = { "channeling_a" }, reqany = false, pos = { 4, 1 },
			mod = { channeling_range = 500, channeling_time = 10, channeling_rate = 1, channeling_cd = 90 }, icon = icons.channeling_b, active = { icons.channeling_b } },
		{ name = "channeling", cost = 2, req = { "channeling_a", "channeling_b" }, reqany = true, pos = { 3.5, 2 },
			mod = { channeling_range_mul = 1.25, channeling_time_mul = 1.2 }, icon = icons.channeling, active = false },

		{ name = "mark1", cost = 2, req = {}, reqany = false, pos = { 3, 3 },
			mod = { mark_rate = 0.85 }, icon = icons.mark, active = false },
		{ name = "mark2", cost = 4, req = { "mark1" }, reqany = false, pos = { 3, 4 },
			mod = { mark_rate = 0.7, mark_range = 1.33 }, icon = icons.mark, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --19/20 + 1 points -> ~60% = 14 (-1 base) = 13 points
		{ 25, 1 },
		{ 50, 1 },
		{ 100, 1 },
		{ 150, 1 },
		{ 200, 1 },
		{ 250, 1 },
		{ 300, 1 },
		{ 350, 1 },
		{ 400, 1 },
		{ 500, 1 },
		{ 600, 1 },
		{ 750, 1 },
		{ 900, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP966", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "attack" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/966/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "channeling" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/966/channeling.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )
		:SetActiveFunction( function( swep )
			return ( swep:HasUpgrade( "channeling_a" ) or swep:HasUpgrade( "channeling_b" ) ) and swep:GetChanneling() == 0
		end )

	hud:AddSkill( "mark" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/966/mark.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )

	hud:AddSkill( "passive" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/966/passive.png", "smooth" )
		:SetCooldownFunction( "GetNextPassive" )
		:SetActiveFunction( function( swep )
			return swep:GetChanneling() == 0
		end )
		:SetTextFunction( "GetStacks" )

	hud:AddBar( "channeling_bar" )
		:SetMaterial( "slc/hud/scp/966/channeling.png", "smooth" )
		:SetColor( Color( 60, 85, 95 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetChanneling() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time, 1 ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetChanneling() - CurTime() ) / swep:GetUpgradeMod( "channeling_time", 1 ) * swep:GetUpgradeMod( "channeling_time_mul", 1 )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetChanneling() > 0
		end )

	hud:AddBar( "mark_bar" )
		:SetMaterial( "slc/hud/scp/966/mark.png", "smooth" )
		:SetColor( Color( 175, 60, 25 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetMarkTime() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time, 1 ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetMarkTime() - CurTime() ) / swep.MarkDuration
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetMarkTime() > 0
		end )
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
AddSounds( "SCP966.Random", "scp_lc/scp/966/random%i.ogg", 80, 1, 100, CHAN_STATIC, 0, 5 )
AddSounds( "SCP966.Attack", "scp_lc/scp/966/slash%i.ogg", 75, 0.75, 100, CHAN_STATIC, 0, 1 )