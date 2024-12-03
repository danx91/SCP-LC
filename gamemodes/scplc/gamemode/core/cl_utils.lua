local color_white = Color( 255, 255, 255 )
--[[-------------------------------------------------------------------------
Player message
---------------------------------------------------------------------------]]
CENTERINFO = {}

local function add_text( txt, clr, c )
	if c then
		CENTERINFO = { text = txt, color = clr or color_white, time = CurTime() + 3 }
	else
		if clr then
			chat.AddText( clr, txt )
		else
			chat.AddText( txt )
		end
	end
end

/*---------------------------------------------------------------------------
PlayerMessage( msg, ply, center )

Powerful function that draws translated text in chat or on screen center (will always last for 3 seconds, and new message will replace old one)

@param 		[string] 		msg 		The message. Message structure is described below.
@param 		[Player] 		ply 		This argument is only for shared usage compatibility.
										In order to work, must be nil or local player
@param 		[boolean] 		center 		If true, message will be drawn on the center of screen

@return 	[nil]			- 			-


Message structure:
	1. Message base: "nregistry_key" - the only required part of message
	2. Color: "rest_of_message#r,g,b" where r, g and b are numbers in range 0-255. Color, if used, must be last part of message
	3. Text formating: "nregistry_key$value1,value2" is equivalent to string.format( "nregistry_value", value1, value2 )
	4. Accessing LANG table: a @ character can be used to access LANG table (instead of nregistry_key or insted of value afte '$')
	Example: "nregistry_key$value1,@sometab.somevalue" is equal to string.format( "nregistry_value", value1, LANG.sometab.somevalue )
	5. RAW text: if one of arguments after '$' will be 'raw:sometext' then 'sometext' will be saved as RAW text. After processing whole message
	every '[RAW]' markdown will be replaced with RAW text. NOTE: Every '.' in RAW text will be replaced with ','
---------------------------------------------------------------------------*/
function PlayerMessage( msg, ply, center )
	if ply and ply != LocalPlayer() then return end

	//print( msg )
	local color = nil
	local nmsg, cr, cg, cb = string.match( msg, "^(.-)%#(%d+)%,(%d*)%,(%d*)$" )
	if nmsg then
		cr = tonumber( cr )

		if cr then
			color = Color( cr, tonumber( cg ) or cr, tonumber( cb ) or cr )
		end

		msg = nmsg
	end

	local name, func = string.match( msg, "^(.-)$(.+)" )
	local rawtext = ""

	if name then
		local args = {}

		for v in string.gmatch( func, "[^,]+" ) do
			local raw = string.match( v, "raw:(.+)" )
			if raw then
				rawtext = string.gsub( raw, "%.", "," )
				continue
			end
			
			local tabinfo = string.match( v, "^@(.+)$" )
			if tabinfo then
				local tab = LANG

				if tabinfo then
					for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
						if !istable( tab ) or !tab[subtable] then
							break
						end

						tab = tab[subtable]
					end
				end

				table.insert( args, !istable( tab ) and tab or tabinfo )
			else
				table.insert( args, v )
			end
		end

		local translated
		local tabinfo = string.match( name, "^@(.+)$" )
		if tabinfo then
			local tab = LANG

			if tabinfo then
				for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
					if !istable( tab ) or !tab[subtable] then
						break
					end

					tab = tab[subtable]
				end
			end

			if !istable( tab ) then
				translated = tab
			end
		else
			translated = LANG.NRegistry[name]
		end

		local text = ""
		if !translated then
			text = string.format( LANG.NFailed, tostring( name ) )
		else
			translated = string.gsub( translated, "%[RAW%]", rawtext )
		 	text = string.format( translated, unpack( args ) )
		end

		text = RestoreMessage( text )

		add_text( text, color, center )
		print( text )
	else
		local text
		local tabinfo = string.match( msg, "^@(.+)$" )
		if tabinfo then
			local tab = LANG

			if tabinfo then
				for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
					if !istable( tab ) or !tab[subtable] then
						break
					end

					tab = tab[subtable]
				end
			end

			if !istable( tab ) then
				text = tab
			end
		else
			text = LANG.NRegistry[msg]
		end

		if !text then
			text = string.format( LANG.NFailed, tostring( msg ) )
		end

		text = RestoreMessage( text )

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
			pos = { ScrW() * 0.5, ScrH() * 0.4 },
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

