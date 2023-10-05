function AddGamemodeContent( workshopid )
	if SERVER then
		resource.AddWorkshop( workshopid )
		print( "Adding '"..workshopid.."' to resource.AddWorkshop!" )
	else
		table.insert( SLC_CONTENT.registry, workshopid )
	end
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

	/*local path_upd = false
	local gm_path = cookie.GetString( "slc_gm_ws_path" )
	local function update_gm_path( path )
		if path_upd then return true end

		local base = string.match( path, "^(.+[\\/]workshop[\\/]content[\\/]4000[\\/]).+$" )
		if !base then return false end

		path_upd = true
		gm_path = base
		cookie.Set( "slc_gm_ws_path", base )
		LocalMountHack()
		print( "GM PATH UPDATE" )
		return true
	end*/

	function CheckContent()
		//for i, v in ipairs( engine.GetAddons() ) do
			//if update_gm_path( v.file ) then break end
		//end

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
				data = data[1]

				/*local hack = false
				if !data.installed and file.Exists( "cache/workshop/"..data.id..".gma", "GAME" ) then
					data.installed = true
					data.disabled = true
					hack = true
				end*/

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

					//if hack then
						//info.was_nsub = info.was_nsub  + 1
					//else
						info.was_disabled = info.was_disabled + 1
					//end
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

			LocalMount()
		end ):Catch( function(err) print(err) end )

		return joined
	end

	function LocalMount()
		if #SLC_CONTENT.info.disabled == 0 then
			SLC_CONTENT.status = SCS_DONE
			DownloadAddons()
			return
		end

		SLC_CONTENT.status = SCS_MOUNTING

		local progress = SLC_CONTENT.progress
		local tab = table.remove( SLC_CONTENT.info.disabled )

		local total = SLC_CONTENT.info.was_disabled
		progress.total = total
		progress.current = total - #SLC_CONTENT.info.disabled
		progress.name = tab.name

		Msg( string.format( "Mounting disabled addons: '%s' (%i/%i)", tab.name, progress.current, total ) )

		steamworks.DownloadUGC( tab.id, function( path )
			if game.MountGMA( path ) then
				SLC_CONTENT.local_mount[tab.id] = true
				Msg( "\t\tMounted!\n" )
			else
				Msg( "\t\tFailed!\n" )
			end

			//update_gm_path( path )
			timer.Simple( 0, LocalMount )
		end )
	end

	/*function LocalMountHack( i )
		if !i then
			i = 1
			progress.total = #SLC_CONTENT.info.nsub
		end

		if #SLC_CONTENT.info.nsub == 0 or i > #SLC_CONTENT.info.nsub or !gm_path then
			SLC_CONTENT.status = SCS_DONE
			return
		end

		SLC_CONTENT.status = SCS_MOUNTING

		local tab = SLC_CONTENT.info.nsub[i]

		progress.current = i
		progress.name = tab.name

		Msg( string.format( "Trying to mount local addon: '%s'", tab.name, progress.current, total ) )

		if game.MountGMA( gm_path.."/" ) then
			SLC_CONTENT.local_mount[tab.id] = true
			Msg( "\t\tMounted!\n" )
		else
			Msg( "\t\tFailed!\n" )
		end

			update_gm_path( path )
			timer.Simple( 0, LocalMount )
	end*/

	function DownloadAddons()
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

		Msg( string.format( "Downloading addons: '%s' (%i/%i)", tab.name, progress.current, progress.total ) )

		steamworks.DownloadUGC( tab.id, function( path )
			if game.MountGMA( path ) then
				SLC_CONTENT.local_mount[tab.id] = true
				Msg( "\t\tMounted!\n" )
			else
				Msg( "\t\tFailed!\n" )
			end
			
			//update_gm_path( path )
			timer.Simple( 0, DownloadAddons )
		end )
	end
end

