SWEP.PrintName 				= "Flashlight"
SWEP.Base 					= "item_slc_base"
SWEP.Language 				= "FLASHLIGHT"

SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/danx91/flashlight/flashlight.mdl"
SWEP.WorldModel				= "models/danx91/flashlight/flashlight.mdl"

SWEP.WorldModelPositionOffset 	= Vector( 4, -2, -1 )
SWEP.WorldModelAngleOffset 		= Angle( 0, 0, 0 )


SWEP.ViewModelPositionOffset 	= Vector( 10, 6, -5 )
SWEP.ViewModelAngleOffset 		= Angle( 0, 0, 0 )

SWEP.BoneAttachment 			= "ValveBiped.Bip01_R_Hand"

SWEP.HoldType 					= "pistol"

SWEP.Toggleable 				= true
SWEP.HasBattery 				= true

SWEP.LightDistance				= 500
SWEP.LightFOV 					= 50

SWEP.NPrimary = 0
SWEP.NBattery = 0

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )
end

function SWEP:Initialize()
	self:CallBaseClass( "Initialize" )

	if CLIENT then
		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetParent( self )
		self.WModel:SetNoDraw( true )
		self.WModel:SetPos( self:GetPos() )

		self.PixelVis = util.GetPixelVisibleHandle()
	end

	if SERVER then
		if !IsValid( SLCFLASHLIGHTLIGHT ) then
			local light = ents.Create( "env_projectedtexture" )
			if IsValid( light ) then
				/*light:SetPos( self:GetPos() )
				light:SetAngles( self:GetAngles() )
				--light:SetParent( self.Owner:GetViewModel() )

				light:SetEnableShadows( true )
				light:SetNearZ( 8 )
				light:SetFarZ( 500 )
				light:SetFOV( 50 )
				light:SetColor( Color( 255, 255, 255 ) )
				light:SetTexture( "effects/flashlight001" )
				light:Update()*/

				light:SetKeyValue( "enableshadows", 1 )
				light:SetKeyValue( "nearz", 8 )
				light:SetKeyValue( "farz", 500 )
				light:SetKeyValue( "lightfov", 50 )
				light:SetKeyValue( "lightcolor", "255 255 255" )

				light:Fire( "SpotlightTexture", "effects/flashlight001" )

				SLCFLASHLIGHTLIGHT = light
			end
		end

		game.GetWorld():SetNWEntity( "SLCFlashlightLight", SLCFLASHLIGHTLIGHT )
	end

	//self:UpdateInfo()
end

function SWEP:OnRemove()
	if CLIENT and self.DLight then
		self.DLight.dietime = CurTime()
	end
end

function SWEP:Deploy()
	self:CallBaseClass( "Deploy" )
	self.NWorldLight = CurTime()
end

function SWEP:Holster()
	if CLIENT and self.DLight then
		self.DLight.dietime = CurTime()
	end

	return true
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

/*function SWEP:OwnerChanged()
	self:SetEnabled( false )
end*/

function SWEP:Think()
	self:CallBaseClass( "Think" )

	if SERVER then
		/*if self.NBlind > CurTime() then return end
		self.NBlind = CurTime() + 0.25

		local orig = self.WorldLight:GetPos()
		orig.z = orig.z + 60 --WTF? on server light is placed 60 units below expected positoin...
		
		if self.Owner:Crouching() then
			orig.z = orig.z - 36
		end

		local light_dir = self.WorldLight:GetForward()
		local max_dist = self.LightDistance * self.LightDistance
		local max_light_ang = self.LightFOV / 4
		local max_ply_ang = math.rad( 90 )

		for k, v in pairs( player.GetAll() ) do
			if v:MazeTeam() == TEAM_ALIVE and v != self.Owner then
				local pos = v:EyePos()
				local dist = orig:DistToSqr( pos )

				if dist <= max_dist then
					local best_light_dir = ( pos - orig ):GetNormalized()
					local light_ang = math.abs( math.deg( math.acos( light_dir:Dot( best_light_dir ) ) ) )
					
					if light_ang <= max_light_ang then
						local tr = util.TraceLine( {
							start = orig,
							endpos = pos,
							filter = { self, self.Owner, v },
							mask = MASK_OPAQUE
						} )

						if !tr.Hit then
							local ply_dir = v:EyeAngles():Forward()
							local best_ply_dir = ( orig - pos ):GetNormalized()
							local ply_ang = math.abs( math.acos( ply_dir:Dot( best_ply_dir ) ) )

							--if math.deg( ply_ang ) < 90 then
							if ply_ang < max_ply_ang then
								local dist_pct = 1 - dist / max_dist
								local light_pct = 1 - light_ang / max_light_ang
								local ply_pct = 1 - ply_ang / max_ply_ang

								local total_power = self.LightPower * dist_pct * light_pct * ply_pct
								--print( total_power )
								v:AddBlind( total_power )
								--self.Owner:AddBlind( total_power )
							end
						end
					end
				end
			end
		end*/
	end
