SWEP.PrintName				= "BASE SCP"
SWEP.DeepBase 				= "weapon_scp_base"

SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.ViewModelFOV			= 62
SWEP.DrawCrosshair 			= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

SWEP.SCP 					= true
SWEP.Droppable				= false

SWEP.WorldModel 			= ""
SWEP.ViewModel 				= ""

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.FreezePlayer 			= false
SWEP.ShouldFreezePlayer 	= false

SWEP.ScoreOnDamage 			= false
SWEP.ScoreOnKill 			= false

SWEP.SelectFont 			= "SCPHUDMedium"

function SWEP:InitializeLanguage( name )
	if CLIENT then
		self.Lang = LANG.WEAPONS[name] or {}
	end
end

function SWEP:InitializeHUD( name )
	if CLIENT then
		self.HUDObject = SCPHUDObject( name, self )
	end
end

function SWEP:StoreWeapon( data )
	StoreUpgradeSystem( self, data )
end

function SWEP:RestoreWeapon( data )
	RestoreUpgradeSystem( self, data )
end

function SWEP:Deploy()
	local owner = self:GetOwner()
	if IsValid( owner ) then
		self.OwnerSignature = owner:TimeSignature()
		owner:DrawViewModel( self.ShouldDrawViewModel )

		if SERVER then
			owner:DrawWorldModel( self.ShouldDrawWorldModel )
		end

		self:ResetViewModelBones()
	end
end

function SWEP:Holster( wep )
	return false
end

function SWEP:PlayerFreeze()
	if !SERVER then return end

	if ROUND.preparing and self.ShouldFreezePlayer and !self.FreezePlayer then
		self.FreezePlayer = true
		
		local owner = self:GetOwner()
		self.OldJumpPower = owner:GetJumpPower()
		owner:SetJumpPower( 0 )
		owner:PushSpeed( 3, 3, -1, "SLC_SCPFreeze" )
	end

	if ROUND.preparing or ROUND.post then return end

	if self.FreezePlayer then
		self.FreezePlayer = false

		local owner = self:GetOwner()
		owner:PopSpeed( "SLC_SCPFreeze" )
		owner:SetJumpPower( self.OldJumpPower )
	end
end

function SWEP:Think()
	self:PlayerFreeze()
	self:SwingThink()
end

function SWEP:SCPDamageEvent( ent, dmg )
	if SERVER then
		hook.Run( "SCPDamage", self:GetOwner(), ent, dmg )
	end
end

function SWEP:CheckOwner()
	local owner = self:GetOwner()
	
	if !IsValid( owner ) then return false end

	if !self.OwnerSignature then
		self.OwnerSignature = owner:TimeSignature()
		return true
	end

	return owner:CheckSignature( self.OwnerSignature )
end

function SWEP:CanTargetPlayer( ply )
	local t = ply:SCPTeam()
	return t != TEAM_SPEC and !SCPTeams.IsAlly( TEAM_SCP, t )
end

SWEP.PrimaryCD = 0
function SWEP:PrimaryAttack()
	if ROUND.preparing then return end
	
	if self.PrimaryCD > CurTime() then return end
	self.PrimaryCD = CurTime() + 0.5

	if SERVER then
		local owner = self:GetOwner()
		local spos = owner:GetShootPos()

		local trace = util.TraceLine{
			start = spos,
			endpos = spos + owner:GetAimVector() * 70,
			filter = owner,
			mask = MASK_SHOT,
		}

		local ent = trace.Entity
		if IsValid( ent ) then
			if !ent:IsPlayer() then
				self:SCPDamageEvent( ent, 50 )
			end
		end
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:DrawHUD()
	if hook.Run( "SLCShouldDrawSCPHUD" ) then
		if self.HUDObject then
			self.HUDObject:Render()
		end

		if self.DrawSCPHUD then
			self:DrawSCPHUD()
		end
	end
end

/*hook.Add( "PlayerButtonDown", "SLCSCPSpecialAbility", function( ply, btn )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and wep.SCP and btn == GetBindButton( "upgrade_tree_button" ) then
	
end )

hook.Add( "PlayerButtonUp", "SLCSCPSpecialAbility", function( ply, btn )
	GetBindButton( "upgrade_tree_button" )
end )*/

if SERVER then
	hook.Add( "PostEntityTakeDamage", "SLCGenericSCPDamage", function( target, dmg, took )
		if !IsValid( target ) or !target:IsPlayer() then return end

		local att = dmg:GetAttacker()
		if !IsValid( att ) or !att:IsPlayer() or att == target or att:SCPTeam() != TEAM_SCP then return end

		local wep = att:GetActiveWeapon()
		if !IsValid( wep ) or !wep.UpgradeSystemMounted or !wep.ScoreOnDamage then return end

		local score = math.max( dmg:GetDamage(), dmg:GetDamageCustom() )
		if score == 0 then return end

		wep:AddScore( score )
	end )

	hook.Add( "SLCPlayerDeath", "SLCGenericSCPKill", function( ply, att )
		if !IsValid( ply ) or !ply:IsPlayer() or !IsValid( att ) or !att:IsPlayer() or att == ply or att:SCPTeam() != TEAM_SCP then return end

		local wep = att:GetActiveWeapon()
		if !IsValid( wep ) then return end

		if wep.UpgradeSystemMounted and wep.ScoreOnKill then
			wep:AddScore( 1 )
		end

		if wep.OnPlayerKilled then
			wep:OnPlayerKilled( att )
		end
	end )
end