SLC_ITEMS_DATA = SLC_ITEMS_DATA or {}
SLC_ITEMS_AUTOSPAWN = SLC_ITEMS_AUTOSPAWN or {}
SLC_ITEMS_FUNCTION = SLC_ITEMS_FUNCTION or {}

/*
	data = {
		(
			item = "item_class" or { "item1", ... } or { item1 = <weight>, ... } or { item1 = { weight = <number>, [post_tab = {}], [post_func = <func>], [max* = <number>] }, ... }
			amount = <number> or {<number>, <number>} --exact amount or random between 2 numbers, nil - spawn all
		)
		or
		item_set = { --allows to use random set of items
			{
				item = "item_class" or { "item1", ... } or { item1 = <weight>, ... } or { item1 = { weight = <number>, [post_tab = {}], [post_func = <func>], [max* = <number>] }, ... }
				amount = <number> or {<number>, <number>} --exact amount or random between 2 numbers, nil - spawn all
				weight = <number> --weight of this set. If all sets has no weight, all have the same chance

				[spawns = {}]
				[post_tab = {}]
				[post_func = <function>]
			},
			...
		}

		spawns = {
			<Vector>,
			...
		}

		[post_tab = {}]
		[post_func = <function>]
	}

	max* - applies to item class, not specific item!
*/

local function calc_weight( tab )
	local total = 0

	for i, v in ipairs( tab ) do
		if !v.weight then
			return
		end

		total = total + v.weight
		v.roll = total
	end

	if total == 0 then
		return
	end

	return total
end

local function process_rule( data )
	local tab = {}

	local amount = data.amount
	local a_type = type( amount )

	if a_type == "table" then
		tab.rand_amount = data.amount
	elseif a_type == "number" then
		tab.amount = data.amount
	end

	local item = data.item
	local i_type = type( item )

	if i_type == "string" then --single item
		tab.item = item
	elseif i_type == "table" then
		local tmp = {}

		for k, v in pairs( item ) do
			local k_type = type( k )
			local v_type = type( v )

			local mode = 0

			if k_type == "number" then
				if v_type == "string" then
					mode = 1
				elseif v_type == "table" then
					mode = 3
				end
			elseif k_type == "string" then
				if v_type == "number" then
					mode = 2
				elseif v_type == "table" then
					mode = 3
				end
			end
	
			if mode == 1 then --item class
				table.insert( tmp, {
					class = v
				} )
			elseif mode == 2 then --weighted item
				table.insert( tmp, {
					class = k,
					weight = v
				} )
			elseif mode == 3 then --advanced item
				table.insert( tmp, {
					class = v.class or isstring(k) and k,
					weight = v.weight,
					max = v.max,
					post_tab = v.post_tab,
					post_func = v.post_func,
				} )
			end
		end

		tab.items = tmp
		tab.weight_data = calc_weight( tmp )
	end

	tab.spawns = data.spawns
	tab.post_tab = data.post_tab
	tab.post_func = data.post_func

	return tab
end

function ItemSpawnRule( name, data, auto )
	if data.item then
		local tab = process_rule( data )
		if tab and tab.spawns then
			SLC_ITEMS_DATA[name] = {
				items = { tab },
			}

			if auto then
				SLC_ITEMS_AUTOSPAWN[name] = true
			end
		end

		if DEVELOPER_MODE then
			for i, v in ipairs( data.spawns ) do
				table.insert( dev_item_draw_em, { v, name } )
			end
		end
	elseif data.item_set then
		local tmp = {}

		for i, v in pairs( data.item_set ) do
			local r = process_rule( v )
			if r then
				r.weight = v.weight
				r.spawns = r.spawns or data.spawns

				if data.spawns then
					table.insert( tmp, r )
				end
			end
		end

		SLC_ITEMS_DATA[name] = {
			items = tmp,
			weight_data = calc_weight( tmp ),
			post_tab = data.post_tab,
			post_func = data.post_func,
		}

		if auto then
			SLC_ITEMS_AUTOSPAWN[name] = true
		end
	end
