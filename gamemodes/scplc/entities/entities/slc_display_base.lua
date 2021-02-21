AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = ""

/*function ENT:SetupDataTables()
end*/

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetModel( self.Model )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetUseType( SIMPLE_USE )

		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

function ENT:Think()

end

ENT.NUse = 0
function ENT:Use( activator, caller, type, value )
	if self.Usable then
		local ct = CurTime()

		if self.NUse <= ct then
			self.NUse = ct + self.Delay

			self:OnUse( activator )
		end
	end
end

function ENT:OnUse( ply )

end

function ENT:SetUsable( usable, delay )
	self.Usable = usable
	self.Delay = delay or 0
end

if CLIENT then
	local TEX_WIDTH, TEX_HEIGHT = 512, 405

	function ENT:Draw()
		self:DrawModel()

		//debugoverlay.BoxAngles( self:GetPos(), Vector( -2.5, -37.5, -6 ), Vector( -0.5, 8, 24 ), self:GetAngles(), 0, Color( 255, 255, 255, 0 ) )
		//debugoverlay.Axis( self:GetPos() + Vector( -0.3, -35.8, 23 ), self:GetAngles(), 3, 0, false )
		//debugoverlay.Axis( self:GetPos() + Vector( -0.3, -1, -4.5 ), self:GetAngles(), 3, 0, false )

		local ang = self:GetAngles()
		local pos = self:GetPos()

		pos = pos + ang:Forward() * -0.3 + ang:Right() * 35.8 + ang:Up() * 23

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), 90 )

		cam.Start3D2D( pos, ang, 0.06797 )
			self:RenderScreen( TEX_WIDTH, TEX_HEIGHT )
		cam.End3D2D()
	end

	function ENT:RenderScreen( width, height )
		
	end
end