SLC_SCP_HUD = SLC_SCP_HUD or {}

--[[-------------------------------------------------------------------------
Locals
---------------------------------------------------------------------------]]
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )
local color_red = Color( 200, 25, 45 )
local color_green = Color( 25, 200, 45 )
local color_cooldown = Color( 0, 0, 0, 240 )

local mat_bar = Material( "slc/hud/scp/scp_bar.png", "smooth" )
local mat_bar_fill = Material( "slc/hud/scp/scp_bar_fill.png", "smooth" )

local bar_ratio = mat_bar:Width() / mat_bar:Height()

local data_functions = {
	"Text",
	"Visible",
	"Cooldown",
	"Progress",
	"Active",
	"Higlight", --TODO make higlight effect
}
--[[-------------------------------------------------------------------------
SCPSkillObjectInstance
---------------------------------------------------------------------------]]
local SCPSkillObjectInstance = {}

function SCPSkillObjectInstance:IsOnCooldown()
	return self.CooldownTime > 0 and self.Cooldown >= CurTime()
end

function SCPSkillObjectInstance:SetColorOverride( col )
	self.Color = col
	return self
end

function SCPSkillObjectInstance:SetMaterialOverride( mat, args )
	if type( mat ) == "string" then
		self.Material = GetMaterial( mat, args )
	else
		self.Material = mat
	end

	return self
end

function SCPSkillObjectInstance:ParseButton()
	local name = self.Data.Button
	if !name then return end

	local btn = GetBindButton( name ) or input.LookupBinding( name ) or name

	if isnumber( btn ) then
		self.Button = btn
	elseif isstring( btn ) then
		self.Button = input.GetKeyCode( btn )
	end

	self.ButtonName = input.GetKeyName( self.Button )
end

function SCPSkillObjectInstance:ButtonPressed()
	if !self.Visible then return end

	if !self.Active then
		self.HUD:Notify( "skill_cant_use", 1, "npc/roller/code2.wav" )
	elseif self:IsOnCooldown() then
		self.HUD:Notify( "skill_not_ready", 1, "npc/roller/code2.wav" )
	end
end

function SCPSkillObjectInstance:Description( x, y, w, h )
	if !vgui.CursorVisible() then return end

	local data = self.Data
	local mx, my = input.GetCursorPos()
	if mx < x or mx > x + w or my < y or my > y + h then
		self.Info = nil
		return
	end

	if self.Info then
		SLCToolTip( self.Info )
		return
	end

	if self.Info != nil then return end

	local lang = self.Lang or LANG.CommonSkills[data.Name]
	local txt = data.Parser and data.Parser( self.HUD.Weapon, lang )

	if istable( txt ) then
		local mb = MarkupBuilder()
		mb:PushFont( "SCPHUDSmall" )
		mb:Print( lang.name )
		mb:Print( "\n" )
		mb:Print( string.gsub( lang.dsc, "%[(.-)%]", txt ), nil )

		txt = mb:ToString()
	end

	if !txt and lang then
		local mb = MarkupBuilder()
		mb:PushFont( "SCPHUDSmall" )
		mb:Print( lang.name )
		mb:Print( "\n" )
		mb:Print( lang.dsc )

		txt = mb:ToString()
	end

	if txt then
		self.Info = markup.Parse( txt, ScrW() * 0.333 )
	else
		self.Info = false
	end
end

function SCPSkillObjectInstance:UpdateDataFunctions()
	local swep = self.HUD.Weapon

	for i, fn_name in ipairs( data_functions ) do
		local data_fn = self.Data[fn_name.."Function"]
		local data_str = self.Data[fn_name.."Watch"]
		local value

		if data_fn then
			value = data_fn( swep, self.HUD, self )
		elseif data_str then
			if isfunction( swep[data_str] ) then
				value = swep[data_str]( swep )
			else
				value = swep[data_str]
			end
		end

		//if !value then continue end

		local old = self.WatchTable[fn_name]
		if value == old then continue end

		if fn_name == "Text" then
			self.Text = value != nil and tostring( value ) or nil
		elseif fn_name == "Visible" then
			self.Visible = !!value
		elseif fn_name == "Cooldown" then
			value = tonumber( value ) or 0

			if value == 0 then
				self.Cooldown = 0
				self.CooldownTime = 0
			else
				self.Cooldown = value
				self.CooldownTime = value - CurTime()
			end
		elseif fn_name == "Progress" then
			self.Progress = tonumber( value )
		elseif fn_name == "Active" then
			self.Active = !!value
		elseif fn_name == "Higlight" then
			self.Higlight = !!value
		end

		self.WatchTable[fn_name] = value
	end
