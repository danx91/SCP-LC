local function levelsort( a, b )
	return a:SCPLevel() > b:SCPLevel()
end

function SetupPlayers( multi )
	local plys = GetActivePlayers()
	local all = #plys

	local scp = 0

	if all < 9 then
		scp = 1
	elseif all < 15 then
		scp = 2
	else
		scp = math.floor( ( all - 14 ) / 7 ) + 3
	end

	local penalty = CVAR.penalty:GetInt()
	local ppenalty = CVAR.p_penalty:GetInt()

	local scpply = {}

	for k, v in pairs( plys ) do
		local p = tonumber( v:GetSCPData( "scp_penalty", 0 ) )

		if p <= 0 then
			table.insert( scpply, v )
		else
			v:SetSCPData( "scp_penalty", p - 1 )
		end
	end

	local SCP = table.Copy( SCPS )
	local rscp = SCP[math.random( #SCP )]

	for i = 1, scp do
		if #SCP == 0 then --not enough SCPs
			break
		end

		if #scpply == 0 then
			scpply = plys
		end

		local ply = table.remove( scpply, math.random( #scpply ) )
		local obj = multi and GetSCP( rscp ) or GetSCP( table.remove( SCP, math.random( #SCP ) ) )

		table.RemoveByValue( plys, ply )
		ply:SetSCPData( "scp_penalty", ply:IsPremium() and ppenalty or penalty )

		print( "Assigning '"..ply:Nick().."' to class '"..obj.name.."' [SCP]" )
		obj:SetupPlayer( ply )

		all = all - 1
	end

	local tab = getPlayerTable( all )
	local groups = getGroups()
	local playertab = {}

	for k, ply in pairs( plys ) do
		playertab[ply] = {}

		local lvl = ply:SCPLevel()
		for g_name, group in pairs( groups ) do
			if g_name != "SUPPORT" then
				playertab[ply][g_name] = {}
				for c_name, class in pairs( group ) do
					local owned

					if class.override then
						local result = class.override( ply )

						if result then
							owned = true
						elseif result == false then
							owned = false
						end
					end

					if owned == nil then
						owned = lvl >= class.level
					end

					if owned then
						playertab[ply][g_name].any = true
						table.insert( playertab[ply][g_name], c_name )
					end
				end
			end
		end
	end

	for n, v in pairs( tab ) do
		if v[2] == 0 then continue end

		local g_name = v[1]
		local classplayers = {}

		local num = n == #tab and all or v[2]
		for i = 1, num do
			local index = math.random( #plys )
			local ply = plys[index]

			if playertab[ply][g_name].any then
				table.remove( plys, index )
				table.insert( classplayers, ply )
			end
		end

		table.sort( classplayers, levelsort )

		local classes, spawninfo = getClassGroup( g_name )
		local spawns = table.Copy( spawninfo )
		local inuse = {}

		local len = #classplayers
		local num = 0
		if len == 0 then
			print( "Failed to assign any player to group: "..g_name )
		else
			for i = 1, len do
				local ply = classplayers[i]
				local tab = playertab[ply][g_name]

				local class = nil

				repeat
					local rc = table.remove( tab, math.random( #tab ) )
					if !inuse[rc] then inuse[rc] = 0 end

					if classes[rc].max == 0 or inuse[rc] < classes[rc].max then
						inuse[rc] = inuse[rc] + 1
						class = classes[rc]
						break
					end
				until #tab == 0

				if !class then
					print( "Failed to assign '"..ply:Nick().."' to any class in group '"..g_name.."'." )
					table.insert( plys, ply )
				else
					if #spawns == 0 then
						spawns = table.Copy( spawninfo )
					end

					print( "Assigning '"..ply:Nick().." to class '"..class.name.."' ["..g_name.."]" )

					ply:SetupPlayer( class )

					--if class.spawn then
						--ply:SetPos( istable( class.spawn ) and table.Random( class.spawn ) or class.spawn )
					--else
						ply:SetPos( table.remove( spawns, math.random( #spawns ) ) )
					--end

					all = all - 1
				end
			end
		end
	end
end

function SpawnSupport()
	local plys = ROUND.queue
	if #plys == 0 then
		local tab = SCPTeams.getPlayersByTeam( TEAM_SPEC )

		if #tab == 0 then return end
		plys = tab
	end


	local group, callback = selectSupportGroup()
	local classes, spawninfo = getSupportGroup( group )
	local spawns = table.Copy( spawninfo )

	local num = 0
	local inuse = {}
	local max = CVAR.maxsupport:GetInt()

	repeat
		local ply

		repeat
			local p = table.remove( plys, 1 )

			if IsValid( p ) and !p:Alive() and p:SCPTeam() == TEAM_SPEC then
				ply = p
				break
			end
		until #plys == 0

		if !IsValid( ply ) then break end

		local plytab = {}

		for k, v in pairs( classes ) do
			if !inuse[k] then inuse[k] = 0 end
			if v.max == 0 or inuse[k] < v.max then
				local owned

				if v.override then
					local result = v.override( ply )

					if result then
						owned = true
					elseif result == false then
						owned = false
					end
				end

				if owned == nil then
					owned = ply:SCPLevel() >= v.level
				end

				if owned then
					table.insert( plytab, v )
				end
			end
		end

		if #plytab > 0 then
			if #spawns == 0 then
				spawns = table.Copy( spawninfo )
			end

			local class = table.Random( plytab )

			print( "Assigning '"..ply:Nick().."' to support class '"..class.name.."' ["..group.."]" )
			ply:SetupPlayer( class )
			ply:SetPos( table.remove( spawns, math.random( #spawns ) ) )

			inuse[class.name] = inuse[class.name] + 1
			num = num + 1
		end
	until num >= max

	if num > 0 then
		if callback then
			callback()
		end

		return true
	end
end

function CheckEscape()
	if ROUND.post then return end
	for k, v in pairs( player.GetAll() ) do
		if v:GetPos():DistToSqr( POS_ESCAPE ) <= 10000 and SCPTeams.canEscape( v:SCPTeam() ) then
			local t = GetTimer( "SLCRound" )

			if IsValid( t ) then
				local rtime = t:GetRemainingTime()
				local ttime = t:GetTime()

				local diff = math.floor( ttime - rtime )
				local time = rtime / ttime
				local min, max = string.match( CVAR.escapexp:GetString(), "^(%d+),(%d+)$" )
				local xp = 0

				min = tonumber( min )
				max = tonumber( max )

				if time < 0.2 then
					xp = min
				elseif time > 0.8 then
					xp = max
				else
					xp = math.Map( xp, 0.2, 0.8, min, max )
				end

				xp = math.floor( xp )

				CenterMessage( string.format( "escaped#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp ), v )

				v:AddXP( xp )

				v:Despawn()

				v:KillSilent()
				v:SetupSpectator()

				CheckRoundEnd()
			end
		end
	end
end

function PlayerEscort( ply )
	if ROUND.post then return end

	local team = ply:SCPTeam()
	local pos = _G["POS_ESCORT_"..SCPTeams.getName( team )] or POS_ESCORT
	if ply:GetPos():DistToSqr( pos ) > 62500 then return end

	local t = GetTimer( "SLCRound" )
	if IsValid( timer ) then
		local rtime = t:GetRemainingTime()
		local ttime = t:GetTime()

		local diff = math.floor( ttime - rtime )
		local time = rtime / ttime
		local min, max = string.match( CVAR.escapexp:GetString(), "^(%d+),(%d+)$" )
		local xp = 0

		min = tonumber( min )
		max = tonumber( max )

		if time < 0.2 then
			xp = min
		elseif time > 0.8 then
			xp = max
		else
			xp = math.Map( 0.2, 0.8, min, max )
		end

		xp = math.floor( xp * 1.5 )

		local plys = {}

		for k, v in pairs( player.GetAll() ) do
			if v:GetPos():DistToSqr( pos ) <= 62500 and SCPTeams.canEscort( team, v:SCPTeam() ) then
				table.insert( plys, v )
			end
		end

		if #plys == 0 then return end

		local msg = string.format( "escorted#255,0,0,SCPHUDVBig;escapeinfo$%s;escapexp$%d", string.ToMinutesSeconds( diff ), xp )
		for k, v in pairs( plys ) do
			CenterMessage( msg, v )

			v:AddXP( xp )

			v:Despawn()

			v:KillSilent()
			v:SetupSpectator()
		end

		local points = #plys * CVAR.escortpoints:GetInt()
		
		PlayerMessage( "escortpoints$"..points )
		ply:AddFrags( points )

		CheckRoundEnd()
	end
end

concommand.Add( "slc_escort", function( ply )
	if IsValid( ply ) and ( !ply.NEscort or ply.NEscort < CurTime() ) then
		ply.NEscort = CurTime() + 10
		PlayerEscort( ply )
	end
end )