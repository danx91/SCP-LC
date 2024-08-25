SWEP.Base 			= "weapon_scp_base"
SWEP.PrintName		= "SCP-2427-3"

SWEP.HoldType		= "melee"

SWEP.DisableDamageEvent = true
SWEP.ScoreOnDamage 	= true

SWEP.ChangeCooldown = 10

SWEP.JEvidenceMultiplier = 0.6
SWEP.JEvidenceLoss = 0.5

SWEP.PPassiveDefense = 0.2
SWEP.PPassiveSlow = 0.2
SWEP.PEvidenceDot = 0.85
SWEP.PEvidenceRate = 0.03

SWEP.DashCooldown = 8
SWEP.DashDamage = 30
SWEP.DashMaxDistance = 315

SWEP.CamouflageCooldown = 40
SWEP.CamouflageDuration = 20

SWEP.DrainCooldown = 50
SWEP.DrainDamage = 50
SWEP.DrainTime = 10
SWEP.DrainSlow = 0.3
SWEP.DrainSlowTime = 5

SWEP.SpectateCooldown = 60
SWEP.SpectateRadius = 2000
SWEP.SpectateTime = 30
SWEP.SpectateDefense = 0.1
SWEP.SpectateSpeed = 500

SWEP.SpecialCooldown = 240
SWEP.SpecialDamage = 100
SWEP.SpecialTime = 12
SWEP.SpecialDuration = 20
SWEP.SpecialDefense = 0.5

SWEP.GhostDuration = 12
SWEP.GhostCooldown = 75
SWEP.GhostRadius = 1500
SWEP.GhostDelay = 0.2
SWEP.GhostHeal = 0.6
SWEP.GhostSpeed = 1.25

local hud_materials = {
	primary = {
		Material( "slc/hud/scp/24273/dash.png", "smooth" ),
		Material( "slc/hud/scp/24273/camo.png", "smooth" ),
	},
	secondary = {
		Material( "slc/hud/scp/24273/drain.png", "smooth" ),
		Material( "slc/hud/scp/24273/spect.png", "smooth" ),
	},
	special = {
		Material( "slc/hud/scp/24273/special.png", "smooth" ),
		Material( "slc/hud/scp/24273/ghost.png", "smooth" ),
	},
}

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Mode", "Bool" ) --false -> judge
	self:AddNetworkVar( "LookedAt", "Entity" )
	self:AddNetworkVar( "Evidence", "Float" )
	self:AddNetworkVar( "NextMode", "Float" )
	self:AddNetworkVar( "Camouflage", "Float" )
	self:AddNetworkVar( "Drain", "Float" )
	self:AddNetworkVar( "Ghost", "Float" )
	self:AddNetworkVar( "Special", "Float" )
	self:AddNetworkVar( "SpectateTime", "Float" )
	self:AddNetworkVar( "SpectateDuration", "Float" )
	self:AddNetworkVar( "SpectateEntity", "Entity" )
	self:AddNetworkVar( "DrainTarget", "Entity" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP24273" )
	self:InitializeHUD()

	self.Evidence = {}
	self.Cooldowns = {}
end

SWEP.NextGhostTick = 0
function SWEP:Think()
	if CLIENT then return end

	self:PlayerFreeze()

	local ct = CurTime()
	local owner = self:GetOwner()

	local camo = self:GetCamouflage()
	if camo > 0 and ( camo < ct or self.CamouflageRestrict and owner:GetPos():DistToSqr( self.CamouflageRestrict ) > self:GetUpgradeMod( "camo_limit", 25 ) ^ 2 ) then
		self:StopCamouflage()
	end

	local ghost = self:GetGhost()
	if ghost != 0 and ghost < ct then
		ghost = 0
		self:SetGhost( 0 )
		owner:SetMaterial( "" )
		owner:PopSpeed( "SLC_SCP24273Ghost" )
	elseif ghost >= ct and self.NextGhostTick < ct and owner:Health() < owner:GetMaxHealth() then
		self.NextGhostTick = self.NextGhostTick + self.GhostDelay

		if self.NextGhostTick < ct then
			self.NextGhostTick = ct + self.GhostDelay
		end

		local pos = owner:GetPos()
		local radius = self.GhostRadius ^ 2
		local heal = 0

		for i, v in ipairs( player.GetAll() ) do
			local tab = self.Evidence[v]
			if !tab or tab[1] <= 0 or !v:CheckSignature( tab[2] ) or !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( pos ) > radius then continue end

			heal = heal + 1
			tab[1] = tab[1] - 0.01

			if tab[1] < 0 then
				tab[1] = 0
			end
		end

		if heal > 0 then
			owner:AddHealth( math.ceil( heal * self:GetUpgradeMod( "ghost_heal", self.GhostHeal ) ) )
		end
	end

	local spectate = self:GetSpectateTime()
	if spectate > 0 and spectate < ct then
		local _, time = owner:LookupSequence( "stary_wstal" )

		self:SetSpectateTime( -ct - time )
		self:SetSpectateDuration( time )
		self:SetSpectateEntity( NULL )
		self:SetNextSecondaryFire( ct + self.SpectateCooldown * self:GetUpgradeMod( "spect_cd", 1 ) )
	elseif spectate < 0 and -spectate < ct then
		self:RestrictMode( 2 )
		self:SetSpectateTime( 0 )
		owner:StopDisableControls( "scp24273_spectate" )
	end

	if self.SpectateFly > 0 and self.SpectateFly <= ct then
		self.SpectateFly = 0
	end

	if ghost == 0 then
		self:EvidenceThink()
	end

	if !self:GetMode() then
		self:DashThink()
		self:DrainThink()
		self:SpecialThink()
	end
end

local evidence_trace = {}
evidence_trace.mask = MASK_BLOCKLOS_AND_NPCS
evidence_trace.output = evidence_trace

function SWEP:EvidenceThink()
	local ent = self:GetView()
	
	if !ent then
		self:SetLookedAt( NULL )
		self:SetEvidence( 0 )
		
		return
	end

	local pos = ent:EyePos()
	local ang = ent:EyeAngles()
	local forward = ang:Forward()

	evidence_trace.start = pos
	evidence_trace.filter = ent

	local min_dot = self.PEvidenceDot
	local best_dot = -1
	local best_ply = nil

	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) then continue end

		local ply_pos = v:GetPos() + v:OBBCenter()
		local diff = ply_pos - pos
		diff:Normalize()

		local dot = forward:Dot( diff )
		if dot < best_dot or dot < min_dot then continue end

		evidence_trace.endpos = ply_pos

		util.TraceLine( evidence_trace )
		if evidence_trace.Entity != v then continue end

		best_dot = dot
		best_ply = v
	end

	if best_ply then
		local tab = self.Evidence[best_ply]
		if !tab or !best_ply:CheckSignature( tab[2] ) then
			tab = { 0, best_ply:TimeSignature() }
			self.Evidence[best_ply] = tab
		end

		if self:GetMode() then
			tab[1] = tab[1] + self:GetUpgradeMod( "p_rate", self.PEvidenceRate ) * FrameTime() * math.Map( best_dot, min_dot, 1, 0.5, 1 )

			if tab[1] > 1 then
				tab[1] = 1
			end
		end

		self:SetLookedAt( best_ply )
		self:SetEvidence( tab[1] )
	else
		self:SetLookedAt( NULL )
		self:SetEvidence( 0 )
	end
