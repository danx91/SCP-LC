SWEP.Base 				= "weapon_scp_base"
SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-3199"

SWEP.ViewModel 			= "models/weapons/alski/scp3199arms.mdl"
SWEP.ShouldDrawViewModel = true

SWEP.HoldType 			= "melee"

SWEP.Frenzy = 0
SWEP.Penalty = 0
SWEP.Tokens = 0
SWEP.FrenzyBaseDuration = 60

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Frenzy", "Float" )
	self:AddNetworkVar( "Penalty", "Float" )
	self:AddNetworkVar( "Tokens", "Int" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP3199" )


end

SWEP.NextIdle = 0
SWEP.NextTransmit = 0
SWEP.NextRegen = 0
function SWEP:Think()
	self:PlayerFreeze()

	local ct = CurTime()
	if self.NextIdle <= ct then
		local vm = self:GetOwner():GetViewModel()
		local seq, time = vm:LookupSequence( "idlearms" )

		self.NextIdle = ct + time
		vm:SendViewModelMatchingSequence( seq )
	end

	if SERVER then
		local owner = self:GetOwner()

		if self.Frenzy != 0 then
			if self.Frenzy < ct then
				self:StopFrenzy()
			else
				local regen = self:GetUpgradeMod( "regen" )
				if regen and self.NextRegen < ct then
					self.NextRegen = ct + ( 1 - ( self:GetUpgradeMod( "regentime" ) or 0 ) * self.Tokens )

					owner:AddHealth( regen )
				end

				if !self:GetUpgradeMod( "ddisable" ) and self.NextTransmit < ct then
					self.NextTransmit = ct + 1

					local pos = owner:GetPos()
					local tab = {}

					local radius = 2500 + ( self:GetUpgradeMod( "range" ) or 0 )
					local max_dist = radius * radius
					for k, v in pairs( player.GetAll() ) do
						if IsValid( v ) then
							if SCPTeams.HasInfo( v:SCPTeam(), SCPTeams.INFO_HUMAN ) then
								if !v:HasEffect( "deep_wounds" ) then
									if pos:DistToSqr( v:GetPos() ) <= max_dist then
										local pos = v:GetPos() + v:OBBCenter()
										table.insert( tab, {
											x = pos.x,
											y = pos.y,
											z = pos.z
										} )
									end
								end
							end
						end
					end

					if #tab > 0 then
						net.SendTable( "SCP3199_Frenzy", tab, owner )
					end
				end
			end
		end

		if self.Penalty != 0 and self.Penalty < ct then
			self.Penalty = 0
			self:SetPenalty( 0 )

			owner:PopSpeed( "SLC_SCP3199_Penalty" )
		end
	end
end

SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	local ct = CurTime()
	if !ROUND.post and !ROUND.preparing and self.NextAttack < ct and self:GetPenalty() == 0 then
		self.NextAttack = ct + 1

		local owner = self:GetOwner()

		owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )

		local vm = owner:GetViewModel()
		local seq = vm:SelectWeightedSequence( ACT_VM_PRIMARYATTACK )

		if seq > -1 then
			local dur = vm:SequenceDuration( seq )

			self.NextIdle = ct + dur
			vm:SendViewModelMatchingSequence( seq )
		end

		if SERVER then
			local start = owner:GetShootPos()

			owner:LagCompensation( true )

			local trace = util.TraceHull( {
				start = start,
				endpos = start + owner:GetAimVector() * 75,
				filter = owner,
				mins = Vector( -10, -10, -10 ),
				maxs = Vector( 10, 10, 10 ),
				mask = MASK_SHOT_HULL
			} )

			owner:LagCompensation( false )

			if !trace.Hit then
				owner:EmitSound( "Zombie.AttackMiss" )

				if self.Frenzy != 0 then
					self:StopFrenzy()
				end
			elseif trace.HitWorld then
				owner:EmitSound( "Zombie.AttackHit" )

				if self.Frenzy != 0 then
					self:StopFrenzy()
				end
			else
				local ent = trace.Entity
				if IsValid( ent ) then
					if ent:IsPlayer() then
						local team = ent:SCPTeam()
						if team != TEAM_SPEC and team != TEAM_SCP then
							owner:EmitSound( "Bounce.Flesh" )

							local dmg = math.random( 30, 40 )

							local has_deep_wounds = ent:HasEffect( "deep_wounds" )
							if has_deep_wounds then
								dmg = math.floor( dmg - 20 )
							end

							ent:TakeDamage( dmg, owner, owner )

							if self.Frenzy != 0 and has_deep_wounds then
								self:StopFrenzy()
							else
								ent:ApplyEffect( "deep_wounds", owner )
								local max_stacks = 5 + ( self:GetUpgradeMod( "stacks" ) or 0 )

								self.Tokens = self.Tokens + 1

								if self.Tokens > max_stacks then
									self.Tokens = max_stacks
								else
									owner:PushSpeed( 1.05, 1.05, -1, "SLC_SCP3199_Tokens_"..self.Tokens, 1 )
								end

								self:SetTokens( self.Tokens )

								local frenzy = self.FrenzyBaseDuration * ( self:GetUpgradeMod( "frenzy" ) or 1 )
								self.Frenzy = ct + frenzy
								self:SetFrenzy( self.Frenzy )
							end
						end
					else
						if self.Killed and ent:GetClass() == "slc_3199_egg" then
							if ent:NotActive() then
								self.Killed = false
								ent:SetActive( true )
							end
						end

						owner:EmitSound( "Zombie.AttackHit" )
						self:SCPDamageEvent( ent, 50 )
					end
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	local ct = CurTime()
	if !ROUND.post and self.NextAttack < ct and self:GetTokens() >= 5 then
		self.Frenzy = ct + 1.5
		self:SetFrenzy( self.Frenzy )

		self.NextAttack = ct + 1.5

		local owner = self:GetOwner()

		owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )

		local vm = owner:GetViewModel()
		local seq, dur = vm:LookupSequence( "armsattacksecondary" )

		if seq > -1 then
			self.NextIdle = ct + dur
			vm:SendViewModelMatchingSequence( seq )
		end

		if SERVER then
			AddTimer( "SCP3199SAttack_"..owner:SteamID64(), 1, 1, function( this, n )
				if IsValid( self ) and IsValid( owner ) then
					self:StopFrenzy()

					local start = owner:GetShootPos()

					owner:LagCompensation( true )

					local trace = util.TraceHull( {
						start = start,
						endpos = start + owner:GetAimVector() * 75,
						filter = owner,
						mins = Vector( -10, -10, -10 ),
						maxs = Vector( 10, 10, 10 ),
						mask = MASK_SHOT_HULL
					} )

					owner:LagCompensation( false )

					if trace.Hit then
						local ent = trace.Entity

						if IsValid( ent ) and ent:IsPlayer() then
							local team = ent:SCPTeam()
							if team != TEAM_SPEC and team != TEAM_SCP then
								if ent:HasEffect( "deep_wounds" ) then
									local dmg = DamageInfo()

									dmg:SetDamage( ent:Health() )
									dmg:SetDamageType( DMG_DIRECT )
									dmg:SetAttacker( owner )

									ent:TakeDamageInfo( dmg )
								else
									ent:ApplyEffect( "deep_wounds", owner )
									ent:TakeDamage( 75, owner, owner )
								end

								owner:EmitSound( "Zombie.AttackHit" )
							end
						end
					end
				end
			end )
		end
	end
