if not serverguard then
	print( "# > Serverguard not found" )
	return
end

--[[-------------------------------------------------------------------------
SLC AL
---------------------------------------------------------------------------]]
SLCAuth.AddLibrary( "serverguard", "Serverguard", {
	CheckAccess = function( ply, access )
		return serverguard.player:HasPermission( ply, access )
	end,
	RegisterAccess = function( name, help )
		if CLIENT then return end
		
		serverguard.permission:Add( name )
	end,
} )

-- Force spawn human
local command = {};

command.help				= "Force spawn as Human";
command.command 			= "forcespawn_hum";
command.arguments			= {"target","class"};
command.permissions			= "scp_spawn";

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);
	local classs = string.lower(arguments[2]);
	local class
	local spawn

    if !IsValid(target) then serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Player invalid!"); return end

    if !target:IsActive() then
        serverguard.Notify(target, SERVERGUARD.NOTIFY.RED, "Player is inactive! Force spawn failed");
        return
    end

	for group_name, group in pairs( GetClassGroups() ) do
		if group_name != "SUPPORT" then
			local _, grspwn = getClassGroup( group_name )
			for k, c in pairs( group ) do
				if k == classs then
					class = c
					spawn = grspwn
					break
				end
			end
		else
			for group_name, group in pairs( group ) do
				local _, grspwn = getSupportGroup( group_name )
				for k, c in pairs( group ) do
					if k == classs then
						class = c
						spawn = grspwn
						break
					end
				end
			end
		end

		if class then
			break
		end
	end

	if (class and spawn) then

		local pos = table.Random( spawn )
		target:SetupPlayer( class, pos, true,true )

		if (!silent) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " spawned as ",SERVERGUARD.NOTIFY.GREEN,classs,SERVERGUARD.NOTIFY.WHITE," player ",SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(target));
		end;
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You entered the wrong class!");
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local kickMenu, menuOption = menu:AddSubMenu("Force spawn as human")
	
	kickMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/user.png");

	local class_names = {}
	for group_name, group in pairs( GetClassGroups() ) do
		if group_name != "SUPPORT" then
			for k, class in pairs( group ) do
				table.insert( class_names, k )
			end
		else
			for _, group in pairs( group ) do
				for k, class in pairs( group ) do
					table.insert( class_names, k )
				end
			end
		end
	end

	for k, v in pairs(class_names) do
		local option = kickMenu:AddOption(v, function()
			serverguard.command.Run("forcespawn_hum", false, player:Name(), v);
		end);
		
		option:SetImage("icon16/user.png");
	end;
end;


serverguard.command.Add(command);

-- Force spawn scp

local command = {};

command.help				= "Force spawn as SCP";
command.command 			= "forcespawn_scp";
command.arguments			= {"target","class"};
command.permissions			= "scp_spawn";

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);
	local classs = arguments[2];

    if !IsValid(target) then serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Player invalid!"); return end

	local scp_obj = GetSCP( classs )	

	if (scp_obj) then
		scp_obj:SetupPlayer( target, true )
		
		if (!silent) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " spawned as ",SERVERGUARD.NOTIFY.GREEN,classs,SERVERGUARD.NOTIFY.WHITE," player ",SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(target));
		end;
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You entered the wrong class!");
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local kickMenu, menuOption = menu:AddSubMenu("Force spawn as SCP")
	
	kickMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/user.png");

	for k, v in pairs(SCPS) do
		local option = kickMenu:AddOption(v, function()
			serverguard.command.Run("forcespawn_scp", false, player:Name(), v);
		end);
		
		option:SetImage("icon16/user.png");
	end;
end;



serverguard.command.Add(command);

-- give level

local command = {};

command.help				= "Give level";
command.command 			= "givelevel_scp";
command.arguments			= {"target","count"};
command.permissions			= "givelevel_scp";

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);
	local count = tonumber(arguments[2]);

    if !IsValid(target) then serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Player invalid!"); return end

	if isnumber( count ) then
		target:AddLevel( count )
		if (!silent) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " gived ",SERVERGUARD.NOTIFY.GREEN,tostring(arguments[2]),SERVERGUARD.NOTIFY.WHITE," to player ",SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(target));
		end;
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You entered the wrong amount!");
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local kickMenu = menu:AddOption("Give level",function()
		Derma_StringRequest("Give level", "Give level", "", function(text)
			serverguard.command.Run("givelevel_scp", false, player:Name(), text);
		end, function(text) end, "Give", "Cancel");
	end)
	
	kickMenu:SetSkin("serverguard");
	kickMenu:SetImage("icon16/user.png");
end;



serverguard.command.Add(command);

-- round restart

local command = {};

command.help				= "Restart round";
command.command 			= "rrestart";
command.arguments			= {};
command.permissions			= "restartround_scp";

function command:Execute(player, silent, arguments)
	RestartRound()
	if (!silent) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " restarted the round");
	end;
end;


serverguard.command.Add(command);

-- Explode gate A

local command = {};

command.help				= "Destroy gate A";
command.command 			= "destroygatea";
command.arguments			= {};
command.permissions			= "destroygatea";

function command:Execute(player, silent, arguments)
	ExplodeGateA()

	if (!silent) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " triggered Gate A destroy");
	end;
end;


serverguard.command.Add(command);

-- Remove player Data

local command = {};

command.help				= "Remove player data";
command.command 			= "rdata";
command.arguments			= {"target","data"};
command.permissions			= "rdata";

function command:Execute(player, silent, arguments)
    local target = util.FindPlayer(arguments[1], player);
    local atype = string.lower(arguments[2])
    if !IsValid(target) then serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Player invalid!"); return end

    if atype == "level" then
        target:SetPlayerLevel( 0 )
        rem_info( ply, target, atype, silent )
    elseif atype == "xp" then
        target:SetPlayerXP( 0 )
        rem_info( ply, target, atype, silent )
    elseif atype == "class_points" then
        target:SetClassPoints( 0 )
        rem_info( ply, target, atype, silent )
    elseif atype == "owned_classes" then
        target.PlayerInfo:Set( "unlocked_classes", {} )

        rem_info( ply, target, atype, silent )
    elseif atype == "all" then
        target:SetPlayerLevel( 0 )
        target:SetPlayerXP( 0 )
        target:SetClassPoints( 0 )
        target.PlayerInfo:Set( "unlocked_classes", {} )

        rem_info( ply, target, atype, silent )
    else
        serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Unknown type data!");
    end

	if (!silent) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " triggered Gate A destroy");
	end;
end;

local dataType = {
    ["level"] = "Level",
    ["xp"] = "XP",
    ["class_points"] = "Class points",
    ["owned_classes"] = "Owned Classes",
    ["all"] = "All",
}
function command:ContextMenu(player, menu, rankData)
	local kickMenu, menuOption = menu:AddSubMenu("Remove player Data")
	
	kickMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/user.png");

    

	for k, v in pairs(dataType) do
		local option = kickMenu:AddOption(v, function()
			serverguard.command.Run("rdata", false, player:Name(), k);
		end);
		
		option:SetImage("icon16/user.png");
	end;
end;



serverguard.command.Add(command);