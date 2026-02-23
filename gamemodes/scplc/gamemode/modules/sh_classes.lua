--[[
	data = {
		team = TEAM_*,
		loadout = "", --defaults to class name, allows to override loadout name
		weapons = {}, --NOTE: it will give both loadout and this!
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
		hide = false, --nil!
		select_group = "", --nil!
		group_max = 0, --nil!
		group_slots = 1, --nil!
		weight = 1, --nil!
		persona = { class = <fake_class>, team = <fake_team> },
		override = function( ply ) end, --return false to disallow, nil to do standard check, true to allow
		spawn = <Vector or table of vectors or string to use other group spawns> Override group spawn
		select_override = function( cur, total ) end, --wheater this class can be selected, return true to allow
		callback = function( ply, class ) end,
	}
]]

if slc_classes_fully_registered and slc_classes_fully_registered > CurTime() then return end --DEBUG function

local gwarn = true
local cwarn = true

local SuppWeightList = {}

local AllGroups = {}
local SelectInfo = {}
local SpecialGroups = {}
local SelectClasses = {}
SelectClasses.SUPPORT = {}

local highest_tier = 0
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

	local registered = false

	if isnumber( weight ) then
		table.insert( SelectInfo, {
			name = name,
			weight = weight,
			percent = -1,
		} )

		registered = true
	elseif isfunction( weight ) then
		table.insert( SpecialGroups, {
			name = name,
			callback = weight,
		} )

		registered = true
	end

	if registered then
		table.insert( AllGroups, name )
	end
end

function AddSupportGroup( name, weight, spawn, max, callback, spawnrule )
	if !name or !weight then return end

	assert_warn( !gwarn, "Using 'AddSupportGroup' function outside 'RegisterClassGroups' hook can cause errors!" )

	assert( !string.match( name, "%s" ), "Group name can not contain any whitespace characters!" )
	assert( SelectClasses.SUPPORT[name] == nil, "Group '"..name.."' is already registered!" )
	assert( istable( spawn ), "Spawn info is not valid!" )

	local cvar_name = "slc_support_"..name.."_chance"
	local cvar = GetConVar( cvar_name )
	if SERVER and !cvar then
		cvar = CreateConVar( cvar_name, weight, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } )
	end

	SelectClasses.SUPPORT[name] = {}
	SpawnInfo.SUPPORT[name] = spawn
	SupportData[name] = { max = max or 0, callback = callback, spawnrule = spawnrule }

	table.insert( SuppWeightList, {
		name = name,
		cvar = cvar,
	} )
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

function GetClassGroups()
	return table.Copy( SelectClasses )
end

function GetSpawnInfo()
	return SpawnInfo
end

function GetSpecialGroups()
	return SpecialGroups
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
	assert( group == true or usetab[group] != nil, "Invalid group: "..group )
	--assert( usetab[group][name] == nil, "Class '"..name.."' is already registered!" )

	if AllClasses[name] and !usetab[group][name] then
		local tab = table.Copy( AllClasses[name] )

		tab.support = support

		usetab[group][name] = tab
		print( "Class '"..name.."' is already registered in another group! Copying old data to new group, provided new data is discarded!" )
		return
	end

	assert( data.team, "Invalid team" )
	assert( AllClasses[name] == nil, "Class '"..name.."' is already registered!" )
	assert_warn( _LANG["english"]["CLASSES"][name] != nil and _LANG["english"]["CLASS_OBJECTIVES"][name] != nil, "No language entry for: "..name )

	CLASSES[string.upper( name )] = name

	data.support = support
	data.name = name
	data.group = group
	data.model = model
	data.loadout = data.loadout or name
	data.tier = data.tier or 0

	AllClasses[name] = data
	usetab[group][name] = data

	if !ClassTiers[data.tier] then
		ClassTiers[data.tier] = {}
	end

	if data.tier > highest_tier then
		highest_tier = data.tier
	end

	ClassTiers[data.tier][name] = true
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

	for i, v in ipairs( SelectInfo ) do
		if v.percent <= 0 then
			tab[v.name] = 0
			continue
		end

		local num = math.floor( ply * v.percent )
		tab[v.name] = num
		total = total + num
	end

	for i = 1, ply - total do
		local name = SelectInfo[i].name
		tab[name] = tab[name] + 1
	end

	return tab
end