end

/*function SWEP:StartFrenzy()

end*/

function SWEP:StopFrenzy()
	self.Tokens = 0
	self:SetTokens( 0 )

	self.Frenzy = 0
	self:SetFrenzy( 0 )

	local owner = self:GetOwner()

	for i = 1, 7 do
		owner:PopSpeed( "SLC_SCP3199_Tokens_"..i )
	end

	owner:PushSpeed( 0.2, 0.2, -1, "SLC_SCP3199_Penalty", 1 )
	self.Penalty = CurTime() + 5
	self:SetPenalty( self.Penalty )
end

function SWEP:TranslateActivity( act )
	if act == ACT_MP_WALK or act == ACT_MP_RUN then
		if self:GetFrenzy() != 0 then
			return ACT_HL2MP_RUN
		else
			return ACT_HL2MP_WALK
		end
	end

	if self.ActivityTranslate[act] != nil then
		return self.ActivityTranslate[act]
	end

	return -1
end

SWEP.FOVIncrease = 0
function SWEP:TranslateFOV( fov )
	if self:GetFrenzy() != 0 then
		self.FOVIncrease = math.Approach( self.FOVIncrease, 10, FrameTime() * 10 )
	elseif self.FOVIncrease > 0 then
		self.FOVIncrease = math.Approach( self.FOVIncrease, 0, FrameTime() * 10 )
	end

	if self.FOVIncrease > 0 then
		return fov + self.FOVIncrease
	end
