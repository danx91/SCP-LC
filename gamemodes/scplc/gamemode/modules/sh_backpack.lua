BACKPACK = {
	registry = {},
	lookup = {},
}

function BACKPACK.Register( name, model, size )
	local tab = {
		name = name,
		model = model,
		size = size,
	}

	local id = table.insert( BACKPACK.registry, tab )
	tab.id = id

	BACKPACK.lookup[name] = id
end

function BACKPACK.GetData( id )
	return BACKPACK.registry[id]
end

function BACKPACK.GetID( name )
	return BACKPACK.lookup[name]
end

function BACKPACK.Create( name, pos )
	local id = BACKPACK.GetID( name )
	if id <= 0 then return end

	local data = BACKPACK.GetData( id )
	if !data then return end

	local bp = ents.Create( "item_slc_backpack" )
	
	bp.WorldModel = data.model
	bp:SetBackpack( id )

	if pos then
		bp:SetPos( pos )
	end

	bp:Spawn()

	return bp
end

--[[-------------------------------------------------------------------------
Base backpacks
---------------------------------------------------------------------------]]
BACKPACK.Register( "small", "models/fallout 3/backpack_1.mdl", 3 )
BACKPACK.Register( "medium", "models/fallout 3/backpack_2.mdl", 4 )
BACKPACK.Register( "large", "models/fallout 3/backpack_4.mdl", 5 )
BACKPACK.Register( "huge", "models/fallout 3/backpack_6.mdl", 6 )