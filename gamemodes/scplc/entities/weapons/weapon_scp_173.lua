SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-173"

SWEP.HoldType		= "normal"

SWEP.SpecialCD 		= 60
SWEP.NextSpecial 	= 0
SWEP.StopThink  	= false
SWEP.GBlink 		= 0
SWEP.QuickReturnTime = 0

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "NSpecial" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP173" )
end
 
function SWEP:Think()
	if CLIENT or ROUND.post or self.StopThink then return end

	local owner = self:GetOwner()
	local freeze = false

	/*local ply = self.Owner
	local obb_bot, obb_top = ply:GetModelBounds()
	local obb_mid = ( obb_bot + obb_top ) * 0.5

	obb_bot.x = obb_mid.x
	obb_bot.y = obb_mid.y
	obb_bot.z = obb_bot.z + 10

	obb_top.x = obb_mid.x
	obb_top.y = obb_mid.y
	obb_top.z = obb_top.z - 10

	local top, mid, bot = ply:LocalToWorld( obb_top ), ply:LocalToWorld( obb_mid ), ply:LocalToWorld( obb_bot )
	local mask = MASK_BLOCKLOS_AND_NPCS*/

	for k, v in pairs( player.GetAll() ) do
		//print( ply:GetBlink() )
		if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP and !v:GetBlink() then
			/*print( v )
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
				if !trace_top.Hit or !trace_mid.Hit or !trace_bot.Hit then*/
				if owner:TestVisibility( v ) then
					freeze = true

					if ( !v.SCP173Horror or v.SCP173Horror < CurTime() ) and owner:GetPos():DistToSqr( v:GetPos() ) < 90000 then
						v.SCP173Horror = CurTime() + 15
						v:TakeSanity( 15, SANITY_TYPE.ANOMALY )
						v:SendLua( "LocalPlayer():EmitSound( 'SCP173.Horror' )" )
					end
				end
			//end
		end
	end

	if freeze then
		owner:Freeze( true )
	else
		owner:Freeze( false )

		for k, v in pairs( player.GetAll() ) do
			if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
				local dist = owner:GetPos():DistToSqr( v:GetPos() )
				if dist <= 1600 then
					local trace = util.TraceLine( {
						start = owner:GetShootPos(),
						endpos = v:EyePos(),
						filter = { owner, v },
						mask = MASK_SHOT
					} )

					if !trace.Hit then
						local dmginfo = DamageInfo()

						dmginfo:SetDamage( v:Health() )
						dmginfo:SetAttacker( self.Owner )
						dmginfo:SetDamageType( DMG_DIRECT )

						v:TakeDamageInfo( dmginfo )
						v:EmitSound( "SCP173.Snap" )

						AddRoundStat( "173" )
						self:AddScore( 1 )

						local heal = self:GetUpgradeMod( "heal" )
						local cd = self:GetUpgradeMod( "cd" )

						if cd then
							local scd = self.NextSpecial - CurTime()

							if scd > 0 then
								scd = scd * cd

								self.NextSpecial = CurTime() + scd
								self:SetNSpecial( self.NextSpecial )
							end
						end

						if heal then
							local hp = self.Owner:Health() + heal
							local max = self.Owner:GetMaxHealth()

							if hp > max then
								hp = max
							end

							self.Owner:SetHealth( hp )
						end
					end
				end
			end
		end
	end
	
	if self.GBlink > CurTime() then
		if self.SpecialUse then
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

		if self.QuickReturnUse then
			self.QuickReturnUse = false

			self.Owner:Blink( 0.5, 0 )
			self.Owner:Freeze( true )
			self.StopThink = true

			timer.Simple( 0.75, function()
				if IsValid( self ) then
					self.StopThink = false
				end
			end )

			self.Owner:SetPos( self.QuickReturn )
		end
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

function SWEP:Reload()
	if CLIENT or ROUND.preparing then return end
	if self.QuickReturnTime < CurTime() then return end
	
	self.QuickReturnTime = 0
	self.QuickReturnUse = true
end

