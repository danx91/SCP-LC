local current_index = 0
local precache_len = 0
local last_model = nil
local precache_list = {}

function BuildPrecacheList()
	current_index = 0
	precache_list = {}

	for _, v in pairs( GetAllClasses() ) do
		if isstring( v.model ) then
			table.insert( precache_list, v.model )
		elseif istable( v.model ) then
			for _, mdl in pairs( v.model ) do
				table.insert( precache_list, mdl )
			end
		end
	end

	for _, v in ipairs( file.Find( BASE_LUA_PATH.."/entities/weapons/*.lua", "LUA" ) ) do
		local wep = weapons.GetStored( string.sub( v, 1, -5 ) )
		if wep and wep.WorldModel and wep.WorldModel != "" then
			table.insert( precache_list, wep.WorldModel )
		end
	end

	for _, v in pairs( VEST.vests ) do
		if isstring( v.model ) then
			table.insert( precache_list, v.model )
		elseif istable( v.model ) then
			for _, mdl in pairs( v.model ) do
				table.insert( precache_list, mdl )
			end
		end
	end

	hook.Run( "SLCPrecache", precache_list )

	precache_len = #precache_list
end

function PrecacheNext()
	if precache_len == 0 or current_index == -1 then return false end

	current_index = current_index + 1

	local mdl = precache_list[current_index]
	if mdl then
		util.PrecacheModel( mdl )
		last_model = mdl
	end

	if !mdl or current_index == precache_len then
		current_index = -1
		precache_list = {}

		return false
	end

	return true
end

function PrecacheProgress()
	if precache_len == 0 then return 0 end
	return current_index / precache_len, last_model
end

if SERVER then
	function PrecacheAll()
		if SLC_PRECACHE_DONE or DEVELOPER_MODE or precache_len == 0 or CVAR.slc_sv_precache:GetInt() != 1 then return end

		util.TimerCycle()
		print( "Precaching "..precache_len.." models..." )
		hook.Add( "Tick", "SLCPrecacheModels", function()
			for i = 1, 10 do
				if !PrecacheNext() then break end
			end

			if current_index == -1 then
				print( string.format( "Precaching done! Took: %.2fs", util.TimerCycle() / 1000 ) )
				hook.Remove( "Tick", "SLCPrecacheModels" )

				SLC_PRECACHE_DONE = true
			else
				print( string.format( "Precache: %i/%i (%.1f%%)", current_index, precache_len, current_index / precache_len * 100 ) )
			end
		end )
	end

	hook.Add( "PostGamemodeLoaded", "SLCPrecacheModels", function()
		timer.Simple( 5, function()
			BuildPrecacheList()
			PrecacheAll()
		end )
	end )
end