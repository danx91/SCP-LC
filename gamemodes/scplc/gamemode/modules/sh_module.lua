// Shared file
GM.Name 	= "SCP: Lost Control"
GM.Author 	= "danx91"
GM.Email 	= ""
GM.Website 	= ""

--[[-------------------------------------------------------------------------
Static values
---------------------------------------------------------------------------]]
SIGNATURE = "b000800"
VERSION = "BETA 0.8.0"
DATE = "04/08/2021"

SCPS = {}
CLASSES = {}

INFO_SCREEN_DURATION = 12

--[[-------------------------------------------------------------------------
Paericles
---------------------------------------------------------------------------]]
game.AddParticles( "particles/slc_fire.pcf" )
game.AddParticles( "particles/slc_blood.pcf" )

PrecacheParticleSystem( "scp_457_fire" )
PrecacheParticleSystem( "SLCBloodSplash" )
PrecacheParticleSystem( "SLCPBSplash" )

--[[-------------------------------------------------------------------------
Convars
---------------------------------------------------------------------------]]

local function cvar_checker( num )
	local pattern = "^%d+"

	for i = 2, num do
		pattern = pattern..",%d+"
	end

	pattern = pattern.."$"

	return function( data )
		return string.match( data, pattern )
	end
end

//ROUND
SLCCVar( "slc_min_players", "round", 2, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_time_wait", { "round", "time" }, 15, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_time_preparing", { "round", "time" }, 60, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_time_round", { "round", "time" }, 1500, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_time_postround", { "round", "time" }, 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )

