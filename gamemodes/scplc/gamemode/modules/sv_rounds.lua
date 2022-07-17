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

function AddRoundType( name, tab, base, chance )
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

function SelectRoundType() --TODO

end

AddRoundType( "normal", {
	name = "normal",
	init = function( self, multi )
		SetupPlayers( multi )
		hook.Run( "SpawnItems" )

		DestroyAll()
		UseAll()
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
			for t1, _ in pairs( teams ) do
				for t2, _ in pairs( teams ) do
					if !SCPTeams.IsAlly( t1, t2 ) then
						return false
					end
				end
			end

			return true
		end
	end,
	getwinner = function( self )
		if #player.GetAll() < CVAR.slc_min_players:GetInt() then return true end

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
			local hs = SCPTeams.HighestScore()

			if hs then
				if istable( hs ) then
					local allies = SCPTeams.GetAllies( hs[1], true )
					local lookup = CreateLookupTable( allies )

					for k, v in pairs( hs ) do
						if !lookup[v] then
							return false
						end
					end

					return allies
				else
					local winner = SCPTeams.GetAllies( hs, true )

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

AddRoundType( "multi", {
	name = "multi",
	init = function( self )
		self.BaseClass.init( self, true )
	end,
}, "normal" )