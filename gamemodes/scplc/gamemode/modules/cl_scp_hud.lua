SLC_SCP_HUD = SLC_SCP_HUD or {}

/*
data = {
	name = "",
	language = "", --same as name by default
	skills = {
		{
			name = "name",
			pos = 1,
			material = "path/to/material",
			button = "button_name", --will be checked in this order: settings entry, bind, key
			cooldown = "key_to_watch", --or function
			show = "key_to_watch", --or function
			text = "key_to_watch", --or function
			active = "key_to_watch", --or function
		},
		...
	}
}
*/

--[[-------------------------------------------------------------------------
SCP Skill Object
---------------------------------------------------------------------------]]
local SCPSkillObject = {}

function SCPSkillObject:SetCooldown( start_time, end_time )
	if end_time then
		self.cd_start = start_time
		self.cd_end = end_time
	else
		local ct = CurTime()

		self.cd_start = ct
		self.cd_end = ct + start_time
	end
end

function SCPSkillObject:SetInactive( bool )
	self.inactive = !!bool
end

function SCPSkillObject:GetName()
	return self.name
end

function SCPSkillObject:IsOnCooldown()
	return self.cd_end > self.cd_start and self.cd_end >= CurTime()
end


function SCPSkillObject:ParseButton()
	if self.data_button then
		local btn = GetBindButton( self.data_button ) or input.LookupBinding( self.data_button ) or self.data_button
		local t = type( btn )

		if t == "number" then
			self.button = btn
		elseif t == "string" then
			self.button = input.GetKeyCode( btn )
		end

		self.button_name = input.GetKeyName( self.button )
	end
end

local COLOR = {
	white = Color( 255, 255, 255, 255 ),
	inactive = Color( 100, 100, 100, 255 ),
	cooldown = Color( 0, 0, 0, 240 ),
	notification = Color( 200, 200, 200, 255 ),
}

local to_watch = {
	"show",
	"cooldown",
	"text",
	"active",
}

