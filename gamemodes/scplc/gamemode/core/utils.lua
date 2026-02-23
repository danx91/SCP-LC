MASK_USE = bit.bor( CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_PLAYERCLIP, CONTENTS_MOVEABLE, CONTENTS_GRATE, CONTENTS_WINDOW, CONTENTS_SOLID )

--[[-------------------------------------------------------------------------
Serverside GetMaterial, for shared compatibility
---------------------------------------------------------------------------]]
if SERVER then
	function GetMaterial( name, args )
		return Material( name, args )
	end
end

--[[-------------------------------------------------------------------------
rpairs
---------------------------------------------------------------------------]]
local function rpairs_iter( tab, i )
	i = i - 1
	local v = tab[i]

	if v then
		return i, v
	end
end

function rpairs( tab, i )
	return rpairs_iter, tab, (i or #tab) + 1
end

--[[-------------------------------------------------------------------------
Roman numbers
---------------------------------------------------------------------------]]
local roman_values = { 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000 }
local roman_digits = { "I", "IV", "V", "IX", "X", "XL", "L", "XC", "C", "CD", "D", "CM", "M" }
local roman_cache = {}

function ToRoman( num )
	if roman_cache[num] then
		return roman_cache[num]
	end

	local result = ""

	for i = 13, 1, -1 do
		result = result..string.rep( roman_digits[i], math.floor( num / roman_values[i] ) )
		num = num % roman_values[i]
	end

	roman_cache[num] = result
	return result
end

--[[-------------------------------------------------------------------------
List (double linked list)
---------------------------------------------------------------------------]]
local function list_iter( tab )
	local cur = tab[1]
	if !cur then return end

	tab[1] = cur.next
	return cur.data
end

List = {}

function List:New()
	if self != List then return end

	return setmetatable( {
		size = 0,
	}, { __index = List } )
end

function List:PushFront( item )
	local _head = self.head

	self.head = {
		next = _head,
		data = item
	}

	self.size = self.size + 1

	if !self.tail then
		self.tail = self.head
	end

	if _head then
		_head.prev = self.head
	end

	return self.size
end

function List:PushBack( item )
	local _tail = self.tail

	self.tail = {
		prev = _tail,
		data = item
	}

	self.size = self.size + 1

	if !self.head then
		self.head = self.tail
	end

	if _tail then
		_tail.next = self.tail
	end

	return self.size
end

function List:PopFront()
	if !self.head then return end

	local item = self.head

	self.head = self.head.next

	if self.head then
		self.head.prev = nil
	end

	self.size = self.size - 1

	if self.size == 1 then self.tail = self.head end
	if self.size == 0 then self.tail = nil end

	return item.data
end

function List:PopBack()
	if !self.tail then return end

	local item = self.tail

	self.tail = self.tail.prev

	if self.tail then
		self.tail.next = nil
	end

	self.size = self.size - 1

	if self.size == 1 then self.head = self.tail end
	if self.size == 0 then self.head = nil end

	return item.data
end

function List:Size()
	return self.size
end

function List:Head()
	return self.head and self.head.data
end

function List:Tail()
	return self.tail and self.tail.data
end

function List:Iter()
	return list_iter, { self.head }
end

setmetatable( List, { __call = List.New } )

--[[-------------------------------------------------------------------------
General functions
---------------------------------------------------------------------------]]
local rep = {
	["%#"] = "?h",
	["%$"] = "?d",
	["%["] = "?o",
	["%]"] = "?c",
	["%."] = "?t",
	["%;"] = "?s",
	["%:"] = "?n",
	["%,"] = "?m",
}

function EscapeMessage( msg )
	msg = string.gsub( msg, "?", "?q" )

	for k, v in pairs( rep ) do
		msg = string.gsub( msg, k, v )
	end

	return msg
end

function RestoreMessage( msg )
	for k, v in pairs( rep ) do
		msg = string.gsub( msg, v, k )
	end

	local str = string.gsub( msg, "?q", "?" )
	return str
end

local fic_trace = {}
fic_trace.output = fic_trace

function FindInCylinder( orig, radius, zmin, zmax, filter, mask, feed )
	local result = {}
	local index = 0
	radius = radius * radius

	if filter then
		if !istable( filter ) then
			filter = { filter }
		end

		local f = filter
		filter = {}

		for i = 1, #f do
			filter[f[i]] = true
		end
	end

	fic_trace.start = orig

	for i, v in ipairs( feed or ents.GetAll() ) do
		if filter and !filter[v:GetClass()] then continue end
		local pos = v:GetPos() + v:OBBCenter()

		local dist = pos - orig
		if dist.z < zmin or dist.z > zmax then continue end
		if dist.x * dist.x + dist.y * dist.y > radius then continue end

		if mask then
			fic_trace.endpos = pos
			fic_trace.mask = mask

			util.TraceLine( fic_trace )

			if fic_trace.Hit then continue end
		end

		index = index + 1
		result[index] = v
	end

	return result, index
end

function player.FindInSphere( pos, rad )
	local rad_sqr = rad * rad
	local res = {}
	local ind = 0

	for i, v in ipairs( player.GetAll() ) do
		if v:GetPos():DistToSqr( pos ) <= rad_sqr then
			ind = ind + 1
			res[ind] = v
		end
	end

	return res
end

function printf( ... )
	print( string.format( ... ) )
end