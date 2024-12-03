SLC_LOOTING_OVERRIDE = SLC_LOOTING_OVERRIDE or {}

local default_icon = GetMaterial( "slc/hud/upgrades/notowned.png", "smooth" )
local default_color = Color( 125, 125, 125, 225 )

local searching_slot = 0
local searching_time = 0

local function post_draw( self, num, x, y, size, s )
	local ct = CurTime()

	if searching_slot == num then
		if !self.Items[num] then
			searching_slot = 0
			searching_time = 0
		end

		local pct = 1 - ( searching_time - ct ) / CVAR.slc_time_looting:GetFloat()

		if pct > 1 then
			pct = 1
		end

		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRing( x + size * 0.5, y + size * 0.5, size * 0.21, 6, pct * 360, 25, 1 )
	end
end

local function on_click( self, x, y, num )
	if x == -1 then
		StopLooting()
	else
		SearchItem( num, self.Items[num] )
	end
end

function AddLootingOverride( class, data )
	SLC_LOOTING_OVERRIDE[class] = data
end

function StopLooting()
	local inv = GetInventory( "slc_looting" )
	if IsValid( inv ) then
		inv:Remove()
	end

	searching_slot = 0
	searching_time = 0

	net.Start( "SLCLooting" )
		net.WriteBool( false )
	net.SendToServer()
end

function SearchItem( num, item )
	local ct = CurTime()

	if item.unknown then
		if searching_time < ct and searching_slot == 0 then
			searching_time = ct + CVAR.slc_time_looting:GetFloat()
			searching_slot = num
		else
			return
		end
	end

	net.Start( "SLCLooting" )
		net.WriteBool( true )
		net.WriteUInt( num, 8 )
	net.SendToServer()
end

net.Receive( "SLCLooting", function( len )
	local op = net.ReadUInt( 2 )
	if op == 0 then
		local inv = GetInventory( "slc_looting" )
		if IsValid( inv ) then
			inv:Remove()
		end

		searching_slot = 0
		searching_time = 0
	elseif op == 1 then
		local tab = net.ReadTable()

		local old = GetInventory( "slc_looting" )
		if IsValid( old ) then
			old:Remove()
		end

		local inv = SLCInventory( "slc_looting", tab.w, tab.h, tab.ent )
		inv.OnClick = on_click
		inv.PostSlotDraw = post_draw

		for k, item in pairs( tab.loot ) do
			if item == true then
				inv:SetItem( k, {
					name = LANG.MISC.inventory.unsearched,
					icon = default_icon,
					color = default_color,
					unknown = true
				} )
			else
				local item_obj = SLC_LOOTING_OVERRIDE[item.class] or weapons.Get( item.class )
				if item_obj then
					local lng = item_obj.Language and LANG.WEAPONS[item_obj.Language] or LANG.WEAPONS[item.class]
					local lng_name = istable( lng ) and ( lng.showname or lng.name ) or isstring( lng ) and lng
					local ico = item.icon and GetMaterial( item.icon )

					inv:SetItem( k, {
						name = item.name and util.ParseLangKey( item.name ) or lng_name or item_obj.PrintName or item.class,
						alt = item.alt and util.ParseLangKey( item.alt ),
						icon = ico or item_obj.SelectIcon or item_obj.WepSelectIcon,
						color = item.color or item_obj.SelectColor,
						amount = item.data and item.data.amount,
						select_font = INVENTORY_FONTS_OVERRIDE[item_obj.SelectFont] or item_obj.SelectFont,
						select_text = item_obj.IconLetter or lng and ( lng.showname or lng.name ) or item_obj.PrintName or item.class,
					} )
				end
			end
		end

		inv:Show()
	elseif op == 2 then
		local num = net.ReadUInt( 8 )
		local item = net.ReadTable()

		if searching_slot == num then
			searching_slot = 0
		end

		local inv = GetInventory( "slc_looting" )
		if IsValid( inv ) then
			if item.remove then
				inv:SetItem( num, nil )
			else
				local item_obj = SLC_LOOTING_OVERRIDE[item.class] or weapons.Get( item.class )
				if item_obj then
					local lng = item_obj.Language and LANG.WEAPONS[item_obj.Language] or LANG.WEAPONS[item.class]
					local lng_name = istable( lng ) and ( lng.showname or lng.name ) or isstring( lng ) and lng

					inv:SetItem( num, {
						name = item.name and util.ParseLangKey( item.name ) or lng_name or item_obj.PrintName or item.class,
						alt = item.alt and util.ParseLangKey( item.alt ),
						icon = item_obj.SelectIcon or item_obj.WepSelectIcon,
						color = item_obj.SelectColor,
						amount = item.data and item.data.amount,
						select_font = INVENTORY_FONTS_OVERRIDE[item_obj.SelectFont] or item_obj.SelectFont,
						select_text = item_obj.IconLetter or lng and ( lng.showname or lng.name ) or item_obj.PrintName or item.class,
					} )
				end
			end
		end
	elseif op == 3 then
		//local num = net.ReadUInt( 8 )
		surface.PlaySound( "common/wpn_denyselect.wav" )
	end
end )

AddLootingOverride( "__slc_ammo", {
	WepSelectIcon = Material( "slc/items/__slc_ammo.png" ),
	SelectColor = Color( 255, 210, 0, 255 ),
} )