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
				//ShowEQ()
				ShowGUIElement( "eq" )
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
			HideGUIElement( "eq" )

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
		if !IsValid( ply ) or !ply:KeyDown( IN_USE ) then return end
		if ply:SCPTeam() == TEAM_SPEC then return end

		local sp = ply:GetShootPos()
		local tr = util.TraceLine{
			start = sp,
			endpos = sp + ply:GetAimVector() * 75,
			filter = ply,
		}

		if !tr.Hit or !IsValid( tr.Entity ) then return end
		if !tr.Entity.CSUse then return end
		
		tr.Entity:CSUse( ply )
	end )
end

function GM:PlayerSwitchWeapon( ply, old, new )
	if !IsValid( new ) then return end

	if new.eq_slot and new.eq_slot > 6 then return true end
	if new.OnSelect and new:OnSelect() == true then return true end
	if new.Selectable == false then return true end
	if ply:GetProperty( "prevent_weapon_switch", 0 ) >= CurTime() then return true end

	//new:ResetViewModelBones()
end

function GM:OnViewModelChanged( vm, old, new )
	vm:ResetBones( vm._bone_count )
	vm._bone_count = vm:GetBoneCount()
end

local admin_weapons = {
	weapon_physgun = true,
	tool_slc_remover = true,
	tool_slc_inv = true,
}

function GM:PlayerCanPickupWeapon( ply, wep )
	if ply:GetAdminMode() then
		local class = wep:GetClass()
		return !!admin_weapons[class]
	end

	local t = ply:SCPTeam()
	if t == TEAM_SPEC then return false end

	if ply:GetFreeInventory() <= 0 then
		if !wep.Stacks or wep.Stacks <= 1 then return false, "max_eq" end

		local pwep = ply:GetWeapon( wep:GetClass() )
		if !IsValid( pwep ) then return false, "max_eq" end
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

	local ct = CurTime()
	if wep.PickupPriority and wep.PickupPriorityTime and wep.PickupPriorityTime >= ct then
		return wep.PickupPriority == ply
	elseif !wep.Dropped then
		return true
	elseif wep.Dropped + 1 >= ct then
		return false
	end

	return ply:KeyDown( IN_USE ) and wep == ply:GetEyeTrace().Entity
end

function GM:SLCCanPickupWeaponClass( ply, class )
	if !WeaponInAnyGroup( class ) then return end

	local lowest = math.huge
	local count = 0

	for i, v in ipairs( ply:GetWeapons() ) do
		local result, limit = v:TestGroup( class )
		if !result then continue end

		if limit <= 1 then
			return false, "same_type"
		end

		if limit < lowest then
			lowest = limit
		end

		count = count + 1
	end

	if count >= lowest then
		return false, "max_type"
	end
end

function GM:PhysgunPickup( ply, ent )
	return ply:GetAdminMode()
end

--From base gamemode
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local len = velocity:Length()
	local rate = 1

	if ( len > 0.2 ) then
		rate = ( len / maxseqgroundspeed )
	end

	local n_rate, noclamp = hook.Run( "SLCMovementAnimSpeed", ply, velocity, maxseqgroundspeed, len, rate )
	if isnumber( n_rate ) then
		rate = n_rate
	end

	if !noclamp and rate > 2 then
		rate = 2
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

--[[-------------------------------------------------------------------------
Move functions
---------------------------------------------------------------------------]]
CAMERA_MASK = bit.lshift( 1, 31 )
MOVEMENT_MASK = bit.lshift( 1, 30 )

function GM:StartCommand( ply, cmd )
	if controller.StartCommand( ply, cmd ) then return true end

	if ply:Alive() and !IsValid( ply:GetActiveWeapon() ) then
		local holster = ply:GetWeaponByBase( "item_slc_holster" )
		if IsValid( holster ) then
			cmd:SelectWeapon( holster )
		end
	end

	if ply.GetDisableControls and ply:GetDisableControls() then
		local mask = ply:GetDisableControlsMask()
		if mask == 0 then
			cmd:ClearButtons()
		else
			cmd:SetButtons( bit.band( cmd:GetButtons(), mask ) )
		end

		if bit.band( mask, CAMERA_MASK ) == 0 then
			if !ply.DisableControlsAngle then
				ply.DisableControlsAngle = cmd:GetViewAngles()
			end

			cmd:SetViewAngles( ply.DisableControlsAngle )
		end

		if bit.band( mask, MOVEMENT_MASK ) == 0 then
			cmd:ClearMovement()
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

function GM:SetupMove( ply, mv, cmd )
	if controller.SetupMove( ply, mv, cmd ) then return true end
end

