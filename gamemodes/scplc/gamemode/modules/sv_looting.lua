SLCLootPools = SLCLootPools or {}

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

function GenerateLootTable( name, num )
	local result = {}

	if SLCLootPools[name] then
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
			if math.random() < tab.chance then
				total = total + 1

				local rng = math.random( total_weight )
				local cur = 0

				for n, v in ipairs( tab.items ) do
					cur = cur + v.weight

					if rng <= cur then
						value = value + ( v.value or 0 )

						result[i] = {
							info = {
								class = v.class,
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

						if v.max and v.max > 0 then
							all[n] = ( all[n] or 0 ) + 1

							if all[n] >= v.max then
								total_weight = total_weight - v.weight
								v.weight = 0
							end
						end

						break
					end
				end

				if tab.max and tab.max > 0 and total >= tab.max then
					break
				end

				if tab.value_limit and tab.value_limit > 0 and value >= tab.value_limit then
					break
				end
			end
		end
	end

	return result
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
					local result = false
					local upd = false
					if obj.func then
						result, upd = obj.func( ply, obj.info.class, obj.info.data, obj.ntd )
					else
						local wep

						if table.Count( ply:GetWeapons() ) < 8 then
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

local function omnitool_post( ply, item, data, ntd )
	if ntd.chip_chance then
		if math.random() < ntd.chip_chance then
			local rng

			if ntd.chip_min then
				rng = math.random( ntd.chip_min, ntd.chip_max )
			else
				rng = math.random( ntd.chip_max )
			end

			local chip = GetChip( SelectChip( rng ) )
			item:SetChipData( chip, GenerateOverride( chip ) )
		end
	end
end

local function chip_post( ply, item, data, ntd )
	if ntd.chip then
		local chip = GetChip( ntd.chip )
		item:SetChipData( chip, GenerateOverride( chip ) )
	end
end

local function chip_roll( data )
	if data.ntd and data.ntd.chip_max then
		local rng

		if data.ntd.chip_min then
			rng = math.random( data.ntd.chip_min, data.ntd.chip_max )
		else
			rng = math.random( data.ntd.chip_max )
		end

		local chip = SelectChip( rng )
		data.ntd.chip = chip

		data.info.data = data.info.data or {}
		data.info.name = "WEAPONS.ACCESS_CHIP.NAMES."..chip
	end
end

//LCZ
AddLootPool( "lcz_loose_loot", {
	max = 3,
	value_limit = 100,
	chance = 0.25,
	items = {
		{ class = "item_slc_battery", weight = 8, value = 50, data = { amount = 2 } },
		{ class = "item_slc_battery", weight = 10, value = 25, },
		{ class = "item_slc_flashlight", weight = 10, value = 30 },
		{ class = "item_slc_radio", weight = 5, value = 75, max = 1 },
		{ class = "item_slc_nvg", weight = 5, value = 75, max = 1 },
		{ class = "item_slc_gasmask", weight = 5, value = 75, max = 1 },
	}
} )

AddLootPool( "lcz_large_loot", {
	max = 8,
	value_limit = 300,
	chance = 0.333,
	items = {
		{ class = "item_slc_battery", weight = 4, value = 75, max = 1, data = { amount = 3 } },
		{ class = "item_slc_battery", weight = 7, value = 50, max = 2, data = { amount = 2 } },
		{ class = "item_slc_battery", weight = 10, value = 25, max = 3 },
		{ class = "item_slc_flashlight", weight = 10, value = 30, max = 2 },
		{ class = "item_slc_radio", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_nvg", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_gasmask", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_omnitool", weight = 5, value = 125, max = 1, ntd = { chip_chance = 0.666, chip_max = 1 }, post = omnitool_post },
		{ class = "item_slc_access_chip", weight = 5, value = 100, max = 1, ntd = { chip_max = 1 }, post = chip_post, roll = chip_roll },
	}
} )

AddLootPool( "lcz_rare_loot", {
	max = 3,
	chance = 0.25,
	items = {
		{ class = "item_slc_battery", weight = 5, data = { amount = 3 } },
		{ class = "item_slc_nvg", weight = 5 },
		{ class = "item_slc_medkit", weight = 5 },
		{ class = "item_slc_omnitool", weight = 5, ntd = { chip_chance = 1, chip_max = 2 }, post = omnitool_post },
		{ class = "item_slc_access_chip", weight = 5, ntd = { chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "cw_mr96", weight = 5 },
	}
} )

AddLootPool( "lcz_valuable_loot", {
	value_limit = 200,
	chance = 0.333,
	items = {
		{ class = "item_slc_medkit", weight = 5, value = 50 },
		{ class = "item_slc_medkitplus", weight = 2, value = 100 },
		{ class = "item_slc_omnitool", weight = 5, value = 150, ntd = { chip_chance = 1, chip_max = 2 }, post = omnitool_post },
		{ class = "item_slc_access_chip", weight = 5, value = 100, ntd = { chip_max = 2 }, post = chip_post, roll = chip_roll },
		{ class = "weapon_taser", weight = 5, value = 150 },
		{ class = "item_scp_500", weight = 1, value = 999 },
	}
} )

AddLootPool( "lcz_military_crate", {
	max = 2,
	chance = 0.2,
	items = {
		{ class = "cw_deagle", weight = 5 },
		{ class = "cw_makarov", weight = 5 },
		{ class = "cw_mr96", weight = 5 },
		{ class = "weapon_taser", weight = 5, max = 1 },
	}
} )

//HCZ
AddLootPool( "hcz_large_loot", {
	max = 8,
	value_limit = 300,
	chance = 0.333,
	items = {
		{ class = "item_slc_battery", weight = 5, value = 50, max = 2, data = { amount = 2 } },
		{ class = "item_slc_nvg", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_camera", weight = 3, value = 100, max = 2 },
		{ class = "item_slc_gasmask", weight = 5, value = 75, max = 2 },
		{ class = "item_slc_medkit", weight = 3, value = 100, max = 2 },
		{ class = "item_slc_omnitool", weight = 5, value = 100, max = 1, ntd = { chip_chance = 1, chip_max = 2 }, post = omnitool_post },
		{ class = "item_slc_access_chip", weight = 5, value = 150, max = 2, ntd = { chip_max = 3 }, post = chip_post, roll = chip_roll },
	}
} )

AddLootPool( "hcz_035", {
	value_limit = 500,
	chance = 0.5,
	items = {
		{ class = "item_scp_500", weight = 3, value = 300 },
		{ class = "cw_deagle", weight = 5, value = 251 },
		{ class = "cw_makarov", weight = 5, value = 251 },
		{ class = "cw_mr96", weight = 5, value = 251 },
		{ class = "weapon_taser", weight = 7, value = 200 },
		{ class = "item_slc_battery", weight = 9, value = 50 },
		{ class = "item_slc_battery", weight = 7, value = 75, data = { amount = 2 } },
		{ class = "item_slc_radio", weight = 9, value = 50 },
		{ class = "item_slc_nvg", weight = 9, value = 50 },
		{ class = "item_slc_camera", weight = 7, value = 100 },
		{ class = "item_slc_flashlight", weight = 9, value = 50 },
		{ class = "item_slc_gasmask", weight = 9, value = 50 },
		{ class = "item_slc_medkit", weight = 7, value = 100 },
		{ class = "item_slc_medkitplus", weight = 7, value = 201 },
		{ class = "item_slc_omnitool", weight = 9, value = 125, ntd = { chip_chance = 1, chip_max = 2 }, post = omnitool_post },
		{ class = "item_slc_access_chip", weight = 7, value = 175, ntd = { chip_max = 3 }, post = chip_post, roll = chip_roll },
	}
} )

//EZ
AddLootPool( "ez_loose_loot", {
	max = 3,
	chance = 0.333,
	items = {
		{ class = "item_slc_battery", weight = 8, value = 25, },
		{ class = "item_slc_flashlight", weight = 8, value = 30 },
		{ class = "item_slc_radio", weight = 8, value = 75, max = 1 },
		{ class = "item_slc_access_chip", weight = 5, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_camera", weight = 5, max = 1 },
	}
} )

AddLootPool( "ez_valuable_loot", {
	value_limit = 200,
	chance = 0.333,
	items = {
		{ class = "item_slc_medkit", weight = 5, value = 50 },
		{ class = "item_slc_medkitplus", weight = 2, value = 100 },
		{ class = "item_slc_omnitool", weight = 5, value = 150, ntd = { chip_chance = 1, chip_min = 2, chip_max = 3 }, post = omnitool_post },
		{ class = "item_slc_access_chip", weight = 5, value = 100, ntd = { chip_min = 2, chip_max = 3 }, post = chip_post, roll = chip_roll },
		{ class = "weapon_taser", weight = 5, value = 150 },
		{ class = "item_scp_500", weight = 1, value = 999 },
	}
} )

//Special
AddLootPool( "guard_desk", {
	max = 2,
	chance = 0.2,
	items = {
		{ class = "item_slc_flashlight", weight = 6 },
		{ class = "item_slc_radio", weight = 6 },
		{ class = "cw_ar15", weight = 1 },
		{ class = "item_slc_access_chip", weight = 1, ntd = { chip_max = 4 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_turret", weight = 1 },
	}
} )

AddLootPool( "toilet", {
	chance = 0.25,
	items = {
		{ class = "item_slc_alpha_card1", weight = 1 },
		{ class = "item_slc_alpha_card2", weight = 1 },
		{ class = "cw_fiveseven", weight = 2 },
		{ class = "item_slc_access_chip", weight = 3, ntd = { chip_min = 3, chip_max = 5 }, post = chip_post, roll = chip_roll },
		{ class = "item_slc_gasmask", weight = 3, post = function( ply, item, data, ntd )
			item:SetUpgraded( true )
		end },
		{ class = "item_scp_500", weight = 5 },
		{ class = "item_slc_nvgplus", weight = 5 },
		{ class = "item_slc_medkitplus", weight = 5 },
		{ class = "item_slc_camera", weight = 5 },
		{ class = "weapon_taser", weight = 5 },
		{ class = "item_slc_battery", weight = 15 },
	}
} )

AddLootPool( "medbay", {
	max = 3,
	chance = 0.4,
	items = {
		{ class = "item_slc_medkit", weight = 9 },
		{ class = "item_slc_medkitplus", weight = 3 },
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