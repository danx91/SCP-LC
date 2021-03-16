SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "TURRET"

SWEP.WorldModel		= "models/Items/item_item_crate.mdl"

SWEP.Primary.Automatic 		= true

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/turret.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.IndicatorRotation = 0 --TODO: Test high ping results

SWEP.Mins = Vector( -24.5, -41, -33 )
SWEP.Maxs = Vector( 44, 41, 16.5 )

SWEP.PlaceTime = 5

SWEP.Place = 0
SWEP.LPrimary = 0

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Place", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
		//if !self.Hold then
			local owner = self:GetOwner()

			if IsValid( owner ) then
				local pos = owner:EyePos()
				local ea = owner:EyeAngles()
				local ep = pos + ea:Forward() * 125

				//self.LastPos = pos
				//self.LastEP = ep

				local ang = Angle( 0, ea.y + self.IndicatorRotation, 0 )

				//self.LastAng = ang

				local ct = CurTime()

				local place = self:GetPlace()
				if place == 0 then
					local result, valid = self:TraceIndicator( pos, ep, ang )

					if valid and self.LPrimary + 0.15 >= ct then
						self.LastResult = result
						self.LastAngle = ang
						//self.LastEA = ea

						self:SetPlace( CurTime() + self.PlaceTime )
					end

					if CLIENT and IsValid( self.Indicator ) then
						self.Indicator:SetColor( valid and Color( 0, 255, 0, 50 ) or Color( 255, 0, 0, 50 ) )
						self.Indicator:SetPos( result )
						self.Indicator:SetAngles( ang )
					end
				elseif place <= ct then
					self:SetPlace( 0 )
					-- if CLIENT and IsValid( self.Indicator ) then
					-- 	self.Indicator:Remove()
					-- end

					if SERVER then
						local turret = ents.Create( "slc_turret" )
						if IsValid( turret ) then
							turret:Spawn()
							turret:SetPos( self.LastResult )
							turret:SetAngles( self.LastAngle )
							turret:SetTurretOwner( owner )
							turret:SetOwnerSignature( owner:TimeSignature() )
						end

						local holster = owner:GetWeapon( "item_slc_holster" )
						if IsValid( holster ) then
							owner:SetActiveWeapon( holster )
						end
						
						self:Remove()
					end
				else
					local result, valid = self:TraceIndicator( pos, ep, ang )
					if self.LPrimary + 0.15 < ct or !valid then
						self:SetPlace( 0 )
					end
				end
			end
		//else
			//self:TraceIndicator( self.LastPos, self.LastEP, self.LastAng )
		//end
	--end
end

function SWEP:Deploy()
	self:CallBaseClass( "Deploy" )

	if CLIENT then
		//self.Indicator:Remove()
		if !IsValid( self.Indicator ) then
			self.Indicator = CreateIndicator( "models/alski/scp/turret/turret1.mdl", false, nil, nil, function()
				return !LocalPlayer():HasWeapon( "item_slc_turret" )
			end )
		end

		self.Indicator:SetPos( self:GetOwner():GetPos() )
		self.Indicator:SetNoDraw( false )
	end

	self.IndicatorRotation = 0
end

function SWEP:Holster()
	if CLIENT and IsValid( self.Indicator ) then
		self.Indicator:SetNoDraw( true )
	end

	return true
end

function SWEP:OnRemove()
	if CLIENT and IsValid( self.Indicator ) then
		self.Indicator:Remove()
	end
end

function SWEP:PrimaryAttack()
	self.LPrimary = CurTime()
end

function SWEP:SecondaryAttack()
	/*if IsFirstTimePredicted() then
		self.Hold = !self.Hold
	end*/
end

SWEP.NReload = 0
function SWEP:Reload()
	if ROUND.preparing then return end
	
	if self.NReload < CurTime() then
		self.NReload = CurTime() + 0.05

		self.IndicatorRotation = self.IndicatorRotation + 6

		if self.IndicatorRotation >= 360 then
			self.IndicatorRotation = self.IndicatorRotation - 360
		end
	end
end

