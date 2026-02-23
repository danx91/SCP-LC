ROUND = {
	name = "",
	time = 0,
	preparing = false,
	post = false,
	active = false,
	properties = {}
}

SCPStats = {}

ChangeLang( true, true )

--[[-------------------------------------------------------------------------
Support opt-out, Class D preparing spawn
---------------------------------------------------------------------------]]
CreateClientConVar( "cvar_slc_support_optout", 0, true, true )
CreateClientConVar( "cvar_slc_zombie_optout", 0, true, true )
CreateClientConVar( "cvar_slc_preparing_classd", 1, true, true )

hook.Add( "SLCRegisterSettings", "SLCSupportOptOut", function()
	RegisterSettingsEntry( "cvar_slc_support_optout", "switch", "!CVAR" )
	RegisterSettingsEntry( "cvar_slc_zombie_optout", "switch", "!CVAR", nil, "scp_config" )
	RegisterSettingsEntry( "cvar_slc_preparing_classd", "switch", "!CVAR" )
end )

--[[-------------------------------------------------------------------------
Credits
---------------------------------------------------------------------------]]
timer.Create( "Credits", 300, 0, function()
	print( "'SCP: Lost Control' by danx91 [ZGFueDkx] version "..VERSION.." ("..DATE..")" )
end )

--[[-------------------------------------------------------------------------
Heartbeat
---------------------------------------------------------------------------]]
timer.Create( "SLCHeartbeat", 2, 0, function()
	local ply = LocalPlayer()
	if !FULLY_LOADED or !ply:Alive() then return end

	local t = ply:SCPTeam()
	if t == TEAM_SPEC or t == TEAM_SCP then return end
	if ply:Health() >= 25 or ply:GetExtraHealth() > 0 or ply:GetStaminaBoost() > CurTime() then return end

	ply:EmitSound( "SLCPlayer.Heartbeat" )
end)

--[[-------------------------------------------------------------------------
Screen effects
---------------------------------------------------------------------------]]
local exhaust_mat = GetMaterial( "slc/misc/exhaust.png", "smooth" )

local stamina_effects = 100
local boost_effects = 0
local color_mat = Material( "pp/colour" )
function GM:RenderScreenspaceEffects()
	local ply = LocalPlayer()

	local clr = {}

	clr.mul_r = 0
	clr.mul_g = 0
	clr.mul_b = 0
	clr.add_r = 0
	clr.add_g = 0
	clr.add_b = 0
	clr.brightness = 0
	clr.contrast = 1
	clr.colour = 1
	clr.inv = 0

	if ply:Alive() then
		local hp = ply:Health()
		local extra = ply:GetExtraHealth()
		local t = ply:SCPTeam()
		
		if ply:Alive() and t != TEAM_SPEC and t != TEAM_SCP and hp < 25 and extra <= 0 then
			local scale = 1 - hp / 25, 0.2
			clr.colour = clr.colour * ( 1 - scale )
			clr.add_r = clr.add_r + scale * 0.1
			clr.mul_r = clr.mul_r + scale * 0.7
			clr.brightness = clr.brightness - scale * 0.075

			DrawMotionBlur( 0.5, 0.6, 0.01 )
			DrawSharpen( 0.8, 2.25 * scale )
		end
	end

	if ply.GetStamina then
		local diff = ply:GetStaminaBoost() - CurTime()

		boost_effects = math.Approach( boost_effects, diff > 2 and 1 or 0, FrameTime() * ( diff > 2 and 20 or 0.5 ) )
		if boost_effects > 0 then
			clr.contrast = clr.contrast + boost_effects

			surface.SetDrawColor( 20, 20, 175, 10 * boost_effects )
			surface.SetMaterial( exhaust_mat )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end

		stamina_effects = math.Approach( stamina_effects, diff > 0 and 100 or ply:GetStamina(), FrameTime() * 20 )
		if stamina_effects < 100 then
			local staminamul = math.Map( math.min( stamina_effects, 30 ), 0, 30, 0.3, 0 )
			clr.contrast = clr.contrast - staminamul * 0.5
			clr.colour = clr.colour - staminamul

			if stamina_effects <= 30 then
				surface.SetDrawColor( 0, 0, 0, math.Map( math.min( stamina_effects, 30 ), 10, 40, 255, 0 ) )
				surface.SetMaterial( exhaust_mat )
				surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			end
		end
	end

	//if hook.Run( "SLCPreScreenMod" ) then return end
	hook.Run( "SLCScreenMod", clr )
	if clr.skip then return end

	if ply.cwFlashbangDuration and CurTime() <= ply.cwFlashbangDuration or ply.CW_SmokeScreenIntensity then return end

	render.UpdateScreenEffectTexture()
	color_mat:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
	
	color_mat:SetFloat( "$pp_colour_mulr", clr.mul_r )
	color_mat:SetFloat( "$pp_colour_mulg", clr.mul_g )
	color_mat:SetFloat( "$pp_colour_mulb", clr.mul_b )

	color_mat:SetFloat( "$pp_colour_addr", clr.add_r )
	color_mat:SetFloat( "$pp_colour_addg", clr.add_g )
	color_mat:SetFloat( "$pp_colour_addb", clr.add_b )

	color_mat:SetFloat( "$pp_colour_brightness", clr.brightness )
	color_mat:SetFloat( "$pp_colour_contrast", clr.contrast )
	color_mat:SetFloat( "$pp_colour_colour", clr.colour )
	color_mat:SetFloat( "$pp_colour_inv", clr.inv )
	
	render.SetMaterial( color_mat )
	render.DrawScreenQuad()

	hook.Run( "SLCPostScreenMod" )
