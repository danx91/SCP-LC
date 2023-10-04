--[[-------------------------------------------------------------------------
Generic inventory used for looting, don't confuse with cl_eq!
---------------------------------------------------------------------------]]

/*data = {
	size_x = <number>,
	size_y = <number>,
	visible = <boolean>,
	items = {},
}*/

local default_icon = surface.GetTextureID( "weapons/swep" )
local color_white = Color( 255, 255, 255 )
local select_color = Color( 255, 210, 0 )

local inv_config = {
	margin = 0.005, --s
	slot = 0.07, --s
	max_w = 0.75, --w
	max_h = 0.8, --h
}

local blur = Material( "pp/blurscreen" )
local recomputed = false

_SLCInventoryCache = _SLCInventoryCache or {}

function GetInventory( name )
	return _SLCInventoryCache[name]
end

SLCInventory = {}

function SLCInventory:New( name, size_x, size_y, ent )
	local tab = setmetatable( {}, { __index = SLCInventory } )

	tab.Name = name
	tab.Valid = true
	tab.Visible = false
	tab.Drawn = false

	local w, h = ScrW(), ScrH()
	local s = math.min( w, h * 16 / 9 )

	local margin = s * inv_config.margin
	local slot = s * inv_config.slot

	local max_w = w * inv_config.max_w
	local max_h = h * inv_config.max_h

	local cw = margin * ( size_x + 1 ) + size_x * slot
	local ch = margin * ( size_y + 1 ) + size_y * slot

	if cw > ch then
		if cw > max_w then
			slot = (max_w - margin * ( size_x + 1 ) ) / size_x
			cw = max_w
			ch = margin * ( size_y + 1 ) + size_y * slot
		end
	else
		if ch > max_h then
			slot = (max_h - margin * ( size_y + 1 ) ) / size_y
			cw = margin * ( size_x + 1 ) + size_x * slot
			ch = max_h
		end
	end

	if slot < s * 0.055 then
		tab.FontOverride = "SCPHUDESmall"
	end
	
	tab.SlotDim = slot
	tab.Margin = margin
	
	tab.IsRagdoll = IsValid( ent ) and ent:GetClass() == "prop_ragdoll"
	tab.InfoW = w * 0.2

	tab.DimX = cw
	tab.DimY = ch
	
	tab.SizeX = size_x
	tab.SizeY = size_y
	
	local total_w = cw

	if tab.IsRagdoll then
		total_w = total_w - margin - tab.InfoW
	end

	tab.PosX = (w - total_w) / 2
	tab.PosY = (h - ch) / 2
	
	
	tab.Items = {}
	tab.Entity = ent

	tab.WasMouseDown = false

	local old = _SLCInventoryCache[name]
	if old and IsValid( old ) then
		old:Remove()
	end

	_SLCInventoryCache[name] = tab

	return tab
end

function SLCInventory:Show()
	if !self.Valid then return end
	
	self.Visible = true
	self.Drawn = false
	self.WasMouseDown = false
	gui.EnableScreenClicker( true )
end

function SLCInventory:Hide()
	if !self.Valid then return end

	self.Visible = false
	gui.EnableScreenClicker( false )
end

--[[-------------------------------------------------------------------------
Drawing has 3 passes:
	1st - normal draw, pre blur
	2nd - will not be drawn, used only to determine blur area
	3rd - normal draw, post blur
---------------------------------------------------------------------------]]
function SLCInventory:Draw()
	if !self.Valid then return end
	self.Drawn = true

	if IsEQVisible() then return end

	if !vgui.CursorVisible() then
		gui.EnableScreenClicker( true )
	end

	local mouse_down = input.IsMouseDown( MOUSE_LEFT )
	if mouse_down and self.WasMouseDown then
		mouse_down = false
	else
		self.WasMouseDown = mouse_down
	end

	self.MouseDown = mouse_down

	local sw, sh = ScrW(), ScrH()
	local s = math.min( sw, sh * 16 / 9 )

	render.UpdateScreenEffectTexture()

	self:DrawBackground( s, 1 )

	render.SetStencilTestMask( 0xFF )
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_REPLACE )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilReferenceValue( 1 )

	render.ClearStencil()
	render.SetStencilEnable( true )

	self:DrawBackground( s, 2 )

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilPassOperation( STENCIL_REPLACE )

	render.SetMaterial( blur )
	render.DrawScreenQuad()

	render.SetStencilEnable( false )

	self:DrawBackground( s, 3 )
 
	for i = 1, self.SizeX do
		for j = 1, self.SizeY do
			self:DrawSlot( i, j, s )
		end
	end

	local x, y = self.PosX, self.PosY
	local w, h = self.DimX, self.DimY
	local mx, my = input.GetCursorPos()

	if self.MouseDown and ( mx < x or mx > x + w or my < y or my > y + h ) then
		self:OnClick( -1, -1, -1 )
	end

	if self.IsRagdoll then
		self:DrawInfo()
	end

