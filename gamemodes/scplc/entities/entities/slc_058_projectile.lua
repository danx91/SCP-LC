AddCSLuaFile()

ENT.Type 			= "anim"  
ENT.Base 			= "base_anim"

ENT.Speed = 11
ENT.Size = 1
ENT.Gravity = Vector( 0, 0, 4 )
ENT.EffectName = "SLCBloodSplash"
 
function ENT:SetupDataTables()
	self:NetworkVar( "Float", "Size" )
end

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

		local hull_size = 3 * self:GetSize()

		local filter = SCPTeams.GetPlayersByTeam( TEAM_SCP )
		filter[#filter + 1] = self

		local trace = util.TraceHull( {
			start = pos,
			endpos = pos + self.Velocity,
			mask = MASK_SHOT,
			filter = filter,
			mins = Vector( -hull_size, -hull_size, -hull_size ),
			maxs = Vector( hull_size, hull_size, hull_size ),
		} )

		if trace.Hit then
			util.Decal( "Blood", trace.HitPos + trace.HitNormal * 5, trace.HitPos - trace.HitNormal * 5 )

			local size = self:GetSize()
			local num = math.floor( 6 * size )
			local ang = 2 * math.pi / num
			local vang = trace.HitNormal:Angle()
			local up = vang:Up()
			local right = vang:Right()
			local radius_min = 10 * size
			local radius_max = 25 * size

			for i = 1, num do
				local n = ang * ( i - 1 + ( SLCRandom() * 0.5 - 0.25 ) )
				local d_pos = trace.HitPos + math.sin( n ) * right * SLCRandom( radius_min, radius_max ) - math.cos( n ) * up * SLCRandom( radius_min, radius_max )
				util.Decal( "Blood", d_pos + trace.HitNormal * 15, d_pos - trace.HitNormal * 15 )
			end

			if self.EffectName then
				ParticleEffect( self.EffectName, trace.HitPos, trace.HitNormal:Angle() )
			end

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
		local size = self:GetSize()

		particle:SetDieTime( 0.3 )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 4 * size )
		particle:SetEndSize( 8 * size )
		particle:SetRoll( SLCRandom() * math.pi * 2 )
		particle:SetRollDelta( SLCRandom() * 0.2 - 0.1 )
		particle:SetColor( 120, 10, 10 )
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector( 0, 0, 5 ) )
	end

	emitter:Finish()
end

function ENT:SetSpeed( speed )
	self.Speed = speed
end

function ENT:SetGravity( gravity )
	self.Gravity = gravity
end

function ENT:SetEffectName( name )
	self.EffectName = name
end

sound.Add{
	name = "SLC.BloodSplash",
	volume = 1,
	level = 75,
	pitch = { 90, 110 },
	//sound = "physics/flesh/flesh_squishy_impact_hard4.wav",
	sound = "physics/surfaces/underwater_impact_bullet1.wav",
	channel = CHAN_STATIC,
}