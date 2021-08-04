--[[-------------------------------------------------------------------------
ButtonController
---------------------------------------------------------------------------]]
SLC_BUTTON_CONTROLLERS = SLC_BUTTON_CONTROLLERS or {}
SLC_CONTROLLERS_CACHE = SLC_CONTROLLERS_CACHE or {}
SLC_CONTROLLERS_USE_TIME = SLC_CONTROLLERS_USE_TIME or {}
SLC_CONTROLLERS_LAST_SETID = SLC_CONTROLLERS_LAST_SETID or {}

local function internal_use( ply, ent, data )
	local cached = SLC_CONTROLLERS_CACHE[ent]
	if cached then
		if SLC_CONTROLLERS_LAST_SETID[data.name] == cached[2] then
			return true
		end

		if data.cooldown then
			if !SLC_CONTROLLERS_USE_TIME[data.name] then
				SLC_CONTROLLERS_USE_TIME[data.name] = 0
			end

			local ct = CurTime()
			if SLC_CONTROLLERS_USE_TIME[data.name] > ct then
				return true
			end

			SLC_CONTROLLERS_USE_TIME[data.name] = CurTime() + data.cooldown
		end

		if isfunction( data.on_use ) then
			if data.on_use( ply, ent, data, cached[2] ) then
				return true
			end
		end

		if data.debug_use and !data.access then
			ent:Fire( "Use" )
		end

		SLC_CONTROLLERS_LAST_SETID[data.name] = cached[2]
	end
end

local function handle_button_use( ply, ent, data )
	if !data.access then
		return internal_use( ply, ent, data )
	end
end

local function handle_input( ply, ent, data )
	return internal_use( ply, ent, data )
end

/*
	data = {
		//same as access table, except name, pos and access_granted (use on_use instead)
		buttons_set = {
			{ pos1_1, pos1_2, ... },
			{ pos2_1, pos2_2, ... },
			...
		},
		on_use = function(ply, ent, data, setid),
		cooldown = <number>,
		initial_state = <number>,
		debug_use = <boolean>,
	}
*/

function ButtonController( name, data )
	data.name = name
	data.access_granted = handle_button_use
	data.input_override = handle_input

	SLC_BUTTON_CONTROLLERS[name] = data
end

hook.Add( "SLCUseOverride", "SLCButtonController", function( ply, ent, data )
	if !ent.ControllersSearched then
		ent.ControllersSearched = true

		for name, cdata in pairs( SLC_BUTTON_CONTROLLERS ) do
			if istable( cdata.buttons_set ) then
				for id, set in pairs( cdata.buttons_set ) do
					if istable( set ) then
						for _, pos in pairs( set ) do
							if ent:GetPos() == pos then
								SLC_CONTROLLERS_CACHE[ent] = { name, id }
							end
						end
					end
				end
			end
		end
	end

	local cached = SLC_CONTROLLERS_CACHE[ent]
	if cached then
		return true, nil, SLC_BUTTON_CONTROLLERS[cached[1]]
	end
end )

/*hook.Add( "AcceptInput", "SLCButtonController", function( ent, input, activator, caller, value )
	print( ent, input, activator, caller, value )
	if input == "Use" then
		local cached = SLC_CONTROLLERS_CACHE[ent]
		if cached then
			local data = SLC_BUTTON_CONTROLLERS[cached[1]]

			SLC_CONTROLLERS_USE_TIME[data.name] = CurTime() + data.cooldown
			SLC_CONTROLLERS_LAST_SETID[data.name] = cached[2]
			print( "OK", cached[2] )
		end
	end
end )*/

hook.Add( "SLCPreround", "SLCButtonController", function()
	SLC_CONTROLLERS_CACHE = {}
	SLC_CONTROLLERS_USE_TIME = {}
	SLC_CONTROLLERS_LAST_SETID = {}

	for k, v in pairs( SLC_BUTTON_CONTROLLERS ) do
		if v.initial_state then
			SLC_CONTROLLERS_LAST_SETID[v.name] = v.initial_state
		end
	end

	--not very optimised way, but the easiest one
	/*for _, ent in pairs( ents.GetAll() ) do
		for name, data in pairs( SLC_BUTTON_CONTROLLERS ) do
			if istable( data.buttons_set ) then
				for id, set in pairs( data.buttons_set ) do
					if istable( set ) then
						for _, pos in pairs( set ) do
							if ent:GetPos() == pos then
								SLC_CONTROLLERS_CACHE[ent] = { name, id }
							end
						end
					end
				end
			end
		end
	end*/

	//print( "Controllers set up" )
	//PrintTable( SLC_CONTROLLERS_CACHE )
end )

