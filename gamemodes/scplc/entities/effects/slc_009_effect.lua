function EFFECT:Init( data )
	local orig = data:GetOrigin() + Vector( 0, 0, 16 )
	local emitter = ParticleEmitter( orig, false )

	for i = 1, 5 do
		local particle = emitter:Add( "particle/smokesprites_000"..SLCRandom( 1,9 ), orig )
		if particle then
			particle:SetDieTime( SLCRandom:NextFloat( 1, 2 ) )
			particle:SetStartAlpha( 125 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 0 )
			particle:SetEndSize( SLCRandom( 128, 196 ) )
			particle:SetRoll( SLCRandom() * math.pi * 2 )
			particle:SetRollDelta( SLCRandom() * 0.2 - 0.1 )
			particle:SetColor( 225, 15, 15 )
			particle:SetAirResistance( 75 )
			particle:SetVelocity( Vector( SLCRandom:NextFloat( -5, 5 ), SLCRandom:NextFloat( -5, 5 ), SLCRandom:NextFloat( 16, 64 ) ) )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end