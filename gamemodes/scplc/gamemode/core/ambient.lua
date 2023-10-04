SLC_AMBIENTS = SLC_AMBIENTS or {
	Registry = {},
	List = {},
	Groups = {},
	CACHE = {},
}

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function AddAmbient( name, path, check, group, volume, duration, fade )
	if SLC_AMBIENTS.Registry[name] then
		print( "Ambient '"..name.."' is already registered!" )
		SLC_AMBIENTS.Registry[name] = { name = name, id = SLC_AMBIENTS.Registry[name].id, path = path, callback = check, duration = duration, volume = volume or 1, fade = fade }
		return false
	end

	if #SLC_AMBIENTS.List >= 255 then
		print( "Reached ambients limit (255)!" )
		return false
	end

	local id = table.insert( SLC_AMBIENTS.List, name )
	SLC_AMBIENTS.Registry[name] = { name = name, id = id, path = path, callback = check, duration = duration, volume = volume or 1, fade = fade }

	if group then
		if !SLC_AMBIENTS.Groups[group] then
			SLC_AMBIENTS.Groups[group] = {}
		end

		table.insert( SLC_AMBIENTS.Groups[group], name )
	end

	return true
end

function GetAmbient( name )
	return SLC_AMBIENTS.Registry[name]
end

function SelectAmbient( group )
	local tab = SLC_AMBIENTS.Groups[group]
	if tab then
		return tab[math.random( #tab )]
	end
end

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )
function PLAYER:PlayAmbient( name, loop, force, co )
	PlayAmbient( name, loop, self, force, co )
end

function PLAYER:StopAmbient( name )
	StopAmbient( self, name )
end

--[[-------------------------------------------------------------------------
Serverside functions
---------------------------------------------------------------------------]]
if SERVER then
	function PlayAmbient( name, loop, ply, force, co )
		if !IsValid( ply ) then return end
		if !ply.SLCAmbient then ply.SLCAmbient = {} end
		if ply.SLCAmbient[name] and !force then return end

		local obj = SLC_AMBIENTS.Registry[name]
		if !obj then return end

		local data = {
			finish = 0,
			override = co,
		}
		
		ply.SLCAmbient[name] = data

		if !loop and obj.duration then
			data[0] = CurTime() + obj.duration
		end

		if !loop and !obj.duration then return end

		net.Start( "SLCAmbient" )
			net.WriteBool( true )
			net.WriteBool( loop )
			net.WriteUInt( obj.id, 8 )
		net.Send( ply )
	end

	function StopAmbient( ply, name )
		if !IsValid( ply ) then return end

		if name and !ply.SLCAmbient[name] then return end

		local obj = name and SLC_AMBIENTS.Registry[name]
		if !obj and !name then return end

		ply.SLCAmbient[name] = nil

		net.Start( "SLCAmbient" )
			net.WriteBool( false )
			net.WriteBool( !name )

			if name then
				net.WriteUInt( name and obj.id, 8 )
			end
		net.Send( ply )
	end

	hook.Add( "PlayerPostThink", "SLCAmbientThink", function( ply )
		if !ply.SLCAmbient then return end

		local ct = CurTime()

		for name, data in pairs( ply.SLCAmbient ) do
			local obj = SLC_AMBIENTS.Registry[name]
			if !obj then continue end

			if data.override and data.override( ply, name ) == true then
				StopAmbient( ply, name )
				continue
			end

			if obj.callback and obj.callback( ply, name ) == true then
				StopAmbient( ply, name )
				continue
			end

			local finish = data.finish
			if finish and finish != 0 and finish <= ct then
				ply.SLCAmbient[name] = nil
			end
		end
	end )
end

--[[-------------------------------------------------------------------------
Clientside functions
---------------------------------------------------------------------------]]
if CLIENT then
	function GetIGModAudio( name, flags, dontcreate, cb )
		local obj = SLC_AMBIENTS.Registry[name]
		if !obj then return end
		
		local c_igac = SLC_AMBIENTS.CACHE[name]
		if c_igac == true then return true end

		if IsValid( c_igac ) then
			if cb then
				cb( c_igac, obj, false )
			end

			return c_igac
		end

		if dontcreate then return false end

		SLC_AMBIENTS.CACHE[name] = true

		sound.PlayFile( obj.path, flags or "", function( igac, errID, err )
			if !IsValid( igac ) then
				SLC_AMBIENTS.CACHE[name] = nil
				print( "IGAC Error!", name, obj.path, flags, errID, err )
				return
			end

			SLC_AMBIENTS.CACHE[name] = igac
			igac:SetVolume( obj.volume )

			if cb then
				cb( igac, obj, true )
			end
		end )
	end

	function PlayAmbient( name, loop )
		//print( "Starting ambient...", name, loop )
		if GetIGModAudio( name, "noblock", false, function( igac, obj, c )
			//print( "IGAC OK" )
			if loop then
				igac:EnableLooping( true )
			end

			igac:SetTime( 0 )
			igac:Play()
		end ) == false then
			print( "Failed to get IGModAudioChannel for ambient!", name )
		end
	end

	function StopAmbient( name )
		//print( "Stopping ambient...", fade, name, all )
		if !name then
			for k, v in pairs( SLC_AMBIENTS.CACHE ) do
				SLC_AMBIENTS.CACHE[k] = nil

				if IsValid( v ) then
					print( "Dropping IGAC:", v )
					v:Stop()
				end
			end
		elseif name then
			local obj = SLC_AMBIENTS.Registry[name]
			if !obj then return end

			local igac = SLC_AMBIENTS.CACHE[name]
			SLC_AMBIENTS.CACHE[name] = nil

			if igac == true or !IsValid( igac ) then return end

			if obj.fade then
				igac:FadeStop( obj.fade )
			else
				print( "Dropping IGAC:", igac )
				igac:Stop()
			end
		end
	end

	net.Receive( "SLCAmbient", function( len )
		local status = net.ReadBool()
		local arg = net.ReadBool()

		if status then
			local name = SLC_AMBIENTS.List[net.ReadUInt( 8 )]
			if !name then return end

			PlayAmbient( name, arg )
		else
			if arg then
				StopAmbient()
			else
				local name = SLC_AMBIENTS.List[net.ReadUInt( 8 )]
				if !name then return end

				StopAmbient( name )
			end
		end
	end )
end

--[[-------------------------------------------------------------------------
IGAC functions
---------------------------------------------------------------------------]]
if CLIENT then
	local IGAC = FindMetaTable( "IGModAudioChannel" )
	function IGAC:FadeStop( time )
		local vol = self:GetVolume()
		local num = math.ceil( 10 * time )

		//print( "FADE STOP", time )
		Timer( "igac_fadeout"..tostring( self ), 0.1, num - 1, function( this, n )
			if !IsValid( self ) then
				this:Destroy()
				return
			end

			//print( "Setting volume", 1 - n / num )
			self:SetVolume( vol * ( 1 - n / num ) )
		end, function( this )
			if !IsValid( self ) then return end
			//print( "FADE STOP STOP" )
			print( "Dropping IGAC:", self )
			self:Stop()
		end )
	end
end

/*concommand.Add( "ambient", function( ply, cmd, args )
	if SERVER then
		if !args[1] or args[1] == "stop" then
			ply:StopAmbient()
		elseif args[1] == "clear" then
			ply:StopAmbient( true )
		elseif args[1] == "list" then
			PrintTable( SLC_AMBIENTS.CACHE )
		else
			ply:PlayAmbient( args[1], args[2] == "loop" )
		end
	end
end )*/

AddAmbient( "scp_chase", "sound/scp_lc/chase.ogg", nil, nil, 1, 22, 5 )