local ULX_CAT = "Admin SCP"

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
			ULib.tsayError( plyc, "Player "..v:Nick().." is inactive! Force spawn failed", true )
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

		plyt:SetupPlayer( class )
		plyt:SetPos( table.Random( spawn ) )

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
	forcespawn:setOpposite( "ulx silent force_spawn", { _, _, _, true }, "!sforcespawn" )
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
	slcxp:setOpposite( "ulx silent xp", { _, _, _, true }, "!sxp" )
	slcxp:defaultAccess( ULib.ACCESS_SUPERADMIN )
	slcxp:help( "Gives XP to specified player" )

	function ulx.level( ply, plyt, lvl, silent )
		if !isnumber( lvl ) then return end

		plyt:AddLevel( lvl )

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A gave #T "..lvl.." level(s)", plyt )
		else
			ulx.fancyLogAdmin( ply, "#A gave #T "..lvl.." level(s)", plyt )
		end
	end

	local level = ulx.command( ULX_CAT, "ulx level", ulx.level, "!level" )
	level:addParam{ type = ULib.cmds.PlayerArg }
	level:addParam{ type = ULib.cmds.NumArg, hint = "Level" }
	level:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	level:setOpposite( "ulx silent level", { _, _, _, true }, "!slevel" )
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
	adminmode:setOpposite( "ulx silent admin_mode", { _, true }, "!sadminmode" )
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
	requestntf:setOpposite( "ulx silent request_ntf", { _, true }, "!sntf" )
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
	destroygatea:setOpposite( "ulx silent destroy_gate_a", { _, true }, "!sdestroygatea" )
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
	restartround:setOpposite( "ulx silent restart_round", { _, true }, "!srestart" )
	restartround:defaultAccess( ULib.ACCESS_SUPERADMIN )
	restartround:help( "Restarts round" )
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
			scp_obj:SetupPlayer( plyt )

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
	forcescp:setOpposite( "ulx silent force_scp", { _, _, _, true }, "!sforcescp" )
	forcescp:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcescp:help( "Sets player to specific SCP and spawns him" )
end

timer.Simple( 0, function()
	InitializeSCPULX()
	SetupForceSCP()

	hook.Run( "UCLChanged" )
end )