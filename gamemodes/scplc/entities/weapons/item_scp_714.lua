SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "SCP714"

SWEP.WorldModel		= "models/mishka/models/scp714.mdl"

SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Toggleable = true
SWEP.Selectable = false

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

SWEP.NThink = 0
function SWEP:Think()
	if self.NThink < CurTime() and self:GetEnabled() then
		self.NThink = CurTime() + 3

		local owner = self:GetOwner()
		if IsValid( owner ) then
			owner:TakeSanity( -1, SANITY_TYPE.ANOMALY )
		end
	end
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

function SWEP:OnDrop()
	self:SetEnabled( false )

	if IsValid( self.LastOwner ) then
		self:StateChanged( self.LastOwner, false )
	end
end

function SWEP:OnSelect()
	local enabled = !self:GetEnabled()
	self:SetEnabled( enabled )

	local owner = self:GetOwner()
	self.LastOwner = owner

	self:StateChanged( owner, enabled )
end

function SWEP:StateChanged( ply, enabled )
	ply:SetSCP714( enabled )

	if enabled then
		ply:SetStaminaLimit( 20 )
	else
		ply:SetStaminaLimit( 100 )
	end
end

if SERVER then
	local func = function( ply )
		local scp = ply:GetWeapon( "item_scp_714" )

		if IsValid( scp ) and scp:GetEnabled() then
			return true
		end
	end

	hook.Add( "SLCCalcSanity", "SLCSCP714Sanity", func )
	hook.Add( "SLCPlayerSanityChange", "SLCSCP714Sanity", func )
end