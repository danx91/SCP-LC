SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "SNAV"

SWEP.WorldModel		= "models/mishka/models/snav.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.DrawCrosshair = false

SWEP.Toggleable = true
SWEP.HasBattery = true
SWEP.BatteryUsage = 6

SWEP.Group = "SNAV"

SWEP.Radius = 900
SWEP.ScanTime = 2

SWEP.SCP914Upgrade = "item_slc_snav_ultimate"

if CLIENT then
	//SWEP.WepSelectIcon = Material( "slc/items/radio.png" )
	//SWEP.SelectColor = Color( 255, 210, 0, 255 )
	SWEP.SelectFont = "SCPHUDMedium"
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Int", "Radius" )
	self:NetworkVar( "Float", "ScanTime" )
	self:NetworkVar( "Float", "NextScan" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	self:SetRadius( self.Radius )
	self:SetScanTime( self.ScanTime )
end

function SWEP:Think()
	self:BatteryTick()

	if CLIENT or !self:GetEnabled() then return end

	local ct = CurTime()
	local scan = self:GetNextScan()

	if scan > ct then return end
	self:SetNextScan( ct + self:GetScanTime() )

	self:Scan()
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

function SWEP:Holster( wep )
	self:SetEnabled( false )
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	if self:GetBattery() <= 0 then return end

	self:SetEnabled( !self:GetEnabled() )
end

function SWEP:SecondaryAttack()
	
end

--[[-------------------------------------------------------------------------
Scanning
---------------------------------------------------------------------------]]
SWEP.ShowScanTime = 0

function SWEP:Scan()
	local owner = self:GetOwner()
	local pos = owner:GetPos()

	local radius = ( self:GetRadius() * 0.9 ) ^ 2
	local scps = {}

	for i, v in ipairs( player.GetAll() ) do
		if v:SCPTeam() != TEAM_SCP then continue end

		local v_pos = v:GetPos()
		if math.abs( pos.z - v_pos.z ) > 256 then continue end

		local dist = pos:Distance2DSqr( v_pos )
		if dist > radius then continue end

		table.insert( scps, { v:SCPClass(), math.sqrt( dist ) } )
	end

	local num = #scps
	if num == 0 then return end

	net.Start( "SLCSNAVScan" )
	net.WriteUInt( num, 6 )

	for i, v in ipairs( scps ) do
		net.WriteString( v[1] )
		net.WriteUInt( v[2], 16 )
	end

	net.Send( owner )
end

function SWEP:ReceiveScan()
	self.ShowScanTime = CurTime() + self:GetScanTime() + 1

	local tab = {}
	self.ShowScanData = tab
	self.ShowScanOrigin = LocalPlayer():GetPos()

	for i = 1, net.ReadUInt( 6 ) do
		local scp = net.ReadString()
		local dist = net.ReadUInt( 16 )

		table.insert( tab, {
			LANG.CLASSES[scp] or scp,
			dist
		} )
	end
end

--[[-------------------------------------------------------------------------
Netowrking
---------------------------------------------------------------------------]]
if SERVER then
	util.AddNetworkString( "SLCSNAVScan" )
else
	net.Receive( "SLCSNAVScan", function( len )
		local wep = LocalPlayer():GetWeaponByGroup( "SNAV" )
		if !IsValid( wep ) then return end

		wep:ReceiveScan()
	end )
end

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
local color_black = Color( 0, 0, 0, 255 )
local snav_mat = Material( "slc/misc/snav.png", "smooth" )

local low_battery_mat = Material( "slc/items/snav/low_battery.png", "smooth" )
local battery_ratio = low_battery_mat:Width() / low_battery_mat:Height()

local no_signal_mat1 = Material( "slc/items/snav/no_signal_1.png", "smooth" )
local no_signal_mat2 = Material( "slc/items/snav/no_signal_2.png", "smooth" )
local signal_ratio = no_signal_mat1:Width() / no_signal_mat1:Height()

local tx_ratio = 434 / 509
local tx_screen_x = 74 / 434
local tx_screen_y = 44 / 509
local tx_screen_w = 286 / 434
local tx_screen_h = 261 / 509

local map_origin, map_size

local function setup_map()
	local map_mins, map_maxs = game.GetWorld():GetModelBounds()
	map_origin = ( map_mins + map_maxs ) / 2

	local map_diff = map_origin - map_mins
	map_size = math.max( map_diff.x, map_diff.y )
end

function SWEP:WorldToSNAV( vec )
	local h = ScrH()
	local draw_h = h * 0.5
	local draw_w = draw_h * tx_ratio
	local scr_w, scr_h = draw_w * tx_screen_w, draw_h * tx_screen_h

	local diff = ( LocalPlayer():GetPos() - vec ) / self:GetRadius() * 0.5
	return scr_w * 0.5 + diff.y * scr_h, ( 0.5 + diff.x ) * scr_h, 0
end

function SWEP:DistanceToSNAV( dist )
	return ScrH() * tx_screen_h * dist / self:GetRadius() * 0.25
end

function SWEP:DrawHUD()
	if hud_disabled then return end

	if !map_origin then
		setup_map()
	end

	local h = ScrH()
	local draw_h = h * 0.5
	local draw_w = draw_h * tx_ratio

	local draw_x, draw_y = ScrW() * 0.925 - draw_w, h - draw_h * 0.9

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( snav_mat )
	surface.DrawTexturedRect( draw_x, draw_y, draw_w, draw_h )

	local scr_x, scr_y = draw_x + draw_w * tx_screen_x, draw_y + draw_h * tx_screen_y
	local scr_w, scr_h = draw_w * tx_screen_w, draw_h * tx_screen_h

	if self:GetBattery() <= 0 then
		local bat_h = scr_h * 0.2

		if CurTime() % 2 < 1 then
			local bat_w = bat_h * battery_ratio

			surface.SetDrawColor( 0, 0, 0 )
			surface.SetMaterial( low_battery_mat )
			surface.DrawTexturedRect( scr_x + ( scr_w - bat_w ) * 0.5, scr_y + ( scr_h - bat_h ) * 0.5, bat_w, bat_h )
		end

		draw.SimpleText( self.Lang.low_battery, "SCPNumbersSmall", scr_x + scr_w * 0.5, scr_y + ( scr_h + bat_h ) * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

		return
	end

	if !self:GetEnabled() then return end

	local ply_pos = LocalPlayer():GetPos()
	local z_pos = ply_pos.z
	local layer

	for i, v in ipairs( SNAV ) do
		if z_pos > v.z then break end
		layer = v.material
	end

	if !layer then
		local signal_h = scr_h * 0.3
		local signal_w = signal_h * signal_ratio

		if CurTime() % 2 < 1 then
			surface.SetMaterial( no_signal_mat1 )
		else
			surface.SetMaterial( no_signal_mat2 )
		end

		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawTexturedRect( scr_x + ( scr_w - signal_w ) * 0.5, scr_y + ( scr_h - signal_h ) * 0.5, signal_w, signal_h )

		draw.SimpleText( self.Lang.no_signal, "SCPNumbersSmall", scr_x + scr_w * 0.5, scr_y + ( scr_h + signal_h ) * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

		return
	end

	local ct = CurTime()
	local scan = 1 - ( self:GetNextScan() - ct ) / self:GetScanTime()
	if scan > 0 then
		if scan > 1 then
			scan = 1
		end

		local tw = draw.TextSize( "#", "SCPNumbersVSmall" )
		local num = math.floor( scr_w / tw )
		local off = ( scr_w - num * tw ) / 2

		draw.SimpleText( string.rep( "#", math.Round( scan * num ) ), "SCPNumbersVSmall", scr_x + off, scr_y + scr_h, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	end

	local ply_pos_n = ( ply_pos - map_origin ) / map_size

	local map_s = scr_h * map_size / self:GetRadius()
	local map_x = scr_x + ( scr_w - map_s * ( 1 - ply_pos_n.y ) ) * 0.5
	local map_y = scr_y + ( scr_h - map_s * ( 1 - ply_pos_n.x ) ) * 0.5

	surface.SetDrawColor( 0, 0, 0 )
	surface.SetMaterial( layer )

	render.SetScissorRect( scr_x, scr_y, scr_x + scr_w, scr_y + scr_h, true )
		surface.DrawTexturedRect( map_x, map_y, map_s, map_s )
		surface.DrawRect( scr_x + scr_w / 2 - 2, scr_y + scr_h / 2 - 2, 4, 4 )

		self:DrawScan( scr_x, scr_y, scr_w, scr_h )
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function SWEP:DrawScan( x, y, w, h )
	if self.ShowScanTime < CurTime() then return end

	local orig_x, orig_y = self:WorldToSNAV( self.ShowScanOrigin )

	for i, v in ipairs( self.ShowScanData ) do
		local radius = self:DistanceToSNAV( v[2] )

		surface.DrawCircle( x + orig_x, y + orig_y, radius, 0, 0, 0 )
		draw.SimpleText( v[1], "SCPNumbersVSmall", x + orig_x, y + orig_y - radius, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	end
end