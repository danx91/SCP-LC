--[[-------------------------------------------------------------------------
Colors
---------------------------------------------------------------------------]]
local color_white = Color( 255, 255, 255 )
local color_gray = Color( 190, 190, 190)
local color_black = Color( 0, 0, 0 )
local color_rule = Color( 255, 255, 150 )

local color_level = {
	HSVToColor( 0, 1, 1 ),
	HSVToColor( 30, 1, 1 ),
	HSVToColor( 60, 1, 1 ),
	HSVToColor( 90, 1, 1 ),
	HSVToColor( 120, 1, 1 ),
}

local level_colors = {
	unchanged = color_gray,
	vlow = HSVToColor( 0, 1, 1 ),
	low = HSVToColor( 30, 1, 1 ),
	normal_up = HSVToColor( 60, 1, 1 ),
	normal_down = HSVToColor( 60, 1, 1 ),
	high = HSVToColor( 90, 1, 1 ),
	vhigh = HSVToColor( 120, 1, 1 ),
}

--[[-------------------------------------------------------------------------
Materials
---------------------------------------------------------------------------]]
local mat_info = Material( "slc/hud/skin_default/round_info.png", "smooth" )
local mat_border = Material( "slc/hud/skin_default/hud_target.png", "smooth" )
local mat_indicator_left = Material( "slc/hud/skin_default/badge_left.png", "smooth" )
local mat_indicator_right = Material( "slc/hud/skin_default/badge_right.png", "smooth" )
local mat_arrow = Material( "slc/hud/skin_default/arrow_right.png", "smooth" )

local border_ratio =  mat_border:Height() / mat_border:Width()
local info_ratio =  mat_info:Height() / mat_info:Width()

local info_segment = 0 //0 hidden, -1 show all, -2 setup
local info_total = 0 //total time to show
local info_dur = 0
local info_time = 0 //start time of current segment
local info_height = 0
local info_data

local function draw_modifier( id, total_w, draw_y, pct )
	local center = ScrW() * 0.5
	local margin = total_w * 0.05

	local lang = LANG.ROUND_MODIFIERS[id]
	local _, th = draw.OutlinedText( lang and lang.name or id, "SCPHUDMedium", center - margin, draw_y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, color_black, 2, 2 )

	local segments = 5
	local per_segment = 1 / segments
	local to_draw = math.ceil( info_data.modifiers[id] * segments )

	local dh = th * 0.75
	local dx = center + margin
	local dy = draw_y + th * 0.5 - dh * 0.5

	surface.SetDrawColor( color_level[to_draw] or color_white )

	for i = 1, to_draw do
		local alpha = ( pct - per_segment * ( i - 1 ) ) / per_segment
		if alpha <= 0 then break end

		alpha = math.Clamp( alpha, 0, 1 )

		local old_alpha
		if alpha < 1 then
			old_alpha = surface.GetAlphaMultiplier()
			surface.SetAlphaMultiplier( alpha * old_alpha )
		end

		surface.SetMaterial( mat_indicator_left )
		surface.DrawTexturedRect( dx, dy, dh, dh )
		dx = dx + 4

		surface.SetMaterial( mat_indicator_right )
		surface.DrawTexturedRect( dx, dy, dh, dh )
		dx = dx + dh * 1.5

		if old_alpha then
			surface.SetAlphaMultiplier( old_alpha )
		end
	end

	return th
end

