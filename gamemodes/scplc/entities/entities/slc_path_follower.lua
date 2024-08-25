AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PathMode = "Simple"
ENT.NextRepath = 0
ENT.Speed = 200
ENT.CutCornerRadius = 0
ENT.DesiredAngle = Angle( 0, 0, 0 )

function ENT:SetupDataTables()

end

function ENT:Initialize()
	if SERVER then
		self.BehaviourThread = coroutine.create( function() self:Behaviour() end )
	end
end

function ENT:Think()
	if CLIENT then return end

	if coroutine.status( self.BehaviourThread ) == "dead" then return end

	local status, err = coroutine.resume( self.BehaviourThread )
	if !status then
		print( "Error in coroutine!", err )
		self:Remove()
		return
	end

	self:SetAngles( LerpAngle( FrameTime() * 8, self:GetAngles(), self.DesiredAngle ) )

	self:NextThink( CurTime() )
	return true
end

function ENT:Behaviour()
	while true do
		coroutine.yield()
	end
end

function ENT:OnMove()
	
end

function ENT:Move()
	while true do
		local ct = CurTime()
		if self.NextRepath != 0 and self.NextRepath <= ct then
			local path = true

			if self.Mode == "Follow" then
				path = self:Repath( 100 )

				if !path then
					self.NextRepath = CurTime() + 2.5
				else
					self.NextRepath = CurTime() + 7.5
				end
			end

			if path and self:Repath() != nil then
				return "unreachable"
			end
		end

		if !self.Path then return "no path" end

		local len = #self.Path
		if len == 0 then return "no path" end

		local result = self:OnMove()
		if result then
			return result != true and result or "canceled"
		end

		local pos = self:GetPos()
		local goal = self.Path[1]
		local dir = goal - pos
		dir:Normalize()
		
		pos = pos + dir * FrameTime() * self.Speed
		local new_dir = goal - pos
		new_dir:Normalize()

		if new_dir:Dot( dir ) <= -0.9 then
			pos = goal
		end

		self:SetPos( pos )

		local ang = dir:Angle()
		self.DesiredAngle = Angle( 0, ang.y, 0 )

		if pos == goal then
			table.remove( self.Path, 1 )

			if len == 1 then
				if self.Mode == "Follow" and pos:DistToSqr( self.Target:GetPos() ) >= 100 then
					self.NextRepath = 1
				else
					return "done"
				end
			end
		end

		coroutine.yield()
	end
end

function ENT:CutCorner( cur_point, prev_point, next_point )
	if prev_point.z != cur_point.z or next_point.z != cur_point.z then return end

	local radius = self.CutCornerRadius

	local vec_dist = cur_point:Distance( prev_point )
	if vec_dist < radius then
		radius = vec_dist
	end

	vec_dist = cur_point:Distance( next_point )
	if vec_dist < radius then
		radius = vec_dist
	end

	local dir_to_prev = prev_point - cur_point
	dir_to_prev:Normalize()

	local dir_to_next = next_point - cur_point
	dir_to_next:Normalize()

	local dir_dot = dir_to_prev:Dot( dir_to_next )
	if math.abs( dir_dot ) > 0.9 then return end

	local cross = dir_to_prev:Cross( dir_to_next )
	local vec_ang = math.atan2( cross:Length(), dir_dot )
	local dist = radius / math.sin( vec_ang / 2 )

	vec_ang = math.deg( vec_ang )
	cross:Normalize()

	local center_angle = dir_to_prev:Angle()
	center_angle:RotateAroundAxis( cross, vec_ang / 2 )

	local center = cur_point + center_angle:Forward() * dist
	local path = {}

	if DEVELOPER_MODE then
		debugoverlay.Line( cur_point, center, 30, Color( 255, 255, 0 ), true )
		debugoverlay.Line( cur_point, cur_point + cross * 32, 30, Color( 255, 255, 255 ), true )
		debugoverlay.Line( cur_point, cur_point + dir_to_next * 32, 30, Color( 255, 0, 0 ), true )
		debugoverlay.Line( cur_point, cur_point + dir_to_prev * 32, 30, Color( 255, 0, 0 ), true )
	end

	center_angle:RotateAroundAxis( cross, 180 )

	center_angle:RotateAroundAxis( cross,  90 - vec_ang / 2 )
	table.insert( path, center + center_angle:Forward() * radius )

	if DEVELOPER_MODE then
		debugoverlay.Line( center, center + center_angle:Forward() * radius, 30, Color( 0, 255, 255 ), true )
	end

	local rotations = math.floor( ( 180 - vec_ang ) / 10 )
	for a = 1, rotations do
		center_angle:RotateAroundAxis( cross, -10 )
		table.insert( path, center + center_angle:Forward() * radius )

		if DEVELOPER_MODE then
			debugoverlay.Line( center, center + center_angle:Forward() * radius, 30, Color( 0, 255, 255 ), true )
		end
	end

	return path
end

local test_offset = Vector( 0, 0, 12 )
function ENT:Repath( max_steps )
	local pos

	if self.Mode == "Simple" then
		pos = self.Target
	elseif self.Mode == "Follow" then
		if !IsValid( self.Target ) then
			self:Stop()
			return
		end

		pos = self.Target:GetPos()
	end

	local our_pos = self:GetPos()

	DEV_NO_PATH = true
	local path = SLCCalculatePath( our_pos, pos, "manhattan", function( nav1, nav2 )
		local pos1 = nav1:GetCenter()
		local pos2 = nav2:GetCenter()

		if math.abs( pos1.z - pos2.z ) > 64 then return false end

		if util.TraceLine( {
			start = pos1 + test_offset,
			endpos = pos2 + test_offset,
			mask = CONTENTS_SOLID,
		} ).Hit then return false end

		return true
	end, max_steps )

	if path == true then
		path = { our_pos, pos }
	elseif !istable( path ) then
		return path
	end

	local len = #path
	if self.CutCornerRadius > 0 and len > 2 then
		local new_path = {
			path[1]
		}

		for i = 2, len - 1 do
			local points = self:CutCorner( path[i], path[i - 1], path[i + 1] )
			if points then
				table.Add( new_path, points )
			else
				table.insert( new_path, path[i] )
			end
		end

		table.insert( new_path, path[len] )

		path = new_path
	end

	if DEVELOPER_MODE then
		SLCDrawPath( path, 30 )
	end

	table.remove( path, 1 )
	self.Path = path
end

function ENT:SetSpeed( speed )
	self.Speed = speed
end

function ENT:SetCutCornerRadius( radius )
	self.CutCornerRadius = radius
end

function ENT:MoveTo( vec )
	self.Mode = "Simple"
	self.Target = vec
	self.NextRepath = 0

	local repath = self:Repath()
	if repath == nil then
		return self:Move()
	end

	return repath
end

function ENT:Follow( ent )
	self.Mode = "Follow"
	self.Target = ent
	self.NextRepath = CurTime() + 1

	local repath = self:Repath()
	if repath == nil then
		return self:Move()
	end

	return repath
end

function ENT:Stop()
	self.Target = nil
	self.NextRepath = 0
	self.Path = nil
end