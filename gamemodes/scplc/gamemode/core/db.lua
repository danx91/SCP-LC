function SetSCPData( steamid64, name, value )
	local key = steamid64..":"..name
	sql.Query( string.format( "REPLACE INTO scpplayerdata ( dataid, value ) VALUES ( %s, %s )", SQLStr( key ), SQLStr( value ) ) )
end

function GetSCPData( steamid64, name, def )
	local key = steamid64..":"..name
	local value = sql.QueryValue( string.format( "SELECT value FROM scpplayerdata WHERE dataid = %s LIMIT 1", SQLStr( key ) ) )

	if value == nil then
		return def
	end

	return value
end

function RemoveSCPData( steamid64, name )
	local key = steamid64..":"..name
	sql.Query( "DELETE FROM scpplayerdata WHERE dataid = "..SQLStr( key ) )
end

local ply = FindMetaTable( "Player" )

function ply:SetSCPData( name, value )
	SetSCPData( self:SteamID64(), name, value )
end

function ply:GetSCPData( name, def )
	return GetSCPData( self:SteamID64(), name, def )
end

function ply:RemoveSCPData( name )
	RemoveSCPData( self:SteamID64(), name )
end

if !sql.TableExists( "scpplayerdata" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS scpplayerdata ( dataid TEXT NOT NULL PRIMARY KEY, value TEXT );" )
end