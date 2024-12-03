MINIGAMES_PATH = BASE_GAMEMODE_PATH.."/minigames"

LoadFolder( MINIGAMES_PATH, "\t> " )

function CanOpenMinigame( ply )
	return ply:IsSpectator()
end

if CLIENT then
	hook.Add( "player_spawn", "SLCMinigames", function( data )
		local ply = Player( data.userid )
		if !IsValid( ply ) or ply != LocalPlayer() then return end

		hook.Run( "SLCCloseMinigames" )
	end )
end

local handler = SLCFrameHandler( "minigames" )

hook.Add( "SLCCloseMinigames", "CloseMinigamesFrame", function()
	handler:CloseFrame()
end )

AddChatCommand( "minigames", function( ply )
	if !CanOpenMinigame( ply ) then return end
	handler:OpenFrame()
end, CLIENT, true )