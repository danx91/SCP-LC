AddCSLuaFile()

ENT.Type = "anim"

ENT.SpawnRegen = false
ENT.NextRegen = 0
ENT.Locked = NULL

function ENT:Initialize()
	self:SetModel( "models/player/alski/scp3199/egg.mdl" )
	
	if SERVER then
		self:SetMaxHealth( 2500 )
		self:SetHealth( 1 )

		self:PhysicsInit( SOLID_VPHYSICS )

		local outside = SLCZones.IsInZone( self:GetPos(), ZONE_FLAG_SURFACE )
		DestroyOnWarhead( self, outside, !outside )
	end

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
end

function ENT:Think()
	if CLIENT or self.NextRegen > CurTime() then return end

	local health = self:Health()
	if health >= 2500 then return end

	self.NextRegen = CurTime() + ( self.SpawnRegen and 1 or 0.1 )

	health = health + 20

	if health >= 2500 then
		health = 2500
		self.SpawnRegen = false
	end

	self:SetHealth( health )
end

function ENT:OnTakeDamage( dmg )
	if IsValid( self.Locked ) and self.Locked:CheckSignature( self.LockedSignature ) then return end

	local att = dmg:GetAttacker()
	if !IsValid( att ) or !att:IsPlayer() or SCPTeams.IsAlly( att:SCPTeam(), TEAM_SCP ) then return end

	local health = self:Health() - dmg:GetDamage()
	self:SetHealth( health )

	self.NextRegen = CurTime() + 1

	if health <= 0 then
		att:AddFrags( 5 )
		PlayerMessage( "destory_scp$5", att )

		self:Destroy()
	end
end

function ENT:Destroy()
	self:Remove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

if SERVER then
	function SpawnSCP3199Egg( owner )
		local tab = GetRoundProperty( "3199_spawns" )

		if !tab then
			tab = table.Copy( EGGS_3199 )
			SetRoundProperty( "3199_spawns", tab )
		end

		local egg = ents.Create( "slc_3199_egg" )
		if IsValid( egg ) then
			egg:SetPos( table.remove( tab, math.random( #tab ) ) )
			egg:SetOwner( owner )
			egg:Spawn()
		end
		
		return egg
	end
end

if CLIENT then
	local color_green = Color( 30, 130, 30, 120 )

	SCPHook( "SCP3199", "PostDrawOpaqueRenderables", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP3199 then return end

		local len = 0
		local eggs = {}

		for i, v in ipairs( ents.GetAll() ) do
			if v:GetClass() == "slc_3199_egg" and v:GetOwner() == ply then
				len = len + 1
				eggs[len] = v
			end
		end

		render.ClearStencil()

		render.SetStencilReferenceValue( 1 )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_REPLACE )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilEnable( true )

		for i = 1, len do
			eggs[i]:DrawModel()
		end

		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilCompareFunction( STENCIL_EQUAL )

		cam.Start2D()
			surface.SetDrawColor( color_green )
			surface.DrawRect( 0, 0, ScrW(), ScrH() )
		cam.End2D()

		render.SetStencilEnable( false )

		for i = 1, len do
			eggs[i]:DrawModel()
		end
	end )
end

function ENT:Draw()
	self:DrawModel()
end