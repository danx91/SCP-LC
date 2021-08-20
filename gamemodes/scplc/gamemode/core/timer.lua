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
Timer.nocache = false

function Timer:Create( name, time, repeats, callback, endcallback, noactivete, nocache )
	if !name or !time or !repeats then return end

	local t = setmetatable( {}, Timer )
	t.name = name
	t.time = time
	t.repeats = repeats
	t.callback = callback
	t.endcallback = endcallback
	t.nocache = nocache

	t.Create = function() end

	if !nocache then
		if IsValid( _TimersCache[name] ) then
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

	if !self.nocache then
		_TimersCache[self.name] = nil
	end
end

function Timer:IsValid()
	return !self.destroyed
end

function Timer:Call( ... )
	if self.destroyed then return end

	if self.callback then
		local suc, err = pcall( self.callback, self, self.current, ... )
		if !suc then
			print( "Error in timer "..self.name.."!" )
			print( err )

			if self.dof then
				self:Destroy()
			end
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
			local suc, err = pcall( self.endcallback, self.name )
			if !suc then
				print( "Error in timer "..self.name.."!" )
				print( err )
			end
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

--BUG: if error occurs in timer function, remaining timers will be called in the next tick
hook.Add( "Tick", "TimersTick", function()
	for k, v in pairs( _TimersCache ) do
		if v.alive and v.ncall <= CurTime() then
			v:Tick()
		end
	end

	if SERVER then
		for k, v in pairs( player.GetAll() ) do
			local tab = v:GetProperty( "slc_timers" )
			if tab then
				for _, t in pairs( tab ) do
					if t.alive and t.ncall <= CurTime() then
						t:Tick()
					end
				end
			end
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

function ThenableTimer( name, time, repeats, callback, endcallback, noactivete, nocache )
	local p = SLCPromise()

	local t = Timer( name, time, repeats, callback, function()
		if endcallback then
			endcallback( name )
		end

		p:Resolve()
	end, noactivete, nocache )

	return p, t
end

--[[-------------------------------------------------------------------------
NextTick
---------------------------------------------------------------------------]]
_CallNextTick = _CallNextTick or {}

function NextTick( func, ... )
	table.insert( _CallNextTick, { func, { ... } } )
end

hook.Add( "Tick", "CallNextTick", function()
	local len = #_CallNextTick
	if len > 0 then
		for i = 1, len do
			local tab = table.remove( _CallNextTick )
			tab[1]( unpack( tab[2] ) )
		end
	end
end )

--[[-------------------------------------------------------------------------
Player Timers
---------------------------------------------------------------------------]]
if SERVER then
	local ply = FindMetaTable( "Player" )

	function ply:AddTimer( name, time, repeats, callback, endcallback, noactivete, nooverride )
		//local t = Timer( name..self:SteamID(), time, repeats, callback, endcallback, noactivete, false )
		local t = Timer( name, time, repeats, callback, endcallback, noactivete, true )

		local tab = self:GetProperty( "slc_timers" )
		if !tab then
			tab = self:SetProperty( "slc_timers", {} )
		end

		local old = tab[name]
		if IsValid( old ) then
			if nooverride then
				return false
			end

			old:Destroy()
		end

		tab[name] = t

		return t
	end

	function ply:GetTimer( name )
		local tab = self:GetProperty( "slc_timers" )
		if !tab then
			tab = self:SetProperty( "slc_timers", {} )
		end

		//return tab[name..self:SteamID()]
		return tab[name]
	end

	hook.Add( "SLCPlayerCleanup", "SLCPlayerTimers", function( p )
		local tab = p:GetProperty( "slc_timers" )
		if tab then
			for k, v in pairs( tab ) do
				if IsValid( v ) then
					v:Destroy()
				end
			end
		end
	end )
end