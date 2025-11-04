local WEAPON = FindMetaTable( "Weapon" )

--[[-------------------------------------------------------------------------
Weapon Groups
---------------------------------------------------------------------------]]
SLC_WEAPON_GROUP_OVERRIDE = {}
SLC_WEAPON_GROUP_LIMITS = {}

function AddWeaponToGroup( class, ... )
	if !SLC_WEAPON_GROUP_OVERRIDE[class] then
		SLC_WEAPON_GROUP_OVERRIDE[class] = {}
	end

	for i, v in ipairs( { ... } ) do
		SLC_WEAPON_GROUP_OVERRIDE[class][v] = true
	end
end

function AddGroupToWeapon( group, ... )
	for i, v in ipairs( { ... } ) do
		if !SLC_WEAPON_GROUP_OVERRIDE[v] then
			SLC_WEAPON_GROUP_OVERRIDE[v] = {}
		end

		SLC_WEAPON_GROUP_OVERRIDE[v][group] = true
	end
end

function SetWeaponGroupLimit( group, limit )
	SLC_WEAPON_GROUP_LIMITS[group] = limit
end

local function weapon_value( class, key, wep )
	if wep then
		return wep[key]
	end

	local done = {}

	repeat
		local data = weapons.GetStored( class )
		if !data then return end

		if data[key] != nil then
			return data[key]
		end

		done[class] = true
		class = data.Base
	until !class or done[class]
end


function WeaponInAnyGroup( class, wep )
	local override = SLC_WEAPON_GROUP_OVERRIDE[class]
	if override then
		return true
	end

	local group = weapon_value( class, "Group", wep )
	if !group then return false end

	return true
end

function IsWeaponInGroup( class, group, wep )
	local override = SLC_WEAPON_GROUP_OVERRIDE[class]
	if override then
		return !!override[group]
	end

	local wep_group = weapon_value( class, "Group", wep )
	if !wep_group then return false end

	local t = type( wep_group )
	if t == "string" then
		return wep_group == group
	elseif t == "table" then
		for i, v in pairs( wep_group ) do
			if v == group then return true end
		end
	end

	return false
end

function TestWeaponGroup( class, other, wep )
	local wep_group = SLC_WEAPON_GROUP_OVERRIDE[class]
	if !wep_group then
		local g = weapon_value( class, "Group", wep )
		if !g then
			return false
		end

		local t = type( g )
		if t == "string" then
			wep_group = { [g] = true }
		elseif t == "table" then
			wep_group = CreateLookupTable( g )
		else
			return false
		end
	end

	local other_class
	if isstring( other ) then
		other_class = other
		other = nil
	else
		other_class = other:GetClass()
	end

	local other_group = SLC_WEAPON_GROUP_OVERRIDE[other_class]
	if !other_group then
		local g = weapon_value( other_class, "Group", other )
		if !g then
			return false
		end

		local t = type( g )
		if t == "string" then
			other_group = { [g] = true }
		elseif t == "table" then
			other_group = CreateLookupTable( g )
		else
			return false
		end
	end

	local lowest = math.huge
	local match = false

	for group in pairs( wep_group ) do
		if !other_group[group] then continue end

		local limit = SLC_WEAPON_GROUP_LIMITS[group] or 1
		if limit <= 1 then
			return true, 1
		end

		match = true

		if limit < lowest then
			lowest = limit
		end
	end

	if match then
		return true, lowest
	end

	return false
end

function WEAPON:InAnyGroup()
	return WeaponInAnyGroup( self:GetClass(), self )
end

function WEAPON:IsGroup( group )
	return IsWeaponInGroup( self:GetClass(), group, self )
end

function WEAPON:TestGroup( other )
	return TestWeaponGroup( self:GetClass(), other, self )
end

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
function WEAPON:IsAttackWeapon()
	local class = self:GetClass()

	if SLC_WEAPONS_REG[class] then return true end
	if SLC_OTHER_WEAPONS_REG[class] then return true end

	return false
end

--[[-------------------------------------------------------------------------
ResetViewModelBones
---------------------------------------------------------------------------]]
function WEAPON:ResetViewModelBones()
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local vm = owner:GetViewModel()
	if !IsValid( vm ) then return end
	
	vm:ResetBones()
