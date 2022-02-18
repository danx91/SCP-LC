SLC_ENTITY_TABLES = {}

--[[-------------------------------------------------------------------------
InstallTable

{
	Setup = function( target ) end, --called right before table is installed, return true to supress
	Finish = function( target ) end, --called right after table is installed
	Table = <table> --actual table to install
}
---------------------------------------------------------------------------]]
function RegisterEntityTable( name, table )
	SLC_ENTITY_TABLES[name] = table
end

function InstallTable( name, target )
	local tab = SLC_ENTITY_TABLES[name]

	if !isentity( target ) and !istable( target ) then
		print( "Entity or table expected in InstallTable!" )
		return
	end

	if tab then
		if tab.Setup then
			tab.Setup( target )
		end

		table.Merge( target, tab.Table )

		if tab.Finish then
			tab.Finish( target )
		end

		target.InstalledTables = target.InstalledTables or {}
		target.InstalledTables[name] = true
	end
end

function InstanceOf( name, tab )
	if tab.InstalledTables and tab.InstalledTables[name] then
		return true
	end

	return false
end

local ent = FindMetaTable( "Entity" )

function ent:InstallTable( name )
	InstallTable( name, self )
end

function ent:InstanceOf( name )
	return InstanceOf( name, self )
end
--[[-------------------------------------------------------------------------
Base EntityTables
---------------------------------------------------------------------------]]
RegisterEntityTable( "ActionQueue", {
	Table = {
		ActionFinish = 0,
		ActionQueueSetup = function( self, np )
			if np then
				self:AddNetworkVar( "_State", "Int" )

				self.State = 0

				self.SetState = function( this, state )
					this.State = state
					self:Set_State( state )
				end

				self.GetState = function( this )
					if SERVER or ( this:IsWeapon() and this:IsCarriedByLocalPlayer() ) then
						return this.State
					else
						return this:Get_State()
					end
				end
			else
				self:AddNetworkVar( "State", "Int" )
			end
		end,
		ActionQueueInit = function( self )
			self.ActionQueue = {}
		end,
		ActionQueueThink = function( self )
			local ct = CurTime()
			if self.ActionFinish != 0 and self.ActionFinish < ct then
				if #self.ActionQueue > 0 then
					local new = table.remove( self.ActionQueue, 1 )

					self:SetState( new.state or 0 )
					self.ActionFinish = ct + ( new.duration or 0 )

					if new.cb then
						new.cb( self.ActionFinish, new.duration )
					end
				else
					self:SetState( 0 )
					self.ActionFinish = 0
				end
			elseif self.ActionFinish == 0 and self:GetState() != 0 then
				self:SetState( 0 )
			end
		end,
		QueueAction = function( self, state, duration, cb )
			table.insert( self.ActionQueue, { state = state, duration = duration, cb = cb } )

			if self.ActionFinish == 0 then
				self.ActionFinish = 1
			end
		end,
		ResetAction = function( self, state, duration )
			self.ActionQueue = {}

			self:SetState( state )
			self.ActionFinish = CurTime() + duration
		end,
	}
} )

RegisterEntityTable( "Lootable", {
	Setup = function( target )
		target.PlayersCache = {}
		target.Listeners = {}
		target.LootItems = {}
		target.LootX = 0
		target.LootY = 0
	end,
	Table = {
		OpenInventory = function( self, ply )
			if self.LootX < 1 or self.LootY < 1 then return end

			if ply:IsPlayer() and !self.Listeners[ply] and self:CanLoot( ply ) then
				if IsValid( ply.ActiveLootable ) then
					ply.ActiveLootable.Listeners[ply] = nil
				end
		
				self.Listeners[ply] = true
				ply.ActiveLootable = self
		
				local tab = {
					w = self.LootX,
					h = self.LootY,
					loot = {}
				}
		
				local cache = self.PlayersCache[ply]
				if !cache then
					cache = {}
					self.PlayersCache[ply] = cache
				end
		
				for i, v in pairs( self.LootItems ) do
					tab.loot[i] = cache[i] and v.info or true
				end
		
				net.Start( "SLCLooting" )
					net.WriteUInt( 1, 2 )
					net.WriteTable( tab )
				net.Send( ply )
			end
		end,
		CheckListeners = function( self )
			local to_update = {}
			for k, v in pairs( self.Listeners ) do
				if !self:CanLoot( k ) then
					self.Listeners[k] = nil
	
					if IsValid( k ) then
						table.insert( to_update, k )
					end
				end
			end
	
			if #to_update > 0 then
				net.Start( "SLCLooting" )
					net.WriteUInt( 0, 2 )
				net.Send( to_update )
			end
		end,
		CanLoot = function( self, ply )
			return IsValid( ply ) and SCPTeams.HasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) and self:GetPos():DistToSqr( ply:GetPos() ) <= 6400
		end,
		DropAllListeners = function( self )
			local listeners = {}
			for k, v in pairs( self.Listeners ) do
				self.Listeners[k] = nil

				if IsValid( k ) then
					table.insert( listeners, k )
				end
			end

			if #listeners > 0 then
				net.Start( "SLCLooting" )
					net.WriteUInt( 0, 2 )
				net.Send( listeners )
			end
		end,
		SetLootData = function( self, w, h, items )
			self.LootX = w
			self.LootY = h
			self.LootItems = items
			self.PlayersCache = {}

			self:DropAllListeners()
		end,
		CopyLootData = function( self, from, dnc )
			if InstanceOf( "Lootable", from ) then
				self.LootX = from.LootX
				self.LootY = from.LootY
				self.LootItems = dnc and from.LootItems or table.Copy( from.LootItems )
				self.PlayersCache = dnc and from.PlayersCache or table.Copy( from.PlayersCache )
			end
		end,
		GenerateLoot = function( self, w, h, pool )
			self.LootX = w
			self.LootY = h
			self.LootItems = GenerateLootTable( pool, w * h )
			self.PlayersCache = {}

			self:DropAllListeners()
			//PrintTable( self.LootItems )
		end,
	}
} )