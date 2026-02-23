local path = "slc/scp_logger"

--[[-------------------------------------------------------------------------
SCPLogger
---------------------------------------------------------------------------]]
SCPLogger = {}

function SCPLogger:Init( ply )
	local wep = ply:GetSCPWeapon()
	local upg = SLC_SCP_UPGRADES[wep.UpgradeSystemName]

	self.Player = ply
	self.Data = {
		start_time = os.time(),
		finish_time = -1,
		start_class = ply:SCPClass(),
		finish_class = "N/A",
		start_swep_data = wep.DataDump and wep:DataDump() or {},
		finish_swep_data = "N/A",
		start_players = #GetActivePlayers(),
		finish_players = -1,
		upg_points_max = upg and upg.total_reward or -1,
		upg_points_total = 0,
		upg_points_left = -1,
		upg_last_point = -1,
		points_inside = 0,
		points_outside = 0,
		hack_norm = 0,
		hack_adv = 0,

		finish_type = "N/A",
		escape_num = -1,
		escape_hp = -1,
		death_src = "N/A",

		dealt_inside = 0,
		dealt_outside = 0,
		received_inside = 0,
		received_outside = 0,
		first_dealt = -1,
		first_received = -1,
		first_kill = -1,
		kills_inside = 0,
		kills_outside = 0,
		assists_inside = 0,
		assists_outside = 0,

		pathing = {},
		upgrades = {},
	}

	print( "[SCPLogger] Logger Started", ply )
end

function SCPLogger:Finish()
	if self.Finalized then return end

	local ply = self.Player
	local wep = ply:GetSCPWeapon()

	self.Data.finish_time = os.time()
	self.Data.finish_class = ply:SCPClass()
	self.Data.finish_swep_data = wep.DataDump and wep:DataDump() or {}
	self.Data.finish_players = #GetActivePlayers()

	if wep.UpgradeSystemMounted then
		local p_left, p_total = wep:GetUpgradePoints()
		self.Data.upg_points_total = p_total
		self.Data.upg_points_left = p_left
	end

	self.Finalized = true
end

function SCPLogger:Save()
	if !self.Finalized then
		self:Finish()
	end

	print( "[SCPLogger] Saving Logger", self.Player )
	
	local file_path
	local n = 0

	repeat
		n = n + 1
		if n > 5 then
			print( "[SCPLogger] Failed to get UUID name!" )
			PrintTable( self.Data )
			return
		end

		file_path = path.."/"..string.UUID()..".json"
	until !file.Exists( file_path, "DATA" )

	file.Write( file_path, util.TableToJSON( self.Data ) )
end

setmetatable( SCPLogger, {
	__call = function( _, ply )
		local tab = setmetatable( {}, { __index = SCPLogger } )

		tab:Init( ply )

		return tab
	end,
} )

