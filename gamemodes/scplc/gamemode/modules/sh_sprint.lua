hook.Add( "StartCommand", "SLCSprint", function( ply, cmd )
	if cmd:KeyDown( IN_WALK ) then cmd:RemoveKey( IN_WALK ) end
	if ply:IsBot() then return end
	if ply:SCPTeam() == TEAM_SPEC then return end
	//if ply:SCPTeam() == TEAM_SCP then return end
	if SERVER and ply:IsAboutToSpawn() then return end
	if ply:GetStaminaBoost() > CurTime() then return end
	if !ply.GetStamina then return end
	if ply:GetMoveType() != MOVETYPE_WALK then return end

	if ply:GetWalkSpeed() == ply:GetRunSpeed() then return end
	local exhausted = ply:GetExhausted()

	if exhausted then
		cmd:RemoveKey( IN_JUMP )
	elseif cmd:KeyDown( IN_JUMP ) and IsFirstTimePredicted() then
		if !ply.WasJumpDown and ply:OnGround() and !ply:InVehicle() then
			local stamina = ply:GetStamina()
			local mask = ply:GetWeaponByGroup( "gasmask" )
			
			if !IsValid( mask ) or !mask:GetEnabled() or !mask:GetUpgraded() or stamina - 10 > 30 then
				ply.StaminaRegen = CurTime() + 1.5
				stamina = stamina - 10
				
				if stamina < 0 then
					stamina = 0
				end
				
				ply:SetStamina( stamina )
			end
		else
			cmd:RemoveKey( IN_JUMP )
		end

		ply.WasJumpDown = true
	elseif ply:OnGround() then
		ply.WasJumpDown = false
	end

	if ( ply:OnGround() or ply:WaterLevel() != 0 ) and !ply:InVehicle() then
		if cmd:KeyDown( IN_SPEED ) and ( cmd:KeyDown( IN_FORWARD ) or cmd:KeyDown( IN_BACK ) or cmd:KeyDown( IN_MOVELEFT ) or cmd:KeyDown( IN_MOVERIGHT ) ) and ply:GetMoveType() == MOVETYPE_WALK then
			if exhausted then
				cmd:RemoveKey( IN_SPEED )
			elseif ply:GetVelocity():Length2DSqr() > 225 then
				ply.Running = true
			end
		end
	end

	if exhausted then
		local ang = ply:EyeAngles()

		if !ply.ExhaustCam then
			ply.ExhaustCam = ang.p
		end

		ply.ExhaustCam = math.Approach( ply.ExhaustCam, 30 + math.TimedSinWave( 0.5, 0, 5 ), FrameTime() * 20 )
		ang.p = ply.ExhaustCam

		cmd:SetViewAngles( ang )
	elseif ply.ExhaustCam then
		ply.ExhaustCam = nil
	end
end )

hook.Add( "OnPlayerHitGround", "SLCBHop", function( ply, water, floater, speed )
	ply.JumpPenalty = CurTime() + 0.3
end )

hook.Add( "Move", "SLCBHop", function( ply, mv )
	if ply.JumpPenalty and ply.JumpPenalty >= CurTime() and !ply:GetProperty( "allow_bhop" ) then
		local vel = mv:GetVelocity()

		local new = vel * 0.98
		new.z = vel.z

		mv:SetVelocity( new )
	end
end )

local function CalcStamina( ply )
	if !ply.Stamina then
		ply.Stamina = true
		ply.StaminaRegen = 0
		ply.RunCheck = 0
	end

	if !ply.Stamina then return end

	if ply:SCPTeam() == TEAM_SPEC or ROUND.post then
		ply:SetStamina( 100 )
		ply:SetExhausted( false )

		if SERVER and ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "SLCPlayer.Breathing" )
		end

		return
	end

	local ct = CurTime()
	local exhausted = ply:GetExhausted()
	local stamina = ply:GetStamina()
	local max_stamina = ply:GetMaxStamina()
	local stamina_limit = ply:GetStaminaLimit()
	local boost = ply:GetStaminaBoost()

	if boost > ct then
		if exhausted then
			ply:SetExhausted( false )

			if SERVER then
				ply:PopSpeed( "SLC_Exhaust" )
				ply.StaminaSpeed = 0
			end
		end

		if ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "SLCPlayer.Breathing" )
		end

		return
	end
	//print( ply, max_stamina )

	local data = {
		regen_delay = 0.2,
		regen_rate_exhausted = 1,
		regen_rate = 2,

		use_delay = 0.125,
		regen_delay_running = 1,
		use_rate = 1,
	}

	local skip = hook.Run( "SLCStamina", ply, data, stamina, max_stamina, stamina_limit )
	if skip then
		return
	end

	if stamina_limit > max_stamina then
		stamina_limit = max_stamina
	end

	if ply.StaminaRegen <= ct then
		ply.StaminaRegen = ply.StaminaRegen + data.regen_delay

		if ply.StaminaRegen < ct then
			ply.StaminaRegen = ct + data.regen_delay
		end

		if exhausted then
			stamina = stamina + data.regen_rate_exhausted
		else
			stamina = stamina + data.regen_rate
		end
	end

	if stamina > stamina_limit then
		stamina = stamina_limit
	end

	if ply.RunCheck < ct then
		ply.RunCheck = ply.RunCheck + data.use_delay

		if ply.RunCheck < ct then
			ply.RunCheck = CurTime() + data.use_delay
		end

		if ply.Running then
			ply.Running = false
			ply.StaminaRegen = CurTime() + data.regen_delay_running

			local mask = ply:GetWeapon( "item_slc_gasmask" )
			if !IsValid( mask ) or !mask:GetEnabled() or !mask:GetUpgraded() or stamina > 30 then
				//ply.Stamina = math.max( ply.Stamina - 1, 0 )
				stamina = stamina - data.use_rate

				if stamina < 0 then
					stamina = 0
				end
			end
		end
	end

	if stamina <= 0 and !exhausted then
		ply:SetExhausted( true )

		if SERVER then
			ply:PushSpeed( 0.2, -1, -1, "SLC_Exhaust" )
		end
	elseif stamina >= 30 and exhausted then
		ply:SetExhausted( false )

		if SERVER then
			ply:PopSpeed( "SLC_Exhaust" )
			ply.StaminaSpeed = 0
		end
	end

	if SERVER then
		if stamina < 50 and !ply.Breathing then
			ply.Breathing = true
			ply:EmitSound( "SLCPlayer.Breathing" )
		elseif stamina > 50 and ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "SLCPlayer.Breathing" )
		end
	end

	ply:SetStamina( stamina )
end

hook.Add( "Tick", "SCPStaminaTick", function()
	if SERVER then
		for i, v in ipairs( player.GetAll() ) do
			CalcStamina( v )
		end
	else
		CalcStamina( LocalPlayer() )
	end
end )