--[[-------------------------------------------------------------------------
Gamemode hooks
---------------------------------------------------------------------------]]
function GM:PlayerSpray( ply )
	return true

	/*if ply:GTeam() == TEAM_SPEC then
		return true
	end

	if ply:GetPos():WithinAABox( POCKETD_MINS, POCKETD_MAXS ) then
		ply:PrintMessage( HUD_PRINTCENTER, "You can't use spray in Pocket Dimension" )
		return true
	end*/
end

function GM:ShutDown()
	--
end

function GM:SCPDamage( ply, ent, dmg )
	if IsValid( ply ) and IsValid( ent ) then
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( dmg, ply, ply )
			return true
		end
	end
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
end

function GM:GetFallDamage( ply, speed )
	print( speed )

	return 1
end

/*function OnUseEyedrops(ply) --TODO
	if ply.usedeyedrops == true then
		ply:PrintMessage(HUD_PRINTTALK, "Don't use them that fast!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	ply:PrintMessage(HUD_PRINTTALK, "Used eyedrops, you will not be blinking for 10 seconds")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
		ply.usedeyedrops = false
		ply:PrintMessage(HUD_PRINTTALK, "You will be blinking now")
	end)
end*/

hook.Add( "PlayerPostThink", "WeaponHolsterThink", function( ply )
	local active = ply:GetActiveWeapon()
	for k, v in pairs( ply:GetWeapons() ) do
		if IsValid( v ) and v != active then
			if v.EnableHolsterThink and v.HolsterThink then
				v:HolsterThink()
			end
		end
	end
end )

--[[-------------------------------------------------------------------------
Misc functions
---------------------------------------------------------------------------]]
function GetActivePlayers()
	local tab = {}

	for i, v in ipairs( player.GetAll() ) do
		if v:IsActive() then
			table.insert( tab, v )
		end
	end

	return tab
end

function GetAlivePlayers()
	return SCPTeams.getPlayersByInfo( SCPTeams.INFO_ALIVE )
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

local blinkdelay = CVAR.blink:GetInt()
Timer( "PlayerBlink", blinkdelay, 0, function( self, n )
	local ntime = CVAR.blink:GetInt()
	if blinkdelay != ntime then
		blinkdelay = ntime
		self:Change( ntime )
	end

	local plys = {}

	for k, v in pairs( SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN ) ) do
		if !v:GetBlink() then
			v:SetBlink( true )
			table.insert( plys, v )
		end
	end

	net.Start( "PlayerBlink" )
		net.WriteFloat( 0.25 )
		net.WriteUInt( blinkdelay, 6 )
	net.Send( plys )

	timer.Create( "PlayerUnBlink", 0.4, 1, function()
		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:SetBlink( false )
			end
		end
	end )

	hook.Run( "SLCBlink", 0.25, blinkdelay )
end )

Timer( "PlayXP", 300, 0, function()
	local pspec, pplay, pplus = string.match( CVAR.roundxp:GetString(), "(%d+),(%d+),(%d+)" )

	pspec = tonumber( pspec )
	pplay = tonumber( pplay )
	pplus = tonumber( pplus )

	local rt = GetTimer( "SLCRound" )
	if IsValid( rt ) then
		local plus = rt:GetRemainingTime() <= rt:GetTime() * 0.5

		for k, v in pairs( player.GetAll() ) do
			if SCPTeams.hasInfo( v:SCPTeam(), SCPTeams.INFO_ALIVE ) then
				if plus then
					v:AddXP( pplus )
					PlayerMessage( "rxpplus$"..pplus, v )
				else
					v:AddXP( pplay )
					PlayerMessage( "rxpplay$"..pplay, v )
				end
			else
				v:AddXP( pspec )
				PlayerMessage( "rxpspec$"..pspec, v )
			end
		end
	else
		for k, v in pairs( player.GetAll() ) do
			v:AddXP( pspec )
			PlayerMessage( "rxpspec$"..pspec, v )
		end
	end
end )