end

local dash_offset = Vector( 0, 0, 32 )
local dash_trace = {}
dash_trace.mins = Vector( -8, -8, -8 )
dash_trace.maxs = Vector( 8, 8, 8 )
dash_trace.mask = MASK_SHOT
dash_trace.output = dash_trace

function SWEP:DashThink()
	local ct = CurTime()
	local owner = self:GetOwner()

	if !controller.IsEnabled( owner, "scp24273_dash" ) then return end
	
	if self.DashTime < ct or owner:GetPos():DistToSqr( self.DashStart ) > self.DashMaxDistance ^ 2 then
		controller.Stop( owner )
		return
	end

	dash_trace.start = owner:GetPos() + dash_offset
	dash_trace.endpos = dash_trace.start + self.DashDirection * 33
	dash_trace.filter = owner

	owner:LagCompensation( true )
	util.TraceHull( dash_trace )
	owner:LagCompensation( false )

	if !dash_trace.Hit then return end

	local ent = dash_trace.Entity

	if !IsValid( ent ) then
		controller.Stop( owner )
		return
	end

	if !ent:IsPlayer() then
		self:SCPDamageEvent( ent, 50 )
		controller.Stop( owner )
		return
	end

	if self.DashFilter[ent] then return end
	self.DashFilter[ent] = true

	if !self:CanTargetPlayer( ent ) then return end

	self:DealDamage( ent, self.DashDamage * self:GetUpgradeMod( "dash_dmg", 1 ) )
end

local drain_trace = {}
drain_trace.mask = MASK_SHOT
drain_trace.output = drain_trace

function SWEP:DrainThink()
	local drain = self:GetDrain()
	if drain == 0 then return end

	local ct = CurTime()
	local owner = self:GetOwner()

	if drain < 0 then
		if -drain < ct then
			owner:PopSpeed( "SLC_SCP24273Drain" )
			self:SetDrain( 0 )
		end

		return
	elseif drain > 0 and drain < ct then
		self:SetDrain( 0 )
		self:RestrictMode( 2 )

		local target = self:GetDrainTarget()
		if !IsValid( target ) then return end

		local slow = 1 - self.DrainSlow
		local slow_time = self.DrainSlowTime
		target:PushSpeed( slow, slow, -1, "SLC_SCP24273Drain", 1 )
		target:AddTimer( "SCP24273Drain", slow_time, 1, function()
			target:PopSpeed( "SLC_SCP24273Drain" )
		end )

		self:DealDamage( target, self.DrainDamage )
		self:SetDrainTarget( NULL )

		return
	end

	local target = self:GetDrainTarget()
	if !IsValid( target ) then return end

	owner:LagCompensation( true )

	drain_trace.start = owner:GetShootPos()
	drain_trace.endpos = target:GetPos() + target:OBBCenter()
	drain_trace.filter = owner

	util.TraceLine( drain_trace )
	owner:LagCompensation( false )

	if drain_trace.Hit and drain_trace.Entity == target then return end

	local slow = 1 - self.DrainSlow
	local slow_time = self.DrainSlowTime
	owner:PushSpeed( slow, slow, -1, "SLC_SCP24273Drain", 1 )
	self:SetDrain( -ct - slow_time )
