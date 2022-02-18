SLC_SCP_UPGRADES = SLC_SCP_UPGRADES or {}

local generic_skill_icons = {
	nvmod = "slc/hud/upgrades/nvmod.png",
}

--[[
	data = {
		grid_x = 3, --X size of grid (width)
		grid_y = 4, --Y size of grid (height)
		upgrades = {
			{
				name = "", --MUST be unique
				icon = <material>, --IMaterial
				cost = 1, --cost of upgrade
				req = {}, --upgrades required to unlock this upgrade
				block = {}, --upgrades that block this upgrade
				reqany = false, --false - All required upgrades are required to unlock; reqany = true - Any required upgrade is required to unlock
				pos = { <xpos>, <ypos> }, -X and Y position on grid
				mod = { key = <value> }, --data to save when upgrade is bought, cab be accessed with SWEP:GetUpgadeMod( name )
				active = false, --active = any* but false/nil -> will call OnUpgradeBought( <upgrade name>, <this field value>, <group> )
				group = nil, --look above
				rowr = false --repeat on weapon restore
			},
			...
		},
		rewards = {
			
		}
	}
]]
function DefineUpgradeSystem( name, data )
	local ids = {}

	for i, v in ipairs( data.upgrades ) do
		ids[v.name] = i

		if !v.icon and generic_skill_icons[v.name] then
			v.icon = GetMaterial( generic_skill_icons[v.name] )
		end
	end

	data.upgradeid = ids
	SLC_SCP_UPGRADES[name] = data
end

function InstallUpgradeSystem( name, swep )
	local upg = SLC_SCP_UPGRADES[name]
	if !upg then return end

	swep.UpgradeSystemName = name
	swep.UpgradeSystemRegistry = {
		upgrades = {},
		mod = {},
		points = 1,
		score = 0,
		lastreward = 0,
	}

	swep.GetUpgradePoints = function( self )
		return self.UpgradeSystemRegistry.points
	end

	swep.SetUpgradePoints = function( self, i )
		self.UpgradeSystemRegistry.points = i
	end

	swep.AddUpgradePoints = function( self, i )
		self.UpgradeSystemRegistry.points = self.UpgradeSystemRegistry.points + ( i or 1 )

		if SERVER then
			net.Start( "SCPUpgrade" )
				net.WriteUInt( self.UpgradeSystemRegistry.points, 8 )
			net.Send( self:GetOwner() )
		end
	end

	swep.HasUpgrade = function( self, name )
		return self.UpgradeSystemRegistry.upgrades[name] == true
	end

	swep.AddScore = function( self, score )
		self.UpgradeSystemRegistry.score = self.UpgradeSystemRegistry.score + score

		local count = #upg.rewards
		if self.UpgradeSystemRegistry.lastreward < count then
			local changed = false

			for i = self.UpgradeSystemRegistry.lastreward + 1, count do
				local reward = upg.rewards[i]

				if reward[1] <= self.UpgradeSystemRegistry.score then
					self.UpgradeSystemRegistry.points = self.UpgradeSystemRegistry.points + reward[2]
					self.UpgradeSystemRegistry.lastreward = i
					changed = true
				else
					break
				end
			end

			if SERVER and changed then
				net.Start( "SCPUpgrade" )
					net.WriteUInt( self.UpgradeSystemRegistry.points, 8 )
				net.Send( self:GetOwner() )
			end
		end
	end

	swep.UpgradeBlocked = function( self, name )
		local id = upg.upgradeid[name]
		if id then
			local block = upg.upgrades[id].block
			if block and #block > 0 then
				for k, v in pairs( block ) do
					if self.UpgradeSystemRegistry.upgrades[v] then
						return true
					end
				end
			end
		end
	end

	swep.UpgradeUnlocked = function( self, name )
		if self:UpgradeBlocked( name ) then return false end

		local id = upg.upgradeid[name]
		if id then
			local req = upg.upgrades[id].req
			local reqany = upg.upgrades[id].reqany

			if !req or #req == 0 then
				return true
			end

			for k, v in pairs( req ) do
				if self.UpgradeSystemRegistry.upgrades[v] then
					if reqany then
						return true
					end
				else
					if !reqany then
						return false
					end
				end
			end

			return !reqany
		end
	end

	swep.CanBuyUpgrade = function( self, name )
		if self:HasUpgrade( name ) then return false end
		if !self:UpgradeUnlocked( name ) then return false end
		//if self:UpgradeBlocked( name ) then return false end

		local id = upg.upgradeid[name]
		if id then
			return self.UpgradeSystemRegistry.points >= upg.upgrades[id].cost
		end
	end

	swep.BuyUpgrade = function( self, id )
		local upgrade = upg.upgrades[id]

		if upgrade then
			if self:CanBuyUpgrade( upgrade.name ) then
				self.UpgradeSystemRegistry.points = self.UpgradeSystemRegistry.points - upgrade.cost
				self.UpgradeSystemRegistry.upgrades[upgrade.name] = true

				if SERVER then
					net.Start( "SCPUpgrade" )
						net.WriteUInt( self.UpgradeSystemRegistry.points, 8 )
					net.Send( self:GetOwner() )
				end

				for k, v in pairs( upgrade.mod ) do
					self.UpgradeSystemRegistry.mod[k] = v
				end

				if upgrade.active and self.OnUpgradeBought then
					self:OnUpgradeBought( upgrade.name, upgrade.active, upgrade.group )
				end
			end
		end
	end

	swep.GetUpgradeMod = function( self, name, def )
		return self.UpgradeSystemRegistry.mod[name] or def
	end

	/*swep.StoreUpgradeSystem = function( self, data )
		StoreUpgradeSystem( self, data )
	end*/

	swep.UpgradeSystemMounted = true