end

--[[-------------------------------------------------------------------------
Blink system
---------------------------------------------------------------------------]]
local blink = false
local endblink = 0
local nextblink = 0

local fade_flag = bit.bor( SCREENFADE.IN, SCREENFADE.OUT )
net.Receive( "PlayerBlink", function( len )
	local ply = LocalPlayer()
	local duration = net.ReadFloat()
	local delay = net.ReadFloat()

	if ply.disable_blink then
		ply.disable_blink = false
		return
	end

	if duration > 0 then
		if GetSettingsValue( "smooth_blink" ) then
			ply:ScreenFade( fade_flag, Color( 0, 0, 0 ), 0.075, duration )
		else
			blink = true
		end
	end

	endblink = CurTime() + duration
	nextblink = CurTime() + delay

	HUDNextBlink = nextblink 
	HUDBlink = delay - duration

	hook.Run( "SLCBlink", ply, duration, delay )
end )

hook.Add( "Tick", "BlinkTick", function()
	if blink and endblink < CurTime() then
		blink = false
	end
end )

local blink_mat = CreateMaterial( "mat_SCP_blink", "UnlitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$color"] = "{ 0 0 0 }"
} )

hook.Add( "PreDrawHUD", "SLCBlink", function()
	if blink then
		render.SetMaterial( blink_mat )
		render.DrawScreenQuad()
	end
end )

hook.Add( "SLCRegisterSettings", "SLCBlinkSettings", function()
	RegisterSettingsEntry( "smooth_blink", "switch", true )
end )

--[[-------------------------------------------------------------------------
RoundProperties
---------------------------------------------------------------------------]]
function SetRoundProperty( key, value )
	if !ROUND.active then return end

	ROUND.properties[key] = value
	return value
end

function GetRoundProperty( key, def )
	if !ROUND.active then return def end

	if !ROUND.properties[key] and def != nil then
		ROUND.properties[key] = def
	end

	return ROUND.properties[key]
end

hook.Add( "SLCRoundCleanup", "RoundProperties", function()
	ROUND.properties = {}
	LocalPlayer():ResetProperties( true )
end )

--[[-------------------------------------------------------------------------
GM hooks
---------------------------------------------------------------------------]]
gameevent.Listen( "player_spawn" )
function GM:player_spawn( data )
	local ply = Player( data.userid )
	if !IsValid( ply ) or ROUND.preparing then return end

	if ply != LocalPlayer() then
		RemovePlayerID( ply )
	end
end

local SyncFunctions = {}
function WaitForSync( func )
	table.insert( SyncFunctions, func )
end

local WaitingSync = false
function GM:Tick()
	local ply = LocalPlayer()

	if WaitingSync then
		if WaitingSync == ply:TimeSignature() then
			WaitingSync = false

			local tmp = SyncFunctions --move table to tmp to avoid infinity calling on error
			SyncFunctions = {}

			for k, v in pairs( tmp ) do
				v()
			end
		end
	end

	if FULLY_LOADED and ply:Alive() then
		local t = ply:SCPTeam()
		if t != TEAM_SPEC and t != TEAM_SCP then
			local ct = CurTime()
			if ply:GetStaminaBoost() > ct and ( !ply.NextStaminaHeartbeat or ply.NextStaminaHeartbeat < ct ) then
				ply.NextStaminaHeartbeat = ct + 0.666
				ply:EmitSound( "SLCPlayer.Heartbeat" )
			end
		end
	end
end

net.ReceivePing( "SLCPlayerSync", function( data )
	WaitingSync = tonumber( data )
end )

