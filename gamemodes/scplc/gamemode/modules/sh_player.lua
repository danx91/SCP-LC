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

function GM:PlayerSwitchWeapon( ply, old, new )
	if !IsValid( new ) then return end

	if new.eq_slot and new.eq_slot > 6 then return true end
	if new.OnSelect and new:OnSelect() == true then return true end
	if new.Selectable == false then return true end
	if ply:GetProperty( "prevent_weapon_switch", 0 ) >= CurTime() then return true end

	//new:ResetViewModelBones()
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
		if wep.Stacks and wep.Stacks <= 1 then return false, "max_eq" end --TEST does it work for non stackable items?

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
	local group = SLC_WEAPON_GROUP_OVERRIDE[class] or tab and tab.Group
	
	if !group then return end

	for k, v in pairs( ply:GetWeapons() ) do
		if v:GetGroup() == group then
			return false, "same_type"
		end
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

local PLAYER = FindMetaTable( "Player" )

--[[-------------------------------------------------------------------------
SLCProperties
---------------------------------------------------------------------------]]
function PLAYER:ResetProperties()
	self.SLCProperties = {}
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

	if !self.SLCProperties[key] and def then
		self.SLCProperties[key] = def
	end

	return self.SLCProperties[key]
end

--[[-------------------------------------------------------------------------
Hold manager
---------------------------------------------------------------------------]]
function PLAYER:StartHold( tab, id, key, time, cb, never )
	if !self:KeyDown( key ) then return end

	if !tab._ButtonHold then
		tab._ButtonHold = {}
	end

	id = id..self:SteamID()

	local data = {
		key = key,
		duration = time,
		time = CurTime() + time,
		never = !!never,
		cb = cb,
	}

	tab._ButtonHold[id] = data
end

function PLAYER:UpdateHold( tab, id )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	if data.interrupted or !self:KeyDown( data.key ) then
		if data.cb then data.cb( self, tab, false ) end
		tab._ButtonHold[id] = nil
		return false, data
	end

	if !data.never and data.time <= CurTime() then
		if data.cb then data.cb( self, tab, true ) end
		tab._ButtonHold[id] = nil
		return true, data
	end
end

function PLAYER:InterruptHold( tab, id )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	tab._ButtonHold[id].interrupted = true
end

function PLAYER:IsHolding( tab, id )
	if !tab._ButtonHold then return false end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return false end

	return self:KeyDown( data.key )
end

function PLAYER:HoldProgress( tab, id )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	return math.Clamp( 1 - ( data.time - CurTime() ) / data.duration, 0, 1 )
end

--[[-------------------------------------------------------------------------
Disable Controls
---------------------------------------------------------------------------]]
function PLAYER:DisableControls( id, mask )
	if !self.DisableControlsRegistry then
		self.DisableControlsRegistry = {}
	end

	mask = mask or 0

	self.DisableControlsRegistry[id] = mask

	self:SetDisableControls( true )
	self:SetDisableControlsMask( bit.band( self:GetDisableControlsMask(), mask ) )
end

function PLAYER:StopDisableControls( id )
	if !self.DisableControlsRegistry or !self.DisableControlsRegistry[id] then return end

	self.DisableControlsRegistry[id] = nil

	if !next( self.DisableControlsRegistry ) then
		self:SetDisableControls( false )
		self:SetDisableControlsMask( -1 )
		return
	end

	local mask = -1
	for k, v in pairs( self.DisableControlsRegistry ) do
		mask = bit.band( mask, v )
		
		if mask == 0 then break end
	end

	self:SetDisableControlsMask( mask )
end

function PLAYER:ResetDisableControls()
	self:SetDisableControls( false )
	self:SetDisableControlsMask( -1 )
	self.DisableControlsRegistry = {}
end

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
function PLAYER:DataTables()
	if !IsValid( self ) then return end

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

local function db_functions( func, db )
	local getter = "Get_"..func
	local setter = "Set_"..func

	PLAYER["Get"..func] = function( self )
		return self[getter]( self )
	end

	PLAYER["Set"..func] = function( self, val )
		self[setter]( self, val )
		self:SetSCPData( db, val )
	end
end

accessor( "IsActive", "_SCPActive" )
accessor( "IsPremium", "_SCPPremium" )
accessor( "IsAFK", "_SCPAFK" )
accessor( "SCPLevel" )
accessor( "SCPExp" )
accessor( "SCPClassPoints" )
accessor( "DailyBonus" )

db_functions( "SpectatorPoints", "spectator_points" )

function PLAYER:GetPrestigePoints()
	return self:Get_PrestigePoints()
end

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
	local backpack = self:GetWeapon( "item_slc_backpack" )
	if IsValid( backpack ) then
		return 6 + backpack:GetSize()
	end

	return 6
end

function PLAYER:GetFreeInventory()
	local weps = self:GetWeapons()
	local free = self:GetInventorySize()

	for i, v in ipairs( weps ) do
		if v:GetClass() == "item_slc_id" or v:IsDerived( "item_slc_holster" ) then continue end

		free = free - 1
	end

	return free
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
	local mask = self:GetWeaponByGroup( "gasmask" )
	if IsValid( mask ) and mask:GetEnabled() then
		if dmg then
			mask:Damage( dmg )
		end

		return true
	end
end

function PLAYER:CheckHazmat( dmg, full )
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
		
		return !full or dur > 0
	end

	return false
end

function PLAYER:GetWeaponByGroup( group )
	for i, v in ipairs( self:GetWeapons() ) do
		if v.Group and v.Group == group then
			return v
		end
	end
end

function PLAYER:GetWeaponByBase( base, all )
	local tab

	if all then
		tab = {}
	end

	for i, v in ipairs( self:GetWeapons() ) do
		if v:IsDerived( base ) then
			if !all then
				return v
			end

			table.insert( tab, v )
		end
	end

	return tab
end

function PLAYER:GetMainWeapon()
	for i, v in ipairs( self:GetWeapons() ) do
		if SLC_WEAPONS_REG[v:GetClass()] then
			return v
		end
	end
end

function PLAYER:GetSCPWeapon()
	local wep = self:GetProperty( "scp_weapon" )
	if wep then return wep end

	for i, v in ipairs( self:GetWeapons() ) do
		if v.SCP then
			self:SetProperty( "scp_weapon", v )			
			return v
		end
	end

	return NULL
end

function PLAYER:TrueFOV()
	return math.TrueFOV( self:GetFOV() )
end

function PLAYER:ChatPrint( ... )
	if CLIENT then
		chat.AddText( ... )
	else
		net.Start( "SLCChatPrint" )
			net.WriteTable( { ... } )
		net.Send( self )
	end
end