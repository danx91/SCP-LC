--[[-------------------------------------------------------------------------
Outside buff
---------------------------------------------------------------------------]]
function GetSCPStats( ply )
	if CLIENT then
		return SCPStats[ply:SCPClass()]
	else
		local scp = GetSCP( ply:SCPClass() )
		if !scp then return end

		return scp.basestats
	end
end

function GetSCPModifiers( ply )
	local mods = {
		def = 0,
		flat = 0,
		heal_scale = 1,
		regen_scale = 0.75,
	}

	if ROUND.aftermatch then
		mods.def = 0.9
		mods.flat = 0
	elseif ESCAPE_STATUS == ESCAPE_ACTIVE and ply:IsInEscape() then
		mods.def = 0.75
		mods.flat = 0
	end

	if !IsRoundLive() then return mods end

	local round_pct = math.Clamp( 1 - RemainingRoundTime() / RoundDuration(), 0, 1 )

	mods.def = math.Map( round_pct, 0, 1, -0.33, 0.5 )
	mods.flat = math.Map( round_pct, 0, 1, 0, -3 )
	mods.heal_scale = math.ClampMap( round_pct, 0.1, 0.9, SCP_BUFF_HEAL_MIN, SCP_BUFF_HEAL_MAX )
	mods.regen_scale = math.ClampMap( round_pct, 0.1, 0.9, SCP_BUFF_REGEN_MIN, SCP_BUFF_REGEN_MAX )

	if mods.def > 0.25 then
		mods.def = 0.25
	end

	if mods.flat < -2 then
		mods.flat = -2
	end

	if ply:GetProperty( "scp_buff" ) and ply:IsInZone( ZONE_SURFACE ) then
		mods.def = mods.def + SCP_BUFF_DEF
		mods.flat = mods.flat - SCP_BUFF_FLAT
	end

	local scp = GetSCPStats( ply )
	if scp and scp.prot_scale then
		if mods.def > 0 then
			mods.def = mods.def * scp.prot_scale
		end

		if mods.flat < 0 then
			mods.flat = mods.flat * scp.prot_scale
		end
	end

	if scp and scp.buff_scale then
		mods.heal_scale = mods.heal_scale * scp.buff_scale
		mods.regen_scale = mods.regen_scale * scp.buff_scale

		if mods.regen_scale > SCP_BUFF_REGEN_CAP then
			mods.regen_scale = SCP_BUFF_REGEN_CAP
		end
	end

	return mods
end

hook.Add( "SLCRound", "SCPSurfaceCheck", function( time )
	AddTimer( "SLCSurfaceCheck", 3, 0, function()
		for i, v in ipairs( player.GetAll() ) do
			if v:SCPTeam() != TEAM_SCP or v:GetSCPHuman() then continue end
			if v:GetProperty( "scp_buff_applied" ) or !v:GetProperty( "scp_buff" ) or !v:IsInZone( ZONE_SURFACE ) then continue end

			local buff_scale = v.SCPData and v.SCPData.buff_scale or 1

			v:SetProperty( "scp_buff_applied", true )
			v:SetProperty( "scp_buff_heal", math.min( CVAR.slc_scp_buff_pct_regen:GetFloat() * v:GetMaxHealth(), CVAR.slc_scp_buff_max_regen:GetInt() ) * buff_scale )

			v:AddTimer( "SCPOutsideBuff", SCP_BUFF_TICK, 0, function( this )
				if !IsValid( v ) then return end

				if !v:IsInZone( ZONE_SURFACE ) then
					v:SetProperty( "scp_buff_regen", 0 )
					v:SetProperty( "scp_buff_heal", 0 )
				end

				local buff_heal = v:GetProperty( "scp_buff_heal", 0 )
				if buff_heal > 0 then
					local to_heal = SCP_BUFF_HEAL_RATE

					if to_heal > buff_heal then
						to_heal = buff_heal
					end

					v:AddHealth( to_heal )
					v:SetProperty( "scp_buff_heal", buff_heal - to_heal )
				end

				local buff_regen = v:GetProperty( "scp_buff_regen", 0 )
				if buff_regen > 0 and v:GetProperty( "scp_buff_regen_time", 0 ) <= CurTime() then
					local to_regen = SCP_BUFF_REGEN_RATE

					if to_regen > buff_regen then
						to_regen = buff_regen
					end

					v:AddHealth( to_regen )
					v:SetProperty( "scp_buff_regen", buff_regen - to_regen )
				end
			end )
		end
	end )
end )

hook.Add( "SCPUpgradeBought", "SCPOutsideBuff", function( wep, upgrade )
	if upgrade.name == "outside_buff" then
		wep:GetOwner():SetProperty( "scp_buff", true, true )
	end
end )

--[[-------------------------------------------------------------------------
Damage handling
---------------------------------------------------------------------------]]
SLC_DAMAGE_EFFECTS = {}

