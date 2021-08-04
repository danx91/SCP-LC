--[[-------------------------------------------------------------------------
SCP 914
---------------------------------------------------------------------------]]
function Use914( ent, ply )
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

	local nummode = 0
	local mode = UPGRADE_MODE.ROUGH

	if angle == 45 then
		mode = UPGRADE_MODE.COARSE
		nummode = 1
	elseif	angle == 90 then
		mode = UPGRADE_MODE.ONE_ONE
		nummode = 2
	elseif	angle == 135 then
		mode = UPGRADE_MODE.FINE
		nummode = 3
	elseif	angle == 180 then
		mode = UPGRADE_MODE.VERY_FINE
		nummode = 4
	end

	AddTimer( "SCP914UpgradeEnd", 16, 1, function()
		SetRoundStat( "914use", false )
	end )

	if CVAR.slc_scp914_kill:GetBool() == true then
		AddTimer( "SCP914KillPlayers", 7.5, 1, function() 
			for k, v in pairs( player.GetAll() ) do
				if v:Alive() then
					local pos = v:GetPos()
					--print( "testing!" )
					if pos:WithinAABox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS ) or pos:WithinAABox( SCP_914_OUTPUT_MINS, SCP_914_OUTPUT_MAXS ) then
						v:Kill()
					end
				end
			end
		end )
	end

	AddTimer( "SCP914Upgrade", 10, 1, function() 
		local items = ents.FindInBox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS )
		for k, v in pairs( items ) do
			if IsValid( v ) then
				if v.HandleUpgrade then
					v:HandleUpgrade( mode, nummode, SCP_914_OUTPUT, ply )
				elseif v.scp914upgrade then
					local item_class

					if isstring( v.scp914upgrade ) and nummode > 2 then item_class = v.scp914upgrade end
					if isfunction( v.scp914upgrade ) then item_class = v:scp914upgrade( mode, nummode ) end

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
local function IsGateAOpen()
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

local function DestroyGateA()
	local ent = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( ent ) do
		local class = v:GetClass()
		if class == "prop_dynamic" or class == "func_door" then
			v:Remove()
		end
	end
end

local function TakeDamageA( ent, ply )
	/*for k, v in pairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 1000 ) ) do
		if v:IsPlayer() and v:Alive() then
			if v:SCPTeam() != TEAM_SPEC then
				local dmg = ( 1001 - v:GetPos():Distance( POS_MIDDLE_GATE_A ) ) * 10
				if dmg > 0 then
					v:TakeDamage( dmg, ply or v, ent )
				end
			end
		end
	end*/

	for k, v in pairs( player.GetAll() ) do
		if v:Alive() and v:SCPTeam() != TEAM_SPEC then
			local pos = v:GetPos()
			for _, tab in pairs( EXPLOSION_AREAS_A ) do
				if pos:WithinAABox( tab[1], tab[2] ) then
					local dmg = math.Clamp( 1 - pos:Distance( POS_MIDDLE_GATE_A ) / GATE_A_EXPLOSION_RADIUS, 0, 1 ) * 10000
					if dmg > 0 then
						v:TakeDamage( dmg, ply or v, ent )
					end

					break
				end
			end
		end
	end
end

function ExplodeGateA( ply )
	if GetRoundStat( "gatea" ) then return end
	if IsGateAOpen() then return end

	SetRoundStat( "gatea", true )
	
	local snd = ServerSound( "ambient/alarms/alarm_citizen_loop1.wav" )
	snd:SetSoundLevel( 0 )
	snd:Play()
	snd:ChangeVolume( 0.25 )

	//BroadcastLua( 'surface.PlaySound("scp_lc/franklin1.ogg")' )

	local time = CVAR.slc_time_explode:GetInt()
	PlayerMessage( "gateexplode$"..time )

	AddTimer( "GateExplode", 1, time, function( self, n )
		if IsGateAOpen() then 
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

			DestroyGateA()

			if IsValid( ply ) then
				ply:AddFrags( 5 )
				TakeDamageA( explosion, ply )
			else
				TakeDamageA( explosion )
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

	//local fplys = ents.FindInBox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS )
	local plys = {}
	for k, v in pairs( player.GetAll() ) do
		if IsValid( v ) and v:IsPlayer() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
			if v:GetPos():WithinAABox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS ) then
				table.insert( plys, v )
			end
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
				v:SkipNextKillRewards()
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

			hook.Run( "SLCSCP106Recontained", ply )

			if IsValid( ply ) then
				local points = math.ceil( SCPTeams.GetReward( TEAM_SCP ) * 1.5 * scpnum )
				PlayerMessage( "r106success$"..points, ply, true )
				ply:AddFrags( points )
			end

			for k, v in pairs( scps ) do
				if IsValid( v ) then
					v:SkipNextKillRewards()
					v:Kill()
				end
			end

			local eloiid = ents.FindByName( ELO_IID_NAME )[1]
			if eloiid then
				eloiid:Use( game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1 )
			end

			TransmitSound( "scp_lc/announcements/recontained106.ogg", true, 1 )
		end )


	end )

	return true