local trace_mask = MASK_SHOT//MASK_SOLID_BRUSHONLY
function SWEP:TraceIndicator( pos, ep, ang )
	/*local att = self.Indicator:GetAttachment( 2 )
	if att then
		debugoverlay.Axis( att.Pos, att.Ang, 5, 0, true )
		debugoverlay.Line( att.Pos, att.Pos + att.Ang:Forward() * 50, 0, Color( 255, 255, 255 ), false )
	end*/

	local owner = self:GetOwner()

	local trace1 = util.TraceLine{
		start = pos,
		endpos = ep,
		mask = trace_mask,
		filter = owner,
	}

	local result
	local valid = false

	if trace1.Hit then
		result = trace1.HitPos + Vector( 0, 0, 33.2 )
		valid = trace1.HitNormal.z > 0.9
	else
		local trace2 = util.TraceLine{
			start = trace1.HitPos,
			endpos = trace1.HitPos - Vector( 0, 0, 100 ),
			mask = trace_mask,
			filter = owner,
		}

		if trace2.Hit then
			result = trace2.HitPos + Vector( 0, 0, 33.2 )
			valid = trace2.HitNormal.z > 0.9
		end
	end

	if !result then
		result = ep
	end

	//debugoverlay.Axis( result, ang, 5, 0, true )

	if valid then
		local mins, maxs = self.Mins, self.Maxs

		mins = mins + Vector( 0, -2, -2.5 )
		maxs = maxs + Vector( 50, 0, 0 )

		local scale1 = 0.9
		local scale2 = 0.5
		//mins:Mul( scale )
		//maxs:Mul( scale )

		local mins1 = mins * scale1
		local maxs1 = maxs * scale2

		mins1:Rotate( ang )
		maxs1:Rotate( ang )

		local pos_bot1 = result + mins1
		local trace3 = util.TraceLine{
			start = pos_bot1,
			endpos = result + maxs1,
			mask = trace_mask,
		}

		if !trace3.Hit then
			//debugoverlay.Line( result + mins1, result + maxs1, 0, Color( 255, 255, 255 ), false )

			local rot = Angle( 0, -90, 0 )
			//mins:Rotate( rot )
			//maxs:Rotate( rot )

			local mins2 = Vector( mins.x, -mins.y, mins.z ) * scale1
			local maxs2 = Vector( maxs.x, -maxs.y, maxs.z ) * scale2

			mins2:Rotate( ang )
			maxs2:Rotate( ang )

			//mins:RotateAroundPoint( result, rot )
			//maxs:RotateAroundPoint( result, rot )

			local pos_bot2 = result + mins2
			local trace4 = util.TraceLine{
				start = pos_bot2,
				endpos = result + maxs2,
				mask = trace_mask,
			}

			if !trace4.Hit then
				//debugoverlay.Line( result + mins2, result + maxs2, 0, Color( 255, 255, 255 ), false )

				local trace5 = util.TraceLine{
					start = result,
					endpos = result + ang:Forward() * 150,
					mask = MASK_OPAQUE,
				}

				if !trace5.Hit then
					//debugoverlay.Line( result, result + ang:Forward() * 150, 0, Color( 255, 255, 255 ), false )

					local trace_ground1 = util.TraceLine{
						start = pos_bot1,
						endpos = pos_bot1 + Vector( 0, 0, -5 ),
						mask = trace_mask,
					}

					if trace_ground1.Hit then
						//debugoverlay.Line( pos_bot1, pos_bot1 + Vector( 0, 0, -5 ), 0, Color( 255, 255, 255 ), false )

						local trace_ground2 = util.TraceLine{
							start = pos_bot2,
							endpos = pos_bot2 + Vector( 0, 0, -5 ),
							mask = trace_mask,
						}

						if trace_ground2.Hit then
							//debugoverlay.Line( pos_bot2, pos_bot2 + Vector( 0, 0, -5 ), 0, Color( 255, 255, 255 ), false )

							local add = Vector( 19, 0, mins1.z )
							add:Rotate( ang )

							local pos = result + add

							local trace_ground3 = util.TraceLine{
								start = pos,
								endpos = pos + Vector( 0, 0, -5 ),
								mask = trace_mask,
							}

							if trace_ground3.Hit then
								//debugoverlay.Line( pos, pos + Vector( 0, 0, -5 ), 0, Color( 255, 255, 255 ), false )

								
							else
								//debugoverlay.Line( pos, pos + Vector( 0, 0, -5 ), 0, Color( 200, 100, 100 ), false )
								valid = false
							end
						else
							//debugoverlay.Line( pos_bot2, pos_bot2 + Vector( 0, 0, -5 ), 0, Color( 200, 100, 100 ), false )
							valid = false
						end
					else
						//debugoverlay.Line( pos_bot1, pos_bot1 + Vector( 0, 0, -5 ), 0, Color( 200, 100, 100 ), false )
						valid = false
					end
				else
					//debugoverlay.Line( result, result + ang:Forward() * 150, 0, Color( 200, 100, 100 ), false )
					valid = false
				end
			else
				//debugoverlay.Line( result + mins2, result + maxs2, 0, Color( 200, 100, 100 ), false )
				valid = false
			end
		else
			//debugoverlay.Line( result + mins1, result + maxs1, 0, Color( 200, 100, 100 ), false )
			valid = false
		end
	end

	return result, valid
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

function SWEP:DrawHUD()
	local place = self:GetPlace()
	if place != 0 and place > CurTime() then
		draw.Text{
			text = string.format( "%.2f", place - CurTime() ),
			pos = { ScrW() * 0.5, ScrH() * 0.5 },
			color = Color( 0, 255, 0 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
end

hook.Add( "StartCommand", "SLCTurretSWEPCMD", function( ply, cmd )
	local wep = ply:GetWeapon( "item_slc_turret" )
	if IsValid( wep ) then
		if wep.GetPlace and wep:GetPlace() != 0 and wep:GetPlace() > CurTime() then
			cmd:ClearMovement()

			if !wep.ViewAngles then wep.ViewAngles = cmd:GetViewAngles() end
			cmd:SetViewAngles( wep.ViewAngles )
		elseif wep.ViewAngles then
			wep.ViewAngles = nil
		end
	end
end )