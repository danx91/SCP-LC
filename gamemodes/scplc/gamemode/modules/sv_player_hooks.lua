function GM:PlayerInitialSpawn( ply )
	PlayerData( ply )
	ply:DataTables()

	ply:CheckPremium()

	if ply:IsBot() then
		ply:SetActive( true )
		CheckRoundStart()
	end

	table.insert( ROUND.queue, ply )
end

function GM:PlayerSpawn( ply )
	if !ply.initialSpawn then
		ply.initialSpawn = true

		ply:KillSilent()
		ply:SetupSpectator()

		return
	end

	ply:SetCanZoom( false )
	ply:CrosshairEnable()
	ply:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR ) //xD???
	//ply:Cleanup()
end

--TODO remove
/*concommand.Add( "spawn", function( ply, cmd, args )
	local n = tonumber( args[1] )
	if n then
		ply = player.GetAll()[n]
	end

	if !IsValid( ply ) then return end

	ply:UnSpectate()
	ply:Spawn()
	ply:Cleanup()
	ply:SetupHands()

	ply:SetModel( "models/player/kleiner.mdl" )
	ply:SetSCPTeam( TEAM_CLASSD )
end )*/

-- concommand.Add( "teams", function( ply, cmd, args )
-- 	for k, v in pairs( player.GetAll() ) do
-- 		print( v, v:SCPTeam(), v:Alive() )
-- 	end
-- end )

function GM:PlayerDisconnected( ply )
	ply:InvalidatePlayerForSpectate()
	ply:StopSound( "Player.Breathing" )

	timer.Simple( 0, function()
		CheckRoundEnd()
	end )
end

function GM:PlayerSetHandsModel( ply, ent )
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
	if !attacker:IsPlayer() then return true end

	local t_vic = ply:SCPTeam()
	local t_att = attacker:SCPTeam()

	if  t_att == TEAM_SPEC or t_vic == TEAM_SPEC then return false end
	if  ply != attacker and t_att == TEAM_SCP and t_vic == TEAM_SCP then return false end

	return true
end

function GM:PlayerHurt( victim, attacker, health, dmg )
	--handle damage stats
end

function GM:DoPlayerDeath( ply, attacker, dmginfo ) --TODO
	--rag
	ply:CreateRagdoll()
	ply:DropEQ()
	
	if attacker:IsPlayer() then
		print( "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.getName( ply:SCPTeam() ).."] has been killed by '"..attacker:Nick().."' ["..SCPTeams.getName( attacker:SCPTeam() ).."]" )
	elseif IsValid( attacker ) then
		print( "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.getName( ply:SCPTeam() ).."] has been killed by '"..attacker:GetName().."' ["..attacker:GetClass().."]" )
	else
		print( "[KILL] Player '"..ply:Nick().."' ["..SCPTeams.getName( ply:SCPTeam() ).."] has been killed by UNKNOWN" )
	end

	ply:Despawn()

	if !table.HasValue( ROUND.queue, ply ) then
		table.insert( ROUND.queue, ply )
	end

	ply:AddDeaths( 1 )
end

function GM:PlayerDeath( victim, inflictor, attacker )
	--TODO handle scp events

	--AddRoundStat( "kill" )

	if IsValid( attacker ) and attacker:IsPlayer() and victim != attacker then
		local t_vic = victim:SCPTeam()
		local t_att = attacker:SCPTeam()

		local tname = SCPTeams.getName( t_vic )
		local rdm = SCPTeams.isAlly( t_vic, t_att )
		local reward = SCPTeams.getReward( t_vic )

		local score = attacker:Frags()

		if rdm then
			--AddRoundStat( "rdm" )

			local n = math.min( reward, score )
			PlayerMessage( string.format( "rdm$%d,%s,%s", reward, "@TEAMS:"..tname, victim:Nick() ), attacker )
			attacker:SetFrags( score - n )
		else
			PlayerMessage( string.format( "kill$%d,%s,%s", reward, "@TEAMS:"..tname, victim:Nick() ), attacker )
			attacker:SetFrags( score + reward )
		end
	end

	victim:SetSCPTeam( TEAM_SPEC )
	victim:SetSCPClass( "spectator" )
	victim.SetupAsSpectator = true

	timer.Simple( 3, function()
		if IsValid( victim ) and victim.SetupAsSpectator then
			victim.SetupAsSpectator = false
			victim:SetupSpectator()
		end
	end )

	CheckRoundEnd()
