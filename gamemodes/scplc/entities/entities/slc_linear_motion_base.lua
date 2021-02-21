AddCSLuaFile()

ENT.Type = "anim"

ENT.Frame = 0
ENT.PlayingAnim = false
ENT.AnimTime = 0
ENT.RemainingTime = 0
ENT.Finished = false

function ENT:Initialize()
	self:SetModel( self.Model or "" )

	if SERVER then
		self:PhysicsInit( self.Solid or SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end

		self.AnimData = {}
	end
end

function ENT:Think()
	if SERVER and self.PlayingAnim then
		local data = self.AnimData[self.Frame]
		if data then
			local ct = CurTime()
			local f = 1 - ( self.AnimTime - ct ) / data.time

			if f > 1 then
				f = 1

				self.Frame = self.Frame + 1
				local ndata = self.AnimData[self.Frame]
				if ndata then
					self.StartPos = data.pos
					self.StartAngles = data.ang
					self.AnimTime = ct + ndata.time
				else
					self.Finished = true
					self.PlayingAnim = false
				end
			end

			if data.pos then
				self:SetPos( LerpVector( f, self.StartPos, data.pos ) )
			end
			
			if data.ang then
				self:SetAngles( LerpAngle( f, self.StartAngles, data.ang ) )
			end

			self:NextThink( ct )
			return true
		end
	end
end

function ENT:AddPoint( data )
	table.insert( self.AnimData, data )
end

function ENT:StartMovement()
	self.PlayingAnim = true
	self.StartPos = self:GetPos()
	self.StartAngles = self:GetAngles()

	if self.Frame > 0 and self.RemainingTime > 0 then
		self.AnimTime = CurTime() + self.RemainingTime
	else
		local data = self.AnimData[self.Frame + 1]
		if data then
			self.Frame = self.Frame + 1
			self.AnimTime = CurTime() + data.time
		end
	end
end

function ENT:StopMovement()
	self.PlayingAnim = false
	self.RemainingTime = self.AnimTime - CurTime()
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end