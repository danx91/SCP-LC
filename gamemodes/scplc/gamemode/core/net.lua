if SERVER then
	util.AddNetworkString( "SLCPing" )
	util.AddNetworkString( "SLCSendTable" )
	//util.AddNetworkString( "SLCSharedHook" )
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
	return id
end

function net.ReceiveTable( name, func )
	net.TableReceivers[name] = func
end

local MAX_LEN = 65526 --65536B (64KB - max net message size) - 2B (short / gmod net header) - 4B (integer / checksum) - 3B (message ID info) - 1B (byte /  i'm not sure why, but using value higher by 1 will supress WriteData)
function net.SendTable( name, tab, ply )
	local msgid = net.TableChannelsID[name] or isnumber( name ) and name
	if !msgid then
		ErrorNoHalt( "Unknown message name '"..name.."'! Register name by 'net.AddTableChannel' function before using 'net.SendTable'!\n" )
		return false
	end

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
		net.WriteData( math.Dec2Bin( util.CRC( chunk ) ), 4 )
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

	local crc = util.CRC( chunk )
	local checksum = tostring( math.Bin2Dec( header, true ) )
	
	if crc != checksum then
		ErrorNoHalt( "SLCSendTable message checksum is wrong! Expected: "..checksum..", got: "..crc..". Message canceled\n" )
		net_cache[message_id] = nil
		return
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
			ErrorNoHalt( "SLCSendTable failed to get message name! ("..message_id..")\n" )
			return
		end

		local receiver = net.TableReceivers[msg_name]
		if receiver then
			receiver( result, ply )
		end
	end
end )

hook.Add( "Think", "NetTablesTimeout", function()
	for k, v in pairs( net_cache ) do
		if v.timeout < RealTime() then
			net_cache[k] = nil
			ErrorNoHalt( "Message timeout! ("..k..")\n" )
		end
	end
end )

--[[-------------------------------------------------------------------------
Shared hooks
---------------------------------------------------------------------------]]
/*function hook.RunShared( name, ... )
	net.Start( "SLCSharedHook" )
		net.WriteString( name )
		net.WriteTable( {...} )
	net.Broadcast()

	return hook.Run( name, ... )
end

function hook.RunSharedPlayer( ply, name, ... )
	net.Start( "SLCSharedHook" )
		net.WriteString( name )
		net.WriteTable( {...} )
	net.Send( ply )

	return hook.Run( name, ... )
end*/