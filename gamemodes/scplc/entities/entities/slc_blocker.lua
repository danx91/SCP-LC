AddCSLuaFile()

ENT.Type = "anim"
//ENT.Blacklist = false

function ENT:SetupDataTables()
    self:AddNetworkVar( "BlockerID", "Int" )
end

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetModel( "models/hunter/plates/plate05x05.mdl" )
	self:SetNoDraw( true )

	if SERVER then
		self:PhysicsInit( SOLID_BBOX )
		self:SetMoveType( MOVETYPE_NONE )
	end

	self:SetCustomCollisionCheck( true )
    self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	//self:SetCollisionBounds( Vector( -25, -25, -25 ), Vector( 25, 25, 25 ) )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:SetMaterial( "gmod_silent" )
    end

    self.TeamFilter = {}
    self.ClassFilter = {}
    self.PlayerFilter = {}

    local data = BLOCKERS[self:GetBlockerID()]
    if data then
        self:SetPos( data.pos )
        self:SetCollisionBounds( data.bounds[1], data.bounds[2] )

        local filter = data.filter
        if filter then
            self:EnableBlacklistMode( filter.mode == BLOCKER_BLACKLIST )

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
        end
    end
end

/*function ENT:Think()
    local ms, mx = self:GetCollisionBounds()
    debugoverlay.BoxAngles( self:GetPos(), ms, mx, self:GetAngles(), 0.1, Color( 0, 255, 255, 1 ) )
end*/

function ENT:AddTeamToFilter( team )
    self.TeamFilter[team] = true
end

function ENT:AddClassToFilter( class )
    self.ClassFilter[class] = true
end

function ENT:AddPlayerToFilter( ply )
    self.PlayerFilter[ply] = true
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

        if data.base then
            self:LoadFilterGroup( data.base )
        end
    end
end

function ENT:EnableBlacklistMode( enable )
    self.Blacklist = !!enable
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

    if blocker and other:IsPlayer() then
        if blocker.PlayerFilter[other] or blocker.TeamFilter[other:SCPTeam()] or blocker.ClassFilter[other:SCPClass()] then
            return blocker.Blacklist
        else
            return !blocker.Blacklist
        end
    end
end )