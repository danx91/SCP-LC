SWEP.Base 				= "weapon_scp_base"
SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-2427-3"

SWEP.HoldType 			= "melee"

function SWEP:SetupDataTables()
	self:AddNetworkVar( "MindControl", "Int" )
	self:AddNetworkVar( "MindControlPenalty", "Int" )
	self:AddNetworkVar( "MindControlTarget", "Entity" )
	//self:AddNetworkVar( "MindControlEnabled", "Bool" ) --only for manual stop purpose
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP24273" )

	self.MindControlBuffer = {}
end		

SWEP.PopSpeed = 0 --TODO: move all to networkvars (?)
SWEP.PrepareMindControl = 0
SWEP.EnableDash = false
SWEP.NTargetTrace = 0
SWEP.NDistCheck = 0
function SWEP:Think()
	self:PlayerFreeze()
	
	local ct = CurTime()
	local owner = self:GetOwner()

	if CLIENT then
		if !self.MindControlEnabled and self:GetMindControl() > 0 then
			self.MindControlEnabled = true
		end

		if self.MindControlEnabled and self:GetMindControl() == 0 then
			self.MindControlEnabled = false
			self:StopMindControl()
		end
	end

	if self.PrepareMindControl != 0 and self.PrepareMindControl < ct then
		self.PrepareMindControl = 0

		if self.MCTarget then
			local ply = self.MCTarget[1]
			if IsValid( ply ) and ply:CheckSignature( self.MCTarget[2] ) then
				local duration = self:GetMindControlDuration()

				self:SetMindControl( ct + duration )
				self:SetMindControlTarget( ply )

				self:SetNextPrimaryFire( ct + self:GetMindControlDuration() + 5 )
				self:SetNextSecondaryFire( ct + self:GetMindControlDuration() + 60 + self:GetUpgradeMod( "mc_cd", 0 ) )

				local oa = owner:EyeAngles()
				self.RestoreEyeAngles = oa

				if CLIENT then
					if IsValid( self.Clone ) then
						self.Clone:Remove()
					end

					self.Clone = ClientsideModel( "models/player/alski/scp2427-3.mdl", RENDERGROUP_OPAQUE )
					self.Clone:SetPos( owner:GetPos() )
					self.Clone:SetAngles( Angle( 0, oa.yaw, 0 ) )

					local seq = self.Clone:LookupSequence( "stary_spi" )
					if seq > -1 then
						self.Clone:SetSequence( seq )
						self.Clone:SetCycle( 1 )
					end
				end

				//target:SetDisableControls( true )

				if SERVER then
					self.MindControlBuffer.Initialized = false
					self.MindControlBuffer.ViewDelta = nil

					ply:SetProperty( "mind_control", { ct + duration, self } )

					ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), 0.15, 0.25 )
					/*timer.Simple( 0.15, function()
						if IsValid( ply ) then
							ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), 0.15, 0.25 )
						end
					end )*/

					net.Start( "SLCMindControl" )
						net.WriteBool( true )
						net.WriteEntity( self )
						net.WriteFloat( ct + duration )
					net.Send( ply )
				end
			end

			//self.MCTarget = nil
		end
	end

	if SERVER then
		if self:GetMindControl() >= ct then
			local target = self:GetMindControlTarget()
			--if IsValid( target ) then

			local owner_pos = owner:GetPos()
			local target_pos = target:GetPos()
			if owner_pos:DistToSqr( target_pos ) <= 10000 then
				if self.NTargetTrace <= ct then
					self.NTargetTrace = ct + 0.5

					local trace = util.TraceLine{
						start = owner_pos + owner:OBBCenter(),
						endpos = target_pos + target:OBBCenter(),
						mask = MASK_SOLID_BRUSHONLY,
						filter = { owner, target, self }
					}

					if !trace.Hit then
						self:StopMindControl()

						local dmg = DamageInfo()

						dmg:SetAttacker( owner )
						dmg:SetDamage( target:Health() )
						dmg:SetDamageType( DMG_DIRECT )

						target:TakeDamageInfo( dmg )

						self:AddScore( 2 )
						AddRoundStat( "24273" )

						if self:HasUpgrade( "mc13" ) then
							local time = self:GetNextSecondaryFire() - ct

							if time > 0 then
								self:SetNextPrimaryFire( ct + time * 0.6 )
							end
						elseif self:HasUpgrade( "mc23" ) then
							owner:AddHealth( 400 )
						end

						--slash sound
					end
				end
			end
			--end
		end

		if self.PopSpeed != 0 and self.PopSpeed <= ct then
			self.PopSpeed = 0
			owner:PopSpeed( "slc_2427_speed" )
		end
	end

	local npf = self:GetNextPrimaryFire()
	if npf > ct and npf - 7 + self:GetUpgradeMod( "dash_cd", 0 ) < ct and self.EnableDash then
		self.EnableDash = false

		local ang = owner:EyeAngles() * 1
		ang.p = 0

		self.DashDirection = ang:Forward()
		self.DashTime = ct + 0.15

		self.PopSpeed = ct + 3 - self:GetUpgradeMod( "dash_ptime", 0 )

		if SERVER then
			local spd = 0.5 + self:GetUpgradeMod( "dash_pspeed", 0 )
			owner:PushSpeed( spd, spd, 1, "slc_2427_speed", 1 )
		end
	end

	local jump_t = 0.5
	if self.DashTime + jump_t >= ct then
		local start = owner:GetShootPos()

		owner:LagCompensation( true )

		local trace = util.TraceHull{
			start = start,
			endpos = start + owner:GetAimVector() * 25,
			mask = MASK_SHOT,
			filter = owner,
			mins = Vector( -6, -6, -32 ),
			maxs = Vector( 6, 6, 6 )
		}

		owner:LagCompensation( false )

		if trace.Hit then
			local ent = trace.Entity

			if IsValid( ent ) then
				if ent:IsPlayer() then
					local team = ent:SCPTeam()
					if team != TEAM_SPEC and team != TEAM_SCP then
						self.DashTime = 0
						self.StopTime = ct + 0.2

						//ent:SetVelocity( self.DashDirection * 400 )

						if SERVER then
							local dmg = DamageInfo()

							dmg:SetAttacker( owner )
							dmg:SetInflictor( owner )
							dmg:SetDamage( 50 + self:GetUpgradeMod( "dash_dmg", 0 ) )
							dmg:SetDamageType( DMG_SLASH )

							ent:TakeDamageInfo( dmg )

							if ent:Health() <= 0 then
								self:AddScore( 1 )
							end
						end
					end
				else
					self:SCPDamageEvent( ent, 175 + self:GetUpgradeMod( "dash_dmg", 0 ) * 2 )
				end
			end
		end
	end

	if self.DashTime != 0 and self.DashTime + jump_t < ct then
		self.DashTime = 0
		self.StopTime = ct + 0.2
	end

	local control_time = self:GetMindControl()
	if control_time != 0 then
		if control_time < ct then
			self:StopMindControl()
		elseif self.NDistCheck <= ct then
			self.NDistCheck = ct + 1
			local max_d = ( 3000 + self:GetUpgradeMod( "mc_dist", 0 ) * 1.5 )
			if owner:GetPos():DistToSqr( self:GetMindControlTarget():GetPos() ) > max_d * max_d then
				self:StopMindControl()
			end
		end
	end
