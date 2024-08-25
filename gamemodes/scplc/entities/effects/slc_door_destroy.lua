function EFFECT:Init( data )
	local orig = data:GetOrigin()

	local num = 12
	local ang = 2 * math.pi / num
	local emitter = ParticleEmitter( orig, false )

	for i = 1, num do
		local dir = Vector( math.sin( ang * i ), math.cos( ang * i ), 0 )

		local particle = emitter:Add( "particle/smokesprites_000"..math.random( 9 ), orig + dir * 50 )
		if particle then
			particle:SetDieTime( 2.5 )
			particle:SetStartAlpha( 225 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 96 )
			particle:SetEndSize( 128 )
			particle:SetRoll( math.random() * math.pi * 2 )
			particle:SetRollDelta( math.random() * 0.2 - 0.1 )
			particle:SetColor( 40, 35, 30 )
			particle:SetGravity( dir * 10 )
			particle:SetAirResistance( 100 )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end