SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "SCP009"

SWEP.WorldModel		= "models/cultist/scp_items/009/w_scp_009.mdl"
SWEP.ViewModel		= "models/cultist/scp_items/009/v_scp009.mdl"

SWEP.SelectFont 	= "SCPHUDMedium"
SWEP.UseHands 		= true

SWEP.HoldType		= "grenade"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	local owner = self:GetOwner()

	if !self.PlayingIdle then
		self.PlayingIdle = true

		local vm = owner:GetViewModel()

		vm:SetCycle( 0 )
		vm:SetPlaybackRate( 1 )
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "molotov_idle" ) )
	end

	if CLIENT then return end
	if self.Thrown or !self.Throw or self.Throw > CurTime() then return end
	if owner:KeyDown( IN_ATTACK ) then return end
	
	self.Thrown = true
	self:SetNoDraw( true )

	local vm = owner:GetViewModel()
	local seq, dur = vm:LookupSequence( "molotov_throw" )
	vm:SendViewModelMatchingSequence( seq )
	
	timer.Simple( dur, function()
		if !IsValid( self ) then return end
		self:Remove()
	end )

	local ent = ents.Create( "slc_009_projectile" )
	if !IsValid( ent ) then return end

	ent:SetOwner( owner )
	ent:SetPos( owner:GetShootPos() )
	ent:SetAngles( owner:EyeAngles() )
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if !IsValid( phys ) then return end

	phys:SetVelocity( owner:GetAimVector() * 500 )
	phys:SetAngleVelocity( Vector( 100, 500, 100 ) )
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SetCycle( 0 )
	vm:SetPlaybackRate( 1 )
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "molotov_deploy" ) )
	self.PlayingIdle = false
end

function SWEP:OnDrop()
	self.Throw = false
	self.PreventDropping = false
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	local seq, dur = vm:LookupSequence( "molotov_pullpin" )
	vm:SendViewModelMatchingSequence( seq )

	self.Throw = CurTime() + dur
	self.PreventDropping = true
end

SWEP.BoneAttachment = "ValveBiped.Bip01_R_Hand"
SWEP.PosOffset = Vector( 4, -2, -1 )
SWEP.AngOffset = Angle( 180, 0, 0 )

function SWEP:DrawWorldModel()
	local owner = self:GetOwner()

	if IsValid( owner ) then
		local bone = owner:LookupBone( self.BoneAttachment )
		if bone then
			local matrix = owner:GetBoneMatrix( bone )
			if matrix then
				local pos, ang = LocalToWorld( self.PosOffset, self.AngOffset, matrix:GetTranslation(), matrix:GetAngles() )

				self:SetRenderOrigin( pos )
				self:SetRenderAngles( ang )
				self:SetupBones()

				self:DrawModel()
			end
		end
	else
		self:SetRenderOrigin()
		self:SetRenderAngles()
		self:SetupBones()

		self:DrawModel()
	end
end