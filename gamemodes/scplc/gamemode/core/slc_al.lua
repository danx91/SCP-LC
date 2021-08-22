--[[-------------------------------------------------------------------------
SLC Auth Library
---------------------------------------------------------------------------]]
SLCAuth = {
    _LIBRARIES = {},
    //_PRIMARY_LIB = nil
    _NAMES = {}
}

function SLCAuth.RunHook( name, ignore, ... )
    if SLCAuth._PRIMARY_LIB then
        local lib = SLCAuth._LIBRARIES[SLCAuth._PRIMARY_LIB]
        if lib and lib[name] then
            local result = { lib[name]( ... ) }

            if result[1] != nil and result[1] != ignore then
                return unpack( result )
            end
        end
    end

    for k, v in pairs( SLCAuth._LIBRARIES ) do
        if v[name] then
            local result = { v[name]( ... ) }

            if result[1] != nil and result[1] != ignore then
                return unpack( result )
            end
        end
    end
end

function SLCAuth.AddLibrary( name, display, data )
    if name and display and data then
        SLCAuth._LIBRARIES[name] = data
        SLCAuth._NAMES[name] = display
    end
end

function SLCAuth.SetPrimaryLibrary( name )
    if name then
        SLCAuth.PRIMARY_LIB = name
    end
end

function SLCAuth.HasAccess( ply, access )
    if SERVER and ply:IsListenServerHost() then
        return true
    end

    local result = SLCAuth.RunHook( "CheckAccess", false, ply, access )
    if result != nil then
        return result
    end

    return false
end

function SLCAuth.RegisterAccess( access, help )
    SLCAuth.RunHook( "RegisterAccess", nil, access, help )
end

--[[-------------------------------------------------------------------------
Plaer bindings
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:SLCHasAccess( access )
    return SLCAuth.HasAccess( self, access )
end

--[[-------------------------------------------------------------------------
Default library
---------------------------------------------------------------------------]]
SLCAuth.AddLibrary( "slcal", "SLC AL", {
    CheckAccess = function( ply, access )
        return ply:IsSuperAdmin()
    end,
} )

if SERVER then
    timer.Simple( 0, function()
        SLCAuth.RegisterAccess( "slc spectatescp", "Allows player to bypass anti-ghosting system and let them spectate SCPs" )
        SLCAuth.RegisterAccess( "slc spectateinfo", "Allows player to details about player they are currently spectating" )
        SLCAuth.RegisterAccess( "slc skipintro", "Allows player to skip info screen at the start of the round" )
        SLCAuth.RegisterAccess( "slc afkdontkick", "Don't kick players with this access if they are AFK" )
        SLCAuth.RegisterAccess( "slc manageal", "Allows players change settings of SLC Auth Library" )
    end )
end

--[[-------------------------------------------------------------------------
Settings window --TODO
---------------------------------------------------------------------------]]
/*if CLIENT then
    local UpdateAuthLibrarySettings

    timer.Simple( 0, function()
        local function slcal_window( parent )

        end

		AddSettingsPanel( "slcal", function( parent )
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

			FetchAuthLibraryConfig():Then( function( data )
				if IsValid( parent ) and parent.SelectedMenuName == "slcal" then
					if IsValid( loading ) then
						loading:Remove()
					end

					slcal_window( parent )
				end
			end ):Catch( function( err )
				print( "Error while loading SLCAL config:" )
				print( err )
			end )
		end, function()
			return SLCAuth.HasAccess( LocalPlayer(), "slc manageal" )
		end )

		local fetch_promise

		function FetchAuthLibraryConfig()
			if fetch_promise and fetch_promise:GetStatus() == PROMISE_PENDING then
				fetch_promise:Reject( "Old request rejected because of new one!" ) --reject old data
			end
	
			fetch_promise = SLCPromise()
	
			net.Start( "SLCAuthLibrary" )
			net.WriteUInt( 0, 1 ) --0 fetch
			net.SendToServer()

			return fetch_promise
		end

		function UpdateAuthLibrarySettings( name, value )
			net.Start( "SLCAuthLibrary" )
			net.WriteUInt( 1, 1 ) --1 update
			net.WriteString( name )
			net.WriteString( value )
			net.SendToServer()
		end
	
		net.Receive( "SLCAuthLibrary", function( data )
			if fetch_promise and fetch_promise:GetStatus() == PROMISE_PENDING then
				fetch_promise:Resolve( data )
			end
		end )
	end )
end

if SERVER then
    net.Receive( "SLCAuthLibrary", function( len, ply )
        if SLCAuth.HasAccess( ply, "slc manageal" ) then
            
        end
    end )
end*/