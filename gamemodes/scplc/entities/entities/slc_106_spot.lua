AddCSLuaFile()

ENT.Type 		= "anim"
ENT.SCPIgnore	= true

function ENT:Initialize()
	self:SetModel( "models/slc/scp106_teleport/portal_floor.mdl" )
	
	if CLIENT then return end

	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	local outside = SLCZones.IsInZone( self:GetPos(), ZONE_FLAG_SURFACE )
	DestroyOnWarhead( self, outside, !outside )
end

/*function ENT:Think()
	if CLIENT then return end

	local owner = self:GetOwner()
	if !IsValid( owner ) or owner:SCPClass() != CLASSES.SCP106 then
		self:Remove()
		return
	end
end*/

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Draw()
	self:DrawModel()
end

if CLIENT then
	local selected_mat = Material( "slc/hud/scp/106/spot_selected.png", "smooth ignorez" )
	local color_main = Color( 120, 120, 120, 120 )
	local color_selected = Color( 255, 25, 25, 120 )

	SCPHook( "SCP106", "PostDrawTranslucentRenderables", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP106 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetClass() != "weapon_scp_106" then return end

		local alpha = 1

		if !GetSettingsValue( "scp106_spots" ) then
			alpha = ( wep.ShowSpots - CurTime() ) / wep.SpotDrawDuration
			if alpha <= 0 then return end
		end

		local len = 0
		local spots = {}

		for i, v in ipairs( ents.GetAll() ) do
			if v:GetClass() == "slc_106_spot" and v:GetOwner() == ply and v != wep.LastCurrentSpot then
				len = len + 1
				spots[len] = v
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
			render.SetStencilReferenceValue( wep.SelectedSpot == spots[i] and 2 or 1 )
			spots[i]:DrawModel()
		end

		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilCompareFunction( STENCIL_EQUAL )

		cam.Start2D()
			color_main.a = 120 * alpha
			color_selected.a = 120 * alpha

			render.SetStencilReferenceValue( 1 )
			surface.SetDrawColor( color_main )
			surface.DrawRect( 0, 0, ScrW(), ScrH() )

			render.SetStencilReferenceValue( 2 )
			surface.SetDrawColor( color_selected )
			surface.DrawRect( 0, 0, ScrW(), ScrH() )
		cam.End2D()
			
		render.SetStencilEnable( false )

		if !wep.SelectedSpot then return end

		local pos = wep.SelectedSpot:GetPos()
		local ang = ( ply:EyePos() - pos ):Angle()
		ang.p = 0
		ang.r = 0

		local right = -ang:Right()
		local cam_ang = right:AngleEx( right:Cross( ang:Up() ) )

		cam.Start3D2D( pos, cam_ang, 0.4 )
		cam.IgnoreZ( true )
			surface.SetDrawColor( color_selected )
			surface.SetMaterial( selected_mat )
			surface.DrawTexturedRect( -128, -64 - 320, 256, 128 )
		cam.IgnoreZ( false )
		cam.End3D2D()
	end )

	hook.Add( "SLCRegisterSettings", "SCP106Spot", function()
		RegisterSettingsEntry( "scp106_spots", "switch", false, nil, "scp_config" )
	end )
end