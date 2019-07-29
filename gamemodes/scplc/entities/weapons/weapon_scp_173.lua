SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-173"

SWEP.HoldType		= "normal"

SWEP.SpecialCD 		= 60
SWEP.NextSpecial 	= 0
SWEP.StopThink  	= false
SWEP.GBlink 		= 0

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "NSpecial" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP173" )
end
 
function SWEP:Think()
	if CLIENT or ROUND.post or self.StopThink then return end

	local freeze = false

	local ply = self.Owner
	local obb_bot, obb_top = ply:GetModelBounds()
	local obb_mid = ( obb_bot + obb_top ) * 0.5

	obb_bot.x = obb_mid.x
	obb_bot.y = obb_mid.y
	obb_bot.z = obb_bot.z + 10

	obb_top.x = obb_mid.x
	obb_top.y = obb_mid.y
	obb_top.z = obb_top.z - 10

	local top, mid, bot = ply:LocalToWorld( obb_top ), ply:LocalToWorld( obb_mid ), ply:LocalToWorld( obb_bot )
	local mask = MASK_BLOCKLOS_AND_NPCS

	for k, v in pairs( player.GetAll() ) do
		//print( ply:GetBlink() )
		if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP and !v:GetBlink() then
			--print( v )
			local dist = ply:GetPos():DistToSqr( v:GetPos() )
			local sight = v:GetSightLimit()

			if sight != -1 then
				if dist > sight * sight then
					continue
				end
			end

			local eyepos = v:EyePos()
			local eyevec = v:EyeAngles():Forward()

			local mid_z = mid:Copy()
			mid_z.z = mid_z.z + 17.5

			local line = ( mid_z - eyepos ):GetNormalized()
			local angle = math.acos( eyevec:Dot( line ) )

			if angle <= 0.8 then
				local trace_top = util.TraceLine( {
					start = eyepos,
					endpos = top,
					filter = { ply, v },
					mask = mask
				} )

				local trace_mid = util.TraceLine( {
					start = eyepos,
					endpos = mid,
					filter = { ply, v },
					mask = mask
				} )

				local trace_bot = util.TraceLine( {
					start = eyepos,
					endpos = bot,
					filter = { ply, v },
					mask = mask
				} )

				//print( trace_top.Hit, trace_mid.Hit, trace_bot.Hit )
				if !trace_top.Hit or !trace_mid.Hit or !trace_bot.Hit then
					freeze = true

					if ( !v.SCP173Horror or v.SCP173Horror < CurTime() ) and dist < 90000 then
						v.SCP173Horror = CurTime() + 15
						v:SendLua( "LocalPlayer():EmitSound( 'SCP173.Horror' )" )
					end
				end
			end
		end
	end

	if freeze then
		ply:Freeze( true )
	else
		ply:Freeze( false )

		for k, v in pairs( player.GetAll() ) do
			if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
				local dist = ply:GetPos():DistToSqr( v:GetPos() )
				if dist <= 1600 then
					local trace = util.TraceLine( {
						start = ply:GetShootPos(),
						endpos = v:EyePos(),
						filter = { ply, v },
						mask = MASK_SHOT
					} )

					if !trace.Hit then
						local dmginfo = DamageInfo()

						dmginfo:SetDamage( v:Health() )
						dmginfo:SetAttacker( self.Owner )
						dmginfo:SetDamageType( DMG_DIRECT )

						v:TakeDamageInfo( dmginfo )

						v:EmitSound( "SCP173.Snap" )
					end
				end
			end
		end
	end

	if self.SpecialUse and self.GBlink > CurTime() then
		self.SpecialUse = false

		self.Owner:Blink( 0.5, 0 )
		self.Owner:Freeze( true )
		self.StopThink = true

		timer.Simple( 0.75, function()
			if IsValid( self ) then
				self.StopThink = false
			end
		end )

		self:Teleport()
	end
end

function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing then return end
	if self.NextSpecial > CurTime() then return end
	if !self:CanTeleport() then return end

	self.NextSpecial = CurTime() + self.SpecialCD
	self:SetNSpecial( self.NextSpecial )

	self.SpecialUse = true
