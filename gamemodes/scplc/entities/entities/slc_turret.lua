AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Modes = {
	{ "off", "slc/misc/turret/off.png" },		--off
	{ "filter", "slc/misc/turret/not_staff.png" },	--filter staff
	{ "target", "slc/misc/turret/staff.png" },	--only staff
	{ "scp", "slc/misc/turret/scp.png" },		--scp only
	{ "all", "slc/misc/turret/all.png" },		--all
	{ "supp", "slc/misc/turret/supp.png" },		--suppressive
}

local STATUS_IDLE = 0
local STATUS_MODE = 1
local STATUS_SETUP = 2
local STATUS_STOP = 3

ENT.Status = 0
ENT.StatusTime = 0

ENT.NextAnim = 0
ENT.LastAnim = -1

ENT.Mins = Vector( -24.5, -41, -33 )
ENT.Maxs = Vector( 44, 41, 16.5 )

ENT.AutomaticFrameAdvance = true

ENT.VerticalRange = 10
ENT.HorizontalRange = 30

local laser_draw = {}

function ENT:SetupDataTables()
	self:AddNetworkVar( "Mode", "Int" )
	self:AddNetworkVar( "Status", "Int" )

	self:AddNetworkVar( "StatusTime", "Float" )
	self:AddNetworkVar( "DesiredAngleY", "Float" )
	self:AddNetworkVar( "DesiredAngleP", "Float" )
	self:AddNetworkVar( "AnimSpeed", "Float" )

	self:AddNetworkVar( "TurretOwner", "Entity" )
	self:AddNetworkVar( "OwnerSignature", "Int" )

	self:SetMode( 1 )
end

function ENT:Initialize()
	self:SetModel( "models/alski/scp/turret/turret1.mdl" )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )

		self:SetUseType( SIMPLE_USE )
	end

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end

	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:CollisionRulesChanged()

	self:SetStatus( STATUS_SETUP )
	self:SetStatusTime( CurTime() + 3 )

	self:SetAutomaticFrameAdvance( true )

	self.LastAngle = Angle( 0, 0, 0 )
	self.PredictedAngle = Angle( 0, 0, 0 )
end

