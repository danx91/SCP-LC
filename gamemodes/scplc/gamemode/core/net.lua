if SERVER then
	util.AddNetworkString( "SLCPing" )
	util.AddNetworkString( "SLCSendTable" )
	util.AddNetworkString( "SLCNetRequest" )
	util.AddNetworkString( "SLCPropertyChanged" )
end

--[[-------------------------------------------------------------------------
Ping
---------------------------------------------------------------------------]]
net.PingReceivers = net.PingReceivers or {}

function net.Ping( name, data, ply )
	net.Start( "SLCPing" )
		net.WriteString( tostring( name ) )
		net.WriteString( tostring( data ) )

	if CLIENT then
		net.SendToServer()
	end

	if SERVER then
		if ply == nil then
			net.Broadcast()
		else
			net.Send( ply )
		end
	end
end

net.Receive( "SLCPing", function( len, ply )
	local name = net.ReadString()
	local data = net.ReadString()

	if net.PingReceivers[name] then
		//for i, v in ipairs( receivers[name] ) do
			if isfunction( net.PingReceivers[name] ) then
				net.PingReceivers[name]( data, ply )
			end
		//end
	end
end )

function net.ReceivePing( name, func )
	if !net.PingReceivers[name] then
		net.PingReceivers[name] = {}
	end

	//table.insert( receivers[name], func )
	net.PingReceivers[name] = func
end

--[[-------------------------------------------------------------------------
Sending huge tables
---------------------------------------------------------------------------]]
net.TableReceivers = net.TableReceivers or {}
net.TableChannels = net.TableChannels or {}
net.TableChannelsID = net.TableChannelsID or {}

function net.AddTableChannel( name )
	if !isstring( name ) then
		return false
	end

	if #net.TableChannels >= 255 then
		return false
	end

	if net.TableChannelsID[name] then
		return net.TableChannelsID[name]
	end

	local id = table.insert( net.TableChannels, name )
	net.TableChannelsID[name] = id

	if SERVER and name != "_TableChannel" then
		for i, v in ipairs( player.GetAll() ) do
			v.TableChannelsUpdated = false
		end
	end

	return id
end

function net.ReceiveTable( name, func )
	net.TableReceivers[name] = func
end

