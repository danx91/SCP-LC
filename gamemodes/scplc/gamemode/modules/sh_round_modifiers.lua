--[[-------------------------------------------------------------------------
Round Modifiers

Types:
	RoundModifierData [table]
		@field		[number]			min				Minimum value of modifier
		@field		[number]			max				Maximum value of modifier - must be greater than 'min'
		@field		[number]			base			Base value of modifier - must be greater than 'min' and lower than 'max'
		@field		[number]			spread			Spread of the value. Must be in the range [0, 1]
		@field		[boolean/number]	rounding		Optional, if specified, rounding step. If true, value of 1 will be used. e.g. 0.25 will round to .0, .25, .5, .75
		@field		[number]			chance			Optional, specifies chance to use this modifier. If rng fails, base value will be used
		@field		[boolean]			hidden			Optonal, if true, this modifier will not show in the round info
		@field		[boolean]			normalize		Optonal, if true, this modifier value will be normalized equally:
															true: whole range is equally divided
															false/nil: left and right side of base value are divided independently
---------------------------------------------------------------------------]]
ROUND_MODIFIERS = ROUND_MODIFIERS or {}

--[[---------------------------------------------------------------------------
RegisterRoundModifier( id, data )

Registers round modifier. Value will be selected randomly using normal distribution

@param		[string]				id					ID of the modifier
@param		[RoundModifierData]		data				-


@return		[nil]					-					-
---------------------------------------------------------------------------]]--
function RegisterRoundModifier( id, data )
	if type( id ) != "string" then argerror( 1, "RegisterRoundModifier", "string", type( id ) ) end
	if !istable( data ) then argerror( 2, "RegisterRoundModifier", "table", type( data ) ) end

	if !isnumber( data.min ) then fielderror( "min", 2, "RegisterRoundModifier", "number", type( data.min ) ) end
	if !isnumber( data.max ) then fielderror( "max", 2, "RegisterRoundModifier", "number", type( data.max ) ) end
	if !isnumber( data.base ) then fielderror( "base", 2, "RegisterRoundModifier", "number", type( data.base ) ) end
	if !isnumber( data.spread ) then fielderror( "spread", 2, "RegisterRoundModifier", "number", type( data.spread ) ) end
	if data.rounding and !isnumber( data.rounding ) and !isbool( data.rounding ) then
		fielderror( "rounding", 2, "RegisterRoundModifier", "number or boolean or nil", type( data.rounding ) )
	end
	if data.chance and !isnumber( data.chance ) then fielderror( "chance", 2, "RegisterRoundModifier", "number or nil", type( data.chance ) ) end
	if data.hidden and !isbool( data.hidden ) then fielderror( "hidden", 2, "RegisterRoundModifier", "boolean or nil", type( data.hidden ) ) end
	if data.normalize and !isbool( data.normalize ) then fielderror( "normalize", 2, "RegisterRoundModifier", "boolean or nil", type( data.normalize ) ) end

	assert( data.min < data.max, "RegisterRoundModifier value of min must be lower than max" )
	assert( data.base >= data.min, "RegisterRoundModifier value of base must be greater or equal to min" )
	assert( data.base <= data.max, "RegisterRoundModifier value of base must be lower or equal to max" )
	assert( data.spread >= 0 and data.spread <= 1, "RegisterRoundModifier value of spread must be in the [0, 1] interval" )
	assert( data.spread >= 0 and data.spread <= 1, "RegisterRoundModifier value of spread must be in the [0, 1] interval" )

	local step = isnumber( data.rounding ) and data.rounding or data.rounding == true and 1 or false
	if step then
		assert( data.min % step == 0, "RegisterRoundModifier value of min must be divisible by value of rounding" )
		assert( data.max % step == 0, "RegisterRoundModifier value of max must be divisible by value of rounding" )
		assert( data.base % step == 0, "RegisterRoundModifier value of step must be divisible by value of rounding" )
	end

	local tab = {}
	ROUND_MODIFIERS[id] = tab

	local offset = nil
	local flip = false

	tab.orig_base = data.base
	tab.orig_min = data.min
	tab.orig_max = data.max

	if data.base == data.min or data.base == data.max then
		data = table.Copy( data )

		if data.base == data.max then
			flip = true
		end

		offset = data.min

		data.base = 0
		data.max = data.max - offset
		data.min = -data.max
		data.normalize = true
	end

	local tmp = ( data.base - data.min ) / ( data.max - data.min )

	tab.min = data.min
	tab.max = data.max
	tab.base = data.base
	tab.center = math.log( tmp / ( 1 - tmp ) )
	tab.offset = offset
	tab.flip = flip
	tab.sigma = data.spread * 2
	tab.step = step
	tab.chance = data.chance or 1
	tab.hidden = data.hidden
end


