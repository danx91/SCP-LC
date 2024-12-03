UPGRADE_MODE = {
	ROUGH = 0,
	COARSE = 1,
	ONE_ONE = 2,
	FINE = 3,
	VERY_FINE = 4,
}

ACC_REGISTRY = {
	ID = 0,
	DATA = {},
	ACCESS_ID = {},
	CHIPS = {},
	CHIPS_ID = {},
	LEVELS = {},
	UPGRADES = {},
}

function RegisterAccess( name )
	assert( isstring( name ), "bad argument #1 to 'RegisterAccess' (string expected, got "..type( name )..")" )

	if ACC_REGISTRY.DATA[name] then
		print( "Access '"..name.."' is already registered!" )
		return false
	end

	if ACC_REGISTRY.ID >= 32 then
		print( "Unable to add new access - reached limit of 32 accesses" )
		return false
	end

	local flag = bit.lshift( 1, ACC_REGISTRY.ID )
	ACC_REGISTRY.ACCESS_ID[ACC_REGISTRY.ID] = name
	ACC_REGISTRY.DATA[name] = flag
	_G["ACCESS_"..name] = flag

	ACC_REGISTRY.ID = ACC_REGISTRY.ID + 1

	return flag
end

local CHIP = {
	Access = 0,

	AddAccess = function( self, access )
		if istable( access ) then
			access = bit.bor( unpack( access ) )
		end

		self.Access = bit.bor( self.Access, access )
		return self
	end,

	RemoveAccess = function( self, access )
		if istable( access ) then
			access = bit.bor( unpack( access ) )
		end

		self.Access = bit.band( self.Access, bit.bnot( access ) )
		return self
	end,

	HasAccess = function( self, access, override )
		return bit.band( self.Access, access ) == access or bit.band( override, access ) == access
	end,

	--weight: 0 to tell game that this is the only and guaranted upgrade, result: true - destroy chip, false/nil - do nothing
	AddUpgrade = function( self, mode, weight, result )
		if istable( mode ) then
			mode = bit.bor( unpack( mode ) )
		end

		if !self.Upgrades[mode] then
			self.Upgrades[mode] = {}
		end

		table.insert( self.Upgrades[mode], { weight, result } )
		return self
	end,
}

function RegisterChip( name, level, access, skin, model )
	level = level or 0

	local advanced = {}

	if istable( access ) then
		if access.randomtable then
			local tab = {}
			advanced.random = tab

			tab.access = access.randomtable
			tab.num = access.randomnum or 0

			access = access.access
		end

		if istable( access ) then
			access = bit.bor( unpack( access ) )
		end
	end

	local id = table.insert( ACC_REGISTRY.CHIPS_ID, name )

	local chip = setmetatable( { Access = access, Upgrades = {} }, { __index = CHIP } )
	ACC_REGISTRY.CHIPS[name] = { name = name, id = id, level = level, obj = chip, advanced = advanced, model = model, skin = skin or 0 }

	if !ACC_REGISTRY.LEVELS[level] then
		ACC_REGISTRY.LEVELS[level] = {}
	end
	table.insert( ACC_REGISTRY.LEVELS[level], name )

	return chip
end

function GetChip( name )
	local chip = ACC_REGISTRY.CHIPS[name]
	if chip then
		return chip
	end
end

function GetChipByID( id )
	local name = ACC_REGISTRY.CHIPS_ID[id]
	if name then
		local chip = ACC_REGISTRY.CHIPS[name]
		if chip then
			return chip
		end
	end
end

function GetChipNameByID( id )
	local name = ACC_REGISTRY.CHIPS_ID[id]
	if name then
		return name
	end
end

function GenerateAccessOverride( chip )
	local tab = chip.advanced.random
	if tab and #tab.access > 0 then
		--print( "has random access" )
		local override = {}
		local st = table.Copy( tab.access )

		local len = #st
		for i = 1, tab.num do
			override[i] = table.remove( st, math.random( len ) )
			--print( "selecting", i, tab.num, override[i] )

			len = #st
			if len < 1 then
				break
			end
		end

		local l = #override
		--print( "override with", l )
		if l == 0 then
			return 0
		elseif l == 1 then
			return override[1]
		end

		return bit.bor( unpack( override ) )
	end
