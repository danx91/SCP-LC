--[[
	data = {
		team = TEAM_*,
		weapons = {},
		ammo = {},
		chip = "", --GetChip?
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		sanity = 100,
		max_sanity = 100 --can be nil
		vest = nil,
		level = 0,
		max = 0,
		persona = { class = <fake_class>, team = <fake_team> },
		override = function( ply ) end, --return false to disallow, nil to do nothing (check level), true to allow
		--spawn = ? --Vector or table if them. Use only to override group spawn --Not working!
	}
]]

if fully_registered and fully_registered > CurTime() then return end --DEBUG function

local gwarn = true
local cwarn = true

local WeightList = {}
local SuppWeightList = {}

local SelectInfo = {}
local SelectClasses = {}
SelectClasses.SUPPORT = {}

local SpawnInfo = {}
SpawnInfo.SUPPORT = {}

local SupportCallbacks = {}

local function assert_warn( b, s )
	if !b then
		MsgC( Color( 255, 50, 50 ), "WARNING! "..s.."\n" )
	end
end

function addClassGroup( name, weight, spawn )
	if !name or !weight then return end

	assert_warn( !gwarn, "Using 'addClassGroup' function outside 'RegisterClassGroups' hook can cause errors!" )

	assert( name != "SUPPORT", "Forbidden group name: 'SUPPORT'! To add support group use 'addSupportGroup' function instead" )
	assert( !string.match( name, "%s" ), "Group name can not contain any whitespace characters!" )
	assert( SelectClasses[name] == nil, "Group '"..name.."' is already registered!" )
	assert( istable( spawn ), "Spawn info is not valid!" )

	SelectClasses[name] = {}
	SpawnInfo[name] = spawn

	table.insert( SelectInfo, { name, weight } )
end

function addSupportGroup( name, weight, spawn, data )
	if !name or !weight then return end

	assert_warn( !gwarn, "Using 'addSupportGroup' function outside 'RegisterClassGroups' hook can cause errors!" )

	assert( !string.match( name, "%s" ), "Group name can not contain any whitespace characters!" )
	assert( SelectClasses.SUPPORT[name] == nil, "Group '"..name.."' is already registered!" )
	assert( istable( spawn ), "Spawn info is not valid!" )

	local cvar
	if SERVER then
		cvar = CreateConVar( "slc_support_"..name.."_chance", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } )
		cvar:SetInt( weight )
	end

	SelectClasses.SUPPORT[name] = {}
	SpawnInfo.SUPPORT[name] = spawn
	SupportCallbacks[name] = data

	table.insert( SuppWeightList, { name, cvar } )
end

function getClassGroup( name )
	assert( SelectClasses[name] != nil, "Invalid group: "..name )
	assert( name != "SUPPORT", "Forbidden group name: 'SUPPORT'! To get support group use 'getSupportGroup' function instead" )

	return SelectClasses[name], SpawnInfo[name]
end

function getSupportGroup( name )
	assert( SelectClasses.SUPPORT[name] != nil, "Invalid group: "..name )

	return SelectClasses.SUPPORT[name], SpawnInfo.SUPPORT[name]
end

function getGroups()
	return SelectClasses
end

function getSupportCallback( name )
	return SupportCallbacks[name]
end

function registerClass( name, group, model, data, support )
	//if !name or !group or !model or !data then return end

	assert_warn( !cwarn, "Using 'registerClass' function outside 'RegisterPlayerClasses' hook can cause errors!" )

	local usetab = support and SelectClasses.SUPPORT or SelectClasses

	assert( name != "SUPPORT", "Forbidden group name: 'SUPPORT'! To register support class use 'registerSupportClass' function instead" )
	assert( !string.match( name, "%s" ), "Class name can not contain any whitespace characters!" )
	assert( usetab[group] != nil, "Invalid group: "..group )
	assert( usetab[group][name] == nil, "Class '"..name.."' is already registered!" )
	assert_warn( _LANG["english"]["CLASSES"][name] != nil and _LANG["english"]["CLASS_INFO"][name] != nil, "No language entry for: "..name )

	CLASSES[string.upper( name )] = name

	data.issupport = support
	data.name = name
	data.model = model

	usetab[group][name] = data
end

function registerSupportClass( name, group, model, data )
	registerClass( name, group, model, data, true )
end

function getPlayerTable( ply )
	local tab = {}
	local total = 0

	for i, v in ipairs( WeightList ) do
		local num = math.floor( ply * v )
		tab[SelectInfo[i][1]] = { num, v }
		total = total + num
	end

	ply = ply - total

	if ply > 0 then
		for i = 1, ply do
			tab[SelectInfo[i][1]][1] = tab[SelectInfo[i][1]][1] + 1
		end
	end

	local final = {}

	for k, v in pairs( tab ) do
		table.insert( final, { k, v[1] } )
	end

	table.sort( final, function( a, b ) return tab[a[1]][2] < tab[b[1]][2] end )

	return final
end

function selectSupportGroup()
	if CLIENT then return end

	local total = 0

	for i, v in ipairs( SuppWeightList ) do
		total = total + v[2]:GetInt()
	end

	local dice = math.random( total )
	total = 0

	for i, v in ipairs( SuppWeightList ) do
		total = total + v[2]:GetInt()

		if total >= dice then
			return v[1], SupportCallbacks[v[1]]
		end
	end
end

timer.Simple( 0, function()
	gwarn = false
	hook.Run( "SLCRegisterClassGroups" )
	gwarn = true

	table.sort( SelectInfo, function( a, b ) return a[2] > b[2] end )

	local total = 0

	for i, v in ipairs( SelectInfo ) do
		total = total + v[2]
	end

	for i, v in ipairs( SelectInfo ) do
		WeightList[i] = v[2] / total
	end

	cwarn = false
	hook.Run( "SLCRegisterPlayerClasses" )
	cwarn = true
end )

fully_registered = CurTime() + 1