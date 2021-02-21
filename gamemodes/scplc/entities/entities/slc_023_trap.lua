AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:AddNetworkVar( "Idle", "Bool" )
	self:AddNetworkVar( "Endpos", "Vector" )

	self:SetIdle( true )
end

function ENT:Initialize()
	self:SetModel( "models/Novux/023/Novux_SCP-023.mdl" )

	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )
	end

	self:SetAutomaticFrameAdvance( true )

	self:SetPoseParameter( "move_x", 1 )
	self:SetPoseParameter( "move_y", 1 )

	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
end

ENT.NextAnim = 0
ENT.ActiveSequence = -1
function ENT:Think()
	local act, seq = self:GetActivity()

	if isstring( seq ) then
		seq = self:LookupSequence( seq )
	end

	if !isnumber( seq ) then
		seq = -1
	end

	if seq < 0 then
		if act and act != ACT_INVALID then
			seq = self:SelectWeightedSequence( act )
		end
	end

	if seq > -1 and ( self.NextAnim < CurTime() or seq != self.ActiveSequence ) then
		self.ActiveSequence = seq

		local dur = self:SequenceDuration( seq )
		self.NextAnim = CurTime() + dur

		self:ResetSequence( seq )
	end

	if SERVER then
		/*for i = 1, #self.Points do
			debugoverlay.Cross( self.Points[i], 5, 0.5, Color(255, 255, 255), true )
		end*/

		local pos = self:GetPos()

		if self:GetIdle() then
			for k, v in pairs( player.GetAll() ) do
				if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
					for i = 1, #self.Points do
						local ppos = self.Points[i]
						if ppos:DistToSqr( v:GetPos() ) <= 490000 then
							local ep = v:EyePos()

							local pyaw = v:EyeAngles().yaw
							local tyaw = ( ep - ppos ):Angle().yaw

							if pyaw < 0 then pyaw = 360 + pyaw end
							if tyaw < 0 then tyaw = 360 + tyaw end

							local diff = pyaw - tyaw
							if diff < 0 then diff = 360 + diff end

							if math.abs( diff - 180 ) < 53 then
								local trace = util.TraceLine( {
									start = ep,
									endpos = ppos,
									mask = MASK_SOLID_BRUSHONLY
								} )

								if !trace.Hit then
									self:SetIdle( false )
									break
								end
							end
						end
					end
				end
			end
		else
			if IsValid( self.Creator ) then
				for k, v in pairs( player.GetAll() ) do
					if !self.Creator.PreysLookup[v] then
						if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
							if pos:DistToSqr( v:GetPos() ) <= 490000 and self:TestVisibility( v ) then
								self.Creator:AddPrey( v )
							end
						end
					end
				end
			end

			local newpos = pos + self:GetAngles():Forward() * 2

			if ( self.FinalPoint - newpos ):Length() <= 2.5 then
				self:Remove()
			else
				self:SetPos( newpos )
			end
		end
	end

	self:NextThink( CurTime() )
	return true
end

function ENT:GetActivity()
	if self:GetIdle() then
		return ACT_HL2MP_IDLE_CROUCH_FIST
	else
		self:SetPlaybackRate( 2 )
		return ACT_HL2MP_WALK
	end
end

function ENT:SetData( data, len, creator )
	local forward = self:GetAngles():Forward()
	local pos = self:GetPos()

	local upper = pos + Vector( 0, 0, 20 )
	local vp = upper + forward * len

	self.Points = { upper }
	local dl = #data
	for i = 1, dl do
		self.Points[i + 1] = vp + forward * len * data[i]
	end

	self.Creator = creator
	self.FinalPoint = pos + forward * ( len * ( dl + 1 ) + 50 )

	self:SetEndpos( self.FinalPoint )
end

function ENT:DrawTranslucent()
	local ply = LocalPlayer()
	local pos = self:GetPos()

	local a = 1
	if ply:SCPTeam() != TEAM_SCP then
		local dist = pos:Distance( ply:GetPos() )

		if dist > 700 then
			return
		end

		local f = ( 670 - dist ) / 30
		if f > 0 then f = 0 end
		a = f + 1
	end

	local ep = self:GetEndpos()
	if ep then
		local dist = pos:Distance( ep ) - 10
		if dist < 0 then
			dist = 0
		end

		if dist < 40 then
			a = a * dist / 40
		end
	end

	self:SetColor( Color( 0, 0, 0, 178 + 77 * a ) )
	self:DrawModel()
end