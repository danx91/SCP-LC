--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function SetSCPData( steamid64, name, value, ply )
	local key = steamid64..":"..name

	if SLCMySQLEnabled then
		SLCMySQL.simple_query( string.format( SLCMySQL.q_set, SLCMySQL.escape( key ), SLCMySQL.escape( value ) ) )

		if ply and ply.SLCInMemoryDatabase then
			ply.SLCInMemoryDatabase[name] = value
		end
	else
		sql.Query( string.format( "REPLACE INTO scpplayerdata ( dataid, value ) VALUES ( %s, %s )", SQLStr( key ), SQLStr( value ) ) )
	end
end


--[[---------------------------------------------------------------------------
GetSCPData( steamid64, name, def, func, ply, pdk, update, sync )

Get data from DB

@param		[string]		steamid64			SteamID64 of player
@param		[string]		name				Name of variable
@param		[any]			def					Default value
@param		[function]		func				Optional, if specified, value will be passed to this function
@param		[Player]		ply					Optional, the player, used to set data on player (pdk must also be specified!)
@param		[stiring]		pdk					Optional, player data key, used to set data on player (ply must also be specified!)
@param		[type]			update				Optional, MySQL only, will perform real query and update player's SLCInMemoryDatabase
@param		[type]			sync				Optional, MySQL only, will perform real SYNCHRONOUS query

@return		[any]			-					Result, IMPORTANT: if MySQL is used and sync == false and ( update == true or !IsValid( ply ) ), SLCPromise will be returned!
---------------------------------------------------------------------------]]--
function GetSCPData( steamid64, name, def, func, ply, pdk, update, sync )
	local key = steamid64..":"..name
	local value

	if SLCMySQLEnabled then
		if sync then
			local data = SLCMySQL.sync_query( string.format( SLCMySQL.q_get, SLCMySQL.escape( key ) ) )
			if data and data[1] then
				value = data[1].value
			end
		else
			if update or !IsValid( ply ) then
				return SLCMySQL.query( string.format( SLCMySQL.q_get, SLCMySQL.escape( key ) ) ):Then( function( data )
					if data and data[1] then
						local val = data[1].value

						if func then
							val = func( val )
						end
					
						if val == nil then
							val = def
						end
						
						if IsValid( ply ) then
							if pdk then
								local set_pdk = "Set"..pdk
								if ply[set_pdk] then
									ply[set_pdk]( ply, val )
								end
							end

							ply.SLCInMemoryDatabase = ply.SLCInMemoryDatabase or {}
							ply.SLCInMemoryDatabase[name] = value
						end

						return val
					end
				end )
			else
				return ply.SLCInMemoryDatabase and ply.SLCInMemoryDatabase[name] or def
			end
		end
	else
		value = sql.QueryValue( string.format( "SELECT value FROM scpplayerdata WHERE dataid = %s LIMIT 1", SQLStr( key ) ) )
	end

	if func then
		value = func( value )
	end

	if value == nil then
		value = def
	end

	if pdk and IsValid( ply ) then
		local set_pdk = "Set"..pdk
		if ply[set_pdk] then
			ply[set_pdk]( ply, value )
		end
	end

	if SLCMySQLEnabled and update and IsValid( ply ) then
		ply.SLCInMemoryDatabase = ply.SLCInMemoryDatabase or {}
		ply.SLCInMemoryDatabase[name] = value
	end

	return value
end

function RemoveSCPData( steamid64, name, ply )
	local key = steamid64..":"..name

	if SLCMySQLEnabled then
		SLCMySQL.simple_query( string.format( SLCMySQL.q_rem, SLCMySQL.escape( key ) ) )

		if ply and ply.SLCInMemoryDatabase and ply.SLCInMemoryDatabase[name] then
			ply.SLCInMemoryDatabase[name] = nil
		end
	else
		sql.Query( "DELETE FROM scpplayerdata WHERE dataid = "..SQLStr( key ) )
	end
end

--[[-------------------------------------------------------------------------
Player Bindings
---------------------------------------------------------------------------]]
local ply = FindMetaTable( "Player" )

function ply:SetSCPData( name, value )
	SetSCPData( self:SteamID64(), name, value, self )
end

function ply:GetSCPData( name, def, sync, update )
	return GetSCPData( self:SteamID64(), name, def, nil, self, nil, update, sync )
end

function ply:RemoveSCPData( name )
	RemoveSCPData( self:SteamID64(), name, self )
end

function ply:SetDataFromDB( name, def, func, pdk )
	return GetSCPData( self:SteamID64(), name, def, func, self, pdk, true, false )
end

--[[-------------------------------------------------------------------------
SQLite
---------------------------------------------------------------------------]]
if !sql.TableExists( "scpplayerdata" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS scpplayerdata ( dataid TEXT NOT NULL PRIMARY KEY, value TEXT );" )
end

--[[-------------------------------------------------------------------------
Factory reset
---------------------------------------------------------------------------]]
if SERVER then
	hook.Add( "SLCFactoryReset", "ResetDB", function()
		print( "Dropping database..." )
		sql.Query( "DROP TABLE scpplayerdata" )
	end )
end