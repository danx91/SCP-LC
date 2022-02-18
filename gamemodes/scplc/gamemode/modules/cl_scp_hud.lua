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
	local size = w * 0.045
	local margin = h * 0.015

	local start_x = SLC_HUD_END_X + margin + dist + ( size + margin ) * ( self.pos - 1 )
	local start_y = h - margin - size + addy

	surface.SetDrawColor( self.inactive and COLOR.inactive or COLOR.white )
	surface.SetMaterial( self.material )
	surface.DrawTexturedRect( start_x, start_y, size, size )

	local ct = CurTime()
	if self.cd_end >= ct then
		local dur = self.cd_end - self.cd_start
		local left = self.cd_end - ct

		if dur > 0 then
			draw.NoTexture()
			surface.SetDrawColor( COLOR.cooldown )
			surface.DrawCooldownRectCW( start_x, start_y, size, size, left / dur )
		end

		/*if true then --TODO
			draw.Text( {
				text = left > 1 and math.floor( left ) or string.format( "%.1f", left ),
				font = "SCPHUDMedium",
				color = COLOR.white,
				pos = { start_x + size / 2, start_y + size / 2 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			} )
		end*/
	end

	if values.text and values.text != "" then
		draw.LimitedText( {
			text = values.text,
			font = "SCPScaledHUDSmall",
			color = COLOR.white,
			pos = { start_x + size - 8, start_y},
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
			pos = { start_x + size - 8, start_y + size},
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		} )
	end

	surface.SetDrawColor( self.inactive and COLOR.inactive or COLOR.white )
	surface.DrawOutlinedRect( start_x - 1, start_y - 1, size + 2, size + 2 )

	return start_x, start_y, size
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
local SCPHUDObject = {}

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
end

function CreateSCPHUDObject( name, swep )
	local tab = setmetatable( {
		name = "invalid_hud_obj",
		translated_name = "Invalid SCP HUD Object",
		swep = swep,
		skills = {},
		skill_id = {},
		notify_end = 0,
		notify_text = "",
		//last_skill_pos = 0,
	}, { __index = SCPHUDObject } )

	local data = SLC_SCP_HUD[name]
	if data then
		local obj_name = data.name or name
		tab.name = obj_name

		local lang = LANG.WEAPONS[data.language or obj_name]
		if lang and lang.HUD then
			tab.translated_name = lang.HUD.name or obj_name
		end

		for i, v in ipairs( data.skills ) do
			tab.skill_id[v.name] = i

			local skill = CreateSCPSkillObject( v )
			skill.hud_object = tab
			tab.skills[i] = skill

			/*if data.pos > tab.last_skill_pos then
				tab.last_skill_pos = data.pos
			end*/
		end
	end

	return tab
end

--[[-------------------------------------------------------------------------
General
---------------------------------------------------------------------------]]
function DefineSCPHUD( scp, data )
	SLC_SCP_HUD[scp] = data
end

hook.Add( "SLCRegisterSettings", "SLCSCPHUDSettings", function()
	//RegisterSettingsEntry( "scp_special", "bind", "key:G" )
	//RegisterSettingsEntry( "scp_hud_show_skill_time", "gui", false )
end )