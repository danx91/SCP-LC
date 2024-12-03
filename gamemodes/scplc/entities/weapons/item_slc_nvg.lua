SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "NVG"

SWEP.WorldModel		= "models/mishka/models/nvg.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.HasBattery 	= true
SWEP.BatteryUsage 	= 0.6

SWEP.DrawCrosshair = false

SWEP.Group = "nvg"
SWEP.UseGroup = "vision"

SWEP.SCP914Upgrade = "item_slc_nvgplus"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	self:CallBaseClass( "Think" )
end

function SWEP:OnSelect()
	if !self:CanEnable() then return true end
end

if CLIENT then
	local overlay = Material( "effects/combine_binocoverlay" )
	hook.Add( "SLCScreenMod", "NVG", function( clr )
		local ply = LocalPlayer()
		local wep = ply:GetActiveWeapon()
		local wep2 = ply:GetWeapon( "item_slc_nvgplus" )

		if IsValid( wep ) and wep:GetClass() == "item_slc_nvg" and wep:GetBattery() > 0 or IsValid( wep2 ) and wep2:GetEnabled() then
			render.SetMaterial( overlay )
			render.DrawScreenQuad()

			DrawBloom( 0.2, 5, 7, 7, 3, 1, 1, 1, 1 )

			clr.colour = 0.5
			clr.brightness = clr.brightness
			clr.contrast = clr.contrast + 2
			clr.add_g = -0.01
			clr.add_r = -0.1
			clr.add_b = -0.1
			clr.mul_g = 2
		end
	end )
end