function SelectSupportGroup()
	if CLIENT then return end

	local total = 0
	local newlist = {}

	for i, v in ipairs( SuppWeightList ) do
		if GetRoundProperty( "support_fail" ) == v.name then continue end

		local data = SupportData[v.name]
		local cvar = v.cvar:GetInt()

		if data.spawnrule then
			local rule, override = data.spawnrule( cvar )
			if rule != true then continue end

			if override == true then
				return v.name, SupportData[v.name]
			else
				table.insert( newlist, { name = v.name, weight = override or cvar } )
				total = total + ( override or cvar )
			end
		else
			table.insert( newlist, { name = v.name, weight = cvar } )
			total = total + cvar
		end
	end
	
	local dice = SLCRandom( total )
	total = 0

	for i, v in ipairs( newlist ) do
		total = total + v.weight

		if total >= dice then
			return v.name, SupportData[v.name]
		end
	end
end

hook.Add( "SLCGamemodeLoaded", "SLCRegisterClasses", function()
	if slc_classes_fully_registered and slc_classes_fully_registered > CurTime() then return end
	slc_classes_fully_registered = CurTime() + 1

	gwarn = false
	hook.Run( "SLCRegisterClassGroups" )
	gwarn = true

	if file.Exists( "slc/classes_data.txt", "DATA" ) then
		local override = LoadINI( "slc/classes_data.txt" )
		if override.ENABLED then
			for i, v in ipairs( SelectInfo ) do
				v.weight = tonumber( override.WEIGHTS[v.name] ) or v.weight
			end
		end
	else
		local tab = {}

		for i, v in ipairs( SelectInfo ) do
			tab[v.name] = v.weight
		end

		WriteINI( "slc/classes_data.txt", {
			WEIGHTS = tab,
			ENABLED = false,
		}, false, ".", "This file has spawn weights for spawnable teams. To use, change ENABLED to true then edit values as you wish.\n# To disable, change ENABLED to false. To restore default values delete this file and restart the game" )
	end

	table.sort( SelectInfo, function( a, b ) return a.weight > b.weight end )

	local total = 0

	for i, v in ipairs( SelectInfo ) do
		total = total + v.weight
	end

	for i, v in ipairs( SelectInfo ) do
		v.percent = v.weight / total
	end

	cwarn = false
	hook.Run( "SLCRegisterPlayerClasses" )
	cwarn = true

	for group, classes in pairs( SelectClasses ) do
		if group == "SUPPORT" then continue end

		local any_free = false
		for class, data in pairs( classes ) do
			if data.tier == 0 then
				any_free = true
				break
			end
		end

		assert( any_free, "The group '"..group.."' has no free (Tier 0) class! You are going to break the gamemode, register it as a special group instead..." )
	end
end )

hook.Add( "SLCVersionChanged", "ClassesOverride", function( new, old )
	file.Rename( "slc/classes_data.txt", "slc/classes_data_"..old.signature..".txt" )
end )

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable( "Player" )

function PLAYER:IsClassUnlocked( name )
	if self:IsBot() then return true end
	if gamerule.Get( "lan" ) then return true end

	local override = hook.Run( "SLCIsClassUnlocked", self, name )
	if override != nil then
		return override
	end

	local class = AllClasses[name]
	if class then
		if class.tier and class.tier == -1 then
			return self.playermeta.prestige[name]
		end

		return !class.tier or class.tier == 0 or self.playermeta.classes[name]
	end

	return true
end

function PLAYER:CanUnlockClass( name )
	local class = AllClasses[name]
	if !class then return false end
	if self.playermeta.classes[name] then return false end
	if self.playermeta.prestige[name] then return false end
	if class.tier == -1 then return self:GetPrestigePoints() > 0 end
	if self:ClassPoints() < 1 then return false end
	if class.tier and !self:CanUnlockClassTier( class.tier ) then return false end

	return true
end

function PLAYER:CanUnlockClassTier( tier )
	if tier == -1 then return true end

	if tier and tier > 1 then
		for k, v in pairs( ClassTiers[tier - 1] ) do
			if !self.playermeta.classes[k] then
				return false
			end
		end
	end

	return true
end

function PLAYER:UnlockClass( name )
	if !self:CanUnlockClass( name ) then return false end

	local class = AllClasses[name]
	if !class then return false end

	if class.tier == -1 then
		if SERVER then
			self:AddPrestigePoints( -1 )
			self.PlayerInfo:Get( "prestige_classes" )[name] = true
			self.PlayerInfo:Update()
		end

		self.playermeta.prestige[name] = true
	else
		if SERVER then
			self:AddClassPoints( -1 )
			self.PlayerInfo:Get( "unlocked_classes" )[name] = true
			self.PlayerInfo:Update()
		end

		self.playermeta.classes[name] = true
	end

	if CLIENT then
		net.Start( "ClassUnlock" )
			net.WriteString( name )
		net.SendToServer()
	end
	
	return true
