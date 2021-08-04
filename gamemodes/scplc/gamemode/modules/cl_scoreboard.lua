local button_next = false
local next_frame = false
local function Button( x, y, w, h )
	local mx, my = input.GetCursorPos()
	if mx >= x and mx <= x + w and my >= y and my <= y + h then
		if input.IsMouseDown( MOUSE_LEFT )then
			
			if button_next then
				button_next = false
				return 2 --LMB
			end

			return 1 --HOVER
		elseif input.IsMouseDown( MOUSE_RIGHT ) then
			if button_next then
				button_next = false
				return 3 --RMB
			end

			return 1 --HOVER
		else
			if next_frame then
				next_frame = false
				button_next = true
			end

			return 1 --HOVER
		end
	end

	return 0
end

local MATS = {
	arrow_up = GetMaterial( "slc/hud/arrow_up.png" ),
	arrow_down = GetMaterial( "slc/hud/arrow_down.png" ),
	muted = Material( "icon32/muted.png" ),
	unmuted = Material( "icon32/unmuted.png" ),
}

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
}

--Lower value is sorted higher
--WARNING!! Don't use values higher than 20 and lower than -20!!
local SORT = {
	inactive = 20,
	unknown = 19,
	other = 16,
	[TEAM_SPEC] = 15,
	[TEAM_CLASSD] = 14,
	[TEAM_SCI] = 13,
	[TEAM_MTF] = 12,
	teammates = 5,
	localplayer = 0,
}

local customRanks = {
	vip = {
		sorting = 17,
		color = Color( 220, 200, 35, 100 ),
		func = function( ply )
			return ply:IsPremium()
		end,
	},

	--CREDITS - It grants NO benefits at all
	author = {
		sorting = -20,
		color = Color( 115, 25, 155, 100 ),
		func = "76561198110788144"--Can be either SteamID64, table of SteamID64s or function with player as argument
	},
	tester = {
		sorting = 19,
		color = Color( 10, 170, 115 ),
		func = { "76561198152379830", "76561198246441626", "76561198210338085", "76561198177855619", "76561198262604873" }
	},
	contributor = {
		sorting = 19,
		color = Color( 20, 100, 20 ),
		func = { "76561198179611206", "76561198108864618" }
	},
	translator = {
		sorting = 19,
		color = Color( 220, 110, 30 ),
		func = { "76561198246441626", "76561198179611206", "76561198121822134" },
	}
}

local playerRanks = {
	default = Color( 125, 125, 125 ),
	ranks = {
		user = false, --don't show
		superadmin = Color( 10, 125, 190, 100 ),
	}
}

local PLAYERS = {}

local function applyPlayerRanks( ply )
	if !PLAYERS[ply] then return end

	local tab = PLAYERS[ply]

	if !IsValid( tab ) then
		PLAYERS[ply] = nil
		return
	end

	tab.ranks = {}
	tab.crank = 0
	tab.rankw = {}

	local rank = ply:GetUserGroup()
	local ignore = false
	for k, v in pairs( playerRanks.ranks ) do
		if k == rank then
			if v then
				local color = IsColor( v ) and v or playerRanks.default
				table.insert( tab.ranks, { k, color, 20 } )
			end

			ignore = true

			break
		end
	end

	if !ignore then
		table.insert( tab.ranks, { rank, playerRanks.default, 20 } )
	end

	for k, v in pairs( customRanks ) do
		local shouldhave = false

		if isstring( v.func ) then
			if ply:SteamID64() == v.func then
				shouldhave = true
			end
		elseif istable( v.func ) then
			for i, v in ipairs( v.func ) do
				if ply:SteamID64() == v then
					shouldhave = true
					break
				end
			end
		elseif isfunction( v.func ) then
			shouldhave = v.func( ply )
		end

		if shouldhave then
			table.insert( tab.ranks, { k, v.color, v.sorting } )
		end
	end

	table.sort( tab.ranks, function( a, b ) return a[3] < b[3] end )
end

