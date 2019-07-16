SWEP.Base 		 = "weapon_scp_base"
SWEP.PrintName 	 = "SCP-939"

SWEP.HoldType 	 = "melee"

SWEP.AttackDelay = 1

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP939" )
end

SWEP.NextPrimary = 0
function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end
	if self.NextPrimary > CurTime() then return end
	
	self.NextPrimary = CurTime() + self.AttackDelay

	if SERVER then
		self.Owner:LagCompensation( true )

		local tr = util.TraceHull{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 70,
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

				self.Owner:EmitSound( "SCP939.Attack" )
				ent:TakeDamage( math.random( 30, 40 ), self.Owner, self.Owner )
				self.Owner:SetHealth( math.Clamp( self.Owner:Health() + math.random( 40, 50 ), 0, self.Owner:GetMaxHealth() ) )
			else
				self:SCPDamageEvent( ent, 50 )
			end	
		end
	end
end

sound.Add( {
	name = "SCP939.Attack",
	volume = 1,
	level = 80,
	pitch = 100,
	sound = "scp/939/attack.ogg",
	channel = CHAN_STATIC,
} )