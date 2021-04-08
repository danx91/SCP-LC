local ULX_CATEGORY = " SCP: Lost Control"


if CLIENT and ULib then 

	local MATS = {
		blur = Material( "pp/blurscreen" ),
		hp = Material( "slc/hud/hp" )
	}

	hook.Add("HUDPaint", "SLCOverwatchHUD", function() 
		local lp = LocalPlayer()
		if(!lp) then return end
		if(!lp:GetNWBool("OverwatchMode")) then return end
		local w, h = ScrW(), ScrH()
		local start = h * 0.01

		local isspec = lp:SCPTeam() == TEAM_SPEC
		if(!isspec) then
			local color = SCPTeams.getColor(lp:SCPTeam())
			draw.LimitedText{
				text = "OVERWATCH",
				pos = {  10, 10 },
				color = color,
				font = "SCPHUDBig",
				max_width = w * 0.2 - start,
			}
			return
		end

		local spectarg = lp:GetObserverTarget()
		local drawtarg = IsValid(spectarg) and ROUND.active
		if(!drawtarg) then return end

		local class = spectarg:SCPClass()
		local team = spectarg:SCPTeam()
		--print(type(class), type(team))

		local color = SCPTeams.getColor(team)

		local hp = spectarg:Health()
		local maxhp = spectarg:GetMaxHealth()

		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawRect( w * 0.028, h * 0.85 - 2, w * 0.27, h * 0.05 + 4 )

		render.SetStencilTestMask( 0xFF )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_REPLACE )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilReferenceValue( 1 )

		render.ClearStencil()
		render.SetStencilEnable( true )

		surface.SetDrawColor( Color( 100, 100, 100, 255 ) )
		surface.DrawRect(w * 0.028 + 2, h * 0.85, w * 0.27 - 4, h * 0.05)

		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )
		surface.SetMaterial( MATS.blur )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( 0, 0, w, h )

		render.SetStencilEnable( false )

		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		surface.DrawRect( w * 0.028 + 2, h * 0.85,w * 0.27 - 4, h * 0.05)

		local sh = h
		local sw = w
		local addy = 0

		local ratio = (w * 0.075) / (h * 0.24)
		local xoffset = ratio * h * 0.035
		local cxo = ratio * h * 0.015
		local ixo = ratio * h * 0.005

		local bar = SimpleMatrix( 2, 4, {
			{ start + w * 0.01, h * 0.81 + addy },
			{ start + w * 0.275, h * 0.81 + addy },
			{ start + w * 0.275 + xoffset, h * 0.845 + addy },
			{ start + w * 0.01 + xoffset, h * 0.845 + addy },
		} )

		local bar_out = SimpleMatrix( 2, 4, {
			{ start + w * 0.01 - 4, h * 0.81 - 2 + addy },
			{ start + w * 0.275 + 2, h * 0.81 - 2 + addy },
			{ start + w * 0.275 + xoffset + 4, h * 0.845 + 2 + addy },
			{ start + w * 0.01 + xoffset - 2, h * 0.845 + 2 + addy },
		} )			
		local bar_offset = SimpleMatrix( 2, 4, {
			{ xoffset + cxo, h * 0.05 + 50},
			{ xoffset + cxo, h * 0.05  + 50},
			{ xoffset + cxo, h * 0.05 + 50},
			{ xoffset + cxo, h * 0.05 + 50 },
		} )

		local xico = ratio * ( h * 0.025 )

		local ico = SimpleMatrix( 2, 4, {
			{ start + w * 0.015, h * 0.815 + addy },
			{ start + w * 0.025, h * 0.815 + addy },
			{ start + w * 0.025 + xico, h * 0.84 + addy },
			{ start + w * 0.015 + xico, h * 0.84 + addy },
		} )

		local ico_offset = SimpleMatrix( 2, 4, {
			{ w * 0.013, 0 },
			{ w * 0.013, 0 },
			{ w * 0.013, 0 },
			{ w * 0.013, 0 },
		} )

		bar = bar + bar_offset
		bar_out = bar_out + bar_offset
		ico = ico + bar_offset
		draw.NoTexture()
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawDifference( bar:ToPoly(), bar_out:ToPoly() )

		local hpperseg = maxhp / 20
		local segments = math.min( math.ceil( hp / maxhp * 20 ), 20 )

		local intense = 1 - segments + hp / hpperseg
		local nico = SimpleMatrix( 2, 4, ico )

		if intense > 1 then
			intense = 1
		end

		for i = 1, segments do
			if i == segments then
				surface.SetDrawColor( Color( 175, 0, 25, 175 * intense ) )
			else
				surface.SetDrawColor( Color( 175, 0, 25, 175 ) )
			end

			surface.DrawPoly( nico:ToPoly() )
			nico = nico + ico_offset
		end

		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )



		draw.LimitedText{
			text = class,
			pos = { w * 0.05 / 2 + 8, h * 0.875 },
			color = color,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.2 - start,
		}

		draw.LimitedText{
			text = hp.."/"..maxhp,
			pos = { w * 0.6 / 2 - 8, h * 0.875 },
			color = Color(255,255,255),
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.2 - start,
		}

		draw.LimitedText{
			text = "OVERWATCH",
			pos = {  w * 0.5, h * 0.955 },
			color = color,
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = w * 0.2 - start,
		}
	end)
	
	local DisplayDistance = 1000

	hook.Add("PostDrawOpaqueRenderables", "SLCOverwatch3DHUD", function()
		local lp = LocalPlayer()
		if(!lp) then return end
		if(!lp:GetNWBool("OverwatchMode")) then return end

		local angle = EyeAngles()
		angle = Angle(angle.x - 90, angle.y, 0)
		angle:RotateAroundAxis( angle:Up(), -90)


		for k,v in ipairs(player.GetAll()) do
			if(v:SCPTeam() != TEAM_SPEC) then
				if(v != lp:GetObserverTarget()) then
					if(lp:GetPos():DistToSqr(v:GetPos()) < DisplayDistance*DisplayDistance) then 
						cam.Start3D2D(v:GetPos() + Vector(0,0, 80), angle, 0.5)
						cam.IgnoreZ(true)
							draw.LimitedText{
								text = v:Nick(),
								pos = {0,0},
								color = SCPTeams.getColor(v:SCPTeam()),
								font = "SCPHUDBig",
								xalign = TEXT_ALIGN_CENTER,
								yalign = TEXT_ALIGN_CENTER,
								}
						cam.IgnoreZ(false)
						cam.End3D2D()
					end
				end
			end

		end

	end)
end

function ulx.overwatch(caller) 
	if(!caller.Get_SCPActive) then
		caller:SetupDataTables()
	end
	if(caller:IsActive()) then
		caller:Set_SCPActive(false)
		if(caller:Alive()) then
			caller:SetupSpectator()
		end
		caller:ChatPrint("Entered overwatch mode, you won`t get respawned")
		caller:SetNWBool("OverwatchMode", true)
	else 
		caller:Set_SCPActive(true)
		caller:ChatPrint("Left overwatch mode, now you will get respawned")
		caller:SetNWBool("OverwatchMode", false)
	end
	
end

local overwatch = ulx.command(ULX_CATEGORY, "ulx overwatch", ulx.overwatch, "!overwatch")
overwatch:defaultAccess(ULib.ACCESS_SUPERADMIN)
overwatch:help("Toggles overwatch(like in SL) mode")