SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "GOC_TAB"

SWEP.WorldModel 	= "models/slusher/tablet/w_tablet.mdl"
SWEP.ViewModel 		= "models/slusher/tablet/c_tablet.mdl"
SWEP.ViewModelFOV 	= 50
SWEP.UseHands 		= true

SWEP.HoldType 		= "slam"
SWEP.m_WeaponDeploySpeed = 0.9

SWEP.DrawCrosshair 	= false

SWEP.Droppable		= false

SWEP.LoadingDuration = 2.5

InstallTable( "ActionQueue", SWEP )

local STATE = {
	IDLE = 0,
	LOADING = 1,
	MALO = 2.
}

local objectives = {
	[-1] = "failed",
	[0] = "nothing",
	"find",
	"escort",
	"deliver",
	"protect",
	"escape",
}

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/tablet.png" )
	SWEP.SelectColor = Color( 80, 5, 130 )
end

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Objective", "Int" )
	self:AddNetworkVar( "Tracking", "Vector" )

	self:ActionQueueSetup()
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	self:ActionQueueInit()
end

SWEP.StateUpdate = 0

SWEP.CachedTracking = Vector( 0, 0, 0 )
SWEP.CachedDist = -1
SWEP.CachedDist2D = -1
SWEP.CachedAngle = 0
SWEP.LastCacheUpdate = 0
function SWEP:Think()
	self:ActionQueueThink()
	
	local ct = CurTime()

	if CLIENT then
		if self.LastCacheUpdate + 1.25 <= ct then
			self.LastCacheUpdate = ct

			local owner = self:GetOwner()
			local pos = owner:GetPos()
			local tr = self:GetTracking()
			local diff = tr - pos

			self.CachedTracking = tr
			self.CachedZDiff = tr.z - pos.z
			self.CachedDist = diff:Length()
			self.CachedDist2D = diff:Length2D()
			self.CachedAngle = owner:EyeAngles().y - diff:Angle().y

			if self:GetObjective() > 0 and self:GetState() == STATE.IDLE then
				surface.PlaySound( "scp_lc/misc/beep1.ogg" )
			end
		end
	end

	if SERVER then
		if self.StateUpdate <= ct then
			self.StateUpdate = ct + 1

			local dev_pl = LocateEntity( "slc_goc_device" )
			if IsValid( dev_pl ) then
				if dev_pl:GetDestroyed() then
					self:SetObjective( -1 )
				elseif dev_pl:Finished() then
					self:SetObjective( 5 )
					self:SetTracking( ( OMEGA_SHELTER[1] + OMEGA_SHELTER[2] ) / 2 )
				else
					self:SetObjective( 4 )
					self:SetTracking( dev_pl:GetPos() )
					return
				end

				self.StateUpdate = ct + 999
				return
			end

			local dev, cont = LocateEntity( "item_slc_goc_device" )
			local dev_valid = IsValid( dev )
			local cont_vpg = IsValid( cont ) and cont:IsPlayer() and cont:SCPTeam() == TEAM_GOC

			if ( dev_valid or dev == true ) and !cont_vpg then
				self:SetObjective( 1 )
				self:SetTracking( dev_valid and dev:GetPos() or cont:GetPos() )
			elseif cont_vpg then
				if cont == self:GetOwner() then
					self:SetObjective( 3 )
					self:SetTracking( GOC_DEVICE_PLACE )
				else
					self:SetObjective( 2 )
					self:SetTracking( cont:GetPos() )
				end
			else
				self:SetObjective( 0 )
				self:SetTracking( Vector( 0, 0, 0 ) )
			end
		end
	end
end

function SWEP:Deploy()
	self:ResetAction( STATE.LOADING, self.LoadingDuration )
	self:ResetViewModelBones()
end

function SWEP:Holster()
	if self:GetState() == STATE.MALO then
		return false
	end

	return true
end

function SWEP:PrimaryAttack()
end

