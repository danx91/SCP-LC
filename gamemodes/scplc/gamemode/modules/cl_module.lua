LANG = {}
LANG_FLAGS = 0
LANG_NAME = "undefined"

ROUND = {
	name = "",
	time = 0,
	preparing = false,
	post = false,
	active = false,
}

--[[-------------------------------------------------------------------------
Language system
---------------------------------------------------------------------------]]
local cl_lang = CreateClientConVar( "cvar_slc_language", "default", true, false )
local cur_lang = cl_lang:GetString()

cvars.AddChangeCallback( "gmod_language", function( name, old, new )
	if cl_lang:GetString() == "default" then
		ChangeLang( new )
	end
end, "SCPGMODLang" )

cvars.AddChangeCallback( "cvar_slc_language", function( name, old, new )
	ChangeLang( new )
end, "SCPLang" )

concommand.Add( "slc_language", function( ply, cmd, args )
	RunConsoleCommand( "cvar_slc_language", args[1] )
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tab = {}

	if string.find( "default", args ) then
		table.insert( tab, "slc_language default" )
	end

	for k, v in pairs( _LANG ) do
		if string.find( string.lower( k ), args ) then
			table.insert( tab, "slc_language "..k )
		end
	end

	return tab
end, "" )

local function CheckTable( tab, ref )
	for k, v in pairs( ref ) do
		if istable( v ) then
			if !istable( tab[k] ) then
				tab[k] = table.Copy( v )
			else
				CheckTable( tab[k], v )
			end
		elseif type( tab[k] ) != type( v ) then
			tab[k] = v
		end
	end
end

function ChangeLang( lang, force )
	if !isstring( lang ) then return end
	if !force and cur_lang == lang then return end

	local usedef = false
	local ltu

	if cl_lang:GetString() == "default" then
		lang = GetConVar( "gmod_language" ):GetString()
		usedef = true
	end

	if _LANG[lang] then
		ltu = lang
	else
		ltu = _LANG_ALIASES[lang]
	end

	if !ltu and usedef then
		ltu = _LANG_ALIASES.default
	end

	if !ltu then
		print( "Unknown language: "..lang )

		timer.Simple( 0, function()
			RunConsoleCommand( "cvar_slc_language", cur_lang )
		end )

		return
	end

	if !force and cur_lang == ltu then return end

	cur_lang = ltu
	LANG_NAME = ltu
	LANG_FLAGS = _LANG_FLAGS[ltu]

	print( "Setting language to: "..ltu )

	local tmp = table.Copy( _LANG[ltu] )

	if ltu != _LANG_ALIASES.default then
		CheckTable( tmp, _LANG[_LANG_ALIASES.default] )
	end

	LANG = tmp
end

hook.Add( "SLCFactoryReset", "SLCLanguageReset", function()
	RunConsoleCommand( "slc_language", "default" )
end )

hook.Add( "SLCRegisterSettings", "SLCLanguage", function()
	local tab = {}

	for k, v in pairs( _LANG ) do
		local name = v.self or k

		if v.self_en then
			name = name.." ("..v.self_en..")"
		end

		table.insert( tab, { k, name } )
	end

	RegisterSettingsEntry( "cvar_slc_language", "dropbox", "!CVAR", {
		list = tab,
		parse = function( value )
			if value == "default" then
				return LANG.default	or "default"
			end

			return _LANG_ALIASES[value] or value
		end
	} )
end )

local function PrintTableDiff( tab, ref, stack )
	local wrong, err = 0, 0
	stack = stack or "LANG"

	for k, v in pairs( ref ) do
		if istable( v ) then
			if !istable( tab[k] ) then
				print( "Missing table: "..stack.." > "..k )
				wrong = wrong + 1
			else
				local a_w, a_e = PrintTableDiff( tab[k], v, stack.." > "..k )
				wrong = wrong + a_w
				err = err + a_e
			end
		elseif tab[k] == nil then
			print( "Missing value: "..stack.." > "..k )
			wrong = wrong + 1
		else
			local ref_t = type( v )
			local tab_t = type( tab[k] )

			if ref_t != tab_t then
				print( "Wrong type: "..stack.." > "..k.." ("..ref_t.." expected, got "..tab_t..")" )
				err = err + 1
			end
		end
	end

	return wrong, err
