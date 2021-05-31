SWEP.PrintName 				= "Particle Cannon"
SWEP.Base 					= "item_slc_base"
SWEP.DeepBase 				= "item_slc_base"
SWEP.Language 				= "PARTICLE_CANNON"

SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/wolf/faton.mdl"
SWEP.WorldModel				= "models/weapons/wolf/w_faton.mdl"

SWEP.ViewModelFOV			= 80
SWEP.RenderGroup 			= RENDERGROUP_BOTH
//SWEP.m_WeaponDeploySpeed 	= 0.25

SWEP.Primary.Automatic 		= true

SWEP.HoldType 				= "ar2"

SWEP.Charges = 300
SWEP.ChargesUsage = 75
SWEP.DamagePerCharge = 15
SWEP.DMGType = bit.bor( DMG_RADIATION, DMG_PREVENT_PHYSICS_FORCE )

local STATE = {
	IDLE = 0,
	WIND_UP1 = 1,
	WIND_UP2 = 2,
	WIND_DOWN = 3,
	SHOOTING = 4,
}

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/particle_cannon.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Charges", "Int" )
	self:SetCharges( self.Charges )

	self:ActionQueueSetup()
end

function SWEP:Initialize()
	self:InitializeLanguage()
	self:SetHoldType( self.HoldType )
	self:SetDeploySpeed( 0.25 )

	self:ActionQueueInit()
end

SWEP.PrimaryTime = 0
SWEP.Cooldown = 0
SWEP.LastAttack = 0
SWEP.Enabled = false
function SWEP:Think()
	//self:SetCharges( self.Charges )

	local ct = CurTime()
	local state = self:GetState()
	if state == STATE.IDLE and self.PrimaryTime > ct then
		//print( "SATRTING SEQUENCE", CurTime() )
		self:StartSequence()
	elseif state != STATE.IDLE and state != STATE.WIND_DOWN and self.PrimaryTime < ct or state == STATE.IDLE and self.Enabled then
		//print( "interrupt - standard", CurTime() )
		self:StopSequence()
	end

	local charges = self:GetCharges()
	if self:GetState() == STATE.SHOOTING then --not using local because 'state' could've changed
		local interrupt = false

		if charges <= 0 then
			interrupt = true
		else
			local diff = ct - self.LastAttack
			if diff > 1 then
				diff = 0
				self.LastAttack = ct
			end

			local take = math.floor( diff * self.ChargesUsage )

			if take > 0 then
				self.LastAttack = ct

				local owner = self:GetOwner()

				if SERVER then
					local start = owner:GetShootPos()
					local tr = util.TraceHull( {
						start = start,
						endpos = start + owner:GetAimVector() * 1000,
						mask = MASK_SHOT,
						filter = { self, owner },
						mins = Vector( -5, -5, -5 ),
						maxs = Vector( 5, 5, 5 )
					} )

					local vic = tr.Entity
					if IsValid( vic ) and vic:IsPlayer() then
						if vic:SCPTeam() != TEAM_SPEC then
							local dmg = take
							if dmg > charges then
								dmg = charges
							end

							dmg = dmg * self.DamagePerCharge

							local info = DamageInfo()
							info:SetInflictor( self )
							info:SetAttacker( owner )
							info:SetDamage( dmg )
							info:SetDamageType( self.DMGType )
							info:SetDamageForce( Vector( 0, 0, 0 ) )

							vic:TakeDamageInfo( info )
						end
					end

					for k, v in pairs( FindInCylinder( start, 256, -64, 256, nil, MASK_SOLID_BRUSHONLY, player.GetAll() ) ) do
						local team = v:SCPTeam()
						if team != TEAMS_SPEC and team != TEAMS_SCP then
							//if !v:HasEffect( "radiation" ) then
								v:ApplyEffect( "radiation" )
							//end
						end
					end
				end

				charges = charges - take

				if charges <= 0 then
					charges = 0
					interrupt = true
				end

				self:SetCharges( charges )
			end
		end

		if interrupt then
			//print( "interrupt - no charges", CurTime() )
			self:StopSequence()
			self.PrimaryTime = 0
		end
	else
		self:ActionQueueThink()
	end
end

function SWEP:Deploy()
	if SERVER then
		local owner = self:GetOwner()
		if IsValid( owner )  then
			owner:PushSpeed( 0.3, 0.3, -1, "particle_cannon", 1 )
		end
	end
end

function SWEP:Holster()
	if self:GetState() != STATE.IDLE then return false end

	if SERVER then
		self:PopSpeed()
	end

	return true
end

function SWEP:SLCPreDrop()
	if SERVER then
		self:PopSpeed()
	end
end

function SWEP:CanDrop()
	return self:GetState() == STATE.IDLE
end

function SWEP:CanPickup( ply )
	self:SetPos( self:GetPos() + Vector( 0, 0, 20 ) )

	return true
end

function SWEP:OnRemove()
	self:StopSound( "particle_cannon.shot" )
	self:StopSound( "particle_cannon.windup1" )
end

function SWEP:OnDrop()
	if self:GetState() != STATE.IDLE then
		self:StopSequence()
	end

	//self:StopSound( "particle_cannon.shot" )
	//self:StopSound( "particle_cannon.windup1" )
end

function SWEP:PrimaryAttack()
	local ct = CurTime()
	if self.Cooldown < ct and self:GetCharges() > 0 then
		self.PrimaryTime = ct + 0.3
	end
end

function SWEP:GetCustomClip()
	return self:GetCharges()
end

