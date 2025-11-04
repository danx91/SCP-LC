_Material_Original_SLC = _Material_Original_SLC or Material

local manifest_file = "slc/resource_packs.json"
local resource_manifest = {}
local resource_overrides = {}
local resource_overrides_built = {}

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function Material( name, args )
	return _Material_Original_SLC( resource_overrides_built[name] or name, args )
end

local function find_and_insert( tab, base_path, path )
	path = path or ""

	local last = string.sub( base_path, -1 )
	if last != "/" and last != "\\" then
		base_path = base_path.."/"
	end

	local files, folders = file.Find( "materials/"..base_path..path.."*", "GAME" )

	for i, v in ipairs( files ) do
		tab[path..v] = base_path..path..v
	end

	for i, v in ipairs( folders ) do
		find_and_insert( tab, base_path, path..v.."/" )
	end
end

function RegisterResourceOverride( id, data )
	if !resource_manifest[id] then
		resource_manifest[id] = {
			enabled = false,
			order = -1,
			name = data.name or id,
		}
	end

	local path = "resource_packs/"..id
	local overrides = data.overrides or {}

	resource_overrides[id] = overrides

	for k, v in pairs( overrides ) do
		if string.sub( v, 1, 1 ) != "#" then continue end
		overrides[k] = path..string.sub( v, 2 )
	end

	if data.auto then
		find_and_insert( overrides, isstring( data.auto ) and data.auto or path )
	end
end

function UpdateResourceOverride( id, enabled, order )

end

function RebuildResourceOverrides()
	resource_overrides_built = {}
	
	local order = {}
	for k, v in pairs( resource_manifest ) do
		if v.order == -1 then continue end
		table.insert( order, v.order, k ) --TODO change that
	end

	for k, v in pairs( resource_manifest ) do
		if v.order != -1 then continue end
		v.order = table.insert( order, k )
	end

	PrintTable( order )

	for i = #order, 1, -1 do
		local id = order[i]
		local tab = resource_manifest[id]

		if !tab.enabled or !resource_overrides[id] then continue end
		
		tab.order = i
		table.Merge( resource_overrides_built, resource_overrides[id] )
	end

	PrintTable( resource_overrides_built )
	SaveResourceManifest()
end

function SaveResourceManifest()
	file.Write( manifest_file, util.TableToJSON( resource_manifest, true ) )
end

--[[-------------------------------------------------------------------------
Register Setting Menu
---------------------------------------------------------------------------]]
local warned = false

