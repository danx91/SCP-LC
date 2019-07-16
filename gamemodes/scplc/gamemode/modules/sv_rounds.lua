ROUNDS = {}

ROUNDS.dull = {
	name = "dull",
	init = function( self ) end,
	roundstart = function( self ) end,
	postround = function( self, winner ) end,
	endcheck = function( self ) return false end,
}

function addRoundType( name, tab, base )
	if base then
		local bc = ROUNDS[base]

		if bc then
			setmetatable( tab, { __index = bc } )
			tab.BaseClass = bc
		end
	end

	ROUNDS[name] = tab
end

addRoundType( "normal", {
	name = "normal",
	init = function( self, multi )
		SetupPlayers( multi )
		SpawnItems()

	end,
	roundstart = function( self )
		AddTimer( "EscapeTimer", 3, 0, CheckEscape )
		SetupSupportTimer()
		OpenSCPs()
	end,
	postround = function( self, winner )
		/*for k, v in pairs( GetActivePlayers() ) do
			local r = tonumber( v:GetPData( "scp_penalty", 0 ) ) - 1
			r = math.max( r, 0 )

			if r == 0 then
				v:PlayerMessage( "scpready#50,200,50" )
				//print( v, "can be scp" )
			else
				v:PlayerMessage( "scpwait".."$"..r.."#200,50,50" )
				//print( v, "must wait", r )
			end
		end*/
	end,
	endcheck = function( self )
		local plys = GetAlivePlayers()
		local teams = {}
		local lt  = nil
		local num = 0

		for k, v in pairs( plys ) do
			local t = v:SCPTeam()
			if !teams[t] then
				teams[t] = true
				lt = t
				num = num + 1
			end
		end

		if num == 0 then
			return true
		elseif num == 1 then
			return lt
		else
			local ret = {}
			for t1, v in pairs( teams ) do
				for t2, v in pairs( teams ) do
					if !SCPTeams.isAlly( t1, t2 ) then
						return false
					end
				end

				table.insert( ret, t1 )
			end

			return ret
		end

		return false
	end,
}, "dull" )

addRoundType( "multi", {
	name = "multi",
	init = function( self )
		self.BaseClass.init( self, true )
	end,
}, "normal" )