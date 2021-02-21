SWEP.Base 					= "item_slc_base"
SWEP.Language 				= "MEDKIT"


SWEP.WorldModel				= "models/mishka/models/firstaidkit.mdl"
SWEP.ShouldDrawViewModel 	= false

SWEP.Primary.Automatic 		= true
SWEP.Secondary.Automatic 	= true

SWEP.SelectFont = "SCPHUDMedium"

SWEP.HealDmg 	= 40
SWEP.HealRand 	= 10
SWEP.Charges 	= 3
SWEP.MaxCharges = 3
SWEP.HealTime 	= 3

SWEP.NextHeal 	= 0

SWEP.Skin = 0

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Charges", "Int" )

	self:SetCharges( self.Charges )
end

function SWEP:Initialize()
	self:CallBaseClass( "Initialize" )

	if CLIENT then
		self.ShowName = self.Lang.showname
		self.PrintName = string.format( self.Lang.name, self.Charges )
	end

	self:SetSkin( self.Skin or 0 )
end

function SWEP:Equip()
	if CLIENT then
		self.PrintName = string.format( self.Lang.name, self:GetCharges() )

		if !IsValid( self.Owner ) then
			self.NextHeal = CurTime() + 3

			self.Healing = nil
			self.NextCheck = nil
			self.HealEnd = nil
		end
	end
end

function SWEP:OnDrop()
	self:PopSpeed()
	self.NextHeal = CurTime() + 3

	self.Healing = nil
	self.NextCheck = nil
	self.HealEnd = nil
end

function SWEP:Think()
	if self.NextCheck then
		if self.NextCheck < CurTime() then
			self:PopSpeed()
			self.NextHeal = CurTime() + 3

			self.Healing = nil
			self.NextCheck = nil
			self.HealEnd = nil
		end
	end
end

function SWEP:PrimaryAttack()
	if ROUND.post or self.NextHeal > CurTime() then return end

	local owner = self:GetOwner()
	if owner:HasEffect( "radiation" ) then return end

	self.NextHeal = CurTime() + 0.2
	self:Heal( owner, true )
end

function SWEP:SecondaryAttack()
	if ROUND.post or self.NextHeal > CurTime() then return end
	self.NextHeal = CurTime() + 0.2

	local start = self.Owner:GetShootPos()
	local trace = util.TraceHull{
		start = start,
		endpos = start + self.Owner:GetAimVector() * 50,
		filter = self.Owner,
		mins = Vector( -8, -8, -8 ),
		maxs = Vector( 8, 8, 8 )
	}

	local ent = trace.Entity

	if IsValid( ent ) and ent:IsPlayer() then
		if !ent:HasEffect( "radiation" ) then 
			self:Heal( ent )
		end
	end
end

function SWEP:PopSpeed()
	if SERVER then
		if IsValid( self.Healing ) then
			self.Healing:PopSpeed( "SLC_Medkit" )
		end

		if IsValid( self.Owner ) then
			self.Owner:PopSpeed( "SLC_Medkit" )
		elseif IsValid( self.HLOwner ) then
			self.HLOwner:PopSpeed( "SLC_Medkit" )
		end
	end
end

function SWEP:Heal( ply, sh )
	if !ply:Alive() or ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

	if IsValid( self.Healing ) then
		if self.Healing == ply then
			self.NextCheck = CurTime() + 0.3

			if self.HealEnd <= CurTime() then
				local rnd = math.random() * 2 - 1
				local heal = self.HealDmg + math.ceil( self.HealRand * rnd )

				local override = hook.Run( "SLCScaleHealing", self.Healing, self.Owner, heal )

				if override == true then
					heal = 0
				elseif isnumber( override ) then
					heal = override
				end

				local hp = math.min( self.Healing:Health() + heal, self.Healing:GetMaxHealth() )
				self.Healing:SetHealth( hp )
				self.Healing:RemoveEffect( "bleeding", true )
				--print( self.Healing, self.Healing:Health(), self.HealDmg + math.ceil( self.HealRand * rnd ) )
				self:PopSpeed()

				if SERVER and self.Healing != self.Owner then
					self.Owner:AddFrags( 1 )
					PlayerMessage( "healplayer$1", self.Owner )
				end

				self.Healing = nil
				self.NextCheck = nil
				self.HealEnd = nil

				self.NextHeal = CurTime() + 3
				self.Charges = self:GetCharges() - 1

				if CLIENT then
					self.PrintName = string.format( self.Lang.name, self.Charges )
				end

				if SERVER then
					self:SetCharges( self.Charges )

					if self.Charges <= 0 then
						self:Remove()
					end
				end
			end
		else
			self:PopSpeed()
			self.Healing = nil
			self.NextHeal = CurTime() + 3
		end
	elseif ply:Health() < ply:GetMaxHealth() * 0.9 then
		self.Healing = ply

		if SERVER then
			self.HLOwner = self.Owner
			self.Owner:PushSpeed( 0.2, 0.2, -1, "SLC_Medkit" )

			if !sh then
				ply:PushSpeed( 0.2, 0.2, -1, "SLC_Medkit" )
			end
		end
		
		self.NextCheck = CurTime() + 0.3
		self.HealEnd = CurTime() + self.HealTime
	end
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

function SWEP:DrawHUD()
	if hud_disabled then return end

	if self.HealEnd then
		draw.NoTexture()
		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRing( ScrW() * 0.5, ScrH() * 0.5, 30, 6, 360, 40, 1 - ( self.HealEnd - CurTime() ) / self.HealTime )
	end
end