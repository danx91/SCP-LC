if SERVER then
	util.AddNetworkString( "SLCAnimController" )
end

local action_bytes = 2
local ANIM_PLAY = 0
local ANIM_STOP = 1

local PLAYER = FindMetaTable( "Player" )

function PLAYER:PlaySequence( seq, loop, speed )
	if seq == -1 then return end
	loop = !!loop
	speed = speed or 1

	if SERVER then
		net.Start( "SLCAnimController" )
			net.WriteUInt( ANIM_PLAY, action_bytes )
			net.WriteInt( seq, 32 )
			net.WriteBool( loop )
			net.WriteDouble( speed )
		net.SendPVS( self:GetPos() )
	end

	local queue = self._slc_anim_controller
	if !queue then
		queue = {}
		self._slc_anim_controller = queue
	end

	table.insert( queue, {
		sequence = seq,
		loop = loop,
		speed = speed,
		start = CurTime(),
		duration = self:SequenceDuration( seq ),
	} )
end

function PLAYER:PlayActivity( act, ... )
	self:PlaySequence( self:SelectWeightedSequence( act ), ... )
end

hook.Add( "CalcMainActivity", "SLCAnimController", function( ply )
	local queue = ply._slc_anim_controller
	if !queue or !queue[1] then return end

	local anim = queue[1]
	local cycle = ( CurTime() - anim.start ) / anim.duration * anim.speed

	if cycle >= 1 and !anim.loop then
		cycle = 1
		table.remove( queue, 1 )
	end

	ply:SetCycle( cycle % 1 )

	return ACT_INVALID, anim.sequence
end )

hook.Add( "SLCPlayerCleanup", "SLCAnimController", function( ply )
	ply._slc_anim_controller = {}
end )

if CLIENT then
	net.Receive( "SLCAnimController", function( len )
		local action = net.ReadUInt( action_bytes )

		if action == ANIM_PLAY then
			LocalPlayer():PlaySequence( net.ReadInt( 32 ), net.ReadBool(), net.ReadDouble() )
		end
	end )
end