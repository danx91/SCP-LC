AddCSLuaFile()

ENT.Type = "anim"

ENT.DieTime = 0
ENT.Used = false

ENT.BurnTime = 2
ENT.Damage = 3

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetModel( "models/hunter/plates/plate05x05.mdl" )

	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )

		self:SetTrigger( true )
		
		self:SetMaxHealth( 100 )
		self:SetHealth( 100 )

		self.ArmTime = CurTime() + 3
	end

	if CLIENT then
		local tr = util.TraceLine{
			start = self:GetPos() + Vector( 0, 0, 10 ),
			endpos = self:GetPos() - Vector( 0, 0, 10 ),
			mask = MASK_SOLID_BRUSHONLY,
		}

		self.RenderPos = tr.HitPos
		self.RenderAng = tr.HitNormal:Angle()
		self.RenderAng.p = self.RenderAng.p + 90
	end

	self:SetCollisionBounds( Vector( -16, -16, 0 ), Vector( 16, 16, 32 ) )
	self:UseTriggerBounds( true, 16 )
end

function ENT:Think()
	if CLIENT then return end

	if self.DieTime != -1 and self.DieTime <= CurTime() then
		self:TriggerIgnite()
	end
end

function ENT:StartTouch( ent )
	if self.ArmTime >= CurTime() or !ent:IsPlayer() then return end

	local t = ent:SCPTeam()
	if SCPTeams.IsAlly( TEAM_SCP, t ) then return end

	self:TriggerIgnite()
end

function ENT:OnTakeDamage( dmg )
	local att = dmg:GetAttacker()
	if !IsValid( att ) or !att:IsPlayer() or SCPTeams.IsAlly( att:SCPTeam(), TEAM_SCP ) then return end
	
	self:SetHealth( self:Health() - dmg:GetDamage() )
	if self:Health() > 0 then return end
	
	self:TriggerIgnite()
end

function ENT:TriggerIgnite()
	if self.Used then return end
	self.Used = true

	local fire = ents.Create( "slc_entity_fire" )
	fire:SetPos( self:GetPos() )

	local owner = self:GetOwner()
	if IsValid( owner ) and owner:IsPlayer() and owner:SCPClass() == CLASSES.SCP457 then
		fire:SetOwner( owner )
	end
	
	fire:SetBurnTime( self.BurnTime )
	fire:SetFireRadius( 100 )
	fire:SetFireDamage( self.Damage )
	fire:Spawn()

	self:EmitSound( "FireTrap.Ignite" )
	self:Remove()
end

local mat = Material( "slc/scp/457trap" )
function ENT:Draw()
	--self:DrawModel()

	cam.Start3D2D( self.RenderPos, self.RenderAng, 0.4 )
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( -64, -64, 128, 128 )
	cam.End3D2D()
end

function ENT:SetLifeTime( time )
	if time < 0 then
		self.DieTime = -1
	else
		self.DieTime = CurTime() + time
	end
end

function ENT:SetBurnTime( time )
	self.BurnTime = time
end

function ENT:SetDamage( dmg )
	self.Damage = dmg
end

sound.Add{
	name = "FireTrap.Ignite",
	sound = "ambient/fire/ignite.wav",
	volume = 1,
	level = 85,
	pitch = 90,
	channel = CHAN_STATIC,
}