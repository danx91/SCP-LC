IDs = IDs or {}

function UpdatePlayerID( ply )
	local lp = LocalPlayer()

	local lpt = lp:SCPTeam()
	local wep = ply:GetActiveWeapon()
	local class, team = ply:SCPClass(), ply:SCPTeam()
	local pclass, pteam = ply:SCPPersona()

	local tc, tt

	if IsValid( wep ) and wep:GetClass() == "item_slc_id" then
		if SCPTeams.IsAlly( team, lpt ) then
			tc = class
			tt = team
		else
			tc = pclass
			tt = pteam
		end
	elseif lpt == TEAM_SCP and team == TEAM_SCP or pteam == TEAM_SCP then
		tc = class
		tt = TEAM_SCP
	end

	if !tc or !tt then return end

	local saved = IDs[ply]
	if saved and saved.class == tc and saved.team == tt then return end

	print( "Updating ID:", ply, tc )
	IDs[ply] = { class = tc, team = tt }
end

function SetupInitialIDs( tab )
	local lp = LocalPlayer()
	local _, lppt = lp:SCPPersona()

	for k, v in pairs( tab ) do
		if !IsValid( v ) or v == lp then continue end
		IDs[v] = { class = "unknown", team = lppt }
	end
end

function GetPlayerID( ply )
	if ply == LocalPlayer() then
		return { class = ply:SCPClass(), team = ply:SCPTeam() }
	end

	return IDs[ply]
end

function RemovePlayerID( ply )
	IDs[ply] = nil
end

function ClearPlayerIDs()
	IDs = {}
end

function GM:HUDDrawTargetID()
	if hud_disabled or ROUND.infoscreen then return end

	local lp = LocalPlayer()
	if lp:SCPTeam() == TEAM_SPEC and !lp:GetAdminMode() then return end

	local ply = lp:GetEyeTrace().Entity
	
	if !IsValid( ply ) or !ply.IsPlayer or !ply:IsPlayer() or !ply:Alive() or ply:SCPTeam() == TEAM_SPEC then return end
	if ply:GetPos():DistToSqr( lp:GetPos() ) > 90000 or ply:GetNoDraw() or hook.Run( "CanPlayerSeePlayer", lp, ply ) == false then return end

	if !ply.updated_id then
		ply.update_id = 0
	end

	if ply.update_id < CurTime() then
		ply.update_id = CurTime() + 1
		UpdatePlayerID( ply )
	end

	if hook.Run( "HUDShouldDraw", "scplc.target" ) == false then return end

	local color = Color( 200, 200, 200, 255 )
	local class = nil

	local id = GetPlayerID( ply )
	if id then
		color = SCPTeams.GetColor( id.team ) or color
		class = id.class or "unknown"
	end

	local w, h = ScrW(), ScrH()

	draw.Text{
		text = ply:Nick(),
		pos = { w * 0.5, h * 0.575 },
		color = color,
		font = "SCPHUDSmall",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_BOTTOM,
	}

	if !class then return end

	local txt = LANG.CLASSES_ID[class] or LANG.CLASSES[class] or class

	if class == "unknown" then
		local t_name = SCPTeams.GetName( id.team )
		txt = t_name and LANG.UNK_CLASSES[t_name] or txt
	end

	draw.Text{
		text = txt,
		pos = { w * 0.5, h * 0.575 },
		color = color,
		font = "SCPHUDSmall",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_TOP,
	}
end