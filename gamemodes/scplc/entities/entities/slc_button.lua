AddCSLuaFile()

ENT.Type = "anim"

ENT.State = false
ENT.NTime = 0

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetModel( "models/hunter/plates/plate05x05.mdl" )
	self:SetNoDraw( true )

	if SERVER then
		self:PhysicsInit( SOLID_BBOX )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetUseType( SIMPLE_USE )
	end

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
end

function ENT:Think()
	if self.PlayingAnim then
		local f = 1 - ( self.NTime - CurTime() ) / self.UseTime

		if f < 0 then
			f = 0
		end

		if f > 1 then
			f = 1
			self.PlayingAnim = false
		end

		if self.AnimType == 0 then
			if f < 0.5 then
				self.TiedEntity:SetPos( LerpVector( f * 2, self.AnimPos, self.MidValue ) )
			else
				self.TiedEntity:SetPos( LerpVector( ( f - 0.5 ) * 2, self.MidValue, self.State == false and self.StartValue or self.EndValue ) )
			end
		elseif self.AnimType == 1 then
			if f < 0.5 then
				self.TiedEntity:SetAngles( LerpAngle( f * 2, self.AnimPos, self.MidValue ) )
			else
				self.TiedEntity:SetAngles( LerpAngle( ( f - 0.5 ) * 2, self.MidValue, self.State == false and self.StartValue or self.EndValue ) )
			end

			//self.TiedEntity:SetAngles( LerpAngle( f, self.AnimPos, self.State == false and self.StartValue or self.EndValue ) )
		end
	end

	self:NextThink( CurTime() )
	return true
end

function ENT:Use()
	if self.NTime <= CurTime() then
		self.NTime = CurTime() + self.UseTime

		self.State = !self.State

		if self.Sound then
			self:EmitSound( self.Sound )
		end

		if IsValid( self.TiedEntity ) then
			self.PlayingAnim = true
			self.AnimPos = self.AnimType == 0 and self.TiedEntity:GetPos() or self.TiedEntity:GetAngles()
		end
	end
end

function ENT:Tie( ent, time, t, startval, endval, initial, mid )
	if IsValid( ent ) then
		self:SetPos( ent:GetPos() )

		self.TiedEntity = ent
		self.UseTime = time

		self.AnimType = t
		self.StartValue = startval
		self.EndValue = endval
		self.MidValue = mid or ( startval + endval ) / 2

		self.Initial = initial
	end
end

function ENT:SetSound( snd )
	self.Sound = snd
end

function ENT:GetState()
	if self.Initial then
		return !self.State
	else
		return self.State
	end
end