function SWEP:StartSequence()
	if !IsFirstTimePredicted() then return end
	self.Enabled = true

	self:QueueAction( STATE.WIND_UP1, 3, function( time, dur )
		self.WheelAcc = CurTime() + dur
		self:EmitSound( "particle_cannon.windup1" )
	end )

	self:QueueAction( STATE.WIND_UP2, 0.5, function( time, dur )
		self:StopSound( "particle_cannon.windup1" )
		self:EmitSound( "particle_cannon.windup2" )
	end )

	self:QueueAction( STATE.SHOOTING, 0, function( time, dur )
		self:EmitSound( "particle_cannon.shot" )
	end )
end

function SWEP:StopSequence()
	self.Enabled = false
	self.Cooldown = CurTime() + 5

	self:StopSound( "particle_cannon.windup1" )
	self:StopSound( "particle_cannon.shot" )

	if self:GetState() != STATE.WIND_UP1 then
		self:EmitSound( "particle_cannon.winddown" )
	end

	local dur = 2
	self:ResetAction( STATE.WIND_DOWN, dur )
	self.WheelAcc = CurTime() + dur
end

function SWEP:PopSpeed()
	local owner = self:GetOwner()
	if IsValid( owner )  then
		owner:PopSpeed( "particle_cannon" )
	end
end

function SWEP:AdjustMouseSensitivity()
	local state = wep:GetState()
	if state != STATE.IDLE then
		return 0.2
	end
end

if CLIENT then
	SWEP.Speed = 0
	SWEP.WepRot = Angle( 0, 0, 0 )
	function SWEP:PreDrawViewModel( vm, wep, ply )
		local state = self:GetState()
		local c_speed

		if state == STATE.WIND_UP1 then
			local t = self.WheelAcc - CurTime()

			if t < 0 then
				t = 0
			end

			self.Speed = 1 - ( t / 3 )
		elseif state == STATE.WIND_UP2 then
			self.Speed = 1
		elseif state == STATE.WIND_DOWN then
			local t = self.WheelAcc - CurTime()

			if t < 0 then
				t = 0
			end

			c_speed = Lerp( 1 - (t / 2), self.Speed, 0 )
		elseif state == STATE.IDLE then
			self.Speed = 0
		end

		c_speed = c_speed or self.Speed

		if c_speed > 0 then
			local bone = vm:LookupBone( "bone007" )
			if bone then
				self.WepRot.r = ( self.WepRot.r + FrameTime() * c_speed * 280 ) % 360
				vm:ManipulateBoneAngles( bone, self.WepRot )
			end
		end

		if state == STATE.SHOOTING then
			vm:SetSkin( 1 )
		end
	end

	function SWEP:ViewModelDrawn( vm )
		self:DrawBeams( vm )
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end

	function SWEP:DrawWorldModelTranslucent()
		self:DrawBeams()
	end

	/*local laser = CreateMaterial( "particle_cannon_laser", "UnlitGeneric", { --tofile
		[ "$basetexture" ]    = "sprites/laserbeam",
		[ "$additive" ]        = "1",
		[ "$vertexcolor" ]    = "1",
		[ "$vertexalpha" ]    = "1",
	} )*/
	local laser = GetMaterial( "slc/misc/pc_laser" )
	local laser_color = Color( 190, 225, 255, 255 )

	function SWEP:DrawBeams( ent )
		if self:GetState() == STATE.SHOOTING then
			if !ent then
				ent = self
			end

			if IsValid( ent ) then
				local owner = self:GetOwner()

				if IsValid( owner ) then
					local tr_start = owner:GetShootPos()
					local vec = owner:GetAimVector()

					local trace = util.TraceHull( {
						start = tr_start,
						endpos = tr_start + vec * 1000,
						mask = MASK_SHOT,
						filter = { self, owner },
						mins = Vector( -5, -5, -5 ),
						maxs = Vector( 5, 5, 5 )
					} )

					local beam_end = trace.HitPos
					local beam_start

					local att = ent:GetAttachment( 1 )
					if att then
						beam_start = att.Pos + vec * 5
					else
						beam_start = tr_start - Vector( 0, 0, 10 )
					end

					self:SetRenderBoundsWS( beam_start, beam_end )

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
					ang:RotateAroundAxis( ang:Up(), math.random( -60, 10 ) )
					ang:RotateAroundAxis( ang:Right(), math.random( -15, 5 ) )

					render.SetMaterial( laser )
					render.StartBeam( count )
					local tx = CurTime() % 1 + 1

					render.AddBeam(
						beam_start,
						15,
						tx,
						Color( 255, 255, 255, 255 )
					)

					for i = 1, count - 2 do
						ang:RotateAroundAxis( ang:Up(), math.random( -20, 20 ) / i )
						ang:RotateAroundAxis( ang:Right(), math.random( -20, 20 ) / i )
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
						Color( 255, 255, 255, 0 )
					)

					render.EndBeam()
					//render.DrawBeam( beam_start, beam_end, 20, 0, 1 )
				end
			end
		end
	end
end

hook.Add( "StartCommand", "ParticleCannonMovement", function( ply, cmd )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and wep:GetClass() == "weapon_slc_pc" then
		local state = wep:GetState()
		if state != STATE.IDLE then
			cmd:ClearMovement()
		end
	end
end )

InstallTable( "ActionQueue", SWEP )

sound.Add{
	name = "particle_cannon.windup1",
	sound = "weapons/particle_cannon/cg_motor_loop_01.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "particle_cannon.windup2",
	sound = "weapons/particle_cannon/cg_windup_mix_01.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "particle_cannon.winddown",
	sound = "weapons/particle_cannon/cg_winddown_mix_01.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "particle_cannon.shot",
	sound = "weapons/particle_cannon/pc_shot.wav",
	volume = 1,
	level = 100,
	pitch = 100,
	channel = CHAN_STATIC,
}