//GENERAL
//SLCCVar( "slc_lcz_gas" )
SLCCVar( "slc_time_explode", { "general", "time" }, 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_scp_penalty", { "general", "scp" }, 4, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_blink_delay", "general", 5, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_scp914_kill", { "general", "scp" }, 0, { FCVAR_ARCHIVE }, nil, nil, nil, tonumber )
SLCCVar( "slc_enable_door_unblocker", "general", 1, { FCVAR_ARCHIVE }, nil, nil, nil, tonumber )
SLCCVar( "slc_allow_scp_spectate", "general", 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, nil, nil, tonumber )

//PREMIUM
SLCCVar( "slc_premium_groups", "premium", "", { FCVAR_ARCHIVE } )
SLCCVar( "slc_premium_xp", { "premium", "xp" }, 2, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_scp_premium_penalty", { "premium", "general", "scp" }, 2, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )

//SUPPORT
SLCCVar( "slc_support_amount", "support", 5, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_support_spawnrate", { "support", "time" }, "360,540", { FCVAR_ARCHIVE }, nil, nil, nil, cvar_checker( 2 ) )

//DMG
//SLCCVar( "slc_scaledamage_human", "damage", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
//SLCCVar( "slc_scaledamage_scp", "damage", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

//XP
SLCCVar( "slc_xp_level", "xp", 10000, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, nil, 1, nil, tonumber )
SLCCVar( "slc_xp_increase", "xp", 1000, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, nil, 0, nil, tonumber )
SLCCVar( "slc_points_xp", "xp", 50, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_xp_escape", "xp", "250,2000", { FCVAR_ARCHIVE }, nil, nil, nil, cvar_checker( 2 ) )
SLCCVar( "slc_xp_round", "xp", "100,200,300", { FCVAR_ARCHIVE }, nil, nil, nil, cvar_checker( 3 ) )
SLCCVar( "slc_xp_win", "xp", "1500,1000", { FCVAR_ARCHIVE }, nil, nil, nil, cvar_checker( 2 ) )
SLCCVar( "slc_points_escort", "xp", 4, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )

//WARHEADS
SLCCVar( "slc_time_alpha", { "warheads", "time" }, 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, nil, 1, nil, tonumber )
SLCCVar( "slc_xp_alpha_escape", { "warheads", "xp" }, 500, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_time_omega", { "warheads", "time" }, 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }, nil, 1, nil, tonumber )
SLCCVar( "slc_xp_omega_shelter", { "warheads", "xp" }, 500, { FCVAR_ARCHIVE }, nil, 0, nil, tonumber )

//AFK
SLCCVar( "slc_afk_mode", "afk", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "0 - don't do anything, 1 - kick if server is full, >= 2 - kick after x seconds", 0, nil, tonumber )
SLCCVar( "slc_afk_time", { "afk", "time" }, 120, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 0, nil, tonumber )

//SCP
SLCCVar( "slc_overload_time", { "scp", "time" }, 5, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 1, nil, tonumber )
SLCCVar( "slc_overload_cooldown", { "scp", "time" }, 90, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_overload_delay", { "scp", "time" }, 6, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 0, nil, tonumber )
SLCCVar( "slc_overload_door_cooldown", { "scp", "time" }, 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, nil, 0, nil, tonumber )

//CVAR = {
	//minplayers = CreateConVar( "slc_min_players", 2, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//pretime = CreateConVar( "slc_time_preparing", 60, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//roundtime = CreateConVar( "slc_time_round", 1500, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//posttime = CreateConVar( "slc_time_postround", 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//waittime = CreateConVar( "slc_time_wait", 15, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//blink = CreateConVar( "slc_blink_delay", 5, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//groups = CreateConVar( "slc_premium_groups", "", { FCVAR_ARCHIVE } ),
	//premiumxp = CreateConVar( "slc_premium_xp", 2, { FCVAR_ARCHIVE } ),
	//spawnrate = CreateConVar( "slc_support_spawnrate", "360,540", { FCVAR_ARCHIVE } ),
	//penalty = CreateConVar( "slc_scp_penalty", 4, { FCVAR_ARCHIVE } ),
	//p_penalty = CreateConVar( "slc_scp_premium_penalty", 2, { FCVAR_ARCHIVE } ),
	//maxsupport = CreateConVar( "slc_support_amount", 5, { FCVAR_ARCHIVE } ),
	//humanscale = CreateConVar( "slc_scaledamage_human", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//scpscale = CreateConVar( "slc_scaledamage_scp", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//explodetime = CreateConVar( "slc_time_explode", 30, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//levelxp = CreateConVar( "slc_xp_level", 10000, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//levelinc = CreateConVar( "slc_xp_increase", 1000, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//escapexp = CreateConVar( "slc_xp_escape", "250,2000", { FCVAR_ARCHIVE } ),
	//escortpoints = CreateConVar( "slc_points_escort", 4, { FCVAR_ARCHIVE } ),
	//pointsxp = CreateConVar( "slc_points_xp", 50, { FCVAR_ARCHIVE } ),
	//roundxp = CreateConVar( "slc_xp_round", "100,200,300", { FCVAR_ARCHIVE } ),
	//winxp = CreateConVar( "slc_xp_win", "1500,1000", { FCVAR_ARCHIVE } ),
	//scp914kill = CreateConVar( "slc_scp914_kill", 0, { FCVAR_ARCHIVE } ),
	//doorunblocker = CreateConVar( "slc_enable_door_unblocker", 1, { FCVAR_ARCHIVE } ),
	//spectatescp = CreateConVar( "slc_allow_scp_spectate", 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//omega_time = CreateConVar( "slc_time_omega", 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//omega_shelter_xp = CreateConVar( "slc_xp_omega_shelter", 500, { FCVAR_ARCHIVE } ),
	//alpha_time = CreateConVar( "slc_time_alpha", 150, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	//alpha_escape_xp = CreateConVar( "slc_xp_alpha_escape", 500, { FCVAR_ARCHIVE } ),
	//afk_mode = CreateConVar( "slc_afk_mode", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE }, "0 - don't do anything, 1 - kick if server is full, >= 2 - kick after x seconds" ),
	//afk_time = CreateConVar( "slc_afk_time", 120, { FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
//}

--[[-------------------------------------------------------------------------
Update Handler
---------------------------------------------------------------------------]]
timer.Simple( 0, function()
	if !file.Exists( "slc", "DATA" ) then
		file.CreateDir( "slc" )
	end

	local cur = file.Read( "slc/version.dat" ) or "x"

	if cur != SIGNATURE then
		hook.Run( "SLCVersionChanged", cur, SIGNATURE )
		file.Write( "slc/version.dat", SIGNATURE )
	end

	hook.Run( "SLCGamemodeLoaded" )
end )

/*hook.Add( "SLCVersionChanged", "VCBase", function( old, new )
	if SERVER and old == "x" then --Delete databases created before ALPHA 0.7 version
		MsgC( Color( 255, 50, 50 ), "WARNING! Database is outdated, deleting...\n" )
		sql.Query( "DROP TABLE scpplayerdata" )
	end
end )*/

--[[-------------------------------------------------------------------------
Shared GM hooks
---------------------------------------------------------------------------]]
function GM:Initialize()
	self.BaseClass.Initialize( self )
end

function GM:PreGamemodeLoaded()
	hook.Remove( "PostDrawEffects", "RenderWidgets" )
    hook.Remove( "PlayerTick", "TickWidgets" )
   // hook.Remove( "RenderScene", "RenderStereoscopy" )
end
/*function GM:EntityTakeDamage( target, dmginfo ) --TODO
	if target:IsPlayer() and target:HasWeapon( "item_scp_500" ) then
		if target:Health() <= dmginfo:GetDamage() then
			target:GetWeapon( "item_scp_500" ):OnUse()
			target:PrintMessage( HUD_PRINTTALK, "Using SCP 500" )
		end
	end
end*/

/*function GM:Move( ply, mv ) --TODO
	if ply:GTeam() == TEAM_SCP and OUTSIDE_BUFF( ply:GetPos() ) then
		local speed = 0.0025
		local ang = mv:GetMoveAngles()
		local vel = mv:GetVelocity()
		if vel.z == 0 then 
			vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
			vel = vel + ang:Right() * mv:GetSideSpeed() * speed
			vel.z = 0
		end

		mv:SetVelocity( vel )
	end
end*/

/*function GM:GetGameDescription()
	return self.Name
end*/

/*function GM:EntityFireBullets( ent, data )

end*/

function GM:ScalePlayerDamage( ply, hitgroup, info )
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

local function getSCPBuff()
	local t = GetTimer( "SLCRound" )

	if IsValid( t ) then
		local total = t:GetTime()
		local rem = t:GetRemainingTime()

		--print( total, rem )
	end
end

--It's serverside only function, but lets leave it here, next to ScalePlayerDamage
function GM:EntityTakeDamage( target, info )
	local dmg_type = info:GetDamageType()
	local dmg_orig = info:GetDamage()
	local hp = target:Health()

	if !info:IsDamageType( DMG_DIRECT ) then
		--scale convar?

		if target:IsPlayer() then
			local t_trg = target:SCPTeam()
			
			--vest
			local vest = target:GetVest()

			if vest > 0 then
				local data = VEST.GetData( vest )

				if data then
					for k, v in pairs( data.damage ) do
						if info:IsDamageType( k ) then
							info:ScaleDamage( v )
						end
					end
				end
			end

			--getSCPBuff()
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

						/*if class == "weapon_crowbar" then
							info:ScaleDamage( 0.3 )
						elseif class == "weapon_stunstick" then
							info:ScaleDamage( 0.5 )
						end*/
					end

					if target != attacker then
						if t_att == TEAM_SCP then
							if t_trg == TEAM_SCP then
								--info:SetDamage( 0 )
								return true
							else
								--TODO scp buffs
								local buff = getSCPBuff()
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
				info:ScaleDamage( 1.2 )
			end

			if info:IsDamageType( DMG_BULLET ) or info:IsDamageType( DMG_SLASH ) then
				if math.random( 1, 100 ) <= ( vest > 0 and 5 or 20 ) then
					target:ApplyEffect( "bleeding", attacker )
				end
			end
		end

		--SCP buff
	end

	if target:IsPlayer() then
		local attacker = info:GetAttacker()
		local dmg = info:GetDamage()

		target.Logger:DamageTaken( dmg, attacker, { dmg_type = dmg_type, dmg_orig = dmg_orig, inflictor = info:GetInflictor(), hp = hp } )

		if IsValid( attacker ) and attacker:IsPlayer() then
			attacker.Logger:DamageDealt( dmg_orig, target, { dmg_type = dmg_type, dmg_final = dmg, hp = hp } )
		end
	end
end

function GM:PlayerFootstep( ply, pos, foot, sound, vol, filter )
	//print( ply, pos, foot, sound, vol, filter )
	if SERVER then
		if ply:Alive() then
			//PrintTable( filter:GetPlayers() )
			local crouch = ply:Crouching()
			ply:EmitSound( sound, crouch and 60 or 80, 100, crouch and 0.5 or 1, CHAN_BODY )
		end
	end

	return true
end

function GM:PlayerStepSoundTime( ply, type, walk )
	local speed = ply:GetMaxSpeed()
	local time = 300

	if type == STEPSOUNDTIME_NORMAL or type == STEPSOUNDTIME_WATER_FOOT then
		if speed <= 100 then
			time = 550
		elseif speed <= 200 then
			time = 400
		elseif speed <= 300 then
			time = 350
		else
			time = 300
		end
	elseif type == STEPSOUNDTIME_ON_LADDER then
		time = 450
	elseif type == STEPSOUNDTIME_WATER_KNEE then
		time = 600
	end

	if ply:Crouching() then
		time = time + 75
	end

	return time
end

local function calcFallDamage( ply, speed )
	local vest = ply:GetVest()
	if vest > 0 then
		local data = VEST.GetData( vest )

		if data then
			local weight = data.weight
			local mul = 1

			if weight <= 1 then --<0, 1>
				mul = 5
			elseif weight <= 2 then --(1, 2>
				mul = 2.5
			elseif weight <= 4 then--(2, 4>
				mul = 1.5
			elseif weight <= 6 then --(4, 6>
				mul = 1
			elseif weight <= 10 then --(6, 10>
				mul = 0.75
			end

			--print( mul, weight * weight, weight * weight * mul, speed, speed + weight * weight * mul )

			speed = speed + weight * weight * mul
		end
	end

	if speed <= 150 then
		return speed * 0.1
	elseif speed <= 225 then
		return speed * 0.3
	elseif speed <= 300 then
		return speed * 0.6
	else
		return speed * 0.9
	end
end

function GM:OnPlayerHitGround( ply, water, floater, speed )
	if SERVER then
		local override, threshold, damage = hook.Run( "SLCFallDamage", ply, water, floater, speed )

		if override then
			speed = override
		end

		threshold = threshold or 300

		if speed > threshold then
			if !water then
				if speed > 300 then
					local ang = math.min( speed - 300, 750 ) * 0.03
					ply:ViewPunch( Angle( 0, 0, ang ) )
				end

				local dmg_t = threshold + 150
				if damage or speed > dmg_t then
					local dmg = damage or calcFallDamage( ply, speed - dmg_t )
					if dmg > 0 then
						local info = DamageInfo()
						info:SetDamageType( DMG_FALL )
						info:SetDamage( dmg )

						ply:TakeDamageInfo( info )

						ply:EmitSound( "Player.FallDamage", 100, 100, 1, CHAN_BODY )
					end
				end
			else
				ply:EmitSound( "Physics.WaterSplash" )
			end
		end

		ply:PlayStepSound( 0 )
	end

	return true
end

function GM:EntityEmitSound( data )
	--print( data.SoundName, data.Entity )
end

function GM:ShouldCollide( ent1, ent2 )
	return true
end

--[[-------------------------------------------------------------------------
Shared functions
---------------------------------------------------------------------------]]
cmd.AddCommand( "slc_destroy_gatea", function( ply )
	if SERVER and IsValid( ply ) and ply:GetPos():DistToSqr( POS_EXPLODE_A ) <= 62500 then
		if ply.ClassData.support then
			ExplodeGateA( ply )
		end
	end
end )

cmd.AddCommand( "slc_escort", function( ply )
	if SERVER and IsValid( ply ) and ( !ply.NEscort or ply.NEscort < CurTime() ) then
		ply.NEscort = CurTime() + 10
		PlayerEscort( ply )
	end
end )