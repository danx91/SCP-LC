UTF8_CHARSET = "[\1-\127\194-\244][\128-\191]*"
UTF8_MAX3B_CHARSET = "[\1-\127\194-\239][\128-\191]*"
UTF8_4B_CHARSET = "[\240-\244][\128-\191]*"

DamageLogger = {}

function DamageLogger:New( ply ) --TODO Test memory usage
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

	logger.Last = {}
	logger.LastRound = {}

	return logger
end

function DamageLogger:DamageTaken( dmg, attacker, data )
	table.insert( self.TakenLog, { attacker = attacker, damage = dmg, data = data } )

	if !self.TakenSourceLog[attacker] then
		self.TakenSourceLog[attacker] = { dmg = 0, orig = 0 }
	end

	self.TakenSourceLog[attacker].dmg = self.TakenSourceLog[attacker].dmg + dmg
	self.TakenSourceLog[attacker].orig = self.TakenSourceLog[attacker].orig + data.dmg_orig

	self.Taken = self.Taken + dmg
end

function DamageLogger:DamageDealt( dmg, target, data )
	table.insert( self.DealtLog, { target = target, damage = dmg, data = data } )

	if !self.DealtTargetLog[target] then
		self.DealtTargetLog[target] = { dmg = 0, final = 0 }
	end

	self.DealtTargetLog[target].dmg = self.DealtTargetLog[target].dmg + dmg
	self.DealtTargetLog[target].final = self.DealtTargetLog[target].final + data.dmg_final

	self.Dealt = self.Dealt + dmg
end

function DamageLogger:AddKill( target )
	table.insert( self.DealtLog, { target = target, damage = 0, data = { kill = true } } )
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
		DealtTargetLog = self.DealtTargetLog,
		TakenSourceLog = self.TakenSourceLog,
	}

	self.Last = data
	table.insert( self.LastRound, data )

	self.Dealt = 0
	self.Taken = 0
	self.DealtLog = {}
	self.TakenLog = {}
	self.DealtTargetLog = {}
	self.TakenSourceLog = {}

	local len = #data.TakenLog
	local lastlogs = {}

	for i = 1, 10 do
		lastlogs[i] = data.TakenLog[len - i + 1]
	end

	if SERVER then
		net.Start( "DeathInfo" )
			net.WriteTable( {
				Killer = data.Killer,
				Weapon = data.Weapon,
				Taken = data.Taken,
				TakenLog = lastlogs,
				TakenSourceLog = data.TakenSourceLog,
			} )
		net.Send( self.Player )
	end
end

function DamageLogger:Reset()
	self.LastRound = {}

	self.Dealt = 0
	self.Taken = 0
	self.DealtLog = {}
	self.TakenLog = {}
end

function DamageLogger.Print( data )
	local killer = data.Killer and IsValid( data.Killer ) and data.Killer:GetName() or "Unknown"
	local n = "Killer: "..killer

	local tab = {}

	for k, v in pairs( data.TakenSourceLog ) do
		table.insert( tab, { attacker = k, dmg = v.dmg, orig = v.orig } )
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
		t1:Insert( 4, 3 + i, string.format( "%i%%",  100 - info.dmg / info.orig * 100 ) )
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

		t2:Insert( 1, 2 + i, IsValid( info.attacker ) and info.attacker:GetNameEx( 24, UTF8_4B_CHARSET, "?" ) or "Unknown", "<&" )
		t2:Insert( 2, 2 + i, string.format( "%i", info.damage ) )
		t2:Insert( 3, 2 + i, string.format( "%i", info.data.dmg_orig ) )
		t2:Insert( 4, 2 + i, string.format( "%i%%",  100 - info.damage / info.data.dmg_orig * 100 ) )
		t2:Insert( 5, 2 + i, info.data.hp )
	end

	t2:Print()
end

-- timer.Simple( 0.1, function() DamageLogger.Print( { Killer = { GetName = function() return "Player1" end }, Taken = "356", TakenLog = {
-- 	{ attacker = { GetName = function() return "Player1" end }, damage = 10, data = { dmg_orig = 15, hp = 100 } },
-- 	{ attacker = { GetName = function() return "Player1" end }, damage = 20, data = { dmg_orig = 20, hp = 90 } },
-- 	{ attacker = { GetName = function() return "Player2" end }, damage = 15, data = { dmg_orig = 25, hp = 70 } },
-- 	{ attacker = { GetName = function() return "Player1" end }, damage = 20, data = { dmg_orig = 20, hp = 55 } },
-- 	{ attacker = { GetName = function() return "Player3" end }, damage = 17, data = { dmg_orig = 30, hp = 35 } },
-- 	{ attacker = { GetName = function() return "Player3" end }, damage = 17, data = { dmg_orig = 30, hp = 18 } },
-- 	{ attacker = { GetName = function() return "Player1" end }, damage = 10, data = { dmg_orig = 15, hp = 1 } },
-- } } ) end )

setmetatable( DamageLogger, { __call = DamageLogger.New } )

/*for k, v in pairs( player.GetAll() ) do
	DamageLogger( v )
end*/

--UTF8 Test Strings
-- local name = "abcdexyz äöüÄÖÜß âêîôû ąęźżńł 你好 ΛλΦφΨψΩω ІКЛМНѮѺПЧ 🔥🔥"
-- //local name = "$¢€𐍈"
-- print( string.gsub( name, UTF8_4B_CHARSET, "?" ) )