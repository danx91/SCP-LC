--[[-------------------------------------------------------------------------
Gamemode hooks
---------------------------------------------------------------------------]]
function GM:PlayerNoClip( ply, on )
	return ply:SCPTeam() == TEAM_SPEC and on == true
end

function GM:PlayerButtonDown( ply, button )
	if SERVER then
		numpad.Activate( ply, button )

		local rt = RealTime()

		if !ply.SLCAFKTimer then
			ply.SLCAFKTimer = 0
		end

		if ply.SLCAFKTimer <= rt then
			if ply:IsAFK() then
				ply:Set_SCPAFK( false )
				QueueInsert( ply ) --insert player back to spawn queue
				CheckRoundStart()

				PlayerMessage( "afk_end", ply )
			end

			ply.SLCAFKTimer = rt
			ply.AFKWarned = false
		end
	end

	if CLIENT and IsFirstTimePredicted() then
		SLCAFKWarning = false

		if button == GetBindButton( "eq_button" ) and hook.Run( "SLCCanUseBind", "eq" ) != false then

			if CanShowEQ() then
				ShowEQ()
			end

			HUDDrawInfo = true

			if ply:SCPTeam() == TEAM_SPEC then
				HUDSpectatorInfo = true
			end
		elseif button == GetBindButton( "upgrade_tree_button" ) and hook.Run( "SLCCanUseBind", "scp_tree" ) != false then
			ShowSCPUpgrades()
		elseif button == GetBindButton( "ppshop_button" ) and hook.Run( "SLCCanUseBind", "class_viewer" ) != false then
			OpenClassViewer()
		elseif button == GetBindButton( "settings_button" ) and hook.Run( "SLCCanUseBind", "settings" ) != false then
			OpenSettingsWindow()
		end
	end
end

function GM:PlayerButtonUp( ply, button )
	if SERVER then numpad.Deactivate( ply, button ) end

	if CLIENT and IsFirstTimePredicted() then
		if button == GetBindButton( "eq_button" ) then
			if IsEQVisible() then
				HideEQ()
			end

			HUDDrawInfo = false

			if ply:SCPTeam() == TEAM_SPEC then
				HUDSpectatorInfo = false
			end
		elseif button == GetBindButton( "upgrade_tree_button" ) then
			HideSCPUpgrades()
		end
	end
end

function GM:KeyPress( ply, key )
	if SERVER and !ply:IsBot() then
		if ply:SCPTeam() == TEAM_SPEC then
			if key == IN_ATTACK then
				ply:SpectatePlayerNext()
			elseif key == IN_ATTACK2 then
				ply:SpectatePlayerPrev()
			elseif key == IN_RELOAD then
				ply:ChangeSpectateMode()
			end
		end
	end
end

function GM:KeyRelease( ply, key )

end

if CLIENT then
	hook.Add( "Tick", "SLCClientSideUse", function()
		local ply = LocalPlayer()
		if IsValid( ply ) and ply:KeyDown( IN_USE ) then
			if ply:SCPTeam() != TEAM_SPEC then
				local sp = ply:GetShootPos()
				local tr = util.TraceLine{
					start = sp,
					endpos = sp + ply:GetAimVector() * 75,
					filter = ply,
				}

				if tr.Hit and IsValid( tr.Entity ) then
					if tr.Entity.CSUse then
						tr.Entity:CSUse( ply )
					end
				end
			end
		end
	end )
end

function GM:StartCommand( ply, cmd )
	if ply:Alive() and !IsValid( ply:GetActiveWeapon() ) then
		local holster = ply:GetWeapon( "item_slc_holster" )
		if IsValid( holster ) then
			cmd:SelectWeapon( holster )
		end
	end

	if ply.GetDisableControls and ply:GetDisableControls() then
		cmd:ClearMovement()

		local mask = ply:GetDisableControlsFlag()
		if mask == 0 then
			cmd:ClearButtons()
		else
			cmd:SetButtons( bit.band( cmd:GetButtons(), mask ) )
		end

		if bit.band( mask, -2147483648 ) == 0 then --TEST camera movement mask
			if !ply.DisableControlsAngle then
				ply.DisableControlsAngle = cmd:GetViewAngles()
			end

			cmd:SetViewAngles( ply.DisableControlsAngle )
		end
	elseif ply.DisableControlsAngle then
		ply.DisableControlsAngle = nil
	end

	if SERVER then
		if ply:IsAboutToSpawn() then
			cmd:ClearMovement()
			cmd:ClearButtons()
		end
	end
end

function GM:PlayerSwitchWeapon( ply, old, new )
	if IsValid( new ) then
		if new.OnSelect then
			new:OnSelect()
		end

		if new.Selectable == false then
			return true
		end
	end