end

local vec_up = Vector( 0, 0, 600 )
function SWEP:SpecialThink()
	local special = self:GetSpecial()
	if special == 0 then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	local owner_pos = owner:GetPos()

	if special < ct then
		self:SetSpecial( 0 )
		self:RestrictMode( 2 )
		owner:StopDisableControls( "scp24273_special" )
		
		self:CleanupTargets()

		return
	end

	local target_pos = owner_pos + owner:OBBCenter()
	for i, v in ipairs( player.GetAll() ) do
		if !self:CanTargetPlayer( v ) or self.SpecialFilter[v] then continue end

		local pos = v:GetPos()
		local should_affect = !v:GetSCP714() and owner:TestVisibility( v, nil, nil, false )
		local target = v:GetProperty( "scp24273_target" )

		if should_affect and !target then
			target = target_pos

			controller.Start( v, "scp24273_follow" )
			v:SetProperty( "scp24273_target", target_pos, true )
			v:SetProperty( "scp24273_player", owner )
			v:SetProperty( "scp24273_time", ct )
		elseif !should_affect and target then
			target = nil

			controller.Stop( v )
			v:SetProperty( "scp24273_target", nil, true )
			v:SetProperty( "scp24273_player", nil )
			v:SetProperty( "scp24273_time", nil )
		end

		if target and pos:DistToSqr( target ) <= 2500 then
			self.SpecialFilter[v] = true

			controller.Stop( v )

			local pct = math.Clamp( ( CurTime() - v:GetProperty( "scp24273_time", 0 ) ) / self.SpecialTime, 0, 1 )
			local diff = pos - owner_pos

			diff.z = 0
			diff:Normalize()

			v:SetVelocity( ( diff * 600 + vec_up ) * ( 0.5 + pct * 0.5 ) )
			self:DealDamage( v, math.ceil( self.SpecialDamage * pct ) )

			v:SetProperty( "scp24273_target", nil, true )
			v:SetProperty( "scp24273_player", nil )
			v:SetProperty( "scp24273_time", nil )
		end
	end
end

function SWEP:OnRemove()
	if CLIENT then return end
	self:CleanupTargets()
end

function SWEP:PrimaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post or !self:CanAttack() then return end

	self:StopCamouflage()

	local ct = CurTime()
	local owner = self:GetOwner()

	if self:GetMode() then
		local dur = self.CamouflageDuration * self:GetUpgradeMod( "camo_dur", 1 )
		self:SetNextPrimaryFire( ct + dur + self.CamouflageCooldown * self:GetUpgradeMod( "camo_cd", 1 ) )
		self:SetCamouflage( ct + dur )

		owner:SetMaterial( "sprites/heatwave" )
		owner:RemoveAllDecals()

		//REMOVE - Temp fix (https://github.com/Facepunch/garrysmod-issues/issues/5946)
		BroadcastLua( "tmpfix=Entity("..owner:EntIndex()..") if IsValid(tmpfix) then tmpfix:RemoveAllDecals() end" )

		owner:AddTimer( "SCP24273Camouflage", 0.5, 1, function()
			self.CamouflageRestrict = owner:GetPos()
		end )
	else
		if !owner:IsOnGround() then return end

		local ang = owner:GetAngles()
		ang.p = 0
		ang.r = 0

		self:SetNextPrimaryFire( ct + self.DashCooldown * self:GetUpgradeMod( "dash_cd", 1 ) )
		self:RestrictMode( 2 )
		self.DashDirection = ang:Forward()
		self.DashStart = owner:GetPos()
		self.DashTime = ct + 0.6
		self.DashFilter = {}

		controller.Start( owner, "scp24273_dash" )

		owner:DoCustomAnimEvent( PLAYERANIMEVENT_CUSTOM_SEQUENCE, 1001 )
	end
end

