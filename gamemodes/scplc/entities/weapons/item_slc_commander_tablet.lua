SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "COM_TAB"

SWEP.ViewModel 		= "models/slusher/tablet/c_tablet.mdl"
SWEP.WorldModel 	= "models/slusher/tablet/w_tablet.mdl"
SWEP.ViewModelFOV 	= 50
SWEP.UseHands 		= true

SWEP.HoldType 		= "slam"
SWEP.m_WeaponDeploySpeed = 0.9

SWEP.DrawCrosshair 	= false

SWEP.LoadingDuration = 3

InstallTable( "ActionQueue", SWEP )

G_COM_TABLET_DATA = {}

local STATE = {
	IDLE = 0,
	LOADING = 1,
	PRESS = 2,
	PROGRESS = 3,
	MALO = 4.
}

local OPTIONS = {
	"scan",
	"tesla",
}

local DURATION = {
	scan = 45,
	tesla = 10,
}

local CD = {
	scan = 300,
	tesla = 120,
}

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/tablet.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:ActionQueueSetup()
	self:AddNetworkVar( "Selected", "Int" )

	self:SetSelected( 1 )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	self:ActionQueueInit()
end

function SWEP:Think()
	self:ActionQueueThink()
end

function SWEP:Equip( owner )
	if CLIENT then return end

	if IsValid( owner ) then
		net.Start( "SLCComTabletUpdate" )
			net.WriteTable( G_COM_TABLET_DATA )
		net.Send( owner )
	end
end

function SWEP:Deploy()
	if self:GetState() != STATE.PROGRESS then
		self:ResetAction( STATE.LOADING, self.LoadingDuration )
	end

	self:ResetViewModelBones()
end

function SWEP:Holster()
	if self:GetState() == STATE.MALO then
		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if self:GetState() != STATE.IDLE then return end

	local selected = self:GetSelected()
	local option = OPTIONS[selected]

	local cd = G_COM_TABLET_DATA["t_cd_"..option]
	if cd and cd >= CurTime() then return end

	G_COM_TABLET_DATA["t_cd_"..option] = CurTime() + CD[option]

	self:QueueAction( STATE.PRESS, 1.5, function( finish, dur )
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	end )

	self:QueueAction( STATE.PROGRESS, DURATION[option], function( finish, dur )
		if !IsValid( self:GetOwner() ) then return end

		if selected == 1 then
			if SERVER then
				ComTab_Transmit()
				TransmitSound( "scp_lc/announcements/camera_check.ogg", true )

				AddTimer( "ComTabFacilityScan", dur, 1, function()
					if IsValid( self ) then
						self:ResetAction( STATE.IDLE, 0 )
					end

					local teams = {}

					for k, v in pairs( SLCZones.GetPlayersByFlag( ZONE_FLAG_FACILITY ) ) do
						local t = v:SCPTeam()

						if !teams[t] then
							teams[t] = {}
						end

						table.insert( teams[t], v )
					end

					local total = 0

					for _, t in pairs( SCPTeams.GetAll() ) do
						if SCPTeams.HasInfo( t, SCPTeams.INFO_ALIVE ) then
							local num = teams[t] and #teams[t] or 0
							total = total + num

							G_COM_TABLET_DATA["team_"..t] = num
						end
					end

					ComTab_Transmit()

					if total > 0 then
						TransmitSound( "scp_lc/announcements/camera_found.ogg", true )
					else
						TransmitSound( "scp_lc/announcements/camera_notfound.ogg", true )
					end
				end )
			end
		elseif selected == 2 then
			if SERVER then
				ComTab_Transmit()
				self:GetOwner():EmitSound( "scp_lc/announcements/tesla_request.ogg", 85, 100, 0.5 )

				AddTimer( "ComTabTeslaRequest", dur, 1, function()
					if IsValid( self ) then
						self:ResetAction( STATE.IDLE, 0 )
					end

					TransmitSound( string.format( "scp_lc/announcements/tesla%i.ogg", math.random( 3 ) ), true )

					local btn = GetButton( "Tesla" )

					if IsValid( btn ) then
						btn:Fire( "PressIn" )
					end

					G_COM_TABLET_DATA.notif_tesla = CurTime() + 60
					ComTab_Transmit()

					AddTimer( "ComTabTeslaReset", 60, 1, function()
						if IsValid( btn ) then
							btn:Fire( "PressOut" )
						end
					end )
				end )
			end
		end
	end )