end

function GM:PlayerCanPickupWeapon( ply, wep )
	local t = ply:SCPTeam()
	if t == TEAM_SPEC then return false end

	if #ply:GetWeapons() >= ply:GetInventorySize() then
		if wep.Stacks and wep.Stacks <= 1 then return false, "max_eq" end

		local pwep = ply:GetWeapon( wep:GetClass() )
		if !IsValid( pwep ) then return false end
		if pwep.CanStack and !pwep:CanStack() then return false, "cant_stack" end
	end

	if t == TEAM_SCP then
		if wep.SCP then
			return true
		end

		if !ply:GetSCPHuman() then
			return false
		end
	end

	if wep.SCP then
		return false
	end

	local status, msg = hook.Run( "SLCCanPickupWeaponClass", ply, wep:GetClass() )
	if status == false then
		return false, msg
	end

	local class = wep:GetClass()
	local has = false
	
	for k, v in pairs( ply:GetWeapons() ) do
		if v:GetClass() == class then
			has = true
			break
		end
	end

	if has then
		if !wep.Stacks or wep.Stacks <= 1 then return false, "has_already" end

		local pwep = ply:GetWeapon( wep:GetClass() )
		if IsValid( pwep ) then
			if pwep.CanStack and !pwep:CanStack() then return false, "cant_stack" end
		end
	end

	if wep.CanPickUp then
		local s, m = wep:CanPickUp( ply )
		if s != nil then
			return s, m
		end
	end

	if CLIENT then return true end

	if !wep.Dropped then
		return !wep.PickupPriority or !wep.PriorityTime or wep.PickupPriority == ply or wep.PriorityTime < CurTime()
	elseif wep.Dropped > CurTime() - 1 then
		return false
	end

	if ply:KeyDown( IN_USE ) then
		if wep == ply:GetEyeTrace().Entity then
			if wep.CanPickup and wep:CanPickup( ply ) == false then
				return false
			end

			return true
		end
	end

	return false
end

function GM:SLCCanPickupWeaponClass( ply, class )
	local tab = weapons.Get( class )
	if !tab then return end

	local group = SLC_WEAPON_GROUP_OVERRIDE[class] or tab.Group
	if !group then return end

	for k, v in pairs( ply:GetWeapons() ) do
		if v:GetGroup() == group then
			return false, "same_type"
		end
	end
end

--From base gamemode
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local n_movement, noclamp = hook.Run( "SLCMovementAnimSpeed", ply, velocity, maxseqgroundspeed, len, movement )
	if isnumber( n_movement ) then
		movement = n_movement
	end

	local rate = movement

	if !noclamp then
		if rate > 2 then
			rate = 2
		end
	end

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() and len >= 1000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	-- We only need to do this clientside..
	if ( CLIENT ) then
		if ( ply:InVehicle() ) then
			--
			-- This is used for the 'rollercoaster' arms
			--
			local Vehicle = ply:GetVehicle()
			local Velocity = Vehicle:GetVelocity()
			local fwd = Vehicle:GetUp()
			local dp = fwd:Dot( Vector( 0, 0, 1 ) )

			ply:SetPoseParameter( "vertical_velocity", ( dp < 0 and dp or 0 ) + fwd:Dot( Velocity ) * 0.005 )

			-- Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 -- convert from 0..1 to -1..1
			if ( Vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then steer = 0 ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) ) end
			ply:SetPoseParameter( "vehicle_steer", steer )

		end
		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end
end

local PLAYER = FindMetaTable( "Player" )
--[[-------------------------------------------------------------------------
SLCProperties
---------------------------------------------------------------------------]]
function PLAYER:ResetProperties()
	self.SLCProperties = {}
	//self.SLCPropertiesSync = {}
end

function PLAYER:SetProperty( key, value, sync )
	if !self.SLCProperties then self.SLCProperties = {} end

	if SERVER and sync then
		net.Start( "SLCPropertyChanged" )
			net.WriteString( key )
			net.WriteTable( { value } )
		net.Send( self )
	end

	self.SLCProperties[key] = value
	return value
end

function PLAYER:GetProperty( key, def )
	if !self.SLCProperties then self.SLCProperties = {} end
	return self.SLCProperties[key] or def
end

--[[-------------------------------------------------------------------------
Hold manager
---------------------------------------------------------------------------]]
function PLAYER:StartHold( id, key, time, cb, tab )
	if !self:KeyDown( key ) then return end

	if !tab._ButtonHold then
		tab._ButtonHold = {}
	end

	id = id..self:SteamID()

	tab._ButtonHold[id] = {
		key = key,
		duration = time,
		time = CurTime() + time,
		cb = cb,
	}
end

