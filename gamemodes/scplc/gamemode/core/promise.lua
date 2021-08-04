--[[-------------------------------------------------------------------------
This library provides JS-like promise that allows you to create flat async code.
It follows MDN description of promise and guarantees:
    1. Cllback added with Then() will never be called faster than in the next tick
    2. Callback will be called even if they were added after promise was resolved or rejected
    3. Multiple callback can be added. They will be invoked one after another, in the order in which they were added

Promises support chaining and internal error catching.
For more info how to use promises, visit: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises
---------------------------------------------------------------------------]]

PROMISE_PENDING = 0
PROMISE_FULFILLED = 1
PROMISE_REJECTED = 2

Promise = {}
Promise._ISPROMISE = true
Promise._STATUS = PROMISE_PENDING

function Promise:New( func )
    local tab = setmetatable( {
        Handler = {},
    }, { __index = Promise } )

    if func then
        func( function( data )
            tab:Resolve( data )
        end, function( err )
            tab:Reject( err )
        end )
    end

    return tab
end

function Promise:Resolve( data )
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

function Promise:Reject( err )
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

function Promise:Then( success, failure )
    local ret = Promise()

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

function Promise:Catch( func )
    return self:Then( nil, func )
end

function Promise:GetStatus()
    return self._STATUS
end

setmetatable( Promise, { __call = Promise.New } )