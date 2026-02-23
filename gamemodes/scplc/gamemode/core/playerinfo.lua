hook.Add( "SLCGamemodeLoaded",  "SLCPlayerInfo", function()
	if !file.Exists( "slc/playerinfo/corrupted", "DATA" ) then
		file.CreateDir( "slc/playerinfo/corrupted" )
	end
end )

PlayerInfo = {}

function PlayerInfo:New( arg )
	if self != PlayerInfo then return end

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

	tab.Ready = GetSCPData( tab.ID, "playerinfo", "{}" ):Then( function( raw )
		local data = util.JSONToTable( raw )

		if !data then
			print( "Player data of '"..tab.ID.."' is corrupted! Fixing..." )
			file.Write( "slc/playerinfo/corrupted/"..tab.ID.."_"..os.date( "%d%m%y" )..".dat", raw )

			data = {}
			SetSCPData( tab.ID, "playerinfo", "{}" )
		end

		tab.Data = data
	end )

	return tab
end

function PlayerInfo:Update()
	local data = util.TableToJSON( self.Data )
	SetSCPData( self.ID, "playerinfo", data )
end

function PlayerInfo:Get( key )
	if !self.Data then
		ErrorNoHalt( "Tried to use PlayerInfo too early - info not loaded yet!\n" )
		return
	end

	return self.Data[key]
end

function PlayerInfo:Set( key, value )
	if !self.Data then
		ErrorNoHalt( "Tried to use PlayerInfo too early - info not loaded yet!\n" )
		return
	end

	self.Data[key] = value
	self:Update()
end

setmetatable( PlayerInfo, { __call = PlayerInfo.New } )

if SERVER then
	//lua_run slc_convert_playerinfo_to_db()

	local function convert_file( f )
		local raw = file.Read( "slc/playerinfo/"..f, "DATA" )
		if !raw then
			print( "Failed to read '"..f.."' playerinfo - cannot read file!" )
			return nil
		end

		local data = util.JSONToTable( raw )
		if !data then
			print( "Failed to read '"..f.."' playerinfo - corrupted JSON!" )
			return nil
		end

		if data.compressed then
			data = util.JSONToTable( util.Decompress( data.data ) )
		end

		if !data then
			print( "Failed to read '"..f.."' playerinfo!" )
			return nil
		end

		return SetSCPData( string.sub( f, 1, -5 ), "playerinfo", util.TableToJSON( data ) )
	end

	function slc_convert_playerinfo_to_db()
		print( "Begin playerinfo migration to database..." )

		SLCDatabase:Query( "BEGIN;" ):Then( function()
			local files = file.Find( "slc/playerinfo/*.dat", "DATA" )
			local size = #files

			print( "Migrating "..size.." files" )

			local promises = {}
			for i, v in ipairs( files ) do
				if i % 10 == 0 then
					print( i.." / "..size.." ("..math.Round( i / size * 100, 1 ).."%)" )
				end

				promises[i] = convert_file( v )
			end

			print( "Commiting - It may take a while..." )
			return SLCPromiseJoin( promises )
		end ):Then( function()
			return SLCDatabase:Query( "COMMIT;" )
		end ):Then( function()
			print( "Migration done! You can now safely delete 'garrysmod/data/slc/playerinfo/' directory" )
		end ):Catch( function()
			print( "Migration failed - rolling back database operations" )
			SLCDatabase:Query( "ROLLBACK;" )
		end )
	end
end