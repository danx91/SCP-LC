AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

ENT.Open = false
ENT.Rating = 5

function ENT:SetupDataTables()
	self:AddNetworkVar( "Fuse", "Int" )
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

function ENT:Think()
	self:NextThink( CurTime() )
	return true
end

//ENT.NextUse = 0
function ENT:Use( activator, caller, use_type, value )
	/*local ct = CurTime()
	if self.NextUse > ct then return end
	self.NextUse = ct + 1*/

	if !activator:IsPlayer() then return end

	if !self.Open then
		self:ResetSequence( self:LookupSequence( "open" ) )
		self:ResetSequenceInfo()
		self.Open = true

		self:EmitSound( "SLC.FuseBox.Open" )
	else
		local fuse
		local num = 0

		for k, v in pairs( activator:GetWeapons() ) do
			num = num + 1

			if v.Group == "fuse" then
				fuse = v
			end
		end

		local isscp = activator:SCPTeam() == TEAM_SCP and !activator:GetSCPHuman()
		local cf = self:GetFuse()

		if cf == 0 and fuse then
			if fuse:GetRating() >= self.Rating then
				self:InstallFuse( fuse )
			else
				PlayerMessage( "fuserating", activator, true )
			end
		elseif cf != 0 then
			self:RemoveFuse( activator, fuse or num >= activator:GetInventorySize() or isscp )
		elseif !isscp then
			PlayerMessage( "nofuse", activator, true )
		end
	end
end

function ENT:InstallFuse( ent )
	self:SetBodygroup( 1, 0 )
	self:SetFuse( ent:GetRating() )
	ent:Remove()

	self:EmitSound( "SLC.FuseBox.Disable" )

	timer.Simple( 0.3, function()
		if !IsValid( self ) then return end
		self:EmitSound( "SLC.FuseBox.Enable" )
	end )

	local effect = EffectData()
	local ang = self:GetAngles()

	effect:SetOrigin( self:GetPos() + ang:Forward() * 4 + ang:Right() * (math.random() < 0.5 and -6.5 or 3.5) + ang:Up() * -3.5 )
	effect:SetNormal( ang:Forward() )
	effect:SetRadius( 1 )
	effect:SetMagnitude( 2 )
	effect:SetScale( 2.5 )

	util.Effect( "ElectricSpark", effect, false, true )
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

	effect:SetOrigin( self:GetPos() + ang:Forward() * 4 + ang:Right() * (math.random() < 0.5 and -6.5 or 3.5) + ang:Up() * -3.5 )
	effect:SetNormal( ang:Forward() )
	effect:SetRadius( 1 )
	effect:SetMagnitude( 2 )
	effect:SetScale( 2.5 )

	util.Effect( "ElectricSpark", effect, false, true )
end

function ENT:Draw()
	self:DrawModel()
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