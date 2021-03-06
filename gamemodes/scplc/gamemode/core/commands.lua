cmd = {}
local commands = {}

local function sendCMD( ply, c, args )
	net.Start( "PlayerCommand" )
		net.WriteString( c )
		net.WriteTable( args )
	net.SendToServer()
end

function cmd.AddCommand( name, callback )
	if SERVER then
		commands[name] = callback
	else
		concommand.Add( name, sendCMD )
	end
end

function cmd.ExecCallback( ply, name, args )
	local callback = commands[name]

	if callback then
		callback( ply, name, args )
	end
end