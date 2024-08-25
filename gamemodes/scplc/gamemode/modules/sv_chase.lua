--[[-------------------------------------------------------------------------
Chase Area
---------------------------------------------------------------------------]]
local ChaseArea = {}

function ChaseArea:New( cont )
	local tab = {}
	
	tab.Controller = cont
	tab.UID = cont.AreaUIDs
	cont.AreaUIDs = cont.AreaUIDs + 1
	
	return setmetatable( tab, { __index = ChaseArea } )
end

function ChaseArea:Think()
	local ct = CurTime()
	if self.DieTime <= ct then return true end

	//debugoverlay.Sphere( self.Position, self.Radius, 0.3, Color( 255, 255, 255, 0 ), true )

	local tab = self.Controller.ChasedBy
	local ply = self.Controller.Player
	for i, v in ipairs( player.FindInSphere( self.Position, self.Radius ) ) do
		if v:SCPTeam() != TEAM_SCP or !v:GetSCPChase() or hook.Run( "SLCChase", ply, v ) then continue end

		if !tab[v] then
			tab[v] = {
				start_time = ct,
				start_area_id = self.UID,
				is_active = false,
			}
		end

		local last_id = tab[v].last_area_id
		if !last_id or self.UID > last_id then
			tab[v].prev_area_id = last_id
			tab[v].last_area_id = self.UID
			tab[v].last_area_dietime = self.DieTime
		end
	end
end

function ChaseArea:SetRadius( rad )
	self.Radius = rad
end

function ChaseArea:SetPos( pos )
	self.Position = pos
end

function ChaseArea:SetDieTime( dt )
	self.DieTime = dt
end

setmetatable( ChaseArea, { __call = ChaseArea.New } )

--[[-------------------------------------------------------------------------
Chase Controller
---------------------------------------------------------------------------]]
local ChaseController = {}

function ChaseController:New( ply )
	local tab = {}
	
	tab.Player = ply
	tab.Areas = {}
	tab.ChasedBy = {}
	tab.NextThink = 0
	tab.AreaUIDs = 0
	
	return setmetatable( tab, { __index = ChaseController } )
end

function ChaseController:Think()
	local ct = CurTime()
	if self.NextThink > ct then return end
	self.NextThink = ct + 0.25

	local ply = self.Player
	local pos = ply:GetPos()

	if !self.LastArea or self.LastArea:DistToSqr( pos ) > self.LastAreaRadiusSqr and !ply:KeyDown( IN_DUCK ) then
		local area = ChaseArea( self )
		table.insert( self.Areas, 1, area )

		if #self.Areas == 9 then
			self.Areas[9] = nil
		end

		local sprint = ply:KeyDown( IN_SPEED )
		local radius = sprint and 320 or 160
		local time = sprint and 10 or 7.5

		area:SetPos( pos )
		area:SetRadius( radius )
		area:SetDieTime( ct + time )

		self.LastArea = pos
		self.LastAreaRadiusSqr = radius * radius
	end

	for i = #self.Areas, 1, -1 do
		if self.Areas[i]:Think() then
			table.remove( self.Areas, i )
		end
	end

	for chase_ply, chase_data in pairs( self.ChasedBy ) do
		if !IsValid( chase_ply ) or chase_data.last_area_dietime <= ct then
			self.ChasedBy[chase_ply] = nil
			continue
		end

		if !chase_data.is_active then
			chase_data.is_active = chase_data.last_area_id > chase_data.start_area_id
		end
	end
end

setmetatable( ChaseController, { __call = ChaseController.New } )

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:ChaseThink()
	if !self:Alive() then return end

	local t = self:SCPTeam()
	if t == TEAM_SPEC then return end

	if t != TEAM_SCP then
		local cont = self:GetProperty( "slc_chase_controller" )
		if !cont then
			cont = ChaseController( self )
			self:SetProperty( "slc_chase_controller", cont )
		end

		cont:Think()
	end
end

function PLAYER:InvalidateChase( forced )
	local isscp = self:SCPTeam() == TEAM_SCP
	
	if isscp and forced then
		for i, v in ipairs( self:GetChasedPlayers() ) do
			v:InvalidateChase()
		end
	end

	self:SetProperty( "slc_chase_data", nil )
	self:RemoveEffect( isscp and "scp_chase" or "human_chase" )
	self:SetChaseLevel( 0 )
	self:StopAmbient( "scp_chase" )
end

function PLAYER:IsChasedBy( other )
	local cont = self:GetProperty( "slc_chase_controller" )
	if !cont then return false end

	local data = cont.ChasedBy[other]
	if !data then return false end

	return data.is_active
end

function PLAYER:IsChasing( other )
	return other:IsChasedBy( self )
end

function PLAYER:GetChasedPlayers()
	local res = {}
	local ind = 0

	for _, ply in ipairs( player.GetAll() ) do
		if ply:IsChasedBy( self ) then
			ind = ind + 1
			res[ind] = ply
		end
	end

	return res, ind
end

--[[-------------------------------------------------------------------------
Chase Think
---------------------------------------------------------------------------]]
local next_chase_tick = 0
hook.Add( "Think", "SLCChaseThink", function()
	local ct = CurTime()

	if next_chase_tick > ct then return end
	next_chase_tick = ct + 0.5

	local ply_tab = {}

	for _, ply in ipairs( player.GetAll() ) do
		local cont = ply:GetProperty( "slc_chase_controller" )
		if !cont then continue end

		for chase_ply, chase_data in pairs( cont.ChasedBy ) do
			if !chase_data.is_active then continue end

			ply_tab[ply] = true
			ply_tab[chase_ply] = true
		end
	end

	for _, ply in ipairs( player.GetAll() ) do
		local data = ply:GetProperty( "slc_chase_data" )
		if !data and !ply_tab[ply] then continue end

		local isscp = ply:SCPTeam() == TEAM_SCP

		if ply_tab[ply] then
			if !data then
				data = {
					increase = 0,
					level = 0,
					scp = isscp
				}

				ply:SetProperty( "slc_chase_data", data )
				ply:PlayAmbient( "scp_chase", true, true, function( pl )
					return !pl:GetProperty( "slc_chase_data" )
				end )
			end

			data.finish = ct + 5

			if data.increase < ct then
				data.increase = ct + 20
				data.level = data.level + 1

				ply:ApplyEffect( isscp and "scp_chase" or "human_chase" )
				ply:SetChaseLevel( data.level )
			end
		elseif data.finish < ct then
			ply:InvalidateChase( false )
		end
	end
end )