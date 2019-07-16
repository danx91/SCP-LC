SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-106"

SWEP.HoldType		= "normal"

SWEP.Chase 			= "scp/106/chase.ogg"
SWEP.Place 			= "scp/106/place.ogg"
SWEP.Teleport 		= "scp/106/tp.ogg"
SWEP.Disappear 		= "scp/106/disappear.ogg"

SWEP.NextPrimaryAttack	= 0
SWEP.AttackDelay		= 1

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP106" )
end

SWEP.SoundPlayers = {}
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
				--TODO 714

				local pos = GetPocketPos()
				local ang = ent:GetAngles()

				ang.yaw = math.random( -180, 180 )

				if pos then
					ent:TakeDamage( math.random( 30, 50 ), self.Owner, self.Owner )
					ent:SetPos( pos )
					ent:SetAngles( ang )
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
		if self.NextPlace > CurTime() then return end
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
	self.NextTP = CurTime() + 90

	if SERVER then
		if self.TPPoint then
			self:TeleportSequence( self.TPPoint )
		end
	end
end

function SWEP:TeleportSequence( point )
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
		if IsValid( self ) and IsValid( self.Owner ) then
			if n < 40 and n % 20 == 1 then
				--self:EmitSound( "SCP106.Disappear" )
				TransmitSound( self.Disappear, true, ppos, 750 )
			end

			self.Owner:SetPos( ppos - Vector( 0, 0, 2 * n ) )
		end
	end, function()
		if IsValid( self ) and IsValid( self.Owner ) then
			self.Owner:SetPos( point - Vector( 0, 0, 80 ) )

			Timer( "106TP_2"..self.Owner:SteamID64(), 0.1, 41, function( this, n )
				if IsValid( self ) and IsValid( self.Owner ) then
					if n == 1 or n == 30 then
						//self:EmitSound( "SCP106.Teleport" )
						TransmitSound( self.Teleport, true, point, 750 )
					end

					self.Owner:SetPos( point - Vector( 0, 0, 82 - 2 * n ) )
				end
			end, function()
				if IsValid( self ) and IsValid( self.Owner ) then
					self.Owner:SetPos( point )
					self.Owner:Freeze( false )
				end	
			end )
		end
	end )
end

function SWEP:DrawHUD()
	if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

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