--TransmitSound( snd, status, player, volume )
--TransmitSound( snd, status, vector, radius )
--TransmitSound( snd, status, volume )
function TransmitSound( snd, status, arg1, arg2 )
	if isvector( arg1 ) then
		for k, v in pairs( player.GetAll() ) do
			if IsValid( v ) then
				local dist = v:GetPos():DistToSqr( arg1 )

				if dist <= arg2 * arg2 then
					net.Start( "PlaySound" )
						net.WriteBool( status )
						net.WriteFloat( 1 - math.sqrt( dist ) / arg2 )
						net.WriteString( snd )
					net.Send( v )
				end
			end
		end
	elseif IsValid( arg1 ) and arg1:IsPlayer() then
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

function GetPocketPos()
	if istable( POS_POCKETD ) then
		return table.Random( POS_POCKETD )
	else
		return POS_POCKETD
	end
end

function BroadcastDetection( ply, tab )
	local transmit = { ply }
	local radio = ply:GetWeapon( "item_slc_radio" )

	if IsValid( radio ) and radio:GetEnabled() then
		local ch = radio:GetChannel()

		for k, v in pairs( player.GetAll() ) do
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

--[[-------------------------------------------------------------------------
Map interaction
---------------------------------------------------------------------------]]
function Use914( ent )
	if GetRoundStat( "914use" ) then return false end
	SetRoundStat( "914use", true )

	if SCP_914_BUTTON and ent:GetPos() != SCP_914_BUTTON then
		for k, v in pairs( ents.FindByClass( "func_door" ) ) do
			if v:GetPos() == SCP_914_DOORS[1] or v:GetPos() == SCP_914_DOORS[2] then
				v:Fire( "Close" )
				AddTimer( "914DoorOpen"..v:EntIndex(), 15, 1, function()
					v:Fire( "Open" )
				end )
			end
		end
	end

	local button = ents.FindByName( SCP_914_STATUS )[1]
	local angle = button:GetAngles().roll
	local mode = 0

	if angle == 45 then
		mode = 1
	elseif	angle == 90 then
		mode = 2
	elseif	angle == 135 then
		mode = 3
	elseif	angle == 180 then
		mode = 4
	end

	AddTimer( "SCP914UpgradeEnd", 16, 1, function()
		SetRoundStat( "914use", false )
	end )

	AddTimer( "SCP914Upgrade", 10, 1, function() 
		local items = ents.FindInBox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS )
		for k, v in pairs( items ) do
			if IsValid( v ) then
				if v.HandleUpgrade then
					v:HandleUpgrade( mode, SCP_914_OUTPUT )
				elseif v.scp914upgrade then
					local item_class

					if isstring( v.scp914upgrade ) and mode > 2 then item_class = v.scp914upgrade end
					if isfunction( v.scp914upgrade ) then item_class = v:scp914upgrade( mode ) end

					if item_class then
						local item = ents.Create( item_class )
						if IsValid( item ) then
							v:Remove()
							item:SetPos( SCP_914_OUTPUT )
							item:Spawn()
						end
					end
				end
			end
		end
	end )

	return true
end

--[[-------------------------------------------------------------------------
Gate A Explosion
---------------------------------------------------------------------------]]
local function isGateAOpen()
	local doors = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )

	for k, v in pairs( doors ) do
		if v:GetClass() == "prop_dynamic" then 
			if table.HasValue( POS_GATE_A_DOORS, v:GetPos() ) then
				return false
			end
		end
	end

	return true
end

local function destroyGate()
	local ent = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( ent ) do
		local class = v:GetClass()
		if class == "prop_dynamic" or class == "func_door" then
			v:Remove()
		end
	end
end

local function takeDamage( ent, ply )
	for k, v in pairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 1000 ) ) do
		if v:IsPlayer() and v:Alive() then
			if v:SCPTeam() != TEAM_SPEC then
				local dmg = ( 1001 - v:GetPos():Distance( POS_MIDDLE_GATE_A ) ) * 10
				if dmg > 0 then 
					v:TakeDamage( dmg, ply or v, ent )
				end
			end
		end
	end
