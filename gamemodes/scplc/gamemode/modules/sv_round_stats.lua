/*
data = {
	init = initial_value
	ref = num, func(return inportance 0-100; 0 most inportant), true(if changed), false(if not changed), nil(never transmit)
	importance = 0-100; 0 most impotant
	player_entry = playerstat name; use player stats
	NOT USED! - single_target = boolean; if player_entry is used: if true and multiple player has same score, this stat will be omited; if false, table will be passed; if nil, first player will be used
}
*/

--[[-------------------------------------------------------------------------
Round Stats
---------------------------------------------------------------------------]]
function RegisterRoundStat( name, data )
	ROUND.stats[name] = {
		value = data.init,
		init = data.init,
		numerical = isnumber( data.init ),
		ref = data.ref == data.init or data.ref,
		importance = math.Clamp( data.importance or 100, 0, 100 ),
		player_entry = data.player_entry,
		--single_target = data.single_target --NOT USED!
	}
end

function AddRoundStat( name, value )
	local stat = ROUND.stats[name]
	if !stat then return end

	value = value or 1

	if stat.numerical then
		if !isnumber( value ) then return end

		stat.value = stat.value + value
	end
end

function SetRoundStat( name, value )
	local stat = ROUND.stats[name]
	if !stat then return end

	if !value then
		stat.value = stat.init
		return
	end

	/*if stat.numerical then
		if isnumber( value ) then return end

		if stat.invert and value < stat.value or !stat.invert and value > stat.value then
			stat.value = value
		end 
	else*/
		stat.value = value
	//end
end

function GetRoundStat( name )
	local stat = ROUND.stats[name]
	if !stat then return end

	return stat.value
end

function ResetRoundStats()
	SCPTeams.resetScore()
	
	for k, v in pairs( ROUND.stats ) do
		v.value = v.init
	end
end

function GetRoundMVP()
	local max = 0
	local plys

	for k, v in pairs( player.GetAll() ) do
		local frags = v:Frags()
		if frags > max then
			plys = { v }
			max = frags
		elseif max > 0 and frags == max then
			table.insert( plys, v )
		end
	end

	if !plys then
		return false
	end

	local len = #plys
	
	if len == 1 then
		return plys[1], max
	end

	return false
end

function GetRoundSummary( stats )
	local tab = {}

	for k, v in pairs( ROUND.stats ) do
		local value = v.value

		if v.player_entry then
			if !PlayerStats._STATS[v.player_entry] then
				print( "Round stat '"..k.."' tried to use unknown player stat '"..tostring(v.player_entry).."'!" )
				continue
			end

			local lower = v.ref < v.init

			local best

			for k, v in pairs( player.GetAll() ) do
				if v.PlayerData then
					local stat = v.PlayerData:GetRoundStat( v.player_entry )

					if !best or lower and stat < best or !lower and stat > best then
						best = stat
					end
				end
			end

			if !best then
				continue
			end

			value = best
		end

		local imp = 100

		if v.ref == nil then
			continue
		elseif v.ref == false and value == v.init or v.ref == true and value != v.init then
			imp = v.importance
		elseif isfunction( v.ref ) then
			imp = v.ref( k, value )
		elseif v.numerical and isnumber( v.ref ) and isnumber( value ) then
			imp = math.Clamp( math.Map( value, v.init, v.ref, 100, 0 ), 0, 100 )
		else
			continue --sth else?
		end

		imp = imp * v.importance

		table.insert( tab, { k, value, imp } )
	end

	table.sort( tab, function( a, b ) return a[3] < b[3] end )

	local ret = {}
	local num = math.min( stats or 5, #tab )

	for i = 1, num do
		ret[i] = { tab[i][1], tab[i][2] }
	end

	return ret
end

--[[-------------------------------------------------------------------------
Base round stats
---------------------------------------------------------------------------]]
RegisterRoundStat( "kill", { init = 0, ref = 30, importance = 80 } )
RegisterRoundStat( "rdm", { init = 0, ref = 5, importance = 60 } )
RegisterRoundStat( "rdmdmg", { init = 0, ref = 750, importance = 50 } )
RegisterRoundStat( "dmg", { init = 0, ref = 5000, importance = 30 } )
RegisterRoundStat( "escapes", { init = 0, ref = 10, importance = 60 } )
RegisterRoundStat( "escorts", { init = 0, ref = 12, importance = 65 } )

RegisterRoundStat( "066", { init = 0, ref = 25, importance = 30 } )
RegisterRoundStat( "106", { init = 0, ref = 15, importance = 30 } )
RegisterRoundStat( "173", { init = 0, ref = 6, importance = 30 } )
RegisterRoundStat( "457", { init = 0, ref = 7, importance = 30 } )
RegisterRoundStat( "682", { init = 0, ref = 10, importance = 30 } )
RegisterRoundStat( "8602", { init = 0, ref = 6, importance = 30 } )
RegisterRoundStat( "939", { init = 0, ref = 20, importance = 30 } )

--Stats can be used as info about round because they will be reset on round restart, just don't transmit them
RegisterRoundStat( "gatea", { init = false } )
RegisterRoundStat( "106recontain", { init = false, ref = true, importance = 25 } )
RegisterRoundStat( "914use", { init = false } )