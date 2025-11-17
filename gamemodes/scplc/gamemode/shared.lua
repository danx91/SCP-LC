BASE_LUA_PATH = GM.FolderName
BASE_GAMEMODE_PATH = GM.FolderName.."/gamemode"

MODULES_PATH = BASE_GAMEMODE_PATH.."/modules"
CORE_PATH = BASE_GAMEMODE_PATH.."/core"
LANGUAGES_PATH = BASE_GAMEMODE_PATH.."/languages"
MAP_CONFIG_PATH = BASE_GAMEMODE_PATH.."/mapconfigs"

_LANG = {}
_LANG_ALIASES = {}
_LANG_FLAGS = {}
_LANG_DEFAULT = "english"

LANGUAGE = {
	EQ_LONG_TEXT = bit.lshift( 1, 0 ),
}

SLCRandom = math.random

function RegisterLanguage( tab, name, ... )
	if !tab or !name then return end

	if _LANG[name] then
		print( "WARNING! Language '"..name.."' is already registered!" )
	end

	_LANG[name] = tab
	_LANG_FLAGS[name] = 0

	for k, v in pairs( { ... } ) do
		_LANG_ALIASES[v] = name

		if v == "default" then
			_LANG_DEFAULT = name
		end
	end

	print( "# Language loaded: "..name )
end

function SetLanguageFlag( name, flag )
	if _LANG_FLAGS[name] and flag then
		_LANG_FLAGS[name] = bit.bor( _LANG_FLAGS[name], flag )
	end
end

--[[-------------------------------------------------------------------------
Load folder
---------------------------------------------------------------------------]]
file.CreateDir( "slc/" )

local skipped = 0

function LoadFolder( path, t, realm )
	for k, f in pairs( file.Find( path.."/*.lua", "LUA" ) ) do
		if string.len( f ) > 3 then
			if string.sub( f, 1, 1 ) == "_" then
				skipped = skipped + 1
				continue
			end

			local ext = string.sub( f, 1, 3 )

			if realm == "CLIENT" or ext == "cl_" then
				if SERVER then
					AddCSLuaFile( path.."/"..f )
				else
					if t then
						print( t..f )
					end

					include( path.."/"..f )
				end
			elseif realm == "SERVER" or ext == "sv_" then
				if SERVER then
					if t then
						print( t..f )
					end

					include( path.."/"..f )
				end
			else
				if SERVER then
					AddCSLuaFile( path.."/"..f )
				end
	
				if t then
					print( t..f )
				end

				include( path.."/"..f )
			end
		end
	end
end

--[[-------------------------------------------------------------------------
Load core modules
---------------------------------------------------------------------------]]
print( "--------------Loading Core Modules---------------" )
LoadFolder( CORE_PATH, "# Loading core module: " )

if DEVELOPER_MODE then
	print( "\n\n\n\n\n" )
	MsgC( Color( 230, 20, 20 ), "=================================================\n" )
	MsgC( Color( 230, 20, 20 ), "================ DEVELOPER MODE =================\n" )
	MsgC( Color( 230, 20, 20 ), "=================================================\n" )
	print( "\n\n" )
	MsgC( Color( 230, 20, 20 ), "# SCP: Lost Control currently runs in DEVELOPER MODE!\n" )

	local dev_file = CORE_PATH.."/_developer.lua"

	if SERVER then
		AddCSLuaFile( dev_file )
	end

	MsgC( Color( 230, 20, 20 ), "# Loading file: "..dev_file.."\n" )
	include( dev_file )

	print( "\n\n" )
	MsgC( Color( 230, 20, 20 ), "=================================================\n" )
	MsgC( Color( 230, 20, 20 ), "=================================================\n" )
	MsgC( Color( 230, 20, 20 ), "=================================================\n" )
	print( "\n\n\n\n\n" )
end

SLCRandom = xoshiro128()

--[[-------------------------------------------------------------------------
Load languages
---------------------------------------------------------------------------]]
print( "----------------Loading Languages----------------" )
for k, f in pairs( file.Find( LANGUAGES_PATH.."/*.lua", "LUA" ) ) do
	if SERVER then
		AddCSLuaFile( LANGUAGES_PATH.."/"..f )
	end

	include( LANGUAGES_PATH.."/"..f )
end

hook.Run( "SLCLanguagesLoaded" ) --language has beed loaded, pre-modules

--[[-------------------------------------------------------------------------
Load modules
---------------------------------------------------------------------------]]
if SERVER then
	AddCSLuaFile( "modules/sh_module.lua" )
	AddCSLuaFile( "modules/cl_module.lua" )

	include( "modules/sh_module.lua" )
	include( "modules/sv_module.lua" )
else
	include( "modules/sh_module.lua" )
	include( "modules/cl_module.lua" )
end

print( "-----------------Loading Modules-----------------" )
local modules = file.Find( MODULES_PATH.."/*.lua", "LUA" )

for k, f in pairs( modules ) do
	if f == "sv_module.lua" or f == "sh_module.lua" or f == "cl_module.lua" then continue end

	if string.sub( f, 1, 1 ) == "_" then
		skipped = skipped + 1
		continue
	end

	if string.len( f ) > 3 then
		local ext = string.sub( f, 1, 3 )

		if ext == "cl_" then
			if SERVER then
				AddCSLuaFile( MODULES_PATH.."/"..f )
			else
				print("# Loading module: "..f )
				include( MODULES_PATH.."/"..f )
			end
		elseif ext == "sv_" then
			if SERVER then
				print("# Loading module: "..f )
				include( MODULES_PATH.."/"..f )
			end
		elseif ext == "sh_" then
			if SERVER then
				AddCSLuaFile( MODULES_PATH.."/"..f )
			end

			print("# Loading module: "..f )
			include( MODULES_PATH.."/"..f )
		end
	else
		skipped = skipped + 1
	end
end

print( "#" )
print( "# Skipped files: "..skipped )

hook.Run( "SLCModulesLoaded" ) --essential gamemode files have been loaded, pre-mapconfig

--[[-------------------------------------------------------------------------
Load map config
---------------------------------------------------------------------------]]
MAP_LOADED = false

local map = game.GetMap()
print( "---------------Loading Map Config----------------" )
if file.Exists( MAP_CONFIG_PATH.."/"..map..".lua", "LUA" ) then
	print( "# Loading config for map "..map )

	local map_file = "mapconfigs/"..map..".lua"
	if SERVER then
		AddCSLuaFile( map_file )
	end

	include( map_file )

	MAP_LOADED = map

	if file.Exists( MAP_CONFIG_PATH.."/__"..map.."_overrides.lua", "LUA" ) then
		local overrides = "mapconfigs/__"..map.."_overrides.lua"
		if SERVER then
			AddCSLuaFile( overrides )
		end
	
		include( overrides )
	end
else
	print( "# Unable to find config for map "..map.."!" )
	print( "# If you are developer, make sure config file name matches map name!" )
end

if hook.Run( "SLCCustomMapConfig", map, MAP_LOADED ) and !MAP_LOADED then
	print( "# SLCCustomMapConfig returned true, assuming that config is loaded!" )
	MAP_LOADED = map
end

if !MAP_LOADED then
	print( "# Map config not found! Make sure you are playing on supported map!" )
	print( "----------------Loading Completed----------------" )
	error( "Unsupported map "..map.."!" )
end

hook.Run( "SLCMapConfigLoaded" )

print( "----------------Loading Completed----------------" )

hook.Run( "SLCFullyLoaded" )