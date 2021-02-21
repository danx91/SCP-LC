--[[-------------------------------------------------------------------------
Player message
---------------------------------------------------------------------------]]
CENTERINFO = {}

local function add_text( txt, clr, c )
	if c then
		CENTERINFO = { text = txt, color = clr or Color( 255, 255, 255 ), time = CurTime() + 3 }
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
@param 		[boolean] 		center 		It true, message will be drawn on the center of screen

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

			/*local tabinfo, key = string.match( v, "^@(.+):(.+)$" )
			if !tabinfo then
				key = string.match( v, "@(.+)" )
			end

			if tabinfo or key then
				local tab = LANG

				if tabinfo then
					for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
						if !tab[subtable] then
							break
						end

						tab = tab[subtable]
					end
				end

				table.insert( args, tab[key] or key )
			else
				table.insert( args, v )
			end*/
			local tabinfo = string.match( v, "^@(.+)$" ) --TODO TEST
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

		local yoff = string.match( s, "^offset:(%d+)$" )
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
				line.font = f or font
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

				/*local tabinfo, key = string.match( v, "^@(.+):(.+)$" )
				if !tabinfo then
					key = string.match( v, "@(.+)" )
				end

				if tabinfo or key then
					local tab = LANG

					if tabinfo then
						for subtable in string.gmatch( tabinfo, "[^%.]+" ) do
							if !tab[subtable] then
								break
							end

							tab = tab[subtable]
						end
					end

					table.insert( args, tab[key] or key )
				else
					table.insert( args, v )
				end*/
				local tabinfo = string.match( v, "^@(.+)$" ) --TODO TEST
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

		local y = h * ( 0.05 + msg.yoffset )
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
Wheel menu
---------------------------------------------------------------------------]]
local wheel_visible = false
local wheel_options = {}
local wheel_cb, wheel_sc
function OpenWheelMenu( options, cb, sc )
	if wheel_visible then return end

	wheel_options = { { "exit", LANG.exit, nil } }
	for i, v in ipairs( options ) do
		table.insert( wheel_options, { v[1], v[2], v[3] } )
	end

	wheel_cb = cb
	wheel_sc = sc
	wheel_visible = true
	gui.EnableScreenClicker( true )
end

function CloseWheelMenu()
	if !wheel_visible then return end

	local x, y = input.GetCursorPos()
	local ca = math.deg( math.atan2( x - ScrW() * 0.5, -y + ScrH() * 0.5 ) )

	if ca < 0 then
		ca = 360 + ca
	end

	local selected = math.floor( ca * #wheel_options / 360 ) + 1

	if wheel_cb then
		wheel_cb( wheel_options[selected][3] )
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

	local w, h = ScrW(), ScrH()

	local x, y = input.GetCursorPos()
	local ca = math.deg( math.atan2( x - w * 0.5, -y + h * 0.5 ) )

	if ca < 0 then
		ca = 360 + ca
	end

	local seg = #wheel_options
	local ang = 360 / seg
	local segang = ang - 4
	for i = 1, seg do
		draw.NoTexture()
		surface.SetDrawColor( Color( 200, 200, 200 ) )
		surface.DrawRing( w * 0.5, h * 0.5, w * 0.099, w * 0.057, segang + 2, 40, 1, 1 + ang * (i - 1) )

		local selected =ca > ang * (i - 1) and ca <= ang * i

		if selected then
			surface.SetDrawColor( Color( 100, 100, 100 ) )
		else
			surface.SetDrawColor( Color( 50, 50, 50 ) )
		end

		surface.DrawRing( w * 0.5, h * 0.5, w * 0.1, w * 0.055, segang, 40, 2, 2 + ang * (i - 1) )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.SetMaterial( GetMaterial( wheel_options[i][1] ) )

		local dist = w * 0.1275
		local a = math.rad( ang * 0.5 + ang * (i - 1) )
		local dx, dy = math.sin( a ) * dist, -math.cos( a ) * dist

		local size = w * 0.035
		surface.DrawTexturedRect( w * 0.5 + dx - size * 0.5, h * 0.5 + dy - size * 0.5, size, size )

		if selected then
			draw.LimitedText{
				text = wheel_options[i][2],
				pos = { w * 0.5, h * 0.5 },
				color = Color( 255, 255, 255, 100 ),
				font = "SCPHUDSmall",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
	end
end )

--[[-------------------------------------------------------------------------
ProgressBar
---------------------------------------------------------------------------]]
PROGRESS_STYLE_BAR = 0
PROGRESS_STYLE_RING = 1
PROGRESS_STYLE_HRC = 2

local PROGRESS_ENABLED = false
local PROGRESS_VALUE = 0
local PROGRESS_MAX_VALUE = 0

function SetProgressBarEnabled( enable, type, maxvalue )

end

function SetProgressBarvalue( value )

end

hook.Add( "DrawOverlay", "SLCProgressBar", function()
	
end )
--[[-------------------------------------------------------------------------
Indicator
---------------------------------------------------------------------------]]
INDICATOR_REGISTRY = INDICATOR_REGISTRY or {}

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
SLC Popup
---------------------------------------------------------------------------]]
SLC_POPUP = SLC_POPUP or nil
SLC_POPUP_QUEUE = {}
local queueNext = 0

