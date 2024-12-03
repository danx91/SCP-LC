SLC_WEAPONS_REG = {}
SLC_LOADOUTS = {}

/*
data = {
	class = <string>,
	ammo = <number>,

}
*/

function AddLoadout( class, ammo, ... )
	local tab = {
		class = class,
		ammo = ammo,
	}

	if SLC_GLOBAL_LOADOUT then
		if !SLC_LOADOUTS[SLC_GLOBAL_LOADOUT] then
			SLC_LOADOUTS[SLC_GLOBAL_LOADOUT] = {}
		end

		table.insert( SLC_LOADOUTS[SLC_GLOBAL_LOADOUT], tab )
	end

	for k, v in pairs( { ... } ) do
		if !SLC_LOADOUTS[v] then
			SLC_LOADOUTS[v] = {}
		end

		table.insert( SLC_LOADOUTS[v], tab )
	end
end

function GetLoadout( name )
	return SLC_LOADOUTS[name]
end

function GetLoadoutWeapon( name )
	local wep = SLC_LOADOUTS[name]
	local tab = istable( wep ) and wep[math.random( #wep )] or wep
	if !tab then return end

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

local sniper_nerf = {
	cw_svd_official = true,
	khr_sr338 = true,

}

hook.Add( "EntityTakeDamage", "SLCCWSniperReductionForIdiots", function( ent, dmg )
	local ent_class = ent:GetClass()
	if ent_class == "cw_ammo_kit_regular" or ent_class == "cw_ammo_kit_small" then return true end

	local att = dmg:GetAttacker()
	if !IsValid( att ) then return end

	local att_class = att:GetClass()
	if string.match( att_class, "_thrown$" ) then return true end

	if !att:IsPlayer() or att == ent or !dmg:IsBulletDamage() then return end

	local pwep = att:GetActiveWeapon()
	if !IsValid( pwep ) then return end

	local wep_class = pwep:GetClass()
	if sniper_nerf[wep_class] then
		local dist = ent:GetPos():Distance( att:GetPos() )
		if dist < 1500 then
			dmg:ScaleDamage( math.Clamp( dist / 1500, 0.25, 1 ) )
		end
	end
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

--CW 2.0 has attachments system so ye les go khris let's make attachments logic in fcking think function, great idea.. only good thing about it is that it can be simply fixed
local khr_callback = function( wep )
	//wep._OriginalIndividualThink = wep._OriginalIndividualThink or wep.IndividualThink
	wep.IndividualThink = function( self ) end
end

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
		AddLoadout( class, ammo, unpack( args ) )
	end

	local wep_tab = weapons.GetStored( class )
	if !wep_tab then return end

	wep_tab.ArmorPenetration = 0
	wep_tab.NoFreeAim = true
	wep_tab.CanRicochet = false
	wep_tab.CanPenetrate = false

	for k, v in pairs( stats ) do
		wep_tab[k] = v
	end

	if func then
		func( wep_tab )
	end

	if !rem then return end

	if #rem > 0 then
		rem = CreateLookupTable( rem )
	end

	if !wep_tab.Attachments then return end

	for button, category in pairs( wep_tab.Attachments ) do
		if !category.atts then continue end

		for i, elem in rpairs( category.atts ) do
			if !rem[elem] then continue end

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
	local base = weapons.GetStored( "cw_base" )
	local ammo_base = scripted_ents.GetStored( "cw_ammo_ent_base" ).t

	--[[-------------------------------------------------------------------------
	Customization
	---------------------------------------------------------------------------]]
	/*CustomizableWeaponry.callbacks:addNew( "disableInteractionMenu", "SCPLCCanCustomize", function( wep )
	
	end )*/

	--[[-------------------------------------------------------------------------
	Fix CW 2.0 exploits (some at least...)
	---------------------------------------------------------------------------]]
	base._OriginalThink = base._OriginalThink or base.Think
	function base:Think()
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
	base._OriginalPlayAnim = base._OriginalPlayAnim or base.playAnim
	function base:playAnim( anim, speed, cycle, ent )
		if !IsValid( ent or self.CW_VM ) then return end

		return self:_OriginalPlayAnim( anim, speed, cycle, ent )
	end

	base._OriginalGetTracerOrigin = base._OriginalGetTracerOrigin or base.GetTracerOrigin
	function base:GetTracerOrigin()
		if !IsValid( self ) then return end

		return self:_OriginalGetTracerOrigin()
	end

	base._OriginalPerformViewmodelMovement = base._OriginalPerformViewmodelMovement or base.performViewmodelMovement
	function base:performViewmodelMovement()
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
		if !IsValid( wep ) or wep.Base == "cw_grenade_base" then return end

		self:_OriginalUse( activator, caller )
	end

	--[[-------------------------------------------------------------------------
	Disable some features
	---------------------------------------------------------------------------]]
	CustomizableWeaponry.quickGrenade.enabled = false
	concommand.Remove( "cw_dropweapon" )

	--[[-------------------------------------------------------------------------
	Fix khr attachments
	---------------------------------------------------------------------------]]
	CustomizableWeaponry.originalValue:add( "DamageFallOff", true )
	CustomizableWeaponry.originalValue:add( "EffectiveRange", true )
	CustomizableWeaponry.originalValue:add( "ClumpSpread", true )
	CustomizableWeaponry.originalValue:add( "ArmorPenetration", true )

	CustomizableWeaponry:registerRecognizedStat( "DamageFallOffMult", "Decreases damage falloff", "Increases damage falloff", CustomizableWeaponry.textColors.POSITIVE, CustomizableWeaponry.textColors.NEGATIVE )
	CustomizableWeaponry:registerRecognizedStat( "EffectiveRangeMult", "Decreases effective range", "Increases effective range", CustomizableWeaponry.textColors.NEGATIVE, CustomizableWeaponry.textColors.POSITIVE )
	CustomizableWeaponry:registerRecognizedStat( "ArmorPenetrationMult", "Decreases armor penetration", "Increases armor penetration", CustomizableWeaponry.textColors.NEGATIVE, CustomizableWeaponry.textColors.POSITIVE )

	if CLIENT and !SLC_CW_STATS_DISPLAY then
		SLC_CW_STATS_DISPLAY = true

		local stat = {}
		stat.varName = "ArmorPenetration"
		stat.display = "ARMOR PENETRATION"
		stat.desc = "Armor penetration against vests"
		
		function stat:textFunc( wep )
			return math.Round( wep.ArmorPenetration * 100 ).."%"
		end
		
		function stat:origTextFunc( wep )
			return math.Round( wep.ArmorPenetration_Orig * 100 ).."%"
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
	} )

	mod_att( "am_magnum", {
		DamageMult = 0.15,
		RecoilMult = 0.25,
	} )

	mod_att( "am_reducedpowderload", {
		DamageMult = -0.25,
		RecoilMult = -0.3,
		SpreadPerShotMult = -0.3,
	} )

	mod_att( "am_slugrounds", {
		DamageMult = 6,
		AimSpreadMult = 1,
		EffectiveRangeMult = 0.5,
		DamageFallOffMult = -0.35,
		ArmorPenetrationMult = -1,
	} )

	mod_att( "am_flechetterounds", {
		ClumpSpreadMult = -0.3,
		DamageMult = -0.7,
		EffectiveRangeMult = -0.25,
		DamageFallOffMult = 0.4,
		ArmorPenetrationMult = 2,
	} )

	mod_att( "bg_regularbarrel", {
		RecoilMult = 0.11,
		AimSpreadMult = -0.1,
		DrawSpeedMult = -0.10,
		DamageMult = 0.1,
		FireDelayMult = 0.2,
	} )

	mod_att( "bg_longbarrelmr96", {
		RecoilMult = 0.22,
		AimSpreadMult = -0.15,
		DrawSpeedMult = -0.3,
		OverallMouseSensMult = -0.1,
		DamageMult = 0.25,
		FireDelayMult = 0.4,
	} )

	mod_att( "md_mchoke", {
		ClumpSpreadMult = -0.075,
		OverallMouseSensMult = -0.15,
		VelocitySensitivityMult = 0.15,
		DrawSpeedMult = -0.05,
		HipSpreadMult = 0.15,
		DamageMult = -0.05,
	}, {
		attachFunc = function() end,
		detachFunc = function() end,
		description = {},
		_description = {},
	} )

	mod_att( "md_fchoke", {
		ClumpSpreadMult = -0.15,
		OverallMouseSensMult = -0.25,
		VelocitySensitivityMult = 0.25,
		DrawSpeedMult = -0.1,
		HipSpreadMult = 0.25,
		DamageMult = -0.1,
	}, {
		attachFunc = function() end,
		detachFunc = function() end,
		description = {},
		_description = {},
	} )

	--[[-------------------------------------------------------------------------
	ClumpSpreadMult fix
	---------------------------------------------------------------------------]]
	function base:recalculateClumpSpread()
		if not self.ClumpSpread then return end
		self.ClumpSpread = self.ClumpSpread_Orig * self.ClumpSpreadMult
	end

	function base:recalculateEffectiveRange()
		self.EffectiveRange = self.EffectiveRange_Orig * self.EffectiveRangeMult
		self.PenetrativeRange = self.EffectiveRange * 0.5
	end

	function base:recalculateDamageFallOff()
		self.DamageFallOff = self.DamageFallOff_Orig * self.DamageFallOffMult
	end

	function base:recalculateArmorPenetration()
		self.ArmorPenetration = math.Clamp( self.ArmorPenetration_Orig * self.ArmorPenetrationMult, 0, 1 )
	end

	base._OriginalRecalculateStats = base._OriginalRecalculateStats or base.recalculateStats
	function base:recalculateStats()
		self:_OriginalRecalculateStats()
		self:recalculateEffectiveRange()
		self:recalculateDamageFallOff()
		self:recalculateArmorPenetration()
	end

	function base:getEffectiveRange()
		return self.EffectiveRange, self.DamageFallOff, self.PenStr, self.PenetrativeRange
	end

	--[[-------------------------------------------------------------------------
	Strip grenade after throw
	---------------------------------------------------------------------------]]
	local tab = weapons.GetStored( "cw_grenade_base" )
	tab.PrimaryAttack = function( self )
		if self:GetOwner():GetAmmoCount( self.Primary.Ammo ) == 0 and self:Clip1() == 0 then
			return
		end
	
		if self.pinPulled then
			return
		end
		
		for i = 1, 3 do
			if not self:canFireWeapon(i) then
				return
			end
		end
		
		self.OriginalHolster = self.OriginalHolster or self.Holster
		self.Holster = function() return false end
		self.OnDrop = function( this ) if SERVER then this:Remove() end end

		self.pinPulled = true
		self.PreventDropping = true
		self.animPlayed = false
		self.throwTime = CurTime() + self.timeToThrow
		self:sendWeaponAnim("pullpin")
	end

	tab.IndividualThink = function( self )
		local curTime = CurTime()
		
		if self.pinPulled then
			local owner = self:GetOwner()
			if curTime > self.throwTime then
				if not owner:KeyDown(IN_ATTACK) then
					if not self.animPlayed then
						self.entityTime = CurTime() + 0.15
						self:sendWeaponAnim("throw")
						owner:SetAnimation(PLAYER_ATTACK1)
					end
					
					if curTime > self.entityTime then
						if SERVER then
							local tr = util.TraceLine( {
								start = owner:GetShootPos(),
								endpos = owner:GetShootPos() + CustomizableWeaponry.quickGrenade:getThrowOffset(owner),
								mask = MASK_SOLID
							} )

							local grenade = ents.Create(self.grenadeEnt)
							grenade:SetPos(tr.HitPos)
							grenade:SetAngles(owner:EyeAngles())
							grenade:Spawn()
							grenade:Activate()
							grenade:Fuse(self.fuseTime)
							grenade:SetOwner(owner)
							CustomizableWeaponry.quickGrenade:applyThrowVelocity(owner, grenade)
							self:TakePrimaryAmmo(1)
						end
						
						self:SetNextPrimaryFire(curTime + 1)
						
						timer.Simple(self.swapTime, function()
							if IsValid(self) and IsValid( owner ) then
								if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then -- we're out of ammo, strip this weapon
									if SERVER then owner:StripWeapon( self.ClassName ) end
								else
									self:sendWeaponAnim("draw")
									
									self.PreventDropping = false
									self.OnDrop = nil
									self.Holster = self.OriginalHolster
								end
							end
						end)
						
						self.pinPulled = false
					end
					
					self.animPlayed = true
				end
			end
		end
	end

	--[[-------------------------------------------------------------------------
	Weapons
	---------------------------------------------------------------------------]]
	--Pistols
	SLC_GLOBAL_LOADOUT = "pistol_all"
	add_cw_weapon( "cw_fiveseven", { Damage = 18 }, 8, "pistol_high" )
	add_cw_weapon( "cw_deagle", { Damage = 34, Recoil = 2.5 }, 8, "pistol_high", "chief" )
	add_cw_weapon( "khr_ots33", {}, khr_callback, 8, "pistol_high", "cimedic" )
	add_cw_weapon( "khr_p226", {}, khr_callback, 8, "pistol_high", "guardmedic" )

	add_cw_weapon( "cw_mr96", { Damage = 32, FireDelay = 60 / 350 }, 8, "pistol_mid", "heavyguard", "chief" )
	add_cw_weapon( "cw_p99", { Damage = 20 }, 8, "pistol_mid", "tech" )
	add_cw_weapon( "cw_m1911", { Damage = 26 }, 8, "pistol_mid", "heavyguard" )
	add_cw_weapon( "khr_m92fs", {}, khr_callback, 8, "pistol_mid", "heavyguard", "tech" )
	add_cw_weapon( "khr_cz75", {}, khr_callback, 8, "pistol_mid", "tech" )

	add_cw_weapon( "khr_makarov", {}, khr_callback, 8, "pistol_low" )
	add_cw_weapon( "khr_sr1m", {}, khr_callback, 8, "pistol_low", "guard" )
	add_cw_weapon( "khr_mp443", {}, khr_callback, 8, "pistol_low", "guard" )
	add_cw_weapon( "khr_gsh18", {}, khr_callback, 8, "pistol_low", "guard" )

	--SMGs
	SLC_GLOBAL_LOADOUT = "smg_all"
	add_cw_weapon( "cw_mp7_official", { Damage = 13 }, 8, "smg_high", "alpha1medic", "cispec" )
	add_cw_weapon( "khr_p90", { Damage = 12 }, khr_callback, 8, "smg_high", "ntfmedic" )

	add_cw_weapon( "cw_ump45", { Damage = 21 }, 8, "smg_mid" )
	add_cw_weapon( "cw_scorpin_evo3", {}, { "skin_ws_evo3scifi", "bg_hk416_cmagforevo", "md_fas2_holo" }, 8, "smg_mid", "gocmedic" )
	add_cw_weapon( "khr_vector", {}, khr_callback, 8, "smg_mid" )
	add_cw_weapon( "cw_mp9_official", { Damage = 13 }, { "am_ultramegamatchammo" }, 8, "smg_mid", "ntfcom", "cimedic" )
	
	add_cw_weapon( "cw_mac11", { Damage = 10, Recoil = 0.7, HipSpread = 0.043, AimSpread = 0.021 }, 8, "smg_low" )
	add_cw_weapon( "cw_mp5", { Damage = 12 }, 8, "smg_low" )
	add_cw_weapon( "khr_veresk", { Damage = 16, HipSpread = 0.04, Recoil = 1.22 }, khr_callback, 8, "smg_low" )

	--Rifles
	SLC_GLOBAL_LOADOUT = "rifle_all"
	add_cw_weapon( "cw_covertible_ak12", {}, { "bg_svd12rndmag", "bg_rpk_12_mag" }, 8, "rifle_high", "cicom" )
	add_cw_weapon( "cw_vss", { Recoil = 1, Damage = 23 }, 8, "rifle_high", "alpha1" )
	add_cw_weapon( "cw_scarh", { Damage = 26, Recoil = 1.9, FireDelay = 60 / 600 }, { "md_m203" }, 8, "rifle_high", "alpha1com" )
	add_cw_weapon( "cw_tr09_mk18", {}, { "md_m203", "mk18_scifi", "md_fas2_holo" }, 8, "rifle_high", "ntfcom" )
	add_cw_weapon( "cw_acr", {}, 8, "rifle_high", "goccom" )
	add_cw_weapon( "cw_aacgsm", {}, 8, "rifle_high", "alpha1com" )
	add_cw_weapon( "khr_fnfal", {}, { "md_m203" }, khr_callback, 8, "rifle_high", "cimedic" )
	
	add_cw_weapon( "cw_ar15", { Damage = 13, Recoil = 0.8 }, { "md_cmag_556_official", "md_m203" }, 8, "rifle_mid", "ntf_3" )
	add_cw_weapon( "cw_m14", { Damage = 24 }, 8, "rifle_mid", "gocmedic" )
	add_cw_weapon( "cw_l85a2", { Damage = 20, FireDelay = 60 / 710 }, 8, "rifle_mid", "ntf_3" )
	add_cw_weapon( "cw_g3a3", { Damage = 25, Recoil = 1.75 }, { "md_m203" }, 8, "rifle_mid", "alpha1" )
	add_cw_weapon( "cw_famasg2_official", { Damage = 18 }, { "md_cmag_556_official" }, 8, "rifle_mid", "goc" )
	add_cw_weapon( "cw_hk416c", {}, { "md_m203" }, 8, "rifle_mid", "ntf_3" )
	add_cw_weapon( "cw_sg55x", {}, { "bg_sleeveak" }, 8, "rifle_mid", "goc" )
	add_cw_weapon( "cw_tr09_auga3", {}, { "md_m203", "auga3_clatch", "auga3_white", "auga3_green", "auga3_tan" }, 8, "rifle_mid", "alpha1medic" )
	add_cw_weapon( "cw_tr09_tar21", {}, { "tar21_tan" }, 8, "rifle_mid", "ntfmedic" )
	add_cw_weapon( "cw_tr09_qbz97", {}, 8, "rifle_mid", "goc" )
	add_cw_weapon( "khr_aek971", {}, khr_callback, 8, "rifle_mid", "ci" )
	add_cw_weapon( "khr_hcar", {}, khr_callback, 8, "rifle_mid", "cispec" )

	add_cw_weapon( "khr_ak103", {}, khr_callback, 8, "rifle_low", "ci" )
	add_cw_weapon( "cw_g36c", { Damage = 15 }, 8, "rifle_low", "ci" )

	--Shotguns
	local khr_shotgun_replace = {
		am_birdshot = true,
		am_shortbuck = true,
		am_flechetterounds2 = "am_flechetterounds",
		am_slugrounds2k = "am_slugrounds",
		am_rifledslugs = "am_slugrounds",
		am_slugroundsneo = "am_slugrounds",
	}
	
	SLC_GLOBAL_LOADOUT = "shotgun_all"
	add_cw_weapon( "khr_ns2000", { Shots = 10, Damage = 11, ArmorPenetration = 0.2 }, khr_shotgun_replace, khr_callback, 8, "shotgun_high", "alpha1" ) // 11x10 - 550 - 110 (60/m)
	add_cw_weapon( "cw_xm1014_official", { Shots = 8, Damage = 9, FireDelay = 60 / 240, ArmorPenetration = 0.2 }, { "md_m203" }, 8, "shotgun_high", "gocmedic" ) // 9x8 - 576 - 288 (240/m)
	
	add_cw_weapon( "cw_m3super90", { Shots = 8, Damage = 9, FireDelay = 60 / 130, ArmorPenetration = 0.2 }, 8, "shotgun_mid" ) // 9x8 - 576 - 156 (130/m)
	add_cw_weapon( "khr_mp153", { Shots = 8, Damage = 7.5, ArmorPenetration = 0.2 }, khr_shotgun_replace, khr_callback, 8, "shotgun_mid", "alpha1" ) // 7.5x8 - 360 - 240 (240/m)
	
	add_cw_weapon( "cw_saiga12k_official", { Shots = 8, Damage = 6, ArmorPenetration = 0.2 }, 8, "shotgun_low" ) // 6x8 - 240 - 282 (353/m)
	add_cw_weapon( "khr_m620", { Shots = 8, Damage = 8, ArmorPenetration = 0.2 }, khr_shotgun_replace, khr_callback, 8, "shotgun_low" ) // 8x8 - 320 - 75 (70/m)

	SLC_GLOBAL_LOADOUT = nil

	--Snipers
	add_cw_weapon( "khr_m95", {}, khr_callback, 8, "sniper_high" )
	add_cw_weapon( "khr_m82a3", {}, khr_callback, 8, "sniper_high" )

	add_cw_weapon( "khr_t5000", { Damage = 60 }, khr_callback, 8, "sniper_mid" )
	add_cw_weapon( "khr_sr338", {}, khr_callback, 8, "sniper_mid" )

	add_cw_weapon( "cw_svd_official", { Damage = 50, FireDelay = 60 / 150, Recoil = 1 }, 8, "sniper_low" )
	add_cw_weapon( "cw_sv98", { Damage = 60 }, 8, "sniper_low" )

	--Heavy
	add_cw_weapon( "cw_m249_official", { Damage = 12 }, 8, "heavy" )
	add_cw_weapon( "cw_pkm", { Damage = 15 }, 8, "heavy" )

	--Grenades
	add_cw_weapon( "cw_frag_grenade", {}, true, "grenade" )
	add_cw_weapon( "cw_flash_grenade", {}, true, "grenade" )
	add_cw_weapon( "cw_smoke_grenade", {}, true, "grenade" )

	local frag_thrown = scripted_ents.GetStored( "cw_grenade_thrown" ).t
	frag_thrown.ExplodeRadius = 432
	frag_thrown.ExplodeDamage = 150

	SLC_WEAPON_GROUP_OVERRIDE["cw_frag_grenade"] = "grenade"
	SLC_WEAPON_GROUP_OVERRIDE["cw_flash_grenade"] = "grenade"
	SLC_WEAPON_GROUP_OVERRIDE["cw_smoke_grenade"] = "grenade"

	SLC_GLOBAL_LOADOUT = nil

	print( "CW 2.0 Modifications Done!" )
end )