end

SWEP.DashTime = 0
SWEP.StopTime = 0
function SWEP:PrimaryAttack()
	local ct = CurTime()
	if self:GetNextPrimaryFire() > ct then return end

	local owner = self:GetOwner()
	if !owner:IsOnGround() then return end

	local owner = self:GetOwner()
	local seq = owner:LookupSequence( "stary_skacze" )
	if seq > -1 then
		owner:DoCustomAnimEvent( PLAYERANIMEVENT_CUSTOM, seq )
	end

	self:SetNextPrimaryFire( ct + 7.5 - self:GetUpgradeMod( "dash_cd", 0 ) )

	self.EnableDash = true
end

SWEP.NSecondaryAttack = 0
SWEP.MindControl = 0
function SWEP:SecondaryAttack()
	local ct = CurTime()
	if self:GetNextPrimaryFire() > ct or self:GetNextSecondaryFire() > ct then return end

	local owner = self:GetOwner()
	if owner:Health() == 1 then return end

	local owner_pos = owner:GetPos()
	local plys = FindInCylinder( owner_pos, 2000 + self:GetUpgradeMod( "mc_dist", 0 ), -400, 350, nil, nil, SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN, true ) )

	local len = #plys
	if len > 0 then
		local final = {}
		for k, v in pairs( plys ) do
			if owner_pos:DistToSqr( v:GetPos() ) >= 90000 then
				table.insert( final, v )
			end
		end

		len = #final
		if len > 0 then
			//local target = plys[math.random( len )]
			//print( len, math.Round( util.SharedRandom( "SCP23273MindControl", 1, len, self:GetNextSecondaryFire() ) ), util.SharedRandom( "SCP23273MindControl", 1, len, self:GetNextSecondaryFire() ) )
			local target = final[math.Round( util.SharedRandom( "SCP23273MindControl", 1, len, self:GetNextSecondaryFire() ) )]

			self.LockAngles = nil
			self.PrepareMindControl = ct + 1
			self.MCTarget = { target, target:TimeSignature() }

			self:SetNextPrimaryFire( self.PrepareMindControl + 5 )
			self:SetNextSecondaryFire( self.PrepareMindControl + 5 )

			local owner = self:GetOwner()
			local seq, dur = owner:LookupSequence( "stary_spi" )
			if seq > -1 then
				self:SetNWFloat( "anim_time", ct + dur )
			end
		end
	end