--[[-------------------------------------------------------------------------
Base Content
---------------------------------------------------------------------------]]
AddGamemodeContent( "2402059605" ) -- SCP: Lost Control
AddGamemodeContent( "1805069928" ) -- SCP: Lost Control - Content Pack
AddGamemodeContent( "1368927958" ) -- [Novux Project] Playermodel SCP-023
AddGamemodeContent( "183901628" ) -- SCP 049 PM and NPC model
AddGamemodeContent( "2509724092" ) -- SCP058
AddGamemodeContent( "931700563" ) -- SCP-066 Playermodel
AddGamemodeContent( "367531149" ) -- SCP 096 - Nextbot
AddGamemodeContent( "1267850660" ) -- SCP: Containment Breach - Unity: SCP-106 PM & NPC
AddGamemodeContent( "2556178016" ) -- SCP-173 [P.M]
AddGamemodeContent( "905114757" ) -- SCP-682 PM
AddGamemodeContent( "1272811493" ) -- SCP: Containment Breach - Unity: SCP-939 PM
AddGamemodeContent( "910206946" ) -- SCP-966 Playermodel & Ragdoll
AddGamemodeContent( "2271330776" ) -- S.C.P 2427-3 [FOR LOST CONTROL]
AddGamemodeContent( "2111632519" ) -- Scp 3199 - playermodel for S.C.P - Lost Control
AddGamemodeContent( "935624655" ) -- SCP Pack (860-B, 999, 131-A, 131-B)
AddGamemodeContent( "1074125384" ) -- SCP-500 "Panacea" Entity and Model
AddGamemodeContent( "2124819577" ) -- SCP Zombie Personel
AddGamemodeContent( "871969365" ) -- [Empire]SCP Staff Janitor
AddGamemodeContent( "740748927" ) -- SCP Staff
AddGamemodeContent( "2499221486" ) -- SCP:LC | Scientific Staff [P.M/Ragdoll]
AddGamemodeContent( "2364118772" ) -- security
AddGamemodeContent( "1083837237" ) -- SCP:BREACH Staff models
AddGamemodeContent( "737686580" ) -- SCP Foundation - Soldier
AddGamemodeContent( "2213313378" ) -- MTF_support
AddGamemodeContent( "2567003071" ) -- CI_soldiers
AddGamemodeContent( "2799711826" ) -- GOC Soldier Retexture
AddGamemodeContent( "804903699" ) -- Hazmat Suit Playermodel (COD Ghosts)
AddGamemodeContent( "925670022" ) -- SCP:CB Prop pack
AddGamemodeContent( "2104194368" ) -- Omnitool [S.C.P Content]
AddGamemodeContent( "2140249780" ) -- Turret_scp
AddGamemodeContent( "2832346918" ) -- Tablet
AddGamemodeContent( "2829865944" ) -- Fuse box
AddGamemodeContent( "1409120926" ) -- Military Grade Rugged Server Laptop
AddGamemodeContent( "783530452" ) -- Rust Backpack (Prop)
AddGamemodeContent( "2484281292" ) -- SCP:LC | PASSPORT
AddGamemodeContent( "358608166" ) -- Extra Chuck's Weaponry 2.0
AddGamemodeContent( "349050451" ) -- Chuck's Weaponry 2.0
AddGamemodeContent( "886451400" ) -- [CW 2.0] Khris' Shared Content
AddGamemodeContent( "886125449" ) -- [CW 2.0] Khris' Pistols
AddGamemodeContent( "886132509" ) -- [CW 2.0] Khris' SMG's
AddGamemodeContent( "886137508" ) -- [CW 2.0] Khris' Rifles
AddGamemodeContent( "886148959" ) -- [CW 2.0] Khris' Shotguns
AddGamemodeContent( "3019072969" ) -- Homemade Weapons - Table leg, Pipe & Glass knife (SWEPs)
AddGamemodeContent( "245750342" ) -- CS:GO Zeus x27 Taser
AddGamemodeContent( "290599102" ) -- SCP Site 19 (Sandbox)
AddGamemodeContent( "764329142" ) -- SCP Site 19 (Sounds)
AddGamemodeContent( "557962238" ) -- ULib
AddGamemodeContent( "557962280" ) -- ULX