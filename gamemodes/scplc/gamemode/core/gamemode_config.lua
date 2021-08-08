SLCGamemodeConfig = {}

function AddGamemodeConfig( name, category, value, help, min, max, check )
	local v_type = type( value )
	min = tonumber( min ) 
	max = tonumber( max ) 

	local help_text = ( help or "No help provided" ).."\n\nDefault: "..value.."\nType: "..( v_type == "number" and "number" or "string" )

	if min then
		help_text = help_text.."\n".."Minimum value: "..min
	end

	if max then
		help_text = help_text.."\n".."Maximum value: "..max
	end

	SLCGamemodeConfig[name] = {
		category = category,
		value = value,
		default = value,
		value_type = v_type,
		min = min,
		max = max,
		help = help_text,
		custom_check = check,
	}
end

CVAR = {}
CVAR_DEFAULT = {}

function SLCCVar( name, category, value, flags, help, min, max, valid_check )
	local cv

	if SERVER or table.HasValue( flags, FCVAR_REPLICATED ) then
		cv = CreateConVar( name, value, flags, help, min, max )
		CVAR[name] = cv
		CVAR_DEFAULT[name] = value
	end

	if CLIENT then
		AddGamemodeConfig( name, category, value, help, min, max, valid_check )
	end

	return cv
end

hook.Add( "SLCFactoryReset", "SLCResetConvars", function()
	if SERVER then
		for k, v in pairs( CVAR ) do
			local default = CVAR_DEFAULT[k]
			if default then
				v:SetString( default )
			end
		end
	end
end)