--[[-------------------------------------------------------------------------
SynchronousEventListener
---------------------------------------------------------------------------]]
SEL_REGISTRY = SEL_REGISTRY or {}
SEL_USER = 0
SEL_TRIGGER = 1
SEL_FULL_TRIGGER = 2

local selobj = {
	Trigger = function( self, ply, ent, id )
		//print( self, id, ply, ent )

		if ROUND.post then return end

		local ct = CurTime()

		self.triggers[id] = { ply = ply, ent = ent, time = ct + self.wait_time }

		local num = 0
		local trigger_list = {}

		for tid, v in pairs( self.triggers ) do
			if v.time >= ct then
				num = num + 1
				trigger_list[tid] = { v.ply, v.ent }
			end
		end

		if num >= self.required then
			self.triggers = {}
			self.callback( self, trigger_list )
			self:BroadcastInternal( ent, true, SEL_FULL_TRIGGER, trigger_list )
		else
			self:BroadcastInternal( ent, true, SEL_TRIGGER )
		end
	end,
	AddEntity = function( self, ent )
		table.insert( self.entities, ent )
	end,
	Broadcast = function( self, ent, selfnotify, ... )
		self:BroadcastInternal( ent, selfnotify, SEL_USER, ... )
	end,
	BroadcastInternal = function( self, ent, selfnotify, t, ... )
		for k, v in pairs( self.entities ) do
			if IsValid( v ) then
				if selfnotify or v != ent then
					if v.DataBroadcast then
						v:DataBroadcast( ent, t, ... )
					end
				end
			else
				self.entities[k] = nil
			end
		end
	end,
}

/*
	name = <string> - unique name
	wait = <number> - reset time
	num = <number> - minimum unique triggers required to call callback 
	callback = function( name, info )
		name <string> - name of listener
		info <table> {
			trigger_id = { ply, ent }
			...
		}
*/

function SynchronousEventListener( name, wait, num, callback )
	local object = setmetatable( {
			name = name,
			wait_time = wait,
			required = num,
			callback = callback,
			triggers = {},
			entities = {},
		}, { __index = selobj } )

	SEL_REGISTRY[name] = object
	return object
end

function GetSELObject( name )
	return SEL_REGISTRY[name]
end

hook.Add( "SLCPreround", "SLCSynchronousEventListener", function()
	SEL_REGISTRY = {}
end )

--[[-------------------------------------------------------------------------
Blocker
---------------------------------------------------------------------------]]
SLC_FILTER_GROUPS = {}

local FilterGroup = {}

function FilterGroup:AddTeam( team )
	self.teams[team] = true

	return self
end

function FilterGroup:AddClass( class )
	self.classes[class] = true

	return self
end

function FilterGroup:AddFunction( func )
	table.insert( self.functions, func )

	return self
end

function AddFilterGroup( name, base )
	local tab = setmetatable( {
		base = base,
		teams = {},
		classes = {},
		functions = {},
	}, { __index = FilterGroup } )

	SLC_FILTER_GROUPS[name] = tab
	return tab
end

function GetFilterGroup( name )
	return SLC_FILTER_GROUPS[name]
end

function GetFilterGroupData( name )
	local filter = SLC_FILTER_GROUPS[name]
	if filter then
		local data = {
			teams = filter.teams,
			classes = filter.classes,
			players = {},
		}

		for k, func in pairs( filter.functions ) do
			local result = func( name )
			if result then
				for k2, ply in pairs( result ) do
					data.players[ply] = true
				end
			end
		end

		return data
	end
end

AddFilterGroup( "non_human" ):AddTeam( TEAM_SCP )

BLOCKER_WHITELIST = 0
BLOCKER_BLACKLIST = 1

hook.Add( "SLCPreround", "SLCBlocker", function()
	for i, v in ipairs( BLOCKERS ) do
		local blocker = ents.Create( "slc_blocker" )
		if IsValid( blocker ) then
			blocker:SetBlockerID( i )
			blocker:Spawn()
		end
	end
end )