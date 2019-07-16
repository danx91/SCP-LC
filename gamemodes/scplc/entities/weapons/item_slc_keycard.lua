SWEP.Base 						= "item_slc_base"
SWEP.Language 					= "KEYCARD"

if CLIENT then
	SWEP.WepSelectIcon		 	= surface.GetTextureID("slc/wep_keycard1")
end

SWEP.ViewModel					= "models/slc/keycard_new.mdl"
SWEP.WorldModel					= "models/slc/keycard_new.mdl"
SWEP.HoldType 					= "pistol"

SWEP.Secondary.Automatic 		= true
SWEP.Access						= 0

SWEP.BoneAttachment				= "ValveBiped.Bip01_R_Hand"
SWEP.WorldModelPositionOffset 	= Vector( 7, -1.5, -2.9 )
SWEP.WorldModelAngleOffset 		= Angle( -20, 180, 190 )

SWEP.DHUD = 0

function SWEP:HandleUpgrade( mode, exit )
	local t = self:GetNWString( "K_TYPE", nil )
	if !t then
		self:SetPos( exit )
		return
	end

	local dice = math.random( 0, 99 )
	if t == "safe" then
		if mode == 0 or mode == 1 then
			if dice < 50 then
				self:Remove()
				return
			end
		elseif mode == 3 then
			if dice < 60 then self:SetKeycardType( "euclid" ) end
		elseif mode == 4 then
			if dice < 30 then self:SetKeycardType( "euclid" ) end
			if dice >= 30 and dice < 50 then self:SetKeycardType( "keter" ) end
		end
	elseif t == "euclid" then
		if mode == 0 then
			if dice < 50 then
				self:Remove()
				return
			end
		elseif mode == 1 then
			if dice < 50 then self:SetKeycardType( "safe" ) end
		elseif mode == 2 then
			if dice < 50 then self:SetKeycardType( "res" ) end
		elseif mode == 3 then
			if dice < 50 then self:SetKeycardType( "keter" ) end
		elseif mode == 4 then
			if dice < 75 then self:SetKeycardType( "keter" ) end
		end
	elseif t == "keter" then
		if mode == 0 then
			if dice < 50 then
				self:Remove()
				return
			end
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "euclid" )
		elseif mode == 2 then
			self:SetKeycardType( "res" )
		elseif mode == 4 then
			if dice < 75 then 
				self:Remove()
				return
			end
			self:SetKeycardType( "com" )
		end
	elseif t == "res" then
		if mode == 0 then
			if dice < 50 then self:SetKeycardType( "safe" ) end
		elseif mode == 1 then
			if dice < 75 then self:SetKeycardType( "euclid" ) end
		elseif mode == 2 then
			self:SetKeycardType( "keter" )
		elseif mode == 3 then
			if dice < 75 then self:SetKeycardType( "cps" ) end
		elseif mode == 4 then
			if dice < 10 then self:SetKeycardType( "com" ) end
			if dice >= 10 and dice < 25 then self:SetKeycardType( "mtf" ) end
			if dice >= 25 and dice < 50 then self:SetKeycardType( "cps" ) end
		end
	elseif t == "cps" then
		if mode == 0 then
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "keter" )
		elseif mode == 2 then
			self:SetKeycardType( "res" )
		elseif mode == 3 then
			if dice < 50 then self:SetKeycardType( "mtf" ) end
		elseif mode == 4 then
			if dice < 20 then self:SetKeycardType( "ci" ) end
			if dice >= 20 and dice < 40 then self:SetKeycardType( "mtf" ) end
		end
	elseif t == "mtf" then
		if mode == 0 then
			self:SetKeycardType( "euclid" )
		elseif mode == 1 then
			if dice < 75 then self:SetKeycardType( "keter" ) end
			if dice >= 75 and dice < 100 then self:SetKeycardType( "res" ) end
		elseif mode == 2 then
			self:SetKeycardType( "res" )
		elseif mode == 3 then
			if dice < 50 then self:SetKeycardType( "com" ) end
		elseif mode == 4 then
			if dice < 20 then self:SetKeycardType( "ci" ) end
			if dice >= 20 and dice < 40 then self:SetKeycardType( "com" ) end
		end	
	elseif t == "com" then
		if mode == 0 then
			self:Remove()
			return
		elseif mode == 1 then
			self:Remove()
			return
		elseif mode == 2 then
			if dice < 50 then self:SetKeycardType( "ci" ) end
		elseif mode == 3 then
			if dice < 15 then self:SetKeycardType( "omni" ) end
			if dice >= 15 and dice < 30 then self:SetKeycardType( "ci" ) end
		elseif mode == 4 then
			if dice < 50 then self:SetKeycardType( "omni" ) end
			if dice >= 50 and dice < 75 then
				self:Remove()
				return
			end
		end	
	elseif t == "omni" then
		if mode == 0 then
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "cps" )
		elseif mode == 2 then
			self:SetKeycardType( "ci" )
		elseif mode == 4 then
			self:Remove()
			return
		end	
	elseif t == "ci" then
		if mode == 0 then
			self:SetKeycardType( "safe" )
		elseif mode == 1 then
			self:SetKeycardType( "keter" )
		elseif mode == 2 then
			self:SetKeycardType( "mtf" )
		elseif mode == 3 then
			if dice < 50 then self:SetKeycardType( "omni" ) end
		elseif mode == 4 then
			if dice < 75 then self:SetKeycardType( "omni" ) end
			if dice >= 75 and dice < 100 then
				self:Remove()
				return
			end
		end	
	end

	self.Dropped = nil
	self:SetPos( exit )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	
	if CLIENT then
		self.WM = ClientsideModel( self.WorldModel )
		self.WM:SetParent( self )
		self.WM:SetPos( self:GetPos() )
		self.WM:SetNoDraw( true )

		self:InitializeLanguage()
	else
		self:SetKeycardType( "safe" )
	end
