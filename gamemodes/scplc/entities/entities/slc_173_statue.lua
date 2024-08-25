AddCSLuaFile()

ENT.Type = "anim"

function ENT:SetupDataTables()
	self:AddNetworkVar( "OnGround", "Bool" )
	self:AddNetworkVar( "Move", "Bool" )
	self:AddNetworkVar( "Target", "Vector" )
end

function ENT:Initialize()
	self:SetModel( "models/scp/173.mdl" )
	
	if CLIENT then return end

	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

function ENT:Think()
	if !self:GetOnGround() then
		self:MakeFall()
	end

	if self:GetMove() then
		self:Move()
	end

	self:NextThink( CurTime() )
	return true
end

local trace_tab = {}
trace_tab.mins = Vector( -12, -12, 1 )
trace_tab.maxs = Vector( 12, 12, 1 )
trace_tab.mask = bit.bor( CONTENTS_HITBOX, CONTENTS_MONSTER, CONTENTS_MOVEABLE, CONTENTS_GRATE, CONTENTS_WINDOW, CONTENTS_SOLID, CONTENTS_PLAYERCLIP, CONTENTS_MONSTERCLIP )
trace_tab.output = trace_tab

local speed_vector = Vector( 0, 0, -300 )

function ENT:MakeFall()
	local pos = self:GetPos()

	trace_tab.filter = { self, self:GetOwner() }
	trace_tab.start = pos
	trace_tab.endpos = pos + speed_vector * FrameTime()

	util.TraceHull( trace_tab )

	self:SetPos( trace_tab.HitPos )

	if trace_tab.Hit then
		self:SetOnGround( true )
	end
end

function ENT:Move()
	local pos = self:GetPos()
	local target = self:GetTarget()

	if self.MoveTarget != target then
		self.MoveTarget = target
		self.MovePos = pos
		self.MovePct = 0
	end

	self.MovePct = self.MovePct + FrameTime() * 8
	if self.MovePct > 1 then
		self.MovePct = 1
	end

	self:SetPos( LerpVector( self.MovePct, self.MovePos, target ) )
	
	if self.MoveThink then
		self.MoveThink()
	end

	if self.MovePct == 1 then
		self:SetMove( false )

		if self.MoveCallback then
			self.MoveCallback()
		end
	end
end

function ENT:MoveTo( pos, think, cb )
	self:SetMove( true )
	self:SetTarget( pos )
	self.MoveThink = think
	self.MoveCallback = cb

	self:SetAngles( Angle( 0, ( pos - self:GetPos() ):Angle().y, 0 ) )
end

function ENT:OnTakeDamage( dmg )
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	owner:TakeDamageInfo( dmg )
end

function ENT:Draw()
	self:DrawModel()
end