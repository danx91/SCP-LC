function EFFECT:Init( data )
	local orig = data:GetOrigin() + Vector( 0, 0, 16 )
	local radius = data:GetRadius()

	local num = 6
	local sang = 360 / num
	local ang = Angle( 0, 0, 0 )
	local up = Vector( 0, 0, 1 )
	local right = Vector( 0, 1, 0 )

	local emitter = ParticleEmitter( orig, false )

	for i = 1, 4 do
		for j = 1, num do
			local particle = emitter:Add( "effects/blood2", orig )
			if particle then
				particle:SetDieTime( 0.75 )
				particle:SetStartAlpha( 175 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 0 )
				particle:SetEndSize( 96 * radius )
				particle:SetRoll( math.random() * math.pi * 2 )
				particle:SetRollDelta( math.random() * 0.2 - 0.1 )
				particle:SetColor( 5, 75, 5 )
				particle:SetGravity( ang:Forward() * 500 * radius )
				particle:SetAirResistance( 0 )
			end

			ang:RotateAroundAxis( up, sang )
		end

		ang.y = 0
		ang:RotateAroundAxis( right, -22.5 )
	end

	emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end