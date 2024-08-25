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
		weight = 1, --nil!
		persona = { class = <fake_class>, team = <fake_team> },
		override = function( ply ) end, --return false to disallow, nil to do standard check, true to allow
		spawn = <Vector or table of vectors> Override group spawn
		select_override = function( cur, total ) end, --wheater this class can be selected, return true to allow
		callback = function( ply, class ) end,
	}
]]

if slc_classes_fully_registered and slc_classes_fully_registered > CurTime() then return end --DEBUG function

local gwarn = true
local cwarn = true

local WeightList = {}
local SuppWeightList = {}

local SelectInfo = {}
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

	table.insert( SelectInfo, { name, weight } )
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

	assert( data.team, "Invalid team" )
	assert( AllClasses[name] == nil, "Class '"..name.."' is already registered!" )
	assert_warn( _LANG["english"]["CLASSES"][name] != nil and _LANG["english"]["CLASS_OBJECTIVES"][name] != nil, "No language entry for: "..name )

	CLASSES[string.upper( name )] = name

	data.support = support
	data.name = name
	data.group = group
	data.model = model
	data.loadout = data.loadout or name

	AllClasses[name] = data
	usetab[group][name] = data

	local tier = data.tier or 0
	if !ClassTiers[tier] then
		ClassTiers[tier] = {}
	end

	if tier > highest_tier then
		highest_tier = tier
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
	
	local dice = math.random( total )
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
				//print( "WEIGHT OVERRIDE", v[1], v[2], override.WEIGHTS[v[1]], "USING", override.WEIGHTS[v[1]] or v[2] )
				v[2] = tonumber( override.WEIGHTS[v[1]] ) or v[2]
			end
		end
	end

	if !file.Exists( "slc/classes_data.txt", "DATA" ) then
		local tab = {}

		for i, v in ipairs( SelectInfo ) do
			tab[v[1]] = v[2]
		end

		WriteINI( "slc/classes_data.txt", {
			WEIGHTS = tab,
			ENABLED = false,
		}, false, ".", "This file has spawn weights for spawnable teams. To use change ENABLED to true then edit values as you wish.\n# To disable change ENABLED to false. To restore default values delete this file and restart the game" )
	end

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

hook.Add( "SLCVersionChanged", "ClassesOverride", function( new, old )
	file.Rename( "slc/classes_data.txt", "slc/classes_data_old.txt" )
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
	if self:SCPClassPoints() < 1 then return false end
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
		self:SetSCPData( "prestige_level", new_level )

		self:ResetDailyBonus( true )

		self:SetClassPoints( 0 )
		self:SetSCPLevel( 0 )
		self:Set_SCPExp( 0 )
		self:SetSCPData( "xp", 0 )

		self.PlayerInfo:Set( "unlocked_classes", {} )
		self.PlayerInfo:Update()
	end

	self.playermeta.classes = {}

	if CLIENT then
		net.Ping( "SLCPrestige" )
	end
end

if SERVER then
	hook.Add( "SLCPlayerMeta", "SLCClassInfo", function( p, playermeta )
		local classinfo = p.PlayerInfo:Get( "unlocked_classes" )
		local prestigeinfo = p.PlayerInfo:Get( "prestige_classes" )

		if !classinfo then
			classinfo = {}
			p.PlayerInfo:Set( "unlocked_classes", classinfo )
		end

		if !prestigeinfo then
			prestigeinfo = {}
			p.PlayerInfo:Set( "prestige_classes", prestigeinfo )
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

		p.PlayerInfo:Update()

		playermeta.refund = refund
		playermeta.classes = classmeta
		playermeta.prestige = prestigemeta
	end )

	net.ReceivePing( "SLCrefundClasses", function( data, p )
		local points = 0
		local prestige_points = 0

		local classinfo = p.PlayerInfo:Get( "unlocked_classes" )
		if classinfo then
			for k, v in pairs( classinfo ) do
				if !AllClasses[k] then
					classinfo[k] = nil
					points = points + 1
				end
			end
		end

		local prestigeinfo = p.PlayerInfo:Get( "prestige_classes" )
		if prestigeinfo then
			for k, v in pairs( prestigeinfo ) do
				if !AllClasses[k] then
					prestigeinfo[k] = nil
					prestige_points = prestige_points + 1
				end
			end
		end

		p.PlayerInfo:Update()

		if points > 0 or prestige_points > 0 then
			net.Ping( "SLCrefundClasses", points..","..prestige_points, p )
			
			p:AddClassPoints( points )
			p:AddPrestigePoints( prestige_points )
		end
	end )

	net.ReceivePing( "SLCPrestige", function( data, p )
		p:PerformPrestige()
	end )

	hook.Add( "SLCRegisterGamerules", "SLCLANRule", function()
		gamerule.Register( "lan", { value = false } )
	end )
end