end

local function select_item( tab )
	if !tab or !tab.items then return end

	local len = #tab.items

	if len == 0 then
		return
	elseif len == 1 then
		return tab.items[1]
	end

	if !tab.weight_data then
		return tab.items[math.random( len )]
	else
		local dice = math.random( tab.weight_data )
		local total = 0

		for i = 1, len do
			local v = tab.items[i]

			total = total + v.weight

			if total >= dice then
				return v, i
			end
		end

		ErrorNoHalt( "Failed to select weighted item! Did you tamper with table?" )
	end
end

local function apply_table( item, tab )
	for k, v in pairs( tab ) do
		if k != "_dnc" then
			if istable( v ) then
				item[k] = item[k] or {}
				apply_table( item[k], v )
			else
				item[k] = v
			end
		end
	end
end

function SpawnUsingRule( name )
	local rule = SLC_ITEMS_DATA[name]
	if rule then
		local tab = table.Copy( select_item( rule ) )
		if tab then
			local amount = tab.amount or tab.rand_amount and math.random( tab.rand_amount[1], tab.rand_amount[2] ) or #tab.spawns
			local counter = {}

			for i = 1, amount do
				local slen = #tab.spawns

				local post_tab = tab.post_tab or rule.post_tab
				local post_func = tab.post_func or rule.post_func

				if slen == 0 then
					break
				end

				local ent_class

				if tab.item then
					ent_class = tab.item
				else
					local item, num = select_item( tab )

					if !item then
						break
					end

					post_tab = item.post_tab or post_tab
					post_func = item.post_func or post_func

					local class = item.class
					ent_class = class

					if item.max then
						counter[class] = counter[class] and counter[class] + 1 or 1

						if counter[class] >= item.max then
							table.remove( tab.items, num )
							tab.weight_data = tab.weight_data - item.weight
						end
					end
				end

				local args = string.Explode( ":", ent_class )
				local key = table.remove( args, 1 )
				local fn_name = table.remove( args, 1 )

				if key == "loadout" and fn_name then
					ent_class = GetLoadoutWeapon( fn_name )
				end

				if ent_class == "_none" then
					if post_func then
						post_func( nil, i )
					end
				elseif key == "func" and fn_name then
					if !SLC_ITEMS_FUNCTION[fn_name] then
						print( "Unknown custom spawn function!", fn_name )
						continue
					end

					local data = {}
					local ent = SLC_ITEMS_FUNCTION[fn_name]( args, data )
					if IsValid( ent ) then
						local pos = table.remove( tab.spawns, math.random( slen ) )

						if data.offset then
							pos = pos + data.offset
						end

						ent:SetPos( pos )

						if post_tab then
							apply_table( ent, post_tab )
						end

						ent:Spawn()

						if post_func then
							post_func( ent, i )
						end
					end
				elseif ent_class then
					local ent = ents.Create( ent_class )
					if IsValid( ent ) then
						ent:SetPos( table.remove( tab.spawns, math.random( slen ) ) )

						if post_tab then
							apply_table( ent, post_tab )
						end

						ent:Spawn()

						if post_func then
							post_func( ent, i )
						end
					end
				end
			end
		end
	end
end

