--[[-------------------------------------------------------------------------
Language loader
---------------------------------------------------------------------------]]
local load_language, load_language_legacy

local current_lang
local awaiting_reload = {}

_LANG = {}
_LANG_MANIFEST = {}
_LANG_ALIASES = {}
_LANG_FLAGS = {}

_LANG_DEFAULT = nil
_LANG_DEFAULT_NAME = nil

LANGUAGE_FLAGS = {
	--None so far
}

LANGUAGE = setmetatable( {}, {
	__index = function( tab, key )
		assert( !!current_lang, "Attempted to use LANGUAGE outside of language files - you can't do that!" )
		return current_lang[key]
	end,
	__newindex = function( tab, key, value )
		if current_lang then
			current_lang[key] = value
			return
		end

		local lang_dir = string.match( debug.getinfo( 2, "S" ).source, LANGUAGES_PATH.."/(.*)/(.*).lua" )
		assert( !!lang_dir, "Attempted to use LANGUAGE outside of language files - you can't do that!" )

		if awaiting_reload[lang_dir] then return end

		local manifest = _LANG_MANIFEST[lang_dir]
		if !manifest then return end

		print( "[SLC] Language reload detected: ", lang_dir )
		awaiting_reload[lang_dir] = true

		NextTick( function()
			awaiting_reload[lang_dir] = nil
			load_language( lang_dir )
		end )
	end,
	__call = function( _, name )
		return _LANG[name]
	end
} )

--[[-------------------------------------------------------------------------
Load languages
---------------------------------------------------------------------------]]
function SLCLoadLanguages()
	print( "----------------Loading Languages----------------" )

	local files, dirs = file.Find( LANGUAGES_PATH.."/*", "LUA" )

	for i, v in ipairs( files ) do
		if !string.EndsWith( v, ".lua" ) then continue end
		load_language_legacy( v )
	end

	for i, v in ipairs( dirs ) do
		load_language( v )
	end

	if !_LANG_DEFAULT_NAME then
		_LANG_DEFAULT_NAME = "english"
		_LANG_DEFAULT = _LANG.english
	end
end

function load_language_legacy( f )
	if SERVER then
		AddCSLuaFile( LANGUAGES_PATH.."/"..f )
	end

	include( LANGUAGES_PATH.."/"..f )
end

local color_err = Color( 200, 0, 0 )

function load_language( dir )
	print( "# Loading language: "..dir )
	print( "#  > Loading language manifest file" )

	local directory = LANGUAGES_PATH.."/"..dir.."/"
	local manifest_file = "_"..dir..".lua"
	local manifest_path = directory..manifest_file

	if !file.Exists( manifest_path, "LUA" ) then
		MsgC( "#  > ", color_err, "Unable to find manifest file: _"..dir..".lua\n" )
	end

	current_lang = {}

	include( manifest_path )

	local manifest_data = current_lang
	manifest_data.name = dir

	current_lang = {
		["self"] = manifest_data.self,
		["self_en"] = manifest_data.self_en,
		WEAPONS = {},
	}

	for i, v in ipairs( manifest_data.aliases or {} ) do
		_LANG_ALIASES[v] = dir
	end

	local flags = {}
	for i, v in ipairs( manifest_data.flags or {} ) do
		flags[v] = true
	end

	if manifest_data.code then
		_LANG_ALIASES[manifest_data.code] = dir
	end

	if manifest_data.default then
		if !_LANG_DEFAULT_NAME then
			_LANG_DEFAULT_NAME = dir
			_LANG_DEFAULT = current_lang
		elseif _LANG_DEFAULT_NAME != dir then
			MsgC( "#  > ", color_err, "More than one language is declared as default! Current default: ".._LANG_DEFAULT_NAME.."\n" )
		end
	end

	for i, v in ipairs( file.Find( directory.."*.lua", "LUA" ) ) do
		if SERVER then
			AddCSLuaFile( directory..v )
		end

		if v != "_"..dir then
			print( "#  > Loading language file: "..v )
			include( directory..v )
		end
	end

	_LANG_FLAGS[dir] = flags
	_LANG_MANIFEST[dir] = manifest_data
	_LANG[dir] = current_lang

	current_lang = nil
end

