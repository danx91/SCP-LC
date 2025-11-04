AddCSLuaFile()

ENT.Type 			= "anim"  
ENT.Base 			= "base_anim"

ENT.Speed = 14
ENT.Gravity = Vector( 0, 0, 6 )

function ENT:Initialize()
	self.DieTime = CurTime() + 10

	self:SetModel( "models/hunter/plates/plate.mdl" )

	if SERVER then
		self:PhysicsInit( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
	end

	self.Velocity = self:GetAngles():Forward() * self.Speed
end

function ENT:Think()
	local ct = CurTime()
	local pos = self:GetPos()

	if SERVER then
		if self.DieTime <= ct then
			self:Remove()
			return
		end

		local filter = SCPTeams.GetPlayersByTeam( TEAM_SCP )
		filter[#filter + 1] = self
		
		local hull_size = 3
		local trace = util.TraceHull( {
			start = pos,
			endpos = pos + self.Velocity,
			mask = MASK_SHOT,
			filter = filter,
			mins = Vector( -hull_size, -hull_size, -hull_size ),
			maxs = Vector( hull_size, hull_size, hull_size ),
		} )

		if trace.Hit then
			ParticleEffect( "SLC_SCP0492_Shot", trace.HitPos, trace.HitNormal:Angle() )
			self:EmitSound( "SLC.BloodSplash" )
			self:OnHit( trace )
			self:Remove()

			return
		end

		self:SetPos( pos + self.Velocity )
		self.Velocity = self.Velocity - self.Gravity * FrameTime()
	end

	self:NextThink( ct )
	return true
end

function ENT:OnHit( trace )
	
end

function ENT:Draw()
	local pos = self:GetPos()
	local emitter = ParticleEmitter( pos, false )

	local particle = emitter:Add( "effects/blood2", pos )
	if particle then
		particle:SetDieTime( 0.3 )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 3 )
		particle:SetEndSize( 6 )
		particle:SetRoll( SLCRandom() * math.pi * 2 )
		particle:SetRollDelta( SLCRandom() * 0.2 - 0.1 )
		particle:SetColor( 10, 120, 10 )
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector( 0, 0, 5 ) )
	end

	emitter:Finish()
end