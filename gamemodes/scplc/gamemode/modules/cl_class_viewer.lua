//CLASS_VIEWER = CLASS_VIEWER

local MATS = {
	blur = Material( "pp/blurscreen" ),
	exit = Material( "hud_scp/exit.png" )
}

local cache = {}

local showinfo = {
	major = 0,
	minor = 0,
	class = 0
}

local showdetails = {
	"name",
	"team",
	"level",
	"health",
	"walk_speed",
	"run_speed",
	"chip",
	"persona",
	"weapons",
	"hp",
	"speed",
}

local headers = {
	"classes",
	"support",
	"scp"
}

ShowSCPs = {}

local recomputed = false
local rebuildView, addHeader, addCategory

function addHeader( name, p, h, id )
	name = LANG.headers[name] or name

	local button = vgui.Create( "DButton", p )
	button:Dock( TOP )
	button:DockMargin( 5, 5, 5, 0 )
	button:SetTall( h )
	button:SetText( "" )
	button.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		surface.SetDrawColor( Color( 150, 150, 150, 50 ) )
		surface.DrawRect( 0, 0, pw, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	button.DoClick = function( self )
		if showinfo.major == self.major then
			showinfo.major = 0
		else
			showinfo.major = self.major
			showinfo.minor = 0
		end

		rebuildView()
	end

	button.major = id
end

function addCategory( name, p, h, id )
	name = LANG.view_cat[name] or name

	local button = vgui.Create( "DButton", p )
	button:Dock( TOP )
	button:DockMargin( 5, 5, 5, 0 )
	button:SetTall( h )
	button:SetText( "" )
	button.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( pw * 0.05, 0, pw * 0.9, ph )

		surface.SetDrawColor( Color( 150, 150, 175, 100 ) )
		surface.DrawRect( pw * 0.05, 0, pw * 0.9, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	button.DoClick = function( self )
		if showinfo.minor == self.minor then
			showinfo.minor = 0
		else
			showinfo.minor = self.minor
		end

		rebuildView()
	end

	button.minor = id
end

local function addClass( tab, p, h )
	local _name = tab.name
	local name = LANG.CLASSES[tab.name] or tab.name

	local ply = LocalPlayer()
	local owned = nil

	if tab.override then
		local result = tab.override( ply )

		if result then
			owned = true
		elseif result == false then
			owned = false
		end
	end

	if owned == nil then
		owned = ply:SCPLevel() >= tab.level
	end

	local button = vgui.Create( "DButton", p )
	button:Dock( TOP )
	button:DockMargin( 5, 5, 5, 0 )
	button:SetTall( h )
	button:SetText( "" )
	button.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( pw * 0.1, 0, pw * 0.8, ph )

		surface.SetDrawColor( owned and Color( 120, 150, 120, 75 ) or Color( 150, 120, 120, 75 ) )
		surface.DrawRect( pw * 0.1, 0, pw * 0.8, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.NoTexture()
		surface.SetDrawColor( SCPTeams.getColor( tab.team ) )
		surface.DrawPoly{
			{ x = pw * 0.9 - ph * 0.5, y = ph * 0.1 },
			{ x = pw * 0.9 - ph * 0.1, y = ph * 0.1 },
			{ x = pw * 0.9 - ph * 0.1, y = ph * 0.5 },
		}
	end

	button.DoClick = function( self )
		showinfo.details = tab

		local model = cache[_name]

		if !model then
			model = istable( tab.model ) and table.Random( tab.model ) or tab.model
			cache[_name] = model
		end

		showinfo.mvp:SetModel( model )
	end
end

local function addSCP( tab, p, h )
	local _name = tab.name
	local name = LANG.CLASSES[tab.name] or tab.name

	local button = vgui.Create( "DButton", p )
	button:Dock( TOP )
	button:DockMargin( 5, 5, 5, 0 )
	button:SetTall( h )
	button:SetText( "" )
	button.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( pw * 0.1, 0, pw * 0.8, ph )

		surface.SetDrawColor( Color( 120, 150, 120, 75 ) )
		surface.DrawRect( pw * 0.1, 0, pw * 0.8, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.NoTexture()
		surface.SetDrawColor( SCPTeams.getColor( TEAM_SCP ) )
		surface.DrawPoly{
			{ x = pw * 0.9 - ph * 0.5, y = ph * 0.1 },
			{ x = pw * 0.9 - ph * 0.1, y = ph * 0.1 },
			{ x = pw * 0.9 - ph * 0.1, y = ph * 0.5 },
		}
	end

	button.DoClick = function( self )
		showinfo.details = tab

		local model = cache[_name]

		if !model then
			model = istable( tab.model ) and table.Random( tab.model ) or tab.model
			cache[_name] = model
		end

		showinfo.mvp:SetModel( model )
	end
end

function rebuildView()
	if !IsValid( showinfo.panel ) then return end
	if !LANG.headers then return end

	local h = ScrH()
	local groups = getGroups()

	local panel = showinfo.panel

	for k, v in pairs( panel:GetChildren() ) do
		if IsValid( v ) then
			v:Remove()
		end
	end

	for i, v in ipairs( headers ) do
		addHeader( v, panel, h * 0.05, i )

		if i == showinfo.major then
			if v == "scp" then
				for i, v in ipairs( ShowSCPs ) do
					addSCP( v, panel, h * 0.05 )
				end
			else
				local usetab = v == "support" and groups.SUPPORT or groups

				for category_name, tab in pairs( usetab ) do
					if category_name != "SUPPORT" then
						addCategory( category_name, panel, h * 0.05, category_name )

						if showinfo.minor == category_name then
							local class_tab = {}

							for k, v in pairs( tab ) do
								//local nt = table.Copy( v )
								//nt.name = k

								table.insert( class_tab, v )
							end

							table.sort( class_tab, function( a, b ) return a.level < b.level end )

							for _, class in pairs( class_tab ) do
								addClass( class, panel, h * 0.05 )
							end
						end
					end
				end
			end
		end
	end
end

local function basicText( text, x, y, maxw )
	local _, th = draw.LimitedText{
		text = text,
		pos = { x, y },
		font = "SCPHUDSmall",
		color = Color( 255, 255, 255, 255 ),
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
		max_width = maxw
	}

	return th
end

local function OpenViewer()
	local w, h = ScrW(), ScrH()

	local window = vgui.Create( "DFrame" )
	CLASS_VIEWER = window

	window:SetSize( w * 0.8, h * 0.8 )
	window:SetTitle( "" )
	window:ShowCloseButton( false )
	window:SetDraggable( false )
	window:Center()
	window:MakePopup()
	window.Paint = function( self, pw, ph )
		render.UpdateScreenEffectTexture()
		MATS.blur:SetFloat( "$blur", 8 )

		if !recomputed then
			recomputed = true
			MATS.blur:Recompute()
		end

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( MATS.blur )
		surface.DrawTexturedRect( -w * 0.1, -h * 0.1, w, h )

		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		surface.DrawRect( 0, 0, pw, ph )

		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		surface.DrawRect( 0, 0, pw, h * 0.035 )

		draw.Text{
			text = LANG.classviewer,
			pos = { w * 0.01, ph * 0.02 },
			font = "SCPHUDMedium",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	local exit_b = vgui.Create( "DButton", window )
	exit_b:SetSize( w * 0.02, h * 0.02 )
	exit_b:AlignRight( w * 0.01 )
	exit_b:AlignTop( h * 0.0075 )
	exit_b:SetText( "" )
	exit_b.Paint = function( self, pw, ph )
		draw.RoundedBox( 6, 0, 0, pw, ph, Color( 255, 0, 0, 150 ))

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( MATS.exit )
		surface.DrawTexturedRect( pw * 0.5 - h * 0.008, ph * 0.5 - h * 0.007, h * 0.0175, h * 0.0175 )
	end

	exit_b.DoClick = function( self )
		window:Close()
	end

	local classselect = vgui.Create( "DScrollPanel", window )
	classselect:Dock( LEFT )
	classselect:DockMargin( 2, 7, 2, 2 )
	classselect:SetWide( w * 0.35 )
	classselect.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end
	classselect:GetVBar():SetWide( 0 )

	showinfo.panel = classselect:GetCanvas()
	rebuildView()

	local c = vgui.Create( "DPanel", window )
	c:Dock( TOP )
	c:DockMargin( 2, 7, 2, 2 )
	c:SetTall( h * 0.4 )
	c.Paint = function() end

	local mv = vgui.Create( "DModelPanel", c )
	mv:Dock( LEFT )
	mv:SetWide( w * 0.2 )

	local paint = mv.Paint
	mv.Paint = function( self, pw, ph )
		paint( self, pw, ph )

		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.preview,
			pos = { 5, 0 },
			font = "SCPHUDSmall",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	showinfo.mvp = mv

	local details = vgui.Create( "DPanel", c )
	details:Dock( FILL )
	details:DockMargin( 4, 0, 0, 0 )
	details.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local totalh = -self.scroll + 5
		totalh = totalh + basicText( LANG.details.details..":", 5, totalh ) + 5

		local tab = showinfo.details
		if tab then
			for i, v in ipairs( showdetails ) do
				local val = tab[v]
				if isstring( val ) or isnumber( val ) then
					if v == "name" then
						val = LANG.CLASSES[val] or val
					elseif v == "team" then
						local t = SCPTeams.getName( val )
						val = LANG.TEAMS[t] or val
					elseif v == "chip" then
						--TODO
					end

					totalh = totalh + basicText( "\t"..(LANG.details[v] or v)..":   "..val, 5, totalh ) + 5
				elseif istable( val ) and table.Count( val ) > 0 then
					totalh = totalh + basicText( "\t"..(LANG.details[v] or v)..":   ", 5, totalh ) - 3
					for key, data in pairs( val ) do
						local txt = "\t\t"

						if v == "weapons" then
							if istable( data ) then
								txt = txt..LANG.random..":"
								totalh = totalh + basicText( txt, 5, totalh ) - 3
								for _, v in pairs( data ) do
									txt = "\t\t\t\t"

									local wep = weapons.GetStored( v )

									if wep and wep.Language then
										local name = LANG.WEAPONS[wep.Language] and ( LANG.WEAPONS[wep.Language].showname or LANG.WEAPONS[wep.Language].name ) or v
										txt = txt..name
									elseif wep and wep.PrintName then
										txt = txt..wep.PrintName
									else
										local name = LANG.WEAPONS[v] or v
										txt = txt..name
									end

									totalh = totalh + basicText( txt, 5, totalh ) - 3
								end

								continue
							else
								local wep = weapons.GetStored( data )

								if wep and wep.Language then
									local name = LANG.WEAPONS[wep.Language] and LANG.WEAPONS[wep.Language].name or data
									txt = txt..name
								elseif wep and wep.PrintName then
									txt = txt..wep.PrintName
								else
									local name = LANG.WEAPONS[data] or data
									txt = txt..name
								end
							end
						else
							if LANG.details[key] then
								txt = txt..LANG.details[key]..":   "
							elseif isstring( key ) then
								txt = txt..key..":   "
							end

							if key == "class" then
								txt = txt..( LANG.CLASSES[data] or data )
							elseif key == "team" then
								local t = SCPTeams.getName( data )
								txt = txt..( LANG.TEAMS[t] or data )
							elseif isstring( data ) or isnumber( data ) then
								txt = txt..data
							end
						end

						totalh = totalh + basicText( txt, 5, totalh ) - 3
					end

					totalh = totalh + 5
				end
			end
		end

		totalh = totalh + self.scroll
		self.maxScroll = math.max( totalh - ph, 0 )
	end
	details.OnMouseWheeled = function( self, delta )
		self.scroll = math.Clamp( self.scroll - delta * 8, 0, self.maxScroll )
	end
	details.scroll = 0
	details.maxScroll = 0

	local info = vgui.Create( "DPanel", window )
	info:Dock( FILL )
	info:DockMargin( 2, 2, 2, 2 )
	info.Paint = function( self, pw, ph )
		surface.SetDrawColor( Color( 150, 150, 150, 100 ) )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.info..":",
			pos = { 5, 0 },
			font = "SCPHUDSmall",
			color = Color( 255, 255, 255, 255 ),
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}

		--TODO
	end
end

function OpenClassViever()
	if IsValid( CLASS_VIEWER ) then CLASS_VIEWER:Close() end

	showinfo.major = 0
	showinfo.minor = 0
	showinfo.class = 0
	showinfo.details = nil

	OpenViewer()
end

/*timer.Simple( 0, function()
	OpenClassViever()
end )*/