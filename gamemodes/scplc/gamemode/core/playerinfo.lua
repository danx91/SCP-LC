hook.Add( "SLCGamemodeLoaded",  "SLCPlayerInfo", function()
	if !file.Exists( "slc/playerinfo", "DATA" ) then
		file.CreateDir( "slc/playerinfo" )
	end
end )

PlayerInfo = {}
function PlayerInfo:New( arg )
	local tab = {}
	setmetatable( tab, { __index = PlayerInfo } )

	tab.New = function() end

	local t = type( arg )
	if t == "string" then
		tab.ID = arg
		tab.Player = NULL
	elseif t == "Player" then
		tab.ID = arg:SteamID64()
		tab.Player = arg
		arg.PlayerInfo = tab
	else
		print( "Error! Failed to create PlayerInfo!" )
		return
	end

	tab.File = "slc/playerinfo/"..tab.ID..".dat"
	if !file.Exists( tab.File, "DATA" ) then
		file.Write( tab.File, "{}" )
		tab.Data = {}
	else
		local f = file.Read( tab.File, "DATA" )
		local data = util.JSONToTable( f )

		if !data then
			print( "Player data of '"..tab.ID.."' is corrupted! Fixing..." )

			if f then
				if !file.Exists( "slc/playerinfo/corrupted", "DATA" ) then
					file.CreateDir( "slc/playerinfo/corrupted" )
				end

				file.Write( "slc/playerinfo/corrupted/"..tab.ID.."_"..os.date( "%d%m%y" )..".dat", f )
			end

			file.Write( tab.File, "{}" )
			tab.Data = {}

			return tab
		end

		if data.compressed then
			data = util.JSONToTable( util.Decompress( data.data ) )
		end

		if !data then
			print( "Failed to load Playerdata for player: "..tostring( tab.Player ).." - "..tab.ID )

			if t == "Player" then
				tab.Player.PlayerInfo = nil
			end

			return
		end

		tab.Data = data

		tab:Update()
	end

	return tab
end

function PlayerInfo:Update()
	local data = util.TableToJSON( self.Data )

	if gamerule.Get( "compressPlayerdata" ) == true then
		local c = util.Compress( data )

		if c then
			data = util.TableToJSON( { compressed = true, data = c } )
		end
	end

	file.Write( self.File, data )
end

function PlayerInfo:Get( key )
	return self.Data[key]
end

function PlayerInfo:Set( key, value )
	self.Data[key] = value
	self:Update()
end

setmetatable( PlayerInfo, { __call = PlayerInfo.New } )

hook.Add( "SLCRegisterGamerules", "SLCPlayerInfoRule", function()
	gamerule.Register( "compressPlayerdata", { value = false } )
end )