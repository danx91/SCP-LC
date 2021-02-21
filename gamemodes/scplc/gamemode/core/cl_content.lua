--SLCModulesLoaded

SLC_CONTENT = {
	REGISTRY = {},
	DATA = {
		OK = {},
		//NOT_SUBSCRIBED = {},
		//NOT_ENABLED = {},
		//NOK = 0
		NOK = {}
	},
	DOWNLOAD = {
		downloading = false,
		idle = true,
	}
}

function AddGamemodeContent( workshopid )
	table.insert( SLC_CONTENT.REGISTRY, workshopid )
end

function CheckContent()
	local nok = 0
	local data = SLC_CONTENT.DATA
	local len = #SLC_CONTENT.REGISTRY

	//data.OK = {}
	data.NOT_SUBSCRIBED = {}
	data.NOT_ENABLED = {}

	for i = 1, len do
		local id = SLC_CONTENT.REGISTRY[i]

		local subscribed = steamworks.IsSubscribed( id )
		//local enabled = steamworks.ShouldMountAddon( id )

		if subscribed and enabled then
			//table.insert( data.OK, id )
		elseif !subscribed then
			//table.insert( data.NOT_SUBSCRIBED, id )
			table.insert( data.NOK, id )
			//print( "nsub" )
			nok = nok + 1
		elseif !enabled then
			//table.insert( data.NOT_ENABLED, id )
			//table.insert( data.NOK, id )
			//nok = nok + 1
		end
	end

	//data.NOK = nok

	if nok > 0 then
		local lang = LANG.MISC.content_checker
		SLCPopup( lang.title, string.format( lang.msg, nok, len ), true, function( i )
			if i == 1 then
				//gui.OpenURL( "https://steamcommunity.com/sharedfiles/filedetails/?id=2037536745" )
				gui.OpenURL( "https://steamcommunity.com/sharedfiles/filedetails/?id=1805981251" )
			end

			/*if i == 0 then
				SLC_CONTENT.DOWNLOAD.downloading = true
				DownloadAddons()
			else*/
				//MakePlayerReady()
			//end
		end, /*lang.download,*/ lang.workshop, lang.no )
	end
end

-- function DownloadAddons()
-- 	local tab = SLC_CONTENT.DOWNLOAD
-- 	local data = SLC_CONTENT.DATA
-- 	local lang = LANG.MISC.content_checker

-- 	if !IsValid( SLC_POPUP ) then
-- 		SLCPopup( lang.downloading, "\n", true, function( i )
-- 			if i == 1 then
-- 				tab.downloading = false
-- 			end
-- 		end, lang.cancel )
-- 	end

-- 	/*if #data.NOT_SUBSCRIBED > 0 then
-- 		tab.idle = false

-- 		local id = table.remove( data.NOT_SUBSCRIBED, 1 )
-- 		print( "Downloading addon", id )

-- 		--download file

-- 		data.NOK = data.NOK - 1
-- 	elseif #data.NOT_ENABLED > 0 then*/
-- 	if #data.NOK > 0 then
-- 		tab.idle = false

-- 		//local id = table.remove( data.NOT_ENABLED, 1 )
-- 		local id = table.remove( data.NOK, 1 )
-- 		print( "addon", id )

-- 		if IsValid( SLC_POPUP ) then
-- 			SLC_POPUP.text = string.format( lang.processing, id, lang.downloading )
-- 		end

-- 		//if true then tab.idle = true return end

-- 		local time = RealTime()
-- 		print( "Downloading addon with ID: "..id )
-- 		steamworks.DownloadUGC( id, function( path, obj )
-- 			print( "Finished downloading! Took: "..math.Round( RealTime() - time ).."s" )

-- 			if !path then
-- 				print( "Failed to download addon with ID: "..id )
-- 				tab.idle = true
-- 				return
-- 			end

-- 			if !tab.downloading then return end

-- 			if IsValid( SLC_POPUP ) then
-- 				SLC_POPUP.text = string.format( lang.processing, id, lang.mounting )
-- 			end

-- 			print( "Mounting addon", path )

-- 			if game.MountGMA( path ) then
-- 				print( "Addon mounted successfully!" )
-- 			else
-- 				print( "Failed to mount addon!" )
-- 			end

-- 			tab.idle = true
-- 		end )
-- 	else
-- 		tab.idle = true
-- 	end
-- end

-- hook.Add( "Think", "SLCDownloadThink", function()
-- 	local tab = SLC_CONTENT.DOWNLOAD
-- 	//print( tab.downloading, tab.idle )
-- 	if tab.downloading and tab.idle then
-- 		local data = SLC_CONTENT.DATA
-- 		if #data.NOK > 0 then
-- 			DownloadAddons()
-- 		else
-- 			tab.downloading = false
			
-- 			if IsValid( SLC_POPUP ) then
-- 				SLC_POPUP:Close()
-- 			end

-- 			SLCPopup( "aaaa", "zakonczono" )
-- 		end
-- 	end
-- end )

--[[-------------------------------------------------------------------------
Base Content
---------------------------------------------------------------------------]]
AddGamemodeContent( "1805069928" ) -- scplc_content
--AddGamemodeContent( "349050451" ) -- Customizable Weaponry 2.0
AddGamemodeContent( "1613647269" ) -- Customizable Weaponry 2.0 Fixed
AddGamemodeContent( "358608166" ) -- Extra Customizable Weaponry 2.0
AddGamemodeContent( "869104712" ) -- SCP Foundation Models
AddGamemodeContent( "740748927" ) -- SCP Staff
AddGamemodeContent( "738724607" ) -- Merryweather Security
AddGamemodeContent( "676638642" ) -- Black Mesa Scientist-Citizens (Playermodels and NPCs)
AddGamemodeContent( "923586734" ) -- Passport V2
AddGamemodeContent( "905114757" ) -- SCP-682 PM
AddGamemodeContent( "245750342" ) -- CS:GO Zeus x27 Taser
AddGamemodeContent( "925670022" ) -- SCP:CB Prop pack
AddGamemodeContent( "871969365" ) -- [Empire]SCP Staff Janitor
AddGamemodeContent( "737686580" ) -- SCP Foundation - Soldier
AddGamemodeContent( "1083837237" ) -- SCP:BREACH Staff models
AddGamemodeContent( "1267850660" ) -- SCP: Containment Breach - Unity: SCP-106 PM & NPC
AddGamemodeContent( "1350884815" ) -- SCP: Containment Breach - Unity: SCP-173 PM
AddGamemodeContent( "1272811493" ) -- SCP: Containment Breach - Unity: SCP-939 PM
AddGamemodeContent( "935624655" ) -- SCP Pack (860-B, 999, 131-A, 131-B)
AddGamemodeContent( "290599102" ) -- SCP Site 19 (Sandbox)
AddGamemodeContent( "764329142" ) -- SCP Site 19 (Sounds)
AddGamemodeContent( "931700563" ) -- SCP-066 Playermodel
AddGamemodeContent( "910206946" ) -- SCP-966 Playermodel & Ragdoll
AddGamemodeContent( "183901628" ) -- SCP 049 PM and NPC model
AddGamemodeContent( "367531149" ) -- SCP 096 - Nextbot
AddGamemodeContent( "2104194368" ) -- Omnitool
AddGamemodeContent( "1368927958" ) -- 023
AddGamemodeContent( "1435327003" ) -- particle cannon