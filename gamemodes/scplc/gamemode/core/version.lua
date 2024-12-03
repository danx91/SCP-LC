local op_mt = {
	__eq = function( this, other )
		if this.realm == "i" or other.realm == "i" then return false end
		return this.realm == other.realm and this.major == other.major and this.minor == other.minor and this.patch == other.patch and this.rev == other.rev
	end,
	__lt = function( this, other )
		if this.realm == "i" or other.realm == "i" then return false end
		if this.major == other.major then
			if this.minor == other.minor then
				if this.patch == other.patch then
					return this.rev < other.rev
				else
					return this.patch < other.patch
				end
			else
				return this.minor < other.minor
			end
		else
			return this.major < other.major
		end
	end,
	__le = function( this, other )
		if this.realm == "i" or other.realm == "i" then return false end
		if this.major == other.major then
			if this.minor == other.minor then
				if this.patch == other.patch then
					return this.rev <= other.rev
				else
					return this.patch < other.patch
				end
			else
				return this.minor < other.minor
			end
		else
			return this.major < other.major
		end
	end,
	__tostring = function( this )
		return this.name
	end
}

local realms = {
	b = "BETA"
}

function SLCVersion( sig )
	sig = sig or SIGNATURE

	local realm, major, minor, patch, rev = string.match( sig, "^(%a)(%d%d)(%d%d)(%d%d)r(%d+)$" )
	major = tonumber( major )
	minor = tonumber( minor )
	patch = tonumber( patch )
	rev = tonumber( rev )

	//print( realm, major, minor, patch, rev )

	if !realm or !major or !minor or !patch or !rev then
		return setmetatable( {
			signature = sig,
			name = "Invalid Version",
			realm = "i",
			major = 0,
			minor = 0,
			patch = 0,
			rev = 0,
		}, op_mt )
	end

	local name = ""

	if realms[realm] then
		name = realms[realm].." "
	end

	name = name..major.."."..minor.."."..patch

	if rev > 0 then
		name = name.." rev. "..rev
	end

	return setmetatable( {
		signature = sig,
		name = name,
		realm = realm,
		major = major,
		minor = minor,
		patch = patch,
		rev = rev,
	}, op_mt )
end