end

function ExplodeGateA( ply )
	if GetRoundStat( "gatea" ) then return end
	if isGateAOpen() then return end

	SetRoundStat( "gatea", true )
	
	local snd = ServerSound( "ambient/alarms/alarm_citizen_loop1.wav" )
	snd:SetSoundLevel( 0 )
	snd:Play()
	snd:ChangeVolume( 0.25 )

	BroadcastLua( 'surface.PlaySound("radio/franklin1.ogg")' )

	local time = CVAR.explodetime:GetInt()
	PlayerMessage( "gateexplode$"..time )

	AddTimer( "GateExplode", 1, time, function( self, n )
		if isGateAOpen() then 
			self:Destroy()
			snd:Stop()

			PlayerMessage( "explodeterminated" )
			SetRoundStat( "gatea", false )

			return
		end
		
		if n % 10 == 0 then PlayerMessage( "gateexplode$"..( time - n ) ) end
		if n + 1 == time then snd:Stop() end

		if n == time then
			BroadcastLua( 'surface.PlaySound("ambient/explosions/exp2.wav")' )

			local explosion = ents.Create( "env_explosion" )
			explosion:SetKeyValue( "spawnflags", 210 )
			explosion:SetPos( POS_MIDDLE_GATE_A )
			explosion:Spawn()
			explosion:Fire( "explode", "", 0 )

			destroyGate()

			if IsValid( ply ) then
				takeDamage( explosion, ply )
				ply:AddFrags( 7 )
			else
				takeDamage( explosion )
			end
		end
	end )
end

