SWEP.Base 				= "weapon_scp_base"
//SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-096"

SWEP.HoldType 			= "normal"

/*
0	ragdoll					24		ACT_DIERAGDOLL --nothing
10	IDLE_STIMULATED			78		ACT_IDLE_STIMULATED --standing up, arms to head
9	IDLE_AGITATED			79		ACT_IDLE_AGITATED -worse version of angry
5	IDLETORUN				505		ACT_IDLETORUN --pretty useless, stay -> run

3	COWER					61		ACT_COWER --covering head
8	IDLE_RELAXED			77		ACT_IDLE_RELAXED --standing up

1	idle					1		ACT_IDLE --idle
4	walk					6		ACT_WALK --walk
6	RUN						10		ACT_RUN --run arms back
7	RUN_CROUCH				12		ACT_RUN_CROUCH --run arms forward
2	CROUCHIDLE				46		ACT_CROUCHIDLE --sit
11	IDLE_ANGRY				76		ACT_IDLE_ANGRY --idel angry
12	GESTURE_MELEE_ATTACK1	139		ACT_GESTURE_MELEE_ATTACK1 --run to short attack
13	GESTURE_FLINCH_HEAD		150		ACT_GESTURE_FLINCH_HEAD --run to meele attacks
*/

SWEP.NewAct = {
	[ACT_MP_STAND_IDLE] = ACT_IDLE,
	[ACT_MP_WALK] = ACT_WALK,
	[ACT_MP_RUN] = ACT_RUN,
	[ACT_MP_CROUCH_IDLE] = ACT_IDLE,
	[ACT_MP_CROUCHWALK] = ACT_WALK,
	//[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_,
	//[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_,
	//[ACT_MP_RELOAD_STAND] = ACT_,
	//[ACT_MP_RELOAD_CROUCH] = ACT_,
	[ACT_MP_JUMP] = ACT_IDLE,
	//[ACT_RANGE_ATTACK1] = ACT_GESTURE_MELEE_ATTACK1,
	//[ACT_MP_SWIM] = ACT_,
}

SWEP.ChaseSound = "scp/096/chase.ogg"
SWEP.TriggeredSound = "scp/096/triggered.ogg"

SWEP.Regen = false
SWEP.RegenPrep = 0
SWEP.RegenPost = 0

SWEP.RegenCharges = 0
SWEP.RegenCD = 0

SWEP.Enraged = false
SWEP.Preparing = 0
SWEP.Lunge = 0
SWEP.Exhaust = 0
SWEP.Cooldown = 0
SWEP.PostAttack = 0

SWEP.Scream = 0
SWEP.AttackSound = 0

