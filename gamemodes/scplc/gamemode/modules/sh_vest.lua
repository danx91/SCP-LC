VEST = {
	vests = {},
	vid = {},
	rand = {}
}

local TRANSLATE_DMG = {
	[DMG_CRUSH] = "CRUSH",
	[DMG_DIRECT] = "DIRECT",
	[DMG_BULLET] = "BULLET",
	[DMG_CLUB] = "CLUB",
	[DMG_ENERGYBEAM] = "ENERGYBEAM",
	[DMG_RADIATION] = "RADIATION",
	[DMG_PLASMA] = "PLASMA",
	[DMG_SLASH] = "SLASH",
	[DMG_SHOCK] = "SHOCK",
	[DMG_BUCKSHOT] = "BUCKSHOT",
	[DMG_POISON] = "POISON",
	[DMG_ACID] = "ACID",
	[DMG_GENERIC] = "GENERIC",
	[DMG_DROWN] = "DROWN",
	[DMG_FALL] = "FALL",
	[DMG_PHYSGUN] = "PHYSGUN",
	[DMG_VEHICLE] = "VEHICLE",
	[DMG_BURN] = "BURN",
	[DMG_SLOWBURN] = "SLOWBURN",
	[DMG_NERVEGAS] = "NERVEGAS",
	[DMG_PARALYZE] = "PARALYZE",
	[DMG_BLAST] = "BLAST",

}

/*for k, v in pairs( _G ) do
	local name = string.match( k, "^DMG_(.+)$" )
		
	if name then
		print( "["..k.."] = \""..name.."\"," )
	end
end*/

/*
data = {
	damage = {
		[DMG_*] = <damage %>, --1 players receive full damage, 0 players receive no damage
		[DMG_BULLET] = 0.5,
	}
	mobility = 0.9, --affects speed of player - 1 means no speed reduce, 0.5 means players walk and run with halved speed (minimum value 0.2)
	weight = 2, --weight of armor, affects fall damage --max 10
	model = "vest.mdl"
}
*/

function VEST.register( name, data, randomvest )
	assert( !VEST.vests[name], "Vest '"..name.."' is already registered!" )
	assert( data.damage and data.model, "Invalid data for vest '"..name.."'!" )

	if !data.weight then data.weight = 2 end
	if !data.mobility then data.mobility = 0.9 end

	data.weight = math.Clamp( data.weight, 0, 10 )
	data.mobility = math.Clamp( data.mobility, 0.2, 1 )
	data.HIDE = data.HIDE or {}

	local id = table.insert( VEST.vid, name )

	if randomvest then
		table.insert( VEST.rand, id )
	end

	data.name = name
	data.id = id
	VEST.vests[name] = data

	return id
end

function VEST.create( id, pos )
	if CLIENT then return end

	if isstring( id ) then
		local tmp = VEST.vests[id]
		id = tmp and tmp.id or id
	end

	assert( VEST.vid[id], "Tried to create invalid vest: "..id )

	local vest = ents.Create( "item_vest" )
	vest:Spawn()

	vest:SetVest( id )
	vest:SetPos( pos )

	return vest
end

function VEST.getName( id )
	return VEST.vid[id]
end

function VEST.getData( id )
	local name = VEST.vid[id]
	if name then
		return VEST.vests[name]
	end
end

function VEST.getID( name )
	local v = VEST.vests[name]
	if v then
		return v.id
	end

	return 0
end

function VEST.translateDamage( dmg )
	return TRANSLATE_DMG[dmg]
end

function VEST.getRandomVest()
	return table.Random( VEST.rand )
end

-- concommand.Add( "spawnvest", function( ply )
-- 	//VEST.create( "com", ply:GetPos() )

-- 	local vest = ents.Create( "item_vest" )
-- 	if IsValid( vest ) then
-- 		vest:Spawn()
-- 		vest:SetPos( ply:GetEyeTrace().HitPos )
-- 	end
-- end )

-- concommand.Add( "getspeed", function( ply )
-- 	print( ply:GetWalkSpeed(), ply:GetRunSpeed() )
-- end )

-- timer.Simple( 0, function()
-- 	hook.Run( "SLCRegisterVests" )
-- end )

VEST.register( "guard", { model = "models/scp/guard_sci.mdl", damage = { [DMG_BULLET] = 0.7, [DMG_FALL] = 1.3 }, mobility = 0.95, weight = 1 }, true )
VEST.register( "chief", { model = "models/scp/soldier_1.mdl", damage = { [DMG_BULLET] = 0.6, [DMG_FALL] = 1.4 }, mobility = 0.93, weight = 2 } )
VEST.register( "private", { model = "models/scp/guard_noob.mdl", damage = { [DMG_BULLET] = 0.65, [DMG_FALL] = 1.35 }, mobility = 0.94, weight = 1.5 } )
VEST.register( "sergeant", { model = "models/scp/captain.mdl", damage = { [DMG_BULLET] = 0.55, [DMG_FALL] = 1.45 }, mobility = 0.9, weight = 2.5 } )
VEST.register( "lieutenant", { model = "models/scp/guard_left.mdl", damage = { [DMG_BULLET] = 0.5, [DMG_FALL] = 1.5 }, mobility = 0.87, weight = 3 } )
VEST.register( "alpha1", { model = "models/scp/soldier_3.mdl", damage = { [DMG_BULLET] = 0.4, [DMG_FALL] = 1.6 }, mobility = 0.85, weight = 4 } )
VEST.register( "medic", { model = "models/scp/guard_med.mdl", damage = { [DMG_BULLET] = 0.55, [DMG_FALL] = 1.4 }, mobility = 0.9, weight = 2 } )

VEST.register( "ntf", { model = "models/player/pmc_4/pmc__07.mdl", damage = { [DMG_BULLET] = 0.5, [DMG_FALL] = 1.5 }, mobility = 0.88, weight = 3 } )
VEST.register( "ci", { model = "models/friskiukas/bf4/us_01.mdl", damage = { [DMG_BULLET] = 0.45, [DMG_FALL] = 1.6 }, mobility = 0.83, weight = 4 } )

VEST.register( "fire", { model = "models/player/kerry/class_securety.mdl", damage = { [DMG_BURN] = 0.2, [DMG_FALL] = 1.75 }, mobility = 0.8, weight = 5 }, true )
VEST.register( "electro", { model = "models/player/kerry/class_securety.mdl", damage = { [DMG_SHOCK] = 0.05, [DMG_ENERGYBEAM] = 0.05, [DMG_FALL] = 2 }, mobility = 0.7, weight = 6, HIDE = { [DMG_ENERGYBEAM] = true } }, true )

//player.GetAll()[1]:SetModel( "models/scp/soldier_3.mdl" )