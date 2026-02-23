local PLAYER = FindMetaTable( "Player" )

--[[-------------------------------------------------------------------------
SLCProperties
---------------------------------------------------------------------------]]
SLCKeepProperties = SLCKeepProperties or {}

PROPERTY_KEEP_ROUND = 0
PROPERTY_KEEP_ALWAYS = 1

function PLAYER:ResetProperties( round_reset )
	if !self.SLCProperties then self.SLCProperties = {} end

	for k, v in pairs( self.SLCProperties ) do
		local keep = SLCKeepProperties[k]
		if !keep or keep == PROPERTY_KEEP_ROUND and round_reset then
			self.SLCProperties[k] = nil
		end
	end
end

function PLAYER:SetProperty( key, value, sync, keep )
	if !self.SLCProperties then self.SLCProperties = {} end

	if SERVER and sync then
		net.Start( "SLCPropertyChanged" )
			net.WriteString( key )
			net.WriteTable( { value } )
		net.Send( self )
	end

	self.SLCProperties[key] = value
	return value
end

function PLAYER:GetProperty( key, def )
	if !self.SLCProperties then self.SLCProperties = {} end

	if !self.SLCProperties[key] and def != nil then
		self.SLCProperties[key] = def
	end

	return self.SLCProperties[key]
end

function KeepPlayerProperty( key, keep )
	SLCKeepProperties[key] = keep
end

function BindPlayerProperty( func, key, def, data )
	data = data or {}

	local sync = !!data.sync

	if data.keep then
		KeepPlayerProperty( key, data.keep )
	end

	PLAYER["Get"..func] = function( self )
		return self:GetProperty( key, def )
	end

	PLAYER["Set"..func] = function( self, val )
		self:SetProperty( key, val, sync )
	end
end

--[[-------------------------------------------------------------------------
Hold manager
---------------------------------------------------------------------------]]
function PLAYER:StartHold( tab, id, key, time, cb, never )
	if !self:KeyDown( key ) then return end

	if !tab._ButtonHold then
		tab._ButtonHold = {}
	end

	id = id..self:SteamID()

	local data = {
		key = key,
		duration = time,
		time = CurTime() + time,
		never = !!never,
		cb = cb,
		sig = self:TimeSignature()
	}

	tab._ButtonHold[id] = data
end

function PLAYER:UpdateHold( tab, id )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	if data.interrupted or !self:KeyDown( data.key ) or !self:CheckSignature( data.sig ) then
		if data.cb then data.cb( self, tab, false ) end
		tab._ButtonHold[id] = nil
		return false, data
	end

	if !data.never and data.time <= CurTime() then
		if data.cb then data.cb( self, tab, true ) end
		tab._ButtonHold[id] = nil
		return true, data
	end
end

function PLAYER:InterruptHold( tab, id )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	tab._ButtonHold[id].interrupted = true
end

function PLAYER:IsHolding( tab, id )
	if !tab._ButtonHold then return false end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data or !self:CheckSignature( data.sig ) then return false end

	return self:KeyDown( data.key )
end

function PLAYER:HoldProgress( tab, id )
	if !tab._ButtonHold then return end

	id = id..self:SteamID()

	local data = tab._ButtonHold[id]
	if !data then return end

	return math.Clamp( 1 - ( data.time - CurTime() ) / data.duration, 0, 1 )
end

--[[-------------------------------------------------------------------------
Disable Controls
---------------------------------------------------------------------------]]
function PLAYER:DisableControls( id, mask )
	if !self.DisableControlsRegistry then
		self.DisableControlsRegistry = {}
	end

	mask = mask or 0

	self.DisableControlsRegistry[id] = mask

	self:SetDisableControls( true )
	self:SetDisableControlsMask( bit.band( self:GetDisableControlsMask(), mask ) )
end

function PLAYER:StopDisableControls( id )
	if !self.DisableControlsRegistry or !self.DisableControlsRegistry[id] then return end

	self.DisableControlsRegistry[id] = nil

	if !next( self.DisableControlsRegistry ) then
		self:SetDisableControls( false )
		self:SetDisableControlsMask( -1 )
		return
	end

	local mask = -1
	for k, v in pairs( self.DisableControlsRegistry ) do
		mask = bit.band( mask, v )
		
		if mask == 0 then break end
	end

	self:SetDisableControlsMask( mask )
