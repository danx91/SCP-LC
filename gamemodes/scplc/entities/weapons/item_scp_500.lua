SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "SCP500"

SWEP.WorldModel		= "models/scp500model/scp500model.mdl"

SWEP.ShouldDrawViewModel = false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Selectable = false

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:OnSelect()
	if SERVER then
		self:Remove()

		local owner = self:GetOwner()
		if math.random( 200 ) == 69 then
			local sig = owner:TimeSignature()
			owner:AddTimer( "SCP500Choke", 3, 3, function( t, n )
				if IsValid( owner ) and owner:CheckSignature( sig ) then
					if n < 3 then
						owner:EmitSound( "SLCEffects.Choke" )
					else
						owner:SetProperty( "death_info_override", {
							type = "dead",
							args = {
								"table;WEAPONS;SCP500;death_info"
							}
						} )

						owner:Kill()
					end
				end
			end )
		else
			if IsValid( owner ) then
				local hp = owner:Health()
				local max_hp = owner:GetMaxHealth()
				if hp < max_hp then
					hp = max_hp
				end

				owner:SetHealth( hp )

				hook.Run( "SLCSCP500Used", owner )
				owner:RemoveEffect()

				owner:SetProperty( "scp500_used", CurTime() + 10 )
				PlayerMessage( "@WEAPONS.SCP500.text_used", owner, true )
			end
		end
	end
end

if SERVER then
	hook.Add( "SLCApplyEffect", "SLCSCP500", function( ply )
		local prop = ply:GetProperty( "scp500_used" )
		if prop then
			if prop >= CurTime() then
				return true
			else
				ply:SetProperty( "scp500_used", nil )
			end
		end
	end )
end

function SWEP:DrawWorldModel()
	if !IsValid( self:GetOwner() ) then
		self:DrawModel()
	end
end