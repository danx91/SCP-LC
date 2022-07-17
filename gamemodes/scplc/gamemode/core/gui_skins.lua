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

		AddSettingsPanel( "skins", function( parent )

		end, nil, 8000 )
	end )
end