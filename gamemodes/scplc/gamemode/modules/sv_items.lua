SLC_ITEMS_DATA = SLC_ITEMS_DATA or {}
SLC_ITEMS_DATA_DEFINITIONS = SLC_ITEMS_DATA_DEFINITIONS or {}
SLC_ITEMS_AUTOSPAWN = SLC_ITEMS_AUTOSPAWN or {}
SLC_ITEMS_FUNCTION = SLC_ITEMS_FUNCTION or {}
SLC_ITEMS_OVERRIDES = SLC_ITEMS_OVERRIDES or {}

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

local function process_item( key, value )
	local k_type = type( key )
	local v_type = type( value )

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
		return {
			class = value,
			weight = 1,
		}
	elseif mode == 2 then --weighted item
		return {
			class = key,
			weight = value
		}
	elseif mode == 3 then --advanced item
		return {
			class = value.class or isstring( key ) and key,
			weight = value.weight,
			max = value.max,
			post_tab = value.post_tab,
			post_func = value.post_func,
		}
	end
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
			table.insert( tmp, process_item( k, v ) )
		end

		tab.items = tmp
		tab.weight_data = calc_weight( tmp )
	end

	tab.spawns = data.spawns
	tab.post_tab = data.post_tab
	tab.post_func = data.post_func

	return tab
end

function ItemSpawnRule( name, data, auto, dest )
	if !dest then
		SLC_ITEMS_DATA_DEFINITIONS[name] = data
	end

	dest = dest or SLC_ITEMS_DATA

	if data.item then
		local tab = process_rule( data )
		if tab and tab.spawns then
			dest[name] = {
				items = { tab },
				condition = data.condition,
				tags = CreateLookupTable( data.tags or {} ),
				ignore_loot_value = data.ignore_loot_value,
			}

			if auto then
				SLC_ITEMS_AUTOSPAWN[name] = true
			end
		end

		if DEVELOPER_MODE then
			for i, v in ipairs( data.spawns ) do
				table.insert( dev_item_draw_em, { istable( v ) and v[1] or v, name } )
			end
		end
	elseif data.item_set then
		local tmp = {}

		for i, v in pairs( data.item_set ) do
			local r = process_rule( v )
			if r then
				r.weight = v.weight or 1
				r.spawns = r.spawns or data.spawns

				if data.spawns then
					table.insert( tmp, r )
				end
			end
		end

		dest[name] = {
			items = tmp,
			weight_data = calc_weight( tmp ),
			post_tab = data.post_tab,
			post_func = data.post_func,
			condition = data.condition,
			tags = CreateLookupTable( data.tags or {} ),
			ignore_loot_value = data.ignore_loot_value,
		}

		if auto then
			SLC_ITEMS_AUTOSPAWN[name] = true
		end
	end
end

function OverrideSpawnRule( name, data )
	if data.copy then
		data = table.Copy( data )

		if istable( data.copy ) then
			data.copy = CreateLookupTable( data.copy )
		end

		local def = SLC_ITEMS_DATA_DEFINITIONS[name]
		if !def then return end

		for k, v in pairs( def ) do
			if ( data.copy == true or data.copy[k] ) and !data[k] then
				if istable( v ) then
					data[k] = table.Copy( v )
				else
					data[k] = v
				end
			end
		end
	end

	ItemSpawnRule( name, data, false, SLC_ITEMS_OVERRIDES )
end

function OverrideSpawnRuleTag( tags, data )
	if !istable( tags ) then tags = { tags } end

	for name, v in pairs( SLC_ITEMS_DATA ) do
		for _, tag in ipairs( tags ) do
			if tag == true or v.tags[tag] then
				OverrideSpawnRule( name, data )
				break
			end
		end
	end
end

function OverrideSpawnRuleItem( selector, replacement )
	local selector_fn = selector == true or isfunction( selector ) and selector or function( tags, item )
		if selector.tags then
			local has = false

			for i, v in ipairs( selector.tags ) do
				if tags[v] then
					has = true
					break
				end
			end

			if !has then return false end
		end

		if selector.class != nil and selector.class != item.class then return false end
		if selector.weight != nil and selector.weight != item.weight then return false end
		if selector.max != nil and selector.max != item.max then return false end

		return true
	end

	local repl_type = type( replacement )
	local repl_is_func = repl_type == "function"
	local repl_is_table = repl_type == "table"
	local repl_is_str = repl_type == "string"
	local repl_is_nil = replacement == nil

	for name, rule in pairs( SLC_ITEMS_OVERRIDES ) do
		local rule_modified = false

		for set_idx, set in rpairs( rule.items ) do
			local set_modified = false

			if set.item and ( repl_is_str or repl_is_nil ) and ( selector_fn == true or selector_fn( rule.tags, nil, set.item ) ) then
				if repl_is_nil then
					table.remove( rule.items, set_idx )
					rule_modified = true
				else
					set.item = replacement
				end

				continue
			end

			if !set.items then continue end

			for item_idx, item in rpairs( set.items ) do
				if selector_fn == true or selector_fn( rule.tags, item, item.class ) then
					if replacement == nil then
						table.remove( set.items, item_idx )
						set_modified = true
					elseif repl_is_func then
						set.items[item_idx] = replacement( item )
						set_modified = true
					elseif repl_is_table then
						set.items[item_idx] = replacement
						set_modified = true
					end
				end
			end

			if set_modified then
				if #set.items == 0 then
					table.remove( rule.items, set_idx )
					rule_modified = true
				else
					set.weight_data = calc_weight( set.items )
				end
			end
		end

		if rule_modified then
			if #rule.items == 0 then
				SLC_ITEMS_OVERRIDES[name] = nil
			else
				rule.weight_data = calc_weight( rule.items )
			end
		end
	end
