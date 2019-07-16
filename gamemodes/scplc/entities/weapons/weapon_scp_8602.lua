SWEP.Base 				= "weapon_scp_base"
SWEP.PrintName			= "SCP-860-2"

SWEP.HoldType 			= "normal"

SWEP.NextPrimary = 0
SWEP.AttackDelay = 1.5

local PunchAngles = { Angle( -10, -5, 0 ), Angle( 10, 5, 0 ), Angle( -10, 5, 0 ), Angle( 10, -5, 0 ) }

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP8602" )
end

function SWEP:PrimaryAttack()
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.AttackDelay

	if SERVER then
		self.Owner:LagCompensation( true )

		local trace = util.TraceHull{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40,
			filter = self.Owner,
			mask = MASK_SHOT_HULL,
			maxs = Vector( 10, 10, 10 ),
			mins = Vector( -10, -10, -10 )
		}

		self.Owner:LagCompensation( false )

		local ent = trace.Entity
		if trace.Hit and IsValid( ent ) then
			if ent:IsPlayer() then
				if ent:SCPTeam() == TEAM_SPEC or ent:SCPTeam() == TEAM_SCP then return end

				local trace2 = util.TraceHull{
					start = self.Owner:GetShootPos(),
					endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
					mask = MASK_SOLID_BRUSHONLY,
					maxs = Vector( 10, 10, 10 ),
					mins = Vector( -10, -10, -10 )
				}

				if trace2.Hit then
					if math.abs( trace2.HitNormal.z ) < 0.5 then --z normal 0 is vertical, 1 or -1 is horizontal. If surface angle to floor is lower than 45 degrees, don't trigger special attack
						self:SpecialAttack( ent )
					else
						self:NormalAttack( ent )
					end
				else
					self:NormalAttack( ent )
				end
			else
				self:SCPDamageEvent( ent, 50 )
			end
		end
	end
end

function SWEP:NormalAttack( ent )
	ent:TakeDamage( math.random( 20, 40 ), self.Owner, self.Owner )
	self.Owner:EmitSound( "SCP8602.ImpactSoft" )
	self.Owner:ViewPunch( table.Random( PunchAngles ) )
end

function SWEP:SpecialAttack( ent )
	ent:TakeDamage( math.random( 75, 125 ), self.Owner, self.Owner )
	self.Owner:TakeDamage( math.random( 50, 100 ), self.Owner, self.Owner )
	self.Owner:EmitSound( "SCP8602.ImpactHard" )

	self.Owner:ViewPunch( Angle( -30, 0, 0 ) )
	ent:ViewPunch( Angle( -50, 0, 0 ) )

	local vel = self.Owner:GetAimVector() * 1250
	self.Owner:SetVelocity( vel )
	ent:SetVelocity( vel )
end

sound.Add( {
	name = "SCP8602.ImpactSoft",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "npc/antlion/shell_impact3.wav",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP8602.ImpactHard",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "npc/antlion/shell_impact4.wav",
	channel = CHAN_STATIC,
} )