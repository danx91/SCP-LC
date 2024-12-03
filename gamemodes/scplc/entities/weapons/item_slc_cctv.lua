SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "CCTV"

SWEP.WorldModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.ViewModel 		= "models/slusher/tablet/c_tablet.mdl"
SWEP.ViewModelFOV 	= 50
SWEP.UseHands 		= true

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.SelectFont = "SCPHUDMedium"
SWEP.DrawCrosshair = false

SWEP.Secondary.Automatic = true

SWEP.UseGroup = "vision"
SWEP.Toggleable = true
SWEP.HasBattery = true
SWEP.CCTVCache = {}
SWEP.BatteryUsage = 3.6
SWEP.ScansPerPoint = 3
SWEP.ScanCooldown = 2

SWEP.TextLinesTime = 3.5
SWEP.TextLines = {
	"client_init();",
	"CCTV Client Initialized!",
	"connect();",
	"CCTV Connected on IP: 192.168.0.100",
	"ping_cctv();",
	"Pinging all CCTV Cameras..."
}

local STATE_DISABLED = 0
local STATE_LOADING = 1
local STATE_ACTIVE = 2

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Camera", "Int" )
	self:AddNetworkVar( "State", "Int" )

	self:SetCamera( 1 )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Holster()
	self:SetState( STATE_DISABLED )
	self:SetEnabled( false )

	self.ViewLerp = 0
	self.LoadingAlpha = 0
 	self.CCTVAlpha = 0

	 if CLIENT and self.ReloadDown then
		self.ReloadDown = false
		gui.EnableScreenClicker( false )
	end

	return true
end

function SWEP:OnDrop()
	self:SetState( STATE_DISABLED )
	self:SetEnabled( false )

	self.ViewLerp = 0
	self.LoadingAlpha = 0
 	self.CCTVAlpha = 0

	if CLIENT and self.ReloadDown then
		self.ReloadDown = false
		gui.EnableScreenClicker( false )
	end
end

function SWEP:OnRemove()
	if CLIENT and self.ReloadDown then
		self.ReloadDown = false
		gui.EnableScreenClicker( false )
	end
end

local cctv_rt, cctv_mat

if CLIENT then
	cctv_rt = GetRenderTarget( "slc_cctv_rt", 1600, 900 )
	cctv_mat = CreateMaterial( "slc_cctv_mat", "UnlitGeneric", {
		["$basetexture"] = cctv_rt:GetName(),
		["$vertexalpha"] = "1",
	} )
end

function SWEP:Think()
	self:BatteryTick()

	if #self.CCTVCache != #CCTV then
		for i, v in ipairs( ents.FindByClass( "slc_cctv" ) ) do
			if v.GetCameraID then
				self.CCTVCache[v:GetCameraID()] = v
			end
		end
	end

	local ct = CurTime()
	local state = self:GetState()
	local owner = self:GetOwner()

	if state != STATE_ACTIVE and owner:IsHolding( self, "cctv_scan" ) then
		owner:InterruptHold( self, "cctv_scan" )
	end

	local status = owner:UpdateHold( self, "cctv_scan" )
	if status == false then
		self:SetNextSecondaryFire( ct + 0.5 )
	elseif status then
		self:SetNextSecondaryFire( ct + self.ScanCooldown )
		self:Scan()
	end

	if state == STATE_LOADING and self:GetNextPrimaryFire() <= ct then
		self:SetState( STATE_ACTIVE )
	end

	if SERVER then return end

	if state == STATE_ACTIVE then
		local tab = CCTV[self:GetCamera()]
		if tab then
			owner.InCCTVRender = true
			render.PushRenderTarget( cctv_rt )

			render.Clear( 0, 0, 0, 255, true, true )
			render.RenderView( {
				origin = tab.pos,
				angles = tab.ang,
				x = 0,
				y = 0,
				fov = 100,
				w = cctv_rt:Width(),
				h = cctv_rt:Height(),
				drawviewmodel = false,
			} )

			render.PopRenderTarget()
			owner.InCCTVRender = false
		end
	end

	if self.ReloadDown and ( !owner:KeyDown( IN_RELOAD ) or state != STATE_ACTIVE ) then
		self.ReloadDown = false
		gui.EnableScreenClicker( false )
	end
end