/*
unknown_chip = "Unknown chip",
name = "Name",
team = "Team",
death_time = "Death time",
time = {
	just = "Just now",
	one = "About one minute ago",
	three = "About three minutes ago",
	five = "About five minutes ago",
	long = "More than five minutes ago",
	very_long = "More than ten minutes ago",
},
*/

	/*if self.MouseDown or input.IsButtonDown( KEY_ESCAPE ) or input.IsButtonDown( GetBindButton( "eq_button" ) ) then
		local mx, my = input.GetCursorPos()
		if !self.MouseDown or mx < self.PosX or mx > self.PosX + self.DimX or my < self.PosY or my > self.PosY + self.DimY then
			self:OnClick( -1, -1, -1 )
		end
	end*/
end

function SLCInventory:DrawBackground( s, pass )
	if !self.Valid then return end

	local x, y = self.PosX, self.PosY
	local w, h = self.DimX, self.DimY
	local marg = self.Margin
	local info_w = self.InfoW
	local isp = self.IsRagdoll

	if pass == 1 then
		surface.SetDrawColor( 175, 175, 175, 255 )
		surface.DrawRect( x - 1, y - 1, w + 2, h + 2 )

		if isp then
			surface.DrawRect( x - info_w - marg - 1 , y - 1, info_w + 2, h + 2 )
		end
	else
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( x, y, w, h )

		if isp then
			surface.DrawRect( x - info_w - marg , y, info_w, h )
		end
	end
end

function SLCInventory:DrawSlot( i, j, s )
	if !self.Valid then return end

	local slot = self.SlotDim
	local x = self.PosX + self.Margin + ( self.Margin + slot ) * ( i - 1 )
	local y = self.PosY + self.Margin + ( self.Margin + slot ) * ( j - 1 )

	local mx, my = input.GetCursorPos()

	surface.SetDrawColor( 175, 175, 175, 255 )
	surface.DrawOutlinedRect( x - 1, y - 1, slot + 2, slot + 2 )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( x, y, slot, slot )

	local num = (j - 1) * self.SizeX + i
	local item = self.Items[num]
	if item then
		local in_slot = mx >= x and mx <= x + slot and my >= y and my <= y + slot

		if ( !input.IsMouseDown( MOUSE_LEFT ) or item.disabled ) and in_slot then
			surface.SetDrawColor( 75, 75, 75, 150 )
			surface.DrawRect( x, y, slot, slot )
		end
		
		local name_h = slot * 0.2
		if item.icon and item.icon != default_icon or !item.select_font then
			draw.WepSelectIcon( item.icon or default_icon, x + 2, y + 2, slot - 4, item.color or color_white )
		elseif item.select_font then
			local font = item.select_font
			local fy = y + slot * 0.5

			if font == "SCPCSSIcons" then
				font = "SCPCSSIconsSmall"
				fy = fy + slot * 0.25
			end
	
			draw.Text{
				text = item.select_text,
				pos = { x + slot * 0.5, fy },
				font = font,
				color = item.color or select_color,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}
		end

		if in_slot or item.unknown then
			surface.SetDrawColor( 0, 0, 0, 225 )
			surface.DrawRect( x, y, slot, name_h + 2 )

			surface.SetDrawColor( 175, 175, 175, 255 )
			surface.DrawLine( x - 1, y + name_h - 1, x + slot - 1, y + name_h - 1 )

			draw.LimitedText{
				text = item.name,
				pos = { x + slot * 0.5 - 2, y + name_h * 0.5 - 1 },
				font = self.FontOverride or "SCPHUDVSmall",
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = slot
			}
		end

		if in_slot and item.alt then
			surface.SetDrawColor( 0, 0, 0, 225 )
			surface.DrawRect( x, y + slot - name_h + 2, slot, name_h - 2 )

			surface.SetDrawColor( 175, 175, 175, 255 )
			surface.DrawLine( x - 1, y + slot - name_h + 1, x + slot - 1, y + slot - name_h + 1 )

			draw.LimitedText{
				text = item.alt,
				pos = { x + slot * 0.5 - 2, y + slot - name_h * 0.5 - 1 },
				font = self.FontOverride or "SCPHUDVSmall",
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = slot
			}
		end

		if item.amount and item.amount > 1 then
			draw.LimitedText{
				text = item.amount,
				pos = { x + slot - 8, y + slot - 4 },
				font = "SCPHUDSmall",
				color = color_white,
				xalign = TEXT_ALIGN_RIGHT,
				yalign = TEXT_ALIGN_BOTTOM,
				max_width = slot
			}
		end

		if !item.disabled and in_slot and self.MouseDown then
			self:OnClick( x, y, num )
		end
	end

	if self.PostSlotDraw then self:PostSlotDraw( num, x, y, slot, s ) end
