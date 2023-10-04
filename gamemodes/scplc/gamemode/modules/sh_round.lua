ESCAPE_STATUS = 0
ESCAPE_TIMER = 0

ESCAPE_INACTIVE = 0
ESCAPE_ACTIVE = 1
ESCAPE_BLOCKED = 2

function IsRoundLive()
	return ROUND.active and !ROUND.infoscreen and !ROUND.preparing and !ROUND.post
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