end

function SWEP:Reload()
	
end

function SWEP:OnRemove()
	self:StopMindControl( false, true )
end

function SWEP:GetMindControlDuration()
	return 20 + self:GetUpgradeMod( "mc_dur", 0 )
end

//SWEP.MCPenalty = 0
//SWEP.ClientValueCheck = 0
function SWEP:StopMindControl( noanim1, noanim2 ) --STOP EKRAN EFEKTY DLA OFIARY PO KILL OFIARY LUB SCP
	if SERVER and self.MCTarget and IsValid( self.MCTarget[1] ) then
		net.Start( "SLCMindControl" )
			net.WriteBool( false )
		net.Send( self.MCTarget[1] )
		
		if self.MCTarget[1]:GetProperty( "mind_control" ) then
			self.MCTarget[1]:SetProperty( "mind_control" )
		end

		if !noanim1 then
			self.MCTarget[1]:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), 0.15, 0.25 )
		end
	end

	self.PrepareMindControl = 0
	self.MCTarget = nil

	--if SERVER then
		self:SetMindControl( 0 )
		self:SetMindControlTarget( NULL )
	--end

	self.LockAngles = self.RestoreEyeAngles//nil
	
	local penalty_time = 3
	local owner = self:GetOwner()
	if IsValid( owner ) then
		if !noanim2 then
			owner:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), 0.15, 0.25 )

			local seq, dur = owner:LookupSequence( "stary_wstal" )
			if seq > -1 then
				if dur > penalty_time then
					penalty_time = dur
				end

				owner:DoCustomAnimEvent( PLAYERANIMEVENT_CUSTOM, seq )
			end
		end

		if self.RestoreEyeAngles then
			owner:SetEyeAngles( self.RestoreEyeAngles )
			self.RestoreEyeAngles = nil
		end
	end

	local ct = CurTime()
	self:SetNextPrimaryFire( ct + 5 )
	self:SetMindControlPenalty( ct + penalty_time )

	if CLIENT then
		if IsValid( self.Clone ) then
			self.Clone:Remove()
		end
	end
end

