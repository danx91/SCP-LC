SWEP.Base 					= "item_slc_base"

SWEP.WorldModel				= "models/weapons/alski/items/w_syringe.mdl"
SWEP.ViewModel				= "models/weapons/alski/items/syringe.mdl"
SWEP.UseHands 				= true

SWEP.Group					= "syringe"

SWEP.Color 					= Vector( 0.8, 0.2, 0.2 )
SWEP.InjectSpeed			= 1
SWEP.SelfInjectSpeed		= 1

local liquid_material 		= Material( "models/weapons/alski/items/liquid.vmt" )

function SWEP:Deploy()
	self.PreventDropping = false
end

function SWEP:Holster()
	return !self.PreventDropping
end

function SWEP:OnDrop()
	self.PreventDropping = false
end

function SWEP:PrimaryAttack()
	if ROUND.post or self.PreventDropping then return end

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	if self:CanUseOn( owner, owner ) != true then return end

	local vm = owner:GetViewModel()
	if !IsValid( vm ) then return end

	local seq, dur = vm:LookupSequence( "self_injection" )
	if seq == -1 then return end

	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( self.SelfInjectSpeed )

	self.PreventDropping = true

	timer.Simple( dur / self.SelfInjectSpeed, function()
		if !IsValid( self ) or !IsValid( owner ) or owner != self:GetOwner() then return end
		
		self:UsedOn( owner, owner )

		if CLIENT then return end
		self:Remove()
	end )
end

local syringe_trace = {}
syringe_trace.mins = Vector( -2.5, -2.5, -2.5 )
syringe_trace.maxs = Vector( 2.5, 2.5, 2.5 )
syringe_trace.mask = MASK_SOLID
syringe_trace.output = syringe_trace

function SWEP:SecondaryAttack()
	if ROUND.post or self.PreventDropping then return end

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local start = owner:GetShootPos()
	syringe_trace.start = start
	syringe_trace.endpos = start + owner:GetAimVector() * 60
	syringe_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceLine( syringe_trace )

	if !syringe_trace.Hit then
		util.TraceHull( syringe_trace )
	end
	owner:LagCompensation( false )

	if !syringe_trace.Hit then return end

	local other = syringe_trace.Entity
	if !IsValid( other ) or !other:IsPlayer() then return end

	if self:CanUseOn( other, owner ) != true then return end

	local vm = owner:GetViewModel()
	if !IsValid( vm ) then return end

	local seq, dur = vm:LookupSequence( "injecting_someone" )
	if seq == -1 then return end

	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( self.InjectSpeed )

	self.PreventDropping = true

	timer.Simple( dur / self.InjectSpeed, function()
		if !IsValid( self ) or !IsValid( owner ) or !IsValid( other ) or owner != self:GetOwner() then return end
		
		self.PreventDropping = false

		if owner:GetPos():DistToSqr( other:GetPos() ) > 4900 then return end

		self:UsedOn( other, owner )

		if CLIENT then return end
		self:Remove()
	end )
end

function SWEP:CanUseOn( target, owner )
	return true
end

function SWEP:UsedOn( target, owner )
	
end

function SWEP:UpdateColor()
	liquid_material:SetVector( "$color2", self.Color )
end

function SWEP:PreDrawViewModel( vm, ply, wep )
	self:UpdateColor()
end

function SWEP:DrawWorldModel()
	if IsValid( self:GetOwner() ) then return end

	self:UpdateColor()
	self:DrawModel()
end