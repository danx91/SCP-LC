//CLASS_VIEWER = CLASS_VIEWER
local roman_tab = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X" }

local MATS = {
	blur = Material( "pp/blurscreen" ),
	exit = Material( "slc/hud/exit.png", "smooth" ),
	locked = Material( "slc/hud/upgrades/locked.png", "smooth" ),
}

local COLOR = {
	outline = Color( 150, 150, 150, 100 ),
	unlocked = Color( 120, 150, 120, 75 ),
	locked = Color( 150, 120, 120, 75 ),
	tier_locked = Color( 120, 120, 120, 75 ),
	white = Color( 255, 255, 255, 255 ),
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
	"tier",
	"health",
	"sanity",
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
CLASS_VIEWER_OVERRIDE = {}

function ClassViewerOverride( model, data )
	CLASS_VIEWER_OVERRIDE[model] = data
end

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
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		surface.SetDrawColor( 150, 150, 150, 50 )
		surface.DrawRect( 0, 0, pw, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.white,
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
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( pw * 0.05, 0, pw * 0.9, ph )

		surface.SetDrawColor( 150, 150, 175, 100 )
		surface.DrawRect( pw * 0.05, 0, pw * 0.9, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.white,
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
	local override = nil

	if tab.override then
		local result = tab.override( ply )

		if result then
			override = true
		elseif result == false then
			override = false
		end
	end

	local button = vgui.Create( "DButton", p )
	button:Dock( TOP )
	button:DockMargin( 5, 5, 5, 0 )
	button:SetTall( h )
	button:SetText( "" )
	button.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( pw * 0.1, 0, pw * 0.8, ph )

		local tier_lock = !ply:CanUnlockClassTier( tab.tier )

		if override == true or override == nil and ply:IsClassUnlocked( tab.name ) then
			surface.SetDrawColor( COLOR.unlocked )
		elseif tier_lock then
			surface.SetDrawColor( COLOR.tier_locked )
		else
			surface.SetDrawColor( COLOR.locked )
		end

		surface.DrawRect( pw * 0.1, 0, pw * 0.8, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = tier_lock and Color( 225, 225, 225, 175 ) or COLOR.white,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.NoTexture()
		surface.SetDrawColor( SCPTeams.GetColor( tab.team ) )
		surface.DrawPoly{
			{ x = pw * 0.9 - ph * 0.5, y = ph * 0.1 },
			{ x = pw * 0.9 - ph * 0.1, y = ph * 0.1 },
			{ x = pw * 0.9 - ph * 0.1, y = ph * 0.5 },
		}

		if tab.tier and tab.tier > 0 then
			draw.Text{
				text = roman_tab[tab.tier] or ( "T"..tab.tier  ),
				pos = { pw * 0.05, ph * 0.5 },
				font = "SCPInfoScreenSmall",
				color = COLOR.white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		if tier_lock then
			surface.SetDrawColor( 255, 255, 255, 33 )
			surface.SetMaterial( MATS.locked )
			surface.DrawTexturedRect( pw * 0.1 + ph * 0.1, ph * 0.1, ph * 0.8, ph * 0.8 )
		end
	end

	button.DoClick = function( self )
		showinfo.details = tab

		local model = cache[_name]
		if !model then
			if tab.vest then
				local vest = VEST.GetID( tab.vest )
				if vest then
					local data = VEST.GetData( vest )
					if data then
						model = { istable( data.model ) and table.Random( data.model ) or data.model, data.skin, data.bodygroups }
						cache[_name] = model
					end
				end
			end

			if !model then
				model = { istable( tab.model ) and table.Random( tab.model ) or tab.model, tab.skin, tab.bodygroups }
				cache[_name] = model
			end
		end

		local mdl_override = CLASS_VIEWER_OVERRIDE[_name]
		if mdl_override then
			if mdl_override.model then
				model[1] = mdl_override.model
			end

			if mdl_override.skin then
				model[2] = mdl_override.skin
			end

			if mdl_override.bodygroups then
				model[3] = mdl_override.bodygroups
			end
		end

		showinfo.mvp:SetModel( model[1] )

		local ent = showinfo.mvp:GetEntity()

		if model[2] then
			ent:SetSkin( model[2] )
		end

		if model[3] then
			for k, v in pairs( model[3] ) do
				if isstring( k ) then
					k = ent:FindBodygroupByName( k )
				end

				if k > -1 then
					ent:SetBodygroup( k, v )
				end
			end
		end

		local seq = ent:SelectWeightedSequence( ACT_HL2MP_IDLE )
		if seq > -1 then
			ent:SetSequence( seq )
		end

		showinfo.mvp:Update( tab.name )
	end

	button.DoDoubleClick = function( self )
		if !ply:IsClassUnlocked( tab.name ) and ply:UnlockClass( tab.name ) then
			showinfo.mvp.buy:SetVisible( false )
		end
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
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( pw * 0.1, 0, pw * 0.8, ph )

		surface.SetDrawColor( COLOR.unlocked )
		surface.DrawRect( pw * 0.1, 0, pw * 0.8, ph )

		draw.Text{
			text = name,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDMedium",
			color = COLOR.white,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.NoTexture()
		surface.SetDrawColor( SCPTeams.GetColor( TEAM_SCP ) )
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

		local ent = showinfo.mvp:GetEntity()
		local seq = ent:SelectWeightedSequence( ACT_HL2MP_IDLE )
		if seq > -1 then
			ent:SetSequence( seq )
		end

		showinfo.mvp:Update( tab.name )
	end
end

function rebuildView()
	if !IsValid( showinfo.panel ) then return end
	if !LANG.headers then return end

	local h = ScrH()
	local groups = GetGroups()

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
				for _, scp in ipairs( ShowSCPs ) do
					addSCP( scp, panel, h * 0.05 )
				end
			else
				local usetab = v == "support" and groups.SUPPORT or groups

				for category_name, tab in pairs( usetab ) do
					if category_name != "SUPPORT" then
						addCategory( category_name, panel, h * 0.05, category_name )

						if showinfo.minor == category_name then
							local class_tab = {}

							for k, val in pairs( tab ) do
								table.insert( class_tab, val )
							end

							table.sort( class_tab, function( a, b ) return ( a.tier or 0 ) < ( b.tier or 0 ) end )

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
		color = COLOR.white,
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_TOP,
		max_width = maxw
	}

	return th
end

local function openViewer()
	local ply = LocalPlayer()
	if !ply.playermeta then return end

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

		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.blur )
		surface.DrawTexturedRect( -w * 0.1, -h * 0.1, w, h )

		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( 0, 0, pw, ph )
		surface.DrawRect( 0, 0, pw, h * 0.035 )

		draw.Text{
			text = LANG.classviewer,
			pos = { pw * 0.01, ph * 0.02 },
			font = "SCPHUDMedium",
			color = COLOR.white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.Text{
			text = LANG.HUD.class_points..": "..ply:SCPClassPoints(),
			pos = { pw * 0.48, ph * 0.02 },
			font = "SCPHUDSmall",
			color = COLOR.white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	local refound_b = vgui.Create( "DButton", window )
	refound_b:SetSize( w * 0.1, h * 0.03 )
	refound_b:AlignRight( w * 0.125 - 14 )
	refound_b:AlignTop( h * 0.0025 )
	refound_b:SetText( "" )
	refound_b.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.refound,
			pos = { pw * 0.5, ph * 0.5 },
			font = "SCPHUDSmall",
			color = COLOR.white,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end

	refound_b.DoClick = function( self )
		self:SetVisible( false )
		net.Ping( "SLCRefoundClasses" )
		ply.playermeta.refound = false
	end
	refound_b:SetVisible( ply.playermeta.refound or false )

	local exit_b = vgui.Create( "DButton", window )
	exit_b:SetSize( w * 0.02, h * 0.02 )
	exit_b:AlignRight( w * 0.01 )
	exit_b:AlignTop( h * 0.0075 )
	exit_b:SetText( "" )
	exit_b.Paint = function( self, pw, ph )
		draw.RoundedBox( 6, 0, 0, pw, ph, Color( 255, 0, 0, 150 ) )

		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.exit )
		surface.DrawTexturedRect( pw * 0.5 - h * 0.008, ph * 0.5 - h * 0.007, h * 0.0175, h * 0.0175 )
	end

	exit_b.DoClick = function( self )
		window:Close()
	end

	local classselect = vgui.Create( "DScrollPanel", window )
	classselect:Dock( LEFT )
	classselect:DockMargin( 2, 14, 2, 2 )
	classselect:SetWide( w * 0.35 )
	classselect.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( 0, 0, pw, ph )
	end
	classselect:GetVBar():SetWide( 0 )

	showinfo.panel = classselect:GetCanvas()
	rebuildView()

	local c = vgui.Create( "DPanel", window )
	c:Dock( TOP )
	c:DockMargin( 2, 14, 2, 2 )
	c:SetTall( h * 0.4 )
	c.Paint = function() end

	local mv = vgui.Create( "DModelPanel", c )
	mv:Dock( LEFT )
	mv:SetWide( w * 0.2 )

	/*mv.LayoutEntity = function( self, ent )

	end*/

	local paint = mv.Paint
	mv.Paint = function( self, pw, ph )
		paint( self, pw, ph )

		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		draw.Text{
			text = LANG.preview,
			pos = { 5, 0 },
			font = "SCPHUDSmall",
			color = COLOR.white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}
	end

	mv.Update = function( self, name )
		self.buy.cur = name
		self.buy:SetVisible( !ply:IsClassUnlocked( name ) )
	end

	local buy = vgui.Create( "DButton", mv )
	buy:Dock( BOTTOM )
	buy:DockMargin( 8, 8, 8, 8 )
	buy:SetTall( h * 0.04 )
	buy:SetText( "" )

	buy.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		if self.cur then
			draw.Text{
				text = LANG.buy,
				pos = { pw * 0.5, ph * 0.5 },
				font = "SCPHUDSmall",
				color = ply:CanUnlockClass( self.cur ) and COLOR.white or Color( 200, 50, 50, 225 ),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end
	end

	buy.DoClick = function( self )
		if ply:UnlockClass( self.cur ) then
			self:SetVisible( false )
		end
	end

	buy:SetVisible( false )

	mv.buy = buy
	showinfo.mvp = mv

	local details = vgui.Create( "DPanel", c )
	details:Dock( FILL )
	details:DockMargin( 4, 0, 0, 0 )
	details.Paint = function( self, pw, ph )
		surface.SetDrawColor( COLOR.outline )
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
						local t = SCPTeams.GetName( val )
						val = LANG.TEAMS[t] or val
					elseif v == "tier" then
						val = val and val <= 0 and 0 or val <= 10 and roman_tab[val] or ( "T"..val )
					elseif v == "chip" then
						if !val or val == "" then
							val = LANG.none
						else
							val = LANG.WEAPONS.ACCESS_CHIP.NAMES[val] or val
						end
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
								for _, wep_class in pairs( data ) do
									txt = "\t\t\t\t"

									local wep = weapons.GetStored( wep_class )

									if wep and wep.Language then
										local name = LANG.WEAPONS[wep.Language] and ( LANG.WEAPONS[wep.Language].showname or LANG.WEAPONS[wep.Language].name ) or wep_class
										txt = txt..name
									elseif wep and wep.PrintName then
										txt = txt..wep.PrintName
									else
										local lang_tab = LANG.WEAPONS[wep_class]
										txt = txt..( istable( lang_tab ) and ( lang_tab.showname or lang_tab.name ) or isstring( lang_tab ) and lang_tab or wep_class )
									end

									totalh = totalh + basicText( txt, 5, totalh ) - 3
								end

								continue
							else
								local wep = weapons.GetStored( data )

								if wep and wep.Language then
									local name = LANG.WEAPONS[wep.Language] and ( LANG.WEAPONS[wep.Language].showname or LANG.WEAPONS[wep.Language].name ) or data
									txt = txt..name
								elseif wep and wep.PrintName then
									txt = txt..wep.PrintName
								else
									local lang_tab = LANG.WEAPONS[data]
									txt = txt..( istable( lang_tab ) and ( lang_tab.showname or lang_tab.name ) or isstring( lang_tab ) and lang_tab or data )
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
								local t = SCPTeams.GetName( data )
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

		if self.scroll > self.maxScroll then
			self.scroll = self.maxScroll
		end
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
		surface.SetDrawColor( COLOR.outline )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		local _, th = draw.Text{
			text = LANG.info..":",
			pos = { 5, 0 },
			font = "SCPHUDSmall",
			color = COLOR.white,
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_TOP,
		}

		if showinfo.details then
			local desc = LANG.CLASS_DESCRIPTION[showinfo.details.name]
			if desc then
				local px, py = self:LocalToScreen()
				local sx, sy = 10, th + 5

				render.SetScissorRect( px, py + sy + 10, px + pw, py + ph - 20, true )

				local height = draw.MultilineText( sx, sy - self.scroll, desc, "SCPHUDSmall", COLOR.white, pw - 20, 10 )
				self.maxScroll = math.max( height - ph + sy + 10, 0 )

				render.SetScissorRect( 0, 0, 0, 0, false )
			end
		end
	end
	info.OnMouseWheeled = function( self, delta )
		self.scroll = math.Clamp( self.scroll - delta * 8, 0, self.maxScroll )
	end
	info.scroll = 0
	info.maxScroll = 0
end

function OpenClassViewer()
	if IsValid( CLASS_VIEWER ) then CLASS_VIEWER:Close() end

	showinfo.major = 0
	showinfo.minor = 0
	showinfo.class = 0
	showinfo.details = nil

	openViewer()
end

net.ReceivePing( "SLCRefoundClasses", function( data )
	data = tonumber( data )
	if data and data > 0 then
		SLCPopup( LANG.classviewer, string.format( LANG.refounded, data ) )
	end
end )

/*timer.Simple( 0, function()
	OpenClassViewer()
end )*/