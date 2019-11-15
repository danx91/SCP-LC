SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "GASMASK"

SWEP.WorldModel		= "models/mishka/models/gasmask.mdl"

SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Toggleable = true
SWEP.Selectable = false

SWEP.Group 		= "gasmask"

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Upgraded", "Bool" )
end

function SWEP:scp914upgrade( mode )
	if mode == 4 then
		if math.random( 100 ) <= 25 then
			self:SetUpgraded( true )
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetSkin( 2 )
	self:InitializeLanguage()
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

function SWEP:OwnerChanged()
	self:SetEnabled( false )
end

function SWEP:OnSelect()
	self:SetEnabled( !self:GetEnabled() )
end

if CLIENT then
	local overlay = GetMaterial( "slc/gasmask.png" )
	hook.Add( "SLCScreenMod", "GasMask", function( clr )
		local ply = LocalPlayer()
		local wep = ply:GetWeapon( "item_slc_gasmask" )

		if IsValid( wep ) and wep:GetEnabled() then
			render.SetMaterial( overlay )
			render.DrawScreenQuad()
		end
	end )
end