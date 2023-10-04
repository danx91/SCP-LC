SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "GASMASK"

SWEP.WorldModel		= "models/mishka/models/gasmask.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/gas_mask.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.Toggleable = true
SWEP.Selectable = false

SWEP.Durability = 150

SWEP.Group 		= "gasmask"

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Upgraded", "Bool" )
end

function SWEP:HandleUpgrade( mode, num_mode, pos )
	self:SetPos( pos )
	
	if mode == UPGRADE_MODE.VERY_FINE then
		if math.random( 100 ) <= 33 then
			self:SetUpgraded( true )
			self:SetDurability( self.Durability )
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

/*function SWEP:OwnerChanged()
	self:SetEnabled( false )
end*/

function SWEP:OnSelect()
	if self:GetDurability() <= 0 then return end
	self:SetEnabled( !self:GetEnabled() )
end

function SWEP:Damage( dmg )
	if self.NDamage and self.NDamage > CurTime() then return end
	self.NDamage = CurTime() + 0.05

	self:CallBaseClass( "Damage", nil, dmg )
end

if CLIENT then
	local overlay = GetMaterial( "slc/misc/gasmask.png" )
	hook.Add( "SLCScreenMod", "GasMask", function( clr )
		local ply = LocalPlayer()
		local wep

		for k, v in pairs( ply:GetWeapons() ) do
			if v:IsDerived( "item_slc_gasmask" ) then
				wep = v
				break
			end
		end

		if IsValid( wep ) and wep:GetEnabled() then
			render.SetMaterial( overlay )
			render.DrawScreenQuad()
		end
	end )
end