end

function SWEP:CanTeleport()
	for k, v in pairs( FindInCylinder( self.Owner:GetPos(), 3000, -512, 512, "player", nil, player.GetAll() ) ) do
		local t = v:SCPTeam()
		if t != TEAM_SPEC and t != TEAM_SCP then
			return true
		end
	end

	return false
end

function SWEP:Teleport()
	local near = {}
	local players = {}

	local ownerpos = self.Owner:GetPos()

	for k, v in pairs( FindInCylinder( ownerpos, 1500, -512, 512, "player", nil, player.GetAll() ) ) do
		local t = v:SCPTeam()
		if t != TEAM_SPEC and t != TEAM_SCP then
			table.insert( players, v )
			near[v] = 0
			for k, ply in pairs( FindInCylinder( v:GetPos(), 500, -128, 128, "player", nil, player.GetAll() ) ) do
				if ply != v then
					local pt = v:SCPTeam()
					if pt != TEAM_SPEC and pt != TEAM_SCP then
						near[v] = near[v] + 1
					end
				end
			end
		end
	end

	table.sort( players, function( a, b )
		if near[a] == near[b] then
			return a:GetPos():DistToSqr( ownerpos ) < b:GetPos():DistToSqr( ownerpos )
		end

		return near[a] < near[b]
	end )

	for i = 1, #players do
		local ply = players[i]

		local dist = ply:GetVelocity():Length() * 0.9

		if dist < 60 then
			dist = 60
		end
		
		/*if ply:GetVelocity():LengthSqr() > 22500 then
			dist = 225
		end*/

		local plypos = ply:GetPos()
		local obb = ply:OBBCenter()
		local point = plypos + obb + ply:GetAngles():Forward() * dist

		if util.IsInWorld( point ) then
			local point_tr = util.TraceLine{
				start = plypos + obb,
				endpos = point,
				filter = ply
			}

			if !point_tr.Hit then
				local trace = util.TraceLine{
					start = point,
					endpos = point - Vector( 0, 0, 128 ),
				}

				if trace.Hit then
					local pos = trace.HitPos

					if !util.TraceLine( {
						start = pos,
						endpos = point + Vector( 0, 0, 72 ),
					} ).Hit then
						self.Owner:SetEyeAngles( ( plypos - pos ):Angle() )
						self.Owner:SetPos( pos )
						return
					end
				end
			end
		end
	end

	self.NextSpecial = CurTime() + 3
	self:SetNSpecial( self.NextSpecial )
end

function SWEP:DrawHUD()
	if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	local NextSpecial = self:GetNSpecial()

	local txt, color
	if NextSpecial > CurTime() then
		txt = string.format( self.Lang.swait, math.ceil( NextSpecial - CurTime() ) )
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

addSounds( "SCP173.Horror", "scp/173/Horror/Horror%i.ogg", 0, 1, 100, CHAN_STATIC, 0, 9 )
addSounds( "SCP173.Rattle", "scp/173/Rattle%i.ogg", 90, 1, 100, CHAN_STATIC, 1, 3 )
addSounds( "SCP173.Snap", "scp/173/NeckSnap%i.ogg", 511, 1, 100, CHAN_STATIC, 1, 3 )

hook.Add( "PlayerFootstep", "173Rattle", function( ply, pos, foot, sound, vol, filter )
	if ply:SCPClass() == CLASSES.SCP173 then
		if SERVER then
			if !ply.N173Step or ply.N173Step < CurTime() then
				ply.N173Step = CurTime() + 0.9
				ply:EmitSound( "SCP173.Rattle" )
			end
		end

		return true
	end
end )

hook.Add( "SLCBlink", "SCP173TP", function( time )
	for k, v in pairs( SCPTeams.getPlayersByTeam( TEAM_SCP ) ) do
		local wep = v:GetActiveWeapon()

		if IsValid( wep ) and wep:GetClass() == "weapon_scp_173" then
			wep.GBlink = CurTime() + time
		end
	end
end )