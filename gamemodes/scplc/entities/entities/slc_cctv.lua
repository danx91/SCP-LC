AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel( "models/slc/cctv/cctvcamera.mdl" )

	//self:SetModelScale( 100 )

	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
	end

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	//self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:OnTakeDamage( dmginfo )
	self:Remove()

	local data = EffectData()

	data:SetOrigin( self:GetPos() )

	util.Effect( "cball_explode", data, true, true )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetCam( num )
	self:SetNWInt( "cam", num )
end

function ENT:GetCam()
	return self:GetNWInt( "cam", 0 )
end

function ENT:Draw()
	self:DrawModel()
end

hook.Add( "SetupPlayerVisibility", "CCTVPVS", function( ply, viewentity )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and wep:GetClass() == "item_slc_camera" then
		if wep:GetEnabled() and IsValid( CCTV[wep:GetCAM()].ent ) then
			AddOriginToPVS( CCTV[wep:GetCAM()].pos )
		end
	end
end )