local function createPlayerTab( ply, pnl )
	local tab = vgui.Create( "DPanel", pnl )
	tab.Player = ply

	tab:Dock( TOP )
	tab:DockMargin( 3, 5, 3, 5 )
	tab:SetZPos( 9999 + ply:EntIndex() )
	tab.Think = function( self )
		if !IsValid( ply ) then
			self:SetZPos( 9999 )
			self:Remove()
			return
		end

		local lp = LocalPlayer()
		local sorting = ply:IsActive() and SORT.unknown or SORT.inactive
		local color = !ply:IsActive() and Color( 100, 100, 100, 255 )
		self.BackgroundAlpha = ply:IsActive() and 225 or 100

		local id = GetPlayerID( ply )
		if id and id.team then
			color = SCPTeams.GetColor( id.team )

			if id.team == lp:SCPTeam() then
				sorting = SORT.teammates
			elseif SORT[id.team] then
				sorting = SORT[id.team]
			else
				sorting = SORT.other
			end
		end

		if ply == lp then
			sorting = SORT.localplayer
		end

		if self.ranks and self.ranks[1] then
			if self.ranks[1][3] < sorting then
				sorting = self.ranks[1][3]
			end
		end

		if color then
			self.Color = color
			self.TextColor = color
		else
			self.Color = self._Color
			self.TextColor = self._TextColor
		end

		self:SetZPos( sorting * 1500 - ply:SCPPrestige() * 10 - ply:SCPLevel() + ply:EntIndex() )
	end

	tab.PerformLayout = function( self, pw, ph )
		self:SetTall( ScrH() * 0.04 ) --tab:SetTall( ScrH() * 0.04 )
	end

	tab.BackgroundAlpha = 0
	tab._Color = Color( 200, 200, 200, 200 )
	tab._TextColor = COLOR.white

	tab.Color = tab._Color
	tab.TextColor = tab._TextColor

	local avatar_btn = vgui.Create( "DButton", tab )
	avatar_btn:Dock( LEFT )
	avatar_btn:DockMargin( 4, 4, 4, 4 )
	avatar_btn.Paint = function( self, pw, ph )
		surface.SetDrawColor( tab.Color )
		surface.DrawRect( 0, 0, pw, ph )
	end
	avatar_btn.DoClick = function( self )
		ply:ShowProfile()
	end
	avatar_btn.PerformLayout = function( self, pw, ph )
		self:SetWide( ph )
	end

	local avatar = vgui.Create( "AvatarImage", avatar_btn )
	avatar:Dock( FILL )
	avatar:DockMargin( 1, 1, 1, 1 )
	avatar:SetPlayer( ply, 64 )
	avatar:SetMouseInputEnabled( false )

	local name = vgui.Create( "DLabel", tab )
	name:Dock( LEFT )
	name:DockMargin( 4, 4, 4, 4 )
	name:SetFont( "SCPHUDMedium" )
	name:SetText( LANG.unconnected or "" )
	name:SetContentAlignment( 5 )
	name:SetTextInset( 10, 0 )
	name.Paint = function( self, pw, ph ) 
		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end
	name.Think = function( self )
		if !IsValid( ply ) then return end

		self:SetText( ply:Nick() )
		self:SetTextColor( tab.TextColor )
	end
	name.PerformLayout = function( self, pw, ph )
		self:SetWide( pnl:GetWide() * 0.2 )
	end

	local mute = vgui.Create( "DButton", tab )
	mute:Dock( RIGHT )
	mute:DockMargin( 4, 4, 4, 4 )
	mute:SetText( "" )
	mute.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.white )

		if IsValid( ply ) and ply:IsMuted() then
			surface.SetMaterial( MATS.muted )
		else
			surface.SetMaterial( MATS.unmuted )
		end

		surface.DrawTexturedRect( 0, 0, pw, ph )

		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end
	mute.DoClick = function( self )
		if input.IsKeyDown( KEY_LCONTROL ) then
			ply:SetMuted( !ply:IsMuted() )
			SCOREBOARD.VolumeSlider = nil
		else
			if SCOREBOARD.VolumeSlider == tab then
				SCOREBOARD.VolumeSlider = nil
			else
				SCOREBOARD.VolumeSlider = tab
			end
		end
	end
	mute.DoRightClick = function( self )
		ply:SetMuted( !ply:IsMuted() )
		SCOREBOARD.VolumeSlider = nil
	end
	mute.PerformLayout = function( self, pw, ph )
		self:SetWide( ph )
	end
	tab.Mute = mute

	local ping = vgui.Create( "DLabel", tab )
	ping:Dock( RIGHT )
	ping:DockMargin( 4, 4, 4, 4 )
	ping:SetText( "" )
	ping.Paint = function( self, pw, ph )
		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local text = IsValid( ply ) and math.min( ply:Ping(), 999 ) or "-"
		draw.Text{
			text = text,
			pos = { pw * 0.5, ph * 0.5 },
			color = COLOR.white,//tab.TextColor,
			font = "SCPNumbersSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
	ping.PerformLayout = function( self, pw, ph )
		self:SetWide( pnl:GetWide() * 0.05 )
	end

	local prestige = vgui.Create( "DLabel", tab )
	prestige:Dock( RIGHT )
	prestige:DockMargin( 4, 4, 4, 4 )
	prestige:SetText( "" )
	prestige.Paint = function( self, pw, ph )
		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local text = IsValid( ply ) and math.min( ply:SCPPrestige(), 9999 ) or "-"
		draw.Text{
			text = text,
			pos = { pw * 0.5, ph * 0.5 },
			color = COLOR.white,//tab.TextColor,
			font = "SCPNumbersSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
	prestige.PerformLayout = function( self, pw, ph )
		self:SetWide( pnl:GetWide() * 0.1 )
	end

	local level = vgui.Create( "DLabel", tab )
	level:Dock( RIGHT )
	level:DockMargin( 4, 4, 4, 4 )
	level:SetText( "" )
	level.Paint = function( self, pw, ph )
		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local text = IsValid( ply ) and math.Clamp( ply:SCPLevel(), 0, 10 ) or "-"
		draw.Text{
			text = text,
			pos = { pw * 0.5, ph * 0.5 },
			color = COLOR.white,//tab.TextColor,
			font = "SCPNumbersSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
	level.PerformLayout = function( self, pw, ph )
		self:SetWide( pnl:GetWide() * 0.075 )
	end

	local score = vgui.Create( "DLabel", tab )
	score:Dock( RIGHT )
	score:DockMargin( 4, 4, 4, 4 )
	score:SetText( "" )
	score.Paint = function( self, pw, ph )
		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local text = IsValid( ply ) and math.Clamp( ply:Frags(), 0, 9999 ) or "-"
		draw.Text{
			text = text,
			pos = { pw * 0.5, ph * 0.5 },
			color = COLOR.white,//tab.TextColor,
			font = "SCPNumbersSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
	score.PerformLayout = function( self, pw, ph )
		self:SetWide( pnl:GetWide() * 0.1 )
	end

	local ranks = vgui.Create( "DPanel", tab )
	ranks:Dock( FILL )
	ranks:DockMargin( 4, 4, 4, 4 )
	ranks.Paint = function( self, pw, ph )
		surface.SetDrawColor( tab.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local totalw = 0
		local widths = {}
		local texts = {}

		surface.SetFont( "SCPHUDVSmall" )
		for i, v in ipairs( tab.ranks ) do
			local text = LANG.ranks[v[1]] or v[1]
			local w = surface.GetTextSize( text )

			totalw = totalw + w + 16 // 4 * 4
			texts[i] = text
			widths[i] = w
		end

		if totalw <= pw then
			totalw = 4

			for i, v in ipairs( tab.ranks ) do
				surface.SetDrawColor( v[2] )
				surface.DrawRect( totalw, 4, widths[i] + 8, ph - 8 )

				draw.Text{
					text = texts[i],
					pos = { totalw + ( widths[i] + 8 ) * 0.5, ph * 0.5 },
					color = COLOR.white,
					font = "SCPHUDVSmall",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}

				totalw = totalw + widths[i] + 16
			end
		else
			local px, py = self:LocalToScreen( 0, 0 )
			totalw = 4

			surface.SetDrawColor( COLOR.white )
			surface.DrawRect( px, py, 8, 8 )

			for i, v in ipairs( tab.ranks ) do
				local cw = tab.rankw[i]


				if !cw then
					cw = 8
				end

				local btn = Button( px + totalw, py + 4, cw + 8, ph - 8 )

				if btn > 0 then
					tab.crank = i
				end

				if tab.crank == i then
					if btn == 0 then
						tab.crank = 0
					else
						cw = math.min( cw + RealFrameTime() * 150, widths[i] )
					end
				elseif cw > 8 then
					cw = math.max( cw - RealFrameTime() * 150, 8 )
				end

				surface.SetDrawColor( v[2] )
				surface.DrawRect( totalw, 4, cw + 8, ph - 8 )

				if cw > 8 then
					draw.LimitedText{
						text = texts[i],
						pos = { totalw + ( cw + 8 ) * 0.5, ph * 0.5 },
						color = COLOR.white,
						font = "SCPHUDVSmall",
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER,
						max_width = cw,
					}
				end

				totalw = totalw + cw + 12
				tab.rankw[i] = cw
			end
		end
	end

	tab.Paint = function( self, pw, ph )
		/*render.SetStencilTestMask( 0xFF )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilPassOperation( STENCIL_INCR )
		render.SetStencilFailOperation( STENCIL_INCR )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilReferenceValue( 1 )

		render.ClearStencil()
		render.SetStencilEnable( true )

		draw.NoTexture()
		surface.SetDrawColor( Color( 0, 0, 0, self.BackgroundAlpha ) )
		surface.DrawPoly{
			{ x = 0, y = 0 },
			{ x = pw, y = 0 },
			{ x = pw, y = ph },
			{ x = 0, y = ph },
		}

		render.SetStencilCompareFunction( STENCIL_ALWAYS )

		surface.DrawPoly{
			{ x =  1, y = 1 },
			{ x = pw - 1, y = 1 },
			{ x = pw - 1, y = ph - 1 },
			{ x = 1, y = ph - 1 },
		}

		render.SetStencilCompareFunction( STENCIL_EQUAL )

		surface.SetDrawColor( self.Color )
		surface.DrawRect( 0, 0, pw, ph )

		render.SetStencilEnable( false )*/

		surface.SetDrawColor( Color( 0, 0, 0, self.BackgroundAlpha ) )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( self.Color )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local x, y, w, h = avatar_btn:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x + w + 3, y + 2, 2, h - 4 )

		local x, y, w, h = name:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x + w + 3, y + 2, 2, h - 4 )

		local x, y, w, h = mute:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x - 5, y + 2, 2, h - 4 )

		local x, y, w, h = ping:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x - 5, y + 2, 2, h - 4 )

		local x, y, w, h = prestige:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x - 5, y + 2, 2, h - 4 )

		local x, y, w, h = level:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x - 5, y + 2, 2, h - 4 )

		local x, y, w, h = score:GetBounds()
		surface.SetDrawColor( self.Color )
		surface.DrawRect( x - 5, y + 2, 2, h - 4 )
	end

	return tab
