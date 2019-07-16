hook.Add( "StartCommand", "SCPSprint", function( ply, cmd )
	if cmd:KeyDown( IN_WALK ) then cmd:RemoveKey( IN_WALK ) end

	if ply:IsBot() then return end
	if ply:SCPTeam() == TEAM_SPEC then return end
	if ply:SCPTeam() == TEAM_SCP /*and !ply.SCPHuman*/ then return end

	if cmd:KeyDown( IN_JUMP ) then
		if ply:OnGround() and !ply:InVehicle() then
			if ply.Exhausted then
				cmd:RemoveKey( IN_JUMP )
			elseif !ply.Jumping then
				ply.Jumping = true
				ply.Stamina = math.max( ply.Stamina - 10, 0 )
				ply.StaminaRegen = CurTime() + 1.5
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

	if ply.StaminaRegen < CurTime() then
		if ply.Exhausted then
			ply.StaminaRegen = CurTime() + 0.2
			ply.Stamina = math.min( ply.Stamina + 1, 100 )
		else
			ply.StaminaRegen = CurTime() + 0.15
			ply.Stamina = math.min( ply.Stamina + 2, 100 )
		end
	end

	if ply.RunCheck < CurTime() then
		ply.RunCheck = CurTime() + 0.1

		if ply.Running then
			ply.Running = false
			ply.Stamina = math.max( ply.Stamina - 1, 0 )
			ply.StaminaRegen = CurTime() + 1
		end
	end

	if ply.Stamina <= 0 and !ply.Exhausted then
		ply.Exhausted = true

		if SERVER then
			ply.StaminaSpeed = ply:PushSpeed( 0.2, -1, -1 )
			
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
			ply:PopSpeed( ply.StaminaSpeed )
			ply.StaminaSpeed = 0
		end
	end

	if SERVER then
		if ply.Stamina < 50 and !ply.Breathing then
			ply.Breathing = true
			ply:EmitSound( "Player.Breathing" )
		elseif ply.Stamina > 50 and ply.Breathing then
			ply.Breathing = false
			ply:StopSound( "Player.Breathing" )
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