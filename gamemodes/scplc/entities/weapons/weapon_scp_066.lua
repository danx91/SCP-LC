SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-066"

SWEP.HoldType		= "normal"

SWEP.ScoreOnDamage 	= true

SWEP.EricCooldown = 14
SWEP.MaxEricStacks = 75

SWEP.MusicCooldown = 12
SWEP.MusicLength = 22
SWEP.MusicDamage = 3
SWEP.MusicRange = 650

SWEP.DashCooldown = 25
SWEP.DashDetachTime = 6

SWEP.SpecialCooldown = 48
SWEP.SpecialDuration = 16
SWEP.SpecialSpeed = 0.013
SWEP.SpecialDefense = 0.01
SWEP.SpecialHeal = 0.6
SWEP.SpecialHealTicks = 14

if CLIENT then
	SWEP.BoostMaterials = {
		"slc/hud/scp/066/speed.png",
		"slc/hud/scp/066/prot.png",
		"slc/hud/scp/066/regen.png",
	}
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Eric", "Int" )
	self:AddNetworkVar( "SpecialType", "Int" )
	self:AddNetworkVar( "NextEric", "Float" )
	self:AddNetworkVar( "NextDash", "Float" )
	self:AddNetworkVar( "DetachTime", "Float" )
	self:AddNetworkVar( "LastDamaged", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP066" )
	self:InitializeHUD()
end

local dash_trace = {}
dash_trace.mins = Vector( -8, -8, -12 )
dash_trace.maxs = Vector( 8, 8, 8 )
dash_trace.mask = MASK_SOLID
dash_trace.output = dash_trace

SWEP.MusicAttack = 0
SWEP.NextMusicAttackTick = 0
function SWEP:Think()
	self:PlayerFreeze()

	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local eric = self:GetNextEric()
	local eric_stacks = self:GetEric()

	if self.MusicAttack < ct and eric <= ct and eric_stacks < self.MaxEricStacks then
		local can_attack, any_player = self:CanAttack()
		if can_attack or !any_player then
			self:SetNextEric( ct + 1 )
		else
			owner:EmitSound( "SCP066.Eric" )
			self:SetEric( eric_stacks + 1 )
			self:AddScore( 20 )
			self:SetNextEric( ct + self.EricCooldown * self:GetUpgradeMod( "eric_cd", 1 ) )

			if self:GetNextPrimaryFire() < ct + 1.5 then
				self:SetNextPrimaryFire( ct + 1.5 )
			end
		end
	end

	if self.MusicAttack >= ct and self.NextMusicAttackTick <= ct then
		self.NextMusicAttackTick = self.NextMusicAttackTick + 1

		if self.NextMusicAttackTick < ct then
			self.NextMusicAttackTick = ct + 1
		end

		local pos = owner:GetPos()
		local dmg = self.MusicDamage * self:GetUpgradeMod( "music_damage", 1 )
		local max_dist = self.MusicRange * self:GetUpgradeMod( "music_range", 1 )

		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) then continue end

			local is_safe, safe_pos = v:IsInSafeSpot()
			if is_safe and !pos:WithinAABox( safe_pos.mins, safe_pos.maxs ) then continue end

			local dist = v:GetPos():Distance( pos )
			local pct = 1 - dist / max_dist
			if pct <= 0 then continue end

			v:TakeDamage( dmg * pct, owner, owner )

			if pct > 0.5 then
				v:ApplyEffect( "scp066_blur" )
			end
		end
	end

	self:DashThink()
end

