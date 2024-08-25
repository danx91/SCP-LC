AddCSLuaFile()

ENT.Base = "slc_path_follower"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.HP = 500

function ENT:SetupDataTables()
	self:AddNetworkVar( "InvisRadius", "Int" )
end

function ENT:Initialize()
	self:CallBaseClass( "Initialize" )

	self:SetModel( "models/Novux/023/Novux_SCP-023.mdl" )

	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_BBOX )
	end

	self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

	self:SetAutomaticFrameAdvance( true )

	self:SetPoseParameter( "move_x", 1 )
	self:SetPoseParameter( "move_y", 1 )

	self:SetRenderMode( RENDERMODE_TRANSCOLOR )

	if SERVER then
		self:SetMaxHealth( self.HP )
	end

	self:SetHealth( self.HP )
end

ENT.NextPassive = 0

function ENT:Think()
	if CLIENT then return end

	self:CallBaseClass( "Think" )

	local owner = self:GetOwner()
	if !IsValid( owner ) or !owner:CheckSignature( self.OwnerSignature ) then
		self:Remove()
		return
	end

	local wep = owner:GetSCPWeapon()
	if !IsValid( wep ) then
		self:Remove()
		return
	end

	local ct = CurTime()
	local pos = self:GetPos()

	if self.NextPassive <= ct and wep:GetPassiveCooldown() < ct then
		self.NextPassive = ct + 0.25

		local burn_dmg = wep.PassiveDamage * wep:GetUpgradeMod( "burn_power", 1 )
		for i, v in ipairs( player.GetAll() ) do
			if !wep:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > wep.PassiveRadius or v:IsBurning() then continue end

			v:Burn( 1.5, 0, owner, burn_dmg )
		end

		local invis_radius = wep:GetInvisRadius()
		invis_radius = invis_radius * invis_radius

		local closest_dist = math.huge
		local closest_prey

		for i, v in ipairs( player.GetAll() ) do
			local dist = v:GetPos():DistToSqr( pos )
			if invis_radius > 0 and dist > invis_radius or !wep:CanTargetPlayer( v ) or !self:TestVisibility( v ) then continue end

			if dist < closest_dist then
				closest_dist = dist
				closest_prey = v
			end

			if !wep.Preys[v] then
				wep:AddPrey( v )
			end
		end

		if closest_prey then
			self.ClosestPrey = closest_prey
		end

		wep:CheckPreys()
	end

	return true
end

function ENT:OnTakeDamage( dmg )
	local attacker = dmg:GetAttacker()
	if !IsValid( attacker ) or !attacker:IsPlayer() or SCPTeams.IsAlly( attacker:SCPTeam(), TEAM_SCP ) then return end

	local hp = self:Health() - dmg:GetDamage()
	self:SetHealth( hp )

	if hp <= 0 then
		self:Remove()

		attacker:AddFrags( 5 )
		PlayerMessage( "destory_scp$5", attacker )
	end
end

function ENT:SelectRandomSpot()
	local navs = navmesh.Find( self:GetPos(), 2000, 256, 256 )
	local nav = navs[math.random( #navs )]
	if !nav then return end

	return nav:GetCenter()
end

function ENT:Behaviour()
	self:SetSpeed( 140 )
	self:SetCutCornerRadius( 64 )

	coroutine.wait( 2 )

	while true do
		self:ResetSequence( self:SelectWeightedSequence( ACT_HL2MP_RUN_FIST ) )
		self:SetPlaybackRate( 2 )

		if IsValid( self.ClosestPrey ) and self.ClosestPrey:GetPos():DistToSqr( self:GetPos() ) <= 9000000 then
			self:Follow( self.ClosestPrey )
			self.ClosestPrey = nil
		else
			local pos = self:SelectRandomSpot()
			if pos then
				self:MoveTo( pos )
			end
		end

		self:ResetSequence( self:SelectWeightedSequence( ACT_HL2MP_IDLE_FIST ) )

		if !IsValid( self.ClosestPrey ) then
			local wait_time = CurTime() + 2
			while wait_time > CurTime() and !IsValid( self.ClosestPrey ) do
				coroutine.yield()
			end
		end
	end
end

function ENT:OnMove()
	if self.Mode == "Simple" and IsValid( self.ClosestPrey ) and self.ClosestPrey:GetPos():DistToSqr( self:GetPos() ) <= 9000000 then
		return "switch to follow"
	elseif self.Mode == "Follow" then
		local pos = self:GetPos()
		if self.Target:GetPos():DistToSqr( pos ) > 9000000 then
			return "target lost"
		elseif self.Target != self.ClosestPrey and self.Target:GetPos():DistToSqr( pos ) > self.ClosestPrey:GetPos():DistToSqr( pos ) then
			return "switch_tragets"
		end
	end
end

function ENT:DrawTranslucent()
	local lp = LocalPlayer()
	local invis_dist = self:GetInvisRadius()

	if lp:SCPTeam() != TEAM_SCP and invis_dist > 0 then
		local dist = lp:GetPos():Distance( self:GetPos() )
		if dist >= invis_dist then return end

		local a = ( invis_dist - dist ) / 200
		if a > 1 then a = 1 end

		self:SetColor( Color( 255, 255, 255, 146 + 109 * a ) )
	end

	self:DrawModel()
end