end

function SWEP:SetKeycardType( t )
	//print( "setting type: "..t )
	if SERVER then 
		self:SetNWString( "K_TYPE", t )
		self.KeycardType = t
	end

	local acc = "00000000000"
	if t == "euclid" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[2]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_2.vmt" )
		else
			self:SetNWInt( "SKIN", 1 )
		end
		self:SetSkin( 1 )
		acc = "00000000011"
	elseif t == "keter" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[3]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_3.vmt" )
		else
			self:SetNWInt( "SKIN", 2 )
		end
		self:SetSkin( 2 )
		acc = "00000100111"
	elseif t == "res" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[4]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_res.vmt" )
		else
			self:SetNWInt( "SKIN", 7 )
		end
		self:SetSkin( 7 )
		acc = "00000000111"
	elseif t == "mtf" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[5]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_guard.vmt" )
		else
			self:SetNWInt( "SKIN", 4 )
		end
		self:SetSkin( 4 )
		acc = "10001001011"
	elseif t == "com" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[6]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_com.vmt" )
		else
			self:SetNWInt( "SKIN", 5 )
		end
		self:SetSkin( 5 )
		acc = "10101101111"
	elseif t == "omni" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[7]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_omni.vmt" )
		else
			self:SetNWInt( "SKIN", 3 )
		end
		self:SetSkin( 3 )
		acc = "11111111111"
	elseif t == "cps" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[8]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_cps.vmt" )
		else
			self:SetNWInt( "SKIN", 6 )
		end
		self:SetSkin( 6 )
		acc = "10000101001"
	elseif t == "ci" then
		if CLIENT then
			self.PrintName = self.Lang.NAMES[9]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_ci.vmt" )
		else
			self:SetNWInt( "SKIN", 8 )
		end
		self:SetSkin( 8 )
		acc = "10111111011"
	else
		if CLIENT then
			self.PrintName = self.Lang.NAMES[1]
			self.WepSelectIcon = surface.GetTextureID( "slc/keycard_1.vmt" )
		else
			self:SetNWInt( "SKIN", 0 )
		end
		self:SetSkin( 0 )
		acc = "00000000001"
	end

	if CLIENT then
		local desc = { self.Lang.instructions, {} }
		local len = string.len( acc )
		for i = len, 1, -1 do
			local is = string.sub( acc, i, i ) == "1" and 1 or 2
			local ins = self.Lang.ACC[len - ( i - 1 )]
			desc[2][len - ( i - 1 )] = { ins, is }
		end
		self.AC_Doors = desc
	end

	self.Access = tonumber( acc, 2 )