function SWEP:DashThink()
	local ct = CurTime()

	local detach = self:GetDetachTime()
	if detach > 0 and detach <= ct then
		self:Detach()
		self:CleanupDash()
		self:SetNextDash( ct + self.DashCooldown * self:GetUpgradeMod( "dash_cd", 1 ) )
		return
	end

	if !self.DashActive then return end

	local owner = self:GetOwner()
	local start = owner:GetPos() + owner:OBBCenter()
	local ang = owner:EyeAngles()
	ang.p = 0

	dash_trace.start = start
	dash_trace.endpos = start + ang:Forward() * 50
	dash_trace.filter = self.Attached

	owner:LagCompensation( true )
	util.TraceHull( dash_trace )
	owner:LagCompensation( false )

	if !dash_trace.Hit then
		owner:LagCompensation( true )
		util.TraceLine( dash_trace )
		owner:LagCompensation( false )

		if !dash_trace.Hit then return end
	end

	local ent = dash_trace.Entity
	if !IsValid( ent ) or !ent:IsPlayer() then
		self:CleanupDash()
		return
	end

	if !self:CanTargetPlayer( ent ) then return end

	local ent_pos = ent:GetPos() + ent:OBBCenter()
	local dir = dash_trace.HitPos - ent_pos
	dir.z = 0
	
	local attach_ang = dir:Angle()
	attach_ang.y = attach_ang.y + ent:GetAngles().y
	
	controller.Start( owner, "scp066_stop" )

	owner:SetMoveType( MOVETYPE_NONE )
	owner:SetPos( ent_pos + attach_ang:Forward() * 15 )
	owner:SetParent( ent )
	
	self.DashActive = false
	self.CurrentAttach = { ent, ent:TimeSignature() }
	self:SetDetachTime( ct + self.DashDetachTime * self:GetUpgradeMod( "detach_time", 1 ) )
	self:SetNextDash( ct + 1 )
	self.Attached[2] = ent
	//table.insert( self.Attached, ent )

	ent:SetProperty( "scp066_attached", owner )
end

function SWEP:TranslateActivity( act )
	if act == ACT_MP_WALK or act == ACT_MP_RUN or act == ACT_MP_CROUCHWALK or act == ACT_LAND then
		return ACT_WALK
	end

	return ACT_IDLE
end

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end
	if !self:CanAttack() then
		if CLIENT then
			self:HUDNotify( "not_threatened", 1, "npc/roller/code2.wav" )
		end

		return
	end

	local ct = CurTime()
	self:SetNextPrimaryFire( ct + self.MusicLength + self.MusicCooldown * self:GetUpgradeMod( "music_cd", 1 ) )
	self:SetNextEric( ct + self.MusicLength + 3 )
	self.MusicAttack = ct + self.MusicLength

	if !SERVER then return end

	self:GetOwner():EmitSound( math.random( 1000 ) == 666 and "SCP066.IHateMyLife" or "SCP066.Music" )
	AddRoundStat( "066" )
end

local dash_up = Vector( 0, 0, 250 )
local dash_attached_up = Vector( 0, 0, 100 )
function SWEP:Reload()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	if self:GetNextDash() > ct then return end

	local owner = self:GetOwner()
	if !self.Attached and !owner:IsOnGround() then return end

	self:SetNextDash( ct + self.DashCooldown * self:GetUpgradeMod( "dash_cd", 1 ) )

	if self.Attached then
		self:Detach()

		if self:HasUpgrade( "dash3" ) then
			self:CleanupDash( true )
		else
			self:CleanupDash()
			return
		end
	end

	local ang = owner:EyeAngles()
	ang.p = 0

	local vel = ang:Forward() * ( self.Attached and 500 or 300 ) + ( self.Attached and dash_attached_up or dash_up )

	if !self.Attached then
		self.Attached = { owner }
	end

	owner:SetVelocity( vel )
	controller.Start( owner, "scp066_dash" )

	owner:AddTimer( "SCP066DashForceStop", 3, 1, function()
		if controller.IsEnabled( owner, "scp066_dash" ) then
			self:CleanupDash()
		end
	end )

	self.DashActive = true
end