SWEP.SpectateFly = 0
function SWEP:SecondaryAttack()
	if CLIENT or ROUND.preparing or ROUND.post then return end
	
	local ct = CurTime()
	local spectate = self:GetSpectateTime()
	if ( spectate > 0 and spectate < ct or self.SpectateFly >= ct ) and !self:CanAttack() then return end

	self:StopCamouflage()

	local owner = self:GetOwner()

	if self:GetMode() then
		if spectate >= ct then
			self:SetSpectateTime( 1 )
		end

		if spectate > 0 then return end

		self:SetNextSecondaryFire( ct + 3 )

		local owner_pos = owner:GetPos()
		local radius = self.SpectateRadius ^ 2
		local targets = {}
		local len = 0

		for i, v in ipairs( player.GetAll() ) do
			if !self:CanTargetPlayer( v ) or v:GetPos():DistToSqr( owner_pos ) > radius then continue end

			len = len + 1
			targets[len] = v
		end

		if len < 1 then return end

		local ent = targets[math.random( len )]
		local path = SLCAStar( owner_pos, ent:GetPos(), "manhattan", nil, 200 )
		if !path then return end

		if path == true then
			return
		end
		
		for i, v in ipairs( path ) do
			path[i] = v:GetCenter() + Vector( 0, 0, 64 )
		end

		local fly_time = 0
		local path_time = { { 0, owner:EyePos() } }

		for i = 2, #path do
			local time = path[i - 1]:Distance( path[i] ) / self.SpectateSpeed
			fly_time = fly_time + time
			path_time[i] = { ct + fly_time, path[i] }
		end

		local dur = self.SpectateTime * self:GetUpgradeMod( "spect_dur", 1 )

		self:SetNextSecondaryFire( ct + fly_time + 1 )
		self:SetSpectateTime( ct + fly_time + dur )
		self:SetSpectateDuration( fly_time + dur )
		self:SetSpectateEntity( ent )

		self.SpectateActivePath = 1
		self.SpectatePathTime = path_time
		self.SpectateFly = ct + fly_time
		
		owner:DisableControls( "scp24273_spectate", IN_ATTACK2 )

		net.SendTable( "SCP24273Path", path, owner )
	else
		drain_trace.start = owner:GetShootPos()
		drain_trace.endpos = drain_trace.start + owner:GetAimVector() * 250
		drain_trace.filter = owner

		owner:LagCompensation( true )
		util.TraceLine( drain_trace )
		owner:LagCompensation( false )

		if !drain_trace.Hit then return end

		local ent = drain_trace.Entity
		if !IsValid( ent ) or !ent:IsPlayer() or !self:CanTargetPlayer( ent ) then return end

		self:SetNextSecondaryFire( ct + self.DrainCooldown * self:GetUpgradeMod( "drain_cd", 1 ) )
		self:SetDrain( ct + self.DrainTime * self:GetUpgradeMod( "drain_dur", 1 ) )
		self:SetDrainTarget( ent )
	end
end

function SWEP:SpecialAttack()
	if CLIENT or ROUND.preparing or ROUND.post or !self:CanAttack() then return end

	self:StopCamouflage()

	local ct = CurTime()
	local owner = self:GetOwner()

	if self:GetMode() then
		local dur = self.GhostDuration * self:GetUpgradeMod( "ghost_dur", 1 )
		local speed = self.GhostSpeed

		self:SetNextSpecialAttack( ct + dur + self.GhostCooldown * self:GetUpgradeMod( "ghost_cd", 1 ) )
		self:SetGhost( ct + dur )
		owner:SetMaterial( "models/props_combine/combine_fenceglow" )
		owner:PushSpeed( speed, speed, -1, "SLC_SCP24273Ghost", 1 )
	else
		local dur = self.SpecialDuration * self:GetUpgradeMod( "special_dur", 1 )

		self:SetNextSpecialAttack( ct + dur + self.SpecialCooldown * self:GetUpgradeMod( "special_cd", 1 ) )
		self:SetSpecial( ct + dur )
		self.SpecialFilter = {}
		owner:DisableControls( "scp24273_special", CAMERA_MASK )
	end
end

function SWEP:Reload()
	local ct = CurTime()
	if self:GetNextMode() > ct or !self:CanAttack() then return end

	if !self:HasUpgrade( "change2" ) then
		self:StopCamouflage()
	end

	self:SetNextMode( ct + self.ChangeCooldown * self:GetUpgradeMod( "change_cd", 1 ) )

	local new = !self:GetMode()
	self:SetMode( new )

	if CLIENT then
		self.HUDObject:GetSkill( "primary" ):SetMaterialOverride( new and hud_materials.primary[2] )
		self.HUDObject:GetSkill( "secondary" ):SetMaterialOverride( new and hud_materials.secondary[2] )
		self.HUDObject:GetSkill( "special" ):SetMaterialOverride( new and hud_materials.special[2] )

		return
	end

	local cd_primary = self:GetNextPrimaryFire()
	local cd_secondary = self:GetNextSecondaryFire()
	local cd_special = self:GetNextSpecialAttack()

	local cd_def = ct + 1
	self:SetNextPrimaryFire( math.max( self.Cooldowns.primary or 0, cd_def ) )
	self:SetNextSecondaryFire( math.max( self.Cooldowns.secondary or 0, cd_def ) )
	self:SetNextSpecialAttack( math.max( self.Cooldowns.special or 0, cd_def ) )

	self.Cooldowns.primary = cd_primary
	self.Cooldowns.secondary = cd_secondary
	self.Cooldowns.special = cd_special

	local owner = self:GetOwner()

	if new then
		local speed = 1 - self:GetUpgradeMod( "p_slow", self.PPassiveSlow )
		owner:PushSpeed( speed, speed, -1, "SLC_SCP24273Prosecutor", 1 )
	else
		owner:PopSpeed( "SLC_SCP24273Prosecutor" )

		self:SetLookedAt( NULL )
		self:SetEvidence( 0 )
	end
