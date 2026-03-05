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

function SelectRoundType() --TODO add round types

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
		local teams = {}
		local num = 0

		for k, v in pairs( player.GetAll() ) do
			local t = v:SCPTeam()
			if t == TEAM_SPEC or !v:Alive() then continue end

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
					if SCPTeams.IsEnemy( t1, t2 ) then
						return false
					end
				end
			end

			return true
		end
	end,
	getwinner = function( self )
		if #player.GetAll() < CVAR.slc_min_players:GetInt() then return true end

		local teams = {}
		local num = 0

		for k, v in pairs( player.GetAll() ) do
			local t = v:SCPTeam()
			if t == TEAM_SPEC or !v:Alive() then continue end

			if !teams[t] then
				teams[t] = true
				num = num + 1
			end
		end

		print( "Check end", num )
		PrintTable( teams )

		if num == 0 then
			return false
		else
			local hs = SCPTeams.HighestScore()
			if !hs then return false end

			local group = SCPTeams.GetTeamsByGroup( hs[1] )
			for i, v in ipairs( group ) do
				print( "Checking team", v )
				if teams[v] then
					num = num - 1
				end
			end

			print( "DONE", num )
			if num <= 0 then
				PrintTable( group )
				return group
			end
		end
	end
}, "dull" )

AddRoundType( "multi", {
	name = "multi",
	init = function( self )
		self.BaseClass.init( self, true )
	end,
}, "normal" )