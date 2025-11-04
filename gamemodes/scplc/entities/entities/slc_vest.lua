AddCSLuaFile()

ENT.Type = "anim"
ENT.Used = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "Vest" )
	self:NetworkVar( "Float", "Durability" )
end

function ENT:Initialize()
	if SERVER then
		local data = VEST.GetData( self:GetVest() )
		self:SetModel( data and data.prop_model or "models/items/vest.mdl" )
	end

	if SERVER then
		self:SetUseType( SIMPLE_USE )
		self:PhysicsInit( SOLID_BBOX )
	end

	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	self:EnableCustomCollisions()
end

function ENT:Use( activator, caller, type, value )
	if self.Used then return end

	if activator:IsPlayer() then
		local vest = activator:GetVest()
		if vest == 0 then
			if activator:EquipVest( self:GetVest(), false, self:GetDurability() ) then
				self.Used = true
				self:Remove()
			end
		else
			PlayerMessage( "hasvest", activator )
		end
	end
end

local color_white = Color( 255, 255, 255 )
function ENT:Draw()
	self:DrawModel()

	local ply = LocalPlayer()
	local pos = self:GetPos() + Vector( 0, 0, 20 )
	if pos:DistToSqr( ply:GetPos() ) < 22500 then
		local tr = util.TraceLine{
			start = ply:EyePos(),
			endpos = pos,
			mask = MASK_SOLID_BRUSHONLY,
			filter = ply,
		}

		if tr.Hit then return end

		local scr = pos:ToScreen()
		if scr.visible then
			local id = self:GetVest()
			local name = "Invalid!"

			if id > 0 then
				local tmp = VEST.GetName( self:GetVest() )
				if tmp then
					name = LANG.VEST[tmp] or tmp
				end
			end

			cam.Start2D()
				local _, th = draw.Text{
					text = name,
					pos = { scr.x, scr.y },
					font = "SCPHUDMedium",
					color = color_white,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}

				local data = VEST.GetData( self:GetVest() )
				if data and data.durability and data.durability > 0 then
					draw.Text{
						text = LANG.durability..": "..math.ceil( self:GetDurability() / data.durability * 100 ).."%",
						pos = { scr.x, scr.y + th },
						font = "SCPHUDMedium",
						color = color_white,
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER,
					}
				end
			cam.End2D()
		end
	end
end

function ENT:TestCollision( start, delta, isbox, bounds, mask )
	return mask == MASK_USE
end