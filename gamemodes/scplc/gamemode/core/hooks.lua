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

	if !SCPHooks.__ActiveSCPs[scp] then return end

	hook.Add( name, scp, func )

	if !DEVELOPER_MODE then return end
	print( "Refreshing SCP hook", scp, name )
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

--[[-------------------------------------------------------------------------
Player Hooks
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:AddHook( name, identifier, func )
	if !self._PlayerHooks then
		self._PlayerHooks = {}
	end

	if !self._PlayerHooks[name] then
		self._PlayerHooks[name] = {}
	end

	local hook_id = identifier..self:SteamID64()
	self._PlayerHooks[name][hook_id] = true
	hook.Add( name, hook_id, func )
end

function PLAYER:RemoveHook( name, identifier )
	if !self._PlayerHooks or !self._PlayerHooks[name] then return end

	local hook_id = identifier..self:SteamID64()
	if !self._PlayerHooks[name][hook_id] then return end

	hook.Remove( name, hook_id )
end

function PLAYER:ClearHooks()
	if !self._PlayerHooks then return end

	for name, tab in pairs( self._PlayerHooks ) do
		for id in pairs( tab ) do
			hook.Remove( name, id )
		end
	end

	self._PlayerHooks = {}
end

hook.Add( "SLCPlayerCleanup", "ClearPlayerHooks", function( ply )
	ply:ClearHooks()
end )