--[[-------------------------------------------------------------------------
SCP106 Recontain
---------------------------------------------------------------------------]]
function Recontain106( ply )
	if GetRoundStat( "106recontain" ) then
		PlayerMessage( "r106used", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 recontain procedure can be triggered only once per round" )
		return false
	end

	local cage
	for k, v in pairs( ents.GetAll() ) do
		if v:GetPos() == CAGE_DOWN_POS then
			cage = v
			break
		end
	end
	if !cage then
		PlayerMessage( "r106eloiid", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure" )
		return false
	end

	local e = ents.FindByName( SOUND_TRANSMISSION_NAME )[1]
	if e:GetAngles().roll == 0 then
		PlayerMessage( "r106sound", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "Enable sound transmission in order to start SCP 106 recontain procedure" )
		return false
	end

	local fplys = ents.FindInBox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS )
	local plys = {}
	for k, v in pairs( fplys ) do
		if IsValid( v ) and v:IsPlayer() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
			table.insert( plys, v )
		end
	end

	if #plys < 1 then
		PlayerMessage( "r106human", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "Living human in cage is required in order to start SCP 106 recontain procedure" )
		return false
	end

	local scps = {}
	for k, v in pairs( player.GetAll() ) do
		if v:SCPClass() == CLASSES.SCP106 then
			table.insert( scps, v )
		end
	end

	local scpnum = #scps
	if scpnum < 1 then
		PlayerMessage( "r106already", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 is already recontained" )
		return false
	end

	SetRoundStat( "106recontain", true )

	AddTimer( "106Recontain", 6, 1, function( self, n )
		if ROUND.post or !GetRoundStat( "106recontain" ) then return end
		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:Kill()
			end
		end

		for k, v in pairs( scps ) do
			if IsValid( v ) then
				local swep = v:GetActiveWeapon()
				if IsValid( swep ) and swep:GetClass() == "weapon_scp_106" then
					swep:TeleportSequence( CAGE_INSIDE )
				end
			end
		end

		AddTimer( "106Recontain", 11, 1, function( self, n )
			if ROUND.post or !GetRoundStat( "106recontain" ) then return end
			for k, v in pairs( scps ) do
				if IsValid( v ) then
					v:Kill()
				end
			end

			local eloiid = ents.FindByName( ELO_IID_NAME )[1]
			eloiid:Use( game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1 )

			if IsValid( ply ) then
				local points = math.ceil( SCPTeams.getReward( TEAM_SCP ) * 1.5 * scpnum )
				PlayerMessage( "r106success$"..points, ply, true )
				//ply:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for recontaining SCP 106!")
				ply:AddFrags( points )
			end
		end )


	end )

	return true
end

--[[-------------------------------------------------------------------------
Omega Warhead
---------------------------------------------------------------------------]]
function OMEGAWarhead( ply )
	if OMEGAEnabled then return end

	local remote = ents.FindByName( OMEGA_REMOTE_NAME )[1]
	if GetConVar( "br_enable_warhead" ):GetInt() != 1 or remote:GetAngles().pitch == 180 then
		ply:PrintMessage( HUD_PRINTCENTER, "You inserted keycard but nothing happened" )
		return
	end

	OMEGAEnabled = true

	--local alarm = ServerSound( "warhead/alarm.ogg" )
	--alarm:SetSoundLevel( 0 )
	--alarm:Play()
	net.Start( "SendSound" )
		net.WriteInt( 1, 2 )
		net.WriteString( "warhead/alarm.ogg" )
	net.Broadcast()

	timer.Create( "omega_announcement", 3, 1, function()
		--local announcement = ServerSound( "warhead/announcement.ogg" )
		--announcement:SetSoundLevel( 0 )
		--announcement:Play()
		net.Start( "SendSound" )
			net.WriteInt( 1, 2 )
			net.WriteString( "warhead/announcement.ogg" )
		net.Broadcast()

		timer.Create( "omega_delay", 11, 1, function()
			for k, v in pairs( ents.FindByClass( "func_door" ) ) do
				if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
					v:Fire( "Unlock" )
					v:Fire( "Open" )
					v:Fire( "Lock" )
				end
			end

			OMEGADoors = true

			--local siren = ServerSound( "warhead/siren.ogg" )
			--siren:SetSoundLevel( 0 )
			--siren:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/siren.ogg" )
			net.Broadcast()
			timer.Create( "omega_alarm", 12, 5, function()
				--siren = ServerSound( "warhead/siren.ogg" )
				--siren:SetSoundLevel( 0 )
				--siren:Play()
				net.Start( "SendSound" )
					net.WriteInt( 1, 2 )
					net.WriteString( "warhead/siren.ogg" )
				net.Broadcast()
			end )

			timer.Create( "omega_check", 1, 89, function()
				if !IsValid( remote ) or remote:GetAngles().pitch == 180 or !OMEGAEnabled then
					WarheadDisabled( siren )
				end
			end )
		end )

		timer.Create( "omega_detonation", 90, 1, function()
			--local boom = ServerSound( "warhead/explosion.ogg" )
			--boom:SetSoundLevel( 0 )
			--boom:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/explosion.ogg" )
			net.Broadcast()
			for k, v in pairs( player.GetAll() ) do
				v:Kill()
			end
		end )
	end )
end

function WarheadDisabled( siren )
	OMEGAEnabled = false
	OMEGADoors = false

	--if siren then
		--siren:Stop()
	--end
	net.Start( "SendSound" )
		net.WriteInt( 0, 2 )
		net.WriteString( "warhead/siren.ogg" )
	net.Broadcast()

	if timer.Exists( "omega_check" ) then timer.Remove( "omega_check" ) end
	if timer.Exists( "omega_alarm" ) then timer.Remove( "omega_alarm" ) end
	if timer.Exists( "omega_detonation" ) then timer.Remove( "omega_detonation" ) end
	
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
			v:Fire( "Unlock" )
			v:Fire( "Close" )
		end
	end
end

-- engine.LightStyle( 0, "m" )
-- timer.Simple( 0, function()
-- 	BroadcastLua( "render.RedownloadAllLightmaps( true )" )
-- end )