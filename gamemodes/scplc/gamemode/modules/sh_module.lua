// Shared file
GM.Name 	= "SCP: Lost Control"
GM.Author 	= "danx91 [ZGFueDkx]"
GM.Email 	= ""
GM.Website 	= "https://github.com/danx91/SCP-LC"

--[[-------------------------------------------------------------------------
Global values
---------------------------------------------------------------------------]]
DATE = "17/11/2025"
SIGNATURE = "b001101r2"
VERSION = SLCVersion().name

SCPS = {}
CLASSES = {}

--[[-------------------------------------------------------------------------
Particles
---------------------------------------------------------------------------]]
game.AddParticles( "particles/slc_particles.pcf" )

PrecacheParticleSystem( "scp_457_fire" )
PrecacheParticleSystem( "SLC_SCP009_Smoke" )

--[[-------------------------------------------------------------------------
Convars
---------------------------------------------------------------------------]]

local function cvar_checker( ... )
	local tab = {...}
	local patterns = {}

	for n = 1, #tab do
		local pattern = "^%d+"

		for i = 2, tab[n] do
			pattern = pattern..",%d+"
		end

		patterns[n] = pattern.."$"
	end

	return function( data )
		for i, v in ipairs( patterns ) do
			if string.match( data, v ) then
				return true
			end
		end

		return false
	end
end

