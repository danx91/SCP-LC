SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-682"

SWEP.HoldType		= "normal"

SWEP.NextPrimary 	= 0
SWEP.NextSpecial 	= 0

SWEP.AttackDelay 	= 1
SWEP.SpecialDelay 	= 90
SWEP.SpecialTime 	= 10


function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP682" )
end

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end
	if self.NextPrimary > CurTime() then return end

	self.NextPrimary = CurTime() + self.AttackDelay

	if SERVER then
		self.Owner:LagCompensation( true )

		local tr = util.TraceHull{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
			filter = self.Owner,
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		}

		self.Owner:LagCompensation( false )

		local ent = tr.Entity
		if IsValid( ent ) then
			if ent:IsPlayer() then
				if ent:SCPTeam() == TEAM_SCP or ent:SCPTeam() == TEAM_SPEC then return end

				ent:TakeDamage( 250, self.Owner, self.Owner )
			else
				self:SCPDamageEvent( ent, 50 )
			end	
		end
	end
end

function SWEP:SecondaryAttack()
	if self.NextSpecial > CurTime() then return end

	self.NextSpecial = CurTime() + self.SpecialDelay + self.SpecialTime

	if SERVER then
		self.Owner:EmitSound( "SCP682.Roar" )
	end

	self.Immortal = true
	Timer( "SCP682Effect"..self.Owner:SteamID64(), self.SpecialTime, 1, function()
		if IsValid( self ) then
			self.Immortal = false
		end
	end )
end

hook.Add( "EntityTakeDamage", "SCP682Damage", function( ply, dmg )
	if !ply:IsPlayer() or !ply:Alive() then return end

	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and wep:GetClass() == "weapon_scp_682" then
		if wep.Immortal then return true end

		if dmg:IsDamageType( DMG_ACID ) then
			if ROUND.preparing then return true end

			dmg:ScaleDamage( 5 )
		end
	end
end)

function SWEP:DrawHUD()
	if hud_disabled or HUDDrawInfo or ROUND.preparing then return end
	
	local txt, color
	if self.Immortal then
		txt = string.format( self.Lang.s_on, math.ceil( self.NextSpecial - self.SpecialDelay - CurTime() ) )
		color = Color( 0, 0, 255 )
	elseif self.NextSpecial > CurTime() then
		txt = string.format( self.Lang.swait, math.ceil( self.NextSpecial - CurTime() ) )
		color = Color( 255, 0, 0 )
	else
		txt = self.Lang.sready
		color = Color( 0, 255, 0 )
	end

	draw.Text{
		text = txt,
		pos = { ScrW() * 0.5, ScrH() * 0.97 },
		color = color,
		font = "SCPHUDSmall",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}
end

sound.Add( {
	name = "SCP682.Roar",
	volume = 1,
	level = 100,
	pitch = { 90, 110 },
	sound = "scp/682/roar.ogg",
	channel = CHAN_STATIC,
} )