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
	local nmsg, cr, cg, cb = string.match( msg, "^(.+)%#(%d+)%,(%d*)%,(%d*)$" )
	if nmsg then
		cr = tonumber( cr )

		if cr then
			color = Color( cr, tonumber( cg ) or cr, tonumber( cb ) or cr )
		end

		msg = nmsg
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
		local tabinfo = string.match( name, "@(.+)" )
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
			text = string.format( LANG.NFailed, name )
		else
			translated = string.gsub( translated, "%[RAW%]", rawtext )
		 	text = string.format( translated, unpack( args ) )
		end

		add_text( text, color, center )
		print( text )
	else
		local text
		local tabinfo = string.match( msg, "@(.+)" )
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
			text = string.format( LANG.NFailed, msg )
		end
		
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

		if !nmsg then
			nmsg, cr, cg, cb = string.match( s, "^(.+)%#(%d*),(%d*),(%d*)$" )
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
			local tabinfo = string.match( name, "@(.+)" )
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
			end
		else
			local text
			local tabinfo = string.match( s, "@(.+)" )
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

		local y = h * 0.05
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