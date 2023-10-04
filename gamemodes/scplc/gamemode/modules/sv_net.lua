util.AddNetworkString( "PlayerBlink" )
util.AddNetworkString( "DropWeapon" )
util.AddNetworkString( "UpdateSLCVars" )
util.AddNetworkString( "WeaponDnD" )
util.AddNetworkString( "SCPList" )
util.AddNetworkString( "PlayerReady" )
util.AddNetworkString( "RoundInfo" )
util.AddNetworkString( "PlaySound" )
util.AddNetworkString( "PlayerMessage" )
util.AddNetworkString( "InitialIDs" )
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
util.AddNetworkString( "SLCLooting" )
util.AddNetworkString( "SLCHooks" )
util.AddNetworkString( "SLCXPSummary" )
util.AddNetworkString( "SLCGasZones" )
util.AddNetworkString( "SLCHitMarker" )
util.AddNetworkString( "SLCDamageIndicator" )

net.AddTableChannel( "SLCPlayerMeta" )
net.AddTableChannel( "SLCGameruleData" )
net.AddTableChannel( "SLCInfoScreen" )
--[[-------------------------------------------------------------------------
Receivers
---------------------------------------------------------------------------]]
net.Receive( "PlayerReady", function( len, ply )
	if ply.FullyLoaded and !DEVELOPER_MODE then return end
	ply.FullyLoaded = true

	SendSCPList( ply )

	if ROUND.active then
		if ROUND.post then
			local t = GetTimer( "SLCPostround" )
			if IsValid( t ) then
				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "post",
						time = CurTime() + t:GetRemainingTime(),
						duration = t:GetTime(),
						name = ROUND.roundtype.name,
					}
				net.Send( ply )
			end
		elseif ROUND.infoscreen then
			local t = GetTimer( "SLCSetup" )
			if IsValid( t ) then
				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "inf",
						time = CurTime() + t:GetRemainingTime(),
						duration = t:GetTime(),
						name = ROUND.roundtype.name,
					}
				net.Send( ply )
			end
		elseif ROUND.preparing then
			local t = GetTimer( "SLCPreround" )
			if IsValid( t ) then
				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "pre",
						time = CurTime() + t:GetRemainingTime(),
						duration = t:GetTime(),
						name = ROUND.roundtype.name,
					}
				net.Send( ply )
			end
		else
			local t = GetTimer( "SLCRound" )
			if IsValid( t ) then
				net.Start( "RoundInfo" )
					net.WriteTable{
						status = "live",
						time = CurTime() + t:GetRemainingTime(),
						duration = t:GetTime(),
						name = ROUND.roundtype.name,
					}
				net.Send( ply )
			end
		end
	end

	if !ply.playermeta then
		ErrorNoHalt( "Error! Player.playermeta is nil!\n", ply )
	end

	TransmitSCPHooks( ply )
	net.SendTable( "SLCPlayerMeta", ply.playermeta or {}, ply )

	hook.Run( "PlayerReady", ply )
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

	slc_cmd.ExecCallback( ply, name, args )
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
local PLAYER = FindMetaTable( "Player" )

function PLAYER:SetupSLCVarTable()
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

function PLAYER:SLCVarUpdated( id, var_type, newVal )
	if newVal != nil then
		local cb = self.scp_var_callbacks[var_type][id]
		if cb then
			cb( self, newVal )
		end
	end

	for i, v in ipairs( self.scp_update_var ) do
		if v[1] == id and v[2] == var_type then
			return
		end
	end

	table.insert( self.scp_update_var, { id, var_type } )
end

function PLAYER:SetSLCVarCallback( id, var_type, cb )
	assert( type( cb ) == "function", "Bad argument #1 to function SetSLCVarCallback. Function expected got "..type( cb ) )

	self.scp_var_callbacks[var_type][id] = cb
end

function PLAYER:AddSLCVar( name, id, var_type )
	if !name or !id or !var_type then return end

	if !self.scp_var_table then
		self:SetupSLCVarTable()
	end

	assert( self.scp_var_table[var_type], "Invalid var_type '"..var_type.."'!" )
	assert( id < 16, "Too big ID in AddSLCVar function. IDs cannot be greater than 15!" )
	assert( id >= 0, "ID in AddSLCVar cannot be negative!" )

	if var_type == "BOOL" then
		self.scp_var_table.BOOL[id] = false
		self["Set"..name] = function( this, b )
			assert( type( b ) == "boolean", "Bad argument #1 to function Set"..name..". Boolean expected, got "..type( b ) )
			if this.scp_var_table.BOOL[id] != b then
				this.scp_var_table.BOOL[id] = b
				this:SLCVarUpdated( id, "BOOL", b )
			end
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.BOOL[id]
		end

		self:SLCVarUpdated( id, "BOOL" )
	elseif var_type == "INT" then
		self.scp_var_table.INT[id] = 0
		self["Set"..name] = function( this, int )
			assert( type( int ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got "..type( int ) )
			int = math.floor( int )
			if this.scp_var_table.INT[id] != int then
				this.scp_var_table.INT[id] = int
				this:SLCVarUpdated( id, "INT", int )
			end
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.INT[id]
		end

		self:SLCVarUpdated( id, "INT" )
	elseif var_type == "FLOAT" then
		self.scp_var_table.FLOAT[id] = 0
		self["Set"..name] = function( this, f )
			assert( type( f ) == "number", "Bad argument #1 to function Set"..name..". Number expected, got "..type( f ) )
			if this.scp_var_table.FLOAT[id] != f then
				this.scp_var_table.FLOAT[id] = f
				this:SLCVarUpdated( id, "FLOAT", f )
			end
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.FLOAT[id]
		end

		self:SLCVarUpdated( id, "FLOAT" )
	elseif var_type == "STRING" then
		self.scp_var_table.STRING[id] = ""
		self["Set"..name] = function( this, str )
			assert( type( str ) == "string", "Bad argument #1 to function Set"..name..". String expected, got "..type( str ) )
			if this.scp_var_table.STRING[id] != str then
				this.scp_var_table.STRING[id] = str
				this:SLCVarUpdated( id, "STRING", str )
			end
		end
		self["Get"..name] = function( this )
			return this.scp_var_table.STRING[id]
		end

		self:SLCVarUpdated( id, "STRING" )
	end
end

function UpdateSLCVars( ply )
	if ply.scp_update_var then
		local num = #ply.scp_update_var
		if num > 0 then
			net.Start( "UpdateSLCVars" )
			net.WriteUInt( num, 6 ) --max 64 values, 16 of each var_type

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

hook.Add( "Tick", "UpdateSLCVars", function()
	for _, v in ipairs( player.GetAll() ) do
		UpdateSLCVars( v )
	end
end )

net.Receive( "UpdateSLCVars", function( len, ply )
	if !ply.scp_var_table then return end

	for k, v in pairs( ply.scp_var_table ) do
		for id, val in pairs( v ) do
			//if isnumber( id ) then
				ply:SLCVarUpdated( id, k )
			//end
		end
	end

	UpdateSLCVars( ply )
end )