end

function SWEP:SecondaryAttack()
	if self:GetState() != STATE.IDLE then return end

	self:SetNextSecondaryFire( CurTime() + 0.1 )
	
	local selected = self:GetSelected() + 1

	if selected > #OPTIONS then
		selected = 1
	end

	self:SetSelected( selected )
end

if SERVER then
	util.AddNetworkString( "SLCComTabletUpdate" )

	function ComTab_Transmit()
		local tab = {}
		
		for k, v in pairs( player.GetAll() ) do
			if v:HasWeapon( "item_slc_commander_tablet" ) then
				table.insert( tab, v )
			end
		end

		net.Start( "SLCComTabletUpdate" )
			net.WriteTable( G_COM_TABLET_DATA )
		net.Send( tab )
	end
end

if CLIENT then
	net.Receive( "SLCComTabletUpdate", function( len )
		G_COM_TABLET_DATA = net.ReadTable()
	end )

	function SWEP:CalcViewModelView( vm, old_pos, old_ang, pos, ang )
		return pos - ang:Up() * 3
	end

	function SWEP:ViewModelDrawn( vm )
		local bone = vm:LookupBone( "jp2" )
		if !bone then return end

		local m = vm:GetBoneMatrix( bone )
		if m then
			local pos, ang = m:GetTranslation(), m:GetAngles()

			ang:RotateAroundAxis( ang:Forward(), -90 )
			ang:RotateAroundAxis( ang:Right(), -100.27 )
			ang:RotateAroundAxis( ang:Up(), 0 )

			pos = pos + ang:Forward() * -0.3 + ang:Right() * 0 + ang:Up() * 0.2

			cam.Start3D2D( pos, ang, 0.015 )
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
				surface.DrawRect( -357.5, -225, 715, 450 )

				render.SetStencilCompareFunction( STENCIL_EQUAL )
				render.SetStencilFailOperation( STENCIL_KEEP )

				self:DrawScreen( -357.5, -225, 715, 450 )

				render.SetStencilEnable( false )
				
			cam.End3D2D()
		end
	end

	local pointer = "➤"

	local fade = Material( "vgui/gradient-l" )
	local logo = Material( "slc/misc/scp_logo_128.png" )
	local alpha = 0

	local color_white = Color( 255, 255, 255 )
	local color_red = Color( 255, 0, 0 )

	function SWEP:DrawScreen( x, y, w, h )
		local ct = CurTime()
		local state = self:GetState()

		if state == STATE.LOADING then
			alpha = 0

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( logo )
			surface.DrawTexturedRect( x + w * 0.5 - h * 0.1, y + h * 0.33, h * 0.2, h * 0.2 )

			local tw = draw.SimpleText( self.Lang.loading, "SCPHUDMedium", x + w * 0.5, y + h * 0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( string.rep( ".", ( ct * 3 ) % 4 ), "SCPHUDMedium", x + w * 0.5 + tw * 0.5, y + h * 0.55, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

			return
		elseif state == STATE.PROGRESS then
			alpha = 0

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( logo )
			surface.DrawTexturedRect( x + w * 0.5 - h * 0.1, y + h * 0.25, h * 0.2, h * 0.2 )

			local option = OPTIONS[self:GetSelected()]
			draw.SimpleText( self.Lang.actions[option] or option, "SCPHUDMedium", x + w * 0.5, y + h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

			local lw, lh = w * 0.4, h * 0.05
			local as, af = self:GetActionStart(), self:GetActionFinish()
			local pct = math.Clamp( ( ct - as ) / ( af - as ), 0, 1 )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( x + w * 0.5 - lw * 0.5, y + h * 0.66, lw, lh )
			surface.DrawRect( x + w * 0.5 - lw * 0.5, y + h * 0.66, lw * pct, lh )

			draw.SimpleText( self.Lang.eta..string.ToMinutesSeconds( math.max( math.ceil( af - ct ), 0 ) ), "SCPHUDSmall", x + w * 0.5, y + h * 0.66 + lh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

			return
		end
		//surface.SetDrawColor( 0, 50, 0 )
		//surface.DrawOutlinedRect( x, y, w, h )
		//surface.DrawRect( x, y, w, h )

		alpha = math.Approach( alpha, 1, FrameTime() * 0.75 )

		if alpha < 1 then
			surface.SetAlphaMultiplier( alpha )
		end

		local _, hh = draw.SimpleText( self.Lang.detected, "SCPHUDMedium", x + 16, y + 4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		local tw, th
		local dy = y + 4 + hh

		local longest = 0

		surface.SetFont( "SCPHUDSmall" )
		local _, font_h = surface.GetTextSize( "W" )

		for _, t in pairs( SCPTeams.GetAll() ) do
			if SCPTeams.HasInfo( t, SCPTeams.INFO_ALIVE ) then
				local name = SCPTeams.GetName( t )
				tw = surface.GetTextSize( ( LANG.TEAMS[name] or name )..":" )

				if tw > longest then
					longest = tw
				end
			end
		end

		for _, t in pairs( SCPTeams.GetAll() ) do
			if SCPTeams.HasInfo( t, SCPTeams.INFO_ALIVE ) then
				local name = SCPTeams.GetName( t )
				local color = SCPTeams.GetColor( t )

				draw.SimpleText( ( LANG.TEAMS[name] or name )..":", "SCPHUDSmall", x + 8 + longest, dy, color or color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
				draw.SimpleText( G_COM_TABLET_DATA["team_"..t] or "?", "SCPHUDSmall", x + 8 + longest + 8, dy, color or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				dy = dy + font_h
			end
		end

		local t_cd = G_COM_TABLET_DATA.notif_tesla
			if t_cd and t_cd > ct then
				draw.SimpleText( self.Lang.tesla_deactivated..string.ToMinutesSeconds( math.ceil( t_cd - ct ) ), "SCPHUDMedium", x + w * 0.5, y + 16, t_cd - 10 < ct and math.floor( ct ) % 2 == 1 and color_red or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end

		local m_x, m_y = x + w * 0.45, y + h - 8
		local m_w = w * 0.45

		draw.SimpleText( self.Lang.change, "SCPHUDSmall", m_x + m_w * 0.1, m_y, color or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		m_y = m_y - font_h

		draw.SimpleText( self.Lang.confirm, "SCPHUDSmall", m_x + m_w * 0.1, m_y, color or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		m_y = m_y - font_h - 32

		local selected = self:GetSelected()
		for i, option in ipairs( OPTIONS ) do
			_, th = draw.SimpleText( self.Lang.options[option] or option, "SCPHUDMedium", m_x + 16, m_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

			if i == selected then
				draw.SimpleText( pointer, "SCPHUDMedium", m_x, m_y, color or color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			end

			local cd = G_COM_TABLET_DATA["t_cd_"..option]
			if cd and cd > ct then
				draw.SimpleText( string.ToMinutesSeconds( math.ceil( cd - ct ) ), "SCPHUDVSmall", x + w - 8, m_y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			end

			surface.SetDrawColor( 125, 125, 125, 255 )
			surface.SetMaterial( fade )
			surface.DrawTexturedRect( m_x + 8, m_y, m_w * 0.75, 1 )

			m_y = m_y - th - 16
		end

		surface.SetAlphaMultiplier( 1 )
	end
end