end


local function createScoreboard()
	local w, h = ScrW(), ScrH()

	local container = vgui.Create( "DPanel" )
	container:SetSize( w * 0.7, h * 0.9 )
	container:Center()
	container:MakePopup()
	container:SetKeyboardInputEnabled( false )
	container.Paint = function( self, pw, ph )
		//surface.SetDrawColor( Color( 255, 255, 255, 20 ) )
		//surface.DrawRect( 0, 0, pw, ph )

		render.SetStencilTestMask( 0xFF )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilPassOperation( STENCIL_INCR )
		render.SetStencilFailOperation( STENCIL_INCR )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilReferenceValue( 1 )

		render.ClearStencil()
		render.SetStencilEnable( true )

		draw.NoTexture()
		surface.SetDrawColor( Color( 0, 0, 0, 225 ) )
		surface.DrawPoly{
			{ x = ph * 0.02, y = 0 },
			{ x = pw - ph * 0.02, y = 0 },
			{ x = pw, y = ph * 0.06 },
			{ x = 0, y = ph * 0.06 },
		}

		render.SetStencilCompareFunction( STENCIL_ALWAYS )

		surface.DrawPoly{
			{ x = ph * 0.02 + 1, y = 2 },
			{ x = pw - ph * 0.02 - 1, y = 2 },
			{ x = pw - 2, y = ph * 0.06 - 2 },
			{ x = 2, y = ph * 0.06 - 2 },
		}

		render.SetStencilCompareFunction( STENCIL_EQUAL )

		surface.SetDrawColor( Color( 200, 200, 200, 200 ) )
		surface.DrawRect( 0, 0, pw, ph * 0.1 )

		render.SetStencilEnable( false )

		local lx = ScrH() * 0.04 + 7
		local lw = pw * 0.2

		draw.LimitedText{
			text = LANG.scoreboard.playername,
			pos = { lx + lw * 0.5, ph * 0.03 },
			color = COLOR.white,
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = lw
		}

		lx = lx + lw + 8

		local rx = pw - ScrH() * 0.04 - 7
		local rw = pw * 0.05

		draw.LimitedText{
			text = LANG.scoreboard.ping,
			pos = { rx - rw * 0.5, ph * 0.03 },
			color = COLOR.white,
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = rw
		}

		rx = rx - rw - 8
		rw = pw * 0.1

		draw.LimitedText{
			text = LANG.scoreboard.prestige,
			pos = { rx - rw * 0.5, ph * 0.03 },
			color = COLOR.white,
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = rw
		}

		rx = rx - rw - 8
		rw = pw * 0.075

		draw.LimitedText{
			text = LANG.scoreboard.level,
			pos = { rx - rw * 0.5, ph * 0.03 },
			color = COLOR.white,
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = rw
		}

		rx = rx - rw - 8
		rw = pw * 0.1

		draw.LimitedText{
			text = LANG.scoreboard.score,
			pos = { rx - rw * 0.5, ph * 0.03 },
			color = COLOR.white,
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = rw
		}

		rx = rx - rw - 8
		lw = rx - lx

		draw.LimitedText{
			text = LANG.scoreboard.ranks,
			pos = { lx + lw * 0.5, ph * 0.03 },
			color = COLOR.white,
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			max_width = lw
		}

		self.DrawArrowUp = false
		self.DrawArrowDown = false

		local diff_h = self.Players:GetCanvas():GetTall() - self.Players:GetTall()
		if diff_h > 0 then
			local scroll = self.Players:GetVBar():GetScroll()
			
			if scroll > 0 then
				self.DrawArrowUp = true
			end

			if scroll < diff_h then
				self.DrawArrowDown = true
			end
		end
	end
	container.Think = function( self )
		for i, v in ipairs( player.GetAll() ) do
			if !IsValid( PLAYERS[v] ) then
				//print( "Creating", v )
				local tab = createPlayerTab( v, self.Players )
				PLAYERS[v] = tab

				applyPlayerRanks( v )
			end
		end
	end
	container.PerformLayout = function( self, pw, ph )
		local h = ScrH()

		self:SetSize( ScrW() * 0.7, h * 0.9 )
		self:Center()
		self.Players:DockMargin( 0, h * 0.06, 0, 0 )
	end

	local _show = container.Show
	container.Show = function( self )
		for i, v in ipairs( player.GetAll() ) do
			if IsValid( PLAYERS[v] ) then
				applyPlayerRanks( v ) --Update ranks each time player opens scoreboard
			end
		end

		_show( self )
	end

	container.Players = vgui.Create( "DScrollPanel", container )
	container.Players:Dock( FILL )
	container.Players:DockMargin( 0, h * 0.06, 0, 0 )
	container.Players.Paint = function( self, pw, ph ) end
	container.Players:GetVBar():SetWide( 0 )
	container.Players:InvalidateParent( true )

	local _OnMouseWheeled = container.Players.OnMouseWheeled
	container.Players.OnMouseWheeled = function( self, delta )
		if container.Players:GetVBar():IsVisible() then
			SCOREBOARD.VolumeSlider = nil
		end

		_OnMouseWheeled( self, delta )
	end

	SCOREBOARD = container
