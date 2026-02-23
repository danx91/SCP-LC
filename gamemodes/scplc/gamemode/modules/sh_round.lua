ESCAPE_STATUS = 0
ESCAPE_TIMER = 0

ESCAPE_INACTIVE = 0
ESCAPE_ACTIVE = 1
ESCAPE_BLOCKED = 2

function IsRoundLive()
	return ROUND.active and !ROUND.infoscreen and !ROUND.preparing and !ROUND.post and !ROUND.aftermatch
end

function RemainingRoundTime()
	if !IsRoundLive() then return 0 end

	if CLIENT then
		local ct = CurTime()
		if !ROUND.time or ROUND.time < ct then return 0 end
		return ROUND.time - ct
	else
		local t = GetTimer( "SLCRound" )
		if !IsValid( t ) then return 0 end
		return t:GetRemainingTime()
	end
end

function RoundDuration()
	if !IsRoundLive() then return 0 end

	if CLIENT then
		return ROUND.duration or 0
	else
		local t = GetTimer( "SLCRound" )
		if !IsValid( t ) then return 0 end
		return t:GetTime()
	end
end

function PrintSCPNotice( tab )
	if !tab then
		tab = CLIENT and { LocalPlayer() } or  GetActivePlayers()
	elseif !istable( tab ) then
		tab = { tab }
	end

	local karma_enabled = CVAR.slc_scp_karma:GetInt() == 1

	for k, v in ipairs( tab ) do
		local penalty = v:GetSCPPenalty()
		if penalty <= 0 then
			local karma_mult = 1

			if karma_enabled then
				karma_mult =  math.ClampMap( v:GetPlayerKarma(), 0, 1000, 1, 1.2 )
			end

			local exponent = CVAR.slc_scp_chance_exponent:GetFloat()
			local chance = exponent <= 0 and 1 or math.ceil( ( -penalty + 1 ) ^ exponent * karma_mult )

			PlayerMessage( "scpready$"..chance.."#50,200,50", v )
		else
			PlayerMessage( "scpwait$"..penalty.."#200,50,50", v )
		end
	end
end