local info_segments = {
	{
		time = 1,
		fade = 0.5,
		paint = function( total_w, draw_y, pct )
			surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial( mat_info )
			surface.DrawTexturedRect( ScrW() * 0.5 - total_w * 0.5, draw_y, total_w, total_w * info_ratio )

			return draw_y
		end
	},
	{
		time = 2,
		fade = 1.5,
		margin = 2,
		paint = function( total_w, draw_y, pct )
			local center = ScrW() * 0.5
			local _, th = draw.OutlinedText( LANG.ROUND_INFO.round_type, "SCPHUDSmall", center, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			draw_y = draw_y + th

			local lang = LANG.ROUND_TYPES[info_data.roundtype]
			_, th = draw.OutlinedText( lang and lang.name or info_data.roundtype, "SCPHUDMedium", center, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			draw_y = draw_y + th

			return draw_y
		end
	},
	{
		time = 2,
		fade = 0.5,
		margin = 2,
		paint = function( total_w, draw_y, pct )
			if !info_data or !info_data.modifiers or info_data.modifiers.length < 1 then return draw_y end

			local per_modifier = 1 / info_data.modifiers.length

			local dy = draw_y
			local dh

			for i, v in ipairs( info_data.modifiers ) do
				local alpha = ( pct - per_modifier * ( i - 1 ) ) / per_modifier
				if i > 1 and alpha <= 0 then break end

				alpha = math.Clamp( alpha, 0, 1 )

				local old_alpha
				if alpha < 1 then
					old_alpha = surface.GetAlphaMultiplier()
					surface.SetAlphaMultiplier( alpha * old_alpha )
				end

				dh = draw_modifier( v, total_w, dy, alpha )
				dy = dy + dh

				if old_alpha then
					surface.SetAlphaMultiplier( old_alpha )
				end
			end

			return draw_y + math.max( dh * info_data.modifiers.length, ScrH() * 0.15 )
		end
	},
	{
		time = 0.75,
		fade = 0.5,
		paint = function( total_w, draw_y, pct )
			if !info_data or !info_data.rules or info_data.rules.length < 1 then return draw_y end

			local _, th = draw.OutlinedText( LANG.ROUND_INFO.round_rules_long, "SCPHUDMedium", ScrW() * 0.5, draw_y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
			return draw_y + th
		end
	},
	{
		time = 2,
		fade = 0.5,
		paint = function( total_w, draw_y, pct )
			if !info_data or !info_data.rules or info_data.rules.length < 1 then return draw_y end

			local center = ScrW() * 0.5
			local per_rule = 1 / info_data.rules.length

			local dy = draw_y
			local _, fh

			for i, v in ipairs( info_data.rules ) do
				local alpha = ( pct - per_rule * ( i - 1 ) ) / per_rule
				if i > 1 and alpha <= 0 then break end

				local old_alpha
				if alpha < 1 then
					old_alpha = surface.GetAlphaMultiplier()
					surface.SetAlphaMultiplier( alpha * old_alpha )
				end

				local lang = LANG.ROUND_RULES[v]
				_, fh = draw.OutlinedText( lang and lang.name or v, "SCPHUDSmall", center, dy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
				dy = dy + fh

				if old_alpha then
					surface.SetAlphaMultiplier( old_alpha )
				end
			end

			return draw_y + fh * info_data.rules.length
		end
	},
}

local total_num = #info_segments
local min_time = 5
for i, v in ipairs( info_segments ) do
	min_time = min_time + v.time
end

local function draw_round_info()
	if info_segment == 0 then
		RunGUISkinFunction( "round_info", "side" )
		hook.Remove( "HUDPaint", "SLCDefaultRoundInfo" )
		return
	end

	local ct = CurTime()
	local w, h = ScrW(), ScrH()
	local scale = 1 //GetHUDScale()

	local center_x = w * 0.5
	local total_w = w * 0.5 * scale
	local start_y = h * 0.075
	local draw_y = start_y
	local margin = h * 0.015

	local global_alpha = 1
	if info_segment == -1 then
		global_alpha = math.Clamp( ( info_time - ct ) / 0.5, 0, 1 )
	end

	for i, v in ipairs( info_segments ) do
		local pct = 1
		local alpha = 1

		if info_segment == i then
			pct = math.Clamp( ( ct - info_time ) / v.time, 0, 1 )
			alpha = math.Clamp( ( ct - info_time ) / v.fade, 0, 1  )
		end

		alpha = alpha * global_alpha

		local old_alpha
		if alpha < 1 then
			old_alpha = surface.GetAlphaMultiplier()
			surface.SetAlphaMultiplier( alpha * old_alpha )
		end

		draw_y = v.paint( total_w, draw_y, pct ) + margin * ( v.margin or 1 )

		if old_alpha then
			surface.SetAlphaMultiplier( old_alpha )
		end

		if info_segment == i then
			if pct >= 1 then
				if i == total_num then
					info_segment = -1
					info_time = info_total
				else
					info_segment = info_segment + 1
					info_time = ct
				end
			end

			break
		end
	end

	if info_segment == -2 then
		info_segment = 1
		info_time = ct
	elseif info_segment == -1 and info_time <= ct then
		info_segment = 0
	end

	if draw_y > info_height then
		info_height = math.max( draw_y, start_y + total_w * info_ratio + 16 )
	end

	local pct

	if info_dur <= 0 then
		pct = 1
	else
		pct = math.Clamp( 1 - ( info_total - ct ) / info_dur, 0, 1 )
	end

	local cap_size = 16
	local bar_size = 8

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( mat_indicator_left )
	surface.DrawTexturedRect( center_x - total_w * 0.5, info_height, cap_size, cap_size )

	surface.SetMaterial( mat_indicator_right )
	surface.DrawTexturedRect( center_x + total_w * 0.5 - cap_size, info_height, cap_size, cap_size )

	local bar_w = ( total_w - 8 ) * pct
	draw.RoundedBox( bar_size, center_x - bar_w * 0.5, info_height + cap_size * 0.5 - bar_size * 0.5, bar_w, bar_size, color_white )

	local _, skip_bind = GetBindButton( "skip_summary_button" )
	if skip_bind then
		local skip_text = string.format( LANG.ROUND_SUMMARY.skip, string.upper( skip_bind ) )
		draw.OutlinedText( skip_text, "SCPHUDVSmall", center_x, info_height + cap_size, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, color_black, 2, 2 )
	end
end

local function show_fullscreen_info()
	hook.Add( "HUDPaint", "SLCDefaultRoundInfo", draw_round_info )

	local ct = CurTime()
	local time_total = ( ROUND.time - ct ) * 0.5
	if time_total < min_time then
		time_total = min_time
	end

	info_total = ct + time_total
	info_dur = time_total
	info_segment = -2
	info_height = 0

	info_data = {
		modifiers = {},
		rules = {},
	}

	info_data.roundtype = ROUND.roundtype

	local show_mod = GetSettingsValue( "hud_round_info_modified" )

	for k, v in pairs( ROUND.modifiers ) do
		local value, norm, base, hidden = GetRoundModifier( k )
		if hidden or show_mod and value == base then continue end

		info_data.modifiers[k] = norm

		table.insert( info_data.modifiers, k )
	end

	info_data.modifiers.length = #info_data.modifiers

	for k, v in pairs( ROUND.rules ) do
		local value, hidden = GetRoundRule( k )
		if !value or hidden then continue end

		table.insert( info_data.rules, k )
	end

	info_data.rules.length = #info_data.rules
end

local function remove_fullscreen_info()
	hook.Remove( "HUDPaint", "SLCDefaultRoundInfo" )
end

local show_side_info
function show_side_info()
	if IsValid( SLC_SIDE_ROUND_INFO ) then
		SLC_SIDE_ROUND_INFO:Remove()
	end

	SLC_SIDE_ROUND_INFO = vgui.Create( "DefaultRoundInfo" )

	if GetSettingsValue( "hud_show_round_info" ) == "hidden" then
		SLC_SIDE_ROUND_INFO:SetClosed( true )
	end

	hook.Add( "SLCOnEQOpen", SLC_SIDE_ROUND_INFO, SLC_SIDE_ROUND_INFO.Open )
	hook.Add( "SLCOnEQClose", SLC_SIDE_ROUND_INFO, SLC_SIDE_ROUND_INFO.Close )
	hook.Add( "SLCLanguageChanged", SLC_SIDE_ROUND_INFO, show_side_info )
	hook.Add( "SLCSettingsChanged.hud_round_info_modified", SLC_SIDE_ROUND_INFO, show_side_info )
end

local function hide_side_info()
	if IsValid( SLC_SIDE_ROUND_INFO ) then
		SLC_SIDE_ROUND_INFO:Remove()
	end

end

AddGUISkin( "round_info", "default", {
	create = nil,
	remove = function()
		remove_fullscreen_info()
		hide_side_info()
	end,
	show =  function() // For round info, 'show' is called to show the fullscreen version
		if GetSettingsValue( "hud_show_round_info" ) == "fullscreen" then
			hide_side_info()
			show_fullscreen_info()
		else
			show_side_info()
		end
	end,
	side = function() // For round info, 'side' is called to hide fullscreen and show side version
		if info_segment > 0 then
			info_segment = -1
			info_time = CurTime() + 5
		end

		if !IsValid( SLC_SIDE_ROUND_INFO ) then
			show_side_info()
		end
	end,
	hide = function() // For round info, 'hide' is called to hide everything
		info_segment = 0
		info_time = 0

		hide_side_info()
	end,
	skip = function()
		if info_segment == 0 then return end

		local ct = CurTime()
		if info_segment > 0 then
			info_segment = -1
			info_dur = 5
			info_time = ct + info_dur
			info_total = info_time
		elseif info_segment == -1 and info_time > ct + 0.5 then
			info_segment = -1
			info_dur = 0.5
			info_time = ct + info_dur
			info_total = info_time
		end
	end,
} )

//lua_run_cl RunGUISkinFunction( "round_info", "side" )

local PANEL

--[[-------------------------------------------------------------------------
DefaultRoundInfo
---------------------------------------------------------------------------]]
PANEL = {}

PANEL.alpha = 0
PANEL.should_hide = true
PANEL.closed = false

function PANEL:Init()
	local max_w = ScrW() * 0.4
	self:DockPadding( 4, 16, 4, 16 )

	self.TopDivider = vgui.Create( "DLabel", self )
	self.TopDivider:Dock( TOP )
	self.TopDivider:SetFont( "SCPHUDVSmall" )
	self.TopDivider:SetColor( color_gray )
	self.TopDivider:SetContentAlignment( 5 )
	self.TopDivider:SetText( LANG.ROUND_INFO.round_type )
	self.TopDivider:SizeToContents()

	self.RoundType = vgui.Create( "DLabel", self )
	self.RoundType:SetMouseInputEnabled( true )
	self.RoundType:Dock( TOP )
	self.RoundType:SetColor( color_white )
	self.RoundType:SetFont( "SCPHUDSmall" )
	self.RoundType:SetContentAlignment( 5 )

	local lang_type = LANG.ROUND_TYPES[ROUND.roundtype]
	self.RoundType:SetText( lang_type and lang_type.name or ROUND.roundtype )
	self.RoundType:SizeToContents()

	if lang_type then
		self.RoundType.SLCToolTip = markup.Parse( "<font=SCPHUDVSmall>"..lang_type.desc.."</font>", max_w )
	end

	self.MiddleDivider = vgui.Create( "DefaultRoundInfo.Divider", self )
	self.MiddleDivider:Dock( TOP )
	self.MiddleDivider:DockMargin( 0, 8, 0, 0 )
	self.MiddleDivider:SetText( LANG.ROUND_INFO.round_modifiers )
	self.MiddleDivider:SizeToContents()

	self.Modifiers = {}
	self.Rules = {}

	local show_mod = GetSettingsValue( "hud_round_info_modified" )

	local lang_levels = LANG.ROUND_INFO.modifier_levels

	for k, v in pairs( ROUND.modifiers ) do
		local value, norm, base, hidden = GetRoundModifier( k )
		if hidden or show_mod and value == base then continue end

		local key
		if value == base then key = "unchanged"
		elseif norm <= 0.2 then key = "vlow"
		elseif norm <= 0.45 then key = "low"
		elseif norm < 0.50 then key = "normal_down"
		elseif norm < 0.55 then key = "normal_up"
		elseif norm < 0.8 then key = "high"
		else key = "vhigh" end

		local mod = vgui.Create( "DefaultRoundInfo.Modifier", self )
		mod:Dock( TOP )
		mod:SetColor( color_white, level_colors[key] or color_gray )

		local lang = LANG.ROUND_MODIFIERS[k]
		mod:SetText( lang and lang.name or k, lang_levels[key] or key )
		mod:SizeToContents()

		if lang then
			mod.SLCToolTip = markup.Parse( "<font=SCPHUDVSmall>"..lang.desc.."</font>", max_w )
		end

		table.insert( self.Modifiers, mod )
	end

	if #self.Modifiers == 0 then
		self.NoMods = vgui.Create( "DLabel", self )
		self.NoMods:SetMouseInputEnabled( true )
		self.NoMods:Dock( TOP )
		self.NoMods:DockMargin( 0, 4, 0, 4 )
		self.NoMods:SetColor( color_gray )
		self.NoMods:SetFont( "SCPHUDSmall" )
		self.NoMods:SetContentAlignment( 5 )
		self.NoMods:SetText( LANG.ROUND_INFO.no_modifiers )
		self.NoMods:SizeToContents()
		self.NoMods.SLCToolTip = markup.Parse( "<font=SCPHUDVSmall>"..LANG.ROUND_INFO.no_modifiers_desc.."</font>", max_w )
	end

	self.BottomDivider = vgui.Create( "DefaultRoundInfo.Divider", self )
	self.BottomDivider:Dock( TOP )
	self.BottomDivider:DockMargin( 0, 8, 0, 0 )
	self.BottomDivider:SetText( LANG.ROUND_INFO.round_rules )
	self.BottomDivider:SizeToContents()

	for k, v in pairs( ROUND.rules ) do
		local value, hidden = GetRoundRule( k )
		if !value or hidden then continue end

		local rule = vgui.Create( "DLabel", self )
		rule:SetMouseInputEnabled( true )
		rule:Dock( TOP )

		rule:SetFont( "SCPHUDSmall" )
		rule:SetColor( color_rule )
		rule:SetContentAlignment( 5 )

		local lang = LANG.ROUND_RULES[k]
		rule:SetText( lang and lang.name or k )
		rule:SizeToContents()

		if lang then
			rule.SLCToolTip = markup.Parse( "<font=SCPHUDVSmall>"..lang.desc.."</font>", max_w )
		end

		table.insert( self.Rules, rule )
	end

	if #self.Rules == 0 then
		self.NoRules = vgui.Create( "DLabel", self )
		self.NoRules:SetMouseInputEnabled( true )
		self.NoRules:Dock( TOP )
		self.NoRules:DockMargin( 0, 4, 0, 4 )
		self.NoRules:SetColor( color_gray )
		self.NoRules:SetFont( "SCPHUDSmall" )
		self.NoRules:SetContentAlignment( 5 )
		self.NoRules:SetText( LANG.ROUND_INFO.no_rules )
		self.NoRules:SizeToContents()
		self.NoRules.SLCToolTip = markup.Parse( "<font=SCPHUDVSmall>"..LANG.ROUND_INFO.no_rules_desc.."</font>", max_w )
	end

	self.Button = vgui.Create( "DButton" )
	self.Button:NoClipping( true )
	self.Button:SetSize( 32, 48 )
	self.Button:SetText( "" )
	self.Button:Hide()

	self.Button.rotation = 180

	self.Button.Paint = function( this, pw, ph )
		local alpha = self:GetAlpha()

		surface.SetDrawColor( 255, 255, 255, alpha * 0.1 )
		surface.DrawOutlinedRect( 0, 0, pw, ph )

		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( mat_arrow )
		surface.DrawTexturedRectRotated( pw * 0.5, ph * 0.5, ph, ph, this.rotation )
	end

	self.Button.DoClick = function( this )
		self:SetClosed( !self.closed )
	end

	self:SetPos( 8, 8 )
	self:SetAlpha( 0 )
	self:Hide()

	self:SizeToChildren( true, false )
	self:SetWide( self:GetWide() + 8 )

	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
end

function PANEL:Think()
	if self.should_hide and self.alpha > 0 then
		self.alpha = math.Clamp( self.alpha - RealFrameTime() * 3, 0, 1 )
		self:SetAlpha( 255 * SLCEase.ease_in_out( self.alpha ) )

		if self.alpha == 0 then
			self:Hide()
			self.Button:Hide()
		end
	elseif !self.should_hide and self.alpha < 1 then
		self.alpha = math.Clamp( self.alpha + RealFrameTime() * 3, 0, 1 )
		self:SetAlpha( 255 * SLCEase.ease_in_out( self.alpha ) )
	end
end

function PANEL:PerformLayout( w, h )
	self.Button:SetPos( self:GetX() + w + 4, h * 0.5 - self.Button:GetTall() * 0.5 )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255 )
	local dh = w * border_ratio
	surface.SetMaterial( mat_border )
	surface.DrawTexturedRect( 0, 0, w, dh )

	surface.DrawTexturedRectRotated( w * 0.5, h - dh * 0.5, w, dh, 180 )
end

function PANEL:OnRemove()
	self.Button:Remove()
end

function PANEL:Open()
	self:Show()
	self.Button:Show()
	self.should_hide = false
end

function PANEL:Close()
	self.should_hide = true
end

function PANEL:SetClosed( b )
	if b and !self.closed then
		self.closed = true

		local anim = self:NewAnimation( 0.333 )
		anim.StartPos = self:GetX()
		anim.EndPos = -self:GetWide()

		anim.Think = function( data, pnl )
			local f = math.Clamp( ( SysTime() - data.StartTime ) / ( data.EndTime - data.StartTime ), 0, 1 )
			local x = data.StartPos + ( data.EndPos - data.StartPos ) * f

			pnl:SetX( x )
			pnl.Button:SetX( x + pnl:GetWide() + 4 )

			pnl.Button.rotation = 0
		end
	elseif !b and self.closed then
		self.closed = false

		local anim = self:NewAnimation( 0.333 )
		anim.StartPos = self:GetX()
		anim.EndPos = 8

		anim.Think = function( data, pnl )
			local f = math.Clamp( ( SysTime() - data.StartTime ) / ( data.EndTime - data.StartTime ), 0, 1 )
			local x = data.StartPos + ( data.EndPos - data.StartPos ) * f

			pnl:SetX( x )
			pnl.Button:SetX( x + pnl:GetWide() + 4 )

			pnl.Button.rotation = 180
		end
	end
end

vgui.Register( "DefaultRoundInfo", PANEL, "DPanel" )

--[[-------------------------------------------------------------------------
DefaultRoundInfo.Modifier
---------------------------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
	self.Title = vgui.Create( "DLabel", self )
	self.Title:Dock( LEFT )
	self.Title:DockMargin( 4, 0, 0, 0 )
	self.Title:SetFont( "SCPHUDSmall" )

	self.Content = vgui.Create( "DLabel", self )
	self.Content:Dock( FILL )
	self.Content:DockMargin( 0, 4, 0, 0 )
	self.Content:SetFont( "SCPHUDVSmall" )
	self.Content:SetContentAlignment( 5 )

	self:SetPaintBackground( false )
end

function PANEL:PerformLayout( w, h )
	self.Title:SetWide( w * 0.5 )
end

function PANEL:SizeToContents()
	self.Title:SizeToContents()
	self.Content:SizeToContents()

	local max_w = math.max( self.Title:GetWide(), self.Content:GetWide() ) + 12

	self:SetSize( max_w * 2, self.Title:GetTall() )
end

function PANEL:SetText( title, content )
	self.Title:SetText( title )
	self.Content:SetText( content )
end

function PANEL:SetColor( title, content )
	if title then self.Title:SetColor( title ) end
	if content then self.Content:SetColor( content ) end
end

vgui.Register( "DefaultRoundInfo.Modifier", PANEL, "DPanel" )

--[[-------------------------------------------------------------------------
DefaultRoundInfo.Divider
---------------------------------------------------------------------------]]
local mat_fade_l = Material( "vgui/gradient-l" )
local mat_fade_r = Material( "vgui/gradient-r" )

PANEL = {}

AccessorFunc( PANEL, "s_Text", "Text", FORCE_STRING )
AccessorFunc( PANEL, "s_Font", "Font", FORCE_STRING )

PANEL.s_Text = ""
PANEL.s_Font = "SCPHUDVSmall"

function PANEL:Init()
	--
end

function PANEL:Paint( w, h )
	local margin = 2
	local center_x = w * 0.5
	local center_y = h * 0.5

	local tw = draw.SimpleText( self.s_Text, self.s_Font, center_x, center_y, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	local dw = ( w - tw ) * 0.5 - margin

	surface.SetDrawColor( color_gray )

	surface.SetMaterial( mat_fade_r )
	surface.DrawTexturedRect( 0, center_y - 1, dw, 2 )

	surface.SetMaterial( mat_fade_l )
	surface.DrawTexturedRect( w - dw + margin, center_y - 1, dw, 2 )
end


function PANEL:SizeToContents()
	local total_w = 48
	local height = 2

	if self.s_Text != "" then
		surface.SetFont( self.s_Font )
		local tw, th = surface.GetTextSize( self.s_Text )

		total_w = total_w + tw
		height = th
	end

	self:SetSize( total_w, height )
end

vgui.Register( "DefaultRoundInfo.Divider", PANEL, "DPanel" )