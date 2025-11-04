function GM:PlayerInitialSpawn( ply )
	ply.playermeta = {}

	ply:DataTables()

	PlayerInfo( ply )
	PlayerData( ply )
	DamageLogger( ply )

	ply:CheckPremium()
	hook.Run( "SLCPlayerMeta", ply, ply.playermeta )

	if ply:IsBot() then
		hook.Run( "PlayerReady", ply )
	end

	timer.Simple( 15, function()
		if !IsValid( ply ) then return end
		ply:ResetDailyBonus()
	end )
end

function GM:PlayerSpawn( ply )
	if !ply.InitialSpawn then
		ply.InitialSpawn = true

		ply:KillSilent()
		ply:SetupSpectator()

		return
	end

	ply:SetCanZoom( false )
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

	if !ROUND.preparing or ply:GetInfoNum( "cvar_slc_preparing_classd", 0 ) == 0 then
		QueueInsert( ply )
	else
		local _, spawn = GetClassGroup( "classd" )
		ply:SetupPlayer( GetClassData( CLASSES.CLASSD ), spawn[SLCRandom( #spawn )] )
		PlayerMessage( "preparing_classd", ply )
	end

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
	if ply:HasEffect( "spawn_protection" ) then return false end
	if !attacker:IsPlayer() or ply == attacker then return true end
	if ROUND.preparing then return false end
	
	local t_vic = ply:SCPTeam()
	local t_att = attacker:GetProperty( "kill_team_override" ) or attacker:SCPTeam()

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

	ply:DropEQ()

	ply.StoredProperties = ply.SLCProperties

	if !ply._SkipNextRagdoll then
		ply:CreatePlayerRagdoll()
	end

	ply._SkipNextRagdoll = false

	ply:Despawn()

	local txt = "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.GetName( ply:SCPTeam() ).."]["..ply:SCPClass().."] has been killed by "

	if attacker:IsPlayer() then
		txt = txt.."'"..attacker:Nick().."' ["..SCPTeams.GetName( attacker:SCPTeam() ).."]["..attacker:SCPClass().."]"
	elseif IsValid( attacker ) then
		txt = txt.."'"..attacker:GetName().."' ["..attacker:GetClass().."]"
	else
		txt = txt.."UNKNOWN"
	end

	print( txt )

	ply:AddDeaths( 1 )
end

function GM:PlayerDeath( victim, inflictor, attacker )
	local pprop = victim.StoredProperties or {}
	victim.StoredProperties = nil

	victim:SetProperty( "stored_properties", pprop )

	if ROUND.post then return end

	AddRoundStat( "kill" )

	local killinfo = victim.Logger:GetDeathDetails()
	if killinfo then
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
			hook.Run( "SLCKillAssist", v[1], victim, v[2], attacker )
		end

		if !victim._SkipNextKillRewards then
			if IsValid( attacker ) and attacker:IsPlayer() and victim != attacker then
				local t_vic = victim:SCPTeam()
				local t_att = attacker:GetProperty( "kill_team_override" ) or attacker:SCPTeam()

				local rdm = !preventrdm and !attacker:GetProperty( "prevent_rdm" ) and SCPTeams.IsAlly( t_att, t_vic )
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
					//print( t_att, t_vic, SCPTeams.IsAlly( t_att, t_vic ), SCPTeams.IsEnemy( t_att, t_vic ), SCPTeams.IsNeutral( t_att, t_vic ) )

					local custom = attacker:GetProperty( "rdm_override" )
					if custom then
						local ovr, result = custom( attacker, victim )
						if ovr then
							if result == true then
								rdm = true
							elseif result == false then
								preventrdm = true
							end
						end
					end

					--phase 2: giving
					if rdm and !preventrdm then
						AddRoundStat( "rdm" )

						local n = math.min( reward, attacker:Frags() )
						PlayerMessage( string.format( "rdm$%d,%s,%s#200,25,25", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
						attacker:AddFrags( -n )
					elseif preventrdm or SCPTeams.IsEnemy( t_att, t_vic ) then
						PlayerMessage( string.format( "kill$%d,%s,%s", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
						attacker:AddFrags( reward )
					else
						PlayerMessage( string.format( "kill_n$%s,%s", "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
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
			victim._SkipNextKillRewards = false
			print( "Skipping rewards", victim )
		end
	end

	//victim.LastTeam = victim:SCPTeam()
	//victim.LastClass = victim:SCPClass()
	victim:SetProperty( "last_team", victim:SCPTeam() )
	victim:SetProperty( "last_class", victim:SCPClass() )
	victim:SetProperty( "last_killer", attacker )

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
			local killer = ply:GetProperty( "last_killer" )
			local msg = { "unknown" }

			if IsValid( killer ) then
				if killer == ply then
					msg = { "suicide" }
				elseif killer:IsPlayer() then
					local kteam = killer:SCPTeam()

					if kteam == TEAM_SPEC then
						kteam = killer:GetProperty( "last_team" )
					end

					msg = {
						{ "killed_by", "text;"..EscapeMessage( killer:Nick() ) },
					}

					if kteam and kteam != TEAM_SPEC then
						table.insert( msg, { "killer_t", "team;"..kteam } )
					end
				else
					msg = { "hazard" }
				end
			end

			InfoScreen( ply, "dead", INFO_SCREEN_DURATION, msg, ply:GetProperty( "last_team" ), ply:GetProperty( "last_class" ) )
		end
	elseif ply.DeathScreen and ply.DeathScreen < CurTime() then
		ply.DeathScreen = nil

		local killer = ply:GetProperty( "last_killer" )
		if ply._ForceSuicideQueue or !ply._SkipNextSuicide and ( killer == ply or !IsValid( killer ) or !killer:IsPlayer() ) then
			QueueInsertSuicide( ply )
		else
			QueueInsert( ply )
		end

		ply._ForceSuicideQueue = false
		ply._SkipNextSuicide = false

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

function GM:PlayerUse( ply, ent )
	if ply:GetAdminMode() then return true end
	if ply:SCPTeam() == TEAM_SPEC or ply:IsAboutToSpawn() then return false end

	local ct = CurTime()

	--Player use cooldown (anti-spamming E)
	if !ply.NextSLCUse then ply.NextSLCUse = 0 end
	if ply.NextSLCUse > ct then return false end

	--Lootables
	if !ent.LootingDisabled and ply:IsHuman() and ent:InstanceOf( "Lootable" ) then
		ent:OpenInventory( ply )
		ply.NextSLCUse = ct + 1.5
		return false
	end

	--Override hook
	local data = BUTTONS_CACHE[ent]
	local _, override, result = hook.Run( "SLCUseOverride", ply, ent, data )

	if override != nil then
		return override
	end

	if result then
		if !data then
			BUTTONS_CACHE[ent] = result
		end

		data = result
	end

	--Cache door
	if !data and !ent.ButtonCacheChecked or DEVELOPER_MODE then
		ent.ButtonCacheChecked = true

		local pos = ent:GetPos()
		local name = ent:GetName()
		local map_id = ent:MapCreationID()
		for _, v in pairs( BUTTONS ) do
			if v.ent_name and v.ent_name == name then
				data = v
				RegisterButton( v, ent, true )
				break
			end

			if v.ent_id and v.ent_id == map_id then
				data = v
				RegisterButton( v, ent, true )
				break
			end

			local btn_pos = v.pos

			if istable( btn_pos ) then
				local registered = false

				for _, tab_pos in pairs( btn_pos ) do
					if pos == tab_pos then
						data = v
						RegisterButton( v, ent, true )
						registered = true
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

	--Handle usage
	if data then
		//ply.NextSLCUse = ct + 1

		if data.disabled then
			return false
		end

		if data.scp_disallow and ply:SCPTeam() == TEAM_SCP and !ply:SCPCanInteract() then
			return false
		end

		if data.warhead_lockdown and GetRoundProperty( "warhead_lockdown" ) then
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

		if istable( data.decon_override ) then
			for i, v in ipairs( data.decon_override ) do
				if GetGasPower( v ) > 0 then
					return true
				end
			end
		elseif data.decon_override and GetGasPower( data.decon_override ) > 0 then
			return true
		end

		if !data.suppress_check then
			local handle_result = HandleButtonUse( ply, ent, data )

			if !handle_result then
				ply.NextSLCUse = ct + 0.5
			end

			return handle_result
		end
	else
		ply.NextSLCUse = ct + 0.5
	end

	return true
end

function GM:AcceptInput( ent, input, activator, caller, data )
	//print( "INPUT", ent, ent:GetName(), input, activator, caller, IsValid( caller ) and caller:GetName() or "-", data )

	local catch = SLC_CATCH_INPUT[ent]
	if catch and catch( ent, input, activator, caller, data ) == true then
		return true
	end

	local btn_data = BUTTONS_CACHE[ent]

	if btn_data and btn_data.accept_input and btn_data.accept_input( ent, input, activator, caller, data ) == true then
		return true
	end

	if string.lower( input ) == "use" and ( ent:GetClass() == "func_button" or btn_data and btn_data.cooldown or ent.UseCooldown ) then
		local new = CurTime() + ( btn_data and btn_data.cooldown or ent.UseCooldown or 2.5 )
		if !ent.NextSLCUse or new > ent.NextSLCUse then
			ent.NextSLCUse = new
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
	if ROUND.infoscreen or listener:IsAboutToSpawn() or talker:IsAboutToSpawn() then return false end
	if listener:GetAdminMode() or talker:GetAdminMode() then return true end
	if !listener:IsActive() then return false end

	local override, ret2 = hook.Run( "PlayerSpeakOverride", talker, listener )
	if override != nil then
		return override, ret2
	end

	local t_lis = listener:SCPTeam()
	local t_tal = talker:SCPTeam()

	--spec
	if t_tal == TEAM_SPEC then
		return t_lis == TEAM_SPEC
	elseif listener:GetObserverMode() == OBS_MODE_ROAMING then
		return false
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

function GM:WeaponEquip( wep, ply )
	timer.Simple( 0, function()
		ply:UpdateEQ()
	end )
end