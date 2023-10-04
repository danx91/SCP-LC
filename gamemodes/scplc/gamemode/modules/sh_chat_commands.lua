local commands_registry = {}

function AddChatCommand( cmd, callback )
	commands_registry[cmd] = callback
end

if SERVER then
	hook.Add( "PlayerSay", "SLCChatCommands", function( ply, msg, teamonly )
		if string.StartWith( msg, "!" ) then
			local space = string.find( msg, " " ) or ( string.len( msg ) + 1 )
			local cmd, sargs = string.sub( msg, 2, space - 1 ), string.sub( msg, space + 1 )

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

			local cb = commands_registry[cmd]
			if cb then
				cb( ply, string.Explode( " ", sargs ), sargs )
				return true
			end
		end
	end )
end

if SERVER then
	AddChatCommand( "scp", function( ply )
		if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
		ply.ncmdcheck = CurTime() + 5

		PrintSCPNotice( ply )
	end )

	AddChatCommand( "afk", function( ply )
		if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
		ply.ncmdcheck = CurTime() + 5

		ply:MakeAFK()
	end )

	AddChatCommand( "bonus", function( ply )
		if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
		ply.ncmdcheck = CurTime() + 5

		local next_reset = ( SLC_UNIX_DAY + 1 ) * 86400 + CVAR.slc_dailyxp_time:GetInt() - os.time()
		PlayerMessage( string.format( "dailybonus$%i,%02ih %02im", ply:DailyBonus(), math.floor( next_reset / 3600 ), math.floor( next_reset % 3600 / 60 ) ), ply )
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