local ply = FindMetaTable( "Player" )

function ply:SetupSpectator()
	self:SetSCPTeam( TEAM_SPEC )
	self:SetSCPClass( "spectator" )

	self:CrosshairEnable()

	//local plys = SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN )
	local plys = self:GetValidSpectateTargets()

	if #plys < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
	else
		self:Spectate( OBS_MODE_CHASE )
		--print( self, "Setup spectate", plys[1] )
		self:SpectateEntity( plys[1] )
	end
end

function ply:SpectatePlayerNext()
	if self:SCPTeam() != TEAM_SPEC then return end
	if self.DeathScreen or self.SetupAsSpectator then return end

	//local plys = SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN )
	local plys = self:GetValidSpectateTargets()
	if self:GetObserverMode() == OBS_MODE_ROAMING then
		if #plys > 0 then
			self:Spectate( OBS_MODE_CHASE )
		else
			return
		end
	end

	if #plys < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		--print( "PlyNext - foce roam", self )
		return
	end

	local cur_target = self:GetObserverTarget()
	local index

	if !IsValid( cur_target ) then
		index = 1
	else
		for i, v in ipairs( plys ) do
			if v == cur_target then
				index = i + 1
				break
			end
		end
	end

	if !index then index = 1 end

	if index > #plys then
		index = 1
	end

	local target = plys[index]

	if target != cur_target then
		--print( self, "PlyNext - new", target )
		self:SpectateEntity( target )
	end
end

function ply:SpectatePlayerPrev()
	if self:SCPTeam() != TEAM_SPEC then return end
	if self.DeathScreen or self.SetupAsSpectator then return end

	//local plys = SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN )
	local plys = self:GetValidSpectateTargets()

	if self:GetObserverMode() == OBS_MODE_ROAMING then
		if #plys > 0 then
			self:Spectate( OBS_MODE_CHASE )
		else
			return
		end
	end

	if #plys < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		--print( "PlyPrev - foce roam", self )
		return
	end

	local cur_target = self:GetObserverTarget()
	local index

	if !IsValid( cur_target ) then
		index = 1
	else
		for i, v in ipairs( plys ) do
			if v == cur_target then
				index = i - 1
				break
			end
		end
	end

	if !index then index = 1 end

	if index < 1 then
		index = #plys
	end

	local target = plys[index]

	if target != cur_target then
		--print( self, "PlyPrev - new", target )
		self:SpectateEntity( target )
	end
end

function ply:ChangeSpectateMode()
	if self:SCPTeam() != TEAM_SPEC then return end
	if self.DeathScreen or self.SetupAsSpectator then return end
	
	local cur_mode = self:GetObserverMode()

	//if #SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN ) < 1 then
	if #self:GetValidSpectateTargets() < 1 then
		if cur_mode != OBS_MODE_ROAMING then
			--print( "SpecMode - foce roam", self )
			self:UnSpectate()
			self:Spectate( OBS_MODE_ROAMING )
		end

		return
	end

	if cur_mode == OBS_MODE_ROAMING then
		self:Spectate( OBS_MODE_CHASE )
		self:SpectatePlayerNext()
	elseif cur_mode == OBS_MODE_IN_EYE then
		self:Spectate( OBS_MODE_CHASE )
	elseif cur_mode == OBS_MODE_CHASE then
		--self:Spectate( OBS_MODE_IN_EYE )
	end

	--print( "change spec mode", self )
end

function ply:GetValidSpectateTargets()
	local info = SCPTeams.INFO_HUMAN

	if CVAR.spectatescp:GetBool() == true or hook.Run( "SLCCanSpectateSCP", self ) == true then
		info = SCPTeams.INFO_ALIVE
	end

	return SCPTeams.getPlayersByInfo( info )
end

function ply:InvalidatePlayerForSpectate()
	//local roam = #SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN ) < 1
	local roam = #self:GetValidSpectateTargets() < 1
	--print( "ivalidate", self, roam )

	for k, v in pairs( SCPTeams.getPlayersByTeam( TEAM_SPEC ) ) do
		if v != self then
			if v:GetObserverTarget() == self then
				if roam then
					v:UnSpectate()
					v:Spectate( OBS_MODE_ROAMING )
				else
					v:SpectatePlayerNext()
				end
			end
		end
	end
end