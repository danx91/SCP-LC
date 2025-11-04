--[[-------------------------------------------------------------------------
Snake
---------------------------------------------------------------------------]]
local color_white = Color( 255, 255, 255 )
local exit_mat = Material( "slc/hud/exit.png", "smooth" )

local snake_texture = GetRenderTarget( "SLCSnakeTexture", 1024, 1024 )
local snake_material = CreateMaterial( "SLCSnakeMaterial", "UnlitGeneric", {
	["$basetexture"] = snake_texture:GetName(),
} )

local board_size = 60
local pix = math.floor( 1024 / board_size )
local margin = ( 1024 - pix * board_size ) / 2

local pause
local game_over

local snake_board
local snake_segments
local snake_apples
local snake_next_apple

local snake_dir_x
local snake_dir_y

local snake_new_dir_x
local snake_new_dir_y

local snake_high_score = 0
local snake_score

local function snake_new_game()
	pause = 0
	game_over = false

	snake_board = {}
	snake_segments = List()
	snake_apples = {}
	snake_next_apple = 5
	
	snake_dir_x = 0
	snake_dir_y = 0

	snake_new_dir_x = 0
	snake_new_dir_y = 0

	snake_score = 1

	local mid = math.ceil( board_size / 2 )
	snake_segments:PushFront( { x = mid, y = mid } )

	for y = 0, board_size - 1 do
		local tab = {}
		snake_board[y] = tab

		for x = 0, board_size - 1 do
			tab[x] = 0
		end
	end
end

snake_new_game()

local function snake_load()
	local data = file.Read( "slc/snake.dat" )
	if !data then return end

	data = util.Decompress( data )
	if !data then return end

	data = util.JSONToTable( data )
	if !data then return end

	snake_dir_x = data.dir_x
	snake_dir_y = data.dir_y
	snake_new_dir_x = snake_dir_x
	snake_new_dir_y = snake_dir_y
	snake_apples = data.apples
	snake_next_apple = data.next_apple
	snake_high_score = data.high_score

	snake_board = {}
	snake_segments = List()

	for y = 0, board_size - 1 do
		local tab = {}
		snake_board[y] = tab

		for x = 0, board_size - 1 do
			tab[x] = 0
		end
	end

	for i, v in ipairs( data.segments ) do
		snake_segments:PushBack( v )
		snake_board[v.y][v.x] = 1
	end

	for i, v in ipairs( snake_apples ) do
		snake_board[v.y][v.x] = 2
	end

	if snake_dir_x != 0 or snake_dir_y != 0 then
		pause = RealTime() + 3
	end

	snake_score = snake_segments:Size()
end

local function snake_save()
	if game_over then
		snake_new_game()
	end

	local segments = {}

	for v in snake_segments:Iter() do
		table.insert( segments, v )
	end

	local data = {
		dir_x = snake_dir_x,
		dir_y = snake_dir_y,
		apples = snake_apples,
		segments = segments,
		next_apple = snake_next_apple,
		high_score = snake_high_score
	}

	data = util.TableToJSON( data )
	if !data then return end

	data = util.Compress( data )
	if !data then return end

	file.Write( "slc/snake.dat", data )
end