SWEP.NRageCheck = 0
function SWEP:SetupDataTables() --networking animation info
	self:AddNetworkVar( "Regen", "Bool" )
	self:AddNetworkVar( "Enraged", "Bool" )
	self:AddNetworkVar( "AttackState", "Bool" )

	self:AddNetworkVar( "RegenPrep", "Float" )
	self:AddNetworkVar( "Preparing", "Float" )
	self:AddNetworkVar( "Lunge", "Float" )
	self:AddNetworkVar( "AttackFinish", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP096" )

	self.RegenCD = CurTime()

	self.Preys = {}

	if SERVER then
		self.SoundPlayers = {}
	end

	if CLIENT then
		self.HaloTable = {}
	end
end		

function SWEP:ResetState()
	for k, v in pairs( self.Preys ) do
		if IsValid( k ) then
			k:SetSCP096Chase( false )
			TransmitSound( self.ChaseSound, false, k )
		end
	end

	self.Preys = {}

	self.Enraged = false
	self:SetEnraged( false )

	self.Lunge = 0
	self:SetLunge( 0 )

	self.Scream = 0
	self:StopSound( "SCP096.Scream" )
	self:StopSound( "SCP096.Attack1" )

	local owner = self:GetOwner()
	owner:PopSpeed( "SLC_SCP096_Lunge" )
	owner:PopSpeed( "SLC_SCP096" )
end

SWEP.NRageThink = 0
SWEP.NLungeThink = 0
function SWEP:Think()
	local ct = CurTime()
	local owner = self:GetOwner()

	if self.Regen then
		if self.RegenPrep < ct and self.RegenCD < ct then
			self.RegenCD = ct + 0.25 - ( self:GetUpgradeMod( "chargesusage" ) or 0 )
			self.RegenCharges = self.RegenCharges - 1
			local hp = owner:Health() + 5 + ( self:GetUpgradeMod( "chargesheal" ) or 0 )
			local maxhp = owner:GetMaxHealth()
			
			if SERVER then
				if hp > maxhp then
					hp = maxhp
				end

				owner:SetHealth( hp )
			end

			if self.RegenCharges <= 0 or hp >= maxhp then
				self.Regen = false
				self:SetRegen( false )

				self.RegenPost = ct + 1
				self.RegenCD = ct + 5
			end
		end
	elseif self.RegenCD < ct then
		self.RegenCD = ct + 5 - ( self:GetUpgradeMod( "chargescd" ) or 0 )
		self.RegenCharges = self.RegenCharges + 1
	end

	if SERVER and !self.Regen then
		if self.NRageThink < ct and self.Cooldown < ct then
			self.NRageThink = ct + 1

			for k, v in pairs( player.GetAll() ) do
				if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
					if owner:TestVisibility( v, nil, true ) then
						if self.Preys[v] == nil then
							self.Preys[v] = true
							--print( "1st tick", v )
						elseif self.Preys[v] == true then
							--print( "2nd tick", v )

							local pos = v:GetPos()

							if !self.Enraged then
								--print( "Enraged, prep start" )
								self.Enraged = true
								self:SetEnraged( true )

								self.Preparing = ct + 4
								self:SetPreparing( self.Preparing )

								TransmitSound( self.TriggeredSound, true, v )

								owner:Freeze( true )
							end

							local chasedist = self:GetUpgradeMod( "distance" ) or 3000
							local dist = pos:Distance( owner:GetPos() )
							if dist < chasedist then
								dist = chasedist
							end

							dist = dist + 250
							self.Preys[v] = { pos, dist * dist, 0 }
							v:SetSCP096Chase( true )
						end
					elseif self.Preys[v] == true then
						--print( "canceled", v )
						self.Preys[v] = nil
					end
				end
			end

			if self.Enraged and self.Preparing < ct then
				if self.Preparing != 0 then
					self.Preparing = 0

					self.Scream = ct + 10
					owner:EmitSound( "SCP096.Scream" )

					owner:Freeze( false )
					owner:PushSpeed( 285, 285, -1, "SLC_SCP096", 1 )
					--print( "prep end, fully enraged" )
				else
					local count = 0
					local postab = {}
					for k, v in pairs( self.Preys ) do
						if istable( v ) then
							if !IsValid( k ) or !k:Alive() then
								--print( "removeing player due invalid or dead player", k )
								self.Preys[k] = nil

								if IsValid( k ) then
									k:SetSCP096Chase( false )
									TransmitSound( self.ChaseSound, false, k )
								end
							else
								local t = k:SCPTeam()
								if t == TEAM_SPEC or t == TEAM_SCP then
									--print( "removeing player due invalid team", k )
									self.Preys[k] = nil
									k:SetSCP096Chase( false )
									TransmitSound( self.ChaseSound, false, k )
								else
									local maxdist = self:GetUpgradeMod( "distsqr" ) or 9000000
									if v[1]:DistToSqr( k:GetPos() ) > maxdist or v[1]:DistToSqr( owner:GetPos() ) > v[2] then
										--print( "removeing player due to distance", k, v[1]:DistToSqr( k:GetPos() ) > maxdist, v[1]:DistToSqr( owner:GetPos() ) > v[2] )
										self.Preys[k] = nil
										k:SetSCP096Chase( false )
										TransmitSound( self.ChaseSound, false, k )
									else
										count = count + 1
										postab[k] = k:GetPos() + k:OBBCenter()

										if v[3] < ct then
											v[3] = ct + 12
											TransmitSound( self.ChaseSound, true, k )
										end
									end
								end
							end
						end
					end

					if count == 0 and self.Lunge == 0 then
						--print( "no players! rage end" )
						self.Cooldown = ct + 10
						self:ResetState()
					else
						net.Start( "SLCSCP096Pos" )
						net.WriteTable( postab )
						net.Send( owner )
					end
				end
			end
		end

		if self.Lunge != 0 then
			if self.NLungeThink < ct then
				self.NLungeThink = ct + 0.1

			 	if self.Lunge < ct then
			 		--print( "lunge end, exhausted" )

			 		self:ResetState()
					self.Exhaust = ct + 10
					self.Cooldown = ct + 15
					self:SetAttackFinish( ct + 5 )
					self:SetAttackState( true )

					owner:PushSpeed( 0.25, 0.25, -1, "SLC_SCP096_Exhaust", 1 )
				else
					local start = owner:GetShootPos()
					local forward = owner:EyeAngles():Forward()

					local filter = {}
					for k, v in pairs( player.GetAll() ) do
						if !self.Preys[v] then
							table.insert( filter, v )
						end
					end

					owner:LagCompensation( true )

					local trace = util.TraceHull{
						start = start - forward * 15,
						endpos = start + forward * 75,
						mask = MASK_SHOT,
						filter = filter,
						mins = Vector( -4, -4, -4 ),
						maxs = Vector( 4, 4, 4 ),
					}

					owner:LagCompensation( false )

					local ent = trace.Entity
					if trace.Hit and IsValid( ent ) and ent:IsPlayer() then
						local t = ent:SCPTeam()
						if t != TEAM_SPEC and t != TEAM_SCP then
							SanityEvent( 30, SANITY_TYPE.ANOMALY, ent:GetPos(), 2000, owner, ent )

							local dmg = DamageInfo()
							dmg:SetDamage( ent:Health() )
							dmg:SetDamageType( DMG_DIRECT )
							dmg:SetAttacker( owner )

							SuppressNextSanityEvent()
							ent:TakeDamageInfo( dmg )
							UnsuppressSanityEvent()

							AddRoundStat( "096" )
							self:AddScore( 1 )

							self:ResetState()

							local time = 5
							local seq = owner:SelectWeightedSequence( ACT_GESTURE_FLINCH_HEAD )
							if seq then
								time = owner:SequenceDuration( seq )
							end

							self.Cooldown = ct + time + 10
							self.PostAttack = ct + time
							self:SetAttackFinish( self.PostAttack )

							--print( time )
							owner:DoAnimationEvent( ACT_GESTURE_FLINCH_HEAD )
							//owner:SendLua( "LocalPlayer():DoAnimationEvent( ACT_GESTURE_FLINCH_HEAD )" )

							owner:EmitSound( "SCP096.Attack1" )
							self.AttackSound = ct + 4

							local regenmod = self:GetUpgradeMod( "regenmod" ) or 0
							owner:AddHealth( 150 + regenmod )
							Timer( "SCP096_Regen_"..owner:SteamID64(), 2, 2, function( this, n )
								if IsValid( self ) and self:CheckOwner() then
									owner:AddHealth( 75 + regenmod )
								end
							end, function( this )
								if IsValid( ent ) and IsValid( ent._RagEntity ) then
									ent._RagEntity:Remove()
								end
								/*if IsValid( ent ) then
									local rag = ent:GetRagdollEntity()
									if IsValid( rag ) then
										rag:Remove()
									end
								end*/
							end )
						end
					end
				end
			end
		end

		if self.Exhaust != 0 and self.Exhaust < ct then
			--print( "exhaust end" )
			self.Exhaust = 0
			self:SetAttackState( false )

			owner:PopSpeed( "SLC_SCP096_Exhaust" )
		end

		if self.Scream != 0 and self.Scream <= ct then
			self.Scream = ct + 10

			owner:EmitSound( "SCP096.Scream" )
		end

		if self.AttackSound != 0 and self.AttackSound < ct then
			self.AttackSound = 0
			owner:EmitSound( "SCP096.Attack2" )
		end
	end
end

function SWEP:PrimaryAttack()
	if ROUND.preparing then return end
	
	//self.Owner:DoAnimationEvent( ACT_IDLE_STIMULATED )
	if SERVER and self.Enraged and self.Lunge == 0 then
		self.Lunge = CurTime() + 2
		self:SetLunge( self.Lunge )

		self:GetOwner():PushSpeed( 1.25, 1.25, -1, "SLC_SCP096_Lunge", 1 )
		--print( "lunge started" )
	end
end

SWEP.NSecondary = 0
function SWEP:SecondaryAttack()
	if ROUND.preparing then return end
	
	if self.PrimaryCD > CurTime() then return end
	self.PrimaryCD = CurTime() + 0.5

	if SERVER then
		local spos = self.Owner:GetShootPos()

		local trace = util.TraceLine{
			start = spos,
			endpos = spos + self.Owner:GetAimVector() * 70,
			filter = self.Owner,
			mask = MASK_SHOT,
		}

		local ent = trace.Entity
		if IsValid( ent ) then
			if !ent:IsPlayer() then
				self:SCPDamageEvent( ent, self.Enraged and 250 or 50 )
			end
		end
	end
end

SWEP.a = 0
function SWEP:Reload()
	if ROUND.preparing then return end

	local ct = CurTime()
	if self.NSecondary > ct or self:GetEnraged() or self:GetAttackFinish() > ct then return end
	self.NSecondary = ct + 1

	if self.Regen then
		self.Regen = false
		self:SetRegen( false )

		self.RegenPost = ct + 1
		self.RegenCD = ct + 5
	elseif self.RegenCharges > 0 then
		local owner = self:GetOwner()
		if owner:Health() < owner:GetMaxHealth() then
			owner:SetCycle( 0 )

			self.Regen = true
			self:SetRegen( true )

			self.RegenPrep = ct + 3
			self:SetRegenPrep( self.RegenPrep )

			self.RegenAngles = nil
		end
	end
end

function SWEP:OnRemove()
	if SERVER then
		self:ResetState()
	end
end

function SWEP:TranslateActivity( act )
	if act == ACT_MP_RUN and self:GetLunge() > CurTime() then
		return ACT_RUN_CROUCH
	end

	return self.NewAct[act] or -1
end

SWEP.AttackPitch = 0
function SWEP:CalcView( ply, pos, ang, fov )
	local ct = CurTime()
	if self.Regen then
		local f = 3 - math.Clamp( self.RegenPrep - ct, 2, 3 )

		ang.p = Lerp( f, ang.p, 45 )
		return pos - Vector( 0, 0, f * 24 )
	elseif wep.RegenPost > ct then
		local f = math.Clamp( self.RegenPost - ct, 0, 1 )

		ang.p = Lerp( f, ang.p, 45 )
		return pos - Vector( 0, 0, f * 24 )
	end

	local af = self:GetAttackFinish()
	if af > ct then
		if self.AttackPitch < 1 then
			self.AttackPitch = self.AttackPitch + FrameTime() * 1.75
			if self.AttackPitch > 1 then
				self.AttackPitch = 1
			end
		end
	elseif self.AttackPitch > 0 then
		self.AttackPitch = self.AttackPitch - FrameTime() * 1.75
		if self.AttackPitch < 0 then
			self.AttackPitch = 0
		end
	end

	if self.AttackPitch > 0 then
		ang.p = Lerp( self.AttackPitch, ang.p, 75 )
		return pos - Vector( 0, 0, self.AttackPitch * 28 )
	end
end

SWEP.TableDieTime = 0
function SWEP:DrawSCPHUD()
	draw.Text( {
		text = string.format( self.Regen and self.Lang.regen or self.Lang.charges, self.RegenCharges ),
		pos = { ScrW() * 0.5, ScrH() * 0.97 },
		font = "SCPHUDSmall",
		color = Color( 0, 255, 0 ),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	if self.TableDieTime > CurTime() then
		local pos = LocalPlayer():GetPos()
		surface.SetDrawColor( Color( 255, 0, 0 ) )
		draw.NoTexture()
		for k, v in pairs( self.Preys ) do
			local dist = pos:DistToSqr( v )
			if dist > 160000 then
				local scr = v:ToScreen()
				if scr.visible then
					--surface.DrawRect( scr.x - 8, scr.y - 8, 16, 16 )
					surface.DrawRing( scr.x, scr.y, 12, 5, 360, 10, 1 )
				end
			else
				table.insert( self.HaloTable, k )
			end
		end
	end
end

hook.Add( "EntityTakeDamage", "SCP066DMGMod", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() and ent:SCPClass() == CLASSES.SCP096 then
		local wep = ent:GetActiveWeapon()
		if IsValid( wep ) then
			if dmg:IsDamageType( DMG_BULLET ) and wep.UpgradeSystemMounted then
				local def = wep:GetUpgradeMod( "def" )
				if def then
					dmg:ScaleDamage( def )
				end
			end

			if wep.PostAttack > CurTime() then
				dmg:ScaleDamage( 0.4 )
			end
		end
	end
end )

hook.Add( "CalcMainActivity", "SLCSCP096Act", function( ply, vel )
	if ply:SCPClass() == CLASSES.SCP096 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			local ct = CurTime()
			if wep.GetPreparing and wep:GetPreparing() > ct then
				//elseif wep.GetEnraged and wep:GetEnraged() then
				//if wep:GetPreparing() > CurTime() then
					return ACT_IDLE_ANGRY, -1
				//end
			elseif wep.GetAttackFinish then
				local af = wep:GetAttackFinish()
				if wep:GetAttackState() and af > ct then
					local f = ( af - ct - 4.75 ) * 3

					if f > 0 then
						if f > 0.75 then
							f = 0.75
						end

						ply:SetCycle( 0.75 - f )
					else
						ply:SetCycle( 0.75 )
					end

					return ACT_GESTURE_MELEE_ATTACK1, -1
				end
			elseif wep.GetRegen and wep:GetRegen() then
				local rp = wep:GetRegenPrep()
				if rp < ct then
					ply:SetCycle( 0.5 )
				else
					ply:SetCycle( 0.5 - (rp - ct) / 6 )
				end

				return ACT_COWER, -1
			/*elseif wep.RegenPost > ct then
				local cyc = 1 - (wep.RegenPost - ct)
				ply:SetCycle( cyc )
				print( "standing up", cyc )
				return ACT_IDLE_RELAXED, -1*/
			end

			/*if vel:LengthSqr() > 0 and wep.GetLunge then
				local lunge = wep:GetLunge()
				if lunge > CurTime() then
					return
				end
			end*/
		end
	end
end )

//SWEP.AttackAngle
hook.Add( "StartCommand", "SLCSCP096Cmd", function( ply, cmd )
	if ply:SCPClass() == CLASSES.SCP096 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			local ct = CurTime()

			if wep.Regen or wep.RegenPost and wep.RegenPost > ct then
				if !wep.RegenAngles then
					wep.RegenAngles = cmd:GetViewAngles()
				end

				cmd:ClearMovement()
				cmd:SetViewAngles( wep.RegenAngles )
			end

			if wep.GetAttackFinish then
				local af = wep:GetAttackFinish()
				if af > ct then
					if !wep.AttackAngle then
						wep.AttackAngle = cmd:GetViewAngles()
					end

					cmd:ClearMovement()
					cmd:SetViewAngles( wep.AttackAngle )
				elseif wep.AttackAngle then
					wep.AttackAngle = nil
				end
			end
		end
	end
end )

if SERVER then
	util.AddNetworkString( "SLCSCP096Pos" )
end

if CLIENT then
	net.Receive( "SLCSCP096Pos", function( len )
		local ply = LocalPlayer()
		if ply:SCPClass() == CLASSES.SCP096 then
			local wep = ply:GetActiveWeapon()
			//if wep:GetClass() == "weapon_scp_096" then
				wep.Preys = net.ReadTable()
				wep.TableDieTime = CurTime() + 1.5
			//end
		end
	end )

	hook.Add( "PreDrawHalos", "SLCSCP096Halos", function()
		local ply = LocalPlayer()
		if ply:SCPClass() == CLASSES.SCP096 then
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) then
				if #wep.HaloTable > 0 then
					halo.Add( wep.HaloTable, Color( 255, 0, 0 ), 3, 3, 1, true, true )
					wep.HaloTable = {}
				end
			end
		end
	end )

	local overlay = GetMaterial( "slc/scp/096overlay" )
	hook.Add( "SLCScreenMod", "SLCSCP096", function( clr )
		local ply = LocalPlayer()

		if ply:SCPClass() == CLASSES.SCP096 then
			local wep = ply:GetActiveWeapon()

			if IsValid( wep ) and wep:GetEnraged() then
				surface.SetMaterial( overlay )
				surface.SetDrawColor( Color( 255, 0, 0, 150 ) )
				surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

				clr.colour = clr.colour
				clr.brightness = clr.brightness
				clr.contrast = clr.contrast + 0.15
				clr.add_g = -0.02
				clr.add_r = -0.0
				clr.add_b = -0.02
				clr.mul_r = 0.2
			end
		end
	end )
end

sound.Add{
	name = "SCP096.Attack1",
	volume = 1,
	level = 80,
	pitch = 100,
	sound = "scp/096/attack1.ogg",
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP096.Attack2",
	volume = 1,
	level = 80,
	pitch = 100,
	sound = "scp/096/attack2.ogg",
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SCP096.Scream",
	volume = 1,
	level = 100,
	pitch = 100,
	sound = "scp/096/scream.ogg",
	channel = CHAN_STATIC,
}

DefineUpgradeSystem( "scp096", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "sregen1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { chargescd = 1 }, active = false },
		{ name = "sregen2", cost = 2, req = { "sregen1" }, reqany = false,  pos = { 1, 2 }, mod = { chargesheal = 1 }, active = false },
		{ name = "sregen3", cost = 4, req = { "sregen2" }, reqany = false,  pos = { 1, 3 }, mod = { chargesusage = 0.1 }, active = false },

		{ name = "kregen1", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { regenmod = 30 }, active = false },
		{ name = "kregen2", cost = 2, req = { "kregen1" }, reqany = false,  pos = { 2, 2 }, mod = { regenmod = 60 }, active = false },

		{ name = "hunt1", cost = 4, req = {}, reqany = false,  pos = { 3, 1 }, mod = { distance = 4250, distsqr = 18062500 }, active = false },
		{ name = "hunt2", cost = 6, req = { "hunt1" }, reqany = false,  pos = { 3, 2 }, mod = { distance = 5500, distsqr = 30250000 }, active = false },

		{ name = "hp", cost = 3, req = {}, reqany = false,  pos = { 4, 1 }, mod = {}, active = 1000 },
		{ name = "def", cost = 5, req = { "hp" }, reqany = false,  pos = { 4, 2 }, mod = { def = 0.7 }, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 3 }, mod = {}, active = false },
	},
	rewards = { --16 + 1
		{ 1, 1 },
		{ 2, 2 },
		{ 3, 2 },
		{ 4, 1 },
		{ 5, 2 },
		{ 6, 1 },
		{ 7, 2 },
		{ 8, 2 },
		{ 10, 3 },
	}
} )

function SWEP:OnUpgradeBought( name, data, group )
	if SERVER and name == "hp" then
		if self:CheckOwner() then
			local owner = self:GetOwner()
			owner:SetMaxHealth( owner:GetMaxHealth() + data )
		end
	end
end

InstallUpgradeSystem( "scp096", SWEP )