ENT.AnimTime = 0
ENT.NFireBullets = 0
function ENT:Think()
	local ct = CurTime()
	local status = self:GetStatus()
	local pos = self:GetPos()
	local ply = self.PickedBy

	if IsValid( ply ) then
		if status != STATUS_STOP or ply:GetPos():DistToSqr( pos ) > 5625 then
			self.PickedBy = nil
			ply.PickingTurret = nil

			//print( "REM - dist" )

			if status == STATUS_STOP then
				self:SetStatus( STATUS_IDLE )
				//self:SetStatusTime( 0 )
			end
		end
	end

	if status != STATUS_IDLE and self:GetStatusTime() < ct then
		if status == STATUS_STOP then
			if IsValid( ply ) then

				self.PickedBy = nil
				ply.PickingTurret = nil

				//print( "SUCCESS" )

				if SERVER then
					self:Remove()

					if ply:GetFreeInventory() <= 0 then
						local wep = ents.Create( "item_slc_turret" )
						if IsValid( wep ) then
							wep:SetPos( pos )
							wep.Dropped = 0

							wep:Spawn()
						end
					else
						ply:Give( "item_slc_turret" )
					end
				end
			end
		end

		self:SetStatus( STATUS_IDLE )
	end

	--for i = 0, self:GetBoneCount() - 1 do
		--print( i, self:GetBoneName( i ), self:GetBoneParent( i ) )
	--end

	if SERVER then
		--target logic
		local mode = self:GetMode()

		local yaw_orig = self:GetDesiredAngleY()
		local pitch_orig = self:GetDesiredAngleP()

		local yaw = yaw_orig
		local pitch = pitch_orig

		local speed = self:GetAnimSpeed()

		if status == STATUS_IDLE and mode != 1 then
			local searching = false
			local target = self:FindTarget( self.CurrentTarget )
			if target then
				self.CurrentTarget = target

				local self_ang = self:GetAngles()
				local target_pos = target:WorldSpaceCenter()

				local line = target_pos - pos
				local line_ang = line:Angle()
				local ang = line_ang - self_ang
				ang:Normalize()

				if self.NFireBullets <= ct then
					if 2 * math.pi * line:Length2D() * math.abs( ang.y - self.PredictedAngle.y ) / 360 < 5 then
						local attacker = self:GetTurretOwner() //self.LastUser
						if !IsValid( attacker ) then
							attacker = self
						elseif !attacker:CheckSignature( self:GetOwnerSignature() ) then
							attacker:SetProperty( "kill_team_override", self.OwnerTeam )
						end

						self:FireBullets{
							Attacker = attacker,
							Src = pos + line_ang:Forward() * 45,
							Dir = line_ang:Forward(),
							AmmoType = "",
							Tracer = 1,
							TracerName = "Tracer",
							Damage = 9,
							Force = 1,
							Num = 1,
							//Distance = ,
							HullSize = 0,
							Spread = mode == 6 and Vector( 0.07, 0.07, 0 ) or Vector( 0.011, 0.011, 0 ),
							IgnoreEntity = self
						}

						if attacker:IsPlayer() then
							attacker:SetProperty( "kill_team_override", nil )
						end

						self:EmitSound( "Turret.Shot" )

						--local att = self:GetAttachment( self:LookupAttachment( "muzzle" ) )
						--if att then
							local effect = EffectData()

							effect:SetOrigin( pos + line_ang:Forward() * 45 )
							effect:SetAngles( line_ang )
							//effect:SetEntity( self )
							//effect:SetAttachment( 3 )
							//effect:SetScale( 1 )

							util.Effect( "MuzzleEffect", effect, true, true )
						--end

						self.NFireBullets = ct + ( mode == 6 and 0.075 or 0.25 )
					end
				end

				yaw = ang.y
				pitch = ang.p
				speed = 30
			else
				self.CurentTarget = nil
				searching = true
			end

			if searching and self.AnimTime < ct then
				if yaw_orig >= self.HorizontalRange then
					yaw = -self.HorizontalRange
				else
					yaw = self.HorizontalRange
				end

				pitch = 0
				speed = 10
			end

			//print( "man" )
			//self:ManipulateBoneAngles( 1, self:GetManipulateBoneAngles( 1 ):Approach( Angle( yaw, 0, pitch ), 0.1 ) )
		end

		if yaw != yaw_orig or pitch != pitch_orig then
			self:SetDesiredAngleY( yaw )
			self:SetDesiredAngleP( pitch )
			self:SetAnimSpeed( speed )

			local ydiff = math.abs( yaw - yaw_orig )
			local pdiff = math.abs( pitch - pitch_orig )

			if ydiff > pdiff then
				self.AnimTime = ct + ydiff / speed
			else
				self.AnimTime = ct + pdiff / speed
			end
		end

		if speed > 0 then
			self.PredictedAngle = self.PredictedAngle:Approach( Angle( pitch, yaw, 0 ), FrameTime() * speed )
		end
	end

	if CLIENT then
		local ang = self:GetManipulateBoneAngles( 1 ) --clientside manipulation because serverside one causes net_graph to cover your whole screen (too much network traffic)
		local yaw = self:GetDesiredAngleY()
		local pitch = self:GetDesiredAngleP()


		if ang.p != yaw or ang.r != pitch then
			local speed = self:GetAnimSpeed()

			if speed > 0 then
				//print( "man" )
				self:ManipulateBoneAngles( 1, ang:Approach( Angle( yaw, 0, pitch ), FrameTime() * speed ) )
			end
		end

		--laser render
		//print( self:GetStatus(), self:GetMode() )
		if self:GetStatus() == STATUS_IDLE and self:GetMode() > 1 then
			local att = self:GetAttachment( self:LookupAttachment( "laser" ) )
			if att then
				local a_pos = att.Pos + Vector( 0, 0, 1.5 )

				local ma = self:GetManipulateBoneAngles( 1 )
				local a_ang = Angle( ma.r, ma.p, 0 ) + self:GetAngles()

				local laser_tr = util.TraceLine{
					start = a_pos,
					endpos = a_pos + a_ang:Forward() * 5000,
					filter = self,
					mask = MASK_BLOCKLOS_AND_NPCS,
				}

				laser_draw[self] = { a_pos, laser_tr.HitPos }
			end
		end
	end

	--if SERVER then
		self:NextThink( CurTime() )
		return true
	--end
end

