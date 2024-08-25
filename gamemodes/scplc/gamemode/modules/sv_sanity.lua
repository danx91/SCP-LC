hook.Add( "PlayerPostThink", "SLCSanity", function( ply )
	if !ply.NSanity then ply.NSanity = 0 end
	if !ply.NSanityRegen then ply.NSanityRegen = 0 end

	if !SCPTeams.HasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) then return end
	if ply.NSanity < CurTime() then
		ply.NSanity = CurTime() + 10

		if hook.Run( "SLCCalcSanity", ply ) != true then
			local sum = 0
			local num = 0

			for i, v in ipairs( FindInCylinder( ply:GetPos(), 500, 0, 128, nil, nil, player.GetAll() ) ) do
				if v == ply or !SCPTeams.HasInfo( v:SCPTeam(), SCPTeams.INFO_HUMAN ) then continue end
				local f = v:GetSanity() / v:GetMaxSanity()

				if f < 0.2 or f >= 0.9 then
					num = num + 2
					sum = sum + 2 * f
				else
					num = num + 1
					sum = sum + f
				end
			end

			local sanity = ply:GetSanity()
			local maxsanity = ply:GetMaxSanity()
			local target = math.ceil( maxsanity * ( sum / num ) )
			local diff = target - sanity

			if math.abs( diff ) > 10 then
				sanity = math.Clamp( math.floor( sanity + diff * 0.1 ), 0, maxsanity )
				ply:SetSanity( sanity )
			end

			if sanity == 0 and !ply:HasEffect( "insane" ) then
				ply:ApplyEffect( "insane" )
			end
		end

		if ply.NSanityRegen < CurTime() then
			ply.NSanityRegen = CurTime() + 5

			ply:AddSanity( 1 )
		end
	end
end )

SANITY_TYPE = {}
local sanity_callback = {}
function AddSanityType( name, func )
	local id = SCPTeams.AddTeamInfo( "SANITY_VULNERABLE_TO_"..name )
	SANITY_TYPE[name] = id
	sanity_callback[id] = func
end

local PLAYER = FindMetaTable( "Player" )

function PLAYER:TakeSanity( num, sanitytype, data )
	if !SCPTeams.HasInfo( self:SCPTeam(), SCPTeams.INFO_HUMAN ) then return end

	local new = hook.Run( "SLCPlayerSanityChange", self, sanitytype, num, data )

	if new == true then
		return
	end

	if isnumber( new ) then
		num = new
	end

	if sanitytype then
		if SCPTeams.HasInfo( self:SCPTeam(), sanitytype ) then
			num = num * 2
		end
	end

	//print( "taking sanity", self, sanitytype, math.ceil( num ) )
	self:AddSanity( -math.ceil( num ) )
end

local suppress = false
local fov = 53
function SanityEvent( amount, sanitytype, origin, distance, inflictor, victim )
	if suppress then
		suppress = false
		return
	end

	local tab = {}

	for i, v in ipairs( FindInCylinder( origin, distance, -1000, 1000, nil, MASK_SOLID_BRUSHONLY, SCPTeams.GetPlayersByInfo( SCPTeams.INFO_HUMAN ) ) ) do
		local pos = v:EyePos()
		local eang = v:EyeAngles().yaw
		local tang = ( pos - origin ):Angle().yaw

		if eang < 0 then eang = 360 + eang end
		if tang < 0 then tang = 360 + tang end

		local diff = eang - tang
		if diff < 0 then diff = 360 + diff end

		if math.abs( diff - 180 ) < fov then
			table.insert( tab, { ply = v, amount = amount, sanitytype = sanitytype } )
		end
	end

	hook.Run( "SLCOnSanityEvent", tab, sanitytype, inflictor, victim )

	if sanitytype then
		local cb = sanity_callback[sanitytype]
		if cb then
			cb( tab, inflictor, victim )
		end
	end

	for k, v in pairs( tab ) do
		if v.amount != 0 then
			v.ply:TakeSanity( v.amount, v.sanitytype )
		end
	end
end

function SuppressNextSanityEvent()
	suppress = true
end

function UnsuppressSanityEvent()
	suppress = false
end

AddSanityType( "DEATH", function( data, inflictor, victim )
	for k, v in pairs( data ) do
		if IsValid( inflictor ) and inflictor:IsPlayer() and inflictor:SCPTeam() == TEAM_SCP then
			v.sanitytype = SANITY_TYPE.ANOMALY
		elseif v.ply == inflictor and v.sanitytype == SANITY_TYPE.DEATH then
			local wep = victim:GetActiveWeapon()
			if !IsValid( wep ) or !SLC_WEAPONS_REG[wep:GetClass()] then
				table.insert( data, {
					ply = v.ply,
					sanitytype = SANITY_TYPE.KILL,
					amount = v.amount
				} )
			end
		end
	end
end )
AddSanityType( "KILL" )
AddSanityType( "ANOMALY" )

SCPTeams.AddInfo( TEAM_CLASSD, SCPTeams.INFO_SANITY_VULNERABLE_TO_ANOMALY )
SCPTeams.AddInfo( TEAM_SCI, SCPTeams.INFO_SANITY_VULNERABLE_TO_KILL )