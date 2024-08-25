--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
SCPHooks = SCPHooks or {
	__ActiveSCPs = {},
	__PreventUpdate = false,
}

function SCPHook( scp, name, func )
	if !SCPHooks[scp] then
		SCPHooks[scp] = {}
	end

	SCPHooks[scp][name] = func
end

function EnableSCPHook( scp )
	if SCPHooks.__ActiveSCPs[scp] then return end
	SCPHooks.__ActiveSCPs[scp] = true

	if SERVER and !SCPHooks.__PreventUpdate then
		net.Start( "SCPHooks" )
			net.WriteBool( false )
			net.WriteString( scp )
		net.Broadcast()
	end

	local tab = SCPHooks[scp]
	if !tab then return end

	for k, v in pairs( tab ) do
		hook.Add( k, scp, v )
		//print( "hook enabled", k, scp )
	end
end

function DisableSCPHook( scp )
	SCPHooks.__ActiveSCPs[scp] = nil

	local tab = SCPHooks[scp]
	if !tab then return end

	for k, v in pairs( tab ) do
		hook.Remove( k, scp )
		//print( "[single] hook removed", k, scp )
	end
end

function ClearSCPHooks()
	for scp, _ in pairs( SCPHooks.__ActiveSCPs ) do
		if !SCPHooks[scp] then continue end

		for k, _ in pairs( SCPHooks[scp] ) do
			hook.Remove( k, scp )
			//print( "[clear] hook removed", k, scp )
		end
	end

	SCPHooks.__ActiveSCPs = {}
end

function TransmitSCPHooks( ply )
	net.Start( "SCPHooks" )
		net.WriteBool( true )
		net.WriteTable( SCPHooks.__ActiveSCPs )

	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end
end

--[[-------------------------------------------------------------------------
Round Hooks
---------------------------------------------------------------------------]]
RoundHooks = RoundHooks or {}

function AddRoundHook( name, identifier, func )
	hook.Add( name, identifier, func )

	if !RoundHooks[name] then
		RoundHooks[name] = {}
	end

	RoundHooks[name][identifier] = true
end

function RemoveRoundHook( name, identifier )
	hook.Remove( name, identifier )

	if !RoundHooks[name] then return end
	RoundHooks[name][identifier] = nil
end

function ClearRoundHooks()
	for name, tab in pairs( RoundHooks ) do
		for identifier, _ in pairs( tab ) do
			hook.Remove( name, identifier )
		end
	end

	RoundHooks = {}
end

hook.Add( "SLCRoundCleanup", "ClearRoundHooks", ClearRoundHooks )