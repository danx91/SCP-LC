function GM:PlayerInitialSpawn( ply )
	ply.playermeta = {}

	PlayerInfo( ply )
	PlayerData( ply )
	DamageLogger( ply )
	ply:DataTables()

	ply:CheckPremium()
	hook.Run( "SLCPlayerMeta", ply, ply.playermeta )

	if ply:IsBot() then
		hook.Run( "PlayerReady", ply )
	end

	//table.insert( ROUND.queue, ply )
	//QueueInsert( ply )
end

function GM:PlayerSpawn( ply )
	if !ply.initialSpawn then
		ply.initialSpawn = true

		ply:KillSilent()
		ply:SetupSpectator()

		return
	end

	ply:SetCanZoom( false )
	//ply:CrosshairDisable()
	ply:CrosshairEnable()
	ply:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR ) //xD ??? Stupid but works!

	if IsValid( ply._RagEntity ) then
		ply._RagEntity:Remove()
	end

	/*local rag = ply:GetRagdollEntity()
	if IsValid( rag ) then
		rag:Remove()
	end*/

	ply:SetupHands()
	//ply:Cleanup()
end

function GM:PlayerReady( ply )
	gamerule.SendAll( ply )

	ply:SetActive( true )
	QueueInsert( ply )

	CheckRoundStart()
end

function GM:PlayerDisconnected( ply )
	//ply:InvalidatePlayerForSpectate()
	ply.Disconnected = true

	ply:StopSound( "SLCPlayer.Breathing" )

	if ply:Alive() then
		ply:Kill()
	end

	/*timer.Simple( 0, function()
		CheckRoundEnd()
	end )*/
end

function GM:PlayerSetHandsModel( ply, ent )
	//print( "setting up hands", ent, ply:GetHands() )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )

	if info then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:CanPlayerSuicide( ply )
	return false
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if ROUND.post then return false end
	if !attacker:IsPlayer() then return true end
	if ROUND.preparing then return false end

	local t_vic = ply:SCPTeam()
	local t_att = attacker:SCPTeam()

	if  t_att == TEAM_SPEC or t_vic == TEAM_SPEC then return false end
	if  ply != attacker and t_att == TEAM_SCP and t_vic == TEAM_SCP then return false end

	return true
end

function GM:PlayerHurt( victim, attacker, health, dmg )
	--TODO: damage stats
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply.Logger:Dump( attacker, dmginfo:GetInflictor() )

	if IsValid( attacker ) and attacker:IsPlayer() then
		attacker.Logger:AddKill( ply )
	end

	if SCPTeams.HasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) then
		SanityEvent( 10, SANITY_TYPE.DEATH, ply:GetPos() + Vector( 0, 0, 20 ), 1000, attacker, ply )
	end

	ply.StoredProperties = ply.SLCProperties

	ply:DropEQ()
	ply:CreatePlayerRagdoll()
	//ply:CreateRagdoll()
	ply:Despawn()

	if attacker:IsPlayer() then
		print( "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.GetName( ply:SCPTeam() ).."] has been killed by '"..attacker:Nick().."' ["..SCPTeams.GetName( attacker:SCPTeam() ).."]" )
	elseif IsValid( attacker ) then
		print( "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.GetName( ply:SCPTeam() ).."] has been killed by '"..attacker:GetName().."' ["..attacker:GetClass().."]" )
	else
		print( "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.GetName( ply:SCPTeam() ).."] has been killed by UNKNOWN" )
	end

	ply:AddDeaths( 1 )
end

