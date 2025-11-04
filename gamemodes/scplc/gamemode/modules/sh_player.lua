local PLAYER = FindMetaTable( "Player" )

--[[-------------------------------------------------------------------------
SLCProperties
---------------------------------------------------------------------------]]
function PLAYER:ResetProperties()
	self.SLCProperties = {}
end

function PLAYER:SetProperty( key, value, sync )
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

	if !self.SLCProperties[key] and def then
		self.SLCProperties[key] = def
	end

	return self.SLCProperties[key]
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
Player functions
---------------------------------------------------------------------------]]
function PLAYER:DataTables()
	if !IsValid( self ) then return end

	player_manager.SetPlayerClass( self, "class_slc" )
	player_manager.RunClass( self, "SetupDataTables" )
end

local function accessor( func, var )
	var = "Get"..( var or "_"..func )

	PLAYER[func] = function( self )
		if !self[var] then
			self:DataTables()
		end

		return self[var]( self )
	end
end

local function db_functions( func, db )
	local getter = "Get_"..func
	local setter = "Set_"..func

	PLAYER["Get"..func] = function( self )
		return self[getter]( self )
	end

	PLAYER["Set"..func] = function( self, val )
		self[setter]( self, val )
		self:SetSCPData( db, val )
	end
end

accessor( "IsActive", "_SCPActive" )
accessor( "IsPremium", "_SCPPremium" )
accessor( "IsAFK", "_SCPAFK" )
accessor( "SCPLevel" )
accessor( "SCPExp" )
accessor( "SCPClassPoints" )
accessor( "DailyBonus" )

db_functions( "SpectatorPoints", "spectator_points" )

function PLAYER:GetPrestigePoints()
	return self:Get_PrestigePoints()
end

function PLAYER:RequiredXP( lvl )
	if !lvl then
		lvl = self:SCPLevel()
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
	return SCPTeams.HasInfo( self:SCPTeam(), SCPTeams.INFO_HUMAN ) or SERVER and self:GetSCPHuman() --FIX: GetSCPHuman on other players
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