end

function SWEP:CanAttack()
	return self:GetDrain() == 0 and self:GetGhost() == 0 and self:GetSpectateTime() == 0 and !controller.IsEnabled( self:GetOwner() )
end

function SWEP:DealDamage( ply, dmg )
	local evidence = self.Evidence[ply] and self.Evidence[ply][1] or 0
	local info = DamageInfo()

	if evidence >= 1 then
		info:SetDamageType( DMG_DIRECT )
		info:SetDamage( ply:Health() )
	elseif evidence > 0 then
		info:SetDamage( dmg * ( 1 + self:GetUpgradeMod( "j_mult", self.JEvidenceMultiplier ) * evidence ) )
		self.Evidence[ply][1] = evidence * self:GetUpgradeMod( "j_loss", self.JEvidenceLoss )
	else
		info:SetDamage( dmg )
	end

	info:SetAttacker( self:GetOwner() )
	
	ply:TakeDamageInfo( info )
end

function SWEP:RestrictMode( time )
	local ct = CurTime()
	if self:GetNextMode() - ct >= time then return end

	self:SetNextMode( ct + time )
end

function SWEP:StopCamouflage()
	if CLIENT or self:GetCamouflage() == 0 then return end

	self:SetCamouflage( 0 )
	self.CamouflageRestrict = nil

	self:GetOwner():SetMaterial( "" )
end

function SWEP:CleanupTargets()
	local owner = self:GetOwner()

	for i, v in ipairs( player.GetAll() ) do
		if v:GetProperty( "scp24273_player" ) != owner then continue end

		controller.Stop( v )
		v:SetProperty( "scp24273_target", nil, true )
		v:SetProperty( "scp24273_player", nil )
		v:SetProperty( "scp24273_time", nil )
	end
end

function SWEP:OnPlayerKilled( ply )
	AddRoundStat( "24273" )
end

function SWEP:GetView()
	local ct = CurTime()

	if self.SpectateFly >= ct then return end

	if self:GetSpectateTime() >= ct then
		local ent = self:GetSpectateEntity()
		if IsValid( ent ) then
			return ent
		end
	end

	local owner = self:GetOwner()
	return owner
end

local color_white = Color( 255, 255, 255 )
function SWEP:DrawSCPHUD()
	local ent = self:GetLookedAt()
	if !IsValid( ent ) then return end

	local w, h = ScrW() * 0.5, ScrH() * 0.5

	draw.SimpleText( ent:Nick(), "SCPHUDMedium", w, h - 16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( math.floor( self:GetEvidence() * 100 ).."%", "SCPHUDMedium", w, h + 16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
end

SWEP.CameraPath = nil
function SWEP:CalcView( ply, cur_pos, cur_ang )
	if self.CameraReset then
		self.CameraReset = false

		self.CameraSegment = 2

		self.CameraPosition = nil
		self.CameraAngle = nil
	end

	if !self.CameraPath then
		if self:GetSpectateTime() < CurTime() then return end

		local target = self:GetSpectateEntity()
		if !IsValid( target ) then return end
				
		return target:EyePos(), target:EyeAngles()
	end

	if !self.CameraPosition then
		self.CameraPosition = cur_pos
		self.CameraAngle = cur_ang
	end

	local target = self.CameraPath[self.CameraSegment]
	if !target then
		self.CameraPath = nil
		return
	end

	local dt = FrameTime()
	local dir = target - self.CameraPosition
	dir:Normalize()
	
	local prev_ang = self.CameraAngle
	local ang = dir:Angle()

	self.CameraPosition = self.CameraPosition + dir * self.SpectateSpeed * dt
	self.CameraAngle = LerpAngle( dt * 4, prev_ang, ang )

	if self.CameraPosition:Distance( target ) < 30 then
		self.CameraSegment = self.CameraSegment + 1
	end

	return self.CameraPosition, self.CameraAngle
end

--[[-------------------------------------------------------------------------
Net
---------------------------------------------------------------------------]]
if SERVER then
	net.AddTableChannel( "SCP24273Path" )
end

if CLIENT then
	net.ReceiveTable( "SCP24273Path", function( data )
		local ply = LocalPlayer()
		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		wep.CameraReset = true
		wep.CameraPath = data
	end )
end

--[[-------------------------------------------------------------------------
SCP Hooks
---------------------------------------------------------------------------]]
//lua_run ClearSCPHooks() EnableSCPHook("SCP24273") TransmitSCPHooks()
SCPHook( "SCP24273", "EntityTakeDamage", function( target, dmg )
	if dmg:IsDamageType( DMG_DIRECT ) or !IsValid( target ) or !target:IsPlayer() or target:SCPClass() != CLASSES.SCP24273 then return end
	
	local wep = target:GetSCPWeapon()
	if !IsValid( wep ) then return end

	if wep:GetGhost() != 0 and !dmg:IsDamageType( DMG_BLAST ) and !dmg:IsDamageType( DMG_FALL ) then return true end
	if !dmg:IsDamageType( DMG_BULLET ) then return end

	wep:StopCamouflage()

	if wep:GetMode() then
		local def = 1 - wep:GetUpgradeMod( "p_prot", wep.PPassiveDefense )

		if wep:GetSpectateTime() > CurTime() then
			def = def - wep:GetUpgradeMod( "spect_prot", wep.SpectateDefense )
		end

		if def < 0.1 then
			def = 0.1
		end

		dmg:ScaleDamage( def )
	elseif wep:GetSpecial() >= CurTime() then
		dmg:ScaleDamage( 1 - wep:GetUpgradeMod( "special_prot", wep.SpecialDefense ) )
	end
end )

SCPHook( "SCP24273", "CalcMainActivity", function( ply, speed )
	if ply:SCPClass() != CLASSES.SCP24273 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) then return end

	local spectate = wep:GetSpectateTime()
	if spectate == 0 then return end

	local ct = CurTime()
	local seq, dur = ply:LookupSequence( spectate > 0 and "stary_spi" or "stary_wstal" )

	if spectate < 0 then
		spectate = -spectate
	end

	if dur == 0 then
		dur = 3
	end

	local f = math.Clamp( ( wep:GetSpectateDuration() - ( spectate - ct ) ) / dur, 0, 1 )

	ply:SetCycle( f )
	return ACT_INVALID, seq
end )

SCPHook( "SCP24273", "DoAnimationEvent", function( ply, event, data )
	if ply:SCPClass() != CLASSES.SCP24273 then return end

	if event == PLAYERANIMEVENT_CUSTOM_SEQUENCE and data == 1001 then
		local seq = ply:LookupSequence( "stary_skacze" )
		if seq == -1 then return end
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, seq, 0, true )
		return ACT_INVALID
	end
end )

