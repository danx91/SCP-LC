--[[-------------------------------------------------------------------------
GM Hooks
---------------------------------------------------------------------------]]
function GM:HUDDrawPickupHistory()

end

function GM:HUDWeaponPickedUp( weapon )
	UpdatePlayerEQ()
end

function GM:HUDItemPickedUp( item )
	
end

function GM:HUDAmmoPickedUp( item, amount )

end

--[[-------------------------------------------------------------------------
Actions
---------------------------------------------------------------------------]]
local cmd_func = function( this, cmd )
	slc_cmd.Run( cmd )
	this.cooldown = slc_cmd.GetPlayerCooldown( LocalPlayer(), cmd )
	this.cd_time = slc_cmd.GetCommandCooldown( cmd )
end

EQ_ACTIONS = {
	{
		name = "escort",
		material = GetMaterial( "slc/hud/escort.png", "smooth" ),
		can_see = function()
			return SCPTeams.CanEscort( LocalPlayer():SCPTeam(), true )
		end,
		callback = cmd_func,
		args = "slc_escort"
	},
	{
		name = "gatea",
		material = GetMaterial( "slc/hud/explosion.png", "smooth" ),
		can_see = function()
			local class_data = GetClassData( LocalPlayer():SCPClass() )
			return class_data and class_data.support
		end,
		callback = cmd_func,
		args = "slc_destroy_gatea"
	},
}

--[[-------------------------------------------------------------------------
Global stuff
---------------------------------------------------------------------------]]
INVENTORY_TEXTURES_OVERRIDE = {
	weapon_stunstick = { SelectFont = "SCPHLIcons", IconLetter = "n" },
	weapon_crowbar = { SelectFont = "SCPHLIcons", IconLetter = "c" }
}

INVENTORY_FONTS_OVERRIDE = {
	CW_SelectIcons = "SCPCSSIcons",
}

INVENTORY = INVENTORY or {}
local sync_tmp = {}

function UpdatePlayerEQ()
	local ply = LocalPlayer()
	local weps = ply:GetWeapons()
	local lookup_weps = CreateLookupTable( weps )
	local backpack = ply:GetWeapon( "item_slc_backpack" )
	local bp_size = IsValid( backpack ) and backpack.GetSize and backpack:GetSize() or 0

	//Remove weapon from local inventory if they are missing from player inventory
	for k, v in pairs( INVENTORY ) do
		if !IsValid( v ) or !lookup_weps[v] /*or v:GetClass() == "item_slc_id" or v:IsDerived( "item_slc_holster" )*/ then
			//print( "REM WEP", k, v )
			INVENTORY[k] = nil
		end
	end

	local lookup_tab = CreateLookupTable( INVENTORY )

	//Add new weapons to local inventory
	for i, v in ipairs( weps ) do
		local class = v:GetClass()
		if lookup_tab[v] or v:IsScripted() and ( !v.ClassName or class == "item_slc_id" or v:IsDerived( "item_slc_holster" ) ) then continue end

		local target = 0
		local sync_slot = sync_tmp[class]

		if sync_slot then
			//Respect SV sync in the first place
			target = sync_slot
			sync_tmp[class] = nil
		else
			//Find first empty slot in EQ
			for j = 1, 6 + bp_size do
				if !INVENTORY[j] then
					target = j
					break
				end
			end
		end

		//Add if empty slot is found
		if target > 0 then
			INVENTORY[target] = v
			v.eq_slot = target
			//print( "ADD WEP EQ", target, v )
		else
			error( "Too many items! "..#weps.."/"..6 + bp_size )
		end
	end
end

function CanShowEQ()
	if ScoreboardVisible then return false end

	local ply = LocalPlayer()
	local team = ply:SCPTeam()
	return team != TEAM_SPEC or ply:GetAdminMode()
end

function GetLocalInventory()
	return INVENTORY
end

function OpenBackpack()
	local bp = LocalPlayer():GetWeapon( "item_slc_backpack" )
	if !IsValid( bp ) then return end
	if !RunGUISkinFunction( "eq", "is_visible" ) then return end
	
	RunGUISkinFunction( "eq", "open_backpack" )
end

net.Receive( "SLCMoveItem", function( len )
	print( "Inventory out of sync!" )
	local ply = LocalPlayer()
	INVENTORY = {}

	for k, v in pairs( net.ReadTable() ) do
		local wep = ply:GetWeapon( v )
		if IsValid( wep ) then
			INVENTORY[k] = wep
			wep.eq_slot = k
		else
			sync_tmp[v] = k
		end
	end
end )

hook.Add( "SLCPlayerCleanup", "SLCEQ", function( ply )
	if ply != LocalPlayer() then return end

	INVENTORY = {}
end )

hook.Add( "SLCRegisterSettings", "SLCEQ", function()
	RegisterSettingsEntry( "eq_instant_desc", "switch", false, nil, "hud_config" )
end )