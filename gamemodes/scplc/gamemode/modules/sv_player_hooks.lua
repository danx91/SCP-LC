function GM:PlayerInitialSpawn( ply )
	ply:DataTables()

	PlayerInfo( ply ).Ready:Then( function()
		if !IsValid( ply ) then return end

		ply.playermeta = {}
		hook.Run( "SLCPlayerMeta", ply, ply.playermeta )

		if ply.FullyLoaded and !ply:IsActive() then
			hook.Run( "PlayerReady", ply )
		end
	end )

	DamageLogger( ply )

	ply:CheckPremium()

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
	net.SendTable( "SLCPlayerMeta", ply.playermeta or {}, ply )
	gamerule.SendAll( ply )

	ply:SetIsActive( true )

	if !ROUND.preparing or ply:GetInfoNum( "cvar_slc_preparing_classd", 0 ) == 0 then
		QueueInsert( ply )
	else
		local _, spawn = GetClassGroup( "classd" )
		ply:SetupPlayer( GetClassData( CLASSES.CLASSD ), spawn[SLCRandom( #spawn )] )
		PlayerMessage( "preparing_classd", ply )
	end

	print( "Player "..ply:Nick().." is ready!" )
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

	local t_vic = ply:GetProperty( "dmg_team_override" ) or ply:SCPTeam()
	local t_att = attacker:GetProperty( "dmg_team_override" ) or attacker:SCPTeam()

	if  t_att == TEAM_SPEC or t_vic == TEAM_SPEC then return false end
	if  ply != attacker and t_att == TEAM_SCP and t_vic == TEAM_SCP then return false end

	return true
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply.Logger:Finish( attacker, dmginfo )

	if SCPTeams.HasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) then
		SanityEvent( 10, SANITY_TYPE.DEATH, ply:GetPos() + Vector( 0, 0, 20 ), 1000, attacker, ply )
	end

	ply:DropEQ()

	ply.StoredProperties = table.Copy( ply.SLCProperties )

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
end

local kill_stat = GetRoundStat( "kill" )
local rdm_stat = GetRoundStat( "rdm" )


/*
kill
kill_rdm
kill_n
assist
assist_rdm
support
*/
local function kill_message( ply, kind, reward, team_name, victim_nick )
	if reward == 0 then
		kind = kind.."_n"
	elseif reward < 0 then
		reward = -reward
		kind = kind.."_rdm"
	end

	local nick = EscapeMessage( victim_nick )
	local team_key = "@TEAMS."..team_name

	if kind == "kill" then
		PlayerMessage( string.format( "kill$%i,%s,%s", reward, team_key, nick ), ply )
	elseif kind == "kill_rdm" then
		PlayerMessage( string.format( "kill_rdm$%i,%s,%s#200,25,25", reward, team_key, nick ), ply )
	elseif kind == "kill_n" then
		PlayerMessage( string.format( "kill_n$%s,%s", team_key, nick ), ply )
	elseif kind == "assist" then
		PlayerMessage( string.format( "assist$%i,%s", reward, nick ), ply )
	elseif kind == "assist_rdm" then
		PlayerMessage( string.format( "assist_rdm$%i,%s#200,25,25", reward, nick ), ply )
	elseif kind == "support" then
		PlayerMessage( string.format( "kill_supp$%i,%s", reward, nick ), ply )
	end
end

	/*
	PlayerMessage( string.format( "rdm$%d,%s,%s#200,25,25", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
	PlayerMessage( string.format( "kill$%d,%s,%s", reward, "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
	PlayerMessage( string.format( "kill_n$%s,%s", "@TEAMS."..tname, EscapeMessage( victim:Nick() ) ), attacker )
	PlayerMessage( string.format( "assist$%d,%s", v, EscapeMessage( victim:Nick() ) ), k )
	*/

function GM:PlayerDeath( victim, inflictor, attacker )
	local pprop = victim.StoredProperties or {}
	victim.StoredProperties = nil

	victim:SetProperty( "stored_properties", pprop )

	if ROUND.post then return end

	local victim_team = victim:SCPTeam()
	local reward_pool = isnumber( pprop.reward_override ) and pprop.reward_override or SCPTeams.GetReward( victim_team ) * 2
	local rdm_support_cap = reward_pool * 0.5
	print( "KILL - get rewards", reward_pool )

	local rewards, support_rewards, killer = victim.Logger:GetRewards( reward_pool )
	local stat_killer = killer or attacker

	kill_stat:AddValue( 1, { victim = victim, killer = stat_killer } )

	if IsValid( stat_killer ) and stat_killer != victim and stat_killer:IsPlayer() and SCPTeams.IsAlly( stat_killer:SCPTeam(), victim_team ) then
		rdm_stat:AddValue( 1, { victim = victim, killer = stat_killer } )
	end

	if rewards then
		local skip_rewards = victim._SkipNextKillRewards
		local team_name = SCPTeams.GetName( victim_team )
		local victim_nick = victim:Nick()

		hook.Run( "SLCPlayerDeath", victim, killer, rewards[killer] and rewards[killer].pct or 0 )

		for ply, data in pairs( rewards ) do
			local is_killer = ply == killer
			local reward = math.max( data.reward, -rdm_support_cap )

			if !is_killer then
				local suppress, override = hook.Run( "SLCKillAssist", ply, victim, data.pct, reward, killer )
				if suppress == true then continue end

				if isnumber( override ) then
					reward = override
				end
			end

			if skip_rewards then continue end

			ply:AddFrags( reward )
			kill_message( ply, is_killer and "kill" or "assist", reward, team_name, victim_nick )
		end

		for ply, reward in pairs( support_rewards ) do
			reward = math.min( reward, rdm_support_cap )

			local suppress, override = hook.Run( "SLCKillSupport", ply, victim, reward, killer )
			if suppress == true or skip_rewards then continue end

			if isnumber( override ) then
				reward = override
			end

			ply:AddFrags( reward )
			kill_message( ply, "support", reward, team_name, victim_nick )
		end
	end

	victim._SkipNextKillRewards = false

	victim:SetProperty( "last_team", victim:SCPTeam() )
	victim:SetProperty( "last_class", victim:SCPClass() )
	victim:SetProperty( "last_killer", killer )

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