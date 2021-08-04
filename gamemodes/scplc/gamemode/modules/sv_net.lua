util.AddNetworkString( "PlayerBlink" )
util.AddNetworkString( "DropWeapon" )
util.AddNetworkString( "UpdateSCPVars" )
util.AddNetworkString( "WeaponDnD" )
util.AddNetworkString( "SCPList" )
util.AddNetworkString( "PlayerReady" )
util.AddNetworkString( "RoundInfo" )
util.AddNetworkString( "PlaySound" )
util.AddNetworkString( "PlayerMessage" )
util.AddNetworkString( "PlayerSetup" )
util.AddNetworkString( "PlayerCleanup" )
util.AddNetworkString( "DropVest" )
util.AddNetworkString( "CameraDetect" )
util.AddNetworkString( "CenterMessage" )
util.AddNetworkString( "PlayerCommand" )
util.AddNetworkString( "PlayerEffect" )
util.AddNetworkString( "SCPUpgrade" )
util.AddNetworkString( "DeathInfo" )
util.AddNetworkString( "ClassUnlock" )
util.AddNetworkString( "SLCAmbient" )
util.AddNetworkString( "SLCEscape" )
util.AddNetworkString( "SLCPlayerDataUpdate" )
util.AddNetworkString( "SLCGamemodeConfig" )
util.AddNetworkString( "SLCProgressBar" )
//util.AddNetworkString( "SLCAuthLibrary" )

net.AddTableChannel( "SLCPlayerMeta" )
net.AddTableChannel( "SLCGameruleData" )
net.AddTableChannel( "SLCInfoScreen" )
--[[-------------------------------------------------------------------------
Receivers
---------------------------------------------------------------------------]]
net.Receive( "PlayerReady", function( len, ply )
	SendSCPList( ply )

	if ROUND.active then
		if ROUND.post then
			net.Start( "RoundInfo" )
				net.WriteTable{
					status = "post",
					time = CurTime() + GetTimer( "SLCPostround" ):GetRemainingTime(),
					name = ROUND.roundtype.name,
				}
			net.Send( ply )
		elseif ROUND.infoscreen then
			local t = GetTimer( "SLCSetup" )
			if t then
				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "inf",
						time = CurTime() + t:GetRemainingTime(),
						name = ROUND.roundtype.name,
					}
				net.Send( ply )
			end
		elseif ROUND.preparing then
			local t = GetTimer( "SLCPreround" )

			/*local time
			if t then
				time = t:GetRemainingTime()
			else
				time = GetTimer( "SLCSetup" ):GetRemainingTime() + CVAR.slc_time_preparing:GetInt()
			end*/

			if t then
				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "pre",
						time = CurTime() + t:GetRemainingTime(),
						name = ROUND.roundtype.name,
					}
				net.Send( ply )
			end
		else
			local t = GetTimer( "SLCRound" )

			net.Start( "RoundInfo" )
				net.WriteTable{
					status = "live",
					time = CurTime() + ( t and t:GetRemainingTime() or 0 ),
					name = ROUND.roundtype.name,
				}
			net.Send( ply )
		end
	end

	if !ply.playermeta then
		ErrorNoHalt( "Error! Player.playermeta is nil!\n", ply )
	end

	net.SendTable( "SLCPlayerMeta", ply.playermeta or {}, ply )

	if !ply.FullyLoaded then
		ply.FullyLoaded = true
		hook.Run( "PlayerReady", ply )
	end
end )

net.Receive( "DropWeapon", function( len, ply )
	local ctrl = ply:GetProperty( "mind_control" )
	if ctrl and ctrl[1] < CurTime() then
		return
	end

	local class = net.ReadString()
	ply:PlayerDropWeapon( class )
end )

net.Receive( "WeaponDnD", function( len, ply )
	local ctrl = ply:GetProperty( "mind_control" )
	if ctrl and ctrl[1] < CurTime() then
		return
	end
	
	local wep1 = net.ReadEntity()
	local wep2 = net.ReadEntity()


	if IsValid( wep1 ) and IsValid( wep2 ) then
		if wep1:GetOwner() == ply and wep2:GetOwner() == ply then
			if wep2.DragAndDrop then
				wep2:DragAndDrop( wep1 )
			end
		end
	end
end )

net.Receive( "DropVest", function( len, ply )
	if ply:GetVest() > 0 then
		ply:DropVest()
	end
end )

net.Receive( "PlayerCommand", function( len, ply )
	local name = net.ReadString()
	local args = net.ReadTable()

	cmd.ExecCallback( ply, name, args )
end )

net.Receive( "ClassUnlock", function( len, ply )
	local class = net.ReadString()

	if class then
		ply:UnlockClass( class )
	end
end )

--[[-------------------------------------------------------------
SCP VARS
---------------------------------------------------------------]]
local ply = FindMetaTable( "Player" )
local _type = type

function ply:SetupSCPVarTable()
	self.scp_var_table = {
		BOOL = {},
		INT = {},
		FLOAT = {},
		STRING = {},
	}

	self.scp_update_var = {}

	self.scp_var_callbacks = {
		BOOL = {},
		INT = {},
		FLOAT = {},
		STRING = {},
	}
end

