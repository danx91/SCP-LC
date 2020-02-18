hook.Add( "PlayerPostThink", "SLCSanity", function( ply )
	if !ply.NSanity then ply.NSanity = 0 end
	if !ply.NSanityRegen then ply.NSanityRegen = 0 end

	if SCPTeams.hasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) then
		if ply.NSanity < CurTime() then
			ply.NSanity = CurTime() + 10

			if hook.Run( "SLCCalcSanity", ply ) != true then
				local sum = 0
				local num = 0

				for k, v in pairs( FindInCylinder( ply:GetPos(), 500, 0, 128, nil, nil, player.GetAll() ) ) do
					if v != ply and SCPTeams.hasInfo( v:SCPTeam(), SCPTeams.INFO_HUMAN ) then
						local f = v:GetSanity() / v:GetMaxSanity()

						if f < 0.2 or f >= 0.9 then
							num = num + 2
							sum = sum + 2 * f
						else
							num = num + 1
							sum = sum + f
						end
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

				if sanity / maxsanity < 0.1 and !ply:HasEffect( "insane" ) then
					ply:ApplyEffect( "insane" )
				end
			end

			if ply.NSanityRegen < CurTime() then
				ply.NSanityRegen = CurTime() + 30

				ply:AddSanity( 1 )
			end
		end
	end
end )

SANITY_TYPE = {}
local sanity_callback = {}
function AddSanityType( name, func )
	local id = SCPTeams.addTeamInfo( "SANITY_VULNERABLE_TO_"..name )
	SANITY_TYPE[name] = id
	sanity_callback[id] = func
end

local ply = FindMetaTable( "Player" )

function ply:TakeSanity( num, sanitytype )
	if !SCPTeams.hasInfo( self:SCPTeam(), SCPTeams.INFO_HUMAN ) then return end

	local new = hook.Run( "SLCPlayerSanityChange", self, sanitytype, num )

	if new == true then
		return
	end

	if isnumber( new ) then
		num = new
	end

	if SCPTeams.hasInfo( self:SCPTeam(), sanitytype ) then
		num = num * 2
	end

	//print( "taking sanity", self, sanitytype, math.ceil( num ) )
	self:AddSanity( -math.ceil( num ) )
end

local fov = 53 -- = math.deg( math.atan( math.tan( math.rad( ply:GetFOV() ) / 2 ) * ( 16 / 9 ) / ( 4 / 3 ) ) ) // player fov is almost always 90
function SanityEvent( amount, sanitytype, origin, distance, inflictor, victim )
	local tab = {}

	for k, v in pairs( FindInCylinder( origin, distance, -1000, 1000, nil, MASK_SOLID_BRUSHONLY, SCPTeams.getPlayersByInfo( SCPTeams.INFO_HUMAN ) ) ) do
		local pos = v:EyePos()
		local eang = v:EyeAngles().yaw
		local tang = (pos - origin):Angle().yaw

		if eang < 180 then eang = 360 + eang end
		if tang < 180 then tang = 360 + tang end

		local diff = eang - tang
		if diff < 180 then diff = 360 + diff end

		if math.abs( diff - 180 ) < fov then
			table.insert( tab, { ply = v, amount = amount, sanitytype = sanitytype } )
		end
	end

	hook.Run( "SLCOnSanityEvent", tab, sanitytype, inflictor, victim )

	local cb = sanity_callback[sanitytype]
	if cb then
		cb( tab, inflictor, victim )
	end

	for k, v in pairs( tab ) do
		if v.amount != 0 then
			v.ply:TakeSanity( v.amount, v.sanitytype )
		end
	end
end

AddSanityType( "DEATH", function( data, inflictor, victim )
	for k, v in pairs( data ) do
		if IsValid( inflictor ) and inflictor:IsPlayer() and inflictor:SCPTeam() == TEAM_SCP then
			v.sanitytype = SANITY_TYPE.ANOMALY
		elseif v.ply == inflictor and v.sanitytype == SANITY_TYPE.DEATH then
			local wep = victim:GetActiveWeapon()

			if !IsValid( wep ) or !string.match( wep:GetClass(), "^cw_" ) then
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

SCPTeams.addInfo( TEAM_CLASSD, SCPTeams.INFO_SANITY_VULNERABLE_TO_ANOMALY )
SCPTeams.addInfo( TEAM_SCIENT, SCPTeams.INFO_SANITY_VULNERABLE_TO_KILL )

//print( SANITY_TYPE.DEATH, SANITY_TYPE.KILL, SANITY_TYPE.ANOMALY )

--TODO: Rem
/*concommand.Add( "reducesanity", function( ply, cmd, args )
	Entity( tonumber( args[1] ) ):TakeSanity( tonumber( args[2] ), tonumber( args[3] ) )
end )*/