SCPHook( "SCP24273", "SLCPlayerFootstep", function( ply, foot, snd )
	if ply:SCPClass() != CLASSES.SCP24273 then return end

	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetCamouflage() == 0 then return end

	return true
end )

SCPHook( "SCP24273", "CanPlayerSeePlayer", function( lp, other )
	if lp:SCPClass() != CLASSES.SCP24273 then return end

	local wep = lp:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetSpectateTime() == 0 then return end

	if wep:GetSpectateEntity() == other then return false end
end )

SCPHook( "SCP24273", "SetupPlayerVisibility", function( ply, ve )
	if ply:SCPClass() != CLASSES.SCP24273 then return end

	local ct = CurTime()
	local wep = ply:GetSCPWeapon()
	if !IsValid( wep ) or wep:GetSpectateTime() < ct then return end

	if wep.SpectateFly < ct then
		local target = wep:GetSpectateEntity()
		if IsValid( target ) then
			AddOriginToPVS( target:EyePos() )
		end

		return
	end

	local act = wep.SpectateActivePath
	local time = wep.SpectatePathTime

	while time[act] and time[act][1] < ct do
		act = act + 1
	end

	if !time[act] then return end

	AddOriginToPVS( time[act][2] )
end )

if CLIENT then
	local brain_beam = Material( "slc/misc/escort_marker.png", "smooth" )
	local drain_color = Color( 140, 60, 180 )

	SCPHook( "SCP24273", "PreDrawEffects", function()
		local ply = LocalPlayer()
		if ply:SCPClass() != CLASSES.SCP24273 then return end

		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) or wep:GetDrain() <= 0 then return end

		local target = wep:GetDrainTarget()
		if !IsValid( target ) then return end

		local ply_pos = ply:GetPos() + ply:OBBCenter()
		local target_pos = target:GetPos() + target:OBBCenter()

		render.SetMaterial( brain_beam )
		render.DrawBeam( ply_pos, target_pos, 1, 0, 1, drain_color )

		return
	end )
end

--[[-------------------------------------------------------------------------
Upgrade system
---------------------------------------------------------------------------]]
local icons = {}

if CLIENT then
	icons.passive = GetMaterial( "slc/hud/upgrades/scp/24273/passive.png", "smooth" )
	icons.camo = GetMaterial( "slc/hud/upgrades/scp/24273/camo.png", "smooth" )
	icons.dash = GetMaterial( "slc/hud/upgrades/scp/24273/dash.png", "smooth" )
	icons.spect = GetMaterial( "slc/hud/upgrades/scp/24273/spect.png", "smooth" )
	icons.drain = GetMaterial( "slc/hud/upgrades/scp/24273/drain.png", "smooth" )
	icons.ghost = GetMaterial( "slc/hud/upgrades/scp/24273/ghost.png", "smooth" )
	icons.special = GetMaterial( "slc/hud/upgrades/scp/24273/special.png", "smooth" )
	icons.combo = GetMaterial( "slc/hud/upgrades/scp/24273/combo.png", "smooth" )

