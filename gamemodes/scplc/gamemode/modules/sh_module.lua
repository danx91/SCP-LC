// Shared file
GM.Name 	= "SCP: Lost Control"
GM.Author 	= "danx91"
GM.Email 	= ""
GM.Website 	= ""

VERSION = "ALPHA 0.5"
DATE = "14/10/2019"

SCPS = {}
CLASSES = {}
MAP = {}

--Keycard access help
ACCESS_SAFE = bit.lshift( 1, 0 )
ACCESS_EUCLID = bit.lshift( 1, 1 )
ACCESS_KETER = bit.lshift( 1, 2 )
ACCESS_CHECKPOINT = bit.lshift( 1, 3 )
ACCESS_OMEGA = bit.lshift( 1, 4 )
ACCESS_GENERAL = bit.lshift( 1, 5 )
ACCESS_GATEA = bit.lshift( 1, 6 )
ACCESS_GATEB = bit.lshift( 1, 7 )
ACCESS_ARMORY = bit.lshift( 1, 8 )
ACCESS_FEMUR = bit.lshift( 1, 9 )
ACCESS_EC = bit.lshift( 1, 10 )

--[[-------------------------------------------------------------------------
Convars
---------------------------------------------------------------------------]]
CVAR = {
	minplayers = CreateConVar( "slc_min_players", 2, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	pretime = CreateConVar( "slc_time_preparing", 60, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	roundtime = CreateConVar( "slc_time_round", 1500, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	posttime = CreateConVar( "slc_time_postround", 30, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	blink = CreateConVar( "slc_blink_delay", 5, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ),
	groups = CreateConVar( "slc_premium_groups", "", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	premiumxp = CreateConVar( "slc_premium_xp", 2, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	spawnrate = CreateConVar( "slc_support_spawnrate", "360,540", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	penalty = CreateConVar( "slc_scp_penalty", 3, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	p_penalty = CreateConVar( "slc_scp_premium_penalty", 1, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	maxsupport = CreateConVar( "slc_support_amount", 5, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	humanscale = CreateConVar( "slc_scaledamage_human", 1, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	scpscale = CreateConVar( "slc_scaledamage_scp", 1, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	explodetime = CreateConVar( "slc_time_explode", 30, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	levelxp = CreateConVar( "slc_xp_level", 10000, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	escapexp = CreateConVar( "slc_xp_escape", "250,2000", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	escortpoints = CreateConVar( "slc_points_escort", 6, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	pointsxp = CreateConVar( "slc_points_xp", 50, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	roundxp = CreateConVar( "slc_xp_round", "100,200,300", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
	winxp = CreateConVar( "slc_xp_win", "1500,1000", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ),
}

--TODO
/*if !ConVarExists("br_roundrestart") then CreateConVar( "br_roundrestart", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Restart the round" ) end
if !ConVarExists("br_time_preparing") then CreateConVar( "br_time_preparing", "60", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set preparing time" ) end
if !ConVarExists("br_time_round") then CreateConVar( "br_time_round", "780", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set round time" ) end
if !ConVarExists("br_time_postround") then CreateConVar( "br_time_postround", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set postround time" ) end
if !ConVarExists("br_time_ntfenter") then CreateConVar( "br_time_ntfenter", "360", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that NTF units will enter the facility" ) end
if !ConVarExists("br_time_blink") then CreateConVar( "br_time_blink", "0.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Blink timer" ) end
if !ConVarExists("br_time_blinkdelay") then CreateConVar( "br_time_blinkdelay", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Delay between blinks" ) end
if !ConVarExists("br_spawnzombies") then CreateConVar( "br_spawnzombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do you want zombies?" ) end
if !ConVarExists("br_scoreboardranks") then CreateConVar( "br_scoreboardranks", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "" ) end
if !ConVarExists("br_defaultlanguage") then CreateConVar( "br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_expscale") then CreateConVar( "br_expscale", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scp_cars") then CreateConVar( "br_scp_cars", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow SCPs to drive cars?" ) end
if !ConVarExists("br_allow_vehicle") then CreateConVar( "br_allow_vehicle", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow vehicle spawn?" ) end
if !ConVarExists("br_dclass_keycards") then CreateConVar( "br_dclass_keycards", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is D class supposed to have keycards? (D Class Weterans have keycard anyway)" ) end
if !ConVarExists("br_time_explode") then CreateConVar( "br_time_explode", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time from call br_destroygatea to explode" ) end
if !ConVarExists("br_ci_percentage") then CreateConVar("br_ci_percentage", "25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_i4_min_mtf") then CreateConVar("br_i4_min_mtf", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_cars_oldmodels") then CreateConVar("br_cars_oldmodels", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Use old cars models?" ) end
if !ConVarExists("br_premium_url") then CreateConVar("br_premium_url", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Link to premium members list" ) end
if !ConVarExists("br_premium_mult") then CreateConVar("br_premium_mult", "1.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Premium members exp multiplier" ) end
if !ConVarExists("br_premium_display") then CreateConVar("br_premium_display", "Premium player %s has joined!", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Text shown to all players when premium member joins" ) end
if !ConVarExists("br_stamina_enable") then CreateConVar("br_stamina_enable", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is stamina allowed?" ) end
if !ConVarExists("br_stamina_scale") then CreateConVar("br_stamina_scale", "1, 1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Stamina regen and use. ('x, y') where x is how many stamina you will receive, and y how many stamina you will lose" ) end
if !ConVarExists("br_rounds") then CreateConVar("br_rounds", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "How many round before map restart? 0 - dont restart" ) end
if !ConVarExists("br_min_players") then CreateConVar("br_min_players", "2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum players to start round" ) end
if !ConVarExists("br_firstround_debug") then CreateConVar("br_firstround_debug", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_force_specialround") then CreateConVar("br_force_specialround", "", {FCVAR_SERVER_CAN_EXECUTE}, "Available special rounds [ infect, multi ]" ) end
if !ConVarExists("br_specialround_pct") then CreateConVar("br_specialround_pct", "10", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_punishvote_time") then CreateConVar("br_punishvote_time", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How much time players have to vote" ) end
if !ConVarExists("br_allow_punish") then CreateConVar("br_allow_punish", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is punish system allowed?" ) end
if !ConVarExists("br_cars_ammount") then CreateConVar("br_cars_ammount", "12", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How many cars should spawn?" ) end
if !ConVarExists("br_dropvestondeath") then CreateConVar("br_dropvestondeath", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do players drop vests on death?" ) end
if !ConVarExists("br_force_showupdates") then CreateConVar("br_force_showupdates", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should players see update logs any time they join to server?" ) end
if !ConVarExists("br_allow_scptovoicechat") then CreateConVar("br_allow_scptovoicechat", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Can SCPs talk with humans?" ) end
if !ConVarExists("br_ulx_premiumgroup_name") then CreateConVar("br_ulx_premiumgroup_name", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Name of ULX premium group" ) end
if !ConVarExists("br_experimental_bulletdamage_system") then CreateConVar("br_experimental_bulletdamage_system", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problems with bullets" ) end
if !ConVarExists("br_experimental_antiknockback_force") then CreateConVar("br_experimental_antiknockback_force", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problems with bullets" ) end
if !ConVarExists("br_allow_ineye_spectate") then CreateConVar("br_allow_ineye_spectate", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_allow_roaming_spectate") then CreateConVar("br_allow_roaming_spectate", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scale_bullet_damage") then CreateConVar("br_scale_bullet_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Bullet damage scale" ) end
if !ConVarExists("br_new_eq") then CreateConVar("br_new_eq", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables new EQ" ) end
if !ConVarExists("br_enable_warhead") then CreateConVar("br_enable_warhead", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Enables OMEGA Warhead" ) end
if !ConVarExists("br_scale_human_damage") then CreateConVar("br_scale_human_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Scales damage dealt by humans" ) end
if !ConVarExists("br_scale_scp_damage") then CreateConVar("br_scale_scp_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Scales damage dealt by SCP" ) end
if !ConVarExists("br_scp_penalty") then CreateConVar("br_scp_penalty", "3", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" ) end
if !ConVarExists("br_premium_penalty") then CreateConVar("br_premium_penalty", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" ) end*/

--[[-------------------------------------------------------------------------
Shared GM hooks
---------------------------------------------------------------------------]]
function GM:Initialize()
	self.BaseClass.Initialize( self )
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
	if !info:IsDamageType( DMG_DIRECT ) then
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
	end
end

local function getSCPBuff()
	local t = GetTimer( "SLCRound" )

	if IsValid( t ) then
		local total = t:GetTime()
		local rem = t:GetRemainingTime()

		--print( total, rem )
	end
end

--It's serverside function, but lets leave it here, next to ScalePlayerDamage
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
				local data = VEST.getData( vest )

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

						if class == "weapon_crowbar" then
							info:ScaleDamage( 0.3 )
						elseif class == "weapon_stunstick" then
							info:ScaleDamage( 0.5 )
						end
					end

					if target != attacker then
						if t_att == TEAM_SCP then
							if t_trg == TEAM_SCP then
								--info:SetDamage( 0 )
								return true
							else
								--TODO
								local buff = getSCPBuff()
							end
						end

						AddRoundStat( "dmg", dmg_orig )

						if SCPTeams.isAlly( t_att, t_trg ) then
							AddRoundStat( "rdmdmg", dmg_orig )
						end
					end
				end
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
		//PrintTable( filter:GetPlayers() )
		local crouch = ply:Crouching()
		ply:EmitSound( sound, crouch and 60 or 80, 100, crouch and 0.5 or 1, CHAN_BODY )
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
		local data = VEST.getData( vest )

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
		if speed > 300 then
			local n = speed - 300
			local ang = math.min( n, 750 ) * 0.03
			ply:ViewPunch( Angle( 0, 0, ang ) )

			if speed > 450 then
				--if SERVER then
					local dmg = calcFallDamage( ply, speed - 450 )
					--print( dmg )
					if dmg > 0 then
						local info = DamageInfo()
						info:SetDamageType( DMG_FALL )
						info:SetDamage( dmg )

						ply:TakeDamageInfo( info )

						ply:EmitSound( "Player.FallDamage", 100, 100, 1, CHAN_BODY )
					end
				--end
			end
		end

		--if SERVER then
			if speed > 300 and water then
				ply:EmitSound( "Physics.WaterSplash" )
			end

			ply:PlayStepSound( 0 )
		--end
	end

	return true
end

function GM:EntityEmitSound( data )
	--print( data.SoundName, data.Entity )
end

--[[-------------------------------------------------------------------------
106 Collision
---------------------------------------------------------------------------]]
function GM:ShouldCollide( ent1, ent2 )
	if ent1:IsPlayer() and ent1:SCPClass() == CLASSES.SCP106 or ent2:IsPlayer() and ent2:SCPClass() == CLASSES.SCP106 then
		if ent1.ignorecollide106 or ent2.ignorecollide106 then
			return false
		end
	end

	return true
end

local function SetupCollide()
	local fent = ents.GetAll()
	for k, v in pairs( fent ) do
		if v and v:GetClass() == "func_door" or v:GetClass() == "prop_dynamic" then
			if v:GetClass() == "prop_dynamic" then
				local ennt = ents.FindInSphere( v:GetPos(), 5 )
				local neardors = false
				for k, v in pairs( ennt ) do
					if v:GetClass() == "func_door" then
						neardors = true
						break
					end
				end
				if !neardors then 
					v.ignorecollide106 = false
					continue
				end
			end

			local changed
			for _, pos in pairs( DOOR_RESTRICT106 ) do
				if v:GetPos():Distance( pos ) < 100 then
					v.ignorecollide106 = false
					changed = true
					break
				end
			end
			
			if !changed then
				v.ignorecollide106 = true
			end
		end
	end
end

function GM:PostCleanupMap()
	SetupCollide()
end

timer.Simple( 0, function()
	SetupCollide()
end )

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