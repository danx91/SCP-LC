SWEP.DeepBase 				= "item_slc_base"

SWEP.PrintName 				= "base_weapon"
SWEP.Author 				= "danx91"
//SWEP.Language 			= nil

SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.ViewModelFOV			= 60
SWEP.HoldType 				= "normal"
SWEP.DrawCrosshair 			= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

SWEP.WorldModel 			= ""
SWEP.ViewModel 				= ""

SWEP.SCP 					= false
SWEP.Droppable				= true

SWEP.ShouldDrawViewModel 	= true
SWEP.ShouldDrawWorldModel 	= true

SWEP.Lang 					= {}

SWEP.Toggleable 			= false
SWEP.HasBattery 			= false

function SWEP:SetupDataTables()
	if self.Toggleable then self:AddNetworkVar( "Enabled", "Bool" ) end
	if self.HasBattery then self:AddNetworkVar( "Battery", "Int" ) end
end

function SWEP:InitializeLanguage()
	if CLIENT and self.Language then
		self.Lang = LANG.WEAPONS[self.Language] or {}

		if self.Lang then
			self.PrintName = self.Lang.name or self.PrintName
			self.ShowName = self.Lang.showname
			self.Author	= self.Lang.author
			self.Info = self.Lang.info
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Deploy()
	if IsValid( self.Owner ) then
		self.Owner:DrawViewModel( self.ShouldDrawViewModel )

		if SERVER then
			self.Owner:DrawWorldModel( self.ShouldDrawWorldModel )
		end
	end
end

function SWEP:Holster( wep )
	return true
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end