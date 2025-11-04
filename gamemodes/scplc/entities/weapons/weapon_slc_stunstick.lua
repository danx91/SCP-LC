SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "STUNSTICK"

SWEP.RenderGroup	 = RENDERGROUP_BOTH

SWEP.ViewModel 		= "models/weapons/v_stunstick.mdl"
SWEP.WorldModel 	= "models/weapons/w_stunbaton.mdl"
SWEP.ViewModelFOV	= 50

SWEP.Primary.Automatic = true

SWEP.HoldType 		= "melee"
SWEP.Group			= "melee"

SWEP.AttackSpeed 		= 1
SWEP.AttackDamage 		= 10
SWEP.AttackDamagePowered= 16
SWEP.AttackDelay		= 0.9
SWEP.AttackDelayPowered = 1.33
SWEP.DamageType 		= DMG_CLUB
SWEP.DamageTypePowered 	= bit.bor( DMG_CLUB, DMG_SHOCK )

SWEP.HasBattery 		= true
SWEP.BatteryUsage		= 20

if CLIENT then
	SWEP.SelectFont = "SCPHLIcons"
	SWEP.IconLetter = "n"
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Float", "NextIdle" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	self:SwingThink()

	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local ct = CurTime()
	local idle = self:GetNextIdle()

	if idle < ct then
		vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_IDLE ) )
		self:SetNextIdle( ct + vm:SequenceDuration() / vm:GetPlaybackRate() )
	end

	if SERVER or !IsFirstTimePredicted() or owner:ShouldDrawLocalPlayer() or vm:GetSequence() <= 1 or SLCRandom( 0, 3 ) != 0 then return end
	if self:GetBattery() <= 0 and !self.LastAttackPowered then return end

	self:CreateBeam( vm, 19 )
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_DRAW ) )
	vm:SetPlaybackRate( 2 )

	local dur = vm:SequenceDuration() / vm:GetPlaybackRate()
	local cd = CurTime() + dur
	self:SetNextPrimaryFire( cd )
	self:SetNextIdle( cd )

	if self:GetBattery() > 0 then
		self:DeployEffects()
	end

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnDrop()
	self.SwingAttackData = nil
end

function SWEP:BatteryInserted()
	self:DeployEffects()
end

SWEP.AttackPathStart = Vector( 0, 6, 4 )
SWEP.AttackPathEnd = Vector( 0, -4, -6 )
SWEP.AttackFOVStart = -5
SWEP.AttackFOVEnd = 20
SWEP.AttackMins = Vector( -1, -1, -1 )
SWEP.AttackMaxs = Vector( 1, 1, 1 )
SWEP.AttackRangeStart = 70
SWEP.AttackRangeEnd = 35
SWEP.AttackFallbackRange = 65
SWEP.AttackFallbackBounds = 1.5

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	local battery = self:GetBattery()
	local powered = battery > 0

	local ct = CurTime()
	local dur = self:PlayActivity( ACT_VM_MISSCENTER, self.AttackSpeed )

	self:SetNextPrimaryFire( ct + dur * ( powered and self.AttackDelayPowered or self.AttackDelay ) )
	self.LastAttackPowered = powered
	
	owner:DoAttackEvent()
	
	self:SwingAttack( {
		path_start = self.AttackPathStart,
		path_end = self.AttackPathEnd,
		fov_start = self.AttackFOVStart,
		fov_end = self.AttackFOVEnd,
		duration = dur * 0.25,
		num = 8,
		dist_start = self.AttackRangeStart,
		dist_end = self.AttackRangeEnd,
		mins = self.AttackMins,
		maxs = self.AttackMaxs,
		on_start = function()
			self:EmitSound( powered and "Weapon_StunStick.Swing" or "Weapon_Crowbar.Single" )
		end,
		callback = function( tr, num, center )
			local ent = tr.Entity
			if !IsValid( ent ) and num < 3 then

				if center then
					self:ImpactEffect( tr )
					self:EmitSound( powered and "Weapon_StunStick.Melee_Hit" or "Weapon_Crowbar.Melee_Hit" )
					self:PlayActivity( ACT_VM_HITCENTER, self.AttackSpeed )

					return
				end

				return true, {
					distance = self.AttackFallbackRange,
					bounds = self.AttackFallbackBounds,
				}
			end
			
			if ent:IsPlayer() then
				util.Decal( "Impact.Flesh", tr.HitPos + tr.HitNormal * 20, tr.HitPos - tr.HitNormal * 20, owner )

				battery = battery - self.BatteryUsage

				if battery < 0 then
					battery = 0
				end
	
				self:SetBattery( battery )
			end

			self:ImpactEffect( tr )
			self:EmitSound( powered and "Weapon_StunStick.Melee_Hit" or "Weapon_Crowbar.Melee_Hit" )
			self:PlayActivity( ACT_VM_HITCENTER, self.AttackSpeed )

			if SERVER then
				local dmg = DamageInfo()

				dmg:SetAttacker( owner )
				dmg:SetInflictor( self )

				dmg:SetDamage( powered and self.AttackDamagePowered or self.AttackDamage )
				dmg:SetDamageType( powered and self.DamageTypePowered or self.DamageType )

				SuppressHostEvents( NULL )
				ent:TakeDamageInfo( dmg )
				SuppressHostEvents( owner )
			end

			return true
		end
	} )
