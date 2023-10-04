SWEP.Base 				= "weapon_scp_base"
SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-066"

SWEP.HoldType 			= "normal"	

SWEP.ScoreOnDamage = true

SWEP.Delay1		= 1.5
SWEP.Delay2		= 26
SWEP.MusicLength = 22
SWEP.MusicFinish = 0

SWEP.Eric = false
SWEP.NextAttack = 0

SWEP.NextCharge = 0
SWEP.ChargeDelay = 20
//SWEP.Attached = nil

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP066" )
	//self:InitializeHUD( "scp066" )
end	

function SWEP:PrimaryAttack()
	if ROUND.preparing then return end
	if self.NextAttack > CurTime() then return end

	local owner = self:GetOwner()
	if !self.Eric then
		self.NextAttack = CurTime() + self.Delay1
		self.Eric = true

		if SERVER then
			owner:EmitSound( "SCP066.Eric" )
		end
	else
		self.NextAttack = CurTime() + self.Delay2
		self.MusicFinish = CurTime() + self.MusicLength
		self.Eric = false

		if SERVER then
			local dist = 400 + ( self:GetUpgradeMod( "dist" ) or 0 ) * ( self:GetUpgradeMod( "distmul" ) or 1 )
			local damage = 3 * ( self:GetUpgradeMod( "dmgmul" ) or 1 )

			owner:EmitSound( "SCP066.Music" )
			AddRoundStat( "066" )

			AddTimer( "SCP066_"..owner:SteamID64(), 1, self.MusicLength, function( t, n )
				if !IsValid( self ) or !self:CheckOwner() then
					t:Destroy()
					return
				end

				for i, v in ipairs( ents.FindInSphere( owner:GetPos(), dist ) ) do
					if IsValid( v ) and v:IsPlayer() and !v:IsInSafeSpot() then
						if self:CanTargetPlayer( v ) then
							v:TakeDamage( damage, owner, owner )
						end
					end
				end
			end )
		end
	end
end

function SWEP:SecondaryAttack()
	self:CallBaseClass( "PrimaryAttack" )
end

function SWEP:Reload()
	if ROUND.preparing then return end
	if !self:HasUpgrade( "charge" ) then return end
	if self.NextCharge > CurTime() then return end

	self.NextCharge = CurTime() + self.ChargeDelay

	local owner = self:GetOwner()
	local mul = owner:OnGround() and 1500 or 275

	local ang = Angle( 0, owner:GetAngles().yaw, 0 )
	local vec = ang:Forward() * mul

	owner:SetVelocity( vec )
	owner.Launched066 = CurTime() + 0.75

	if CLIENT then return end
	if self:HasUpgrade( "sticky" ) then
		local start = owner:EyePos()
		local tr = util.TraceHull{
			start = start,
			endpos = start + ang:Forward() * 250,
			filter = { self, owner },
			mins = { -5, -5, -5 },
			maxs = { 5, 5, 5 }
		}

		if !tr.Hit then return end
		local ent = tr.Entity

		if !IsValid( ent ) or !ent:IsPlayer() or ent:SCPTeam() == TEAM_SPEC or ( ent:SCPTeam() == TEAM_SCP and !ent:GetSCPHuman() ) then return end

		timer.Simple( 0.5, function()
			if !IsValid( self ) or !self:CheckOwner() or !IsValid( ent ) then return end
			
			owner:SetPos( ent:GetPos() + ang:Forward() * 15 + Vector( 0, 0, 15 ) )
			owner:SetMoveType( MOVETYPE_CUSTOM )
			owner:SetParent( ent )

			self.Attached = ent
			ent.SCP066Attached = owner

			timer.Simple( 10, function()
				if !IsValid( owner ) then return end

				owner:SetParent( nil )
				owner:SetMoveType( MOVETYPE_WALK )

				if IsValid( self ) and IsValid( self.Attached ) and self.Attached:Alive() then
					self.Attached.SCP066Attached = nil
					owner:SetPos( self.Attached:GetPos() )
				end

				self.Attached = nil
			end )
		end )
	end
end

SCPHook( "SCP066", "DoPlayerDeath", function( ply, attacker, dmginfo )
	if !IsValid( ply ) then return end

	if ply:SCPClass() == CLASSES.SCP066 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			if wep.Attached then
				ply:SetParent( nil )
				ply:SetMoveType( MOVETYPE_WALK )

				if IsValid( wep.Attached ) then
					wep.Attached.SCP066Attached = nil
				end

				wep.Attached = nil
			end
		end
	end

	if ply.SCP066Attached then
		if IsValid( ply.SCP066Attached ) then
			local scp = ply.SCP066Attached
			local wep = scp:GetActiveWeapon()

			if IsValid( wep ) and wep.Attached then
				scp:SetParent( nil )
				scp:SetMoveType( MOVETYPE_WALK )

				if IsValid( wep.Attached ) then
					ply.SCP066Attached = nil
					scp:SetPos( ply:GetPos() )
				end

				wep.Attached = nil
			end
		end

		ply.SCP066Attached = nil
	end
end )

