--[[-------------------------------------------------------------------------
SCP 914
---------------------------------------------------------------------------]]
function SCP914Use( ply )
	if GetRoundProperty( "scp914_in_use" ) then return false end
	SetRoundProperty( "scp914_in_use", true )

	local mode = SCP_914_MODE()

	AddTimer( "SCP914Upgrade", 10, 1, function() 
		SCP914Upgrade( mode, ply )
	end )

	AddTimer( "SCP914UpgradeEnd", 16, 1, function()
		SetRoundProperty( "scp914_in_use", false )
	end )

	return true
end

function SCP914Upgrade( mode, ply )
	local ct = CurTime()

	for i, v in ipairs( ents.FindInBox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS ) ) do
		if !IsValid( v ) then continue end

		if v.HandleUpgrade then
			v:HandleUpgrade( mode, SCP_914_OUTPUT, ply )
		elseif v.SCP914Upgrade then
			local item_class

			if istable( v.SCP914Upgrade ) then
				item_class = v.SCP914Upgrade[mode]
			elseif isfunction( v.SCP914Upgrade ) then
				item_class = v.SCP914Upgrade( mode, ply )
			elseif mode >= UPGRADE_MODE.FINE and isstring( v.SCP914Upgrade ) then
				item_class = v.SCP914Upgrade
			end

			if istable( item_class ) then
				item_class = item_class[SLCRandom( #item_class )]
			end

			if !item_class then
				v:SetPos( SCP_914_OUTPUT )

				if v.PickupPriority then
					v.Dropped = ct
					v.PickupPriorityTime = ct + 10
				end

				continue
			end

			local item = ents.Create( item_class )
			if !IsValid( item ) then continue end

			item:SetPos( SCP_914_OUTPUT )
			item:Spawn()
			
			if v.PickupPriority then
				item.Dropped = ct
				item.PickupPriority = v.PickupPriority
				item.PickupPriorityTime = ct + 10
			end

			v:Remove()
		elseif v:IsPlayer() then
			v:SetPos( SCP_914_OUTPUT )

			if mode == UPGRADE_MODE.ROUGH then
				v:TakeDamage( SLCRandom( 50, 100 ), v, v )
			elseif mode == UPGRADE_MODE.COARSE then
				v:TakeDamage( SLCRandom( 5, 50 ), v, v )
			elseif mode == UPGRADE_MODE.FINE then
				v:AddHealth( SLCRandom( 5, 25 ) )
			elseif mode == UPGRADE_MODE.VERY_FINE then
				local upgrade_num = v:GetProperty( "scp914_veryfine", 0 )
				v:SetProperty( "scp914_veryfine", upgrade_num + 1 )

				local extra = v:GetExtraHealth() + SLCRandom( 30, 50 ) + 15 * upgrade_num
				v:SetExtraHealth( extra )
				v:SetMaxExtraHealth( extra )
				v:SetProperty( "extra_hp_think", ct + 1 )

				if SLCRandom( 10 ) <= upgrade_num then
					v:SetProperty( "death_info_override", {
						type = "dead",
						args = {
							"scp914_death"
						}
					} )

					v:SkipNextSuicide()
					v:Kill()
				end
			end
		else
			//v:SetPos( SCP_914_OUTPUT )
		end
	end
end

--[[-------------------------------------------------------------------------
Gate A Explosion
---------------------------------------------------------------------------]]
GATEA_DESTROY = GATEA_DESTROY or {}

function DestroyOnGateA( ent )
	GATEA_DESTROY[ent] = true
end

local function IsGateAOpen()
	for i, v in ipairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 125 ) ) do
		if v:GetClass() == "prop_dynamic" then 
			if table.HasValue( POS_GATE_A_DOORS, v:GetPos() ) then
				return false
			end
		end
	end

	return true
end

local function DestroyGateA()
	for i, v in ipairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 125 ) ) do
		local class = v:GetClass()
		if class == "prop_dynamic" or class == "func_door" then
			v:Remove()
		end
	end

	for k, v in pairs( GATEA_DESTROY ) do
		if IsValid( k ) then
			k:Remove()
		end

		GATEA_DESTROY[k] = nil
	end
