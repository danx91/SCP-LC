AddCSLuaFile()

ENT.Type 			= "anim"  
ENT.Base 			= "base_anim"

ENT.Damage = 0
ENT.PoisonDamage = 0
ENT.ParticleNum = 6

function ENT:SetupDataTables()
	self:NetworkVar( "Float", "Duration" )
	self:NetworkVar( "Float", "Size" )
end

function ENT:Initialize()
	local dur = self:GetDuration()

	if dur < 3 then
		dur = 3
		self:SetDuration( 3 )
	end

	local ct = CurTime()
	self.DieTime = ct + dur
	self.ArmTime = ct + 1

	self:SetModel( "models/hunter/plates/plate.mdl" )

	if SERVER then
		self:PhysicsInit( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		return
	end

	self.Particles = {}

	local pos = self:GetPos()
	local size = self:GetSize()
	local ang = Angle( 0, 0, 0 )
	local up = Vector( 0, 0, 1 )
	local rot = 360 / self.ParticleNum

	for i = 1, self.ParticleNum do
		self.Particles[i] = { pos = pos + ang:Forward() * 64 * size, roll = SLCRandom() * math.pi * 2 - math.pi, delta = ( SLCRandom( 0, 1 ) * 2 - 1 ) * 0.08 }
		ang:RotateAroundAxis( up, rot )
	end
end

ENT.NextDamageTick = 0
function ENT:Think()
	if CLIENT then return end

	local ct = CurTime()
	
	if self.DieTime <= ct then
		self:Remove()
		return
	end

	if self.ArmTime > ct or self.NextDamageTick > ct then return end

	self.NextDamageTick = self.NextDamageTick + 0.5

	if self.NextDamageTick < ct then
		self.NextDamageTick = ct + 0.5
	end

	local owner = self:GetOwner()
	local wep = IsValid( owner ) and owner:GetSCPWeapon()
	local wep_valid = IsValid( wep ) and wep:CheckOwner()

	local pos = self:GetPos()
	local radius = ( 64 * self:GetSize() ) ^ 2

	for i, v in ipairs( player.GetAll() ) do
		if v:GetPos():DistToSqr( pos ) > radius or v:CheckHazardProtection( 50 ) then continue end

		if wep_valid and !wep:CanTargetPlayer( v ) then continue end
		if !wep_valid then
			local t = v:SCPTeam()
			if t == TEAM_SPEC or SCPTeams.IsAlly( TEAM_SCP, t ) then continue end
		end
	
		v:ApplyEffect( "poison", owner, self.PoisonDamage )

		if self.Damage <= 0 then continue end

		local dmg = DamageInfo()
		dmg:SetDamageType( DMG_POISON )
		dmg:SetDamage( self.Damage )

		if wep_valid then
			dmg:SetAttacker( owner )
		end

		v:TakeDamageInfo( dmg )
	end
end

function ENT:OnRemove()
	if SERVER then return end

	for i, v in ipairs( self.Particles ) do
		if v.particle then
			v.particle:SetDieTime( 0 )
		end
	end
end

ENT.Stage = 0
function ENT:Draw()
	if self.Stage == 0 then
		local pos = self:GetPos()
		local emitter = ParticleEmitter( pos, false )

		for i = 1, self.ParticleNum do
			local data = self.Particles[i]
			local particle = emitter:Add( "effects/blood2", data.pos )
			if particle then
				local size = self:GetSize()

				particle:SetDieTime( 1 )
				particle:SetStartAlpha( 50 )
				particle:SetEndAlpha( 225 )
				particle:SetStartSize( 48 * size )
				particle:SetEndSize( 64 * size )
				particle:SetRoll( data.roll )
				particle:SetRollDelta( data.delta )
				particle:SetColor( 70, 5, 5 )

				self.Particle = particle
				data.particle = particle
				data.roll = data.roll + data.delta
			end
		end

		emitter:Finish()
		self.Stage = 1
	elseif self.Stage == 1 and self.Particle:GetLifeTime() >= self.Particle:GetDieTime() then
		local pos = self:GetPos()
		local dur = self:GetDuration() - 2
		local emitter = ParticleEmitter( pos, false )

		for i = 1, self.ParticleNum do
			local data = self.Particles[i]
			local particle = emitter:Add( "effects/blood2", data.pos )
			if particle then
				local size = self:GetSize()

				particle:SetDieTime( dur )
				particle:SetStartAlpha( 225 )
				particle:SetEndAlpha( 225 )
				particle:SetStartSize( 64 * size )
				particle:SetEndSize( 60 * size )
				particle:SetRoll( data.roll )
				particle:SetRollDelta( data.delta )
				particle:SetColor( 70, 5, 5 )

				self.Particle = particle
				data.particle = particle
				data.roll = data.roll + data.delta * dur
			end
		end

		emitter:Finish()
		self.Stage = 2
	elseif self.Stage == 2 and self.Particle:GetLifeTime() >= self.Particle:GetDieTime() then
		local pos = self:GetPos()
		local emitter = ParticleEmitter( pos, false )

		for i = 1, self.ParticleNum do
			local data = self.Particles[i]
			local particle = emitter:Add( "effects/blood2", data.pos )
			if particle then
				local size = self:GetSize()

				particle:SetDieTime( 1 )
				particle:SetStartAlpha( 225 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 64 * size )
				particle:SetEndSize( 32 * size )
				particle:SetRoll( data.roll )
				particle:SetRollDelta( data.delta )
				particle:SetColor( 70, 5, 5 )

				self.Particle = particle
				data.particle = particle
				data.roll = data.roll + data.delta
			end
		end

		emitter:Finish()
		self.Stage = 3
	end
end

function ENT:SetDamage( damage )
	self.Damage = damage
end

function ENT:SetPoisonDamage( damage )
	self.PoisonDamage = damage
end