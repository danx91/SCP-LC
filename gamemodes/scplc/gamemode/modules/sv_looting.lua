SLCLootPools = SLCLootPools or {}
SLCLootProcessors = SLCLootProcessors or {}
SLCLootFunctions = {}

--[[
	data = {
		max = 0, --max items inside one container
		value_limit = 0, --generating will be stopper when total 'value' of items exceeds this
		chance = 0, --chance of single slot having item
		items = {
			{	
				class = "", --item class
				weight = 0, --weight
				name = "", --optional, will override default name
				icon = "", --optional, path to material
				color = Color(), --optional, color
				value = 0, --optional, value of item
				max = 0, --optional, max amount
				data = <any>, --optional, passed to client and to post function
				ntd = <any>, --optional, (not transmitted data) passed to post function
				roll = function( tab ) end, --optional, called once this item is
				func = function( ply, class, data, ntd ) end, --optional, called before item is given, will override default behaviour
				post = function( ply, item, data, ntd ) end, --optional, called after item is given
			},
		}
	}
]]

function AddLootPool( name, data )
	SLCLootPools[name] = data

	for _, v in ipairs( data.items ) do
		if v.max and v.max > 0 then
			data.copy = true
			break
		end
	end
end

function AddItemToLootPool( name, item_tab )
	local pool = SLCLootPools[name]
	if !pool or !pool.items then return end

	table.insert( pool.items, item_tab )
end

