--[[-------------------------------------------------------------------------
EntityCache
---------------------------------------------------------------------------]]
SLC_ENTITY_CACHE = {}

function CacheEntity( arg )
	if SLC_ENTITY_CACHE[arg] == true then return NULL end

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
	return NULL
end

--[[-------------------------------------------------------------------------
Door unblocker
---------------------------------------------------------------------------]]
local door_blockers = {}
local door_blockers_pattern = {}

function AddDoorBlocker( class, pattern )
	table.insert( pattern and door_blockers_pattern or door_blockers, class )
end

function GM:SLCOnDoorClosed( ply, retry, act )
	if !CVAR.slc_door_unblocker:GetBool() then return end

	local activator = act or ACTIVATOR

	if retry and retry > 1 then
		timer.Simple( 0.25, function()
			hook.Run( "SLCOnDoorClosed",  ply, retry - 1, activator )
		end )
	end

	local dpos = activator:GetPos() - Vector( 0, 0, 55.5 )
	local forward = activator:GetKeyValues().movedir
	local right = forward:Angle():Right()

	local pos_start = dpos - forward * 30 + right * 10
	local pos_end = dpos - forward * 92 - right * 3 + Vector( 0, 0, 32 )

	local found = ents.FindInBox( pos_start, pos_end )
	if #found <= 0 then return end

	local up = Vector( 0, 0, 16 )
	local mid = ( pos_start + pos_end ) / 2
	mid.z = dpos.z

	for _, item in ipairs( found ) do
		local class = item:GetClass()
		local pos = item:GetPos()
		pos.z = dpos.z

		local is_blocker = ply and item:IsPlayer() or door_blockers[class]

		if !is_blocker then
			for _, pattern in ipairs( door_blockers_pattern ) do
				if string.find( class, pattern ) then
					is_blocker = true
					break
				end
			end
		end

		if !is_blocker then continue end

		local diff = ( pos - mid ):GetNormalized()
		local dot = diff:Dot( right )

		item:SetPos( pos + up + right * 64 * ( dot >= 0 and 1 or -1 ) )
		item:DropToFloor()
	end
end

AddDoorBlocker( "^item_slc_", true )
AddDoorBlocker( "^weapon_", true )
AddDoorBlocker( "^cw_", true )
AddDoorBlocker( "^khr_", true )
AddDoorBlocker( "slc_turret", false )
AddDoorBlocker( "slc_vest", false )

--[[-------------------------------------------------------------------------
Door destroyer
---------------------------------------------------------------------------]]
SLC_DESTROYED_DOORS_LOOKUP = SLC_DESTROYED_DOORS_LOOKUP or {}
SLC_DESTROYED_DOORS = SLC_DESTROYED_DOORS or {}

//lua_run DestroyDoor(Entity(1):GetEyeTrace().Entity:GetParent(), Entity(1):EyeAngles())
function DestroyDoor( ent, breach_ang, ignore_moving )
	if SLC_DESTROYED_DOORS_LOOKUP[ent:EntIndex()] then return true end
	if !CanDestroyDoor( ent, ignore_moving ) then return false end

	local ent_list = GetDoorEnts( ent )
	if #ent_list == 0 then return false end

	local areaportal = GetDoorAreaportal( ent )
	local orig_groups = {}
	local orig_solids = {}
	for i, v in ipairs( ent_list ) do
		v:SetNoDraw( true )

		orig_groups[i] = v:GetCollisionGroup()
		v:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		orig_solids[i] = v:GetSolid()
		v:SetSolid( SOLID_NONE )

		local class = v:GetClass()
		if class == "func_door" or class == "func_door_rotating" then
			//v:Fire( "open" )
			v:Fire( "lock" )

			SLC_DESTROYED_DOORS_LOOKUP[v:EntIndex()] = true
		end
	end

	if IsValid( areaportal ) then
		areaportal:Fire( "open" )
	end

	local time = CVAR.slc_door_destroy_time:GetInt()
	local data = {
		ent_list = ent_list,
		orig_groups = orig_groups,
		orig_solids = orig_solids,
		areaportal = areaportal,
		time = time > 0 and CurTime() + time,
		last_seen = 0,
	}

	SLC_DESTROYED_DOORS[ent:EntIndex()] = data

	local pos = ent:GetPos()
	util.ScreenShake( pos, 10, 40, 2, 500, true )

	ent:EmitSound( "SLC.DestroyDoor" )
	ent:EmitSound( "SLC.DestroyDoorStress" )

	local effect = EffectData()
	effect:SetOrigin( pos )

	util.Effect( "slc_door_destroy", effect, true, true )

	local prop_model, prop_pos, prop_ang, prop_scale = TranslateDoorModel( ent, breach_ang )
	if !prop_model then return true end
	local prop = ents.Create( "prop_dynamic" )
	if !IsValid( prop ) then return true end

	prop:SetModel( prop_model )
	prop:SetModelScale( prop_scale or 1 )
	prop:SetPos( prop_pos )
	prop:SetAngles( prop_ang )
	prop:Spawn()

	data.prop = prop
	return true
end

sound.Add( {
	name = "SLC.DestroyDoor",
	sound = "doors/heavy_metal_stop1.wav",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = { 95, 105 }
} )

sound.Add( {
	name = "SLC.DestroyDoorStress",
	sound = {
		"ambient/materials/metal_stress5.wav",
		"ambient/materials/metal_stress4.wav"
	},
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = { 95, 105 }
} )

function IsDoorDestroyed( ent )
	return !!SLC_DESTROYED_DOORS_LOOKUP[ent:EntIndex()]
end