end

hook.Add( "SLCRoundCleanup", "SLCClearSpawnRulesOverrides", function()
	SLC_ITEMS_OVERRIDES = table.Copy( SLC_ITEMS_DATA )
end )

local function select_item( tab )
	if !tab or !tab.items then return end

	local len = #tab.items

	if len == 0 then
		return
	elseif len == 1 then
		return tab.items[1]
	end

	if !tab.weight_data then
		return tab.items[SLCRandom( len )]
	else
		local dice = SLCRandom( tab.weight_data )
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
	local rule = SLC_ITEMS_OVERRIDES[name]
	if !rule then return end

	if rule.condition and rule.condition() == false then return end

	local tab = table.Copy( select_item( rule ) )
	if !tab then return end

	local loot_value =  rule.ignore_loot_value and 1 or GetRoundModifier( "loot-value", 1 )

	local amount = tab.amount or tab.rand_amount and SLCRandom( tab.rand_amount[1], tab.rand_amount[2] ) or #tab.spawns

	amount = math.StochasticRound( amount * loot_value )

	local counter = {}

	for i = 1, amount do
		local slen = #tab.spawns
		if slen == 0 then break end

		local post_tab = tab.post_tab or rule.post_tab
		local post_func = tab.post_func or rule.post_func
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

			local item_max = item.max and math.StochasticRound( item.max * loot_value )
			if item_max then
				counter[class] = counter[class] and counter[class] + 1 or 1

				if counter[class] >= item_max then
					table.remove( tab.items, num )
					tab.weight_data = tab.weight_data - item.weight
				end
			end
		end

		local args = string.Explode( ":", ent_class )
		local key = table.remove( args, 1 )
		local fn_name = table.remove( args, 1 )

		if key == "loadout" and fn_name then
			ent_class = ResolveWeapon( fn_name )
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
				local pos = table.remove( tab.spawns, SLCRandom( slen ) )
				local ang

				if istable( pos ) then
					pos = pos[1]
					ang = pos[2]
				end

				if data.offset then
					pos = pos + data.offset
				end

				ent:SetPos( pos )

				if ang then
					ent:SetAngles( ang )
				end

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
				local pos = table.remove( tab.spawns, SLCRandom( slen ) )
				local ang

				if istable( pos ) then
					ang = pos[2]
					pos = pos[1]
				end

				ent:SetPos( pos )

				if ang then
					ent:SetAngles( ang )
				end

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
		local item = ents.Create( istable( class ) and class[SLCRandom( #class )] or class )
		if IsValid( item ) then
			item:SetPos( seq and pos[i] or table.remove( pos, SLCRandom( #pos ) ) )

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
	--[[-------------------------------------------------------------------------
	Auto-spawn
	---------------------------------------------------------------------------]]
	if !GetRoundRule( "no-loose-loot" ) then
		for k, v in pairs( SLC_ITEMS_AUTOSPAWN ) do
			SpawnUsingRule( k )
		end
	end

	--[[-------------------------------------------------------------------------
	Lootables
	---------------------------------------------------------------------------]]
	if !GetRoundRule( "no-looting" ) then
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
	end

	--[[-------------------------------------------------------------------------
	Cameras
	---------------------------------------------------------------------------]]
	for i, v in ipairs( CCTV ) do
		local cctv = ents.Create( "slc_cctv" )

		if IsValid( cctv ) then
			cctv:SetPos( v.pos )
			cctv:SetCameraID( i )

			cctv:Spawn()

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
		local rng = SLCRandom()

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
		fuse:SetRating( args[2] and SLCRandom( tonumber( args[1] ), tonumber( args[2] ) ) or tonumber( args[1] ) or 5 )
		return fuse
	end
end )

ItemSpawnFunction( "backpack", function( args, data )
	return BACKPACK.Create( args[1] )
end )

ItemSpawnFunction( "syringe", function( args )
	local chance = tonumber( args[1] ) or 0
	local small_list, big_list = GetSyringes()

	local use_list = chance > 0 and SLCRandom( 100 ) <= chance and big_list or small_list
	return ents.Create( use_list[SLCRandom( #use_list )] )
end )