function GM:Move( ply, mv )
	if controller.Move( ply, mv ) then return true end

	local speed_mod = { 1 }
	hook.Run( "SLCScaleSpeed", ply, speed_mod )

	local mod = speed_mod[1]

	if ply:SCPTeam() == TEAM_SCP and ply:GetProperty( "scp_buff" ) and ply:IsInZone( ZONE_SURFACE ) then
		mod = mod * 1.1
	end

	if mod != 1 then
		local speed = ( mv:KeyDown( IN_SPEED ) and ply:GetRunSpeed() or ply:GetWalkSpeed() ) * mod

		if ply:Crouching() then
			speed = speed * ply:GetCrouchedWalkSpeed()
		end

		mv:SetMaxSpeed( speed )
		mv:SetMaxClientSpeed( speed )
	end
end

--[[-------------------------------------------------------------------------
Footsteps
For some reason when players move slower than some speed threshold (91 hu/s) thay make no step sounds at all
So, yea, I created new step sound system
---------------------------------------------------------------------------]]
STEPTYPE_NORMAL = 0
STEPTYPE_LADDER = 1
STEPTYPE_WATER = 2

function GM:PlayerFootstep( ply, pos, foot, sound, vol, filter )
	return true
end

function GM:FinishMove( ply, mv )
	local mvtype = ply:GetMoveType()
	if SERVER and ( ply:OnGround() and ( mvtype == MOVETYPE_WALK or mvtype == MOVETYPE_STEP ) or mvtype == MOVETYPE_LADDER ) then
		local vel = mv:GetVelocity()
		local len = vel:Length()

		if ply.slc_next_footstep then
			ply.slc_next_footstep = ply.slc_next_footstep - len * FrameTime()

			if ply.slc_next_footstep <= 0 then
				ply:PlayStepSound()
			end
		end

		if !ply.slc_next_footstep or ply.slc_next_footstep <= 0 then
			ply:UpdateStepTime()
		end
	end

	if controller.FinishMove( ply, mv ) then return true end
end


function GM:SLCPlayerFootstep( ply, foot, snd )

end

function GM:SLCFootstepParams( ply, st, vel, crouch )
	if st == STEPTYPE_LADDER then
		return 100
	end

	local units = 50
	local len = vel:Length()

	if len > 125 then
		units = units + len / 10
	end

	if crouch then
		units = units - 15
	end

	if units < 25 then
		units = 25
	end

	return units
end

if !SLCStepSoundsAdded then
	SLCStepSoundsAdded = true

	for i, v in ipairs( sound.GetTable() ) do
		if !string.find( v, "StepLeft" ) and !string.find( v, "StepRight" ) then continue end

		local tab = sound.GetProperties( v )
		local orig = tab.name
		
		tab.name = orig.."Walk"
		tab.level = 70
		tab.volume = 0.7
		sound.Add( tab )

		tab.name = orig.."Crouch"
		tab.level = 65
		tab.volume = 0.4
		sound.Add( tab )
	end
end

--[[-------------------------------------------------------------------------
Fall Damage
---------------------------------------------------------------------------]]
local function calc_fall_threshold( ply )
	local vest = ply:GetVest()
	if vest > 0 then
		local data = VEST.GetData( vest )
		if data then
			return math.max( 300 / ( 1 + data.weight / 10 ), 75 )
		end
	end

	return 300
end

local function calc_fall_dmg( ply, speed )
	if speed <= 100 then
		return speed * 0.1
	elseif speed <= 200 then
		return speed * 0.15
	elseif speed <= 300 then
		return speed * 0.25
	else
		return speed * 0.5
	end
end

function GM:OnPlayerHitGround( ply, water, floater, speed )
	if CLIENT then return true end
	local override, threshold, damage = hook.Run( "SLCFallDamage", ply, water, floater, speed )

	if override then
		speed = override
	end

	threshold = threshold or calc_fall_threshold( ply )

	ply:PlayStepSound()

	if speed <= threshold then return true end
	
	if !water then
		if speed > 300 then
			local ang = math.min( speed - 300, 750 ) * 0.03
			ply:ViewPunch( Angle( 0, 0, ang ) )
		end

		local dmg_t = threshold + 150
		if damage or speed > dmg_t then
			local dmg = damage or calc_fall_dmg( ply, speed - dmg_t )
			if dmg > 0 then
				local info = DamageInfo()
				info:SetAttacker( ply )
				info:SetDamageType( DMG_FALL )

				if ply:HasEffect( "fracture" ) then
					info:SetDamage( dmg * 2.5 )
					ply:ApplyEffect( "bleeding", ply )
				else
					info:SetDamage( dmg )
				end

				if dmg > 25 then
					ply:ApplyEffect( "fracture" )
				end

				ply:TakeDamageInfo( info )
				ply:EmitSound( "Player.FallDamage", 100, 100, 1, CHAN_BODY )
			end
		end
	else
		ply:EmitSound( "Physics.WaterSplash" )
	end

	return true
end