local MAX_LEN = 65526 --65536B (64KB - max net message size) - 2B (short / gmod net header) - 4B (integer / checksum) - 3B (message ID info) - 1B (byte /  i'm not sure why, but using value higher by 1 will suppress WriteData)
function net.SendTable( name, tab, ply, disablecrc, dnc )
	local msgid = net.TableChannelsID[name] or isnumber( name ) and name
	if !msgid then
		ErrorNoHalt( "Unknown message name '"..name.."'! Register name by 'net.AddTableChannel' function before using 'net.SendTable'!\n" )
		return false
	end

	if !dnc then
		tab = table.Copy( tab )
	end

	net.PrepareTable( tab )

	local data = util.Compress( util.TableToJSON( tab ) )
	local len = string.len( data )
	local maxid = math.floor( len / MAX_LEN )

	if maxid > 127 then
		ErrorNoHalt( "Message is too big! Message size after compression can't be bigger than 8387328B (8190.75KB = ~7.99MB)\n" )
		return false
	end

	local id = 0

	repeat
		local towrite = math.min( len, MAX_LEN )
		len = len - towrite

		net.Start( "SLCSendTable" )

		local chunk = string.sub( data, 1, towrite )
		data = string.sub( data, towrite + 1 )

		net.WriteData( string.char( msgid ), 1 )
		net.WriteData( string.char( id )..string.char( maxid ), 2 )
		net.WriteData( disablecrc and "0310" or math.Dec2Bin( util.CRC( chunk ) ), 4 ) --0310 is just random data sequence to write instead of CRC (0x30333130)
		net.WriteData( chunk, towrite )

		if CLIENT then
			net.SendToServer()
		end

		if SERVER then
			if ply == nil then
				net.Broadcast()
			else
				net.Send( ply )
			end
		end

		id = id + 1
	until len == 0 or id == 128

	return true
end

local net_cache = {}
net.Receive( "SLCSendTable", function( len, ply )
	local message_id = string.byte( net.ReadData( 1 ) )
	local id = string.byte( net.ReadData( 1 ) ) + 1
	local maxid = string.byte( net.ReadData( 1 ) ) + 1
	local header = net.ReadData( 4 )
	local chunk = net.ReadData( len / 8 - 7 )

	if header != "0310" then //0x30333130
		local crc = util.CRC( chunk )
		local checksum = tostring( math.Bin2Dec( header, true ) )

		if crc != checksum then
			ErrorNoHalt( "SLCSendTable message checksum is wrong! Expected: "..checksum..", got: "..crc..". Message canceled\n" )
			net_cache[message_id] = nil
			return
		end
	-- else
	-- 	print( "crc ignored!" )
	end

	if !net_cache[message_id] then
		net_cache[message_id] = {
			num = 0,
			max = maxid,
			timeout = RealTime() + 5
		}
	end

	local tab = net_cache[message_id]
	tab[id] = chunk
	tab.num = tab.num + 1

	if tab.num == tab.max then
		net_cache[message_id] = nil
		local result = ""

		for i = 1, tab.max do
			result = result..tab[i]
		end


		result = util.JSONToTable( util.Decompress( result ) )

		if !result then
			ErrorNoHalt( "SLCSendTable failed to read meassage content! ("..message_id..")\n" )
			return
		end

		local msg_name = net.TableChannels[message_id]

		if !msg_name then
			if CLIENT and !FULLY_LOADED then
				print( "Suppresing net.SendTable! Player is not fully loaded! - "..message_id )
				return
			end

			ErrorNoHalt( "SLCSendTable failed to get message name! ("..message_id..")\n" )
			return
		end

		local receiver = net.TableReceivers[msg_name]
		if receiver then
			net.RestoreTable( result )
			receiver( result, ply )
		end
	end
end )

net.AddTableChannel( "_TableChannel" )

hook.Add( "Think", "SLCNetTables", function()
	for k, v in pairs( net_cache ) do
		if v.timeout < RealTime() then
			net_cache[k] = nil
			ErrorNoHalt( "Message timeout! ("..k..")\n" )
		end
	end

	if SERVER then
		local plys = {}
		for i, v in ipairs( player.GetAll() ) do
			if !v.TableChannelsUpdated then
				v.TableChannelsUpdated = true
				table.insert( plys, v )
			end
		end

		if #plys > 0 then
			local ch = {}

			for k, v in pairs( net.TableChannels ) do
				if v != "_TableChannel" then
					ch[k] = v
				end
			end

			net.SendTable( "_TableChannel", ch, plys )
		end
	end
end )

if CLIENT then
	net.ReceiveTable( "_TableChannel", function( data )
		for k, v in pairs( data ) do
			net.TableChannels[k] = v
			net.TableChannelsID[v] = k
		end

		NetTablesReceived = true
	end )
end

--[[-------------------------------------------------------------------------
Utils
---------------------------------------------------------------------------]]
local function prepare_type( var )
	if isentity( var ) then
		return { ENTITY = "Entity$"..var:EntIndex() }
	elseif isvector( var ) then
		return { VECTOR = { var.x, var.y, var.z } }
	end
end

function net.PrepareTable( tab )
	for k, v in pairs( tab ) do
		if istable( v ) then
			net.PrepareTable( v )
		else
			local p = prepare_type( v )
			if p then
				tab[k] = p
			end
		end
	end
end

local function restore_type( var )
	if var.ENTITY then
		local id = string.match( var.ENTITY, "Entity$(%d+)" )
		if id then
			local ent = Entity( id )
			//if IsValid( ent ) then
				return ent
			//end
		end
	elseif var.VECTOR then
		return Vector( var.VECTOR[1], var.VECTOR[2], var.VECTOR[3] )
	end
end

function net.RestoreTable( tab )
	for k, v in pairs( tab ) do
		if istable( v ) then
			local r = restore_type( v )
			if r then
				tab[k] = r
			else
				net.RestoreTable( v )
			end
		end
	end
end

--[[-------------------------------------------------------------------------
Requests
---------------------------------------------------------------------------]]
net.RequestsRegistry = {
	_RequestID = 0
}
net.RequestsReceivers = {}

if CLIENT then
	function net.SendRequest( name, data, timeout )
		if !istable( data ) then
			data = { data }
		end

		local id = net.RequestsRegistry._RequestID
		net.RequestsRegistry._RequestID = id + 1

		net.Start( "SLCNetRequest" )
			net.WriteUInt( id, 32 )
			net.WriteString( name )
			net.WriteTable( data )
		net.SendToServer()

		local promise = SLCPromise()

		net.RequestsRegistry[id] = {
			id = id,
			name = name,
			promise = promise
		}

		timer.Simple( timeout or 3, function()
			local req = net.RequestsRegistry[id]
			if !req then return end

			net.RequestsRegistry[id] = nil

			MsgC( Color( 200, 0, 0 ), "Request "..req.name.." ["..req.id.."] timed out!\n" )
			req.promise:Reject( "timeout" )
		end )
	end

	net.Receive( "SLCNetRequest", function( len, ply )
		local id = net.ReadUInt( 32 )
		local req = net.RequestsRegistry[id]

		if !req then
			MsgC( Color( 200, 0, 0 ), "Unknown request with id: "..req.id.."!\n" )
			return
		end

		req.promise:Resolve( net.ReadTable() )
	end )
end

if SERVER then
	function net.ReceiveRequest( name, fn )
		net.RequestsReceivers[name] = fn
	end

	net.Receive( "SLCNetRequest", function( len, ply )
		local id = net.ReadUInt( 32 )
		local name = net.ReadString()
		local data = net.ReadTable()

		local receiver = net.RequestsReceivers[name]
		if !receiver then
			error( "Unhandled request: "..name.."!" )
			return
		end

		SLCToPromise( receiver( ply, name, data ) ):Then( function( result )
			net.Start( "SLCNetRequest" )
				net.WriteUInt( id, 32 )
				net.WriteTable( result )
			net.Send( ply )
		end )
	end )
end

--[[-------------------------------------------------------------------------
Property Changed
---------------------------------------------------------------------------]]
if CLIENT then
	SLCPropertyCallbacks = SLCPropertyCallbacks or {}

	net.Receive( "SLCPropertyChanged", function( len )
		local name = net.ReadString()
		local val = net.ReadTable()[1]

		LocalPlayer():SetProperty( name, val )

		local cb = SLCPropertyCallbacks[name]
		if !cb then return end

		cb( name, val )
	end )

	function OnPropertyChanged( name, cb )
		SLCPropertyCallbacks[name] = cb
	end
end