hook.Add( "ShouldDrawLocalPlayer", "SLCCCTVRender", function( ply )
	if ply.InCCTVRender then return true end
end )

function SWEP:PrimaryAttack()
	if self:GetBattery() <= 0 or !self:CanEnable() or self:GetState() == STATE_LOADING then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "cctv_scan" ) then return end

	local enabled = self:GetEnabled()
	self:SetEnabled( !enabled )
	self:SetState( enabled and STATE_DISABLED or STATE_LOADING )

	local cd = CurTime() + ( enabled and 2 or self.TextLinesTime )
	self:SetNextPrimaryFire( cd )
	self:SetNextSecondaryFire( cd )

	self.NextTextLine = 0
	self.CurrentTextLine = 0
	self.TextLineScroll = 0
end

function SWEP:SecondaryAttack()
	if self:GetBattery() <= 0 or self:GetState() != STATE_ACTIVE then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "cctv_scan" ) then return end
	
	local ent = self.CCTVCache[self:GetCamera()]
	if !ent or !IsValid( ent ) then return end

	owner:StartHold( self, "cctv_scan", IN_ATTACK2, 1 )
	self:SetBattery( self:GetBattery() - 1 )
end

function SWEP:Reload()
	if SERVER or self:GetBattery() <= 0 or self:GetState() != STATE_ACTIVE or self.ReloadDown then return end

	local owner = self:GetOwner()
	if owner:IsHolding( self, "cctv_scan" ) then return end

	self.ReloadDown = true
	gui.EnableScreenClicker( true )
end

function SWEP:BatteryDepleted()
	self:SetState( STATE_DISABLED )

	local cd = CurTime() + 2
	self:SetNextPrimaryFire( cd )
	self:SetNextSecondaryFire( cd )
end

function SWEP:Scan()
	if CLIENT then return end

	local cctv = self:GetCamera()
	if !IsValid( self.CCTVCache[cctv] ) then return end

	local detected = {}

	for i, v in ipairs( SCPTeams.GetPlayersByTeam( TEAM_SCP ) ) do
		local tr = util.TraceLine{
			start = CCTV[cctv].pos - Vector( 0, 0, 10 ),
			endpos = v:GetPos() + v:OBBCenter(),
			mask = MASK_BLOCKLOS_AND_NPCS,
			filter = { v }
		}

		if !tr.Hit then
			table.insert( detected, v )
		end
	end

	local num = #detected
	self:SetBattery( self:GetBattery() - 2 * ( num + 1 ) )

	if num <= 0 then return end

	local owner = self:GetOwner()
	local scans = owner:GetProperty( "cctv_scans", 0 ) + num
	local points = math.floor( scans / self.ScansPerPoint )

	owner:SetProperty( "cctv_scans", scans % self.ScansPerPoint )

	BroadcastDetection( owner, detected )

	if points <= 0 then return end

	owner:AddFrags( points )
	PlayerMessage( "detectscp$"..points, owner )
end

function SWEP:DrawWorldModel()
	if IsValid( self:GetOwner() ) then return end
	self:DrawModel()
end

if SERVER then
	hook.Add( "SetupPlayerVisibility", "CCTVPVS", function( ply, viewentity )
		local wep = ply:GetActiveWeapon()
		if !IsValid( wep ) or wep:GetClass() != "item_slc_cctv" or !wep:GetEnabled() or wep:GetState() != STATE_ACTIVE then return end

		local tab = CCTV[wep:GetCamera()]
		if !tab or !IsValid( tab.ent ) then return end

		AddOriginToPVS( tab.pos )
	end )

	net.ReceivePing( "SLCCCTVChange", function( data, ply )
		local cctv = tonumber( data )
		if !cctv or cctv < 1 or cctv > #CCTV then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid( wep ) or wep:GetClass() != "item_slc_cctv" or !wep:GetEnabled() or wep:GetState() != STATE_ACTIVE then return end
		if ply:IsHolding( wep, "cctv_scan" ) then return end

		wep:SetCamera( cctv )
	end )
end

if SERVER then return end

local pos_idle = Vector( 10, 8, -8 )
local ang_idle = Angle( 0, -40, 0 )
local pos_active = Vector( -8, -3, -0.5 )
local ang_active = Angle( 0, 10, -2 )

SWEP.ViewLerp = 0

