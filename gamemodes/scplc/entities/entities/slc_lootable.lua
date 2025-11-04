AddCSLuaFile()

ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", "ShouldRender" )
end

function ENT:Initialize()
	if CLIENT then return end

	if !self.Model then
		self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		self:DrawShadow( false )
		//self:SetNoDraw( true )

		if SERVER then
			self:PhysicsInit( SOLID_BBOX )
			self:SetMoveType( MOVETYPE_NONE )
			self:SetUseType( SIMPLE_USE )

			local phys = self:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableMotion( false )
			end
		end

		self:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	else
		self:SetModel( self.Model )

		if SERVER then
			self:PhysicsInit( SOLID_VPHYSICS )
			self:SetUseType( SIMPLE_USE )
			self:PhysWake()
		end
	end

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	if SERVER then
		self:InstallTable( "Lootable" )
	end
end

ENT.NCheck = 0
function ENT:Think()
	if CLIENT then return end

	local rt = RealTime()
	if self.NCheck <= rt then
		self.NCheck = rt + 1

		self:CheckListeners()

		if self.RemoveOnEmpty and !next( self.LootItems ) then
			self:DropAllListeners()
			self:Remove()
		end
	end
end

if CLIENT then
	local ind = Material( "sprites/light_ignorez" )
	local pick = Material( "slc/hud/pickup.png", "smooth" )

	function ENT:Draw()
		if self:GetShouldRender() then
			self:DrawModel()
		end

		local ply = LocalPlayer()
		if !ply:IsHuman() then return end

		local pos = self:GetPos()
		local diff = ply:EyePos() - pos
		local len = diff:LengthSqr()

		if len <= 160000 then
			if len >= 8100 and !GetSettingsValue( "search_indicator" ) then return end

			local ang = ( diff ):Angle()
			//ang.p = ang.p + 90
			ang:RotateAroundAxis( ang:Right(), -90 )
			ang:RotateAroundAxis( ang:Up(), 90 )

			cam.Start3D2D( pos, ang, 0.1 )
			cam.IgnoreZ( true )

			local a = math.TimedSinWave( 0.5, 0.66, 1 )
			surface.SetDrawColor( 225, 225, 255, a * 255 )

			if len < 8100 then
				surface.SetMaterial( pick )

				local bind = input.LookupBinding( "use" )
				draw.SimpleText( string.format( LANG.MISC.inventory.search, string.upper( bind or "+use" ) ), "SCPHUDMedium", 0, 32, Color( 255, 255, 255, a * 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			else
				surface.SetMaterial( ind )
			end

			surface.DrawTexturedRect( -32, -32, 64, 64 )

			cam.IgnoreZ( false )
			cam.End3D2D()
		end
	end

	hook.Add( "SLCRegisterSettings", "SLCSearchSettings", function()
		RegisterSettingsEntry( "search_indicator", "switch", true, nil, "hud_config" )
	end )
end