end

--[[-------------------------------------------------------------------------
Swing Attacks
---------------------------------------------------------------------------]]
function WEAPON:SwingAttack( data )
	self.SwingAttackData = {
		start = CurTime() + ( data.delay or 0 ),
		path_start = data.path_start,
		path_end = data.path_end,
		fov_start = data.fov_start or data.fov or 0,
		fov_end = data.fov_end or data.fov or 0,
		duration = data.duration,
		dist_start = data.dist_start or data.distance,
		dist_end = data.dist_end or data.distance,
		num = data.num,
		mins = data.mins,
		maxs = data.maxs,
		correct_mins = data.mins.x != data.mins.y or data.mins.x != data.mins.z,
		correct_maxs = data.maxs.x != data.maxs.y or data.maxs.x != data.maxs.z,
		callback = data.callback,
		cb_end = data.on_end,
		on_start = data.on_start,
		mask = data.mask,
		filter = data.filter,
		last_id = 0,
	}
end

local trace_tbl = {}
trace_tbl.output = trace_tbl
function WEAPON:SwingThink()
	local data = self.SwingAttackData
	if !data then return end

	local ct = CurTime()
	local dt = ct - data.start

	if dt < 0 then return end

	local delay_time = data.duration / ( data.num - 1 )
	local id = math.ceil( dt / delay_time )

	if id > data.last_id then
		data.last_id = data.last_id + 1

		if data.last_id == 1 and data.on_start then
			data.on_start()
		end

		local owner = self:GetOwner()
	
		local aimvec = owner:GetAimVector()
		local aimang = aimvec:Angle()
		local plyang = owner:GetAngles()
	
		local df = ( data.fov_end - data.fov_start ) * ( data.last_id - 1 ) / ( data.num - 1 )
		local ds = ( data.path_end - data.path_start ) * ( data.last_id - 1 ) / ( data.num - 1 )
		local dd = ( data.dist_end - data.dist_start ) * ( data.last_id - 1 ) / ( data.num - 1 )
	
		local pos = owner:GetShootPos() + aimang:Forward() * ( ds.x + data.path_start.x ) + aimang:Right() * ( ds.y + data.path_start.y ) + aimang:Up() * ( ds.z + data.path_start.z )
		aimang:RotateAroundAxis( aimang:Up(), data.fov_start + df )
	
		trace_tbl.start = pos
		trace_tbl.endpos = pos + aimang:Forward() * ( data.dist_start + dd )
	
		if data.correct_mins then
			trace_tbl.mins = plyang:Forward() * data.mins.x + plyang:Right() * data.mins.y + plyang:Up() * data.mins.z
			//print( trace_tbl.mins )
		else
			trace_tbl.mins = data.mins * 1
		end

		if data.correct_maxs then
			trace_tbl.maxs = plyang:Forward() * data.maxs.x + plyang:Right() * data.maxs.y + plyang:Up() * data.maxs.z
			//print( trace_tbl.maxs )
		else
			trace_tbl.maxs = data.maxs * 1
		end

		/*debugoverlay.Axis( owner:GetShootPos(), Angle(0), 3, 2, false )
		debugoverlay.Axis( owner:GetShootPos() + trace_tbl.mins, Angle(0), 3, 2, false )
		debugoverlay.Axis( owner:GetShootPos() + trace_tbl.maxs, Angle(0), 3, 2, false )*/

		if data.correct_mins or data.correct_maxs then
			OrderVectors( trace_tbl.mins, trace_tbl.maxs )
		end

		trace_tbl.mask = data.mask or MASK_SHOT
		trace_tbl.filter = data.filter or owner

		_DrawNextTrace = true

		owner:LagCompensation( true )
		util.TraceHull( trace_tbl )
		owner:LagCompensation( false )

		if trace_tbl.Hit then
			local stop, center = data.callback( trace_tbl, id, false )
			if stop == true then
				if istable( center ) then
					local bounds = center.bounds or 1
					local start = owner:GetShootPos()

					trace_tbl.start = start
					trace_tbl.endpos = start + aimvec * ( center.distance or 60 )
					trace_tbl.mins = Vector( -bounds, -bounds, -bounds )
					trace_tbl.maxs = Vector( bounds, bounds, bounds )
					trace_tbl.mask = center.mask or data.mask or MASK_SHOT
					trace_tbl.filter = center.filter or data.filter or owner

					_DrawNextTrace = true
					
					owner:LagCompensation( true )
					util.TraceHull( trace_tbl )
					owner:LagCompensation( false )

					if trace_tbl.Hit then
						data.callback( trace_tbl, 0, true )
					end
				end

				if data.cb_end then
					data.cb_end( trace_tbl )
				end

				self.SwingAttackData = nil

				return
			end
		end
	end
	
	if id >= data.num then
		if data.cb_end then
			data.cb_end( trace_tbl )
		end

		self.SwingAttackData = nil
		return
	end

	if id > data.last_id then
		self:SwingThink()
	end