end

local function TakeDamageA( ent, ply )
	for i, v in ipairs( player.GetAll() ) do
		if !v:Alive() or v:SCPTeam() == TEAM_SPEC then continue end

		local pos = v:GetPos()
		for _, tab in pairs( EXPLOSION_AREAS_A ) do
			if pos:WithinAABox( tab[1], tab[2] ) then
				local dmg = math.Clamp( 1 - pos:Distance( POS_MIDDLE_GATE_A ) / GATE_A_EXPLOSION_RADIUS, 0, 1 ) * 10000
				if dmg > 0 then
					if dmg >= v:Health() then
						v:SkipNextSuicide()
					end

					v:TakeDamage( dmg, v, ent )
				end

				break
			end
		end
	end
end

local fire_trace = {}
fire_trace.output = fire_trace
fire_trace.mask = MASK_SOLID_BRUSHONLY

local function spawn_fire_ents( pos, time )
	local pos1, pos2 = pos[1], pos[2]
	local step = 90
	local noise = step / 2
	
	for x = pos1.x, pos2.x, step do
		for y = pos1.y, pos2.y, step do
			fire_trace.start = Vector(
				x + ( SLCRandom() * 2 - 1 ) * noise,
				y + ( SLCRandom() * 2 - 1 ) * noise,
				pos2.z
			)

			if !util.IsInWorld( fire_trace.start ) then continue end

			fire_trace.endpos = fire_trace.start * 1
			fire_trace.endpos.z = pos1.z

			_DrawNextTrace = true
			util.TraceLine( fire_trace )

			if !fire_trace.Hit or fire_trace.StartSolid or fire_trace.AllSolid then continue end

			local fire = ents.Create( "slc_entity_fire" )
			if !IsValid( fire ) then return end

			fire:SetPos( fire_trace.HitPos )
			fire:SetBurnTime( time + SLCRandom() * 1.5 - 0.5 )
			fire:SetFireRadius( 0 )
			fire:SetFireDamage( 0 )
			fire:Spawn()
		end
	end
end

local function spawn_fire()
	local time = CVAR.slc_time_gate_fire:GetInt()
	if time <= 0 then return end

	local pos = EXPLOSION_FIRE
	local tick = 0.2

	for i, v in ipairs( pos ) do
		spawn_fire_ents( v, time )
	end

	SetRoundProperty( "gate_a_fire", CurTime() + time, true )

	AddTimer( "GateFireTimer", tick, time / tick, function()
		for i, v in ipairs( pos ) do
			for _, ply in ipairs( player.GetAll() ) do
				if !ply:GetPos():WithinAABox( v[1], v[2] ) then continue end

				local t = ply:SCPTeam()
				if !ply:Alive() or t == TEAM_SPEC then continue end

				if t == TEAM_SCP then
					ply:TakeDamage( 100, ply )
				else
					local dmg = DamageInfo()
					dmg:SetAttacker( ply )
					dmg:SetDamageType( DMG_BURN )
					dmg:SetDamage( 10 )

					ply:TakeDamageInfo( dmg )
				end
			end
		end
	end )
end

