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
	ply:NetworkVar( "Int", 6, "PrestigeLevel" )
	
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
	ply:AddSLCVar( "_DailyBonus", 6, "INT" )
	ply:AddSLCVar( "QueuePosition", 7, "INT" )
	ply:AddSLCVar( "_PrestigePoints", 8, "INT" )
	ply:AddSLCVar( "_SpectatorPoints", 9, "INT" )

	ply:AddSLCVar( "VestDurability", 0, "FLOAT" )
	ply:AddSLCVar( "StaminaBoost", 1, "FLOAT" )
	ply:AddSLCVar( "StaminaBoostDuration", 2, "FLOAT" )

	ply:AddSLCVar( "DisableControls", 0, "BOOL" )
	ply:AddSLCVar( "AdminMode", 1, "BOOL" )

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
			ply:GetSCPData( "spectator_points", -1 )
		):Then( function( data )
			ply:Set_SCPLevel( tonumber( data[1] ) )
			ply:Set_SCPExp( tonumber( data[2] ) )
			ply:Set_SCPClassPoints( tonumber( data[3] ) )
			ply:Set_DailyBonus( tonumber( data[4] ) )
			ply:SetPrestigePoints( tonumber( data[5] ) )
			ply:SetPrestigeLevel( tonumber( data[6] ) )
			ply:SetSpectatorPoints( tonumber( data[7] ) )

			--REMOVE
			if tonumber( data[7] ) == -1 then
				ply:SetSpectatorPoints( ( tonumber( data[6] ) * 35 + tonumber( data[1] ) ) * 3550 )
			end
		end )
	end

	if CLIENT then
		ply:RequestSLCVars()
	end
end


player_manager.RegisterClass( "class_slc", PLAYER, "player_default" )