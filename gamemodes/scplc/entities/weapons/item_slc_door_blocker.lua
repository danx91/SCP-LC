SWEP.Base 		= "item_slc_base"
SWEP.Language 	= "DOOR_BLOCKER"

SWEP.WorldModel 		= "models/slc/emptool/w_emptool.mdl"
SWEP.ViewModel 			= "models/slc/emptool/c_emptool.mdl"
SWEP.UseHands 			= true
SWEP.ViewModelFOV		= 54

SWEP.HoldType			= "slam"
SWEP.Primary.Automatic 	= true

SWEP.HasBattery = true
SWEP.BatteryUsage = 0

SWEP.MaxBattery = 30
SWEP.MinBattery = 15
SWEP.MaxTime = 10
SWEP.MinTime = 2.5
SWEP.UseTime = 3

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/emptool.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.IdleTime = 0
SWEP.CloseTime = 0
SWEP.LastCD = 0
function SWEP:Think()
	if CLIENT then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	if self.IdleTime > 0 and self.IdleTime < ct then
		local seq = vm:LookupSequence( self.Idle )
		if seq != -1 then
			vm:SendViewModelMatchingSequence( seq )
			vm:SetPlaybackRate( 1 )

			self.IdleTime = 0
		end
	elseif self.CloseTime > 0 and self.CloseTime < ct then
		local seq, dur = vm:LookupSequence( "close" )
		if seq != -1 then
			local speed = 2

			vm:SendViewModelMatchingSequence( seq )
			vm:SetPlaybackRate( speed )

			self.Idle = "closeidle"
			self.IdleTime = ct + dur / speed
			self.CloseTime = 0
		end
	end
end

local button_mask = bit.bor( CONTENTS_GRATE, CONTENTS_MOVEABLE, CONTENTS_SOLID )
function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end

	local ct = CurTime()
	self:SetNextPrimaryFire( ct + 0.2 )

	local owner = self:GetOwner()
	local start = owner:GetShootPos()

	local tr = util.TraceHull( {
		start = start,
		endpos = start + owner:GetAimVector() * 60,
		filter = owner,
		mask = button_mask,
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )

	if !tr.Hit then return end

	local ent = tr.Entity
	if !IsValid( ent ) or ent:GetClass() != "func_button" then return end

	local vm = owner:GetViewModel()
	local seq, dur = vm:LookupSequence( "open" )
	local speed = 2

	if seq != -1 then
		vm:SendViewModelMatchingSequence( seq )
		vm:SetPlaybackRate( speed )

		self.Idle = "openidle"
		self.IdleTime = ct + dur / speed
		self.CloseTime = ct + dur / speed
	end

	if self:GetBattery() < self.MaxBattery then
		owner:EmitSound( "EMPTool.LowPower" )
		self:SetNextPrimaryFire( ct + 1 )
		return
	end

	self:SetNextPrimaryFire( ct + self.UseTime + 1 )
	self.CloseTime = ct + self.UseTime + 0.5

	owner:StartSLCTask( "door_blocker", self.UseTime, function( ply )
		return IsValid( self ) and owner:KeyDown( IN_ATTACK ) and owner:GetActiveWeapon() == self
	end, {
		name = "lang:WEAPONS.DOOR_BLOCKER.progress",
		c2 = Color( 215, 255, 45 )
	}, IN_ATTACK ):Finally( function()
		if !IsValid( self ) or !IsValid( ent ) then return end

		local ct2 = CurTime()
		self.CloseTime = ct2 + 0.5

		local f = math.Clamp( ( ct2 - ct ) / self.UseTime, 0, 1 )
		local battery = math.ceil( math.Map( f, 0, 1, self.MinBattery, self.MaxBattery ) )
		local time = math.Map( f * f, 0, 1, self.MinTime, self.MaxTime )

		self:SetNextPrimaryFire( ct2 + 1 )

		if self:GetBattery() < battery then
			self:EmitSound( "EMPTool.LowPower" )
			return
		end

		self:SetBattery( self:GetBattery() - battery )
		self:EmitSound( "EMPTool.Discharge" )

		local eff = EffectData()

		eff:SetOrigin( tr.HitPos )
		eff:SetNormal( tr.HitNormal )
		eff:SetMagnitude( 8 )
		eff:SetScale( 1 )
		eff:SetRadius( 16 )

		util.Effect( "cball_bounce", eff, true, true )

		eff:SetEntity( self )
		eff:SetAttachment( 1 )
		eff:SetStart( start )

		util.Effect( "tooltracer", eff, true, true )

		if ent.DoorLocked and ent.DoorLocked > ct2 then
			ent.DoorLocked = ent.DoorLocked + time
		else
			ent.DoorLocked = ct2 + time

			timer.Simple( 1.5, function()
				if !IsValid( self ) then return end
				self:MakeTesla( tr.HitPos, time - 1.5 )
			end )
		end
	end )
end

function SWEP:MakeTesla( pos, time )
	local tesla = ents.Create( "point_tesla" )
	tesla:SetPos( pos )
	tesla:SetKeyValue( "m_SoundName", "DoSpark" )
	tesla:SetKeyValue( "texture", "sprites/physbeam.vmt" )
	tesla:SetKeyValue( "m_Color", "175 175 255" )
	tesla:SetKeyValue( "m_flRadius", 25 )
	tesla:SetKeyValue( "beamcount_min", 10 )
	tesla:SetKeyValue( "beamcount_max", 15 )
	tesla:SetKeyValue( "thick_min", 4 )
	tesla:SetKeyValue( "thick_max", 6 )
	tesla:SetKeyValue( "lifetime_min", 0.3 )
	tesla:SetKeyValue( "lifetime_max", 0.4 )
	tesla:SetKeyValue( "interval_max", 1 )
	tesla:SetKeyValue( "interval_min", 3 )

	tesla:Spawn()
	tesla:Activate()
	tesla:Fire( "TurnOn", "", 0 )
	tesla:Fire( "DoSpark", "", 0 )

	timer.Simple( time, function()
		if !IsValid( tesla ) then return end
		tesla:Remove()
	end	)
end

if CLIENT then
	local color_ready = Color( 125, 225, 125 )
	local color_wait = Color( 225, 125, 125 )

	function SWEP:Deploy()
		self:CallBaseClass( "Deploy" )
	
		return true
	end	

	function SWEP:PrintCooldown()
		local time = self:GetNextPrimaryFire() - CurTime()
		self.LastCD = time

		local txt, color

		if time <= 0 then
			color = color_ready
			txt = self.Lang.ready
		else
			color = color_wait
			txt = self.Lang.wait.." "..math.ceil( time ).."s"
		end

		chat.AddText( self.Lang.skill..": ", color, txt )
	end
end

--[[-------------------------------------------------------------------------
Hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCUseOverride", "SLCDoorBlocker", function( ply, ent, data )
	if ent.DoorLocked and ent.DoorLocked >= CurTime() then
		return true, false
	end
end )

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
sound.Add( {
	name = "EMPTool.Discharge",
	volume = 0.75,
	level = 80,
	pitch = { 90, 110 },
	sound = {
		"weapons/stunstick/alyx_stunner1.wav",
		"weapons/stunstick/alyx_stunner2.wav",
	},
	channel = CHAN_WEAPON,
} )

sound.Add( {
	name = "EMPTool.LowPower",
	volume = 0.6,
	level = 75,
	pitch = { 90, 110 },
	sound = "weapons/physcannon/physcannon_tooheavy.wav",
	channel = CHAN_WEAPON,
} )