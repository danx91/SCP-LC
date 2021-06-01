local ULX_CAT = " SCP: Lost Control"

if SERVER and ULib then
	ULib.ucl.registerAccess( "slc spectatescp", ULib.ACCESS_OPERATOR, "Allows player to bypass anti-ghosting system and let them spectate SCPs", ULX_CAT )
	ULib.ucl.registerAccess( "slc spectateinfo", ULib.ACCESS_OPERATOR, "Allows player to details about player they are currently spectating", ULX_CAT )
	ULib.ucl.registerAccess( "slc skipintro", ULib.ACCESS_OPERATOR, "Allows player to skip info screen at the start of the round", ULX_CAT )
	ULib.ucl.registerAccess( "slc afkdontkick", ULib.ACCESS_ADMIN, "Don't kick players with this access if they are AFK", ULX_CAT )

	hook.Add( "SLCCanSpectateSCP", "SLCBaseULX", function( ply )
		if ULib.ucl.query( ply, "slc spectatescp" ) then
			return true
		end
	end )
end

function InitializeSCPULX()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end

	local class_names = {}
	for group_name, group in pairs( getGroups() ) do
		if group_name != "SUPPORT" then
			for k, class in pairs( group ) do
				table.insert( class_names, k )
			end
		else
			for _, group in pairs( group ) do
				for k, class in pairs( group ) do
					table.insert( class_names, k )
				end
			end
		end
	end

	function ulx.forcespawn( ply, plyt, class_n, silent )
		if !class_n then return end
		
		if !plyt:GetActive() then
			ULib.tsayError( ply, "Player "..plyt:Nick().." is inactive! Force spawn failed", true )
			return
		end

		local class
		local spawn

		for group_name, group in pairs( getGroups() ) do
			if group_name != "SUPPORT" then
				local _, grspwn = getClassGroup( group_name )
				for k, c in pairs( group ) do
					if k == class_n then
						class = c
						spawn = grspwn
						break
					end
				end
			else
				for group_name, group in pairs( group ) do
					local _, grspwn = getSupportGroup( group_name )
					for k, c in pairs( group ) do
						if k == class_n then
							class = c
							spawn = grspwn
							break
						end
					end
				end
			end

			if class then
				break
			end
		end

		if !class or !spawn then return end

		local pos = table.Random( spawn )
		plyt:SetupPlayer( class, pos, true )

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..class.name, plyt )
		else
			ulx.fancyLogAdmin( ply, "#A force spawned #T as "..class.name, plyt )
		end
	end

	local forcespawn = ulx.command( ULX_CAT, "ulx force_spawn", ulx.forcespawn, "!forcespawn" )
	forcespawn:addParam{ type = ULib.cmds.PlayerArg }
	forcespawn:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn:setOpposite( "ulx silent force_spawn", { nil, nil, nil, true }, "!sforcespawn" )
	forcespawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn:help( "Sets player to specific class and spawns him" )

	function ulx.slcxp( ply, plyt, xp, silent )
		if !isnumber( xp ) then return end

		plyt:AddXP( xp )

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A gave #T "..xp.." experience", plyt )
		else
			ulx.fancyLogAdmin( ply, "#A gave #T "..xp.." experience", plyt )
		end
	end

	local slcxp = ulx.command( ULX_CAT, "ulx xp", ulx.slcxp, "!xp" )
	slcxp:addParam{ type = ULib.cmds.PlayerArg }
	slcxp:addParam{ type = ULib.cmds.NumArg, hint = "XP" }
	slcxp:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	slcxp:setOpposite( "ulx silent xp", { nil, nil, nil, true }, "!sxp" )
	slcxp:defaultAccess( ULib.ACCESS_SUPERADMIN )
	slcxp:help( "Gives XP to specified player" )

	function ulx.level( ply, plyt, lvl, silent )
		if !isnumber( lvl ) then return end

		for k, v in pairs( plyt ) do
			v:AddLevel( lvl )
		end

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A gave #T "..lvl.." level(s)", plyt )
		else
			ulx.fancyLogAdmin( ply, "#A gave #T "..lvl.." level(s)", plyt )
		end
	end

	local level = ulx.command( ULX_CAT, "ulx level", ulx.level, "!level" )
	level:addParam{ type = ULib.cmds.PlayersArg }
	level:addParam{ type = ULib.cmds.NumArg, hint = "Level" }
	level:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	level:setOpposite( "ulx silent level", { nil, nil, nil, true }, "!slevel" )
	level:defaultAccess( ULib.ACCESS_SUPERADMIN )
	level:help( "Gives level to specified player" )

	/*function ulx.adminmode( ply, silent )
		ply:ToggleAdminModePref()
		if ply.admpref then
			if ply.AdminMode then
				if silent then
					ulx.fancyLogAdmin( ply, true, "#A entered admin mode" )
				else
					ulx.fancyLogAdmin( ply, "#A entered admin mode" )
				end
			else
				if silent then
					ulx.fancyLogAdmin( ply, true, "#A will enter admin mode in next round" )
				else
					ulx.fancyLogAdmin( ply, "#A will enter admin mode in next round" )
				end
			end
		else
			if silent then
				ulx.fancyLogAdmin( ply, "#A will no longer be in admin mode" )
			else
				ulx.fancyLogAdmin( ply, "#A will no longer be in admin mode" )
			end
		end
	end

	local adminmode = ulx.command( ULX_CAT, "ulx admin_mode", ulx.adminmode, "!adminmode" )
	adminmode:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	adminmode:setOpposite( "ulx silent admin_mode", { nil, true }, "!sadminmode" )
	adminmode:defaultAccess( ULib.ACCESS_ADMIN )
	adminmode:help( "Toggles admin mode" )*/

	/*function ulx.requestntf( ply, silent )
		SpawnNTFS()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A spawned support units" )
		else
			ulx.fancyLogAdmin( ply, "#A spawned support units" )
		end
	end

	local requestntf = ulx.command( ULX_CAT, "ulx request_ntf", ulx.requestntf, "!ntf" )
	requestntf:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	requestntf:setOpposite( "ulx silent request_ntf", { nil, true }, "!sntf" )
	requestntf:defaultAccess( ULib.ACCESS_SUPERADMIN )
	requestntf:help( "Spawns support units" )*/

	function ulx.destroygatea( ply, silent )
		ExplodeGateA()

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A triggered Gate A destroy" )
		else
			ulx.fancyLogAdmin( ply, "#A triggered Gate A destroy" )
		end
	end

	local destroygatea = ulx.command( ULX_CAT, "ulx destroy_gate_a", ulx.destroygatea, "!destroygatea" )
	destroygatea:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	destroygatea:setOpposite( "ulx silent destroy_gate_a", { nil, true }, "!sdestroygatea" )
	destroygatea:defaultAccess( ULib.ACCESS_ADMIN )
	destroygatea:help( "Destroys Gate A" )

	function ulx.restartround( ply, silent )
		RestartRound()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A restarted round" )
		else
			ulx.fancyLogAdmin( ply, "#A restarted round" )
		end
	end

	local restartround = ulx.command( ULX_CAT, "ulx restart_round", ulx.restartround, "!restart" )
	restartround:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	restartround:setOpposite( "ulx silent restart_round", { nil, true }, "!srestart" )
	restartround:defaultAccess( ULib.ACCESS_SUPERADMIN )
	restartround:help( "Restarts round" )

	function ulx.spawnchip( ply, chip, silent )
		chip = tostring( chip )

		local ent = CreateChip( chip )
		if IsValid( ent ) then
			ent:SetPos( ply:GetEyeTrace().HitPos )
			ent:Spawn()

			if silent then
				ulx.fancyLogAdmin( ply, true, "#A spawned '"..chip.."' chip" )
			else
				ulx.fancyLogAdmin( ply, "#A spawned '"..chip.."' chip" )
			end
		else
			ULib.tsayError( plyc, "Unknown chip name '"..chip.."'!", true )
		end
	end

	local spawnchip = ulx.command( ULX_CAT, "ulx spawn_chip", ulx.spawnchip, "!chip" )
	spawnchip:addParam{ type = ULib.cmds.StringArg, hint = "Chip name", completes = ACC_REGISTRY.CHIPS_ID }
	spawnchip:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	spawnchip:setOpposite( "ulx silent spawn_chip", { nil, nil, true } )
	spawnchip:defaultAccess( ULib.ACCESS_SUPERADMIN )
	spawnchip:help( "Spawns chip" )

	local function rem_info( ply, target, type, silent )
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A removed #T data: "..type, target )
		else
			ulx.fancyLogAdmin( ply, "#A removed #T data: "..type, target )
		end
	end

	function ulx.removedata( ply, target, atype, silent )
		if atype == "level" then
			target:Set_SCPLevel( 0 )
			target:SetSCPData( "level", 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "xp" then
			target:Set_SCPExp( 0 )
			target:SetSCPData( "xp", 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "prestige" then
			target:Set_SCPPrestige( 0 )
			target:SetSCPData( "prestige", 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "prestige_points" then
			target:Set_SCPPrestigePoints( 0 )
			target:SetSCPData( "prestige_points", 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "owned_classes" then
			target.PlayerInfo:Set( "unlocked_classes", {} )

			rem_info( ply, target, atype, silent )
		elseif atype == "all" then
			target:Set_SCPLevel( 0 )
			target:SetSCPData( "level", 0 )
			target:Set_SCPExp( 0 )
			target:SetSCPData( "xp", 0 )
			target:Set_SCPPrestige( 0 )
			target:SetSCPData( "prestige", 0 )
			target:Set_SCPPrestigePoints( 0 )
			target:SetSCPData( "prestige_points", 0 )
			target.PlayerInfo:Set( "unlocked_classes", {} )

			rem_info( ply, target, atype, silent )
		else
			ULib.tsayError( plyc, "Unknown type '"..atype.."'!", true )
		end
	end

	local removedata = ulx.command( ULX_CAT, "ulx remove_data", ulx.removedata )
	removedata:addParam{ type = ULib.cmds.PlayerArg, hint = "Target" }
	removedata:addParam{ type = ULib.cmds.StringArg, hint = "Type", completes = { "level", "xp", "prestige", "prestige_points", "owned_classes", "all" } }
	removedata:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	removedata:setOpposite( "ulx silent remove_data", { nil, nil, true } )
	removedata:defaultAccess( ULib.ACCESS_SUPERADMIN )
	removedata:help( "Removes player data" )
end

function SetupForceSCP()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end
	
	function ulx.forcescp( plyc, plyt, scp, silent )
		if !scp then return end

		if !plyt:GetActive() then
			ULib.tsayError( plyc, "Player "..plyt:GetName().." is inactive! Force spawn failed", true )
			return
		end

		local scp_obj = GetSCP( scp )
		if scp_obj then
			scp_obj:SetupPlayer( plyt, true )

			if silent then
				ulx.fancyLogAdmin( plyc, true, "#A force spawned #T as "..scp, plyt )
			else
				ulx.fancyLogAdmin( plyc, "#A force spawned #T as "..scp, plyt )
			end
		else
			ULib.tsayError( plyc, "Invalid SCP "..scp.."!", true )
		end
	end

	local forcescp = ulx.command( ULX_CAT, "ulx force_scp", ulx.forcescp, "!forcescp" )
	forcescp:addParam{ type = ULib.cmds.PlayerArg }
	forcescp:addParam{ type = ULib.cmds.StringArg, hint = "SCP name", completes = SCPS, ULib.cmds.takeRestOfLine }
	forcescp:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcescp:setOpposite( "ulx silent force_scp", { nil, nil, nil, true }, "!sforcescp" )
	forcescp:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcescp:help( "Sets player to specific SCP and spawns him" )
end

timer.Simple( 0, function()
	InitializeSCPULX()
	SetupForceSCP()

	hook.Run( "UCLChanged" )
end )