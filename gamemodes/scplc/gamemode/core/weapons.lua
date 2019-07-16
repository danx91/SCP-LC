local wep = FindMetaTable( "Weapon" )
 
local disablecall = false
function wep:CallBaseClass( func, bc, ... )
	if disablecall then return end

	if !bc then
		bc = self.BaseClass
	end

	if bc.BaseClass and bc.ClassName != bc.Base and ( !self.DeepBase or bc.ClassName != self.DeepBase ) then
		self:CallBaseClass( func, bc.BaseClass, ... )
	end

	local val = bc[func]
	if isfunction( val ) then
		disablecall = true

		local ok, err = pcall( val, self, ... )
		if !ok then
			print( "Error in CallBaseClass!" )
			print( err )
		end

		disablecall = false
	end
end

function wep:AddNetworkVar( name, type )
	if !self._NVTable then
		self._NVTable = {
			Int = { 0, 32 },
			Float = { 0, 32 },
			Bool = { 0, 32 },
			String = { 0, 4 },
			Vector = { 0, 32 },
			Angle = { 0, 32 },
			Entity = { 0, 32 }
		}
	end

	local tab = self._NVTable[type]
	assert( tab, "Unknown NetworkVar type: "..tostring( type ) )
	assert( tab[1] < tab[2], "You have already hit NetworkVar limit for type '"..tostring( type ).."' on this entity! ["..tostring( self ).."]" )

	self:NetworkVar( type, tab[1], name )
	tab[1] = tab[1] + 1
end

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