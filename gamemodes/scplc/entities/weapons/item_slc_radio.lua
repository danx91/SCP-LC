SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "RADIO"

SWEP.WorldModel		= "models/mishka/models/radio.mdl"

SWEP.NextUse 		= 0

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.Toggleable 	= true

SWEP.SelectFont = "SCPHUDMedium"

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
	if self.NextUse > CurTime() then return end
	self.NextUse = CurTime() + 0.25

	local enabled = !self:GetEnabled()
	self:SetEnabled( enabled )

	if enabled then
		self:EmitSound( "Radio.Beep" )
	end
end

function SWEP:SecondaryAttack()
	if !self:GetEnabled() then return end
	if self.NextUse > CurTime() then return end
	self.NextUse = CurTime() + 0.25

	local ch = self:GetChannel() + 1

	if ch > 5 then
		ch = 1
	end

	self:SetChannel( ch )
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

local radio = Material( "slc/radioHUD.png" )
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
		color = Color( 0, 0, 0, 255 ),
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
	sound = "radio_beep.ogg",
	volume = 1,
	level = 60,
	pitch = 100,
	channel = CHAN_STATIC,
}