--[[---------------------------------------------------------------------------
ClearRoundModifiers()

Restores all modifiers to their base values

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function ClearRoundModifiers()
	for k, v in pairs( ROUND_MODIFIERS ) do
		ROUND.modifiers[k] = v.orig_base
	end
end

function RandomizeRoundModifier( id )
	local mod = ROUND_MODIFIERS[id]
	if !mod then return end

	local z = math.RandNormal( 0, mod.sigma )
	local u = 1 / ( 1 + math.exp( -( mod.center + z ) ) )
	local value = mod.min + u * ( mod.max - mod.min )

	if mod.offset then
		value = math.abs( value )

		if mod.flip then
			value = mod.max - value
		end

		value = value + mod.offset
	end

	if mod.step then
		value = math.Clamp( math.StochasticRound( value / mod.step ) * mod.step, mod.orig_min, mod.orig_max )
	end

	print( "Modifier randomize", id, value )

	ROUND.modifiers[id] = value

	return value
end

--[[---------------------------------------------------------------------------
SelectRoundModifiers( whitelist, use_blacklist )

Randomizes all round modifiers optionally using provided whitelist/blacklist

@param		[table<string, number/true>]
							force				Optional, if provided, exact value or forced selection (true)
@param		[table]			whitelist			Optional, if provided, only modifiers present in the whitelist will be randomized, remaining ones will be reset to base value
@param		[boolean]		use_blacklist		Optional, if true, whitelist will be treated as blacklist instead

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function SelectRoundModifiers( force, whitelist, use_blacklist )
	print( "Selecting modifiers", force, whitelist, use_blacklist )
	for k, v in pairs( ROUND_MODIFIERS ) do
		if force and force[k] then
			if force[k] == true then
				print( "force random", k )
				RandomizeRoundModifier( k )
			else
				local val = v.step and math.StochasticRound( force[k] / v.step ) * v.step or force[k]
				ROUND.modifiers[k] = math.Clamp( val, v.orig_min, v.orig_max )
				print( "force val", k, force[k], ROUND.modifiers[k] )
			end
		elseif v.chance <= 0 or SLCRandom() >= v.chance or whitelist and ( !use_blacklist and !whitelist[k] or use_blacklist and whitelist[k] ) then
			print( "Modifier keep base", k )
			ROUND.modifiers[k] = v.orig_base
		else
			RandomizeRoundModifier( k )
		end
	end
end

function GetRoundModifier( id, def )
	local value = ROUND.modifiers[id] or def
	local norm, base
	local hidden = true

	local mod = ROUND_MODIFIERS[id]
	if mod then
		base = mod.orig_base
		hidden = mod.hidden

		if !value then
			value = base
		end

		if mod.normalize then
			norm = ( value - mod.orig_min ) / ( mod.orig_max - mod.orig_min )
		elseif value < base then
			norm = ( value - mod.orig_min ) / ( base - mod.orig_min ) * 0.5
		else
			norm = ( value - base ) / ( mod.orig_max - base ) * 0.5 + 0.5
		end

		if norm != norm then
			norm = 0.5
		end
	end

	return value, norm, base, hidden or false
end

--[[-------------------------------------------------------------------------
Round rules

Types:
	RoundRuleData [table]
		@field		[number]			chance				Optional, chance of selection from 0 to 1. Rule with chance 0 will never be selected
															and rule with chance 1 will always be selected if other conditions are met
		@field		[boolean/table]		exclude				Optional, if true, no other rules will be randomly selected;
															if false, all rules are allowed;
															if table, all rules inside table will be excluded from random selection
															NOTE: Selection is done in random order and all exclusions are assumed as mutual e.g. if A excludes B, B is assumed
															to exclude A or 'solo' rule cannot be selected if there is any other already selected rule
															To create unusual combinations of rules, create dedicated round type and force them
		@field		[function]			condition			Optional, function to decide whenever this rule can be selected. Return true to allow
		@field		[function]			callback			Optional, callback that will be called right after selection.
															That's the right place to modify things and register round hooks.
		@field		[boolean]			hidden				Optonal, if true, this rule will not show in the round info

---------------------------------------------------------------------------]]
ROUND_RULES = ROUND_RULES or {}

--[[---------------------------------------------------------------------------
RegisterRoundRule( id, data )

Registers new round rule

@param		[string]			id					ID of the rule
@param		[RoundRuleData]		data				-

@return		[nil]				-					-
---------------------------------------------------------------------------]]--
function RegisterRoundRule( id, data )
	if type( id ) != "string" then argerror( 1, "RegisterRoundRule", "string", type( id ) ) end
	if !istable( data ) then argerror( 2, "RegisterRoundRule", "table", type( data ) ) end

	if data.chance and !isnumber( data.chance ) then fielderror( "chance", 2, "RegisterRoundRule", "number or nil", type( data.chance ) ) end
	if data.exclude and !istable( data.exclude ) and !isbool( data.exclude ) then
		fielderror( "exclude", 2, "RegisterRoundRule", "table or boolean or nil", type( data.exclude ) )
	end
	if data.condition and !isfunction( data.condition ) then fielderror( "condition", 2, "RegisterRoundRule", "function or nil", type( data.condition ) ) end
	if data.callback and !isfunction( data.callback ) then fielderror( "callback", 2, "RegisterRoundRule", "function or nil", type( data.callback ) ) end
	if data.hidden and !isbool( data.hidden ) then fielderror( "hidden", 2, "RegisterRoundRule", "boolean or nil", type( data.hidden ) ) end

	data = data or {}

	ROUND_RULES[id] = {
		chance = data.chance or 0,
		exclude = data.exclude or false,
		condition = data.condition,
		callback = data.callback,
		hidden = data.hidden,
	}
end

--[[---------------------------------------------------------------------------
ClearRoundRules()

Removes all rules from round


@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function ClearRoundRules()
	ROUND.rules = {}
end


--[[---------------------------------------------------------------------------
ActivateRoundRule( id, active, force_callback )

Activates round rule with given id. Callback will be called only when inactive rule becomes active unless force_callback is true

@param		[string]		id					ID of the rule
@param		[boolean]		active				Whether to activate or deactivate round rule 
@param		[boolean]		force_callback		Optional, if true, callback will be called even when rule was already active

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function ActivateRoundRule( id, active, force_callback )
	local rule = ROUND_RULES[id]
	if !rule then
		ErrorNoHaltWithStack( "Failed to activate round rule '"..id.."' - rule doesn't exist\n" )
		return
	end

	print( "activaing rule", id, active, force_callback )

	local prev = ROUND.rules[id]
	ROUND.rules[id] = !!active

	if active and rule.callback and ( force_callback or !prev ) then
		rule.callback()
	end
end


--[[---------------------------------------------------------------------------
SelectRoundRules( force, whitelist, use_blacklist )

Selects round rules.
WARNING: If force list is used, it ignores exclude fields of rules, this includes even 'solo' rules!

@param		[table]			force				Optional, if provided, these rules are guaranteed to be active
@param		[table]			whitelist			Optional, if provided, only rules present in the whitelist are allowed
@param		[boolean]		use_blacklist		Optional, if true, whitelist will be treated as blacklist instead

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function SelectRoundRules( force, whitelist, use_blacklist )
	ClearRoundRules()

	local force_lookup = {}
	local exclude_lookup = {}
	local exclude_all = false

	for rule, _ in ipairs( force or {} ) do
		force_lookup[rule] = true
		ActivateRoundRule( rule, true )
		print( "Forcing rule", rule )

		local rule_obj = ROUND_RULES[rule]
		if !rule_obj then continue end

		if rule_obj.exclude == true then
			exclude_all = true
			continue
		elseif !istable( rule_obj.exclude ) then
			continue
		end

		for _, v in ipairs( rule_obj.exclude ) do
			exclude_lookup[v] = true
		end
	end

	if exclude_all then print( "No random rules allowed - all excluded" ) return end
	if whitelist and !use_blacklist and !next( whitelist ) then print( "No random rules allowed - whitelist is empty" ) return end

	local keys = table.GetKeys( ROUND_RULES )
	ShuffleTable( keys )

	for _, rule in ipairs( keys ) do
		if force_lookup[rule] or exclude_lookup[rule] then print( "Already active or excluded", rule ) continue end
		if whitelist and ( !use_blacklist and !whitelist[rule] or use_blacklist and whitelist[rule] ) then print( "Not allowed by whitelist/blacklist", rule ) continue end

		local rule_obj = ROUND_RULES[rule]

		if rule_obj.exclude == true and next( ROUND.rules ) then print( "solo but other active", rule ) continue end
		if rule_obj.chance <= 0 or SLCRandom() >= rule_obj.chance then print( "RNG failed", rule ) continue end
		if rule_obj.condition and rule_obj.condition() != true then print( "condition not met", rule ) continue end

		local exclude_is_table = istable( rule_obj.exclude )

		if exclude_is_table then
			local exclude_self = false

			for _, v in ipairs( rule_obj.exclude ) do
				if ROUND.rules[v] then
					print( "excludes rule that is already selected", rule, v )
					exclude_self = true
					break
				end
			end

			if exclude_self then continue end
		end

		ActivateRoundRule( rule, true )

		if rule_obj.exclude == true then
			print( "Excludes all - exit selection", rule )
			return
		elseif !exclude_is_table then
			continue
		end

		for _, v in ipairs( rule_obj.exclude ) do
			exclude_lookup[v] = true
		end
	end
end

function GetRoundRule( id )
	local rule = ROUND_RULES[id]
	local hidden = true

	if rule then
		hidden = rule.hidden
	end

	return ROUND.rules[id], hidden or false
end

--[[-------------------------------------------------------------------------
Run hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCGamemodeLoaded", "SLCRegisterRoundModifiersAndRules", function()
	hook.Run( "SLCRegisterRoundModifiers" )
	hook.Run( "SLCRegisterRoundRules" )
end )