end

DefineUpgradeSystem( "scp24273", {
	grid_x = 5,
	grid_y = 4,
	upgrades = {
		{ name = "j_passive1", cost = 2, req = {}, reqany = false, pos = { 1, 1 },
			mod = { j_mult = 0.9, j_loss = 0.4 }, icon = icons.passive },
		{ name = "j_passive2", cost = 2, req = { "j_passive1" }, block = { "p_passive2" }, reqany = false, pos = { 1, 2 },
			mod = { j_mult = 1.2, j_loss = 0.25 }, icon = icons.passive },
		{ name = "p_passive1", cost = 2, req = {}, reqany = false, pos = { 1, 3 },
			mod = { p_prot = 0.4, p_slow = 0.3, p_rate = 0.06 }, icon = icons.passive },
		{ name = "p_passive2", cost = 2, req = { "p_passive1" }, block = { "j_passive2" }, reqany = false, pos = { 1, 4 },
			mod = { p_prot = 0.6, p_slow = 0.4, p_rate = 0.09 }, icon = icons.passive },

		{ name = "dash1", cost = 1, req = {}, reqany = false, pos = { 2, 1 },
			mod = { dash_cd = 0.9, dash_dmg = 1.1 }, icon = icons.dash },
		{ name = "dash2", cost = 2, req = { "dash1" }, block = { "camo2" }, reqany = false, pos = { 2, 2 },
			mod = { dash_cd = 0.75, dash_dmg = 1.25 }, icon = icons.dash },
		{ name = "camo1", cost = 1, req = {}, reqany = false, pos = { 2, 3 },
			mod = { camo_cd = 0.9, camo_limit = 100, camo_dur = 1.2 }, icon = icons.camo },
		{ name = "camo2", cost = 1, req = { "camo1" }, block = { "dash2" }, reqany = false, pos = { 2, 4 },
			mod = { camo_cd = 0.75, camo_limit = 250, camo_dur = 1.5 }, icon = icons.camo },

		{ name = "drain1", cost = 1, req = {}, reqany = false, pos = { 3, 1 },
			mod = { drain_cd = 0.9, drain_dur = 0.85 }, icon = icons.drain },
		{ name = "drain2", cost = 1, req = { "drain1" }, block = { "spect2" }, reqany = false, pos = { 3, 2 },
			mod = { drain_cd = 0.8, drain_dur = 0.6 }, icon = icons.drain },
		{ name = "spect1", cost = 1, req = {}, reqany = false, pos = { 3, 3 },
			mod = { spect_cd = 0.9, spect_dur = 1.5, spect_prot = 0.2 }, icon = icons.spect },
		{ name = "spect2", cost = 2, req = { "spect1" }, block = { "drain2" }, reqany = false, pos = { 3, 4 },
			mod = { spect_cd = 0.8, spect_dur = 2, spect_prot = 0.3 }, icon = icons.spect },

		{ name = "combo", cost = 1, req = {}, reqany = false, pos = { 4.5, 1 },
			mod = { special_prot = 0.6, ghost_dur = 1.1 }, icon = icons.combo },
		{ name = "spec", cost = 3, req = { "combo" }, block = { "ghost1" }, reqany = false, pos = { 4, 2 },
			mod = { special_prot = 0.9, special_cd = 0.75, special_dur = 1.5 }, icon = icons.special },
		{ name = "ghost1", cost = 1, req = { "combo" }, block = { "spec" }, reqany = false, pos = { 5, 2 },
			mod = { ghost_dur = 1.2, ghost_cd = 0.9, ghost_heal = 1 }, icon = icons.ghost },
		{ name = "ghost2", cost = 2, req = { "ghost1" }, reqany = false, pos = { 5, 3 },
			mod = { ghost_dur = 1.5, ghost_cd = 0.8, ghost_heal = 1.5 }, icon = icons.ghost },

		{ name = "change1", cost = 1, req = {}, reqany = false, pos = { 4, 3 },
			mod = { change_cd = 0.66 }, icon = icons.passive },
		{ name = "change2", cost = 1, req = { "change1" }, reqany = false, pos = { 4, 4 },
			mod = { change_cd = 0.25 }, icon = icons.passive },

		{ name = "outside_buff", cost = 1, req = {}, reqany = false, pos = { 5, 4 }, mod = {}, active = false },
	},
	rewards = { --15 + 1 points -> 60% = 10 (-1 base) = 9 points
		{ 50, 1 },
		{ 100, 1 },
		{ 175, 1 },
		{ 275, 1 },
		{ 375, 1 },
		{ 500, 1 },
		{ 750, 1 },
		{ 900, 1 },
		{ 1100, 1 },
	}
}, SWEP )

