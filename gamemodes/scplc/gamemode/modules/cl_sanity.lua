local insane_effects = {}
function InsaneTick( ply )
	if !ply.NextSanityEffect then ply.NextSanityEffect = 0 end
	if ply.NextSanityEffect < CurTime() then
		if math.random( 1, 2 ) == 1 then
			local id = math.random( #insane_effects )
			local eff = insane_effects[id]

			if eff then
				ply.InsaneEffectID = id
				ply.NextSanityEffect = CurTime() + eff[1]
				eff[2]( ply )
			end
		end
	end
end

function InterruptInsane( ply )
	local id = ply.InsaneEffectID
	ply.InsaneEffectID = nil

	local eff = insane_effects[id]
	if eff and eff[3] then
		eff[3]( ply )
	end
end

function AddInsaneEffect( delay, func, stop )
	table.insert( insane_effects, { delay, func, stop } )
end

--[[-------------------------------------------------------------------------
Whispers
---------------------------------------------------------------------------]]
AddSounds( "SLCEffects.Whispers", "scp_lc/effects/insane/whispers%i.ogg", 0, { 0.75, 1 }, { 90, 110 }, CHAN_STATIC, 1, 3 )

AddInsaneEffect( 12, function( ply )
	ply:EmitSound( "SLCEffects.Whispers" )
end, function( ply )
	ply:StopSound( "SLCEffects.Whispers" )
end )

--[[-------------------------------------------------------------------------
Insane Screen Effect
---------------------------------------------------------------------------]]
AddInsaneEffect( 5, function( ply )
	ply.InsaneScreenEffect = CurTime() + 5
	ply.InsaneKickViewNext = 0
end, function( ply )
	ply.InsaneScreenEffect = 0
end )

hook.Add( "SLCScreenMod", "InsaneBlur", function()
	local ply = LocalPlayer()

	if ply.InsaneScreenEffect and ply.InsaneScreenEffect > CurTime() then
		local i = ( ply.InsaneScreenEffect - CurTime() ) * 0.18
		DrawMotionBlur( 0.15, i, 0.075 )
	end
end )

hook.Add( "StartCommand", "InsaneKickView", function( ply, cmd )
	if ply.InsaneScreenEffect and ply.InsaneScreenEffect > CurTime() then
		if ply.InsaneKickViewNext < CurTime() then
			ply.InsaneKickViewNext = CurTime() + 1

			local ang = cmd:GetViewAngles()
			ang.yaw = ang.yaw + math.random( -30, 30 )
			ang.pitch = ang.pitch + math.random( -30, 30 )
			ply.InsaneKickViewAngle = ang
		end

		if ply.InsaneKickViewAngle then
			local ang = cmd:GetViewAngles()
			ang.yaw = math.ApproachAngle( ang.yaw, ply.InsaneKickViewAngle.yaw, (ply.InsaneKickViewAngle.yaw - ang.yaw) * 0.02 )
			ang.pitch = math.ApproachAngle( ang.pitch, ply.InsaneKickViewAngle.pitch, (ply.InsaneKickViewAngle.pitch - ang.pitch) * 0.02 )
			//ang = LerpAngle( 0.01, ang, ply.InsaneKickViewAngle )
			//ang.roll = 0
			cmd:SetViewAngles( ang )
		end
	end
end )

--[[-------------------------------------------------------------------------
Blink Effect
---------------------------------------------------------------------------]]
sound.Add{
	name = "SLCEffects.Horror",
	sound = "scp_lc/scp/173/Horror/Horror2.ogg",
	volume = 1,
	level = 0,
	pitch = 100,
	channel = CHAN_STATIC,
}

AddInsaneEffect( 11, function( ply )
	ply.InsaneBlinkChange = 1
end, function( ply )
	ply.InsaneBlinkChangeOn = false
end )

hook.Add( "SLCBlink", "SLCInsaneBlink", function( duration, delay )
	local ply = LocalPlayer()

	if ply.InsaneBlinkChange == 1 then
		ply.InsaneBlinkChange = 2
		ply.InsaneBlinkChangeOn = true

		ply:EmitSound( "SLCEffects.Horror" )
	elseif ply.InsaneBlinkChange == 2 then
		ply.InsaneBlinkChange = 0
		ply.InsaneBlinkChangeOn = false
	end
end )

hook.Add( "SLCScreenMod", "SLCSanityEffects", function( clr )
	local ply = LocalPlayer()

	if ply.InsaneBlinkChangeOn then
		clr.contrast = 2
		clr.brightness = -0.1
		clr.mul_r = 2
	end
end )