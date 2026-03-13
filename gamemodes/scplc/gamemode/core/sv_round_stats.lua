--[[-------------------------------------------------------------------------
Round Stats
---------------------------------------------------------------------------]]
ROUND_STATS = ROUND_STATS or {}
ROUND_STAT_GROUPS = ROUND_STAT_GROUPS or {}

ROUND_STAT_MODE_ONCE = 0
ROUND_STAT_MODE_MULTIPLE = 1
ROUND_STAT_MODE_CONTINUOUS = 2
ROUND_STAT_MODE_ALWAYS = 3

ROUND_STAT_OP_SUM = 0
ROUND_STAT_OP_MAX = 1
ROUND_STAT_OP_MIN = 2

ROUND_STAT_COLLECT_ALL = 1
ROUND_STAT_COLLECT_POS = 2
ROUND_STAT_COLLECT_NEG = 3
ROUND_STAT_COLLECT_ABS = 4

--[[-------------------------------------------------------------------------
RoundStatBase

Types:
	CallbackData [table]
		@field		[CallbackFunction]		callback			Actual callback function
		@field		[number/boolean]		threshold			Optional, Threshold value
		@field		[CallbackModeEnum]		mode				Optional, Mode of callback
		@field		[boolean]				round_reset			If true, this callback will be removed on round reset
		@field		[boolean]				fired				For internal use, don't pass

	CallbackFunction [function]
		@param		[string]				name				Name of the stat/group
		@param		[number/boolean]		value				Current value of stat/group - for groups it's always numerical (bools are converted to 0/1)
		@param		[number/boolean]		diff				Value past threshold (nil if no threshold, always positive past threshold and negative before threshold,
																equal to value for bools). For groups it's always numerical (bools are converted to 0/1)
		@param		[any/GroupContext]		context				Context passed by function that changed the state, for groups it's always table
		@param		[any]					data				Name of the stat/group

	GroupContext [table]
		@field		[any]					original_context	Original context of stat that triggered callback
		@field		[any]					stat_data			Original data of stat that triggered callback
		@field		[number/boolean]		stat_old			Old value of stat that triggered callback
		@field		[number/boolean]		stat_new			New value of stat that triggered callback
		@field		[number/boolean]		stat_diff			Value past threshold (negative if before threshold, equal to value for bools) of stat that triggered callback
		@field		[string]				cause				Name of stat that triggered callback

Enums:
	CallbackModeEnum* [number]
		@value		[0]		ROUND_STAT_MODE_ONCE			Callback is fired exactly once when threshold is crossed
		@value		[1]		ROUND_STAT_MODE_MULTIPLE		Callback is fired every time threshold is crossed
		@value		[2]		ROUND_STAT_MODE_CONTINUOUS		Callback is fired every time value changes if threshold is satisfied
		@value		[3]		ROUND_STAT_MODE_ALWAYS			Callback is fired every time value changes

	* - All modes except ROUND_STAT_MODE_ALWAYS do nothing if threshold is nil or equal to initial value
---------------------------------------------------------------------------]]
do
	RoundStatBase = {}
	RoundStatBase.__index = RoundStatBase
	RoundStatBase = setmetatable( RoundStatBase, {
		__call = function( class, ... )
			local obj = setmetatable( {}, class )
			if obj.Initialize then obj:Initialize( ... ) end
			return obj
		end
	} )

	--[[---------------------------------------------------------------------------
	RoundStatBase:Initialize( name )

	Initializes RoundStatBase object with default values and given name

	@param		[string]		name				Name of stat

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:Initialize( name )
		if !isstring( name ) then argerror( 1, "Initialize", "string", type( name ) ) end

		self.kind = "BASE"

		self.name = name

		self.initial = 0
		self.type = "number"

		self.show = false

		self.weight_add = 0
		self.weight_mul = 1

		self.exclude = {}
		self.callbacks = {}
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:InitialValue( value )

	Sets the initial value of the stat/group
	For groups don't call it directly - it's automatically called after adding stat(s)

	@param		[number/boolean]	value				Initial value

	@return		[self]				self					-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:InitialValue( value )
		local t = type( value )

		if t != "number" and t != "boolean" then argerror( 1, "InitialValue", "number or boolean", t ) end

		self.initial = value
		self.type = t

		local tmp = self.callbacks
		self.callbacks = {}

		for k, v in pairs( tmp ) do
			self:AddCallback( k, v )
		end

		return self
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:Show( show, weight_add, weight_mul )

	Setups visibility of stat/group with optional weight calculation params
	Weight is calculted with following formula: value * weight_mul + weight_add

	@param		[boolean]		show				Whether to show in round summary
	@param		[number]		weight_add			Optional, this value will be added to weight
	@param		[type]			weight_mul			Optional, weight will be multiplied by this value

	@return		[self]			self				-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:Show( show, weight_add, weight_mul )
		if !isbool( show ) then argerror( 1, "Show", "boolean", type( show ) ) end
		if weight_add and !isnumber( weight_add ) then argerror( 2, "Show", "nil or number", type( weight_add ) ) end
		if weight_mul and !isnumber( weight_mul ) then argerror( 3, "Show", "nil or number", type( weight_mul ) ) end

		if !_LANG_DEFAULT.ROUND_STATS[self.name] then
			SLCErrorMessage( "RoundStat '%s' is missing it's language entry", self.name )
		end

		self.show = show
		self.weight_add = weight_add or self.weight_add
		self.weight_mul = weight_mul or self.weight_mul

		return self
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:ShowByRef( ref, bias )

	Helper function to calculate weight_add and weight_mul using reference value and bias
	This function assumes 100 as goal for all stats, so when stat is equal to ref + bias, weight will be equal to 100

	@param		[type]			ref					Reference value
	@param		[type]			bias				Bias value

	@return		[self]			self				-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:ShowByRef( ref, bias )
		if !isnumber( ref ) then argerror( 1, "Show", "nil or number", type( ref ) ) end
		if bias and !isnumber( bias ) then argerror( 2, "Show", "nil or number", type( bias ) ) end

		assert( ref != 0, "ref cannot be 0" )

		local mul = 100 / ref
		local add = 0

		if bias then
			add = -mul * bias
		end

		return self:Show( true, add, mul )
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:Exclude( exclude )

	Sets up stats/groups that will be excluded from summary if this stat is present in summary

	@param		[string/table]	exclude				Stat or table of stats to exclude

	@return		[self]			self				-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:Exclude( exclude )
		for i, v in ipairs( istable( exclude ) and exclude or { exclude } ) do
			self.exclude[v] = true
		end

		return self
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:AddCallback( key, data )

	Adds callback to stat/group or replaces it. Stat objects are persistent across rounds - once added, callbacks will not be removed on round reset.
	For example using Player as key, will keep the callback until player disconnects, for round reset either use other entities (like weapon) or set proper flag

	@param		[string/Entity]	key					Identifier of callback, if it's already in use, it will be replaced
													If it's Entity, it will be automatically removed when it becomes not valid
	@param		[CallbackData]	data				Data of the callback

	@return		[self]			self				-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:AddCallback( key, data )
		local t = type( key )

		if t != "string" and TypeID( key ) != TYPE_ENTITY then argerror( 1, "AddCallback", "string or Entity", type( key ) ) end
		if !istable( data ) then argerror( 2, "AddCallback", "table", type( data ) ) end

		if !isfunction( data.callback ) then fielderror( "callback", 2, "AddCallback", "function", type( data.callback ) ) end
		if data.threshold and type( data.threshold ) != self.type then fielderror( "threshold", 2, "AddCallback", self.type, type( data.threshold ) ) end
		if data.mode and !isnumber( data.mode ) then fielderror( "mode", 2, "AddCallback", "number", type( data.mode ) ) end

		local tab = {
			callback = data.callback,
			threshold = data.threshold,
			mode = data.mode or ROUND_STAT_MODE_ONCE,
			round_reset = !!data.round_reset,
			fired = data.fired or false,
		}

		if self.type == "number" and data.threshold then
			tab.direction = math.Sign( data.threshold - self.initial )
		end

		self.callbacks[key] = tab

		return self
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:RemoveCallback( key )

	Removes callback 

	@param		[type]			key					-

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:RemoveCallback( key )
		self.callbacks[key] = nil
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:SetData( data )

	Sets data that will be passed to callbacks

	@param		[any]			data				Any value, it will be passed to callbacks	

	@return		[self]			self				-
	---------------------------------------------------------------------------]]--
	function RoundStatBase:SetData( data )
		self.data = data
		return self
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:GetValue()

	Gets the current value of stat/group

	@return		[number/boolean]	value				Value of stat/group, this is always numerical for groups
	---------------------------------------------------------------------------]]--
	function RoundStatBase:GetValue()
		error( "GetValue() must be implemented in subclass", 2 )
	end

	--[[---------------------------------------------------------------------------
	RoundStatBase:GetWeight()

	Gets weight of stat/group

	@return		[number]		weight				Weight of stat/group
	---------------------------------------------------------------------------]]--
	function RoundStatBase:GetWeight()
		local value = self:GetValue()

		if self.type == "boolean" then
			value = value and 1 or 0
		end

		return value * self.weight_mul + self.weight_add
	end

	-- Internal - don't call
	function RoundStatBase:OnValueChanged( old, new, context )
		local bool = self.type == "boolean"

		for k, v in pairs( self.callbacks ) do
			if !isstring( k ) and !IsValid( k ) then
				self.callbacks[k] = nil
				continue
			end

			if v.mode == ROUND_STAT_MODE_ALWAYS then
				self:ExecuteCallback( v, new, context )
				continue
			end

			local threshold = v.threshold
			if threshold == nil then continue end

			local wasBefore, isBefore

			if bool then
				wasBefore = old != threshold
				isBefore = new != threshold
			else
				local d = v.direction
				if d == 0 then continue end

				local t = threshold * d
				wasBefore = old * d < t
				isBefore = new * d < t
			end

			if !isBefore and ( wasBefore or v.mode == ROUND_STAT_MODE_CONTINUOUS ) and ( !v.fired or v.mode != ROUND_STAT_MODE_ONCE ) then
				self:ExecuteCallback( v, new, context )
			end
		end
	end

	-- Internal - don't call
	function RoundStatBase:ExecuteCallback( tab, value, context )
		local diff

		if self.type == "boolean" then
			diff = value
		elseif tab.threshold then
			diff = ( value - tab.threshold ) * tab.direction
		end

		tab.fired = true
		tab.callback( self.name, value, diff, context, self.data )
	end

	-- Internal - don't call
	function RoundStatBase:DebugInfo( indent )
		local i = string.rep( "\t", indent or 0 )
		print( i..string.format(
			"Name: %s, Kind: %s, Type: %s, Initial: %s, Show: %s (add: %.4f, mul: %.4f), Value: %s, Weight: %.4f",
			self.name, self.kind, self.type, self.initial, self.show, self.weight_add, self.weight_mul, self:GetValue(), self:GetWeight()
		) )

		print( i.."Exclude: "..ConcatKeys( self.exclude ) )
		print( i..string.format( "Callbacks (%d):", table.Count( self.callbacks ) ) )
		for k, v in pairs( self.callbacks ) do
			print( i..string.format(
				"\tName: %s, Threshold: %s, Mode: %d, Round reset: %s, Fired: %s",
				k, v.threshold, v.mode, v.round_reset, v.fired
			) )
		end
	end
