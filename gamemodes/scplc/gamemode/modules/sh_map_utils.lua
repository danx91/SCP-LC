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
	data.controller = true

	SLC_BUTTON_CONTROLLERS[name] = data

	if !istable( data.buttons_set ) then return end

	local btn_set = {}
	for id, set in pairs( data.buttons_set ) do
		if !istable( set ) then continue end
		for _, pos in pairs( set ) do
			table.insert( btn_set, pos )
		end
	end
end

hook.Add( "SLCUseOverride", "SLCButtonController", function( ply, ent, data )
	if !ent.ControllersSearched then
		ent.ControllersSearched = true

		for name, cdata in pairs( SLC_BUTTON_CONTROLLERS ) do
			if !istable( cdata.buttons_set ) then continue end
			for id, set in pairs( cdata.buttons_set ) do
				if !istable( set ) then continue end
				for _, pos in pairs( set ) do
					if ent:GetPos() == pos then
						SLC_CONTROLLERS_CACHE[ent] = { name, id }
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

--[[-------------------------------------------------------------------------
SynchronousEventListener
---------------------------------------------------------------------------]]
SEL_REGISTRY = SEL_REGISTRY or {}
SEL_USER = 0
SEL_TRIGGER = 1
SEL_FULL_TRIGGER = 2

local selobj = {
	Trigger = function( self, ply, ent, id )
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

--[[-------------------------------------------------------------------------
Blocker
---------------------------------------------------------------------------]]
local ps = {
	{ 1, 0, 0, 1 },
	{ -1, 0, 0, 1 },
	{ 0, 1, 1, 0 },
	{ 0, -1, 1, 0 },
}

function GenCubeBlockerData( name, pos, x, y, z, thickness, ex, filter, dest )
	dest = dest or BLOCKERS

	for i = 1, 4 do
		local dim = ps[i]
		if !ex or ex != i then
			table.insert( dest, {
				name = name.."_"..i,
				pos = pos + Vector( ( x / 2 - thickness / 2 ) * dim[1], ( y / 2 - thickness / 2 ) * dim[2], 0 ),
				bounds = {
					Vector( dim[3] == 1 and ( -x / 2 + thickness ) or ( -thickness / 2 ), dim[4] == 1 and ( -y / 2 ) or ( -thickness / 2 ), -z / 2 ),
					Vector( dim[3] == 1 and ( x / 2 - thickness ) or ( thickness / 2 ), dim[4] == 1 and ( y / 2 ) or ( thickness / 2 ), z / 2 ),
				},
				filter = filter,
			} )
		end
	end

	/*table.insert( dest, {
		name = name.."_xp",
		pos = pos + Vector( x / 2 - thickness / 2, 0, 0 ),
		bounds = {
			Vector( -thickness / 2, -y / 2, -z / 2 ),
			Vector(  thickness / 2,  y / 2,  z / 2 ),
		}
	} )

	table.insert( dest, {
		name = name.."_xn",
		pos = pos - Vector( x / 2 - thickness / 2, 0, 0 ),
		bounds = {
			Vector( -thickness / 2, -y / 2, -z / 2 ),
			Vector(  thickness / 2,  y / 2,  z / 2 ),
		}
	} )

	table.insert( dest, {
		name = name.."_yp",
		pos = pos + Vector( 0, y / 2 - thickness / 2, 0 ),
		bounds = {
			Vector( -x / 2 + thickness, -thickness / 2, -z / 2 ),
			Vector(  x / 2 - thickness,  thickness / 2,  z / 2 ),
		}
	} )

	table.insert( dest, {
		name = name.."_yn",
		pos = pos - Vector( 0, y / 2 - thickness / 2, 0 ),
		bounds = {
			Vector( -x / 2 + thickness, -thickness / 2, -z / 2 ),
			Vector(  x / 2 - thickness,  thickness / 2,  z / 2 ),
		}
	} )*/
end

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

--[[-------------------------------------------------------------------------
EntityCache
---------------------------------------------------------------------------]]
SLC_ENTITY_CACHE = {}

function CacheEntity( arg )
	if SLC_ENTITY_CACHE[arg] == true then return end

	if SLC_ENTITY_CACHE[arg] then
		return SLC_ENTITY_CACHE[arg]
	end

	local isn = isnumber( arg )
	local iss = isstring( arg )
	local isv = isvector( arg )

	for i, v in ipairs( ents.GetAll() ) do
		if isn and v:MapCreationID() != arg then continue end
		if iss and v:GetName() != arg then continue end
		if isv and v:GetPos() != arg then continue end

		SLC_ENTITY_CACHE[arg] = v
		return v
	end

	SLC_ENTITY_CACHE[arg] = true
end

--[[-------------------------------------------------------------------------
Fuse Boxes
---------------------------------------------------------------------------]]
SLC_FUSE_BOXES = SLC_FUSE_BOXES or {}

hook.Add( "SLCPreround", "SLCFuseBox", function()
	if CVAR.slc_disable_fuseboxes:GetInt() != 0 then return end

	for i, v in ipairs( FUSE_BOXES ) do
		local box = ents.Create( "slc_fuse_box" )
		if IsValid( box ) then
			box:SetPos( v.pos )
			box:SetAngles( v.ang )

			if v.rating then
				box.Rating = v.rating
			end

			if isnumber( v.fuse ) and v.fuse > 0 then
				if v.fuse < 1 then
					if math.random() < v.fuse then
						box:SetFuse( box.Rating )
					end
				else
					box:SetFuse( v.fuse )
				end
			elseif istable( v.fuse ) then
				box:SetFuse( math.random( v.fuse[1], v.fuse[2] ) )
			end

			box:Spawn()

			SLC_FUSE_BOXES[v.name] = box

			RegisterButton( {
				name = v.name,
				cooldown = 0.75,
				msg_access = "",
				disable_overload = true,
				scp_disallow = true,
			}, box )
		end
	end
end )

hook.Add( "SLCButtonUse", "SLCFuseBox", function( ply, ent, data, omni )
	if !data.fuse_box or CVAR.slc_disable_fuseboxes:GetInt() != 0 then return end
	
	local tab = istable( data.fuse_box ) and data.fuse_box or { data.fuse_box }
	for _, v in ipairs( tab ) do
		local box = SLC_FUSE_BOXES[v]
		if !IsValid( box ) then continue end

		local rok = box:GetFuse() >= box.Rating
		if !rok and tab.all then
			break
		elseif rok and !tab.all then
			return
		end
	end

	return false, data.access and ( omni and "nopower_omni" or "acc_omnitool" ) or "nopower", 1
end )

--[[-------------------------------------------------------------------------
Catch Input
---------------------------------------------------------------------------]]
SLC_CATCH_INPUT = SLC_CATCH_INPUT or {}

function CatchInput( name, func )
	local ent = CacheEntity( name )
	if !ent then return end

	SLC_CATCH_INPUT[ent] = func
end

--[[-------------------------------------------------------------------------
Utils Cleanup
---------------------------------------------------------------------------]]
hook.Add( "SLCRoundCleanup", "SLCMapUtilsCleanup", function()
	SLC_ENTITY_CACHE = {}
	SLC_CATCH_INPUT = {}
	SLC_FUSE_BOXES = {}
	SEL_REGISTRY = {}

	SLC_CONTROLLERS_CACHE = {}
	SLC_CONTROLLERS_USE_TIME = {}
	SLC_CONTROLLERS_LAST_SETID = {}

	for k, v in pairs( SLC_BUTTON_CONTROLLERS ) do
		if v.initial_state then
			SLC_CONTROLLERS_LAST_SETID[v.name] = v.initial_state
		end
	end
end )