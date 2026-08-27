--[[-------------------------------------------------------------------------
Round Modifiers
---------------------------------------------------------------------------]]
hook.Add( "SLCRegisterRoundModifiers", "SLCBaseRoundModifiers", function()
	RegisterRoundModifier( "loot-value", {
		min = 0.1,
		max = 3,
		base = 1,
		spread = 0.85,
		chance = 0.333,
	} )

	RegisterRoundModifier( "health-value", {
		min = 0.1,
		max = 3,
		base = 1,
		spread = 0.5,
		chance = 0.1,
	} )

	RegisterRoundModifier( "light-value", {
		min = 1,
		max = 16,
		base = 12,
		spread = 1,
		rounding = true,
		chance = 0.2,
	} )

	RegisterRoundModifier( "time-value", {
		min = 1,
		max = 3,
		base = 1,
		spread = 0.75,
		chance = 0.04,
	} )

	RegisterRoundModifier( "gravity-value", {
		min = 0.1,
		max = 1.5,
		base = 1,
		spread = 0.75,
		chance = 0.04,
	} )
end )

hook.Add( "SLCRoundInit", "SLCBaseModifiers", function()
	if CLIENT then return end

	local light_value = GetRoundModifier( "light-value", 12 )
	engine.LightStyle( 0, string.char( 97 + light_value ) )
	BroadcastLua( "render.RedownloadAllLightmaps( true )" )

	if light_value < 10  then
		GetRoundProperty( "slc_exclude_scps", {} )[CLASSES.SCP106] = true
	end

	local time_value = GetRoundModifier( "time-value", 1 )
	game.SetTimeScale( time_value )

	if time_value >= 2 then
		ActivateRoundRule( "disable-tesla", true )
	end

	RunConsoleCommand( "sv_gravity", 600 * GetRoundModifier( "gravity-value", 1 ) )
end )

--[[-------------------------------------------------------------------------
Round Rules
---------------------------------------------------------------------------]]
hook.Add( "SLCRegisterRoundRules", "SLCBaseRoundRules", function()
	RegisterRoundRule( "melee-only", {
		chance = 0.05,
		callback = function()
			OverrideLootItem( function( item )
				if item.class == "__slc_ammo" then return true end

				local is_wep, tag = IsAttackWeaponClass( item.class )
				if is_wep and tag != "melee" then return true end

				return false
			end, function( item )
				if item.class == "__slc_ammo" then
					return { class = "loadout:melee_low!", weight = item.weight, value = item.value, max = item.max }
				end

				return { class = "loadout:melee_mid!", weight = item.weight, value = item.value, max = item.max }
			end )

			OverrideLoadoutWeapon( function( class )
				local is_wep, tag = IsAttackWeaponClass( class )
				if is_wep and tag != "melee" then return "loadout:melee_mid" end
			end )

			OverrideSpawnRuleTag( { "ammo", "gun" }, { item = "loadout:melee_mid!", copy = true } )
			OverrideSpawnRuleItem( function( item )
				local is_wep, tag = IsAttackWeaponClass( item.class )
				if is_wep and tag != "melee" then return true end

				return false
			end, function( item )
				return { class = "loadout:melee_mid!", weight = item.weight, max = item.max }
			end )

			SetRoundWeaponGroupLimit( "melee", 2 )

			AddRoundHook( "SLCScaleDamage", "SLCMeleeOnlyRoundRule", function( target, info )
				if target:SCPTeam() != TEAM_SCP then return end
				info:ScaleDamage( 4 )
			end )
		end,
	} )

	RegisterRoundRule( "lifesteal-only", {
		chance = 0.05,
		callback = function()
			OverrideLootItem( function( item )
				return item.class == "item_slc_medkit" or item.class == "item_slc_medkitplus"
			end, nil )

			OverrideLoadoutWeapon( function( class )
				if class == "item_slc_medkit" or class == "item_slc_medkitplus" then return "__nothing" end
			end )

			OverrideSpawnRuleItem( function( tags, item_tab, item_class )
				return item_class == "item_slc_medkit" or item_class == "item_slc_medkitplus"
			end, function( item )
				return { class = "func:syringe:33", weight = item.weight, max = item.max }
			end )

			AddRoundHook( "SLCCanHeal", "SLCLifestealRoundRule", function( target, healer, heal_type )
				if heal_type == "medkit" then return false end
			end )

			AddRoundHook( "PostEntityTakeDamage", "SLCLifestealRoundRule", function( target, info )
				if !IsValid( target ) or !target:IsPlayer() or info:IsDamageType( DMG_DIRECT ) then return end
				if target:SCPTeam() == TEAM_SCP then return end

				local attacker = info:GetAttacker()
				if !IsValid( attacker ) or !attacker:IsPlayer() then return end
				if attacker:SCPTeam() == TEAM_SCP then return end

				if SCPTeams.PlayerRelation( attacker, target ) != nil then return end --REVIEW PlayerDamageRelation

				local heal = info:GetDamage() * 0.5

				local health = attacker:Health() + heal
				local max_health = attacker:GetMaxHealth()

				local overheal = 0
				if health > max_health then
					overheal = health - max_health
					health = max_health
				end

				attacker:SetHealth( health )

				if overheal <= 0 then return end

				local extra = attacker:GetExtraHealth() + overheal
				attacker:SetExtraHealth( extra )
				attacker:SetMaxExtraHealth( extra )
				attacker:SetProperty( "extra_hp_think", CurTime() + 1 )
			end )
		end,
	} )

	RegisterRoundRule( "no-armor", {
		chance = 0.05,
		callback = function()
			OverrideSpawnRuleItem( function( tags, item_tab, item_class )
				return string.sub( item_class, 1, 9 ) == "func:vest"
			end, nil )

			AddRoundHook( "SLCArmorPickedUp", "SLCNoArmorRoundRule", function()
				return true
			end )
		end,
	} )

	RegisterRoundRule( "disable-tesla", {
		callback = function()
			local btn = GetButton( "Tesla" )
			if btn and istable( btn ) then
				btn = btn[1]
			end

			print( "dsbl tesla", btn )

			if IsValid( btn ) then
				btn:Fire( "PressIn" )
			end
		end
	} )

	RegisterRoundRule( "no-loose-loot", { hidden = true } )
	RegisterRoundRule( "no-looting", { hidden = true } )
	RegisterRoundRule( "no-scp", { hidden = true } )
	RegisterRoundRule( "no-gas", { hidden = true } )
	RegisterRoundRule( "no-scp-upgrades", { hidden = true } )
end )