function SpawnItemGeneric( class, pos, num, post_tab, post_func )
	if isfunction( post_tab ) then
		post_func = post_tab
		post_tab = nil
	end

	if istable( pos ) then
		if !post_tab or !post_tab._dnc then
			pos = table.Copy( pos )
		end
	else
		pos = { pos }
	end

	local seq = false

	if num < 0 then
		num = #pos
		seq = true
	end

	for i = 1, num do
		local item = ents.Create( istable( class ) and class[math.random( #class )] or class )
		if IsValid( item ) then
			item:SetPos( seq and pos[i] or table.remove( pos, math.random( #pos ) ) )

			if post_tab then
				apply_table( item, post_tab )
			end

			item:Spawn()

			if post_func then
				post_func( item, i )
			end
		end
	end
end

function SpawnItemSingle( class, pos )
	local item = ents.Create( class )
	if IsValid( item ) then
		item:SetPos( pos )
		item:Spawn()
		item.Dropped = 0
	end
end

function ItemSpawnFunction( name, fn )
	SLC_ITEMS_FUNCTION[name] = fn
end

--[[-------------------------------------------------------------------------
Item spawn
---------------------------------------------------------------------------]]
local GAS_TABLE = {
	Touch = function( self, ent )
		if ent:IsPlayer() then
			if !ent.NextGasChoke or ent.NextGasChoke < CurTime() then
				ent.NextGasChoke = CurTime() + 2.5

				ent:ApplyEffect( "gas_choke" )
			end
		end
	end
}

local function GAS_POST( item, i )
	local data = GAS_DIM[i]
	item:SetTriggerBounds( data.mins, data.maxs, data.bounds )
end

function GM:SpawnItems()
	local post = { Dropped = 0 }
	//local post_dnc = { Dropped = 0, _dnc = true }

	if USE_LEGACY_ITEMS_SPAWN then
		--[[-------------------------------------------------------------------------
		Weapons
		---------------------------------------------------------------------------]]
		SpawnItemGeneric( "weapon_slc_pc", SPAWN_PARTICLE_CANNON, -1, post )

		SpawnItemGeneric( { "cw_deagle", "cw_makarov", "cw_mr96", "cw_p99" }, SPAWN_PISTOLS, -1, post )
		SpawnItemGeneric( { "cw_g36c", "cw_ump45", "cw_mp5", "cw_mac11" }, SPAWN_SMGS, -1, post )
		SpawnItemGeneric( { "cw_ak74", "cw_ar15", "cw_m14", "cw_scarh", "cw_l85a2", "cw_g3a3" }, SPAWN_RIFLES, -1, post )
		SpawnItemGeneric( { "cw_shorty", "cw_m3super90", "cw_xm1014_official", "cw_saiga12k_official" }, SPAWN_PUMP, -1, post )
		SpawnItemGeneric( "cw_svd_official", SPAWN_SNIPER, -1, post )

		SpawnItemGeneric( "weapon_crowbar", SPAWN_MELEE, 3, post )

		SpawnItemGeneric( "cw_ammo_kit_regular", SPAWN_AMMO_CW, -1, { AmmoCapacity = 20 } )

		--[[-------------------------------------------------------------------------
		SCP Items
		---------------------------------------------------------------------------]]
		SpawnItemSingle( "item_scp_714", SPAWN_714 )
		SpawnItemSingle( "item_scp_1025", SPAWN_1025 )

		SpawnItemGeneric( "item_scp_500", SPAWN_500, 3, post )

		--[[-------------------------------------------------------------------------
		Vests
		---------------------------------------------------------------------------]]
		for k,v in pairs( SPAWN_VEST ) do
			VEST.Create( VEST.GetRandomVest(), v - Vector( 0, 0, 10 ) )
		end

		--[[-------------------------------------------------------------------------
		Omnitools
		---------------------------------------------------------------------------]]
		for k, v in pairs( OMNITOOLS ) do
			local spawns = table.Copy( v.spawns )

			local amt = istable( v.amount ) and math.random( v.amount[1], v.amount[2] ) or v.amount
			for i = 1, amt do
				local len = #spawns

				if len == 0 then
					break
				end

				local omnitool = ents.Create( "item_slc_omnitool" )
				if IsValid( omnitool ) then
					omnitool:SetPos( table.remove( spawns, math.random( len ) ) )
					omnitool:Spawn()
					omnitool.Dropped = 0

					local chip
					local rng = math.random()
					if rng < 0.05 then --5%
						chip = SelectChip( 3 )
					elseif rng < 0.2 then --15%
						chip = SelectChip( 2 )
					elseif rng < 0.6 then --40%
						chip = SelectChip( 1 )
					end

					if chip then
						local obj = GetChip( chip )
						omnitool:SetChipData( obj, GenerateAccessOverride( obj ) )
					end
				end
			end
		end

		--[[-------------------------------------------------------------------------
		Chips
		---------------------------------------------------------------------------]]
		for k, v in pairs( CHIPS ) do
			local spawns = table.Copy( v.spawns )
			local amount = v.amount

			if istable( amount ) then
				amount = math.random( amount[1], amount[2] )
			end

			for i = 1, amount do
				local len = #spawns

				if len == 0 then
					break
				end

				local chip = CreateChip( SelectChip( v.level ) )
				if IsValid( chip ) then
					chip:SetPos( table.remove( spawns, math.random( len ) ) )
					chip:Spawn()
					chip.Dropped = 0
				end
			end
		end
	end

	--[[-------------------------------------------------------------------------
	Auto-spawn
	---------------------------------------------------------------------------]]
	for k, v in pairs( SLC_ITEMS_AUTOSPAWN ) do
		SpawnUsingRule( k )
	end

	--[[-------------------------------------------------------------------------
	Lootables
	---------------------------------------------------------------------------]]
	for k, v in pairs( LOOTABLES ) do
		local ent = ents.Create( "slc_lootable" )
		if IsValid( ent ) then
			ent:SetShouldRender( false )
			ent:SetPos( v.pos )
			ent:Spawn()

			ent:GenerateLoot( v.width, v.height, v.loot_pool )

			if v.bounds then
				ent:SetCollisionBounds( v.bounds.mins, v.bounds.maxs )
			end
		end
	end

	--[[-------------------------------------------------------------------------
	Cameras
	---------------------------------------------------------------------------]]
	for i, v in ipairs( CCTV ) do
		local cctv = ents.Create( "slc_cctv" )

		if IsValid( cctv ) then
			cctv:Spawn()
			cctv:SetPos( v.pos )

			cctv:SetCam( i )

			if v.destroy_alpha or v.destroy_omega then
				DestroyOnWarhead( cctv, v.destroy_alpha, v.destroy_omega )
			end

			if v.destroy_gatea then
				DestroyOnGateA( cctv )
			end

			v.ent = cctv
		end
	end

	--[[-------------------------------------------------------------------------
	Gas 
	---------------------------------------------------------------------------]]
	SpawnItemGeneric( "slc_trigger", GAS_POS, -1, GAS_TABLE, GAS_POST )

	hook.Run( "SLCSpawnItems" )
end

ItemSpawnFunction( "omnitool", function( args )
	local omnitool = ents.Create( "item_slc_omnitool" )
	if IsValid( omnitool ) then

		local chip
		local rng = math.random()

		for i = #args, 1, -1 do
			if rng < tonumber( args[i] ) / 100 then
				chip = SelectChip( i )
				break
			end
		end

		if chip then
			local obj = GetChip( chip )
			omnitool:SetChipData( obj, GenerateAccessOverride( obj ) )
		end

		return omnitool
	end
end )

ItemSpawnFunction( "chip", function( args )
	return CreateChip( SelectChip( tonumber( args[1] ) or 1 ) )
end )

ItemSpawnFunction( "vest", function( args, data )
	data.offset = Vector( 0, 0, tonumber( args[2] ) or 0 )
	return VEST.Create( args[1] == "?" and VEST.GetRandomVest() or args[1], nil )
end )

ItemSpawnFunction( "fuse", function( args, data )
	local fuse = ents.Create( "item_slc_fuse" )
	if IsValid( fuse ) then
		fuse:SetRating( args[2] and math.random( args[1], args[2] ) or args[1] or 5 )
		return fuse
	end
end )

ItemSpawnFunction( "backpack", function( args, data )
	return BACKPACK.Create( args[1] )
end )