end

hook.Add( "StartCommand", "SLCSCP3199Cmd", function( ply, cmd )
	if ply:SCPClass() == CLASSES.SCP3199 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			local ct = CurTime()

			if wep.GetPenalty then
				local p = wep:GetPenalty()
				if p > ct then
					local ang = cmd:GetViewAngles()

					if !wep.PenaltyPitch then
						wep.PenaltyPitch = ang.pitch
					end

					wep.PenaltyPitch = math.Approach( wep.PenaltyPitch, 50, FrameTime() * 15 )
					ang.pitch = wep.PenaltyPitch

					cmd:SetViewAngles( ang )
				elseif wep.PenaltyPitch then
					wep.PenaltyPitch = nil
				end
			end
		end
	end
end )

if SERVER then
	net.AddTableChannel( "SCP3199_Frenzy" )
end

if CLIENT then
	local color_white = Color( 255, 255, 255, 255 )
	local color_gray = Color( 170, 170, 170, 255 ) 

	local heart = Material( "slc/hud/scp/heart1.png" )
	local ico = Material( "slc/hud/scp/3199attack.png" )

	SWEP.DrawSpotted = 0
	function SWEP:DrawSCPHUD()
		local frenzy = self:GetFrenzy()
		if frenzy != 0 then
			local w, h = ScrW(), ScrH()
			local ct = CurTime()

			if self.FrenzySpotted and self.DrawSpotted >= ct then
				surface.SetDrawColor( Color( 255, 255, 255, 255 * ( self.DrawSpotted - ct ) ) )
				surface.SetMaterial( heart )
				for k, v in pairs( self.FrenzySpotted ) do
					local pos = Vector( v.x, v.y, v.z ):ToScreen()
					if pos.visible then
						surface.DrawTexturedRect( pos.x - w * 0.01, pos.y - w * 0.01, w * 0.02, w * 0.02 )
					end
				end
			end

			if frenzy >= ct then
				local frenzy_duration = self.FrenzyBaseDuration * ( self:GetUpgradeMod( "frenzy" ) or 1 )
				local f = ( frenzy - ct ) / frenzy_duration

				if f > 0 then
					surface.SetMaterial( ico )
					surface.SetDrawColor( color_white )
					surface.DrawTexturedRect( w * 0.48, h * 0.75, w * 0.04, w * 0.04 )


					draw.NoTexture()
					surface.SetDrawColor( color_gray )
					surface.DrawCooldownHollowRectCW( w * 0.48, h * 0.75, w * 0.04, w * 0.04, 10, f, HRCSTYLE_TRIANGLE_DYNAMIC )

					local tokens = self:GetTokens()
					draw.Text{
						text = tokens,
						pos = { w * 0.514, h * 0.75 + w * 0.032 },
						color = Color( 255, 255, 255 ),
						font = "SCPHUDSmall",
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER,
					}

					if tokens >= 5 and !self:GetUpgradeMod( "sdisable" ) then
						draw.Text{
							text = self.Lang.special,
							pos = { w * 0.5, h * 0.97 },
							color = Color( 0, 255, 0 ),
							font = "SCPHUDSmall",
							xalign = TEXT_ALIGN_CENTER,
							yalign = TEXT_ALIGN_CENTER,
						}
					end
				end
			end
		end
	end

	net.ReceiveTable( "SCP3199_Frenzy", function( data )
		local ply = LocalPlayer()
		ply:EmitSound( "SLCPlayer.Heartbeat" )

		local wep = ply:GetWeapon( "weapon_scp_3199" )
		if IsValid( wep ) then
			wep.DrawSpotted = CurTime() + 1
			wep.FrenzySpotted = data
		end
	end )
