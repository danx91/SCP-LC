SWEP.PrintName				= "BASE SCP"
SWEP.DeepBase 				= "weapon_scp_base"

SWEP.DrawCrosshair			= true

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

SWEP.FreezePlayer = false
SWEP.ShouldFreezePlayer = false

function SWEP:InitializeLanguage( name )
	if CLIENT then
		self.Lang = LANG.WEAPONS[name] or {}
	end
end

function SWEP:InitializeHUD( name )
	if CLIENT then
		self.HUDObject = CreateSCPHUDObject( name, self )
	end
end

function SWEP:StoreWeapon( data )
	/*if self.UpgradeSystemMounted then
		self:StoreUpgradeSystem( data )
	end*/

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
		/*self.Owner:SetCrouchedWalkSpeed( self.OldStats.crouch )
		self.Owner:SetJumpPower( self.OldStats.jump )
		self.Owner:SetWalkSpeed( self.OldStats.walk )
		self.Owner:SetRunSpeed( self.OldStats.run )*/
	end
end

function SWEP:Think()
	self:PlayerFreeze()
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

hook.Add( "SLCScreenMod", "SCPVisionMod", function( clr )
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and ply:SCPTeam() == TEAM_SCP then
		if wep.UpgradeSystemMounted then
			if wep:HasUpgrade( "nvmod" ) then
				clr.contrast = clr.contrast + 0.75
				clr.brightness = clr.brightness + 0.01
			end
		end
	end
end )