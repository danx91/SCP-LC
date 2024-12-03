--[[-------------------------------------------------------------------------
This library provides JS-like promise that allows you to create flat async code.
It follows MDN description of promise and guarantees:
	1. Cllback added with Then() will never be called faster than in the next tick
	2. Callbacks will be called even if they were added after promise was resolved or rejected
	3. Multiple callbacks can be added. They will be invoked one after another, in the order in which they were added
	4. IMPORTANT: All LUA errors inside promise ARE REDIRECTED to catch method and will produce no error!
	5. Returning promise in Finally, adds it to execution chain, but returned value is ignored

Promises support chaining and internal error catching.
For more info how to use promises, visit: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises
---------------------------------------------------------------------------]]

PROMISE_PENDING = 0
PROMISE_FULFILLED = 1
PROMISE_REJECTED = 2

SLCPromise = {}
SLCPromise._ISPROMISE = true
SLCPromise._STATUS = PROMISE_PENDING

function SLCPromise:New( func )
	local tab = setmetatable( {
		Handler = {},
	}, { __index = SLCPromise } )

	if func then
		func( function( data )
			tab:Resolve( data )
		end, function( err )
			tab:Reject( err )
		end )
	end

	return tab
end

function SLCPromise:Resolve( data )
	NextTick( function()
		if self._STATUS == PROMISE_PENDING then
			self._STATUS = PROMISE_FULFILLED
			self._RESULT = data

			for i, v in ipairs( self.Handler ) do
				v( true, data )
			end
		end
	end )
end

function SLCPromise:Reject( err )
	NextTick( function()
		if self._STATUS == PROMISE_PENDING then
			self._STATUS = PROMISE_REJECTED
			self._RESULT = err

			for i, v in ipairs( self.Handler ) do
				v( false, err )
			end
		end
	end )
end

function SLCPromise:Then( success, failure )
	local ret = SLCPromise()

	local func = function( status, data )
		if status then
			if success then
				local pcall_status, then_return = pcall( success, data )
				if pcall_status then
					if type( then_return ) == "table" and then_return._ISPROMISE then
						then_return:Then( function( new_data )
							ret:Resolve( new_data )
						end, function( err )
							ret:Reject( err )
						end )
					else
						ret:Resolve( then_return )
					end
				else
					ret:Reject( then_return )
				end
			else
				ret:Resolve( data )
			end
		else
			if failure then
				local pcall_status, then_return = pcall( failure, data )
				if pcall_status then
					if type( then_return ) == "table" and then_return._ISPROMISE then
						then_return:Then( function( new_data )
							ret:Resolve( new_data )
						end, function( err )
							ret:Reject( err )
						end )
					else
						ret:Resolve( then_return )
					end
				else
					ret:Reject( then_return )
				end
			else
				ret:Reject( data )
			end
		end
	end

	if self._STATUS == PROMISE_PENDING then
		table.insert( self.Handler, func )
	elseif self._STATUS == PROMISE_FULFILLED then
		NextTick( func, true, self._RESULT )
	elseif self._STATUS == PROMISE_REJECTED then
		NextTick( func, false, self._RESULT )
	end

	return ret
end

function SLCPromise:Catch( func )
	return self:Then( nil, func )
end

function SLCPromise:Finally( func )
	local function fn( val )
		local ret = func( val )
		if !istable( ret ) or !ret._ISPROMISE then
			return val
		end

		return SLCPromise( function( resolve, reject )
			ret:Then( function()
				resolve( val )
			end, function()
				reject( val )
			end )
		end )
	end

	return self:Then( fn, fn )
end

function SLCPromise:GetStatus()
	return self._STATUS
end

setmetatable( SLCPromise, { __call = SLCPromise.New } )

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function ispromise( arg )
	return istable( arg ) and arg._ISPROMISE == true
end

function SLCPromiseJoin( ... )
	local tab = { ... }
	if #tab == 1 and istable( tab[1] ) and !tab[1]._ISPROMISE then
		tab = tab[1]
	end

	local num = table.Count( tab )

	local ret = {}
	local p = SLCPromise()

	if num == 0 then
		p:Resolve()
		return p
	end

	for i, v in pairs( tab ) do
		if ispromise( v ) then
			v:Then( function( data )
				ret[i] = data
				num = num - 1

				if num <= 0 then
					p:Resolve( ret )
				end
			end, function( err )
				ret[i] = err
				num = num - 1

				if num <= 0 then
					p:Resolve( ret )
				end
			end )
		else
			ret[i] = v
			num = num - 1

			if num <= 0 then
				p:Resolve( ret )
			end
		end
	end

	return p
end

function SLCPromiseAny( ... )
	local p = SLCPromise()

	for i, v in pairs( { ... } ) do
		v:Then( function( data )
			p:Resolve( data )
		end )
	end

	return p
end

function SLCToPromise( obj )
	if ispromise( obj ) then
		return obj
	else
		return SLCPromise( function( resolve )
			resolve( obj )
		end )
	end
end

function SLCPromisify( func )
	return function( ... )
		local tab = { ... }
		return SLCPromise( function( resolve )
			func( tab[1], function( ... )
				if select( "#", ... ) <= 1 then
					resolve( ... )
				else
					resolve( { ... } )
				end
			end, unpack( tab, 2 ) )
		end )
	end
end

--[[-------------------------------------------------------------------------
Default promises
---------------------------------------------------------------------------]]
hook.Add( "SLCFullyLoaded", "DefaultPromises", function()
	SLCPromise.Resolved = SLCPromise()
	SLCPromise.Resolved:Resolve()

	SLCPromise.Rejected = SLCPromise()
	SLCPromise.Rejected:Reject()
end )