--[[-------------------------------------------------------------------------
Gamemode hooks
---------------------------------------------------------------------------]]
function GM:PlayerSpray( ply )
	return true
end

function GM:ShutDown()
	
end

function GM:SCPDamage( ply, ent, dmg )
	if !IsValid( ply ) or !IsValid( ent ) then return end
	if !ent.SCPBreakable and ent:GetClass() != "func_breakable" then return end

	ent:TakeDamage( dmg, ply, ply )

	return true
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
end

function GM:GetFallDamage( ply, speed )
	return 0
end

function GM:Think()
	
end

function GM:PlayerPostThink( ply )
	ply:ChaseThink()

	--Ragdoll lootable think
	local ent = ply._RagEntity
	if IsValid( ent ) and ent.LootableCheck and ent.LootableCheck < RealTime() then
		ent.LootableCheck = RealTime() + 1
		ent:CheckListeners()
	end

	--Weapon holster think
	local active = ply:GetActiveWeapon()
	for k, v in pairs( ply:GetWeapons() ) do
		if IsValid( v ) and v != active then
			if v.EnableHolsterThink and v.HolsterThink then
				v:HolsterThink()
			end
		end
	end

	--Extra HP
	local extra = ply:GetExtraHealth()
	if extra > 0 then
		local ct = CurTime()
		local nth = ply:GetProperty( "extra_hp_think", 0 )
		if nth == 0 then
			ply:SetProperty( "extra_hp_think", ct + 1 )
		elseif nth <= ct then
			ply:SetProperty( "extra_hp_think", ct + 1 )

			extra = extra - 1

			if extra <= 0 then
				extra = 0
				ply:SetMaxExtraHealth( 0 )
			end

			ply:SetExtraHealth( extra )
		end
	end
end

--[[-------------------------------------------------------------------------
Misc functions
---------------------------------------------------------------------------]]
function GetActivePlayers()
	local tab = {}

	for i, v in ipairs( player.GetAll() ) do
		if v:IsActive() and !v:IsAFK() then
			table.insert( tab, v )
		end
	end

	return tab
end

function GetAlivePlayers()
	return SCPTeams.GetPlayersByInfo( SCPTeams.INFO_ALIVE )
end

function PlayerMessage( msg, ply, center )
	if !msg or msg == "" then return end
	if ply and !IsValid( ply ) then return end

	net.Start( "PlayerMessage" )
	net.WriteString( msg )
	net.WriteBool( center or false )

	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end
end

function CenterMessage( msg, ply )
	if !msg or msg == "" then return end
	if ply and !IsValid( ply ) then return end

	net.Start( "CenterMessage" )
	net.WriteString( msg )

	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end
end

function ChatPrint( ply, ... )
	net.Start( "SLCChatPrint" )
		net.WriteTable( { ... } )
	net.Send( ply )
end

function ChatBroadcast( ... )
	net.Start( "SLCChatPrint" )
		net.WriteTable( { ... } )
	net.Broadcast()
end

function InfoScreen( ply, t, duration, data, ovteam, ovclass )
	if type( ply ) == "Player" then
		net.SendTable( "SLCInfoScreen", {
			type = t,
			time = duration,
			data = data,
			team = ovteam or ply:SCPTeam(),
			class = ovclass or ply:SCPClass(),
		}, ply )
	end
end

function ProgressBar( ply, enable, endtime, text, col1, col2 )
	local ct = CurTime()

	if enable then
		if endtime > ct then
			net.Start( "SLCProgressBar" )
				net.WriteBool( true )
				net.WriteFloat( ct )
				net.WriteFloat( endtime )
				net.WriteString( text or "" )
				net.WriteColor( col1 or Color( 225, 225, 225, 255 ) )
				net.WriteColor( col2 or Color( 75, 75, 90, 255 ) )
			net.Send( ply )
		end
	else
		net.Start( "SLCProgressBar" )
			net.WriteBool( false )
		net.Send( ply )
	end
end

hook.Add( "PlayerPostThink", "SLCBlink", function( ply )
	local ct = CurTime()
	local nb = ply:GetNextBlink()
	if ply:GetBlink() or nb == -1 or nb > ct or !SCPTeams.HasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) then return end

	local delay, duration = hook.Run( "SLCBlinkParams", ply )
	ply:Blink( delay, duration )
end )