SWEP.SpecialDefenseTime = 0
SWEP.SpecialDefenseMult = 0
SWEP.SpecialEndTime = 0
function SWEP:SpecialAttack()
	if ROUND.preparing or ROUND.post then return end

	local power = self:GetEric() * self:GetUpgradeMod( "boost_power", 1 )
	if power == 0 then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local special_type = self:GetSpecialType()
	local next_type = ( special_type + 1 ) % 3
	local duration = self.SpecialDuration * self:GetUpgradeMod( "boost_dur", 1 )

	self:SetNextSpecialAttack( ct + self.SpecialCooldown * self:GetUpgradeMod( "boost_cd", 1 ) )
	self:SetSpecialType( next_type )
	self.SpecialEndTime = ct + duration

	if CLIENT then
		local skill = self.HUDObject:GetSkill( "boost" )
		if skill then
			skill:SetMaterialOverride( self.BoostMaterials[next_type + 1], "smooth" )
		end

		local bar = self.HUDObject:GetBar( "boost_bar" )
		if bar then
			bar:SetMaterialOverride( self.BoostMaterials[special_type + 1], "smooth" )
		end

		return
	end

	if special_type == 0 then --speed
		local speed = 1 + power * self.SpecialSpeed
		owner:PushSpeed( speed, speed, -1, "SLC_SCP066Special", 1 )

		owner:AddTimer( "SCP066Special", duration, 1, function()
			owner:PopSpeed( "SLC_SCP066Special" )
		end )
	elseif special_type == 1 then --def
		self.SpecialDefenseTime = ct + duration
		self.SpecialDefenseMult = math.Clamp( 1 - power * self.SpecialDefense, 0, 1 )
	elseif special_type == 2 then --regen
		owner:AddTimer( "SCP066Special", duration / self.SpecialHealTicks, self.SpecialHealTicks, function()
			owner:AddHealth( math.ceil( power * self.SpecialHeal ) )
		end )
	end
end

function SWEP:CanAttack()
	if self:GetLastDamaged() + 3 > CurTime() then return true end

	local owner = self:GetOwner()
	local escape, blocked = IsOnEscape( owner )
	if escape and blocked then return true end

	local pos = owner:GetPos()
	local radius = 1000000
	local any = false

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > radius or !v:TestVisibility( owner ) then continue end
		
		any = true

		local wep = v:GetActiveWeapon()
		if IsValid( wep ) and wep:IsAttackWeapon() then
			return true
		end
	end

	return false, any
end

local detach_trace = {}
detach_trace.mask = MASK_SOLID_BRUSHONLY
detach_trace.output = detach_trace

function SWEP:Detach()
	if !self.CurrentAttach or !IsValid( self.CurrentAttach[1] ) or !self.CurrentAttach[1]:CheckSignature( self.CurrentAttach[2] ) then return end

	local owner = self:GetOwner()

	detach_trace.start = self.CurrentAttach[1]:GetPos()
	detach_trace.endpos = detach_trace.start + self.CurrentAttach[1]:OBBCenter()
	detach_trace.mins, detach_trace.maxs = owner:GetCollisionBounds()

	util.TraceHull( detach_trace )

	owner:SetPos( detach_trace.HitPos )
end

