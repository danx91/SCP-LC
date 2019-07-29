SWEP.Base 				= "weapon_scp_base"
SWEP.PrintName			= "SCP-049"

SWEP.HoldType 			= "normal"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP049" )
end

function SWEP:PrimaryAttack()
	
end

function SWEP:DrawHUD()
	if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	
end

addSounds( "SCP049.Attack", "scp/049/attack%i.ogg", 120, 1, 100, CHAN_STATIC, 0, 4 )