end

--[[-------------------------------------------------------------------------
Omega Warhead
---------------------------------------------------------------------------]]
OMEGA_DESTROY = OMEGA_DESTROY or {}

hook.Add( "SLCPreround", "SLCOmegaWarhead", function()
	local listener = SynchronousEventListener( "OmegaWarhead", 2, 2, function( listener, info )
		if OMEGA_REMOTE_CHECK() then
			OMEGAWarhead( info[1][1], info[2][1] )
		else
			listener:Broadcast( NULL, false, 1 )
		end
	end )

	local screen1 = ents.Create( "slc_display_omega" )
	//print( "created" )
	if IsValid( screen1 ) then
		screen1:SetPos( OMEGA_ACTIVATION_1[1] )
		screen1:SetAngles( OMEGA_ACTIVATION_1[2] )
		screen1:SetUsable( true, 17 )
		screen1:SetData( listener, 1 )
		screen1:Spawn()

		listener:AddEntity( screen1 )
	end

	local screen2 = ents.Create( "slc_display_omega" )
	if IsValid( screen2 ) then
		screen2:SetPos( OMEGA_ACTIVATION_2[1] )
		screen2:SetAngles( OMEGA_ACTIVATION_2[2] )
		screen2:SetUsable( true, 17 )
		screen2:SetData( listener, 2 )
		screen2:Spawn()

		listener:AddEntity( screen2 )
	end

	local omega_access_data = {
		name = "Omega Warhead",
		//pos = , --not needed
		access = ACCESS_OMEGA,
		-- access_granted = function( ply, ent, data )
		-- 	//return OmegaFunction()
		-- end,
		msg_access = "",
		msg_omnitool = "device_noomni",
		omega_disable = true,
		alpha_disable = true,
		disable_overload = true,
	}

	RegisterButton( omega_access_data, screen1 )
	RegisterButton( omega_access_data, screen2 )
end )