/*---------------------------------------------------------------------------
CenterMessage( msg, ply )

Powerful function that draws translated text on screen center.
Time, font and default font can be changed. Also supports multiline disaplay. New messages are queued.

@param 		[string] 		msg 		The message. Message structure is described below.
@param 		[Player] 		ply 		This argument is only for shared usage compatibility.
										In order to work, must be nil or local player

@return 	[nil]			- 			-


Message structure:
	(first 5 points are same as in PlayerMessage)
	1. Message base: "ncregistry_key" - the only required part of message
	2. Color and font: "rest_of_message#r,g,b,font" where r, g and b are numbers in range 0-255, font is optional. If used, must be last part of message
	3. Text formating: "ncregistry_key$value1,value2" is equivalent to string.format( "ncregistry_value", value1, value2 )
	4. Accessing LANG table: a @ character can be used to access LANG table (instead of ncregistry_key or insted of value afte '$')
	Example: "ncregistry_key$value1,@sometab.somevalue" is equal to string.format( "ncregistry_value", value1, LANG.sometab.somevalue )
	5. RAW text: if one of arguments after '$' will be 'raw:sometext' then 'sometext' will be saved as RAW text. After processing whole message
	every '[RAW]' will be replaced with RAW text. NOTE: Every '.' in RAW text will be replaced with ','

	6.Every line of text is separated by ';'. Example: 'ncregistry_key$value1,value2;another_ncregistry_key$value3' will display 2 text rows
	7. Special arguments are: 'font:font_name' to override default font for whole message, 'time:number' to override display time in seconds (default: 10)
	Example: 'ncregistry_key$value1,value2#255,0,0;another_ncregistry_key$value3;3rd_ncregistry_key#0,0,255,Font2';font:Font1 - 1st and 2nd row will be drawn with Font1,
	3rd one with Font2
	8. Each text line can specify font override. See example above
---------------------------------------------------------------------------*/
function CenterMessage( msg, ply )
	if ply and ply != LocalPlayer() then return end

	local gfont = "SCPHUDMedium"
	//local gcolor = Color( 255, 255, 255 )
	local time = 10
	local yoffset = 0
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
			time = tonumber( t )
			continue
		end

		local yoff = string.match( s, "^offset:(-?%d+)$" )
		if yoff then
			yoffset = tonumber( yoff ) / 1000
			continue
		end

		/*local gclr = string.match( s, "^offset:(%d+)$" )
		if gclr then
			
		end*/

		local nmsg, cr, cg, cb, f = string.match( s, "^(.-)%#(%d*),(%d*),(%d*),([%w%p]*)$" )

		if !nmsg then
			nmsg, cr, cg, cb = string.match( s, "^(.-)%#(%d*),(%d*),(%d*)$" )
		end

		if nmsg then
			cr = tonumber( cr )

			if cr then
				line.color = Color( cr, tonumber( cg ) or cr, tonumber( cb ) or cr )
			end

			if f and f != "" then
				line.font = f or gfont
			end

			s = nmsg
		end

		local name, func = string.match( s, "^(.-)$(.+)" )
		local rawtext = ""

		if name then
			local args = {}

			for v in string.gmatch( func, "[^,]+" ) do
				local raw = string.match( v, "raw:(.+)" )
				if raw then
					rawtext = string.gsub( raw, "%.", "," )
					continue
				end

				local tabinfo = string.match( v, "^@(.+)$" )
				if tabinfo then
					local tab = LANG

					if tabinfo then
						for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
							if !istable( tab ) or !tab[subtable] then
								break
							end

							tab = tab[subtable]
						end
					end

					table.insert( args, !istable( tab ) and tab or tabinfo )
				else
					table.insert( args, v )
				end
			end

			local translated
			local tabinfo = string.match( name, "^@(.+)$" )
			if tabinfo then
				local tab = LANG

				if tabinfo then
					for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
						if !istable( tab ) or !tab[subtable] then
							break
						end

						tab = tab[subtable]
					end
				end

				if !istable( tab ) then
					translated = tab
				end
			else
				translated = LANG.NCRegistry[name]
			end

			if translated then
				translated = string.gsub( translated, "%[RAW%]", rawtext )
			 	line.txt = string.format( translated, unpack( args ) )
			else
				print( string.format( LANG.NCFailed, tostring( name ) ) )
			end
		else
			local text
			local tabinfo = string.match( s, "^@(.+)$" )
			if tabinfo then
				local tab = LANG

				if tabinfo then
					for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
						if !istable( tab ) or !tab[subtable] then
							break
						end

						tab = tab[subtable]
					end
				end

				if !istable( tab ) then
					text = tab
				end
			else
				text = LANG.NCRegistry[s]
			end

			if text then
				line.txt = text
			else
				print( string.format( LANG.NCFailed, tostring( s ) ) )
			end
		end

		if line.txt and line.txt != "" then
			line.txt = RestoreMessage( line.txt )
			table.insert( lines, line )
		end
	end

	table.insert( CENTERMESSAGES, { time = 0, duration = time, font = gfont, yoffset = yoffset, lines = lines } )