function RestoreDoor( id )
	local tab = SLC_DESTROYED_DOORS[id]
	if !tab then return end

	SLC_DESTROYED_DOORS[id] = nil

	for i, v in ipairs( tab.ent_list ) do
		v:SetNoDraw( false )
		v:SetCollisionGroup( tab.orig_groups[i] )
		v:SetSolid( tab.orig_solids[i] )

		local class = v:GetClass()
		if class == "func_door" or class == "func_door_rotating" then
			v:Fire( "unlock" )
			v:Fire( "close" )

			SLC_DESTROYED_DOORS_LOOKUP[v:EntIndex()] = nil
		end
	end

	if IsValid( tab.areaportal ) then
		tab.areaportal:Fire( "close" )
	end

	if IsValid( tab.prop ) then
		tab.prop:Remove()
	end
end

local door_pos_offset = Vector( 0, 0, 32 )
function RestoreDoorSilent( id )
	local data = SLC_DESTROYED_DOORS[id]
	if !data then return end

	if !IsValid( data.prop ) then
		RestoreDoor( id )
		return
	end

	local ct = CurTime()
	local pos = data.prop:GetPos() + door_pos_offset
	for i, v in ipairs( ents.FindInPVS( pos ) ) do
		if !v:IsPlayer() then continue end

		local diff = ( pos - v:EyePos() )
		if diff:LengthSqr() < 10000 then return end

		if diff:GetNormalized():Dot( v:EyeAngles():Forward() ) > 0.5 then
			data.last_seen = ct
			return
		end
	end

	if data.last_seen + CVAR.slc_door_repair_time:GetInt() >= ct then return end

	RestoreDoor( id )
end

local n_repair_check = 0
hook.Add( "Think", "SLCRepairDoors", function()
	local ct = CurTime()
	if n_repair_check > ct then return end
	n_repair_check = ct + 1

	for id, data in pairs( SLC_DESTROYED_DOORS ) do
		if !data.time or data.time >= ct then continue end

		RestoreDoorSilent( id )
	end
end )

--[[-------------------------------------------------------------------------
ButtonController
---------------------------------------------------------------------------]]
SLC_CONTROLLERS_CACHE = SLC_CONTROLLERS_CACHE or {}
SLC_BUTTON_CONTROLLERS = SLC_BUTTON_CONTROLLERS or {}
SLC_CONTROLLERS_USE_TIME = SLC_CONTROLLERS_USE_TIME or {}
SLC_CONTROLLERS_LAST_SETID = SLC_CONTROLLERS_LAST_SETID or {}

local function internal_use( ply, ent, data )
	local cached = SLC_CONTROLLERS_CACHE[ent]
	if !cached then return end

	if SLC_CONTROLLERS_LAST_SETID[data.name] == cached[2] then
		return true
	end

	if data.cooldown then
		if !SLC_CONTROLLERS_USE_TIME[data.name] then
			SLC_CONTROLLERS_USE_TIME[data.name] = 0
		end

		if SLC_CONTROLLERS_USE_TIME[data.name] > CurTime() then
			return true
		end
	end

	if isfunction( data.on_use ) and data.on_use( ply, ent, data, cached[2] ) then
		return true
	end

	if data.cooldown then
		SLC_CONTROLLERS_USE_TIME[data.name] = CurTime() + data.cooldown
	end

	if data.debug_use and !data.access then
		ent:Fire( "Use" )
	end

	SLC_CONTROLLERS_LAST_SETID[data.name] = cached[2]
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
Intercom
---------------------------------------------------------------------------]]
hook.Add( "SLCPreround", "SLCIntercom", function()
	local intercom = ents.Create( "slc_intercom" )
	if IsValid( intercom ) then
		intercom:SetPos( INTERCOM[1] )
		intercom:SetAngles( INTERCOM[2] )
		intercom:SetUsable( true, 1 )
		intercom:Spawn()

		INTERCOM_SCREEN = intercom

		RegisterButton( {
			name = "Intercom",
			msg_access = "",
			scp_disallow = true,
		}, intercom )
	end
end )

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
				box:SetRating( v.rating )
			end

			box.BoxName = v.name
			box.Time = v.time or 0

			if isnumber( v.fuse ) and v.fuse > 0 then
				if v.fuse < 1 then
					if SLCRandom() < v.fuse then
						box:SetFuse( box:GetRating() )
					end
				else
					box:SetFuse( v.fuse )
				end
			elseif istable( v.fuse ) then
				box:SetFuse( SLCRandom( v.fuse[1], v.fuse[2] ) )
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
	local rok = false

	for _, v in ipairs( tab ) do
		local box = SLC_FUSE_BOXES[v]
		if !IsValid( box ) then continue end

		rok = box:GetFuse() >= box:GetRating()

		if !rok and tab.all then
			break
		elseif rok and !tab.all then
			return
		end
	end

	if rok then return end

	return false, data.access and ( omni and "nopower_omni" or data.msg_omnitool or "acc_omnitool" ) or "nopower", 1
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
	SEL_REGISTRY = {}
	SLC_FUSE_BOXES = {}
	SLC_CATCH_INPUT = {}
	SLC_ENTITY_CACHE = {}
	SLC_DESTROYED_DOORS = {}
	SLC_DESTROYED_DOORS_LOOKUP = {}

	SLC_CONTROLLERS_CACHE = {}
	SLC_CONTROLLERS_USE_TIME = {}
	SLC_CONTROLLERS_LAST_SETID = {}

	for k, v in pairs( SLC_BUTTON_CONTROLLERS ) do
		if v.initial_state then
			SLC_CONTROLLERS_LAST_SETID[v.name] = v.initial_state
		end
	end
end )