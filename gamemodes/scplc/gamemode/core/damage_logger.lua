--[[-------------------------------------------------------------------------
Damage Logger

Types:
	DeathDetails [table]
		@field		[Entity]						killer				Entity that killed player
		@field		[string]						killer_name			Name of the killer
		@field		[Entity]						inflictor			Inflictor of fatal damage
		@field		[table<number, TakenData>]		taken_by_player		Sequential table containing summed damage events per player
		@field		[table<Player, AssistsData>]	assist_events		Player to AssistsData map that contains summed assist events per player
		@field		[table<number, KillsData>]		kills				Sequential table containing all kills made by player

	TakenData [table]
		@field		[Player]			ply					Player who dealt damage
		@field		[string]			ply_id				SteamID64 of player who dealt damage
		@field		[number]			ally				Total sum of damage done as ally (RDM damage)
		@field		[number]			neutral				Total sum of damage done as neutral team
		@field		[number]			enemy				Total sum of damage done as enemy team

	AssistsData [table]
		@field		[number]			power				Assist power
		@field		[number]			timeout				CurTime based timeout of support event
		@field		[nil/true/false]	relation			Relation between assisting player and logger player (nil - enemy, false - neutral, true - ally)
		@field		[number]			timestamp			CurTime when this event was added
	
	KillsData [table]
		@field		[Player]			target				Killed player
		@field		[string]			target_id			Killed player SteamID64
		@field		[nil/true/false]	relation			Relation between logger player and killed player (nil - enemy, false - neutral, true - ally)
		@field		[number]			timestamp			CurTime when this event was added

	RewardData [table]
		@field		[number]			reward				Reward
		@field		[number]			dmg					Dealt damage
		@field		[number]			pct					Dealt damage divided by total damage
---------------------------------------------------------------------------]]
do
	local MAX_DEALT_HISTORY = 10
	local HEALING_EVENTS_TIMEOUT = 60
	local SUPPORT_THRESHOLD = 200

	DamageLogger = {}

	--[[---------------------------------------------------------------------------
	DamageLogger:Initialize( ply )

	Initializes DamageLogger object with empty data

	@param		[Player]		ply					Player that will be assigned to this logger
													Logger will be automatically added to ply.Logger field

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:Initialize( ply )
		if type( ply ) != "Player" then argerror( 1, "Initialize", "Player", type( ply ) ) end

		self:Reset()

		self.Player = ply
		ply.Logger = self
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:DamageTaken( info, dmg_original )

	Adds damage taken event to logger. If attacker is valid player, automatically calls DamageDealt on their logger

	REVIEW: Do we really need full history of taken damage?

	@param		[CTakeDamageInfo]	info				Damage info
	@param		[number]			dmg_original		Original damage before claculations

	@return		[nil]				-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:DamageTaken( info, dmg_original )
		if type( info ) != "CTakeDamageInfo" then argerror( 1, "DamageTaken", "CTakeDamageInfo", type( info ) ) end
		if type( dmg_original ) != "number" then argerror( 2, "DamageTaken", "number", type( dmg_original ) ) end

		print( "DMG TAKEN" )

		local dmg_final = info:GetDamage()
		if dmg_final <= 0 then return end

		local attacker = info:GetAttacker()

		local attacker_valid = IsValid( attacker )
		local attacker_is_player = attacker_valid and attacker:IsPlayer()

		local relation = nil

		if attacker_is_player then
			relation = SCPTeams.PlayerDamageRelation( attacker, self.Player )
		end

		if !relation or attacker == self.Player then
			self.healable_pool = self.healable_pool + dmg_final
		end

		table.insert( self.damage_taken_events, {
			damage_original = dmg_original,
			damage_final = dmg_final,
			damage_type = info:GetDamageType(),

			attacker = attacker,
			attacker_id = attacker_is_player and attacker:SteamID64() or nil,
			attacker_name = attacker_valid and attacker:GetName() or nil,
			inflictor = info:GetInflictor(),
			current_hp = self.Player:Health(),

			relation = relation,

			timestamp = CurTime(),
		} )

		if attacker_valid then
			attacker.Logger:DamageDealt( self.Player, dmg_final, dmg_original )
		end
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:DamageDealt( target, dmg_final, dmg_original )

	Adds damage dealt event to logger. Keeps last [MAX_DEALT_HISTORY] entries
	It's used internally, you shouldn't call this directly unless you know what you are doing

	@param		[Player]		target				Damaged player
	@param		[number]		dmg_final			Final damage
	@param		[number]		dmg_original		Original damage

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:DamageDealt( target, dmg_final, dmg_original )
		if type( target ) != "Player" then argerror( 1, "DamageDealt", "Player", type( target ) ) end
		if type( dmg_final ) != "number" then argerror( 2, "DamageDealt", "number", type( dmg_final ) ) end
		if type( dmg_original ) != "number" then argerror( 3, "DamageDealt", "number", type( dmg_original ) ) end

		if dmg_final <= 0 then return end

		table.insert( self.damage_dealt_events, {
			damage_original = dmg_original,
			damage_final = dmg_final,

			target_name = target:Nick(),
			target_hp = target:Health(),

			relation = SCPTeams.PlayerDamageRelation( self.Player, target ),

			timestamp = CurTime(),
		} )

		while #self.damage_dealt_events > MAX_DEALT_HISTORY do
			table.remove( self.damage_dealt_events, 1 )
		end
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:AssitstEvent( ply, power, timeout, id, override )

	Adds assist event to logger
	Assist events are used to store non-damage events that should grant assist reward

	@param		[Player]		ply					Player who assisted
	@param		[number]		power				Assit power, 1 power is equal to 1 DMG in calculation
	@param		[number]		timeout				Optional, timeout for this event, 0/nil for no timeout

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:AssitstEvent( ply, power, timeout )
		if type( ply ) != "Player" then argerror( 1, "AssitstEvent", "Player", type( ply ) ) end
		if type( power ) != "number" then argerror( 2, "AssitstEvent", "number", type( power ) ) end
		if timeout and type( timeout ) != "number" then argerror( 3, "AssitstEvent", "nil or number", type( timeout ) ) end

		local tab = self.assist_events[ply]
		if !tab then
			tab = {}
			self.assist_events[ply] = tab
		end

		table.insert( tab, {
			power = power,
			timeout = timeout and CurTime() + timeout or 0,
			relation = SCPTeams.PlayerDamageRelation( ply, self.Player ),

			timestamp = CurTime(),
		} )
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:SupportEvent( ply, power, timeout )

	Adds support event to logger
	Support events are used to grant assist when suppoerted player kills someone

	Support events can grant up to 50% of player's reward
	Actual % is calculated in the following way: % = power / max(sum of all support events, SUPPORT_THRESHOLD) * 0.5

	@param		[Player]		ply					Player who supported
	@param		[number]		power				Support power, see above for calculation details
	@param		[number]		timeout				Optional, timeout for this event, 0 for no timeout, 0 by default

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:SupportEvent( ply, power, timeout )
		if type( ply ) != "Player" then argerror( 1, "SupportEvent", "Player", type( ply ) ) end
		if type( power ) != "number" then argerror( 2, "SupportEvent", "number", type( power ) ) end
		if timeout and type( timeout ) != "number" then argerror( 3, "SupportEvent", "nil or number", type( timeout ) ) end

		local tab = self.support_events[ply]
		if !tab then
			tab = {}
			self.support_events[ply] = tab
		end

		table.insert( tab, {
			power = power,
			timeout = timeout and CurTime() + timeout or 0,
			relation = SCPTeams.PlayerDamageRelation( ply, self.Player ),

			timestamp = CurTime(),
		} )
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:HealingEvent( ply, power, timeout )

	Adds healing event to logger
	Healing events check healable pool of HP and return actual heal value

	@param		[Player]		ply					Player who healed
	@param		[number]		heal				Healed HP
	@param		[number]		missing_hp			Optional, HP missing prior to healing, can be skipped ONLY if event is added BEFORE adding HP

	@return		[number]		-					True non-RDM healed damage
	---------------------------------------------------------------------------]]--
	function DamageLogger:HealingEvent( ply, heal, missing_hp )
		if type( ply ) != "Player" then argerror( 1, "HealingEvent", "Player", type( ply ) ) end
		if type( heal ) != "number" then argerror( 2, "HealingEvent", "number", type( heal ) ) end
		if missing_hp and type( missing_hp ) != "number" then argerror( 3, "HealingEvent", "nil or number", type( missing_hp ) ) end

		print( "Heal event", heal, self.healable_pool, missing_hp )

		if !missing_hp then
			missing_hp = self.Player:GetMaxHealth() - self.Player:Health()
		end

		if missing_hp < 0 then
			missing_hp = 0
		end

		if self.healable_pool > missing_hp then
			self.healable_pool = missing_hp
		end

		if heal > self.healable_pool then
			heal = self.healable_pool
		end

		print( "Heal final", heal )

		if heal <= 0 then
			return 0
		end

		self.healable_pool = self.healable_pool - heal

		self:SupportEvent( ply, heal, HEALING_EVENTS_TIMEOUT )

		return heal
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:AddKill( target, info )

	Adds kill to logger
	It's used internally, you shouldn't call this directly unless you know what you are doing

	@param		[Player]			target				Killed player

	@return		[nil]				-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:AddKill( target )
		if type( target ) != "Player" then argerror( 1, "AddKill", "Player", type( target ) ) end

		table.insert( self.kills, {
			target = target,
			target_id = target:SteamID64(),
			relation = SCPTeams.PlayerDamageRelation( self.Player, target ),

			timestamp = os.time()
		} )
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:Finish( killer, info )

	Finalizes logger - saves data to self.DeathDetails, clears logger and sends logs to player

	@param		[Entity]			killer				Entity responsible for kill
	@param		[CTakeDamageInfo]	info				Damage info

	@return		[DeathDetails]		-					Death details
	---------------------------------------------------------------------------]]--
	function DamageLogger:Finish( killer, info )
		if TypeID( killer ) != TYPE_ENTITY then argerror( 1, "Finish", "Entity", type( killer ) ) end
		if type( info ) != "CTakeDamageInfo" then argerror( 2, "Finish", "CTakeDamageInfo", type( info ) ) end

		local taken_by_player = self:CollectTakenByPlayer()

		self.death_details = {
			killer = killer,
			killer_name = killer:GetName(),
			inflictor = info:GetInflictor(),

			//damage_taken = self.damage_taken_events,
			taken_by_player = taken_by_player,
			assist_events = self.assist_events,
			kills = self.kills,
		}

		local send_dealt = {}
		local send_taken = {}
		local send_by_player = {}

		for i, v in ipairs( self.damage_dealt_events ) do
			send_dealt[i] = {
				ply = v.target_name,
				dmg = v.damage_final,
				rdm = v.relation == true,
			}
		end

		local taken_len = #self.damage_taken_events
		for i = math.max( taken_len - 10, 1 ), taken_len do
			local event = self.damage_taken_events[i]
			send_taken[i] = {
				ply = event.attacker_name,
				dmg = event.damage_final,
				orig = event.damage_original,
				hp = event.current_hp,
				rdm = event.relation == true,
			}
		end

		local by_player_len = #taken_by_player
		for i = math.max( by_player_len - 10, 1 ), by_player_len do
			local data = taken_by_player[i]
			table.insert( send_by_player, {
				ply = IsValid( data.ply ) and data.ply:Nick() or data.ply_id,
				total = data.total,
				rdm = data.ally
			} )
		end

		net.SendTable( "DeathInfo", { dealt = send_dealt, taken = send_taken, by_player = send_by_player } )

		self:Reset()

		if IsValid( killer ) and killer:IsPlayer() then
			killer.Logger:AddKill( self.Player )
		end

		return self.death_details
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:GetRewards( reward_pool )

	Gets rewards for all assisting and supporting players

	@param		[number]					reward_pool			Reward pool to distribute

	@return		[table<Player, RewardData>]	-					Kill and assist rewards
	@return		[table<Player, number>]		-					Support rewards
	---------------------------------------------------------------------------]]--
	local function remainder_sort( a, b )
		return a.remainder > b.remainder
	end

	function DamageLogger:GetRewards( reward_pool )
		if !isnumber( reward_pool ) then argerror( 1, "GetRewards", "number", type( reward_pool ) ) end

		local details = self:GetDeathDetails()
		if !details then return end

		local damage_taken = details.taken_by_player
		if #damage_taken == 0 then return end

		local killer = details.killer
		local assist_by_player = DamageLogger.CollectEvents( details.assist_events )

		if killer == self.Player or !IsValid( killer ) or !killer:IsPlayer() then
			killer = nil
		end

		// 1. Count total damage
		local total = 0
		local kill_data = {}

		for i, v in ipairs( damage_taken ) do
			if !IsValid( v.ply ) then continue end

			if !killer then
				killer = v.ply
			end

			local ply_total = v.total
			local assist_ally = 0
			local assist_enemy = 0

			local assist = assist_by_player[v.ply]
			if assist then
				ply_total = ply_total + assist.total
				assist_ally = assist.ally
				assist_enemy = assist.enemy
			end

			total = total + ply_total

			kill_data[i] = {
				ply = v.ply,
				total = ply_total,
				rdm_pct = ( v.ally + assist_ally ) / ply_total,
				enemy_pct = ( v.enemy + assist_enemy ) / ply_total,
			}
		end

		print( "PHASE 1 - prepare data", total )
		PrintTable( kill_data )

		// 2. Calculate rewards
		local point_for_killer = SCPTeams.PlayerDamageRelation( killer, self.Player ) == nil
		if point_for_killer then
			reward_pool = reward_pool - 1
		end

		local remaining_pool = reward_pool
		local rewards = {}
		local remainders = {}

		for i, v in ipairs( kill_data ) do
			local dmg_pct = v.total / total
			local raw_reward = dmg_pct * reward_pool
			local int_reward = math.floor( raw_reward )
			local ply_reward = math.Round( int_reward * ( v.enemy_pct - 2 * v.rdm_pct ) ) //REVIEW: truncate?

			rewards[v.ply] = { reward = ply_reward, dmg = v.total, pct = dmg_pct }
			remainders[i] = { ply = v.ply, remainder = raw_reward - int_reward }

			remaining_pool = remaining_pool - int_reward
		end

		if point_for_killer then
			if !rewards[killer] then
				rewards[killer] = { reward = 0, dmg = 0, pct = 0 }
			end

			rewards[killer].reward = rewards[killer].reward + 1
		end

		print( "PHASE 2 - rewards first pass", remaining_pool )
		PrintTable( rewards )
		PrintTable( remainders )

		// 3. Distribute remaining pool
		table.sort( remainders, remainder_sort )

		for i, v in ipairs( remainders ) do
			if remaining_pool <= 0 then break end

			rewards[v.ply].reward = rewards[v.ply].reward + 1
			remaining_pool = remaining_pool - 1
		end

		print( "PHASE 3 - rewards seconds pass", remaining_pool )
		PrintTable( rewards )

		if remaining_pool != 0 then
			ErrorNoHalt( "This should never happen - Remaining pool of rewards was not zero, remaining: ", remaining_pool, "\n" )
		end

		// 4. Handle support events
		local support_rewards = {}

		for ply, reward in pairs( rewards ) do
			if reward.reward <= 0 then continue end

			local support_by_player, total_power = DamageLogger.CollectEvents( ply.Logger.support_events )
			PrintTable( support_by_player )

			if total_power < SUPPORT_THRESHOLD then
				total_power = SUPPORT_THRESHOLD
			end

			for supporting_ply, power_data in pairs( support_by_player ) do
				local support_reward = math.floor( reward.reward * 0.5 * ( power_data.ally + power_data.neutral ) / total_power )

				if rewards[supporting_ply] then
					rewards[supporting_ply].reward = rewards[supporting_ply].reward + support_reward
				else
					support_rewards[supporting_ply] = ( support_rewards[supporting_ply] or 0 ) + support_reward
				end
			end
		end

		print( "PHASE 4 - support rewards", killer )
		PrintTable( rewards )
		PrintTable( support_rewards )

		return rewards, support_rewards, killer
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:GetDeathDetails()

	Returns death details

	@return		[DeathDetails]	-					Death details
	---------------------------------------------------------------------------]]--
	function DamageLogger:GetDeathDetails()
		return self.death_details
	end

	--[[---------------------------------------------------------------------------
	DamageLogger:Reset( round_reset )

	Resets logger to empty values

	@param		[boolean]		round_reset			If true, also clears last death data

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function DamageLogger:Reset( round_reset )
		self.healable_pool = 0

		self.kills = {}

		self.damage_taken_events = {}
		self.damage_dealt_events = {}

		self.assist_events = {}
		self.support_events = {}

		if round_reset then
			self.death_details = nil
		end
	end

	-- Internal - don't call
	local function damage_sort( a, b )
		return a.total > b.total
	end

	-- Internal - don't call
	function DamageLogger:CollectTakenByPlayer()
		local by_player = {}
		local id_map = {}

		for i, v in ipairs( self.damage_taken_events ) do
			local attacker_id = v.attacker_id
			if !attacker_id then continue end

			local attacker = v.attacker
			if v.attacker == self.Player then continue end

			if IsValid( attacker ) then
				id_map[attacker_id] = attacker
			end

			local tab = by_player[attacker_id]
			if !tab then
				tab = { total = 0, enemy = 0, ally = 0, neutral = 0 }
				by_player[attacker_id] = tab
			end

			local damage = v.damage_final

			tab.total = tab.total + damage

			if v.relation == true then
				tab.ally = tab.ally + damage
			elseif v.relation == false then
				tab.neutral = tab.neutral + damage
			else
				tab.enemy = tab.enemy + damage
			end
		end

		print( "Collected" )
		PrintTable( by_player )

		local all = {}

		for k, v in pairs( by_player ) do
			v.ply_id = k

			if id_map[k] then
				v.ply = id_map[k]
			end

			table.insert( all, v )
		end

		table.sort( all, damage_sort )

		print( "Sequential" )
		PrintTable( all )

		return all
	end

	-- Internal - don't call
	function DamageLogger.CollectEvents( source )
		local ct = CurTime()

		local power_by_player = {}
		local total_power = 0

		for ply, events in pairs( source ) do
			if !IsValid( ply ) then continue end

			local ply_power_total = 0
			local ply_power_ally = 0
			local ply_power_enemy = 0
			local ply_power_neutral = 0

			for i, v in ipairs( events ) do
				if v.timeout > 0 and v.timeout < ct then continue end

				ply_power_total = ply_power_total + v.power

				if v.relation == true then
					ply_power_ally = ply_power_ally + v.power
				elseif v.relation == false then
					ply_power_neutral = ply_power_neutral + v.power
				else
					ply_power_enemy = ply_power_enemy + v.power
				end
			end

			if ply_power_total > 0 then
				power_by_player[ply] = { ally = ply_power_ally, neutral = ply_power_neutral, enemy = ply_power_enemy, total = ply_power_total }
				total_power = total_power + ply_power_total
			end
		end

		return power_by_player, total_power
	end

	function DamageLogger.Print( data )
		//TODO
	end

	setmetatable( DamageLogger, { __call = function( class, ... )
		local logger = setmetatable( {}, { __index = class } )
		logger:Initialize( ... )
		return logger
	end } )
end

--[[-------------------------------------------------------------------------
Receive Table
---------------------------------------------------------------------------]]
hook.Add( "SLCCoreLoaded", "SLCDamageLogger", function()
	net.AddTableChannel( "DeathInfo" )

	if CLIENT then
		net.ReceiveTable( "DeathInfo", function( data )
			DamageLogger.Print( data )
		end )
	end
end )

for i, v in ipairs( player.GetAll() ) do
	DamageLogger( v )
end

/*
lua_run Entity(1).Logger:DamageTaken(  )
*/