//Global blink time
local blinkdelay = CVAR.slc_blink_delay:GetFloat()
Timer( "PlayerBlink", blinkdelay, 0, function( self, n )
	local ntime = CVAR.slc_blink_delay:GetFloat()
	if blinkdelay != ntime then
		blinkdelay = ntime
		self:Change( ntime )
	end

	local plys = {}

	for i, v in ipairs( SCPTeams.GetPlayersByInfo( SCPTeams.INFO_HUMAN ) ) do
		if v:GetBlink() or v:GetNextBlink() != -1 then continue end

		v:SetBlink( true )
		table.insert( plys, v )
		hook.Run( "SLCBlink", v, 0.25, blinkdelay )
	end

	net.Start( "PlayerBlink" )
		net.WriteFloat( 0.25 )
		net.WriteFloat( blinkdelay )
	net.Send( plys )

	timer.Create( "PlayerUnBlink", 0.3, 1, function()
		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:SetBlink( false )
			end
		end
	end )
end )

Timer( "PlayXP", 300, 0, function()
	local pspec, pplay, pplus = string.match( CVAR.slc_xp_round:GetString(), "(%d+),(%d+),(%d+)" )

	pspec = tonumber( pspec )
	pplay = tonumber( pplay )
	pplus = tonumber( pplus )

	local rt = GetTimer( "SLCRound" )
	if IsValid( rt ) then
		local plus = rt:GetRemainingTime() <= rt:GetTime() * 0.5

		for i, v in ipairs( player.GetAll() ) do
			if !v:IsAFK() then
				if SCPTeams.HasInfo( v:SCPTeam(), SCPTeams.INFO_ALIVE ) then
					if plus then
						v:AddXP( pplus, "round" )
						PlayerMessage( "rxpplus$"..pplus, v )
					else
						v:AddXP( pplay, "round" )
						PlayerMessage( "rxpplay$"..pplay, v )
					end
				else
					v:AddXP( pspec, "round" )
					PlayerMessage( "rxpspec$"..pspec, v )
				end
			end
		end
	else
		for i, v in ipairs( player.GetAll() ) do
			if !v:IsAFK() then
				v:AddXP( pspec, "round" )
				PlayerMessage( "rxpspec$"..pspec, v )
			end
		end
	end
end )

--TransmitSound( snd, status, player, volume or 1 )
--TransmitSound( snd, status, vector, radius )
--TransmitSound( snd, status, volume )
function TransmitSound( snd, status, arg1, arg2 )
	if isvector( arg1 ) then
		for i, v in ipairs( player.GetAll() ) do
			if IsValid( v ) then
				local dist = v:GetPos():Distance( arg1 )

				if dist <= arg2 then
					net.Start( "PlaySound" )
						net.WriteBool( status )
						net.WriteFloat( 1 - dist / arg2 )
						net.WriteString( snd )
					net.Send( v )
				end
			end
		end
	elseif isentity( arg1 ) and IsValid( arg1 ) and arg1:IsPlayer() or istable( arg1 ) then
		net.Start( "PlaySound" )
			net.WriteBool( status )
			net.WriteFloat( arg2 or 1 )
			net.WriteString( snd )
		net.Send( arg1 )
	else
		net.Start( "PlaySound" )
			net.WriteBool( status or false )
			net.WriteFloat( arg1 or 1 )
			net.WriteString( snd )
		net.Broadcast()
	end
end