function SWEP:CalcViewModelView( vm, old_pos, old_ang, pos, ang )
	self.ViewLerp = math.Approach( self.ViewLerp, self:GetEnabled() and 1 or 0, FrameTime() / 2 )
	return LocalToWorld( LerpVector( self.ViewLerp, pos_idle, pos_active ), LerpAngle( self.ViewLerp, ang_idle, ang_active ), pos, ang )
end

local render_pos, render_ang, render_scale

function SWEP:ViewModelDrawn( vm )
	local bone = vm:LookupBone( "jp2" )
	if !bone then return end

	local matrix = vm:GetBoneMatrix( bone )
	if !matrix then return end

	local pos, ang = matrix:GetTranslation(), matrix:GetAngles()

	ang:RotateAroundAxis( ang:Forward(), -90 )
	ang:RotateAroundAxis( ang:Right(), -100.27 )
	ang:RotateAroundAxis( ang:Up(), 0 )

	pos = pos + ang:Forward() * -0.3 + ang:Right() * 0 + ang:Up() * 0.2

	render_pos = pos
	render_ang = ang
	render_scale = 0.0075

	cam.Start3D2D( render_pos, render_ang, render_scale )
		render.ClearStencil()
		render.SetStencilReferenceValue( 1 )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )

		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_REPLACE )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilCompareFunction( STENCIL_NEVER )

		render.SetStencilEnable( true )

		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawRect( -715, -450, 1430, 900 )

		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilCompareFunction( STENCIL_EQUAL )

		self:DrawScreen( -715, -450, 1430, 900 )

		render.SetStencilEnable( false )
	cam.End3D2D()
end

local logo = Material( "slc/misc/scp_logo_128.png", "smooth" )
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )

local scan_text_color = Color( 255, 255, 255, 255 )
local scan_start = 0
local scan_cd = 0

SWEP.LoadingAlpha = 0
SWEP.CCTVAlpha = 0

