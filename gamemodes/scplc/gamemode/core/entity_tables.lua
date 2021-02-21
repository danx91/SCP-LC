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
	end
end

local ent = FindMetaTable( "Entity" )
function ent:InstallTable( name )
	InstallTable( name, self )
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