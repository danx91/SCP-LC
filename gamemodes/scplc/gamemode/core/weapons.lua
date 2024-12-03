local WEAPON = FindMetaTable( "Weapon" )

--[[-------------------------------------------------------------------------
Weapon Groups
---------------------------------------------------------------------------]]
SLC_WEAPON_GROUP_OVERRIDE = {}

function WEAPON:GetGroup()
	return SLC_WEAPON_GROUP_OVERRIDE[self:GetClass()] or self.Group
end

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
SLC_OTHER_WEAPONS_REG = SLC_OTHER_WEAPONS_REG or {}

function MarkAsWeapon( class )
	SLC_OTHER_WEAPONS_REG[class] = true
end

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
			trace_tbl.mins = data.mins
		end
		
		if data.correct_maxs then
			trace_tbl.maxs = plyang:Forward() * data.maxs.x + plyang:Right() * data.maxs.y + plyang:Up() * data.maxs.z
			//print( trace_tbl.maxs )
		else
			trace_tbl.maxs = data.maxs
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