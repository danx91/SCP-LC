SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "NVGPLUS"

SWEP.WorldModel		= "models/mishka/models/nvg.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Selectable 	= false
SWEP.Toggleable 	= true
SWEP.EnableHolsterThink	= true
SWEP.HasBattery 	= true
SWEP.HolsterBatteryUsage = true
SWEP.BatteryUsage 	= 0.1

SWEP.SCP914Upgrade = {
	[UPGRADE_MODE.ONE_ONE] = "item_slc_thermal"
}

SWEP.Group = "nvg"
SWEP.UseGroup = "vision"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:OnSelect()
	if self:GetBattery() <= 0 or !self:CanEnable() then return end
	self:SetEnabled( !self:GetEnabled() )
end