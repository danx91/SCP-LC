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

	if CanShowEQ() then
		local key = input.LookupBinding( "+menu" )

		if key then
			key = string.upper( key )
		else
			key = "+menu"
		end

		//LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( LANG.eq_key, key ) )
	end
end )

timer.Create( "SLCHeartbeat", 2, 0, function()
	if !FULLY_LOADED or !LocalPlayer():Alive() then return end
	if LocalPlayer():SCPTeam() != TEAM_SPEC and LocalPlayer():SCPTeam() != TEAM_SCP then
		if LocalPlayer():Health() < 25 then
			LocalPlayer():EmitSound( "SLCPlayer.Heartbeat" )
		end
	end
end)

--[[-------------------------------------------------------------------------
Screen effects
---------------------------------------------------------------------------]]
local exhaust_mat = GetMaterial( "slc/misc/exhaust.png" )

local stamina_effects = 100
local color_mat = Material( "pp/colour" )
hook.Add( "RenderScreenspaceEffects", "SCPEffects", function()
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

	if ply:Alive() then
		local hp = ply:Health()
		local t = ply:SCPTeam()
		
		if ply:Alive() and t != TEAM_SPEC and t != TEAM_SCP and hp < 25 then
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
		stamina_effects = math.Approach( stamina_effects, ply:GetStamina(), RealFrameTime() * 20 )

		local staminamul = math.Map( math.min( stamina_effects, 30 ), 0, 30, 0.25, 0 )
		clr.contrast = clr.contrast - staminamul
		clr.colour = clr.colour - staminamul * 2

		if stamina_effects <= 30 then
			surface.SetDrawColor( Color( 255, 255, 255, math.Map( math.min( stamina_effects, 30 ), 0, 30, 511, 0 ) ) ) --REVIEW: why 511?
			surface.SetMaterial( exhaust_mat )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end
	end

	hook.Run( "SLCScreenMod", clr )

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
	
	render.SetMaterial( color_mat )
	render.DrawScreenQuad()
end )

--[[-------------------------------------------------------------------------
Blink system
---------------------------------------------------------------------------]]
local blink = false
local endblink = 0
local nextblink = 0

