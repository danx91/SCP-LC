--Lower value is sorted higher
--WARNING!! Don't use values higher than 20 and lower than -20!!
local SORT = {
	inactive = 20,
	unknown = 19,
	other = 16,
	[TEAM_SPEC] = 15,
	[TEAM_CLASSD] = 14,
	[TEAM_SCI] = 13,
	[TEAM_MTF] = 12,
	teammates = 5,
	localplayer = 0,
}

local customRanks = {
	vip = {
		sorting = 17,
		color = Color( 220, 200, 35, 100 ),
		func = function( ply )
			return ply:IsPremium()
		end,
	},

	--CREDITS - It grants NO benefits at all
	author = {
		sorting = -20,
		color = Color( 115, 25, 155, 100 ),
		func = "76561198110788144"--Can be either SteamID64, table of SteamID64s or function with player as argument
	},
	tester = {
		sorting = 19,
		color = Color( 10, 170, 115 ),
		func = { "76561198152379830", "76561198246441626", "76561198210338085", "76561198177855619", "76561198262604873", "76561198148991634", "76561198807020481" }
	},
	contributor = {
		sorting = 19,
		color = Color( 20, 100, 20 ),
		func = { "76561198179611206", "76561198108864618" }
	},
	translator = {
		sorting = 19,
		color = Color( 220, 110, 30 ),
		func = { "76561198246441626", "76561198179611206", "76561198121822134" },
	}
}

local playerRanks = {
	default = Color( 125, 125, 125 ),
	ranks = {
		user = false, --don't show
		superadmin = Color( 10, 125, 190, 100 ),
	}
}

function ScoreboardPlayerData( ply, ranks )
	local lp = LocalPlayer()
	local sorting = ply:IsActive() and SORT.unknown or SORT.inactive
	local color = !ply:IsActive() and Color( 100, 100, 100, 255 )

	local id = GetPlayerID( ply )
	if id and id.team then
		color = SCPTeams.GetColor( id.team )

		if id.team == lp:SCPTeam() then
			sorting = SORT.teammates
		elseif SORT[id.team] then
			sorting = SORT[id.team]
		else
			sorting = SORT.other
		end
	end

	if ply == lp then
		sorting = SORT.localplayer
	end

	if ranks and ranks[1] then
		if ranks[1][3] < sorting then
			sorting = ranks[1][3]
		end
	end

	return sorting, color
end

function ScoreboardPlayerRanks( ply, tab )
	tab.ranks = {}

	local rank = ply:GetUserGroup()
	local ignore = false
	for k, v in pairs( playerRanks.ranks ) do
		if k == rank then
			if v then
				local color = IsColor( v ) and v or playerRanks.default
				table.insert( tab.ranks, { k, color, 20 } )
			end

			ignore = true

			break
		end
	end

	if !ignore then
		table.insert( tab.ranks, { rank, playerRanks.default, 20 } )
	end

	for k, v in pairs( customRanks ) do
		local shouldhave = false

		if isstring( v.func ) then
			if ply:SteamID64() == v.func then
				shouldhave = true
			end
		elseif istable( v.func ) then
			for i, v in ipairs( v.func ) do
				if ply:SteamID64() == v then
					shouldhave = true
					break
				end
			end
		elseif isfunction( v.func ) then
			shouldhave = v.func( ply )
		end

		if shouldhave then
			table.insert( tab.ranks, { k, v.color, v.sorting } )
		end
	end

	table.sort( tab.ranks, function( a, b ) return a[3] < b[3] end )
end

/*function GM:HUDDrawScoreBoard() --TODO: buttons to class viewer, stat viewer and settings
	if !ScoreboardVisible then return end

	//local w, h = ScrW(), ScrH()

	
end*/

function GM:ScoreboardShow()
	ScoreboardVisible = true

	HideEQ()

	if !IsValid( SCOREBOARD ) then
		RunGUISkinFunction( "create_scoreboard" )
	else
		SCOREBOARD:Show()
		RunGUISkinFunction( "show_scoreboard" )
	end
end

function GM:ScoreboardHide()
	ScoreboardVisible = false

	SCOREBOARD:Hide()
	//SCOREBOARD:Remove()
	RunGUISkinFunction( "hide_scoreboard" )
end

hook.Add( "HUDPaint", "ScoreboardArrow", function()
	RunGUISkinFunction( "overlay_scoreboard" )
end )