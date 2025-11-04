if true then return end

SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-682"

SWEP.HoldType		= "normal"

SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage 	= true

SWEP.BasicCooldown = 2

/*
	Passive - 
	LMB - 
	RMB - 
	Reload - 
	Special - 
*/

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	//self:NetworkVar( "Bool", "Charging" )

end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP682" )
	self:InitializeHUD()

end


function SWEP:Think()
	
end

local attack_trace = {}
attack_trace.mins = Vector( -8, -8, -8 )
attack_trace.maxs = Vector( 8, 8, 8 )
attack_trace.mask = MASK_SHOT
attack_trace.output = attack_trace

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end

	
end

function SWEP:SecondaryAttack()
	
end

function SWEP:Reload()
	
end

function SWEP:SpecialAttack()
	
end

function SWEP:OnPlayerKilled( ply )
	//AddRoundStat( "682" )
end

function SWEP:OnUpgradeBought( name, active, group )
	
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP682") TransmitSCPHooks()
SCPHook( "SCP682", "EntityTakeDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or dmg:IsDamageType( DMG_FALL ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP682 then return end
	if ROUND.preparing and dmg:IsDamageType( DMG_ACID ) then return true end

	
end )

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.shield = GetMaterial( "slc/hud/upgrades/scp/682/shield.png", "smooth" )

end

DefineUpgradeSystem( "scp682", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "shield_a", cost = 3, req = {}, block = { "shield_b", "shield_c", "shield_d" }, reqany = false, pos = { 1, 1 },
			mod = { shield = 1.5, shield_cd = 1.25 }, icon = icons.shield_a, active = { icons.shield_a }, group = "shield" },
		

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 4, 4 }, mod = {}, active = false },
	},
	rewards = { --24 + 1 points -> 60% = 15 (-1 base) = 14 points
		{ 75, 1 },
		{ 150, 1 },

	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP682", SWEP )
	hud:AddCommonSkills()

	/*hud:AddSkill( "primary" )
		:SetButton( "attack" )
		:SetMaterial( "slc/hud/scp/682/attack.png", "smooth" )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "secondary" )
		:SetButton( "attack2" )
		:SetMaterial( "slc/hud/scp/682/bite.png", "smooth" )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	hud:AddSkill( "charge" )
		:SetButton( "scp_special" )
		:SetMaterial( "slc/hud/scp/682/charge.png", "smooth" )
		:SetCooldownFunction( "GetNextSpecialAttack" )
		:SetActiveFunction( function( swep )
			return swep:HasUpgrade( "charge_1" )
		end )

	hud:AddSkill( "shield" )
		:SetOffset( 0.5 )
		:SetMaterial( "slc/hud/scp/682/shield.png", "smooth" )
		:SetCooldownFunction( "GetShieldCooldown" )

	hud:AddBar( "shield_bar" )
		:SetMaterial( "slc/hud/scp/682/shield.png", "smooth" )
		:SetColor( Color( 26, 147, 195 ) )
		:SetTextFunction( "GetShield" )
		:SetProgressFunction( function( swep )
			local max_shield

			if swep:HasUpgrade( "shield_c" ) then
				max_shield = swep:GetOwner():GetMaxHealth()
			else
				max_shield = swep.DefaultShield * swep:GetUpgradeMod( "shield", 1 )
			end

			return swep:GetShield() / max_shield
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetShield() > 0
		end )*/
end

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
/*sound.Add( {
	name = "SCP682.Roar",
	volume = 1,
	level = 90,
	pitch = { 90, 110 },
	sound = "scp_lc/scp/682/roar.ogg",
	channel = CHAN_STATIC,
} )

AddSounds( "SCP682.Step", "scp_lc/scp/682/footstep_%i_n.ogg", 80, 0.8, { 90, 110 }, CHAN_STATIC, 1, 2 )*/