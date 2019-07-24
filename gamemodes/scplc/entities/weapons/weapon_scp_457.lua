SWEP.Base 		= "weapon_scp_base"
SWEP.PrintName	= "SCP-457"

SWEP.HoldType	= "normal"

SWEP.Traps = {}
SWEP.MaxTraps = 5
SWEP.TrapCD = 0

SWEP.NextDMG = 0
SWEP.NCheck = 0

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "Traps" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP457" )
end

function SWEP:Think()
	if SERVER then
		if self.Owner:WaterLevel() > 0 then
			if self.NextDMG < CurTime() and self.Owner:Health() > 1 then
				self.NextDMG = CurTime() + 0.1
				self.Owner:SetHealth( math.max( 1, self.Owner:Health() - 20 ) )
			end
		elseif !self.Owner:IsBurning() then
			self.Owner:Burn( -3, 125, self.Owner, 2 ):SetShouldHurtOwner( false )
		end

		if self.NCheck < CurTime() then
			self.NCheck = CurTime() + 1

			for i = 1, #self.Traps do
				if !IsValid( self.Traps[i] ) then
					table.remove( self.Traps, i )
				end
			end

			self:SetTraps( #self.Traps )
		end
	end
end

function SWEP:SecondaryAttack()
	if self.TrapCD > CurTime() then return end

	local hp = self.Owner:Health()
	local maxhp = self.Owner:GetMaxHealth()

	if hp <= maxhp * 0.1 then return end

	local tr = util.TraceLine{
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 175,
		mask = MASK_SOLID_BRUSHONLY
	}

	if tr.Hit and tr.HitNormal.z > 0.35 then
		self.TrapCD = CurTime() + 8

		if SERVER then
			local traps = #self.Traps

			if traps >= self.MaxTraps then
				local oldest = table.remove( self.Traps, 1 )

				if IsValid( oldest ) then
					oldest:Remove()
				end
			end

			local trap = ents.Create( "slc_fire_trap" )
			trap:SetPos( tr.HitPos )
			trap:SetOwner( self.Owner )
			trap:SetLifeTime( 180 )
			trap:Spawn()

			table.insert( self.Traps, trap )

		end

		self:SetTraps( math.min( self:GetTraps() + 1, self.MaxTraps ) )
		self.Owner:SetHealth( hp - maxhp * 0.04 )
	end
end

function SWEP:DrawHUD()
	if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	local txt, color
	if self.TrapCD > CurTime() then
		txt = string.format( self.Lang.swait, math.ceil( self.TrapCD - CurTime() ) )
		color = Color( 255, 0, 0 )
	elseif self.Owner:Health() <= self.Owner:GetMaxHealth() * 0.1 then
		txt = self.Lang.nohp
		color = Color( 255, 0, 0 )
	else
		txt = self.Lang.sready
		color = Color( 0, 255, 0 )
	end

	local tw, th = draw.Text{
		text = txt,
		pos = { ScrW() * 0.5, ScrH() * 0.97 },
		color = color,
		font = "SCPHUDSmall",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}

	draw.Text{
		text = string.format( self.Lang.placed, self:GetTraps(), self.MaxTraps ),
		pos = { ScrW() * 0.5, ScrH() * 0.97 - th },
		color = Color( 0, 255, 0 ),
		font = "SCPHUDSmall",
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}
end

hook.Add( "EntityTakeDamage", "SCP457Damage", function( ply, dmg )
	if !ply:IsPlayer() or !ply:Alive() then return end
	if ply:SCPClass() == CLASSES.SCP457 then
		if dmg:IsDamageType( DMG_BURN ) then
			return true
		end
	end
end )