SCPHook( "SCP066", "Move", function( ply, mv )
	if IsValid( ply ) and ply:IsPlayer() and ply:SCPClass() == CLASSES.SCP066 then
		local vel = mv:GetVelocity()
		local len = vel:LengthSqr()
		local maxspeed = 202500

		if ply.Launched066 and ply.Launched066 > CurTime() and !ply:OnGround() and len > maxspeed then
			local pct = maxspeed / len
			vel = vel * pct
			ply.Launched066 = false

			mv:SetVelocity( vel )
		end
	end
end )

local color_red = Color( 255, 0, 0 )
local color_green = Color( 0, 255, 0 )
function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end
	
	local txt, color
	if self.NextAttack > CurTime() then
		txt = string.format( self.Lang.wait, math.ceil( self.NextAttack - CurTime() ) )
		color = color_red
	else
		txt = self.Lang.ready
		color = color_green
	end
	
	draw.Text( {
		text = txt,
		pos = { ScrW() * 0.5, ScrH() * 0.97 },
		font = "SCPHUDSmall",
		color = color,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	if self.NextCharge > CurTime() then
		draw.Text( {
			text = string.format( self.Lang.chargecd, math.ceil( self.NextCharge - CurTime() ) ),
			pos = { ScrW() * 0.5, ScrH() * 0.94 },
			font = "SCPHUDSmall",
			color = color_red,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		})
	end
end

sound.Add( {
	name = "SCP066.Eric",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "scp_lc/scp/066/eric.ogg"
} )

sound.Add( {
	name = "SCP066.Music",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 511,
	pitch = 100,
	sound = "scp_lc/scp/066/beethoven.ogg"
} )

DefineUpgradeSystem( "scp066", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "range1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { dist = 100 }, active = false },
		{ name = "range2", cost = 2, req = { "range1" }, reqany = false,  pos = { 1, 2 }, mod = { dist = 200 }, active = false },
		{ name = "range3", cost = 3, req = { "range2" }, reqany = false,  pos = { 1, 3 }, mod = { dist = 400 }, active = false },

		{ name = "damage1", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { distmul = 0.9, dmgmul = 1.15 }, active = false },
		{ name = "damage2", cost = 3, req = { "damage1" }, reqany = false,  pos = { 2, 2 }, mod = { distmul = 0.75, dmgmul = 1.5 }, active = false },
		{ name = "damage3", cost = 5, req = { "damage2" }, reqany = false,  pos = { 2, 3 }, mod = { distmul = 0.5, dmgmul = 2 }, active = false },

		{ name = "charge", cost = 3, req = { "damage1" }, reqany = false,  pos = { 3, 2 }, mod = {}, active = false },
		{ name = "sticky", cost = 5, req = { "charge" }, reqany = false,  pos = { 3, 3 }, mod = {}, active = false },

		{ name = "def1", cost = 2, req = {}, reqany = false,  pos = { 4, 1 }, mod = { def = 0.8 }, active = false },
		{ name = "def2", cost = 4, req = { "def1" }, reqany = false,  pos = { 4, 2 }, mod = { def = 0.5 }, active = false },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false,  pos = { 4, 3 }, mod = {}, active = false },
	},
	rewards = { --16
		{ 100, 1 },
		{ 175, 1 },
		{ 250, 1 },
		{ 375, 2 },
		{ 450, 1 },
		{ 525, 2 },
		{ 625, 1 },
		{ 750, 2 },
		{ 850, 1 },
		{ 925, 2 },
		{ 1050, 2 },
	}
} )

SCPHook( "SCP066", "EntityTakeDamage", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() and ent:SCPClass() == CLASSES.SCP066 then
		local wep = ent:GetActiveWeapon()
		if IsValid( wep ) and wep.UpgradeSystemMounted then
			local mod = wep:GetUpgradeMod( "def" )

			if mod and wep.MusicFinish > CurTime() then
				if !dmg:IsDamageType( DMG_DIRECT ) then
					dmg:ScaleDamage( mod )
				end
			end
		end
	end
end )

InstallUpgradeSystem( "scp066", SWEP )

/*if CLIENT then
	DefineSCPHUD( "scp066",  {
		name = "SCP066",
		skills = {
			{
				name = "Skill 1",
				pos = 1,
				watch = "key_to_watch", --or function
				show = "key_to_watch", --or function
				button = "button_name", --will be checked in this order: Settings entry, bind, key
				material = "slc/hud/scp/3199attack.png",
			},
			{
				name = "Skill 2",
				pos = 2,
				watch = "key_to_watch", --or function
				show = "key_to_watch", --or function
				button = "button_name", --will be checked in this order: Settings entry, bind, key
				material = "slc/hud/scp/3199attack.png",
			},
			{
				name = "Skill 3",
				pos = 3,
				watch = "key_to_watch", --or function
				show = "key_to_watch", --or function
				button = "button_name", --will be checked in this order: Settings entry, bind, key
				material = "slc/hud/scp/3199attack.png",
			},
			{
				name = "Skill 4",
				pos = 5,
				watch = "key_to_watch", --or function
				show = "key_to_watch", --or function
				button = "button_name", --will be checked in this order: Settings entry, bind, key
				material = "slc/hud/scp/3199attack.png",
			},
		}
	} )
end*/