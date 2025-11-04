AddCSLuaFile()

ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "BlockerID" )
end

function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate05x05.mdl" )
	self:DrawShadow( false )
	self:SetNoDraw( true )

	self.TeamFilter = {}
	self.ClassFilter = {}
	self.PlayerFilter = {}
	self.RoundFilter = {}
	self.CustomChecks = {}
	self.UseCustomChecks = false

	local data = BLOCKERS[self:GetBlockerID()]
	if !data then return end

	if SERVER then
		/*self:PhysicsInitConvex( {
			Vector( data.bounds[1].x, data.bounds[1].y, data.bounds[1].z ),
			Vector( data.bounds[1].x, data.bounds[1].y, data.bounds[2].z ),
			Vector( data.bounds[1].x, data.bounds[2].y, data.bounds[1].z ),
			Vector( data.bounds[1].x, data.bounds[2].y, data.bounds[2].z ),
			Vector( data.bounds[2].x, data.bounds[1].y, data.bounds[1].z ),
			Vector( data.bounds[2].x, data.bounds[1].y, data.bounds[2].z ),
			Vector( data.bounds[2].x, data.bounds[2].y, data.bounds[1].z ),
			Vector( data.bounds[2].x, data.bounds[2].y, data.bounds[2].z ),
		}, "gmod_silent" )

		self:SetSolid( SOLID_VPHYSICS )*/

		self:PhysicsInit( SOLID_BBOX )
		self:SetMoveType( MOVETYPE_NONE )
	end

	self:SetCollisionGroup( COLLISION_GROUP_PLAYER_MOVEMENT )
	self:SetCustomCollisionCheck( true )
	self:EnableCustomCollisions()

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:SetMaterial( "gmod_silent" )
	end

	self.Initialized = true

	self:SetPos( data.pos )
	self:SetCollisionBounds( data.bounds[1], data.bounds[2] )

	self:CollisionRulesChanged()

	local filter = data.filter
	if !filter then return end

	self:EnableBlacklistMode( filter.mode == BLOCKER_BLACKLIST )
	self:AllowUse( filter.allow_use )

	--teams
	if filter.teams then
		for i = 1, #filter.teams do
			local team = filter.teams[i]
			if team then
				self:AddTeamToFilter( team )
			end
		end
	end

	--classes
	if filter.classes then
		for i = 1, #filter.classes do
			local class = CLASSES[filter.classes[i]]
			if class then
				self:AddClassToFilter( class )
			end
		end
	end

	--group
	if filter.group then
		self:LoadFilterGroup( filter.group )
	end

	--custom check
	if filter.custom_check then
		self:AddCustomCheckToFilter( filter.custom_check )
	end

	if filter.round then
		self.RoundFilter = {
			preparing = !!filter.round.preparing,
			post = !!filter.round.post,
		}
	end
end

function ENT:AddTeamToFilter( team )
	self.TeamFilter[team] = true
end

function ENT:AddClassToFilter( class )
	self.ClassFilter[class] = true
end

function ENT:AddPlayerToFilter( ply )
	self.PlayerFilter[ply] = true
end

function ENT:AddCustomCheckToFilter( fn )
	table.insert( self.CustomChecks, fn )
	self.UseCustomChecks = true
end

function ENT:LoadFilterGroup( group )
	local data = GetFilterGroupData( group )
	if data then
		for t, _ in pairs( data.teams ) do
			self:AddTeamToFilter( t )
		end

		for class, _ in pairs( data.classes ) do
			self:AddClassToFilter( class )
		end

		for ply, _ in pairs( data.players ) do
			self:AddPlayerToFilter( ply )
		end

		for _, fn in ipairs( data.custom ) do
			self:AddCustomCheckToFilter( fn )
		end

		if data.base then
			self:LoadFilterGroup( data.base )
		end
	end
end

function ENT:EnableBlacklistMode( enable )
	self.Blacklist = !!enable
end

function ENT:AllowUse( allow )
	self.UseAllowed = !!allow
end

function ENT:TestCollision( startpos, delta, isbox, extents, mask )
	if self.UseAllowed and mask == MASK_USE then return end
	if bit.band( mask, MASK_PLAYERSOLID ) != MASK_PLAYERSOLID then return end

	return {
		HitPos = startpos,
		Fraction = 0,
		Normal = -delta:GetNormalized()
	}
	//return true
end

hook.Add( "ShouldCollide", "SLCBlocker", function( ent1, ent2 )
	local blocker, other

	if ent1:GetClass() == "slc_blocker" then
		blocker = ent1
		other = ent2
	elseif ent2:GetClass() == "slc_blocker" then
		blocker = ent2
		other = ent1
	end

	if !blocker or !blocker.Initialized or !other:IsPlayer() then return end

	if blocker.UseCustomChecks then
		local all_nil = true

		for i, v in ipairs( blocker.CustomChecks ) do
			local result = v( other )

			if result == true and !blocker.Blacklist then return false end
			if result == false and blocker.Blacklist then return true end

			if result != nil then
				all_nil = false
			end
		end

		if !all_nil then
			return !blocker.Blacklist
		end
	end

	if blocker.RoundFilter.preparing and ROUND.preparing or blocker.RoundFilter.post and ROUND.post then return true end

	if blocker.PlayerFilter[other] or blocker.TeamFilter[other:SCPTeam()] or blocker.ClassFilter[other:SCPClass()] then
		return blocker.Blacklist
	else
		return !blocker.Blacklist
	end
end )