AddCSLuaFile()

ENT.Type = "anim"
ENT.Used = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Vest" )
end

function ENT:Initialize()
	self:SetModel( "models/items/vest.mdl" )

	self:SetMoveType( MOVETYPE_NONE )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end

	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
end

function ENT:Use( activator, caller, type, value )
	if self.Used then return end

	if activator:IsPlayer() then
		local vest = activator:GetVest()
		if vest == 0 then
			if activator:EquipVest( self:GetVest() ) then
				self.Used = true
				self:Remove()
			end
		else
			PlayerMessage( "hasvest", activator )
		end
	end
end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector( 0, 0, 15 )
	if pos:DistToSqr( LocalPlayer():GetPos() ) < 22500 then
		local scr = pos:ToScreen()
		if scr.visible then
			local id = self:GetVest()
			local name = "Invalid!"

			if id > 0 then
				local tmp = VEST.getName( self:GetVest() )
				if tmp then
					name = LANG.VEST[tmp] or tmp
				end
			end

			cam.Start2D()
				draw.Text{
					text = name,
					pos = { scr.x, scr.y },
					font = "SCPHUDMedium",
					color = Color( 255, 255, 255, 255 ),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			cam.End2D()
		end
	end
end