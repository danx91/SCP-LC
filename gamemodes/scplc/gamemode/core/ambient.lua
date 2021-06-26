SLC_AMBIENTS = SLC_AMBIENTS or {
	Registry = {},
	List = {},
	Groups = {},
	CACHE = {},
}

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function AddAmbient( name, path, check, group, volume, duration )
	if SLC_AMBIENTS.Registry[name] then
		print( "Ambient '"..name.."' is already registered!" )
		return false
	end

	if #SLC_AMBIENTS.List >= 255 then
		print( "Reached ambients limit (255)!" )
		return false
	end

	local id = table.insert( SLC_AMBIENTS.List, name )
	SLC_AMBIENTS.Registry[name] = { name = name, id = id, path = path, callback = check, duration = duration, volume = volume or 1 }

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

function PLAYER:StopAmbient( name, all )
	StopAmbient( self, name, all )
end

--[[-------------------------------------------------------------------------
Serverside functions
---------------------------------------------------------------------------]]
if SERVER then
	function PlayAmbient( name, loop, ply, force, co )
		if !IsValid( ply ) then return end

		if ply.PlayingAmbient != name and !force then
			local obj = SLC_AMBIENTS.Registry[name]
			if obj then
				if loop then
					ply.AmbientFinish = 0
				elseif obj.duration then
					ply.AmbientFinish = CurTime() + obj.duration
				else
					return
				end

				ply.AmbientOverride = co
				ply.PlayingAmbient = name

				net.Start( "SLCAmbient" )
					net.WriteBool( true )
					net.WriteBool( loop )
					net.WriteUInt( obj.id, 8 )

				if ply then
					net.Send( ply )
				else
					//net.Broadcast()
				end
			end
		end
	end

	function StopAmbient( ply, name, all )
		if !IsValid( ply ) then return end
		//print( "Stopping...", ply, name, all, ply.PlayingAmbient )

		if name and ply.PlayingAmbient != name then
			return
		end

		if ply.PlayingAmbient or all then
			//print( "Sending stop ambient" )
			net.Start( "SLCAmbient" )
				net.WriteBool( false )
				net.WriteBool( all or false )

			if ply then
				net.Send( ply )
			else
				//net.Broadcast()
			end

			ply.PlayingAmbient = false
		end
	end

	hook.Add( "PlayerPostThink", "SLCAmbientThink", function( ply )
		local id = ply.PlayingAmbient
		if id then
			local obj = SLC_AMBIENTS.Registry[id]
			if obj then
				if isfunction( ply.AmbientOverride ) then
					if ply.AmbientOverride( ply ) then
						StopAmbient( ply, obj.name )
						return
					end
				else
					local cb = obj.callback
					if cb and cb( ply ) then
						StopAmbient( ply, obj.name )
						return
					end
				end

				if ply.AmbientFinish then
					if ply.AmbientFinish != 0 and ply.AmbientFinish < CurTime() then
						ply.PlayingAmbient = false
					end
				end
			end
		end
	end )
end

--[[-------------------------------------------------------------------------
Clientside functions
---------------------------------------------------------------------------]]
if CLIENT then
	local current_ambient
	function GetIGModAudio( name, nc, flags, cb )
		local c_igac = SLC_AMBIENTS.CACHE[name]
		local obj = SLC_AMBIENTS.Registry[name]

		if IsValid( c_igac ) then
			if cb then
				cb( c_igac, obj, false )
			end

			return c_igac
		end

		if c_igac == true then
			return true
		end

		if nc then
			return false
		end

		SLC_AMBIENTS.CACHE[name] = true

		if !flags then
			flags = ""
		end

		if obj then
			StopAmbient()

			sound.PlayFile( obj.path, flags, function( igac, errID, err )
				if IsValid( igac ) then
					current_ambient = name
					SLC_AMBIENTS.CACHE[name] = igac

					igac:SetVolume( obj.volume )

					if cb then
						cb( igac, obj, true )
					end
				else
					print( "IGAC Error!", name, flags, errID, err )
					SLC_AMBIENTS.CACHE[name] = nil
				end
			end )
		end
	end

	function PlayAmbient( name, loop )
		if GetIGModAudio( name, false, "noblock", function( igac, obj, c )
			if loop then
				igac:EnableLooping( true )
			end

			igac:SetTime( 0 )
			igac:Play()
		end ) == false then
			print( "Failed to get IGModAudioChannel for ambient!", name )
		end
	end

	function StopAmbient( all )
		print( "Stopping ambient..." )
		if all then
			for k, v in pairs( SLC_AMBIENTS.CACHE ) do
				SLC_AMBIENTS.CACHE[k] = nil

				if IsValid( v ) then
					print( "Dropping IGAC:", v )
					v:Stop()
				end
			end
		elseif current_ambient then
			local igac = SLC_AMBIENTS.CACHE[current_ambient]
			SLC_AMBIENTS.CACHE[current_ambient] = nil

			if igac != true and IsValid( igac ) then
				print( "Dropping IGAC:", igac )
				igac:Stop()
			end
		end
	end

	net.Receive( "SLCAmbient", function( len )
		local status = net.ReadBool()
		local arg = net.ReadBool()

		if status then
			local id = net.ReadUInt( 8 )
			local name = SLC_AMBIENTS.List[id]

			if name then
				PlayAmbient( name, arg )
			end
		else
			StopAmbient( arg )
		end
	end )
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
end )

AddAmbient( "023", "sound/scp_lc/scp/023/ambient.ogg", nil, nil, 0.2 )*/