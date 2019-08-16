local wep = FindMetaTable( "Weapon" )


--[[-------------------------------------------------------------------------
CW 2.0 DMG Mod
---------------------------------------------------------------------------]]
local CW_WEP_DMG = {
	cw_fiveseven = 20,
	cw_deagle = 30,
	cw_mp5 = 10,
	cw_ump45 = 12.5,
	cw_g36c = 15,
	cw_scarh = 17,
	cw_m14 = 19,
	cw_ar15 = 8,
	cw_ak74 = 11,
	cw_l115 = 90,
	cw_shorty = 5,
	cw_m3super90 = 3,
}

timer.Simple( 0, function()
	for k, v in pairs( CW_WEP_DMG ) do
		local wep_tab = weapons.GetStored( k )
		wep_tab.Damage = v
	end
end )

hook.Add( "PlayerCanPickupWeapon", "CW20Pickup", function( ply, wep )
	if string.sub( wep:GetClass(), 1, 3 ) == "cw_" then
		for k, v in pairs( ply:GetWeapons() ) do
			if string.sub( v:GetClass(), 1, 3 ) == "cw_" then
				return false
			end
		end
	end
end )