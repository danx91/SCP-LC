AddCSLuaFile()

ENT.Type = "anim"

ENT.EHealth = 2000
ENT.Locked = NULL

function ENT:SetupDataTables()
	self:AddNetworkVar( "Active", "Bool" )
end

function ENT:Initialize()
	self:SetModel( "models/player/alski/scp3199/egg.mdl" )
	
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )

		local p = GetRoundProperty( "3199_eggs" )

		if !p then
			p = {}
			SetRoundProperty( "3199_eggs", p )
		end

		table.insert( p, self )
	end

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
end

ENT.NRegen = 0
function ENT:Think()
	if SERVER and self.EHealth < 2000 then
		if self.NRegen < CurTime() then
			self.NRegen = CurTime() + 0.5

			self.EHealth = self.EHealth + 20

			if self.EHealth > 2000 then
				self.EHealth = 2000
			end
		end
	end
end

function ENT:OnTakeDamage( dmg )
	local att = dmg:GetAttacker()
	if !IsValid( self.Locked ) or !self.Locked:CheckSignature( self.LockedSignature ) then
		if IsValid( att ) and att:IsPlayer() then
			local t = att:SCPTeam()
			if t != TEAM_SPEC and t != TEAM_SCP then
				self.EHealth = self.EHealth - dmg:GetDamage()
				self.NRegen = CurTime() + 1

				if self.EHealth <= 0 then
					att:AddFrags( 5 )
					PlayerMessage( "destory_scp$5", att )
					self:Destroy()
				end
			end
		end
	end
end

function ENT:Destroy()
	--create effects
	self:Remove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:NotActive()
	return !self:GetActive() and ( !IsValid( self.Locked ) or !self.Locked:CheckSignature( self.LockedSignature ) )
end

if SERVER then
	function SpawnSCP3199Eggs( num )
		num = num or 3

		local tab = GetRoundProperty( "3199_spawns" )

		if !tab then
			tab = table.Copy( EGGS_3199 )
			SetRoundProperty( "3199_spawns", tab )
		end

		local spawned = 0
		while #tab > 0 and spawned < num do
			local egg = ents.Create( "slc_3199_egg" )

			if IsValid( egg ) then
				egg:SetPos( table.remove( tab, math.random( #tab ) ) )
				egg:Spawn()

				DestroyOnWarhead( egg, false, true )

				spawned = spawned + 1
			end
		end
	end
end

if CLIENT then
	local color_green = Color( 30, 130, 30, 120 )
	local color_red = Color( 130, 30, 30, 120 )

	hook.Add( "PostDrawOpaqueRenderables", "SCP3199DrawEggs", function()
		local ply = LocalPlayer()
		if ply:SCPClass() == CLASSES.SCP3199 then
			render.ClearStencil()

			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )

			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilFailOperation( STENCIL_REPLACE )
			render.SetStencilZFailOperation( STENCIL_KEEP )

			render.SetStencilEnable( true )

			for k, v in pairs( ents.FindByClass( "slc_3199_egg" ) ) do
				render.SetStencilReferenceValue( v:GetActive() and 2 or 1 )

				v:DrawModel()
			end

			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilCompareFunction( STENCIL_EQUAL )

			cam.Start2D()
				render.SetStencilReferenceValue( 1 )
				surface.SetDrawColor( color_red )
				surface.DrawRect( 0, 0, ScrW(), ScrH() )

				render.SetStencilReferenceValue( 2 )
				surface.SetDrawColor( color_green )
				surface.DrawRect( 0, 0, ScrW(), ScrH() )
			cam.End2D()

			render.SetStencilEnable( false )
		end
	end )
end

function ENT:Draw()
	self:DrawModel()
end