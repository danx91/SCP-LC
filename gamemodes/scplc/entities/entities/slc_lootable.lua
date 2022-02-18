AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	if CLIENT then return end

	if !self.Model then
		self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		self:DrawShadow( false )
		self:SetNoDraw( true )

		if SERVER then
			self:PhysicsInit( SOLID_BBOX )
			self:SetMoveType( MOVETYPE_NONE )
			self:SetUseType( SIMPLE_USE )

			local phys = self:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableMotion( false )
			end
		end

		self:SetCollisionBounds( Vector( -16, -16, -16), Vector( 16, 16, 16 ) )
	else
		self:SetModel( self.Model )

		if SERVER then
			self:PhysicsInit( SOLID_VPHYSICS )
			self:SetUseType( SIMPLE_USE )
			self:PhysWake()
		end
	end

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	if SERVER then
		self:InstallTable( "Lootable" )
	end
end

ENT.NCheck = 0
function ENT:Think()
	if CLIENT then return end

	local rt = RealTime()
	if self.NCheck <= rt then
		self.NCheck = rt + 1

		self:CheckListeners()

		if self.RemoveOnEmpty and !next( self.LootItems ) then
			self:DropAllListeners()
			self:Remove()
		end
	end
end