end

/*function GM:HUDDrawScoreBoard() --TODO: buttons to class viewer, stat viewer and settings
	if !ScoreboardVisible then return end

	//local w, h = ScrW(), ScrH()

	
end*/

function GM:ScoreboardShow()
	next_frame = true
	ScoreboardVisible = true

	HideEQ()

	if !IsValid( SCOREBOARD ) then
		createScoreboard()
	else
		SCOREBOARD:Show()
	end
end

function GM:ScoreboardHide()
	ScoreboardVisible = false

	SCOREBOARD.VolumeSlider = nil
	SCOREBOARD:Hide()
	//SCOREBOARD:Remove()
end

local holdingVC = false
hook.Add( "DrawOverlay", "ScoreboardArrow", function()
	if holdingVC and !input.IsButtonDown( MOUSE_LEFT ) then
		holdingVC = false
	end

	if IsValid( SCOREBOARD ) and SCOREBOARD:IsVisible() then
		local w, h = ScrW(), ScrH()

		local x, y = w * 0.15, h * 0.11
		local pw, ph = SCOREBOARD.Players:GetSize()

		PushFilters( TEXFILTER.LINEAR )

		if SCOREBOARD.DrawArrowUp then
			surface.SetMaterial( MATS.arrow_up )
			surface.SetDrawColor( Color( 255, 255, 255, math.TimedSinWave( 0.75, 0, 255 ) ) )
			surface.DrawTexturedRect( x + pw, y, 32, 32 )
		end

		if SCOREBOARD.DrawArrowDown then
			surface.SetDrawColor( Color( 255, 255, 255, math.TimedSinWave( 0.75, 0, 255 ) ) )
			surface.SetMaterial( MATS.arrow_down )
			surface.DrawTexturedRect( x + pw, y + ph - 32, 32, 32 )
		end

		PopFilters()

		local tab = SCOREBOARD.VolumeSlider
		if tab and IsValid( tab.Player ) then
			local px, py = SCOREBOARD.Players:LocalToScreen( tab:GetPos() )
			local pw, ph = tab:GetSize()

			surface.SetDrawColor( Color( 0, 0, 0, tab.BackgroundAlpha ) )
			surface.DrawRect( px + pw + w * 0.01, py, w * 0.11, ph )

			surface.SetDrawColor( tab._Color )
			surface.DrawOutlinedRect( px + pw + w * 0.01, py, w * 0.11, ph )

			local nx, ny = px + pw + w * 0.02, py + ph * 0.5
			local nw = w * 0.09
			surface.SetDrawColor( Color( 75, 75, 75, 255 ) )
			surface.DrawRect( nx, ny - 1, nw, 2 )

			local muted = tab.Player:IsMuted()
			local vol = tab.Player:GetVoiceVolumeScale()

			if muted then
				vol = 0
			end

			draw.NoTexture()
			local cpx = nx + nw * vol
			local mx, my = input.GetCursorPos()
			local dx, dy = cpx - mx, ny - my

			local hover = dx * dx + dy * dy <= 36
			local lmb = input.IsButtonDown( MOUSE_LEFT )

			if lmb then
				if hover then
					holdingVC = true
				elseif math.abs( dy ) <= 6 and mx >= nx and mx <= nx + nw then
					cpx = mx

					vol = ( cpx - nx ) / nw
					tab.Player:SetVoiceVolumeScale( vol )
				end
			end

			if holdingVC then
				cpx = mx

				if cpx < nx then
					cpx = nx
				end

				if cpx > nx + nw then
					cpx = nx + nw
				end

				vol = ( cpx - nx ) / nw
				tab.Player:SetVoiceVolumeScale( vol )
			end

			if !muted and vol == 0 then
				tab.Player:SetMuted( true )
			elseif muted and vol > 0 then
				tab.Player:SetMuted( false )
			end

			surface.SetDrawColor( Color( 175, 175, 175, 255 ) )
			surface.DrawRect( nx, ny - 1, nw * vol, 2 )

			if holdingVC or hover then
				surface.SetDrawColor( Color( 225, 225, 225, 255 ) )
			end

			surface.DrawFilledCircle( cpx, ny, 6, 12 )

		end
	end
end )

//RemoveAllDerma()