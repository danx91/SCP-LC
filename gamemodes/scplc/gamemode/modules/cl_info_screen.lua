local INFO_SCREEN = {}

/*
text_data = {
	{ 
		text = <string>, --required, text to display
		font = <string>, --optional, default: SCPInfoScreenBig
		offset = <number> -- optional, default: 0
	}
}
*/

local function prepare_text( text_data )
	local letters = 0
	local lines = {}

	//local tab_size = #text_data
	for i, v in ipairs( text_data ) do
		for line in string.gmatch( v.text, "[^\n]+" ) do
			local len, pos = utf8.len( line )
			
			if !len then
				line = "Invalid UTF8 string!"
				len = string.len( line )
			end

			local max = v.max or 43

			if len > max then
				line = utf8.sub( line, 1, max )
				len = max
			end

			len = len + 5

			table.insert( lines, { text = line, length = len, font = v.font or "SCPInfoScreenBig", x_offset = v.x_offset or 0, y_offset = v.y_offset or 0 } )
			letters = letters + len
		end

		-- if i != tab_size then

		-- end
	end

	return lines, letters
end

local function parse_key( data )
	//print( "processing key" )

	local key
	local args = {}
	local i = 1

	for line in string.gmatch( data, "[^;]+" ) do
		//print( "line", line )

		if !key then
			key = RestoreMessage( line )
		else
			args[i] = RestoreMessage( line )
			i = i + 1
		end
	end

	//print( "Finished", key )
	//PrintTable( args )

	if key then
		if #args > 0 then
			if key == "text" then
				return args[1]
			end

			local macro = LANG.info_screen_macro[key]
			if macro then
				return macro( args )
			end
		else
			return LANG.info_screen_registry[key] or ( LANG.info_screen.registry_failed..": "..data )
		end
	end

	return LANG.info_screen.registry_failed..": "..data
end

function InfoScreen( ply, type, duration, data )
	local istab = istable( ply )
	if ply and ply != LocalPlayer() and !istab then return end

	if !ply then
		ply = LocalPlayer()
	end

	//print( ply, istab, ply.class, ply.team )

	local text = {}
	local status

	local class = istab and ply.class or ply:SCPClass()
	local team = SCPTeams.GetName( istab and ply.team or ply:SCPTeam() )

	if type == "spawn" then
		status = LANG.info_screen_type.alive

		if LANG.CLASS_OBJECTIVES[class] then
			text[2] = {
				text = LANG.info_screen.objectives..":",
				font = "SCPInfoScreenMedium",
				x_offset = 0.02,
				y_offset = 0.03,
			}

			text[3] = {
				text = LANG.CLASS_OBJECTIVES[class] or "-",
				font = "SCPInfoScreenMedium",
				x_offset = 0.05,
				max = 48,
			}
		end
	else
		status = LANG.info_screen_type[type]
		local txt

		for i, v in ipairs( data ) do
			//print( "-------------------------" )
			//print( "parsing", i, v )

			if txt then
				txt = txt.."\n- "
			else
				txt = "- "
			end

			if istable( v ) then
				local key
				local args = {}
				local index = 1

				for i, key in ipairs( v ) do
					if !key then
						key = parse_key( key )
					else
						args[index] = parse_key( key )
						index = index + 1
					end
				end

				txt = txt..string.format( table.remove( args, 1 ), unpack( args ) )
			else
				 txt = txt..parse_key( v )
			end

			//print( "parse finished", txt )
		end

		text[2] = {
			text = LANG.info_screen.details..":",
			font = "SCPInfoScreenMedium",
			x_offset = 0.02,
			y_offset = 0.03,
		}

		text[3] = {
			text = txt,
			font = "SCPInfoScreenMedium",
			x_offset = 0.05,
			max = 48,
		}
	end

	text[1] = {
		text = string.format( "%s: %s\n%s: %s\n%s: %s\n%s: %s", LANG.info_screen.subject, LocalPlayer():Nick(), LANG.info_screen.class, ( LANG.CLASSES[class] or class ),
								LANG.info_screen.team, ( LANG.TEAMS[team] or team ), LANG.info_screen.status, status or LANG.info_screen_type.unknown ),
	}

	local lines, num = prepare_text( text )

	local pause = 3
	local min_speed = 22.5 --characters per second
	local full_duration = duration - 0.5

	local show_time = duration - 1
	local write_time = show_time - pause

	//print( "characters per second", num / write_time, write_time )

	if num / write_time < min_speed then
		local newtime = num / min_speed
		pause = show_time - newtime
		//print( "new speed", newtime, pause )
	end

	if true then
		//return
	end

	INFO_SCREEN = {
		lines = lines,
		letters = num,

		end_time = CurTime() + full_duration, --(duration - fadeout) when to finish everything and fade out
		duration = show_time, --fully opaque time //--duration - 4, --duration of writing (full duration - fadein - fadeout - waittime)
		pause_time = pause, --wait
		full_duration = full_duration,

		--only used internally
		show_screen = true,
		calc_text = false,

		done = false,
		time = 0,
		alpha = 0,
		blackout = 0,
		last_char = 0,
	}

	START_TIME_U = CurTime()
	TEXT_U = false
	//print( "Start", CurTime(), 0 )
	util.TimerCycle()
end

local overlay = Material( "slc/misc/info_bg.png" )
local color_white = Color( 255, 255, 255, 255 )

