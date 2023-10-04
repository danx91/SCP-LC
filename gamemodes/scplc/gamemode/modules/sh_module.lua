// Shared file
GM.Name 	= "SCP: Lost Control"
GM.Author 	= "danx91 [ZGFueDkx]"
GM.Email 	= ""
GM.Website 	= ""

--[[-------------------------------------------------------------------------
Global values
---------------------------------------------------------------------------]]
SIGNATURE = "b000900r0"
DATE = "04/10/2023"

SCPS = {}
CLASSES = {}

--[[-------------------------------------------------------------------------
Particles
---------------------------------------------------------------------------]]
game.AddParticles( "particles/slc_fire.pcf" )
game.AddParticles( "particles/slc_blood.pcf" )

PrecacheParticleSystem( "scp_457_fire" )
PrecacheParticleSystem( "SLCBloodSplash" )
PrecacheParticleSystem( "SLCPBSplash" )

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
SLCCVar( "slc_min_players", "round", 2, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Minimum number of players to start the round", 1, nil, tonumber )
SLCCVar( "slc_time_wait", { "round", "time" }, 15, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The delay between meeting players requirement and starting the round (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_preparing", { "round", "time" }, 60, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Preparing time of the round (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_round", { "round", "time" }, 1500, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Duration of the round (seconds)", 1, nil, tonumber )
SLCCVar( "slc_time_postround", { "round", "time" }, 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The delay between end of the round and start of the next one (seconds)", 1, nil, tonumber )
SLCCVar( "slc_lockdown_duration", { "round", "time" }, 180, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Duration of the facility lockdown (seconds)", -1, nil, tonumber )
SLCCVar( "slc_time_goc_device", { "round", "time" }, 90, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The time required to fully deploy GOC device (seconds)", -1, nil, tonumber )

//GENERAL
//SLCCVar( "slc_lcz_gas" )
SLCCVar( "slc_time_explode", { "general", "time" }, 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Gate A explosion time (seconds)", 1, nil, tonumber )
SLCCVar( "slc_auto_destroy_gatea", { "general", "time" }, 300, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "How long before the end of the round, Gate A should automatically explode? (seconds). 0 to disable", 0, nil, tonumber )
SLCCVar( "slc_time_looting", { "general", "time" }, 1.5, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The time required to identify a single item while looting (seconds)", 0.1, nil, tonumber )
SLCCVar( "slc_scp_penalty", { "general", "scp" }, 4, { FCVAR_ARCHIVE }, "The number of rounds of low SCP priority for players that just played as SCP", 0, nil, tonumber )
SLCCVar( "slc_blink_delay", "general", 5, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The delay between eye blinks", 1, nil, tonumber )
SLCCVar( "slc_allow_scp_spectate", "general", 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "If 1, all players will be able to spectate SCPs", nil, nil, tonumber )

//FEATURES
SLCCVar( "slc_scp914_kill", { "feature", "scp" }, 0, { FCVAR_ARCHIVE }, "If set to 1, SCP 914 will kill anyone inside its input and/or output", nil, nil, tonumber )
SLCCVar( "slc_door_unblocker", "feature", 1, { FCVAR_ARCHIVE }, "EXPERIMENTAL! This feature will try to move away any potential items that may get stuck between doors. Set to 1 to enable", nil, nil, tonumber )
SLCCVar( "slc_disable_fuseboxes", "feature", 0, { FCVAR_ARCHIVE }, "If other than 0, completely disable fuse boxes. Fuses can still spawn, however they will be unusable" )
//SLCCVar( "slc_spawn_protection", { "general", "time" }, 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The duration of spawn protection of some classes, mostly support (seconds)", nil, nil, tonumber )

//PREMIUM
SLCCVar( "slc_premium_groups", "premium", "", { FCVAR_ARCHIVE }, "Comma separated group names of premium/VIP players" )
SLCCVar( "slc_premium_xp", { "premium", "xp" }, 2, { FCVAR_ARCHIVE }, "XP multiplier for premium players", 0, nil, tonumber )
SLCCVar( "slc_scp_premium_penalty", { "premium", "general", "scp" }, 2, { FCVAR_ARCHIVE }, "Same as slc_scp_penalty, but applies only to premium players", 0, nil, tonumber )

//SUPPORT
SLCCVar( "slc_support_amount", "support", "4,7,40", { FCVAR_ARCHIVE }, "The amount of players that will spawn as support in format: max OR min,max,pct -> min = minimum, max = maximum, pct = % of all players", 0, nil, cvar_checker( 3, 1 ) )
SLCCVar( "slc_support_spawnrate", { "support", "time" }, "240,300", { FCVAR_ARCHIVE }, "The time between support spawns (seconds). This can be either a single value or two comma separated values. If 2 values are used, time is selected at random between these values", nil, nil, cvar_checker( 2, 1 ) )
SLCCVar( "slc_alpha1_amount", { "support" }, 5, { FCVAR_ARCHIVE }, "Maximum amount of Alpha 1 support", 1, nil, tonumber )

//DMG
//SLCCVar( "slc_scaledamage_human", "damage", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
//SLCCVar( "slc_scaledamage_scp", "damage", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

//XP
SLCCVar( "slc_xp_level", "xp", 7500, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "XP required to level up", 1, nil, tonumber )
SLCCVar( "slc_xp_increase", "xp", 1250, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Additional XP required to level up for each level", 0, nil, tonumber )
SLCCVar( "slc_points_xp", "xp", 50, { FCVAR_ARCHIVE }, "Number of XP that single point is worth", 0, nil, tonumber )
SLCCVar( "slc_xp_escape", "xp", "300,1500", { FCVAR_ARCHIVE }, "XP granted on escape. Accepted format: minimum,maximum", nil, nil, cvar_checker( 2 ) )
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

//GAS
SLCCVar( "slc_gas_lcz", { "gas" }, 450, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The time after which gas will be released in LCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_hcz", { "gas" }, 750, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The ime after which gas will be released in HCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_ez", { "gas" }, 900, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "The ime after which gas will be released in EZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_lcz_time", { "gas" }, 150, { FCVAR_ARCHIVE }, "How long it takes for gas to have its maximum power in LCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_hcz_time", { "gas" }, 120, { FCVAR_ARCHIVE }, "How long it takes for gas to have its maximum power in HCZ (seconds)", 0, nil, tonumber )
SLCCVar( "slc_gas_ez_time", { "gas" }, 60, { FCVAR_ARCHIVE }, "How long it takes for gas to have its maximum power in EZ (seconds)", 0, nil, tonumber )

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
local realms = {
	b = "BETA "
}

function SLCVersion( sig )
	sig = sig or SIGNATURE

	local realm, major, minor, patch, rev = string.match( sig, "^(%a)(%d%d)(%d%d)(%d%d)r(%d+)$" )
	major = tonumber( major )
	minor = tonumber( minor )
	patch = tonumber( patch )
	rev = tonumber( rev )

	//print( realm, major, minor, patch, rev )

	if !realm or !major or !minor or !patch or !rev then
		return {
			signature = sig,
			name = "Invalid Version",
			realm = "i",
			major = 0,
			minor = 0,
			patch = 0,
			rev = 0,
		}
	end

	local name = ""

	if realms[realm] then
		name = realms[realm].." "
	end

	name = name..major.."."..minor.."."..patch

	if rev > 0 then
		name = name.." rev. "..rev
	end

	return {
		signature = sig,
		name = name,
		realm = realm,
		major = major,
		minor = minor,
		patch = patch,
		rev = rev,
	}
end

VERSION = SLCVersion().name

--[[-------------------------------------------------------------------------
Update Handler
---------------------------------------------------------------------------]]
timer.Simple( 0, function()
	if !file.Exists( "slc", "DATA" ) then
		file.CreateDir( "slc" )
	end

	local cur = file.Read( "slc/version.dat" ) or "x"

	if cur != SIGNATURE then
		hook.Run( "SLCVersionChanged", SLCVersion( cur ), SLCVersion( SIGNATURE ) )
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
Damage related stuff
---------------------------------------------------------------------------]]
function GM:ScalePlayerDamage( ply, hitgroup, info )
	if hook.Run( "PlayerShouldTakeDamage", ply, info:GetAttacker() ) == false then return true end --TODO test??

	/*if !info:IsDamageType( DMG_DIRECT ) then --TODO disabled till all models have hitgroups
		if hitgroup == HITGROUP_HEAD then
			info:ScaleDamage( 2 )
		elseif hitgroup == HITGROUP_CHEST then
			info:ScaleDamage( 1 )
		elseif hitgroup == HITGROUP_STOMACH then
			info:ScaleDamage( 1 )
		elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			info:ScaleDamage( 0.75 )
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			info:ScaleDamage( 0.75 )
		end
	end*/
end

function GetSCPDamageScale( ply )
	local buff = ply:GetProperty( "scp_buff" )
	if buff then
		if ROUND.aftermatch then
			return 0.1
		end

		if ESCAPE_STATUS == ESCAPE_ACTIVE and ply:IsInEscape() then
			return 0.2
		end
	end

	if IsRoundLive() then
		local calc = math.Map( RemainingRoundTime(), 0, RoundDuration(), 0.5, 1.5 )
		if calc < 0.75 then
			calc = 0.75
		end

		if buff and ply:IsInZone( ZONE_SURFACE ) then
			calc = calc - 0.25
		end

		return calc
	end

	return 1
end

hook.Add( "SLCRound", "SCPSurfaceCheck", function( time )
	AddTimer( "SLCSurfaceCheck", 5, 0, function()
		local hp = IsRoundLive() and math.ceil( math.Map( RemainingRoundTime(), 0, RoundDuration(), 50, 0 ) ) or 0

		for i, v in ipairs( player.GetAll() ) do
			if v:SCPTeam() != TEAM_SCP or v:GetSCPHuman() then continue end

			local surf = v:IsInZone( ZONE_SURFACE )
			//v:SetProperty( "scp_on_surface", surf )

			if surf and hp > 0 and v:GetProperty( "scp_buff" ) then
				v:AddHealth( hp )
			end
		end
	end )
end )

hook.Add( "SCPUpgradeBought", "SCPOutsideBuff", function( ply, wep, upgrade )
	if upgrade.name == "outside_buff" then
		ply:SetProperty( "scp_buff", true, true )
	end
end )

--It's serverside only function, but lets leave it here, next to ScalePlayerDamage
local INVERSE_POISON = bit.bnot( DMG_POISON )
function GM:EntityTakeDamage( target, info )
	if PREVENT_BREAK then
		local cache = GetRoundProperty( "prevent_break_cache" )

		if !cache then
			cache = SetRoundProperty( "prevent_break_cache", {} )
		end

		if !cache then return end --round is not active

		if !cache[target] and !target.SkipSCPDamageCheck then
			local pos = target:GetPos()
			for k, v in pairs( PREVENT_BREAK ) do
				if v == pos then
					cache[target] = true
					break
				end

				target.SkipSCPDamageCheck = true
			end
		end

		if cache[target] then
			return true
		end
	end

	if target:IsPlayer() and hook.Run( "PlayerShouldTakeDamage", target, info:GetAttacker() ) == false then return true end --TODO test??

	local dmg_orig = info:GetDamage()

	if !info:IsDamageType( DMG_DIRECT ) then
		--scale convar?

		if target:IsPlayer() then
			local t_trg = target:SCPTeam()
			
			--vest
			local bleed_prot = false
			local vest = target:GetVest()
			if vest > 0 then
				local dur = target:GetVestDurability()
				local data = VEST.GetData( vest )

				if data and ( data.durability == -1 or dur > 0 ) then
					has_vest = true
					local pre_scaled = info:GetDamage()

					for k, v in pairs( data.damage ) do
						if info:IsDamageType( k ) then
							if k == DMG_BULLET or k == DMG_SLASH then
								bleed_prot = true
							end
							
							info:ScaleDamage( v )
						end
					end

					if dur > 0 then
						target:SetVestDurability( dur - math.Clamp( pre_scaled - info:GetDamage(), 0, dur ) )
					end
				end
			end

			local attacker = info:GetAttacker()
			if IsValid( attacker ) then
				if attacker:IsVehicle() then
					//info:SetDamage( 0 )
					return true
				elseif attacker:IsPlayer() then
					local t_att = attacker:SCPTeam()

					if attacker:InVehicle() then
						//info:SetDamage( 0 )
						return true
					end

					--nerf melee
					local wep = attacker:GetActiveWeapon()
					if IsValid( wep ) then
						local class = wep:GetClass()

						if class == "weapon_crowbar" then
							info:ScaleDamage( 0.5 )
						elseif class == "weapon_stunstick" then
							info:ScaleDamage( 0.5 )
						end
					end

					if target != attacker then
						if t_att == TEAM_SCP then
							if t_trg == TEAM_SCP then
								return true
							elseif !target:GetSCPHuman() then
								info:ScaleDamage( GetSCPDamageScale( target ) )
							end
						end

						AddRoundStat( "dmg", dmg_orig )

						if SCPTeams.IsAlly( t_att, t_trg ) then
							AddRoundStat( "rdmdmg", dmg_orig )
						end
					end
				end
			end

			if info:IsDamageType( DMG_RADIATION ) and target:HasEffect( "radiation" ) then
				info:ScaleDamage( 1.5 )
			end

			if info:IsDamageType( DMG_BULLET ) or info:IsDamageType( DMG_SLASH ) then
				if math.random( 1, 100 ) <= ( bleed_prot and 4 or 20 ) then
					target:ApplyEffect( "bleeding", attacker )
				end
			end

			local extra = target:GetExtraHealth()
			if extra > 0 then
				local pre = info:GetDamage()
				local dmg = pre - extra

				if dmg < 0 then
					dmg = 0
				end

				extra = extra - pre

				if extra <= 0 then
					extra = 0
					target:SetMaxExtraHealth( extra )
				end

				target:SetExtraHealth( extra )
				info:SetDamage( dmg )
				info:SetDamageCustom( pre )
			end
		end
	end

	if target:IsPlayer() then
		local dmg_type = info:GetDamageType()
		local dmg = info:GetDamage()
		local hp = target:Health()
		local attacker = info:GetAttacker()

		target.Logger:DamageTaken( dmg, attacker, { dmg_type = dmg_type, dmg_orig = dmg_orig, inflictor = info:GetInflictor(), hp = hp } )

		if IsValid( attacker ) and attacker:IsPlayer() then
			attacker.Logger:DamageDealt( dmg_orig, target, { dmg_type = dmg_type, dmg_final = dmg, hp = hp } )
		end
	end

	if !info:IsDamageType( DMG_DIRECT ) and hook.Run( "SLCPostScaleDamage", target, info ) == true then return true end

	local dmgtype = info:GetDamageType()
	if bit.band( dmgtype, DMG_POISON ) == DMG_POISON then
		info:SetDamageType( bit.bor( bit.band( dmgtype, INVERSE_POISON ), DMG_NERVEGAS ) )
	end
end

function GM:PostEntityTakeDamage( ent, dmg, took )
	if ent:IsPlayer() then
		if !ent.slc_dmg_ind then ent.slc_dmg_ind = {} end

		local att = dmg:GetInflictor()
		if IsValid( att ) then
			local owner = att:GetOwner()
			if IsValid( owner ) then
				att = owner
			end
		else
			att = dmg:GetAttacker()
		end

		if IsValid( att ) and att != ent and dmg:IsBulletDamage() then
			if !ent.slc_dmg_ind[att] and att:IsPlayer() then
				net.Start( "SLCHitMarker" )
				net.Send( att )
			end

			ent.slc_dmg_ind[att] = ( ent.slc_dmg_ind[att] or 0 ) + dmg:GetDamage()
		else
			net.Start( "SLCDamageIndicator" )
				net.WriteUInt( math.Clamp( math.ceil( dmg:GetDamage() ), 0, 1023 ), 10 )

				net.WriteFloat( 0 )
				net.WriteFloat( 0 )
			net.Send( ent )
		end
	end
end

hook.Add( "PlayerPostThink", "SLCDamageIndicator", function( ply )
	local tab = ply.slc_dmg_ind
	if !tab then return end

	for att, dmg in pairs( tab ) do
		tab[att] = nil

		net.Start( "SLCDamageIndicator" )
			net.WriteUInt( math.Clamp( math.ceil( dmg ), 0, 1023 ), 10 )

			local dir = att:GetPos() - ply:GetPos()
			net.WriteFloat( dir.x )
			net.WriteFloat( dir.y )
		net.Send( ply )
	end
end )

--[[-------------------------------------------------------------------------
Speed ajustment
Used fo continuous speed change, if you want to set speed once, conside using PushSpeed and PopSpeed instead!
---------------------------------------------------------------------------]]
/*


function GM:Move( ply, mv )
	local speed = mv:GetMaxSpeed() * 2
	mv:SetMaxSpeed( speed )
	mv:SetMaxClientSpeed( speed )
end*/

--[[-------------------------------------------------------------------------
Footsteps
For some reason when playerd move slower than some speed threshold (91 hu/s) thay make no step sounds at all
So, yea, I created new step sound system
---------------------------------------------------------------------------]]
STEPTYPE_NORMAL = 0
STEPTYPE_LADDER = 1
STEPTYPE_WATER = 2

function GM:PlayerFootstep( ply, pos, foot, sound, vol, filter )
	return true
end

function GM:FinishMove( ply, mv )
	local mvtype = ply:GetMoveType()
	if SERVER and ( ply:OnGround() and ( mvtype == MOVETYPE_WALK or mvtype == MOVETYPE_STEP ) or mvtype == MOVETYPE_LADDER ) then
		local vel = mv:GetVelocity()
		local len = vel:Length()

		if ply.slc_next_footstep then
			ply.slc_next_footstep = ply.slc_next_footstep - len * FrameTime()

			if ply.slc_next_footstep <= 0 then
				ply:PlayStepSound()
			end
		end

		if !ply.slc_next_footstep or ply.slc_next_footstep <= 0 then
			ply:UpdateStepTime()
		end
	end
end


function GM:SLCPlayerFootstep( ply, foot, snd )

end

function GM:SLCFootstepParams( ply, st, vel, crouch )
	if st == STEPTYPE_LADDER then
		return 100
	end

	local units = 50
	local len = vel:Length()

	if len > 125 then
		units = units + len / 10
	end

	if crouch then
		units = units - 15
	end

	if units < 25 then
		units = 25
	end

	return units
end

if !SLCStepSoundsAdded then
	SLCStepSoundsAdded = true

	for i, v in ipairs( sound.GetTable() ) do
		if !string.find( v, "StepLeft" ) and !string.find( v, "StepRight" ) then continue end

		local tab = sound.GetProperties( v )
		local orig = tab.name
		
		tab.name = orig.."Walk"
		tab.level = 70
		tab.volume = 0.7
		sound.Add( tab )

		tab.name = orig.."Crouch"
		tab.level = 65
		tab.volume = 0.4
		sound.Add( tab )
	end
end

--[[-------------------------------------------------------------------------
Fall Damage
---------------------------------------------------------------------------]]
local function calc_fall_threshold( ply )
	local vest = ply:GetVest()
	if vest > 0 then
		local data = VEST.GetData( vest )
		if data then
			return math.max( 300 / ( 1 + data.weight / 10 ), 75 )
		end
	end

	return 300
end

local function calc_fall_dmg( ply, speed )
	if speed <= 100 then
		return speed * 0.1
	elseif speed <= 200 then
		return speed * 0.15
	elseif speed <= 300 then
		return speed * 0.25
	else
		return speed * 0.5
	end
end

function GM:OnPlayerHitGround( ply, water, floater, speed )
	if CLIENT then return true end
	local override, threshold, damage = hook.Run( "SLCFallDamage", ply, water, floater, speed )

	if override then
		speed = override
	end

	threshold = threshold or calc_fall_threshold( ply )

	ply:PlayStepSound()

	if speed <= threshold then return true end
	
	if !water then
		if speed > 300 then
			local ang = math.min( speed - 300, 750 ) * 0.03
			ply:ViewPunch( Angle( 0, 0, ang ) )
		end

		local dmg_t = threshold + 150
		if damage or speed > dmg_t then
			local dmg = damage or calc_fall_dmg( ply, speed - dmg_t )
			if dmg > 0 then
				local info = DamageInfo()
				info:SetDamageType( DMG_FALL )

				if ply:HasEffect( "fracture" ) then
					info:SetDamage( dmg * 2.5 )
					ply:ApplyEffect( "bleeding", ply )
				else
					info:SetDamage( dmg )
				end

				if dmg > 25 then
					ply:ApplyEffect( "fracture" )
				end

				ply:TakeDamageInfo( info )
				ply:EmitSound( "Player.FallDamage", 100, 100, 1, CHAN_BODY )
			end
		end
	else
		ply:EmitSound( "Physics.WaterSplash" )
	end

	return true
end

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
	if !SERVER or !IsValid( ply ) then return end 
	if !ply.ClassData.support or ply:GetPos():DistToSqr( POS_EXPLODE_A ) > 62500 then return end

	ExplodeGateA( ply )
end, 30 )

slc_cmd.AddCommand( "slc_escort", function( ply )
	if !SERVER or !IsValid( ply ) then return end 
	PlayerEscort( ply )
end, 10 )