end

function PLAYER:CanPrestige()
	return self:CanUnlockClassTier( highest_tier + 1 )
end

function PLAYER:PerformPrestige()
	if !self:CanPrestige() then return end

	if SERVER then
		self:AddPrestigePoints( 1 )

		local new_level = self:GetPrestigeLevel() + 1
		self:SetPrestigeLevel( new_level )

		self:ResetDailyBonus( true )

		self:SetClassPoints( 0 )
		self:SetPlayerLevel( 0 )
		self:SetPlayerXP( 0 )

		self.PlayerInfo:Set( "unlocked_classes", {} )
		self.PlayerInfo:Update()
	end

	self.playermeta.classes = {}

	hook.Run( "SLCPlayerPrestige", self )

	if CLIENT then
		net.Ping( "SLCPrestige" )
	end
end

if SERVER then
	function PLAYER:GetGroupData( group )
		return self.GroupData and self.GroupData[group] or 0
	end

	function PLAYER:ApplyGroupData( group )
		local gd = self.GroupData
		if !gd then return end

		for i, v in ipairs( AllGroups ) do
			local num = gd[v] or 0

			if v == group then
				num = 0
			else
				num = num + 1
			end

			gd[v] = num
			self:SetSCPData( "group_last_game#"..v, num )
		end
	end
end

--[[-------------------------------------------------------------------------
SV Logic
---------------------------------------------------------------------------]]
if SERVER then
	--[[-------------------------------------------------------------------------
	Classes and refunding
	---------------------------------------------------------------------------]]

	hook.Add( "SLCPlayerMeta", "SLCClassInfo", function( ply, playermeta )
		local classinfo = ply.PlayerInfo:Get( "unlocked_classes" )
		local prestigeinfo = ply.PlayerInfo:Get( "prestige_classes" )

		if !classinfo then
			classinfo = {}
			ply.PlayerInfo:Set( "unlocked_classes", classinfo )
		end

		if !prestigeinfo then
			prestigeinfo = {}
			ply.PlayerInfo:Set( "prestige_classes", prestigeinfo )
		end

		local classmeta = {}
		local prestigemeta = {}
		local refund = false

		for k, v in pairs( classinfo ) do
			if v then
				if AllClasses[k] then
					classmeta[k] = true
				else
					refund = true
				end
			else
				classinfo[k] = nil
			end
		end

		for k, v in pairs( prestigeinfo ) do
			if v then
				if AllClasses[k] then
					prestigemeta[k] = true
				else
					refund = true
				end
			else
				prestigeinfo[k] = nil
			end
		end

		ply.PlayerInfo:Update()

		playermeta.refund = refund
		playermeta.classes = classmeta
		playermeta.prestige = prestigemeta
	end )

	net.ReceivePing( "SLCrefundClasses", function( data, ply )
		local points = 0
		local prestige_points = 0

		local classinfo = ply.PlayerInfo:Get( "unlocked_classes" )
		if classinfo then
			for k, v in pairs( classinfo ) do
				if !AllClasses[k] then
					classinfo[k] = nil
					points = points + 1
				end
			end
		end

		local prestigeinfo = ply.PlayerInfo:Get( "prestige_classes" )
		if prestigeinfo then
			for k, v in pairs( prestigeinfo ) do
				if !AllClasses[k] then
					prestigeinfo[k] = nil
					prestige_points = prestige_points + 1
				end
			end
		end

		ply.PlayerInfo:Update()

		if points > 0 or prestige_points > 0 then
			net.Ping( "SLCrefundClasses", points..","..prestige_points, ply )
			
			ply:AddClassPoints( points )
			ply:AddPrestigePoints( prestige_points )
		end
	end )

	net.ReceivePing( "SLCPrestige", function( data, ply )
		ply:PerformPrestige()
	end )

	hook.Add( "SLCRegisterGamerules", "SLCLANRule", function()
		gamerule.Register( "lan", { value = false } )
	end )

	--[[-------------------------------------------------------------------------
	Player group data
	---------------------------------------------------------------------------]]
	hook.Add( "PlayerInitialSpawn", "SLCGroupsData", function( ply )
		local group_data = {}
		ply.GroupData = group_data

		local promises = {}

		for i, v in ipairs( AllGroups ) do
			promises[i] = ply:GetSCPData( "group_last_game#"..v, 0 )
			group_data[v] = 0
		end

		SLCPromiseJoin( promises ):Then( function( data )
			for i, v in ipairs( AllGroups ) do
				group_data[v] = tonumber( data[i] or 0 ) or 0
			end
		end )
	end )
end