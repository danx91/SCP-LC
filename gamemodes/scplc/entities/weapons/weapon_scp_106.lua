SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-106"

SWEP.HoldType		= "normal"

SWEP.Chase 			= "scp/106/chase.ogg"
SWEP.Place 			= "scp/106/place.ogg"
SWEP.Teleport 		= "scp/106/tp.ogg"
SWEP.Disappear 		= "scp/106/disappear.ogg"

SWEP.NextPrimaryAttack	= 0
SWEP.AttackDelay		= 1
SWEP.DMGBoost			= 0

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP106" )

	self.SoundPlayers = {}
end

//SWEP.SoundPlayers = {}
SWEP.NThink = 0
function SWEP:Think()
	if self.NThink > CurTime() then return end
	self.NThink = CurTime() + 1

	if SERVER then
		local pos = self.Owner:GetPos()

		for ply, time in pairs( self.SoundPlayers ) do
			if IsValid( ply ) then
				if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP or time < CurTime() or pos:DistToSqr( ply:GetPos() ) > 562500 then
					TransmitSound( self.Chase, false, ply )
					-- net.Start( "PlaySound" )
					-- 	net.WriteUInt( 0, 1 )
					-- 	net.WriteString( self.Chase )
					-- net.Send( ply )

					self.SoundPlayers[ply] = nil
					--print( "Removing ", ply )
				end
			else
				self.SoundPlayers[ply] = nil
			end
		end

		local e = ents.FindInSphere( pos, 750 )
		for k, v in pairs( e ) do
			if IsValid( v ) and v:IsPlayer() then
				if  v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
					if !self.SoundPlayers[v] then
						TransmitSound( self.Chase, true, v )
						-- net.Start( "PlaySound" )
						-- 	net.WriteUInt( 1, 1 )
						-- 	net.WriteString( self.Chase )
						-- net.Send( v )

						self.SoundPlayers[v] = CurTime() + 31
						--print( "inserting ", v )
					end
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end
	if self.NextPrimaryAttack > CurTime() then return end

	self.NextPrimaryAttack = CurTime() + self.AttackDelay

	if SERVER then
		self.Owner:LagCompensation( true )

		local tr = util.TraceHull{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 75,
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

				if ent:GetPos():WithinAABox( POCKETD_MINS, POCKETD_MAXS ) then
					self:AddScore( 1 )
					
					local dmg = DamageInfo()
					dmg:SetDamage( ent:Health() )
					dmg:SetDamageType( DMG_DIRECT )
					dmg:SetAttacker( self.Owner )
					dmg:SetInflictor( self.Owner )

					ent:TakeDamageInfo( dmg )
				else
					local pos

					if istable( POS_POCKETD ) then
						pos = table.Random( POS_POCKETD )
					else
						pos = POS_POCKETD
					end

					if pos then
						local dmg = math.random( 30, 50 )
						if self.DMGBoost > CurTime() then
							dmg = dmg + ( self:GetUpgradeMod( "dmg" ) or 0 )
						end

						ent:TakeDamage( dmg, self.Owner, self.Owner )
						ent:SetPos( pos )

						local ang = ent:GetAngles()
						ang.yaw = math.random( -180, 180 )
						ent:SetAngles( ang )

						self:AddScore( 1 )
						AddRoundStat( "106" )
					end
				end
			else
				self:SCPDamageEvent( ent, 50 )
			end
		end
	end
end

SWEP.NextPlace = 0
SWEP.TPPoint = nil
function SWEP:SecondaryAttack()
	if SERVER then
		if self.NextPlace > CurTime() or self:GetOwner():GetVelocity().z != 0 then return end
		self.NextPlace = CurTime() + 10

		self.Owner:EmitSound( "SCP106.Place" )

		self.TPPoint = self.Owner:GetPos()
		
		local tr = util.TraceLine{
			start = self.Owner:GetPos(),
			endpos = self.Owner:GetPos() - Vector( 0, 0, 100 ),
			filter = self.Owner
		}

		if tr.Hit then
			util.Decal( "Decal106", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal )
		end
	end
end

SWEP.NextTP = 0
function SWEP:Reload()
	if self.NextTP > CurTime() then return end

	local cd = 90 - ( self:GetUpgradeMod( "cd" ) or 0 )
	self.NextTP = CurTime() + cd

	if SERVER then
		if self.TPPoint then
			self:TeleportSequence( self.TPPoint )
		end
	end
end

function SWEP:TeleportSequence( point )
	//if ROUND.post then return end

	self.NextAttackW = CurTime() + 8
	self.NextPlace = CurTime() + 15

	local tr = util.TraceLine{
		start = self.Owner:GetPos(),
		endpos = self.Owner:GetPos() - Vector( 0, 0, 100 ),
		filter = self.Owner
	}

	if tr.Hit then
		util.Decal( "Decal106", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal )
	end

	self.Owner:Freeze( true )

	DestroyTimer( "106TP_1"..self.Owner:SteamID64() )
	DestroyTimer( "106TP_2"..self.Owner:SteamID64() )

	local ppos = self.Owner:GetPos()
	Timer( "106TP_1"..self.Owner:SteamID64(), 0.1, 40, function( this, n )
		if IsValid( self ) and self:CheckOwner() then
			if n < 40 and n % 20 == 1 then
				--self:EmitSound( "SCP106.Disappear" )
				TransmitSound( self.Disappear, true, ppos, 750 )
			end

			self.Owner:SetPos( ppos - Vector( 0, 0, 2 * n ) )
		end
	end, function()
		if IsValid( self ) and self:CheckOwner() then
			self.Owner:SetPos( point - Vector( 0, 0, 80 ) )

			Timer( "106TP_2"..self.Owner:SteamID64(), 0.1, 41, function( this, n )
				if IsValid( self ) and self:CheckOwner() then
					if n == 1 or n == 30 then
						//self:EmitSound( "SCP106.Teleport" )
						TransmitSound( self.Teleport, true, point, 750 )
					end

					self.Owner:SetPos( point - Vector( 0, 0, 82 - 2 * n ) )
				end
			end, function()
				if IsValid( self ) and self:CheckOwner() then
					self.Owner:SetPos( point )
					self.Owner:Freeze( false )

					local boost = self:GetUpgradeMod( "dmgtime" )

					if boost then
						self.DMGBoost = CurTime() + boost
					end
				end	
			end )
		end
	end )
end

function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	local txt, color
	if self.NextTP > CurTime() then
		txt = string.format( self.Lang.swait, math.ceil( self.NextTP - CurTime() ) )
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

--[[-------------------------------------------------------------------------
106 Collision
---------------------------------------------------------------------------]]
if SERVER then --TODO: do shared version
	hook.Add( "ShouldCollide", "SCP106Collision", function ( ent1, ent2 )
		if ent1:IsPlayer() and ent1:SCPClass() == CLASSES.SCP106 or ent2:IsPlayer() and ent2:SCPClass() == CLASSES.SCP106 then
			if ent1.ignorecollide106 or ent2.ignorecollide106 then
				return false
			end
		end
	end )

	local function Setup106Collision()
		for k, v in pairs( ents.GetAll() ) do
			if v and v:GetClass() == "func_door" or v:GetClass() == "prop_dynamic" then
				if v:GetClass() == "prop_dynamic" then
					local ennt = ents.FindInSphere( v:GetPos(), 5 )
					local neardors = false
					for k, v in pairs( ennt ) do
						if v:GetClass() == "func_door" then
							neardors = true
							break
						end
					end
					if !neardors then 
						v.ignorecollide106 = false
						continue
					end
				end

				local changed
				for _, pos in pairs( DOOR_RESTRICT106 ) do
					if v:GetPos():Distance( pos ) < 100 then
						v.ignorecollide106 = false
						changed = true
						break
					end
				end
				
				if !changed then
					v.ignorecollide106 = true
				end
			end
		end
	end

	hook.Add( "PostCleanupMap", "SCP106Collision", Setup106Collision )
	timer.Simple( 0, Setup106Collision )
end

game.AddDecal( "Decal106", "decals/decal106" )

sound.Add( {
	name = "SCP106.Place",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = SWEP.Place,
	channel = CHAN_STATIC,
} )

/*sound.Add( {
	name = "SCP106.Disappear",
	volume = 1,
	level = 125,
	pitch = 100,
	sound = SWEP.Disappear,
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SCP106.Teleport",
	volume = 1,
	level = 255,
	pitch = 100,
	sound = SWEP.Teleport,
	channel = CHAN_STATIC,
} )*/

DefineUpgradeSystem( "scp106", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "cd1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { cd = 15 }, active = false },
		{ name = "cd2", cost = 2, req = { "cd1" }, reqany = false,  pos = { 1, 2 }, mod = { cd = 30 }, active = false },
		{ name = "cd3", cost = 4, req = { "cd2" }, reqany = false,  pos = { 1, 3 }, mod = { cd = 45 }, active = false },

		{ name = "tpdmg1", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { dmgtime = 10, dmg = 15 }, active = false },
		{ name = "tpdmg2", cost = 3, req = { "tpdmg1" }, reqany = false,  pos = { 2, 2 }, mod = { dmgtime = 20, dmg = 20 }, active = false },
		{ name = "tpdmg3", cost = 5, req = { "tpdmg2" }, reqany = false,  pos = { 2, 3 }, mod = { dmgtime = 30, dmg = 25 }, active = false },
		
		{ name = "tank1", cost = 3, req = {}, reqany = false,  pos = { 3, 1 }, mod = { prot = 0.8 }, active = true },
		{ name = "tank2", cost = 5, req = { "tank1" }, reqany = false,  pos = { 3, 2 }, mod = { prot = 0.6 }, active = true },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = {
		{ 1, 1 },
		{ 3, 1 },
		{ 6, 2 },
		{ 9, 1 },
		{ 12, 1 },
		{ 15, 2 },
		{ 18, 2 },
		{ 21, 3 }
	}
} )

function SWEP:OnUpgradeBought( name, info, group )
	if SERVER and self:CheckOwner() then
		self.Owner:PushSpeed( 0.9, 0.9, -1, "SLC_SCP106" )
	end
end

hook.Add( "EntityTakeDamage", "SCP106DMGMod", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() and ent:SCPClass() == CLASSES.SCP106 then
		local wep = ent:GetActiveWeapon()
		if IsValid( wep ) and wep.UpgradeSystemMounted then
			local mod = wep:GetUpgradeMod( "prot" )

			if mod then
				if dmg:IsDamageType( DMG_BULLET ) then
					dmg:ScaleDamage( mod )
				end
			end
		end
	end
end )

InstallUpgradeSystem( "scp106", SWEP )
