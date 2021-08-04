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
	self:SetModelScale( 2 / 3 )

	if CLIENT then
		/*self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetParent( self )
		self.WModel:SetNoDraw( true )
		self.WModel:SetPos( self:GetPos() )

		local mx = Matrix()
		mx:Scale( self.ModScale )

		self.WModel:EnableMatrix( "RenderMultiply", mx )*/
		
		self:InitializeLanguage()
	end

	self.mat_ply = Material( "null" )
end

function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if !IsValid( vm ) then return end

		local bone = vm:LookupBone( "PBase" )
		if !bone then return end

		local m = vm:GetBoneMatrix( bone )
		if m then
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
			cam.End3D2D()
		end
end

//SWEP.ModScale = Vector( 0.699, 0.699, 0.699 )
SWEP.ModPos = Vector( 6, -3, 0 )
SWEP.ModAng = Angle( 0, 90, 120 )

function SWEP:DrawWorldModel()
	local ply = self.Owner
	//local model = self.WModel

	if !IsValid( ply ) then return end

	local bone = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
	if bone then
		local mx = ply:GetBoneMatrix( bone )

		if mx then
			local pos, ang = LocalToWorld( self.ModPos, self.ModAng, mx:GetTranslation(), mx:GetAngles() )

			//model:SetRenderAngles( ang )
			//model:SetRenderOrigin( pos )
			//model:DrawModel()

			self:SetRenderOrigin( pos )
			self:SetRenderAngles( ang )
			self:SetupBones()
			self:DrawModel()
		end
	end
end