end

function SWEP:OnRemove()
	if CLIENT then
		if IsValid( self.WM ) then
			self.WM:Remove()
		end
	end
end

SWEP.C_Init = false
SWEP.LThink = 0
function SWEP:Think()
	if self.LThink > CurTime() then return end
	self.LThink = CurTime() + 0.5

	local t = self:GetNWString( "K_TYPE", nil )
	if CLIENT and ( !self.C_Init or self.KeycardType != t ) then
		if t then
			self.C_Init = true
			self.KeycardType = t
			self:SetKeycardType( t )
		end
	end
end

function SWEP:Reload()
	if CLIENT then
		self.DHUD = CurTime() + 0.01
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 85,
			filter = self.Owner
		} )

		if tr.Hit then
			local ent = tr.Entity
			if IsValid( ent ) then
				if gamemode.Call( "PlayerUse", self.Owner, ent ) then
					ent:Use( self.Owner, self, USE_TOGGLE, 1 )
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then
		self.DHUD = CurTime() + 0.01
	end
end

function SWEP:PreDrawViewModel( vm, wep, ply )
	vm:SetSkin( self:GetNWInt( "SKIN", 0 ) )
end

function SWEP:CalcViewModelView( vm, oldpos, oldang, pos, ang )
	if !IsValid( self.Owner ) then return end
	local angs = self.Owner:EyeAngles()
	//ang.pitch = -ang.pitch
	return pos + angs:Forward() * 15 + angs:Right() * 5 + angs:Up() * -6, ang + Angle( 180, 10, 190 )
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	else
		if !IsValid( self.WM ) then
			print( "INVALID WORLD MODEL!" )
			return
			/*self.WM = ClientsideModel( self.WorldModel )
			self.WM:SetParent( self )
			self.WM:SetPos( self:GetPos() )
			self.WM:SetNoDraw( true )*/
		end

		local boneid = self.Owner:LookupBone( self.BoneAttachment )
		if not boneid then
			return
		end

		local matrix = self.Owner:GetBoneMatrix( boneid )
		if not matrix then
			return
		end

		local newpos, newang = LocalToWorld( self.WorldModelPositionOffset, self.WorldModelAngleOffset, matrix:GetTranslation(), matrix:GetAngles() )

		self.WM:SetPos( newpos )
		self.WM:SetAngles( newang )
		self.WM:SetupBones()
		self.WM:SetSkin( self:GetNWInt( "SKIN", 0 ) )
		self.WM:DrawModel()
	end
end

function SWEP:DrawHUD()
	if hud_disabled then return end
	if self.DHUD < CurTime() then return end

	local colors = { Color( 0, 255, 0 ), Color( 255, 0, 0 ) }
	
	if self.AC_Doors then
		local txw = draw.Text( {
			text = self.AC_Doors[1],
			pos = { ScrW() / 2, ScrH() / 3 },
			font = "SCPHUDMedium",
			color = showcolor,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		})

		for i, v in ipairs( self.AC_Doors[2] ) do
			local wid = draw.Text( {
				text = v[1].." - ",
				pos = { ScrW() / 2 - txw / 2, ScrH() / 3 + i * 25 },
				font = "SCPHUDMedium",
				color = Color( 255, 255, 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			})

			local st = v[2]
			draw.Text( {
				text = self.Lang.STATUS[st],
				pos = { ScrW() / 2 + wid - txw / 2, ScrH() / 3 + i * 25 },
				font = "SCPHUDMedium",
				color = colors[st],
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			})
		end
	end
end

hook.Add( "WeaponPickupHover", "KeycardHover", function( wep )
	if wep:GetClass() == "item_slc_keycard" and wep.PrintName == "base_weapon" then
		wep:Think()
	end
end )