local commands_registry = {}

function AddChatCommand( cmd, callback )
	commands_registry[cmd] = callback
end

if SERVER then
	hook.Add( "PlayerSay", "SLCChatCommands", function( ply, msg, teamonly )
		if string.StartWith( msg, "!" ) then
			local space = string.find( msg, " " ) or ( string.len( msg ) + 1 )
			local cmd, sargs = string.sub( msg, 2, space - 1 ), string.sub( msg, space + 1 )

			//print( cmd, sargs )

			local cb = commands_registry[cmd]
			if cb then
				cb( ply, string.Explode( " ", sargs ), sargs )
				return ""
			end
		end
	end )
else
	hook.Add( "OnPlayerChat", "SLCChatCommands", function(ply, msg, teamonly, dead)
		if ply != LocalPlayer() then return end

		if string.StartWith( msg, "!" ) then
			local space = string.find( msg, " " ) or ( string.len( msg ) + 1 )
			local cmd, sargs = string.sub( msg, 2, space - 1 ), string.sub( msg, space + 1 )

			//print( cmd, sargs )

			local cb = commands_registry[cmd]
			if cb then
				cb( ply, string.Explode( " ", sargs ), sargs )
			end
		end
	end )
end

if SERVER then
	AddChatCommand( "scp", function( ply )
		if !ply.nscpcmdcheck or ply.nscpcmdcheck < CurTime() then
			ply.nscpcmdcheck = CurTime() + 10

			PrintSCPNotice( ply )
		end
	end )

	AddChatCommand( "afk", function( ply )
		ply:MakeAFK()
	end )
else
	AddChatCommand( "muteall", function( ply )
		for k, v in pairs( player.GetAll() ) do
			v:SetMuted( true )
		end
	end )

	AddChatCommand( "unmuteall", function( ply )
		for k, v in pairs( player.GetAll() ) do
			v:SetMuted( false )
		end
	end )
	
	AddChatCommand( "settings", function( ply )
		OpenSettingsWindow()
	end )
end