--Lower values are sorted higher
--WARNING!! Don't use values higher than 20 and lower than -20!!
local SORT = {
	inactive = 20,
	unknown = 19,
	other = 16,
	[TEAM_SPEC] = 15,
	[TEAM_CLASSD] = 14,
	[TEAM_SCI] = 13,
	[TEAM_GUARD] = 12,
	[TEAM_MTF] = 11,
	[TEAM_CI] = 10,
	[TEAM_GOC] = 9,
	[TEAM_SCP] = 8,
	teammates = 1,
	localplayer = 0,
}

--Higher value is sorted higher
local custom_badges = {
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
		func = "76561198110788144" --Can be either SteamID64, table of SteamID64s or function with player as argument
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
	},*/
	
}

--[[-------------------------------------------------------------------------
IMPORTANT - PLEASE READ!

Badges grant absolutely NOTHING other than just badge itself on scoreboard, it grants NO in-game benefits at all.
If you don't like idea of fetching data from gamemode github, you can disable it, but it's used to give credits for people who helped me a lot
with the development of the gamemode, so please consider leaving it as is (of course you can add your custom badges).

If you don't trust this code (or me), trust facts: there is no malicious thing this code can do. The worst possible thing I (or person who somehow hacked into my github)
can do with this, is to load thousands of useless keys of data, however JSONToTable will fail after reaching 15k keys so no harm can be done anyway.
---------------------------------------------------------------------------]]

local web_badges_status = 0

local function fetch_web_badges()
	if web_badges_status == 1 then return end

	web_badges_status = 1
	print( "Fetching badges from github..." )

	http.Fetch( "https://danx91.github.io/SCP-LC/badges.min.json", function( body, size, head, code )
		print( "Badges: OK", code )

		if code != 200 then
			web_badges_status = -1
			return
		end

		local tbl = util.JSONToTable( body )
		if !tbl then
			web_badges_status = 0
			return
		end

		local badges, users = 0, 0
		for k, v in pairs( tbl ) do
			custom_badges[k] = {
				sorting = v.sorting,
				color = Color( v.color[1], v.color[2], v.color[3] ),
				func = v.ids
			}

			badges = badges + 1
			users = users + #v.ids
		end
		
		web_badges_status = 2
		print( "Badges fully loaded!", "Badges: "..badges, "Users: "..users )
	end, function( err )
		print( "BADGES FETCH ERROR", err )
		web_badges_status = -1
	end )
end

if !DEVELOPER_MODE then
	timer.Simple( 10, function()
		fetch_web_badges()
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

function ScoreboardPlayerData( ply )
	if !DEVELOPER_MODE and web_badges_status == 0 then
		fetch_web_badges()
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

function ScoreboardPlayerBadges( ply, tab )
	local badges = {}

	if tab then
		tab.badges = badges
	end

	local rank = ply:GetUserGroup()
	local group_rank = player_ranks.ranks[rank]
	if group_rank then
		table.insert( badges, { rank, IsColor( group_rank ) and group_rank or player_ranks.default, 0 } )
	elseif group_rank != false then
		table.insert( badges, { rank, player_ranks.default, 0 } )
	end

	for k, v in pairs( custom_badges ) do
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
			table.insert( badges, { k, v.color, v.sorting } )
		end
	end

	table.sort( badges, function( a, b ) return a[3] > b[3] end )

	return badges
end

function AddRankBadge( rank, color )
	player_ranks.ranks[rank] = color
end

function GM:ScoreboardShow()
	if RunGUISkinFunction( "eq", "is_visible" ) then return end
	
	ScoreboardVisible = true
	ShowGUIElement( "scoreboard" )
end

function GM:ScoreboardHide()
	ScoreboardVisible = false
	HideGUIElement( "scoreboard" )
end