SWEP.Base 			= "item_slc_base"
SWEP.UseHands 		= true
SWEP.Language 		= "ID"

SWEP.ViewModelFOV 	= 55
SWEP.ViewModel 		= "models/weapons/kerry/passport_g.mdl"
SWEP.WorldModel 	= "models/weapons/kerry/w_garrys_pass.mdl"

SWEP.Droppable		= false
SWEP.HoldType 		= "pistol"

SWEP.SelectFont = "SCPHUDMedium"

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

	if CLIENT then
		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetParent( self )
		self.WModel:SetNoDraw( true )
		self.WModel:SetPos( self:GetPos() )

		local mx = Matrix()
		mx:Scale( self.ModScale )

		self.WModel:EnableMatrix( "RenderMultiply", mx )
		
		self:InitializeLanguage()
	end

	self.mat_ply = Material( "null" )//Material( "spawnicons/"..string.gsub( self.Owner:GetModel(), ".mdl", ".png" ) )
end

function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if !IsValid( vm ) then return end

		local bone = vm:LookupBone( "PBase" )
		if !bone then return end

		local m = vm:GetBoneMatrix( bone )
		local pos, ang = m:GetTranslation(), m:GetAngles()

		ang:RotateAroundAxis( ang:Forward(), 0 )
		ang:RotateAroundAxis( ang:Right(), -130 )
		ang:RotateAroundAxis( ang:Up(), 93 )

		cam.Start3D2D( pos + ang:Right() * 3 + ang:Forward() * -1.80 + ang:Up() * 1.0, ang, 0.02 )
	        draw.SimpleText( self.Lang.pname, "PassHud2", 40, -50, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( self.Owner:Name() or "Unknown", "PassHud", 40, -40, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( self.Lang.server, "PassHud2", 40, 15, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( string.sub( GetHostName(), 1, 20 ), "PassHud3", 40, 30, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( "<G<<<<<<<<<<<"..self.Owner:SteamID().."<<<<", "PassHud2", -60, 60, Color( 0, 0, 0, 200 ) )
			draw.SimpleText( "<G<<<2281337<<<<777<<<<06<<<<<<<<<<", "PassHud2", -60, 75, Color( 0, 0, 0, 200 ) )
			//surface.SetDrawColor(255,255,255,250)
			//surface.SetMaterial(self.mat_ply)
			//surface.DrawRect( -40, -42, 80, 80 )
		cam.End3D2D()
end

SWEP.ModScale = Vector( 0.699, 0.699, 0.699 )
SWEP.ModPos = Vector( 6, -3, 0 )
SWEP.ModAng = Angle( 0, 90, 120 )

function SWEP:DrawWorldModel()
	local ply = self.Owner
	local model = self.WModel

	if !IsValid( ply ) then return end

	local bone = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
	if bone then
		local mx = ply:GetBoneMatrix( bone )

		if mx then
			local pos, ang = LocalToWorld( self.ModPos, self.ModAng, mx:GetTranslation(), mx:GetAngles() )

			model:SetRenderAngles( ang )
			model:SetRenderOrigin( pos )
			model:DrawModel()
		end
	end

	//self:DrawModel()
	/*if (!self.wRenderOrder) then
		self.wRenderOrder = {}
		for k, v in pairs( self.Passport) do
			if (v.type == "Model") then
				table.insert(self.wRenderOrder, 1, k)
			elseif (v.type == "Quad") then
				table.insert(self.wRenderOrder, k)
			end
		end
	end
	
	if (IsValid(self.Owner)) then
		bone_ent = self.Owner
	else
		// when the weapon is dropped
		bone_ent = self
	end
	
	for k, name in pairs( self.wRenderOrder ) do
	
		local v = self.Passport[name]
		if (!v) then self.wRenderOrder = nil break end
		if (v.hide) then continue end
		
		local pos, ang
		
		if (v.bone) then
			pos, ang = self:GetBoneOrientation( self.Passport, v, bone_ent )
		else
			pos, ang = self:GetBoneOrientation( self.Passport, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
		end
		
		if (!pos) then continue end
		
		local model = v.modelEnt
		local sprite = v.spriteMaterial
		
		if (v.type == "Model" and IsValid(model)) then
			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			model:SetAngles(ang)
			//model:SetModelScale(v.size)
			local matrix = Matrix()
			matrix:Scale(v.size)
			model:EnableMatrix( "RenderMultiply", matrix )
			
			if (v.surpresslightning) then
				render.SuppressEngineLighting(true)
			end
			
			render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
			render.SetBlend(v.color.a/255)
			model:DrawModel()
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)
			
			if (v.surpresslightning) then
				render.SuppressEngineLighting(false)
			end								
		elseif (v.type == "Quad") then
			if LocalPlayer():GetPos():Distance(self:GetPos()) >= 200 then return end				
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * 0.08
			ang:RotateAroundAxis(ang:Up(), 180)
			
			cam.Start3D2D(drawpos, ang, 0.02)
			    draw.SimpleText(self.Lang.name, "PassHud2", 40, -50, Color(0,0,0,255))
				draw.SimpleText(self.Owner:Name() or "Unknown", "PassHud", 40, -40, Color(0,0,0,255))
				draw.SimpleText(self.Lang.city, "PassHud2", 40, 15, Color(0,0,0,255))
				draw.SimpleText(validString( GetHostName() ), "PassHud3", 40, 30, Color(0,0,0,255))
				draw.SimpleText("<G<<<<<<<<<<<"..self.Owner:SteamID().."<<<<", "PassHud2", -60, 60, Color(0,0,0,200))
				draw.SimpleText("<G<<<2281337<<<<777<<<<06<<<<<<<<<<", "PassHud2", -60, 75, Color(0,0,0,200))
				surface.SetDrawColor(255,255,255,250)
				surface.SetMaterial(self.mat_ply)
				surface.DrawTexturedRect( -40, -42, 80, 80 )
			cam.End3D2D()
		end
		
	end*/
	
end