//ROUND
SLCCVar( "slc_min_players", "round", 2, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Minimum number of players to start the round", 2, nil, tonumber )
SLCCVar( "slc_time_wait", { "round", "time" }, 15, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The delay between meeting players requirement and starting the round (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_preparing", { "round", "time" }, 60, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Preparing time of the round (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_round", { "round", "time" }, 1500, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Duration of the round (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_postround", { "round", "time" }, 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The delay between end of the round and start of the next one (seconds)", 1, nil, tonumber )
SLCCVar( "slc_lockdown_duration", { "round", "time" }, 180, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Duration of the facility lockdown (seconds)", -1, nil, tonumber )
SLCCVar( "slc_time_goc_device", { "round", "time" }, 90, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The time required to fully deploy GOC device (seconds)", -1, nil, tonumber )

//GENERAL
SLCCVar( "slc_time_explode", { "general", "time" }, 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Gate A explosion time (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_gate_fire", { "general", "time" }, 15, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Gate A fire time (seconds) - 0 to disable", 0, nil, tonumber )
SLCCVar( "slc_auto_destroy_gatea", { "general", "time" }, 300, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "How long before the end of the round, Gate A should automatically explode? (seconds). 0 to disable", 0, nil, tonumber )
SLCCVar( "slc_time_looting", { "general", "time" }, 1.5, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The time required to identify a single item while looting (seconds)", 0.1, nil, tonumber )
SLCCVar( "slc_time_swapping", { "general", "time" }, 1.5, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The time required to swap item from EQ to backpack and vice versa", 0, nil, tonumber )
SLCCVar( "slc_blink_delay", "general", 5, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The delay between eye blinks", 1, nil, tonumber )

//FEATURES
SLCCVar( "slc_door_unblocker", "feature", 1, { FCVAR_ARCHIVE }, "This feature will try to move away any potential items that may get stuck between doors. Set to 1 to enable", nil, nil, tonumber )
SLCCVar( "slc_disable_fuseboxes", "feature", 0, { FCVAR_ARCHIVE }, "If other than 0, completely disable fuse boxes. Fuses can still spawn, however they will be unusable" )
SLCCVar( "slc_intercom_cooldown", { "feature", "time" }, 180, { FCVAR_ARCHIVE }, "Intercom cooldown", 1, nil, tonumber )
SLCCVar( "slc_intercom_duration", { "feature", "time" }, 20, { FCVAR_ARCHIVE }, "Intercom duration", 1, nil, tonumber )
SLCCVar( "slc_door_destroy_time", { "feature", "time" }, 120, { FCVAR_ARCHIVE }, "For how long doors will remain destroyed (0 - permanent)", 1, nil, tonumber )
SLCCVar( "slc_door_repair_time", { "feature", "time" }, 10, { FCVAR_ARCHIVE }, "How long players have to look away to allow door repair", 0, nil, tonumber )
SLCCVar( "slc_sv_precache", { "feature" }, 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "EXPERIMENTAL! Enables server precache of models allowing clients to precache", nil, nil, tonumber )
SLCCVar( "slc_scp_logging", { "feature" }, 0, { FCVAR_ARCHIVE }, "EXPERIMENTAL! Enables SCP data logging", nil, nil, tonumber )
SLCCVar( "slc_scp_karma", { "feature" }, 1, { FCVAR_ARCHIVE }, "1 to enable karma", nil, nil, tonumber )
//SLCCVar( "slc_spawn_protection", { "general", "time" }, 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The duration of spawn protection of some classes, mostly support (seconds)", nil, nil, tonumber )

//PREMIUM
SLCCVar( "slc_premium_groups", "premium", "", { FCVAR_ARCHIVE }, "Comma separated group names of premium/VIP players" )
SLCCVar( "slc_premium_xp", { "premium", "xp" }, 2, { FCVAR_ARCHIVE }, "XP multiplier for premium players", 0, nil, tonumber )
SLCCVar( "slc_scp_premium_penalty", { "premium", "general", "scp" }, 2, { FCVAR_ARCHIVE }, "Same as slc_scp_penalty, but applies only to premium players", 0, nil, tonumber )

//SUPPORT
SLCCVar( "slc_support_amount", "support", "4,7,40", { FCVAR_ARCHIVE }, "The amount of players that will spawn as support in format: max OR min,max,pct -> min = minimum, max = maximum, pct = % of all players", 0, nil, cvar_checker( 3, 1 ) )
SLCCVar( "slc_support_minimum", "support", 2, { FCVAR_ARCHIVE }, "Minimum amount of players spawned in ANY support, support will not spawn if it can't fulfill this requirement", 1, nil, tonumber )
SLCCVar( "slc_support_spawnrate", { "support", "time" }, "240,300", { FCVAR_ARCHIVE }, "The time between support spawns (seconds). This can be either a single value or two comma separated values. If 2 values are used, time is selected at random between these values", nil, nil, cvar_checker( 2, 1 ) )
SLCCVar( "slc_alpha1_amount", { "support" }, 5, { FCVAR_ARCHIVE }, "Maximum amount of Alpha 1 support", 1, nil, tonumber )
SLCCVar( "slc_alpha1_time_goc", { "support" }, 90, { FCVAR_ARCHIVE }, "Time after apwning GOC before Alpha 1 is spawned", 1, nil, tonumber )

//DMG
//SLCCVar( "slc_scaledamage_human", "damage", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
//SLCCVar( "slc_scaledamage_scp", "damage", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

//XP
SLCCVar( "slc_xp_level", "xp", 7500, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "XP required to level up", 1, nil, tonumber )
SLCCVar( "slc_xp_increase", "xp", 1250, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Additional XP required to level up for each level", 0, nil, tonumber )
SLCCVar( "slc_points_xp", "xp", 50, { FCVAR_ARCHIVE }, "Number of XP that single point is worth", 0, nil, tonumber )
SLCCVar( "slc_xp_escape", "xp", "500,1750", { FCVAR_ARCHIVE }, "XP granted on escape. Accepted format: minimum,maximum", nil, nil, cvar_checker( 2 ) )
SLCCVar( "slc_xp_round", "xp", "100,150,200", { FCVAR_ARCHIVE }, "XP for playing on the server. First value for spectators, second for alive players, third for players that are alive after half of the round", nil, nil, cvar_checker( 3 ) )
SLCCVar( "slc_xp_win", "xp", "1500,1000", { FCVAR_ARCHIVE }, "XP granted to team that won the round. First value for alive players, second for dead ones.", nil, nil, cvar_checker( 2 ) )
SLCCVar( "slc_points_escort", "xp", 2, { FCVAR_ARCHIVE }, "Points granted for escorting players", 0, nil, tonumber )
SLCCVar( "slc_dailyxp_amount", "xp", 2500, { FCVAR_ARCHIVE }, "Amount of daily XP boost", 0, nil, tonumber )
SLCCVar( "slc_dailyxp_mul", "xp", 0.5, { FCVAR_ARCHIVE }, "Multiplier of daily XP boost", 0.1, nil, tonumber )
SLCCVar( "slc_dailyxp_time", "xp", 0, { FCVAR_ARCHIVE }, "Time offset for daily XP boost reset time", nil, nil, tonumber )
SLCCVar( "slc_xp_goc_device", "xp", 2000, { FCVAR_ARCHIVE }, "XP granted for successful GOC device placement", nil, nil, tonumber )

//WARHEADS
SLCCVar( "slc_time_alpha", { "warheads", "time" }, 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Explosion time of Alpha warhead (seconds)", 1, nil, tonumber )
SLCCVar( "slc_xp_alpha_escape", { "warheads", "xp" }, 500, { FCVAR_ARCHIVE }, "XP granted for escape during Alpha warhead countdown", 0, nil, tonumber )
SLCCVar( "slc_time_omega", { "warheads", "time" }, 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Explosion time of Omega warhead (seconds)", 1, nil, tonumber )
SLCCVar( "slc_xp_omega_shelter", { "warheads", "xp" }, 500, { FCVAR_ARCHIVE }, "XP granted for escape in blast shelter", 0, nil, tonumber )
SLCCVar( "slc_time_goc_warheads", { "warheads", "time" }, 120, { FCVAR_ARCHIVE }, "Explosion time of all warheads after placing GOC device (seconds)", 0, nil, tonumber )

//AFK
SLCCVar( "slc_afk_mode", "afk", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "0 - don't do anything, 1 - kick if server is full, >= 2 - kick after x seconds", 0, nil, tonumber )
SLCCVar( "slc_afk_autoslay", { "afk", "time" }, 45, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Time without any input required to slay alive player and flag them as AFK (seconds), 0 to disable", 0, nil, tonumber )
SLCCVar( "slc_afk_time", { "afk", "time" }, 120, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Time without any input required to flag player as AFK (seconds), 0 to disable AFK system", 0, nil, tonumber )

//SCP
SLCCVar( "slc_overload_time", { "scp", "time" }, 5, { FCVAR_ARCHIVE }, "The time required to overload door as SCP (seconds)", 1, nil, tonumber )
SLCCVar( "slc_overload_cooldown", { "scp", "time" }, 60, { FCVAR_ARCHIVE }, "SCP overload cooldown (seconds)", 0, nil, tonumber )
SLCCVar( "slc_overload_delay", { "scp", "time" }, 6, { FCVAR_ARCHIVE }, "The time after overload door will return to its original state (seconds), 0 - disable", 0, nil, tonumber )
SLCCVar( "slc_overload_door_cooldown", { "scp", "time" }, 60, { FCVAR_ARCHIVE }, "Door overload cooldown (seconds)", 0, nil, tonumber )
SLCCVar( "slc_overload_advanced_cooldown", { "scp", "time" }, 300, { FCVAR_ARCHIVE }, "Door advanced overload cooldown (seconds)", 0, nil, tonumber )
SLCCVar( "slc_scp_min_players", { "scp" }, 4, { FCVAR_ARCHIVE }, "Minimum number of players to spawn SCP", 1, nil, tonumber )
SLCCVar( "slc_players_per_scp", { "scp" }, 12, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "How many players are needed for next SCP - SCPs = ceil( total_players / this_number )", 5, nil, tonumber )
SLCCVar( "slc_scp_filter_last", { "scp" }, 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "If 1, SCPs from the previous round will not appear in the next round", nil, nil, tonumber )
SLCCVar( "slc_scp_chance_exponent", { "scp" }, 2, { FCVAR_ARCHIVE }, "Exponent of SCP selection chance. 0 to disable SCP chance system", 0, nil, tonumber )
SLCCVar( "slc_scp_penalty", { "general", "scp" }, 4, { FCVAR_ARCHIVE }, "The number of rounds of low SCP priority for players that just played as SCP", 0, nil, tonumber )
SLCCVar( "slc_allow_scp_spectate", { "general", "scp" }, 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "If 1, all players will be able to spectate SCPs", nil, nil, tonumber )
SLCCVar( "slc_689_min_players", { "scp" }, 1, { FCVAR_ARCHIVE }, "Minimum number of players for SCP-689 to spawn. 0 to disable this SCP", 0, nil, tonumber )
SLCCVar( "slc_scp_buff_pct_regen", { "scp" }, 0.4, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Outside buff one time heal % of SCP max HP", 0, 1, tonumber )
SLCCVar( "slc_scp_buff_max_regen", { "scp" }, 1000, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Outside buff one time heal HP cap", 0, nil, tonumber )

//GAS
SLCCVar( "slc_gas_lcz", { "gas" }, 450, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The time after which gas will be released in LCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_lcz_time", { "gas" }, 150, { FCVAR_ARCHIVE }, "How long it takes for gas to have its maximum power in LCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_hcz", { "gas" }, 750, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The time after which gas will be released in HCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_hcz_time", { "gas" }, 120, { FCVAR_ARCHIVE }, "How long it takes for gas to have its maximum power in HCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_ez", { "gas" }, 900, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The time after which gas will be released in EZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_ez_time", { "gas" }, 60, { FCVAR_ARCHIVE }, "How long it takes for gas to have its maximum power in EZ (seconds)", 0, nil, tonumber )

SLCCVar( "slc_gas_fast", { "gas" }, 0, { FCVAR_ARCHIVE }, "How many tokens are required to trigger fast decontamination. 0 to disable", 0, nil, tonumber )
SLCCVar( "slc_gas_fast_rate", { "gas" }, 5, { FCVAR_ARCHIVE }, "How many tokens are added per second if no player is present. Each player inside zone reduces this number by some amount", 1, nil, tonumber )
SLCCVar( "slc_gas_fast_alt", { "gas" }, 0, { FCVAR_ARCHIVE }, "Enables alternative mode. In alternative mode gas start time is reduced by number of tokens divided by slc_gas_fast", nil, nil, tonumber )

//MINIGAMES
SLCCVar( "slc_spectator_points_xp", { "minigames" }, 10, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "For each X xp player will get 1 spectator point. Calculation are rounded down and don't carry over!", 1, nil, tonumber )

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Update Handler
---------------------------------------------------------------------------]]
timer.Simple( 0, function()
	if !file.Exists( "slc", "DATA" ) then
		file.CreateDir( "slc" )
	end

	local saved = file.Read( "slc/version.dat" ) or "x"

	if saved != SIGNATURE then
		hook.Run( "SLCVersionChanged", SLCVersion( saved ), SLCVersion( SIGNATURE ) )
		file.Write( "slc/version.dat", SIGNATURE )
	end

	hook.Run( "SLCGamemodeLoaded" )
end )

--[[-------------------------------------------------------------------------
Shared GM functions
---------------------------------------------------------------------------]]
function GM:Initialize()
	self.BaseClass.Initialize( self )
end

function GM:PreGamemodeLoaded() --Remove unused expensive hooks
	hook.Remove( "PostDrawEffects", "RenderWidgets" )
    hook.Remove( "PlayerTick", "TickWidgets" )
	// hook.Remove( "RenderScene", "RenderStereoscopy" )
end

/*function GM:GetGameDescription()
	return self.Name
end*/

/*function GM:EntityFireBullets( ent, data )
	
end*/

--[[-------------------------------------------------------------------------
EntityEmitSound
---------------------------------------------------------------------------]]
local cheats = GetConVar( "sv_cheats" )
local timeScale = GetConVar( "host_timescale" )

function GM:EntityEmitSound( t )
	local p = t.Pitch
	
	if ( game.GetTimeScale() != 1 ) then
		p = p * game.GetTimeScale()
	end
	
	if ( timeScale:GetFloat() != 1 and cheats:GetBool() ) then
		p = p * timeScale:GetFloat()
	end
	
	if p != t.Pitch then
		t.Pitch = math.Clamp( p, 0, 255 )
		return true
	end
end

function GM:ShouldCollide( ent1, ent2 )
	return true
end

--[[-------------------------------------------------------------------------
Commands
---------------------------------------------------------------------------]]
slc_cmd.AddCommand( "slc_destroy_gatea", function( ply )
	if !SERVER or !IsValid( ply ) or !ply.ClassData or !ply.ClassData.support or ply:GetPos():DistToSqr( POS_EXPLODE_A ) > 62500 then return end 
	ExplodeGateA( ply )
end, 30 )

slc_cmd.AddCommand( "slc_escort", function( ply )
	if !SERVER or !IsValid( ply ) then return end 
	PlayerEscort( ply )
end, 10 )