end

function StoreUpgradeSystem( swep, data )
	if swep.UpgradeSystemMounted then
		data.UpgradeSystemMounted = true
		data.UpgradeSystemRegistry = swep.UpgradeSystemRegistry
	end
end

function RestoreUpgradeSystem( swep, data )
	if data.UpgradeSystemMounted then
		swep.UpgradeSystemRegistry = data.UpgradeSystemRegistry

		local owner = swep:GetOwner()

		if IsValid( owner ) then
			net.SendTable( "SCPUpgradeSync", { swep:GetClass(), swep.UpgradeSystemRegistry }, owner )
		end

		if swep.UpgradeSystemRestored then
			swep:UpgradeSystemRestored( swep.UpgradeSystemRegistry.upgrades )
		end

		local upg = SLC_SCP_UPGRADES[swep.UpgradeSystemName]
		if upg then
			for k, v in pairs( upg.upgrades ) do
				if v.active and v.rowr and swep.OnUpgradeBought and swep.UpgradeSystemRegistry.upgrades[v.name] then
					swep:OnUpgradeBought( v.name, v.active, v.group )
				end
			end
		end
	end
end

--[[-------------------------------------------------------------------------
Server utils
---------------------------------------------------------------------------]]
if SERVER then
	net.AddTableChannel( "SCPUpgradeSync" )

	net.Receive( "SCPUpgrade", function( len, ply )
		local id = net.ReadUInt( 8 )

		local wep = ply:GetActiveWeapon()
		if !IsValid( wep ) or !wep.UpgradeSystemMounted then return end

		wep:BuyUpgrade( id )
	end )
end