ENT.LCSUse =  0
function ENT:CSUse( ply )
	local owner = self:GetTurretOwner()
	if ply != owner and owner:CheckSignature( self:GetOwnerSignature() ) then return end

	local t = ply:SCPTeam()
	if t == TEAM_SPEC or t == TEAM_SCP then return end

	if self:GetStatus() != STATUS_IDLE then return end
	if ply:IsHolding( self, "slc_turret_mode" ) then return end

	ply:StartHold( self, "slc_turret_mode", IN_USE, 0, function()
		CloseWheelMenu()
	end, true )

	local mode = self:GetMode()
	local options = {
		{
			mat = "slc/misc/turret/pickup.png",
			name = LANG.WEAPONS.TURRET.pickup or "pickup",
			data = 0
		}
	}

	for i, v in ipairs( self.Modes ) do
		if i != mode then
			table.insert( options, {
				mat = v[2],
				name = LANG.WEAPONS.TURRET.MODES[v[1]] or v[1],
				data = i
			} )
		end
	end

	OpenWheelMenu( options, function( selected )
		if !selected then return end

		net.Ping( "SLCTurretMode", selected )
		self:RequestMode( LocalPlayer(), selected )
	end, function()
		return !IsValid( self ) or ply:UpdateHold( self, "slc_turret_mode" ) != nil
	end, "slc/misc/turret/exit.png" )
end

ENT.HP = 250
function ENT:OnTakeDamage( dmginfo )
	self.HP = self.HP - dmginfo:GetDamage()

	if self.HP <= 0 then
		local pos = self:GetPos()

		local explosion = ents.Create( "env_explosion" )
		explosion:SetKeyValue( "spawnflags", 129 )
		explosion:SetPos( pos )
		explosion:Spawn()
		explosion:Fire( "explode", "", 0 )

		for i, v in ipairs( ents.FindInSphere( pos, 200 ) ) do
			if v:IsPlayer() and v:SCPTeam() != TEAM_SPEC then
				local dist = v:GetPos():Distance( pos )

				local dmginfo2 = DamageInfo()

				dmginfo2:SetDamage( math.ceil( ( 201 - dist ) / 2 ) )
				dmginfo2:SetAttacker( dmginfo:GetAttacker() )

				v:TakeDamageInfo( dmginfo2 )
			end
		end

		self:Remove()
	end
end

function ENT:RequestMode( ply, mode )
	local owner = self:GetTurretOwner()
	if ply != owner then
		if owner:CheckSignature( self:GetOwnerSignature() ) then return end

		local t = ply:SCPTeam()
		if t == TEAM_SPEC or t == TEAM_SCP then return end

		owner = ply
		self:SetTurretOwner( owner )
		self:SetOwnerSignature( owner:TimeSignature() )
		self.OwnerTeam = owner:SCPTeam()
	end

	local status = self:GetStatus()
	if status != STATUS_IDLE then return end

	self:SetDesiredAngleY( 0 )
	self:SetDesiredAngleP( 0 )
	self:SetAnimSpeed( 10 )

	local ct = CurTime()
	if mode == 0 then
		self:SetStatus( STATUS_STOP )
		self:SetStatusTime( ct + 5 )

		if SERVER then
			ply:EnableProgressBar( true, ct + 5, "lang:WEAPONS.TURRET.pickup_turret", Color( 200, 200, 200, 255 ), Color( 50, 225, 25, 255 ) )
		end

		ply.PickingTurret = self
		self.PickedBy = ply
	elseif self:GetMode() != mode then
		self:SetStatus( STATUS_MODE )
		self:SetStatusTime( ct + 3 )
		self:SetMode( mode )
	end
end

