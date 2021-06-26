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

				local range = 80 + ( self:GetUpgradeMod( "range" ) or 0 )
				local trace2 = util.TraceHull{
					start = self.Owner:GetShootPos(),
					endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * range,
					mask = MASK_SOLID_BRUSHONLY,
					maxs = Vector( 10, 10, 10 ),
					mins = Vector( -10, -10, -10 )
				}

				if trace2.Hit then
					if math.abs( trace2.HitNormal.z ) < 0.5 then --z normal 0 is vertical, 1 or -1 is horizontal. If surface angle to floor is lower than 45 degrees, don't trigger special attack
						self:SpecialAttack( ent, trace2.HitPos )
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

function SWEP:SpecialAttack( ent, p )
	AddRoundStat( "8602" )

	local bonus = self:GetUpgradeMod( "dmg" ) or 0
	local dmg = math.random( 75, 125 ) + bonus

	ent:TakeDamage( dmg, self.Owner, self.Owner )
	self.Owner:TakeDamage( math.random( 50, 100 ) + bonus * 3, self.Owner, self.Owner )
	self.Owner:EmitSound( "SCP8602.ImpactHard" )

	self.Owner:ViewPunch( Angle( -30, 0, 0 ) )
	ent:ViewPunch( Angle( -50, 0, 0 ) )

	local vel = self.Owner:GetAimVector() * 1250
	self.Owner:SetVelocity( vel )
	ent:SetVelocity( vel )

	if self:HasUpgrade( "charge31" ) then
		for k, v in pairs( FindInCylinder( p, 125, -128, 128, nil, MASK_SOLID_BRUSHONLY, player.GetAll() ) ) do
			if v != self.Owner then
				local t = v:SCPTeam()

				if t != TEAM_SCP and t != TEAM_SPEC then
					v:TakeDamage( dmg * 0.2, self.Owner, self.Owner )
				end
			end
		end
	end
end

hook.Add( "DoPlayerDeath", "SCP8602Damage", function( ply, attacker, info ) --TODO move to after dmg
	if attacker:IsPlayer() and attacker:SCPClass() == CLASSES.SCP8602 then
	 	local wep = attacker:GetActiveWeapon()

	 	if IsValid( wep ) then
	 		wep:AddScore( 1 )
	 	end
	end
end )

DefineUpgradeSystem( "scp8602", {
	grid_x = 3,
	grid_y = 3,
	upgrades = {
		{ name = "charge11", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { dmg = 5 }, active = false },
		{ name = "charge12", cost = 3, req = { "charge11" }, reqany = false,  pos = { 2, 2 }, mod = { dmg = 15 }, active = false },
		{ name = "charge13", cost = 5, req = { "charge12" }, reqany = false,  pos = { 2, 3 }, mod = { dmg = 25 }, active = false },

		{ name = "charge21", cost = 2, req = { "charge11" }, reqany = false,  pos = { 1, 2 }, mod = { range = 15 }, active = false },
		{ name = "charge22", cost = 3, req = { "charge21" }, reqany = false,  pos = { 1, 3 }, mod = { range = 30 }, active = false },

		{ name = "charge31", cost = 5, req = { "charge12" }, reqany = false,  pos = { 3, 3 }, mod = {}, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 3, 2 }, mod = {}, active = false },
	},
	rewards = {
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 2 },
		{ 5, 2 },
		{ 7, 1 },
		{ 9, 2 },
		{ 10, 2 }
	}
} )

InstallUpgradeSystem( "scp8602", SWEP )

sound.Add( {
	name = "SCP8602.ImpactSoft",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "npc/antlion/shell_impact3.wav",
	channel = CHAN_STATIC,
} )

-- sound.Add( {
-- 	name = "SCP8602.ImpactHard",
-- 	volume = 1,
-- 	level = 75,
-- 	pitch = 100,
-- 	sound = "npc/antlion/shell_impact4.wav",
-- 	channel = CHAN_STATIC,
-- } )
AddSounds( "SCP8602.ImpactHard", "scp_lc/scp/8602/attack%i.ogg", 75, 1, 100, CHAN_STATIC, 1, 3 )