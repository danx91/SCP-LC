SWEP.Base 				= "weapon_scp_base"
SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-049"

SWEP.HoldType 			= "normal"

SWEP.Zombies = {
	{ name = "normal", speed = 1, health = 1, damage = 1, mdl = nil, material = "" }, --standard zombie
	{ name = "light", speed = 1.3, health = 0.7, damage = 0.6, mdl = nil, material = "" }, --fast zombie
	{ name = "heavy", speed = 0.7, health = 1.4, damage = 1.3, mdl = nil, material = "" }, --heavy zombie
}

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP049" )
end

--SWEP.Target = NULL
SWEP.Targets = {}
SWEP.LastAttack = 0

SWEP.NCheck = 0
SWEP.NHeal = 0
function SWEP:Think()
	self:PlayerFreeze()

	if CLIENT then
		if self.HoldingReload and self.HoldingReload < CurTime() then
			self.HoldingReload = false

			CloseWheelMenu()
		end
	end

	if self.PerformingSurgery and self.SurgeryEnd then
		if self.SurgeryEnd < CurTime() then
			self:FinishSurgery( self.ZombieType, self.TargetBody )

			self.PerformingSurgery = false
			self.SurgeryEnd = nil
			self.ZombieType = nil
			self.TargetBody = nil
		end
	end

	if self.NCheck > CurTime() then return end
	self.NCheck = CurTime() + 0.1

	for k, v in pairs( self.Targets ) do
		if !IsValid( k ) or !k:CheckSignature( v[2] ) then
			self.Targets[k] = nil
		end
	end

	if SERVER and self.NHeal < CurTime() then
		self.NHeal = CurTime() + 180

		local heal = self:GetUpgradeMod( "heal" )
		if heal then
			self:GetOwner():AddHealth( heal )
		end
	end
end

SWEP.NAttack = 0
function SWEP:PrimaryAttack()
	if self.NAttack > CurTime() then return end
	
	local owner = self:GetOwner()
	local pos = owner:GetShootPos()

	owner:LagCompensation( true )

	local tr = util.TraceLine{
		start = pos,
		endpos = pos + owner:GetAimVector() * 75,
		filter = owner,
		mask = MASK_SHOT
	}

	owner:LagCompensation( false )

	local ent = tr.Entity
	if IsValid( ent ) and ent:IsPlayer() then
		if ent:SCPTeam() != TEAM_SPEC and ent:SCPTeam() != TEAM_SCP then
			self.NAttack = CurTime() + 5 - ( self:GetUpgradeMod( "cd" ) or 0 )

			if !self.Targets[ent] then
				self.Targets[ent] = { 0, ent:TimeSignature(), 0 }
			end

			local tab = self.Targets[ent]
			tab[3] = CurTime() + 2
			tab[1] = tab[1] + 1

			if tab[1] >= 3 then
				self.Targets[ent] = nil

				if SERVER then
					if ent:GetSCP714() then
						ent:PlayerDropWeapon( "item_scp_714" )
					else
						local dmginfo = DamageInfo()

						dmginfo:SetDamage( ent:Health() )
						dmginfo:SetAttacker( owner )
						dmginfo:SetDamageType( DMG_DIRECT )

						ent:TakeDamageInfo( dmginfo )

						self:AddScore( 1 )
					end
				end
			end

			if SERVER then
				owner:EmitSound( "SCP049.Attack" )
				
				owner:PushSpeed( 0.6, 0.6, -1, "SLC_SCP049Speed" )
				timer.Simple( 5, function()
					if IsValid( self ) and IsValid( owner ) then
						owner:PopSpeed( "SLC_SCP049Speed" )
					end
				end )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:CallBaseClass( "PrimaryAttack" )
end

SWEP.HoldingReload = false
function SWEP:Reload()
	if CLIENT then
		if self.PerformingSurgery then return end

		if !self.HoldingReload then
			local owner = self:GetOwner()
			local pos = owner:GetShootPos()

			local tr = util.TraceLine{
				start = pos,
				endpos = pos + owner:GetAimVector() * 75,
				filter = owner,
				mask = MASK_SHOT
			}

			local ent = tr.Entity
			if IsValid( ent ) and ent:GetClass() == "prop_ragdoll" then
				if ent:GetNWInt( "team", TEAM_SCP ) != TEAM_SCP then
					local options = {}

					for i, v in ipairs( self.Zombies ) do
						table.insert( options, { v.material, self.Lang.zombies[v.name] or v.name, tostring( i ) } )
					end

					OpenWheelMenu( options, function( selected )
						if selected then
							net.Ping( "SLC_SCP049", selected )
							self:Zombify( selected, ent )
						end
					end )
				end
			end
		end

		self.HoldingReload = CurTime() + 0.1
	end