local color_white = Color( 255, 255, 255 )
local color_lime = Color( 100, 200, 100 )
local color_black = Color( 0, 0, 0 )
local color_gray = Color( 150, 150, 150 )
function GM:OnPlayerChat( ply, text, team, dead )
	if IsValid( ply ) then
		local t = GetPlayerID( ply )
		if ply:SCPTeam() == TEAM_SPEC then
			t = { team = TEAM_SPEC }
		end

		if t and t.team then
			local n = SCPTeams.GetName( t.team )
			chat.AddText( SCPTeams.GetColor( t.team ), "["..( LANG.TEAMS[n] or n ).."] ", color_lime, ply:Nick(), color_white, ": ", text )
		else
			chat.AddText( color_gray, "[???] ", color_lime, ply:Nick(), color_white, ": ", text )
		end
	else
		chat.AddText( color_black, "[CONSOLE] ", color_white, " ", text )
	end

	return true
end

--[[-------------------------------------------------------------------------
Copied from Base Gamemode and edited
---------------------------------------------------------------------------]]
local trace_3rdperson = {}
trace_3rdperson.mask = MASK_SOLID_BRUSHONLY
trace_3rdperson.mins = Vector( -4, -4, -4 )
trace_3rdperson.maxs = Vector( 4, 4, 4 )
trace_3rdperson.output = trace_3rdperson

function CalcThirdPersonView( ply, view, dist, ang )
	if ang then
		view.angles = ang
	end

	trace_3rdperson.start = view.origin
	trace_3rdperson.endpos = view.origin - view.angles:Forward() * ( dist or 100 )

	util.TraceHull( trace_3rdperson )

	view.origin = trace_3rdperson.HitPos
	view.drawviewer = true
end

function GM:CreateMove( cmd )
	
end

hook.Add( "SLCRegisterSettings", "SLCSpeedFOV", function()
	RegisterSettingsEntry( "dynamic_fov", "switch", false )
end )

function GM:CalcView( ply, origin, angles, fov, znear, zfar )
	local view = {}
	view.origin		= origin
	view.angles		= angles
	view.fov		= fov
	view.znear		= znear
	view.zfar		= zfar
	view.drawviewer	= false
	view.no_dynamic = false

	local vehicle = ply:GetVehicle()
	if IsValid( vehicle ) then return hook.Run( "CalcVehicleView", vehicle, ply, view ) end

	player_manager.RunClass( ply, "CalcView", view )

	if controller.CalcView( ply, view ) then return view end

	local weapon = ply:GetActiveWeapon()
	if IsValid( weapon ) and weapon.CalcView then
		local norig, nang, nfov, draw_viewer = weapon:CalcView( ply, origin * 1, angles * 1, fov, view )
		if norig then view.origin = norig end
		if nang then view.angles = nang end
		if nfov then view.fov = nfov end
		if draw_viewer then view.drawviewer = true end
	end

	if !view.no_dynamic and GetSettingsValue( "dynamic_fov" ) then
		local t = ply:SCPTeam()
		if t != TEAM_SPEC and t != TEAM_SCP then
			local fov_add = math.Clamp( Lerp( FrameTime() * 10, ply.LastFOV or 0, ply:GetVelocity():Length() / math.max( 225, ply:GetRunSpeed() ) * 10 ), 0, 15 )
			ply.LastFOV = fov_add
			view.fov = ( view.fov or fov ) - 5 + fov_add
		else
			ply.LastFOV = 0
		end
	else
		ply.LastFOV = 5
	end

	hook.Run( "SLCCalcView", ply, view )

	return view
end

function GM:CalcViewModelView( wep, vm, old_pos, old_ang, pos, ang )
	if !IsValid( wep ) then return end

	local vm_origin, vm_angles = pos, ang

	-- Controls the position of all viewmodels
	local func = wep.GetViewModelPosition
	if ( func ) then
		local new_pos, new_ang = func( wep, pos * 1, ang * 1 )
		vm_origin = new_pos or vm_origin
		vm_angles = new_ang or vm_angles
	end

	-- Controls the position of individual viewmodels
	func = wep.CalcViewModelView
	if ( func ) then
		local new_pos, new_ang = func( wep, vm, old_pos * 1, old_ang * 1, pos * 1, ang * 1 )
		vm_origin = new_pos or vm_origin
		vm_angles = new_ang or vm_angles
	end

	local data = {
		origin = vm_origin,
		angles = vm_angles,
		vm = vm,
	}

	hook.Run( "SLCCalcView", LocalPlayer(), data )

	return data.origin, data.angles
end

function  GM:SetupWorldFog()
	
end

