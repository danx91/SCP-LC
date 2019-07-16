LANG = {}
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
		elseif tab[k] == nil then
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

	print( "Setting language to: "..ltu )

	local tmp = table.Copy( _LANG[ltu] )

	if ltu != _LANG_ALIASES.default then
		CheckTable( tmp, _LANG[_LANG_ALIASES.default] )
	end

	LANG = tmp
end

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

		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( LANG.eq_key, key ) )
	end
end )

/*timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		if LocalPlayer():Health() < 30 then
			LocalPlayer():EmitSound("heartbeat.ogg")
		end
	end
end)*/

/*net.Receive( "689", function( len )
	if LocalPlayer():GetNClass() == ROLES.ROLE_SCP689 then
		local targets = net.ReadTable()
		if targets then
			local swep = LocalPlayer():GetWeapon( "weapon_scp_689" )
			if IsValid( swep ) then
				swep.Targets = targets
			end
		end
	end
end )*/

--[[-------------------------------------------------------------------------
Screen effects
---------------------------------------------------------------------------]]
Material( "slc/blind.png" )
local blind_mat = CreateMaterial( "mat_SCP_blind", "UnlitGeneric", {
	["$basetexture"] = "slc/blind.png",
	["$additive"] = "1",
} )

local exhaust_mat = GetMaterial( "slc/exhaust.png" )

local stamina_effects = 100
local color_mat = Material( "pp/colour" )
hook.Add( "RenderScreenspaceEffects", "SCPEffects", function()
	local ply = LocalPlayer()
	
	/*if LocalPlayer().mblur == nil then LocalPlayer().mblur = false end
	if ( LocalPlayer().mblur == true ) then
		DrawMotionBlur( 0.3, 0.8, 0.03 )
	end*/
	
	/*if LocalPlayer().n420endtime and LocalPlayer().n420endtime > CurTime() then
		DrawMotionBlur( 1 - ( LocalPlayer().n420endtime - CurTime() ) / 15 , 0.3, 0.025 )
		DrawSharpen( ( LocalPlayer().n420endtime - CurTime() ) / 3, ( LocalPlayer().n420endtime - CurTime() ) / 20 )
		clr_r = ( LocalPlayer().n420endtime - CurTime() ) * 2
		clr_g = ( LocalPlayer().n420endtime - CurTime() ) * 2
		clr_b = ( LocalPlayer().n420endtime - CurTime() ) * 2
	end*/

	/*if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
			nvgbrightness = 0.2
			DrawSobel( 0.7 )
		end
	end*/
	
	/*if LocalPlayer():Health() < 30 and LocalPlayer():Alive() then
		colour = math.Clamp((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 5, 0, 2)
		DrawMotionBlur( 0.27, 0.5, 0.01 )
		DrawSharpen( 1,2 )
		DrawToyTown( 3, ScrH() / 1.8 )
	end*/

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

	if ply.Stamina then
		stamina_effects = math.Approach( stamina_effects, ply.Stamina, RealFrameTime() * 20 )

		local staminamul = math.Map( math.min( stamina_effects, 30 ), 0, 30, 0.25, 0 )
		clr.contrast = clr.contrast - staminamul
		clr.colour = clr.colour - staminamul * 2

		if stamina_effects <= 30 then
			surface.SetDrawColor( Color( 255, 255, 255, math.Map( math.min( stamina_effects, 30 ), 0, 30, 511, 0 ) ) )
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

	//DrawBloom( Darken, Multiply, SizeX, SizeY, Passes, ColorMultiply, Red, Green, Blue )
	//DrawBloom( 0.65, bloommul, 9, 9, 1, 1, 1, 1, 1 )
end )

--[[-------------------------------------------------------------------------
Blink system
---------------------------------------------------------------------------]]
local blink = false
local endblink = 0
local nextblink = 0

