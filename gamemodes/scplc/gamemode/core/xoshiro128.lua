--[[-------------------------------------------------------------------------
MIT License

Copyright (c) 2024 danx91 (https://github.com/danx91/gmod-xoshiro128)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
Some useful constants
---------------------------------------------------------------------------]]
local UINT32_MAX = 4294967295 --2^32-1
local UINT32_MAX_PLUS_ONE = 4294967296 --2^32

--[[-------------------------------------------------------------------------
Unsigned bitwise operations used by xoshiro128** and SplitMix32
---------------------------------------------------------------------------]]
local function uint32_xor( num1, num2 )
	local res = bit.bxor( num1, num2 )

	if res < 0 then
		res = res + UINT32_MAX_PLUS_ONE
	end

	return res
end

local function uint32_rotl( num, rot )
	if rot <= 0 then return num end

	num = bit.rol( num, rot )

	if num < 0 then
		num = num + UINT32_MAX_PLUS_ONE
	end

	return num
end

local function uint32_lshift( num, shift )
	if shift <= 0 then return num end
	if shift >= 32 then return 0 end

	local new = bit.lshift( num, shift )

	if new < 0 then
		new = new + UINT32_MAX_PLUS_ONE
	end

	return new
end

local function uint32_rshift( num, shift )
	if shift <= 0 then return num end
	if shift >= 32 then return 0 end

	local new = bit.rshift( num, shift )

	if new < 0 then
		new = new + UINT32_MAX_PLUS_ONE
	end

	return new
end

--[[-------------------------------------------------------------------------
xoshiro128** Implementation
Based on https://prng.di.unimi.it/xoshiro128starstar.c by David Blackman and Sebastiano Vigna

Usage:
	Call xoshiro128( seed ) to get brand new xoshiro128** generator (seed is optional, look below). Once you have the generator, you
	can use all the provided functions: NextUInt(), NextInt(), NextFloat(), NextBool() and Next() - for more information on how each
	of these functions works, take a look at documentaion of each function

Arguments:
	seed - [optional] Seed to use. If not specified will be randomly selected by math.random() from the interval [0, 2^32-1].
			For more information look at the documentation of `xoshiro128:Initialize( seed )` function
---------------------------------------------------------------------------]]
xoshiro128 = {}

setmetatable( xoshiro128, {
	__call = function( _, seed )
		local tab = setmetatable( {}, {
			__index = xoshiro128,
			__call = xoshiro128.Next
		} )

		tab:Initialize( seed )

		return tab
	end
} )

--[[---------------------------------------------------------------------------
xoshiro128:Initialize( seed )

Initializes xoshiro128** state with 4 numbers. This function is automatically called when xoshiro128 object is created.
Calling this function on already existing object will reinitialize it with a new state

@param		[any]			seed				Can be either nil, number, function that returns 4 numbers or table with NextUInt function that returns number
												If number/nil is passed, a new SplitMix32 with given seed (or random seed if nil) will be used to initialize this object
												If function is passed, it will be called once times to get all 4 state values
												If table with NextUInt function is passed (e.g. SplitMix32 object), this function will be called 4 times to get state values

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function xoshiro128:Initialize( seed )
	if seed == nil or isnumber( seed ) then
		seed = SplitMix32( seed )
	end

	if isfunction( seed ) then
		local s1, s2, s3, s4 = seed()
		assert( isnumber( s1 ) and isnumber( s2 ) and isnumber( s3 ) and isnumber( s4 ), "Failed to initialize xoshiro128 object (bad seed function)" )

		self.state = { s1, s2, s3, s4 }
	elseif istable( seed ) then
		assert( isfunction( seed.NextUInt ), string.format( "Bad table value NextUInt in argument #1 to Initialize (function expected got %s)", type( seed.NextUInt ) ) )

		self.state = {
			seed:NextUInt(),
			seed:NextUInt(),
			seed:NextUInt(),
			seed:NextUInt(),
		}
	else
		error( string.format( "Bad argument #1 to Initialize (nil/function/table expected got %s)", type( seed ) ) )
	end
end

--[[---------------------------------------------------------------------------
xoshiro128:NextUInt()

Return pseudo random uniformly distributed unsigned integer from the interval [0, 2^32-1]

@return		[nil]			-					Pseudo random number
---------------------------------------------------------------------------]]--
function xoshiro128:NextUInt()
	local state = self.state
	assert( state, "Attempted to call NextUInt on an uninitialized xoshiro128 object!" )

	local result = uint32_rotl( ( state[2] * 5 ) % UINT32_MAX_PLUS_ONE, 7 ) * 9
	local t = uint32_lshift( state[2], 9 )

	state[3] = uint32_xor( state[3], state[1] )
	state[4] = uint32_xor( state[4], state[2] )
	state[2] = uint32_xor( state[2], state[3] )
	state[1] = uint32_xor( state[1], state[4] )

	state[3] = uint32_xor( state[3], t )
	state[4] = uint32_rotl( state[4], 11 )

	return result % UINT32_MAX_PLUS_ONE
end

--[[---------------------------------------------------------------------------
xoshiro128:NextInt( m, n )

Return pseudo random integer from the interval [m, n].

@param		[number]		m					Lower bound
@param		[number]		n					Upper bound

@return		[number]		-					Pseudo random number
---------------------------------------------------------------------------]]--
function xoshiro128:NextInt( m, n )
	assert( self.state, "Attempted to call NextInt on an uninitialized xoshiro128 object!" )
	assert( isnumber( m ), string.format( "Bad argument #1 to NextInt (number expected, got %s)", type( m ) ) )
	assert( isnumber( n ), string.format( "Bad argument #2 to NextInt (number expected, got %s)", type( n ) ) )

	if m > n then
		m, n = n, m
	end

	return m + self:NextUInt() % ( n - m + 1 )
end

--[[---------------------------------------------------------------------------
xoshiro128:NextFloat()

Return pseudo random float from the interval [0, 1).

@return		[nil]			-					Pseudo random number
---------------------------------------------------------------------------]]--
function xoshiro128:NextFloat()
	assert( self.state, "Attempted to call NextFloat on an uninitialized xoshiro128 object!" )
	
	return self:NextUInt() / UINT32_MAX_PLUS_ONE
end


--[[---------------------------------------------------------------------------
xoshiro128:NextBool()

Gets random boolean value (true or false).

@return		[nil]			-					-
---------------------------------------------------------------------------]]--
function xoshiro128:NextBool()
	assert( self.state, "Attempted to call NextBool on an uninitialized xoshiro128 object!" )

	return self:NextUInt() % 2 == 0
end

--[[---------------------------------------------------------------------------
xoshiro128:Next( m, n )

Helper function that calls other ones. Arguments work just like ones used in math.random().
Depending on arguments passed, this function will return either:
	- pseudo random float from the interval [0, 1) if no arguments are passed
	- pseudo random integer from the interval [1, m] if only m is passed
	- pseudo random integer from the interval [m, n] if both m and n are passed

@param		[number/nil]	m					If it's only parameter, it's upper bound
												If n is also passed, it's lower bound
@param		[number/nil]	n					Upper bound, if specified

@return		[number]		-					Pseudo random number
---------------------------------------------------------------------------]]--
function xoshiro128:Next( m, n )
	assert( self.state, "Attempted to call Next on an uninitialized xoshiro128 object!" )
	assert( isnumber( m ) or m == nil, string.format( "Bad argument #1 to Next (nil/number expected, got %s)", type( m ) ) )
	assert( isnumber( m ) or n == nil, string.format( "Bad argument #1 to Next (number expected, got %s)", type( m ) ) )
	assert( n == nil or isnumber( n ), string.format( "Bad argument #2 to Next (nil/number expected, got %s)", type( n ) ) )

	if m == nil and n == nil then
		return self:NextFloat()
	elseif n == nil then
		return self:NextInt( 1, m )
	else
		return self:NextInt( m, n )
	end
end

--[[-------------------------------------------------------------------------
SplitMix32 Implementation
Based on https://groups.google.com/g/prng/c/VFjdFmbMgZI/m/PXAGifwABwAJ by Sebastiano Vigna

Usage:
	You shouldn't use it. SplitMix32 is used internally to initialize state of
	xoshiro128**. It provides bare minimum required only for that.

	Call `SplitMix32()` to get new instance of SplitMix32 PRNG with optional seed

Arguments:
	seed - [optional] Seed to use. If not specified will be randomly selected by math.random() from the interval [0, 2^32-1]
---------------------------------------------------------------------------]]
SplitMix32 = {}

setmetatable( SplitMix32, {
	__call = function( _, seed )
		return setmetatable( {
			state = seed or math.random( 0, UINT32_MAX )
		}, {
			__index = SplitMix32,
			__call = SplitMix32.NextUInt
		} )
	end
} )

--[[---------------------------------------------------------------------------
SplitMix32:NextUInt()

Returns next pseudo random unsigned integer from the interval [0, 2^32-1].

@return		[number]		-					Pseudo random unsigned integer from the interval [0, 2^32-1]
---------------------------------------------------------------------------]]--
function SplitMix32:NextUInt()
	self.state = ( self.state + 0x9e3779b9 ) % UINT32_MAX_PLUS_ONE

	local z = self.state

	z = uint32_xor( z, uint32_rshift( z, 16 ) )
	z = ( z * 0x85ebca6b ) % UINT32_MAX_PLUS_ONE
	z = uint32_xor( z, uint32_rshift( z, 13 ) )
	z = ( z * 0xc2b2ae35 ) % UINT32_MAX_PLUS_ONE
	z = uint32_xor( z, uint32_rshift( z, 16 ) )

	return z
end