hook.Add( "CalcMainActivity", "SLCSCP2427Activity", function( ply, vel )
	if ply:SCPClass() == CLASSES.SCP24273 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			local ct = CurTime()
			if wep.GetMindControl and wep:GetMindControl() >= ct then
				local seq, dur = ply:LookupSequence( "stary_spi" )
				if seq > -1 then
					local f = 1 - ( wep:GetNWInt( "anim_time" ) - ct ) / dur

					if f > 1 then
						f = 1
					end

					ply:SetCycle( f )
					return -1, seq
				end
			end
		end	
	end
end )

hook.Add( "DoAnimationEvent", "SLCSCP2427AnimEvent", function( ply, event, data )
	if ply:SCPClass() == CLASSES.SCP24273 then
		if event == PLAYERANIMEVENT_CUSTOM then
			ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, data, 0, true )
		end
	end
end )

hook.Add( "Move", "SLCSCP2427Move", function( ply, mv )
	if ply:SCPClass() == CLASSES.SCP24273 then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			local ct = CurTime()

			if wep.DashTime and wep.DashTime >= ct then
				local vel = wep.DashDirection * ( 850 + wep:GetUpgradeMod( "dash_power", 0 ) )

				if ply:IsOnGround() then
					vel.z = 251
				end

				mv:SetVelocity( vel )
			end

			if wep.StopTime and wep.StopTime > ct then
				mv:SetVelocity( mv:GetVelocity() * 0.95 )
			end
		end
	end
end )

local buttons_filter = bit.bor( IN_USE, IN_SPEED, IN_DUCK, IN_JUMP )
hook.Add( "StartCommand", "SLCSCP2427Control", function( ply, cmd )
	local wep = ply:GetActiveWeapon()
	local ct = CurTime()

	local scpok = ply:SCPClass() == CLASSES.SCP24273 and IsValid( wep )
	local mctime = wep.GetMindControl and wep:GetMindControl() >= ct

	if scpok then
		//local npf = wep:GetNextPrimaryFire()
		if wep.EnableDash then
			cmd:ClearMovement()
			cmd:ClearButtons()
		end

		if wep.PrepareMindControl and wep.PrepareMindControl >= ct or wep.GetMindControlPenalty and wep:GetMindControlPenalty() >= ct then
			cmd:ClearMovement()
			cmd:ClearButtons()

			if !wep.LockAngles then
				wep.LockAngles = cmd:GetViewAngles()
			end

			cmd:SetViewAngles( wep.LockAngles )
		end

		if wep.PopSpeed and wep.PopSpeed > ct then
			if cmd:KeyDown( IN_JUMP ) then
				cmd:RemoveKey( IN_JUMP )
			end
			
			if cmd:KeyDown( IN_DUCK ) then
				cmd:RemoveKey( IN_DUCK )
			end
		end
	end

	if CLIENT then
		if ply.MindControlTime and ply.MindControlTime >= CurTime() then
			cmd:ClearButtons()
			cmd:ClearMovement()

			cmd:SetButtons( ply.MindControlObject:GetNWInt( "mc_buttons" ) )
			
			local desired = ply.MindControlObject:GetNWAngle( "mc_angles" )

			if !ply.MindControlAngles then
				ply.MindControlAngles = desired
			end
			
			local ang = LerpAngle( FrameTime() * 2, ply.MindControlAngles, desired )
			ang.roll = 0

			cmd:SetViewAngles( ang )
			ply.MindControlAngles = ang

			return true
		end
	end

	if SERVER then
		if scpok then
			if mctime then
				if cmd:KeyDown( IN_RELOAD ) then
					wep:StopMindControl( false, false )
					return true
				end

				--save data and write to controlled player
				wep.MindControlBuffer.ViewAngles = cmd:GetViewAngles()
				wep.MindControlBuffer.ForwardMove = cmd:GetForwardMove()
				wep.MindControlBuffer.SideMove = cmd:GetSideMove()
				wep.MindControlBuffer.UpMove = cmd:GetUpMove()

				local buttons = bit.band( cmd:GetButtons(), buttons_filter )
				wep.MindControlBuffer.Buttons = buttons

				wep.MindControlBuffer.Initialized = true

				wep:SetNWInt( "mc_buttons", buttons )
				wep:SetNWAngle( "mc_angles", cmd:GetViewAngles() )

				cmd:SetViewAngles( wep.LockAngles )

				cmd:ClearMovement()
				cmd:ClearButtons()
			end
		end

		local ctrl = ply:GetProperty( "mind_control" )
		if ctrl and ctrl[1] >= CurTime() and IsValid( ctrl[2] ) then
			cmd:ClearButtons()
			cmd:ClearMovement()

			local buffer = ctrl[2].MindControlBuffer
			if buffer and buffer.Initialized then
				cmd:SetButtons( buffer.Buttons )
				cmd:SetForwardMove( buffer.ForwardMove )
				cmd:SetSideMove( buffer.SideMove )
				cmd:SetUpMove( buffer.UpMove )

				cmd:SetViewAngles( buffer.ViewAngles )
				ply:SetEyeAngles( buffer.ViewAngles )

				return true
			end
		end
	end
end )

