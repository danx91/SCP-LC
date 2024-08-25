function EFFECT:Init( data )
	local orig = data:GetOrigin() + Vector( 0, 0, 16 )
	local emitter = ParticleEmitter( orig, false )

	for i = 1, 5 do
		local particle = emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), orig )
		if particle then
			particle:SetDieTime( math.Rand( 1, 2 ) )
			particle:SetStartAlpha( 125 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 0 )
			particle:SetEndSize( math.random( 128, 196 ) )
			particle:SetRoll( math.random() * math.pi * 2 )
			particle:SetRollDelta( math.random() * 0.2 - 0.1 )
			particle:SetColor( 225, 15, 15 )
			particle:SetAirResistance( 75 )
			particle:SetVelocity( Vector( math.Rand( -5, 5 ), math.Rand( -5, 5 ), math.Rand( 16, 64 ) ) )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end