end

function SWEP:PrimaryAttack()
	if self.NPrimary > CurTime() then return end
	if self:GetBattery() <= 0 then return end

	self.NPrimary = CurTime() + 0.1

	self:SetEnabled( !self:GetEnabled() )
	self.NWorldLight = CurTime()
end

if CLIENT then
	light_sprite = Material( "sprites/slc_light_sprite" )
	light_beam = Material( "sprites/slc_light_beam" )
end

function SWEP:CalcViewModelView( vm, oldpos, oldang, pos, ang )
	if !IsValid( self.Owner ) then return pos, ang end

	local forward, right, up = self.ViewModelPositionOffset.x, self.ViewModelPositionOffset.y, self.ViewModelPositionOffset.z

	local angs = self.Owner:EyeAngles()
	--ang.pitch = -ang.pitch

	ang:RotateAroundAxis( ang:Forward(), self.ViewModelAngleOffset.pitch )
	ang:RotateAroundAxis( ang:Right(), self.ViewModelAngleOffset.roll )
	ang:RotateAroundAxis( ang:Up(), self.ViewModelAngleOffset.yaw )

	return pos + angs:Forward() * forward + angs:Right() * right + angs:Up() * up, ang --Angle( 0, 180, -45 )
end

function SWEP:PreDrawViewModel( vm, wep, ply )
	local light = game.GetWorld():GetNWEntity( "SLCFlashlightLight" )
	if IsValid( light ) then
		if self:GetEnabled() then
			light:SetRenderOrigin( vm:GetPos() )
			light:SetRenderAngles( vm:GetAngles() )
		else
			light:SetRenderOrigin( Vector( 0, 0, -10000 ) )
		end
	end
end

local spriterenderer = {}
local beamrenderer = {}

