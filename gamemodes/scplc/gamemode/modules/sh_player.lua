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
		local key = input.LookupBinding( "+menu" )

		if key then
			if input.GetKeyCode( key ) == button then
				if CanShowEQ() then
					ShowEQ()
				end
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
		local key = input.LookupBinding( "+menu" )

		if key then
			if input.GetKeyCode( key ) == button then
				HideEQ()
			end
		end
	end
end

function GM:KeyPress( ply, key )

end

function GM:KeyRelease( ply, key )

end

/*function GM:StartCommand( ply, cmd )

end*/

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