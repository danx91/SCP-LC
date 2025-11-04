AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

ENT.Open = false
ENT.Time = 0
ENT.BreakTime = 0

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "Fuse" )
	self:NetworkVar( "Int", "Rating" )
end

function ENT:Initialize()
	self:SetModel( "models/slusher/fuzebox/fuzebox.mdl" )

	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	if self:GetFuse() == 0 then
		self:SetBodygroup( 1, 1 )
	end
end

ENT.NextEffect = 0
function ENT:Think()
	local ct = CurTime()

	if self.Time > 0 and self.BreakTime != 0 then
		if self.BreakTime < ct then
			hook.Run( "SLCFuseRemoved", self.BoxName )
			
			if self.NextEffect < ct then
				self.NextEffect = ct + SLCRandom( 4, 8 )

				self:EmitSound( "SLC.FuseBox.Disable" )

				local effect = EffectData()
				local ang = self:GetAngles()

				effect:SetOrigin( self:GetPos() + ang:Forward() * 4 + ang:Right() * ( SLCRandom() < 0.5 and -6.5 or 3.5 ) + ang:Up() * -3.5 )
				effect:SetNormal( ang:Forward() )
				effect:SetRadius( 1 )
				effect:SetMagnitude( 2 )
				effect:SetScale( 2.5 )

				util.Effect( "ElectricSpark", effect, false, true )
			end
		end
	end

	self:NextThink( ct )
	return true
end

function ENT:Use( activator, caller, use_type, value )
	if !activator:IsPlayer() then return end

	if !self.Open then
		self:ResetSequence( self:LookupSequence( "open" ) )
		self:ResetSequenceInfo()
		self.Open = true

		self:EmitSound( "SLC.FuseBox.Open" )
	else
		local fuse

		for k, v in pairs( activator:GetWeapons() ) do
			if v:IsGroup( "fuse" ) then
				fuse = v
				break
			end
		end

		local isscp = activator:SCPTeam() == TEAM_SCP and !activator:GetSCPHuman()
		local cf = self:GetFuse()

		if cf == 0 and fuse then
			if fuse:GetRating() >= self:GetRating() then
				self:InstallFuse( fuse )
			else
				PlayerMessage( "fuserating", activator, true )
			end
		elseif cf != 0 then
			if self.Time > 0 then
				PlayerMessage( self.BreakTime < CurTime() and "fusebroken" or "cantremfuse", activator, true )
			else
				self:RemoveFuse( activator, fuse or activator:GetFreeInventory() <= 0 or isscp )
			end
		elseif !isscp then
			PlayerMessage( "nofuse", activator, true )
		end
	end
end

function ENT:InstallFuse( ent )
	self:SetBodygroup( 1, 0 )
	self:SetFuse( ent:GetRating() )
	ent:Remove()

	if self.Time > 0 then
		self.BreakTime = CurTime() + self.Time
	end

	self:EmitSound( "SLC.FuseBox.Disable" )

	timer.Simple( 0.3, function()
		if !IsValid( self ) then return end
		self:EmitSound( "SLC.FuseBox.Enable" )
	end )

	local effect = EffectData()
	local ang = self:GetAngles()

	effect:SetOrigin( self:GetPos() + ang:Forward() * 4 + ang:Right() * ( SLCRandom() < 0.5 and -6.5 or 3.5 ) + ang:Up() * -3.5 )
	effect:SetNormal( ang:Forward() )
	effect:SetRadius( 1 )
	effect:SetMagnitude( 2 )
	effect:SetScale( 2.5 )

	util.Effect( "ElectricSpark", effect, false, true )

	hook.Run( "SLCFuseInstalled", self.BoxName )
end

function ENT:RemoveFuse( ply, drop )
	if drop then
		local ent = ents.Create( "item_slc_fuse" )
		if IsValid( ent ) then
			local ang = self:GetAngles()
			local forward = ang:Forward()

			ent:SetPos( self:GetPos() + forward * 8 )
			ent:SetRating( self:GetFuse() )
			ent:SetAngles( ang )
			ent:Spawn()

			ent.Dropped = 0

			local phys = ent:GetPhysicsObject()
			if IsValid( phys ) then
				phys:SetVelocity( forward * 150 )
			end
		end
	else
		local ent = ply:Give( "item_slc_fuse" )
		if IsValid( ent ) then
			ent:SetRating( self:GetFuse() )
		end
	end

	self:SetBodygroup( 1, 1 )
	self:SetFuse( 0 )

	self:EmitSound( "SLC.FuseBox.Disable" )

	local effect = EffectData()
	local ang = self:GetAngles()

	effect:SetOrigin( self:GetPos() + ang:Forward() * 4 + ang:Right() * ( SLCRandom() < 0.5 and -6.5 or 3.5 ) + ang:Up() * -3.5 )
	effect:SetNormal( ang:Forward() )
	effect:SetRadius( 1 )
	effect:SetMagnitude( 2 )
	effect:SetScale( 2.5 )

	util.Effect( "ElectricSpark", effect, false, true )

	hook.Run( "SLCFuseRemoved", self.BoxName )
end

local color_label = Color( 55, 55, 55 )
local label_offset = Vector( 0.75, -1.8, -3.2 )
function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	pos = pos + ang:Forward() * label_offset.x + ang:Right() * label_offset.y + ang:Up() * label_offset.z

	local right = -ang:Right()
	local cam_ang = right:AngleEx( right:Cross( ang:Up() ) )

	cam.Start3D2D( pos, cam_ang, 0.1 )
		draw.SimpleText( self:GetRating().."A", "SCPHUDSmall", 0, 0, color_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

sound.Add( {
	name = "SLC.FuseBox.Open",
	volume = 1,
	level = 75,
	sound = "doors/door_screen_move1.wav",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SLC.FuseBox.Enable",
	volume = 1,
	level = 80,
	sound = "buttons/button1.wav",
	channel = CHAN_STATIC,
} )

sound.Add( {
	name = "SLC.FuseBox.Disable",
	volume = 1,
	level = 80,
	sound = {
		"ambient/energy/zap1.wav",
		"ambient/energy/zap2.wav",
		"ambient/energy/zap3.wav",
	},
	channel = CHAN_STATIC,
} )