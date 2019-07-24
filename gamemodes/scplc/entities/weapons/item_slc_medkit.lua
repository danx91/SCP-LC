SWEP.Base 					= "item_slc_base"
SWEP.Language 				= "MEDKIT"


SWEP.WorldModel				= "models/mishka/models/firstaidkit.mdl"
SWEP.ShouldDrawViewModel 	= false

SWEP.Primary.Automatic 		= true
SWEP.Secondary.Automatic 	= true

SWEP.SelectFont = "SCPHUDMedium"

SWEP.HealDmg 	= 40
SWEP.HealRand 	= 5
SWEP.Charges 	= 3
SWEP.MaxCharges = 3
SWEP.HealTime 	= 3

SWEP.NextHeal 	= 0

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
end

function SWEP:OwnerChanged()
	if CLIENT then
		self.PrintName = string.format( self.Lang.name, self:GetCharges() )
	end
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
	if self.NextHeal > CurTime() then return end
	self.NextHeal = CurTime() + 0.2

	self:Heal( self.Owner, true )
end

function SWEP:SecondaryAttack()
	if self.NextHeal > CurTime() then return end
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
		self:Heal( ent )
	end
end

function SWEP:PopSpeed()
	if CLIENT then return end

	if IsValid( self.Healing ) and self.HealingSpd then
		self.Healing:PopSpeed( self.HealingSpd )
		self.HealingSpd = nil
	end

	if self.OwnerSpd then
		self.Owner:PopSpeed( self.OwnerSpd )
		self.OwnerSpd = nil
	end
end

function SWEP:Heal( ply, sh )
	if !ply:Alive() or ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

	if IsValid( self.Healing ) then
		if self.Healing == ply then
			self.NextCheck = CurTime() + 0.3

			if self.HealEnd <= CurTime() then
				local rnd = math.random() * 2 - 1
				local hp = math.min( self.Healing:Health() + self.HealDmg + math.ceil( self.HealRand * rnd ), self.Healing:GetMaxHealth() )
				self.Healing:SetHealth( hp )
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
		if SERVER then self.OwnerSpd = self.OwnerSpd or self.Owner:PushSpeed( 0.2, 0.2, -1 ) end
		if SERVER and !sh then self.HealingSpd = ply:PushSpeed( 0.2, 0.2, -1 ) end
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