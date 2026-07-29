--[[-------------------------------------------------------------------------
Round Modifiers
---------------------------------------------------------------------------]]
hook.Add( "SLCRegisterRoundModifiers", "SLCBaseRoundModifiers", function()
	RegisterRoundModifier( "loot-value", 0.1, 3, 1, 0.85, false, 0.666 )
	RegisterRoundModifier( "health-value", 0.1, 3, 1, 0.5, false, 0.2 )

	RegisterRoundModifier( "light-value", 1, 16, 12, 1, true, 0.333 )

	RegisterRoundModifier( "time-value", -2, 2, 0, 0.75, false, 0.05 )
	RegisterRoundModifier( "gravity-value", 0.1, 1.5, 1, 0.75, false, 0.05 )
end )

hook.Add( "SLCRoundInit", "SLCBaseModifiers", function()
	if CLIENT then return end

	local light_value = GetRoundModifier( "light-value", 12 )
	engine.LightStyle( 0, string.char( 97 + light_value ) )
	BroadcastLua( "render.RedownloadAllLightmaps( true )" )

	if light_value < 10  then
		GetRoundProperty( "slc_exclude_scps", {} )[CLASSES.SCP106] = true
	end

	game.SetTimeScale( 1 + math.abs( GetRoundModifier( "time-value", 0 ) ) )
	RunConsoleCommand( "sv_gravity", 600 * GetRoundModifier( "gravity-value", 1 ) )
end )

--[[-------------------------------------------------------------------------
Round Rules
---------------------------------------------------------------------------]]
hook.Add( "SLCRegisterRoundRules", "SLCBaseRoundRules", function()
	RegisterRoundRule( "melee-only", 0.05, nil, nil, function()
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
	end )

	RegisterRoundRule( "lifesteal-only", 0.05, nil, nil, function()
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
	end )

	RegisterRoundRule( "no-armor", 0.05, nil, nil, function()
		OverrideSpawnRuleItem( function( tags, item_tab, item_class )
			return string.sub( item_class, 1, 9 ) == "func:vest"
		end, nil )

		AddRoundHook( "SLCArmorPickedUp", "SLCNoArmorRoundRule", function()
			return true
		end )
	end )

	RegisterRoundRule( "no-loose-loot" )
	RegisterRoundRule( "no-looting" )
	RegisterRoundRule( "no-scp" )
	RegisterRoundRule( "no-gas" )
	RegisterRoundRule( "no-scp-upgrades" )
end )