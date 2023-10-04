slc_cmd = {}
local commands = {}

local function exec_cmd( ply, name, args )
	local cmd = commands[name]
	if !cmd or !slc_cmd.ExecCallback( ply, name, args ) then return end

	net.Start( "PlayerCommand" )
		net.WriteString( name )
		net.WriteTable( args )
	net.SendToServer()
end

function slc_cmd.AddCommand( name, callback, cooldown )
	commands[name] = {
		callback = callback,
		cooldown = cooldown,
		cd = {}
	}

	if CLIENT then
		concommand.Add( name, exec_cmd )
	end
end

if CLIENT then
	function slc_cmd.Run( name, args )
		exec_cmd( LocalPlayer(), name, istable( args ) and args or { args } )
	end
end

function slc_cmd.ExecCallback( ply, name, args )
	local cmd = commands[name]
	if !cmd then return false end

	local ct = CurTime()
	if cmd.cd[ply] and cmd.cd[ply] > ct then return false end

	for k, v in pairs( cmd.cd ) do
		if !IsValid( k ) then
			cmd.cd[k] = nil
		end
	end

	if cmd.callback and cmd.callback( ply, name, args ) == true then
		return false
	end

	if cmd.cooldown then
		cmd.cd[ply] = ct + cmd.cooldown
	end

	return true
end

function slc_cmd.GetCommandCooldown( name )
	return commands[name] and commands[name].cooldown
end

function slc_cmd.GetPlayerCooldown( ply, name )
	return commands[name] and commands[name].cd[ply]
end