SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-682"

SWEP.HoldType		= "normal"

SWEP.NextPrimary 	= 0
SWEP.NextSpecial 	= 0

SWEP.AttackDelay 	= 2.5
SWEP.SpecialDelay 	= 60
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

				ent:TakeDamage( 75, self.Owner, self.Owner )

				if ent:Health() <= 0 then
					self:AddScore( 1 )
					AddRoundStat( "682" )
				end
			else
				self:SCPDamageEvent( ent, 50 )
			end	
		end
	end
end

function SWEP:SecondaryAttack()
	if self.NextSpecial > CurTime() then return end

	local duration = self.SpecialTime + ( self:GetUpgradeMod( "duration" ) or 0 )
	self.NextSpecial = CurTime() + self.SpecialDelay + duration

	if SERVER then
		self.Owner:EmitSound( "SCP682.Roar" )

		local speed = self:GetUpgradeMod( "speed" )
		if speed and !self.SpeedActive then
			self.SpeedActive = self.Owner:PushSpeed( speed, speed, -1 )
		end
	end

	self.Immortal = true
	Timer( "SCP682Effect"..self.Owner:SteamID64(), duration, 1, function()
		if IsValid( self ) then
			self.Immortal = false
		end
	end )
end

function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end
	
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

hook.Add( "EntityTakeDamage", "SCP682Damage", function( ply, dmg )
	if !ply:IsPlayer() or !ply:Alive() then return end

	if ply:SCPClass() == CLASSES.SCP682 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			if wep.Immortal then return true end

			if dmg:IsDamageType( DMG_ACID ) then
				if ROUND.preparing then return true end

				dmg:ScaleDamage( 5 )
			elseif dmg:IsDamageType( DMG_BULLET ) then
				local scale = wep:GetUpgradeMod( "prot" )

				if scale then
					dmg:ScaleDamage( scale )
				end

				if wep:HasUpgrade( "ult" ) then
					local t = GetTimer( "SCP682Ult"..ply:SteamID64() )

					if IsValid( t ) then
						t:Start() --reset timer time
					else
						Timer( "SCP682Ult"..ply:SteamID64(), 3, 1, function()
							if IsValid( ply ) and IsValid( wep ) then
								local hp = ply:Health()
								local dif = ply:GetMaxHealth() - hp

								if dif > 0 then
									ply:SetHealth( hp + math.ceil( dif * 0.05 ) )
								end
							end
						end )
					end
				end
			end

			if wep.SpeedActive then
				ply:PopSpeed( wep.SpeedActive )
				wep.SpeedActive = false
			end
		end
	end
end )

DefineUpgradeSystem( "scp682", {
	grid_x = 4,
	grid_y = 4,
	upgrades = {
		{ name = "time1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { duration = 2.5 }, active = false },
		{ name = "time2", cost = 2, req = { "time1" }, reqany = false,  pos = { 1, 2 }, mod = { duration = 5 }, active = false },
		{ name = "time3", cost = 3, req = { "time2" }, reqany = false,  pos = { 1, 3 }, mod = { duration = 7.5 }, active = false },

		{ name = "speed1", cost = 3, req = { "time1", "prot1" }, reqany = false,  pos = { 2, 2 }, mod = { speed = 1.1 }, active = false },
		{ name = "speed2", cost = 5, req = { "speed1" }, reqany = false,  pos = { 2, 3 }, mod = { speed = 1.2 }, active = false },

		{ name = "prot1", cost = 1, req = {}, reqany = false,  pos = { 3, 1 }, mod = { prot = 0.9 }, active = false },
		{ name = "prot2", cost = 3, req = { "prot1" }, reqany = false,  pos = { 3, 2 }, mod = { prot = 0.75 }, active = false },
		{ name = "prot3", cost = 3, req = { "prot2" }, reqany = false,  pos = { 3, 3 }, mod = { prot = 0.6 }, active = false },

		{ name = "ult", cost = 6, req = { "speed2" }, reqany = false,  pos = { 2, 4 }, mod = {}, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = {
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 2 },
		{ 4, 1 },
		{ 5, 3 },
		{ 6, 1 },
		{ 7, 1 },
		{ 8, 2 },
		{ 10, 3 }
	}
} )

InstallUpgradeSystem( "scp682", SWEP )

sound.Add( {
	name = "SCP682.Roar",
	volume = 1,
	level = 100,
	pitch = { 90, 110 },
	sound = "scp/682/roar.ogg",
	channel = CHAN_STATIC,
} )