end

function SWEP:Zombify( t, ent )
	t = tonumber( t )

	if t then
		self.PerformingSurgery = true
		self.SurgeryEnd = CurTime() + 15 - ( self:GetUpgradeMod( "surgery_time" ) or 0 )
		self.ZombieType = t
		self.TargetBody = ent
	end
end

SWEP.SurgeryStacks = 0
function SWEP:FinishSurgery( t, ent )
	if SERVER then
		local owner = self:GetOwner()
		local ply
		local spawnent

		if IsValid( ent ) and ent.Data then
			spawnent = ent
			if ent.Data.team != TEAM_SCP then
				local bodyOwner = ent:GetOwner()

				if IsValid( bodyOwner ) and bodyOwner:SCPTeam() == TEAM_SPEC then
					ply = bodyOwner
				end
			end
		else
			spawnent = owner
		end

		if !ply then
			local qp = GetQueuePlayers( 1 )[1]
			if qp then
				ply = qp
			end
		end

		if ply then
			local hpbonus = ( self:GetUpgradeMod( "hp" ) or 0 ) + self.SurgeryStacks * 0.025

			local stats = self.Zombies[t] or {}
			local scp = GetSCP( "SCP0492" )
			scp:SetupPlayer( ply, spawnent:GetPos(), owner, (stats.health or 1) + hpbonus, stats.speed or 1, stats.damage or 1, self:GetUpgradeMod( "steal" ) or 0, stats.model )

			if self:HasUpgrade( "rm" ) then
				local qp = GetQueuePlayers( 1 )[1]

				if qp then
					scp:SetupPlayer( qp, spawnent:GetPos(), owner, ((stats.health or 1) + hpbonus) * 0.5, stats.speed or 1, (stats.damage or 1) * 0.75, self:GetUpgradeMod( "steal" ) or 0, stats.model )
				end
			end

			if IsValid( ent ) then
				ent:Remove()
			end

			AddRoundStat( "049" )
			self:AddScore( 3 )

			if self:HasUpgrade( "hidden" ) then
				self.SurgeryStacks = self.SurgeryStacks + 1
			end

			--self heal
			local sh = self:GetUpgradeMod( "sh" )
			if sh then
				owner:AddHealth( math.ceil( owner:GetMaxHealth() * sh ) )
			end

			--zombie heal
			local zh = self:GetUpgradeMod( "zh" )
			if zh then
				local ownerpos = owner:GetPos()

				for k, v in pairs( player.GetAll() ) do
					if v:SCPClass() == CLASSES.SCP0492 and v:GetPos():DistToSqr( ownerpos ) <= 250000 then
						v:AddHealth( math.ceil( v:GetMaxHealth() * zh ) )
					end
				end
			end
		else
			CenterMessage( "@WEAPONS.SCP049.surgery_failed#255,0,0;time:5", owner )
		end
	end
end

