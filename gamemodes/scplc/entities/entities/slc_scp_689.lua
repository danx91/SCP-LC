AddCSLuaFile()

ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", "Sigma" )
end

function ENT:Initialize()
	self:SetModel( "models/slusher/scp689/scp689.mdl" )
	
	if CLIENT then return end

	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:DropToFloor()

	self:DoRandom()

	self.Targets = {}
end

local light_offset = Vector( 0, 0, 64 )

ENT.NextAttack = 0
function ENT:Think()
	local ct = CurTime()

	if CLIENT then
		if self:GetNoDraw() then return end

		local light = DynamicLight( self:EntIndex(), false )
		if !light then return end

		light.pos = self:GetPos() + light_offset
		light.decay = 1000
		light.dietime = ct + 1

		if self:GetSigma() then
			local color = HSVToColor( ct * 120 % 360, 1, 1 )
			light.r = color.r
			light.g = color.g
			light.b = color.b

			light.brightness = 3
			light.size = 512
		else
			light.r = 0
			light.g = 255
			light.b = 0

			light.brightness = 1
			light.size = 256
		end
		
		return
	end

	self:CheckTargets()

	if self.NextAttack >= 0 then
		local pos = self:GetPos()

		for i, v in ipairs( SCPTeams.GetPlayersByInfo( SCPTeams.INFO_HUMAN ) ) do
			if !self:CanTarget( v ) or !self:TestVisibility( v, nil, false, 44, 58, 0 ) and v:GetPos():Distance2DSqr( pos ) > 900 then continue end
			if !self.Targets[v] and v:GetSCP714() then continue end

			if self.NextAttack < ct + 3 then
				self.NextAttack = ct + 3
			end

			if !self.Targets[v] then
				self.Targets[v] = v:TimeSignature()
				TransmitSound( "scp_lc/scp/689/spotted.ogg", true, v )
			end
		end
	end

	if self.NextAttack > 0 and self.NextAttack <= ct then
		local _, num = self:GetTargets()
		if num == 0 then
			self.NextAttack = 0
			return
		end

		self.NextAttack = -1
		self:SetNoDraw( true )

		self:SetSigma( false )
		self:StopSound( "SLC.SCP689.Sigma" )
		
		AddTimer( "SCP689Attack"..self:EntIndex(), SLCRandom( 15, 90 ), 1, function()
			self:DoAttack()
		end )
	end

	self:NextThink( ct + 0.5 )
	return true
end

function ENT:OnRemove()
	self:StopSound( "SLC.SCP689.Sigma" )
end

function ENT:CanTarget( ply )
	local t = ply:SCPTeam()
	return t != TEAM_SPEC and !SCPTeams.IsAlly( TEAM_SCP, t )
end

function ENT:CheckTargets()
	local num = 0

	for k, v in pairs( self.Targets ) do
		if !IsValid( k ) or !k:CheckSignature( v ) then
			self.Targets[k] = nil
		else
			num = num + 1
		end
	end

	return num
end

function ENT:GetTargets()
	local plys = {}
	local num = 0

	for k, v in pairs( self.Targets ) do
		if !k:IsInZone( ZONE_FLAG_ANOMALY ) then
			num = num + 1
			plys[num] = k
		end
	end

	return plys, num
end

function ENT:DoAttack()
	self:SetNoDraw( false )
	self:CheckTargets()

	local plys, num = self:GetTargets()
	local target = plys[SLCRandom( num )]

	self.NextAttack = 0

	if !IsValid( target ) then return end

	self:SetPos( target:GetPos() )
	self:DropToFloor()

	self:DoRandom()

	local dmg = DamageInfo()
	dmg:SetDamage( target:Health() )
	dmg:SetDamageType( DMG_DIRECT )

	target:SkipNextSuicide()
	target:TakeDamageInfo( dmg )

	self.Targets = {}
end

function ENT:DoRandom()
	self:SetAngles( Angle( 0, SLCRandom( 0, 3 ) * 90, 0 ) )

	local sigma = SLCRandom( 100 ) == 69
	self:SetSigma( sigma )

	if sigma then
		self:EmitSound( "SLC.SCP689.Sigma" )
	else
		self:StopSound( "SLC.SCP689.Sigma" )
	end
end

function ENT:Draw()
	self:DrawModel()
end

sound.Add( {
	name = "SLC.SCP689.Sigma",
	volume = 0.1,
	level = 75,
	sound = "scp_lc/scp/689/sigma.wav",
	channel = CHAN_STATIC,
} )