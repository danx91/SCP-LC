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
		end
	end

	if CLIENT and IsFirstTimePredicted() then
		if button == GetBindButton( "eq_button" ) then
			if CanShowEQ() then
				ShowEQ()
			end

			local t = ply:SCPTeam()
			if t == TEAM_SPEC then
				HUDSpectatorInfo = true
			end
		elseif button == GetBindButton( "upgrade_tree_button" ) then
			ShowSCPUpgrades()
		elseif button == GetBindButton( "ppshop_button" ) then
			OpenClassViewer()
		elseif button == GetBindButton( "settings_button" ) then
			OpenSettingsWindow()
		end
	end
end

function GM:PlayerButtonUp( ply, button )
	if SERVER then numpad.Deactivate( ply, button ) end

	if CLIENT and IsFirstTimePredicted() then
		local menu_key = input.LookupBinding( "+menu" )
		if menu_key then
			if input.GetKeyCode( menu_key ) == button then
				HideEQ()

				local t = ply:SCPTeam()
				if t == TEAM_SPEC then
					HUDSpectatorInfo = false
				end
			end
		end

		local zoom_key = input.LookupBinding( "+zoom" )
		if zoom_key then
			if input.GetKeyCode( zoom_key ) == button then
				HideSCPUpgrades()
			end
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
			elseif key == IN_JUMP or key == IN_RELOAD then
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

	if SERVER and ply:IsAboutToSpawn() then
		cmd:ClearMovement()
		cmd:ClearButtons()
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
		if wep.Stacks and wep.Stacks <= 1 then return false end

		local pwep = ply:GetWeapon( wep:GetClass() )
		if !IsValid( pwep ) then return false end
		if pwep.CanStack and !pwep:CanStack() then return false end
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

	local class = wep:GetClass()

	local has = false
	for k, v in pairs( ply:GetWeapons() ) do
		if v:GetClass() == class then
			has = true
			break
		elseif v.Group and v.Group == wep.Group then
			return false
		end
	end

	if has then
		if !wep.Stacks or wep.Stacks <= 1 then return false end

		local pwep = ply:GetWeapon( wep:GetClass() )
		if IsValid( pwep ) then
			if pwep.CanStack and !pwep:CanStack() then return false end
		end
	end

	if !wep.Dropped then
		return CLIENT or !wep.PickupPriority or !wep.PriorityTime or wep.PickupPriority == ply or wep.PriorityTime < CurTime()
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
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
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

			ply:SetPoseParameter( "vertical_velocity", ( dp < 0 && dp || 0 ) + fwd:Dot( Velocity ) * 0.005 )

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
--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
local ply = FindMetaTable( "Player" )

function ply:DataTables()
	player_manager.SetPlayerClass( self, "class_slc" )
	player_manager.RunClass( self, "SetupDataTables" )
end

function ply:IsActive()
	if !self.Get_SCPActive then
		self:DataTables()
	end

	return self:Get_SCPActive()
end

function ply:IsPremium()
	if !self.Get_SCPPremium then
		self:DataTables()
	end

	return self:Get_SCPPremium()
end

function ply:IsAFK()
	if !self.Get_SCPAFK then
		self:DataTables()
	end

	return self:Get_SCPAFK()
end

function ply:SCPLevel()
	if !self.Get_SCPLevel then
		self:DataTables()
	end

	return self:Get_SCPLevel()
end

function ply:SCPExp()
	if !self.Get_SCPExp then
		self:DataTables()
	end

	return self:Get_SCPExp()
end

function ply:SCPPrestige()
	if !self.Get_SCPPrestige then
		self:DataTables()
	end

	return self:Get_SCPPrestige()
end

function ply:SCPPrestigePoints()
	if !self.Get_SCPPrestigePoints then
		self:DataTables()
	end

	return self:Get_SCPPrestigePoints()
end

function ply:SCPClass()
	if !self.Get_SCPClass then
		self:DataTables()
	end

	return self:Get_SCPClass()
end

function ply:SCPPersona()
	if !self.Get_SCPPersonaC or !self.Get_SCPPersonaT then
		self:DataTables()
	end

	return self:Get_SCPPersonaC(), self:Get_SCPPersonaT()
end

function ply:GetPlayermeta()
	return self.playermeta
end

function ply:TimeSignature()
	if !self.GetTimeSignature then
		self:DataTables()
	end

	return self:GetTimeSignature()
end

function ply:CheckSignature( time )
	return self:TimeSignature() == time
end

function ply:IsSpectator()
	return !self:Alive() and self:SCPTeam() == TEAM_SPEC
end

function ply:GetInventorySize()
	return 8
end

function ply:IsHuman()
	return SCPTeams.HasInfo( self:SCPTeam(), SCPTeams.INFO_HUMAN ) or self:GetSCPHuman()
end

function ply:IsInSafeSpot()
	local pos = self:GetPos()

	for k, v in pairs( SAFE_SPOTS ) do
		if pos:WithinAABox( v.mins, v.maxs ) then
			return true
		end
	end

	return false
end