end

function PLAYER:ResetDisableControls()
	self:SetDisableControls( false )
	self:SetDisableControlsMask( -1 )
	self.DisableControlsRegistry = {}
end

--[[-------------------------------------------------------------------------
Accessors
---------------------------------------------------------------------------]]
function SLCAccessor( func, data )
	data = data or {}

	local getter = "Get"..(data.internal or "_"..func)
	local setter = "Set"..(data.internal or "_"..func)
	local db_key = data.db_key
	local db_client = data.db_client
	local ignore_dt = data.ignore_dt

	PLAYER[data.getter or "Get"..func] = function( self )
		if !ignore_dt and !self[getter] then
			self:DataTables()
		end

		return self[getter]( self )
	end

	PLAYER[data.setter or "Set"..func] = function( self, val )
		if !ignore_dt and !self[setter] then
			self:DataTables()
		end

		self[setter]( self, val )

		if db_key and ( db_client or SERVER ) then
			self:SetSCPData( db_key, val )
		end
	end
end

SLCDatabaseProperties = SLCDatabaseProperties or {}

function SLCDatabaseProperty( func, key, def, db, sync )
	local db_key = db or key

	SLCDatabaseProperties[key] = { db_key = db_key, def = def, sync = sync }

	BindPlayerProperty( "_"..func, key, def, { sync = sync, keep = PROPERTY_KEEP_ALWAYS } )
	SLCAccessor( func, { db_key = db_key, ignore_dt = true } )
end

hook.Add( "PlayerInitialSpawn", "SLCDatabaseProperties", function( ply )
	for key, data in pairs( SLCDatabaseProperties ) do
		ply:GetSCPData( data.db_key, data.def ):Then( function( val )
			if !IsValid( ply ) then return end
			ply:SetProperty( key, val, data.sync )
		end )
	end
end )

--[[-------------------------------------------------------------------------
Player functions
---------------------------------------------------------------------------]]
function PLAYER:DataTables()
	if !IsValid( self ) then return end

	player_manager.SetPlayerClass( self, "class_slc" )
	player_manager.RunClass( self, "SetupDataTables" )
end

function PLAYER:RequiredXP( lvl )
	if !lvl then
		lvl = self:PlayerLevel()
	end

	if SLC_XP_OVERRIDE then
		return SLC_XP_OVERRIDE( lvl )
	else
		return CVAR.slc_xp_level:GetInt() + CVAR.slc_xp_increase:GetInt() * lvl
	end
end

function PLAYER:SCPClass()
	if !self.Get_SCPClass then
		self:DataTables()
	end

	return self:Get_SCPClass()
end

function PLAYER:SCPPersona()
	if !self.Get_SCPPersonaC or !self.Get_SCPPersonaT then
		self:DataTables()
	end

	return self:Get_SCPPersonaC(), self:Get_SCPPersonaT()
end

function PLAYER:GetPlayermeta()
	return self.playermeta
end

function PLAYER:TimeSignature()
	if !self.GetTimeSignature then
		self:DataTables()
	end

	return self:GetTimeSignature()
end

function PLAYER:CheckSignature( time )
	return self:TimeSignature() == time
end

function PLAYER:IsSpectator()
	return !self:Alive() and self:SCPTeam() == TEAM_SPEC
end

function PLAYER:GetInventorySize()
	local backpack = self:GetWeapon( "item_slc_backpack" )
	if IsValid( backpack ) then
		return 6 + backpack:GetSize()
	end

	return 6
end

function PLAYER:GetFreeInventory()
	local weps = self:GetWeapons()
	local free = self:GetInventorySize()

	for i, v in ipairs( weps ) do
		if v:GetClass() == "item_slc_id" or v:IsDerived( "item_slc_holster" ) then continue end

		free = free - 1
	end

	return free
end

function PLAYER:IsHuman()
	return SCPTeams.HasInfo( self:SCPTeam(), SCPTeams.INFO_HUMAN ) or ( SERVER or self == LocalPlayer() ) and self:GetSCPHuman()
end

function PLAYER:IsInEscape()
	if istable( POS_ESCAPE ) then
		return self:GetPos():WithinAABox( POS_ESCAPE[1], POS_ESCAPE[2] )
	else
		return self:GetPos():DistToSqr( POS_ESCAPE ) <= ( DIST_ESCAPE or 22500 )
	end
