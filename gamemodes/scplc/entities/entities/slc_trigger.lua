AddCSLuaFile()

ENT.Type = "brush"

function ENT:Initialize()
	if SERVER then
		self:SetTrigger( true )
	end
end

function ENT:SetTriggerBounds( mins, maxs, bounds )
	self:SetCollisionBounds( mins, maxs )
	self:UseTriggerBounds( !!bounds, bounds or 0 )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

/*function ENT:StartTouch( ent )
	
end

function ENT:Touch( ent )
	
end

function ENT:EndTouch( ent )
	
end*/