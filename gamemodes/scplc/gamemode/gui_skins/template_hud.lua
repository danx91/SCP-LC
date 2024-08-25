local function pre_draw_hud()

end

local function draw_spectator_hud()

end

local function draw_hud()

end

local function draw_extended_hud()

end

local function post_draw_hud()

end

local function draw_all()
	pre_draw_hud()

	if LocalPlayer():SCPTeam() == TEAM_SPEC then
		draw_spectator_hud()
	else
		draw_hud()
	end

	if HUDDrawInfo or ROUND.post then
		draw_extended_hud()
	end

	post_draw_hud()
end

/*AddGUISkin( "hud", "template", {
	create = function()
		hook.Add( "SLCDrawHUD", "HUD.Template.Paint", draw_all )
	end,
	remove = function()
		hook.Remove( "SLCDrawHUD", "HUD.Template.Paint" )
	end,
	show =  nil,
	hide = nil,
} )*/