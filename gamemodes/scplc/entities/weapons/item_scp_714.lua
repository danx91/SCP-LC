SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "SCP714"

SWEP.WorldModel		= "models/mishka/models/scp714.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Toggleable = true
SWEP.Selectable = false
SWEP.EnableHolsterThink = true

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

SWEP.NThink = 0
function SWEP:HolsterThink()
	if self.NThink < CurTime() and self:GetEnabled() then
		self.NThink = CurTime() + 5

		if SERVER then
			local owner = self:GetOwner()
			if IsValid( owner ) then
				owner:TakeSanity( -1, SANITY_TYPE.ANOMALY, "scp714" )
			end
		end
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
	if CLIENT then return end

	if enabled then
		ply:SetStaminaLimit( 51 )
	else
		ply:SetStaminaLimit( ply.ClassData and ply.ClassData.stamina or 100 )
	end
end

if SERVER then
	local func = function( ply, arg1, arg2, data )
		if data != "scp714" then
			local scp = ply:GetWeapon( "item_scp_714" )

			if IsValid( scp ) and scp:GetEnabled() then
				return true
			end
		end
	end

	hook.Add( "SLCCalcSanity", "SLCSCP714Sanity", func )
	hook.Add( "SLCPlayerSanityChange", "SLCSCP714Sanity", func )
end

--[[-------------------------------------------------------------------------
Player binding
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:GetSCP714()
	local scp = self:GetWeapon( "item_scp_714" )
	if IsValid( scp ) then
		return scp:GetEnabled()
	end

	return false
end