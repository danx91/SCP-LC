local commands_registry = {}
local commands_aliases = {}

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

		if !tab then
			local alias = commands_aliases[cmd]
			if alias then
				tab = commands_registry[alias]
			end
		end

		if !tab or !tab.realm then
			net.Ping( "SLCChatCommand", msg, ply )

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
	net.ReceivePing( "SLCChatCommand", function( data )
		local args = string.Explode( " ", data )
		local cmd = table.remove( args, 1 )

		local tab = commands_registry[cmd]
		if !tab then
			local alias = commands_aliases[cmd]
			if !alias then return end

			tab = commands_registry[alias]
			if !tab then return end
		end

		if tab.callback then
			tab.callback( LocalPlayer(), args )
		end
	end )
end

--[[-------------------------------------------------------------------------
Aliases
---------------------------------------------------------------------------]]
hook.Add( "SLCFullyLoaded", "SLCChatCommandsAliases", function()
	for _, lang in pairs( _LANG ) do
		if !lang.MISC.commands_aliases then continue end

		for alias, cmd in pairs( lang.MISC.commands_aliases ) do
			if !string.StartsWith( alias, "!" ) then
				alias = "!"..alias
			end

			if !string.StartsWith( cmd, "!" ) then
				cmd = "!"..cmd
			end

			commands_aliases[alias] = cmd
		end
	end
end )

--[[-------------------------------------------------------------------------
Base chat commands
---------------------------------------------------------------------------]]
AddChatCommand( "afk", function( ply )
	if ply.ncmdcheck and ply.ncmdcheck > CurTime() or !ply:IsValidSpectator() then return end
	ply.ncmdcheck = CurTime() + 2

	ply:MakeAFK( 30 )
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

AddChatCommand( "scp", function( ply )
	PrintSCPNotice()
end, CLIENT, true )

AddChatCommand( "karma", function( ply )
	if CVAR.slc_scp_karma:GetInt() != 1 then return end

	local karma = ply:GetPlayerKarma()
	local standing = "good"

	if karma < -500 then
		standing = "vbad"
	elseif karma < -100 then
		standing = "bad"
	elseif karma > 900 then
		standing = "perfect"
	elseif karma > 400 then
		standing = "vgood"
	end

	PlayerMessage( "karma$@MISC.karma."..standing )
end, CLIENT, true )