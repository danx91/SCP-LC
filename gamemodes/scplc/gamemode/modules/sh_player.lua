--[[-------------------------------------------------------------------------
Gamemode hooks
---------------------------------------------------------------------------]]
function GM:KeyPress( ply, key )
	
end

function GM:PlayerNoClip( ply, on )
	return ply:SCPTeam() == TEAM_SPEC and on == true
end

function GM:PlayerButtonDown( ply, button )
	if SERVER and !ply:IsBot() then
		if ply:SCPTeam() == TEAM_SPEC then
			if button == MOUSE_LEFT then
				ply:SpectatePlayerNext()
			elseif button == MOUSE_RIGHT then
				ply:SpectatePlayerPrev()
			elseif button == KEY_SPACE or button == KEY_R then
				ply:ChangeSpectateMode()
			end
		end
	end

	if SERVER then numpad.Activate( ply, button ) end

	if CLIENT and IsFirstTimePredicted() then
		local menu_key = input.LookupBinding( "+menu" )
		if menu_key then
			if input.GetKeyCode( menu_key ) == button then
				if CanShowEQ() then
					ShowEQ()
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
			OpenClassViever()
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

end

function GM:KeyRelease( ply, key )

end

function GM:StartCommand( ply, cmd )
	if ply:HasEffect( "amnc227" ) then
		cmd:RemoveKey( IN_ATTACK )
		cmd:RemoveKey( IN_ATTACK2 )
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
	if #ply:GetWeapons() >= 8 then
		if wep.Stacks and wep.Stacks <= 1 then return false end

		local pwep = ply:GetWeapon( wep:GetClass() )
		if !IsValid( pwep ) then return false end
		if pwep.CanStack and !pwep:CanStack() then return false end
	end

	if t == TEAM_SCP and !ply:GetSCPHuman() then
		if wep.SCP then
			return true
		end

		return false
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
		return true
	elseif wep.Dropped > CurTime() - 1 then
		return false
	end

	if ply:KeyDown( IN_USE ) then
		if wep == ply:GetEyeTrace().Entity then
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