end

function GM:PlayerDeathThink( ply ) --TODO
	/*if ply:GetNClass() == ROLES.ROLE_SCP076 and IsValid( SCP0761 ) then
		if ply.n076nextspawn and ply.n076nextspawn < CurTime() then
			--ply:SetSCP076()
			local scp = GetSCP( "SCP076" )
			if scp then
				scp:SetupPlayer( ply )
			end
		end
		return
	end*/

	if ply.SetupAsSpectator then
		if ply:KeyPressed( IN_ATTACK ) or ply:KeyPressed( IN_ATTACK2 ) or ply:KeyPressed( IN_JUMP ) then
			ply.SetupAsSpectator = false
			ply:SetupSpectator()
		end
	else
		local obs = ply:GetObserverTarget()
		if IsValid( obs ) then
			ply:SetPos( obs:GetPos() )
		end
	end
end

hook.Add( "StartCommand", "DeadFreeze", function( ply, cmd )
	if ply:SCPTeam() == TEAM_SPEC and ply.SetupAsSpectator then
		cmd:ClearMovement()
	end
end )

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerSwitchFlashlight( ply, enabled )
	return !enabled
end

/*
Button structure
{
	name = "name of button",
	pos = Vector( 0, 0, 0 ),
	access = ACCESS_*, --optional, keycard access required to open door
	nosound = true, --optional, if true game will not play keycard sound
	tolerance = <number or table>, --optional, tolerance in which game should look for button
	override = function( ply, ent ) end, --optional, return true to allow, false to disallow and nil to do access check
	access_msg = "", --optional, custom message for player when access is granted
	deny_msg = "", --optional, custom message for player when access is denied
	nocard_msg = "", --optional, custom message for player when he has no keycard
	access_granted = function( ply )  end, --optional, called when access is granted for player, return false to suppress use event
}
*/

