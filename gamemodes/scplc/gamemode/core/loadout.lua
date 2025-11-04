SLC_WEAPONS_REG = {}
SLC_OTHER_WEAPONS_REG = SLC_OTHER_WEAPONS_REG or {}
SLC_LOADOUTS = {}

/*
data = {
	class = <string>,
	ammo = <number>,

}
*/


--[[---------------------------------------------------------------------------
MarkAsWeapon( class )

Marks SWEP as weapon

@param		[type]			class				Weapon class

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function MarkAsWeapon( class )
	SLC_OTHER_WEAPONS_REG[class] = true
end


--[[---------------------------------------------------------------------------
AddWeaponLoadout( weapon_class, ammo, ... )

Adds SWEP to multiple loadouts

@param		[string]			weapon_class		Class of weapon
@param		[number]			ammo				Default number of mags
@param		[string(s)]			...					Loadout names

@return		[nil]				-					-
---------------------------------------------------------------------------]]--
function AddWeaponLoadout( weapon_class, ammo, ... )
	local tab = {
		class = weapon_class,
		ammo = ammo,
		weight = false,
	}

	if SLC_GLOBAL_LOADOUT then
		if !SLC_LOADOUTS[SLC_GLOBAL_LOADOUT] then
			SLC_LOADOUTS[SLC_GLOBAL_LOADOUT] = { _total = 0 }
		end

		table.insert( SLC_LOADOUTS[SLC_GLOBAL_LOADOUT], tab )
	end

	for k, v in pairs( { ... } ) do
		if !SLC_LOADOUTS[v] then
			SLC_LOADOUTS[v] = { _total = 0 }
		end

		table.insert( SLC_LOADOUTS[v], tab )
	end
end


--[[---------------------------------------------------------------------------
AddLoadoutWeapon( class, ammo, ... )

Adds multiple SWEPs to loadout

@param		[string]			loadout				Loadout name
@param		[number]			ammo				Default number of mags
@param		[string(s)]			...					SWEP names

@return		[nil]				-					-
---------------------------------------------------------------------------]]--
function AddLoadoutWeapon( loadout, ammo, ... )
	local lo = SLC_LOADOUTS[loadout]
	if !lo then
		lo = { _total = 0 }
		SLC_LOADOUTS[loadout] = lo
	end

	for k, v in pairs( { ... } ) do
		local c, w = string.match( v, "^(.+):(%d+)$" )
		w = w and tonumber( w )

		if !c or !w then
			c = v
			w = false
		else
			lo._total = lo._total + w
		end

		table.insert( lo, {
			class = c,
			ammo = ammo,
			weight = w
		} )
	end
end


--[[---------------------------------------------------------------------------
RemoveLoadout( name, class )

Removed weapon class from loadout

@param		[type]			name				Loadout name
@param		[type]			class				Weapon class

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function RemoveLoadout( name, class )
	local lo = SLC_LOADOUTS[name]
	if !lo then return end

	if !class then
		SLC_LOADOUTS[name] = nil
		return
	end

	for i, v in rpairs( lo ) do
		if v.class == class then
			table.remove( lo, i )

			if v.weight then
				lo._total = lo._total - v.weight
			end
		end
	end
end

--[[---------------------------------------------------------------------------
GetLoadout( name )

Gets loadout table

@param		[string]			name				Loadout name

@return		[table]				-					Loadout table
---------------------------------------------------------------------------]]--
function GetLoadout( name )
	return SLC_LOADOUTS[name]
end


--[[---------------------------------------------------------------------------
GetLoadoutWeapon( name, use_weights )

Get random weapon from loadout.
If use_weights is nil or false (or no weapon in loadout has weight assigned), a random selection is made among all weapons.
If use_weights is true, a weighted random selection is made only among weapons with weights.

@param		[string]			name				Loadout name
@param		[boolean]			use_weights			Should weighted probability be used if possible?

@return		[string, number]	-					Selected weapon class and default mags
---------------------------------------------------------------------------]]--
function GetLoadoutWeapon( name, use_weights )
	local lo = SLC_LOADOUTS[name]
	if !lo then return end

	if lo._total == 0 then
		use_weights = false
	end

	local tab
	if use_weights then
		local dice = SLCRandom( lo._total )
		local total = 0

		for i, v in ipairs( lo ) do
			if !v.weight then continue end

			total = total + v.weight
			if total >= dice then
				tab = v
				break
			end
		end
	else
		tab = lo[SLCRandom( #lo )]
	end

	if !tab then return end

	local other = string.match( tab.class, "^loadout:(.+)$" )
	if other then
		local class, ammo = GetLoadoutWeapon( other, use_weights )
		if class then
			return class, ammo
		end
	end

	return tab.class, tab.ammo
end

if hook.Run( "SLCLoadout" ) then return end

--[[-------------------------------------------------------------------------
CW 2.0
---------------------------------------------------------------------------]]
hook.Add( "SLCCanPickupWeaponClass", "SLCCW20Pickup", function( ply, class )
	if !SLC_WEAPONS_REG[class] then return end

	for k, v in pairs( ply:GetWeapons() ) do
		if SLC_WEAPONS_REG[v:GetClass()] then
			return false, "one_weapon"
		end
	end
end )

hook.Add( "SLCCanUseBind", "SLCCW20Binds", function( bind )
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid( wep ) and wep.CW20Weapon and wep.dt.State == CW_CUSTOMIZE then
		return false
	end
end )

/*local sniper_nerf = {
	
}*/

hook.Add( "EntityTakeDamage", "SLCCWSniperReductionForIdiots", function( ent, dmg )
	local ent_class = ent:GetClass()
	if ent_class == "cw_ammo_kit_regular" or ent_class == "cw_ammo_kit_small" then return true end

	/*local att = dmg:GetAttacker()
	if !IsValid( att ) then return end

	local att_class = att:GetClass()
	if string.match( att_class, "_thrown$" ) then return true end*/

	/*if !att:IsPlayer() or att == ent or !dmg:IsBulletDamage() then return end

	local pwep = att:GetActiveWeapon()
	if !IsValid( pwep ) then return end

	local wep_class = pwep:GetClass()
	if sniper_nerf[wep_class] then
		local dist = ent:GetPos():Distance( att:GetPos() )
		if dist < 1500 then
			dmg:ScaleDamage( math.Clamp( dist / 1500, 0.25, 1 ) )
		end
	end*/
end )

/*local att_remap = {
	[1] = "Sight",
	[2] = "Barrel",
	[3] = "Receiver",
	[4] = "Handguard",
	[5] = "Magazine",
	[6] = "Stock",
	[7] = "Rail",
	["+reload"] = "Ammo",
}*/

local global_remove = {}
local precache_list_cw = {}

local function add_cw_weapon( class, stats, ... )
	local noreg, rem, func, ammo
	local args = { ... }

	if type( args[1] ) == "boolean" then noreg = table.remove( args, 1 ) end
	if type( args[1] ) == "table" then rem = table.remove( args, 1 ) end
	if type( args[1] ) == "function" then func = table.remove( args, 1 ) end
	if type( args[1] ) == "number" then ammo = table.remove( args, 1 ) end

	if !noreg then
		SLC_WEAPONS_REG[class] = true
	end

	if #args > 0 then
		AddWeaponLoadout( class, ammo, unpack( args ) )
	end

	local wep_tab = weapons.GetStored( class )
	if !wep_tab then return end

	wep_tab.PenetrationPower = 100
	wep_tab.PenetrationPower_Flat = 0
	wep_tab.ImpactPower = 1
	wep_tab.NoFreeAim = true
	wep_tab.CanRicochet = false
	wep_tab.CanPenetrate = false
	wep_tab.CW_KK_MELEE = function() end

	if isstring( wep_tab.WorldModel ) then
		table.insert( precache_list_cw, wep_tab.WorldModel )
	end

	if isstring( wep_tab.ViewModel ) then
		table.insert( precache_list_cw, wep_tab.ViewModel )
	end

	wep_tab.SelectFont = "SCPCSSIcons"
	wep_tab.SelectIcon = nil

	if wep_tab.Primary and wep_tab.Primary.ClipSize then
		wep_tab.Primary.DefaultClip = wep_tab.Primary.ClipSize
	end

	for k, v in pairs( stats ) do
		wep_tab[k] = v
	end

	if func then
		func( wep_tab )
	end

	rem = rem or {}
	local rem_lookup = {}

	for i, v in ipairs( rem ) do
		rem_lookup[v] = true
	end

	if !wep_tab.Attachments then return end

	for button, category in pairs( wep_tab.Attachments ) do
		if !category.atts then continue end

		for i, elem in rpairs( category.atts ) do
			if !rem[elem] and !rem_lookup[elem] and !global_remove[elem] then continue end

			if isstring( rem[elem] ) then
				category.atts[i] = rem[elem]
			else
				table.remove( category.atts, i )
			end
		end

		/*if #category.atts == 0 then
			wep_tab.Attachments[button] = nil
		end*/
	end
end

hook.Add( "SLCPrecache", "PrecacheCWWeapons", function( p_list )
	local start = #p_list
	for i, v in ipairs( precache_list_cw ) do
		p_list[start + i] = v
	end
end )

/*
wep_tab.CustomizationMenuScale
wep_tab.Damage
wep_tab.Shots
wep_tab.FireDelay
wep_tab.Recoil
wep_tab.HipSpread
wep_tab.AimSpread
wep_tab.ClumpSpread
wep_tab.RecoilToSpread
wep_tab.SpreadPerShot
wep_tab.SpreadCooldown
wep_tab.MaxSpreadInc
wep_tab.InsertShellTime
*/

hook.Add( "SLCGamemodeLoaded", "SLCCWStuff", function()
	local cw_base = weapons.GetStored( "cw_base" )
	local ins_base = weapons.GetStored( "cw_kk_ins2_base_main" )
	local ammo_base = scripted_ents.GetStored( "cw_ammo_ent_base" ).t

	--[[-------------------------------------------------------------------------
	Customization
	---------------------------------------------------------------------------]]
	/*CustomizableWeaponry.callbacks:addNew( "disableInteractionMenu", "SCPLCCanCustomize", function( wep )
	
	end )*/

	--[[-------------------------------------------------------------------------
	Fix CW 2.0 exploits (some at least...)
	---------------------------------------------------------------------------]]
	ins_base._OriginalThink = ins_base._OriginalThink or ins_base.Think
	function ins_base:Think()
		self:_OriginalThink()

		--[[-------------------------------------------------------------------------
		Cooldown skip sprint exploit
		---------------------------------------------------------------------------]]
		local ct = CurTime()
		if self.dt.State == CW_RUNNING and ( self:GetNextPrimaryFire() > ct or self:GetNextSecondaryFire() > ct ) then
			self.dt.State = CW_IDLE
		end
	end

	--[[-------------------------------------------------------------------------
	Fix some NULL entities...
	---------------------------------------------------------------------------]]
	cw_base._OriginalPlayAnim = cw_base._OriginalPlayAnim or cw_base.playAnim
	function cw_base:playAnim( anim, speed, cycle, ent )
		if !IsValid( ent or self.CW_VM ) then return end

		return self:_OriginalPlayAnim( anim, speed, cycle, ent )
	end

	cw_base._OriginalGetTracerOrigin = cw_base._OriginalGetTracerOrigin or cw_base.GetTracerOrigin
	function cw_base:GetTracerOrigin()
		if !IsValid( self ) then return end

		return self:_OriginalGetTracerOrigin()
	end

	cw_base._OriginalPerformViewmodelMovement = cw_base._OriginalPerformViewmodelMovement or cw_base.performViewmodelMovement
	function cw_base:performViewmodelMovement()
		if !IsValid( self.CW_VM ) then return end
		self:_OriginalPerformViewmodelMovement()
	end

	--[[-------------------------------------------------------------------------
	Don't let players pick up grenades from ammo box
	---------------------------------------------------------------------------]]
	ammo_base._OriginalUse = ammo_base._OriginalUse or ammo_base.Use
	function ammo_base:Use( activator, caller )
		if !activator:IsPlayer() or !activator:Alive() then return end

		local wep = activator:GetActiveWeapon()
		if !IsValid( wep ) or wep.Base == "cw_kk_ins2_base_nade" then return end

		self:_OriginalUse( activator, caller )
	end

	--[[-------------------------------------------------------------------------
	Disable some features
	---------------------------------------------------------------------------]]
	CustomizableWeaponry.quickGrenade.enabled = false
	concommand.Remove( "cw_dropweapon" )
	concommand.Remove( "cw_kk_melee" )

	--[[-------------------------------------------------------------------------
	Fix khr attachments
	---------------------------------------------------------------------------]]
	CustomizableWeaponry.originalValue:add( "DamageFallOff", true )
	CustomizableWeaponry.originalValue:add( "EffectiveRange", true )
	CustomizableWeaponry.originalValue:add( "ClumpSpread", true )
	CustomizableWeaponry.originalValue:add( "PenetrationPower", true )
	CustomizableWeaponry.originalValue:add( "ImpactPower", true )

	CustomizableWeaponry:registerRecognizedStat(
		"DamageFallOffMult",
		"Decreases damage falloff",
		"Increases damage falloff",
		CustomizableWeaponry.textColors.POSITIVE,
		CustomizableWeaponry.textColors.NEGATIVE
	)
	CustomizableWeaponry:registerRecognizedStat(
		"EffectiveRangeMult",
		"Decreases effective range",
		"Increases effective range",
		CustomizableWeaponry.textColors.NEGATIVE,
		CustomizableWeaponry.textColors.POSITIVE
	)
	CustomizableWeaponry:registerRecognizedStat(
		"PenetrationPowerMult",
		"Decreases penetration power",
		"Increases penetration power",
		CustomizableWeaponry.textColors.NEGATIVE,
		CustomizableWeaponry.textColors.POSITIVE
	)
	CustomizableWeaponry:registerRecognizedStat(
		"ImpactPowerMult",
		"Decreases impact power",
		"Increases impact power",
		CustomizableWeaponry.textColors.NEGATIVE,
		CustomizableWeaponry.textColors.POSITIVE
	)

	CustomizableWeaponry:registerRecognizedVariable(
		"PenetrationPowerFlat",
		"Decreases penetration power",
		"Increases penetration power",
		CustomizableWeaponry.textColors.NEGATIVE,
		CustomizableWeaponry.textColors.POSITIVE,
		function( weapon, attachmentData )
			weapon.PenetrationPower_Flat = weapon.PenetrationPower_Flat + attachmentData.PenetrationPowerFlat
		end,
		function( weapon, attachmentData )
			weapon.PenetrationPower_Flat = weapon.PenetrationPower_Flat - attachmentData.PenetrationPowerFlat
		end
	)

	if CLIENT and !SLC_CW_STATS_DISPLAY then
		SLC_CW_STATS_DISPLAY = true
		local stat

		stat = {}
		stat.varName = "PenetrationPower"
		stat.display = "PENETRATION POWER"
		stat.desc = "Penetration power against armor"
		
		function stat:textFunc( wep )
			return math.Round( wep.PenetrationPower )
		end
		
		function stat:origTextFunc( wep )
			return math.Round( wep.PenetrationPower_Orig )
		end
		
		CustomizableWeaponry.statDisplay:addStat(stat)

		stat = {}
		stat.varName = "ImpactPower"
		stat.display = "IMPACT POWER"
		stat.desc = "Impact power that damages armor"
		
		function stat:textFunc( wep )
			return math.Round( wep.ImpactPower * 100 ).."%"
		end
		
		function stat:origTextFunc( wep )
			return math.Round( wep.ImpactPower_Orig * 100 ).."%"
		end
		
		CustomizableWeaponry.statDisplay:addStat(stat)
	end

	--[[-------------------------------------------------------------------------
	Attachment modifications
	---------------------------------------------------------------------------]]
	local function mod_att( name, tab, fn_tab )
		local tbl = CustomizableWeaponry.registeredAttachmentsSKey[name]
		tbl.statModifiers = tab

		if fn_tab then
			for k, v in pairs( fn_tab ) do
				tbl[k] = v
			end
		end

		if CLIENT then
			CustomizableWeaponry:createStatText( tbl )
		end
	end

	mod_att( "am_matchgrade", {
		AimSpreadMult = -0.3,
		RecoilMult = -0.05,
		PenetrationPowerMult = 0.1,
		ImpactPowerMult = -0.5,
	} )

	mod_att( "am_magnum", {
		DamageMult = 0.15,
		RecoilMult = 0.25,
		PenetrationPowerMult = -0.25,
		ImpactPowerMult = 0.15,
	} )

	mod_att( "am_slugrounds", {
		DamageMult = 9,
		AimSpreadMult = 1,
		EffectiveRangeMult = 0.5,
		DamageFallOffMult = -0.35,
		PenetrationPowerMult = -1,
		ImpactPowerMult = 2,
	} )

	mod_att( "am_flechetterounds", {
		ClumpSpreadMult = -0.3,
		DamageMult = -0.75,
		EffectiveRangeMult = -0.25,
		DamageFallOffMult = 0.4,
		PenetrationPowerMult = 2,
		ImpactPowerMult = -0.8,
	} )

	mod_att( "kk_ins2_hoovy", {
		VelocitySensitivityMult = 0.25,
		RecoilMult = -0.25,
		AimSpreadMult = -0.1,
		FireDelayMult = 0.1,
		EffectiveRangeMult = 0.2
	} )

	--[[-------------------------------------------------------------------------
	New ammo types
	---------------------------------------------------------------------------]]
	local att

	att = {}
	att.name = "slc_hp"
	att.displayName = "Hollow point rounds"
	att.displayNameShort = "HP"

	att.statModifiers = { DamageMult = 0.2, RecoilMult = -0.1, AimSpreadMult = 0.1, PenetrationPowerMult = -1, ImpactPowerMult = 0.35 }

	if CLIENT then
		att.displayIcon = surface.GetTextureID( "atts/magnumrounds" )
		att.description = {}
	end

	function att:attachFunc()
		self:unloadWeapon()
	end

	function att:detachFunc()
		self:unloadWeapon()
	end

	CustomizableWeaponry:registerAttachment( att )
	if CLIENT then
		CustomizableWeaponry:createStatText( att )
	end

	att = {}
	att.name = "slc_fmj"
	att.displayName = "Full metal jacket rounds"
	att.displayNameShort = "FMJ"

	att.statModifiers = { DamageMult = -0.3, AimSpreadMult = -0.1, ImpactPowerMult = -0.75 }
	att.PenetrationPowerFlat = 200

	if CLIENT then
		att.displayIcon = surface.GetTextureID( "atts/matchgradeammo" )
		att.description = {}
	end

	function att:attachFunc()
		self:unloadWeapon()
	end

	function att:detachFunc()
		self:unloadWeapon()
	end

	CustomizableWeaponry:registerAttachment( att )
	if CLIENT then
		CustomizableWeaponry:createStatText( att )
	end

	att = {}
	att.name = "slc_ap"
	att.displayName = "Armor piercing rounds"
	att.displayNameShort = "AP"

	att.statModifiers = { DamageMult = -0.5, AimSpreadMult = -0.2, ImpactPowerMult = -0.9, RecoilMult = 0.15 }
	att.PenetrationPowerFlat = 500

	if CLIENT then
		att.displayIcon = surface.GetTextureID( "atts/matchgradeammo" )
		att.description = {{t = "Allows penetration of thin objects", c = CustomizableWeaponry.textColors.POSITIVE}}
	end

	function att:attachFunc()
		self:unloadWeapon()

		self.CanPenetrate_AP = self.CanPenetrate
		self.CanPenetrate = true
	end

	function att:detachFunc()
		self:unloadWeapon()

		self.CanPenetrate = self.CanPenetrate_AP
		self.CanPenetrate_AP = nil
	end

	CustomizableWeaponry:registerAttachment( att )
	if CLIENT then
		CustomizableWeaponry:createStatText( att )
	end

	att = {}
	att.name = "slc_sc"
	att.displayName = "Steel core rounds"
	att.displayNameShort = "SC"

	att.statModifiers = { DamageMult = -0.1, RecoilMult = 0.1, FireDelayMult = 0.33, PenetrationPowerMult = 0.1, ImpactPowerMult = -0.1, }

	if CLIENT then
		att.displayIcon = surface.GetTextureID( "atts/matchgradeammo" )
		att.description = {{t = "Allows penetration of thin objects", c = CustomizableWeaponry.textColors.POSITIVE}}
	end

	function att:attachFunc()
		self:unloadWeapon()

		self.CanPenetrate_SC = self.CanPenetrate
		self.CanPenetrate = true
	end

	function att:detachFunc()
		self:unloadWeapon()

		self.CanPenetrate = self.CanPenetrate_SC
		self.CanPenetrate_SC = nil
	end

	CustomizableWeaponry:registerAttachment( att )
	if CLIENT then
		CustomizableWeaponry:createStatText( att )
	end

	--[[-------------------------------------------------------------------------
	ClumpSpreadMult fix
	---------------------------------------------------------------------------]]
	function cw_base:recalculateClumpSpread()
		if not self.ClumpSpread then return end
		self.ClumpSpread = self.ClumpSpread_Orig * self.ClumpSpreadMult
	end

	function cw_base:recalculateEffectiveRange()
		self.EffectiveRange = self.EffectiveRange_Orig * self.EffectiveRangeMult
		self.PenetrativeRange = self.EffectiveRange * 0.5
	end

	function cw_base:recalculateDamageFallOff()
		self.DamageFallOff = self.DamageFallOff_Orig * self.DamageFallOffMult
	end

	function cw_base:recalculatePenetrationPower()
		if self.PenetrationPowerMult == 0 then
			self.PenetrationPower = 0
		else
			self.PenetrationPower = math.max( self.PenetrationPower_Orig * self.PenetrationPowerMult + self.PenetrationPower_Flat, 0 )
		end
	end

	function cw_base:recalculateImpactPower()
		self.ImpactPower = math.max( self.ImpactPower_Orig * self.ImpactPowerMult, 0 )
	end

	ins_base._OriginalRecalculateStats = ins_base._OriginalRecalculateStats or ins_base.recalculateStats
	function ins_base:recalculateStats()
		self:_OriginalRecalculateStats()
		self:recalculateEffectiveRange()
		self:recalculateDamageFallOff()
		self:recalculatePenetrationPower()
		self:recalculateImpactPower()
	end

	function cw_base:getEffectiveRange()
		return self.EffectiveRange, self.DamageFallOff, self.PenStr, self.PenetrativeRange
	end

	--[[-------------------------------------------------------------------------
	Weapons
	---------------------------------------------------------------------------]]
	global_remove["kk_ins2_flashlight"] = true
	global_remove["kk_ins2_m6x"] = true
	global_remove["kk_ins2_anpeq15"] = true
	global_remove["kk_ins2_gl_m203"] = true

	--Pistols
	SLC_GLOBAL_LOADOUT = "pistol_all"
	add_cw_weapon( "cw_kk_ins2_grach", { IconLetter = "u" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_low" )
	add_cw_weapon( "cw_kk_ins2_tokarev", { IconLetter = "a" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_low" )
	add_cw_weapon( "cw_kk_ins2_makarov", { IconLetter = "a" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_low" )

	add_cw_weapon( "cw_kk_ins2_m9", { IconLetter = "a" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_mid" )
	add_cw_weapon( "cw_kk_ins2_m45", { IconLetter = "a" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_mid" )
	add_cw_weapon( "cw_kk_ins2_mr96", { IconLetter = "f" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_mid" )

	add_cw_weapon( "cw_kk_ins2_deagle", { IconLetter = "f" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_high" )
	//add_cw_weapon( "cw_jk_ins2_fnp", {}, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_high" )
	add_cw_weapon( "cw_kk_ins2_hkuspbestgun", { IconLetter = "a" }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "pistol_high" )

	--SMGs
	SLC_GLOBAL_LOADOUT = "smg_all"
	add_cw_weapon( "cw_kk_ins2_mp5k", { IconLetter = "x", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_low" )
	add_cw_weapon( "cw_kk_ins2_mp5a4", { IconLetter = "x", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_low" )
	add_cw_weapon( "cw_kk_ins2_uzi", { IconLetter = "d", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_low" )
	add_cw_weapon( "cw_kk_ins2_mac10", { IconLetter = "l", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_low" )
	
	add_cw_weapon( "cw_kk_ins2_ump45", { IconLetter = "q", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_mid" )
	add_cw_weapon( "cw_kk_ins2_scorpion", { IconLetter = "q", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_mid" )
	add_cw_weapon( "cw_kk_ins2_veresk", { IconLetter = "d", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_mid" )
	add_cw_weapon( "cw_kk_ins2_vityaz", { IconLetter = "x", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_mid" )
	add_cw_weapon( "cw_kk_ins2_p90", { IconLetter = "m", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_mid" )

	//add_cw_weapon( "cw_kk_ins2_mpx", { IconLetter = "m", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_high" )
	add_cw_weapon( "cw_kk_ins2_vector", { IconLetter = "q", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_high" )
	add_cw_weapon( "cw_kk_ins2_mp7", { IconLetter = "d", ImpactPower = 1.1 }, { am_magnum = "slc_hp", am_matchgrade = "slc_fmj" }, 8, "smg_high" )

	--Rifles
	SLC_GLOBAL_LOADOUT = "rifle_all"
	add_cw_weapon( "cw_kk_ins2_ak74", { IconLetter = "b", PenetrationPower = 115 }, 8, "rifle_low" ) --g
	add_cw_weapon( "cw_kk_ins2_aks74u", { IconLetter = "b", PenetrationPower = 115 }, 8, "rifle_low" )
	add_cw_weapon( "cw_kk_ins2_akm", { IconLetter = "b", PenetrationPower = 115 }, 8, "rifle_low" ) --g
	add_cw_weapon( "cw_kk_ins2_abakan", { IconLetter = "b", PenetrationPower = 115 }, 8, "rifle_low" ) --g
	add_cw_weapon( "cw_kk_ins2_aek971", { IconLetter = "v", PenetrationPower = 115 }, 8, "rifle_low" )
	add_cw_weapon( "cw_kk_ins2_m16a4", { IconLetter = "w", PenetrationPower = 115 }, 8, "rifle_low" ) --g

	add_cw_weapon( "cw_kk_ins2_m4a1", { IconLetter = "w", PenetrationPower = 115 }, 8, "rifle_mid" ) --g
	add_cw_weapon( "cw_kk_ins2_galil", { IconLetter = "v", PenetrationPower = 115 }, 8, "rifle_mid" )
	add_cw_weapon( "cw_kk_ins2_cz805", { IconLetter = "A", PenetrationPower = 115 }, 8, "rifle_mid" )
	add_cw_weapon( "cw_kk_ins2_aug", { IconLetter = "e", PenetrationPower = 115 }, 8, "rifle_mid" )
	add_cw_weapon( "cw_kk_ins2_famasf1", { IconLetter = "t", PenetrationPower = 115 }, 8, "rifle_mid" )
	add_cw_weapon( "cw_kk_ins2_sg551", { IconLetter = "v", PenetrationPower = 115 }, 8, "rifle_mid" )

	add_cw_weapon( "cw_kk_ins2_sa58", { IconLetter = "A", PenetrationPower = 115 }, 8, "rifle_high" )
	add_cw_weapon( "cw_kk_ins2_mk18mod1", { IconLetter = "A", PenetrationPower = 115 }, 8, "rifle_high" )
	add_cw_weapon( "cw_kk_ins2_fnf2000", { IconLetter = "m", PenetrationPower = 115 }, 8, "rifle_high" )
	add_cw_weapon( "cw_kk_ins2_asval", { IconLetter = "v", PenetrationPower = 115 }, 8, "rifle_high" )
	//add_cw_weapon( "cw_kk_ins2_scarh", { PenetrationPower = 115 }, 8, "rifle_high" )
	add_cw_weapon( "cw_kk_ins2_m14", { IconLetter = "v", PenetrationPower = 115 }, 8, "rifle_high" )

	--Shotguns
	
	SLC_GLOBAL_LOADOUT = "shotgun_all"
	//add_cw_weapon( "cw_xm1014_official", { Shots = 8, Damage = 9, FireDelay = 60 / 240, PenetrationPower = 0.2 }, { "md_m203" }, 8, "shotgun_high", "gocmedic" ) // 9x8 - 576 - 288 (240/m)
	add_cw_weapon( "cw_kk_ins2_chaser13", { IconLetter = "k", PenetrationPower = 145 }, 8, "shotgun_low" )
	add_cw_weapon( "cw_kk_ins2_ks23", { IconLetter = "k", PenetrationPower = 145 }, 8, "shotgun_low" )
	add_cw_weapon( "cw_kk_ins2_br99", { IconLetter = "k", PenetrationPower = 145 }, 8, "shotgun_low" )

	add_cw_weapon( "cw_kk_ins2_m1014", { IconLetter = "B", PenetrationPower = 145 }, 8, "shotgun_mid" )
	add_cw_weapon( "cw_kk_ins2_m590", { IconLetter = "k", PenetrationPower = 145 }, 8, "shotgun_mid" )

	add_cw_weapon( "cw_kk_ins2_saigaspike", { IconLetter = "B", PenetrationPower = 145 }, { "kk_ins2_saigaspike_syndicate", "kk_ins2_saigaspike_joke" }, 8, "shotgun_high" )
	add_cw_weapon( "cw_kk_ins2_spas12", { IconLetter = "B", PenetrationPower = 145 }, 8, "shotgun_high" )

	--Snipers
	SLC_GLOBAL_LOADOUT = "sniper_all"
	add_cw_weapon( "cw_kk_ins2_svd", { IconLetter = "o", Damage = 85, FireDelay = 60 / 100, HipSpread = 0.5 }, { am_magnum = "slc_ap", "am_matchgrade" }, 8, "sniper_low" ) --a
	add_cw_weapon( "cw_kk_ins2_sv98b", { IconLetter = "r", Damage = 95 }, { am_magnum = "slc_ap", "am_matchgrade" }, 8, "sniper_low" )
	add_cw_weapon( "cw_kk_ins2_svu", { IconLetter = "i", Damage = 95, FireDelay = 60 / 180, HipSpread = 1 }, { am_magnum = "slc_ap", "am_matchgrade" }, 8, "sniper_mid" ) --a
	add_cw_weapon( "cw_kk_ins2_awm", { IconLetter = "r", Damage = 105 }, { "kk_ins2_awm_gold", am_magnum = "slc_ap", "am_matchgrade" }, 8, "sniper_mid" )
	add_cw_weapon( "cw_kk_ins2_t5000", { IconLetter = "o", Damage = 160 }, { "kk_ins2_t5000_rage", am_magnum = "slc_ap", "am_matchgrade" }, 8, "sniper_high" )
	add_cw_weapon( "cw_kk_ins2_ax308", { IconLetter = "o", Damage = 205 }, { "kk_ins2_ax308_oc", am_magnum = "slc_ap", "am_matchgrade" }, 8, "sniper_high" )
	//add_cw_weapon( "cw_kk_ins2_m98", { Damage = 220}, { "kk_ins2_m98b_cartel", "kk_ins2_m98b_pink" }, 8, "sniper_high" )

	SLC_GLOBAL_LOADOUT = nil

	--Heavy
	add_cw_weapon( "cw_kk_ins2_m249", { IconLetter = "z" }, { am_magnum = "slc_sc", "am_matchgrade" }, 8, "heavy" )
	add_cw_weapon( "cw_kk_ins2_stonerlmg", { IconLetter = "z" }, { am_magnum = "slc_sc", "am_matchgrade" }, 8, "heavy" )
	add_cw_weapon( "cw_kk_ins2_m240b", { IconLetter = "z" }, { am_magnum = "slc_sc", "am_matchgrade" }, 8, "heavy" )
	add_cw_weapon( "cw_kk_ins2_pkp", { IconLetter = "z" }, { am_magnum = "slc_sc", "am_matchgrade" }, 8, "heavy" )

	add_cw_weapon( "cw_kk_ins2_nade_anm14", { IconLetter = "Q" }, true, "grenade" ) --inc
	add_cw_weapon( "cw_kk_ins2_nade_molotov", { IconLetter = "Q" }, true, "grenade" ) --molo
	add_cw_weapon( "cw_kk_ins2_nade_m67", { IconLetter = "O" }, true, "grenade" ) --frag
	add_cw_weapon( "cw_kk_ins2_nade_f1", { IconLetter = "O" }, true, "grenade" ) --frag v2
	add_cw_weapon( "cw_kk_ins2_nade_m18", { IconLetter = "P" }, true, "grenade" ) --smoke
	add_cw_weapon( "cw_kk_ins2_nade_m84", { IconLetter = "P" }, true, "grenade" ) --flash

	/*local frag_thrown = scripted_ents.GetStored( "cw_grenade_thrown" ).t
	frag_thrown.ExplodeRadius = 432
	frag_thrown.ExplodeDamage = 150*/

	AddGroupToWeapon(
		"grenade",
		"cw_kk_ins2_nade_anm14",
		"cw_kk_ins2_nade_molotov",
		"cw_kk_ins2_nade_m67",
		"cw_kk_ins2_nade_f1",
		"cw_kk_ins2_nade_m18",
		"cw_kk_ins2_nade_m84"
	)

	SetWeaponGroupLimit( "grenade", 2 )

	SLC_GLOBAL_LOADOUT = nil

	AddLoadoutWeapon( "guard", 8, "cw_kk_ins2_grach:30", "cw_kk_ins2_tokarev:30", "cw_kk_ins2_makarov:30", "loadout:smg_low:10" )
	AddLoadoutWeapon( "heavyguard", 8, "loadout:pistol_mid:40", "loadout:shotgun_low:10" )
	AddLoadoutWeapon( "ntf_3", 8, "cw_kk_ins2_m4a1", "cw_kk_ins2_m16a4" )
	AddLoadoutWeapon( "ntfmedic", 8, "cw_kk_ins2_aug" )
	AddLoadoutWeapon( "ntfcom", 8, "cw_kk_ins2_mk18mod1" )
	AddLoadoutWeapon( "ntfsniper", 8, "cw_kk_ins2_awm", "cw_kk_ins2_svu" )
	AddLoadoutWeapon( "alpha1", 8, "cw_kk_ins2_m14", "cw_kk_ins2_asval" )
	AddLoadoutWeapon( "alpha1sniper", 8, "cw_kk_ins2_ax308", "cw_kk_ins2_t5000" )
	AddLoadoutWeapon( "alpha1medic", 8, "cw_kk_ins2_mp7", "cw_kk_ins2_spas12" )
	AddLoadoutWeapon( "alpha1com", 8, "cw_kk_ins2_sa58", "cw_kk_ins2_m240b" )
	AddLoadoutWeapon( "cisniper", 8, "cw_kk_ins2_sv98b", "cw_kk_ins2_svd" )
	AddLoadoutWeapon( "cicom", 8, "cw_kk_ins2_galil", "cw_kk_ins2_cz805" )
	AddLoadoutWeapon( "cimedic", 8, "cw_kk_ins2_famasf1" )
	AddLoadoutWeapon( "cispec", 8, "cw_kk_ins2_mp7", "cw_kk_ins2_asval" )
	AddLoadoutWeapon( "ciheavy", 8, "cw_kk_ins2_pkp", "cw_kk_ins2_stonerlmg" )
	AddLoadoutWeapon( "goc", 8, "cw_kk_ins2_fnf2000", "cw_kk_ins2_sg551" )
	AddLoadoutWeapon( "gocmedic", 8, "cw_kk_ins2_vector", "cw_kk_ins2_saigaspike" )
	AddLoadoutWeapon( "goccom", 8, "cw_kk_ins2_m249", "cw_kk_ins2_mk18mod1" )

	print( "CW 2.0 Modifications Done!" )
	--lua_run for k,v in pairs(SLC_LOADOUTS["rifle_all"]) do local l = ents.Create(v.class) l:SetPos(Entity(1):GetPos()) l:Spawn() end
end )