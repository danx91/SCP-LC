local vector = FindMetaTable( "Vector" )

function vector:Copy()
	return Vector( self.x, self.y, self.z )
end

function vector:Approach( target, delta )
	//local diff = target - self
end

function vector:IsInTolerance( dpos, tolerance )
	if self == dpos then return true end

	if isnumber( tolerance ) then
		tolerance = { x = tolerance, y = tolerance, z = tolerance }
	end

	for k, v in pairs( { "x", "y", "z" } ) do
		if self[v] != dpos[v] then
			if !tolerance[v] or math.abs( dpos[v] - self[v] ) > tolerance[v] then
				return false
			end
		end
	end

	return true
end

function vector:DropToFloor( maxdist )
	local result = util.TraceLine{
		start = self,
		endpos = self - Vector( 0, 0, maxdist or 100 ),
		mask = MASK_SOLID_BRUSHONLY,
	}

	if !result.Hit then
		return self * 1
	else
		return result.HitPos
	end
end

//https://gamedev.stackexchange.com/a/110233
local function is_right( p0, p1, p2 )
	return ( p1.x - p0.x ) * ( p2.y - p0.y ) - ( p2.x - p0.x ) * ( p1.y - p0.y ) < 0
end

//a, b, c, d are vertices of rectange in counter-clockwise order! This ignores z values!
function vector:WithinRotatedRect( a, b, c, d )
	return is_right( a, b, self ) and is_right( b, c, self ) and is_right( c, d, self ) and is_right( d, a, self )
end

local angle = FindMetaTable( "Angle" )

function angle:Copy()
	return Angle( self.pitch, self.yaw, self.roll )
end

function angle:Approach( ang, inc )
	local angle360 = self:To360()
	local target = ang:To360()

	return math.Angle360ToAngle( math.ApproachAngle360( angle360, target, inc ) )
end

function angle:To360()
	return math.AngleTo360( self )
end

function angle:Clamp( pmin, pmax, ymin, ymax, rmin, rmax )
	if pmin and self.p < pmin then
		self.p = pmin
	end

	if pmax and self.p > pmax then
		self.p = pmax
	end

	if ymin and self.p < ymin then
		self.y = ymin
	end

	if ymax and self.y > ymax then
		self.y = ymax
	end

	if rmin and self.r < rmin then
		self.r = rmin
	end

	if rmax and self.r > rmax then
		self.r = rmax
	end
end

function math.AngleTo360( ang )
	ang:Normalize()

	local a360 = { p = ang.p, y = ang.y, r = ang.r }

	if a360.p < 0 then
		a360.p = 360 + a360.p
	end

	if a360.y < 0 then
		a360.y = 360 + a360.y
	end

	if a360.r < 0 then
		a360.r = 360 + a360.r
	end

	return a360
end

function math.Angle360ToAngle( ang )
	math.NormalizeAngle360( ang )

	if ang.p > 180 then
		ang.p = -360 + ang.p
	end

	if ang.y > 180 then
		ang.y = -360 + ang.y
	end

	if ang.r > 180 then
		ang.r = -360 + ang.r
	end

	return Angle( ang.p, ang.y, ang.r )
end

function math.ApproachAngle360( ang, target, inc )
	math.NormalizeAngle360( ang )
	math.NormalizeAngle360( target )

	inc = math.abs( inc )
	local result = { p = 0, y = 0, r = 0 }

	for k, v in pairs( ang ) do
		local diff = target[k] - v

		local abs_diff = math.abs( diff )
		local mul = abs_diff == 0 and 1 or diff / abs_diff

		if abs_diff > 180 then
			abs_diff = 360 - abs_diff
			mul = mul * -1
		end

		if abs_diff > inc then
			abs_diff = inc
		end

		local r = v + abs_diff * mul

		if r < 0 then
			r = 360 + r
		elseif r > 360 then
			r = r - 360
		end

		result[k] = r
	end

	return result
end

function math.NormalizeAngle360( ang )
	ang.p = ang.p % 360
	ang.y = ang.y % 360
	ang.r = ang.r % 360

	return ang
end

function math.TimedSinWave( freq, min, max )
	min = ( min + max ) / 2
	local wave = math.SinWave( RealTime(), freq, min - max, min )
	return wave
end

--based on wikipedia: f(x) = sin( angular frequency * x ) * amplitude + offset
function math.SinWave( x, freq, amp, offset )
	local wave = math.sin( 2 * math.pi * freq * x ) * amp + offset
	return wave
end

