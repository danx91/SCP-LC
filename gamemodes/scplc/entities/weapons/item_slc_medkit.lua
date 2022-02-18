SWEP.Base 					= "item_slc_base"
SWEP.Language 				= "MEDKIT"


SWEP.WorldModel				= "models/mishka/models/firstaidkit.mdl"
SWEP.ShouldDrawViewModel 	= false

SWEP.Primary.Automatic 		= true
SWEP.Secondary.Automatic 	= true

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/medkit.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.HealDmg 	= 40
SWEP.HealRand 	= 10
SWEP.Charges 	= 3
SWEP.MaxCharges = 3
SWEP.HealTime 	= 3

SWEP.NextHeal 	= 0

SWEP.Skin = 0

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Charges", "Int" )
	self:AddNetworkVar( "HealEnd", "Float" )

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

		self:ResetData()
	end
end

function SWEP:OnDrop()
	self:ResetData()
end

function SWEP:Think()
	if self.NextCheck then
		if self.NextCheck < CurTime() then
			self:ResetData()
		end
	end
end

function SWEP:ResetData( time )
	self:PopSpeed()
	self.NextHeal = CurTime() + ( time or 3 )

	self.Healing = nil
	self.NextCheck = nil
	self:SetHealEnd( 0 )
end

function SWEP:PrimaryAttack()
	if ROUND.post or self.NextHeal > CurTime() then return end

	local owner = self:GetOwner()
	//if hook.Run( "SLCCanHeal", owner, owner, "medkit" ) == false then return end
	if hook.Run( "SLCHealing", "can_heal", owner, owner, "medkit" ) == false then return end

	self.NextHeal = CurTime() + 0.2
	self:Heal( owner, true )
end

function SWEP:SecondaryAttack()
	if ROUND.post or self.NextHeal > CurTime() then return end
	self.NextHeal = CurTime() + 0.2

	local owner = self:GetOwner()

	local start = owner:GetShootPos()
	local trace = util.TraceHull{
		start = start,
		endpos = start + owner:GetAimVector() * 50,
		filter = owner,
		mins = Vector( -8, -8, -8 ),
		maxs = Vector( 8, 8, 8 )
	}

	local ent = trace.Entity

	if IsValid( ent ) and ent:IsPlayer() then
		//if hook.Run( "SLCCanHeal", ent, owner, "medkit" ) != false then
		if hook.Run( "SLCHealing", "can_heal", owner, owner, "medkit" ) != false then
			self:Heal( ent )
		end
	end
end

function SWEP:PopSpeed()
	if SERVER then
		if IsValid( self.Healing ) then
			self.Healing:PopSpeed( "SLC_Medkit" )
		end

		local owner = self:GetOwner()
		if IsValid( owner ) then
			owner:PopSpeed( "SLC_Medkit" )
		elseif IsValid( self.HLOwner ) then
			self.HLOwner:PopSpeed( "SLC_Medkit" )
		end
	end
end

function SWEP:Heal( ply, sh )
	if !ply:Alive() or ply:SCPTeam() == TEAM_SPEC or ( !sh and ply:SCPTeam() == TEAM_SCP ) then return end

	local owner = self:GetOwner()
	local ct = CurTime()

	if IsValid( self.Healing ) then
		if self.Healing == ply then
			self.NextCheck = ct + 0.3

			if self:GetHealEnd() <= ct then
				local rnd = math.random() * 2 - 1
				local heal = self.HealDmg + math.ceil( self.HealRand * rnd )

				//local override = hook.Run( "SLCScaleHealing", self.Healing, owner, heal )
				local override = hook.Run( "SLCHealing", "scale_heal", self.Healing, owner, heal )

				if override == true then
					heal = 0
				elseif isnumber( override ) then
					heal = override
				end

				local hp = math.min( self.Healing:Health() + heal, self.Healing:GetMaxHealth() )
				self.Healing:SetHealth( hp )
				hook.Run( "SLCHealing", "healed", self.Healing, owner )
				--print( self.Healing, self.Healing:Health(), self.HealDmg + math.ceil( self.HealRand * rnd ) )
				self:PopSpeed()

				if SERVER and self.Healing != owner then
					owner:AddFrags( 1 )
					PlayerMessage( "healplayer$1", owner )
				end

				self.Healing = nil
				self.NextCheck = nil
				self:SetHealEnd( 0 )

				self.NextHeal = ct + 3
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
			self.NextHeal = ct + 3
		end
	elseif ply:Health() < ply:GetMaxHealth() * 0.9 then
		self.Healing = ply

		if SERVER then
			self.HLOwner = owner
			owner:PushSpeed( 0.2, 0.2, -1, "SLC_Medkit" )

			if !sh then
				ply:PushSpeed( 0.2, 0.2, -1, "SLC_Medkit" )
			end
		end
		
		self.NextCheck = ct + 0.3
		self:SetHealEnd( ct + self.HealTime )
	end
end

function SWEP:DrawWorldModel()
	if !IsValid( self:GetOwner() ) then
		self:DrawModel()
	end
end

function SWEP:DrawHUD()
	if hud_disabled then return end

	local heal_end = self:GetHealEnd()
	local ct = CurTime()
	if heal_end > ct then
		draw.NoTexture()
		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRing( ScrW() * 0.5, ScrH() * 0.5, 30, 6, 360, 40, 1 - ( heal_end - ct ) / self.HealTime )
	end
end