function SWEP:DrawHUD()
	if hud_disabled or HUDDrawInfo or ROUND.preparing then return end

	local owner = self:GetOwner()
	local ply = owner:GetEyeTrace().Entity

	if IsValid( ply ) and ply:IsPlayer() then
		if owner:GetPos():DistToSqr( ply:GetPos() ) < 14400 then
			if self.Targets[ply] then
				local tab = self.Targets[ply]
				local progress = 0

				if tab[3] > CurTime() then
					progress = math.Map( tab[3] - CurTime(), 2, 0, 0, 1 )
				else
					progress = 1
				end

				local w, h = ScrW(), ScrH()

				draw.NoTexture()
				surface.SetDrawColor( Color( 100, 100, 100 ) )
				surface.DrawRing( w * 0.5, h * 0.5, 40, 10, 160, 30, tab[1] == 1 and progress or 1, 10 )

				if tab[1] > 1 then
					surface.DrawRing( w * 0.5, h * 0.5, 40, 10, 160, 30, tab[1] == 2 and progress or 1, 190 )
				end
			end
		end
	end

	if self.PerformingSurgery and self.SurgeryEnd and self.SurgeryEnd > CurTime() then
		draw.Text{
			text = self.Lang.surgery,
			pos = { ScrW() * 0.5, ScrH() * 0.6 },
			color = Color( 150, 150, 150, 255 ),
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		draw.Text{
			text = math.ceil( self.SurgeryEnd - CurTime() ),
			pos = { ScrW() * 0.5, ScrH() * 0.63 },
			color = Color( 150, 150, 150, 255 ),
			font = "SCPHUDMedium",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
end

addSounds( "SCP049.Attack", "scp/049/attack%i.ogg", 120, 1, 100, CHAN_STATIC, 0, 4 )

if SERVER then
	net.ReceivePing( "SLC_SCP049", function( data, ply )
		local wep = ply:GetWeapon( "weapon_scp_049" )
		if IsValid( wep ) then
			local pos = ply:GetShootPos()

			local tr = util.TraceLine{
				start = pos,
				endpos = pos + ply:GetAimVector() * 75,
				filter = ply,
				mask = MASK_SHOT
			}

			local ent = tr.Entity
			if IsValid( ent ) and ent:GetClass() == "prop_ragdoll" and ent.Data then
				if ent:GetNWInt( "team", TEAM_SCP ) != TEAM_SCP then
					wep:Zombify( data, ent )
					return
				end
			end

			net.Ping( "SLC_SCP049", "", ply )
		end
	end )

	hook.Add( "EntityTakeDamage", "SLCSCP049Surgery", function( target, info )
		if IsValid( target ) and target:IsPlayer() and target:SCPClass() == CLASSES.SCP049 then
			local wep = target:GetWeapon( "weapon_scp_049" )
			if IsValid( wep ) then
				if wep.PerformingSurgery then
					wep.PerformingSurgery = false
					wep.SurgeryEnd = nil
					wep.ZombieType = nil
					wep.TargetBody = nil

					net.Ping( "SLC_SCP049", "", target )
				end

				if info:IsDamageType( DMG_BULLET ) then
					local def = wep:GetUpgradeMod( "def" )
					if def then
						info:ScaleDamage( def )
					end
				end
			end
		end
	end )
end

if CLIENT then
	net.ReceivePing( "SLC_SCP049", function( data )
		local wep = LocalPlayer():GetWeapon( "weapon_scp_049" )
		if IsValid( wep ) then
			wep.PerformingSurgery = false
			wep.SurgeryEnd = nil
			wep.ZombieType = nil
			wep.TargetBody = nil
		end
	end )
end

hook.Add( "StartCommand", "SLCSCP049Zombify", function( ply, cmd )
	if IsValid( ply ) and ply:SCPClass() == CLASSES.SCP049 then
		local wep = ply:GetWeapon( "weapon_scp_049" )
		if IsValid( wep ) then
			if wep.PerformingSurgery then
				cmd:ClearButtons()
				cmd:ClearMovement()

				cmd:SetButtons( IN_DUCK )
			end
		end
	end
end )

DefineUpgradeSystem( "scp049", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "cure1", cost = 2, req = {}, reqany = false, pos = { 1, 1 }, mod = { def = 0.6 }, active = false },
		{ name = "cure2", cost = 3, req = { "cure1" }, reqany = false, pos = { 1, 2 }, mod = { heal = 300 }, active = false },
		{ name = "merci", cost = 5, req = { "cure2" }, reqany = false, pos = { 1, 3 }, mod = { cd = 2.5 }, active = true },

		{ name = "symbiosis1", cost = 1, req = {}, reqany = false, pos = { 2, 1 }, mod = { sh = 0.025 }, active = false },
		{ name = "symbiosis2", cost = 3, req = { "symbiosis1" }, reqany = false, pos = { 2, 2 }, mod = { sh = 0.05, zh = 0.025 }, active = false },
		{ name = "symbiosis3", cost = 5, req = { "symbiosis2" }, reqany = false, pos = { 2, 3 }, mod = { sh = 0.075, zh = 0.05 }, active = false },

		{ name = "hidden", cost = 5, req = {}, reqany = false, pos = { 3, 1 }, mod = {}, active = false },
		{ name = "trans", cost = 3, req = { "hidden" }, reqany = false, pos = { 3, 2 }, mod = { hp = 0.15, steal = 0.1 }, active = false },
		{ name = "rm", cost = 7, req = { "trans", "doc2" }, reqany = true, pos = { 3, 3 }, mod = {}, active = false },

		{ name = "doc1", cost = 1, req = {}, reqany = false, pos = { 4, 1 }, mod = { surgery_time = 5 }, active = false },
		{ name = "doc2", cost = 4, req = { "doc1" }, reqany = false, pos = { 4, 2 }, mod = { surgery_time = 10 }, active = false },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 3 }, mod = {}, active = false },
	},
	rewards = { --21
		{ 1, 1 },
		{ 2, 1 },
		{ 4, 1 },
		{ 6, 1 },
		{ 8, 2 },
		{ 10, 1 },
		{ 12, 2 },
		{ 16, 2 },
		{ 20, 2 },
		{ 24, 2 },
		{ 28, 2 },
		{ 32, 2 },
		{ 36, 2 },
	}
} )

function SWEP:OnUpgradeBought( name, info, group )
	if SERVER and name == "merci" then
		self:GetOwner():SetSCPTerror( false )
	end
end

InstallUpgradeSystem( "scp049", SWEP )