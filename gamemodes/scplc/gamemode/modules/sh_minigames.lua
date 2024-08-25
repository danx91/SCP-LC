MINIGAMES_PATH = BASE_GAMEMODE_PATH.."/minigames"

LoadFolder( MINIGAMES_PATH, "\t> " )

if CLIENT then
	function CanOpenMinigame()
		return LocalPlayer():IsSpectator()
	end

	hook.Add( "player_spawn", "SLCMinigames", function( data )
		local ply = Player( data.userid )
		if !IsValid( ply ) or ply != LocalPlayer() then return end

		hook.Run( "SLCCloseMinigames" )
	end )
end