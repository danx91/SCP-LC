local vector = FindMetaTable( "Vector" )

function vector:Copy()
	return Vector( self.x, self.y, self.z )
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

local angle = FindMetaTable( "Angle" )

function angle:Copy()
	return Angle( self.pitch, self.yaw, self.roll )
end

function angle:Approach( ang, inc )
	local angle = self:To360()
	local target = ang:To360()

	return Angle360ToAngle( ApproachAngle360( angle, target, inc ) )
end

function angle:To360()
	return AngleTo360( self )
end


function AngleTo360( ang )
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

function Angle360ToAngle( ang )
	NormalizeAngle360( ang )

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

function ApproachAngle360( angle, target, inc )
	NormalizeAngle360( angle )
	NormalizeAngle360( target )

	inc = math.abs( inc )
	local result = { p = 0, y = 0, r = 0 }

	for k, v in pairs( angle ) do
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

function NormalizeAngle360( ang )
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

function math.NumStep( start, endnum, step )
	if start == endnum then return start end
	local mul = endnum - start
	mul = mul / math.abs( mul )
	local result = start + step * mul
	if mul > 0 then
		result = math.min( result, endnum )
	else
		result = math.max( result, endnum )
	end
	return result
end

function math.Map( num, min, max, newmin, newmax )
	if max == min then error( "Invalid arguments to math.Map" ) end

	return newmin + ( num - min ) / ( max - min ) * ( newmax - newmin )
end

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
	local usematrix, usescalar = false, false

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