hook.Add( "DrawOverlay", "SLCInfoScreen", function()
	if !INFO_SCREEN.show_screen then return end

	local ct = CurTime()

	if INFO_SCREEN.end_time < ct then
		INFO_SCREEN.done = true
	end

	if ULib then
		if !INFO_SCREEN.done and input.IsMouseDown( MOUSE_LEFT ) and ((ULib and ULib.ucl.query( LocalPlayer(), "slc skipintro" )) or (serverguard and serverguard.player:HasPermission(ply, "Skip intro"))) then
			INFO_SCREEN.done = true
		end
	end

	if !INFO_SCREEN.done then
		if INFO_SCREEN.blackout < 1 then
			if INFO_SCREEN.time == 0 then
				INFO_SCREEN.time = ct + 0.3
			end

			INFO_SCREEN.blackout = 1 - ( INFO_SCREEN.time - ct ) / 0.3

			if INFO_SCREEN.blackout >= 1 then
				INFO_SCREEN.blackout = 1
				INFO_SCREEN.time = 0
			end
		elseif INFO_SCREEN.alpha < 1 then
			if INFO_SCREEN.time == 0 then
				INFO_SCREEN.time = ct + 0.2
			end

			INFO_SCREEN.alpha = 1 - ( INFO_SCREEN.time - ct ) / 0.2

			if INFO_SCREEN.alpha >= 1 then
				INFO_SCREEN.alpha = 1
				INFO_SCREEN.time = 0
			end
		elseif !INFO_SCREEN.calc_text then
			//print( "TextDraw", CurTime(), util.TimerCycle() / 1000 )
			INFO_SCREEN.calc_text = true
		end
	else
		if INFO_SCREEN.alpha > 0 then
			if INFO_SCREEN.time == 0 then
				INFO_SCREEN.time = ct + 0.2
				//print( "FadeOut", CurTime(), util.TimerCycle() / 1000 )
			end

			INFO_SCREEN.alpha = ( INFO_SCREEN.time - ct ) / 0.2

			if INFO_SCREEN.alpha <= 0 then
				INFO_SCREEN.alpha = 0
				INFO_SCREEN.time = 0
				INFO_SCREEN.calc_text = false
			end
		elseif INFO_SCREEN.blackout > 0 then
			if INFO_SCREEN.time == 0 then
				INFO_SCREEN.time = ct + 0.3
			end

			INFO_SCREEN.blackout = ( INFO_SCREEN.time - ct ) / 0.3
			if INFO_SCREEN.blackout <= 0 then
				INFO_SCREEN.blackout = 0
				INFO_SCREEN.time = 0
			end
		else
			INFO_SCREEN.show_screen = false
			//print( "Close", CurTime(), util.TimerCycle() / 1000, CurTime() - START_TIME_U )
		end
	end

	local line = 0
	local pos = 0

	if INFO_SCREEN.calc_text then
		local f = 1 - ( INFO_SCREEN.end_time - ct - INFO_SCREEN.pause_time ) / ( INFO_SCREEN.duration - INFO_SCREEN.pause_time )
		if f >= 1 then
			f = 1

			if !TEXT_U then
				TEXT_U = true
				//print( "TextFinish", CurTime(), util.TimerCycle() / 1000 )
			end
		end

		local chars = math.floor( INFO_SCREEN.letters * f )

		local c = 0
		for i = 1, #INFO_SCREEN.lines do
			local tab = INFO_SCREEN.lines[i]
			c = c + tab.length

			if c > chars then
				line = i - 1
				pos = tab.length - ( c - chars )

				if pos < tab.length - 5 then
					if chars > INFO_SCREEN.last_char then
						INFO_SCREEN.last_char = chars + 2
						//sound.Play( "common/talk.wav", Vector( 0, 0, 0 ), 0, math.random( 100, 120 ), 1 )
						sound.Play( "scp_lc/misc/text_sound.wav", Vector( 0, 0, 0 ), 0, math.random( 100, 120 ), 1 )
					end
				end

				break
			elseif c == chars then
				line = i
				break
			end
		end
	end

	local w, h = ScrW(), ScrH()

	surface.SetDrawColor( Color( 0, 0, 0, INFO_SCREEN.blackout * 255 ) )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( Color( 255, 255, 255, INFO_SCREEN.alpha * 255 ) )
	surface.SetMaterial( overlay )
	surface.DrawTexturedRect( 0, 0, w, h )

	if !INFO_SCREEN.done then
		local pct = 1 - ( INFO_SCREEN.end_time - ct ) / INFO_SCREEN.full_duration
		
		if pct > 1 then
			pct = 1
		end

		surface.SetDrawColor( color_white )
		surface.DrawRect( 0, h - 3, w * pct, 3 )
	end

	local dh = h * 0.29

	if line > 0 then
		for i = 1, line do
			//draw.LimitedText{
			local data = INFO_SCREEN.lines[i]
			local y_offset = h * data.y_offset

			local _, th = draw.Text{
				text = data.text,
				pos = { w * ( 0.07 + data.x_offset ), dh + y_offset },
				font = data.font,
				color = Color( 255, 255, 255, INFO_SCREEN.alpha * 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
				//max_width = w * 0.875
			}

			dh = dh + th + y_offset
		end
	end

	if pos > 0 then
		//draw.LimitedText{
		local data = INFO_SCREEN.lines[line + 1]
		draw.Text{
			text = utf8.sub( data.text, 1, pos ) ,
			pos = { w * ( 0.07 + data.x_offset ), dh + h * data.y_offset },
			font = data.font,
			color = Color( 255, 255, 255, INFO_SCREEN.alpha * 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			//max_width = w * 0.875
		}
	end
end )

/*concommand.Add( "tscr", function()
	InfoScreen( nil, "escape", 12, {
		{ "text;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" },
		{ "text;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" },
		{ "text;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" },
		{ "text;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" },
		{ "text;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" },
		{ "text;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" },
	} )
end )*/