local NTerror = 0
hook.Add( "Think", "ApplyTerror", function()
	if NTerror < CurTime() then
		NTerror = CurTime() + 5

		for k, v in pairs( player.GetAll() ) do
			v.TerrorPower = 0
		end

		for k, v in pairs( SCPTeams.getPlayersByTeam( TEAM_SCP ) ) do
			for k, ply in pairs( FindInCylinder( v:GetPos(), 1500, -128, 128, { "player" } ) ) do
				local t = ply:SCPTeam()

				if t != TEAM_SCP and t != TEAM_SPEC then
					ply.TerrorPower = ply.TerrorPower + 1
					ply.NDoorLockRem = CurTime() + 15
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
				for k, ply in pairs( FindInCylinder( activator:GetPos(), 500, -128, 128, { "player" }, nil, player.GetAll() ) ) do
					if ply.TerrorPower and ply.TerrorPower > 0 then
						if !ply.DoorHistory then ply.DoorHistory = 0 end

						local pt = ply:SCPTeam()
						if pt != TEAM_SCP and pt != TEAM_SPEC then
							ply.DoorHistory = ply.DoorHistory + 1

							if ply.DoorHistory >= 8 then
								ply.DoorHistory = 0

								ply.DoorLock = CurTime() + 15
								ply.NUse = CurTime() + 2.5
							end
						end
					end
				end
			end
		end
	end
end

function GM:PlayerUse( ply, ent )
	if ply:SCPTeam() == TEAM_SPEC then return false end

	if !ply.NUse then ply.NUse = 0 end
	if ply.NUse > CurTime() then return false end

	if ply.DoorLock and ply.DoorLock > CurTime() then
		ply.NUse = CurTime() + 2.5
		PlayerMessage( "acc_deny", ply, true )

		return false
	end

	for k, v in pairs( BUTTONS ) do
		local pos = ent:GetPos()

		if pos == v.pos or v.tolerance and pos:IsInTolerance( v.pos, v.tolerance ) then
			ply.NUse = CurTime() + 1

			local keycard = false
			local access = nil

			if v.override then
				access = v.override( ply, ent )
			end

			if access == nil and v.access then
				if GetRoundStat( "omega_active" ) then
					access = true
				else
					access = false

					local wep = ply:GetActiveWeapon()
					if IsValid( wep ) and wep:GetClass() == "item_slc_keycard" then
						keycard = true
						if bit.band( v.access, wep.Access ) > 0 then
							access = true
						end
					else
						--keycard required
						--print( "no card!" )
						PlayerMessage( v.nocard_msg or "acc_nocard", ply, true )
						return false
					end
				end
			end

			if access or access == nil then
				--granted
				--print( "granted!" )
				if keycard and !v.nosound then
					ent:EmitSound( "KeycardUse1.ogg" )
				end

				PlayerMessage( v.access_msg or "acc_granted", ply, true )

				if v.access_granted then
					return v.access_granted( ply ) or false
				else
					return true
				end
			else
				if keycard then
					--wrong card
					--print( "wrong card!" )
					if !v.nosound then
						ent:EmitSound( "KeycardUse2.ogg" )
					end

					PlayerMessage( "acc_wrongcard", ply, true )
					return false
				else
					--denied
					--print( "denied!" )
					if keycard and !v.nosound then
						ent:EmitSound( "KeycardUse2.ogg" )
					end

					PlayerMessage( v.deny_msg or "acc_deny", ply, true )
					return false
				end
			end
		end
	end

	if ent:GetClass() == "prop_vehicle_jeep" then
		if ply:SCPTeam() == TEAM_SCP and !ply.SCPHuman then
			return false
		end
	end

	return true
end

function GM:PlayerSay( ply, text, team )
	return text
end

function GM:PlayerCanSeePlayersChat( text, team, listener, speaker )
	if speaker == NULL then return true end
	return hook.Run( "PlayerCanHearPlayersVoice", listener, speaker ) --SLC uses the same rule for voice and chat
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	local t_lis = listener:SCPTeam()
	local t_tal = talker:SCPTeam()

	--spec
	if t_tal == TEAM_SPEC then
		return t_lis == TEAM_SPEC
	end

	--scp
	if t_tal == TEAM_SCP and t_lis != TEAM_SCP and !talker.SCPHuman and !talker.SCPChat then
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

function GM:PlayerCanPickupWeapon( ply, wep )
	local t = ply:SCPTeam()
	if t == TEAM_SPEC then return end

	if t == TEAM_SCP and !ply.SCPHuman then
		if wep.SCP then
			return true
		end

		return false
	end

	if wep.SCP then
		return false
	end

	if ply:HasWeapon( wep:GetClass() ) then
		return false
	end

	if !wep.Dropped then
		return true
	elseif wep.Dropped > CurTime() - 1 then
		return false
	end

	if ply:KeyDown( IN_USE ) then
		if wep == ply:GetEyeTrace().Entity then
			return true
		end
	end

	return false
end

hook.Add( "PlayerSay", "SCPPenaltyShow", function( ply, msg, teamonly )
	if string.lower( msg ) == "!scp" then
		if !ply.nscpcmdcheck or ply.nscpcmdcheck < CurTime() then
			ply.nscpcmdcheck = CurTime() + 10

			local r = tonumber( ply:GetSCPData( "scp_penalty", 0 ) )

			if r == 0 then
				PlayerMessage( "scpready#50,200,50", ply )
			else
				PlayerMessage( "scpwait$"..r.."#200,50,50", ply )
			end
		end

		return ""
	end
end )

hook.Add( "SetupPlayerVisibility", "CCTVPVS", function( ply, viewentity )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) and wep:GetClass() == "item_slc_camera" then
		if wep:GetEnabled() and IsValid( CCTV[wep:GetCAM()].ent ) then
			AddOriginToPVS( CCTV[wep:GetCAM()].pos )
		end
	end
end )