--[[-------------------------------------------------------------------------
SCP HUD
---------------------------------------------------------------------------]]
if CLIENT then
	local hud = SCPHUDObject( "SCP24273", SWEP )
	hud:AddCommonSkills()

	hud:AddSkill( "primary" )
		:SetButton( "attack" )
		:SetMaterial( hud_materials.primary[1] )
		:SetCooldownFunction( "GetNextPrimaryFire" )

	hud:AddSkill( "secondary" )
		:SetButton( "attack2" )
		:SetMaterial( hud_materials.secondary[1] )
		:SetCooldownFunction( "GetNextSecondaryFire" )

	hud:AddSkill( "special" )
		:SetButton( "scp_special" )
		:SetMaterial( hud_materials.special[1] )
		:SetCooldownFunction( "GetNextSpecialAttack" )

	hud:AddSkill( "change" )
		:SetOffset( 0.5 )
		:SetButton( "reload" )
		:SetMaterial( "slc/hud/scp/24273/passive.png", "smooth" )
		:SetCooldownFunction( "GetNextMode" )

	hud:AddBar( "camo_bar" )
		:SetMaterial( "slc/hud/scp/24273/camo.png", "smooth" )
		:SetColor( Color( 90, 225, 80 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			return math.Round( this.last_time or 0 ).."s"
		end )
		:SetProgressFunction( function( swep, hud_obj, this )
			local time = swep:GetCamouflage() - CurTime()
			if time > 0 then
				this.last_time = time
			end

			return ( this.last_time or 0 ) / swep.CamouflageDuration
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetCamouflage() != 0
		end )

	hud:AddBar( "spectate_bar" )
		:SetMaterial( "slc/hud/scp/24273/spect.png", "smooth" )
		:SetColor( Color( 33, 215, 160 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			return math.Round( this.last_time or 0 ).."s"
		end )
		:SetProgressFunction( function( swep, hud_obj, this )
			local time = swep:GetSpectateTime() - CurTime()
			if time > 0 then
				this.last_time = time
				this.last_dur = swep:GetSpectateDuration()
			end

			return ( this.last_time or 0 ) / ( this.last_dur or 1 )
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetSpectateTime() >= CurTime()
		end )

	hud:AddBar( "drain_bar" )
		:SetMaterial( "slc/hud/scp/24273/drain.png", "smooth" )
		:SetColor( Color( 190, 50, 145 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			return math.Round( this.last_time or 0 ).."s"
		end )
		:SetProgressFunction( function( swep, hud_obj, this )
			local f = swep:GetDrain() - CurTime()
			if f > 0 then
				this.last_time = f
			end

			return ( this.last_time or 0 ) / swep.DrainTime
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetDrain() >= CurTime()
		end )

	hud:AddBar( "ghost_bar" )
		:SetMaterial( "slc/hud/scp/24273/ghost.png", "smooth" )
		:SetColor( Color( 30, 140, 15 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			local time = swep:GetGhost() - CurTime()
			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep, hud_obj, this )
			return ( swep:GetGhost() - CurTime() ) / swep.GhostDuration
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetGhost() != 0
		end )

	hud:AddBar( "special_bar" )
		:SetMaterial( "slc/hud/scp/24273/special.png", "smooth" )
		:SetColor( Color( 120, 40, 210 ) )
		:SetTextFunction( function( swep, hud_obj, this )
			local time = swep:GetSpecial() - CurTime()
			if time < 0 then
				time = 0
			end

			return math.Round( time ).."s"
		end )
		:SetProgressFunction( function( swep, hud_obj, this )
			return ( swep:GetSpecial() - CurTime() ) / swep.SpecialDuration
		end )
		:SetVisibleFunction( function( swep )
			return swep:GetSpecial() != 0
		end )
end

--[[-------------------------------------------------------------------------
Controllers
---------------------------------------------------------------------------]]
controller.Register( "scp24273_dash", {
	OnStart = function( self, ply )
		if SERVER then return end

		local ang = ply:GetAngles()
		ang.p = 0
		ang.r = 0

		self.DashDirection = ang:Forward()
	end,
	StartCommand = function( self, ply, cmd )
		cmd:ClearButtons()
		cmd:ClearMovement()
	end,
	Move = function( self, ply, mv )
		local wep = ply:GetSCPWeapon()
		if !IsValid( wep ) then return end

		local vel = ( wep.DashDirection or self.DashDirection ) * 850

		if ply:IsOnGround() then
			vel.z = 251
		end

		mv:SetVelocity( vel )
	end,
} )

controller.Register( "scp24273_follow", {
	StartCommand = function( self, ply, cmd )
		cmd:ClearButtons()
		cmd:ClearMovement()

		local target = ply:GetProperty( "scp24273_target" )
		if !target then return end

		cmd:SetButtons( IN_FORWARD )
		cmd:SetForwardMove( 10000 )

		//cmd:SetViewAngles( ( target - ply:EyePos() ):Angle() )
	end,
	Move = function( self, ply, mv )
		local target = ply:GetProperty( "scp24273_target" )
		if !target then return end

		local dir = target - mv:GetOrigin()
		dir.z = 0

		//dir:Normalize()
		
		mv:SetMoveAngles( dir:Angle() )
		//mv:SetVelocity( dir * mv:GetMaxSpeed() )
	end,
} )