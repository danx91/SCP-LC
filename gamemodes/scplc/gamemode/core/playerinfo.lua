if !file.Exists( "slc", "DATA" ) then
	file.CreateDir( "slc" )
end

if !file.Exists( "slc/playerinfo", "DATA" ) then
	file.CreateDir( "slc/playerinfo" )
end

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
		tab.Data = util.JSONToTable( file.Read( tab.File, "DATA" ) )
	end

	return tab
end

function PlayerInfo:Update()
	file.Write( self.File, util.TableToJSON( self.Data ) )
end

function PlayerInfo:Get( key )
	return self.Data[key]
end

function PlayerInfo:Set( key, value )
	self.Data[key] = value
	self:Update()
end

setmetatable( PlayerInfo, { __call = PlayerInfo.New } )