gamerule = gamerule or {
	data = {}
}

/*
data = {
	dfeault = [def value],
	type = <"number", "string", "boolean", nil(auto detected)>,
	protected = <bool>, --don't send to clients
}
*/

function gamerule.Register( name, data )
	if !name or !data or data.value == nil then return end

	local t = data.type

	if !t then
		t = type( data.value )
	end

	if t != "string" and t != "number" and t != "boolean" then
		print( "Failed to register gamerule '"..name.."'! Invalid type: "..t )
		return
	end

	if type( data.value ) != t then
		if t == "number" and tonumber( data.value ) then
			data.value = tonumber( data.value )
		elseif t == "string" and tostring( data.value ) then
			data.value = tostring( data.value )
		elseif t == "boolean" then
			data.value = tobool( data.value )
		else
			print( "Failed to register gamerule '"..name.."'! Can't parse value! Expected: "..t..", got: "..type( data.value ) )
			return
		end
	end

	gamerule.data[name] = {
		default = data.value,
		value = data.value,
		type = t,
		protected = data.protected == true,
		registered = true,
	}
end

function gamerule.Set( name, value, silent )
	local data = gamerule.data[name]
	if data then
		if type( value ) != data.type then
			if data.type == "number" and tonumber( value ) then
				value = tonumber( value )
			elseif data.type == "string" and tostring( value ) then
				value = tostring( value )
			elseif data.type == "boolean" then
				value = tobool( value )
			else
				print( "Failed to set gamerule!" )
				return
			end
		end

		if data.value != value then
			data.value = value
			gamerule.Save()

			if !data.protected and !silent then
				gamerule.SendAll( nil, name )
			end
		end
	end
end

function gamerule.Get( name )
	local data = gamerule.data[name]
	if data then
		return data.value
	end
end

function gamerule.SendAll( ply, list )
	if !list then
		list = {}

		for k, v in pairs( gamerule.data ) do
			if !v.protected then
				table.insert( list, k )
			end
		end
	elseif type( list ) != "table" then
		list = { list }
	end

	local tab = {}
	local any = false
	for k, v in pairs( list ) do
		if gamerule.data[v] and !gamerule.data[v].protected then
			tab[v] = gamerule.data[v].value
			any = true
		end
	end

	if any then
		net.SendTable( "SLCGameruleData", tab, ply )
	end
end

function gamerule.Save()
	file.Write( "slc/gamerule.dat", util.TableToJSON( gamerule.data ) )
end

if SERVER then
	timer.Simple( 0, function()
		hook.Run( "SLCRegisterGamerules" )

		if !file.Exists( "slc", "DATA" ) then
			file.CreateDir( "slc" )
		end

		if !file.Exists( "slc/gamerule.dat", "DATA" ) then
			file.Write( "slc/gamerule.dat", util.TableToJSON( gamerule.data ) )
		else
			local data = util.JSONToTable( file.Read( "slc/gamerule.dat", "DATA" ) )

			for k, v in pairs( data ) do
				local wasRegistered = false

				if gamerule.data[k] and gamerule.data[k].registered then
					wasRegistered = true
				end

				gamerule.data[k] = v

				if v.registered and !wasRegistered then
					gamerule.data[k].registered = false
				end
			end

			file.Write( "slc/gamerule.dat", util.TableToJSON( gamerule.data ) )
		end
	end )
end

if CLIENT then
	timer.Simple( 0, function()
		net.ReceiveTable( "SLCGameruleData", function( data )
			for k, v in pairs( data ) do
				if !gamerule.data[k] then
					gamerule.data[k] = { protected = true }
				end

				gamerule.data[k].value = v
			end
		end )
	end )
end

local actions = {
	get = true,
	set = true,
	reset = true,
	remove = true,
}