--[[-------------------------------------------------------------------------
GUI
---------------------------------------------------------------------------]]
if CLIENT then
	net.ReceiveTable( "SCPUpgradeSync", function( data )

		WaitForSync( function()
			local wep = LocalPlayer():GetWeapon( data[1] )

			if IsValid( wep ) then
				if wep.UpgradeSystemMounted then
					wep.UpgradeSystemRegistry = data[2]

					local upg = SLC_SCP_UPGRADES[wep.UpgradeSystemName]
					if upg then
						for k, v in pairs( upg.upgrades ) do
							if v.active and v.rowr and wep.OnUpgradeBought and wep.UpgradeSystemRegistry.upgrades[v.name] then
								wep:OnUpgradeBought( v.name, v.active, v.group )
							end
						end
					end
				end
			end
		end )
	end )

	net.Receive( "SCPUpgrade", function( len )
		local num = net.ReadUInt( 8 )

		local wep = LocalPlayer():GetActiveWeapon()
		if !IsValid( wep ) or !wep.UpgradeSystemMounted then return end

		local cur = wep:GetUpgradePoints()

		if num > cur then
			local bind = input.LookupBinding( "+zoom" )

			if bind then
				bind = string.upper( bind )
			else
				bind = "+zoom"
			end

			PlayerMessage( "upgradepoints$"..EscapeMessage( bind ) )
		end

		wep:SetUpgradePoints( num )
	end )

	local button_next = false
	local next_frame = false
	local function Button( x, y, w, h )
		local mx, my = input.GetCursorPos()
		if mx >= x and mx <= x + w and my >= y and my <= y + h then
			if input.IsMouseDown( MOUSE_LEFT )then
				
				if button_next then
					button_next = false
					return 2 --LMB
				end

				return 1 --HOVER
			elseif input.IsMouseDown( MOUSE_RIGHT ) then
				if button_next then
					button_next = false
					return 3 --RMB
				end

				return 1 --HOVER
			else
				if next_frame then
					next_frame = false
					button_next = true
				end

				return 1 --HOVER
			end
		end

		return 0
	end

	HUDSCPUpgradesOpen = false
	local MATS = {
		blur = Material( "pp/blurscreen" ),
		nown = Material( "slc/hud/upgrades/notowned.png" ),
		locked = Material( "slc/hud/upgrades/locked.png" )
	}
	local recomputed = false

	local color_white = Color( 255, 255, 255, 255 )

	local function drawUpgrades()
		if !HUDSCPUpgradesOpen then return end
		next_frame = true

		local wep = LocalPlayer():GetActiveWeapon()
		if !IsValid( wep ) or !wep.UpgradeSystemMounted then return end

		local upg = SLC_SCP_UPGRADES[wep.UpgradeSystemName]
		if !upg then return end

		local info
		local lang = wep.Lang.upgrades or {}
		local w, h = ScrW(), ScrH()

		render.UpdateScreenEffectTexture()
		MATS.blur:SetFloat( "$blur", 8 )

		if !recomputed then
			recomputed = true
			MATS.blur:Recompute()
		end

		surface.SetDrawColor( 150, 150, 150, 100 )
		surface.DrawRect( w * 0.2 - 2, h * 0.05 - 2, w * 0.6 + 4, h * 0.7 + 4 )

		render.SetStencilTestMask( 0xFF )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_REPLACE )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilReferenceValue( 1 )

		render.ClearStencil()
		render.SetStencilEnable( true )

		surface.DrawRect( w * 0.2, h * 0.05, w * 0.6, h * 0.7 )

		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )

		surface.SetMaterial( MATS.blur )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, w, h )

		render.SetStencilEnable( false )

		surface.SetDrawColor( 0, 0, 0, 175 )
		surface.DrawRect( w * 0.2, h * 0.05, w * 0.6, h * 0.7 )

		draw.Text{
			text = string.format( LANG.upgrades.tree, wep:GetPrintName() ),
			pos = {  w * 0.25, h * 0.075 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.Text{
			text = LANG.upgrades.points..": "..wep:GetUpgradePoints(),
			pos = {  w * 0.75, h * 0.075 },
			color = Color( 255, 255, 255, 100 ),
			font = "SCPHUDBig",
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_CENTER,
		}

		surface.SetDrawColor( 150, 150, 150, 100 )
		surface.DrawLine( w * 0.225, h * 0.1, w * 0.775, h * 0.1 )

		local drawx = w * 0.2
		local drawy = h * 0.1
		local draww = w * 0.6
		local drawh = h * 0.65

		surface.SetDrawColor( 255, 50, 50, 100 )
		--surface.DrawOutlinedRect( drawx, drawy, draww, drawh )

		local gridxs = draww / ( upg.grid_x + 1 )
		local gridys = drawh / ( upg.grid_y + 1 )
		local icosize = math.min( gridxs, gridys ) * 0.6
		local halfico = icosize * 0.5

		/*for i = 1, upg.grid_x do
			surface.DrawLine( drawx + gridxs * i, drawy, drawx + gridxs * i, drawy + drawh )
		end

		for j = 1, upg.grid_y do
			surface.DrawLine( drawx, drawy + gridys * j, drawx + draww, drawy + gridys * j )
		end*/

		for i, v in ipairs( upg.upgrades ) do
			local xpos = drawx + gridxs * v.pos[1]
			local ypos = drawy + gridys * v.pos[2]

			local sx = xpos - halfico
			local sy = ypos - halfico

			surface.SetDrawColor( 150, 150, 150, 255 )
			surface.DrawOutlinedRect( sx - 1, sy - 1, icosize + 2, icosize + 2 )

			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( sx, sy, icosize, icosize )

			//render.PushFilterMin( TEXFILTER.LINEAR )
			//render.PushFilterMag( TEXFILTER.LINEAR )
			PushFilters( TEXFILTER.LINEAR )
			
			if v.icon then
				surface.SetDrawColor( color_white )
				surface.SetMaterial( v.icon )
				surface.DrawTexturedRect( sx, sy, icosize, icosize )
			end

			if !wep:HasUpgrade( v.name ) then
				surface.SetDrawColor( 0, 0, 0, 220 )
				surface.DrawRect( sx, sy, icosize, icosize )

				surface.SetDrawColor( 150, 150, 150, 45 )
				surface.SetMaterial( MATS.nown )
				surface.DrawTexturedRect( sx, sy, icosize, icosize )

				//surface.SetDrawColor( Color( 0, 0, 0, 210 ) )
				//surface.DrawRect( sx + halfico * 1.25, sy + halfico * 1.25, halfico * 0.75, halfico * 0.75 )

				draw.Text{
					text = v.cost,
					pos = {  sx + halfico * 1.625, sy + halfico * 1.625 },
					color = wep:GetUpgradePoints() >= v.cost and Color( 255, 255, 255, 200 ) or Color( 225, 50, 50, 200 ),
					font = "SCPHUDSmall",
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			end

			if !wep:UpgradeUnlocked( v.name ) then
				surface.SetDrawColor( 255, 255, 255, 175 )
				surface.SetMaterial( MATS.locked )
				surface.DrawTexturedRect( sx + halfico * 0.5, sy + halfico * 0.5, halfico, halfico )
			end

			//render.PopFilterMin()
			//render.PopFilterMag()
			PopFilters()

			local rnum = #v.req
			for j = 1, rnum do
				local second = upg.upgrades[upg.upgradeid[v.req[j]]]

				surface.SetDrawColor( 150, 150, 150, 255 )

				if v.reqany and v.pos[1] != second.pos[1] then
					if v.pos[1] > second.pos[1] then
						surface.DrawLine( xpos - halfico - 1, ypos, drawx + gridxs * second.pos[1], drawy + gridys * second.pos[2] + halfico )
					else
						surface.DrawLine( xpos + halfico + 1, ypos, drawx + gridxs * second.pos[1], drawy + gridys * second.pos[2] + halfico )
					end
				else
					surface.DrawLine( xpos, sy - 1, drawx + gridxs * second.pos[1], drawy + gridys * second.pos[2] + halfico )
				end
			end

			if rnum > 1 and !v.reqany then
				surface.SetDrawColor( 150, 150, 150, 255 )
				draw.NoTexture()
				surface.DrawFilledCircle( xpos, sy - 1, 5, 10 )
			end

			local btn = Button( sx, sy, icosize, icosize )

			if btn > 0 then
				info = v
			end

			if btn == 2 and wep:CanBuyUpgrade( v.name ) then
				net.Start( "SCPUpgrade" )
					net.WriteUInt( i, 8 )
				net.SendToServer()

				wep:BuyUpgrade( i )
			end
		end

		if info then
			local clang = lang[info.name] or LANG.GenericUpgrades[info.name] or {}

			local cx, cy = input.GetCursorPos()

			local width = w * 0.3

			if cx + width > w then
				cx = w - width
			end

			render.SetStencilTestMask( 0xFF )
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilPassOperation( STENCIL_REPLACE )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )

			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilReferenceValue( 1 )

			render.ClearStencil()
			render.SetStencilEnable( true )

			surface.SetDrawColor( 0, 0, 0, 240 )

			surface.DrawRect( cx, cy, width, math.ceil( h * 0.04 ) )
			local cur_y = cy + math.ceil( h * 0.04 )

			draw.LimitedText{
				text = clang.name or info.name,
				pos = { cx + w * 0.01, cy + h * 0.02 },
				font = "SCPHUDMedium",
				color = color_white,
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
				max_width = w * 0.28
			}

			local owned = wep:HasUpgrade( info.name )
			surface.DrawRect( cx, cur_y, width, math.ceil( h * 0.04 ) )
			cur_y = cur_y + math.ceil( h * 0.04 )

			draw.Text{
				text = owned and ( LANG.upgrades.owned.." ✓" ) or ( LANG.upgrades.cost..": "..info.cost ),
				pos = { cx + w * 0.01, cur_y - h * 0.025 },
				font = "SCPHUDSmall",
				color = color_white,
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			}

			local dsc = clang.info
			if dsc then
				if lang.parse_description == true or clang.parse_description == true then
					if !wep.cached_description then
						wep.cached_description = {}
					end

					if !wep.cached_description[info.name] then
						wep.cached_description[info.name] = string.gsub( dsc, "%[([%w_]+)%]", info.mod )
					end

					dsc = wep.cached_description[info.name]
				end

				local height = draw.MultilineText( cx + w * 0.01, cur_y + h * 0.01, dsc, "SCPHUDSmall", nil, w * 0.28, 0, 0, TEXT_ALIGN_LEFT, nil, true )

				surface.DrawRect( cx, cur_y, width, math.ceil( height + h * 0.015 ) )

				draw.MultilineText( cx + w * 0.01, cur_y + h * 0.01, dsc, "SCPHUDSmall", color_white, w * 0.28, 0, 0, TEXT_ALIGN_LEFT )

				cur_y = cur_y + math.ceil( height + h * 0.015 )
			end

			if info.req and #info.req > 0 and !wep:UpgradeUnlocked( info.name ) then
				surface.DrawRect( cx, cur_y, width, math.ceil( h * 0.05 ) )
				cur_y = cur_y + math.ceil( h * 0.05 )

				draw.Text{
					text = ( info.reqany and LANG.upgrades.requiresany or LANG.upgrades.requiresall )..":",
					pos = { cx + w * 0.01, cur_y - h * 0.02 },
					font = "SCPHUDMedium",
					color = color_white,
					xalign = TEXT_ALIGN_LEFT,
					yalign = TEXT_ALIGN_CENTER,
				}

				for i, v in ipairs( info.req ) do
					local owned = wep:HasUpgrade( v )

					surface.DrawRect( cx, cur_y, width, math.ceil( h * 0.03 ) )
					cur_y = cur_y + math.ceil( h * 0.03 )

					draw.LimitedText{
						text = "\t"..( lang[v] and lang[v].name or v )..( owned and " ✓" or " ✗" ),
						pos = { cx + w * 0.01, cur_y - h * 0.02 },
						font = "SCPHUDSmall",
						color = owned and color_white or Color( 225, 55, 55, 255 ),
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER,
						max_width = w * 0.28
					}
				end
			end

			if info.block and #info.block > 0 and !wep:HasUpgrade( info.name ) then
				local blocked = wep:UpgradeBlocked( info.name )

				surface.DrawRect( cx, cur_y, width, math.ceil( h * 0.05 ) )
				cur_y = cur_y + math.ceil( h * 0.05 )

				draw.Text{
					text = LANG.upgrades.blocked..":",
					pos = { cx + w * 0.01, cur_y - h * 0.02 },
					font = "SCPHUDMedium",
					color = color_white,
					xalign = TEXT_ALIGN_LEFT,
					yalign = TEXT_ALIGN_CENTER,
				}

				for i, v in ipairs( info.block ) do
					surface.DrawRect( cx, cur_y, width, math.ceil( h * 0.03 ) )
					cur_y = cur_y + math.ceil( h * 0.03 )

					draw.LimitedText{
						text = "\t"..( lang[v] and lang[v].name or v ),
						pos = { cx + w * 0.01, cur_y - h * 0.02 },
						font = "SCPHUDSmall",
						color = blocked and Color( 255, 55, 55, 255 ) or color_white,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER,
						max_width = w * 0.28
					}
				end
			end

			render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
			render.SetStencilPassOperation( STENCIL_KEEP )

			surface.SetDrawColor( 150, 150, 150, 50 )
			surface.DrawRect( cx - 2, cy - 2, width + 4, math.ceil( cur_y - cy + 4 ) )

			render.SetStencilEnable( false )
		end
	end

	hook.Add( "DrawOverlay", "SCPUpgradesOverlay", drawUpgrades )

	function ShowSCPUpgrades()
		local wep = LocalPlayer():GetActiveWeapon()
		if wep.UpgradeSystemMounted then
			HUDSCPUpgradesOpen = true
			gui.EnableScreenClicker( true )
		end
	end

	function HideSCPUpgrades()
		HUDSCPUpgradesOpen = false
		gui.EnableScreenClicker( false )
	end
end