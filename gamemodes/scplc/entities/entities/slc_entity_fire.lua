AddCSLuaFile()

ENT.Type = "anim"

ENT.Radius = 50
ENT.Power = 50
ENT.Damage = 1.5
ENT.ShouldSpread = true
ENT.HurtOwner = true

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "_DieTime" )
	self:NetworkVar( "Float", 1, "_BurnTime" )

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
end

function ENT:OnRemove()
	if SERVER then
		self:StopSound( "General.BurningObject" )
	end
end

ENT.NThink = 0
ENT.NextDamage = 0
function ENT:Think()
	if self.NThink > CurTime() then return end
	self.NThink = CurTime() + 0.25

	if CLIENT then
		if !IsValid( self.Particles ) then
			self.Particles = CreateParticleSystem( self, "scp_457_fire", PATTACH_ABSORIGIN, 0, Vector( 0, 0, 10 ) )
		end
	end

	if self:Get_DieTime() != -1 and self:Get_DieTime() < CurTime() or self:WaterLevel() > 0 then
		if CLIENT then
			self.Particles:StopEmission()
		end

		if SERVER then
			self:Remove()
		end
	end

	if SERVER then
		if self.Damage > 0 and self.NextDamage < CurTime() then
			self.NextDamage = CurTime() + 0.333

			local owner = self:GetOwner()

			local parent = self:GetParent()
			if IsValid( parent ) then
				if self.HurtOwner or parent != owner then
					local dmg = DamageInfo()
					dmg:SetDamage( self.Damage )
					dmg:SetDamageType( DMG_BURN )
					dmg:SetInflictor( self )

					if IsValid( owner ) then
						dmg:SetAttacker( owner )

						if owner:IsPlayer() and owner:SCPClass() == CLASSES.SCP457 then
							local hp = owner:Health() + 5
							local max = owner:GetMaxHealth()

							if hp > max then
								hp = max
							end

							owner:SetHealth( hp )
						end
					else
						dmg:SetAttacker( self )
					end

					parent:TakeDamageInfo( dmg )
				end
			end

			if self.Power >= 20 then
				for k, v in pairs( FindInCylinder( self:GetPos() + Vector( 0, 0, 32 ), self.Radius, -32, 32, { "player" }, MASK_SOLID_BRUSHONLY ) ) do
					if v:IsPlayer() and v != parent and v:SCPTeam() != TEAM_SPEC then
						if IsValid( owner ) and owner:IsPlayer() then
							if owner:SCPTeam() == TEAM_SCP and v:SCPTeam() == TEAM_SCP then
								continue
							end
						end

						local dmg = DamageInfo()
						dmg:SetDamage( self.Damage * 0.5 )
						dmg:SetDamageType( DMG_BURN )
						dmg:SetInflictor( self )

						if IsValid( owner ) then
							dmg:SetAttacker( owner )

							if owner:IsPlayer() and owner:SCPClass() == CLASSES.SCP457 then
								local hp = owner:Health() + 2
								local max = owner:GetMaxHealth()

								if hp > max then
									hp = max
								end

								owner:SetHealth( hp )
							end
						else
							dmg:SetAttacker( self )
						end

						v:TakeDamageInfo( dmg )

						if self.ShouldSpread then
							if math.random( 100 ) <= self.Power then
								v:Burn( math.max( self:Get_BurnTime() * 0.75, 1 ), self.Power * 0.75, owner, self.Damage )
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

	if time > 0 then
		self:Set_BurnTime( time )
		self:Set_DieTime( CurTime() + time )
	else
		self:Set_BurnTime( -time )
		self:Set_DieTime( -1 )
	end
end

function ENT:SetFireRadius( radius )
	if !radius then return end

	self.Power = math.Clamp( radius, 10, 100 )
	self.Radius = math.max( radius, 10 )
end

function ENT:SetFireDamage( dmg )
	if !dmg then return end

	self.Damage = dmg
end

function ENT:SetShouldSpread( b )
	self.ShouldSpread = b
end

function ENT:SetShouldHurtOwner( b )
	self.HurtOwner = b
end