end

--[[-------------------------------------------------------------------------
RoundStat Object
---------------------------------------------------------------------------]]
do
	RoundStat = {}
	RoundStat.__index = RoundStat
	RoundStat = setmetatable( RoundStat, {
		__index = RoundStatBase,
		__call = function( class, ... )
			local obj = setmetatable( {}, class )
			if obj.Initialize then obj:Initialize( ... ) end
			return obj
		end
	} )

	--[[---------------------------------------------------------------------------
	RoundStat:Initialize( name )

	Initializes RoundStat object with default values and given name

	@param		[string]		name				Name of stat, there can't be stat and group with the same name

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function RoundStat:Initialize( name )
		if !isstring( name ) then argerror( 1, "Initialize", "string", type( name ) ) end
		assert( !ROUND_STAT_GROUPS[name], string.format( "name '%s' is already in use by stat group - cannot use same name for stat and group", name ) )

		RoundStatBase.Initialize( self, name )

		self.kind = "STAT"

		self.property = "slc_stat_"..name

		ROUND_STATS[name] = self
	end

	--[[---------------------------------------------------------------------------
	RoundStat:SetValue( value, context )

	Sets value of stat and triggers callbacks if conditions are met

	@param		[number/boolean]	value				New value of stat, type must match type of initial value
	@param		[any]				context				Any data that will be passed to callbacks

	@return		[nil]				-					-
	---------------------------------------------------------------------------]]--
	function RoundStat:SetValue( value, context )
		if type( value ) != self.type then argerror( 1, "SetValue", self.type, type( value ) ) end

		local current = self:GetValue()
		if value == current then return end

		SetRoundProperty( self.property, value )

		self:OnValueChanged( current, value, context )
	end

	--[[---------------------------------------------------------------------------
	RoundStat:AddValue( value, context )

	Adds value to stat and triggers callbacks if conditions are met. Can only be used for numerical stats

	@param		[type]			value				Value to add
	@param		[type]			context				Any data that will be passed to callbacks

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function RoundStat:AddValue( value, context )
		assert( self.type == "number", "cannot add value to boolean stat" )
		if value and !isnumber( value ) then argerror( 1, "AddValue", "nil or number", type( value ) ) end

		self:SetValue( self:GetValue() + ( value or 1 ), context )
	end

	-- @override
	function RoundStat:GetValue()
		return GetRoundProperty( self.property, self.initial )
	end
end

--[[-------------------------------------------------------------------------
RoundStatGroup Object

Enums:
	GroupOperator* [number]
		@value		[0]		ROUND_STAT_OP_SUM				Value of group is calculated by summing collected values of stats
		@value		[1]		ROUND_STAT_OP_MAX				Value of group is maximal value of collected values of stats
		@value		[2]		ROUND_STAT_OP_MIN				Value of group is minimal value of collected values of stats

	GroupCollect** [number]
		@value		[0]		ROUND_STAT_COLLECT_ALL			All raw values are collected from stats
		@value		[1]		ROUND_STAT_COLLECT_POS			Only positive values are collected from stats
		@value		[2]		ROUND_STAT_COLLECT_NEG			Only negative values are collected from stats
		@value		[3]		ROUND_STAT_COLLECT_ABS			Absolute values are collected from stats

	* - SUM is O(1)
		MIN/MAX operators are O(N) and should be avoided in performance critical code - each change iterates over all stats to select new extreme value
	** - Value is collected only when callback is called, if value is changed directly by editing internal state, it will not be colected
---------------------------------------------------------------------------]]
do
	RoundStatGroup = {}
	RoundStatGroup.__index = RoundStatGroup
	RoundStatGroup = setmetatable( RoundStatGroup, {
		__index = RoundStatBase,
		__call = function( class, ... )
			local obj = setmetatable( {}, class )
			if obj.Initialize then obj:Initialize( ... ) end
			return obj
		end
	} )

	--[[---------------------------------------------------------------------------
	RoundStatGroup:Initialize( name, operator, collect )

	Initializes RoundStatGroup object with default values and given name, operator and collect mode

	@param		[type]			name				Name of group, there can't be stat and group with the same name
	@param		[GroupOperator]	operator			Collect operator of group
	@param		[GroupCollect]	collect				Collect mode of group

	@return		[nil]			-					-
	---------------------------------------------------------------------------]]--
	function RoundStatGroup:Initialize( name, operator, collect )
		if !isstring( name ) then argerror( 1, "Initialize", "string", type( name ) ) end
		assert( !ROUND_STATS[name], string.format( "name '%s' is already in use by stat - cannot use same name for stat and group", name ) )

		RoundStatBase.Initialize( self, name )

		self.kind = "GROUP"

		self.property = "slc_stat_group_"..name
		self.operator = operator or ROUND_STAT_OP_SUM
		self.collect = collect or ROUND_STAT_COLLECT_ALL
		self.stats = {}

		ROUND_STAT_GROUPS[name] = self
	end

	--[[---------------------------------------------------------------------------
	RoundStatGroup:AddStat( name )

	Adds stat(s) to group and calculates initial value of group. It's advised to add all stats in one call

	@param		[string/table]	name				This can be either stat name or table of stat names

	@return		[self]			self				-
	---------------------------------------------------------------------------]]--
	function RoundStatGroup:AddStat( name )
		local key = "stat_group_"..self.name

		local collect = self.collect
		local op = self.operator

		local old_value = self.initial
		local value = old_value

		for i, v in ipairs( istable( name ) and name or { name } ) do
			local stat = ROUND_STATS[v]
			if !stat then
				SLCErrorMessage( "Attepmted to use nonexisting round stat '%s' in group '%s'", v, self.name )
				continue
			end

			if stat.callbacks[key] then print( "CB ALREADY EXISTS" ) continue end
			table.insert( self.stats, v )

			stat:AddCallback( key, {
				mode = ROUND_STAT_MODE_ALWAYS,
				callback = function( ... )
					self:OnStatChanged( ... )
				end
			} )

			local initial = stat.initial

			local is_bool = isbool( initial )
			if is_bool then
				initial = initial and 1 or 0
			elseif collect == ROUND_STAT_OP_DEF then
				initial = initial
			elseif collect == ROUND_STAT_COLLECT_POS then
				initial = initial > 0 and initial or 0
			elseif collect == ROUND_STAT_COLLECT_NEG then
				initial = initial < 0 and initial or 0
			elseif collect == ROUND_STAT_COLLECT_ABS then
				initial = math.abs( initial )
			end

			if op == ROUND_STAT_OP_MAX and initial > value or op == ROUND_STAT_OP_MIN and initial < value then
				value = initial
			elseif op == ROUND_STAT_OP_SUM then
				value = value + initial
			end
		end

		if value != old_value then
			self:InitialValue( value )
		end

		return self
	end

	-- @override
	function RoundStatGroup:GetValue()
		return self:GetProperty().value
	end

	-- Internal - don't call
	function RoundStatGroup:GetProperty()
		local data = GetRoundProperty( self.property )
		if !data then
			data = {
				value = self.initial,
				cache = {}
			}

			SetRoundProperty( self.property, data )
		end

		return data
	end

	-- Internal - don't call
	function RoundStatGroup:OnStatChanged( name, value, diff, context, stat_data )
		local data = self:GetProperty()

		local collect = self.collect
		local op = self.operator

		local old_stat = data.cache[name]
		local new_stat

		local is_bool = isbool( value )
		if is_bool then
			new_stat = value and 1 or 0
		elseif collect == ROUND_STAT_OP_DEF then
			new_stat = value
		elseif collect == ROUND_STAT_COLLECT_POS then
			new_stat = value > 0 and value or 0
		elseif collect == ROUND_STAT_COLLECT_NEG then
			new_stat = value < 0 and value or 0
		elseif collect == ROUND_STAT_COLLECT_ABS then
			new_stat = math.abs( value )
		end

		if !new_stat or new_stat == old_stat then return end

		data.cache[name] = new_stat

		local old_value = data.value
		local new_value

		if op == ROUND_STAT_OP_MAX and op == ROUND_STAT_OP_MIN then
			new_value = self:SelectExtreme()
		elseif op == ROUND_STAT_OP_SUM then
			new_value = old_value + new_stat - ( old_stat or 0 )
		end

		if !new_value or new_value == old_value then return end

		data.value = new_value

		self:OnValueChanged( old_value, new_value, {
			original_context = context,
			stat_data = stat_data,
			stat_old = old_stat,
			stat_new = new_stat,
			stat_diff = diff,
			cause = name,
		} )
	end

	-- Internal - don't call
	function RoundStatGroup:SelectExtreme()
		local cache = self:GetProperty().cache
		local min = self.operator == ROUND_STAT_OP_MIN
		local value = min and math.huge or -math.huge

		for k, v in pairs( cache ) do
			if min and v < value or !min and v > value then
				value = v
			end
		end

		return value
	end

	function RoundStatGroup:DebugInfo( indent )
		RoundStatBase.DebugInfo( self, indent )

		local i = string.rep( "\t", indent or 0 )
		print( i..string.format( "Operator: %d, Collect: %d, Stats in group: %s",
			self.operator, self.collect, table.concat( self.stats, ", " )
		) )
	end
end

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function GetRoundStat( name )
	return ROUND_STATS[name]
end

function GetRoundStatGroup( name )
	return ROUND_STAT_GROUPS[name]
end

function GetRoundStatValue( name )
	local stat = ROUND_STATS[name]
	if !stat then return end

	return stat:GetValue()
end

function SetRoundStatValue( name, value, context )
	local stat = ROUND_STATS[name]
	if !stat then return end

	stat:SetValue( value, context )
end

function AddRoundStatValue( name, value, context )
	local stat = ROUND_STATS[name]
	if !stat then return end

	stat:AddValue( value, context )
end

function ClearRoundStats()
	for _, stat in pairs( ROUND_STATS ) do
		for k, v in pairs( stat.callbacks ) do
			if v.round_reset then
				stat.callbacks[k] = nil
			end
		end
	end

	for _, stat in pairs( ROUND_STAT_GROUPS ) do
		for k, v in pairs( stat.callbacks ) do
			if v.round_reset then
				stat.callbacks[k] = nil
			end
		end
	end
end

function GetRoundMVP()
	local best_player
	local best_score = 0

	for i, v in ipairs( player.GetAll() ) do
		local frags = v:Frags()
		if frags > best_score then
			best_score = frags
			best_player = v
		end
	end

	return best_player, best_score
end

--[[---------------------------------------------------------------------------
GetRoundSummary( num_stats )

Gets top [num_stats] stats/groups
Selection is greedy - that means stat with higher weigt will always be selected, even if it's excluded by stat with lower weight

@param		[type]			num_stats			Number of stats to select in summary

@return		[table]			summary				Table of stats where each entry is table { stat_name [string], stat_value [number/boolean] }
---------------------------------------------------------------------------]]--
local function stat_sort( a, b )
	if a.weight == b.weight then
		return a.rng > b.rng
	end

	return a.weight > b.weight
end

function GetRoundSummary( num_stats )
	num_stats = num_stats or 6

	local show_stats = {}

	for _, stat in pairs( ROUND_STATS ) do
		if stat.show then
			table.insert( show_stats, {
				name = stat.name,
				value = stat:GetValue(),
				weight = stat:GetWeight(),
				exclude = stat.exclude,
				rng = SLCRandom(),
			} )
		end
	end

	for _, stat in pairs( ROUND_STAT_GROUPS ) do
		if stat.show then
			table.insert( show_stats, {
				name = stat.name,
				value = stat:GetValue(),
				weight = stat:GetWeight(),
				exclude = stat.exclude,
				rng = SLCRandom(),
			} )
		end
	end

	table.sort( show_stats, stat_sort )

	local final_list = {}
	local blocked = {}
	local selected = 0

	for _, stat in ipairs( show_stats ) do
		if stat.weight <= 0 then print( "Skip stat - 0 weight", stat.name ) continue end
		if blocked[stat.name] then print( "Skip stat - blocked", stat.name ) continue end

		table.insert( final_list, { stat.name, stat.value } )

		selected = selected + 1
		if selected >= num_stats then
			break
		end

		for name, _ in pairs( stat.exclude ) do
			blocked[name] = true
		end
	end

	return final_list
end

function RoundStatsDebug( indent )
	indent = indent or 0

	local i = string.rep( "\t", indent )
	print( i.."Round Stats:" )
	for k, v in pairs( ROUND_STATS ) do
		v:DebugInfo( indent + 1 )
	end

	print( i.."Round Stat Groups:" )
	for k, v in pairs( ROUND_STAT_GROUPS ) do
		v:DebugInfo( indent + 1 )
	end
end

--[[-------------------------------------------------------------------------
Base round stats
---------------------------------------------------------------------------]]
hook.Add( "SLCLanguagesLoaded", "SLCBaseRoundStats", function()
	RoundStat( "recontain106" )
		:InitialValue( false )
		:Show( true, 0, 1000 )

	RoundStat( "omega_warhead" )
		:InitialValue( false )
		:Show( true, 0, 900 )

	RoundStat( "alpha_warhead" )
		:InitialValue( false )
		:Show( true, 0, 900 )

	RoundStat( "goc_warhead" )
		:InitialValue( false )
		:Show( true, 0, 1000 )
		:Exclude( { "omega_warhead", "alpha_warhead" } )
end )