function SWEP:DrawScreen( x, y, w, h )
	local ct = CurTime()
	local state = self:GetState()

	self.CCTVAlpha = math.Approach( self.CCTVAlpha, state == STATE_ACTIVE and 1 or 0, FrameTime() / 0.5 )
	if self.CCTVAlpha > 0 then
		local old_alpha = surface.GetAlphaMultiplier()
		surface.SetAlphaMultiplier( self.CCTVAlpha )

		local cctv = self:GetCamera()
		local valid = IsValid( self.CCTVCache[cctv] )

		if valid then
			local mat_w = cctv_mat:Width()
			surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial( cctv_mat )
			surface.DrawTexturedRect( x + ( w - mat_w ) * 0.5, y, mat_w, h )
		else
			draw.SimpleText( self.Lang.no_signal, "SCPHUDMedium", x + w * 0.5, y + h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		local _, th = draw.OutlinedText( "CCTV #"..self:GetCamera(), "SCPHUDSmall", x + w * 0.5, y + 8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 3 )
		
		local tab = CCTV[cctv]
		if tab then
			draw.OutlinedText( tab.name, "SCPHUDMedium", x + w * 0.5, y + 8 + th, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 3 )
		end

		if state == STATE_DISABLED or self:DrawMap( x, y, w, h ) then
			surface.SetAlphaMultiplier( old_alpha )
			return
		end

		local map_btn = string.upper( input.LookupBinding( "+reload" ) ) or "+reload"

		if LANG.MISC.buttons[map_btn] then
			map_btn = LANG.MISC.buttons[map_btn]
		end

		local _, mth = draw.OutlinedText( string.format( self.Lang.map_info, map_btn ),
				"SCPHUDMedium", x + w * 0.5, y + h * 0.75, scan_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 3 )

		if !valid then
			surface.SetAlphaMultiplier( old_alpha )
			return
		end

		local owner = self:GetOwner()
		local cd = self:GetNextSecondaryFire() - ct
		
		if cd > 0 then
			if scan_start < ct - scan_cd then
				scan_start = ct
				scan_cd = cd
			end

			local _, cd_th = draw.OutlinedText( self.Lang.scan_cd, "SCPHUDMedium", x + w * 0.5, y + h * 0.75 + mth,
				scan_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 3 )

			local cd_w = w * 0.2
			local f = math.Clamp( 1 - ( cd / scan_cd ), 0, 1 )

			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( x + ( w - cd_w ) * 0.5, y + h * 0.75 + mth + cd_th * 0.5, cd_w, h * 0.02, 1 )
			surface.DrawRect( x + ( w - cd_w ) * 0.5, y + h * 0.75 + mth + cd_th * 0.5, cd_w * f, h * 0.02 )
		elseif owner:IsHolding( self, "cctv_scan" ) then
			scan_text_color.a = math.TimedSinWave( 1, 128, 255 )

			draw.OutlinedText( self.Lang.scanning, "SCPHUDBig", x + w * 0.5, y + h * 0.6, scan_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 3 )

			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawRing( x + w * 0.5, y + h * 0.5, h * 0.05, h * 0.01, 360, 48, owner:HoldProgress( self, "cctv_scan" ) or 0 )
		else
			scan_text_color.a = math.TimedSinWave( 0.5, 128, 255 )

			local btn = string.upper( input.LookupBinding( "+attack2" ) ) or "+attack2"

			if LANG.MISC.buttons[btn] then
				btn = LANG.MISC.buttons[btn]
			end

			draw.OutlinedText( string.format( self.Lang.scan_info, btn ),
				"SCPHUDMedium", x + w * 0.5, y + h * 0.75 + mth, scan_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 3 )
		end

		surface.SetAlphaMultiplier( old_alpha )
	end

	if state == STATE_DISABLED then return end

	self.LoadingAlpha = math.Approach( self.LoadingAlpha, state == STATE_LOADING and 1 or 0, FrameTime() / 0.5 )
	if self.LoadingAlpha <= 0 then return end

	local old_alpha = surface.GetAlphaMultiplier()
	surface.SetAlphaMultiplier( self.LoadingAlpha )

	surface.SetDrawColor( 0, 0, 0 )
	surface.DrawRect( x, y, w, h )

	local loading = self:GetNextPrimaryFire() - ct
	local time_per_line = ( self.TextLinesTime - 0.5 ) / ( #self.TextLines + #CCTV )
	local f = 1 - loading / self.TextLinesTime
	if f > 1 then
		f = 1
	end

	local logo_s = h * 0.2
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( logo )
	surface.DrawTexturedRect( x + ( w - logo_s ) * 0.5, y + h * 0.33, logo_s, logo_s )

	local loading_w = w * 0.35
	surface.DrawOutlinedRect( x + ( w - loading_w ) * 0.5, y + h * 0.55, loading_w, h * 0.03, 1 )
	surface.DrawRect( x + ( w - loading_w ) * 0.5, y + h * 0.55, loading_w * f, h * 0.03, 1 )

	if self.NextTextLine <= ct then
		self.NextTextLine = self.NextTextLine + time_per_line

		if self.NextTextLine < ct then
			self.NextTextLine = ct + time_per_line
		end

		self.CurrentTextLine = self.CurrentTextLine + 1
	end

	local tx = x + 8
	local ty = y + 8 - self.TextLineScroll
	local lines = #self.TextLines
	local cctvs = #self.CCTVCache

	for i = 1, self.CurrentTextLine do
		local text
		local cctv = i - lines

		if i <= lines then
			text = self.TextLines[i]
		elseif cctv <= cctvs then 
			text = "CCTV :: ping 192.168.0."..( 100 + cctv ).." :: "..( IsValid( self.CCTVCache[cctv] ) and "OK" or "ERROR" )
		elseif i == lines + cctvs + 1 then
			text = "Done!"
		else
			break
		end

		local _, th = draw.SimpleText( text, "SCPHUDSmall", tx, ty, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		ty = ty + th

		if ty > y + h then
			self.TextLineScroll = self.TextLineScroll + th
		end
	end

	surface.SetAlphaMultiplier( old_alpha )
end

local map_origin, map_size

local function setup_map()
	local map_mins, map_maxs = game.GetWorld():GetModelBounds()
	map_origin = ( map_mins + map_maxs ) / 2

	local map_diff = map_origin - map_mins
	map_size = math.max( map_diff.x, map_diff.y ) * 2
end

SWEP.MapID = 1
function SWEP:WorldToMap( pos )
	if !map_origin then
		setup_map()
	end

	local data = CCTV_CONFIG[self.MapID]
	if !data then return end

	local mat_size = data.u_size
	if data.v_size > mat_size then
		mat_size = data.v_size
	end

	local n_pos = ( pos - map_origin ) / map_size

	local off_x = 0.5 - ( data.u_offset + data.u_size * 0.5 )
	local off_y = 0.5 - ( data.v_offset + data.v_size * 0.5 )

	local n_x = 0.5 - ( n_pos.y - off_x ) / mat_size
	local n_y = 0.5 - ( n_pos.x - off_y ) / mat_size

	return n_x, n_y
end

local function point_within_circle( mx, my, x, y, r )
	return ( mx - x ) ^ 2 + ( my - y ) ^ 2 <= r ^ 2
end

local was_mouse_down = false
function SWEP:HandleMouse()
	local mouse_down = input.IsMouseDown( MOUSE_LEFT )
	if mouse_down and !was_mouse_down then
		was_mouse_down = true

		local ply = self:GetOwner()
		local mx, my = input.GetCursorPos()

		local w, h = ScrW(), ScrH()
		local dir = util.AimVector( ply:EyeAngles(), render.GetViewSetup().fovviewmodel, mx, my, w, h )
		local pos = util.IntersectRayWithPlane( ply:EyePos(), dir, render_pos, render_ang:Up() )

		local diff = pos - render_pos
		local x = diff:Dot( render_ang:Forward() ) / render_scale
		local y = diff:Dot( render_ang:Right() ) / render_scale

		return x, y
	elseif !mouse_down and was_mouse_down then
		was_mouse_down = false
	end
end

function SWEP:DrawMap( x, y, w, h )
	if !self.ReloadDown then return false end

	local data = CCTV_CONFIG[self.MapID]
	if !data then return false end

	local map_margin = h * 0.05
	local max_size = h - 2 * map_margin

	local mat = data.material
	local mat_w = mat:Width()
	local mat_h = mat:Height()
	local mat_s

	if mat_w > mat_h then
		mat_s = mat_w / max_size
	else
		mat_s = mat_h / max_size
	end
	
	mat_w = mat_w / mat_s
	mat_h = mat_h / mat_s

	surface.SetDrawColor( 16, 16, 16, 225 )
	surface.DrawRect( x + ( w - max_size ) * 0.5, y + map_margin, max_size, max_size, 1 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x + ( w - mat_w ) * 0.5, y + map_margin + ( max_size - mat_h ) * 0.5, mat_w, mat_h )

	local mx, my = self:HandleMouse()

	draw.NoTexture()

	for i, v in ipairs( data.cams ) do
		local tab = CCTV[v]
		if !tab then continue end
		
		local cctv = self.CCTVCache[v]
		if IsValid( cctv ) then
			surface.SetDrawColor( 0, 255, 0 )
		else
			surface.SetDrawColor( 255, 0, 0 )
		end
		
		local cx, cy = self:WorldToMap( tab.pos )
		local dx = x + ( w - max_size ) * 0.5 + cx * max_size
		local dy = y + map_margin + cy * max_size
		local dr = h * 0.009

		surface.DrawFilledCircle( dx, dy, dr, 12 )

		if mx and point_within_circle( mx, my, dx, dy, dr * 1.5 ) then
			net.Ping( "SLCCCTVChange", v )
		end
	end

	surface.SetDrawColor( 255, 255, 255 )

	local arrow_x_l = x + w * 0.35
	local arrow_x_r = x + w * 0.65
	local arrow_y = y + h - map_margin * 0.5
	local arrow_r = map_margin * 0.4

	draw.OutlinedText( string.format( data.name, btn ),
		"SCPHUDMedium", x + w * 0.5, arrow_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_black, 2, 3 )

	surface.DrawTriangle( arrow_x_l, arrow_y, arrow_r, -90 )
	surface.DrawTriangle( arrow_x_r, arrow_y, arrow_r, 90 )

	if mx and point_within_circle( mx, my, arrow_x_l, arrow_y, arrow_r * 1.5 ) then
		self.MapID = self.MapID - 1

		if self.MapID < 1 then
			self.MapID = #CCTV_CONFIG
		end
	elseif mx and point_within_circle( mx, my, arrow_x_r, arrow_y, arrow_r * 1.5 ) then
		self.MapID = self.MapID + 1

		if self.MapID > #CCTV_CONFIG then
			self.MapID = 1
		end
	end

	return true
end