function SWEP:CanTeleport()
	for k, v in pairs( FindInCylinder( self.Owner:GetPos(), 3000, -512, 512, nil, nil, player.GetAll() ) ) do
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

	local add = self:GetUpgradeMod( "specdist" ) or 0
	for k, v in pairs( FindInCylinder( ownerpos, 1500 + add, -512, 512, nil, nil, player.GetAll() ) ) do
		local t = v:SCPTeam()
		if t != TEAM_SPEC and t != TEAM_SCP then
			table.insert( players, v )
			near[v] = 0
			for k, ply in pairs( FindInCylinder( v:GetPos(), 500, -128, 128, nil, nil, player.GetAll() ) ) do
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
						self.QuickReturn = ownerpos
						self.QuickReturnTime = CurTime() + 15

						CenterMessage( "@WEAPONS.SCP173.back;time:5", self.Owner )

						return
					end
				end
			end
		end
	end

	self.NextSpecial = CurTime() + 3
	self:SetNSpecial( self.NextSpecial )
end

function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

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

AddSounds( "SCP173.Horror", "scp_lc/scp/173/horror/horror%i.ogg", 0, 1, 100, CHAN_STATIC, 0, 9 )
AddSounds( "SCP173.Rattle", "scp_lc/scp/173/rattle%i.ogg", 100, 1, 100, CHAN_STATIC, 1, 3 )
AddSounds( "SCP173.Snap", "scp_lc/scp/173/neck_snap%i.ogg", 511, 1, 100, CHAN_STATIC, 1, 3 )

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
	for k, v in pairs( SCPTeams.GetPlayersByTeam( TEAM_SCP ) ) do
		if v:SCPClass() == CLASSES.SCP173 then
			local wep = v:GetActiveWeapon()
			if IsValid( wep ) then
				wep.GBlink = CurTime() + time
			end
		end
	end
end )

hook.Add( "EntityTakeDamage", "SCP173DMGMod", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() and ent:SCPClass() == CLASSES.SCP173 then
		local wep = ent:GetActiveWeapon()
		if IsValid( wep ) and wep.UpgradeSystemMounted then
			local mod = wep:GetUpgradeMod( "dmg" )

			if mod then
				if dmg:IsDamageType( DMG_BULLET ) then
					dmg:ScaleDamage( mod )
				end
			end
		end
	end
end )

DefineUpgradeSystem( "scp173", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "specdist1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { specdist = 500 }, active = false },
		{ name = "specdist2", cost = 2, req = { "specdist1" }, reqany = false,  pos = { 1, 2 }, mod = { specdist = 1200 }, active = false },
		{ name = "specdist3", cost = 3, req = { "specdist2" }, reqany = false,  pos = { 1, 3 }, mod = { specdist = 2000 }, active = false },

		{ name = "boost1", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { cd = 0.9, heal = 150 }, active = false },
		{ name = "boost2", cost = 2, req = { "boost1" }, reqany = false,  pos = { 2, 2 }, mod = { cd = 0.75, heal = 300 }, active = false },
		{ name = "boost3", cost = 3, req = { "boost2" }, reqany = false,  pos = { 2, 3 }, mod = { cd = 0.5, heal = 500 }, active = false },

		{ name = "prot1", cost = 1, req = {}, reqany = false,  pos = { 3, 1 }, mod = { dmg = 0.9 }, active = true, group = "prot" },
		{ name = "prot2", cost = 1, req = { "prot1" }, reqany = false,  pos = { 3, 2 }, mod = { dmg = 0.8 }, active = true, group = "prot" },
		{ name = "prot3", cost = 4, req = { "prot2" }, reqany = false,  pos = { 3, 3 }, mod = { dmg = 0.6 }, active = true, group = "prot" },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = { -- ~55%-60%
		{ 1, 2 },
		{ 2, 1 },
		{ 3, 1 },
		{ 5, 2 },
		{ 7, 2 },
		{ 10, 2 }
	}
} )

function SWEP:OnUpgradeBought( name, info, group )
	if group == "prot" and self:CheckOwner() then
		local hp = self.Owner:Health() + 1000
		local max = self.Owner:GetMaxHealth()

		if hp > max then
			hp = max
		end

		self.Owner:SetHealth( hp )
	end
end

InstallUpgradeSystem( "scp173", SWEP )