function ply:SCPVarUpdated( id, type, newVal )
	if newVal != nil then
		local cb = self.scp_var_callbacks[type][id]
		if cb then
			cb( self, newVal )
		end
	end

	for i, v in ipairs( self.scp_update_var ) do
		if v[1] == id and v[2] == type then
			return
		end
	end

	table.insert( self.scp_update_var, { id, type } )
end

function ply:SetSCPVarCallback( id, type, cb )
	assert( _type( cb ) == "function", "Bad argument #1 to function SetSCPVarCallback. Function expected got ".._type( cb ) )

	self.scp_var_callbacks[type][id] = cb
end

function ply:AddSCPVar( name, id, type )
	if !name or !id or !type then return end

	if !self.scp_var_table then
		self:SetupSCPVarTable()
	end

	/*assert( self.scp_var_table[type], "Invalid type '"..type.."'!" )

	if !id then
		id = self.scp_var_lookup[type][name]

		if !id then
			for i = 0, 15 do
				if self.scp_var_table[type][i] == nil then
					id = i
					break
				end
			end
		end
	end
	
	assert( id, "Failed to assign ID for SCPVar '"..name.."'! " )
	assert( id < 16, "You can only create maximum of 16 SCPVars of each type!" )*/
	assert( id < 16, "Too big ID in AddSCPVar function. IDs cannot be greater than 15!" )
	assert( id >= 0, "ID in AddSCPVar cannot be negative!" )

	if type == "BOOL" then
		self.scp_var_table.BOOL[id] = false
		self["Set"..name] = function( self, b )
			assert( _type( b ) == "boolean", "Bad argument #1 to function Set"..name..". Boolean expected, got ".._type( b ) )
			if self.scp_var_table.BOOL[id] != b then
				self.scp_var_table.BOOL[id] = b
				self:SCPVarUpdated( id, "BOOL", b )
			end
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.BOOL[id]
		end

		self:SCPVarUpdated( id, "BOOL" )
	elseif type == "INT" then
		self.scp_var_table.INT[id] = 0
		self["Set"..name] = function( self, int )
			assert( _type( int ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got ".._type( int ) )
			int = math.floor( int )
			if self.scp_var_table.INT[id] != int then
				self.scp_var_table.INT[id] = int
				self:SCPVarUpdated( id, "INT", int )
			end
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.INT[id]
		end

		self:SCPVarUpdated( id, "INT" )
	elseif type == "FLOAT" then
		self.scp_var_table.FLOAT[id] = 0
		self["Set"..name] = function( self, f )
			assert( _type( f ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got ".._type( f ) )
			if self.scp_var_table.FLOAT[id] != f then
				self.scp_var_table.FLOAT[id] = f
				self:SCPVarUpdated( id, "FLOAT", f )
			end
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.FLOAT[id]
		end

		self:SCPVarUpdated( id, "FLOAT" )
	elseif type == "STRING" then
		self.scp_var_table.STRING[id] = ""
		self["Set"..name] = function( self, str )
			assert( _type( str ) == "string", "Bad argument #1 to function Set"..name..". String expected, got ".._type( str ) )
			if self.scp_var_table.STRING[id] != str then
				self.scp_var_table.STRING[id] = str
				self:SCPVarUpdated( id, "STRING", str )
			end
		end
		self["Get"..name] = function( self )
			return self.scp_var_table.STRING[id]
		end

		self:SCPVarUpdated( id, "STRING" )
	end
end

function UpdateSCPVars( ply )
	if ply.scp_update_var then
		local num = #ply.scp_update_var
		if num > 0 then
			net.Start( "UpdateSCPVars" )
			net.WriteUInt( num, 6 ) --max 64 values, 16 of each type

			for _, var in pairs( ply.scp_update_var ) do
				if var[2] == "BOOL" then
					local id = var[1]

					net.WriteInt( id, 6 ) --00xxxx where xxxx is 4 bit ID
					net.WriteBool( ply.scp_var_table.BOOL[id] )
				elseif var[2] == "INT" then
					local id = var[1]

					net.WriteInt( id + 16, 6 ) --01xxxx where xxxx is 4 bit ID
					net.WriteInt( ply.scp_var_table.INT[id], 32 )
				elseif var[2] == "FLOAT" then
					local id = var[1]

					net.WriteInt( id - 32, 6 ) --10xxxx where xxxx is 4 bit ID
					net.WriteFloat( ply.scp_var_table.FLOAT[id] )
				elseif var[2] == "STRING" then
					local id = var[1]

					net.WriteInt( id - 16, 6 ) --11xxxx where xxxx is 4 bit ID
					net.WriteString( ply.scp_var_table.STRING[id] )
				end
			end

			net.Send( ply )

			ply.scp_update_var = {}
		end
	end
end

hook.Add( "Tick", "UpdateSCPVars", function()
	for _, v in pairs( player.GetAll() ) do
		UpdateSCPVars( v )
	end
end )

net.Receive( "UpdateSCPVars", function( len, ply )
	if !ply.scp_var_table then return end

	for k, v in pairs( ply.scp_var_table ) do
		for id, val in pairs( v ) do
			//if isnumber( id ) then
				ply:SCPVarUpdated( id, k )
			//end
		end
	end

	UpdateSCPVars( ply )
end )