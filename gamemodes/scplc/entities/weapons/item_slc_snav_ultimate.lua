SWEP.Base 			= "item_slc_snav"
SWEP.Language 		= "SNAV_ULT"

SWEP.WorldModel		= "models/mishka/models/snav.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.DrawCrosshair = false

SWEP.Toggleable = true
SWEP.HasBattery = true

SWEP.Group = "SNAV"

SWEP.BatteryUsageRange = { 0.5, 6 }
SWEP.RadiusRange = { 400, 1200 }
SWEP.ScanTimeRange = { 0.666, 4 }

if CLIENT then
	//SWEP.WepSelectIcon = Material( "slc/items/radio.png" )
	//SWEP.SelectColor = Color( 255, 210, 0, 255 )
	SWEP.SelectFont = "SCPHUDMedium"
end

/*function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "NextScan", "Float" )
end*/

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	if SERVER then
		self.BatteryUsage = math.Rand( self.BatteryUsageRange[1], self.BatteryUsageRange[2] )
		self:SetRadius( math.random( self.RadiusRange[1], self.RadiusRange[2]) )
		self:SetScanTime( math.Rand( self.ScanTimeRange[1], self.ScanTimeRange[2] ) )
	end
end

SWEP.UpgradeID = 0
function SWEP:HandleUpgrade( mode, exit, ply )
	self:SetPos( exit )
	
	if self.PickupPriority then
		self.Dropped = CurTime()
		self.PickupPriorityTime = CurTime() + 10
	end

	if mode != UPGRADE_MODE.ONE_ONE then return end

	self.BatteryUsage = math.Rand( self.BatteryUsageRange[1], self.BatteryUsageRange[2] )
	self:SetRadius( math.random( self.RadiusRange[1], self.RadiusRange[2]) )
	self:SetScanTime( math.Rand( self.ScanTimeRange[1], self.ScanTimeRange[2] ) )
end

--[[-------------------------------------------------------------------------
Scanning
---------------------------------------------------------------------------]]
SWEP.ShowScanTime = 0

function SWEP:Scan()
	local owner = self:GetOwner()
	local pos = owner:GetPos()

	local radius = self:GetRadius() ^ 2
	local plys = {}

	for i, v in ipairs( player.GetAll() ) do
		local t = v:SCPTeam()
		if v == owner or t == TEAM_SPEC then continue end

		local v_pos = v:GetPos()
		if math.abs( pos.z - v_pos.z ) > 256 or pos:Distance2DSqr( v_pos ) > radius then continue end

		table.insert( plys, { t == TEAM_SCP and v:SCPClass(), v_pos } )
	end

	local num = #plys
	if num == 0 then return end

	net.Start( "SLCSNAVScan" )
	net.WriteUInt( num, 8 )

	for i, v in ipairs( plys ) do
		net.WriteBool( !!v[1] )
		if v[1] then
			net.WriteString( v[1] )
		end

		net.WriteFloat( v[2].x )
		net.WriteFloat( v[2].y )
	end

	net.Send( owner )
end

function SWEP:ReceiveScan()
	self.ShowScanTime = CurTime() + self:GetScanTime() + 1

	local tab = {}
	self.ShowScanData = tab

	for i = 1, net.ReadUInt( 8 ) do
		local scp

		if net.ReadBool() then
			scp = net.ReadString()
		end

		local pos = Vector( net.ReadFloat(), net.ReadFloat() )

		table.insert( tab, {
			scp and LANG.CLASSES[scp],
			pos
		} )
	end
end

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local color_scp = Color( 200, 0, 0, 255 )

function SWEP:DrawScan( x, y, w, h )
	if self.ShowScanTime < CurTime() then return end

	for i, v in ipairs( self.ShowScanData ) do
		local pos_x, pos_y = self:WorldToSNAV( v[2] )

		if v[1] then
			surface.SetDrawColor( 200, 0, 0 )
			draw.SimpleText( v[1], "SCPNumbersVSmall", x + pos_x, y + pos_y, color_scp, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		else
			surface.SetDrawColor( 0, 200, 0 )
		end

		surface.DrawRect( x + pos_x - 2, y + pos_y - 2, 4, 4 )
	end
end