hook.Add( "CanPlayerSeePlayer", "SLCSCP2427CanSee", function( ply1, ply2 )
	if ply1:SCPClass() == CLASSES.SCP24273 then
		local wep = ply1:GetActiveWeapon()
		if IsValid( wep ) then
			if wep.GetMindControl and wep:GetMindControl() > CurTime() then
				local target = wep:GetMindControlTarget()
				if IsValid( target ) and target == ply2 then
					return false
				end
			end
		end
	end
end )

hook.Add( "PlayerButtonDown", "SLCSCP2427Buttons", function( ply, button )
	if SERVER then
		local ctrl = ply:GetProperty( "mind_control" )
		if ctrl and ctrl[1] < CurTime() then
			return false
		end
	end

	if CLIENT then
		if ply.MindControlTime and ply.MindControlTime >= CurTime() then
			return false
		end
	end
end )

hook.Add( "PlayerPostThink", "SLCSCP2427Monitor", function( ply )
	if SERVER then
		local ctrl = ply:GetProperty( "mind_control" )
		if ctrl and ctrl[1] < CurTime() then
			ply:SetProperty( "mind_control", nil )
			//ply:SetDisableControls( false )
		end
	end

	if CLIENT then
		if ply.MindControlTime and ply.MindControlTime < CurTime() then
			ply.MindControlTime = nil
			ply.MindControlObject = nil
			ply.MindControlAngles = nil
		end
	end
end )

if SERVER then
	util.AddNetworkString( "SLCMindControl" )

	hook.Add( "SetupPlayerVisibility", "SLCSCP2427Vis", function( ply, ent )
		if ply:SCPClass() == CLASSES.SCP24273 then
			local wep = ply:GetActiveWeapon()
			if IsValid( wep ) then
				if wep.GetMindControl and wep:GetMindControl() > CurTime() then
					local target = wep:GetMindControlTarget()
					if IsValid( target ) then
						AddOriginToPVS( target:GetPos() )
					end
				end
			end
		end
	end )

	hook.Add( "DoPlayerDeath", "SLCSCP2427Death", function( ply, att, dmg )
		local ctrl = ply:GetProperty( "mind_control" )
		if ctrl and IsValid( ctrl[2] ) then
			ctrl[2]:StopMindControl( true )

			if !IsValid( att ) or !att:IsPlayer() or att == ply and !att.Disconnected then
				local owner = ctrl[2]:GetOwner()

				local hp = owner:Health() - 1500
				if hp < 1 then
					hp = 1
				end

				owner:SetHealth( hp )
			end
		end

		if ply:SCPClass() == CLASSES.SCP24273 then
			local wep = ply:GetActiveWeapon()
			if IsValid( wep ) then
				wep:StopMindControl( false, true )
			end
		end
	end )

	hook.Add( "PlayerCanHearPlayersVoice", "SLCSCP2427Voice", function( listener, talker )
		local ply

		if talker:SCPClass() == CLASSES.SCP24273 then
			ply = talker
		elseif listener:SCPClass() == CLASSES.SCP24273 then
			ply = listener
		end

		if ply then
			local wep = ply:GetActiveWeapon()
			if IsValid( wep ) then
				if wep.GetMindControl and wep:GetMindControl() > CurTime() then
					return false
				end
			end
		end

		if talker:GetProperty( "mind_control" ) then
			return false
		end
	end )

	hook.Add( "PlayerCanPickupWeapon", "SLCSCP2427Pickup", function( ply, wep )
		//if ply.MindControlTime and ply.MindControlTime >= CurTime() then
		if ply:GetProperty( "mind_control" ) then
			return false
		end
	end )
