local SCPObjects = {}
local SCPNoSelectObjects = {}
local TransmitSCPS = {}

local SCP_VALID_ENTRIES = {
	base_speed = true,
	run_speed = true,
	base_health = true,
	max_health = true,
	jump_power = true,
	crouch_speed = true,
	no_ragdoll = true,
	model_scale = true,
	hands_model = true,
	prep_freeze = true,
	no_spawn = true,
	no_model = true,
	no_swep = true,
	no_strip = true,
	no_select = true,
	no_draw = true,
	allow_chat = true,
	scp_human = true,
	no_damage_forces = true,
	dynamic_spawn = true,
	no_terror = true,
	can_interact = true,
	reward_override = true,
	disable_overload = true,
	//disable_crosshair = true,
}

local SCP_DYNAMIC_VARS = {}
local SCP_DYNAMIC_DEFAULT = {}

function UpdateDynamicVars()
	print( "Updating SCPs dynamic vars" )

	if !file.Exists( "slc/scp_override.txt", "DATA" ) then
		WriteINI( "slc/scp_override.txt", {} )
	end

	if DEVELOPER_MODE then
		print( "Dev mode is enabled! Overwritting INI values..." )
	else
		local override = LoadINI( "slc/scp_override.txt" )

		for k, v in pairs( override ) do
			if istable( v ) then
				for _k, _v in pairs( v ) do
					if !SCP_DYNAMIC_VARS[k] then
						SCP_DYNAMIC_VARS[k] = {}
					end

					SCP_DYNAMIC_VARS[k][_k] = _v
				end
			end
		end
	end
end

function SaveDynamicVars()
	//WriteINI( "slc/scp_default.txt", SCP_DYNAMIC_VARS, false, ".", "For reference use only (this file is not used anywhere)! Use scp_override.txt instead!\n# Changes in scp_override.txt will affect this file so 'real' default values are gone!" )
	WriteINI( "slc/scp_default.txt", SCP_DYNAMIC_DEFAULT, false, ".", "For reference use only (this file is not used anywhere)! Use scp_override.txt instead.\n# Copy and paste SCP header (e.g. [SCP173]), then just below it paste attribute that you want to edit and change its value" )
end

function SendSCPList( ply )
	local data = {}

	for i, v in ipairs( SCPS ) do
		local obj = SCPObjects[v]
		table.insert( data, { name = v, model = obj.model, hp = obj.basestats.base_health, speed = obj.basestats.base_speed } )
	end

	net.Start( "SCPList" )
		net.WriteTable( data )
		net.WriteTable( TransmitSCPS )

	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end
end

function GetSCP( name )
	return SCPObjects[name] or SCPNoSelectObjects[name]
end

function RegisterSCP( name, model, weapon, static_stats, dynamic_stats, custom_callback, post_callback )
	--RegisterSCP( "name", "path_to_model", "SWEP_class_name", {entry = value} )
	if !name or !model or !weapon or !static_stats then return end

	dynamic_stats = dynamic_stats or {}

	if SCPObjects[name] then
		error( "SCP " .. name .. "is already registered!" )
	end

	if !_LANG["english"]["CLASSES"][name] or !_LANG["english"]["CLASS_OBJECTIVES"][name] then
		MsgC( Color( 255, 50, 50 ), "No language entry for: "..name, "\n" )
	end

	local spawn = _G["SPAWN_"..name]
	if !static_stats.no_spawn and !dynamic_stats.no_spawn and !static_stats.dynamic_spawn and !dynamic_stats.dynamic_spawn then
		if !spawn or ( !isvector( spawn ) and !istable( spawn ) ) then
			error( "No spawn position entry for: "..name )
		end
	end

	CLASSES[name] = name

	local scp = ObjectSCP( name, model, weapon, spawn, static_stats, dynamic_stats )

	if custom_callback and isfunction( custom_callback ) then
		scp:SetCallback( custom_callback )
	end

	if post_callback and isfunction( post_callback ) then
		scp:SetCallback( post_callback, true )
	end

	if !scp.basestats.no_select then
		SCPObjects[name] = scp
		table.insert( SCPS, name )
	else
		SCPNoSelectObjects[name] = scp
		table.insert( TransmitSCPS, name )
	end

	print( name.." has been registered!" )
	return true
end


-----SCP class-----
ObjectSCP = {}
ObjectSCP.__index = ObjectSCP

function ObjectSCP:Create( name, model, weapon, pos, static_stats, dynamic_stats )
	local scp = setmetatable( {}, ObjectSCP )
	scp.Create = function() end

	scp.name = name
	scp.model = model
	scp.swep = weapon
	scp.spawnpos = pos
	scp.basestats = {}

	scp.callback = function() end
	scp.post = function() end

	if !SCP_DYNAMIC_VARS[name] then
		SCP_DYNAMIC_VARS[name] = {}
	end

	SCP_DYNAMIC_DEFAULT[name] = SCP_DYNAMIC_DEFAULT[name] or {}

	local dv = SCP_DYNAMIC_VARS[name]
	local dd = SCP_DYNAMIC_DEFAULT[name]

	for k, v in pairs( dynamic_stats ) do
		if SCP_VALID_ENTRIES[k] then
			local istab = istable( v )
			local var = istab and v.var or v

			dd[k] = var

			if dv[k] then
				var = dv[k]
			else
				dv[k] = var
			end

			if istab then
				if v.min or v.max then
					if !isnumber( var ) then
						ErrorNoHalt( name.." entry: "..k..". Number expected, got "..type( var ) )
						continue
					end

					if v.min then
						var = math.max( v.min, var )
					end

					if v.max then
						var = math.min( v.max, var )
					end
				end
			end

			scp.basestats[k] = var
		else
			print( "Invalid dynamic stat entry '"..k.."' for "..name )
		end
	end

	for k, v in pairs( static_stats ) do
		if SCP_VALID_ENTRIES[k] then
			scp.basestats[k] = v
		else
			print( "Invalid static stat entry '"..k.."' for "..name )
		end
	end

	return scp
