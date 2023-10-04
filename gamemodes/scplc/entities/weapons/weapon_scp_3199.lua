SWEP.Base 				= "weapon_scp_base"
SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-3199"

SWEP.ViewModel 			= "models/weapons/alski/scp3199arms.mdl"
SWEP.ShouldDrawViewModel = true

SWEP.HoldType 			= "melee"

SWEP.ScoreOnDamage = true
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
	self:SwingThink()

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
						if !IsValid( v ) or !self:CanTargetPlayer( v ) or v:HasEffect( "deep_wounds" ) or pos:DistToSqr( v:GetPos() ) > max_dist then continue end
						
						local cpos = v:GetPos() + v:OBBCenter()
						table.insert( tab, {
							x = cpos.x,
							y = cpos.y,
							z = cpos.z
						} )
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

local paths = {
	[1] = {
		Vector( 0, 8, -2 ),
		Vector( 0, -8, 3 ),
		-20,
		20,
	},
	[2] = {
		Vector( 0, -8, -2 ),
		Vector( 0, 8, 3 ),
		20,
		-20,
	},
	spec = {
		Vector( 0, 0, 0 ),
		Vector( 10, 0, 0 ),
		0,
		0,
	},
}

local mins, maxs = Vector( -1, -1, -1 ), Vector( 1, 1, 1 )
local mins_str, maxs_str = Vector( -1, -6, -6 ), Vector( 1, 6, 6 )

SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	local ct = CurTime()
	if ROUND.post or ROUND.preparing or self.NextAttack > ct or self:GetPenalty() != 0 then return end
	self.NextAttack = ct + 0.5

	local owner = self:GetOwner()

	owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )

	local vm = owner:GetViewModel()
	local seq = self.LastSeq == 1 and 2 or 1
	self.LastSeq = seq

	if seq > -1 then
		local dur = vm:SequenceDuration( seq )

		self.NextIdle = ct + dur
		vm:SendViewModelMatchingSequence( seq )
	end

	local any_hit = false
	local ent_filter = {}
	local path = paths[seq]

	self:SwingAttack( {
		path_start = path[1],
		path_end = path[2],
		fov_start = path[3],
		fov_end = path[4],
		delay = 0.2,
		duration = 0.25,
		num = 8,
		dist_start = 75,
		dist_end = 50,
		mins = mins,
		maxs = maxs,
		on_start = function()
			self:EmitSound( "Zombie.AttackMiss" )
		end,
		callback = function( trace, id )
			if trace.HitWorld then
				self:EmitSound( "Zombie.AttackHit" )
				return true, id < 4 and {
					distance = 65,
					bounds = 2.5,
				}
			end

			local ent = trace.Entity
			if !IsValid( ent ) or ent_filter[ent] then return end

			ent_filter[ent] = true

			if ent:IsPlayer() then
				self:EmitSound( "Bounce.Flesh" )

				if CLIENT or !self:CanTargetPlayer( ent ) then return end

				local dmg = math.random( 30, 40 )

				local has_deep_wounds = ent:HasEffect( "deep_wounds" )
				if has_deep_wounds then
					dmg = math.floor( dmg - 25 )
				end

				SuppressHostEvents( NULL )
				ent:TakeDamage( dmg, owner, owner )
				SuppressHostEvents( owner )

				if self.Frenzy == 0 or !has_deep_wounds then
					any_hit = true
					ent:ApplyEffect( "deep_wounds", owner )

					self.Tokens = self.Tokens + 1
					
					local max_stacks = 5 + ( self:GetUpgradeMod( "stacks" ) or 0 )
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
			else
				self:EmitSound( "Zombie.AttackHit" )
				
				if self.Killed and ent:GetClass() == "slc_3199_egg" then
					any_hit = true
					
					if SERVER and ent:NotActive() then
						self.Killed = false
						ent:SetActive( true )
					end
				end

				if SERVER then
					SuppressHostEvents( NULL )
					self:SCPDamageEvent( ent, 50 )
					SuppressHostEvents( owner )
				end
			end
		end,
		on_end = function()
			if !any_hit then
				if self.Frenzy != 0 then
					self:StopFrenzy()
				end
			end
		end 
	} )