end

function PLAYER:IsInSafeSpot()
	return IsInSafeSpot( self:GetPos() )
end

function PLAYER:CheckHazardProtection( dmg )
	return self:CheckHazmat( dmg ) or self:CheckGasmask( dmg )
end

function PLAYER:CheckGasmask( dmg )
	local mask = self:GetWeaponByGroup( "gasmask" )
	if IsValid( mask ) and mask:GetEnabled() then
		if dmg then
			mask:Damage( dmg )
		end

		return true
	end
end

function PLAYER:CheckHazmat( dmg, full )
	local vest = self:GetVest()
	local dur = self:GetVestDurability()
	if vest > 0 and dur > 0 and VEST.GetName( vest ) == "hazmat" then
		if dmg then
			dur = dur - dmg

			if dur < 0 then
				dur = 0
			end

			self:SetVestDurability( dur )
		end
		
		return !full or dur > 0
	end

	return false
end

function PLAYER:GetWeaponByGroup( group )
	for i, v in ipairs( self:GetWeapons() ) do
		if v:IsGroup( group ) then
			return v
		end
	end
end

function PLAYER:GetWeaponByBase( base, all )
	local tab

	if all then
		tab = {}
	end

	for i, v in ipairs( self:GetWeapons() ) do
		if v:IsDerived( base ) then
			if !all then
				return v
			end

			table.insert( tab, v )
		end
	end

	return tab
end

function PLAYER:GetMainWeapon()
	for i, v in ipairs( self:GetWeapons() ) do
		if SLC_WEAPONS_REG[v:GetClass()] then
			return v
		end
	end
end

function PLAYER:GetSCPWeapon()
	local wep = self:GetProperty( "scp_weapon" )
	if wep then return wep end

	for i, v in ipairs( self:GetWeapons() ) do
		if v.SCP then
			self:SetProperty( "scp_weapon", v )			
			return v
		end
	end

	return NULL
end

function PLAYER:TrueFOV()
	return math.TrueFOV( self:GetFOV() )
end

function PLAYER:ChatPrint( ... )
	if CLIENT then
		chat.AddText( ... )
	else
		net.Start( "SLCChatPrint" )
			net.WriteTable( { ... } )
		net.Send( self )
	end
end

--[[-------------------------------------------------------------------------
Base functions
---------------------------------------------------------------------------]]
BindPlayerProperty( "Blink", "slc_blink", false )
BindPlayerProperty( "NextBlink", "slc_next_blink", -1 )
BindPlayerProperty( "SightLimit", "slc_sight_limit", -1 )

BindPlayerProperty( "SCPCanInteract", "scp_can_interact", false )
BindPlayerProperty( "SCPChat", "scp_humans_chat", false )
BindPlayerProperty( "SCPNoRagdoll", "scp_no_ragdoll", false )
BindPlayerProperty( "SCPChase", "scp_chase_active", false )
BindPlayerProperty( "ChaseLevel", "scp_chase_level", 0 )

BindPlayerProperty( "InitialTeam", "slc_initial_team", 0, { keep = PROPERTY_KEEP_ROUND } )

BindPlayerProperty( "SCPHuman", "scp_is_human", false, { sync = true } )
BindPlayerProperty( "SCPDisableOverload", "scp_disable_overload", false, { sync = true } )

SLCAccessor( "IsActive", { getter = "IsActive" } )
SLCAccessor( "IsPremium", { getter = "IsPremium" } )
SLCAccessor( "IsAFK", { getter = "IsAFK" } )

SLCAccessor( "PlayerLevel", { db_key = "level", getter = "PlayerLevel" } )
SLCAccessor( "PlayerXP", { db_key = "xp", getter = "PlayerXP" } )
SLCAccessor( "ClassPoints", { db_key = "class_points", getter = "ClassPoints" } )
SLCAccessor( "DailyBonus", { db_key = "daily_bonus", getter = "DailyBonus" } )
SLCAccessor( "PrestigePoints", { db_key = "prestige_points" } )
SLCAccessor( "PrestigeLevel", { db_key = "prestige_level" } )
SLCAccessor( "SpectatorPoints", { db_key = "spectator_points" } )
SLCAccessor( "SCPPenalty", { db_key = "scp_penalty" } )
SLCAccessor( "PlayerKarma", { db_key = "scp_karma" } )