--[[-------------------------------------------------------------------------
Options window
---------------------------------------------------------------------------]]
if CLIENT then
	local UpdateGamemodeConfig

	local COLOR = {
		white = Color( 255, 255, 255, 255 ),
		hover = Color( 75, 75, 75, 255 ),
		inactive = Color( 125, 125, 125, 255 ),
		selected_text = Color( 255, 255, 255, 50 ),
		error = Color( 225, 50, 50, 255 ),
	}

	local MATS = {
		reset = Material( "slc/hud/refresh.png", "smooth" ),
		apply = Material( "slc/hud/accept.png", "smooth" ),
		exit = Material( "slc/hud/exit.png", "smooth" ),
	}

	local settings_data = {}

	local function BuildSettingsTree()
		settings_data = {}

		local primary_categories = {}
		local secondary_categories = {}

		for k, v in pairs( SLCGamemodeConfig ) do
			local istab = type( v.category ) == "table"
			local primary = istab and v.category[1] or v.category

			if !primary_categories[primary] then
				primary_categories[primary] = {}
			end

			table.insert( primary_categories[primary], k )

			if istab then
				local len = #v.category
				if len > 1 then
					for i = 2, len do
						local category = v.category[i]
						if !secondary_categories[category] then
							secondary_categories[category] = {}
						end

						table.insert( secondary_categories[category], k )
					end
				end
			end
		end

		for k, v in pairs( secondary_categories ) do
			local tab = primary_categories[k]
			if tab then
				for i, item in ipairs( v ) do
					table.insert( tab, item )
				end
			else
				primary_categories[k] = v
			end
		end

		for k, v in pairs( primary_categories ) do
			table.insert( settings_data, {
				name = k, 
				items = v
			} )
		end
	end

	local function settings_window( parent )
		local w, h = ScrW(), ScrH()

		local panel_margin = w * 0.005
		local items_margin = w * 0.01
		local item_padding = h * 0.0075

		local function refresh_text_boxes()
			for _, child in pairs( parent:GetCanvas():GetChildren() ) do
				if child.RefreshAllTextBoxes then
					child:RefreshAllTextBoxes()
				end
			end
		end

		for i, v in ipairs( settings_data ) do
			local pnl = vgui.Create( "DPanel", parent )
			pnl:Dock( TOP )
			pnl:DockMargin( panel_margin, panel_margin, 0, panel_margin )

			pnl.PerformLayout = function( self )
				self:SizeToChildren( false, true )
			end

			pnl.Paint = function( self, pw, ph ) end

			pnl.RefreshAllTextBoxes = function( self )
				for _, item in pairs( self.items:GetChildren() ) do
					item.text_box:RefreshValue()
				end
			end

			local controls = vgui.Create( "DPanel", pnl )
			controls:SetTall( h * 0.05 )
			controls:Dock( TOP )

			controls.Paint = function( self, pw, ph )
				surface.SetDrawColor( COLOR.white )
				surface.DrawOutlinedRect( 0, 0, pw, ph )

				draw.Text{
					text = "---   "..( LANG.gamemode_config.categories[v.name] or v.name ).."   ---",
					pos = { pw * 0.5, ph * 0.5 },
					font = "SCPHUDMedium",
					color = COLOR.white,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			end

			controls.OnMousePressed = function( self, key )
				if key == MOUSE_LEFT then
					local items = pnl.items

					if items:IsVisible() then
						items:Hide()
					else
						items:Show()
						self:GetParent():RefreshAllTextBoxes()
					end

					pnl:InvalidateLayout()
				end
			end

			local items = vgui.Create( "DPanel", pnl )
			items:SetTall( 0 )
			items:Dock( TOP )
			items:DockMargin( items_margin, 0, items_margin, 0 )

			items.Paint = function( self, pw, ph )
				if self:GetTall() > 0 then
					surface.SetDrawColor( COLOR.white )
					surface.DrawLine( 0, ph - 1, pw, ph - 1 )
				end
			end

			items.PerformLayout = function( self )
				self:SizeToChildren( false, true )
				//self:SetTall( self:GetTall() + h * 0.05 )
			end

			items:Hide()
			pnl.items = items

			for _, item in ipairs( v.items ) do
				local data = SLCGamemodeConfig[item]

				local item_pnl = vgui.Create( "DPanel", items )
				item_pnl:SetTall( h * 0.07 )
				item_pnl:Dock( TOP )
				//item_pnl:DockMargin( 0, h * 0.01, 0, 0 )
				item_pnl:DockPadding( item_padding, item_padding, item_padding, item_padding )

				item_pnl.Paint = function( self, pw, ph ) end	

				local text_box
				local reset_btn = vgui.Create( "DButton", item_pnl )
				reset_btn:Dock( RIGHT )
				reset_btn:SetText( "" )

				reset_btn.PerformLayout = function( self )
					self:SetWide( self:GetTall() )
				end

				reset_btn.Paint = function( self, pw, ph )
					local enabled = self:IsEnabled()

					if enabled and self:IsHovered() then
						surface.SetDrawColor( COLOR.hover )
						surface.DrawRect( 0, 0, pw, ph )
					end

					surface.SetDrawColor( COLOR.white )
					surface.DrawOutlinedRect( 0, 0, pw, ph )

					if !enabled then
						surface.SetDrawColor( COLOR.inactive )
					end

					local ico_size = pw * 0.5
					surface.SetMaterial( MATS.reset )
					surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
				end

				reset_btn.DoClick = function( self )
					UpdateGamemodeConfig( item, data.default )

					data.value = data.default

					text_box:SetValue( data.default )
					text_box:OnChange()

					refresh_text_boxes()
				end

				local rb_enabled = reset_btn.SetEnabled
				reset_btn.SetEnabled = function( self, enabled )
					self:SetCursor( enabled and "hand" or "arrow" )
					rb_enabled( self, enabled )
				end

				reset_btn:SetEnabled( data.value != data.default )

				local discard_btn = vgui.Create( "DButton", item_pnl )
				discard_btn:Dock( RIGHT )
				discard_btn:DockMargin( 0, 0, item_padding, 0 )
				discard_btn:SetText( "" )

				discard_btn.PerformLayout = function( self )
					self:SetWide( self:GetTall() )
				end

				discard_btn.Paint = function( self, pw, ph )
					local enabled = self:IsEnabled()

					if enabled and self:IsHovered() then
						surface.SetDrawColor( COLOR.hover )
						surface.DrawRect( 0, 0, pw, ph )
					end

					surface.SetDrawColor( COLOR.white )
					surface.DrawOutlinedRect( 0, 0, pw, ph )

					if !enabled then
						surface.SetDrawColor( COLOR.inactive )
					end

					local ico_size = pw * 0.5
					surface.SetMaterial( MATS.exit )
					surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
				end

				discard_btn.DoClick = function( self )
					text_box:SetValue( data.value )
					text_box:OnChange()
				end

				local db_enabled = discard_btn.SetEnabled
				discard_btn.SetEnabled = function( self, enabled )
					self:SetCursor( enabled and "hand" or "arrow" )
					db_enabled( self, enabled )
				end

				discard_btn:SetEnabled( false )

				local apply_btn = vgui.Create( "DButton", item_pnl )
				apply_btn:Dock( RIGHT )
				apply_btn:DockMargin( 0, 0, item_padding, 0 )
				apply_btn:SetText( "" )

				apply_btn.PerformLayout = function( self )
					self:SetWide( self:GetTall() )
				end

				apply_btn.Paint = function( self, pw, ph )
					local enabled = self:IsEnabled()

					if enabled and self:IsHovered() then
						surface.SetDrawColor( COLOR.hover )
						surface.DrawRect( 0, 0, pw, ph )
					end

					surface.SetDrawColor( COLOR.white )
					surface.DrawOutlinedRect( 0, 0, pw, ph )

					if !enabled then
						surface.SetDrawColor( COLOR.inactive )
					end

					local ico_size = pw * 0.5
					surface.SetMaterial( MATS.apply )
					surface.DrawTexturedRect( pw * 0.5 - ico_size * 0.5, ph * 0.5 - ico_size * 0.5, ico_size, ico_size )
				end

				apply_btn.DoClick = function( self )
					local value = text_box:GetValue()

					if data.value_type == "number" then
						value = tonumber( value )
					end

					UpdateGamemodeConfig( item, value )

					data.value = value

					text_box:OnChange()
					refresh_text_boxes()
				end

				local ab_enabled = apply_btn.SetEnabled
				apply_btn.SetEnabled = function( self, enabled )
					self:SetCursor( enabled and "hand" or "arrow" )
					ab_enabled( self, enabled )
				end

				apply_btn:SetEnabled( false )

				text_box = vgui.Create( "DTextEntry", item_pnl )
				text_box:SetWide( w * 0.225 )
				text_box:Dock( RIGHT )
				text_box:DockMargin( 0, 0, item_padding, 0 )
				text_box:SetValue( tostring( data.value ) )

				text_box:SetFont( "SCPHUDSmall" )
				text_box:SetTooltip( data.help )

				text_box.has_error = false

				text_box.Paint = function( self, pw, ph )
					surface.SetDrawColor( COLOR.white )
					surface.DrawOutlinedRect( 0, 0, pw, ph )

					self:DrawTextEntryText( self.has_error and COLOR.error or COLOR.white, COLOR.selected_text, COLOR.white )
				end

				text_box.OnChange = function( self )
					local value = self:GetValue()
					local num = data.value_type == "number"

					if num then
						value = tonumber( value )
					end

					apply_btn:SetEnabled( value != data.value )
					discard_btn:SetEnabled( value != data.value )
					reset_btn:SetEnabled( data.value != data.default )
					

					if data.custom_check then
						//print( "has check", data.custom_check, value, type(value), data.custom_check( value ) )
						self.has_error = !data.custom_check( value ) or num and ( data.min and value < data.min or data.max and value > data.max )

						if self.has_error then
							apply_btn:SetEnabled( false )
						end
					end
				end

				text_box.RefreshValue = function( self )
					self:SetValue( data.value )
					self:OnChange()
				end

				item_pnl.text_box = text_box

				local name = vgui.Create( "DLabel", item_pnl )
				name:Dock( FILL )
				name:DockMargin( 0, 0, item_padding, 0 )
				name:SetText( "" )

				name.Paint = function( self, pw, ph )
					draw.Text{
						text = item,
						pos = { 0, ph * 0.5 },
						font = "SCPHUDSmall",
						color = COLOR.white,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER,
					}
				end
			end
		end
	end

	timer.Simple( 0, function()
		AddSettingsPanel( "cvars", function( parent )
			local h = ScrH()

			local loading = vgui.Create( "DPanel", parent )
			loading:SetTall( h * 0.2 )
			loading:Dock( TOP )

			loading.Paint = function( self, pw, ph )
				draw.Text{
					text = LANG.gamemode_config.loading,
					pos = { pw * 0.5, ph * 0.5 },
					font = "SCPHUDVBig",
					color = COLOR.white,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}
			end

			FetchGamemodeConfig():Then( function( data )
				if IsValid( parent ) and parent.SelectedMenuName == "cvars" then
					if IsValid( loading ) then
						loading:Remove()
					end

					for k, v in pairs( data ) do
						local tab = SLCGamemodeConfig[k]
						if tab then
							if tab.value_type == "number" then
								v = tonumber( v )
							end

							tab.value = v
						end
					end

					BuildSettingsTree()
					settings_window( parent )
				end
			end ):Catch( function( err )
				print( "Error while loading gamemode config:" )
				print( err )
			end )
		end, function()
			return SLCAuth.HasAccess( LocalPlayer(), "slc gamemodeconfig" )
		end )

		local fetch_promise

		function FetchGamemodeConfig()
			if fetch_promise and fetch_promise:GetStatus() == PROMISE_PENDING then
				fetch_promise:Reject( "Old request rejected because of new one!" ) --reject old data
			end
	
			fetch_promise = Promise()
	
			net.Start( "SLCGamemodeConfig" )
			net.WriteUInt( 0, 1 ) --0 fetch
			net.SendToServer()

			return fetch_promise
		end

		function UpdateGamemodeConfig( name, value )
			net.Start( "SLCGamemodeConfig" )
			net.WriteUInt( 1, 1 ) --1 update
			net.WriteString( name )
			net.WriteString( value )
			net.SendToServer()
		end
	
		net.ReceiveTable( "SLCGamemodeConfig", function( data )
			if fetch_promise and fetch_promise:GetStatus() == PROMISE_PENDING then
				fetch_promise:Resolve( data )
			end
		end )
	end )
end

if SERVER then
	timer.Simple( 0, function()
		net.AddTableChannel( "SLCGamemodeConfig" )

		net.Receive( "SLCGamemodeConfig", function( len, ply )
			if SLCAuth.HasAccess( ply, "slc gamemodeconfig" ) then
				local op = net.ReadUInt( 1 )
				if op == 0 then
					local tab = {}

					for k, v in pairs( CVAR ) do
						tab[k] = v:GetString() --get string, net.SendTable uses JSON so all values that can be converted to number, will be converted later
					end

					net.SendTable( "SLCGamemodeConfig", tab, ply, false, true )
				else
					local name = net.ReadString()
					local cvar = CVAR[name]
					if cvar then
						local value = net.ReadString()
						local old = cvar:GetString()
						cvar:SetString( value )

						print( "Server ConVar '"..name.."' has been changed by: "..ply:Nick().." ("..ply:SteamID()..") - Value: "..old.." -> "..value )
					end
				end
			end
		end )
	end )
end