if CLIENT then
	function SWEP:CalcViewModelView( vm, old_pos, old_ang, pos, ang )
		return pos - ang:Up() * 4 + ang:Right() * 2
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
				render.SetStencilReferenceValue( 2 )
				render.SetStencilWriteMask( 0xFF )
				render.SetStencilTestMask( 0xFF )

				render.SetStencilPassOperation( STENCIL_KEEP )
				render.SetStencilFailOperation( STENCIL_REPLACE )
				render.SetStencilZFailOperation( STENCIL_KEEP )

				render.SetStencilCompareFunction( STENCIL_NEVER )

				render.SetStencilEnable( true )

				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawRect( -357.5, -225, 715, 450 )

				render.SetStencilCompareFunction( STENCIL_LESSEQUAL )
				render.SetStencilFailOperation( STENCIL_KEEP )

				self:DrawScreen( -357.5, -225, 715, 450 )

				render.SetStencilEnable( false )
				
			cam.End3D2D()
		end
	end

	local logo = Material( "slc/misc/goc_logo_256.png", "smooth" )
	local dot = Material( "slc/misc/dot.png", "smooth" )
	local arr_up = Material( "slc/hud/arrow_up.png", "smooth" )
	local arr_down = Material( "slc/hud/arrow_down.png", "smooth" )
	local alpha = 0

	local color_white = Color( 255, 255, 255 )

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
		end
		//surface.SetDrawColor( 0, 50, 0 )
		//surface.DrawOutlinedRect( x, y, w, h )
		//surface.DrawRect( x, y, w, h )

		alpha = math.Approach( alpha, 1, FrameTime() * 0.75 )

		if alpha < 1 then
			surface.SetAlphaMultiplier( alpha )
		end

		local oid = self:GetObjective()
		local obj = objectives[oid] or oid

		local tw, th = draw.SimpleText( self.Lang.status, "SCPHUDMedium", x + w * 0.5, y + 8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		draw.SimpleText( self.Lang.objectives[obj] or obj, "SCPHUDMedium", x + w * 0.5, y + 8 + th, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

		local size = h - th * 2 - 40
		local sx, sy = x + w * 0.025, y + th * 2 + 24
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawOutlinedRect( sx, sy, size, size )

		draw.NoTexture()
		surface.DrawTriangle( sx + size * 0.5, sy + size * 0.5, h * 0.03, 180 )

		if oid > 0 then
			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilFailOperation( STENCIL_INCR )

			surface.DrawRect( sx, sy, size, size )

			render.SetStencilReferenceValue( 3 )
			render.SetStencilCompareFunction( STENCIL_LESSEQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )

			local dist = math.Clamp( self.CachedDist2D, 0, 1000 )
			local rad = math.rad( self.CachedAngle )
			local tx, ty = math.sin( rad ), -math.cos( rad )

			local dr = dist / 1000 * size * 0.5

			local ax, ay = math.abs( tx ), math.abs( ty )
			local factor = ax >= ay and ax or ay

			tx = tx / factor * dr
			ty = ty / factor * dr

			local ds = h * 0.05
			surface.SetDrawColor( 255, 255, 255, math.Clamp( ( self.LastCacheUpdate - CurTime() + 0.75 ) / 0.5, 0, 1 ) * 255 )
			surface.SetMaterial( dot )
			surface.DrawTexturedRect( sx + size * 0.5 + tx - ds * 0.5, sy + size * 0.5 + ty - ds * 0.5, ds, ds )

			render.SetStencilReferenceValue( 2 )
			render.SetStencilCompareFunction( STENCIL_EQUAL )

			local ix = sx + size + w * 0.025
			local dy = sy + 16

			tw, th = draw.SimpleText( self.Lang.dist..": ", "SCPHUDSmall", ix, dy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			dy = dy + th

			local ttx = ix + 32
			tw, th = draw.SimpleText( math.ceil( self.CachedDist * 0.01905 ).."m", "SCPHUDSmall", ttx, dy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

			if math.abs( self.CachedZDiff ) > 100 then
				surface.SetDrawColor( 255, 255, 255 )
				surface.SetMaterial( self.CachedZDiff > 0 and arr_up or arr_down )
				surface.DrawTexturedRect( ttx + tw + 8, dy, th, th )
			end

			dy = dy + th

			/*tw, th = draw.SimpleText( self.Lang.dist..": "..math.ceil( self.CachedDistance ), "SCPHUDSmall", ix, dy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			dy = dy + th*/

			render.SetStencilCompareFunction( STENCIL_LESSEQUAL )
		end

		render.SetScissorRect( 0, 0, 0, 0, false )
		surface.SetAlphaMultiplier( 1 )
	end
end