local blur = Material( "pp/blurscreen" )
local recomputed = false

/*---------------------------------------------------------------------------
SLCPopup( name, text, keep, callback, ... )

Creates clientside sound handler attached to specified entity. Created sounds are precached.
This function is meant to be accesed by 'PlaySound' net message.

@param 		[string] 		name 		Name of popup
@param 		[string] 		text 		Popup content, obeys line ends and tabs
@param 		[boolean] 		keep 		Keep popup always on top, if not clicking outside of popup will close it
@param 		[function] 		callback 	Called when specified event happens. Number is passed as only param:
										-1: when popup is opened,0: when exited by clicking outside, other: pressed button id
@param 		[vararg] 		- 			Names of buttons

@return 	[nil] 			- 			-
---------------------------------------------------------------------------*/
function SLCPopup( name, text, keep, callback, ... )
	if IsValid( SLC_POPUP ) then
		table.insert( SLC_POPUP_QUEUE, { name, text, keep, callback, {...} } )
		return
	end

	if isfunction( callback ) then
		callback( -1 )
	end

	local w, h = ScrW(), ScrH()
	local maxH = draw.SimulateMultilineText( text, "SCPHUDSmall", w * 0.5, 10, 0 )

	local popup = vgui.Create( "DFrame" )
	SLC_POPUP = popup
	popup.text = text
	popup:SetDeleteOnClose( true )
	popup:ShowCloseButton( false )
	popup:SetDraggable( false )
	popup:SetSizable( false )
	//popup:SetBackgroundBlur( false )
	//popup:SetDrawOnTop( keep )
	popup:SetTitle( "" )
	popup:SetSize( w * 0.5, maxH + h * 0.03 + h * 0.07 )
	popup:Center()
	popup:DockPadding( 0, 0, 0, 0 )
	popup:MakePopup()
	popup.Think = function( self )
		if !self:HasFocus() then
			if keep then
				self:MakePopup()
			else
				self:Close()

				if isfunction( callback ) then
					callback( 0 )
				end
			end
		end
	end

	popup.Paint = function( self, pw, ph )
		render.UpdateScreenEffectTexture()
		blur:SetFloat( "$blur", 8 )

		if !recomputed then
			recomputed = true
			blur:Recompute()
		end

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( blur )

		local x, y = self:GetPos()
		surface.DrawTexturedRect( -x, -y, w, h )

		surface.SetDrawColor( Color( 10, 10, 10, 225 ) )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		surface.DrawRect( 0, 0, pw, h * 0.03 )

		draw.Text{
			text = name or "Information",
			pos = { pw * 0.01, h * 0.015 },
			font = "SCPHUDSmall",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.MultilineText( 0, h * 0.03, popup.text, "SCPHUDSmall", Color( 255, 255, 255, 255 ), w * 0.5, 10, 0, TEXT_ALIGN_LEFT )
	end

	local cont = vgui.Create( "DPanel", popup )
	cont:Dock( BOTTOM )
	cont:SetTall( h * 0.05 )
	cont.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 255 ) )
		surface.DrawLine( 10, 0, pw - 20, 0 )
	end

	local options = {...}
	local len = #options

	if len == 0 then
		options[1] = "OK"
	end

	for i = 1, #options do
		local width = draw.TextSize( options[i], "SCPHUDMedium" ) + w * 0.01

		if width < w * 0.08 then
			width = w * 0.08
		elseif width > w * 0.15 then
			width = w * 0.15
		end

		local btn = vgui.Create( "DButton", cont )
		btn:Dock( RIGHT )
		btn:DockMargin( 5, 5, 5, 5 )
		btn:SetWide( width )
		btn:SetText( "" )
		btn.Paint = function( self, pw, ph )
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.DrawOutlinedRect( 0, 0, pw, ph )

			draw.Text{
				text = options[i],
				pos = { pw * 0.5, ph * 0.5 },
				font = "SCPHUDMedium",
				color = Color( 255, 255, 255, 255 ),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
		btn.DoClick = function( self )
			popup:Close()

			if isfunction( callback ) then
				callback( i )
			end
		end
	end
end

hook.Add( "Think", "SLCPopupThink", function()
	if !IsValid( SLC_POPUP ) and #SLC_POPUP_QUEUE > 0 then
		if queueNext == 0 then
			queueNext = RealTime() + 0.75
		elseif queueNext < RealTime() then
			queueNext = 0

			local data = table.remove( SLC_POPUP_QUEUE, 1 )
			SLCPopup( data[1], data[2], data[3], data[4], unpack( data[5] ) )
		end
	end
end )