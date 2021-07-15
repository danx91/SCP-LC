AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

timer.Simple(0,function()

    http.Fetch("https://raw.githubusercontent.com/danx91/SCP-LC/master/gamemodes/scplc/gamemode/modules/sh_module.lua",function(data)

        if string.find( data, [[VERSION = "BETA 0.7.2"]] ) then
            print("[SCP:LC] You using lasted version!")
        else
            print("[SCP:LC] Your version is outdated update your gamemode in workshop or github (https://github.com/danx91/SCP-LC)")
        end
    
    end)

end)