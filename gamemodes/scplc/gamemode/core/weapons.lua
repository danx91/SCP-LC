local wep = FindMetaTable( "Weapon" )

--[[-------------------------------------------------------------------------
ResetViewModelBones
---------------------------------------------------------------------------]]
function wep:ResetViewModelBones()
	if CLIENT then
		local owner = self:GetOwner()

		if IsValid( owner ) then
			local vm = owner:GetViewModel()
			if IsValid( vm ) then
				vm:ResetBones()
			end
		end
	end
end

--[[-------------------------------------------------------------------------
CW 2.0 DMG Mod
---------------------------------------------------------------------------]]
local CW_WEP_DMG = {
	--pistol
	cw_fiveseven = 20,
	cw_makarov = 18,
	cw_deagle = 30,
	cw_mr96 = 45,

	--pm
	cw_mp5 = 11,
	cw_ump45 = 13,
	cw_g36c = 15,

	--rifle
	cw_scarh = 17,
	cw_m14 = 21,
	cw_ar15 = 9,
	cw_ak74 = 11.5,
	cw_l85a2 = 13,

	--pump
	cw_shorty = 8,
	cw_m3super90 = 5.5,

	--sniper
	cw_l115 = 150,
}

timer.Simple( 0, function()
	for k, v in pairs( CW_WEP_DMG ) do
		local wep_tab = weapons.GetStored( k )
		if wep_tab then
			wep_tab.Damage = v
		end
	end
end )

/*hook.Add( "PlayerCanPickupWeapon", "CW20Pickup", function( ply, wep_p )
	if string.sub( wep_p:GetClass(), 1, 3 ) == "cw_" then
		for k, v in pairs( ply:GetWeapons() ) do
			if string.sub( v:GetClass(), 1, 3 ) == "cw_" then
				return false
			end
		end
	end
end )*/

hook.Add( "SLCCanPickupWeaponClass", "CW20Pickup", function( ply, class )
	if string.sub( class, 1, 3 ) == "cw_" then
		for k, v in pairs( ply:GetWeapons() ) do
			if string.sub( v:GetClass(), 1, 3 ) == "cw_" then
				return false
			end
		end
	end
end )