AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Model = "models/hunter/plates/plate025x025.mdl"

function ENT:SetupDataTables()
	self:AddNetworkVar( "Text", "String" )
end

function ENT:Initialize()
	self:SetModel( self.Model )
end

function ENT:Time( time )
	timer.Simple( time, function()
		if IsValid( self ) then
			self:Remove()
		end
	end )
end

local white = Color( 255, 255, 255 )
function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()

	local ang = Angle( 0, 0, 90 )
	ang.y = ( LocalPlayer():GetPos() - pos ):Angle().y + 90


	cam.Start3D2D( pos + Vector( 0, 0, 16 ), ang, 0.1 )
		draw.SimpleText( self:GetText(), "SCPHUDVBig", 0, 0, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end