end

--[[-------------------------------------------------------------------------

---------------------------------------------------------------------------]]
function WEAPON:TranslateViewModelAttachment( orig, inverse )
	local view = render.GetViewSetup()
	local vec = view.origin
	local ang = view.angles
	
	local worldx = math.tan( view.fov * math.pi / 360 )
	local viewx = math.tan( view.fovviewmodel * math.pi / 360 )

	local diff = orig - vec
	local factor = worldx / viewx

	local right = ang:Right()
	local up = ang:Up()
	local forward = ang:Forward()

	if !inverse then
		right:Mul( right:Dot( diff ) * factor )
		up:Mul( up:Dot( diff ) * factor )
	elseif factor != 0 then
		right:Mul( right:Dot( diff ) / factor )
		up:Mul( up:Dot( diff ) / factor )
	else
		right = 0
		up = 0
	end

	forward:Mul( forward:Dot( diff ) )

	vec:Add( right )
	vec:Add( up )
	vec:Add( forward )

	return vec
end

--[[-------------------------------------------------------------------------
Custom Data Table

TODO:
	OnChanged
---------------------------------------------------------------------------]]
function WEAPON:InstallCustomDataTable()
	if self._CutomDataTable then return end

	local data = {
		dirty = false,
		full_update = true,
		data = {},
		delta = {},
	}

	self._CutomDataTable = data

	self.Data = setmetatable( {}, {
		__index = function( _, key )
			return data.data[key]
		end,
		__newindex = function( _, key, value )
			local old = data.data[key]
			if old != value then
				data.data[key] = value

				if CLIENT then return end

				data.delta[key] = value
				data.dirty = true
			end
		end
	} )

	if CLIENT then return end

	self.UpdateCustomDataTable = function( this )
		if !data.dirty then return end

		local owner = this:GetOwner()
		if !IsValid( owner ) then return end

		net.Start( "SLCDataTable" )
			net.WriteEntity( this )
			net.WriteTable( data.full_update and data.data or data.delta )
		net.Send( owner )

		data.dirty = false
		data.full_update = false
		data.delta = {}
	end
end

net.Receive( "SLCDataTable", function()
	local ent = net.ReadEntity()
	if !IsValid( ent ) or !ent._CutomDataTable then return end

	for k, v in pairs( net.ReadTable() ) do
		ent._CutomDataTable.data[k] = v
	end
end )

hook.Add( "PreRegisterSWEP", "SLCCustomDataTable", function( swep, class )
	if !swep.UseCustomDT then return end

	local setup_data_tables = swep.SetupDataTables
	swep.SetupDataTables = function( this )
		setup_data_tables( this )
		this:InstallCustomDataTable()
	end

	if CLIENT then return end

	local think = swep.Think
	swep.Think = function( this )
		local ret = think( this )

		this:UpdateCustomDataTable()

		return ret
	end

	local owner_changed = swep.OwnerChanged
	swep.OwnerChanged = function( this )
		if owner_changed then
			owner_changed( this )
		end

		local owner = this:GetOwner()
		if !IsValid( owner ) then return end

		this._CutomDataTable.dirty = true
		this._CutomDataTable.full_update = true
	end
end )