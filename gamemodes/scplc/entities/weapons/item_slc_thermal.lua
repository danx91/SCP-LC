SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "THERMAL"

SWEP.WorldModel		= "models/mishka/models/nvg.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Selectable 			= false
SWEP.Toggleable 			= true
SWEP.EnableHolsterThink		= true
SWEP.HasBattery 			= true
SWEP.HolsterBatteryUsage	= true
SWEP.BatteryUsage 			= 0.2

SWEP.DrawCrosshair = false

SWEP.Group = "nvg"

SWEP.FrameRate = 10

function SWEP:Think()
	self:CallBaseClass( "Think" )
end

function SWEP:OnSelect()
	if self:GetBattery() <= 0 then return end
	self:SetEnabled( !self:GetEnabled() )
end

if CLIENT then
	SLC_THERMAL_FILTER = {}
	SLC_THERMAL_CLASSES = {}

	local TEX_SIZE = 256
	local thermal_rt = GetRenderTargetEx("slc_thermal_texture",
		TEX_SIZE, TEX_SIZE,
		RT_SIZE_NO_CHANGE,
		MATERIAL_RT_DEPTH_SEPARATE,
		bit.bor( 2, 256 ),
		0,
		IMAGE_FORMAT_BGRA8888
	)

	local thermal_mat = CreateMaterial( "slc_thermal_material", "UnlitGeneric", {
		["$basetexture"] = thermal_rt:GetName(),
	} )

	local thermal_mat_ex = CreateMaterial( "slc_thermal_full_frame", "UnlitGeneric", {
		["$basetexture"] = "_rt_fullframefb",
	} )
	
	local thermal_overlay = Material( "slc/misc/thermal.png" )
	local color_modify = Material( "pp/colour" )
	
	local function update_thermal( pct )
		local w, h = ScrW(), ScrH()
		local lp = LocalPlayer()
		
		cam.Start2D()

		render.UpdateScreenEffectTexture()
		color_modify:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
		
		color_modify:SetFloat( "$pp_colour_mulr", 0 )
		color_modify:SetFloat( "$pp_colour_mulg", 0  )
		color_modify:SetFloat( "$pp_colour_mulb", 0  )
	
		color_modify:SetFloat( "$pp_colour_addr", 0 )
		color_modify:SetFloat( "$pp_colour_addg", 0 )
		color_modify:SetFloat( "$pp_colour_addb", 0 )
	
		color_modify:SetFloat( "$pp_colour_brightness", -0.1 )
		color_modify:SetFloat( "$pp_colour_contrast", 0.5 )
		color_modify:SetFloat( "$pp_colour_colour", 0 )
		color_modify:SetFloat( "$pp_colour_inv", 0.66 )

		render.SetMaterial( color_modify )
		render.DrawScreenQuad()

		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, w, h )

		cam.End2D()

		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.SetStencilReferenceValue( 1 )

		render.SetStencilEnable( true )

		for i, v in ipairs( ents.GetAll() ) do
			if v == lp then continue end
			
			local class = v:GetClass()
			local isp = v:IsPlayer()
			local isr = class == "prop_ragdoll"
			if SLC_THERMAL_FILTER[v:GetModel()] or ( !isp or !v:Alive() ) and !isr and !SLC_THERMAL_CLASSES[class] then continue end

			render.ClearStencil()
			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )

			v:DrawModel()

			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilPassOperation( STENCIL_KEEP )

			cam.Start2D()

			if isr then
				local ct = CurTime()
				local color = 75 + math.Clamp( 1 - ( ct - v:GetNWFloat( "time", ct ) ) / 120, 0, 1 ) * 65
				surface.SetDrawColor( color, color, color )
			else
				surface.SetDrawColor( 140, 140, 140 )
			end

			surface.DrawRect( 0, 0, w, h )
	
			cam.End2D()
		end

		render.SetStencilEnable( false )
		
		render.UpdateScreenEffectTexture()

		render.PushRenderTarget( thermal_rt )

		render.Clear( 0, 0, 0, 255, true, true )

		cam.Start2D()
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( thermal_mat_ex )

		local ratio = w / h
		surface.DrawTexturedRect( -( TEX_SIZE * ( ratio - 1) ) / 2, 0, TEX_SIZE * ratio, TEX_SIZE )
		cam.End2D()

		render.PopRenderTarget()
	end

	hook.Add( "PreDrawEffects", "SLCThermal", function(a,b)
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetWeapon( "item_slc_thermal" )
		if !IsValid( wep ) or !wep:GetEnabled() then return end

		local ct = CurTime()
		if !wep.NextFrame or wep.NextFrame <= ct then
			wep.NextFrame = ct + 1 / wep.FrameRate
			update_thermal()
		end
	end )

	hook.Add( "PreDrawViewModel", "SLCThermal", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetWeapon( "item_slc_thermal" )
		if !IsValid( wep ) or !wep:GetEnabled() then return end

		return true
	end )

	hook.Add( "PreDrawHUD", "SLCThermal", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetWeapon( "item_slc_thermal" )
		if !IsValid( wep ) or !wep:GetEnabled() then return end

		local w, h = ScrW(), ScrH()
		local start = ( w - h ) / 2

		cam.Start2D()
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( thermal_mat )
		surface.DrawTexturedRect( start, 0, h, h )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.SetMaterial( thermal_overlay )
		surface.DrawTexturedRect( start, 0, h, h )
		
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, start, h )
		surface.DrawRect( ( w + h ) / 2, 0, start, h )
		cam.End2D()
	end )
	
	hook.Add( "SLCScreenMod", "SLCThermal", function( clr )
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetWeapon( "item_slc_thermal" )
		if !IsValid( wep ) or !wep:GetEnabled() then
			ply.disable_blink = false
			return
		end

		ply.disable_blink = true

		clr.colour = 0
		clr.brightness = clr.brightness - 0.06
		clr.contrast = clr.contrast - 0.25
	end )
end