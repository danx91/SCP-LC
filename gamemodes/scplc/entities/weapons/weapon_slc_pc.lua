SWEP.PrintName 				= "Particle Cannon"
SWEP.Base 					= "item_slc_base"
SWEP.DeepBase 				= "item_slc_base"
SWEP.Language 				= "PARTICLE_CANNON"

SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/wolf/faton.mdl"
SWEP.WorldModel				= "models/weapons/wolf/w_faton.mdl"

SWEP.ViewModelFOV			= 80
SWEP.RenderGroup 			= RENDERGROUP_BOTH

SWEP.HoldType 				= "ar2"

SWEP.Primary.ClipSize		= 500
SWEP.Primary.DefaultClip 	= 500

SWEP.FireDelay				= 1 / 50
SWEP.Damage 				= 15
SWEP.Range 					= 5000
SWEP.DamageType 			= bit.bor( DMG_RADIATION, DMG_PREVENT_PHYSICS_FORCE )

SWEP.WindUpPhase1Duration 	= 0.75
SWEP.WindUpPhase2Duration 	= 0.5
SWEP.WindDownDuration		= 1.5
SWEP.Cooldown				= 1

local STATE = {
	IDLE = 0,
	WINDUP_1 = 1,
	WINDUP_2 = 2,
	WINDDOWN = 3,
	COOLDOWN = 4,
	SHOOTING = 5
}

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/particle_cannon.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	//self:NetworkVar( "Int", "Charges" )
	self:NetworkVar( "Float", "WeaponState" )
end

function SWEP:Initialize()
	self:InitializeLanguage()
	self:SetHoldType( self.HoldType )
	self:SetDeploySpeed( 0.4 )
end

local vector_zero = Vector( 0, 0, 0 )
local attack_trace = {}
attack_trace.output = attack_trace
attack_trace.mask = MASK_SHOT
attack_trace.mins = Vector( -3, -3, -3 )
attack_trace.maxs = Vector( 3, 3, 3 )

SWEP.LastState = STATE.IDLE
function SWEP:Think()
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local state, time = self:WeaponState()
	local prev = self.LastState

	if state != prev then
		self.LastState = state
		self:StateChanged( state, prev )
	end

	if state == STATE.IDLE or state == STATE.WINDDOWN then return end

	if state == STATE.COOLDOWN then
		if time >= self.Cooldown then
			self:SetWeaponState( 0 )
		end

		return
	end

	owner:UpdateHold( self, "particle_cannon" )

	if !owner:IsHolding( self, "particle_cannon" ) then
		self:SetWeaponState( -CurTime() - self.WindDownDuration )
		return
	end

	if CLIENT or state != STATE.SHOOTING then return end

	local ct = CurTime()
	local start = owner:GetShootPos()

	while self.NextFire <= ct do
		self.NextFire = self.NextFire + self.FireDelay
		self:TakePrimaryAmmo( 1 )

		attack_trace.start = start
		attack_trace.endpos = start + owner:GetAimVector() * self.Range
		attack_trace.filter = { self, owner }

		util.TraceHull( attack_trace )

		local target = attack_trace.Entity
		if !attack_trace.Hit or !IsValid( target ) or target:IsPlayer() and target:SCPTeam() == TEAM_SPEC then
			util.TraceLine( attack_trace )
		end

		if attack_trace.Hit and IsValid( target ) and ( !target:IsPlayer() or target:SCPTeam() != TEAM_SPEC ) then
			local info = DamageInfo()

			info:SetInflictor( self )
			info:SetAttacker( owner )
			info:SetDamage( self.Damage )
			info:SetDamageType( self.DamageType )
			info:SetDamageForce( vector_zero )

			target:TakeDamageInfo( info )
		end

		if self:Clip1() <= 0 then
			owner:InterruptHold( self, "particle_cannon" )
			break
		end
	end

	for k, v in pairs( FindInCylinder( start, 256, -64, 256, nil, MASK_SOLID_BRUSHONLY, player.GetAll() ) ) do
		v:ApplyEffect( "radiation" )
	end
end

function SWEP:Deploy()
	self.BoneRotation:Zero()

	if CLIENT then return end
	
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	owner:PushSpeed( 0.8, 0.8, -1, "SLC_ParticleCannon", 1 )
end

function SWEP:Holster()
	if self:WeaponState() != STATE.IDLE then return false end
	self:Cleanup()

	return true