function math.Map( num, min, max, newmin, newmax )
	if max == min then error( "Invalid arguments to math.Map" ) end

	return newmin + ( num - min ) / ( max - min ) * ( newmax - newmin )
end

function math.TrueFOV( fov, aspect )
	if !aspect and CLIENT then
		aspect = ScrW() / ScrH()
	end

	local ratio = ( aspect or 16 / 9 ) / ( 4 / 3 )

	return 2 * math.deg( math.atan( math.tan( math.rad( fov ) / 2 ) * ratio ) )
end

local po2 = setmetatable( {}, {
	__index = function( tab, key )
		if !isnumber( key ) then return end

		local num = math.pow( 2, key )
		tab[key] = num

		return num
	end
} )

function math.PowerOf2( pow ) --Memoizing po2 values is almost useless (for values up to 2^32 this function is 7% faster and for values up to 2^512 is about 11% faster)
	return po2[pow]
end
/*function math.Bin2Dec( bin, unsigned )
	local bytes = { string.byte( bin, 1, string.len( bin ) ) }
	local num = 0

	for i = 1, 4 do
		num = num + bit.lshift( bytes[i], (4 - i) * 8 )
	end
	
	if num < 0 and unsigned then
		num = num + 4294967296 --2^32
	end

	return num
end*/

function math.Bin2Dec( bin, unsigned ) --this version is about 400% faster
	local num = bit.lshift( string.byte( bin, 1 ), 24 ) +
				bit.lshift( string.byte( bin, 2 ), 16 ) +
				bit.lshift( string.byte( bin, 3 ), 8 ) +
							string.byte( bin, 4 )

	if num < 0 and unsigned then
		num = num + 4294967296 --2^32
	end

	return num
end

/*function math.Dec2Bin( dec )
	local bytes = ""

	for i = 1, 4 do
		bytes = string.char( bit.band( dec, 255 ) )..bytes
		dec = bit.rshift( dec, 8 )
	end

	return bytes
end*/

function math.Dec2Bin( dec ) --this version is about 30% faster
	return string.char( bit.rshift( bit.band( dec, -16777216 ), 24 ) )..
		   string.char( bit.rshift( bit.band( dec, 16711680 ), 16 ) )..
		   string.char( bit.rshift( bit.band( dec, 65280 ), 8 ) )..
		   string.char( bit.band( dec, 255 ) )
end

--[[-------------------------------------------------------------------------
Simple Matrix
---------------------------------------------------------------------------]]
SimpleMatrix = {}

function SimpleMatrix:New( w, h, init )
	if !isnumber( w ) or !isnumber( h ) then return {} end
	local usetab = type( init ) == "table"
	local usenum = ( type( init ) == "number" and init ) or ( type( init ) == "boolean" and init and 1 ) or 0

	local mx = {}

	mx.New = function() end

	for y = 1, h do
		mx[y] = {}
		for x = 1, w do
			mx[y][x] = usetab and tonumber( init[y] and init[y][x] ) or usenum
		end
	end

	setmetatable( mx, {
		__index = SimpleMatrix,
		__add = function( a, b )
			if type( a ) == "table" and a.Add then
				return a:Add( b )
			elseif type( b ) == "table" and b.Add then
				return b:Add( a )
			end
		end,
		__sub = function( a, b )
			if type( a ) == "table" and a.Sub then
				return a:Sub( b )
			elseif type( b ) == "table" and b.Sub then
				return b:Sub( a, true )
			end
		end,
		__mul = function( a, b )
			if type( a ) == "table" and a.Mul then
				return a:Mul( b )
			elseif type( b ) == "table" and b.Mul then
				return b:Mul( a )
			end
		end
	} )

	return mx
end

