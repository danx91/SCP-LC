if !ulx or !ULib then 
	print( "# > ULX or ULib not found" )
	return
end

local ULX_CAT = " SCP: Lost Control"

/*if SERVER then
	/*ULib.ucl.registerAccess( "slc spectatescp", ULib.ACCESS_OPERATOR, "Allows player to bypass anti-ghosting system and let them spectate SCPs", ULX_CAT )
	ULib.ucl.registerAccess( "slc spectateinfo", ULib.ACCESS_OPERATOR, "Allows player to details about player they are currently spectating", ULX_CAT )
	ULib.ucl.registerAccess( "slc skipintro", ULib.ACCESS_OPERATOR, "Allows player to skip info screen at the start of the round", ULX_CAT )
	ULib.ucl.registerAccess( "slc afkdontkick", ULib.ACCESS_ADMIN, "Don't kick players with this access if they are AFK", ULX_CAT )*/

	/*hook.Add( "SLCCanSpectateSCP", "SLCBaseULX", function( ply )
		if ULib.ucl.query( ply, "slc spectatescp" ) then
			return true
		end
	end )
end*/

SLCAuth.AddLibrary( "ulx", "ULX", {
	CheckAccess = function( ply, access )
		return ULib.ucl.query( ply, access )
	end,
	RegisterAccess = function( name, help )
		if CLIENT then return end

		ULib.ucl.registerAccess( name, ULib.ACCESS_ADMIN, help, ULX_CAT )
	end,
} )

