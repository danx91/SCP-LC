local ENTITY = FindMetaTable( "Entity" )

FIRE_REGISTRY = FIRE_REGISTRY or {}

game.AddParticles( "particles/slc_fire.pcf" )
PrecacheParticleSystem( "scp_457_fire" )

if SERVER then
	function ENTITY:Burn( time, radius, attacker, dmg )
		local fire = FIRE_REGISTRY[self]

		if !IsValid( fire ) then
			fire = ents.Create( "slc_entity_fire" )
			fire:SetPos( self:GetPos() )
			fire:SetParent( self )
			fire:SetOwner( attacker )

			fire:SetBurnTime( time )
			fire:SetFireDamage( dmg )
			fire:SetFireRadius( radius )

			fire:Spawn()

			FIRE_REGISTRY[self] = fire
		else
			local changed = false

			if fire:Get_DieTime() - CurTime() < time then
				fire:SetBurnTime( time )
				changed = true
			end

			if fire.Damage < dmg then
				fire:SetFireDamage( dmg )
				changed = true
			end

			if fire.Radius < radius then
				fire:SetFireRadius( radius )
				changed = true
			end

			if changed then
				if IsValid( attacker ) and attacker:IsPlayer() then
					if attacker != fire:GetOwner() then
						fire:SetOwner( attacker )
					end
				end
			end
		end

		return fire
	end

	function ENTITY:IsBurning()
		return IsValid( FIRE_REGISTRY[self] )
	end

	function ENTITY:StopBurn()
		local fire = FIRE_REGISTRY[self]

		if IsValid( fire ) then
			fire:Remove()
		end
	end
end