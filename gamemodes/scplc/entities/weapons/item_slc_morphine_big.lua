SWEP.Base 				= "item_slc_morphine"
SWEP.Language			= "MORPHINE_BIG"

SWEP.InjectSpeed		= 1.1
SWEP.SelfInjectSpeed	= 1
SWEP.ExtraHealth		= 75

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/morphine.png" )
	SWEP.SelectColor = Color( 0, 123, 255, 255 )
end

function SWEP:HandleUpgrade( mode, num_mode, exit, ply )
	if num_mode < 2 then
		self:Remove()
	elseif num_mode == 2 then
		local new = ents.Create( "item_slc_adrenaline_big" )
		if IsValid( new ) then
			self:Remove()
			new:SetPos( exit )
			new:Spawn()
		end
	else
		self:SetPos( exit )
	end
end