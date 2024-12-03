SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "RADIO"

SWEP.WorldModel		= "models/mishka/models/radio.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.DrawCrosshair = false

SWEP.Toggleable 	= true
SWEP.EnableHolsterThink	= true
SWEP.HasBattery 	= true
SWEP.HolsterBatteryUsage = true
SWEP.BatteryUsage 	= 6

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/radio.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Channel", "Int" )

	self:SetChannel( 1 )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
	self:SetSkin( 1 )
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	if self:GetBattery() <= 0 then return end

	local enabled = !self:GetEnabled()
	self:SetEnabled( enabled )

	if enabled then
		self:EmitSound( "Radio.Beep" )
	end
end

function SWEP:SecondaryAttack()
	if !self:GetEnabled() then return end
	self:SetNextSecondaryFire( CurTime() + 0.25 )

	local ch = self:GetChannel() + 1

	if ch > 5 then
		ch = 1
	end

	self:SetChannel( ch )
end

local color_black = Color( 0, 0, 0, 255 )
local radio = Material( "slc/misc/radioHUD.png", "smooth" )
function SWEP:DrawHUD()
	if hud_disabled then return end

	local w, h = ScrW(), ScrH()

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( radio )
	surface.DrawTexturedRect( w * 0.8, h - w * 0.353, w * 0.15, w * 0.353 )

	if !self:GetEnabled() then return end

	draw.Text{
		text = self:GetChannel(),
		pos = { w * 0.839, h - w * 0.09 },
		color = color_black,
		font = "SCPRadioHUD",
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_CENTER,
	}
end

hook.Add( "RebuildFonts", "RadioFont", function()
	surface.CreateFont( "SCPRadioHUD", {
		font = "DS-Digital",
		size = ScrW() * 0.04,
		antialias = true,
		weight = 500,
	} )
end )

sound.Add{
	name = "Radio.Beep",
	sound = "scp_lc/radio_beep.ogg",
	volume = 1,
	level = 60,
	pitch = 100,
	channel = CHAN_STATIC,
}