end

function SelectChip( level, blacklist )
	local tab = ACC_REGISTRY.LEVELS[level]
	if !tab then return end

	if !blacklist then
		return tab[math.random( #tab )]
	end

	local copy = table.Copy( tab )
	blacklist = CreateLookupTable( blacklist )

	for i = #copy, 1, -1 do
		local selected = table.remove( copy, math.random( i ) )
		if !blacklist[selected] then
			return selected
		end
	end
end

function SelectUpgrade( name, mode )
	local upgrades = ACC_REGISTRY.UPGRADES[name]
	if !upgrades then return false end

	local weightlist = upgrades[mode]
	if !weightlist then return false end

	local len = #weightlist
	local total = weightlist[len][1]

	if total == 0 then
		local result = weightlist[len][2]
		if !result or result == true then
			return result
		end
		
		return result, GenerateAccessOverride( GetChip( result ) )
	end

	local dice = math.random( total )
	for i = 1, len do
		if dice <= weightlist[i][1] then
			local result = weightlist[i][2]
			if !result or result == true then
				return result
			end

			return result, GenerateAccessOverride( GetChip( result ) )
		end
	end

	print( "Something went wrong while selecting upgraded chip type!", name, mode )
	return false
end

function CreateChip( name )
	local chip = ACC_REGISTRY.CHIPS[name]
	if chip then
		local ent = ents.Create( "item_slc_access_chip" )
		if IsValid( ent ) then
			ent:SetChipData( chip, GenerateAccessOverride( chip ) )
			return ent
		end
	end
end

if CLIENT then
	local desc_cache = {}

	function GetChipDescription( name, override, feed, refresh )
		override = override or 0

		if override == 0 and desc_cache[name] and !refresh then
			return desc_cache[name]
		end

		local chip = ACC_REGISTRY.CHIPS[name]
		if chip then
			local obj = chip.obj
			local desc

			for i = 0, #ACC_REGISTRY.ACCESS_ID do
				local acc = ACC_REGISTRY.ACCESS_ID[i]
				local flag = ACC_REGISTRY.DATA[acc]
				//print( "checking", i, acc, flag, obj.Access )
				if flag and obj:HasAccess( flag, override ) then
					//print( "hass acc to ", acc )
					local txt = feed and feed[acc] or acc

					if !desc then
						desc = StringBuilder( txt )
					else
						desc:append( ", ", txt )
					end
				end
			end

			local str = tostring( desc )
			desc_cache[name] = str
			return str
		end
	end
end

if SERVER then
	/*
	{
		name = "name of the button",
		pos = <vector>, --button position
		tolerance = <number/table>, --optional, tolerance in which game should look for that button (useful for buttons that move)
		access = <ACCESS_ enum>, --optional, access required to open this door
		override = <function(ply, ent, name), return <boolean>, <string>>, --optional, return true to allow, false to disallow and nil to do access check;
			optional string return to override message; higher priority than ENTITY:AccessOverride
		access_granted = <function(ply, name) return <boolean>>, --optional, called when access is granted, return true to suppress use
		input_override = <function( ply ) return <boolean>>
		no_sound = <boolean>, --optional, if true, don't play sounds
		msg_target = <number>, --optional, nil - auto (default); 1 - force (override suppress_texts option); 2 - force (override suppress_texts option and omnitools)
		msg_access = <string>, --optional, custom message when access is granted
		msg_deny = <string>, --optional, custom message when access is denied
		msg_omnitool = <string>, --optional, custom message when omnitool is required, but player doesn't have one
		scp_disallow = <boolean>, --optional, true = scps can't use but ones with can_interact
		suppress_check = <boolean>, --optional, skipps access check
		disabled = <boolean>, --optional, blocks usage of button
		suppress_texts = <boolean>, --optional, suppress all texts
		omega_disable = <boolean>, --optional, can't be used when omega is active
		alpha_disable = <boolean>, --optional, can't be used when alpha is active
		omega_override = <boolean>, --optional, overrides access when omega is active
		alpha_override = <boolean>, --optional, overrides access when alpha is active
		decon_override = <string>/<table>, --optional, overrides access when given zone/zones is being decontaminated
		disable_overload = <boolean>, --optional, if true, SCPs won't be able to overload this button
		advanced_overload = <boolean>, --optional, if true, overloading will take longer
		overload_delay = <boolean>, --optional, overrides close delay
		cooldown = <number>, --optional, overrides default cooldown
	}
	*/
	BUTTONS_CACHE = BUTTONS_CACHE or {}
	BUTTONS_NAME_CACHE = BUTTONS_NAME_CACHE or {}

	function HandleButtonUse( ply, ent, data )
		local omnitool
		local omnitoolused = false
		
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) and wep:GetClass() == "item_slc_omnitool" then
			omnitool = wep
		end

		local access, msg, target = hook.Run( "SLCButtonUse", ply, ent, data, omnitool )

		if access == nil and isfunction( data.override ) then
			access, msg, target = data.override( ply, ent, data )
		end

		if access == nil and ent.AccessOverride then
			access, msg, target = ent:AccessOverride( ply, data )
		end

		if !target then
			target = data.msg_target
		end

		if access == nil and data.access then
			access = false

			--SCP Overload
			if !data.disable_overload and SCPButtonOverload( ply, ent, data ) then
				return false
			end

			//if access == nil then
				if omnitool then
					omnitoolused = true
					access = omnitool:CanAccess( data.access )
				else
					--no omnitool
					//if data.msg_omnitool != "" then
					if !data.suppress_texts and msg != true then
						PlayerMessage( msg or data.msg_omnitool or "acc_omnitool", ply, true )
					end
					//end

					return false
				end
			//end
		end

		if access != false then
			--access granted

			if isfunction( data.access_granted ) and data.access_granted( ply, ent, data ) == true then
				return false
			end

			if omnitoolused then
				--has omnitool
				omnitool:UseOmnitool( ent, data, true, msg, false )

				if data.msg_access == "" or target != 2 then
					return false
				end
			end

			if ( !data.suppress_texts or target and target >= 1 ) and msg != true then
				PlayerMessage( msg or data.msg_access or "acc_granted", ply, true )
			end

			if !omnitoolused then
				return true
			end
		else
			if omnitoolused then
				--insufficient access/denied with omnitool
				omnitool:UseOmnitool( ent, data, false, msg, false )

				if target != 2 then
					//omnitool:PrintMessage( msg or data.msg_deny or "acc_wrong" )
					return false
				end
			end

			--denied
			//if data.msg_deny != "" then
			if ( !data.suppress_texts or target and target >= 1 ) and msg != true then
				if omnitoolused then
					PlayerMessage( msg or data.msg_wrong or "acc_wrong", ply, true )
				else
					PlayerMessage( msg or data.msg_deny or "acc_denied", ply, true )
				end
			end
			//end
		end

		return false
	end

	local function overload_effect( ply )
		local effect = EffectData()

		local spos = ply:GetShootPos()
		local pos = spos + ply:GetAimVector() * 25
	
		local trace = util.TraceHull{
			start = spos,
			endpos = pos,
			mins = Vector( -5, -5, -5 ),
			maxs = Vector( 5, 5, 5 ),
			mask = MASK_SOLID_BRUSHONLY
		}
	
		effect:SetOrigin( trace.HitPos )
		effect:SetNormal( trace.Hit and trace.HitNormal or (pos - spos):GetNormalized() )
		effect:SetRadius( 1 )
		effect:SetMagnitude( 2 )
		effect:SetScale( 2.5 )
	
		util.Effect( "ElectricSpark", effect, false, true )

		timer.Simple( 0.2, function()
			util.Effect( "ElectricSpark", effect, false, true )
		end )
	end

	function SCPButtonOverload( ply, ent, data )
		if ply:SCPTeam() != TEAM_SCP or ply:GetSCPHuman() or ply:GetSCPDisableOverload() then return false end
		if ROUND.post or ROUND.preparing then return true end

		if ply:IsDoingSLCTask() then
			return ply:IsDoingSLCTask( "button_overload" )
		end

		local ct = CurTime()
		local cd = ply:GetProperty( "overload_cd" )
		local override = hook.Run( "SLCOverloadOverride", ply, ent, data )
		if override == false or cd and cd >= ct and override != true then return true end
		
		ply:SetProperty( "overload_cd", ct + 3, true )
		
		if ent.OverloadCooldown and ent.OverloadCooldown >= ct and override != true then
			PlayerMessage( string.format( "overload_cooldown$%i", ent.OverloadCooldown - ct ), ply, true )
			return true
		end

		local adv = data.advanced_overload
		ply:StartSLCTask( "button_overload", CVAR.slc_overload_time:GetFloat() * ( adv and 2 or 1 ), function()
			return ply:KeyDown( IN_USE )
		end, true, IN_USE ):Then( function()
			local in_ct = CurTime()

			if !IsValid( ent ) or ent.OverloadCooldown and ent.OverloadCooldown >= in_ct then
				return true
			end

			ply:SetProperty( "overload_cd", in_ct + CVAR.slc_overload_cooldown:GetInt(), true )

			local door_cd = CVAR.slc_overload_door_cooldown:GetInt()

			if adv and !ent.AdvancedOverload then
				local adv_cd = CVAR.slc_overload_advanced_cooldown:GetInt()
				ent.OverloadCooldown = in_ct + adv_cd
				ent.AdvancedOverload = true
				
				ent:EmitSound( "SLCMisc.Overload" )
				overload_effect( ply )

				PlayerMessage( string.format( "advanced_overload$%i", adv_cd ), ply, true )

				hook.Run( "SLCButtonOverloaded", ply, ent, true )

				return true
			end

			ent.OverloadCooldown = in_ct + door_cd
			ent.IsOverloaded = true
			ent:Fire( "Use" )
			ent:EmitSound( "SLCMisc.Overload" )
			overload_effect( ply )

			hook.Run( "SLCButtonOverloaded", ply, ent, false )

			local delay = data.overload_delay or CVAR.slc_overload_delay:GetFloat()
			if delay > 0 then
				ent:Fire( "Lock" )
				return AddThenableTimer( "SLCButtonOverload"..ply:SteamID(), delay, 1 )
			end

			return true
		end ):Then( function( result )
			ent.IsOverloaded = false

			if !result then
				ent:Fire( "Unlock" )
				ent:Fire( "Use" )
			end
		end )/*:Catch( function( err )
			print( "Interrupted", err )
		end )*/

		return true
	end

	hook.Add( "EntityTakeDamage", "SLCButtonOverload", function( ply, info )
		if IsValid( ply ) and ply:IsPlayer() and ply:IsDoingSLCTask( "button_overload" ) and !info:IsDamageType( DMG_POISON ) then
			ply:StopSLCTask( 3 )
			ply:SetProperty( "overload_cd", CurTime() + 3, true )
		end
	end )

	function RegisterButton( data, ent, override )
		if IsValid( ent ) then
			if override or !BUTTONS_CACHE[ent] then
				BUTTONS_CACHE[ent] = data

				//print( "Button cached", ent )
				//PrintTable( data )
			end
		end
	end
	
	function GetButton( name )
		local cache = BUTTONS_NAME_CACHE[name]

		if cache == false then
			return
		elseif cache then
			return cache
		end

		for k, v in pairs( BUTTONS ) do
			if v.name != name then continue end

			local btn_pos = v.pos
			if istable( btn_pos ) then
				local ret = {}

				for _, tab_pos in pairs( btn_pos ) do
					for _, ent in ipairs( ents.GetAll() ) do
						if ent:GetPos() == tab_pos then
							table.insert( ret, ent )
							break
						end
					end
				end

				BUTTONS_NAME_CACHE[name] = ret
				return ret
			else
				for _, ent in ipairs( ents.GetAll() ) do
					local pos = ent:GetPos()
					if pos == v.pos or v.tolerance and pos:IsInTolerance( v.pos, v.tolerance ) then
						BUTTONS_NAME_CACHE[name] = ent
						return ent
					end
				end
			end

			BUTTONS_NAME_CACHE[name] = false
			return
		end
	end

	hook.Add( "SLCRoundCleanup", "SLCClearDoorCache", function()
		BUTTONS_CACHE = {}
		BUTTONS_NAME_CACHE = {}
	end )
end

hook.Add( "SLCModulesLoaded", "SLCAccessSetup", function()
	hook.Run( "SLCRegisterAccess" )
	hook.Run( "SLCRegisterChips" )

	for k, v in pairs( ACC_REGISTRY.CHIPS ) do
		local tab = {}
		ACC_REGISTRY.UPGRADES[k] = tab

		local upgrades = v.obj.Upgrades
		for mode = 0, 4 do --swap fors?
			local mode_data = upgrades[mode]
			if mode_data and #mode_data > 0 then
				local weights = {}
				local total = 0

				for i, data in ipairs( mode_data ) do
					total = total + data[1]
					table.insert( weights, { total, data[2] } )
				end

				tab[mode] = weights
			elseif mode == 0 then
				tab[mode] = { { 0, true } }
			elseif mode == 1 then
				tab[mode] = { { 15, true }, { 10, false } }
			end
		end
	end

	//PrintTable( ACC_REGISTRY )
end )

hook.Add( "SLCRegisterAccess", "SCLBaseAccess", function()
	RegisterAccess( "SAFE" )
	RegisterAccess( "EUCLID" )
	RegisterAccess( "KETER" )
	RegisterAccess( "OFFICE" )
	RegisterAccess( "MEDBAY" )
	RegisterAccess( "GENERAL" )
	RegisterAccess( "CHECKPOINT_LCZ" )
	RegisterAccess( "CHECKPOINT_EZ" )
	RegisterAccess( "WARHEAD_ELEVATOR" )
	RegisterAccess( "EC" )
	RegisterAccess( "ARMORY" )
	RegisterAccess( "GATE_A" )
	RegisterAccess( "GATE_B" )
	//RegisterAccess( "GATE_C" )
	RegisterAccess( "FEMUR" )
	RegisterAccess( "ALPHA" )
	RegisterAccess( "OMEGA" )
	RegisterAccess( "PARTICLE" )
end )

hook.Add( "SLCRegisterChips", "SCLBaseChips", function()
	RegisterChip( "jan", 1, { ACCESS_SAFE, ACCESS_GENERAL }, 3 )
	:AddUpgrade( UPGRADE_MODE.FINE, 12, "sci2" )
	:AddUpgrade( UPGRADE_MODE.FINE, 8, "spec" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 8, "sci2" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 12, "spec" )

	RegisterChip( "sci1", 1, { ACCESS_SAFE, ACCESS_GENERAL, ACCESS_OFFICE }, 5 )
	:AddUpgrade( UPGRADE_MODE.FINE, 12, "sci2" )
	:AddUpgrade( UPGRADE_MODE.FINE, 8, "spec" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 8, "sci2" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 12, "spec" )

	RegisterChip( "sci2", 2, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_OFFICE, ACCESS_GENERAL }, 6 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, "spec" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, "guard" )
	:AddUpgrade( UPGRADE_MODE.FINE, 15, "sci3" )
	:AddUpgrade( UPGRADE_MODE.FINE, 5, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 10, "sci3" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 4, "hacked3" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 4, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, true )

	RegisterChip( "sci3", 3, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_KETER, ACCESS_OFFICE, ACCESS_GENERAL, ACCESS_MEDBAY }, 7 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 0, "hacked3" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 10, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 4, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 4, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, true )

	RegisterChip( "spec", 2, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_EC, ACCESS_CHECKPOINT_LCZ, ACCESS_WARHEAD_ELEVATOR }, 8 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 5, "sci2" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, "guard" )
	:AddUpgrade( UPGRADE_MODE.FINE, 0, "hacked3" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 8, "hacked3" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, true )

	RegisterChip( "guard", 2, { ACCESS_SAFE, ACCESS_OFFICE, ACCESS_EC, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ }, 9 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, "sci2" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, "spec" )
	:AddUpgrade( UPGRADE_MODE.FINE, 0, "chief" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 10, "chief" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, false )

	RegisterChip( "chief", 3, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_OFFICE, ACCESS_GENERAL, ACCESS_EC, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ }, 10 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 0, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "com" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, true )

	RegisterChip( "mtf", 3, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_KETER, ACCESS_EC, ACCESS_MEDBAY, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ, ACCESS_GATE_A, ACCESS_GATE_B }, 11 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 0, "chief" )
	:AddUpgrade( UPGRADE_MODE.FINE, 15, "com" )
	:AddUpgrade( UPGRADE_MODE.FINE, 5, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 18, "com" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, true )

	RegisterChip( "com", 4, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_KETER, ACCESS_EC, ACCESS_ARMORY, ACCESS_MEDBAY, ACCESS_WARHEAD_ELEVATOR, ACCESS_CHECKPOINT_LCZ,
	ACCESS_CHECKPOINT_EZ, ACCESS_GATE_A, ACCESS_GATE_B }, 12 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, "director" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 10, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "hacked3" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "hacked5" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "chief" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "director" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "o5" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, true )


	RegisterChip( "hacked3", 3, {
		access = { ACCESS_SAFE, ACCESS_EUCLID },
		randomtable = { ACCESS_OFFICE, ACCESS_GENERAL, ACCESS_KETER, ACCESS_MEDBAY, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ, ACCESS_WARHEAD_ELEVATOR, ACCESS_EC,
						ACCESS_GATE_A },
		randomnum = 5
	}, 15 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 5, "sci3" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 15, "hacked3" ) --generate new access
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "chief" )
	:AddUpgrade( UPGRADE_MODE.FINE, 5, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 8, "chief" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 8, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 2, true )

	RegisterChip( "hacked4", 4, {
		access = { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_KETER },
		randomtable = { ACCESS_OFFICE, ACCESS_GENERAL, ACCESS_MEDBAY, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ, ACCESS_WARHEAD_ELEVATOR, ACCESS_EC, ACCESS_GATE_A,
						ACCESS_GATE_B, ACCESS_ARMORY, ACCESS_FEMUR, ACCESS_PARTICLE },
		randomnum = 6
	}, 16 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 15, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 5, false )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "hacked5" )
	:AddUpgrade( UPGRADE_MODE.FINE, 5, "mtf" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 10, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "hacked5" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, true )

	RegisterChip( "hacked5", 5, {
		access = { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_KETER },
		randomtable = { ACCESS_OFFICE, ACCESS_GENERAL, ACCESS_MEDBAY, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ, ACCESS_WARHEAD_ELEVATOR, ACCESS_EC, ACCESS_GATE_A,
						ACCESS_GATE_B, ACCESS_ARMORY, ACCESS_FEMUR, ACCESS_ALPHA, ACCESS_OMEGA, ACCESS_PARTICLE },
		randomnum = 7
	}, 17 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 15, "hacked5" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 5, "o5" )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 5, false )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "com" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 15, "com" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, true )

	RegisterChip( "director", 4, { ACCESS_SAFE, ACCESS_GENERAL, ACCESS_OFFICE, ACCESS_MEDBAY, ACCESS_EC, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ,
	ACCESS_WARHEAD_ELEVATOR, ACCESS_FEMUR, ACCESS_ARMORY, ACCESS_OMEGA, ACCESS_GATE_A, ACCESS_GATE_B, ACCESS_PARTICLE }, 13 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 0, "com" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "o5" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 15, "o5" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, true )

	RegisterChip( "o5", 5, { ACCESS_SAFE, ACCESS_EUCLID, ACCESS_KETER, ACCESS_OFFICE, ACCESS_MEDBAY, ACCESS_GENERAL, ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ,
	ACCESS_WARHEAD_ELEVATOR, ACCESS_EC, ACCESS_ARMORY, ACCESS_GATE_A, ACCESS_GATE_B, ACCESS_FEMUR, ACCESS_ALPHA, ACCESS_OMEGA, ACCESS_PARTICLE }, 14 )
	:AddUpgrade( UPGRADE_MODE.ONE_ONE, 0, "hacked5" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "jan" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 20, false )

	RegisterChip( "goc", 3, { ACCESS_CHECKPOINT_LCZ, ACCESS_CHECKPOINT_EZ, ACCESS_WARHEAD_ELEVATOR, ACCESS_GATE_A, ACCESS_GATE_B }, 16 )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, "hacked3" )
	:AddUpgrade( UPGRADE_MODE.FINE, 5, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.FINE, 10, false )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 10, "hacked4" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, "mtf" )
	:AddUpgrade( UPGRADE_MODE.VERY_FINE, 5, true )
end )