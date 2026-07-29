ROUNDS = {}

--[[-------------------------------------------------------------------------
Round Types

Types:
	ModifiersSet [table]
		@field		[table<string, number/true>]		
								force			Optional, exact value for modifier or true to force selection
		@field		[table]		whitelist		Optional, modifiers that are allowed during this round, shouldn't be used together with blacklist
		@field		[boolean]	blacklist		Optional, modifiers that are banned during this round, shouldn't be used together with whitelist

	RulesSet [table]
		@field		[table]		force			Optional, rules that are alaways active during this round
		@field		[table]		whitelist		Optional, rules that are allowed during this round, shouldn't be used together with blacklist
		@field		[table]		blacklist		Optional, rules that are banned during this round, shouldn't be used together with whitelist
---------------------------------------------------------------------------]]
local function lookup_all( tab )
	if tab.whitelist then tab.whitelist = CreateLookupTable( tab.whitelist ) end
	if tab.blacklist then tab.blacklist = CreateLookupTable( tab.blacklist ) end

	return tab
end

do
	RoundType = setmetatable( {}, {
		__call = function( class, base, ... )
			local obj = setmetatable( {}, {
				__index = function( _, k )
					if base then
						local value = base[k]
						if value != nil then return value end
					end
					return class[k]
				end,
			} )
			if obj.Initialize then obj:Initialize( ... ) end
			obj.base = base or class
			return obj
		end
	} )

	--[[---------------------------------------------------------------------------
	RoundType:Initialize( name, weight, condition, modifiers, rules )

	Creates and registers new round type

	@param		[string]				name				Name of the round type
	@param		[number]				weight				Select weight of the round type, use 0 for round that can't be selected automatically
	@param		[ModifiersSet]			modifiers			Optional, set of modifiers to use/allow/ban. If nil or provided table is empty, normal modifiers are applied
	@param		[RulesSet]				rules				Optional, set of rules to use/allow/ban. If nil or provided table is empty, normal rules are applied
	@param		[function]				condition			Optional, function to decide whenever this round type can be selected. Return true to allow.
															This can be used to for example make date specific round types or to check count of players

	@return		[nil]					-					-
	---------------------------------------------------------------------------]]--
	function RoundType:Initialize( name, weight, modifiers, rules, condition )
		assert( !modifiers or !modifiers.whitelist or !modifiers.blacklist, "If specified, set of modifiers cannot contain both whitelist and blacklist" )
		assert( !rules or !rules.whitelist or !rules.blacklist, "If specified, set of rules cannot contain both whitelist and blacklist" )

		ROUNDS[name] = self

		self.name = name
		self.weight = weight
		self.modifiers = lookup_all( modifiers or {} )
		self.rules = lookup_all( rules or {} )
		self.condition = condition
	end

	function RoundType:Activate()
		SelectRoundModifiers( self.modifiers.force, self.modifiers.blacklist or self.modifiers.whitelist, !!self.modifiers.blacklist )
		SelectRoundRules( self.rules.force, self.rules.blacklist or self.rules.whitelist, !!self.rules.blacklist )
	end

	function RoundType:RoundInit()
		self:Activate()
	end

	function RoundType:RoundStart()
		--
	end

	function RoundType:RoundPost( winners )
		SCPTeams.UpdateScoreData()
	end

	function RoundType:RoundCleanup()
		--
	end

	function RoundType:EndCheck()
		//print( "Endcheck" )
		local alive_players = GetAlivePlayers()

		for _, ply1 in ipairs( alive_players ) do
			for _, ply2 in ipairs( alive_players ) do
				if ply1 != ply2 and SCPTeams.PlayerRelation( ply1, ply2 ) == nil then
					//print( "Hostile found - exit", ply1, ply2 )
					return false
				end
			end
		end

		return true
	end

	function RoundType:GetWinners()
		if #GetActivePlayers() < CVAR.slc_min_players:GetInt() then return true end

		local scores = SCPTeams.TeamsZScore()
		print( "Getting winners" )
		PrintTable( scores )
		local winners = {}

		for i = 1, 3 do
			local score = scores[i]
			if !score or score.score <= 0 then print( "no more", i ) break end

			winners[i] = { score.group, score.score }
		end

		if !next( winners ) then print("rt no winners") return false end

		print( "RET" )
		PrintTable( winners )
		return winners
	end
end

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
local round_force

function SelectRoundType()
	local tmp = round_force
	round_force = nil

	if tmp and ROUNDS[tmp] then
		return ROUNDS[tmp]
	end

	local candidates = {}
	local total_weight = 0

	for k, v in pairs( ROUNDS ) do
		if v.weight <= 0 or v.condition and !v.condition() then continue end

		table.insert( candidates, v )
		total_weight = total_weight + v.weight
	end

	local rng = SLCRandom( total_weight )

	for i, v in ipairs( candidates ) do
		rng = rng - v.weight
		if rng <= 0 then return v end
	end
end

function ForceRoundType( id )
	round_force = id
end

--[[-------------------------------------------------------------------------
Default round
---------------------------------------------------------------------------]]
local default = RoundType( nil, "default", 100 )

function default:RoundInit( multi )
	default.base.RoundInit( self )

	SetupPlayers( multi )
	hook.Run( "SpawnItems" )

	DestroyAll()
	UseAll()
end

function default:RoundStart()
	AddTimer( "EscapeTimer", 2, 0, CheckEscape )
	SetupSupportTimer()
	OpenSCPs()
end

function default:RoundPost( winners )
	default.base.RoundPost( self, winners )
	PrintSCPNotice()
end

--[[-------------------------------------------------------------------------
Default round
---------------------------------------------------------------------------]]
local multi = RoundType( ROUNDS.default, "multi", 10 )

function multi:RoundInit()
	multi.base.RoundInit( self, true )
end