function BroadcastDetection( ply, tab )
	local transmit = { ply }
	local radio = ply:GetWeapon( "item_slc_radio" )

	if IsValid( radio ) and radio:GetEnabled() then
		local ch = radio:GetChannel()

		for i, v in ipairs( player.GetAll() ) do
			if v:SCPTeam() != TEAM_SCP and v:SCPTeam() != TEAM_SPEC and v != ply then
				local r = v:GetWeapon( "item_slc_radio" )
				if IsValid( r ) and r:GetEnabled() and r:GetChannel() == ch then
					table.insert( transmit, v )
				end
			end
		end
	end

	local info = {}

	for k, v in pairs( tab ) do
		table.insert( info, {
			name = v:SCPClass(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function ServerSound( file, ent, filter )
	ent = ent or game.GetWorld()
	if !filter then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end

	local sound = CreateSound( ent, file, filter )

	return sound
end

SLC_UNIX_DAY = -1

function SLCUpdateUnixDay()
	SLC_UNIX_DAY = math.floor( ( os.time() - CVAR.slc_dailyxp_time:GetInt() ) / 86400 )
end

timer.Simple( 0, SLCUpdateUnixDay )

function LocateEntity( class )
	for i, v in ipairs( player.GetAll() ) do
		local wep = v:GetWeapon( class )
		if IsValid( wep ) then
			return wep, v
		end
	end

	for i, v in ipairs( ents.GetAll() ) do
		if v:GetClass() == class then
			return v, nil
		elseif v:InstanceOf( "Lootable" ) then
			for _, item in pairs( v.LootItems ) do
				if item.info.class == class then
					return true, v
				end
			end
		end
	end
end

hook.Add( "PostGamemodeLoaded", "SCPLCLightStyle", function()
	timer.Simple( 0, function()
		engine.LightStyle( 0, "k" )
	end )
end )

concommand.Add( "slc_debuginfo", function( ply, cmd, args )
	if !IsValid( ply ) or ply:IsListenServerHost() then
		print( "=== DEBUG INFO ===" )
		print( "Round:" )
		PrintTable( ROUND, 1 )
		print( "\nPlayers" )
		for _, v in ipairs( player.GetAll() ) do
			print( "->", v, v:Nick(), v:SteamID() )
			print( "\tGeneral info -> ", v:SCPTeam(), v:SCPClass(), v:Alive(), v:IsAFK(), v:GetModel(), v:GetObserverMode(), v:GetObserverTarget() )
			print( "\tMisc -> ", v:IsBurning(), v:GetVest() )
			print( "\tSpeed -> ", v:GetWalkSpeed(), v:GetRunSpeed(), v:GetCrouchedWalkSpeed() )
			if v.SpeedStack then PrintTable( v.SpeedStack, 2 ) end
			print( "\tEngine inventory ->" )
			PrintTable( v:GetWeapons(), 2 )
			print( "\tGamemode inventory ->" )
			PrintTable( v:GetProperty( "inventory", {} ), 2 )
			print( "\tWeapons debug info ->" )
			for _, wep in ipairs( v:GetWeapons() ) do
				if wep.DebugInfo then
					print( "\t", wep )
					wep:DebugInfo( 3 )
				end
			end
			print( "\tSLCVars ->" )
			PrintTable( v.scp_var_table or {}, 2 )
			print( "\tProperties ->" )
			PrintTable( v.SLCProperties or {}, 2 )
			print( "\tEffects registry ->" )
			PrintTable( v.EFFECTS_REG or {}, 2 )
			print( "\tEffects ->" )
			PrintTable( v.EFFECTS or {}, 2 )
			print( "--------------------" )
		end
		print( "==================" )
	end
end )

concommand.Add( "slc_lightstyle", function( ply, cmd, args )
	if !IsValid( ply ) or ply:IsListenServerHost() then
		--for i = 0, 31 do
			engine.LightStyle( 0, args[1] )
		--end

		BroadcastLua( "render.RedownloadAllLightmaps( true )" )
	end
end )

local reset_confirm = 0
local should_reset = false
concommand.Add( "slc_factory_reset", function( ply, cmd, args )
	if !IsValid( ply ) or ply:IsListenServerHost() then
		if should_reset then
			print( "====================================================================" )
			print( "Factory reset stopped!" )
			print( "====================================================================" )

			should_reset = false
			reset_confirm = 0

			local t = GetTimer( "SLCFactoryReset" )
			if t then
				t:Destroy()
			end
		elseif reset_confirm < CurTime() then
			reset_confirm = CurTime() + 60

			print( "====================================================================" )
			print( "You are about to reset gamemode settings to default values!" )
			print( "It will clear all data about gamemode and players!" )
			print( "It includes data like levels, unlocked classes, convars and more!" )
			print( "" )
			print( "If you are sure and you want to continue, type this command again." )
			print( "====================================================================" )
		else
			print( "====================================================================" )
			print( "All data will be erased after 60 seconds!" )
			print( "This process can be stopped by typing 'slc_factory_reset' again!" )
			print( "====================================================================" )

			reset_confirm = 0
			should_reset = true

			Timer( "SLCFactoryReset", 60, 1, function( self, n )
				if should_reset then
					hook.Run( "SLCFactoryReset" )

					print( "Reset done! Restarting gamemode..." )
					--timer.Simple( 0, function()
						RunConsoleCommand( "changelevel", game.GetMap() )
					--end )
				end
			end )
		end
	end
end )