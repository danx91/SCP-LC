--[[-------------------------------------------------------------------------
INI Library
---------------------------------------------------------------------------]]
INI_LOADER_VERSION = "v1.0"

local function writeSections( f, tab, c )
	local d = file.Open( f, "w", "DATA" )
	if !d then
		error( "Failed to open "..f )
	end

	d:Write( "# INI library by danx91 version: "..INI_LOADER_VERSION )
	if c then d:Write( "\n# "..c ) end

	for k, v in pairs( tab ) do
		d:Write( "\n\n"..string.format( "[%s]", k ) )
		for _k, _v in pairs( v ) do
			if _v == "" then
				_v = "''"
			elseif tonumber( _v ) and type( _v ) == "string" then
				_v = "'".._v.."'"
			end

			d:Write( "\n"..string.format( "%s = %s", _k, _v ) )
		end
	end

	d:Close()
end

local function createSections( tab, name, prefix, sections, char )
	local n = prefix..char..name
	sections[n] = {}
	for k, v in pairs( tab ) do
		if type( v ) == "table" then
			createSections( v, k, n, sections, char )
		elseif type( v ) != "function" and type( v ) != "userdata" then
			sections[n][k] = v
		end
	end
end

local function parseFile( path )
	local f = file.Open( path, "r", "DATA" )
	if !f then
		error( "Failed to open "..path )
	end

	local tab = {}
	local activetab

	local line_i = 0

	local line = f:ReadLine()
	while line do
		line_i = line_i + 1
		if !string.match( line, "^%s*#" ) and !string.match( line, "^%s+$" ) then
			local section = string.match( line, "%s*%[(%S+)%]" )
			if section then
				tab[section] = {}
				activetab = section
			end

			local key, value = string.match( line, "%s*(.+)%s+=%s*(.*%S+)%s*" )
			if key and value then
				if tonumber( key ) then
					key = tonumber( key )
				end

				if value == "''" then
					value = ""
				elseif value == "true" then
					value = true
				elseif value == "false" then
					value = false
				elseif tonumber( value ) then
					value = tonumber( value )
				elseif string.match( value, "'%d+'" ) then
					value = string.match( value, "'(%d+)'" )
				end

				tab[activetab][key] = value
			end

			if !section and !key and !value then
				error( "Unexpected char at line "..line_i )
			end
		end
		line = f:ReadLine()
	end

	f:Close()

	return tab
end

function LoadINI( f, target )
	local data = parseFile( f )
	if !data._ini or !data._GLOBAL then return end

	local char = data._ini.char
	local version = data._ini.version
	if !char then return end

	if !version or version != INI_LOADER_VERSION then
		//print( version, INI_LOADER_VERSION )
		MsgC( Color( 255, 50, 50 ), "Versions of file and parser are different!", "\tFile: "..f, "\tVersion of parser: "..INI_LOADER_VERSION, "\tVersion of file: "..(version or "Undefined").."\n" )
	end

	local result = target or {}
	for k, v in pairs( data._GLOBAL ) do
		result[k] = v
	end

	for k, v in pairs( data ) do
		if k != "_ini" and k != "_GLOBAL" then
			local stack = {}

			for s in string.gmatch( k, "[^%"..char.."]+" ) do
				table.insert( stack, s )
			end

			local parent
			for i = 1, #stack do
				if !parent then
					result[stack[i]] = result[stack[i]] or {}
					parent = result[stack[i]]
				else
					parent[stack[i]] = parent[stack[i]] or {}
					parent = parent[stack[i]]
				end
				if i == #stack then
					for _k, _v in pairs( v ) do
						parent[_k] = _v
					end
				end
			end
		end
	end

	return result
end

function WriteINI( f, data, ignoretables, customchar, c )
	--PrintTable( data )
	customchar = customchar or "."
	local sections = {
		_GLOBAL = {},
		_ini = {
			char = customchar,
			version = INI_LOADER_VERSION
		}
	}
	for k, v in pairs( data ) do
		if type( v ) != "table" then
			sections._GLOBAL[k] = v
		else
			sections[k] = {}
			for _k, _v in pairs( v ) do
				if type( _v ) != "table" and type( _v ) != "function" and type( _v ) != "userdata" then
					sections[k][_k] = _v
				elseif type( _v ) == "table" and !ignoretables then
					createSections( _v, _k, k, sections, customchar )
				end
			end
		end
	end
	--PrintTable( sections )
	writeSections( f, sections, c )
end