function SCPSkillObject:Render( swep )
	local values = self.last_watch_values

	for k, v in pairs( to_watch ) do
		local value
		local func = self[v.."_func"]
		local key = self[v.."_key"]

		if func then
			value = func( swep )
		elseif key then
			local data = swep[key]
			local key_type = self[v.."_type"]

			if !key_type then
				key_type = type( data )
				self[v.."_type"] = key_type
			end

			if key_type == "number" then
				value = data
			elseif key_type == "function" then
				value = data( swep )
			end
		end

		local last = self.last_watch_values[v]
		if last != nil then
			if value != last then
				if v == "show" then
					self.visible = !!value

					if !value then
						return
					end
				elseif v == "active" then
					self:SetInactive( !value )
				elseif v == "cooldown" then
					if value == 0 then
						self:SetCooldown( 0, 0 )
					else
						self:SetCooldown( CurTime(), value )
					end
				elseif v == "text" then
					/*if value != "" then
						self.display_text = value
					end*/
				end
			end
		end

		values[v] = value
	end

	self:ParseButton()

	local scale = GetHUDScale()
	local sw, sh = ScrW(), ScrH()

	local w = sw * scale
	local h = sh * scale
	local addy = sh - h

	local dist = w * 0.03
	local size = w * 0.04
	local margin = h * 0.015

	local total_w = ( size + margin ) * self.hud_object.max_pos - margin
	local start_x = sw * 0.5 - total_w * 0.5

	if start_x < SLC_HUD_END_X + dist then
		start_x = SLC_HUD_END_X + dist
	end

	local draw_x = start_x + ( size + margin ) * ( self.pos - 1 )
	local draw_y = h - margin - size + addy

	surface.SetDrawColor( self.inactive and COLOR.inactive or COLOR.white )
	surface.SetMaterial( self.material )
	surface.DrawTexturedRect( draw_x, draw_y, size, size )

	local ct = CurTime()
	if self.cd_end >= ct then
		local dur = self.cd_end - self.cd_start
		local left = self.cd_end - ct

		if dur > 0 then
			draw.NoTexture()
			surface.SetDrawColor( COLOR.cooldown )
			surface.DrawCooldownRectCW( draw_x, draw_y, size, size, left / dur )
		end

		if GetSettingsValue( "scp_hud_skill_time" ) then
			draw.Text( {
				text = left > 1 and math.floor( left ) or string.format( "%.1f", left ),
				font = "SCPHUDMedium",
				color = COLOR.white,
				pos = { draw_x + size / 2, draw_y + size / 2 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )
		end
	end

	if values.text and values.text != "" then
		draw.LimitedText( {
			text = values.text,
			font = "SCPScaledHUDSmall",
			color = COLOR.white,
			pos = { draw_x + size - 8, draw_y },
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_TOP,
			max_width = size,
		} )
	end

	local btn_name = self.button_name
	if btn_name then
		draw.Text( {
			text = LANG.MISC.buttons[btn_name] or string.upper( btn_name ),
			font = "SCPScaledHUDSmall",
			color = COLOR.white,
			pos = { draw_x + size - 8, draw_y + size },
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		} )
	end

	surface.SetDrawColor( self.inactive and COLOR.inactive or COLOR.white )
	surface.DrawOutlinedRect( draw_x - 1, draw_y - 1, size + 2, size + 2 )

	if vgui.CursorVisible() then
		local mx, my = input.GetCursorPos()

		if mx >= draw_x and mx <= draw_x + size and my >= draw_y and my <= draw_y + size then
			self.hud_object.draw_info = self.name
		end
	end

	return draw_x, draw_y, size
end

local function CreateSCPSkillObject( data )
	local tab = setmetatable( {
		name = data.name,
		material = GetMaterial( data.material, "smooth" ),
		cd_start = 0,
		cd_end = 0,
		pos = data.pos,
		data_button = data.button,
		inactive = false,
		visible = true,
		last_watch_values = {},
	}, { __index = SCPSkillObject } )

	for k, v in pairs( to_watch ) do
		local watch_t = type( data[v] )
		if watch_t == "string" then
			tab[v.."_key"] = data[v]
		elseif watch_t == "function" then
			tab[v.."_func"] = data[v]
		end
	end

	tab:ParseButton()

	return tab
end

hook.Add( "PlayerButtonDown", "SLCSCPHUDButtons", function( ply, btn )
	if IsFirstTimePredicted() and !vgui.CursorVisible() and ply:SCPTeam() == TEAM_SCP then
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) and wep.SCP then
			local hud_object = wep.HUDObject
			if hud_object then
				hud_object:ButtonPressed( btn )
			end
		end
	end
end )

--[[-------------------------------------------------------------------------
SCP HUD Object
---------------------------------------------------------------------------]]
SCPHUDObject = {}

function SCPHUDObject:New( name, swep )
	if self != SCPHUDObject then return end

	local tab = setmetatable( {
		name = "invalid_hud_obj",
		translated_name = "Invalid SCP HUD Object",
		swep = swep,
		skills = {},
		skill_id = {},
		notify_end = 0,
		notify_text = "",
		max_pos = 0,
	}, { __index = SCPHUDObject } )

	local data = SLC_SCP_HUD[name]
	if data then
		local obj_name = data.name or name
		tab.name = obj_name
		tab.max_pos = 0

		local lang = LANG.WEAPONS[data.language or obj_name]
		tab.translated_name = lang and lang.HUD and lang.HUD.name or obj_name

		for i, v in ipairs( data.skills ) do
			tab.skill_id[v.name] = i

			local skill = CreateSCPSkillObject( v )
			skill.hud_object = tab
			tab.skills[i] = skill

			if v.pos > tab.max_pos then
				tab.max_pos = v.pos
			end
		end
	end

	return tab
end

function SCPHUDObject:GetName()
	return self.name
end

function SCPHUDObject:GetSkill( id )
	if isstring( id ) then
		return self:GetSkillByName( id )
	else
		return self.skills[id]
	end
end

function SCPHUDObject:GetSkillByName( id )
	local nid = self.skill_id[id]
	if nid then
		return self:GetSkill( nid )
	end
end

function SCPHUDObject:AddText( txt, dur ) --TODO
	
end

function SCPHUDObject:Notify( txt, dur, snd )
	local ct = CurTime()

	self.notify_text = txt
	self.notify_end = ct + ( dur or 1 )

	if snd then
		if !self.notify_snd or self.notify_snd <= ct then
			self.notify_snd = ct + ( dur or 1 )
			surface.PlaySound( snd )
		end
	end
end

function SCPHUDObject:ButtonPressed( button )
	for k, v in pairs( self.skills ) do
		if v.visible and v.button == button then
			if v:IsOnCooldown() then
				self:Notify( "skill_not_ready", 1, "npc/roller/code2.wav" )
			elseif v.inactive then
				self:Notify( "skill_cant_use", 1, "npc/roller/code2.wav" )
			end

			break
		end
	end
end

function SCPHUDObject:Render()
	local h = ScrH() * GetHUDScale()

	--Skills
	local start_x, end_x, start_y
	for k, v in pairs( self.skills ) do
		local swep = self.swep
		if IsValid( swep ) then
			local x, y, size = v:Render( swep )

			start_y = y

			local pos = x + size
			if !end_x or pos > end_x then
				end_x = pos
			end

			if !start_x or x < start_x then
				start_x = x
			end
		end
	end

	local ct = CurTime()

	--Notifications
	if self.notify_end > ct and self.notify_text != "" then
		local color = COLOR.notification

		local left = self.notify_end - ct
		if left < 0.5 then
			color = Color( color.r, color.g, color.b, left * 510 )
		end

		draw.Text( {
			text = LANG.SCPHUD[self.notify_text] or self.notify_text,
			font = "SCPScaledHUDVSmall",
			color = color,
			pos = { ( start_x + end_x ) * 0.5, start_y - h * 0.02 },
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_BOTTOM,
		} )
	end

	--Messages
	--TODO
	local s_name = self.draw_info
	if s_name then
		self.draw_info = nil


		local lang = LANG.WEAPONS[self.name]
		if lang and lang.skills and lang.skills[s_name] then
			local sw, sh = ScrW(), ScrH()
			local mx, my = input.GetCursorPos()

			local clang = lang.skills[s_name]
			local marg = sh * 0.015
			local name_h = sh * 0.04
			local total_h = name_h
			local feed

			surface.SetFont( "SCPHUDMedium" )
			local info_w = surface.GetTextSize( clang.name or s_name ) + marg * 4

			if clang.dsc then
				local th, tw
				th, tw, feed = draw.SimulateMultilineText( clang.dsc, "SCPHUDSmall", sw * 0.3, marg, 0, 6, true )
				total_h = total_h + th
				if tw + marg * 2 > info_w then
					info_w = tw + marg * 2
				end
			end

			if mx + info_w > sw then
				mx = sw - info_w
			end

			local dy = my - total_h

			surface.SetDrawColor( 0, 0, 0, 240 )
			surface.DrawRect( mx, dy, info_w, total_h )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( mx - 1, dy - 1, info_w + 2, total_h + 2, 1 )

			draw.SimpleText( clang.name or s_name, "SCPHUDMedium", mx + marg, dy + name_h / 2, COLOR.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			dy = dy + name_h

			if clang.dsc and feed then
				draw.MultilineText( mx, dy, nil, "SCPHUDSmall", COLOR.white, sw * 0.3, marg, 0, TEXT_ALIGN_LEFT, 6, false, false, feed )
			end
		end
	end
end

setmetatable( SCPHUDObject, { __call = SCPHUDObject.New } )

--[[-------------------------------------------------------------------------
General
---------------------------------------------------------------------------]]
function DefineSCPHUD( scp, data )
	SLC_SCP_HUD[scp] = data
end

hook.Add( "SLCRegisterSettings", "SLCSCPHUDSettings", function()
	AddConfigPanel( "scp_config", 8000 )

	RegisterSettingsEntry( "scp_special", "bind", "key:G" )
	RegisterSettingsEntry( "scp_hud_skill_time", "switch", true, nil, "scp_config" )
	RegisterSettingsEntry( "scp_hud_overload_cd", "switch", true, nil, "scp_config" )
	RegisterSettingsEntry( "scp_hud_dmg_mod", "switch", true, nil, "scp_config" )
	RegisterSettingsEntry( "scp_nvmod", "switch", true, nil, "scp_config" )
end )

OnPropertyChanged( "overload_cd", function( name, value )
	if !isnumber( value ) then return end

	_SCPOverloadCooldown = value
end )

local color_white = Color( 255, 255, 255 )
local color_red = Color( 200, 25, 45 )
local color_green = Color( 25, 200, 45 )
hook.Add( "SLCPostDrawHUD", "TempSCPOverloadCD", function()
	local lp = LocalPlayer()
	if lp:SCPTeam() != TEAM_SCP then return end

	local dy = 16

	if !lp:GetSCPHuman() and GetSettingsValue( "scp_hud_dmg_mod" ) then
		local _, th = draw.SimpleText( string.format( "%s: %.1f%%", LANG.SCPHUD.damage_scale, GetSCPDamageScale( lp ) * 100 ), "SCPHUDMedium", ScrW() / 2, dy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		dy = dy + th
	end

	if !lp:GetSCPHuman() and !lp:GetSCPDisableOverload() and GetSettingsValue( "scp_hud_overload_cd" ) then
		local text, color

		local ct = CurTime()
		if !_SCPOverloadCooldown or _SCPOverloadCooldown < ct then
			text = LANG.SCPHUD.overload_ready
			color = color_green
		else
			text = LANG.SCPHUD.overload_cd..math.ceil( _SCPOverloadCooldown - CurTime() )
			color = color_red
		end
		
		local _, th = draw.SimpleText( text, "SCPHUDMedium", ScrW() / 2, dy, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		dy = dy + th
	end
end )

hook.Add( "SLCScreenMod", "SCPVisionMod", function( clr )
	if !GetSettingsValue( "scp_nvmod" ) then return end

	local ply = LocalPlayer()
	if ply:SCPTeam() != TEAM_SCP or ply:IsInZone( ZONE_SURFACE ) then return end

	clr.contrast = clr.contrast + 0.75
	clr.brightness = clr.brightness + 0.01
end )