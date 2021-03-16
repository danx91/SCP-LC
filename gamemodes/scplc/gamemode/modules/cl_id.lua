IDs = IDs or {}

function updatePlayerID( ply )
	local lp = LocalPlayer()

	local lpt = lp:SCPTeam()
	local wep = ply:GetActiveWeapon()
	local class, team = ply:SCPClass(), ply:SCPTeam()
	local pclass, pteam = ply:SCPPersona()

	local tc, tt

	if IsValid( wep ) and wep:GetClass() == "item_slc_id" then
		if SCPTeams.isAlly( lpt, team ) then
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

	if tc and tt then
		local saved = IDs[ply]
		if !saved or saved.class != tc or saved.team != tt then
			print( "Updating ID:", ply, tc )
			IDs[ply] = { class = tc, team = tt }
		end
	end
end

function getPlayerID( ply )
	if ply == LocalPlayer() then
		return { class = ply:SCPClass(), team = ply:SCPTeam() }
	end

	return IDs[ply]
end

function removePlayerID( ply )
	IDs[ply] = nil
end


function clearPlayerIDs()
	IDs = {}
end

local nupd = 0
function GM:HUDDrawTargetID()
	if hud_disabled then return end

	local lp = LocalPlayer()
	if lp:SCPTeam() == TEAM_SPEC then return end

	local ply = lp:GetEyeTrace().Entity

	if !IsValid( ply ) then return end
	if !ply.IsPlayer or !ply:IsPlayer() then return end
	if !ply:Alive() then return end
	if ROUND.infoscreen then return end
	if ply:GetPos():DistToSqr( lp:GetPos() ) > 90000 then return end
	if ply:SCPTeam() == TEAM_SPEC then return end
	if hook.Run( "CanPlayerSeePlayer", lp, ply ) == false then return end

	if nupd < CurTime() then
		nupd = CurTime() + 0.5
		updatePlayerID( ply )
	end

	local color = Color( 200, 200, 200, 255 )
	local class = nil

	local id = getPlayerID( ply )
	if id then
		color = SCPTeams.getColor( id.team ) or color
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

	if class then
		draw.Text{
			text = LANG.CLASSES_ID[class] or LANG.CLASSES[class] or class,
			pos = { w * 0.5, h * 0.575 },
			color = color,
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_TOP,
		}
	end
end