net.Receive( "PlayerBlink", function( len )
	local duration = net.ReadFloat()

	if duration > 0 then
		blink = true
	end

	endblink = CurTime() + duration

	local delay = net.ReadUInt( 6 )
	nextblink = CurTime() + delay

	HUDNextBlink = nextblink 
	HUDBlink = delay - duration
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

hook.Add( "PostDrawHUD", "Blink", function()
	if blink then
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.SetMaterial( blink_mat )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	end
end )

--[[-------------------------------------------------------------------------
Player message
---------------------------------------------------------------------------]]
CENTERINFO = {}

local function add_text( txt, clr, c )
	if c then
		CENTERINFO = { text = txt, color = clr or Color( 255, 255, 255 ), time = CurTime() + 3 }
	else
		if color then
			chat.AddText( clr, txt )
		else
			chat.AddText( txt )
		end
	end
end

function PlayerMessage( msg, ply, center )
	if ply and ply != LocalPlayer() then return end

	//print( msg )
	local color = nil
	local nmsg, cr, cg, cb = string.match( msg, "^(.+)%#(%d+)%,(%d*)%,(%d*)$" )
	if nmsg then
		cg = tonumber( cg ) or cr
		cb = tonumber( cb ) or cr

		msg = nmsg
		color = Color( cr, cg, cb )
	end

	local name, func = string.match( msg, "^(.+)$(.+)" )
	local rawtext = ""
	
	if name then
		local args = {}

		for v in string.gmatch( func, "[^,]+" ) do
			local raw = string.match( v, "raw:(.+)" )
			if raw then
				rawtext = string.gsub( raw, "%.", "," )
				continue
			end

			local tabinfo, key = string.match( v, "^@(.+):(.+)$" )
			if !tabinfo then
				key = string.match( v, "@(.+)" )
			end

			if tabinfo or key then
				local tab = LANG

				if tabinfo then
					for subtable in string.gmatch( tabinfo, "[^.]+" ) do
						if !tab[subtable] then
							break
						end

						tab = tab[subtable]
					end
				end

				table.insert( args, tab[key] or key )
			else
				table.insert( args, v )
			end
		end

		local translated = LANG.NRegistry[name]
		local text = ""

		if !translated then
			text = string.format( LANG.NFailed, name )
		else
			translated = string.gsub( translated, "%[RAW%]", rawtext )
		 	text = string.format( translated, unpack( args ) )
		end

		add_text( text, color, center )
		print( text )
	else
		local text = LANG.NRegistry[msg] or string.format( LANG.NFailed, msg )

		add_text( text, color, center )
		print( text )
	end
end

hook.Add( "HUDPaint", "CenterPlayerMessage", function()
	if CENTERINFO.text then
		if CENTERINFO.time < CurTime() then
			CENTERINFO = {}
			return
		end

		draw.Text{
			text = CENTERINFO.text,
			pos = { ScrW() * 0.5, ScrH() * 0.2 },
			color = CENTERINFO.color,
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
end )

--[[-------------------------------------------------------------------------
CenterMessage
---------------------------------------------------------------------------]]
CENTERMESSAGES = {}
function CenterMessage( msg, ply )
	if ply and ply != LocalPlayer() then return end

	local gfont = "SCPHUDMedium"
	local time = 10
	local lines = {}

	for s in string.gmatch( msg, "[^;]+" ) do
		local line = {}

		local g = string.match( s, "^font:([%w%p]+)$" )
		if g then
			gfont = g
			continue
		end

		local t = string.match( s, "^time:(%d+)$" )
		if t then
			time = t
			continue
		end

		local nmsg, cr, cg, cb, f = string.match( s, "^(.+)%#(%d*),(%d*),(%d*),([%w%p]*)$" )

		if nmsg then
			cr = tonumber( cr )

			if cr then
				line.color = Color( cr, tonumber( cg ) or cr, tonumber( cb ) or cr )
			end

			if f and f != "" then
				line.font = f or font
			end

			s = nmsg
		end

		local name, func = string.match( s, "^(.+)$(.+)" )
		local rawtext = ""
	
		if name then
			local args = {}

			for v in string.gmatch( func, "[^,]+" ) do
				local raw = string.match( v, "raw:(.+)" )
				if raw then
					rawtext = string.gsub( raw, "%.", "," )
					continue
				end

				local tabinfo, key = string.match( v, "^@(.+):(.+)$" )
				if !tabinfo then
					key = string.match( v, "@(.+)" )
				end

				if tabinfo or key then
					local tab = LANG

					if tabinfo then
						for subtable in string.gmatch( tabinfo, "[^.]+" ) do
							if !tab[subtable] then
								break
							end

							tab = tab[subtable]
						end
					end

					table.insert( args, tab[key] or key )
				else
					table.insert( args, v )
				end
			end

			local translated = LANG.NCRegistry[name]

			if translated then
				translated = string.gsub( translated, "%[RAW%]", rawtext )
			 	line.txt = string.format( translated, unpack( args ) )
			end
		else
			local text = LANG.NCRegistry[s]
			if text then
				line.txt = text
			end
		end

		if line.txt and line.txt != "" then
			table.insert( lines, line )
		end
	end

	table.insert( CENTERMESSAGES, { time = CurTime() + time, font = gfont, lines = lines } )
end

hook.Add( "HUDPaint", "CenterMessage", function()
	if #CENTERMESSAGES > 0 then
		local msg = CENTERMESSAGES[1]
		if msg.time < CurTime() then
			table.remove( CENTERMESSAGES, 1 )
			return
		end

		local w, h = ScrW(), ScrH()

		local y = h * 0.075
		for k, v in pairs( msg.lines ) do
			local _, th = draw.Text{
				text = v.txt,
				pos = { w * 0.5, y },
				color = v.color or Color( 255, 255, 255 ),
				font = v.font or msg.font,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			}

			y = y + th
		end
	end
end )
--[[-------------------------------------------------------------------------
?
---------------------------------------------------------------------------]]
/*function DropCurrentWeapon()
	if dropnext > CurTime() then return true end
	dropnext = CurTime() + 0.5
	net.Start("DropCurWeapon")
	net.SendToServer()
	if LocalPlayer().channel != nil then
		LocalPlayer().channel:EnableLooping( false )
		LocalPlayer().channel:Stop()
		LocalPlayer().channel = nil
	end
	return true
end*/

hook.Add( "HUDWeaponPickedUp", "DonNotShowCards", function( weapon )
	//EQHUD.weps = LocalPlayer():GetWeapons()
	//if weapon:GetClass() == "br_keycard" then return false end
end )

--[[-------------------------------------------------------------------------
Sound functions
---------------------------------------------------------------------------]]
local PrecachedSounds = {}
function ClientsideSound( file, ent )
	ent = ent or game.GetWorld()
	local sound

	if !PrecachedSounds[file] then
		sound = CreateSound( ent, file, nil )
		PrecachedSounds[file] = sound

		return sound
	else
		sound = PrecachedSounds[file]
		sound:Stop()

		return sound
	end
end

net.Receive( "PlaySound", function( len )
	local com = net.ReadBool()
	local vol = net.ReadFloat()
	local f = net.ReadString()

	if com then
		local snd = ClientsideSound( f )
		snd:SetSoundLevel( 0 )
		snd:Play()
		snd:ChangeVolume( vol )
	else
		ClientsideSound( f )
	end
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
		removePlayerID( ply )
	end
end

/*gameevent.Listen( "entity_killed" )
function GM:entity_killed( data )
	local inflictor = Entity( data.entindex_inflictor )
	local attacker = Entity( data.entindex_attacker )
	local victim = Entity( data.entindex_killed )

	if victim == LocalPlayer() then
		clearPlayerIDs()
	end
end*/

function GM:OnPlayerChat( ply, text, team, dead )
	if IsValid( ply ) then
		local t = getPlayerID( ply )
		if ply:SCPTeam() == TEAM_SPEC then
			t = { team = TEAM_SPEC }
		end

		if t and t.team then
			local n = SCPTeams.getName( t.team )
			name = LANG.TEAMS[n] or n
			clr = SCPTeams.getColor( t.team )

			chat.AddText( clr, "["..name.."] ", Color( 100, 200, 100 ), ply:Nick(), Color( 255, 255, 255 ), ": ", text )
		else
			chat.AddText( Color( 150, 150, 150 ), "[???] ", Color( 100, 200, 100 ), ply:Nick(), Color( 255, 255, 255 ), ": ", text )
		end
	else
		chat.AddText( Color( 0, 0, 0 ), "[CONSOLE] ", Color( 255, 255, 255 ), " ", text )
	end

	return true
end

function GM:CalcView( ply, origin, angles, fov )
	local data = {}
	data.origin = origin
	data.angles = angles
	data.fov = fov
	data.drawviewer = false

	local item = ply:GetActiveWeapon()
	if IsValid( item ) then
		if item.CalcView then
			local vec, ang, nfov, dw = item:CalcView( ply, origin, angles, fov )
			if vec then data.origin = vec end
			if ang then data.angles = ang end
			if nfov then data.fov = ifov end
			if dw != nil then data.drawviewer = dw end
		end
	end

	/*if CamEnable then
		--print( "enabled" )
		if !timer.Exists( "CamViewChange" ) then
			timer.Create( "CamViewChange", 1, 1, function()
				CamEnable = false
			end )
		end
		data.drawviewer = true
		dir = dir or Vector( 0, 0, 0 )
		--print( dir )
		data.origin = ply:GetPos() - dir - dir:GetNormalized() * 30 + Vector( 0, 0, 80 )
		data.angles = Angle( 10, dir:Angle().y, 0 )
	end*/

	//data = HeadBob( ply, data )

	return data
end

/*function GetWeaponLang()
	if cwlang then
		return cwlang
	end
end*/

function  GM:SetupWorldFog()
	/*if LocalPlayer():GetNClass() == ROLES.ROLE_SCP9571 then
		if OUTSIDE_BUFF and OUTSIDE_BUFF( ply:GetPos() ) then return end
		render.FogMode( MATERIAL_FOG_LINEAR )
		render.FogColor( 0, 0, 0 )
		render.FogStart( 250 )
		render.FogEnd( 500 )
		render.FogMaxDensity( 1 )
		return true
	end

	if !Effect957 then return end

	if Effect957Mode == 0 then
		if Effect957Density < 1 then
			Effect957Density = math.Clamp( math.abs( Effect957 - CurTime() ), 0, 1 )
		elseif Effect957Density >= 1 then
			Effect957 = CurTime() + 3
			Effect957Mode = 1
		end
	elseif Effect957Mode == 1 then
		Effect957Density = 1
		if Effect957 < CurTime() then
			Effect957 = CurTime() + 1
			Effect957Mode = 2
		end
	else
		Effect957Density = math.Clamp( Effect957 - CurTime(), 0, 1 )
		if Effect957Density == 0 then
			Effect957 = false
			Effect957Mode = 0
		end
	end



	render.FogMode( MATERIAL_FOG_LINEAR )
	render.FogColor( 0, 0, 0 )
	render.FogStart( 50 )
	render.FogEnd( 250 )
	render.FogMaxDensity( Effect957Density )
	return true*/
end

/*Effect957 = false
Effect957Density = 0
Effect957Mode = 0
net.Receive( "957Effect", function( len )
	local status = net.ReadBool()
	if status then
		Effect957 = CurTime()
		Effect957Mode = 0
	elseif Effect957 then
		//Effect957 = false
		Effect957Mode = 2
		Effect957 = CurTime() + 1
	end
end )*/

hook.Add( "PreDrawHalos", "PickupWeapon", function()
	local ply = LocalPlayer()

	local t = ply:SCPTeam()
	if t == TEAM_SPEC or t == TEAM_SCP then return end

	local wep = ply:GetEyeTrace().Entity
	if IsValid( wep ) and wep:IsWeapon() then
		if !ply:HasWeapon( wep:GetClass() ) and ( ply:GetPos():DistToSqr( wep:GetPos() ) < 4500 or ply:EyePos():DistToSqr( wep:GetPos() ) < 3700 ) then
			if !hook.Run( "WeaponPickupHover", wep ) and hook.Run( "PlayerCanPickupWeapon", ply, wep ) != false then
				halo.Add( { wep }, Color( 125, 100, 200 ), 2, 2, 1, true, true )
				HUDPickupHint = wep
			end
		end
	end
end )

timer.Simple( 0, function()
	ChangeLang( cur_lang, true )

	net.Start( "PlayerReady" )
	net.SendToServer()
end )