function PLAYER:UpdateHold( id, tab )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	if data.interrupted or !self:KeyDown( data.key ) then
		tab._ButtonHold[id] = nil
		if data.cb then data.cb( false ) end
		return false
	end

	if data.time <= CurTime() then
		tab._ButtonHold[id] = nil
		if data.cb then data.cb( true ) end
		return true
	end
end

function PLAYER:InterruptHold( id, tab )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	tab._ButtonHold[id].interrupted = true
end

function PLAYER:IsHolding( id, tab )
	if !tab._ButtonHold then return false end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return false end

	return self:KeyDown( data.key )
end

function PLAYER:HoldProgress( id, tab )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	return math.Clamp( 1 - ( data.time - CurTime() ) / data.duration, 0, 1 )
end

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
function PLAYER:DataTables()
	player_manager.SetPlayerClass( self, "class_slc" )
	player_manager.RunClass( self, "SetupDataTables" )
end

local function accessor( func, var )
	var = "Get"..( var or "_"..func )

	PLAYER[func] = function( self )
		if !self[var] then
			self:DataTables()
		end

		return self[var]( self )
	end
end

accessor( "IsActive", "_SCPActive" )
accessor( "IsPremium", "_SCPPremium" )
accessor( "IsAFK", "_SCPAFK" )
accessor( "SCPLevel" )
accessor( "SCPExp" )
accessor( "SCPClassPoints" )
accessor( "DailyBonus" )

function PLAYER:RequiredXP( lvl )
	if !lvl then
		lvl = self:SCPLevel()
	end

	if SLC_XP_OVERRIDE then
		return SLC_XP_OVERRIDE( lvl )
	else
		return CVAR.slc_xp_level:GetInt() + CVAR.slc_xp_increase:GetInt() * lvl
	end
end

function PLAYER:SCPClass()
	if !self.Get_SCPClass then
		self:DataTables()
	end

	return self:Get_SCPClass()
end

function PLAYER:SCPPersona()
	if !self.Get_SCPPersonaC or !self.Get_SCPPersonaT then
		self:DataTables()
	end

	return self:Get_SCPPersonaC(), self:Get_SCPPersonaT()
end

function PLAYER:GetPlayermeta()
	return self.playermeta
end

function PLAYER:TimeSignature()
	if !self.GetTimeSignature then
		self:DataTables()
	end

	return self:GetTimeSignature()
end

function PLAYER:CheckSignature( time )
	return self:TimeSignature() == time
end

function PLAYER:IsSpectator()
	return !self:Alive() and self:SCPTeam() == TEAM_SPEC
end

function PLAYER:GetInventorySize()
	return 8 + self:GetBackpack()
end

function PLAYER:IsHuman()
	return SCPTeams.HasInfo( self:SCPTeam(), SCPTeams.INFO_HUMAN ) or self:GetSCPHuman()
end

function PLAYER:IsInEscape()
	if istable( POS_ESCAPE ) then
		return self:GetPos():WithinAABox( POS_ESCAPE[1], POS_ESCAPE[2] )
	else
		return self:GetPos():DistToSqr( POS_ESCAPE ) <= ( DIST_ESCAPE or 22500 )
	end
end

function PLAYER:IsInSafeSpot()
	return IsInSafeSpot( self:GetPos() )
end

function PLAYER:CheckHazardProtection( dmg )
	return self:CheckHazmat( dmg ) or self:CheckGasmask( dmg )
end

function PLAYER:CheckGasmask( dmg )
	/*local mask = self:GetWeapon( "item_slc_gasmask" )
	if IsValid( mask ) and mask:GetEnabled() then
		if dmg then
			mask:Damage( dmg )
		end

		return true
	end

	local heavy_mask = self:GetWeapon( "item_slc_heavymask" )
	if IsValid( heavy_mask ) and heavy_mask:GetEnabled() then
		if dmg then
			heavy_mask:Damage( dmg )
		end

		return true
	end*/

	for k, v in pairs( self:GetWeapons() ) do
		if v.Group == "gasmask" and v:GetEnabled() then
			if dmg then
				v:Damage( dmg )
			end

			return true
		end
	end
end

function PLAYER:CheckHazmat( dmg )
	local vest = self:GetVest()
	local dur = self:GetVestDurability()
	if vest > 0 and dur > 0 and VEST.GetName( vest ) == "hazmat" then
		if dmg then
			dur = dur - dmg

			if dur < 0 then
				dur = 0
			end

			self:SetVestDurability( dur )
		end
		
		return true
	end
end

function PLAYER:GetMainWeapon()
	for k, v in pairs( self:GetWeapons() ) do
		if SLC_WEAPONS_REG[v:GetClass()] then
			return v
		end
	end
end