end

function SWEP:SLCPreDrop()
	self:Cleanup()
end

function SWEP:CanDrop()
	return self:WeaponState() == STATE.IDLE
end

function SWEP:OnRemove()
	self:Cleanup()
end

function SWEP:OnDrop()
	self:Cleanup()
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 or self:WeaponState() != STATE.IDLE then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "particle_cannon" ) then return end

	local windup = self.WindUpPhase1Duration + self.WindUpPhase2Duration

	self:SetWeaponState( CurTime() + windup )
	owner:StartHold( self, "particle_cannon", IN_ATTACK, windup, nil, true )
end

function SWEP:Reload()
	/*local owner = self:GetOwner()
	owner:InterruptHold( self, "particle_cannon" )
	self:SetWeaponState( 0 )*/
end

function SWEP:WeaponState()
	local state = self:GetWeaponState()

	if state == 0 then
		return STATE.IDLE, state
	end

	local ct = CurTime()

	if state < 0 then
		state = -state - ct

		return state < 0 and STATE.COOLDOWN or STATE.WINDDOWN, math.abs( state )
	end

	if state < ct then
		return STATE.SHOOTING, state
	end

	state = state - ct

	if state > self.WindUpPhase2Duration then
		return STATE.WINDUP_1, state - self.WindUpPhase2Duration
	end

	return STATE.WINDUP_2, state
end

function SWEP:StateChanged( new, old )
	if new == STATE.WINDUP_1 then
		self:EmitSound( "SLC.ParticleCannon.WindUpPhase1" )
		controller.Start( self:GetOwner(), "particle_cannon" )
	elseif new == STATE.WINDUP_2 then
		self:StopSound( "SLC.ParticleCannon.WindUpPhase1" )
		self:EmitSound( "SLC.ParticleCannon.WindUpPhase2" )
	elseif new == STATE.SHOOTING then
		self:EmitSound( "SLC.ParticleCannon.Shot" )
		self.NextFire = CurTime()
	elseif new == STATE.WINDDOWN then
		self:StopSound( "SLC.ParticleCannon.WindUpPhase1" )
		self:StopSound( "SLC.ParticleCannon.Shot" )

		if old == STATE.SHOOTING then
			self:EmitSound( "SLC.ParticleCannon.WindDown" )
		end
	elseif new == STATE.COOLDOWN then
		controller.Stop( self:GetOwner() )
	end
end

function SWEP:Cleanup()
	self:SetWeaponState( 0 )

	self:StopSound( "SLC.ParticleCannon.WindUpPhase1" )
	self:StopSound( "SLC.ParticleCannon.Shot" )
	self:PopSpeed()

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	controller.Stop( owner )
end

function SWEP:PopSpeed()
	if !SERVER then return end

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	owner:PopSpeed( "SLC_ParticleCannon" )
end

--[[-------------------------------------------------------------------------
Model effects
---------------------------------------------------------------------------]]
SWEP.RotationSpeed = 0
SWEP.BoneRotation = Angle( 0, 0, 0 )

function SWEP:PreDrawViewModel( vm, wep, ply )
	local state, time = self:WeaponState()
	local c_speed

	if state == STATE.WINDUP_1 then
		self.RotationSpeed = math.Clamp( 1 - time / self.WindUpPhase1Duration, 0, 1 )
	elseif state == STATE.WINDUP_2 then
		self.RotationSpeed = 1
	elseif state == STATE.WINDDOWN then
		c_speed = Lerp( math.Clamp( 1 - time / self.WindDownDuration, 0, 1 ), self.RotationSpeed, 0 )
	elseif state == STATE.IDLE or state == STATE.COOLDOWN then
		self.RotationSpeed = 0
	elseif state == STATE.SHOOTING then
		vm:SetSkin( 1 )
	end

	c_speed = c_speed or self.RotationSpeed
	if c_speed <= 0 then return end

	local bone = vm:LookupBone( "bone007" )
	if !bone then return end

	self.BoneRotation.r = ( self.BoneRotation.r + FrameTime() * c_speed * 280 ) % 360
	vm:ManipulateBoneAngles( bone, self.BoneRotation )
end

--[[-------------------------------------------------------------------------
Beam
---------------------------------------------------------------------------]]
function SWEP:ViewModelDrawn( vm )
	self:DrawBeams( vm )
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	self:DrawBeams()
end