function ExplodeGateA( ply )
	if GetRoundProperty( "gatea" ) or GetRoundProperty( "gatea_destroyed" ) then return end
	if IsGateAOpen() then return end

	SetRoundProperty( "gatea", true )
	
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
			SetRoundProperty( "gatea", false )

			return
		end
		
		if n % 10 == 0 then PlayerMessage( "gateexplode$"..( time - n ) ) end
		if n + 1 == time then snd:Stop() end

		if n == time then
			SetRoundProperty( "gatea", false )
			SetRoundProperty( "gatea_destroyed", true )

			BroadcastLua( 'surface.PlaySound("ambient/explosions/exp2.wav")' )

			local explosion = ents.Create( "env_explosion" )
			explosion:SetKeyValue( "spawnflags", 210 )
			explosion:SetPos( POS_MIDDLE_GATE_A )
			explosion:Spawn()
			explosion:Fire( "explode", "", 0 )

			DestroyGateA()
			spawn_fire()

			if IsValid( ply ) then
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

	if !MAP_CHECKERS.SCP106_CAGE() then
		PlayerMessage( "r106eloiid", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure" )
		return false
	end

	if !MAP_CHECKERS.SCP106_SOUND() then
		PlayerMessage( "r106sound", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "Enable sound transmission in order to start SCP 106 recontain procedure" )
		return false
	end

	//local fplys = ents.FindInBox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS )
	local plys = {}
	for i, v in ipairs( player.GetAll() ) do
		if IsValid( v ) and v:IsPlayer() and SCPTeams.HasInfo( v:SCPTeam(), SCPTeams.INFO_HUMAN ) and v:GetPos():WithinAABox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS ) then
			table.insert( plys, v )
		end
	end

	if #plys < 1 then
		PlayerMessage( "r106human", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "Living human in cage is required in order to start SCP 106 recontain procedure" )
		return false
	end

	local scps = {}
	for i, v in ipairs( player.GetAll() ) do
		if v:SCPClass() == CLASSES.SCP106 then
			table.insert( scps, v )
			v:SetProperty( "escape_override", false )
		end
	end

	local scpnum = #scps
	if scpnum < 1 then
		PlayerMessage( "r106already", ply, true )
		//ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 is already recontained" )
		return false
	end

	SetRoundStat( "106recontain", true )

	AddTimer( "106Recontain", 8, 1, function()
		if ROUND.post then return end

		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:SkipNextKillRewards()
				v:SkipNextSuicide()
				v:Kill()
			end
		end

		for k, v in pairs( scps ) do
			if IsValid( v ) then
				local swep = v:GetActiveWeapon()
				if IsValid( swep ) and swep:GetClass() == "weapon_scp_106" then
					v:DisableControls( "scp106_recontain" )
					swep:TeleportSequence( CAGE_INSIDE )
				end
			end
		end

		AddTimer( "106Recontain", 12, 1, function()
			if ROUND.post then return end

			hook.Run( "SLCSCP106Recontained", ply )

			if IsValid( ply ) then
				local points = math.ceil( SCPTeams.GetReward( TEAM_SCP ) * 0.5 * scpnum )
				PlayerMessage( "r106success$"..points, ply, true )
				ply:AddFrags( points )
			end

			local points = math.floor( SCPTeams.GetReward( TEAM_SCP ) * 1.5 * scpnum / #plys )
			for k, v in pairs( plys ) do
				if IsValid( v ) then
					PlayerMessage( "r106success$"..points, v, true )
					v:AddFrags( points )
				end
			end

			for k, v in pairs( scps ) do
				if IsValid( v ) then
					v:SkipNextKillRewards()
					v:SkipNextSuicide()
					v:Kill()
				end
			end

			local eloiid = CacheEntity( ELO_IID or ELO_IID_NAME )
			if IsValid( eloiid ) then
				eloiid:Use( game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1 )
			end

			PlayPA( "scp_lc/announcements/recontained106.ogg", 9 )
		end )


	end )

	return true
end

--[[-------------------------------------------------------------------------
Omega Warhead
---------------------------------------------------------------------------]]
OMEGA_DESTROY = OMEGA_DESTROY or {}

local function omega_shelter()
	local xp = CVAR.slc_xp_omega_shelter:GetInt()
	for i, v in ipairs( SCPTeams.GetPlayersByInfo( SCPTeams.INFO_HUMAN ) ) do
		if v:GetPos():WithinAABox( OMEGA_SHELTER[1], OMEGA_SHELTER[2] ) then
			//CenterMessage( string.format( "offset:75;escaped#255,0,0,SCPHUDVBig;shelter_escape;escapexp$%d", xp ), v )
			InfoScreen( v, "escaped", INFO_SCREEN_DURATION, {
				"escape3",
				{ "escape_xp", "text;"..xp }
			} )

			v:AddXP( xp, "escape" )

			local team = v:SCPTeam()
			SCPTeams.AddScore( team, SCPTeams.GetReward( team ) * 2 )

			v:Despawn()
			v:SkipNextSuicide()

			v:KillSilent()
			v:SetSCPTeam( TEAM_SPEC )
			v:SetSCPClass( "spectator" )
			v.DeathScreen = CurTime() + INFO_SCREEN_DURATION

			AddRoundStat( "escapes" )
			//print( "SHELTER ESCAPE", v )
		end
	end
end

hook.Add( "SLCPreround", "SLCOmegaWarhead", function()
	local listener = SynchronousEventListener( "OmegaWarhead", 2, 2, function( lis, info )
		if MAP_CHECKERS.OMEGA_REMOTE() and !GetRoundStat( "goc_countdown" ) and !IsGOCDeviceValid() then
			OMEGAWarhead( info[1][1], info[2][1] )
		else
			lis:Broadcast( NULL, false, 1 )
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
	
	if GetRoundStat( "omega_warhead" ) or GetRoundStat( "alpha_warhead" ) or GetRoundStat( "goc_countdown" ) then return end
	SetRoundStat( "omega_warhead", true )

	if IsValid( ALPHA_WARHED_SCREEN ) then
		ALPHA_WARHED_SCREEN:SetState( 4 )
		ALPHA_WARHED_SCREEN:SetUsable( false )
	end

	TransmitSound( "scp_lc/warhead/alarm.ogg", true, 1 )
	AddTimer( "OmegaSiren", 3, 1, function()

		//print( "Opening doors..." )

		local time = CVAR.slc_time_omega:GetInt()
		PlayerMessage( "omega_detonation$"..time )
		TransmitSound( "scp_lc/warhead/siren.wav", true, 1 )

		local a_doors = { [OMEGA_GATE_A_DOOR_L] = true, [OMEGA_GATE_A_DOOR_R] = true }
		local s_doors = { [OMEGA_SHELTER_DOOR_L] = true, [OMEGA_SHELTER_DOOR_R] = true }

		for k, v in ipairs( ents.GetAll() ) do
			if v:GetClass() == "func_door" and ( a_doors[v:GetName()] or s_doors[v:GetName()] ) then
				v:Fire( "Unlock" )
				v:Fire( "Open" )
			end
		end

		AddTimer( "OmegaCountdown", time - 10, 1, function()
			//print( "closig shelter, lockdown" )

			SetRoundProperty( "warhead_lockdown", true )

			for k, v in ipairs( ents.GetAll() ) do
				if v:GetClass() == "func_door" and ( s_doors[v:GetName()] ) then
					v:Fire( "Close" )
				end
			end

			AddTimer( "OmegaShelter", 5, 1, function()
				TransmitSound( "scp_lc/warhead/siren.wav", false, 1 )

				//print( "HOLDING ROUND!" )
				HoldRound()

				omega_shelter()
			end )

			AddTimer( "OmegaExplosion", 10, 1, function()
				local surface = {}
				local facility = {}

				local clr = Color( 255, 255, 255, 255 )
				for i, v in ipairs( player.GetAll() ) do
					if v:IsInZone( ZONE_SURFACE ) then
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
							v:SkipNextSuicide()
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
				end

				OMEGA_DESTROY = {}

				local sel_omega = GetSELObject( "OmegaWarhead" )
				if sel_omega then
					sel_omega:Broadcast( NULL, false, 2 )
				end

				//print( "RELEASING ROUND" )
				ReleaseRound()
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
		local spawns = table.remove( tab, SLCRandom( #tab ) )

		local card = ents.Create( "item_slc_alpha_card"..i )
		if IsValid( card ) then
			card:SetPos( spawns[SLCRandom( #spawns )] )
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

	if GetRoundStat( "omega_warhead" ) or GetRoundStat( "alpha_warhead" ) or GetRoundStat( "goc_countdown" ) then return end
	SetRoundStat( "alpha_warhead", true )

	local sel_omega = GetSELObject( "OmegaWarhead" )
	if sel_omega then
		sel_omega:Broadcast( NULL, false, 2 )
	end

	TransmitSound( "scp_lc/warhead/alarm.ogg", true, 1 )
	AddTimer( "AlphaSiren", 3, 1, function()
		local time = CVAR.slc_time_alpha:GetInt()
		PlayerMessage( "alpha_detonation$"..time )
		TransmitSound( "scp_lc/warhead/siren.wav", true, 1 )

		local support_timer = GetTimer( "SupportTimer" )
		if IsValid( support_timer ) then
			support_timer:Destroy()
			//print( "SUPPORT TIMER DESTROYED" )
		end

		AddTimer( "AlphaCountdown", time - 10, 1, function()
			//print( "Lockdown" )
			SetRoundProperty( "warhead_lockdown", true )

			local escape_timer = GetTimer( "EscapeTimer" )
			if IsValid( escape_timer ) then
				escape_timer:Destroy()
				//print( "ESCAPE TIMER DESTROYED" )
			end

			AddTimer( "AlphaSiren", 5, 1, function()
				TransmitSound( "scp_lc/warhead/siren.wav", false, 1 )
			end )

			AddTimer( "AlphaExplosion", 10, 1, function()
				//print( "HOLDING ROUND" )
				HoldRound()

				for k, v in pairs( ALPHA_DESTROY ) do
					if IsValid( k ) then
						k:Remove()
					end
				end
				
				ALPHA_DESTROY = {}

				local surface = {}
				local facility = {}

				local clr = Color( 255, 255, 255, 255 )
				for i, v in ipairs( player.GetAll() ) do
					if v:IsInZone( ZONE_SURFACE ) then
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
							v:SkipNextSuicide()
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

				//print( "RELEASING ROUND" )
				ReleaseRound()

				if IsValid( ALPHA_WARHED_SCREEN ) then
					ALPHA_WARHED_SCREEN:SetState( 4 )
					ALPHA_WARHED_SCREEN:SetUsable( false )
				end
			end )
		end )
	end )

	return true
end

function ALLWarheads( time )
	print( "ALL WARHEADS Activated" )
	
	if GetRoundStat( "goc_warhead" ) then return end
	SetRoundStat( "omega_warhead", true )
	SetRoundStat( "alpha_warhead", true )
	SetRoundStat( "goc_warhead", true )

	if IsValid( ALPHA_WARHED_SCREEN ) then
		ALPHA_WARHED_SCREEN:SetState( 4 )
		ALPHA_WARHED_SCREEN:SetUsable( false )
	end

	local sel_omega = GetSELObject( "OmegaWarhead" )
	if sel_omega then
		sel_omega:Broadcast( NULL, false, 2 )
	end

	TransmitSound( "scp_lc/warhead/alarm.ogg", true, 1 )
	AddTimer( "GOCSiren", 3, 1, function()

		//print( "Opening doors..." )

		PlayerMessage( "goc_detonation$"..time )
		TransmitSound( "scp_lc/warhead/siren.wav", true, 1 )

		local a_doors = { [OMEGA_GATE_A_DOOR_L] = true, [OMEGA_GATE_A_DOOR_R] = true }
		local s_doors = { [OMEGA_SHELTER_DOOR_L] = true, [OMEGA_SHELTER_DOOR_R] = true }

		for k, v in ipairs( ents.GetAll() ) do
			if v:GetClass() == "func_door" and ( a_doors[v:GetName()] or s_doors[v:GetName()] ) then
				v:Fire( "Unlock" )
				v:Fire( "Open" )
			end
		end

		AddTimer( "GOCCountdown", time - 10, 1, function()
			//print( "closig shelter, lockdown" )

			SetRoundProperty( "warhead_lockdown", true )

			for k, v in ipairs( ents.GetAll() ) do
				if v:GetClass() == "func_door" and ( s_doors[v:GetName()] ) then
					v:Fire( "Close" )
				end
			end

			local escape_timer = GetTimer( "EscapeTimer" )
			if IsValid( escape_timer ) then
				escape_timer:Destroy()
			end

			AddTimer( "GOCShelter", 5, 1, function()
				TransmitSound( "scp_lc/warhead/siren.wav", false, 1 )

				HoldRound()
				omega_shelter()
			end )

			AddTimer( "GOCExplosion", 10, 1, function()
				local clr = Color( 255, 255, 255, 255 )
				for i, v in ipairs( player.GetAll() ) do
					v:ScreenFade( SCREENFADE.IN, clr, 2, 3 )

					if v:Alive() then
						v:SetProperty( "death_info_override", {
							type = "mia",
							args = {
								v:IsInZone( ZONE_SURFACE ) and "alpha_mia" or "omega_mia"
							}
						} )
						
						v:SkipNextKillRewards()
						v:Kill()
					end
				end

				TransmitSound( "scp_lc/warhead/explosion.ogg", true, player.GetAll(), 1 )

				//print( "RELEASING ROUND" )
				SetRoundStat( "omega_warhead", false )
				SetRoundStat( "alpha_warhead", false )

				ReleaseRound()
			end )
		end )
	end )

	return true
end

function IsGOCDeviceValid()
	local device_placed = LocateEntity( "slc_goc_device" )
	if IsValid( device_placed ) then
		return !device_placed:GetDestroyed()
	end

	if #SCPTeams.GetPlayersByTeam( TEAM_GOC ) == 0 then return false end

	local dev = LocateEntity( "item_slc_goc_device" )
	return dev == true or IsValid( dev )
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

--[[-------------------------------------------------------------------------
Lockdown
---------------------------------------------------------------------------]]
function InitiateLockdown( ply, ent, cb )
	local dur = CVAR.slc_lockdown_duration:GetInt()
	if dur <= 0 then return false end
	if ROUND.preparing or ROUND.post then return false end

	local status = GetRoundProperty( "facility_lockdown", 0 )
	if status > 0 then
		if status == 2 then
			PlayerMessage( "lockdown_once", ply, true )
		end

		return false
	end

	SetRoundProperty( "facility_lockdown", 1 )

	AddTimer( "DisableLockdown", dur, 1, function()
		SetRoundProperty( "facility_lockdown", 2 )

		if cb and cb() == true then return end

		if IsValid( ent ) then
			ent:Fire( "Use" )
		end
	end )

	hook.Run( "SLCLockdown", ply, dur )
	return true
end

--[[-------------------------------------------------------------------------
Auto destroy gate a
---------------------------------------------------------------------------]]
hook.Add( "SLCRound", "SLCAutoDestroyGateA", function( time )
	local auto = CVAR.slc_auto_destroy_gatea:GetInt()
	if auto > 0 then
		AddTimer( "auto_destroy_gatea", time - auto - 5, 1, function()
			local btn = GetButton( "Gate A" )
			if !btn then return end

			if istable( btn ) then
				for k, v in pairs( btn ) do
					v:Fire( "lock" )
				end
			else
				btn:Fire( "lock" )
			end

			local remote = GetButton( "remote" )
			if remote then
				remote:Fire( "lock" )
			end

			AddTimer( "auto_destroy_gatea2", 5, 1, function()
				ExplodeGateA()
			end )
		end )
	end
end )

--[[-------------------------------------------------------------------------
Pocket Dimension
---------------------------------------------------------------------------]]
function SendToPocketDimension( ply, attacker )
	ply:SetPos( istable( POS_POCKETD ) and POS_POCKETD[SLCRandom( #POS_POCKETD )] or POS_POCKETD )
	ply:SetAngles( Angle( 0, SLCRandom( -180, 180 ), 0 ) )
	//ply:ScreenFade( bit.bor( SCREENFADE.IN, SCREENFADE.OUT ), Color( 0, 0, 0 ), 0.05, 0.3 )
	ply:ApplyEffect( "decay", attacker )

	TransmitSound( "#scp_lc/scp/106/decay.ogg", true, ply, 1 )
end