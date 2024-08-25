/*
SkinFunc = {
	create = function() end, --allocate resources etc.
	remove = function() end, --remove resources etc.
	show = function() end, --open element
	hide = function() end, --close element

	//how to draw elements other than vgui ones? Register draw hook in 'create' and remove it in 'remove'
}
*/

if CLIENT then
	SLCSkins = {}
	SLCSkinsTargets = {}

	function AddGUISkin( target, name, functbl )
		if !SLCSkins[name] then
			SLCSkins[name] = {}
		end

		SLCSkins[name][target] = functbl
		SLCSkinsTargets[target] = true
	end

	function RunGUISkinFunction( target, fn, name )
		name = name or GetSettingsValue( "hud_skin_"..target )

		if name and SLCSkins[name] and SLCSkins[name][target] and SLCSkins[name][target][fn] then
			return SLCSkins[name][target][fn]()
		end

		/*if SLCSkins.default[target] and SLCSkins.default[target][fn] then
			return SLCSkins.default[target][fn]()
		end*/
	end

	function CreateGUIElement( target )
		RunGUISkinFunction( target, "create" )
	end

	function RemoveGUIElement( target )
		RunGUISkinFunction( target, "remove" )
	end

	function ShowGUIElement( target )
		RunGUISkinFunction( target, "show" )
	end

	function HideGUIElement( target )
		RunGUISkinFunction( target, "hide" )
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

		local change_cb = function( new, old, name )
			local main_entry = GetSettingsEntry( "hud_skin_main" )
			if main_entry then
				local all = true

				for k, v in pairs( SLCSkinsTargets ) do
					local entry = GetSettingsEntry( "hud_skin_"..k )
					if !entry then continue end
	
					if entry.value != new then
						all = false
						break
					end
				end

				if all then
					main_entry.value = new
				else
					main_entry.value = "custom"
				end
			end

			local target = string.match( name, "^hud_skin_(.+)$" )
			RunGUISkinFunction( target, "remove", old )
			CreateGUIElement( target )

			OpenSettingsPanel()
			SaveSettings()

			return true
		end

		local main_cb = function( new, old, name )
			for k, v in pairs( SLCSkinsTargets ) do
				local entry = GetSettingsEntry( "hud_skin_"..k )
				if !entry then continue end

				for i, item in ipairs( entry.data.list ) do
					if item == new then
						RunGUISkinFunction( k, "remove", entry.value )
						entry.value = new
						CreateGUIElement( k )
						break
					end
				end
			end

			OpenSettingsPanel()
			SaveSettings()

			return true
		end

		for k, v in pairs( SLCSkins ) do
			if k != "default" then
				table.insert( names, k )
			end

			for fname, _ in pairs( v ) do
				if !funcs[fname] then
					funcs[fname] = {}
				end

				table.insert( funcs[fname], k )
			end
		end

		RegisterSettingsEntry( "hud_skin_main", "dropbox", "default", { list = names, callback = main_cb }, "skins" )

		for k, v in pairs( funcs ) do
			RegisterSettingsEntry( "hud_skin_"..k, "dropbox", "default", { list = v, callback = change_cb, lang = "hud_skin_main" }, "skins" )
		end

		AddConfigPanel( "skins", 5000 )
	end )

	hook.Add( "SLCSettingsLoaded", "SLCGUISkins", function()
		for k, v in pairs( SLCSkinsTargets ) do
			CreateGUIElement( k )
		end
	end )
end