end

if CLIENT then
	net.Receive( "SLCMindControl", function( len )
		local status = net.ReadBool()

		if status then
			local ctrl = net.ReadEntity()
			local time = net.ReadFloat()

			local ply = LocalPlayer()

			ply.MindControlTime = time
			ply.MindControlObject = ctrl
		else
			ply.MindControlTime = nil
			ply.MindControlObject = nil
			ply.MindControlAngles = nil
		end
	end )

	local overlay = GetMaterial( "slc/scp/2427overlay.png" )
	hook.Add( "SLCScreenMod", "SLCSCP2427Screen", function( clr )
		local ply = LocalPlayer()
		local ct = CurTime()

		if ply.MindControlTime and ply.MindControlTime >= ct then
			clr.colour = 0
			clr.contrast = clr.contrast * 0.8
			DrawToyTown( 3, ScrH() / 1.7 )
		end

		if ply:SCPClass() == CLASSES.SCP24273 then
			local wep = ply:GetActiveWeapon()
			if IsValid( wep ) then
				if wep.GetMindControl then
					local time = wep:GetMindControl()
					if time >= ct then
						local f = 1 - (time - ct) / wep:GetMindControlDuration()

						surface.SetMaterial( overlay )
						surface.SetDrawColor( Color( 155 + 100 * f, 100, 100, math.TimedSinWave( 0.7, 25 + 150 * f, 120 + 135 * f ) ) )
						surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
					end
				end
			end
		end
	end )

	hook.Add( "PreDrawHalos", "SLCSCP2427Halo", function()
		local ply = LocalPlayer()
		if ply:SCPClass() == CLASSES.SCP24273 then
			local wep = ply:GetActiveWeapon()
			if IsValid( wep ) then
				if IsValid( wep.Clone ) then
					halo.Add( { wep.Clone }, Color( 255, 0, 0 ), 2, 2, 1, true, true )
				end
			end
		end
	end )

	/*hook.Add( "PlayerBindPress", "SLCSCP2427Bind", function( ply, bind )
		if ply.MindControlTime and ply.MindControlTime >= CurTime() then
			return true
		end
	end )*/
end

function SWEP:CalcView( ply, origin, angles, fov )
	local ct = CurTime()
	if self.PrepareMindControl >= ct and IsValid( self.MCTarget[1] ) then
		local f = 1 - ( self.PrepareMindControl - ct )

		return LerpVector( f, origin, self.MCTarget[1]:EyePos() ) //origin + (self.MCTarget:EyePos() - origin ) * f
	elseif self:GetMindControl() > ct then
		local ent = self:GetMindControlTarget()
		if IsValid( ent ) then
			return ent:EyePos()//, angles, fov, true //, ent:EyeAngles(), fov
		end
	end
end

