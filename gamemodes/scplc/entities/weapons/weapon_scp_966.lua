SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-966"

SWEP.HoldType		= "normal"

SWEP.NextAttack = 0
SWEP.AttackCD = 1

SWEP.LockOnEnd = 0

function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Target" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP966" )
end

SWEP.LastOK = false
SWEP.nrndsnd = 0
function SWEP:Think()
	local owner = self:GetOwner()

	if SERVER then
		if self.nrndsnd < CurTime() then
			self.nrndsnd = CurTime() + 10

			owner:EmitSound( "SCP966.Random" )
		end
	end

	local target = self:GetTarget()

	if self.LockOnEnd > CurTime() and !IsValid( target ) and self.LastOK then
		self.LockOnEnd = 0
	end

	if IsValid( target ) then
		self.LastOK = true
		local t = target:SCPTeam()

		if target:GetPos():Distance( owner:GetPos() ) > 110 + ( self:GetUpgradeMod( "dist" ) or 0 ) or t == TEAM_SPEC or t == TEAM_SCP then
			self.LockOnEnd = 0
			self:SetTarget( NULL )
		end

		if self.LockOnEnd > 0 and self.LockOnEnd < CurTime() then
			if SERVER then
				owner:EmitSound( "SCP966.Attack" )

				target:TakeDamage( 15 + ( self:GetUpgradeMod( "dmg" ) or 0 ), owner, owner )

				local b = ( self:GetUpgradeMod( "bleed" ) or 0 )

				local tier = math.random( 1, 100 ) <= b and 2 or 1
				target:ApplyEffect( "bleeding", tier, owner )
			end


			self.LockOnEnd = CurTime() + 3 - ( self:GetUpgradeMod( "time" ) or 0 )
		end
	else
		self.LastOK = false
	end
end

function SWEP:PrimaryAttack()
	if self.NextAttack > CurTime() then return end
	self.NextAttack = CurTime() + self.AttackCD

	if self.LockOnEnd > CurTime() then return end

	local owner = self:GetOwner()
	local start = owner:GetShootPos()

	local trace = util.TraceHull( {
		start = start,
		endpos = start + owner:GetAimVector() * 90,
		mask = MASK_SHOT,
		filter = owner,
		mins = Vector( -5, -5, -5 ),
		maxs = Vector( 5, 5, 5 )
	} )

	local entity = trace.Entity
	if IsValid( entity ) then
		if entity:IsPlayer() then
			local t = entity:SCPTeam()

			if t != TEAM_SPEC and t != TEAM_SCP then
				self:SetTarget( entity )
				self.LockOnEnd = CurTime() + 3 - ( self:GetUpgradeMod( "time" ) or 0 )
			end
		else
			self:SCPDamageEvent( entity, 50 )
		end
	end
end

function SWEP:DrawSCPHUD()
	//if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	local target = self:GetTarget()
	if IsValid( target ) then
		local pos = target:GetPos() + target:OBBCenter() * 1.5
		local scr = pos:ToScreen()

		local x = math.Clamp( scr.x, 24, ScrW() - 24 )
		local y = math.Clamp( scr.y, 24, ScrH() - 24 )

		draw.NoTexture()

		local crl = math.Clamp( target:GetPos():Distance( self.Owner:GetPos() ) / ( 110 + ( self:GetUpgradeMod( "dist" ) or 0 ) ) * 225, 0, 225 )
		surface.SetDrawColor( Color( 15 + crl, 240 - crl, 0 ) )
		surface.DrawRing( x, y, 16, 4, 360, 16 )

		surface.SetDrawColor( Color( 220, 220, 220 ) )
		surface.DrawRing( x, y, 20, 4, ( self.LockOnEnd - CurTime() ) / 3 * 360, 16 )
	end
end

hook.Add( "CanPlayerSeePlayer", "SCP966Visibility", function( ply, target )
	local target_c = target:SCPClass()

	if target_c == CLASSES.SCP966 then
		local ply_t = ply:SCPTeam()

		if ply_t == TEAM_SCP then
			return
		end

		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) and wep:GetClass() == "item_slc_nvg" and wep:GetBattery() > 0 then
			return
		end

		local nvgp = ply:GetWeapon( "item_slc_nvgplus" )
		if IsValid( nvgp ) and nvgp:GetEnabled() then
			return
		end

		return false
	end
end )

-- hook.Add( "DoPlayerDeath", "SCP966Damage", function( ply, attacker, info )
-- 	if attacker:IsPlayer() and attacker:SCPClass() == CLASSES.SCP966 then
-- 	 	AddRoundStat( "966" )
-- 	 	local wep = attacker:GetWeapon( "weapon_scp_966" )
-- 	 	if IsValid( wep ) then
-- 	 		wep:AddScore( 1 )
-- 	 	end
-- 	end
-- end )

hook.Add( "EntityTakeDamage", "SCP966DMG", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() then
		local ply = dmg:GetAttacker()
		if IsValid( ply ) and ply:IsPlayer() and ply:SCPClass() == CLASSES.SCP966 then
			local wep = ply:GetActiveWeapon()
			if IsValid( wep ) and wep.UpgradeSystemMounted then
				wep:AddScore( dmg:GetDamage() )
			end
		end
	end
end )

DefineUpgradeSystem( "scp966", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "lockon1", cost = 2, req = {}, reqany = false,  pos = { 1, 1 }, mod = { time = 0.5 }, active = false },
		{ name = "lockon2", cost = 4, req = { "lockon1" }, reqany = false,  pos = { 1, 2 }, mod = { time = 1 }, active = false },

		{ name = "dist1", cost = 2, req = {}, reqany = false,  pos = { 2, 1 }, mod = { dist = 15 }, active = false },
		{ name = "dist2", cost = 3, req = { "dist1" }, reqany = false,  pos = { 2, 2 }, mod = { dist = 30 }, active = false },
		{ name = "dist3", cost = 4, req = { "dist2" }, reqany = false,  pos = { 2, 3 }, mod = { dist = 45 }, active = false },

		{ name = "dmg1", cost = 3, req = {}, reqany = false,  pos = { 3, 1 }, mod = { dmg = 5 }, active = false },
		{ name = "dmg2", cost = 3, req = { "dmg1" }, reqany = false,  pos = { 3, 2 }, mod = { dmg = 10 }, active = false },

		{ name = "bleed1", cost = 3, req = { "dmg1" }, reqany = false,  pos = { 4, 2 }, mod = { bleed = 25 }, active = false },
		{ name = "bleed2", cost = 5, req = { "bleed1" }, reqany = false,  pos = { 4, 3 }, mod = { bleed = 50 }, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 1 }, mod = {}, active = false },
	},
	rewards = { --16+1
		{ 100, 1 },
		{ 200, 1 },
		{ 300, 1 },
		{ 500, 2 },
		{ 700, 2 },
		{ 900, 3 },
		{ 1000, 3 },
		{ 1200, 3 }
	}
} )

InstallUpgradeSystem( "scp966", SWEP )

addSounds( "SCP966.Random", "scp/966/Random%i.ogg", 80, 1, 100, CHAN_STATIC, 0, 5 )
addSounds( "SCP966.Attack", "scp/966/Slash%i.ogg", 75, 0.75, 100, CHAN_STATIC, 0, 1 )