end

function ObjectSCP:SetCallback( cb, post )
	if post then
		self.post = cb
	else
		self.callback = cb
	end
end

local function setup_scp_internal( self, ply, ... )
	local args = {...}
	local basestats = table.Copy( self.basestats )

	if self.callback then
		if self.callback( ply, basestats, ... ) then
			return
		end
	end

	ply:UnSpectate()
	ply:Cleanup( basestats.no_strip == true )
	//ply:GodDisable()

	/*if !self.basestats.no_strip then
		ply:SetVest( 0 )
		ply:RemoveAllItems()
		//ply:StripWeapons()
		//ply:RemoveAllAmmo()
	end*/

	local pos = self.spawnpos
	if pos and !basestats.no_spawn then
		if istable( pos ) then
			pos = table.Random( pos )
		end

		ply:Spawn()
		ply:SetPos( pos )
	elseif basestats.dynamic_spawn and isvector( args[1] ) then
		ply:Spawn()
		ply:SetPos( args[1] )
	end

	ply:SetSCPTeam( TEAM_SCP )
	ply:SetSCPClass( CLASSES[self.name] )

	//ply.SCPHuman = basestats.is_human == true
	//ply.SCPChat = basestats.allow_chat == true

	ply:SetSCPHuman( basestats.scp_human == true )
	ply:SetSCPChat( basestats.allow_chat == true )
	//ply:SetSCPTerror( basestats.no_terror != true )
	ply:SetSCPCanInteract( basestats.can_interact == true )
	ply:SetSCPDisableOverload( basestats.disable_overload == true )

	if !basestats.no_model then
		ply:SetModel( self.model )
	end

	ply:SetModelScale( basestats.model_scale or 1 )

	ply:SetHealth( basestats.base_health or 1500 )
	ply:SetMaxHealth( basestats.max_health or 1500 )

	ply:SetBaseSpeed( basestats.base_speed or 200, basestats.run_speed or basestats.base_speed or 200, 0.4 )
	ply:SetJumpPower( basestats.jump_power or 200 )

	if !basestats.no_swep then
		local wep = ply:Give( self.swep )
		ply:SelectWeapon( self.swep )

		if IsValid( wep ) then
			wep.ShouldFreezePlayer = basestats.prep_freeze == true
		end

		ply:SetProperty( "scp_weapon", wep )
	end

	ply:SetArmor( 0 )

	ply:Flashlight( false )
	ply:AllowFlashlight( false )

	/*if basestats.disable_crosshair == true then
		ply:CrosshairDisable()
	else
		ply:CrosshairEnable()
	end*/

	ply:SetNoDraw( basestats.no_draw == true )

	if basestats.no_damage_forces == true then
		ply:AddEFlags( EFL_NO_DAMAGE_FORCES )
	end

	//ply.noragdoll = basestats.no_ragdoll == true
	ply:SetSCPNoRagdoll( basestats.no_ragdoll == true )

	if isnumber( basestats.reward_override ) then
		ply:SetProperty( "reward_override", basestats.reward_override )
	end

	//ply.handsmodel = basestats.hands_model
	ply:SetupHands()

	hook.Run( "SLCSCPSetup", ply, self.name )

	//net.Start( "PlayerSetup" )
	//net.Send( ply )

	if self.post then
		self.post( ply, ... )
	end
end

function ObjectSCP:SetupPlayer( ply, instant, ... )
	EnableSCPHook( self.name )

	if instant then
		setup_scp_internal( self, ply, ... )
	else
		ply:KillSilent()
		ply:UnSpectate()
		ply:SetPos( ZERO_POS )

		ply:SetSCPTeam( TEAM_SCP )
		ply:SetSCPClass( CLASSES[self.name] )

		ply:SetProperty( "spawning_scp", { time = CurTime() + INFO_SCREEN_DURATION, obj = self, args = {...} } )
		InfoScreen( ply, "spawn", INFO_SCREEN_DURATION )
	end
end

hook.Add( "Tick", "SLCSpawnSCPTick", function()
	local ct = CurTime()

	for k, v in pairs( player.GetAll() ) do
		local data = v:GetProperty( "spawning_scp" )
		if data and data.time < ct then
			v:SetProperty( "spawning_scp", nil )
			setup_scp_internal( data.obj, v, unpack( data.args ) )
		end
	end
end )

setmetatable( ObjectSCP, { __call = ObjectSCP.Create } )
--------------------------------------------------------------------------------

hook.Add( "SLCGamemodeLoaded", "SLCSCPModule", function()
	UpdateDynamicVars()

	hook.Run( "RegisterSCP" )
	SaveDynamicVars()

	if SetupForceSCP then SetupForceSCP() end

	//for k, v in pairs( player.GetAll() ) do
		SendSCPList()
	//end
end )

hook.Add( "SLCFactoryReset", "SLCResetSCPs", function()
	print( "Deleting SCP settings..." )

	file.Delete( "slc/scp_override.txt" )
	file.Delete( "slc/scp_default.txt" )
end )