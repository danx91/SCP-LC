UTF8_CHARSET = "[\1-\127\194-\244][\128-\191]*"
UTF8_MAX3B_CHARSET = "[\1-\127\194-\239][\128-\191]*"
UTF8_4B_CHARSET = "[\240-\244][\128-\191]*"

timer.Simple( 0, function()
	net.AddTableChannel( "DeathInfo" )

	if CLIENT then
		net.ReceiveTable( "DeathInfo", function( data )
			DamageLogger.Print( data )
		end )
	end
end )

DamageLogger = {}

function DamageLogger:New( ply )
	local logger = setmetatable( {}, { __index = DamageLogger } )

	logger.New = function() end

	ply.Logger = logger
	logger.Player = ply

	logger.Dealt = 0
	logger.Taken = 0

	logger.DealtLog = {}
	logger.TakenLog = {}

	logger.DealtTargetLog = {}
	logger.TakenSourceLog = {}

	logger.Kills = {}

	logger.Last = {}
	logger.LastRound = {}

	return logger
end

function DamageLogger:DamageTaken( dmg, attacker, data )
	local ivp = IsValid( attacker ) and attacker:IsPlayer()
	local rdm = ivp and SCPTeams.IsAlly( attacker:SCPTeam(), self.Player:SCPTeam() )
	local enemy = ivp and SCPTeams.IsEnemy( attacker:SCPTeam(), self.Player:SCPTeam() )

	table.insert( self.TakenLog, { attacker = attacker, attackername = ivp and attacker:GetName() or "NULL", attackerid = ivp and attacker:SteamID64() or "NULL", damage = dmg, data = data, rdm = rdm } )

	if !self.TakenSourceLog[attacker] then
		self.TakenSourceLog[attacker] = { dmg = 0, orig = 0, nrdm = 0 }

		if ivp then
			self.TakenSourceLog[attacker].attackername = attacker:GetName()
			self.TakenSourceLog[attacker].attackerid = attacker:SteamID64()
		end
	end

	self.TakenSourceLog[attacker].dmg = self.TakenSourceLog[attacker].dmg + dmg
	self.TakenSourceLog[attacker].orig = self.TakenSourceLog[attacker].orig + data.dmg_orig

	if enemy then
		self.TakenSourceLog[attacker].nrdm = self.TakenSourceLog[attacker].nrdm + dmg
	end

	self.Taken = self.Taken + dmg
end

function DamageLogger:DamageDealt( dmg, target, data )
	local ivp = IsValid( target ) and target:IsPlayer()
	local rdm = ivp and SCPTeams.IsAlly( self.Player:SCPTeam(), target:SCPTeam() )
	local enemy = ivp and SCPTeams.IsEnemy( self.Player:SCPTeam(), target:SCPTeam() )

	table.insert( self.DealtLog, { target = target, targetname = ivp and target:GetName() or "NULL", targetid = ivp and target:SteamID64() or "NULL", damage = dmg, data = data, rdm = rdm } )

	if !self.DealtTargetLog[target] then
		self.DealtTargetLog[target] = { dmg = 0, final = 0, nrdm = 0 }

		if ivp then
			self.DealtTargetLog[target].targetname = target:GetName()
			self.DealtTargetLog[target].targetid = target:SteamID64()
		end
	end

	self.DealtTargetLog[target].dmg = self.DealtTargetLog[target].dmg + dmg
	self.DealtTargetLog[target].final = self.DealtTargetLog[target].final + data.dmg_final

	if enemy then
		self.DealtTargetLog[target].nrdm = self.DealtTargetLog[target].nrdm + data.dmg_final
	end

	self.Dealt = self.Dealt + dmg
end

function DamageLogger:AddKill( target )
	table.insert( self.DealtLog, { target = target, damage = 0, data = { kill = true } } )
	table.insert( self.Kills, target )
end

function DamageLogger:Dump( killer, inflictor )
	if ( !IsValid( inflictor ) or inflictor == killer ) and killer:IsPlayer() then
		inflictor = killer:GetActiveWeapon()
	end

	local data = {
		Killer = killer,
		Weapon = inflictor,
		Dealt = self.Dealt,
		Taken = self.Taken,
		DealtLog = self.DealtLog,
		TakenLog = self.TakenLog,
		//DealtTargetLog = self.DealtTargetLog,
		//TakenSourceLog = self.TakenSourceLog,
		DealtTargetLog = {},
		TakenSourceLog = {},
	}

	for k, v in pairs( self.DealtTargetLog ) do
		table.insert( data.DealtTargetLog, { k, v } )
	end

	for k, v in pairs( self.TakenSourceLog ) do
		table.insert( data.TakenSourceLog, { k, v } )
	end

	self.Last = data
	local deathid = table.insert( self.LastRound, data )

	self.Dealt = 0
	self.Taken = 0
	self.DealtLog = {}
	self.TakenLog = {}
	self.DealtTargetLog = {}
	self.TakenSourceLog = {}
	self.Kills = {}

	local len = #data.TakenLog
	local lastlogs = {}

	for i = 1, 10 do
		lastlogs[i] = data.TakenLog[len - i + 1]
	end

	if SERVER then
		/*net.Start( "DeathInfo" )
			net.WriteTable( {
				Killer = data.Killer,
				Weapon = data.Weapon,
				Taken = data.Taken,
				TakenLog = lastlogs,
				TakenSourceLog = data.TakenSourceLog,
			} )
		net.Send( self.Player )*/
		net.SendTable( "DeathInfo", {
				Killer = data.Killer,
				Weapon = data.Weapon,
				Taken = data.Taken,
				TakenLog = lastlogs,
				TakenSourceLog = data.TakenSourceLog,
			}, self.Player )
	end

	return deathid