function SimpleMatrix:Add( mx )
	local result = SimpleMatrix( #self[1], #self, self ) --create new matrix because we don't want to mess with original matrix

	if type( mx ) != "table" then
		if type( mx ) == "number" then
			mx = SimpleMatrix( #self[1], #self, true ) * mx --convert scalar to matrix
		else
			error( "Matrix or scalar expected, got "..type( mx ) )
		end
	end

	if #self != #mx or #self[1] != #mx[1] then
		error( "Dimensions of matrixes are not equal" )
	end

	local width = #result[1]
	for y = 1, #result do
		for x = 1, width do
			result[y][x] = result[y][x] + mx[y][x]
		end
	end

	return result
end

function SimpleMatrix:Sub( mx, invert )
	local result = SimpleMatrix( #self[1], #self, self ) --create new matrix because we don't want to mess with original matrix

	if type( mx ) != "table" then
		if type( mx ) == "number" then
			mx = SimpleMatrix( #self[1], #self, true ) * mx --convert scalar to matrix
		else
			error( "Matrix or scalar expected, got "..type( mx ) )
		end
	end

	if #self != #mx or #self[1] != #mx[1] then
		error( "Dimensions of matrixes are not equal" )
	end

	local width = #result[1]
	for y = 1, #result do
		for x = 1, width do
			if invert then
				result[y][x] = mx[y][x] - result[y][x]
			else
				result[y][x] = result[y][x] - mx[y][x]
			end
		end
	end

	return result
end

function SimpleMatrix:Mul( mx )
	local result
	//local usematrix, usescalar = false, false

	if type( mx ) == "table" then
		if #self[1] != #mx then
			error( "First matrix width is not eaqual to second matrix height" )
		end

		result = SimpleMatrix( #mx[1], #self )

		local width = #result[1]
		for y = 1, #result do
			for x = 1, width do
				for i = 1, #self do
					result[y][x] = result[y][x] + self[y][i] * mx[i][x]
				end
			end
		end

		return result
	elseif type( mx ) == "number" then
		result = SimpleMatrix( #self[1], #self, self )

		local width = #result[1]
		for y = 1, #result do
			for x = 1, width do
				result[y][x] = result[y][x] * mx
			end
		end

		return result
	else
		error( "Matrix or scalar expected, got "..type( mx ) )
	end
end

function SimpleMatrix:Get( x, y )
	return self[y] and self[y][x]
end

function SimpleMatrix:ToPoly()
	local poly = {}

	for y = 1, #self do
		local f = self[y]
		local vert = {
			x = f[1],
			y = f[2],
			u = f[3],
			v = f[4],
		}

		table.insert( poly, vert )
	end

	return poly
end

setmetatable( SimpleMatrix, { __call = SimpleMatrix.New } )

--[[-------------------------------------------------------------------------
Cubic Bezier
---------------------------------------------------------------------------]]
function math.CubicBezier( x1, y1, x2, y2 )
	return function( n )
		local x = 3 * n * ( 1 - n ) * ( 1 - n ) * x1 + 3 * n * n * ( 1 - n ) * x2 + n * n * n
		local y = 3 * n * ( 1 - n ) * ( 1 - n ) * y1 + 3 * n * n * ( 1 - n ) * y2 + n * n * n

		return x, y
	end
end

function math.CubicBezierYFromX( x1, y1, x2, y2, precision )
	precision = precision or 0.0001

	return function( x )
		local upper = 1
		local lower = 0
		local n = ( upper + lower ) / 2
		local nx = 3 * n * ( 1 - n ) * ( 1 - n ) * x1 + 3 * n * n * ( 1 - n ) * x2 + n * n * n

		while math.abs( nx - x ) > precision do
			if nx > x then
				upper = n
			else
				lower = n
			end

			n = ( upper + lower ) / 2
			nx = 3 * n * ( 1 - n ) * ( 1 - n ) * x1 + 3 * n * n * ( 1 - n ) * x2 + n * n * n
		end

		local y = 3 * n * ( 1 - n ) * ( 1 - n ) * y1 + 3 * n * n * ( 1 - n ) * y2 + n * n * n

		return y
	end
end

function math.CubicBezierXFromY( x1, y1, x2, y2, precision )
	precision = precision or 0.0001

	return function( y )
		local upper = 1
		local lower = 0
		local n = ( upper + lower ) / 2
		local ny = 3 * n * ( 1 - n ) * ( 1 - n ) * y1 + 3 * n * n * ( 1 - n ) * y2 + n * n * n

		while math.abs( ny - y ) > precision do
			if ny > y then
				upper = n
			else
				lower = n
			end

			n = ( upper + lower ) / 2
			ny = 3 * n * ( 1 - n ) * ( 1 - n ) * y1 + 3 * n * n * ( 1 - n ) * y2 + n * n * n
		end

		local x = 3 * n * ( 1 - n ) * ( 1 - n ) * x1 + 3 * n * n * ( 1 - n ) * x2 + n * n * n

		return x
	end
end

SLCEase = {
	ease = math.CubicBezierYFromX( 0.25, 0.1, 0.25, 1 ),
	ease_in = math.CubicBezierYFromX( 0.42, 0, 1, 1 ),
	ease_out = math.CubicBezierYFromX( 0, 0, 0.58, 1 ),
	ease_in_out = math.CubicBezierYFromX( 0.42, 0, 0.58, 1 ),
}