end

hook.Add( "HUDPaint", "CenterMessage", function()
	if #CENTERMESSAGES > 0 then
		local msg = CENTERMESSAGES[1]
		local time = msg.time

		if time == 0 then
			msg.time = CurTime() + msg.duration
		elseif time < CurTime() then
			table.remove( CENTERMESSAGES, 1 )
			return
		end

		local w, h = ScrW(), ScrH()

		local y = h * ( 0.3 + msg.yoffset )
		for k, v in pairs( msg.lines ) do
			local _, th = draw.Text{
				text = v.txt,
				pos = { w * 0.5, y },
				color = v.color or color_white,
				font = v.font or msg.font,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			}

			y = y + th
		end
	end
end )

function util.ParseLangKey( key )
	if !key then return end

	local tabinfo, args = string.match( key, "^@(.+):(.+)$" )
	if !tabinfo then
		tabinfo = string.match( key, "^@(.+)$" ) or key
	end

	local tab = LANG

	if tabinfo then
		for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
			if !istable( tab ) then
				break
			end

			tab = tab[subtable]
		end

		if isstring( tab ) then
			if args then
				tab = string.format( tab, unpack( string.Explode( ",", args ) ) )
			end

			return tab
		end
	end

	return tabinfo
end

--[[-------------------------------------------------------------------------
Wheel menu
---------------------------------------------------------------------------]]
local wheel_visible = false
local wheel_options = {}
local wheel_cb, wheel_sc

--[[-------------------------------------------------------------------------
OpenWheelMenu( options, cb, sc )

Wheel menu. Used by SCP 049

@param		[table]			options
{
	@param		[table]			
	{
		@param		[string]		mat					Path to material
		@param		[string]		name				Display name of option
		@param		[string]		desc				Description
		@param		[any]			data				Any value that is passed to callback
	}
	...
}
@param		[function]		cb					Optional: Called when option is selected - value from selected option is passed
@param		[function]		sc					Optional: Called each frame - return true to close wheel menu

@return		[nil]			-					-
-------------------------------------------------------------------------]]--
function OpenWheelMenu( options, cb, sc, exmat )
	if wheel_visible then return end

	wheel_options = table.Copy( options )
	table.insert( wheel_options, 1, {
		mat = exmat,
		name = LANG.exit
	} )

	local max_w = ScrW() * 0.25
	for i, v in ipairs( wheel_options ) do
		if !v.desc then continue end

		v.desc = markup.Parse( "<font=SCPHUDSmall>"..v.desc.."</font>", max_w )
	end

	wheel_cb = cb
	wheel_sc = sc
	wheel_visible = true
	gui.EnableScreenClicker( true )
end