end

function DamageLogger:GetCurrent()
	return self
end

function DamageLogger:GetByDeathID( deathid )
	if deathid > 0 then
		return self.LastRound[deathid]
	elseif deathid == -1 then
		return self.Last
	else
		return self
	end
end

local function assistsSort( a, b )
	return a[2] > b[2]
end

function DamageLogger:GetDeathDetails( deathid )
	local tab = {}

	if !deathid or deathid == -1 then
		deathid = #self.LastRound
	end

	if deathid > 0 then
		local log = self.LastRound[deathid]

		if log then
			tab.killer = log.Killer
			tab.weapon = log.Weapon

			/*local ivp = IsValid( log.Killer ) and log.Killer:IsPlayer()
			local t_att

			if ivp then
				t_att = log.Killer:SCPTeam()
			end*/

			local assists = {}

			local total = 0
			local kdmg = 0
			for k, v in pairs( log.TakenSourceLog ) do
				if IsValid( v[1] ) and v[1]:IsPlayer() then
					if v[1] != log.Killer then
						if v[2].nrdm > 0 then
							table.insert( assists, { v[1], v[2].nrdm } )
						end
					else
						kdmg = v[2].nrdm
					end

					total = total + v[2].nrdm
				end
			end

			local len = #assists

			if len > 0 then
				table.sort( assists, assistsSort )
				//table.insert( assists, 1, { log.killer, kdmg } )

				for i = 1, len do
					assists[i][2] = assists[i][2] / total
				end
			end

			tab.assists = assists
			tab.killer_pct = kdmg / total
		end

		return tab
	end
end

function DamageLogger:Reset( round )
	if round then
		self.LastRound = {}
	end

	self.Dealt = 0
	self.Taken = 0
	self.DealtLog = {}
	self.TakenLog = {}
	self.DealtTargetLog = {}
	self.TakenSourceLog = {}
	self.Kills = {}
end

function DamageLogger.Print( data )
	local killer = data.Killer and IsValid( data.Killer ) and data.Killer.GetName and data.Killer:GetName() or "Unknown"
	local n = "Killer: "..killer

	local tab = {}

	for k, v in pairs( data.TakenSourceLog ) do
		table.insert( tab, { attacker = v[1], dmg = v[2].dmg, orig = v[2].orig } )
	end

	table.sort( tab, function( a, b ) return a.dmg > b.dmg end )

	local tsl_num = #tab

	local t1 = StringTable( 3 + tsl_num, 4, { { 4 }, { 2, 0, 2 } } )
	t1:Insert( 1, 1, n, "<&" )

	t1:Insert( 1, 2, "TOTAL", "<>" )
	t1:Insert( 3, 2, string.format( "%.1f", data.Taken ), "<>" )

	t1:Insert( 1, 3, "ATT", "<>" )
	t1:Insert( 2, 3, "DMG", "<>" )
	t1:Insert( 3, 3, "ORIG", "<>" )
	t1:Insert( 4, 3, "DEF", "<>" )

	for i = 1, tsl_num do
		local info = tab[i]

		t1:Insert( 1, 3 + i, IsValid( info.attacker ) and info.attacker:GetNameEx( 24, UTF8_4B_CHARSET, "?" ) or "Unknown", "<&" )
		t1:Insert( 2, 3 + i, string.format( "%i", info.dmg ) )
		t1:Insert( 3, 3 + i, string.format( "%i", info.orig ) )
		t1:Insert( 4, 3 + i, string.format( "%i%%",  info.orig == 0 and 0 or ( 100 - info.dmg / info.orig * 100 ) ) )
	end

	t1:Print()

	print( "\n\n" )

	local tl_num = #data.TakenLog

	local t2 = StringTable( 2 + tl_num, 5, { { 5 } } )
	t2:Insert( 1, 1, "Recent Damage Events", "<>" )

	t2:Insert( 1, 2, "ATT", "<>" )
	t2:Insert( 2, 2, "DMG", "<>" )
	t2:Insert( 3, 2, "ORIG", "<>" )
	t2:Insert( 4, 2, "DEF", "<>" )
	t2:Insert( 5, 2, "HP", "<>" )

	for i = 1, tl_num do
		local info = data.TakenLog[i]
		local name = IsValid( info.attacker ) and info.attacker:GetNameEx( 24, UTF8_4B_CHARSET, "?" ) or "Unknown"

		t2:Insert( 1, 2 + i, string.gsub( name, "%%", "" ), "<&" )
		t2:Insert( 2, 2 + i, string.format( "%i", info.damage ) )
		t2:Insert( 3, 2 + i, string.format( "%i", info.data.dmg_orig ) )
		t2:Insert( 4, 2 + i, string.format( "%i%%",  info.data.dmg_orig == 0 and 0 or ( 100 - info.damage / info.data.dmg_orig * 100 ) ) )
		t2:Insert( 5, 2 + i, info.data.hp )
	end

	t2:Print()
end

setmetatable( DamageLogger, { __call = DamageLogger.New } )

/*net.Receive( "DeathInfo", function( len )
	local data = net.ReadTable()

	DamageLogger.Print( data )
end )*/

/*for k, v in pairs( player.GetAll() ) do
	DamageLogger( v )
end*/

--UTF8 Test Strings
-- local name = "abcdexyz äöüÄÖÜß âêîôû ąęźżńł 你好 ΛλΦφΨψΩω ІКЛМНѮѺПЧ 🔥🔥"
-- //local name = "$¢€𐍈"
-- print( string.gsub( name, UTF8_4B_CHARSET, "?" ) )