function AddDamageEffect( cb, ... )
	for k, v in pairs( { ... } ) do
		if !SLC_DAMAGE_EFFECTS[v] then
			SLC_DAMAGE_EFFECTS[v] = {}
		end

		table.insert( SLC_DAMAGE_EFFECTS[v], cb )
	end
end

AddDamageEffect( function( target, info, prot )
	if SLCRandom( 1, 100 ) <= ( prot and 4 or 20 ) then
		target:ApplyEffect( "bleeding", info:GetAttacker() )
	end
end, DMG_BULLET, DMG_SLASH )

AddDamageEffect( function( target, info, prot )
	if prot then return end

	target:ApplyEffect( "electrical_shock" )
end, DMG_SHOCK, DMG_ENERGYBEAM )

local function handle_prevent_break( target, info )
	if !PREVENT_BREAK then return end

	local cache = GetRoundProperty( "prevent_break_cache" )
	if !cache then
		cache = SetRoundProperty( "prevent_break_cache", {} )
	end

	if !cache then return end
	if cache[target] then return true end
	if target.SkipSCPDamageCheck then return end

	local pos = target:GetPos()
	for k, v in pairs( PREVENT_BREAK ) do
		if v == pos then
			cache[target] = true
			return true
		end
	end

	target.SkipSCPDamageCheck = true
end

local function handle_bullets( target, weapon, mult )
	local vest = weapon.ImpactPower or 1
	local pen = weapon.PenetrationPower

	//print( "[VEST]", vest )
	if !pen then
		return mult, vest
	end

	local new_mult

	if pen <= 100 then
		new_mult = mult * pen / 100
		//print( "[BULLET] PEN <= 100", pen, mult, new_mult )
	else
		new_mult = 1 - ( 1 - mult ) * 0.5 ^ ( ( pen - 100 ) / 100 )
		//print( "[BULLET] PEN > 100", pen, mult, new_mult )
	end

	return new_mult, vest
end

local function handle_vest( target, info )
	local vest = target:GetVest()
	if vest <= 0 then return end

	local data = VEST.GetData( vest )
	if !data then return end

	local dur = target:GetVestDurability()
	if dur <= 0 and data.durability != -1 then return end

	local pre_scaled = info:GetDamage()
	local attacker = info:GetAttacker()
	local wep = IsValid( attacker ) and attacker:IsPlayer() and attacker:GetActiveWeapon()
	local prot = {}
	local vest_dmg = 0

	for k, v in pairs( data.damage ) do
		if !info:IsDamageType( k ) then continue end

		local vest_mult = 1

		if v < 1 and ( k == DMG_BULLET or k == DMG_BUCKSHOT ) and IsValid( wep ) then
			//v = 1 - ( 1 - v ) * ( 1 - wep.ArmorPenetration )
			//v = v + ( 1 - v ) * wep.ArmorPenetration
			v, vest_mult = handle_bullets( target, wep, v )
		end

		local cvd = pre_scaled * vest_mult
		vest_dmg = vest_dmg + cvd

		//local last = info:GetDamage()
		info:ScaleDamage( v )
		prot[k] = true

		//print( string.format( "[VEST] Type: %i; Damage: %.1f -> %.1f (%.2f); CVD: %.1f (%.1f);", k, last, info:GetDamage(), v, cvd, vest_dmg ) )
	end

	if dur > 0 then
		target:SetVestDurability( dur - math.min( vest_dmg, dur ) )
		//print( "[VEST]", target:GetVestDurability() )
	end

	return prot
end

function handle_scps( target, info, attacker )
	if target:SCPTeam() != TEAM_SCP or !info:IsDamageType( DMG_BULLET ) then return end
	if attacker:SCPTeam() == TEAM_SCP then return true end
	if target:GetSCPHuman() then return end

	local mods = GetSCPModifiers( target )
	local dmg = info:GetDamage() + mods.flat

	if dmg < 1 then
		dmg = 1
	end

	info:SetDamage( dmg )

	local scale = 1 - mods.def
	if scale >= 0 then
		info:ScaleDamage( scale )
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, info )
	if hook.Run( "PlayerShouldTakeDamage", ply, info:GetAttacker() ) == false then return true end

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

