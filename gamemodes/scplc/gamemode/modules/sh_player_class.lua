local PLAYER = {}

function PLAYER:SetupDataTables()
	local ply = self.Player

	print("Setting up datatables for " .. ply:Nick() )
	ply:NetworkVar( "Bool", 0, "_SCPActive" )
	ply:NetworkVar( "Bool", 1, "_SCPPremium" )

	ply:NetworkVar( "Int", 0, "_SCPTeam" )
	ply:NetworkVar( "Int", 1, "_SCPPersonaT" )
	
	ply:NetworkVar( "Int", 2, "_SCPLevel" )
	ply:NetworkVar( "Int", 3, "_SCPExp" )
	ply:NetworkVar( "Int", 4, "_SCPPrestige" )

	ply:NetworkVar( "String", 0, "_SCPClass" )
	ply:NetworkVar( "String", 1, "_SCPPersonaC" )

	ply:AddSCPVar( "Sanity", 0, "INT" )
	ply:AddSCPVar( "MaxSanity", 1, "INT" )
	ply:AddSCPVar( "Vest", 2, "INT" )

	if SERVER then
		ply:Set_SCPActive( false )
		ply:Set_SCPPremium( false )

		ply:Set_SCPTeam( TEAM_SPEC )
		ply:Set_SCPPersonaT( TEAM_SPEC )

		ply:Set_SCPClass( "spectator" )
		ply:Set_SCPPersonaC( "spectator" )

		ply:Set_SCPLevel( tonumber( ply:GetSCPData( "level", 0 ) ) or 0 )
		ply:Set_SCPExp( tonumber( ply:GetSCPData( "xp", 0 ) ) or 0 )
		ply:Set_SCPPrestige( 0 )

		ply:SetSanity( 100 )
		ply:SetMaxSanity( 100 )
		ply:SetVest( 0 )
	end

	if CLIENT then
		ply:RequestSCPVars()
	end
end


player_manager.RegisterClass( "class_slc", PLAYER, "player_default" )