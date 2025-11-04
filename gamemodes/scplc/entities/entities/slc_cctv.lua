AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "CameraID" )
end

function ENT:Initialize()
	self:SetModel( "models/slc/cctv/cctvcamera.mdl" )

	if CLIENT then return end

	self:SetMoveType( MOVETYPE_NONE )
	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if !IsValid( phys ) then return end

	phys:EnableMotion( false )

	local pos = self:GetPos()
	self:SetPos( util.TraceLine( {
		start = pos,
		endpos = pos + Vector( 0, 0, 64 ),
		mask = MASK_SOLID_BRUSHONLY,
	} ).HitPos )
end

ENT.DestroyPenalty = 3
function ENT:OnTakeDamage( dmg )
	self:Remove()

	local data = EffectData()
	data:SetOrigin( self:GetPos() )
	data:SetNormal( Vector( 0, 0, -1 ) )
	util.Effect( "cball_explode", data, true, true )

	local attacker = dmg:GetAttacker()
	if !IsValid( attacker ) or !attacker:IsPlayer() or !SCPTeams.HasInfo( attacker:SCPTeam(), SCPTeams.INFO_STAFF ) then return end

	local n = math.min( self.DestroyPenalty, attacker:Frags() )
	attacker:AddFrags( -n )
	PlayerMessage( string.format( "property_dmg$%d#200,25,25", self.DestroyPenalty ), attacker )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Draw()
	self:DrawModel()
end