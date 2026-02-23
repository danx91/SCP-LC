AddCSLuaFile()

ENT.Type = "anim"

ENT.Size = 1
ENT.Damage = 3

PrecacheParticleSystem( "SLC_SCP457_Fireball" )

function ENT:SetupDataTables()
	self:NetworkVar( "Float", "Speed" )
end

local mat = Material( "slc/scp/457fireball" )
function ENT:Initialize()
	self:SetModel( "models/dav0r/hoverball.mdl" )
	self:DrawShadow( false )
	self:SetMaterial( mat:GetName() )

	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )
		self:SetModelScale( self.Size )

		local fire = self:Burn( -3, 75 * self.Size, self:GetOwner(), self.Damage )
		fire:SetShouldHurtOwner( false )
		fire:SetShouldHurtParent( false )
		fire:SetDontCreateParticles( true )
		fire:SetOffset( Vector( 0, 0, 0 ) )

		timer.Simple( 0, function()
			ParticleEffectAttach( "SLC_SCP457_Fireball", PATTACH_ABSORIGIN_FOLLOW, self, 0 )
		end )
	end
end

local movement_trace = {}
movement_trace.output = movement_trace
movement_trace.mask = MASK_SOLID_BRUSHONLY
movement_trace.maxs = Vector( 4, 4, 4 )
movement_trace.mins = Vector( -4, -4, -4 )

function ENT:Think()
	local pos = self:GetPos()
	local new_pos = pos + self:GetAngles():Forward() * self:GetSpeed() * FrameTime()

	if SERVER then
		movement_trace.start = pos
		movement_trace.endpos = new_pos

		if self.NoHull then
			util.TraceLine( movement_trace )
		else
			util.TraceHull( movement_trace )
		end

		if movement_trace.Hit then
			self:Remove()
			return
		end
	end

	self:SetPos( new_pos )
	self:NextThink( CurTime() )
	return true
end

function ENT:SetDamage( dmg )
	self.Damage = dmg
end

function ENT:SetSize( size )
	self.Size = size
end

function ENT:Draw()
	self:DrawModel()
end