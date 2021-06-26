--[[-------------------------------------------------------------------------
Gamemode hooks
---------------------------------------------------------------------------]]
function GM:PlayerNoClip( ply, on )
	return ply:SCPTeam() == TEAM_SPEC and on == true
end

function GM:PlayerButtonDown( ply, button )
	/*if SERVER and !ply:IsBot() then
		if ply:SCPTeam() == TEAM_SPEC then
			if button == MOUSE_LEFT then
				ply:SpectatePlayerNext()
			elseif button == MOUSE_RIGHT then
				ply:SpectatePlayerPrev()
			elseif button == KEY_SPACE or button == KEY_R then
				ply:ChangeSpectateMode()
			end
		end
	end*/

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
		local menu_key = input.LookupBinding( "+menu" )
		if menu_key then
			if input.GetKeyCode( menu_key ) == button then
				if CanShowEQ() then
					ShowEQ()
				end

				local t = ply:SCPTeam()
				if t == TEAM_SPEC then
					HUDSpectatorInfo = true
				end
			end
		end

		local zoom_key = input.LookupBinding( "+zoom" )
		if zoom_key then
			if input.GetKeyCode( zoom_key ) == button then
				ShowSCPUpgrades()
			end
		end

		if button == KEY_F1 then
			OpenClassViewer()
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
					//mask = 
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
		cmd:ClearButtons()
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
	return SCPTeams.HasInfo(self:SCPTeam(), SCPTeams.INFO_HUMAN) or self:GetSCPHuman()
end