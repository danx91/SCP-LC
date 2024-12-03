SWEP.Base 		= "item_slc_holster"
SWEP.Language 	= "CLOTHES_CHANGER"

SWEP.Cooldown = 240
SWEP.IDDuration = 180

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "IDTime", "Float" )
end

function SWEP:PrimaryAttack()
	if ROUND.preparing or ROUND.post then return end

	local owner = self:GetOwner()
	if owner:GetVest() > 0 then
		if CLIENT then
			chat.AddText( self.Lang.vest )
		end

		return
	end

	if CLIENT then return end
	
	local start = owner:GetShootPos()

	local tr = util.TraceLine( {
		start = start,
		endpos = start + owner:GetAimVector() * 80,
		filter = owner,
		mask = MASK_SOLID,
	} )

	if !tr.Hit then return end

	local ent = tr.Entity
	if !IsValid( ent ) or ent:GetClass() != "prop_ragdoll" or !ent.Data or !ent.Data.team or ent.Data.team == TEAM_SCP then return end

	owner:StartSLCTask( "clothes_changer", 10, function( ply )
		return IsValid( self ) and owner:KeyDown( IN_ATTACK )
	end, {
		name = "lang:WEAPONS.CLOTHES_CHANGER.progress",
		c2 = Color( 215, 255, 45 )
	}, bit.bor( IN_ATTACK, CAMERA_MASK ) ):Then( function()
		if !IsValid( ent ) then return end

		self:SetNextPrimaryFire( CurTime() + self.Cooldown )
		owner:FullSwapModels( ent )

		if !ent.Data or !ent.Data.team or !ent.Data.class or ent.Data.id_stolen then
			PlayerMessage( "tailor_fail", owner )
			return
		end

		ent.Data.id_stolen = true

		self:SetIDTime( CurTime() + self.IDDuration )
		owner:Set_SCPPersonaC( ent.Data.class )
		owner:Set_SCPPersonaT( ent.Data.team )
		PlayerMessage( "tailor_success", owner )

		owner:AddTimer( "TailorPersona", self.IDDuration, 1, function()
			self:SetIDTime( 0 )
			owner:Set_SCPPersonaC( owner:SCPClass() )
			owner:Set_SCPPersonaT( owner:SCPTeam() )
			PlayerMessage( "tailor_end", owner )
	end )
	end )
end

if CLIENT then
	SWEP.LastCD = 0

	local color_ready = Color( 125, 225, 125 )
	local color_wait = Color( 225, 125, 125 )

	function SWEP:Deploy()
		self:CallBaseClass( "Deploy" )
		self:PrintCooldown()

		return true
	end

	function SWEP:Think()
		local time = self:GetNextPrimaryFire() - CurTime()
		if self.LastCD > 0 and time <= 0 or self.LastCD <= 0 and time > 0 then
			self:PrintCooldown()
		end
	end

	function SWEP:PrintCooldown()
		if !IsFirstTimePredicted() then return end

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

		local time_id = self:GetIDTime() - CurTime()
		if time_id <= 0 then return end

		chat.AddText( self.Lang.id_time..": ", color_ready, math.ceil( time_id ).."s" )
	end
end