function OMEGAWarhead( ply1, ply2 )
	print( "OMEGA Activated", ply1, ply2 )
	
	if GetRoundStat( "omega_warhead" ) or GetRoundStat( "alpha_warhead" ) then return end
	SetRoundStat( "omega_warhead", true )

	if IsValid( ALPHA_WARHED_SCREEN ) then
		ALPHA_WARHED_SCREEN:SetState( 4 )
		ALPHA_WARHED_SCREEN:SetUsable( false )
	end

	TransmitSound( "scp_lc/warhead/alarm.ogg", true, 1 )
	AddTimer( "OmegaSiren", 3, 1, function( self, n )

		//print( "Opening doors..." )

		local time = CVAR.slc_time_omega:GetInt()
		PlayerMessage( "omega_detonation$"..time )
		TransmitSound( "scp_lc/warhead/siren.wav", true, 1 )

		local a_doors = { [OMEGA_GATE_A_DOOR_L] = true, [OMEGA_GATE_A_DOOR_R] = true }
		local s_doors = { [OMEGA_SHELTER_DOOR_L] = true, [OMEGA_SHELTER_DOOR_R] = true }

		for k, v in pairs( ents.GetAll() ) do
			if v:GetClass() == "func_door" and ( a_doors[v:GetName()] or s_doors[v:GetName()] ) then
				v:Fire( "Unlock" )
				v:Fire( "Open" )
			end
		end

		AddTimer( "OmegaCountdown", time - 10, 1, function( self, n )
			//print( "closig shelter, lockdown" )

			SetRoundStat( "warhead_lockdown", true )

			for k, v in pairs( ents.GetAll() ) do
				if v:GetClass() == "func_door" and ( s_doors[v:GetName()] ) then
					v:Fire( "Close" )
				end
			end

			AddTimer( "OmegaShelter", 5, 1, function( self, n )
				TransmitSound( "scp_lc/warhead/siren.wav", false, 1 )

				//print( "HOLDING ROUND!" )
				HoldRound()

				local xp = CVAR.slc_xp_omega_shelter:GetInt()
				for k, v in pairs( SCPTeams.GetPlayersByInfo( SCPTeams.INFO_HUMAN ) ) do
					if v:GetPos():WithinAABox( OMEGA_SHELTER[1], OMEGA_SHELTER[2] ) then
						//CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;shelter_escape;escapexp$%d", xp ), v )
						InfoScreen( v, "escaped", INFO_SCREEN_DURATION, {
							"escape3",
							{ "escape_xp", "text;"..xp }
						} )

						v:AddXP( xp )

						local team = v:SCPTeam()
						SCPTeams.AddScore( team, SCPTeams.GetReward( team ) * 2 )

						v:Despawn()

						v:KillSilent()
						v:SetSCPTeam( TEAM_SPEC )
						v:SetSCPClass( "spectator" )
						v.DeathScreen = CurTime() + INFO_SCREEN_DURATION
						//v:SetupSpectator()

						//QueueInsert( v )

						AddRoundStat( "escapes" )
						//print( "SHELTER ESCAPE", v )
					end
				end
			end )

			AddTimer( "OmegaExplosion", 10, 1, function( self, n )
				local surface = {}
				local facility = {}

				local clr = Color( 255, 255, 255, 255 )
				for k, v in pairs( player.GetAll() ) do
					if WARHEAD_IS_ON_SURFACE( v ) then
						table.insert( surface, v )

						v:SendLua( "util.ScreenShake(Vector(0),10,5,5,0)" )
					else
						table.insert( facility, v )

						v:ScreenFade( SCREENFADE.IN, clr, 2, 3 )

						if v:Alive() then
							v:SetProperty( "death_info_override", {
								type = "mia",
								args = {
									"omega_mia"
								}
							} )
							v:SkipNextKillRewards()
							v:Kill()

							//print( "OMEGA KILL", v )
						end
					end
				end

				TransmitSound( "scp_lc/warhead/explosion.ogg", true, facility, 1 )
				TransmitSound( "scp_lc/warhead/explosion_far.ogg", true, surface, 1 )

				for k, v in pairs( OMEGA_DESTROY ) do
					if IsValid( k ) then
						k:Remove()
					end

					OMEGA_DESTROY[k] = nil
				end

				local sel_omega = GetSELObject( "OmegaWarhead" )
				if sel_omega then
					sel_omega:Broadcast( NULL, false, 2 )
				end

				//print( "RELEASING ROUND" )
				ReleaseRound()

				//SetRoundStat( "omega_warhead", false )
				//SetRoundStat( "warhead_lockdown", false )
			end )
		end )
	end )

	return true
end

--[[-------------------------------------------------------------------------
Alpha Warhead
---------------------------------------------------------------------------]]
ALPHA_DESTROY = ALPHA_DESTROY or {}

