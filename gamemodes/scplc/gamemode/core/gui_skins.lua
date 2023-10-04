if CLIENT then
	SLCSkins = {}

	function AddGUISkin( target, name, func )
		if !SLCSkins[name] then
			SLCSkins[name] = {}
		end

		SLCSkins[name][target] = func
	end

	function RunGUISkinFunction( target, ... )
		local name = GetSettingsValue( "hud_skin_"..target )
		if name and SLCSkins[name] and SLCSkins[name][target] then
			return SLCSkins[name][target]( ... )
		end

		if SLCSkins.default[target] then
			return SLCSkins.default[target]( ... )
		end
	end

	print( "\tLoading GUI Skins:" )
end

LoadFolder( BASE_GAMEMODE_PATH.."/gui_skins", "\t  > ", "CLIENT" )

if CLIENT then
	hook.Add( "SLCRegisterSettings", "SLCGUISkins", function()
		local names = {
			"default",
		}

		local funcs = {}

		for k, v in pairs( SLCSkins ) do
			if k != "default" then
				table.insert( names, v )
			end

			for fname, _ in pairs( v ) do
				if !funcs[fname] then
					funcs[fname] = {}
				end

				table.insert( funcs[fname], k )
			end
		end

		RegisterSettingsEntry( "hud_skin_main", "dropbox", "default", names, "skins" )

		for k, v in pairs( funcs ) do
			RegisterSettingsEntry( "hud_skin_"..k, "dropbox", "default", v, "skins" )
		end

		local COLOR = {
			white = Color( 255, 255, 255, 255 ),
			black = Color( 0, 0, 0, 255 ),
			inactive = Color( 125, 125, 125, 255 ),
			border = Color( 175, 175, 175, 255 ),
			hover = Color( 75, 75, 75, 200 ),
			selected = Color( 115, 115, 115, 25 ),
			conflict = Color( 225, 50, 50, 255 ),
		}

		local order = {
			dropbox = 1,
			switch = 3,
		}

		AddSettingsPanel( "skins", function( parent )
			local tab = {}

			for k, v in pairs( SLC_SETTINGS ) do
				if order[v.stype] and  v.panel == "skins" then
					table.insert( tab, { name = k, data = v, sorting = order[v.stype] } )
				end
			end
		
			table.sort( tab, function( a, b )
				if a.sorting != b.sorting then
					return a.sorting < b.sorting
				end
		
				return a.data.id < b.data.id
			end )
		
			local w, h = ScrW(), ScrH()
			local options_margin = w * 0.006
		
			for i, v in ipairs( tab ) do
				local pnl = vgui.Create( "DPanel", parent )
				pnl:SetTall( h * 0.06 )
				pnl:Dock( TOP )
				pnl:DockMargin( 0, h * 0.01, 0, 0 )
		
				pnl.Paint = function( this, pw, ph )
					surface.SetDrawColor( COLOR.border )
					surface.DrawLine( 0, ph - 1, pw, ph - 1 )
				end
		
				AddConfigControl( pnl, v.data, options_margin )
		
				local name = vgui.Create( "DPanel", pnl )
				name:Dock( FILL )
				name:DockMargin( options_margin, options_margin, options_margin, options_margin )
				name.Paint = function( this, pw, ph )
					draw.Text{
						text = LANG.settings.config[v.name] or v.name,
						pos = { 0, ph * 0.5 },
						font = "SCPHUDSmall",
						color = COLOR.white,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER,
					}
				end
			end
		end, false, 5000 )
	end )
end