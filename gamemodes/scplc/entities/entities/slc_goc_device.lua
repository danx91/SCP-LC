AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.Destroyed = false

function ENT:SetupDataTables()
	self:AddNetworkVar( "StartTime", "Float" )
	self:AddNetworkVar( "FinishTime", "Float" )

	self:AddNetworkVar( "Destroyed", "Bool" )
end

function ENT:Initialize()
	self:SetModel( "models/ruggedlaptopserver/ruggedlaptopserver.mdl" )

	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )

		local ct = CurTime()
		self:SetStartTime( ct )
		self:SetFinishTime( ct + CVAR.slc_time_goc_device:GetFloat() )
	end

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

ENT.NEffectTime = 0
function ENT:Think()
	if CLIENT then return end

	local ct = CurTime()
	if self:GetDestroyed() and self.NEffectTime <= ct then
		self.NEffectTime = ct + 0.5 + math.random() * 2

		local effect = EffectData()
	
		effect:SetOrigin( self:GetPos() + Vector( 0, 0, 5 ) )
		effect:SetNormal( Vector( 0, 0, 1 ) )
		effect:SetRadius( 1 )
		effect:SetMagnitude( 2 )
		effect:SetScale( 3 )
	
		util.Effect( "ElectricSpark", effect, false, true )
		self:EmitSound( "SLC.GOCDestroyed" )
	end

	if !self:GetDestroyed() and self:Finished() and !self.Detonated then
		self.Detonated = true

		ALLWarheads( CVAR.slc_time_goc_warheads:GetInt() )

		local pos = self:GetPos()
		local xp = CVAR.slc_xp_goc_device:GetInt()
		for k, v in pairs( SCPTeams.GetPlayersByTeam( TEAM_GOC ) ) do
			if v:GetPos():DistToSqr( pos ) > 1000000 then continue end
			
			v:AddXP( xp )
			PlayerMessage( "xp_goc_device$"..xp, v )
		end
	end
end

function ENT:OnTakeDamage( dmginfo )
	if self:GetDestroyed() or self:Finished() then return end
	
	local att = dmginfo:GetAttacker()
	if !IsValid( att ) or !att:IsPlayer() or SCPTeams.IsAlly( att:SCPTeam(), TEAM_GOC ) then return end

	self:SetDestroyed( true )

	local data = EffectData()
	data:SetOrigin( self:GetPos() )

	util.Effect( "ManhackSparks", data, true, true )

	att:AddFrags( 5 )
	PlayerMessage( "goc_device_destroyed$5", att )
end

/*function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end*/

function ENT:Finished()
	return CurTime() >= self:GetFinishTime()
end

if CLIENT then
	local color_white = Color( 255, 255, 255 )
	local goc_logo = Material( "slc/misc/goc_logo_256.png" )

	local glitch_data = util.GlitchData( 10, 4 )
	local glitch_mode = 0
	local glitch_time = 0

	function ENT:Draw()
		self:DrawModel()

		local ct = CurTime()

		local pos = self:GetPos()
		local ang = self:GetAngles()

		ang:RotateAroundAxis( ang:Forward(), 83 )
		pos = pos + Vector( 0, 0, 12.5 ) - ang:Up() * 6.7

		cam.Start3D2D( pos, ang, 0.07 )

			if self:GetDestroyed() then
				if glitch_time <= ct then
					glitch_time = ct + math.random() * 0.1 + 0.01

					glitch_mode = math.random( 0, 1 )
					glitch_data = util.GlitchData( math.random( 8, 16 ), 0.05 + math.random() * 0.05, 150 )
				end

				if math.random() < 0.33 then
					surface.SetDrawColor( 255, 255, 255 )
					surface.SetMaterial( goc_logo )
					//surface.DrawTexturedRect( -48, -48, 96, 96 )
					draw.Glitch( -48, -48, 96, 96, glitch_mode, glitch_data )
				end
			elseif self:Finished() then
				surface.SetDrawColor( 255, 255, 255 )
				surface.SetMaterial( goc_logo )
				surface.DrawTexturedRect( -32, -32, 64, 64 )
			else
				local st = self:GetStartTime()
				local ft = self:GetFinishTime()

				local pct = math.Clamp( ( ct - st ) / ( ft - st ), 0, 1 )

				local t = ft - ct
				if t < 0 then
					t = 0
				end

				draw.SimpleText( string.ToMinutesSeconds( t ), "SCPHUDBig", 0, -28, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( math.Round( pct * 100 ).."%", "SCPHUDSmall", 0, 44, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawOutlinedRect( -64, 8, 128, 18, 1 )
				surface.DrawRect( -64, 8, 128 * pct, 18, 1 )
			end

		cam.End3D2D()
	end
end

sound.Add{
	name = "SLC.GOCDestroyed",
	sound = { "ambient/energy/zap7.wav", "ambient/energy/zap8.wav", "ambient/energy/zap9.wav" },
	volume = 0.1,
	level = 70,
	pitch = 100,
	channel = CHAN_STATIC,
}