function GM:PreRender()
	/*local lp = LocalPlayer()

	for i, v in ipairs( player.GetAll() ) do
		if v != lp then
			local state = hook.Run( "CanPlayerSeePlayer", lp, v ) == false

			v:SetNoDraw( state )

			local cwep = v:GetActiveWeapon()
			if IsValid( cwep ) then
				cwep:SetNoDraw( state )
			end
		end
	end*/
end

function GM:PrePlayerDraw( ply, flags )
	local lp = LocalPlayer()
	if ply == lp then return end

	if ply:GetNoDraw() or hook.Run( "CanPlayerSeePlayer", lp, ply ) == false then
		return true
	end
end

function GM:CanPlayerSeePlayer( ply, target )
	if ply:GetObserverMode() == OBS_MODE_ROAMING then
		return false
	end
end

local halo_color_ok = Color( 125, 100, 200 )
local halo_color_bad = Color( 200, 100, 100 )
hook.Add( "PreDrawHalos", "PickupWeapon", function()
	local ply = LocalPlayer()
	local t = ply:SCPTeam()
	if t == TEAM_SPEC or t == TEAM_SCP and !ply:GetSCPHuman() then return end

	local wep = ply:GetEyeTrace().Entity
	if !IsValid( wep ) or !wep:IsWeapon() then return end
	if ply:GetPos():DistToSqr( wep:GetPos() ) > 4500 and ply:EyePos():DistToSqr( wep:GetPos() ) > 3700 then return end
	if hook.Run( "WeaponPickupHover", wep ) == true then return end

	local status, msg = hook.Run( "PlayerCanPickupWeapon", ply, wep )
	//print( status, msg )
	if status == false and !msg then return end

	halo.Add( { wep }, status and halo_color_ok or halo_color_bad, 2, 2, 1, true, true )
	HUDPickupHint = wep
	HUDPickupHintMsg = msg
end )

function SLCWindowAlert()
	if !system.HasFocus() then
		system.FlashWindow()
		sound.PlayFile( "sound/common/warning.wav", "", function( igac )
			if IsValid( igac ) then
				igac:Play()
			end
		end )
	end
end

hook.Add( "InitPostEntity", "SLCUpdateStatus", function()
	local ply = LocalPlayer()

	DamageLogger( ply )

	SLCWindowAlert()

	ply.FullyLoaded = true
end )

timer.Simple( 0, function()
	OpenMenuScreen()

	print( "Almost ready! Waiting for additional info..." )

	local timeout = RealTime() + 10
	hook.Add( "Tick", "SLCPlayerReady", function()
		if timeout <= RealTime() then
			hook.Remove( "Tick", "SLCPlayerReady" )

			ErrorNoHalt( "ReadyCheck timed out!\n" )
			_SLCPlayerReady = true
		end

		if NetTablesReceived then
			hook.Remove( "Tick", "SLCPlayerReady" )

			print( "Everything is set up! Updating our status on server...", RealTime() - timeout + 10 )
			_SLCPlayerReady = true
		end
	end )
end )

function MakePlayerReady()
	net.Start( "PlayerReady" )
	net.SendToServer()

	FULLY_LOADED = true
	hook.Run( "PlayerReady", LocalPlayer() )
end

--[[-------------------------------------------------------------------------
DebugInfo
---------------------------------------------------------------------------]]
concommand.Add( "slc_debuginfo_cl", function( ply, cmd, args )
	print( "=== DEBUG INFO ===" )
	print( "Round:" )
	PrintTable( ROUND, 1 )
	print( "Info:" )
	local v = LocalPlayer()
	print( v, v:Nick(), v:SteamID() )
	print( "General info -> ", v:SCPTeam(), v:SCPClass(), v:Alive(), v:IsAFK(), v:GetModel(), v:GetObserverMode(), v:GetObserverTarget() )
	print( "Misc ->" )
	print( "Speed -> ", v:GetWalkSpeed(), v:GetRunSpeed(), v:GetCrouchedWalkSpeed() )
	print( "Inventory ->" )
	PrintTable( v:GetWeapons(), 1 )
	print( "Local Inventory ->" )
	PrintTable( GetLocalInventory(), 1 )
	print( "Weapons debug info ->" )
	for i, wep in ipairs( v:GetWeapons() ) do
		if wep.DebugInfo then
			print( "", wep )
			wep:DebugInfo( 2 )
		end
	end
	print( "SLCVars ->" )
	PrintTable( v.scp_var_table, 1 )
	print( "\tEffects registry ->" )
	PrintTable( v.EFFECTS_REG, 2 )
	print( "\tEffects ->" )
	PrintTable( v.EFFECTS, 2 )
	print( "==================" )
end )