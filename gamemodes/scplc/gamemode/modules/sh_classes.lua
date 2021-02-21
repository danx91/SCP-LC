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
		sanity = 100,
		max_sanity = 100 --can be nil
		vest = nil,
		price = 1,
		max = 0,
		persona = { class = <fake_class>, team = <fake_team> },
		override = function( ply ) end, --return false to disallow, nil to do standard check, true to allow
		--spawn = ? --Vector or table of them. Use only to override group spawn
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

local SpawnInfo = {}
SpawnInfo.SUPPORT = {}

local SupportData = {}

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

function addSupportGroup( name, weight, spawn, max, callback, spawnrule )
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
	SupportData[name] = { max = max or 0, callback = callback, spawnrule = spawnrule }

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

function getSupportData( name )
	return SupportData[name]
end

function registerClass( name, group, model, data, support )
	//if !name or !group or !model or !data then return end

	assert_warn( !cwarn, "Using 'registerClass' function outside 'RegisterPlayerClasses' hook can cause errors!" )

	local usetab = support and SelectClasses.SUPPORT or SelectClasses

	assert( group != "SUPPORT", "Forbidden group name: 'SUPPORT'! To register support class use 'registerSupportClass' function instead" )
	assert( !string.match( name, "%s" ), "Class name can not contain any whitespace characters!" )
	assert( usetab[group] != nil, "Invalid group: "..group )
	--assert( usetab[group][name] == nil, "Class '"..name.."' is already registered!" )

	if AllClasses[name] and !usetab[group][name] then
		local tab = table.Copy( AllClasses[name] )

		tab.support = support

		usetab[group][name] = tab
		print( "Class '"..name.."' is already registered in another group! Duplicating old data to new group, provided new data is discarded!" )
	end

	assert( AllClasses[name] == nil, "Class '"..name.."' is already registered!" )
	assert_warn( _LANG["english"]["CLASSES"][name] != nil and _LANG["english"]["CLASS_OBJECTIVES"][name] != nil, "No language entry for: "..name )

	CLASSES[string.upper( name )] = name

	data.support = support
	data.name = name
	//data.group = group
	data.model = model

	AllClasses[name] = data
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

local ply = FindMetaTable( "Player" )
function ply:IsClassUnlocked( name )
	if self:IsBot() then return true end

	local class = AllClasses[name]
	if class then
		return !class.price or class.price == 0 or self.playermeta.classes[name]
	end

	return true
end

function ply:CanUnlockClass( name )
	local class = AllClasses[name]
	if class and class.price and class.price > 0 then
		return self:SCPPrestigePoints() >= class.price
	end

	return false
end

function ply:UnlockClass( name )
	if self:CanUnlockClass( name ) then
		if SERVER then
			local price = AllClasses[name].price

			self:AddPrestigePoints( -price )
			self.PlayerInfo:Get( "unlocked_classes" )[name] = price
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

	return false
end

if SERVER then
	hook.Add( "SLCPlayerMeta", "SLCClassInfo", function( ply, playermeta )
		local classinfo = ply.PlayerInfo:Get( "unlocked_classes" )

		if !classinfo then
			classinfo = {}
			ply.PlayerInfo:Set( "unlocked_classes", classinfo )
		end

		local classmeta = {}
		local refound = false
		for k, v in pairs( classinfo ) do
			if v then
				local class = AllClasses[k]

				if class then
					if !isnumber( v ) then
						//ply.PlayerInfo:Get( "unlocked_classes" )[k] = class.price
						classinfo[k] = class.price
					elseif v > class.price then
						refound = true
					end

					classmeta[k] = true
				else
					if isnumber( v ) then
						refound = true
					else
						//ply.PlayerInfo:Get( "unlocked_classes" )[k] = nil
						classinfo[k] = nil
					end
				end
			else
				//ply.PlayerInfo:Get( "unlocked_classes" )[k] = nil
				classinfo[k] = nil
			end
		end

		ply.PlayerInfo:Update()

		playermeta.refound = refound
		playermeta.classes = classmeta
	end )

	net.ReceivePing( "SLCRefoundClasses", function( data, ply )
		local points = 0

		local classinfo = ply.PlayerInfo:Get( "unlocked_classes" )
		if classinfo then
			for k, v in pairs( classinfo ) do
				if v then
					local class = AllClasses[k]

					if class then
						if isnumber( v ) and v > class.price then
							classinfo[k] = class.price
							points = points + (v - class.price)
						end
					else
						if isnumber( v ) then
							classinfo[k] = nil
							points = points + v
						end
					end
				end
			end

			ply.PlayerInfo:Update()
		end

		if points > 0 then
			net.Ping( "SLCRefoundClasses", points, ply )
			//print( "Refounded", points, ply )
			ply:AddPrestigePoints( points )
		end
	end )
end