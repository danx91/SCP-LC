--[[
	data = {
		team = TEAM_*,
		weapons = {},
		ammo = {},
		chip = "", --GetChip?
		omnitool = true/false,
		health = 100,
		walk_speed = 100,
		run_speed = 225,
		stamina = 100, --can be nil
		sanity = 100,
		max_sanity = 100, --can be nil
		vest = nil,
		max = 0,
		tier = 0,
		persona = { class = <fake_class>, team = <fake_team> },
		override = function( ply ) end, --return false to disallow, nil to do standard check, true to allow
		spawn = <Vector or table of vectors> Override group spawn
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

local AllClasses = {}
local ClassTiers = {}

local SpawnInfo = {}
SpawnInfo.SUPPORT = {}

local SupportData = {}

local function assert_warn( b, s )
	if !b then
		MsgC( Color( 255, 50, 50 ), "WARNING! "..s.."\n" )
	end
end

function AddClassGroup( name, weight, spawn )
	if !name or !weight then return end

	assert_warn( !gwarn, "Using 'AddClassGroup' function outside 'RegisterClassGroups' hook can cause errors!" )

	assert( name != "SUPPORT", "Forbidden group name: 'SUPPORT'! To add support group use 'AddSupportGroup' function instead" )
	assert( !string.match( name, "%s" ), "Group name can not contain any whitespace characters!" )
	assert( SelectClasses[name] == nil, "Group '"..name.."' is already registered!" )
	assert( istable( spawn ), "Spawn info is not valid!" )

	SelectClasses[name] = {}
	SpawnInfo[name] = spawn

	table.insert( SelectInfo, { name, weight } )
end

function AddSupportGroup( name, weight, spawn, max, callback, spawnrule )
	if !name or !weight then return end

	assert_warn( !gwarn, "Using 'AddSupportGroup' function outside 'RegisterClassGroups' hook can cause errors!" )

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
	SupportData[name] = { max = max or 0, callback = callback, spawnrule = spawnrule }

	table.insert( SuppWeightList, { name, cvar } )
end

function GetClassGroup( name )
	assert( SelectClasses[name] != nil, "Invalid group: "..name )
	assert( name != "SUPPORT", "Forbidden group name: 'SUPPORT'! To get support group use 'GetSupportGroup' function instead" )

	return SelectClasses[name], SpawnInfo[name]
end

function GetSupportGroup( name )
	assert( SelectClasses.SUPPORT[name] != nil, "Invalid group: "..name )

	return SelectClasses.SUPPORT[name], SpawnInfo.SUPPORT[name]
end

function GetGroups()
	return SelectClasses
end

function GetSupportData( name )
	return SupportData[name]
end

function RegisterClass( name, group, model, data, support )
	//if !name or !group or !model or !data then return end

	assert_warn( !cwarn, "Using 'RegisterClass' function outside 'RegisterPlayerClasses' hook can cause errors!" )

	local usetab = support and SelectClasses.SUPPORT or SelectClasses

	assert( group != "SUPPORT", "Forbidden group name: 'SUPPORT'! To register support class use 'RegisterSupportClass' function instead" )
	assert( !string.match( name, "%s" ), "Class name can not contain any whitespace characters!" )
	assert( usetab[group] != nil, "Invalid group: "..group )
	--assert( usetab[group][name] == nil, "Class '"..name.."' is already registered!" )

	if AllClasses[name] and !usetab[group][name] then
		local tab = table.Copy( AllClasses[name] )

		tab.support = support

		usetab[group][name] = tab
		print( "Class '"..name.."' is already registered in another group! Copying old data to new group, provided new data is discarded!" )
		return
	end

	assert( AllClasses[name] == nil, "Class '"..name.."' is already registered!" )
	assert_warn( _LANG["english"]["CLASSES"][name] != nil and _LANG["english"]["CLASS_OBJECTIVES"][name] != nil, "No language entry for: "..name )

	CLASSES[string.upper( name )] = name

	data.support = support
	data.name = name
	data.group = group
	data.model = model

	AllClasses[name] = data
	usetab[group][name] = data

	local tier = data.tier or 1
	if !ClassTiers[tier] then
		ClassTiers[tier] = {}
	end

	ClassTiers[tier][name] = true
end

function RegisterSupportClass( name, group, model, data )
	RegisterClass( name, group, model, data, true )
end

function GetAllClasses()
	return AllClasses
end

function GetClassData( name )
	return AllClasses[name]
end

function GetPlayerTable( ply )
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

function SelectSupportGroup()
	if CLIENT then return end

	local newlist = {}

	for i, v in pairs( SuppWeightList ) do
		local data = SupportData[v[1]]

		if !data.spawnrule or data.spawnrule() then
			table.insert( newlist, v )
		end
	end

	local total = 0
	for i, v in ipairs( newlist ) do
		total = total + v[2]:GetInt()
	end

	local dice = math.random( total )
	total = 0

	for i, v in ipairs( newlist ) do
		total = total + v[2]:GetInt()

		if total >= dice then
			return v[1], SupportData[v[1]]
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

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
local ply = FindMetaTable( "Player" )

function ply:IsClassUnlocked( name )
	if self:IsBot() then return true end
	if gamerule.Get( "lan" ) then return true end

	local override = hook.Run( "SLCIsClassUnlocked", self, name )
	if override != nil then
		return override
	end

	local class = AllClasses[name]
	if class then
		return !class.tier or class.tier == 0 or self.playermeta.classes[name]
	end

	return true
end

function ply:CanUnlockClass( name )
	local class = AllClasses[name]
	if !class or self:SCPClassPoints() < 1 then return false end
	if self.playermeta.classes[name] then return false end
	if class.tier and !self:CanUnlockClassTier( class.tier ) then return false end

	return true
end

function ply:CanUnlockClassTier( tier )
	if tier and tier > 1 then
		for k, v in pairs( ClassTiers[tier - 1] ) do
			if !self.playermeta.classes[k] then
				return false
			end
		end
	end

	return true
end

function ply:UnlockClass( name )
	if !self:CanUnlockClass( name ) then return false end

	if SERVER then
		self:AddClassPoints( -1 )
		self.PlayerInfo:Get( "unlocked_classes" )[name] = true
		self.PlayerInfo:Update()
	end

	self.playermeta.classes[name] = true

	if CLIENT then
		net.Start( "ClassUnlock" )
			net.WriteString( name )
		net.SendToServer()
	end
	
	return true
end

if SERVER then
	hook.Add( "SLCPlayerMeta", "SLCClassInfo", function( p, playermeta )
		local classinfo = p.PlayerInfo:Get( "unlocked_classes" )

		if !classinfo then
			classinfo = {}
			p.PlayerInfo:Set( "unlocked_classes", classinfo )
		end

		local classmeta = {}
		local refound = false
		for k, v in pairs( classinfo ) do
			if v then
				if AllClasses[k] then
					classmeta[k] = true
				else
					refound = true
				end
			else
				classinfo[k] = nil
			end
		end

		p.PlayerInfo:Update()

		playermeta.refound = refound
		playermeta.classes = classmeta
	end )

	net.ReceivePing( "SLCRefoundClasses", function( data, p )
		local points = 0

		local classinfo = p.PlayerInfo:Get( "unlocked_classes" )
		if classinfo then
			for k, v in pairs( classinfo ) do
				if !AllClasses[k] then
					classinfo[k] = nil
					points = points + 1
				end
			end

			p.PlayerInfo:Update()
		end

		if points > 0 then
			net.Ping( "SLCRefoundClasses", points, p )
			//print( "Refounded", points, p )
			p:AddClassPoints( points )
		end
	end )

	hook.Add( "SLCRegisterGamerules", "SLCPlayerInfoRule", function()
		gamerule.Register( "lan", { value = false } )
	end )
end