end

local function draw_info_chunk( x, y, marg, t1, t2 )
	local _, th1 = draw.SimpleText( t1, "SCPHUDSmall", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	local _, th2 = draw.SimpleText( t2, "SCPHUDSmall", x + marg * 2, y + th1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	return th1 + th2 + marg * 1.5
end

function SLCInventory:DrawInfo()
	local ent = self.Entity
	local x, y = self.PosX, self.PosY
	local marg = self.Margin
	local info_w = self.InfoW

	local dx = x - info_w
	local dy = y
	local lang = LANG.MISC.inventory

	local t = SCPTeams.GetName( ent:GetNWInt( "team", 1 ) )
	local time = math.Round( ( CurTime() - ent:GetNWFloat( "time", 0 ) ) / 60 )

	dy = dy + draw_info_chunk( dx, dy, marg, lang.name..":", ent:GetNWString( "nick", "???" ) )
	dy = dy + draw_info_chunk( dx, dy, marg, lang.team..":", LANG.TEAMS[t] or t )
	dy = dy + draw_info_chunk( dx, dy, marg, lang.death_time..":", time > 10 and lang.time.long or lang.time[time] )
end

function SLCInventory:OnClick( x, y, num )

end

function SLCInventory:SetItem( num, item )
	self.Items[num] = item
end

function SLCInventory:GetItem( num )
	return self.Items[num]
end

function SLCInventory:Remove()
	if !self.Valid then return end

	self.Valid = false
	_SLCInventoryCache[self.Name] = nil

	if self.Visible then
		gui.EnableScreenClicker( false )
	end
end

function SLCInventory:IsVisible()
	if !self.Valid then return end
	return self.Visible
end

function SLCInventory:IsValid()
	return self.Valid
end

setmetatable( SLCInventory, { __call = SLCInventory.New } )

function IsAnyInventoryVisible()
	for k, v in pairs( _SLCInventoryCache ) do
		if IsValid( v ) and v:IsVisible() then
			return true
		end
	end

	return false
end

hook.Add( "DrawOverlay", "SLCInventory", function()
	if !recomputed then
		recomputed = true

		blur:SetFloat( "$blur", 4 )
		blur:Recompute()
	end

	for k, v in pairs( _SLCInventoryCache ) do
		if IsValid( v ) and v:IsVisible() then
			v:Draw()
		end
	end
end )

hook.Add( "PlayerButtonDown", "SLCInventory", function( ply, btn )
	if btn >= KEY_FIRST and btn <= KEY_LAST and btn != GetBindButton( "eq_button" ) and GetSettingsValue( "any_button_close_search" ) then
		for k, v in pairs( _SLCInventoryCache ) do
			if IsValid( v ) and v:IsVisible() and v.Drawn then
				v:OnClick( -1, -1, -1 )
			end
		end
	end
end )

hook.Add( "SLCRegisterSettings", "SLCSearching", function()
	RegisterSettingsEntry( "any_button_close_search", "switch", true )
end )