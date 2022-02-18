--[[-------------------------------------------------------------------------
MySQL Library

MySQL is async so there is one hack (SLCInMemoryDatabase) used to remember values
for quick access where async function would fail
---------------------------------------------------------------------------]]

SLCMySQLEnabled = SLCMySQLEnabled or false
SLCMySQL = SLCMySQL or {
	//database = nil,
	preload = {}
}

SLCMySQL.q_set = "REPLACE INTO scpplayerdata ( dataid, value ) VALUES ( '%s', '%s' );"
SLCMySQL.q_get = "SELECT value FROM scpplayerdata WHERE dataid = '%s';"
SLCMySQL.q_rem = "DELETE FROM scpplayerdata WHERE dataid = '%s';"

SLCMySQL.table_schema = "CREATE TABLE IF NOT EXISTS scpplayerdata ( dataid VARCHAR(255) NOT NULL PRIMARY KEY, value VARCHAR(255) );"

--[[-------------------------------------------------------------------------
Preloads values to SLCInMemoryDatabase on player initial spawn
---------------------------------------------------------------------------]]
function SLCMySQL.AddPreload( name, def, func, nw )
	SLCMySQL.preload[name] = {
		def = def,
		func = func,
		nw = nw,
	}
end

local function initialize_functions( db )
	--Escape
	SLCMySQL.escape = function( msg )
		msg = tostring( msg )

		return SLCMySQL.database:escape( msg )
	end

	--Standard query, returns SLCPromise
	SLCMySQL.query = function( query )
		return SLCPromise( function( resolve, reject )
			local q = db:query( query )

			q.onSuccess = function( self, data )
				resolve( data )
			end

			q.onError = function( self, err, sql_q )
				MsgC( Color( 200, 0, 0 ), "MySQL query error! "..sql_q.."\n" )
				print( err )

				reject( err )
			end

			q:start()
		end )
	end

	--Simple query, returns nothing
	SLCMySQL.simple_query = function( query, success, err, data, abort )
		local q = db:query( query )

		if success then q.onSuccess = success end
		if err then q.onError = err end
		if data then q.onData = data end
		if abort then q.onAborted = abort end

		q:start()
	end

	--synchronous query, returns data or error
	SLCMySQL.sync_query = function( query )
		local q = db:query( query )

		q:start()
		q:wait( true )

		return q:getData(), q:error()
	end

	hook.Add( "ShutDown", "MySQL", function()
		if SLCMySQL.database then
			print( "Disconnecting MySQL..." )
			SLCMySQL.database:disconnect( true )
		end
	end )

	hook.Add( "SLCFactoryReset", "ResetMySQL", function()
		if SLCMySQL.database then
			print( "Dropping MySQL database..." )

			local drop_q = SLCMySQL.database:query( "DROP TABLE scpplayerdata" )
			drop_q:start()
		end
	end )

	hook.Add( "PlayerInitialSpawn", "MySQL", function( ply )
		if SLCMySQLEnabled then

			ply.SLCInMemoryDatabase = {}

			for k, v in pairs( SLCMySQL.preload ) do
				SLCMySQL.query( string.format( SLCMySQL.q_get, SLCMySQL.escape( ply:SteamID64()..":"..k ) ) ):Then( function( data )
					if data and data[1] then
						local value = data[1].value

						if v.func then
							value = v.func( value )
						end

						if value == nil then
							value = v.def
						end

						ply.SLCInMemoryDatabase[k] = value

						if v.wn then
							local key = "Set"..v.nw
							if ply[key] then
								ply[key]( ply, value )
							end
						end
					end
				end )
			end
		end
	end )
end

function SLCUseMySQL( cfg )
	if SLCMySQL.database then return end
	print( "Loading MySQL..." )

	require( "mysqloo" )

	if mysqloo then
		local db = mysqloo.connect( cfg.host, cfg.username, cfg.password, cfg.database, cfg.port, cfg.socket )
		
		function db.onConnected( self )
			MsgC( Color( 0, 150, 0 ), "MySQL successfully connected!\n" )

			SLCMySQLEnabled = true
			SLCMySQL.database = self

			local tab_q = self:query( SLCMySQL.table_schema )
			tab_q:start()

			initialize_functions( self )
		end

		function db.onConnectionFailed( self, err )
			MsgC( Color( 200, 0, 0 ), "Failed to connect to MySQL!\n" )
			print( err )
		end

		db:connect()
	else
		MsgC( Color( 200, 0, 0 ), "Failed to load MySQL binary file!\n" )
	end
end

SLCMySQL.AddPreload( "scp_penalty", 0, tonumber )