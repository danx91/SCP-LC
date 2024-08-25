AddCSLuaFile()

ENT.Type = "anim"

function ENT:SetupDataTables()
	self:AddNetworkVar( "DieTime", "Float" )
	self:AddNetworkVar( "GroundPos", "Vector" )
end

local bounds = Vector( 16, 16, 32 )
function ENT:Initialize()
	self:SetModel( "models/slc/scp106_teleport/portal_wall.mdl" )

	if CLIENT then return end

	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

	self:SetCollisionBounds( -bounds, bounds )

	self:SetMaxHealth( 400 )
	self:SetHealth( 400 )

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

local trace_tab = {}
trace_tab.mins = Vector( -16, -16, 16 )
trace_tab.maxs = Vector( 16, 16, 16 )
trace_tab.mask = MASK_SHOT
trace_tab.output = trace_tab

function ENT:Think()
	if CLIENT or self.Triggered or self.Destroyed then return end

	local owner = self:GetOwner()
	if self:GetDieTime() <= CurTime() or !IsValid( owner ) or owner:SCPClass() != CLASSES.SCP106 then
		self.Destroyed = true
		self:Remove()
		return
	end

	local wep = owner:GetSCPWeapon()
	if !IsValid( wep ) then
		self.Destroyed = true
		self:Remove()
		return
	end

	local pos = self:GetPos()
	local dir = self:GetAngles():Up()

	trace_tab.start = pos + dir * 16
	trace_tab.endpos = pos + dir * 100
	trace_tab.filter = self
	
	util.TraceHull( trace_tab )

	if !trace_tab.Hit then return end

	local ent = trace_tab.Entity
	if !IsValid( ent ) or !ent:IsPlayer() or SCPTeams.IsAlly( ent:SCPTeam(), TEAM_SCP ) then return end
	
	self.Triggered = true
	wep:TrapTriggered( self, ent )
	self:EmitSound( "SCP106.TrapTriggered" )

	timer.Simple( 10, function()
		if !IsValid( self ) then return end
		self.Destroyed = true
		self:Remove()
	end )
end

function ENT:OnTakeDamage( dmg )
	if self.Triggered or self.Destroyed then return end

	local att = dmg:GetAttacker()
	if !IsValid( att ) or !att:IsPlayer() or SCPTeams.IsAlly( att:SCPTeam(), TEAM_SCP ) then return end

	local hp = self:Health() - dmg:GetDamage()
	self:SetHealth( hp )

	if hp <= 0 then
		self.Destroyed = true
		self:Remove()
	end
end

function ENT:Draw()
	self:DrawModel()
end

sound.Add( {
	name = "SCP106.TrapTriggered",
	volume = 0.5,
	level = 75,
	pitch = 100,
	sound = "npc/ichthyosaur/snap_miss.wav",
	channel = CHAN_STATIC,
} )