function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end
	
	local ct = CurTime()
	local ctime = self:GetMindControl()
	if ctime >= ct then
		surface.SetDrawColor( Color( 50, 20, 155 ) )
		surface.DrawOutlinedRect( ScrW() * 0.4, ScrH() * 0.9, ScrW() * 0.2, ScrH() * 0.03 )

		local f = ( ctime - ct ) / self:GetMindControlDuration()

		if f < 0 then
			f = 0
		end

		surface.DrawRect( ScrW() * 0.4, ScrH() * 0.9, ScrW() * 0.2 * f, ScrH() * 0.03 )

		return
	end

	local txt, color
		
	local npf = self:GetNextPrimaryFire()
	local nsf = self:GetNextSecondaryFire()

	if npf > nsf then
		nsf = npf
	end

	if nsf > ct then
		txt = string.format( self.Lang.mind_control_cd, math.ceil( nsf - ct ) )
		color = Color( 255, 0, 0 )
	else
		txt = self.Lang.mind_control
		color = Color( 0, 255, 0 )
	end

	draw.Text( {
		text = txt,
		pos = { ScrW() * 0.5, ScrH() * 0.97 },
		font = "SCPHUDSmall",
		color = color,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	if npf > ct then
		txt = string.format( self.Lang.dash_cd, math.ceil( npf - ct ) )
		color = Color( 255, 0, 0 )
	else
		txt = self.Lang.dash
		color = Color( 0, 255, 0 )
	end

	draw.Text( {
		text = txt,
		pos = { ScrW() * 0.5, ScrH() * 0.94 },
		font = "SCPHUDSmall",
		color = color,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end

DefineUpgradeSystem( "scp24273", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "dash1", cost = 2, req = {}, reqany = false,  pos = { 1, 1 }, mod = { dash_cd = 1, dash_power = 125 }, active = false },
		{ name = "dash2", cost = 3, req = { "dash1" }, reqany = false,  pos = { 1, 2 }, mod = { dash_pspeed = 0.15, dash_ptime = 0.5 }, active = false },
		{ name = "dash3", cost = 4, req = { "dash2" }, reqany = false,  pos = { 1, 3 }, mod = { dash_dmg = 50 }, active = false },

		{ name = "mc11", cost = 1, req = {}, block = { "mc21" }, reqany = false,  pos = { 2, 1 }, mod = { mc_dur = 10, mc_cd = 20 }, active = false },
		{ name = "mc12", cost = 3, req = { "mc11" }, reqany = false,  pos = { 2, 2 }, mod = { mc_dur = 20, mc_cd = 45 }, active = false },
		{ name = "mc13", cost = 6, req = { "mc12", "mc22" }, block = { "mc23" }, reqany = true,  pos = { 2, 3 }, mod = { mc_dist = 1000 }, active = false }, --kill gives mc cd

		{ name = "mc21", cost = 1, req = {}, block = { "mc11" }, reqany = false,  pos = { 3, 1 }, mod = { mc_dur = -5, mc_cd = -10 }, active = false },
		{ name = "mc22", cost = 3, req = { "mc21" }, reqany = false,  pos = { 3, 2 }, mod = { mc_dur = -10, mc_cd = -15 }, active = false },
		{ name = "mc23", cost = 6, req = { "mc22", "mc12" }, block = { "mc13" }, reqany = true,  pos = { 3, 3 }, mod = { mc_dist = 500 }, active = false }, --kill gives hp

		{ name = "mc3", cost = 2, req = { "mc21" }, reqany = false,  pos = { 4, 2 }, mod = { mc_def = 0.5 }, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 3 }, mod = {}, active = false },
	},
	rewards = { --15, mc kill grants 2 points, normal kill 1 point
		{ 1, 2 },
		{ 3, 1 },
		{ 5, 1 },
		{ 8, 2 },
		{ 10, 2 },
		{ 13, 2 },
		{ 16, 3 },
		{ 20, 2 }
	}
} )

hook.Add( "EntityTakeDamage", "SCP24273DMGMod", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() and ent:SCPClass() == CLASSES.SCP24273 then
		local wep = ent:GetActiveWeapon()
		if IsValid( wep ) and wep.UpgradeSystemMounted then
			local mod = wep:GetUpgradeMod( "mc_def" )

			if mod then
				if !dmg:IsDamageType( DMG_DIRECT ) then
					dmg:ScaleDamage( mod )
				end
			end
		end
	end
end )

InstallUpgradeSystem( "scp24273", SWEP )