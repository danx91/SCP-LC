local PLAYER = {}

function PLAYER:SetupDataTables()
	local ply = self.Player

	print("Setting up datatables for " .. ply:Nick() )
	ply:NetworkVar( "Bool", 0, "_SCPActive" )
	ply:NetworkVar( "Bool", 1, "_SCPPremium" )
	ply:NetworkVar( "Bool", 2, "_SCPAFK" )
	ply:NetworkVar( "Bool", 3, "Exhausted" )

	ply:NetworkVar( "Int", 0, "_SCPTeam" )
	ply:NetworkVar( "Int", 1, "_SCPPersonaT" )
	
	ply:NetworkVar( "Int", 2, "_SCPLevel" )
	ply:NetworkVar( "Int", 3, "_SCPExp" )
	ply:NetworkVar( "Int", 4, "_SCPClassPoints" )
	ply:NetworkVar( "Int", 5, "TimeSignature" )
	ply:NetworkVar( "Int", 6, "Stamina" ) --although this could be SLCVar, NetworkVar is more reliable and has prediction error correction

	ply:NetworkVar( "Float", 0, "ExtraHealth" )
	ply:NetworkVar( "Float", 1, "MaxExtraHealth" )

	ply:NetworkVar( "String", 0, "_SCPClass" )
	ply:NetworkVar( "String", 1, "_SCPPersonaC" )

	ply:AddSLCVar( "Sanity", 0, "INT" )
	ply:AddSLCVar( "MaxSanity", 1, "INT" )
	ply:AddSLCVar( "Vest", 2, "INT" )
	ply:AddSLCVar( "MaxStamina", 3, "INT" )
	ply:AddSLCVar( "StaminaLimit", 4, "INT" )
	ply:AddSLCVar( "DisableControlsFlag", 5, "INT" )
	ply:AddSLCVar( "_DailyBonus", 6, "INT" )
	ply:AddSLCVar( "Backpack", 7, "INT" )

	ply:AddSLCVar( "VestDurability", 0, "FLOAT" )
	ply:AddSLCVar( "StaminaBoost", 1, "FLOAT" )
	ply:AddSLCVar( "StaminaBoostDuration", 2, "FLOAT" )

	ply:AddSLCVar( "DisableControls", 0, "BOOL" )

	if SERVER then
		ply:Set_SCPActive( false )
		ply:Set_SCPPremium( false )
		ply:Set_SCPAFK( false )
		ply:SetExhausted( false )

		ply:Set_SCPTeam( TEAM_SPEC )
		ply:Set_SCPPersonaT( TEAM_SPEC )

		ply:Set_SCPClass( "spectator" )
		ply:Set_SCPPersonaC( "spectator" )

		ply:SetTimeSignature( math.floor( CurTime() ) )
		ply:SetStamina( 100 )

		ply:SetExtraHealth( 0 )
		ply:SetMaxExtraHealth( 0 )

		ply:SetSanity( 100 )
		ply:SetMaxSanity( 100 )
		ply:SetVest( 0 )
		ply:SetMaxStamina( 100 )
		ply:SetStaminaLimit( 100 )
		ply:SetDisableControlsFlag( 0 )
		ply:SetBackpack( 0 )

		ply:SetVestDurability( -1 )
		ply:SetStaminaBoost( 0 )
		ply:SetStaminaBoostDuration( 0 )

		ply:SetDisableControls( false )

		ply:SetDataFromDB( "level", 0, tonumber, "_SCPLevel" )
		ply:SetDataFromDB( "xp", 0, tonumber, "_SCPExp" )
		ply:SetDataFromDB( "class_points", 0, tonumber, "_SCPClassPoints" )
		ply:SetDataFromDB( "daily_bonus", 0, tonumber, "_DailyBonus" )
	end

	if CLIENT then
		ply:RequestSLCVars()
	end
end


player_manager.RegisterClass( "class_slc", PLAYER, "player_default" )