function GM:PlayerDeath( victim, inflictor, attacker )
	--TODO handle scp events
	local pprop = victim.StoredProperties or {}
	victim.StoredProperties = nil

	if !ROUND.post then
		AddRoundStat( "kill" )

		local killinfo = victim.Logger:GetDeathDetails()
		local len = #killinfo.assists

		local preventrdm = false

		if !IsValid( attacker ) or !attacker:IsPlayer() or victim == attacker then
			if len > 0 then
				local tmp = table.remove( killinfo.assists, 1 )

				attacker = tmp[1]
				killinfo.killer_pct = tmp[2]
				preventrdm = true

				len = len - 1
			end
		end

		hook.Run( "SLCPlayerDeath", victim, attacker, killinfo.killer_pct )

		for i, v in ipairs( killinfo.assists ) do
			hook.Run( "SLCKillAssist", victim, attacker, v[1], v[2] )
		end

		if !victim._skipNextKillRewards then
			//print( "PRE" )
			//PrintTable( killinfo )

			//print( "POST" )
			//PrintTable( killinfo )

			if IsValid( attacker ) and attacker:IsPlayer() and victim != attacker then
				//local ivp = IsValid( attacker ) and attacker:IsPlayer() and victim != attacker

				local t_vic = victim:SCPTeam()
				local t_att = attacker:SCPTeam()

				local rdm = !preventrdm and SCPTeams.IsAlly( t_vic, t_att )
				local reward = isnumber( pprop.reward_override ) and pprop.reward_override or SCPTeams.GetReward( t_vic )
				local tname = SCPTeams.GetName( t_vic )

				//if len > 0 and !rdm then
					local pool = reward * 2
					local init = pool
					//print( "pool", victim, pool )

					if len == 0 then
						reward = pool
					else
						local pc = math.floor( init * killinfo.killer_pct )
						if pc > reward then
							reward = pc
						end
					end

					pool = pool - reward

					local rewardtab = {}

					--phase 1: calculating
					if len > 0 then
						while pool > 0 do
							//print( "cycle" )
							for i = 1, len do
								local tab = killinfo.assists[i]
								local points = math.ceil( init * tab[2] )

								if points > pool then
									points = pool
								end

								rewardtab[tab[1]] = ( rewardtab[tab[1]] or 0 ) + points
								pool = pool - points

								if pool <= 0 then
									break
								end
							end

							if pool > 0 then
								reward = reward + 1
								pool = pool - 1
							end
						end
					end

					//print( "kill", attacker, reward, rdm )

					--phase 2: giving
					if rdm then
						AddRoundStat( "rdm" )

						local n = math.min( reward, attacker:Frags() )
						PlayerMessage( string.format( "rdm$%d,%s,%s#200,25,25", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
						attacker:AddFrags( -n )
					else
						PlayerMessage( string.format( "kill$%d,%s,%s", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
						attacker:AddFrags( reward )
					end

					for k, v in pairs( rewardtab ) do
						local override, points = hook.Run( "SLCAssistReward", k, victim, v )

						if !override then
							if points then
								v = points
							end

							PlayerMessage( string.format( "assist$%d,%s", v, EscapeMessage( victim:Nick() ) ), k )
							k:AddFrags( v )
							//print( "assist", k, v )
						//else
							//print( "" )
						end
					end
				//else
					//if rdm then
						//AddRoundStat( "rdm" )

						//local n = math.min( reward, attacker:Frags() )
						//PlayerMessage( string.format( "rdm$%d,%s,%s#200,25,25", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
						//attacker:AddFrags( -n )
					//else
						//PlayerMessage( string.format( "kill$%d,%s,%s", reward * 2, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
						//attacker:AddFrags( reward * 2 )
					//end
				//end
			end
		else
			victim._skipNextKillRewards = false
			print( "Skipping rewards", victim )
		end
	end

	//victim.LastTeam = victim:SCPTeam()
	//victim.LastClass = victim:SCPClass()
	victim:SetProperty( "last_team", victim:SCPTeam() )
	victim:SetProperty( "last_class", victim:SCPClass() )

	if pprop.death_info_override then
		victim:SetProperty( "death_info_override", pprop.death_info_override )
	end

	if pprop.death_cause_override then
		victim:SetProperty( "death_cause_override", pprop.death_cause_override )
	end

	victim:SetSCPTeam( TEAM_SPEC )
	victim:SetSCPClass( "spectator" )
	victim.SetupAsSpectator = true

	timer.Simple( 3, function()
		if IsValid( victim ) and victim.SetupAsSpectator then
			victim.SetupAsSpectator = false

			if victim:SCPTeam() == TEAM_SPEC then
				victim.DeathScreen = true
			end
		end
	end )

	CheckRoundEnd()
end

function GM:PlayerDeathThink( ply )
	if ply.SetupAsSpectator then
		if ply:KeyPressed( IN_ATTACK ) or ply:KeyPressed( IN_ATTACK2 ) or ply:KeyPressed( IN_JUMP ) then
			ply.SetupAsSpectator = false
			ply.DeathScreen = true
		end
	elseif ply.DeathScreen == true then
		ply.DeathScreen = CurTime() + INFO_SCREEN_DURATION

		local override = ply:GetProperty( "death_info_override" )
		if override then
			InfoScreen( ply, override.type, INFO_SCREEN_DURATION, override.args, ply:GetProperty( "last_team" ), ply:GetProperty( "last_class" ) )
		else
			local kill = ply.Logger:GetDeathDetails()
			local msg = "unknown"
			//local data

			/*local cause = ply:GetProperty( "death_cause_override" )
			if cause then
				if istable( cause ) then
					data = cause
				else
					msg = cause
				end
			else*/
				if IsValid(  kill.killer ) then
					if kill.killer == ply then
						msg = "suicide"
					elseif kill.killer:IsPlayer() then
						msg = { "killed_by", "text;"..EscapeMessage( kill.killer:Nick() ) }
					else
						msg = "hazard"
					end
				end
			--end

			/*if !data then
				data = { msg }
			end*/

			InfoScreen( ply, "dead", INFO_SCREEN_DURATION, { msg }, ply:GetProperty( "last_team" ), ply:GetProperty( "last_class" ) )
		end
	elseif ply.DeathScreen and ply.DeathScreen < CurTime() then
		ply.DeathScreen = nil

		QueueInsert( ply )
		ply:SetupSpectator()
	elseif !ply.DeathScreen then
		local obs = ply:GetObserverTarget()
		if IsValid( obs ) then
			ply:SetPos( obs:GetPos() )
		end
	end
end

hook.Add( "StartCommand", "SLCDeadFreeze", function( ply, cmd )
	if ply:SCPTeam() == TEAM_SPEC and ( ply.SetupAsSpectator or ply.DeathScreen ) then
		cmd:ClearMovement()
	end
end )

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerSwitchFlashlight( ply, enabled )
	return !enabled
end

--[[-------------------------------------------------------------------------
SCP "chase" effect
---------------------------------------------------------------------------]]
/*local NTerror = 0
hook.Add( "Think", "ApplyTerror", function()
	if NTerror < CurTime() then
		NTerror = CurTime() + 5

		for k, v in pairs( player.GetAll() ) do
			v.TerrorPower = 0
		end

		for k, v in pairs( SCPTeams.GetPlayersByTeam( TEAM_SCP ) ) do
			if v:GetSCPTerror() then
				for k, ply in pairs( FindInCylinder( v:GetPos(), 1500, -128, 128, nil, nil, player.GetAll() ) ) do
					local t = ply:SCPTeam()

					if t != TEAM_SCP and t != TEAM_SPEC then
						ply.TerrorPower = ply.TerrorPower + 1
						ply.NDoorLockRem = CurTime() + 10
					end
				end
			end
		end
	end
end )

hook.Add( "Think", "DoorLockThink", function()
	for k, v in pairs( player.GetAll() ) do
		if !v.NDoorLockRem then v.NDoorLockRem = 0 end

		if v.NDoorLockRem > 0 and v.NDoorLockRem < CurTime() then
			v.NDoorLockRem = 0
			v.DoorHistory = 0
		end
	end
end )

function GM:AcceptInput( ent, input, activator, caller, value )
	if STORED_DOORS and STORED_DOORS[ent] then
		if IsValid( activator ) and activator:IsPlayer() then

			local t = activator:SCPTeam()
			if t != TEAM_SCP and t != TEAM_SPEC then
				for k, ply in pairs( FindInCylinder( activator:GetPos(), 500, -128, 128, nil, nil, player.GetAll() ) ) do
					if ply.TerrorPower and ply.TerrorPower > 0 then
						if !ply.DoorHistory then ply.DoorHistory = 0 end

						local pt = ply:SCPTeam()
						if pt != TEAM_SCP and pt != TEAM_SPEC then
							ply.DoorHistory = ply.DoorHistory + 1

							if ply.DoorHistory >= 8 then
								ply.DoorHistory = 0

								if !ply:GetSCP096Chase() then
									ply:ApplyEffect( "doorlock" )
									ply.DoorLock = CurTime() + 10
									ply.NUse = CurTime() + 2.5
								end
							end
						end
					end
				end
			end
		end
	end
end*/

function GM:PlayerUse( ply, ent )
	if ply:SCPTeam() == TEAM_SPEC or ply:IsAboutToSpawn() then return false end

	local ct = CurTime()

	--Player use cooldown (anti-spamming E)
	if !ply.NextSLCUse then ply.NextSLCUse = 0 end
	if ply.NextSLCUse > ct then return false end

	--Override hook
	local data = BUTTONS_CACHE[ent]
	local _, override, result = hook.Run( "SLCUseOverride", ply, ent, data )

	if override != nil then
		return override
	end

	if result then
		data = result
	end

	--Cache door
	if !data and !ent.ButtonCacheChecked then
		ent.ButtonCacheChecked = true

		local pos = ent:GetPos()
		for _, v in pairs( BUTTONS ) do
			local btn_pos = v.pos

			if istable( btn_pos ) then
				local registered = false

				for _, tab_pos in pairs( btn_pos ) do
					if pos == tab_pos then
						data = v
						RegisterButton( v, ent, true )
						registered = true
						print( "tab reg" )
						break
					end
				end

				if registered then
					break
				end
			else
				if pos == v.pos or v.tolerance and pos:IsInTolerance( v.pos, v.tolerance ) then
					data = v
					RegisterButton( v, ent, true )
					break
				end
			end
		end
	end

	--Door cooldown
	if ent.NextSLCUse and ent.NextSLCUse >= ct then
		return false
	end

	--Player door cooldown --REMOVE useless?
	/*local pcd = ply:GetProperty( "button_cooldows" )
	if! pcd then
		pcd = ply:SetProperty( "button_cooldows", {} )
	end

	if pcd[ent] and pcd[ent] > ct then
		return false
	end*/

	--Handle usage
	if data then
		//ply.NextSLCUse = ct + 1

		if data.disabled then
			return false
		end

		if data.scp_disallow and ply:SCPTeam() == TEAM_SCP and !ply:SCPCanInteract() then
			return false
		end

		if data.warhead_lockdown and GetRoundStat( "warhead_lockdown" ) then
			return false
		end

		local omega = GetRoundStat( "omega_warhead" )
		if omega and data.omega_disable then
			return false
		end

		local alpha = GetRoundStat( "alpha_warhead" )
		if alpha and data.alpha_disable then
			return false
		end

		if omega and data.omega_override then
			return true
		end

		if alpha and data.alpha_override then
			return true
		end

		if !data.suppress_check then
			local handle_result = HandleButtonUse( ply, ent, data )

			if !handle_result then
				ply.NextSLCUse = ct + 1.5
			end

			return handle_result
		end
	else
		ply.NextSLCUse = ct + 1.5
	end

	return true
end

function GM:AcceptInput( ent, input, activator, caller, data )
	if string.lower( input ) == "use" then
		if ent:GetClass() == "func_button" then
			local btn_data = BUTTONS_CACHE[ent]

			/*if IsValid( caller ) and caller:IsPlayer() then
				caller.NextSLCUse = CurTime() + 1.5

				local pcd = caller:GetProperty( "button_cooldows" )
				if! pcd then
					pcd = caller:SetProperty( "button_cooldows", {} )
				end
				
				pcd[ent] = CurTime() + ( btn_data and btn_data.player_cooldown or 7.5 )
			end*/

			ent.NextSLCUse = CurTime() + ( btn_data and btn_data.cooldown or ent.UseCooldown or 3.5 )
		end
	end
end

hook.Add( "EntityKeyValue", "SLCButtons", function( ent, key, value )
	if ent:GetClass() == "func_button" and key == "wait" then
		ent.UseCooldown = tonumber( value ) + 0.5
	end
end )

function GM:PlayerSay( ply, text, team )
	return text
end

function GM:PlayerCanSeePlayersChat( text, team, listener, speaker )
	if speaker == NULL then return true end
	return hook.Run( "PlayerCanHearPlayersVoice", listener, speaker ) --SLC uses the same rules for voice and chat
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if ROUND.infoscreen then return false end

	local t_lis = listener:SCPTeam()
	local t_tal = talker:SCPTeam()

	--spec
	if t_tal == TEAM_SPEC then
		return t_lis == TEAM_SPEC
	end

	--scp
	if t_tal == TEAM_SCP and t_lis != TEAM_SCP and !talker:GetSCPHuman() and !talker:GetSCPChat() then
		return false
	end

	--radio
	local radio_t = talker:GetWeapon( "item_slc_radio" )
	local radio_l = listener:GetWeapon( "item_slc_radio" )

	if IsValid( radio_t ) and IsValid( radio_l ) then
		if radio_t:GetEnabled() and radio_l:GetEnabled() and radio_t:GetChannel() == radio_l:GetChannel() then
			return true
		end
	end


	if listener:GetPos():DistToSqr( talker:GetPos() ) <= 562500 then --750 * 750
		return true, true
	end

	return false
end

function GM:AllowPlayerPickup( ply, ent )
	local t = ply:SCPTeam()
	if t == TEAM_SPEC or t == TEAM_SCP then return false end
	return ent:GetName() == "4016" --allow picking up melon
end

function GM:PlayerCanPickupItem( ply, item )
	return false
end

--moved to sh_player.lua
/*function GM:PlayerCanPickupWeapon( ply, wep )
	
end*/

hook.Add( "SetupPlayerVisibility", "CCTVPVS", function( ply, viewentity )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and wep:GetClass() == "item_slc_camera" then
		if wep:GetEnabled() and IsValid( CCTV[wep:GetCAM()].ent ) then
			AddOriginToPVS( CCTV[wep:GetCAM()].pos )
		end
	end
end )