local function printRules( name )
	local list = {}
	if name == "*" then
		for k, v in pairs( gamerule.data ) do
			table.insert( list, k )
		end
	elseif gamerule.data[name] then
		list[1] = name
	end

	if #list > 0 then
		MsgC( Color( 255, 255, 255 ), "--------------------------------------------------------------------------------\n" )
		MsgC( Color( 255, 255, 255 ), "Gamerule name:                | Type:             | Value: ", Color( 175, 175, 175 ), "(modified) ", Color( 100, 255, 100 ), "(protected) ", Color( 255, 100, 100 ), "(not registered)\n" )
		for k, v in pairs( list ) do
			MsgC( Color( 255, 255, 255 ), "--------------------------------------------------------------------------------\n" )
			local data = gamerule.data[v]
			if data then
				local color = Color( 255, 255, 255 )

				if !data.registered then
					color = Color( 255, 100, 100 )
				elseif data.protected then
					color = Color( 100, 255, 100 )
				end

				if data.value == data.default then
					MsgC( color, string.ExactLength( v, 30 ), Color( 255, 255, 255 ), "| ", string.ExactLength( data.type or "?", 18 ), "| ", data.value == nil and "?" or data.value, "\n" )
				else
					MsgC( color, string.ExactLength( v, 30 ), Color( 255, 255, 255 ), "| ", string.ExactLength( data.type or "?", 18 ), "| ", Color( 175, 175, 175 ), data.value == nil and "?" or data.value, Color( 255, 255, 255 ), "   ["..tostring(data.default == nil and "?" or data.default).."]", "\n" )
				end
			end
		end
	end
end

concommand.Add( "slc_gamerule", function( ply, cmd, args )
	if !args[1] or args[1] == "" or args[1] == "help" or args[1] == "?" then
		--print help
		return
	end

	if !actions[args[1]] then
		--print list of commands
		return
	end

	if !args[2] then
		--print error
		return
	end

	if SERVER and (!IsValid( ply ) or ply:IsListenServerHost()) then
		if args[1] == "get" then
			printRules( args[2] )
		elseif args[1] == "set" then
			if args[3] then
				local data = gamerule.data[args[2]]

				if data then
					local val = args[3]

					if type( val ) != data.type then
						if data.type == "number" and tonumber( val ) then
							val = tonumber( val )
						elseif data.type == "string" and tostring( val ) then
							val = tostring( val )
						elseif data.type == "boolean" then
							val = tobool( val )
						else
							print( "Failed to set gamerule!" )
							return
						end
					end

					if data.value != val then
						data.value = val
						gamerule.Save()
						gamerule.SendAll( nil, args[2] )
					end
				end
			end
		elseif args[1] == "reset" then
			local tab = {}

			if args[2] == "*" then
				for k, v in pairs( gamerule.data ) do
					table.insert( tab, k )
				end
			else
				tab = { args[2] }
			end

			local any = false
			for k, v in pairs( tab ) do
				local data = gamerule.data[v]
				if data then
					if data.value != data.default then
						data.value = data.default
						any = true
					end
				end
			end

			if any then
				gamerule.Save()
				gamerule.SendAll( nil, tab )
			end
		elseif args[1] == "remove" then
			local tab = {}

			if args[2] == "*" then
				for k, v in pairs( gamerule.data ) do
					if !v.registered then
						table.insert( tab, k )
					end
				end
			else
				tab = { args[2] }
			end

			local any = false
			for k, v in pairs( tab ) do
				local data = gamerule.data[v]
				if data then
					if !data.registered then
						gamerule.data[v] = nil
						any = true
					end
				end
			end

			if any then
				gamerule.Save()
			end
		end
	elseif CLIENT then
		if args[1] != "get" then
			--print warning
			return
		end

		printRules( args[2] )
	end
end, function( cmd, args )
	args = string.lower( string.Trim( args ) )

	local space = string.find( args, " " )

	if space then
		local pre = string.sub( args, 1, space - 1 )
		local arg = string.sub( args, space + 1 )
		local tab = {}

		local cmd = "slc_gamerule "..pre.." "
		for k, v in pairs( gamerule.data ) do
			if args == "" or string.find( string.lower( k ), arg, 1, true ) then
				table.insert( tab, cmd..k )
			end
		end

		return tab
	else
		local tab = {}

		for k, v in pairs( actions ) do
			if args == "" or string.find( string.lower( k ), args, 1, true ) then
				table.insert( tab, "slc_gamerule "..k )
			end
		end

		return tab
	end
end, "" )