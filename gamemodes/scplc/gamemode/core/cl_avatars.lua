local api_url = "https://steamcommunity.com/profiles/%s?xml=1"
local cache_dir = "slc/avatars/"
local fallback_mat = Material( "vgui/avatar_default" )

local avatar_cache = {}

local function fetch_avatar( sid, cb )
	local avatar

	if file.Exists( cache_dir..sid..".jpg", "DATA" ) then
		avatar = Material( "../data/"..cache_dir..sid..".jpg", "smooth" )
	elseif file.Exists( cache_dir..sid..".png", "DATA" ) then
		avatar = Material( "../data/"..cache_dir..sid..".png", "smooth" )
	end

	if avatar and !avatar:IsError() then
		if cb then cb( avatar ) end
		return
	end

	local function fail_func( ... )
		print( "AvatarMaterial fetch failed!", ... )
		if cb then cb( fallback_mat ) end
	end

	http.Fetch( string.format( api_url, sid ), function( body, size, headers, code )
		if size == 0 or code < 200 or code > 299 then return fail_func( "profile", code ) end

		local url, ext = string.match( body, "<avatarFull>.-(https?://%S+)%.(%w+).-</avatarFull>" )
		if !url or !ext then return fail_func( "profile", "bad avatar url" ) end
		if ext == "jpeg" then ext = "jpg" end
		if ext != "jpg" and ext != "png" then return fail_func( "profile", "bad avatar ext", ext ) end

		http.Fetch( url.."."..ext, function( body2, size2, headers2, code2 )
			if size2 == 0 or code2 < 200 or code2 > 299 then return fail_func( "avatar", code2 ) end

			local img_path = cache_dir..sid.."."..ext
			file.Write( img_path, body2 )

			avatar = Material( "../data/"..img_path, "smooth" )

			if avatar:IsError() then
				return fail_func( "avatar", "material error" )
			else
				if cb then cb( avatar ) end
			end
		end, function( err ) fail_func( "avatar", err ) end )
	end, function( err ) fail_func( "profile", err ) end )
end

function AvatarMaterial( ply, cb )
	if avatar_cache[ply] then
		if cb then cb( avatar_cache[ply] ) end
		return avatar_cache[ply]
	end

	local sid = ply

	if isentity( ply ) then
		if !IsValid( ply ) or !ply:IsPlayer() then return end
		sid = ply:SteamID64()
	elseif !isstring( ply ) then return
	elseif string.match( ply, "^STEAM_" ) then
		sid = util.SteamIDTo64( ply )
	end

	avatar_cache[ply] = fallback_mat

	if sid == "0" or !string.match( sid, "^%d+$" ) then return end

	fetch_avatar( sid, function( avatar )
		avatar_cache[ply] = avatar
	end )

	return fallback_mat
end

hook.Add( "SLCFullyLoaded", "SLCClearCachedAvatars", function()
	file.CreateDir( cache_dir )

	for k, v in ipairs( file.Find( cache_dir.."*", "DATA" ) ) do
		file.Delete( cache_dir..v )
	end
end )