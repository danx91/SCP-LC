hook.Add( "StartCommand", "SCPSprint", function( ply, cmd )
	if cmd:KeyDown( IN_WALK ) then cmd:RemoveKey( IN_WALK ) end

	if ply:IsBot() then return end
	if ply:SCPTeam() == TEAM_SPEC then return end
	if ply:SCPTeam() == TEAM_SCP then return end

	if cmd:KeyDown( IN_JUMP ) then
		if ply:OnGround() and !ply:InVehicle() then
			if ply.Exhausted then
				cmd:RemoveKey( IN_JUMP )
			elseif !ply.Jumping then
				ply.Jumping = true
				ply.StaminaRegen = CurTime() + 1.5

				local mask = ply:GetWeapon( "item_slc_gasmask" )

				if !IsValid( mask ) or !mask:GetEnabled() or !mask:GetUpgraded() or ply.Stamina - 10 > 30 then
					ply.Stamina = math.max( ply.Stamina - 10, 0 )
				end
			end
		end
	else
		ply.Jumping = false
	end

	if ply:GetWalkSpeed() == ply:GetRunSpeed() then return end

	if ( ply:OnGround() or ply:WaterLevel() != 0 ) and !ply:InVehicle() then
		if cmd:KeyDown( IN_SPEED ) and ( cmd:KeyDown( IN_FORWARD ) or cmd:KeyDown( IN_BACK ) or cmd:KeyDown( IN_MOVELEFT ) or cmd:KeyDown( IN_MOVERIGHT ) ) and ply:GetMoveType() == MOVETYPE_WALK then
			if ply.Exhausted then
				cmd:RemoveKey( IN_SPEED )
			else
				ply.Running = true
			end
		end
	end

	if ply.Exhausted then
		local ang = ply:EyeAngles()

		if !ply.ExhaustCam then
			ply.ExhaustCam = ang.p
		end

		ply.ExhaustCam = math.Approach( ply.ExhaustCam, 30 + math.TimedSinWave( 0.5, 0, 5 ), 0.1 )
		ang.p = ply.ExhaustCam


		cmd:SetViewAngles( ang )
	elseif ply.ExhaustCam then
		ply.ExhaustCam = nil
	end
end )

local function CalcStamina( ply )
	if !ply.Stamina then
		ply.Stamina = 100
		ply.Exhausted = false
		ply.StaminaRegen = 0
		ply.RunCheck = 0
	end

	if !ply.Stamina then return end
	if ply:SCPTeam() == TEAM_SPEC or ROUND.post then
		ply.Stamina = 100
	end

	local max_stamina = ply:GetStaminaLimit()

	if max_stamina > 100 then
		max_stamina = 100
	end

	if ply.StaminaRegen < CurTime() then
		if ply.Exhausted then
			ply.StaminaRegen = CurTime() + 0.2
			ply.Stamina = math.min( ply.Stamina + 1, max_stamina )
		else
			ply.StaminaRegen = CurTime() + 0.15
			ply.Stamina = math.min( ply.Stamina + 2, max_stamina )
		end
	end

	if ply.RunCheck < CurTime() then
		ply.RunCheck = CurTime() + 0.1

		if ply.Running then
			ply.Running = false
			ply.StaminaRegen = CurTime() + 1

			local mask = ply:GetWeapon( "item_slc_gasmask" )

			if !IsValid( mask ) or !mask:GetEnabled() or !mask:GetUpgraded() or ply.Stamina > 30 then
				ply.Stamina = math.max( ply.Stamina - 1, 0 )
			end
		end
	end

	if ply.Stamina <= 0 and !ply.Exhausted then
		ply.Exhausted = true

		if SERVER then
			ply:PushSpeed( 0.2, -1, -1, "SLC_Exhaust" )
			
			net.Start( "SCPForceExhaust" )
			net.Send( ply )
		end

		if CLIENT then
			net.Start( "SCPForceExhaust" )
			net.SendToServer()
		end
	elseif ply.Stamina >= 30 and ply.Exhausted then
		ply.Exhausted = false

		if SERVER then
			ply:PopSpeed( "SLC_Exhaust" )
			ply.StaminaSpeed = 0
		end
	end

	if SERVER then
		if ply.Stamina < 50 and !ply.Breathing then
			ply.Breathing = true
			ply:EmitSound( "SLCPlayer.Breathing" )
		elseif ply.Stamina > 50 and ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "SLCPlayer.Breathing" )
		end
	end
end

hook.Add( "Tick", "SCPStaminaTick", function()
	if SERVER then
		for k, ply in pairs( player.GetAll() ) do
			CalcStamina( ply )
		end
	else
		CalcStamina( LocalPlayer() )
	end
end )