local laser = GetMaterial( "slc/misc/pc_laser" )
local laser_color = Color( 190, 225, 255, 255 )
local color_white255 = Color( 255, 255, 255 )
local color_white0 = Color( 255, 255, 255, 0 )

local beam_trace = {}
beam_trace.output = beam_trace
beam_trace.mask = MASK_SHOT
beam_trace.mins = Vector( -3, -3, -3 )
beam_trace.maxs = Vector( 3, 3, 3 )

function SWEP:DrawBeams( ent )
	if self:WeaponState() != STATE.SHOOTING then return end

	if !ent then ent = self end
	if !IsValid( ent ) then return end

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local tr_start = owner:GetShootPos()
	local vec = owner:GetAimVector()

	beam_trace.start = tr_start
	beam_trace.endpos = tr_start + vec * self.Range
	beam_trace.filter = { self, owner }

	util.TraceHull( beam_trace )

	local beam_end = beam_trace.HitPos
	local beam_start

	local att = ent:GetAttachment( 1 )
	if att then
		beam_start = att.Pos + vec * 5
	else
		beam_start = tr_start - Vector( 0, 0, 10 )
	end

	//self:SetRenderBoundsWS( beam_start, beam_end ) --TODO

	local max_c = 30
	local count = max_c

	local dir = ( beam_end - beam_start ):GetNormalized()
	local inc = ( beam_end - beam_start ):Length()

	local num = inc / 25
	if num < count then
		count = math.floor( num )

		if count < 5 then
			count = 5
		end
	end

	local f = 1 / count
	inc = inc / count

	local ang = dir:Angle()
	ang:RotateAroundAxis( ang:Up(), SLCRandom( -60, 10 ) )
	ang:RotateAroundAxis( ang:Right(), SLCRandom( -15, 5 ) )

	render.SetMaterial( laser )
	render.StartBeam( count )
	local tx = CurTime() % 1 + 1

	render.AddBeam(
		beam_start,
		15,
		tx,
		color_white255
	)

	for i = 1, count - 2 do
		ang:RotateAroundAxis( ang:Up(), SLCRandom( -20, 20 ) / i )
		ang:RotateAroundAxis( ang:Right(), SLCRandom( -20, 20 ) / i )
		local pos = dir * inc * i + ang:Forward() * math.sin( i / count * 2 * math.pi ) * f * 100 * ( count / max_c )

		render.AddBeam(
			beam_start + pos,
			15,
			tx - f * i,
			laser_color
		)
	end

	render.AddBeam(
		beam_end,
		15,
		tx - 1,
		color_white0
	)

	render.EndBeam()
end

--[[-------------------------------------------------------------------------
Controller
---------------------------------------------------------------------------]]
controller.Register( "particle_cannon", {
	StartCommand = function( self, ply, cmd )
		local wep = ply:GetActiveWeapon()
		if !IsValid( wep ) or wep:GetClass() != "weapon_slc_pc" then
			self:Stop()
			return
		end

		local state = wep:WeaponState()
		
		if state == STATE.IDLE then
			self:Stop()
			return
		end

		cmd:SetButtons( bit.band( cmd:GetButtons(), IN_ATTACK ) )

		if state == STATE.WINDUP_1 then return end

		cmd:ClearMovement()

		if state == STATE.COOLDOWN then return end

		if !self.Angle then
			self.Angle = cmd:GetViewAngles()
		end

		local ang = cmd:GetViewAngles()
		local diff = ang - self.Angle
		diff:Normalize()

		local abs_diff = math.sqrt( diff.y * diff.y + diff.p * diff.p )
		local max_diff = 180 * FrameTime()

		if abs_diff > max_diff then
			diff:Div( abs_diff / max_diff )
		end

		self.Angle:Add( diff )
		cmd:SetViewAngles( self.Angle )
	end,
} )


--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "SLC.ParticleCannon.WindUpPhase1",
	sound = "weapons/particle_cannon/cg_motor_loop_01.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SLC.ParticleCannon.WindUpPhase2",
	sound = "weapons/particle_cannon/cg_windup_mix_01.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SLC.ParticleCannon.WindDown",
	sound = "weapons/particle_cannon/cg_winddown_mix_01.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SLC.ParticleCannon.Shot",
	sound = "weapons/particle_cannon/pc_shot.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
} )

MarkAsWeapon( "weapon_slc_pc" )