local function generate_apple()
	local i = 1
	local free = {}

	for y = 0, board_size - 1 do
		local row = snake_board[y]

		for x = 0, board_size - 1 do
			if row[x] == 0 then
				free[i] = { x = x, y = y }
				i = i + 1
			end
		end
	end

	if #free == 0 then
		game_over = true
		return
	end

	local rng = free[SLCRandom( #free )]
	table.insert( snake_apples, rng )
	snake_board[rng.y][rng.x] = 2
end

local function snake_render()
	render.PushRenderTarget( snake_texture )
		cam.Start2D()
			//Draw background
			surface.SetDrawColor( 32, 32, 32, 255 )
			surface.DrawRect( 0, 0, 1024, 1024 )

			//Draw borders
			surface.SetDrawColor( 200, 200, 200, 255 )
			surface.DrawRect( 0, 0, 1024, margin )
			surface.DrawRect( 1024 - margin, 0, margin, 1024 )
			surface.DrawRect( 0, 1024 - margin, 1024, margin )
			surface.DrawRect( 0, 0, margin, 1024 )

			//Draw apples
			surface.SetDrawColor( 200, 48, 48, 255 )
			for i, v in ipairs( snake_apples ) do
				surface.DrawRect( margin + v.x * pix, margin + v.y * pix, pix, pix )
			end

			//Draw snake
			surface.SetDrawColor( 64, 225, 64, 255 )
			for v in snake_segments:Iter() do
				surface.DrawRect( margin + v.x * pix, margin + v.y * pix, pix, pix )
			end
		cam.End2D()
	render.PopRenderTarget()
end

local function snake_update()
	if pause > RealTime() or game_over then return end

	//Handle user input
	if math.abs( snake_new_dir_x - snake_dir_x ) == 1 or math.abs( snake_new_dir_y - snake_dir_y ) == 1 then
		snake_dir_x = snake_new_dir_x
		snake_dir_y = snake_new_dir_y
	end

	if snake_dir_x == 0 and snake_dir_y == 0 then return end

	//Handle movement and collision (game over apple)
	local apple = false
	local first_segment = snake_segments:Head()
	local new_x = first_segment.x + snake_dir_x
	local new_y = first_segment.y + snake_dir_y

	if new_x < 0 or new_x >= board_size or new_y < 0 or new_y >= board_size then
		game_over = true
		return
	end

	local tile = snake_board[new_y][new_x]
	if tile == 1 then
		game_over = true
		return
	elseif tile == 2 then
		apple = true
		snake_next_apple = SLCRandom( 10, 40 )
		snake_score = snake_score + 1

		if snake_score > snake_high_score then
			snake_high_score = snake_score
		end
		
		for i, v in ipairs( snake_apples ) do
			if v.x == new_x and v.y == new_y then
				table.remove( snake_apples, i )
				break
			end
		end
	end

	snake_board[new_y][new_x] = 1

	snake_segments:PushFront( {
		x = new_x,
		y = new_y,
	} )

	local last_segment
	
	if !apple then
		last_segment = snake_segments:PopBack()
		snake_board[last_segment.y][last_segment.x] = 0
	end

	if snake_next_apple <= 0 then
		snake_next_apple = SLCRandom( 10, 40 )
		generate_apple()
	end

	if #snake_apples < 3 then
		snake_next_apple = snake_next_apple - 1
	end

	//Render changes
	render.PushRenderTarget( snake_texture )
		cam.Start2D()
		surface.SetDrawColor( 200, 48, 48, 255 )
			for i, v in ipairs( snake_apples ) do
				surface.DrawRect( margin + v.x * pix, margin + v.y * pix, pix, pix )
			end

			surface.SetDrawColor( 64, 225, 64, 255 )
			surface.DrawRect( margin + new_x * pix, margin + new_y * pix, pix, pix )

			if last_segment then
				surface.SetDrawColor( 32, 32, 32, 255 )
				surface.DrawRect( margin + last_segment.x * pix, margin + last_segment.y * pix, pix, pix )
			end
		cam.End2D()
	render.PopRenderTarget()
end

local function snake_open()
	if IsValid( SNAKE_FRAME ) or !CanOpenMinigame( LocalPlayer() ) then return end

	local lang = LANG.minigames.snake

	local h = ScrH()
	local size = h * 0.8
	local header_h = h * 0.03

	local panel = vgui.Create( "DPanel" )
	SNAKE_FRAME = panel

	panel:SetSize( size + 2, size + header_h + 2 )
	panel:Center()
	panel:MakePopup()

	panel.Paint = function( this, pw, ph )
		surface.SetDrawColor( 128, 128, 128, 255 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end
	
	panel.OnKeyCodePressed = function( this, code )
		if code == KEY_A or code == KEY_LEFT then
			snake_new_dir_x = -1
			snake_new_dir_y = 0
		elseif code == KEY_D or code == KEY_RIGHT then
			snake_new_dir_x = 1
			snake_new_dir_y = 0
		elseif code == KEY_W or code == KEY_UP then
			snake_new_dir_x = 0
			snake_new_dir_y = -1
		elseif code == KEY_S or code == KEY_DOWN then
			snake_new_dir_x = 0
			snake_new_dir_y = 1
		elseif game_over and code == KEY_SPACE or code == KEY_ENTER then
			snake_new_game()
			snake_render()
		end
	end

	local header = vgui.Create( "DPanel", panel )
	header:Dock( TOP )
	header:SetTall( header_h )

	header.Paint = function( this, pw, ph )
		surface.SetDrawColor( 48, 48, 48, 255 )
		surface.DrawRect( 0, 0, pw, ph )
		surface.SetDrawColor( 128, 128, 128, 255 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.SimpleText( lang.score..": "..snake_score, "SCPHUDSmall", pw * 0.5, ph * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	header.PerformLayout = function( this, pw, ph )
		local marg = math.ceil( ph * 0.15 )
		local btn_size = ph - marg * 2

		this.Exit:DockMargin( 0, marg, marg, marg )
		this.Exit:SetWide( btn_size )
	end

	local title = vgui.Create( "DLabel", header )
	title:Dock( LEFT )
	title:DockMargin( 4, 0, 0, 0 )
	title:SetFont( "SCPHUDSmall" )
	title:SetTextColor( Color( 255, 255, 255 ) )
	title:SetText( "Snake" )
	title:SizeToContents()
	title:SetContentAlignment( 5 )

	local exit = vgui.Create( "DButton", header )
	header.Exit = exit

	exit:Dock( RIGHT )
	exit:SetText( "" )
	
	exit.Paint = function( this, pw, ph )
		local s = math.ceil( ph * 0.1 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( exit_mat )
		surface.DrawTexturedRect( s, s, pw - s * 2, ph - s * 2 )

		surface.SetDrawColor( 128, 128, 128, 255 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end

	exit.DoClick = function( this )
		snake_save()
		panel:Remove()
	end

	local board = vgui.Create( "DPanel", panel )
	board:Dock( FILL )
	board:DockMargin( 1, 0, 1, 1 )
	board.NextUpdate = 0

	board.Paint = function( this, pw, ph )
		local rt = RealTime()
		if this.NextUpdate < rt then
			this.NextUpdate = this.NextUpdate + 0.125

			if this.NextUpdate < rt then
				this.NextUpdate = rt + 0.125
			end

			snake_update()
		end

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( snake_material )
		surface.DrawTexturedRect( 0, 0, pw, ph )

		if snake_dir_x == 0 and snake_dir_y == 0 then
			draw.SimpleText( lang.high_score..": "..snake_high_score, "SCPHUDVBig", pw * 0.5, ph * 0.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( lang.info, "SCPHUDBig", pw * 0.5, ph * 0.3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif pause > rt then
			draw.SimpleText( lang.paused, "SCPHUDBig", pw * 0.5, ph * 0.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( math.ceil( pause - rt ), "SCPHUDBig", pw * 0.5, ph * 0.3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif game_over then
			local _, th = draw.SimpleText( lang.score..": "..snake_score, "SCPHUDVBig", pw * 0.5, ph * 0.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( lang.high_score..": "..snake_high_score, "SCPHUDVBig", pw * 0.5, ph * 0.2 + th, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( lang.restart, "SCPHUDBig", pw * 0.5, ph * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	snake_load()
	snake_render()
end

AddChatCommand( "snake", snake_open, CLIENT, false )
concommand.Add( "slc_snake", snake_open )

hook.Add( "SLCCloseMinigames", "SLCSnake", function()
	if !IsValid( SNAKE_FRAME ) then return end

	snake_save()
	SNAKE_FRAME:Remove()
end )