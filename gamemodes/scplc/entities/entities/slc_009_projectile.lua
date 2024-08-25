AddCSLuaFile()

ENT.Type 			= "anim"  
ENT.Base 			= "base_anim"

function ENT:Initialize()
	self.RemoveTime = CurTime() + 10

	self:SetModel( "models/cultist/scp_items/009/w_scp_009.mdl" )

	if CLIENT then return end

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
end

local hit_trace = {}
hit_trace.mask = MASK_SOLID_BRUSHONLY
hit_trace.output = hit_trace

function ENT:PhysicsCollide( entity )
	self:EmitSound( "SCP009.Splash" )

	local owner = self:GetOwner()
	local pos = self:GetPos()
	local data = EffectData()

	data:SetOrigin( pos )
	util.Effect( "slc_009_effect", data )

	hit_trace.start = pos
	hit_trace.filter = self

	for i, v in pairs( ents.FindInSphere( pos, 150 ) ) do
		if !v:IsPlayer() or !v:Alive() then continue end
		
		hit_trace.endpos = v:GetPos() + v:OBBCenter()
		util.TraceLine( hit_trace )

		if !hit_trace.Hit then
			v:ApplyEffect( "scp009", owner:Alive() and owner )
		end
	end

	self:Remove()
end

function ENT:Draw()
	self:DrawModel()
end

sound.Add{
	name = "SCP009.Splash",
	volume = 1,
	level = 75,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/009/shatter.ogg",
	channel = CHAN_STATIC,
}