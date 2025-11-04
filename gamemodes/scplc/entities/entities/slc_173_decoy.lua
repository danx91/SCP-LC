AddCSLuaFile()

ENT.Type = "anim"

function ENT:SetupDataTables()

end

function ENT:Initialize()
	self:SetModel( "models/scp/173.mdl" )
	
	if CLIENT then return end

	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )

	self.Targets = {}
	self.TargetsLookup = {}
	self.Attacked = false

	self:DropToFloor()
end

function ENT:Think()
	if CLIENT then return end

	local freeze = false

	for i, v in ipairs( player.GetAll() ) do
		local team = v:SCPTeam()
		if !v:Alive() or team == TEAM_SPEC or team == TEAM_SCP or v:GetBlink() or !self:TestVisibility( v ) then continue end

		freeze = true

		if !self.TargetsLookup[v] then
			self.TargetsLookup[v] = v:TimeSignature()
			table.insert( self.Targets, v )
		end
	end

	if !freeze then
		if #self.Targets > 0 and !self.Attacked then
			self:Attack()
		elseif self.ShouldRemove then
			self:Remove()
		end
	elseif self.Attacked then
		self.ShouldRemove = true
	end
end

local trace_offset = Vector( 0, 0, -96 )

local attack_trace = {}
attack_trace.mins = Vector( -24, -24, 1 )
attack_trace.maxs = Vector( 24, 24, 1 )
attack_trace.mask = MASK_SOLID
attack_trace.output = attack_trace

function ENT:Attack()
	local victim = self.Targets[SLCRandom( #self.Targets )]
	if !IsValid( victim ) or !victim:CheckSignature( self.TargetsLookup[victim] ) or !victim:GetBlink() then return end

	local pos = victim:GetPos() + victim:OBBCenter()
	local angles = victim:GetAngles()

	angles.p = 0
	angles.r = 0

	local point = pos + angles:Forward() * 100
	if !util.IsInWorld( point ) then return end

	attack_trace.start = pos
	attack_trace.endpos = point
	attack_trace.filter = victim

	util.TraceLine( attack_trace )

	if attack_trace.Hit then return end

	attack_trace.start = point
	attack_trace.endpos = point + trace_offset

	util.TraceHull( attack_trace )

	if !attack_trace.Hit then return end

	self.Attacked = true
	self:SetPos( attack_trace.HitPos )

	local line_ang = ( pos - attack_trace.HitPos ):Angle()

	line_ang.p = 0
	line_ang.r = 0

	self:SetAngles( line_ang )

	victim:SetProperty( "SCP173NextHorror", CurTime() + 10 )
	victim:TakeSanity( 15, SANITY_TYPE.ANOMALY )
	
	TransmitSound( "scp_lc/scp/173/horror/horror"..SLCRandom( 0, 9 )..".ogg", true, victim )
end

function ENT:Draw()
	self:DrawModel()
end