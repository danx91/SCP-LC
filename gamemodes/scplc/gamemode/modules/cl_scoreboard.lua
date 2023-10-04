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

--Higher value is sorted higher
local custom_ranks = {
	vip = {
		sorting = 100,
		color = Color( 180, 180, 15 ),
		func = function( ply )
			return ply:IsPremium()
		end,
	},

	--CREDITS - It grants NO benefits at all
	author = {
		sorting = 999,
		color = Color( 100, 25, 140 ),
		func = "76561198110788144"--Can be either SteamID64, table of SteamID64s or function with player as argument
	},
	/*contributor = {
		sorting = 15,
		color = Color( 60, 60, 175 ),
		func = "76561198110788144"
	},
	translator = {
		sorting = 17,
		color = Color( 190, 110, 30 ),
		func = "76561198110788144"
	},
	tester = {
		sorting = 19,
		color = Color( 125, 220, 30 ),
		func = "76561198110788144"
	},
	hunter = {
		sorting = 0,
		color = Color( 20, 200, 200 ),
		func = "76561198110788144"
	},
	donator = {
		sorting = 0,
		color = Color( 190, 50, 150 ),
		func = "76561198110788144"
	},
	*/
}

local web_ranks_status = 0

local function fetch_web_ranks()
	if web_ranks_status == 1 then return end

	web_ranks_status = 1
	print( "Fetching badges from github..." )

	http.Fetch( "https://danx91.github.io/SCP-LC/badges.min.json", function( body, size, head, code )
		print( "Badges: OK", code )

		if code != 200 then
			web_ranks_status = -1
			return
		end

		local tbl = util.JSONToTable( body )
		if !tbl then
			web_ranks_status = 0
			return
		end

		local ranks, users = 0, 0
		for k, v in pairs( tbl ) do
			custom_ranks[k] = {
				sorting = v.sorting,
				color = Color( v.color[1], v.color[2], v.color[3] ),
				func = v.ids
			}

			ranks = ranks + 1
			users = users + #v.ids
		end
		
		web_ranks_status = 2
		print( "Badges fully loaded!", "Badges: "..ranks, "Users: "..users )
	end, function( err )
		print( "BADGES FETCH ERROR", err )
		web_ranks_status = -1
	end )
end

if !DEVELOPER_MODE then
	timer.Simple( 10, function()
		fetch_web_ranks()
	end )
end

local player_ranks = {
	default = Color( 125, 125, 125 ),
	ranks = {
		user = false, --don't show
		superadmin = Color( 120, 15, 15 ),
		admin = Color( 90, 110, 130 ),
	}
}

function ScoreboardPlayerData( ply, ranks )
	if web_ranks_status == 0 then
		fetch_web_ranks()
	end

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

	return sorting, color
end

function ScoreboardPlayerRanks( ply, tab )
	tab.ranks = {}

	local rank = ply:GetUserGroup()
	local ignore = false
	for k, v in pairs( player_ranks.ranks ) do
		if k == rank then
			if v then
				local color = IsColor( v ) and v or player_ranks.default
				table.insert( tab.ranks, { k, color, 0 } )
			end

			ignore = true

			break
		end
	end

	if !ignore then
		table.insert( tab.ranks, { rank, player_ranks.default, 0 } )
	end

	for k, v in pairs( custom_ranks ) do
		local shouldhave = false

		if isstring( v.func ) then
			if ply:SteamID64() == v.func then
				shouldhave = true
			end
		elseif istable( v.func ) then
			for i, sid in ipairs( v.func ) do
				if ply:SteamID64() == sid then
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

	table.sort( tab.ranks, function( a, b ) return a[3] > b[3] end )
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
	SCOREBOARD:Remove()
	RunGUISkinFunction( "hide_scoreboard" )
end

hook.Add( "HUDPaint", "ScoreboardArrow", function()
	RunGUISkinFunction( "overlay_scoreboard" )
end )