end

local function PrintRevDiff( tab, ref, stack )
	local num = 0
	stack = stack or "LANG"

	for k, v in pairs( tab ) do
		if istable( v ) and istable( ref[k] ) then
				num = num + PrintRevDiff( v, ref[k], stack.." > "..k )
		elseif ref[k] == nil then
			print( "Redundant value: "..stack.." > "..k )
			num = num + 1
		end
	end

	return num
end

concommand.Add( "slc_diff_language", function( ply, cmd, args )
	local lang_name = args[1]
	if !isstring( lang_name ) then return end

	local lang = _LANG[lang_name]
	local default = _LANG[_LANG_ALIASES.default]

	if lang and default then
		print( "#####################################################################" )
		local wrong, err = PrintTableDiff( lang, default )
		local num = PrintRevDiff( lang, default )
		print( "#####################################################################" )
		print( "Language diff: "..lang_name )
		print( "Total missing values or tables: "..wrong )
		print( "Total errors: "..err )
		print( "Total redundant values: "..num )
		print()
		print( "Check logs above for details" )
		print( "#####################################################################" )
	end
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tab = {}

	if string.find( "default", args ) then
		table.insert( tab, "slc_diff_language default" )
	end

	for k, v in pairs( _LANG ) do
		if string.find( string.lower( k ), args ) then
			table.insert( tab, "slc_diff_language "..k )
		end
	end

	return tab
end, "" )

--[[-------------------------------------------------------------------------
Credits
---------------------------------------------------------------------------]]
timer.Create( "Credits", 300, 0, function()
	print( "'SCP: Lost Control' by danx91 [ZGFueDkx] version "..VERSION.." ("..DATE..")" )

	/*if CanShowEQ() then
		local key = input.LookupBinding( "+menu" )

		if key then
			key = string.upper( key )
		else
			key = "+menu"
		end

		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( LANG.eq_key, key ) )
	end*/
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
local exhaust_mat = GetMaterial( "slc/misc/exhaust.png" )

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
	local delay = net.ReadUInt( 6 )

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

	hook.Run( "SLCBlink", duration, delay )
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
Commands
---------------------------------------------------------------------------]]
--

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

	local vehicle	= ply:GetVehicle()
	if IsValid( vehicle ) then return hook.Run( "CalcVehicleView", vehicle, ply, view ) end

	if drive.CalcView( ply, view ) then return view end

	player_manager.RunClass( ply, "CalcView", view )

	local weapon = ply:GetActiveWeapon()
	if IsValid( weapon )then
		if weapon.CalcView then
			local norig, nang, nfov, draw_viewer = weapon:CalcView( ply, origin * 1, angles * 1, fov, view )
			if norig then view.origin = norig end
			if nang then view.angles = nang end
			if nfov then view.fov = nfov end
			if draw_viewer then view.drawviewer = true end
		end
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

	for k, v in pairs( player.GetAll() ) do
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
local halo_color_bad = Color( 200, 100, 100)
hook.Add( "PreDrawHalos", "PickupWeapon", function()
	local ply = LocalPlayer()
	local t = ply:SCPTeam()
	if t == TEAM_SPEC or ( t == TEAM_SCP and !ply:GetSCPHuman() ) then return end

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
	PlayerData( ply )

	SLCWindowAlert()

	ply.FullyLoaded = true
end )

timer.Simple( 0, function()
	ChangeLang( cur_lang, true )
	OpenMenuScreen()

	print( "Almost ready! Waiting for additional info..." )

	local timeout
	hook.Add( "Tick", "SLCPlayerReady", function()
		if !timeout then
			timeout = RealTime() + 10
		end

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
	PrintTable( GetLocalWeapons(), 1 )
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