function GenerateLootTable( name, num )
	local result = {}

	if !SLCLootPools[name] then return result end
	local tab
	
	if SLCLootPools[name].copy then
		tab = table.Copy( SLCLootPools[name] )
	else
		tab = SLCLootPools[name]
	end
	
	local total_weight = 0
	for _, v in ipairs( tab.items ) do
		total_weight = total_weight + v.weight
	end

	local total = 0
	local value = 0
	local all = {}
	for i = 1, num do
		if SLCRandom() >= tab.chance then continue end
		total = total + 1

		local rng = SLCRandom( total_weight )
		local cur = 0

		for n, v in ipairs( tab.items ) do
			cur = cur + v.weight
			if rng > cur then continue end

			local class

			if istable( v.class ) then
				class = v.class[SLCRandom( #v.class )]
			else
				local loadout = string.match( v.class, "^loadout:(.+)$" )
				if loadout then
					class = GetLoadoutWeapon( loadout, true )
				else
					class = v.class
				end
			end

			if !class then break end

			result[i] = {
				info = {
					class = class,
					name = v.name,
					icon = v.icon,
					color = v.color,
					data = v.data and table.Copy( v.data ),
				},

				ntd = v.ntd and table.Copy( v.ntd ),
				func = v.func,
				post = v.post,
			}

			if v.roll then v.roll( result[i] ) end

			value = value + ( v.value or 0 )

			if v.max and v.max > 0 then
				all[n] = ( all[n] or 0 ) + 1

				if all[n] >= v.max then
					total_weight = total_weight - v.weight
					v.weight = 0
				end
			end

			break
		end

		if tab.max and tab.max > 0 and total >= tab.max then
			break
		end

		if tab.value_limit and tab.value_limit > 0 and value >= tab.value_limit then
			break
		end
	end

	return result
end

function AddLootProcessor( class, func )
	SLCLootProcessors[class] = func
end

--net codes: 0 - close, 1 - open, 2 - update, 3 - deny
net.Receive( "SLCLooting", function( len, ply )
	local ent = ply.ActiveLootable
	if IsValid( ent ) and ent.Listeners[ply] then
		local status = net.ReadBool()
		if status then
		 	if ent:CanLoot( ply ) then
				local item = net.ReadUInt( 8 )
				local obj = ent.LootItems[item]
				local cache = ent.PlayersCache[ply]

				if !cache then
					cache = {}
					ent.PlayersCache[ply] = cache
				end

				if obj and cache[item] then
					local result, upd, wep

					if obj.func then
						result, upd, wep = obj.func( ply, obj.info.class, obj.info.data, obj.ntd )
					end
					
					if result == nil and !upd then
						if !IsValid( wep ) and ply:GetFreeInventory() > 0 and hook.Run( "SLCCanPickupWeaponClass", ply, obj.info.class ) != false then
							wep = ply:Give( obj.info.class )
						end

						if IsValid( wep ) then
							local data = obj.info.data

							if data and data.amount then
								data.amount = data.amount - 1
							end

							if !data or !data.amount or data.amount < 1 then
								result = true
							else
								upd = true
							end

							if obj.post then obj.post( ply, wep, obj.info.data, obj.ntd ) end
						else
							local pwep = ply:GetWeapon( obj.info.class )
							if IsValid( pwep ) and pwep.CanStack and pwep:CanStack() then
								pwep:Stack()

								local data = obj.info.data

								if data and data.amount then
									data.amount = data.amount - 1
								end

								if !data or !data.amount or data.amount < 1 then
									result = true
								else
									upd = true
								end
								
								if obj.post then obj.post( ply, pwep, obj.info.data, obj.ntd ) end
							end
						end
					end

					if result then
						ent.LootItems[item] = nil

						local send = {}

						for k, v in pairs( ent.Listeners ) do
							table.insert( send, k )
						end

						net.Start( "SLCLooting" )
							net.WriteUInt( 2, 2 )
							net.WriteUInt( item, 8 )
							net.WriteTable( { remove = true } )
						net.Send( send )
					elseif upd then
						local send = {}

						for k, v in pairs( ent.Listeners ) do
							if ent.PlayersCache[k] and ent.PlayersCache[k][item] then
								table.insert( send, k )
							end
						end

						net.Start( "SLCLooting" )
							net.WriteUInt( 2, 2 )
							net.WriteUInt( item, 8 )
							net.WriteTable( obj.info )
						net.Send( send )
					else
						net.Start( "SLCLooting" )
							net.WriteUInt( 3, 2 )
							net.WriteUInt( item, 8 )
						net.Send( ply )
					end
				elseif !ply.SearchingLoot or ply.SearchingLoot < CurTime() then
					local sig = ply:TimeSignature()
					local dur = CVAR.slc_time_looting:GetFloat()

					ply.SearchingLoot = CurTime() + dur
					AddTimer( ply:SteamID().."Examine", dur, 1, function()
						if IsValid( ply ) and IsValid( ent ) and ent.LootItems[item] and ply:CheckSignature( sig ) and ent.Listeners[ply] and ent:CanLoot( ply ) then
							ply.SearchingLoot = 0
							cache[item] = true

							net.Start( "SLCLooting" )
								net.WriteUInt( 2, 2 )
								net.WriteUInt( item, 8 )
								net.WriteTable( obj.info )
							net.Send( ply )
						end
					end )
				end
			else
				net.Start( "SLCLooting" )
					net.WriteUInt( 0, 2 )
				net.Send( ply )
			end
		else
			local t = GetTimer( ply:SteamID().."Examine" )
			if IsValid( t ) then
				t:Destroy()
			end

			ent.Listeners[ply] = nil
			ply.ActiveLootable = nil
		end
	end
end )

AddLootProcessor( "item_slc_access_chip", function( tab )
	local info = tab.info
	local data = info.data

	if data and data._stored then
		info.name = "@WEAPONS.ACCESS_CHIP.SHORT."..GetChipNameByID( data.chip_id )
	elseif tab.ntd and tab.ntd.chip then
		info.name = "@WEAPONS.ACCESS_CHIP.SHORT."..tab.ntd.chip
	end
end )

AddLootProcessor( "item_slc_omnitool", function( tab )
	local info = tab.info
	local data = info.data

	if data and data.chip_id < 0 then return end

	if data and data._stored then
		info.alt = "@WEAPONS.ACCESS_CHIP.SHORT."..GetChipNameByID( data.chip_id )
	elseif tab.ntd and tab.ntd.chip then
		info.alt = "@WEAPONS.ACCESS_CHIP.SHORT."..tab.ntd.chip
	end
end )

AddLootProcessor( "item_slc_fuse", function( tab )
	local info = tab.info
	local data = info.data

	if data and data._stored then
		info.name = "@WEAPONS.FUSE.name_f:"..data.rating
	elseif tab.ntd and tab.ntd.rating then
		info.name = "@WEAPONS.FUSE.name_f:"..tab.ntd.rating
	end
end )

--[[-------------------------------------------------------------------------
Base loot
---------------------------------------------------------------------------]]
local function chip_roll( data )
	if !data.ntd then return end

	if data.ntd.chip_chance then
		if SLCRandom() >= data.ntd.chip_chance then return end
	end

	if data.ntd.chip_max then
		local rng

		if data.ntd.chip_min then
			rng = SLCRandom( data.ntd.chip_min, data.ntd.chip_max )
		else
			rng = SLCRandom( data.ntd.chip_max )
		end

		local chip = SelectChip( rng, data.ntd.blacklist )
		data.ntd.chip = chip
	end
end

local function chip_post( ply, item, data, ntd )
	if !ntd.chip then return end

	local chip = GetChip( ntd.chip )
	item:SetChipData( chip, GenerateAccessOverride( chip ) )
end

local function ammo_roll( data )
	if data.ntd and data.ntd.max then
		local rng

		if data.ntd.min then
			rng = SLCRandom( data.ntd.min, data.ntd.max )
		else
			rng = SLCRandom( data.ntd.max )
		end

		data.info.data = data.info.data or {}
		data.info.data.amount = rng
	end
end

local function ammo_func( ply, class, data, ntd )
	local wep = ply:GetMainWeapon()
	if !IsValid( wep ) then return false end

	local num = ply:GiveAmmo( data.amount, wep:GetPrimaryAmmoType(), true )
	if num == 0 then return false end

	if num >= data.amount then
		return true
	end

	data.amount = data.amount - num

	return false, true
end

SLCLootFunctions.ammo = ammo_func

local function fuse_roll( data )
	if !data.ntd then return end
	data.ntd.rating = SLCRandom( data.ntd.min, data.ntd.max )
end

local function fuse_post( ply, item, data, ntd )
	if !ntd.rating then return end
	item:SetRating( ntd.rating )
end

//LCZ
AddLootPool( "lcz_loose_loot", {
	max = 4,
	value_limit = 120,
	chance = 0.3,
	items = {
		{ class = "item_slc_battery", weight = 5, value = 50, max = 1, data = { amount = 2 } },
		{ class = "item_slc_battery", weight = 8, value = 25, max = 1 },
		{ class = "item_slc_flashlight", weight = 10, value = 30, max = 1 },
		{ class = "item_slc_radio", weight = 5, value = 75, max = 1 },
		{ class = "item_slc_nvg", weight = 5, value = 75, max = 1 },
		{ class = "item_slc_gasmask", weight = 5, value = 75, max = 1 },
		{ class = "item_slc_snav", weight = 5, value = 85, max = 1 },
		{ class = "__slc_ammo", weight = 3, value = 75, max = 1, ntd = { max = 6 }, roll = ammo_roll, func = ammo_func },
	}
} )

AddLootPool( "lcz_large_loot", {
	value_limit = 375,
	chance = 0.45,
	items = {
		{ class = "item_slc_battery", weight = 4, value = 75, max = 1, data = { amount = 3 } },
		{ class = "item_slc_battery", weight = 7, value = 50, max = 1, data = { amount = 2 } },
		{ class = "item_slc_battery", weight = 10, value = 25, max = 2 },
		{ class = "item_slc_flashlight", weight = 10, value = 30, max = 2 },
		{ class = "item_slc_radio", weight = 6, value = 75, max = 2 },
		{ class = "item_slc_nvg", weight = 6, value = 75, max = 2 },
		{ class = "item_slc_snav", weight = 6, value = 100, max = 1 },
		{ class = "item_slc_gasmask", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_omnitool", weight = 5, value = 125, max = 1, ntd = { chip_chance = 0.666, chip_max = 1 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 5, value = 100, max = 1, ntd = { chip_max = 1 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_fuse", weight = 3, value = 75, max = 1, ntd = { min = 1, max = 3 }, post = fuse_post, roll = fuse_roll },
		{ class = "__slc_ammo", weight = 3, value = 75, max = 2, ntd = { min = 3, max = 6 }, roll = ammo_roll, func = ammo_func },
	}
} )

AddLootPool( "lcz_rare_loot", {
	max = 2,
	chance = 0.35,
	items = {
		{ class = "item_slc_battery", weight = 2, max = 1, data = { amount = 3 } },
		{ class = "item_slc_battery", weight = 3, max = 1, data = { amount = 2 } },
		{ class = "item_slc_nvg", weight = 5, max = 1 },
		{ class = "item_slc_snav", weight = 4, max = 1 },
		{ class = "item_slc_nvgplus", weight = 2, max = 1 },
		{ class = "item_slc_thermal", weight = 1, max = 1 },
		{ class = "item_slc_medkit", weight = 5, max = 1 },
		{ class = "item_slc_morphine", weight = 1, max = 1 },
		{ class = "item_slc_adrenaline", weight = 1, max = 1 },
		{ class = "item_slc_ephedrine", weight = 1, max = 1 },
		{ class = "item_slc_hemostatic", weight = 1, max = 1 },
		{ class = "item_slc_omnitool", weight = 5, max = 1, ntd = { chip_chance = 1, chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 5, max = 1, ntd = { chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_fuse", weight = 3, max = 1, ntd = { min = 2, max = 5 }, post = fuse_post, roll = fuse_roll },
		{ class = "loadout:pistol_low", weight = 2, max = 1 },
		{ class = "loadout:melee_low", weight = 3, max = 1 },
		{ class = "__slc_ammo", weight = 3, max = 1, ntd = { min = 6, max = 12 }, roll = ammo_roll, func = ammo_func },
	}
} )

AddLootPool( "lcz_toilet", {
	max = 1,
	chance = 1,
	items = {
		{ class = "item_slc_battery", weight = 2, max = 1, data = { amount = 3 } },
		{ class = "item_slc_battery", weight = 3, max = 1, data = { amount = 2 } },
		{ class = "item_slc_nvg", weight = 5, max = 1 },
		{ class = "item_slc_snav", weight = 4, max = 1 },
		{ class = "item_slc_nvgplus", weight = 2, max = 1 },
		{ class = "item_slc_medkit", weight = 5, max = 1 },
		{ class = "item_slc_morphine", weight = 1, max = 1 },
		{ class = "item_slc_adrenaline", weight = 1, max = 1 },
		{ class = "item_slc_ephedrine", weight = 1, max = 1 },
		{ class = "item_slc_hemostatic", weight = 1, max = 1 },
		{ class = "item_slc_omnitool", weight = 5, max = 1, ntd = { chip_chance = 1, chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 5, max = 1, ntd = { chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_fuse", weight = 3, max = 1, ntd = { min = 2, max = 5 }, post = fuse_post, roll = fuse_roll },
		{ class = "loadout:pistol_low", weight = 2, max = 1 },
		{ class = "loadout:melee_low", weight = 3, max = 1 },
		{ class = "__slc_ammo", weight = 3, max = 1, ntd = { min = 6, max = 12 }, roll = ammo_roll, func = ammo_func },
	}
} )

AddLootPool( "lcz_valuable_loot", {
	value_limit = 250,
	chance = 0.35,
	items = {
		{ class = "item_slc_nvg", weight = 4, value = 25 },
		{ class = "item_slc_nvgplus", weight = 3, value = 125 },
		{ class = "item_slc_snav", weight = 3, value = 100 },
		{ class = "item_slc_snav_ultimate", weight = 1, value = 250 },
		{ class = "item_slc_thermal", weight = 2, value = 150 },
		{ class = "item_slc_medkit", weight = 6, value = 50 },
		{ class = "item_slc_medkitplus", weight = 1, value = 200 },
		{ class = "item_slc_morphine", weight = 2, value = 165 },
		{ class = "item_slc_adrenaline", weight = 2, value = 165 },
		{ class = "item_slc_ephedrine", weight = 2, value = 165 },
		{ class = "item_slc_hemostatic", weight = 2, value = 165 },
		{ class = "item_slc_antidote", weight = 2, value = 165 },
		{ class = "item_slc_poison", weight = 1, value = 225 },
		{ class = "item_slc_omnitool", weight = 6, value = 100, ntd = { chip_chance = 1, chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 6, value = 75, ntd = { chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "weapon_taser", weight = 3, value = 175 },
		{ class = "loadout:melee_low", weight = 3, value = 75 },
		{ class = "loadout:melee_mid", weight = 1, value = 200 },
		{ class = "item_scp_500", weight = 1, value = 999 },
	}
} )

AddLootPool( "lcz_military_crate", {
	max = 3,
	chance = 0.225,
	items = {
		{ class = "loadout:pistol_mid", weight = 2 },
		{ class = "loadout:pistol_low", weight = 5 },
		{ class = "weapon_taser", weight = 3, max = 1 },
		{ class = "__slc_ammo", weight = 15, max = 1, ntd = { min = 5, max = 15 }, roll = ammo_roll, func = ammo_func },
		{ class = "cw_kk_ins2_nade_m84", weight = 3, max = 1 },
		{ class = "cw_kk_ins2_nade_m18", weight = 3, max = 1 },
		{ class = "cw_kk_ins2_nade_anm14", weight = 2, max = 1 },
		{ class = "loadout:melee_mid", weight = 3, max = 1 },
		{ class = "item_slc_thermal", weight = 2, max = 1 },
	}
} )

//HCZ
AddLootPool( "hcz_large_loot", {
	max = 8,
	value_limit = 350,
	chance = 0.35,
	items = {
		{ class = "item_slc_battery", weight = 3, value = 50, max = 1, data = { amount = 2 } },
		{ class = "item_slc_nvg", weight = 3, value = 75, max = 2 },
		{ class = "item_slc_snav", weight = 3, value = 100, max = 2 },
		{ class = "item_slc_nvgplus", weight = 2, value = 125, max = 1 },
		{ class = "item_slc_thermal", weight = 1, value = 150, max = 1 },
		{ class = "item_slc_cctv", weight = 3, value = 100, max = 2 },
		{ class = "item_slc_gasmask", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_medkit", weight = 5, value = 100, max = 2 },
		{ class = "item_slc_morphine", weight = 2, value = 75, max = 1 },
		{ class = "item_slc_adrenaline", weight = 2, value = 75, max = 1 },
		{ class = "item_slc_ephedrine", weight = 2, value = 75, max = 1 },
		{ class = "item_slc_hemostatic", weight = 2, value = 75, max = 1 },
		{ class = "item_slc_antidote", weight = 2, value = 75, max = 1 },
		{ class = "item_slc_omnitool", weight = 5, value = 100, max = 1, ntd = { chip_chance = 1, chip_min = 2, chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 5, value = 150, max = 2, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "__slc_ammo", weight = 3, value = 75, max = 2, ntd = { min = 6, max = 18 }, roll = ammo_roll, func = ammo_func },
		{ class = "loadout:melee_mid", weight = 3, value = 150, max = 1 },
	}
} )

AddLootPool( "hcz_valuable_loot", {
	max = 4,
	value_limit = 350,
	chance = 0.6,
	items = {
		{ class = "item_slc_nvgplus", weight = 3, value = 200, max = 1 },
		{ class = "item_slc_snav_ultimate", weight = 2, value = 300, max = 1 },
		{ class = "item_slc_thermal", weight = 2, value = 250, max = 1 },
		{ class = "item_slc_medkit", weight = 4, value = 75, max = 2 },
		{ class = "item_slc_medkitplus", weight = 2, value = 100, max = 1 },
		{ class = "item_slc_morphine", weight = 3, value = 75, max = 1 },
		{ class = "item_slc_adrenaline", weight = 3, value = 75, max = 1 },
		{ class = "item_slc_ephedrine", weight = 3, value = 75, max = 1 },
		{ class = "item_slc_hemostatic", weight = 3, value = 75, max = 1 },
		{ class = "item_slc_antidote", weight = 3, value = 75, max = 1 },
		{ class = "item_slc_poison", weight = 2, value = 125, max = 1 },
		{ class = "loadout:pistol_mid", weight = 5, value = 225, max = 1 },
		{ class = "item_slc_omnitool", weight = 4, value = 125, max = 1, ntd = { chip_chance = 1, chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 4, value = 125, max = 2, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "__slc_ammo", weight = 3, value = 75, max = 2, ntd = { min = 6, max = 18 }, roll = ammo_roll, func = ammo_func },
	}
} )

AddLootPool( "hcz_035", {
	value_limit = 750,
	chance = 0.6,
	items = {
		{ class = "item_scp_500", weight = 4, value = 300 },
		{ class = "loadout:shotgun_mid", weight = 6, value = 450, max = 1 },
		{ class = "loadout:pistol_high", weight = 8, value = 250 },
		{ class = "loadout:pistol_mid", weight = 9, value = 225 },
		{ class = "weapon_taser", weight = 8, value = 200, max = 1 },
		{ class = "item_slc_battery", weight = 3, value = 25, max = 1 },
		{ class = "item_slc_battery", weight = 4, value = 50, max = 1, data = { amount = 2 } },
		{ class = "item_slc_radio", weight = 4, value = 50, max = 2 },
		{ class = "item_slc_nvg", weight = 6, value = 50 },
		{ class = "item_slc_nvgplus", weight = 3, value = 200, max = 1 },
		{ class = "item_slc_snav", weight = 5, value = 90, max = 1 },
		{ class = "item_slc_snav_ultimate", weight = 2, value = 225, max = 1 },
		{ class = "item_slc_thermal", weight = 3, value = 250, max = 1 },
		{ class = "item_slc_cctv", weight = 4, value = 100 },
		{ class = "item_slc_flashlight", weight = 4, value = 50, max = 1 },
		{ class = "item_slc_gasmask", weight = 8, value = 50 },
		{ class = "item_slc_medkit", weight = 6, value = 100 },
		{ class = "item_slc_medkitplus", weight = 5, value = 201 },
		{ class = "item_slc_morphine", weight = 4, value = 150 },
		{ class = "item_slc_adrenaline", weight = 4, value = 150 },
		{ class = "item_slc_ephedrine", weight = 4, value = 150 },
		{ class = "item_slc_hemostatic", weight = 4, value = 150 },
		{ class = "item_slc_antidote", weight = 4, value = 150 },
		{ class = "item_slc_poison", weight = 4, value = 175 },
		{ class = "item_slc_omnitool", weight = 9, value = 125, max = 1, ntd = { chip_chance = 0.9, chip_min = 2, chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 7, value = 175, max = 2, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "__slc_ammo", weight = 5, value = 75, max = 3, ntd = { min = 10, max = 25 }, roll = ammo_roll, func = ammo_func },
		{ class = "cw_kk_ins2_nade_m84", weight = 4, value = 200, max = 1 },
		{ class = "cw_kk_ins2_nade_m18", weight = 4, value = 200, max = 1 },
		{ class = "cw_kk_ins2_nade_m67", weight = 4, value = 200, max = 1 },
		{ class = "cw_kk_ins2_nade_molotov", weight = 3, value = 200, max = 1 },
		{ class = "loadout:melee_mid", weight = 3, value = 100, max = 1 },
	}
} )

//EZ
AddLootPool( "ez_loose_loot", {
	max = 3,
	chance = 0.5,
	items = {
		{ class = "item_slc_battery", weight = 4, max = 1 },
		{ class = "item_slc_flashlight", weight = 4, max = 1 },
		{ class = "item_slc_radio", weight = 6, max = 1 },
		{ class = "item_slc_cctv", weight = 5, max = 1 },
		{ class = "item_slc_nvg", weight = 5, max = 1 },
		{ class = "item_slc_nvgplus", weight = 1, max = 1 },
		{ class = "item_slc_access_chip", weight = 5, max = 1, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "__slc_ammo", weight = 5, max = 1, ntd = { min = 10, max = 25 }, roll = ammo_roll, func = ammo_func },
		{ class = "loadout:melee_mid", weight = 2, max = 1 },
	}
} )

AddLootPool( "ez_large_loot", {
	value_limit = 600,
	chance = 0.4,
	items = {
		{ class = "item_slc_battery", weight = 4, value = 30, data = { amount = 2 } },
		{ class = "item_slc_flashlight", weight = 4, value = 30 },
		{ class = "item_slc_radio", weight = 4, value = 45 },
		{ class = "item_slc_cctv", weight = 4, value = 45 },
		{ class = "item_slc_nvg", weight = 5, value = 45 },
		{ class = "item_slc_nvgplus", weight = 2, value = 200 },
		{ class = "item_slc_thermal", weight = 1, value = 275 },
		{ class = "item_slc_medkit", weight = 5, value = 125 },
		{ class = "item_slc_medkitplus", weight = 2, value = 225 },
		{ class = "item_slc_morphine", weight = 3, value = 150 },
		{ class = "item_slc_adrenaline", weight = 3, value = 150 },
		{ class = "item_slc_ephedrine", weight = 3, value = 150 },
		{ class = "item_slc_hemostatic", weight = 3, value = 150 },
		{ class = "item_slc_antidote", weight = 3, value = 150 },
		{ class = "item_slc_poison", weight = 1, value = 225, max = 1 },
		{ class = "item_slc_omnitool", weight = 5, value = 175, ntd = { chip_chance = 1, chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 5, value = 120, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "loadout:pistol_mid", weight = 3, value = 301, max = 1 },
		{ class = "__slc_ammo", weight = 5, value = 75, max = 2, ntd = { min = 9, max = 27 }, roll = ammo_roll, func = ammo_func },
		{ class = "cw_kk_ins2_nade_m84", weight = 1, value = 200 },
		{ class = "cw_kk_ins2_nade_m18", weight = 1, value = 200 },
		{ class = "cw_kk_ins2_nade_f1", weight = 1, value = 200 },
		{ class = "cw_kk_ins2_nade_molotov", weight = 1, value = 200 },
		{ class = "loadout:melee_mid", weight = 2, max = 150 },
	}
} )

AddLootPool( "ez_rare_loot", {
	max = 2,
	chance = 0.15,
	items = {
		{ class = "item_slc_nvgplus", weight = 2, max = 1 },
		{ class = "item_slc_snav_ultimate", weight = 1, max = 1 },
		{ class = "item_slc_thermal", weight = 1, max = 1 },
		{ class = "item_slc_medkit", weight = 5, max = 1 },
		{ class = "item_slc_medkitplus", weight = 2, max = 1 },
		{ class = "item_slc_morphine", weight = 3 },
		{ class = "item_slc_adrenaline", weight = 3 },
		{ class = "item_slc_ephedrine", weight = 2 },
		{ class = "item_slc_hemostatic", weight = 2 },
		{ class = "item_slc_antidote", weight = 2 },
		{ class = "item_slc_access_chip", weight = 5, ntd = { chip_min = 3, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "weapon_taser", weight = 5 },
		{ class = "item_scp_500", weight = 1 },
		{ class = "__slc_ammo", weight = 3, max = 1, ntd = { min = 15, max = 45 }, roll = ammo_roll, func = ammo_func },
		{ class = "cw_kk_ins2_nade_m84", weight = 2, max = 1 },
		{ class = "cw_kk_ins2_nade_m18", weight = 2, max = 1 },
		{ class = "cw_kk_ins2_nade_f1", weight = 2, max = 1 },
		{ class = "cw_kk_ins2_nade_molotov", weight = 1, max = 1 },
	}
} )

AddLootPool( "ez_valuable_loot", {
	value_limit = 375,
	chance = 0.3,
	items = {
		{ class = "item_slc_nvg", weight = 5, value = 30, max = 1 },
		{ class = "item_slc_nvgplus", weight = 2, value = 175 },
		{ class = "item_slc_snav", weight = 4, value = 90, max = 1 },
		{ class = "item_slc_snav_ultimate", weight = 2, value = 300, max = 1 },
		{ class = "item_slc_thermal", weight = 1, value = 275 },
		{ class = "item_slc_medkit", weight = 5, value = 50 },
		{ class = "item_slc_medkitplus", weight = 2, value = 100 },
		{ class = "item_slc_morphine", weight = 3, value = 75 },
		{ class = "item_slc_adrenaline", weight = 3, value = 75 },
		{ class = "item_slc_ephedrine", weight = 3, value = 75 },
		{ class = "item_slc_hemostatic", weight = 3, value = 75 },
		{ class = "item_slc_antidote", weight = 3, value = 75 },
		{ class = "item_slc_omnitool", weight = 5, value = 150, max = 1, ntd = { chip_chance = 1, chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_access_chip", weight = 5, value = 100, max = 1, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "weapon_taser", weight = 5, max = 1, value = 150 },
		{ class = "item_scp_500", weight = 1, max = 1, value = 999 },
		{ class = "cw_kk_ins2_nade_m84", weight = 3, value = 175, max = 1 },
		{ class = "cw_kk_ins2_nade_m18", weight = 3, value = 175, max = 1 },
		{ class = "cw_kk_ins2_nade_f1", weight = 3, value = 175, max = 1 },
		{ class = "cw_kk_ins2_nade_molotov", weight = 2, value = 175, max = 1 },
	}
} )

//Special
AddLootPool( "guard_desk", {
	max = 2,
	chance = 0.5,
	items = {
		{ class = "item_slc_flashlight", weight = 6 },
		{ class = "loadout:melee_low", weight = 6 },
		{ class = "item_slc_radio", weight = 6 },
		{ class = "item_slc_snav", weight = 6 },
		{ class = "loadout:melee_mid", weight = 4 },
		{ class = "item_slc_adrenaline", weight = 3 },
		{ class = "item_slc_morphine", weight = 3 },
		{ class = "item_slc_ephedrine", weight = 3 },
		{ class = "item_slc_hemostatic", weight = 3 },
		{ class = "item_slc_antidote", weight = 3 },
		{ class = "item_slc_poison", weight = 2 },
		{ class = "item_slc_snav_ultimate", weight = 2 },
		{ class = "cw_kk_ins2_nade_m67", weight = 2 },
		{ class = "item_slc_access_chip", weight = 1, ntd = { chip_max = 4 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_turret", weight = 1 },
		{ class = "cw_ar15", weight = 1 },
	}
} )

AddLootPool( "toilet", {
	chance = 1,
	items = {
		{ class = "item_slc_alpha_card1", weight = 1 },
		{ class = "item_slc_alpha_card2", weight = 1 },
		{ class = "item_slc_commander_tablet", weight = 1 },
		{ class = "weapon_slc_pc", weight = 1 },
		{ class = "item_slc_morphine", weight = 1, post = function( ply, item, data, ntd ) item.ExtraHealth = 999 item.SelfInjectSpeed = 0.1 item.InjectSpeed = 0.1 end },
		{ class = "item_slc_adrenaline", weight = 1, post = function( ply, item, data, ntd ) item.BoostTime = 300 item.SelfInjectSpeed = 0.1 item.InjectSpeed = 0.1 end },
		{ class = "item_slc_ephedrine", weight = 1, post = function( ply, item, data, ntd ) item.BoostPower = 1.9 item.SelfInjectSpeed = 0.1 item.InjectSpeed = 0.1 end },
		{ class = "item_slc_hemostatic", weight = 1, post = function( ply, item, data, ntd ) item.BoostTime = 1200 item.SelfInjectSpeed = 0.1 item.InjectSpeed = 0.1 end },
		{ class = "item_slc_antidote", weight = 1, post = function( ply, item, data, ntd ) item.BoostTime = 900 item.SelfInjectSpeed = 0.1 item.InjectSpeed = 0.1 end },
		{ class = "item_slc_poison", weight = 1, post = function( ply, item, data, ntd ) item.PoisonTick = 0.1 item.PoisonDamage = 5 item.SelfInjectSpeed = 0.1 item.InjectSpeed = 0.1 end },
		{ class = "__slc_ammo", weight = 1, ntd = { min = 333, max = 999 }, roll = ammo_roll, func = ammo_func },
		{ class = "cw_fiveseven", weight = 2 },
		{ class = "item_scp_009", weight = 2 },
		{ class = "item_slc_battery_x", weight = 2 },
		{ class = "item_slc_access_chip", weight = 2, ntd = { chip_min = 4, chip_max = 5 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_gasmask", weight = 3, post = function( ply, item, data, ntd ) item:SetUpgraded( true ) end },
		{ class = "item_slc_snav_ultimate", weight = 4 },
		{ class = "item_scp_500", weight = 5 },
		{ class = "item_slc_nvgplus", weight = 5 },
		{ class = "item_slc_thermal", weight = 5 },
		{ class = "item_slc_medkitplus", weight = 5 },
		{ class = "weapon_taser", weight = 5 },
		{ class = "weapon_slc_glass_knife", weight = 5, post = function( ply, item, data, ntd ) item.AttackDamage = 1 item.StrongAttackDamage = 99 end },
		{ class = "item_slc_turret", weight = 5 },
		{ class = "item_slc_snav", weight = 5 },
		{ class = "item_slc_heavymask", weight = 10 },
		{ class = "item_slc_cctv", weight = 15 },
		{ class = "item_slc_battery", weight = 15 },
	}
} )

AddLootPool( "medbay", {
	max = 5,
	chance = 0.5,
	items = {
		{ class = "item_slc_medkit", weight = 18 },
		{ class = "item_slc_medkitplus", weight = 6 },
		{ class = "item_slc_morphine", weight = 4 },
		{ class = "item_slc_adrenaline", weight = 4 },
		{ class = "item_slc_ephedrine", weight = 4 },
		{ class = "item_slc_hemostatic", weight = 4 },
		{ class = "item_slc_antidote", weight = 4 },
		{ class = "item_slc_morphine_big", weight = 2 },
		{ class = "item_slc_adrenaline_big", weight = 2 },
		{ class = "item_slc_ephedrine_big", weight = 2 },
		{ class = "item_slc_hemostatic_big", weight = 2 },
		{ class = "item_slc_antidote_big", weight = 2 },
		
	}
} )

AddLootPool( "test", {
	max = 4,
	chance = 1,
	items = {
		{ class = "weapon_crowbar", weight = 6 },
		{ class = "weapon_stunstick", weight = 6 },
	}
} )