--[[-------------------------------------------------------------------------
Deprecated - legacy way of registering new languages
---------------------------------------------------------------------------]]
function RegisterLanguage( tab, name, ... )
	if !tab or !name then return end

	if _LANG[name] then
		print( "WARNING! Language '"..name.."' is already registered!" )
	end

	_LANG[name] = tab
	_LANG_FLAGS[name] = {}

	for k, v in pairs( { ... } ) do
		if v == "default" then
			_LANG_DEFAULT_NAME = name
			_LANG_DEFAULT = tab
		else
			_LANG_ALIASES[v] = name
		end
	end

	print( "# Legacy language loaded: "..name )
end

function SetLanguageFlag( name, flag )
	_LANG_FLAGS[name][flag] = true
end

--[[-------------------------------------------------------------------------
Language system
---------------------------------------------------------------------------]]
if SERVER then return end

LANG = {}
LANG_FLAGS = 0
LANG_NAME = "undefined"

local cl_lang = CreateClientConVar( "cvar_slc_language", "default", true, false )
local cur_lang = cl_lang:GetString()

cvars.AddChangeCallback( "gmod_language", function( name, old, new )
	if cl_lang:GetString() == "default" then
		ChangeLang( new )
	end
end, "SCPGMODLang" )

cvars.AddChangeCallback( "cvar_slc_language", function( name, old, new )
	ChangeLang( new )
end, "SCPLang" )

concommand.Add( "slc_language", function( ply, cmd, args )
	RunConsoleCommand( "cvar_slc_language", args[1] )
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tab = {}

	if string.find( "default", args ) then
		table.insert( tab, "slc_language default" )
	end

	for k, v in pairs( _LANG ) do
		if string.find( string.lower( k ), args ) then
			table.insert( tab, "slc_language "..k )
		end
	end

	return tab
end, "" )

local function CheckTable( tab, ref )
	for k, v in pairs( ref ) do
		if istable( v ) then
			if !istable( tab[k] ) then
				tab[k] = table.Copy( v )
			else
				CheckTable( tab[k], v )
			end
		elseif type( tab[k] ) != type( v ) then
			tab[k] = v
		end
	end
end

function ChangeLang( lang, force )
	if lang == true then
		lang = cur_lang
		force = true
	end

	if !isstring( lang ) then return end
	if !force and cur_lang == lang then return end

	local usedef = false
	local ltu

	if lang == "default" or cl_lang:GetString() == "default" then
		lang = GetConVar( "gmod_language" ):GetString()
		usedef = true
	end

	if _LANG[lang] then
		ltu = lang
	else
		ltu = _LANG_ALIASES[lang]
	end

	if !ltu and usedef then
		print( "Language "..lang.." is not supported - using default" )
		ltu = _LANG_DEFAULT_NAME
	end

	if !ltu then
		print( "Unknown language: "..lang )

		timer.Simple( 0, function()
			RunConsoleCommand( "cvar_slc_language", cur_lang )
		end )

		return
	end

	if !force and cur_lang == ltu then return end

	cur_lang = ltu
	LANG_NAME = ltu
	LANG_FLAGS = _LANG_FLAGS[ltu]

	print( "Setting language to: "..ltu )

	local tmp = table.Copy( _LANG[ltu] )

	if ltu != _LANG_DEFAULT_NAME then
		CheckTable( tmp, _LANG_DEFAULT )
	end

	for k, v in pairs( tmp.__binds ) do
		local to = string.Explode( ".", k )
		local from = string.Explode( ".", v )

		local val = tmp
		local to_val = tmp
		local to_len = #to

		for _, key in ipairs( from ) do
			if !val[key] then break end
			val = val[key]
		end

		if val == tmp then continue end

		for i = 1, to_len do
			if i == to_len then
				to_val[to[i]] = val
			else
				to_val = to_val[to[i]]
				if to_val == nil then break end
			end
		end
	end

	LANG = tmp
	hook.Run( "SLCLanguageChanged" )
end

hook.Add( "SLCFactoryReset", "SLCLanguageReset", function()
	RunConsoleCommand( "slc_language", "default" )
end )

hook.Add( "SLCRegisterSettings", "SLCLanguage", function()
	local tab = {
		"default"
	}

	for k, v in pairs( _LANG ) do
		local name = v.self or k

		if v.self_en then
			name = name.." ("..v.self_en..")"
		end

		table.insert( tab, { k, name } )
	end

	RegisterSettingsEntry( "cvar_slc_language", "dropbox", "!CVAR", {
		list = tab,
		parse = function( value )
			if value == "default" then return end
			return _LANG_ALIASES[value] or value
		end
	} )
end )

