SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "TURRET"

SWEP.WorldModel		= "models/Items/item_item_crate.mdl"

SWEP.Primary.Automatic 		= true

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.DrawCrosshair = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/turret.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.Mins = Vector( -24.5, -41, -33 )
SWEP.Maxs = Vector( 44, 41, 16.5 )

SWEP.PlaceTime = 5
SWEP.RotationSpeed = 90

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Place", "Float" )
	self:AddNetworkVar( "Rotation", "Float" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:Think()
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local status = owner:UpdateHold( self, "turret_place" )

	if status == true then
		if SERVER then
			local turret = ents.Create( "slc_turret" )
			if IsValid( turret ) then
				turret:Spawn()
				turret:SetPos( self.LastPos )
				turret:SetAngles( self.LastAng )
				turret:SetTurretOwner( owner )
				turret:SetOwnerSignature( owner:TimeSignature() )
				turret.OwnerTeam = owner:SCPTeam()
			end

			owner:ForceHolster()
			self:Remove()
		end
	elseif status == false then
		if SERVER then
			owner:EnableProgressBar( false )
		else
			//self.Indicator:SetNoDraw( false )
		end
	else
		local valid, pos, ang = self:TestIndicator()

		if owner:IsHolding( self, "turret_place" ) then
			if !valid then
				owner:InterruptHold( self, "turret_place" )
			end
		else
			self.LastPos = pos
			self.LastAng = ang

			if CLIENT and IsValid( self.Indicator ) then
				self.Indicator:SetColor( valid and Color( 0, 255, 0, 50 ) or Color( 255, 0, 0, 50 ) )
				self.Indicator:SetPos( pos )
				self.Indicator:SetAngles( ang )
			end
		end
	end
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

	self:SetRotation( 0 )
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
	local owner = self:GetOwner()
	if owner:IsHolding( self, "turret_place" ) then return end
	if owner:IsInZone( ZONE_FLAG_ANOMALY ) then return end
	
	local valid, _, _ = self:TestIndicator()
	if !valid then return end

	owner:StartHold( self, "turret_place", IN_ATTACK, self.PlaceTime )

	if SERVER then
		owner:EnableProgressBar( true, CurTime() + self.PlaceTime, "lang:WEAPONS.TURRET.placing_turret", Color( 200, 200, 200, 255 ), Color( 50, 225, 25, 255 ) )
	else
		//self.Indicator:SetNoDraw( true )
	end
end

function SWEP:SecondaryAttack()
	self:SetRotation( 0 )
end

SWEP.NReload = 0
function SWEP:Reload()
	if ROUND.preparing then return end

	local rot = self:GetRotation() + FrameTime() * self.RotationSpeed * ( self:GetOwner():KeyDown( IN_SPEED ) and -1 or 1 )

	if rot >= 360 then
		rot = rot - 360
	end

	self:SetRotation( rot )
end

function SWEP:TestIndicator()
	local owner = self:GetOwner()
	local pos = owner:EyePos()
	local ea = owner:EyeAngles()
	local ep = pos + ea:Forward() * 125
	local ang = Angle( 0, ea.y + self:GetRotation(), 0 )

	local valid, result = self:TraceIndicator( pos, ep, ang )
	return valid, result, ang
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

			//local rot = Angle( 0, -90, 0 )
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

							local npos = result + add

							local trace_ground3 = util.TraceLine{
								start = npos,
								endpos = npos + Vector( 0, 0, -5 ),
								mask = trace_mask,
							}

							if trace_ground3.Hit then
								//debugoverlay.Line( npos, npos + Vector( 0, 0, -5 ), 0, Color( 255, 255, 255 ), false )
							else
								//debugoverlay.Line( npos, npos + Vector( 0, 0, -5 ), 0, Color( 200, 100, 100 ), false )
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

	return valid, result
end

hook.Add( "StartCommand", "SLCTurretSWEPCMD", function( ply, cmd )
	local wep = ply:GetWeapon( "item_slc_turret" )
	if IsValid( wep ) then
		if ply:IsHolding( wep, "turret_place" ) then
			cmd:ClearMovement()

			if !wep.ViewAngles then wep.ViewAngles = cmd:GetViewAngles() end
			cmd:SetViewAngles( wep.ViewAngles )
		elseif wep.ViewAngles then
			wep.ViewAngles = nil
		end
	end
end )