if SERVER then
	SLC_TURRET_FILTER_MODELS = {}
	/*SLC_TURRET_LOGIC_OVERRIDE = {
		["models/novux/023/novux_scp-023.mdl"] = {
			offset = Vector( 0, 0, -8 ),
			mask = bit.bor( MASK_BLOCKLOS_AND_NPCS, CONTENTS_HITBOX ),
		}
	}*/

	function AddTurretFilterModels( mdl )
		if !istable( mdl ) then
			mdl = { mdl }
		end

		for k, v in pairs( mdl ) do
			SLC_TURRET_FILTER_MODELS[v] = true
		end
	end

	local function turret_test_range_vis( self, target, shoot_pos, shoot_ang, vertical, horizontal )
		local pos = target:WorldSpaceCenter()

		/*local offset = SLC_TURRET_POSITION_OFFSET[target:GetModel()]
		if offset then
			pos = pos + offset
		end*/

		local ang = ( pos - shoot_pos ):Angle() - shoot_ang
		ang:Normalize()

		if math.abs( ang.p ) <= vertical + 3 and math.abs( ang.y ) <= horizontal + 3 then
			local tr = util.TraceLine{
				start = shoot_pos,
				endpos = pos,
				mask = MASK_BLOCKLOS_AND_NPCS,
				filter = self,
			}

			if tr.Entity == target or tr.Entity == NULL then
				return true
			end
		end

		return false
	end

	local function test_target( model, mode, ply )
		if mode == 2 then return !SLC_TURRET_FILTER_MODELS[model] end
		if mode == 3 then return SLC_TURRET_FILTER_MODELS[model] end
		if mode == 4 then return ply:SCPTeam() == TEAM_SCP end

		return true
	end

	function ENT:FindTarget( ply )
		local mode = self:GetMode()
		if mode > 1 then
			local shoot_pos = self:GetPos()
			local shoot_ang = self:GetAngles()

			if IsValid( ply ) and ply:Alive() and test_target( ply:GetModel(), mode, ply ) then
				if turret_test_range_vis( self, ply, shoot_pos, shoot_ang, self.VerticalRange, self.HorizontalRange ) then
					return ply
				end
			end

			for i, v in ipairs( SCPTeams.GetPlayersByInfo( SCPTeams.INFO_ALIVE, true ) ) do
				if test_target( v:GetModel(), mode, v ) then
					if turret_test_range_vis( self, v, shoot_pos, shoot_ang, self.VerticalRange, self.HorizontalRange ) then
						return v
					end
				end
			end
		end
	end

	AddTurretFilterModels( SCI_MODELS )
	AddTurretFilterModels( SCI_MODELS_2 )
	AddTurretFilterModels( MTF_MODELS )
	AddTurretFilterModels( GUARD_MODELS )
	AddTurretFilterModels( {
		"models/scp/guard_med.mdl",
		"models/alski/mtfsupport/mtf1.mdl",
		"models/alski/mtfsupport/mtf_medyk.mdl",
		"models/scp/captain.mdl",
		"models/alski/mtfsupport/saper_mtf.mdl"
	} )

	net.ReceivePing( "SLCTurretMode", function( data, ply )
		local ent = ply:GetEyeTrace().Entity
		if IsValid( ent ) and ent:GetClass() == "slc_turret" then
			if ply:GetPos():DistToSqr( ent:GetPos() ) <= 5625 then--75 * 75
				ent:RequestMode( ply, tonumber( data ) )
			end
		end
	end )
end

if CLIENT then
	local color_laser = Color( 255, 0, 0 )
	local mat_laser = CreateMaterial( "SLCTurretLaser14", "UnlitGeneric", {
		["$basetexture"] = "sprites/laser",
		["$additive"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1",
	} )

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:DrawTranslucent()
		--if self:GetStatus() == STATUS_IDLE and self:GetMode() > 1 then
		if laser_draw[self] then
			render.SetMaterial( mat_laser )
			render.DrawBeam( laser_draw[self][1], laser_draw[self][2], 5, 0, 1, color_laser )
		end
	end

	hook.Add( "PreDrawEffects", "SLCTurretLaser", function()
		for k, v in pairs( laser_draw ) do
			render.SetMaterial( mat_laser )
			render.DrawBeam( v[1], v[2], 5, 0, 1, color_laser )

			laser_draw[k] = nil
		end
	end )
end

hook.Add( "StartCommand", "SLCTurretENTCMD", function( ply, cmd )
	if !ply.PickingTurret then return end

	if IsValid( ply.PickingTurret ) and ply.PickingTurret.PickedBy == ply then
		if ply:GetPos():DistToSqr( ply.PickingTurret:GetPos() ) <= 5625 then
			cmd:ClearMovement()
			cmd:ClearButtons()
		else
			//print( "REM - dist (cmd)" )
			ply.PickingTurret.PickedBy = nil
			ply.PickingTurret = nil
		end
	else
		//print( "REM - not valid (cmd)" )
		ply.PickingTurret = nil
	end
end )

sound.Add{
	name = "Turret.Shot",
	sound = "weapons/smg1/smg1_fire1.wav",
	volume = 0.7,
	level = 70,
	pitch = { 95, 105 },
	channel = CHAN_STATIC,
}