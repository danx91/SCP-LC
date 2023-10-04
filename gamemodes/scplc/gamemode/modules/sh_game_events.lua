--[[-------------------------------------------------------------------------
Safe spots
---------------------------------------------------------------------------]]
function IsInSafeSpot( pos )
	for k, v in pairs( SAFE_SPOTS ) do
		if pos:WithinAABox( v.mins, v.maxs ) then
			return true
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
Gas System
---------------------------------------------------------------------------]]
SLC_GAS = SLC_GAS or {}
SLC_GAS_ZONES = {
	ZONE_LCZ,
	ZONE_HCZ,
	ZONE_EZ,
}

if SERVER then
	function UpdateGasStatus( ply )
		net.Start( "SLCGasZones" )
			net.WriteTable( SLC_GAS )
		
		if ply then
			net.Send( ply )
		else
			net.Broadcast()
		end
	end

	hook.Add( "SLCRound", "SLCGasZones", function( time )
		for k, v in pairs( SLC_GAS_ZONES ) do
			local start = CVAR["slc_gas_"..v]:GetInt()
			local dur = CVAR["slc_gas_"..v.."_time"]:GetInt()

			if start <= 0 then
				SLC_GAS[v] = { 0, 0 }
				continue
			end

			local t_start = CurTime() + start
			SLC_GAS[v] = { t_start, t_start + dur }

			AddTimer( "SLCGas"..v, start - 60, 1, function()
				PlayerMessage( "gaswarn$@MISC.zones."..v )
			end )
		end

		UpdateGasStatus()
	end )

	hook.Add( "PlayerReady", "SLCGasZones", function( ply )
		UpdateGasStatus( ply )
	end )

	hook.Add( "SLCRoundCleanup", "SLCGasZones", function( time )
		SLC_GAS = {}

		for k, v in pairs( SLC_GAS_ZONES ) do
			SLC_GAS[v] = { 0, 0 }
		end

		UpdateGasStatus()
		//print( "upd!" )
	end )

	hook.Add( "PlayerPostThink", "SLCGasZones", function( ply )
		local ct = CurTime()
		if ply.NGasDamageTick and ply.NGasDamageTick > ct then return end
		ply.NGasDamageTick = ct + 1

		if ply:SCPTeam() == TEAM_SPEC or !ply:Alive() then return end
		
		for k, v in pairs( SLC_GAS_ZONES ) do
			if SLC_GAS[v] and SLC_GAS[v][1] > 0 and SLC_GAS[v][1] <= ct and ply:IsInZone( v ) then
				local _, dmg, delay = GetGasPower( v )
				ply.NGasDamageTick = ct + delay

				if !ply:CheckHazardProtection( dmg ) then
					local dmg_info = DamageInfo()

					dmg_info:SetDamage( ply:SCPTeam() == TEAM_SCP and dmg * 5 or dmg )
					dmg_info:SetDamageType( DMG_POISON )

					ply:TakeDamageInfo( dmg_info )
				end

				return
			end
		end
	end )
end

if CLIENT then
	hook.Add( "SetupWorldFog", "SLCGasZones", function()
		if !SLC_GAS.GasPower then SLC_GAS.GasPower = 0 end

		local ply = LocalPlayer()
		if !ply:Alive() and ply:GetObserverMode() == OBS_MODE_NONE then return end
		
		local ct = CurTime()
		local pct = 0

		for k, v in pairs( SLC_GAS_ZONES ) do
			if SLC_GAS[v] and SLC_GAS[v][1] > 0 and SLC_GAS[v][1] <= ct and ply:IsInZone( v ) then
				pct = GetGasPower( v )
				break
			end
		end

		pct = math.Approach( SLC_GAS.GasPower, pct, FrameTime() * 0.75 )
		SLC_GAS.GasPower = pct

		if pct > 0 then
			render.FogMode( MATERIAL_FOG_LINEAR )
			render.FogStart( -250 )
			render.FogEnd( 1150 - 750 * pct )
			render.FogMaxDensity( pct * 0.99 )
			render.FogColor( 0, 75, 0 )

			return true
		end
	end )
end

--return pct, dmg, delay
function GetGasPower( zone )
	local tab = SLC_GAS[zone]
	if !tab or tab[1] == 0 then return 0, 0 end

	local pct = math.Clamp( ( CurTime() - tab[1] ) / ( tab[2] - tab[1] ), 0, 1 )
	return pct, 1 + math.floor( 2 * pct ), 2 - 1.5 * pct
end