--[[-------------------------------------------------------------------------
Logger Hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCSCPSetup", "SCPLogger", function( ply )
	if CVAR.slc_scp_logging:GetInt() != 1 then return end
	if ply.SCPLogger then return end

	ply.SCPLogger = SCPLogger( ply )
	ply._SkipNextSCPLoggerCleanup = false
end )

hook.Add( "SLCPlayerCleanup", "SCPLogger", function( ply )
	if ply._SkipNextSCPLoggerCleanup then
		ply._SkipNextSCPLoggerCleanup = false
		return
	end

	if ply.SCPLogger then
		ply.SCPLogger:Save()
		ply.SCPLogger = nil
	end

	local prop = ply:GetProperty( "stored_properties" )
	if prop and prop.scp_logger then
		prop.scp_logger:Save()
		prop.scp_logger = nil
	end
end )

hook.Add( "DoPlayerDeath", "SCPLogger", function( ply )
	if !ply.SCPLogger then return end

	ply.SCPLogger:Finish()

	ply:SetProperty( "scp_logger", ply.SCPLogger )
	ply.SCPLogger = nil
end )

hook.Add( "SLCPreround", "SCPLogger", function()
	if CVAR.slc_scp_logging:GetInt() != 1 then return end

	AddRoundHook( "SCPUpgradeBought", "SCPLogger", function( wep, upgrade )
		local ply = wep:GetOwner()
		if !ply.SCPLogger then return end

		table.insert( ply.SCPLogger.Data.upgrades, { upgrade.name, os.time() } )
	end )

	AddRoundHook( "SCPUpgradePoint", "SCPLogger", function( wep, points, last_reward, total_rewards )
		if last_reward < total_rewards then return end

		local ply = wep:GetOwner()
		if !ply.SCPLogger then return end

		ply.SCPLogger.Data.upg_last_point = os.time()
	end )

	AddRoundHook( "PostEntityTakeDamage", "SCPLogger", function( ply, dmg )
		local att = dmg:GetAttacker()
		if !IsValid( att ) or att == ply then return end

		if ply.SCPLogger then
			local data = ply.SCPLogger.Data

			if data.first_received == -1 then
				data.first_received = os.time()
			end

			if ply:IsInZone( ZONE_FLAG_SURFACE ) then
				data.received_outside = data.received_outside + dmg:GetDamage()
			else
				data.received_inside = data.received_inside + dmg:GetDamage()
			end
		end

		if att.SCPLogger then
			local data = att.SCPLogger.Data

			if data.first_dealt == -1 and att != ply then
				data.first_dealt = os.time()
			end

			if ply:IsInZone( ZONE_FLAG_SURFACE ) then
				data.dealt_outside = data.dealt_outside + dmg:GetDamage()
			else
				data.dealt_inside = data.dealt_inside + dmg:GetDamage()
			end
		end
	end )

	AddRoundHook( "SLCAddFrags", "SCPLogger", function( ply, frags )
		if !ply.SCPLogger then return end

		if ply:IsInZone( ZONE_FLAG_SURFACE ) then
			ply.SCPLogger.Data.points_outside = ply.SCPLogger.Data.points_outside + frags
		else
			ply.SCPLogger.Data.points_inside = ply.SCPLogger.Data.points_inside + frags
		end
	end )

	AddRoundHook( "SLCPlayerDeath", "SCPLogger", function( victim, attacker ) --Test escape/quit/suicide/kill
		local prop = victim:GetProperty( "stored_properties" )
		if prop and prop.scp_logger then
			prop.scp_logger.Data.finish_type = "death"

			local killinfo = victim.Logger:GetDeathDetails()
			prop.scp_logger.Data.death_src = killinfo and killinfo.weapon or "N/A"

			prop.scp_logger:Save()
			prop.scp_logger = nil
		end

		if !IsValid( attacker ) or victim == attacker or !attacker.SCPLogger then return end

		if attacker.SCPLogger.Data.first_kill == -1 then
			attacker.SCPLogger.Data.first_kill = os.time()
		end

		if attacker:IsInZone( ZONE_FLAG_SURFACE ) then
			attacker.SCPLogger.Data.kills_outside = attacker.SCPLogger.Data.kills_outside + 1
		else
			attacker.SCPLogger.Data.kills_inside = attacker.SCPLogger.Data.kills_inside + 1
		end
	end )

	AddRoundHook( "SLCKillAssist", "SCPLogger", function( ply, victim, pct, killer )
		if !ply.SCPLogger then return end

		if ply:IsInZone( ZONE_FLAG_SURFACE ) then
			ply.SCPLogger.Data.assists_outside = ply.SCPLogger.Data.assists_outside + 1
		else
			ply.SCPLogger.Data.assists_inside = ply.SCPLogger.Data.assists_inside + 1
		end
	end )

	AddRoundHook( "SLCButtonOverloaded", "SCPLogger", function( ply, ent, adv )
		if !ply.SCPLogger then return end

		if adv then
			ply.SCPLogger.Data.hack_adv = ply.SCPLogger.Data.hack_adv + 1
		else
			ply.SCPLogger.Data.hack_norm = ply.SCPLogger.Data.hack_norm + 1
		end
	end )

	AddRoundHook( "SLCPlayerEscaped", "SCPLogger", function( ply, alpha, escape_time, remaining_time, all_players )
		if !ply.SCPLogger then return end

		local data = ply.SCPLogger.Data
		data.finish_type = "escape"
		data.escape_num = #all_players
		data.escape_hp = ply:Health()
	end )
	
	AddTimer( "SCPLogger", 30, 0, function()
		for i, v in ipairs( player.GetAll() ) do
			if !v.SCPLogger then continue end

			local pos = v:GetPos()
			table.insert( v.SCPLogger.Data.pathing, { math.Round( pos.x ), math.Round( pos.y ), math.Round( pos.z ) } )
		end
	end )
end )

--[[-------------------------------------------------------------------------

---------------------------------------------------------------------------]]
if !file.IsDir( path, "DATA" ) then
	file.CreateDir( path )
end