end

if SERVER then
	hook.Add( "DoPlayerDeath", "SCP3199Kills", function( ply, attacker, info )
		if IsValid( attacker ) and attacker:IsPlayer() and attacker:SCPClass() == CLASSES.SCP3199 then
		 	local wep = attacker:GetActiveWeapon()

		 	if IsValid( wep ) then
		 		wep.Killed = true
		 		wep:AddScore( 1 )
		 		AddRoundStat( "3199" )
		 	end
		end
	end )

	hook.Add( "EntityTakeDamage", "SCP3199Damage", function( target, dmg )
		if IsValid( target ) and target:IsPlayer() then
			if target:SCPClass() == CLASSES.SCP3199 then
				if dmg:GetDamage() >= target:Health() then
					local wep = target:GetActiveWeapon()

					if IsValid( wep ) then
						local tab = GetRoundProperty( "3199_eggs" )

						if tab and #tab > 0 then
							local egg

							for i = 1, #tab do
								local e = tab[i]
								if IsValid( e ) and e:GetActive() then
									egg = e
									break
								end
							end

							if egg then
								egg:SetActive( false )
								egg.Locked = target
								egg.LockedSignature = target:TimeSignature()

								target:SetProperty( "3199_respawn", egg )
								target:SetStasis( wep:GetUpgradeMod( "stasis" ) or 50 )
								target:SpectateEntity( egg )

								return true
							end
						end
					end
				end
			end
		end
	end )

	hook.Add( "SLCPlayerStasisStart", "SLCSCP3199Stasis", function( ply, data )
		if ply:SCPClass() == CLASSES.SCP3199 then
			data.health = data.max_health
		end
	end )

	hook.Add( "SLCPlayerStasisEnd", "SLCSCP3199Stasis", function( ply, data )
		if ply:SCPClass() == CLASSES.SCP3199 then
			local egg = ply:GetProperty( "3199_respawn" )

			if IsValid( egg ) then
				ply:SetPos( egg:GetPos() )

				egg:Destroy()
			end
		end
	end )
end

DefineUpgradeSystem( "scp3199", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "regen1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { regen = 2 }, active = false }, --taste of blood
		{ name = "regen2", cost = 2, req = { "regen1" }, reqany = false,  pos = { 1, 2 }, mod = { regentime = 0.1 }, active = false },

		{ name = "frenzy1", cost = 2, req = {}, reqany = false,  pos = { 2, 1 }, mod = { stacks = 1, frenzy = 1.2 }, active = false }, --huntr's game
		{ name = "frenzy2", cost = 4, req = { "frenzy1" }, reqany = false,  pos = { 2, 2 }, mod = { stacks = 2, frenzy = 1.5, range = 500, sdisable = true }, active = false },
		
		{ name = "egg1", cost = 3, req = {}, reqany = false,  pos = { 3, 1 }, mod = {}, active = true },
		{ name = "egg2", cost = 3, req = {}, reqany = false,  pos = { 4, 1 }, mod = {}, active = true },
		{ name = "egg3", cost = 1, req = { "egg1", "egg2" }, reqany = true,  pos = { 3, 2 }, mod = { stasis = 20 }, active = false },


		{ name = "ch", cost = 5, req = {}, reqany = false,  pos = { 2, 3 }, mod = { ddisable = true }, active = 1.25 }, --blind fury

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = { -- ~55%-60% --8 + 1
		{ 1, 1 },
		{ 2, 1 },
		{ 3, 2 },
		{ 4, 2 },
		{ 6, 2 },
	}
} )

function SWEP:OnUpgradeBought( name, info, group )
	if SERVER then
		if name == "ch" and self:CheckOwner() then
			self:GetOwner():PushSpeed( info, info, -1, "SLCSCP3199Upgrade", 1 )
		elseif name == "egg1" then
			SpawnSCP3199Eggs( 1 )
		elseif name == "egg2" then
			local tab = GetRoundProperty( "3199_eggs" )

			if tab then
				for k, v in pairs( tab ) do
					if v:NotActive() then
						v:SetActive( true )
						break
					end
				end
			end
		end			
	end
end

InstallUpgradeSystem( "scp3199", SWEP )