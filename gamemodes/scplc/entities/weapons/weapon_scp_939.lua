SWEP.Base 		 = "weapon_scp_base"
SWEP.PrintName 	 = "SCP-939"

SWEP.HoldType 	 = "melee"

SWEP.AttackDelay = 1
SWEP.PosLog = {}
SWEP.NLog = 0

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP939" )
end

function SWEP:Think()
	self:PlayerFreeze()

	if CLIENT or self.NLog > CurTime() then return end
	self.NLog = CurTime() + 1

	local pos = self.Owner:GetPos()

	local len = #self.PosLog
	if len == 0 or pos:DistToSqr( self.PosLog[len] ) > 10000 then
		table.insert( self.PosLog, pos )
		len = len + 1

		if len > 5 then
			table.remove( self.PosLog, 1 )
			len = len - 1
		end
	end

	for i = 1, len do
		local dist = 75 + ( self:GetUpgradeMod( "radius" ) or 0 )
		for k, v in pairs( FindInCylinder( self.PosLog[i], dist, -32, 128, nil, nil, player.GetAll() ) ) do
			if v != self.Owner then
				v:ApplyEffect( "amnc227", self.Owner, self:GetUpgradeMod( "damage" ) )
			end
		end
	end
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

				local dmg = math.random( 20, 30 )

				self.Owner:EmitSound( "SCP939.Attack" )
				ent:TakeDamage( dmg, self.Owner, self.Owner )

				if ent:Health() <= 0 then
					self:AddScore( 1 )
					AddRoundStat( "939" )
				end

				local heal = self:GetUpgradeMod( "heal" )
				if heal then
					local hp = self.Owner:Health() + math.ceil( heal * ( 0.75 + math.random() * 0.25 ) )
					local max = self.Owner:GetMaxHealth()

					if hp > max then
						hp = max
					end

					self.Owner:SetHealth( hp )
				end
			else
				self:SCPDamageEvent( ent, 50 )
			end	
		end
	end
end

if CLIENT then
	hook.Add( "SLCScreenMod", "939ScreenMod", function( clr )
		if LocalPlayer():HasEffect( "amnc227" ) then
			DrawMotionBlur( 0.1, 1, 0.01 )
			clr.colour = 0
			clr.contrast = clr.contrast + 0.5
			clr.brightness = clr.brightness - 0.07
		end
	end )
end

DefineUpgradeSystem( "scp939", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "heal1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { heal = 30 }, active = false },
		{ name = "heal2", cost = 2, req = { "heal1" }, reqany = false,  pos = { 1, 2 }, mod = { heal = 50 }, active = false },
		{ name = "heal3", cost = 3, req = { "heal2" }, reqany = false,  pos = { 1, 3 }, mod = { heal = 70 }, active = false },

		{ name = "amn1", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { radius = 25 }, active = false },
		{ name = "amn2", cost = 3, req = { "amn1" }, reqany = false,  pos = { 2, 2 }, mod = { damage = 1.5 }, active = false },
		{ name = "amn3", cost = 5, req = { "amn2" }, reqany = false,  pos = { 2, 3 }, mod = { radius = 50, damage = 3 }, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = {
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 2 },
		{ 5, 2 },
		{ 7, 1 },
		{ 9, 2 },
	}
} )

InstallUpgradeSystem( "scp939", SWEP )

sound.Add( {
	name = "SCP939.Attack",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "scp_lc/scp/939/attack.ogg",
	channel = CHAN_STATIC,
} )