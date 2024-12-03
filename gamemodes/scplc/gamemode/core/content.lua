SLC_CONTENT_WORKSHOP_ID = "1805981251"

function AddGamemodeContent( workshopid )
	if SERVER then
		resource.AddWorkshop( workshopid )
		print( "Adding '"..workshopid.."' to resource.AddWorkshop!" )
	else
		table.insert( SLC_CONTENT.registry, workshopid )
	end
end

local function fetch_collection()
	return SLCPromise( function( resolve, reject )
		if !steamworks then
			reject()
			return
		end

		steamworks.FileInfo( SLC_CONTENT_WORKSHOP_ID, function( data )
			if !data or !data.children then
				print( "Failed to fetch collection info!", SLC_CONTENT_WORKSHOP_ID )
				reject()
				return
			end

			for i, v in ipairs( data.children ) do
				AddGamemodeContent( v )
			end

			if SERVER then
				print( string.format( "Added %i addons as gamemode content from collection: %s", #data.children, SLC_CONTENT_WORKSHOP_ID ) )
			end

			resolve()
		end )
	end )
end

if CLIENT then
	SCS_WAITING = 1
	SCS_CHECKING = 2
	SCS_MOUNTING = 3
	SCS_DOWNLOADING = 4
	SCS_DONE = 5

	SLC_CONTENT = {
		status = SCS_WAITING,
		registry = {},
		info = {
			ok = {},
			nsub = {},
			disabled = {},
			nok = 0,
			was_nsub = 0,
			was_disabled = 0,
			size = 0
		},
		progress = {
			current = 0,
			total = 0,
			name = "",
		},
		local_mount = {},
	}

	local function download_addons()
		if #SLC_CONTENT.info.nsub == 0 then
			SLC_CONTENT.status = SCS_DONE
			return
		end

		local progress = SLC_CONTENT.progress

		if SLC_CONTENT.status != SCS_DOWNLOADING then
			progress.total = #SLC_CONTENT.info.nsub
		end

		SLC_CONTENT.status = SCS_DOWNLOADING

		local tab = table.remove( SLC_CONTENT.info.nsub )
		
		progress.current = progress.total - #SLC_CONTENT.info.nsub
		progress.name = tab.name

		print( string.format( "Downloading addon: '%s' (%i/%i)", tab.name, progress.current, progress.total ) )

		steamworks.DownloadUGC( tab.id, function( path )
			if path then
				if game.MountGMA( path ) then
					SLC_CONTENT.local_mount[tab.id] = true
					print( "  > Addon downloaded & mounted: "..tab.name )
				else
					print( "  >Failed to mount: "..tab.name )
				end
			else
				print( "  > Failed to download: "..tab.name )
			end
			
			timer.Simple( 0, download_addons )
		end )
	end

	local function mount_addons()
		if #SLC_CONTENT.info.disabled == 0 then
			SLC_CONTENT.status = SCS_DONE
			download_addons()
			return
		end

		SLC_CONTENT.status = SCS_MOUNTING

		local progress = SLC_CONTENT.progress
		local tab = table.remove( SLC_CONTENT.info.disabled )

		local total = SLC_CONTENT.info.was_disabled
		progress.total = total
		progress.current = total - #SLC_CONTENT.info.disabled
		progress.name = tab.name

		print( string.format( "Mounting disabled addon: '%s' (%i/%i)", tab.name, progress.current, total ) )

		steamworks.DownloadUGC( tab.id, function( path )
			if path and game.MountGMA( path ) then
				SLC_CONTENT.local_mount[tab.id] = true
				print( "  > Addon mounted: "..tab.name )
			else
				print( "  > Failed to mount: "..tab.name )
			end

			timer.Simple( 0, mount_addons )
		end )
	end

	local function verify_addons()
		local ugcinfo = SLCPromisify( steamworks.FileInfo )
		local info = SLC_CONTENT.info
		local len = #SLC_CONTENT.registry
		
		info.nsub = {}
		info.disabled = {}
		info.ok = 0
		info.nok = 0
		info.size = 0
		info.was_nsub = 0
		info.was_disabled = 0

		SLC_CONTENT.status = SCS_CHECKING

		local promises = {}
		for i = 1, len do
			local id = SLC_CONTENT.registry[i]
			promises[i] = ugcinfo( id ):Then( function( data )
				local tab = {
					id = data.id,
					name = data.title,
					installed = data.installed,
					enabled = !data.disabled,
					size = data.size,
				}

				if !data.installed then
					table.insert( info.nsub, tab )
					info.was_nsub = info.was_nsub  + 1
					info.nok = info.nok + 1
					info.size = info.size + data.size
				elseif data.disabled then
					table.insert( info.disabled, tab )
					info.nok = info.nok + 1
					info.was_disabled = info.was_disabled + 1
				else
					info.ok = info.ok + 1
				end

				return tab
			end )
		end

		local joined = SLCPromiseJoin( promises )
		
		joined:Then( function( tab )
			SLC_CONTENT.status = SCS_DONE

			print( "#####################################" )
			print( "########## Content Checker ##########" )
			print( "#####################################\n" )
			print( "Total missing addons: "..#info.nsub )
			print( "Total disabled addons: "..#info.disabled )
			print( "\n#####################################\n" )
			print( "Missing addons:" )
			for i, v in ipairs( tab ) do
				if !v.installed then
					print( string.format( "\t> '%s' (%s)", v.name, v.id ) )
				end
			end
			print( "\n#####################################\n" )
			print( "Disabled addons:" )
			for i, v in ipairs( tab ) do
				if v.installed and !v.enabled then
					print( string.format( "\t> '%s' (%s)", v.name, v.id ) )
				end
			end
			print( "\n#####################################\n" )

			mount_addons()
		end ):Catch( function( err ) print( err ) end )

		return joined
	end

	function CheckContent()
		return fetch_collection():Then( verify_addons )
	end
end

if SERVER then
	hook.Add( "SLCFullyLoaded", "SLCGamemodeContent", function()
		if game.IsDedicated() then
			timer.Simple( 30, function()
				fetch_collection():Catch( function()
					print( "Failed to fetch collection info!" )
				end )
			end )
		else
			fetch_collection():Catch( function()
				print( "Failed to fetch collection info!" )
			end )
		end
	end )
end