SWEP.NWorldLight = 0
function SWEP:DrawWorldModel()
	if IsValid( self.Owner ) then
		if !IsValid( self.WModel ) then return end

		local boneid = self.Owner:LookupBone( self.BoneAttachment )
		if not boneid then
			return
		end

		local matrix = self.Owner:GetBoneMatrix( boneid )
		if not matrix then
			return
		end

		local newpos, newang = LocalToWorld( self.WorldModelPositionOffset, self.WorldModelAngleOffset, matrix:GetTranslation(), matrix:GetAngles() )

		self.WModel:SetPos( newpos )
		self.WModel:SetAngles( newang )
		self.WModel:SetupBones()
		self.WModel:DrawModel()

		--TODO test
		if !self:GetEnabled() then
			if self.DLight then
				self.DLight.dietime = CurTime()
			end

			return
		end

		local forward = ( newang or self:GetAngles() ):Forward()
		local pos = ( newpos or self:GetPos() ) + forward * 6
		local endpos = pos + forward * self.LightDistance

		local tr = util.TraceLine( {
			start = pos - forward * 15,
			endpos = endpos,
			filter = { self, self.Owner },
			mask = MASK_BLOCKLOS_AND_NPCS
		} )

		if tr.StartSolid or tr.HitPos:DistToSqr( pos ) < 100 then return end

		if self.NWorldLight < CurTime() then
			self.NWorldLight = CurTime() + 5

			local light = DynamicLight( self:EntIndex() )
			if light then
				light.r = 200
				light.g = 200
				light.b = 200
				light.size = 196
				light.brightness = 0.5
				light.decay = 0
				light.dietime = CurTime() + 6
				light.pos = tr.HitPos
				light.dir = newang:Forward()

				self.DLight = light
			end
		end

		if self.DLight then
			self.DLight.pos = tr.HitPos - forward * 10 + tr.HitNormal * 15
		end
		
		local dot = ( LocalPlayer():EyePos() - pos ):GetNormalized():Dot( forward )

		local beamalpha = math.Clamp( 0.95 - dot, 0, 1 )
		if beamalpha > 0 then
			table.insert( beamrenderer, { pos, tr.HitPos, beamalpha } )
		end

		if dot < 0 then return end

		local vis = util.PixelVisible( pos, 3, self.PixelVis )

		local alpha = 255 * vis * ( dot - 0.22 )
		local size = 64 * vis * ( dot + 0.1 )

		alpha = math.Clamp( alpha, 0, 255 )
		size = math.Clamp( size, 16, 48 )

		//render.SetMaterial( light_sprite )
		//render.DrawSprite( pos, size, size, Color( 255, 255, 255, alpha ) )
		table.insert( spriterenderer, { pos, size, alpha } )
	else
		self:DrawModel()

		if self.DLight then
			self.DLight.dietime = CurTime()
		end

		return
	end

	-- if !self:GetEnabled() then
	-- 	if self.DLight then
	-- 		self.DLight.dietime = CurTime()
	-- 	end

	-- 	return
	-- end

	-- local forward = ( newang or self:GetAngles() ):Forward()
	-- local pos = ( newpos or self:GetPos() ) + forward * 6
	-- local endpos = pos + forward * self.LightDistance

	-- local tr = util.TraceLine( {
	-- 	start = pos - forward * 15,
	-- 	endpos = endpos,
	-- 	filter = { self, self.Owner },
	-- 	mask = MASK_BLOCKLOS_AND_NPCS
	-- } )

	-- if tr.StartSolid or tr.HitPos:DistToSqr( pos ) < 100 then return end

	-- if self.NWorldLight < CurTime() then
	-- 	self.NWorldLight = CurTime() + 5

	-- 	local light = DynamicLight( self:EntIndex() )
	-- 	if light then
	-- 		light.r = 200
	-- 		light.g = 200
	-- 		light.b = 200
	-- 		light.size = 196
	-- 		light.brightness = 0.5
	-- 		light.decay = 0
	-- 		light.dietime = CurTime() + 6
	-- 		light.pos = tr.HitPos
	-- 		light.dir = newang:Forward()

	-- 		self.DLight = light
	-- 	end
	-- end

	-- if self.DLight then
	-- 	self.DLight.pos = tr.HitPos - forward * 10 + tr.HitNormal * 15
	-- end
	
	-- local dot = ( LocalPlayer():EyePos() - pos ):GetNormalized():Dot( forward )

	-- local beamalpha = math.Clamp( 0.95 - dot, 0, 1 )
	-- if beamalpha > 0 then
	-- 	table.insert( beamrenderer, { pos, tr.HitPos, beamalpha } )
	-- end

	-- if dot < 0 then return end

	-- local vis = util.PixelVisible( pos, 3, self.PixelVis )

	-- local alpha = 255 * vis * ( dot - 0.22 )
	-- local size = 64 * vis * ( dot + 0.1 )

	-- alpha = math.Clamp( alpha, 0, 255 )
	-- size = math.Clamp( size, 16, 48 )

	-- //render.SetMaterial( light_sprite )
	-- //render.DrawSprite( pos, size, size, Color( 255, 255, 255, alpha ) )
	-- table.insert( spriterenderer, { pos, size, alpha } )
end

hook.Add( "PostDrawOpaqueRenderables", "FlashLightSprite", function()
	render.SetMaterial( light_sprite )

	for k, v in pairs( spriterenderer ) do
		render.DrawSprite( v[1], v[2], v[2], Color( 255, 255, 255, v[3] ) )
	end

	render.SetMaterial( light_beam )

	for k, v in pairs( beamrenderer ) do
		render.StartBeam( 2 )
			render.AddBeam( v[1], 40, 0, Color( 255, 255, 255, 50 * v[3] ) )
			render.AddBeam( v[2], 40, 0.97, Color( 255, 255, 255, 220 * v[3] ) )
		render.EndBeam()
	end

	beamrenderer = {}
	spriterenderer = {}

	local light = game.GetWorld():GetNWEntity( "SLCFlashlightLight" )
	if IsValid( light ) then
		light:SetRenderOrigin( Vector( 0, 0, -10000 ) )
	end
end )