--[[-------------------------------------------------------------------------
CloseWheelMenu()

Close wheel menu. Will trigger callback.


@return		[nil]			-					-
-------------------------------------------------------------------------]]--
function CloseWheelMenu()
	if !wheel_visible then return end

	local x, y = input.GetCursorPos()
	local w, h = ScrW(), ScrH()
	local selected = 1

	local dx, dy = x - w * 0.5,  -y + h * 0.5
	local min_dist = w * 0.02

	if dx * dx + dy * dy >= min_dist * min_dist then
		local ca = math.deg( math.atan2( dx, dy ) )

		if ca < 0 then
			ca = 360 + ca
		end

		selected = math.floor( ca * #wheel_options / 360 ) + 1
	end

	if wheel_cb then
		wheel_cb( wheel_options[selected].data )
	end

	wheel_visible = false
	wheel_options = {}
	gui.EnableScreenClicker( false )
end

hook.Add( "Think", "SLCWheelMenu", function()
	if wheel_visible and isfunction( wheel_sc ) then
		if wheel_sc() then
			wheel_visible = false
			wheel_options = {}
			gui.EnableScreenClicker( false )
		end
	end
end )

hook.Add( "HUDPaint", "SLCWheelMenu", function()
	if !wheel_visible then return end

	local x, y = input.GetCursorPos()
	local w, h = ScrW(), ScrH()
	local selected = 1

	local dx, dy = x - w * 0.5,  -y + h * 0.5
	local min_dist = w * 0.02

	if dx * dx + dy * dy >= min_dist * min_dist then
		local ca = math.deg( math.atan2( dx, dy ) )

		if ca < 0 then
			ca = 360 + ca
		end

		selected = math.floor( ca * #wheel_options / 360 ) + 1
	end

	local seg = #wheel_options
	local ang = 360 / seg
	local inner = w * 0.1
	local thickness = w * 0.055
	local outer = inner + thickness
	local cx, cy = w * 0.5, h * 0.5

	for i = 1, seg do
		local tab = wheel_options[i]

		if i == selected then
			surface.SetDrawColor( 100, 100, 100 )
		else
			surface.SetDrawColor( 50, 50, 50 )
		end
		
		draw.NoTexture()
		surface.DrawRing( cx, cy, inner, thickness, ang, 40, 2, ang * ( i - 1 ) )

		local la = math.rad( ang * ( i - 1 ) )
		local dlx, dly = math.sin( la ), -math.cos( la )

		surface.SetDrawColor( 200, 200, 200 )
		surface.DrawLine( cx + dlx * inner, cy + dly * inner, cx + dlx * outer, cy + dly * outer )
		
		if tab.mat then
			surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial( GetMaterial( tab.mat, "smooth" ) )

			local dist = inner + thickness * 0.5
			local a = math.rad( ang * 0.5 + ang * ( i - 1 ) )
			local drx, dry = math.sin( a ) * dist, -math.cos( a ) * dist

			local size = w * 0.035
			surface.DrawTexturedRect( cx + drx - size * 0.5, cy + dry - size * 0.5, size, size )
		end

		if i != selected then continue end

		local marg_w, marg_h = w * 0.01, h * 0.005
		local tw, th = draw.TextSize( tab.name, "SCPHUDSmall" )

		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( cx - tw * 0.5 - marg_w, h * 0.45 - th * 0.5 - marg_h, tw + marg_w * 2, th + marg_h * 2 )

		draw.Text{
			text = tab.name,
			pos = { cx, h * 0.45 },
			color = Color( 255, 255, 255, 255 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		if !tab.desc then continue end

		local dsc_w, dsc_h = tab.desc:Size()

		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( cx + outer + marg_w, h * 0.5 - dsc_h * 0.5 - marg_h, dsc_w + marg_w * 2, dsc_h + marg_h * 2 )

		tab.desc:Draw( cx + outer + marg_w * 2, h * 0.5 - dsc_h * 0.5 )
	end
end )

--[[-------------------------------------------------------------------------
ProgressBar
---------------------------------------------------------------------------]]
local PROGRESS_ENABLED = false
local PROGRESS_VALUE = 0
local PROGRESS_MAX_VALUE = 1
local PROGRESS_TEXT = ""
local PROGRESS_ID = ""
local PROGRESS_TICK_BASED = false
local PROGRESS_TICK = false

local COLOR_PROGRESS_BORDER = Color( 225, 225, 225, 255 )
local COLOR_PROGRESS_FILL = Color( 75, 75, 90, 255 )

--[[-------------------------------------------------------------------------
ProgressBar( enable, maxvalue, text, tick, id )

Enables or disables progress bar. Example of tick based bar can be found in Turret.

@param		[boolean]		enable				True to enable, false to disable
@param		[number]		maxvalue			Maximum value of progress bar
@param		[string]		text				Optional: Text displayed below bar
@param		[boolean]		tick				Optional [default = false]: If true, ProgressBarTick() must be called each tick or bar will be closed
@param		[any]			id					Optional: If set, SetProgressBarValue and ProgressBarTick will only work if ID provided to them is the same as here

@return		[nil]			-					-
-------------------------------------------------------------------------]]--
function ProgressBar( enable, maxvalue, text, tick, id )
	if enable then
		if text and string.sub( text, 1, 5 ) == "lang:" then
			local tab = LANG
			
			for k, v in ipairs( string.Explode( ".", string.sub( text, 6 ) ) ) do
				tab = tab[v]

				if !tab then
					break
				elseif isstring( tab ) then
					text = tab
					break
				end
			end
		end

		PROGRESS_ENABLED = true
		PROGRESS_MAX_VALUE = tonumber( maxvalue ) or 100
		PROGRESS_VALUE = 0
		PROGRESS_ID = id
		PROGRESS_TEXT = text
		PROGRESS_TICK_BASED = !!tick
		PROGRESS_TICK = true
	else
		PROGRESS_ENABLED = false
		PROGRESS_MAX_VALUE = 1
		PROGRESS_VALUE = 0
		PROGRESS_TEXT = nil
		PROGRESS_ID = nil
		PROGRESS_TICK_BASED = false
		PROGRESS_TICK = false
	end
end

--[[-------------------------------------------------------------------------
SetProgressBarValue( value, id )

Sets the current value of progress bar

@param		[number]		value				Value
@param		[any]			id					Optional: If specified, this function will only work if bar has the same ID

@return		[nil]			-					-
-------------------------------------------------------------------------]]--
function SetProgressBarValue( value, id )
	if !id or id == PROGRESS_ID then
		PROGRESS_VALUE = tonumber( value ) or 0
	end
end

--[[-------------------------------------------------------------------------
SetProgressBarColor( border, fill, blend )

Sets progress bar color

@param		[Color]			border				Color of border
@param		[Color]			fill				Fill color, can also be function - values passed: fraction, segment, all_segments, current_value, max_value - return color
@param		[boolean]		blend				Optional: If set, fill alpha will be affected by progress bar status. IMPORTANT: fill must be color, not function

@return		[nil]			-					-
-------------------------------------------------------------------------]]--
function SetProgressBarColor( border, fill, blend )
	if border then
		COLOR_PROGRESS_BORDER = border
	end

	if fill then
		if blend and type( fill ) != "function" then
			COLOR_PROGRESS_FILL = function( f, i, seg )
				if i == seg then
					return Color( fill.r, fill.g, fill.b, ( 1 - i + f / 0.05 ) * 255 )
				else
					return fill
				end
			end
		else
			COLOR_PROGRESS_FILL = fill
		end
	end
end

--[[-------------------------------------------------------------------------
ProgressBarTick( id )

Keeps open tick based progress bar

@param		[type]			id					Optional, If specified, this function will only work if bar has the same ID

@return		[boolean]		-					Is progress bar enabled
-------------------------------------------------------------------------]]--
function ProgressBarTick( id )
	if PROGRESS_TICK_BASED and ( !id or id == PROGRESS_ID ) then
		PROGRESS_TICK = true
	end

	return PROGRESS_ENABLED
end

local tbpb_enable = false
local tbpb_start = 0
local tbpb_end = 0

--[[-------------------------------------------------------------------------
TimeBasedProgressBar( start_time, end_time, text )

Starts progress bar based on start and end time

@param		[type]			start_time			CurTime based start time
@param		[type]			end_time			CurTime based end time
@param		[type]			text				Optional: Text displayed below bar

@return		[nil]			-					-
-------------------------------------------------------------------------]]--
function TimeBasedProgressBar( start_time, end_time, text )
	ProgressBar( true, 1, text, false, "tbpb" )

	tbpb_enable = true
	tbpb_start = start_time
	tbpb_end = end_time
end

hook.Add( "Tick", "SLCProgressBar", function()
	if tbpb_enable then
		local ct = CurTime()

		SetProgressBarValue( ( ct - tbpb_start ) / ( tbpb_end - tbpb_start ), "tbpb" )

		if ct >= tbpb_end then
			tbpb_enable = false
			ProgressBar( false )
		end
	end

	if PROGRESS_ENABLED and PROGRESS_TICK_BASED then
		if PROGRESS_TICK then
			PROGRESS_TICK = false
		else
			ProgressBar( false )
		end
	end
end )

hook.Add( "DrawOverlay", "SLCProgressBar", function()
	if PROGRESS_ENABLED then
		local w, h = ScrW(), ScrH()

		local ratio = ( w * 0.075 ) / ( h * 0.24 )

		local bar_w = w * 0.27
		local bar_h = h * 0.04

		local bx_start = w * 0.5 - bar_w * 0.5
		local by_start = h * 0.7

		local bar_xoffset = ratio * bar_h

		local b_in = {
			{ x = bx_start, y = by_start },
			{ x = bx_start + bar_w, y = by_start },
			{ x = bx_start + bar_w + bar_xoffset, y = by_start + bar_h },
			{ x = bx_start + bar_xoffset, y = by_start + bar_h },
		}

		local b_out = {
			{ x = bx_start - 4, y = by_start - 2 },
			{ x = bx_start + bar_w + 2, y = by_start - 2 },
			{ x = bx_start + bar_w + bar_xoffset + 4, y = by_start + bar_h + 2 },
			{ x = bx_start + bar_xoffset - 2, y = by_start + bar_h + 2 },
		}

		draw.NoTexture()
		surface.SetDrawColor( COLOR_PROGRESS_BORDER )
		surface.DrawDifference( b_in, b_out )

		local dist = w * 0.004

		local fill_h = bar_h - dist * 2
		local fill_w = ( bar_w - dist ) / 20 - dist

		local fx_start = bx_start + dist * ratio + dist
		local fy_start = by_start + dist

		local fill_xoffset = ratio * fill_h

		local isfunc = type( COLOR_PROGRESS_FILL ) == "function"
		if !isfunc then
			surface.SetDrawColor( COLOR_PROGRESS_FILL )
		end

		local f = PROGRESS_VALUE / PROGRESS_MAX_VALUE
		local seg = math.Clamp( math.ceil( f * 20 ), 0, 20 )

		if seg > 0 then
			for i = 1, seg do
				if isfunc then
					local color = COLOR_PROGRESS_FILL( f, i, seg, PROGRESS_VALUE, PROGRESS_MAX_VALUE )
					if color then
						surface.SetDrawColor( color )
					end
				end

				surface.DrawPoly{
					{ x = fx_start, y = fy_start },
					{ x = fx_start + fill_w, y = fy_start },
					{ x = fx_start + fill_w + fill_xoffset, y = fy_start + fill_h },
					{ x = fx_start + fill_xoffset, y = fy_start + fill_h },
				}

				fx_start = fx_start + fill_w + dist
			end
		end

		if PROGRESS_TEXT and PROGRESS_TEXT != "" then
			draw.Text{
				text = PROGRESS_TEXT,
				pos = { w * 0.5, by_start + bar_h + h * 0.01 },
				font = "SCPHUDBig",
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			}
		end
	end
end )

--[[-------------------------------------------------------------------------
Indicator
---------------------------------------------------------------------------]]
INDICATOR_REGISTRY = INDICATOR_REGISTRY or {}


--[[-------------------------------------------------------------------------
CreateIndicator( model, nodraw, rendergroup, rendermode, shouldremove )

Indicator is a clinetside model used internally by Turret and SCP 023

@param		[string]		model				Path to model
@param		[boolean]		nodraw				SetNoDraw on entity
@param		[number]		rendergroup			Render group - RENDERGROUP enum
@param		[number]		rendermode			Render group - RENDERMODE enum
@param		[function]		shouldremove		Function called each frame - return true to remove indicator

@return		[CSEnt]			-					Clientside model of indicator
-------------------------------------------------------------------------]]--
function CreateIndicator( model, nodraw, rendergroup, rendermode, shouldremove )
	local mdl = ClientsideModel( model, rendergroup )

	if rendermode then
		mdl:SetRenderMode( rendermode )
	end
	
	mdl:SetNoDraw( nodraw )

	for i = 1, #mdl:GetMaterials() do
		mdl:SetSubMaterial( i - 1, "models/debug/debugwhite" )
	end

	if isfunction( shouldremove ) then
		INDICATOR_REGISTRY[mdl] = shouldremove
	end

	return mdl
end

local ncheck = 0
hook.Add( "Tick", "SLCIndicatorCheck", function()
	local rt = RealTime()
	if ncheck > rt then return end
	ncheck = rt + 1

	for k, v in pairs( INDICATOR_REGISTRY ) do
		if !IsValid( k ) then
			INDICATOR_REGISTRY[k] = nil
		elseif v() then
			INDICATOR_REGISTRY[k] = nil
			k:Remove()
		end
	end
end )
--[[-------------------------------------------------------------------------
Sound functions
---------------------------------------------------------------------------]]
local PrecachedSounds = {}

/*---------------------------------------------------------------------------
ClientsideSound( file, ent )

Creates clientside sound handler attached to specified entity. Created sounds are precached.
This function is meant to be accesed by 'PlaySound' net message.

@param 		[string] 		file 		Path to sound file
@param 		[Entity] 		ent 		Parent entity. World Entity if nil

@return 	[CSoundPatch] 	sound 		The sound object
---------------------------------------------------------------------------*/
function ClientsideSound( file, ent )
	if !IsValid( ent ) then
		ent = game.GetWorld()
	end

	if ent == NULL then return end

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
		if !snd then return end

		snd:SetSoundLevel( 0 )
		snd:Play()
		snd:ChangeVolume( vol )
	else
		ClientsideSound( f )
	end
end )

--[[-------------------------------------------------------------------------
SLC Popup
---------------------------------------------------------------------------]]
SLC_POPUP_QUEUE = {}

--[[---------------------------------------------------------------------------
SLCPopup( name, text, keep, options, callback )

Opens popup with given title, text and buttons

@param		[type]			name				Name of popup
@param		[type]			text				Text if popup
@param		[type]			keep				Keep popup open, if not set, clicking outside of popup will close it
@param		[table]			options
{
	@param		[string]	[sequential]		Button text
	...

	<OR>

	@param		[table]		[sequential]
	{
		@param		[string]		[1]		Button text
		@param		[Color]			color	Button color
		@param		[boolean]		warn	Warning button (if true, player will have to wait 5 seconds before pressing it)
	}
	...
}
@param		[type]			callback			Called when specified event happens. 3 arguments are passed: number (see next line), popup panel and button
												Passed numbers: -1: when popup is opened, 0: when exited by clicking outside, other: pressed button id
												return true to prevent popup close

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function SLCPopup( name, text, keep, options, callback, font )
	if font then
		text = "<font="..font..">"..text.."</font>"
	end

	local data = {
		name = name,
		text = text,
		keep = keep,
		options = options or { "OK" },
		callback = callback,
	}

	if IsValid( SLC_POPUP ) then
		return table.insert( SLC_POPUP_QUEUE, data )
	end

	SLC_POPUP = vgui.Create( "SLCPopup" )
	SLC_POPUP:SetData( data )

	return 0
end

/*---------------------------------------------------------------------------
SLCLegacyPopup( name, text, keep, callback, ... )

Legacy function. Internally calls new one

@param 		[string] 		name 		Name of popup
@param 		[string] 		text 		Popup content, obeys line ends and tabs
@param 		[boolean] 		keep 		Keep popup always on top, if not clicking outside of popup will close it
@param 		[function] 		callback 	Called when specified event happens. Number is passed as only param:
										-1: when popup is opened, 0: when exited by clicking outside, other: pressed button id
@param 		[vararg] 		- 			Names of buttons

@return 	[nil] 			- 			-
---------------------------------------------------------------------------*/
function SLCLegacyPopupIfEmpty( ... )
	if !IsValid( SLC_POPUP ) then
		SLCLegacyPopup( ... )
	end
end

function SLCLegacyPopup( name, text, keep, callback, ... )
	SLCPopup( name, text, keep, { ... }, callback, "SCPHUDVSmall" )
end

--[[-------------------------------------------------------------------------
Tooltip
---------------------------------------------------------------------------]]
local tooltip

hook.Add( "DrawOverlay", "SLCToolTip", function()
	if !tooltip then
		local hovered = vgui.GetHoveredPanel()
		if IsValid( hovered ) and hovered.SLCToolTip then
			tooltip = hovered.SLCToolTip
		end
	end

	if tooltip then
		local tmp = tooltip
		tooltip = nil

		local sw, sh = ScrW(), ScrH()

		if GetSettingsValue( "hud_windowed_mode" ) then
			sh = sh * 0.97
		end

		local w, h = tmp:GetWidth() + 16, tmp:GetHeight() + 16
		local x, y = input.GetCursorPos()

		x = x + 16

		if x + w > sw then
			x = sw - w
		end

		if y + h > sh then
			y = sh - h
		end

		surface.SetDrawColor( 16, 16, 16, 235 )
		surface.DrawRect( x, y, w, h )

		surface.SetDrawColor( 128, 128, 128 )
		surface.DrawOutlinedRect( x, y, w, h )

		tmp:Draw( x + 8, y + 8, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255, TEXT_ALIGN_LEFT )
	end
end )

function SLCToolTip( obj )
	tooltip = obj
end