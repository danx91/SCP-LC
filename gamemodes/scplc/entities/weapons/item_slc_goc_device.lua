SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "GOCDEVICE"

SWEP.WorldModel		= "models/ruggedlaptopserver/ruggedlaptopserver.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

SWEP.DrawCrosshair = false

SWEP.DespawnDrop = true
SWEP.PlaceTime = 10

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/misc/goc_logo_256.png" )
	SWEP.SelectColor = Color( 255, 255, 255, 255 )
end

function SWEP:Think()
	local owner = self:GetOwner()
	if !IsValid( owner ) or owner:SCPTeam() != TEAM_GOC then return end

	local status = owner:UpdateHold( "gocdevice_place", self )

	if status == true then
		if SERVER then
			local device = ents.Create( "slc_goc_device" )
			if IsValid( device ) then
				device:SetPos( self.LastPos )
				device:SetAngles( self.LastAng )
				device:Spawn()
			end

			local holster = owner:GetWeapon( "item_slc_holster" )
			if IsValid( holster ) then
				owner:SetActiveWeapon( holster )
			end
			
			self:Remove()
		elseif IsValid( self.Indicator ) then
			self.Indicator:Remove()
		end
	elseif status == false then
		if SERVER then
			owner:EnableProgressBar( false )
		end
	else
		local valid, pos, ang = self:TestIndicator()

		if owner:IsHolding( "gocdevice_place", self ) then
			if !valid then
				owner:InterruptHold( "gocdevice_place", self )
			end
		else
			self.LastPos = pos
			self.LastAng = ang

			if CLIENT and IsValid( self.Indicator ) then
				self.Indicator:SetColor( valid and Color( 0, 255, 0, 50 ) or Color( 255, 0, 0, 50 ) )
				self.Indicator:SetPos( pos )
				self.Indicator:SetAngles( ang )
			end
		end
	end

	if SERVER then return end

	if !IsValid( self.Indicator ) then
		self.Indicator = CreateIndicator( self.WorldModel, false, nil, nil, function()
			local wep = LocalPlayer():GetActiveWeapon()
			return !IsValid( wep ) or wep:GetClass() != "item_slc_goc_device"
		end )
	end
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if owner:IsHolding( "gocdevice_place", self ) or owner:SCPTeam() != TEAM_GOC then return end
	if !self:TestIndicator() then return end
	
	owner:StartHold( "gocdevice_place", IN_ATTACK, self.PlaceTime, nil, self )

	if SERVER then
		owner:EnableProgressBar( true, CurTime() + self.PlaceTime, "lang:WEAPONS.GOCDEVICE.placing", Color( 200, 200, 200, 255 ), Color( 50, 225, 25, 255 ) )
	end
end

function SWEP:TestIndicator()
	local owner = self:GetOwner()

	local sp = owner:GetShootPos()
	local tr = util.TraceLine {
		start = sp,
		endpos = sp + owner:GetAimVector() * 100,
		filter = owner,
		mask = MASK_SOLID,
	}

	local valid = false
	local pos = tr.HitPos

	if tr.Hit and pos:WithinAABox( GOC_DEVICE_BOUNDS[1], GOC_DEVICE_BOUNDS[2] ) then
		local tr2 = util.TraceHull {
			start = pos,
			endpos = pos,
			mins = Vector( -12, -12, 0 ),
			maxs = Vector( 12, 12, 16 ),
			filter = owner,
			mask = MASK_SOLID,
		}

		if !tr2.Hit then
			valid = true
		end
	end

	return valid, pos, Angle( 0, (owner:GetPos() - pos):Angle().y + 90, 0 )
end

function SWEP:CanPickUp( ply )
	if ply:SCPTeam() != TEAM_GOC then
		return false, "goc_only"
	end
end

hook.Add( "StartCommand", "SLCGOCDeviceCMD", function( ply, cmd )
	local wep = ply:GetWeapon( "item_slc_goc_device" )
	if IsValid( wep ) then
		if ply:IsHolding( "gocdevice_place", wep ) then
			cmd:ClearMovement()

			if !wep.ViewAngles then wep.ViewAngles = cmd:GetViewAngles() end
			cmd:SetViewAngles( wep.ViewAngles )
		elseif wep.ViewAngles then
			wep.ViewAngles = nil
		end
	end
end )