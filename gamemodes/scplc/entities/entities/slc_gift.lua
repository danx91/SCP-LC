ENT.Base = "base_entity"

ENT.Type = "anim"
ENT.Category = "Breach"


ENT.Author = "danx91"

ENT.PrintName = ""
ENT.GiftType = false

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "GiftType" )
end

function ENT:Initialize()
	self.GiftType = self:GetGiftType()
	local model = self.GiftType and "models/katharsmodels/present/type-2/big/present3.mdl" or "models/katharsmodels/present/type-2/big/present2.mdl" 
	self:SetModel( model )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
	end
	if SERVER then
		timer.Simple( 3, function()
			if IsValid( self ) then
				if self.GiftType then

					local fx = EffectData()
					fx:SetOrigin( self:GetPos() )
					util.Effect( "br_heal", fx )

		        	local fent = ents.FindInSphere( self:GetPos(), 100 )
		        	for k, v in pairs( fent ) do
		        		if IsValid( v ) and v:IsPlayer() then
		        			if v:GTeam() != TEAM_SPEC then
		        				local dist = self:GetPos():Distance( v:GetPos() )
		        				local health = math.Clamp( v:Health() + math.random( 20, 40 ), 1, v:GetMaxHealth() )
		        				v:SetHealth( health )
		        			end
		        		end
		        	end
				else
					local explosion = ents.Create( "env_explosion" )
		        	explosion:SetKeyValue( "spawnflags", 145 )
		        	explosion:SetPos( self:GetPos() )
		        	explosion:Spawn()
		        	explosion:Fire( "explode", "", 0 )
		        	local fent = ents.FindInSphere( self:GetPos(), 300 )
		        	for k, v in pairs( fent ) do
		        		if IsValid( v ) then
		        			if v:IsPlayer() then
			        			if v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
			        				local dist = self:GetPos():Distance( v:GetPos() )
			        				local dmg = ( 300 - dist ) / 4
			        				v:TakeDamage( dmg, self.Owner, self.Owner )
			        			end
			        		elseif v:GetClass() == "func_breakable" then
			        			v:TakeDamage( 50, self.Owner, self.Owner )
			        		end
		        		end
		        	end
				end
				self:Remove()
			end
		end )
	end
end

function ENT:SetPhysVelocity( vel )
	self:SetVelocity( vel )
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:SetVelocity( vel )
	end
end

function ENT:Draw()
	self:DrawModel()
end