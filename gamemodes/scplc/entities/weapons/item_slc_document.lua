SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "DOCUMENT"

SWEP.WorldModel		= "models/slc/document_folder/folder.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.Selectable = false

SWEP.DrawCrosshair = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/document.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.IS_DOCUMENT = true
SWEP.Reward = 10

function SWEP:Initialize()
	if SERVER then return end

	self:InitializeLanguage()
	self.PrintName = self.Name and self.Lang.types[self.Name] or self.PrintName
end

function SWEP:OwnerChanged()
	if CLIENT then return end

	local new = self:GetOwner()
	if !IsValid( new ) then return end

	TransmitSound( "scp_lc/misc/document.ogg", true, new, 1 )
	PlayerMessage( "docs_pick", new )
end

if CLIENT then
	function SWEP:DrawHUD()
		if !self.Page then return end

		local w, h = ScrW(), ScrH()

		local dw = w * 0.3
		local dh = dw * self.Page:Height() / self.Page:Width()

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( self.Page )
		surface.DrawTexturedRect( w * 0.5 - dw * 0.5, h * 0.5 - dh * 0.5, dw, dh )
	end
end