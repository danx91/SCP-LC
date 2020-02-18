SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "CAMERA"

SWEP.WorldModel		= "models/props_junk/cardboard_box004a.mdl"

SWEP.NextChange 	= 0
SWEP.CCTV 			= {}

SWEP.ScanCD 		= 0
SWEP.CurScan 		= 0
SWEP.ScanEnd 		= 0

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Toggleable = true
SWEP.HasBattery = true
SWEP.BatteryUsage = 2

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "CAM", "Int" )
	self:SetCAM( 1 )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Holster()
	self:SetEnabled( false )

	return true
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

function SWEP:Think()
	self:CallBaseClass( "Think" )

	if #self.CCTV != #CCTV then
		for k, v in pairs( ents.FindByClass( "slc_cctv" ) ) do
			//print( v, v:GetCam() )
			self.CCTV[v:GetCam()] = v
		end
	end

	if self.CurScan + 0.2 < CurTime() then
		self.ScanEnd = 0
		self.CurScan = 0
	end
end

function SWEP:PrimaryAttack()
	if !SERVER then return end
	if self.NextChange > CurTime() then return end
	if self:GetBattery() <= 0 then return end

	self:SetEnabled( !self:GetEnabled() )
	self.NextChange = CurTime() + 0.5
end

function SWEP:SecondaryAttack()
	if !SERVER then return end
	if !self:GetEnabled() then return end
	if self.NextChange > CurTime() then return end

	local CAM = self:GetCAM() + 1

	if CAM > #CCTV then
		CAM = 1
	end

	self:SetCAM( CAM )
	self.NextChange = CurTime() + 0.1
end

function SWEP:Reload()
	if !self:GetEnabled() or !IsValid( self.CCTV[self:GetCAM()] ) then return end
	if self.ScanCD > CurTime() then return end
	self.ScanCD = CurTime() + 0.1

	if self.ScanEnd == 0 then 
		self.ScanEnd = CurTime() + 3
		self.CurScan = CurTime()
	else
		self.CurScan = CurTime()

		if self.CurScan > self.ScanEnd then
			self.ScanEnd = 0
			self.CurScan = 0
			self.ScanCD = CurTime() + 5

			if SERVER then
				self:Scan()
			end
		end
	end
end

function SWEP:Scan()
	local CAM = self:GetCAM()
	if !IsValid( self.CCTV[CAM] ) then return end

	local detected = {}

	local scps = SCPTeams.getPlayersByTeam( TEAM_SCP )
	//print( #scps )
	for k, v in pairs( scps ) do
		local tr = util.TraceLine{
			start = CCTV[CAM].pos - Vector( 0, 0, 10 ),
			endpos = v:GetPos() + v:OBBCenter(),
			mask = MASK_BLOCKLOS_AND_NPCS,
			filter = { v }
		}

		if !tr.Hit then
			table.insert( detected, v )
		end
	end

	local num = #detected
	if num > 0 then
		self.Owner:AddFrags( num )
		PlayerMessage( "detectscp$"..num, self.Owner )

		BroadcastDetection( self.Owner, detected )
	end
end

function SWEP:CalcView( ply, pos, ang, fov )
	if CCTV == nil then return end

	local CAM = self:GetCAM()
	if CCTV[CAM] == nil then return end
	if !IsValid( self.CCTV[CAM] ) then return end

	local dw = false

	if self:GetEnabled() then
		ang = CCTV[CAM].ang
		pos = CCTV[CAM].pos - Vector( 0, 0, 10 )
		fov = 90
		dw = true
	end

	return pos, ang, fov, dw
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

function SWEP:DrawHUD()
	if self:GetEnabled() then
		DisableHUDNextFrame()

		local CAM = self:GetCAM()
		local w, h = ScrW(), ScrH()

		if !IsValid( self.CCTV[CAM] ) then
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawRect( 0, 0, w, h )

			draw.Text( {
				text = "NO SIGNAL",
				font = "SCPHUDBig",
				pos = { w * 0.5, h * 0.5 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )

			draw.Text( {
				text = "CAM "..CAM,
				font = "SCPHUDBig",
				pos = { w * 0.5, 50 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )

			draw.Text( {
				text = CCTV[CAM].name,
				font = "SCPHUDBig",
				pos = { w * 0.5, 100 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )

			return
		end

		--if blinkHUDTime < GetConVar("br_time_blinkdelay"):GetFloat() then
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

			draw.Text( {
				text = "CAM "..CAM,
				font = "SCPHUDBig",
				pos = { w * 0.5, 50 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )

			draw.Text( {
				text = CCTV[CAM].name,
				font = "SCPHUDBig",
				pos = { w * 0.5, 100 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )

			for i = 1, 10 do
				local ry = math.random( h )
				local h = math.random( 1, 5 )
				local c = math.random( 100, 200 )
				local a = math.random( 0, 10 )

				surface.SetDrawColor( Color( c, c, c, a ) )
				surface.DrawRect( 0, ry, w, h )
			end
		--end

		if self.ScanEnd != 0 then
			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.DrawRing( w * 0.5, h * 0.5, 40, 5, 360 - 360 * (self.ScanEnd - CurTime()) / 3, 30 )

			draw.Text( {
				text = "SCANNING",
				font = "SCPHUDBig",
				color = Color( 255, 255, 255, math.TimedSinWave( 0.8, 1, 255 ) ),
				pos = { w * 0.5, h * 0.5 + 55 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )
		end

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawOutlinedRect( w * 0.875, h * 0.025, w * 0.09, h * 0.05 )
		surface.DrawRect( w * 0.87, h * 0.035, w * 0.005, h * 0.03 )

		local battery = self:GetBattery()

		if battery > 0 then
			local pct = battery * 0.01

			surface.SetDrawColor( Color( 175 * ( 1 - pct ), 175 * pct, 0, 255 ) )
			//surface.DrawRect( w * 0.878, h * 0.029, w * 0.084 * pct, h * 0.043 )
			surface.DrawRect( w * 0.875 + 4, h * 0.025 + 4, (w * 0.09 - 8) * pct, h * 0.05 - 8 )

			if battery < 15 then
				surface.SetDrawColor( Color( 255, 0, 0, math.TimedSinWave( 0.5, 0, 255 ) ) )
				surface.DrawLine( w * 0.88, h * 0.09, w * 0.96, h * 0.01 )
			end
		end
	end
end