local diff_skip = {
	["MISC.commands_aliases"] = true,
	["__binds"] = true,
}

local function PrintTableDiff( tab, ref, stack, raw_stack )
	local wrong, err = 0, 0
	stack = stack or "LANG"

	if raw_stack and diff_skip[raw_stack] then
		return wrong, err
	end

	for k, v in pairs( ref ) do
		if istable( v ) then
			if !istable( tab[k] ) then
				print( "Missing table: "..stack.." > "..k )
				wrong = wrong + 1
			else
				local a_w, a_e = PrintTableDiff( tab[k], v, stack.." > "..k, raw_stack and raw_stack.."."..k or k )
				wrong = wrong + a_w
				err = err + a_e
			end
		elseif tab[k] == nil then
			print( "Missing value: "..stack.." > "..k )
			wrong = wrong + 1
		else
			local ref_t = type( v )
			local tab_t = type( tab[k] )

			if ref_t != tab_t then
				print( "Wrong type: "..stack.." > "..k.." ("..ref_t.." expected, got "..tab_t..")" )
				err = err + 1
			end
		end
	end

	return wrong, err
end

local function PrintRevDiff( tab, ref, stack, raw_stack )
	local num = 0
	stack = stack or "LANG"

	if raw_stack and diff_skip[raw_stack] then
		return num
	end

	for k, v in pairs( tab ) do
		if istable( v ) and istable( ref[k] ) then
				num = num + PrintRevDiff( v, ref[k], stack.." > "..k, raw_stack and raw_stack.."."..k or k )
		elseif ref[k] == nil then
			print( "Unused value: "..stack.." > "..k )
			num = num + 1
		end
	end

	return num
end

concommand.Add( "slc_diff_language", function( ply, cmd, args )
	local lang_name = args[1]
	if !isstring( lang_name ) then return end

	local lang = _LANG[lang_name]
	local default = _LANG_DEFAULT

	if lang and default then
		print( "#####################################################################" )
		local wrong, err = PrintTableDiff( lang, default )
		local num = PrintRevDiff( lang, default )
		print( "#####################################################################" )
		print( "Language diff: "..lang_name )
		print( "Total missing values or tables: "..wrong )
		print( "Total errors: "..err )
		print( "Total unused values: "..num )
		print()
		print( "Check logs above for details" )
		print( "#####################################################################" )
	end
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tab = {}

	if string.find( "default", args ) then
		table.insert( tab, "slc_diff_language default" )
	end

	for k, v in pairs( _LANG ) do
		if string.find( string.lower( k ), args ) then
			table.insert( tab, "slc_diff_language "..k )
		end
	end

	return tab
end )

function GenTabHash( lang )
	local hash_tab = {}

	for k, v in pairs( lang ) do
		if istable( v ) then
			hash_tab[k] = GenTabHash( v )
		else
			hash_tab[k] = util.SHA256( tostring( v ) )
		end
	end

	return hash_tab
end

function PrintHashDiff( lang, src, stack )
	stack = stack or "LANG"

	for k, v in pairs( lang ) do
		if istable( v ) then
			if istable( src[k] ) then
				PrintHashDiff( v, src[k], stack.." > "..k )
			end
		elseif isstring( src[k] ) and util.SHA256( tostring( v ) ) != src[k] then
			 print( "Hash mismatch: "..stack.." > "..k )
		end
	end
end

concommand.Add( "slc_hash_lang", function( ply, cmd, args )
	local lang_name = args[1]
	if !isstring( lang_name ) then return end

	local lang = _LANG[lang_name]

	if !lang then
		print( "Unknown language!" )
		return
	end

	file.Write( "slc_hash_"..lang_name..".json", util.TableToJSON( GenTabHash( lang ) ) )
end )

concommand.Add( "slc_hash_lang_check", function( ply, cmd, args )
	local lang_name = args[1]
	if !isstring( lang_name ) then return end

	local lang = _LANG[lang_name]

	if !lang then
		print( "Unknown language!" )
		return
	end

	local hash_file = file.Read( "slc_hash_"..lang_name..".json" )
	if !hash_file then
		print( "data/slc_hash"..lang_name..".json file not found!" )
		return
	end

	hash_file = util.JSONToTable( hash_file, true, true )
	if !hash_file then
		print( "data/slc_hash"..lang_name..".json file is corrupted!" )
		return
	end

	PrintHashDiff( lang, hash_file )
end )