function SWEP:CleanupDash( soft )
	if IsValid( self.CurrentAttach ) then
		self.CurrentAttach:SetProperty( "scp066_attached", nil )
	end

	self.CurrentAttach = nil
	self.DashActive = false
	self:SetDetachTime( 0 )
	
	local owner = self:GetOwner()
	controller.Stop( owner )
	owner:SetParent( nil )
	owner:SetMoveType( MOVETYPE_WALK )

	if soft then return end
	
	self.Attached = nil
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP066") TransmitSCPHooks()
SCPHook( "SCP066", "EntityTakeDamage", function( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !dmg:IsDamageType( DMG_BULLET ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP066 then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	if wep.SpecialDefenseTime >= CurTime() then
		dmg:ScaleDamage( wep.SpecialDefenseMult )
	end
end )

SCPHook( "SCP066", "PostEntityTakeDamage", function( ent, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( ent ) or !ent:IsPlayer() or ent:SCPClass() != CLASSES.SCP066 then return end

	local attacker = dmg:GetAttacker()
	if !IsValid( attacker ) or !attacker:IsPlayer() or attacker == ent then return end

	local wep = ent:GetSCPWeapon()
	if !IsValid( wep ) then return end

	wep:SetLastDamaged( CurTime() )
end )

SCPHook( "SCP066", "SLCPlayerFootstep", function( ply, foot, snd )
	if ply:SCPClass() != CLASSES.SCP066 then return end

	local ct = CurTime()
	if !ply.Next066Step or ply.Next066Step < ct then
		ply.Next066Step = ct + 0.8
		ply:EmitSound( "SCP066.Move" )
	end

	return true
end )

local function handle_death( ply )
	local scp = ply:GetProperty( "scp066_attached" )
	if !IsValid( scp ) then return end

	local wep = scp:GetSCPWeapon()
	if !IsValid( wep ) or !wep.CurrentAttach or wep.CurrentAttach[1] != ply or !ply:CheckSignature( wep.CurrentAttach[2] ) then return end

	wep:Detach()
	wep:CleanupDash()
end

SCPHook( "SCP066", "DoPlayerDeath", handle_death )
SCPHook( "SCP066", "PlayerSilentDeath", handle_death )

--[[-------------------------------------------------------------------------
Effects
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "scp066_blur", {
	duration = 5,
	stacks = 0,
	max_tier = 1,
	tiers = {},
	hide = true,
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh, decrease )
		if SERVER or refresh then return end

		AddRoundHook( "SLCScreenMod", "SCP066ScreenBlur", function( clr )
			DrawMotionBlur( 0.25, 0.95, 0.02 )
		end )
	end,
	finish = function( self, ply, tier, args, interrupt, all )
		if SERVER then return end
		RemoveRoundHook( "SLCScreenMod", "SCP066ScreenBlur" )
	end,
	ignore500 = true,
} )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.eirc = GetMaterial( "slc/hud/upgrades/scp/066/eric.png", "smooth" )
	icons.music = GetMaterial( "slc/hud/upgrades/scp/066/music.png", "smooth" )
	icons.dash = GetMaterial( "slc/hud/upgrades/scp/066/dash.png", "smooth" )
	icons.boost = GetMaterial( "slc/hud/upgrades/scp/066/boost.png", "smooth" )
end

DefineUpgradeSystem( "scp066", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "eric1", cost = 1, req = {}, reqany = false, pos = { 1.25, 1 },
			mod = { eric_cd = 0.8 }, icon = icons.eirc },
		{ name = "eric2", cost = 2, req = { "eric1" }, reqany = false, pos = { 1.25, 2 },
			mod = { eric_cd = 0.5 }, icon = icons.eirc },
		
		{ name = "music1", cost = 1, req = { "eric1" }, reqany = false, pos = { 2, 2 },
			mod = { music_cd = 0.9, music_range = 1.1 }, icon = icons.music },
		{ name = "music2", cost = 2, req = { "music1" }, reqany = false, pos = { 2, 3 },
			mod = { music_cd = 0.75, music_range = 1.25 }, icon = icons.music },
		{ name = "music3", cost = 2, req = { "music2" }, reqany = false, pos = { 2, 4 },
			mod = { music_damage = 1.33 }, icon = icons.music },

		{ name = "dash1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { dash_cd = 0.8, detach_time = 1.33 }, icon = icons.dash },
		{ name = "dash2", cost = 1, req = { "dash1" }, reqany = false, pos = { 3, 2 },
			mod = { dash_cd = 0.6, detach_time = 2 }, icon = icons.dash },
		{ name = "dash3", cost = 2, req = { "dash2" }, reqany = false, pos = { 3, 3 },
			mod = {}, icon = icons.dash },

		{ name = "boost1", cost = 1, req = {}, reqany = false, pos = { 4, 1 },
			mod = { boost_cd = 0.9, boost_dur = 1.2 }, icon = icons.boost },
		{ name = "boost2", cost = 2, req = { "boost1" }, reqany = false, pos = { 4, 2 },
			mod = { boost_cd = 0.8, boost_power = 1.1 }, icon = icons.boost },
		{ name = "boost3", cost = 2, req = { "boost2" }, reqany = false, pos = { 4, 3 },
			mod = { boost_dur = 1.5, boost_power = 1.2 }, icon = icons.boost },

		
		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 1, 4 }, mod = {}, active = false },
	},
	rewards = { --17 + 1 points -> 60% = 11 (-1 base) = 10 points
		{ 75, 1 },
		{ 150, 1 },
		{ 250, 1 },
		{ 350, 1 },
		{ 450, 1 },
		{ 550, 1 },
		{ 700, 1 },
		{ 850, 1 },
		{ 1000, 1 },
		{ 1200, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local color_green = Color( 25, 200, 45 )

	local hud = SCPHUDObject( "SCP066", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "music" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/066/music.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )
		:SetActiveFunction( "CanAttack" )

	hud:AddSkill( "dash" )
		:SetButton( "reload" )
		:SetMaterial( "slc/hud/scp/066/dash.png", "smooth" )
		:SetCooldownFunction( "GetNextDash" )

	hud:AddSkill( "boost" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/066/speed.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetActiveFunction( function( swep )
			return swep:GetEric() > 0
		end )
		:SetParser( function( swep, lang )
			local power = swep:GetEric() * swep:GetUpgradeMod( "boost_power", 1 )

			return {
				cap = MarkupBuilder.StaticPrint( swep.MaxEricStacks, color_green ),
				boost = MarkupBuilder.StaticPrint( lang.buffs[swep:GetSpecialType() + 1], color_green ),
				speed = MarkupBuilder.StaticPrint( math.Round( power * swep.SpecialSpeed * 100, 1 ).."%", color_green ),
				def = MarkupBuilder.StaticPrint( math.Round( math.Clamp( power * swep.SpecialDefense, 0, 1 ) * 100, 1 ).."%", color_green ),
				regen = MarkupBuilder.StaticPrint( math.ceil( power * swep.SpecialHeal, 1 ).." (x"..swep.SpecialHealTicks..")", color_green ),
			}
		end )

	hud:AddSkill( "eric" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/066/eric.png", "smooth" )
		:SetCooldownFunction( "GetNextEric" )
		:SetTextFunction( "GetEric" )

	hud:AddBar( "music_bar" )
		:SetMaterial( "slc/hud/scp/066/music.png", "smooth" )
		:SetColor( Color( 164, 195, 26 ) )
		:SetTextFunction( function( swep )
			local time = swep.MusicAttack - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep.MusicAttack - CurTime() ) / swep.MusicLength
		end )
		:SetVisibleFunction( function( swep )
			return swep.MusicAttack > CurTime()
		end )

	hud:AddBar( "dash_bar" )
		:SetMaterial( "slc/hud/scp/066/dash.png", "smooth" )
		:SetColor( Color( 199, 169, 38 ) )
		:SetTextFunction( function( swep )
			local time = swep:GetDetachTime() - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep:GetDetachTime() - CurTime() ) / ( swep.DashDetachTime * swep:GetUpgradeMod( "detach_time", 1 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetDetachTime() > CurTime()
		end )

	hud:AddBar( "boost_bar" )
		:SetMaterial( "slc/hud/scp/066/speed.png", "smooth" )
		:SetColor( Color( 43, 231, 168 ) )
		:SetTextFunction( function( swep )
			local time = swep.SpecialEndTime - CurTime()

			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep )
			return ( swep.SpecialEndTime - CurTime() ) / ( swep.SpecialDuration * swep:GetUpgradeMod( "boost_dur", 1 ) )
		end )
		:SetVisibleFunction( function( swep )
			return swep.SpecialEndTime > CurTime()
		end )
end

--[[-------------------------------------------------------------------------
Dash controller
---------------------------------------------------------------------------]]
controller.Register( "scp066_dash", {
	StartCommand = function( self, ply, cmd )
		if !self.Angle then
			self.Angle = cmd:GetViewAngles()
		end

		cmd:SetViewAngles( self.Angle )
		cmd:ClearButtons()
		cmd:ClearMovement()
	end,
	Move = function( self, ply, mv )
		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		local on_ground = ply:IsOnGround() 
		if !self.InAir and !on_ground then
			self.InAir = true
		end

		if self.InAir and on_ground then
			wep:CleanupDash()
		end
	end,
} )

local vector_zero = Vector( 0, 0, 0 )
controller.Register( "scp066_stop", {
	Move = function( self, ply, mv )
		mv:SetVelocity( vector_zero )
	end,
} )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "SCP066.Move",
	channel = CHAN_BODY,
	volume = 1.0,
	level = 70,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/066/move.ogg"
} )

sound.Add( {
	name = "SCP066.Eric",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = 100,
	sound = "scp_lc/scp/066/eric.ogg"
} )

sound.Add( {
	name = "SCP066.Music",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 511,
	pitch = 100,
	sound = "scp_lc/scp/066/beethoven.ogg"
} )

sound.Add( {
	name = "SCP066.IHateMyLife",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 511,
	pitch = 100,
	sound = "scp_lc/scp/066/dont_play_this_you_have_been_warned.ogg"
} )