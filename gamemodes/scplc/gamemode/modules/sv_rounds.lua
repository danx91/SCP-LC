ROUNDS = {}
local select_info = {}

ROUNDS.dull = {
	name = "dull",
	init = function( self ) end,
	roundstart = function( self ) end,
	postround = function( self, winner ) end,
	endcheck = function( self ) return false end,
	getwinner = function( self ) return false end,
}

function addRoundType( name, tab, base, chance )
	if base then
		local bc = ROUNDS[base]

		if bc then
			setmetatable( tab, { __index = bc } )
			tab.BaseClass = bc
		end
	end

	if isnumber( chance ) and number > 0 then
		select_info[name] = chance
	end

	ROUNDS[name] = tab
end

function selectRoundType() --TODO

end

addRoundType( "normal", {
	name = "normal",
	init = function( self, multi )
		SetupPlayers( multi )
		SpawnItems()
	end,
	roundstart = function( self )
		AddTimer( "EscapeTimer", 2, 0, CheckEscape )
		SetupSupportTimer()
		OpenSCPs()
	end,
	postround = function( self, winner )
		PrintSCPNotice()
	end,
	endcheck = function( self )
		local plys = GetAlivePlayers()
		local teams = {}
		local num = 0

		for k, v in pairs( plys ) do
			local t = v:SCPTeam()
			if !teams[t] then
				teams[t] = true
				num = num + 1
			end
		end

		if num == 0 then
			return true
		else
			for t1, v in pairs( teams ) do
				for t2, v in pairs( teams ) do
					if !SCPTeams.isAlly( t1, t2 ) then
						return false
					end
				end
			end

			return true
		end
	end,
	getwinner = function( self )
		if #player.GetAll() < CVAR.minplayers:GetInt() then return true end --TODO check

		local plys = GetAlivePlayers()
		local teams = {}
		local num = 0

		for k, v in pairs( plys ) do
			local t = v:SCPTeam()
			if !teams[t] then
				teams[t] = true
				num = num + 1
			end
		end

		//if num == 0 then
			//return false
		//else
			local hs = SCPTeams.highestScore()

			if hs then
				if istable( hs ) then
					local allies = SCPTeams.getAllies( hs[1], true )
					local lookup = CreateLookupTable( allies )

					for k, v in pairs( hs ) do
						if !lookup[v] then
							return false
						end
					end

					return allies
				else
					local winner = SCPTeams.getAllies( hs, true )

					if #winner == 1 then
						winner = winner[1]
					end

					return winner
				end
			else
				return false
			end
		//end
	end
}, "dull" )

addRoundType( "multi", {
	name = "multi",
	init = function( self )
		self.BaseClass.init( self, true )
	end,
}, "normal" )