end

function SWEP:SecondaryAttack()

end

function SWEP:DeployEffects()
	self:EmitSound( "Weapon_StunStick.Activate" )

	local att = self:GetAttachment( 1 )
	local data = EffectData()

	data:SetOrigin( att.Pos )
	data:SetMagnitude( 1.5 )
	data:SetScale( 0.5 )
	data:SetRadius( 2.5 )

	util.Effect( "Sparks", data )
end

function SWEP:ImpactEffect( tr )
	if CLIENT then return end

	self:DispatchImpactTrace( tr, DMG_CLUB )
	
	local data = EffectData()
	data:SetNormal( tr.HitNormal )
	data:SetOrigin( tr.HitPos + tr.HitNormal * 4 )
	
	if self:GetBattery() <= 0 and !self.LastAttackPowered then return end

	util.Effect( "StunstickImpact", data, false, true )
end

function SWEP:PlayActivity( act, speed )
	local owner = self:GetOwner()

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( act ) )
	vm:SetPlaybackRate( speed )

	local dur = vm:SequenceDuration() / speed
	self:SetNextIdle( CurTime() + dur )

	return dur
end

AddWeaponLoadout( "weapon_slc_stunstick", nil, "melee_mid" )
MarkAsWeapon( "weapon_slc_stunstick" )

if SERVER then return end

local w_glow_color = Color( 110, 110, 110 )
local w_glow_color2 = Color( 0, 0, 0 )

local v_glow_color = Color( 0, 0, 0 )
local color_beam = Color( 255, 255, 255 )

local beam_mat = CreateMaterial( "slc_stunstick_beam_x", "Sprite", {
	["$basetexture"] = "sprites/lgtning",
	["$vertexalpha"] = "1",
	["$spriterendermode"] = "2"
} )

local glow_mat = Material( "sprites/light_glow02_add" )
local glow_mat2 = Material( "effects/blueflare1" )
local glow_mat_noz = Material( "sprites/light_glow02_add_noz" )

local vec_origin = Vector( 0, 0, 0 )
local vec_random = Vector( 0, 0, 0 )

local fade_duration = 0.25
SWEP.GlowFadeTime = 0
SWEP.SwingLastFrame = false

function SWEP:CreateBeam( ent, att )
	local pos = ent:GetAttachment( att ).Pos

	vec_random:Random( -8, 8 )

	self.Beam = GenericBeam( {
		vec_start = vec_origin,
		ent_start = ent,
		attachment_start = att,

		vec_end = pos + vec_random,

		material = beam_mat,
		color = color_beam,
		segments = 16,

		speed = 0,
		amplitude = SLCRandom() * 16 + 16,
		width = SLCRandom() + 1,
		width_end = 0,
		life = 0.05,
		fade = 0,
		divs = 32,
	} )
end

function SWEP:ViewModelDrawn( vm )
	local is_swing = vm:GetSequence() > 1

	if is_swing and !self.SwingLastFrame then
		self.SwingLastFrame = true
	elseif !is_swing and self.SwingLastFrame then
		self.SwingLastFrame = false
		self.GlowFadeTime = CurTime() + fade_duration
	end

	if self:GetBattery() <= 0 and !self.LastAttackPowered then return end

	local fade = ( self.GlowFadeTime - CurTime() ) / fade_duration
	if !is_swing and fade <= 0 then return end

	local clr = is_swing and 140 or 140 * fade
	local scale = is_swing and 22 or 20

	v_glow_color.r = clr
	v_glow_color.g = clr
	v_glow_color.b = clr

	render.SetMaterial( glow_mat_noz )
	render.DrawSprite( self:TranslateViewModelAttachment( vm:GetAttachment( 19 ).Pos, true ), scale, scale, v_glow_color )

	for i = 1, 18 do
		clr = ( SLCRandom() * 125 + 25 ) * ( is_swing and 1 or fade )
		scale = ( SLCRandom() + 4 ) * ( is_swing and 1 or fade )

		v_glow_color.r = clr
		v_glow_color.g = clr
		v_glow_color.b = clr

		render.DrawSprite( self:TranslateViewModelAttachment( vm:GetAttachment( i ).Pos, true ), scale, scale, v_glow_color )
	end
end

function SWEP:DrawWorldModel( flags )
	if IsValid( self:GetOwner() ) and self:GetBattery() > 0 then
		local pos = self:GetAttachment( 1 ).Pos

		render.SetMaterial( glow_mat )
		render.DrawSprite( pos, 20, 20, w_glow_color )

		local clr = SLCRandom() * 51 + 153
		w_glow_color2.r = clr
		w_glow_color2.g = clr
		w_glow_color2.b = clr

		local scale = SLCRandom() * 2 + 4

		render.SetMaterial( glow_mat2 )
		render.DrawSprite( pos, scale, scale, w_glow_color2 )

		if SLCRandom( 0, 8 ) == 0 then
			self:CreateBeam( self, 1 )
		end
	end

	self:DrawModel( flags )
end