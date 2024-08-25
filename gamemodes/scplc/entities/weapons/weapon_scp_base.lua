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

SWEP.DisableDamageEvent		= false

SWEP.ScoreOnDamage 			= false
SWEP.ScoreOnKill 			= false

SWEP.SelectFont 			= "SCPHUDMedium"

function SWEP:SetupDataTables()
	self:AddNetworkVar( "NextSpecialAttack", "Float" )
end

function SWEP:InitializeLanguage( name )
	if CLIENT then
		self.Lang = LANG.WEAPONS[name] or {}
	end
end

function SWEP:InitializeHUD( name )
	if SERVER or !name and !self.HUDName then return end

	local hud = GetSCPHUDObject( name or self.HUDName )
	if !hud then return end

	hud:Create( self )
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
	return t != TEAM_SPEC and !SCPTeams.IsAlly( TEAM_SCP, t ) and !ply:HasGodMode() and !ply:HasEffect( "spawn_protection" )
end

function SWEP:PrimaryAttack()
	self:DamageEvent()
end

function SWEP:SecondaryAttack()
	self:DamageEvent()
end

function SWEP:SpecialAttack()

end

function SWEP:Reload()
	self:DamageEvent()
end

SWEP.DamageEventCD = 0
function SWEP:DamageEvent()
	if ROUND.preparing or self.DisableDamageEvent then return end

	if self.DamageEventCD > CurTime() then return end
	self.DamageEventCD = CurTime() + 0.5

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
		if IsValid( ent ) and !ent:IsPlayer() then
			self:SCPDamageEvent( ent, 50 )
		end
	end
end

function SWEP:HUDNotify( text, time, snd )
	if SERVER then
		net.Ping( "SCPHUDNotify", text, self:GetOwner() )
		return
	end

	if !self.HUDObject then return end

	self.HUDObject:Notify( text, time or 1, snd )
end

function SWEP:DrawHUD()
	if !hook.Run( "SLCShouldDrawSCPHUD" ) then return end

	if self.HUDObject then
		self.HUDObject:Draw()
	end

	if self.DrawSCPHUD then
		self:DrawSCPHUD()
	end
end

if CLIENT then
	net.ReceivePing( "SCPHUDNotify", function( data )
		local wep = LocalPlayer():GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep:HUDNotify( data )
	end )

	hook.Add( "PlayerButtonDown", "SLCSCPSpecialAbility", function( ply, btn )
		if ply:SCPTeam() != TEAM_SCP or ply:GetDisableControls() then return end
		if btn != GetBindButton( "scp_special" ) then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end
		
		if wep:GetNextSpecialAttack() > CurTime() then return end

		wep:SpecialAttack()

		net.Start( "SCPSpecialAttack" )
		net.SendToServer()
	end )
end

if SERVER then
	net.Receive( "SCPSpecialAttack", function( len, ply )
		if ply:SCPTeam() != TEAM_SCP then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end
		
		if wep:GetNextSpecialAttack() > CurTime() then return end

		wep:SpecialAttack()
	end )

	hook.Add( "PostEntityTakeDamage", "SLCGenericSCPDamage", function( target, dmg, took )
		if !IsValid( target ) or !target:IsPlayer() then return end

		local att = dmg:GetAttacker()
		if !IsValid( att ) or !att:IsPlayer() or att == target or att:SCPTeam() != TEAM_SCP then return end

		local dmg_num = math.max( dmg:GetDamage(), dmg:GetDamageCustom() )
		if dmg_num == 0 then return end

		local wep = att:GetSCPWeapon()
		if !IsValid( wep ) then return end

		if wep.OnPlayerDamaged then
			wep:OnPlayerDamaged( dmg_num, target )
		end

		if !wep.UpgradeSystemMounted or !wep.ScoreOnDamage then return end

		wep:AddScore( dmg_num )
	end )

	hook.Add( "SLCPlayerDeath", "SLCGenericSCPKill", function( ply, att )
		if !IsValid( ply ) or !ply:IsPlayer() or !IsValid( att ) or !att:IsPlayer() or att == ply or att:SCPTeam() != TEAM_SCP then return end

		local wep = att:GetSCPWeapon()
		if !IsValid( wep ) then return end

		if wep.UpgradeSystemMounted and wep.ScoreOnKill then
			wep:AddScore( 1 )
		end

		if wep.OnPlayerKilled then
			wep:OnPlayerKilled( att )
		end
	end )
end