function InitializeSCPULX()
	local class_names = {}
	local support_groups = { "random" }
	for group_name, group in pairs( GetClassGroups() ) do
		if group_name != "SUPPORT" then
			for k, class in pairs( group ) do
				table.insert( class_names, k )
			end
		else
			for sup_name, sup_group in pairs( group ) do
				table.insert( support_groups, sup_name )

				for k, class in pairs( sup_group ) do
					table.insert( class_names, k )
				end
			end
		end
	end

	function ulx.forcespawn( ply, plyt, class_n, silent )
		if !class_n or !ROUND.active then
			ULib.tsayError( ply, "Round is not active!", true )
			return
		end
		
		if !plyt:IsActive() then
			ULib.tsayError( ply, "Player "..plyt:Nick().." is inactive! Force spawn failed", true )
			return
		end

		local class, spawn
		local issupport = false

		for group_name, group in pairs( GetClassGroups() ) do
			if group_name != "SUPPORT" then
				local _, grspwn = GetClassGroup( group_name )
				for k, c in pairs( group ) do
					if k == class_n then
						class = c
						spawn = grspwn
						break
					end
				end
			else
				for sup_group_name, sup_group in pairs( group ) do
					local _, grspwn = GetSupportGroup( sup_group_name )
					for k, c in pairs( sup_group ) do
						if k == class_n then
							class = c
							spawn = grspwn
							issupport = true
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

		local pos = class.spawn or table.Random( spawn )

		if isstring( pos ) then
			local _

			if issupport then
				_, pos = GetSupportGroup( pos )
			else
				_, pos = GetClassGroup( pos )
			end

			if !pos then
				return
			end
		end

		while istable( pos ) do
			pos = pos[SLCRandom( #pos )]
		end

		plyt:SetupPlayer( class, pos, true )

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A force spawned #T as #s", plyt, class.name )
		else
			ulx.fancyLogAdmin( ply, "#A force spawned #T as #s", plyt, class.name )
		end
	end

	local forcespawn = ulx.command( ULX_CAT, "ulx force_spawn", ulx.forcespawn, "!forcespawn" )
	forcespawn:addParam{ type = ULib.cmds.PlayerArg }
	forcespawn:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn:setOpposite( "ulx silent force_spawn", { nil, nil, nil, true }, "!sforcespawn" )
	forcespawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn:help( "Sets player to specific class and spawns him" )

	function ulx.spawnsupport( ply, name, silent )
		if SpawnSupport( name ) then
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A spawned support #s", name )
			else
				ulx.fancyLogAdmin( ply, "#A spawned support #s", name )
			end
		else
			ULib.tsayError( ply, "Failed to spawn support '"..name.."'!", true )
		end
	end

	local spawnsupport = ulx.command( ULX_CAT, "ulx spawn_support", ulx.spawnsupport, "!spawnsupport" )
	spawnsupport:addParam{ type = ULib.cmds.StringArg, hint = "Support name (or random)", completes = support_groups }
	spawnsupport:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	spawnsupport:setOpposite( "ulx silent spawn_support", { nil, nil, true } )
	spawnsupport:defaultAccess( ULib.ACCESS_SUPERADMIN )
	spawnsupport:help( "Spawns support" )

	function ulx.slcxp( ply, plyt, xp, silent )
		if !isnumber( xp ) then return end

		plyt:AddXP( xp, "cmd" )

		if silent then
			ulx.fancyLogAdmin( ply, true, "#A gave #T #i experience", plyt, xp )
		else
			ulx.fancyLogAdmin( ply, "#A gave #T #i experience", plyt, xp )
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
			ulx.fancyLogAdmin( ply, true, "#A gave #T #i level(s)", plyt, lvl )
		else
			ulx.fancyLogAdmin( ply, "#A gave #T #i level(s)", plyt, lvl )
		end
	end

	local level = ulx.command( ULX_CAT, "ulx level", ulx.level, "!level" )
	level:addParam{ type = ULib.cmds.PlayersArg }
	level:addParam{ type = ULib.cmds.NumArg, hint = "Level" }
	level:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	level:setOpposite( "ulx silent level", { nil, nil, nil, true }, "!slevel" )
	level:defaultAccess( ULib.ACCESS_SUPERADMIN )
	level:help( "Gives level to specified player" )

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
				ulx.fancyLogAdmin( ply, true, "#A spawned #s chip", chip )
			else
				ulx.fancyLogAdmin( ply, "#A spawned #s chip", chip )
			end
		else
			ULib.tsayError( ply, "Unknown chip name '"..chip.."'!", true )
		end
	end

	local spawnchip = ulx.command( ULX_CAT, "ulx spawn_chip", ulx.spawnchip, "!chip" )
	spawnchip:addParam{ type = ULib.cmds.StringArg, hint = "Chip name", completes = ACC_REGISTRY.CHIPS_ID }
	spawnchip:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	spawnchip:setOpposite( "ulx silent spawn_chip", { nil, nil, true } )
	spawnchip:defaultAccess( ULib.ACCESS_SUPERADMIN )
	spawnchip:help( "Spawns chip" )

	function ulx.setafk( ply, target )
		target:MakeAFK()
		ulx.fancyLogAdmin( ply, "#A marked #T as AFK", target )
	end

	local setafk = ulx.command( ULX_CAT, "ulx set_afk", ulx.setafk, "!setafk" )
	setafk:addParam{ type = ULib.cmds.PlayerArg, hint = "Target" }
	setafk:defaultAccess( ULib.ACCESS_OPERATOR )
	setafk:help( "Marks player as AFK" )

	local function rem_info( ply, target, type, silent )
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A removed #T data: #s", target, type )
		else
			ulx.fancyLogAdmin( ply, "#A removed #T data: #s", target, type )
		end
	end

	function ulx.removedata( ply, target, atype, silent )
		if atype == "level" then
			target:SetPlayerLevel( 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "xp" then
			target:SetPlayerXP( 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "class_points" then
			target:SetClassPoints( 0 )

			rem_info( ply, target, atype, silent )
		elseif atype == "prestige" then
			target:SetPrestigeLevel( 0 )
			target:SetPrestigePoints( 0 )
			target.PlayerInfo:Set( "prestige_classes", {} )

			rem_info( ply, target, atype, silent )
		elseif atype == "owned_classes" then
			target.PlayerInfo:Set( "unlocked_classes", {} )

			rem_info( ply, target, atype, silent )
		elseif atype == "all" then
			target:SetPlayerLevel( 0 )
			target:SetPlayerXP( 0 )
			target:SetClassPoints( 0 )
			target.PlayerInfo:Set( "unlocked_classes", {} )
			target:SetPrestigeLevel( 0 )
			target:SetPrestigePoints( 0 )
			target.PlayerInfo:Set( "prestige_classes", {} )

			rem_info( ply, target, atype, silent )
		else
			ULib.tsayError( ply, "Unknown type '"..tostring( atype ).."'!", true )
		end
	end

	local removedata = ulx.command( ULX_CAT, "ulx remove_data", ulx.removedata )
	removedata:addParam{ type = ULib.cmds.PlayerArg, hint = "Target" }
	removedata:addParam{ type = ULib.cmds.StringArg, hint = "Type", completes = { "level", "xp", "class_points", "prestige", "owned_classes", "all" } }
	removedata:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	removedata:setOpposite( "ulx silent remove_data", { nil, nil, nil, true } )
	removedata:defaultAccess( ULib.ACCESS_SUPERADMIN )
	removedata:help( "Removes player data" )

	function ulx.punish( ply, target )
		if !target:Alive() then return end

		target:SetFrags( 0 )

		target:ForceSuicideQueue()
		target:Kill()

		ulx.fancyLogAdmin( ply, "#A punished #T", target )
	end

	local punish = ulx.command( ULX_CAT, "ulx punish", ulx.punish, "!punish" )
	punish:addParam{ type = ULib.cmds.PlayerArg, hint = "Target" }
	punish:defaultAccess( ULib.ACCESS_ADMIN )
	punish:help( "Punish player" )

	function ulx.punishid( ply, id )
		local target
		if string.match( id, "^%d+$" ) then
			target = player.GetBySteamID64( id )
		else
			target = player.GetBySteamID( id )
		end

		if !IsValid( target ) or !target:Alive() then return end
		
		target:SetFrags( 0 )

		target:ForceSuicideQueue()
		target:Kill()

		ulx.fancyLogAdmin( ply, "#A punished #T", target )
	end

	local punishid = ulx.command( ULX_CAT, "ulx punishid", ulx.punishid, "!punishid" )
	punishid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
	punishid:defaultAccess( ULib.ACCESS_ADMIN )
	punishid:help( "Punish player (SteamID)" )

	function ulx.xslay( ply, target )
		if !target:Alive() then return end

		target:SkipNextSuicide()
		target:Kill()

		ulx.fancyLogAdmin( ply, "#A xslayed #T", target )
	end

	local xslay = ulx.command( ULX_CAT, "ulx xslay", ulx.xslay, "!xslay" )
	xslay:addParam{ type = ULib.cmds.PlayerArg, hint = "Target" }
	xslay:defaultAccess( ULib.ACCESS_ADMIN )
	xslay:help( "Slay player skipping low priority queue" )

	function ulx.spawnd( ply, target )
		if !ROUND.active then
			ULib.tsayError( ply, "Round is not active!", true )
			return
		end
		
		if !target:IsActive() then
			ULib.tsayError( ply, "Player "..target:Nick().." is inactive! Force spawn failed", true )
			return
		end

		if target:Alive() or !target:IsValidSpectator() then
			ULib.tsayError( ply, "Player "..target:Nick().." is already alive! Force spawn failed", true )
			return
		end

		target:SetupPlayer( GetClassData( CLASSES.CLASSD ), ply:GetPos(), true )
		ulx.fancyLogAdmin( ply, "#A spawned #T as Class D", target )
	end

	local spawnd = ulx.command( ULX_CAT, "ulx spawnd", ulx.spawnd, "!spawnd" )
	spawnd:addParam{ type = ULib.cmds.PlayerArg, hint = "Target" }
	spawnd:defaultAccess( ULib.ACCESS_ADMIN )
	spawnd:help( "Slay player skipping low priority queue" )
end

hook.Add( "SetupForceSCP", "ULXForceSCP", function()
	function ulx.forcescp( plyc, plyt, scp, silent )
		if !scp or !ROUND.active then
			ULib.tsayError( plyc, "Round is not active!", true )
			return
		end

		if !plyt:IsActive() then
			ULib.tsayError( plyc, "Player "..plyt:GetName().." is inactive! Force spawn failed", true )
			return
		end

		local scp_obj = GetSCP( scp )
		if scp_obj then
			scp_obj:SetupPlayer( plyt, true )

			if silent then
				ulx.fancyLogAdmin( plyc, true, "#A force spawned #T as #s", plyt, scp )
			else
				ulx.fancyLogAdmin( plyc, "#A force spawned #T as #s", plyt, scp )
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
end )

timer.Simple( 0, function()
	InitializeSCPULX()
	hook.Run( "SetupForceSCP" )

	hook.Run( "UCLChanged" )
end )