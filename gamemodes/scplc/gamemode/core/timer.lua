--[[-------------------------------------------------------------------------
Better timers
---------------------------------------------------------------------------]]
_TimersCache = _TimersCache or {}

Timer = {}
Timer.__index = Timer

Timer.name = ""
Timer.repeats = 0
Timer.current = 0
Timer.time = 0
Timer.ncall = 0
Timer.alive = false
Timer.destroyed = false
Timer.dof = false

function Timer:Create( name, time, repeats, callback, endcallback, noactivete, nocache )
	if !name or !time or !repeats or !callback then return end

	local t = setmetatable( {}, Timer )
	t.name = name
	t.time = time
	t.repeats = repeats
	t.callback = callback
	t.endcallback = endcallback

	t.Create = function() end

	if !nocache then
		if _TimersCache[name] then
			_TimersCache[name]:Destroy()
		end

		_TimersCache[name] = t
	end

	if !noactivate then
		t:Start()
	end

	return t
end

function Timer:GetName()
	if self.destroyed then return end

	return self.name
end

function Timer:GetTime()
	if self.destroyed then return end

	return self.time
end

function Timer:GetRemainingTime()
	if self.destroyed then return end

	return self.ncall - CurTime()
end

function Timer:Stop()
	if self.destroyed then return end

	self.alive = false
end

function Timer:Start()
	if self.destroyed then return end

	self.alive = true
	self.ncall = CurTime() + self.time
end

function Timer:DestroyOnError( b )
	self.dof = b
end

function Timer:Reset()
	if self.destroyed then return end

	self.current = 0
end

function Timer:Change( time, repeats )
	if self.destroyed then return end

	if time then
		self.time = time
	end

	if repeats then
		self.repeats = repeats
	end
end

function Timer:StopReset()
	if self.destroyed then return end

	self:Stop()
	self:Reset()
end

function Timer:Destroy()
	if self.destroyed then return end

	self:Stop()
	self.destroyed = true

	_TimersCache[self.name] = nil
end

function Timer:IsValid()
	return !self.destroyed
end

function Timer:Call( ... )
	if self.destroyed then return end
	
	local suc, err = pcall( self.callback, self, self.current, ... )
	if !suc then
		print( "Error in timer "..self.name.."!" )
		print( err )

		if self.dof then
			self:Destroy()
		end
	end
end

function Timer:Tick()
	if self.destroyed then return end

	self.ncall = self.ncall + self.time

	self.current = self.current + 1
	self:Call()

	if self.repeats > 0 and self.current >= self.repeats then
		self:Destroy()

		if self.endcallback then
			self.endcallback()
		end
	end
end

setmetatable( Timer, { __call = Timer.Create } )

function GetTimer( name )
	return _TimersCache[name]
end

function DestroyTimer( name )
	local t = _TimersCache[name]

	if IsValid( t ) then
		t:Destroy()
	end
end

_TickTimersCache = _TickTimersCache or {}

function TickTimer( num, func )
	table.insert( _TickTimersCache, { num, func } )
end

hook.Add( "Tick", "TimersTick", function()
	for k, v in pairs( _TimersCache ) do
		if v.alive and v.ncall <= CurTime() then
			v:Tick()
		end
	end

	for i, v in rpairs( _TickTimersCache ) do
		if v[1] <= 0 then
			table.remove( _TickTimersCache, i )
			v[2]()
		else
			v[1] = v[1] - 1
		end
	end
end )

function ZeroTimer( func )
	TickTimer( 0, func )
end
--[[-------------------------------------------------------------------------
Player Timers
---------------------------------------------------------------------------]]
--TODO player/ent timers with string keys like NThink