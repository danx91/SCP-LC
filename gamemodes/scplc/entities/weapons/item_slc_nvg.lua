SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "NVG"

SWEP.WorldModel		= "models/mishka/models/nvg.mdl"

SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.HasBattery 	= true
SWEP.BatteryUsage 	= 0.6

SWEP.scp914upgrade = "item_slc_nvgplus"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	self:CallBaseClass( "Think" )

	local wep = self.Owner:GetWeapon( "item_slc_nvgplus" )

	if IsValid( wep ) and wep:GetEnabled() and self:GetBattery() > 0 then
		wep:SetEnabled( false )
	end
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
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