//ALPHA_WARHED_SCREEN = ALPHA_WARHED_SCREEN
hook.Add( "SLCPreround", "SLCAlphaWarhead", function()
	local tab = table.Copy( ALPHA_CARD_SPAWN )

	for i = 1, 2 do
		local spawns = table.remove( tab, math.random( #tab ) )

		local card = ents.Create( "item_slc_alpha_card"..i )
		if IsValid( card ) then
			card:SetPos( spawns[math.random( #spawns )] )
			card:Spawn()
			card.Dropped = 0
		end
	end

	local screen = ents.Create( "slc_display_alpha" )
	if IsValid( screen ) then
		screen:SetPos( ALPHA_ACTIVATION[1] )
		screen:SetAngles( ALPHA_ACTIVATION[2] )
		screen:SetUsable( false, 0 )
		screen:Spawn()

		ALPHA_WARHED_SCREEN = screen
	end

	RegisterButton( {
		name = "Alpha Warhead",
		//pos = , --not needed
		access = ACCESS_ALPHA,
		-- access_granted = function( ply, ent, data )
		-- 	//return OmegaFunction()
		-- end,
		msg_access = "",
		msg_omnitool = "device_noomni",
		omega_disable = true,
		alpha_disable = true,
		disable_overload = true,
	}, screen )
end )

function ALPHAWarhead( ply )
	print( "ALPHA activated", ply )

	if GetRoundStat( "omega_warhead" ) or GetRoundStat( "alpha_warhead" ) then return end
	SetRoundStat( "alpha_warhead", true )

	local sel_omega = GetSELObject( "OmegaWarhead" )
	if sel_omega then
		sel_omega:Broadcast( NULL, false, 2 )
	end

	TransmitSound( "scp_lc/warhead/alarm.ogg", true, 1 )
	AddTimer( "AlphaSiren", 3, 1, function( self, n )
		local time = CVAR.slc_time_alpha:GetInt()
		PlayerMessage( "alpha_detonation$"..time )
		TransmitSound( "scp_lc/warhead/siren.wav", true, 1 )

		local support_timer = GetTimer( "SupportTimer" )
		if IsValid( support_timer ) then
			support_timer:Destroy()
			//print( "SUPPORT TIMER DESTROYED" )
		end

		AddTimer( "AlphaCountdown", time - 10, 1, function( self, n )
			//print( "Lockdown" )
			SetRoundStat( "warhead_lockdown", true )

			local escape_timer = GetTimer( "EscapeTimer" )
			if IsValid( escape_timer ) then
				escape_timer:Destroy()
				//print( "ESCAPE TIMER DESTROYED" )
			end

			AddTimer( "AlphaSiren", 5, 1, function( self, n )
				TransmitSound( "scp_lc/warhead/siren.wav", false, 1 )
			end )

			AddTimer( "AlphaExplosion", 10, 1, function( self, n )
				//print( "HOLDING ROUND" )
				HoldRound()

				local surface = {}
				local facility = {}

				local clr = Color( 255, 255, 255, 255 )
				for k, v in pairs( player.GetAll() ) do
					if WARHEAD_IS_ON_SURFACE( v ) then
						table.insert( surface, v )

						v:ScreenFade( SCREENFADE.IN, clr, 2, 3 )

						if v:Alive() then
							v:SetProperty( "death_info_override", {
								type = "mia",
								args = {
									"alpha_mia"
								}
							} )
							v:SkipNextKillRewards()
							v:Kill()

							//print( "ALPHA KILL", v )
						end
					else
						table.insert( facility, v )
						v:SendLua( "util.ScreenShake(Vector(0),10,5,5,0)" )
					end
				end

				TransmitSound( "scp_lc/warhead/explosion.ogg", true, surface, 1 )
				TransmitSound( "scp_lc/warhead/explosion_far.ogg", true, facility, 1 )

				for k, v in pairs( ALPHA_DESTROY ) do
					if IsValid( k ) then
						k:Remove()
					end

					ALPHA_DESTROY[k] = nil
				end

				//print( "RELEASING ROUND" )
				ReleaseRound()

				if IsValid( ALPHA_WARHED_SCREEN ) then
					ALPHA_WARHED_SCREEN:SetState( 4 )
					ALPHA_WARHED_SCREEN:SetUsable( false )
				end

				//SetRoundStat( "alpha_warhead", false )
				//SetRoundStat( "warhead_lockdown", false )
			end )
		end )
	end )

	return true
end

--[[-------------------------------------------------------------------------
Warhead Misc
---------------------------------------------------------------------------]]
function DestroyOnWarhead( ent, alpha, omega )
	if alpha then
		ALPHA_DESTROY[ent] = true
	end
	
	if omega then
		OMEGA_DESTROY[ent] = true
	end
end

hook.Add( "SLCRoundCleanup", "SLCWarheadCleanup", function()
	ALPHA_DESTROY = {}
	OMEGA_DESTROY = {}
end )