end

function SCPSkillObjectInstance:Draw( x, y, s )
	self:UpdateDataFunctions()

	if !self.Visible then return end
	local data = self.Data
	local mat = self.Material or data.Material

	local cd_pct, cd_text

	if self.Progress then
		cd_pct = math.Clamp( self.Progress, 0, 1 )
		cd_text = math.Round( cd_pct * 100 ).."%"
	elseif self.CooldownTime > 0 and self.Cooldown > CurTime() then
		local cd = self.Cooldown - CurTime()
		cd_pct = math.Clamp( 1 - cd / self.CooldownTime, 0, 1 )
		cd_text = cd > 1 and math.floor( cd ) or string.format( "%.1f", cd )
	end

	if mat then
		if cd_pct or self.Active then
			surface.SetDrawColor( 255, 255, 255 )
		else
			surface.SetDrawColor( 75, 75, 75 )
		end

		surface.SetMaterial( mat )
		surface.DrawTexturedRect( x, y, s, s )
	end

	if cd_pct then
		draw.NoTexture()
		surface.SetDrawColor( color_cooldown )
		surface.DrawCooldownRectCW( x, y, s, s, 1 - cd_pct )

		if cd_text and GetSettingsValue( "scp_hud_skill_time" ) then
			draw.SimpleText( cd_text, "SCPScaledHUDSmall_Blur", x + s * 0.5, y + s * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( cd_text, "SCPScaledHUDSmall", x + s * 0.5, y + s * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	if cd_pct or self.Active then
		surface.SetDrawColor( 255, 255, 255 )
	else
		surface.SetDrawColor( 75, 75, 75 )
	end
	surface.DrawOutlinedRect( x, y, s, s )

	self:ParseButton()

	if self.ButtonName then
		draw.SimpleText( LANG.MISC.buttons[self.ButtonName] or string.upper( self.ButtonName ), "SCPScaledHUDVSmall_Blur", x + s - 8, y + s, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( LANG.MISC.buttons[self.ButtonName] or string.upper( self.ButtonName ), "SCPScaledHUDVSmall_Blur", x + s - 8, y + s, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( LANG.MISC.buttons[self.ButtonName] or string.upper( self.ButtonName ), "SCPScaledHUDVSmall", x + s - 8, y + s, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
	end

	if self.Text then
		draw.SimpleText( self.Text, "SCPScaledHUDVSmall_Blur", x + s - 8, y, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		draw.SimpleText( self.Text, "SCPScaledHUDVSmall_Blur", x + s - 8, y, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		draw.SimpleText( self.Text, "SCPScaledHUDVSmall", x + s - 8, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	end

	self:Description( x, y, s, s )
end

function SCPSkillObjectInstance:DrawBar( x, y, h )
	self:UpdateDataFunctions()

	if !self.Visible then
		self.Alpha = math.Approach( self.Alpha, 0, RealFrameTime() * 1.5 )
		if self.Alpha == 0 then
			return false
		end
	else
		self.Alpha = math.Approach( self.Alpha, 1, RealFrameTime() * 2 )
	end

	local w = bar_ratio * h
	local start_x = x - w * 0.5
	local data = self.Data

	surface.SetAlphaMultiplier( self.Alpha )

	if self.Progress then
		render.SetScissorRect( start_x, y, start_x + w * math.Clamp( self.Progress, 0, 1 ), y + h, true )

		surface.SetDrawColor( self.Color or data.Color or color_white )
		surface.SetMaterial( mat_bar_fill )
		surface.DrawTexturedRect( start_x, y, w, h )

		render.SetScissorRect( 0, 0, 0, 0, false )
	end

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_bar )
	surface.DrawTexturedRect( start_x, y, w, h )

	local mat = self.Material or data.Material
	if mat then
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( start_x - h * 1.5, y, h, h )
		surface.DrawOutlinedRect( start_x - h * 1.5, y, h, h )
	end

	if self.Text then
		local text_x = start_x + w + h * 0.5
		local text_y = y + h * 0.5 - 4
		draw.SimpleText( self.Text, "SCPScaledHUDSmall_Blur", text_x, text_y, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( self.Text, "SCPScaledHUDSmall_Blur", text_x, text_y, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( self.Text, "SCPScaledHUDSmall", text_x, text_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	surface.SetAlphaMultiplier( 1 )

	self:Description( x - w * 0.5, y, w, h )

	return true
end

--[[-------------------------------------------------------------------------
SCPSkillObject
---------------------------------------------------------------------------]]
local SCPSkillObject = {}

function SCPSkillObject:New( hud, name )
	if self != SCPSkillObject then return end

	local tab = setmetatable( {
		Name = name,
		HUD = hud,
		Offset = 0,
	}, {
		__index = SCPSkillObject
	} )

	return tab
end

function SCPSkillObject:Create( hud )
	local lang = hud.Lang and hud.Lang[self.Name]

	local tab = setmetatable( {
		Data = self,
		HUD = hud,
		Lang = lang,
		WatchTable = {},
		Visible = true,
		//Progress = 0,
		Cooldown = 0,
		CooldownTime = 0,
		Active = true,
		Highlight = false,
		Alpha = 0,
	}, {
		__index = SCPSkillObjectInstance
	} )

	tab:ParseButton()
	
	return tab
end

function SCPSkillObject:SetBar()
	self.Bar = true
	return self
end

function SCPSkillObject:SetOffset( num )
	self.Offset = num
	return self
end

function SCPSkillObject:SetButton( name )
	self.Button = name
	return self
end

function SCPSkillObject:SetMaterial( mat, args )
	if type( mat ) == "string" then
		self.Material = GetMaterial( mat, args )
	else
		self.Material = mat
	end

	return self
end

function SCPSkillObject:SetColor( col )
	self.Color = col
	return self
end

function SCPSkillObject:SetParser( fn )
	self.Parser = fn
	return self
end

for i, v in ipairs( data_functions ) do
	SCPSkillObject["Set"..v.."Function"] = function( self, fn )
		self[v.."Function"] = nil
		self[v.."Watch"] = nil

		if isfunction( fn ) then
			self[v.."Function"] = fn
		elseif isstring( fn ) then
			self[v.."Watch"] = fn
		end

		return self
	end
end

setmetatable( SCPSkillObject, { __call = SCPSkillObject.New } )

hook.Add( "PlayerButtonDown", "SLCSCPHUDButtons", function( ply, code )
	if !IsFirstTimePredicted() or vgui.CursorVisible() or ply:SCPTeam() != TEAM_SCP then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or !wep.HUDObject then return end

	wep.HUDObject:ButtonPressed( code )
end )

--[[-------------------------------------------------------------------------
SCPHUDObjectInstance
---------------------------------------------------------------------------]]
SCPHUDObjectInstance = {
	BaseSize = 0.04,
	BaseMargin = 0.01,
}

function SCPHUDObjectInstance:GetSkill( name )
	return self.SkillsLookup[name]
end

function SCPHUDObjectInstance:GetBar( name )
	return self.BarsLookup[name]
end

function SCPHUDObjectInstance:Notify( name, dur, snd )
	local ct = CurTime()
	self.Notification = name
	self.NotificationTime = ct + dur
	
	if snd and self.NotificationSound < ct then
		self.NotificationSound = ct + dur
		surface.PlaySound( snd )
	end
end

function SCPHUDObjectInstance:ButtonPressed( code )
	for i, v in ipairs( self.Skills ) do
		if v.Button == code then
			v:ButtonPressed()
		end
	end
end

function SCPHUDObjectInstance:CalculateBounds()
	local w = ScrW() * GetHUDScale()
	local size = math.ceil( w * self.BaseSize )
	local margin = math.ceil( w * self.BaseMargin )

	self.Size = size
	self.Margin = margin

	if #self.Skills == 0 then
		self.Width = 0
		self.Height = 0
		return
	end

	local num = 0

	for i, v in ipairs( self.Skills ) do
		num = num + 1 + v.Data.Offset
	end

	self.Width = num * ( size + margin ) - margin
end

function SCPHUDObjectInstance:Draw()
	self:CalculateBounds()

	local w, h = ScrW(), ScrH()
	local x = ( w - self.Width ) * 0.5
	local y = h - self.Margin - self.Size - ( GetSettingsValue( "hud_windowed_mode" ) and h * 0.0225 or 0 )
	local min_x = SLC_HUD_END_X + self.Margin * 4
	local offset = 0

	if x < min_x then
		x = min_x
	end

	for i, v in ipairs( self.Skills ) do
		offset = offset + v.Data.Offset
		v:Draw( x + ( i - 1 + offset ) * ( self.Size + self.Margin ), y, self.Size )
	end

	local dx = w - self.Size - self.Margin * 2
	local lp = LocalPlayer()

	if self.DamageModSkill and !lp:GetSCPHuman() then
		self.DamageModSkill:Draw( dx, y, self.Size )
		dx = dx - self.Size - self.Margin
	end

	if self.OverloadSkill and !lp:GetSCPHuman() and !lp:GetSCPDisableOverload() then
		self.OverloadSkill:Draw( dx, y, self.Size )
		dx = dx - self.Size - self.Margin
	end

	local ct = CurTime()
	if self.NotificationTime > ct then
		local diff = self.NotificationTime - ct
		if diff < 0.5 then
			surface.SetAlphaMultiplier( diff / 0.5 )
		end

		local text = self.Lang and self.Lang[self.Notification] or LANG.SCPHUD[self.Notification] or self.Notification

		draw.SimpleText( text, "SCPScaledHUDSmall_Blur", w * 0.5, y - self.Margin, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( text, "SCPScaledHUDSmall_Blur", w * 0.5, y - self.Margin, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( text, "SCPScaledHUDSmall", w * 0.5, y - self.Margin, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

		surface.SetAlphaMultiplier( 1 )
	end

	local bar_h = self.Size * 0.4
	local dy = y - bar_h - self.Margin * 4

	for i, v in ipairs( self.Bars ) do
		local cy = Lerp( RealFrameTime() * 6, v.LastY or dy, dy )
		if v:DrawBar( w * 0.5, cy, bar_h ) then
			v.LastY = cy
			dy = dy - bar_h - self.Margin
		else
			v.LastY = nil
		end
	end
end

--[[-------------------------------------------------------------------------
SCPHUDObject
---------------------------------------------------------------------------]]
SCPHUDObject = {}

function SCPHUDObject:New( name, swep )
	if self != SCPHUDObject then return end

	local tab = setmetatable( {
		Name = name,
		Lang = name,
		Skills = {},
		Bars = {},
	}, {
		__index = SCPHUDObject
	} )

	SLC_SCP_HUD[name] = tab

	if swep then
		swep.HUDName = name
	end

	return tab
end

function SCPHUDObject:Create( swep )
	local tab = setmetatable( {
		Data = self,
		Weapon = swep,
		Skills = {},
		SkillsLookup = {},
		Bars = {},
		BarsLookup = {},
		NotificationTime = 0,
		NotificationSound = 0,
		Lang = LANG.WEAPONS[self.Lang] and LANG.WEAPONS[self.Lang].skills
	}, {
		__index = SCPHUDObjectInstance
	} )

	for i, v in ipairs( self.Skills ) do
		local skill = v:Create( tab )
		tab.Skills[i] = skill
		tab.SkillsLookup[v.Name] = skill
	end

	for i, v in ipairs( self.Bars ) do
		local bar = v:Create( tab )
		tab.Bars[i] = bar
		tab.BarsLookup[v.Name] = bar
	end

	tab.OverloadSkill = self.OverloadSkill and self.OverloadSkill:Create( tab )
	tab.DamageModSkill = self.DamageModSkill and self.DamageModSkill:Create( tab )

	swep.HUDObject = tab
	return tab
end

function SCPHUDObject:SetLanguage( lang )
	self.Lang = lang
end

function SCPHUDObject:AddSkill( name )
	local skill = SCPSkillObject( self, name )
	table.insert( self.Skills, skill )

	return skill
end

function SCPHUDObject:AddBar( name )
	local bar = SCPSkillObject( self, name )
	table.insert( self.Bars, bar )

	bar:SetBar()

	return bar
end

function SCPHUDObject:AddCommonSkills()
	local overload = SCPSkillObject( self, "c_button_overload" )
	local dmg_mod = SCPSkillObject( self, "c_dmg_mod" )

	overload:SetMaterial( "slc/hud/scp/door_overload.png", "smooth" )
		:SetCooldownFunction( function( swep, hud )
			return _SCPOverloadCooldown
		end )

	dmg_mod:SetMaterial( "slc/hud/scp/dmg_mod.png", "smooth" )
		:SetTextFunction( function( swep, hud )
			return string.format( "%.1f%%", GetSCPModifiers( LocalPlayer() ).def * 100 )
		end )
		:SetParser( function( swep, lang )
			local ply = LocalPlayer()
			local mods = GetSCPModifiers( ply )
			local def = mods.def * 100
			local buff

			if !ply:GetProperty( "scp_buff" ) then
				buff = MarkupBuilder.StaticPrint( lang.not_bought, color_red )
			elseif !ply:IsInZone( ZONE_SURFACE ) then
				buff = MarkupBuilder.StaticPrint( lang.not_surface, color_red )
			else
				buff = string.format( lang.buff, MarkupBuilder.StaticPrint( math.Round( mods.regen_scale * 100, 1 ).."%", color_green ),
					MarkupBuilder.StaticPrint( math.Round( mods.heal_scale * 100, 1 ).."%", color_green ) )
					
			end

			return {
				mod = MarkupBuilder.StaticPrint( math.Round( def, 1 ).."%", def < 0 and color_red or color_green ),
				flat = MarkupBuilder.StaticPrint( math.Round( -mods.flat, 2 ).." "..lang.dmg, color_green ),
				buff = buff,
			}
		end )

	self.OverloadSkill = overload
	self.DamageModSkill = dmg_mod

	return self
end

setmetatable( SCPHUDObject, { __call = SCPHUDObject.New } )

--[[-------------------------------------------------------------------------
General
---------------------------------------------------------------------------]]
function GetSCPHUDObject( name )
	return SLC_SCP_HUD[name]
end

hook.Add( "SLCRegisterSettings", "SLCSCPHUDSettings", function()
	AddConfigPanel( "scp_config", 8000 )

	RegisterSettingsEntry( "scp_special", "bind", "key:G" )
	RegisterSettingsEntry( "scp_hud_skill_time", "switch", true, nil, "scp_config" )
	RegisterSettingsEntry( "scp_nvmod", "switch", true, nil, "scp_config" )
end )

OnPropertyChanged( "overload_cd", function( name, value )
	if !isnumber( value ) then return end

	_SCPOverloadCooldown = value
end )

hook.Add( "SLCScreenMod", "SCPVisionMod", function( clr )
	if !GetSettingsValue( "scp_nvmod" ) then return end

	local ply = LocalPlayer()
	if ply:SCPTeam() != TEAM_SCP or ply:IsInZone( ZONE_SURFACE ) then return end

	clr.contrast = clr.contrast + 0.75
	clr.brightness = clr.brightness + 0.01
end )