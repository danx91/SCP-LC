local commands_registry = {}

function AddChatCommand( cmd, callback, realm, hide )
	cmd = string.lower( cmd )

	if !string.StartsWith( cmd, "!" ) then
		cmd = "!"..cmd
	end

	commands_registry[cmd] = {
		realm = realm != false,
		callback = callback,
		hide = hide,
	}
end

if SERVER then
	hook.Add( "PlayerSay", "SLCChatCommands", function( ply, msg, teamonly )
		if !string.StartsWith( msg, "!" ) then return end

		local args = string.Explode( " ", msg )
		local cmd = table.remove( args, 1 )

		if isstring( cmd ) then
			cmd = string.lower( cmd )
		end

		local tab = commands_registry[cmd]
		if !tab or !tab.realm then
			net.Ping( "SCLChatCommand", msg, ply )

			if tab and tab.hide then
				return ""
			end

			return
		end

		if tab.callback then
			tab.callback( ply, args )
		end

		if tab.hide then
			return ""
		end
	end )
else
	net.ReceivePing( "SCLChatCommand", function( data )
		local args = string.Explode( " ", data )
		local cmd = table.remove( args, 1 )

		local tab = commands_registry[cmd]
		if !tab then
			//PlayerMessage( "unknown_cmd$"..cmd )
			return
		end

		if tab.callback then
			tab.callback( LocalPlayer(), args )
		end
	end )
end

AddChatCommand( "scp", function( ply )
	if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
	ply.ncmdcheck = CurTime() + 2

	PrintSCPNotice( ply )
end, SERVER, false )

AddChatCommand( "afk", function( ply )
	if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
	ply.ncmdcheck = CurTime() + 2

	ply:MakeAFK()
end, SERVER, false )

AddChatCommand( "bonus", function( ply )
	if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
	ply.ncmdcheck = CurTime() + 2

	local next_reset = ( SLC_UNIX_DAY + 1 ) * 86400 + CVAR.slc_dailyxp_time:GetInt() - os.time()
	PlayerMessage( string.format( "dailybonus$%i,%02ih %02im", ply:DailyBonus(), math.floor( next_reset / 3600 ), math.floor( next_reset % 3600 / 60 ) ), ply )
end, SERVER, true )

AddChatCommand( "adminmode", function( ply )
	if ply.ncmdcheck and ply.ncmdcheck > CurTime() then return end
	ply.ncmdcheck = CurTime() + 2

	if SLCAuth.HasAccess( ply, "slc adminmode" ) then
		ply:ToggleAdminMode()
	end
end, SERVER, true )

AddChatCommand( "muteall", function( ply )
	for i, v in ipairs( player.GetAll() ) do
		v:SetMuted( true )
	end
end, CLIENT, true )

AddChatCommand( "unmuteall", function( ply )
	for i, v in ipairs( player.GetAll() ) do
		v:SetMuted( false )
	end
end, CLIENT, true )

AddChatCommand( "settings", function( ply )
	OpenSettingsWindow()
end, CLIENT, true )

AddChatCommand( "queue", function( ply )
	if ply:SCPTeam() != TEAM_SPEC then
		PlayerMessage( "queue_alive" )
	else
		local pos = ply:GetQueuePosition()
		if pos == -1 then
			PlayerMessage( "queue_low" )
		elseif pos == 0 then
			PlayerMessage( "queue_not" )
		else
			PlayerMessage( "queue_pos$"..pos )
		end
	end
end, CLIENT, true )