end

function SWEP:SecondaryAttack()
	local ct = CurTime()
	if ROUND.post or self.NextAttack > ct or self:GetTokens() < 5 then return end
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

	local path = paths.spec
	self:SwingAttack( {
		path_start = path[1],
		path_end = path[2],
		fov_start = path[3],
		fov_end = path[4],
		delay = 0.65,
		duration = 0.5,
		num = 6,
		distance = 50,
		mins = mins_str,
		maxs = maxs_str,
		on_start = function()
			self:EmitSound( "Zombie.AttackMiss" )
		end,
		callback = function( trace, id )
			local ent = trace.Entity
			if !IsValid( ent ) or !ent:IsPlayer() or !self:CanTargetPlayer( ent ) then return end

			self:EmitSound( "Zombie.AttackHit" )

			if CLIENT then return true end

			if ent:HasEffect( "deep_wounds" ) then
				local dmg = DamageInfo()

				dmg:SetDamage( ent:Health() )
				dmg:SetDamageType( DMG_DIRECT )
				dmg:SetAttacker( owner )

				SuppressHostEvents( NULL )
				ent:TakeDamageInfo( dmg )
				SuppressHostEvents( owner )
			else
				ent:ApplyEffect( "deep_wounds", owner )
				SuppressHostEvents( NULL )
				ent:TakeDamage( 75, owner, owner )
				SuppressHostEvents( owner )
			end

			return true
		end,
		on_end = function()
			self:StopFrenzy()
		end
	} )
end

function SWEP:StopFrenzy()
	if !SERVER then return end
	
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

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "3199" )
	self.Killed = true
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

SCPHook( "SCP3199", "StartCommand", function( ply, cmd )
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

SCPHook( "SCP3199", "SLCMovementAnimSpeed", function( ply, vel, speed, len, movement )
	if ply:SCPClass() == CLASSES.SCP3199 then
		local n = len / 75

		if n < 1.5 then
			n = 1.5
		end

		return n, true
	end
end )

if SERVER then
	net.AddTableChannel( "SCP3199_Frenzy" )
end

if CLIENT then
	local color_white = Color( 255, 255, 255 )
	local color_gray = Color( 170, 170, 170 ) 
	local color_green = Color( 0, 255, 0 )

	local heart = Material( "slc/hud/scp/heart1.png" )
	local ico = Material( "slc/hud/scp/3199attack.png" )

	SWEP.DrawSpotted = 0
	function SWEP:DrawSCPHUD()
		local frenzy = self:GetFrenzy()
		if frenzy != 0 then
			local w, h = ScrW(), ScrH()
			local ct = CurTime()

			if self.FrenzySpotted and self.DrawSpotted >= ct then
				surface.SetDrawColor( 255, 255, 255, 255 * ( self.DrawSpotted - ct ) )
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
						color = color_white,
						font = "SCPHUDSmall",
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER,
					}

					if tokens >= 5 and !self:GetUpgradeMod( "sdisable" ) then
						draw.Text{
							text = self.Lang.special,
							pos = { w * 0.5, h * 0.97 },
							color = color_green,
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
	SCPHook( "SCP3199", "EntityTakeDamage", function( target, dmg )
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

	SCPHook( "SCP3199", "SLCPlayerStasisStart", function( ply, data )
		if ply:SCPClass() == CLASSES.SCP3199 then
			data.health = data.max_health
		end
	end )

	SCPHook( "SCP3199", "SLCPlayerStasisEnd", function( ply, data )
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

		{ name = "outside_buff", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = { -- ~55%-60% --8 + 1
		{ 100, 1 },
		{ 200, 1 },
		{ 350, 2 },
		{ 500, 2 },
		{ 750, 2 },
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
					if IsValid( v ) and v:NotActive() then
						v:SetActive( true )
						break
					end
				end
			end
		end			
	end
end

InstallUpgradeSystem( "scp3199", SWEP )