hook.Add( "SLCRegisterSettings", "SLCResourcePacks", function()
	AddSettingsPanel( "resource_packs", function( parent )
		local h = ScrH()
		local marg = h * 0.03
		local padding = h * 0.01

		local header = vgui.QuickLabel( LANG.settings.panels.resource_packs, parent, TOP, "SCPHUDMedium", Color( 255, 255, 255 ) )
		header:SetContentAlignment( 5 )
		header:DockMargin( 0, 0, 0, marg )

		local container = vgui.QuickPanel( parent, TOP )
		container:DockPadding( padding, marg, padding, padding )

		container.Panels = {}

		container.Paint = function( this, pw, ph )
			surface.SetDrawColor( 175, 175, 175 )
			surface.DrawLine( 0, 0, pw, 0 )
		end

		container.PerformLayout = function( this, pw, ph )
			container:SizeToChildren( true, true )
		end

		local ordered_manifest = {}
		local max = table.Count( resource_manifest )
		for k, v in pairs( resource_manifest ) do
			table.insert( ordered_manifest, v.order, k )

			local pnl = vgui.QuickPanel( container, TOP )
			container.Panels[k] = pnl

			pnl:SetTall( h * 0.08 )
			pnl:DockMargin( 0, 0, 0, padding )
			pnl:DockPadding( padding, padding, padding, padding )
			pnl:SetZPos( v.order )

			pnl.Paint = function( this, pw, ph )
				draw.NoTexture()
				surface.SetDrawColor( 225, 255, 225 )
				surface.OutlinedRoundedRect( 0, 0, pw, ph, 16, 1 )
			end

			pnl.PerformLayout = function( this, pw, ph )
				//this.Controls:SetWide( pw * 0.2 )
				local btn_marg = ph * 0.1
				this.Down:DockMargin( btn_marg, btn_marg, 0, btn_marg )
				this.Down:SetWide( this.Down:GetTall() )

				this.Up:DockMargin( 0, btn_marg, 0, btn_marg )
				this.Up:SetWide( this.Up:GetTall() )

				this.Enabled:DockMargin( 0, ph * 0.2, pw * 0.1, ph * 0.2 )
				this.Enabled:SizeToContents()
			end

			local down = vgui.Create( "SLCButton", pnl )
			pnl.Down = down

			down:Dock( RIGHT )
			down:SetColor( Color( 145, 145, 145 ) )
			down:SetFont( "SCPHUDSmall" )
			down:SetText( "⯆", true )

			down.Think = function( this )
				this:SetEnabled( v.order < max )
			end

			down.DoClick = function( this )
				if !warned then
					warned = true
					SLCPopup( LANG.settings.panels.resource_packs, LANG.settings.resource_warn, false, nil, nil, "SCPHUDSmall" )
				end

				local other_id = ordered_manifest[v.order + 1]
				local other = resource_manifest[other_id]

				other.order = v.order
				v.order = v.order + 1

				ordered_manifest[v.order] = k
				ordered_manifest[other.order] = other_id

				container.Panels[k]:SetZPos( v.order )
				container.Panels[other_id]:SetZPos( other.order )

				SaveResourceManifest()
			end

			local up = vgui.Create( "SLCButton", pnl )
			pnl.Up = up

			up:Dock( RIGHT )
			up:SetColor( Color( 145, 145, 145 ) )
			up:SetFont( "SCPHUDSmall" )
			up:SetText( "⯅", true )

			up.Think = function( this )
				this:SetEnabled( v.order > 1 )
			end

			up.DoClick = function( this )
				if !warned then
					warned = true
					SLCPopup( LANG.settings.panels.resource_packs, LANG.settings.resource_warn, false, nil, nil, "SCPHUDSmall" )
				end

				local other_id = ordered_manifest[v.order - 1]
				local other = resource_manifest[other_id]

				other.order = v.order
				v.order = v.order - 1

				ordered_manifest[v.order] = k
				ordered_manifest[other.order] = other_id

				container.Panels[k]:SetZPos( v.order )
				container.Panels[other_id]:SetZPos( other.order )

				SaveResourceManifest()
			end

			local enabled = vgui.Create( "SLCCheckbox", pnl )
			pnl.Enabled = enabled

			enabled:Dock( RIGHT )
			enabled:SetFont( "SCPHUDSmall" )
			enabled:SetText( LANG.settings.enabled )
			enabled:SetState( v.enabled )

			enabled.OnUpdate = function( this, val )
				if !warned then
					warned = true
					SLCPopup( LANG.settings.panels.resource_packs, LANG.settings.resource_warn, false, nil, nil, "SCPHUDSmall" )
				end

				v.enabled = val

				SaveResourceManifest()
			end

			local name = vgui.QuickLabel( v.name, pnl, FILL, "SCPHUDSmall" )
			pnl.Name = name
		end

	end, true, 4000 )
end )

--[[-------------------------------------------------------------------------
Load Resource Overrides
---------------------------------------------------------------------------]]
local manifest = file.Read( manifest_file, "DATA" )

if manifest then
	resource_manifest = util.JSONToTable( manifest ) or {}
end

local path = "data_static/slc/resource_packs/"

print( "  > Loading Resource Packs" )

for i, v in ipairs( file.Find( path.."*.json", "GAME" ) ) do
	Msg( "    > Loading: "..v )
	local f = file.Read( path..""..v, "GAME" )
	if !f then
		print( " : FAIL - Failed to read a file!" )
		continue
	end

	local tab = util.JSONToTable( f )
	if !tab then
		print( " : FAIL - Invalid JSON!" )
		continue
	end

	print( " : OK - Loaded!" )
	RegisterResourceOverride( string.sub( v, 1, -6 ), tab )
end

print( "  > Building Resource Packs" )
RebuildResourceOverrides()