function GM:PlayerTakeDamage( target, info )
	if !target:IsPlayer() or info:IsDamageType( DMG_DIRECT ) then return end

	local attacker = info:GetAttacker()
	if hook.Run( "PlayerShouldTakeDamage", target, attacker ) == false then return true end --TODO test if called by default?
	
	if IsValid( attacker ) then
		if attacker:IsVehicle() then return true end
		
		if attacker:IsPlayer() then
			if attacker:InVehicle() then return true end

			if target != attacker then
				if handle_scps( target, info, attacker ) == true then return true end

				local dmg_orig = info:GetDamage()
				AddRoundStat( "dmg", dmg_orig )

				if SCPTeams.IsAlly( attacker:SCPTeam(), target:SCPTeam() ) then
					AddRoundStat( "rdmdmg", dmg_orig )
				end

			end
		end
	end

	local prot = handle_vest( target, info )
	local dmg_flag = info:GetDamageType()

	while dmg_flag != 0 do
		local b = bit.band( dmg_flag, -dmg_flag )
		dmg_flag = bit.band( dmg_flag, bit.bnot( b ) )

		if SLC_DAMAGE_EFFECTS[b] then
			local p = !!( prot and prot[b] )

			for i, v in ipairs( SLC_DAMAGE_EFFECTS[b] ) do
				v( target, info, p )
			end
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

--It's serverside only function, but lets leave it here, next to ScalePlayerDamage
local INVERSE_POISON = bit.bnot( DMG_POISON )
function GM:EntityTakeDamage( target, info )
	if handle_prevent_break( target, info ) == true then return true end

	local dmg_orig = info:GetDamage()

	if hook.Run( "PlayerTakeDamage", target, info ) == true then
		return result
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

	local prevent, direct = hook.Run( "SLCPostScaleDamage", target, info )
	if prevent == true and ( direct == true or !info:IsDamageType( DMG_DIRECT ) ) then return true end

	local dmgtype = info:GetDamageType()
	if bit.band( dmgtype, DMG_POISON ) == DMG_POISON then
		info:SetDamageType( bit.bor( bit.band( dmgtype, INVERSE_POISON ), DMG_NERVEGAS ) )
	end
end

function GM:SLCPostScaleDamage( target, info )
	if !IsValid( target ) or !target:IsPlayer() then return end

	local att = info:GetAttacker()
	if target == att or !IsValid( att ) or !att:IsPlayer() or SCPTeams.IsAlly( att:SCPTeam(), target:SCPTeam() ) then return end

	if target:SCPTeam() == TEAM_SCP and target:GetProperty( "scp_buff" ) and target:IsInZone( ZONE_SURFACE ) then
		if  info:IsDamageType( DMG_DIRECT ) or !info:IsDamageType( DMG_BULLET ) then return end

		target:SetProperty( "scp_buff_regen", target:GetProperty( "scp_buff_regen", 0 ) + info:GetDamage() * GetSCPModifiers( target ).regen_scale )
		target:SetProperty( "scp_buff_regen_time", CurTime() + SCP_BUFF_REGEN_TIME )
	elseif att:SCPTeam() == TEAM_SCP and att:GetProperty( "scp_buff" ) and att:IsInZone( ZONE_SURFACE ) then
		att:SetProperty( "scp_buff_heal", att:GetProperty( "scp_buff_heal", 0 ) + info:GetDamage() * GetSCPModifiers( att ).heal_scale )
	end
end

function ApplyDamageHUDEvents( target, dmg )
	local target_valid = IsValid( target ) and target:IsPlayer()
	if !target.slc_dmg_ind and target_valid then target.slc_dmg_ind = {} end

	local att = dmg:GetInflictor()
	if IsValid( att ) then
		local owner = att:GetOwner()
		if IsValid( owner ) then
			att = owner
		end
	else
		att = dmg:GetAttacker()
	end

	if IsValid( att ) and att != target and dmg:IsBulletDamage() then
		if ( !target_valid or !target.slc_dmg_ind[att] ) and att:IsPlayer() then
			net.Start( "SLCHitMarker" )
			net.Send( att )
		end

		if target_valid then
			target.slc_dmg_ind[att] = ( target.slc_dmg_ind[att] or 0 ) + dmg:GetDamage()
		end
	elseif target_valid then
		net.Start( "SLCDamageIndicator" )
			net.WriteUInt( math.Clamp( math.ceil( dmg:GetDamage() ), 0, 1023 ), 10 )

			net.WriteFloat( 0 )
			net.WriteFloat( 0 )
		net.Send( target )
	end
end

function GM:PostEntityTakeDamage( ent, dmg, took )
	if !ent:IsPlayer() then return end
	ApplyDamageHUDEvents( ent, dmg )

	//print( "[DMG]", ent, dmg )
end

hook.Add( "PlayerPostThink", "SLCDamageIndicator", function( ply )
	local tab = ply.slc_dmg_ind
	if !tab then return end

	for att, dmg in pairs( tab ) do
		tab[att] = nil
		if !IsValid( att ) then continue end

		net.Start( "SLCDamageIndicator" )
			net.WriteUInt( math.Clamp( math.ceil( dmg ), 0, 1023 ), 10 )

			local dir = att:GetPos() - ply:GetPos()
			net.WriteFloat( dir.x )
			net.WriteFloat( dir.y )
		net.Send( ply )
	end
end )