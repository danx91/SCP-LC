AddCSLuaFile()

ENT.Type = "anim"

ENT.Radius = 50
ENT.Power = 50
ENT.Damage = 1.5
ENT.ShouldSpread = true
ENT.HurtOwner = true
ENT.CreateParticles = true

function ENT:SetupDataTables()
	self:AddNetworkVar( "_DieTime", "Float" )
	self:AddNetworkVar( "_BurnTime", "Float" )

	self:Set_BurnTime( 3 )
end

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )

	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )

		self:EmitSound( "General.BurningObject" )
		
		if self:Get_DieTime() == 0 then
			self:Set_DieTime( CurTime() + self:Get_BurnTime() )
		end
	end

	hook.Run( "SLCOnEntityIgnited", self:GetParent(), self )
end

function ENT:OnRemove()
	if SERVER then
		self:StopSound( "General.BurningObject" )
	end

	if CLIENT and IsValid( self.Particles ) then
		self.Particles:StopEmission()
	end
end

ENT.NThink = 0
//ENT.NextDamage = 0
function ENT:Think()
	if self.NThink > CurTime() then return end
	self.NThink = CurTime() + 0.333//0.25

	if CLIENT then
		if !IsValid( self.Particles ) then
			if self.CreateParticles then
				self.Particles = CreateParticleSystem( self, "scp_457_fire", PATTACH_ABSORIGIN, 0, Vector( 0, 0, 10 ) )

				if !IsValid( self.Particles ) then
					print( "Failed to create ParticleSystem! Particle file may be missing!" )
					return
				end
			end
		else
			if !self.CreateParticles then
				self.Particles:StopEmission()
			end
		end
	end

	local parent = self:GetParent()
	local water_level = IsValid( parent ) and parent:WaterLevel() or self:WaterLevel()
	if ( self:Get_DieTime() != -1 and self:Get_DieTime() < CurTime() ) or water_level == 4 or ( IsValid( parent ) and parent:IsPlayer() and !parent:Alive() ) then
		if CLIENT and IsValid( self.Particles ) then
			self.Particles:StopEmission()
		end

		if SERVER then
			self:Remove()
			return
		end
	end

	if SERVER then
		local owner = self:GetOwner()
		if self.Signature and IsValid( owner ) then
			if !owner:CheckSignature( self.Signature ) then
				self:Remove()
			end
		end

		local final_dmg = self.Damage

		if water_level == 1 then
			final_dmg = final_dmg * 0.66
		elseif water_level == 2 then
			final_dmg = final_dmg * 0.33
		end

		if final_dmg > 0 /*and self.NextDamage < CurTime()*/ then
			//self.NextDamage = CurTime() + 0.333

			if IsValid( parent ) then
				if self.HurtOwner or parent != owner then
					local dmg = DamageInfo()

					dmg:SetDamage( final_dmg )
					dmg:SetDamageType( DMG_BURN )
					dmg:SetInflictor( self )

					if IsValid( owner ) then
						dmg:SetAttacker( owner )
					else
						dmg:SetAttacker( self )
					end

					if hook.Run( "SLCFireOnBurnPlayer", self, parent, dmg ) != true then
						parent:TakeDamageInfo( dmg )
					end
				end
			end

			if self.Power >= 20 then
				for k, v in pairs( FindInCylinder( self:GetPos() + Vector( 0, 0, 32 ), self.Radius, -32, 32, nil, MASK_SOLID_BRUSHONLY, player.GetAll() ) ) do
					if v:IsPlayer() and v != parent and v:SCPTeam() != TEAM_SPEC and ( self.HurtOwner or v != owner ) then
						if IsValid( owner ) and owner:IsPlayer() then
							if owner:SCPTeam() == TEAM_SCP and v:SCPTeam() == TEAM_SCP then
								continue
							end
						end

						if final_dmg > 0 then
							local dmg = DamageInfo()
							
							dmg:SetDamage( final_dmg * 0.5 )
							dmg:SetDamageType( DMG_BURN )
							dmg:SetInflictor( self )

							if IsValid( owner ) then
								dmg:SetAttacker( owner )
							else
								dmg:SetAttacker( self )
							end

							if hook.Run( "SLCFireOnBurnPlayer", self, v, dmg ) != true then
								v:TakeDamageInfo( dmg )
							end
						end

						if self.ShouldSpread then
							if math.random( 100 ) <= self.Power then
								v:Burn( math.max( self:Get_BurnTime() * 0.75, 1 ), self.Power * 0.75, owner, self.Damage, self.Signature != nil, self.DontOverride )
							end
						end
					end
				end
			end
		end
	end
end

function ENT:Draw()
end

function ENT:SetBurnTime( time )
	if !time then return end

	if time >= 0 then
		self:Set_BurnTime( time )
		self:Set_DieTime( CurTime() + time )
	else
		self:Set_BurnTime( -time )
		self:Set_DieTime( -1 )
	end
end

function ENT:SetFireRadius( radius )
	if !radius then return end

	if radius > 0 then
		self.Power = math.Clamp( radius, 10, 100 )
		self.Radius = math.max( radius, 10 )
	else
		self.Power = 0
		self.Radius = 0
	end
end

function ENT:SetFireDamage( dmg )
	if !dmg then return end

	self.Damage = dmg
end

function ENT:SetSignatureCheck( s )
	self.Signature = s
end

function ENT:SetShouldSpread( b )
	self.ShouldSpread = b
end

function ENT:SetShouldHurtOwner( b )
	self.HurtOwner = b
end

function ENT:SetShouldCreateParticles( b )
 	self.CreateParticles = b
end

function ENT:SetDontOverride( b )
	self.DontOverride = b
end