local fade_flag = bit.bor( SCREENFADE.IN, SCREENFADE.OUT )
net.Receive( "PlayerBlink", function( len )
	local duration = net.ReadFloat()
	local delay = net.ReadUInt( 6 )

	if duration > 0 then
		if GetSettingsValue( "smooth_blink" ) then
			LocalPlayer():ScreenFade( fade_flag, Color( 0, 0, 0 ), 0.075, duration )
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
	if !IsValid( ply ) then return end

	if ply != LocalPlayer() then
		RemovePlayerID( ply )
	end
end

local SyncFunctions = {}
function WaitForSync( func )
	table.insert( SyncFunctions, func )
end

local WaitingSync = false
hook.Add( "Tick", "SyncTick", function()
	if WaitingSync then
		if WaitingSync == LocalPlayer():TimeSignature() then
			WaitingSync = false

			local tmp = SyncFunctions --move table to tmp to avoid infinity calling on error
			SyncFunctions = {}

			for k, v in pairs( tmp ) do
				v()
			end
		end
	end
end )

net.ReceivePing( "SLCPlayerSync", function( data )
	WaitingSync = tonumber( data )
end )

function GM:OnPlayerChat( ply, text, team, dead )
	if IsValid( ply ) then
		local t = GetPlayerID( ply )
		if ply:SCPTeam() == TEAM_SPEC then
			t = { team = TEAM_SPEC }
		end

		if t and t.team then
			local n = SCPTeams.GetName( t.team )
			chat.AddText( SCPTeams.GetColor( t.team ), "["..( LANG.TEAMS[n] or n ).."] ", Color( 100, 200, 100 ), ply:Nick(), Color( 255, 255, 255 ), ": ", text )
		else
			chat.AddText( Color( 150, 150, 150 ), "[???] ", Color( 100, 200, 100 ), ply:Nick(), Color( 255, 255, 255 ), ": ", text )
		end
	else
		chat.AddText( Color( 0, 0, 0 ), "[CONSOLE] ", Color( 255, 255, 255 ), " ", text )
	end

	return true
end

--[[-------------------------------------------------------------------------
Copied from Base Gamemode and edited
---------------------------------------------------------------------------]]
function GM:CalcView( ply, origin, angles, fov, znear, zfar )
	local view = {}
	view.origin		= origin
	view.angles		= angles
	view.fov		= fov
	view.znear		= znear
	view.zfar		= zfar
	view.drawviewer	= false

	local vehicle	= ply:GetVehicle()
	if IsValid( vehicle ) then return hook.Run( "CalcVehicleView", vehicle, ply, view ) end

	if drive.CalcView( ply, view ) then return view end

	player_manager.RunClass( ply, "CalcView", view )

	local weapon = ply:GetActiveWeapon()
	if IsValid( weapon )then
		if weapon.CalcView then
			local draw_viewer 
			view.origin, view.angles, view.fov, draw_viewer = weapon:CalcView( ply, origin * 1, angles * 1, fov )

			if draw_viewer then
				view.drawviewer = true
			end
		end
	end

	return view
end

function  GM:SetupWorldFog()
	
end

function GM:PreRender()
	local lp = LocalPlayer()

	for k, v in pairs( player.GetAll() ) do
		if v != lp then
			if hook.Run( "CanPlayerSeePlayer", lp, v ) == false then
				v:SetNoDraw( true )
			else
				v:SetNoDraw( false )
			end
		end
	end
end

hook.Add( "PreDrawHalos", "PickupWeapon", function()
	/*debugoverlay.Axis(trace.HitPos, trace.HitNormal:Angle(), 5, 0.1 )
	debugoverlay.Text(trace.HitPos + Vector( 0, 0, -5 ), tostring(trace.Entity), 0.1 )*/
	local ply = LocalPlayer()
	local t = ply:SCPTeam()
	if t == TEAM_SPEC or ( t == TEAM_SCP and !ply:GetSCPHuman() ) then return end
	local wep = ply:GetEyeTrace().Entity
	if IsValid( wep ) and wep:IsWeapon() then
		if ply:GetPos():DistToSqr( wep:GetPos() ) < 4500 or ply:EyePos():DistToSqr( wep:GetPos() ) < 3700 then
			if !hook.Run( "WeaponPickupHover", wep ) and hook.Run( "PlayerCanPickupWeapon", ply, wep ) != false then
				halo.Add( { wep }, Color( 125, 100, 200 ), 2, 2, 1, true, true )
				HUDPickupHint = wep
			end
		end
	end
end )

hook.Add( "InitPostEntity", "SLCUpdateStatus", function()
	local ply = LocalPlayer()

	DamageLogger( ply )
	PlayerData( ply )

	--if FULLY_LOADED then
		--MakePlayerReady()
	--else
		--CheckContent()
	--end
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
			//MakePlayerReady()
		end

		if NetTablesReceived then
			hook.Remove( "Tick", "SLCPlayerReady" )
			
			print( "Everything is set up! Updating our status on server...", RealTime() - timeout + 10 )
			_SLCPlayerReady = true
			//MakePlayerReady()
		end
	end )
	--MakePlayerReady()
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
	print( "Speed -> ", v:GetWalkSpeed(), v:GetRunSpeed(), v:GetCrouchedWalkSpeed() )
	print( "Inventory ->" )
	PrintTable( v:GetWeapons(), 1 )
	print( "Local Inventory ->" )
	PrintTable( GetLocalWeapons(), 1 )
	print( "SCPVars ->" )
	PrintTable( v.scp_var_table, 1 )
	print( "Misc ->" )
	print( "==================" )
end )