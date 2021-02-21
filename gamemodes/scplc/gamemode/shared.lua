MODULES_PATH = GM.FolderName .. "/gamemode/modules"
CORE_PATH = GM.FolderName .. "/gamemode/core"
LANGUAGES_PATH = GM.FolderName .. "/gamemode/languages"
MAP_CONFIG_PATH = GM.FolderName .. "/gamemode/mapconfigs"

_LANG = {}
_LANG_ALIASES = {}
_LANG_FLAGS = {}

LANGUAGE = {
	EQ_LONG_TEXT = bit.lshift( 1, 0 ),
}

function registerLanguage( tab, name, ... )
	if !tab or !name then return end

	if _LANG[name] then
		print( "WARNING! Language '"..name.."' is already registered!" )
	end

	_LANG[name] = tab
	_LANG_FLAGS[name] = 0

	for k, v in pairs( { ... } ) do
		_LANG_ALIASES[v] = name
	end

	print( "# Language loaded: "..name )
end

function setLanguageFlag( name, flag )
	if _LANG_FLAGS[name] and flag then
		_LANG_FLAGS[name] = bit.bor( _LANG_FLAGS[name], flag )
	end
end

--[[-------------------------------------------------------------------------
Load mods - TODO
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Load core modules
---------------------------------------------------------------------------]]
print( "--------------Loading Core Modules---------------" )
local files = file.Find( CORE_PATH.."/*.lua", "LUA" )
for k, f in pairs( files ) do

	if string.len( f ) > 3 then
		local ext = string.sub( f, 1, 3 )

		if ext == "cl_" then
			if SERVER then
				AddCSLuaFile( CORE_PATH.."/"..f )
			else
				print("# Loading core module: " .. f )
				include( CORE_PATH.."/"..f )
			end
		elseif ext == "sv_" then
			if SERVER then
				AddCSLuaFile( CORE_PATH.."/"..f )

				print("# Loading core module: " .. f )
				include( CORE_PATH.."/"..f )
			end
		else
			if SERVER then
				AddCSLuaFile( CORE_PATH.."/"..f )
			end

			print("# Loading core module: " .. f )
			include( CORE_PATH.."/"..f )
		end
	end
end

--[[-------------------------------------------------------------------------
Load language
---------------------------------------------------------------------------]]
print( "----------------Loading Languages----------------" )
local files = file.Find( LANGUAGES_PATH.."/*.lua", "LUA" )
for k, f in pairs( files ) do
	if SERVER then
		AddCSLuaFile( LANGUAGES_PATH.."/"..f )
	end

	include( LANGUAGES_PATH.."/"..f )
end

hook.Run( "SLCLanguageLoaded" ) --language has beed loaded, pre-modules

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
local skipped = 0
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
				AddCSLuaFile( MODULES_PATH .. "/" .. f )
			else
				print("# Loading module: " .. f )
				include( MODULES_PATH .. "/" .. f )
			end
		elseif ext == "sv_" then
			if SERVER then
				print("# Loading module: " .. f )
				include( MODULES_PATH .. "/" .. f )
			end
		elseif ext == "sh_" then
			if SERVER then
				AddCSLuaFile( MODULES_PATH .. "/" .. f )
			end

			print("# Loading module: " .. f )
			include( MODULES_PATH .. "/" .. f )
		end
	else
		skipped = skipped + 1
	end
end
print( "#" )
print( "# Skipped files: " .. skipped )

hook.Run( "SLCModulesLoaded" ) --essential gamemode files have been loaded, pre-mapconfig

--[[-------------------------------------------------------------------------
Load map config
---------------------------------------------------------------------------]]
print( "---------------Loading Map Config----------------" )
if file.Exists( MAP_CONFIG_PATH .. "/" .. game.GetMap() .. ".lua", "LUA" ) then
	local map = "mapconfigs/" .. game.GetMap() .. ".lua"
	if SERVER then
		AddCSLuaFile( map )
	end

	print( "# Loading config for map " .. game.GetMap() )
	include( map )

	MAP_LOADED = true
else
	print( "----------------Loading Complete-----------------" )
	error( "Unsupported map " .. game.GetMap() .. "!" )
end

hook.Run( "SLCMapConfigLoaded" )

print( "----------------Loading Complete-----------------" )