local PLAYER = {}

function PLAYER:SetupDataTables()
	local ply = self.Player

	print("Setting up datatables for " .. ply:Nick() )
	ply:NetworkVar( "Bool", 0, "_IsActive" )
	ply:NetworkVar( "Bool", 1, "_IsPremium" )
	ply:NetworkVar( "Bool", 2, "_IsAFK" )
	ply:NetworkVar( "Bool", 3, "Exhausted" )

	ply:NetworkVar( "Int", 0, "_SCPTeam" )
	ply:NetworkVar( "Int", 1, "_SCPPersonaT" )

	ply:NetworkVar( "Int", 2, "_PlayerLevel" )
	ply:NetworkVar( "Int", 3, "_PlayerXP" )
	ply:NetworkVar( "Int", 4, "_ClassPoints" )
	ply:NetworkVar( "Int", 5, "_PrestigeLevel" )
	ply:NetworkVar( "Int", 6, "TimeSignature" )

	ply:NetworkVar( "Float", 0, "Stamina" )
	ply:NetworkVar( "Float", 1, "ExtraHealth" )
	ply:NetworkVar( "Float", 2, "MaxExtraHealth" )

	ply:NetworkVar( "String", 0, "_SCPClass" )
	ply:NetworkVar( "String", 1, "_SCPPersonaC" )
	ply:NetworkVar( "String", 2, "Controller" )

	ply:AddSLCVar( "Sanity", 0, "INT" )
	ply:AddSLCVar( "MaxSanity", 1, "INT" )
	ply:AddSLCVar( "Vest", 2, "INT" )
	ply:AddSLCVar( "MaxStamina", 3, "INT" )
	ply:AddSLCVar( "StaminaLimit", 4, "INT" )
	ply:AddSLCVar( "DisableControlsMask", 5, "INT" )
	ply:AddSLCVar( "QueuePosition", 6, "INT" )
	ply:AddSLCVar( "_DailyBonus", 7, "INT" )
	ply:AddSLCVar( "_PrestigePoints", 8, "INT" )
	ply:AddSLCVar( "_SpectatorPoints", 9, "INT" )
	ply:AddSLCVar( "_SCPPenalty", 10, "INT" )
	ply:AddSLCVar( "_PlayerKarma", 11, "INT" )

	ply:AddSLCVar( "VestDurability", 0, "FLOAT" )
	ply:AddSLCVar( "StaminaBoost", 1, "FLOAT" )
	ply:AddSLCVar( "StaminaBoostDuration", 2, "FLOAT" )

	ply:AddSLCVar( "DisableControls", 0, "BOOL" )
	ply:AddSLCVar( "AdminMode", 1, "BOOL" )

	if SERVER then
		ply:Set_IsActive( false )
		ply:Set_IsPremium( false )
		ply:Set_IsAFK( false )
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
		ply:SetDisableControlsMask( -1 )
		ply:SetQueuePosition( 0 ) //0 - not in queue, -1 - in suicide queue

		ply:SetVestDurability( -1 )
		ply:SetStaminaBoost( 0 )
		ply:SetStaminaBoostDuration( 0 )

		ply:SetDisableControls( false )

		SLCPromiseJoin(
			ply:GetSCPData( "level", 0 ),
			ply:GetSCPData( "xp", 0 ),
			ply:GetSCPData( "class_points", 0 ),
			ply:GetSCPData( "daily_bonus", 0 ),
			ply:GetSCPData( "prestige_points", 0 ),
			ply:GetSCPData( "prestige_level", 0 ),
			ply:GetSCPData( "spectator_points", 0 ),
			ply:GetSCPData( "scp_penalty", 0 ),
			ply:GetSCPData( "scp_karma", 250 )
		):Then( function( data )
			ply:Set_PlayerLevel( tonumber( data[1] ) )
			ply:Set_PlayerXP( tonumber( data[2] ) )
			ply:Set_ClassPoints( tonumber( data[3] ) )
			ply:Set_DailyBonus( tonumber( data[4] ) )
			ply:Set_PrestigePoints( tonumber( data[5] ) )
			ply:Set_PrestigeLevel( tonumber( data[6] ) )
			ply:Set_SpectatorPoints( tonumber( data[7] ) )
			ply:Set_SCPPenalty( tonumber( data[8] ) )
			ply:Set_PlayerKarma( tonumber( data[9] ) )
		end )
	end

	if CLIENT then
		ply:RequestSLCVars()
	end
end


player_manager.RegisterClass( "class_slc", PLAYER, "player_default" )