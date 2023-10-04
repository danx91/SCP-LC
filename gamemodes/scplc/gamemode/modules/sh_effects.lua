EFFECTS = EFFECTS or {
	registry = {},
	effects = {}
}

/*
data = {
	duration = <time>,
	think = nil'/function( self, ply, tier, args ) (return <delay>) end,
	wait = 0//time between thinks
	begin = nil'/function( self, ply, tier, args, refresh, decrease ) end,
	finish = nil'/function( self, ply, tier, args, interrupt, all ) end,
	stacks = 0(nil)/1/2, //0 - don't stack, refresh duration; 1 - stack effects; 2 - increase effect level, refresh duration
	finish_type = 0(nil)/1, //0 - end as usual, 1 - decrease tier and refresh duration
	tiers = { { icon = <material> } },
	cantarget = nil'/function( ply ) end, //return false to disallow
	hide = false'/true
}
*/

function EFFECTS.RegisterEffect( name, data )
	local tiers = #data.tiers

	for i = 1, tiers do
		data.tiers[i].tier = i
		EFFECTS.registry[name.."_"..i] = data.tiers[i]
	end

	data.tiers = tiers
	EFFECTS.effects[name] = data
end

hook.Add( "PlayerPostThink", "SLCEffectsThink", function( ply )
	if !ply.EFFECTS then ply.EFFECTS = {} end

	local ct = CurTime()

	for i, v in rpairs( ply.EFFECTS ) do
		local eff = EFFECTS.effects[v.name]

		if v.endtime != -1 and v.endtime < ct then
			local keep = eff.finish_type == 1 and v.tier > 1

			if keep then
				v.endtime = ct + eff.duration
				v.tier = v.tier - 1

				if eff.begin then
					eff.begin( v, ply, v.tier, v.args, true, true )
				end
			else
				if eff.finish then
					if eff.finish( v, ply, v.tier, v.args, false, false ) then
						continue
					end
				end

				table.remove( ply.EFFECTS, i )

				local found = false
				for _, e in ipairs( ply.EFFECTS ) do
					if e.name == v.name then
						found = true
						break
					end
				end

				if !found then
					ply.EFFECTS_REG[v.name] = nil
				end
			end
		elseif eff.think then
			if eff.wait then
				if v.nextthink and v.nextthink > ct then
					return
				end

				v.nextthink = ct + eff.wait
			end

			local override = eff.think( v, ply, v.tier, v.args )
			if isnumber( override ) then
				v.nextthink = ct + override
			end
		end
	end
end )

if CLIENT then
	net.Receive( "PlayerEffect", function( len )
		local rem = net.ReadBool()
		local name = net.ReadString()

		if rem then
			LocalPlayer():RemoveEffect( name, net.ReadBool() )
		else
			LocalPlayer():ApplyEffect( name, unpack( net.ReadTable() ) )
		end
	end )
end

local PLAYER = FindMetaTable( "Player" )
function PLAYER:ApplyEffect( name, ... )
	if CLIENT and self != LocalPlayer() then return end
	
 	local args = {...}
	local effect = EFFECTS.effects[name]

	if !effect then return end
	if effect.cantarget and effect.cantarget( self ) == false then return end

	local tier = 1

	if isnumber( args[1] ) and args[1] > 0 then
		if args[1] > effect.tiers then
			tier = effect.tiers
		else
			tier = args[1]
		end

		table.remove( args, 1 )
	end

	if !self.EFFECTS then self.EFFECTS = {} end
	if !self.EFFECTS_REG then self.EFFECTS_REG = {} end

	if hook.Run( "SLCApplyEffect", self, name, args ) == true then
		return
	end

	if !effect.stacks or effect.stacks == 0 or effect.stacks == 2 then
		if self.EFFECTS_REG[name] then
			for k, v in ipairs( self.EFFECTS ) do
				if v.name == name then
					if effect.duration >= 0 then
						v.endtime = CurTime() + effect.duration
					end

					if effect.stacks == 2 then
						local ntier = v.tier + tier

						if ntier > effect.tiers then
							ntier = effect.tiers
						end

						v.tier = ntier
						//v.icon = EFFECTS.registry[name.."_"..ntier]
					end

					if effect.begin then
						effect.begin( v, self, v.tier, args, true, false )
					end

					if SERVER then
						net.Start( "PlayerEffect" )
							net.WriteBool( false )
							net.WriteString( name )
							net.WriteTable( {...} )
						net.Send( self )
					end

					return
				end
			end
		end
	end

	local endtime = -1

	if effect.duration >= 0 then
		endtime = CurTime() + effect.duration
	end

	//local tab = { name = name, tier = tier, icon = EFFECTS.registry[name.."_"..tier], endtime = endtime, args = args }
	local tab = { name = name, tier = tier, start = CurTime(), endtime = endtime, args = args }

	table.insert( self.EFFECTS, 1, tab )
	self.EFFECTS_REG[name] = true

	if effect.begin then
		effect.begin( tab, self, tier, args, false, false )
	end

	if SERVER then
		net.Start( "PlayerEffect" )
			net.WriteBool( false )
			net.WriteString( name )
			net.WriteTable( {...} )
		net.Send( self )
	end
end

--if name == nil -> remove all effects
--if all == true -> if effect.stacks == 1: remove all effects with this name instead of oldest one; if effect.stacks == 2: remove effect insetad of decreasing tier
function PLAYER:RemoveEffect( name, all )
	if CLIENT and self != LocalPlayer() then return end
	if !self.EFFECTS then self.EFFECTS = {} end

	if !name or name == "" then
		for i, v in ipairs( self.EFFECTS ) do
			local effect = EFFECTS.effects[v.name]
			if effect and effect.finish then
				effect.finish( v, self, v.tier, v.args, true, true )
			end
		end

		self.EFFECTS = {}
		self.EFFECTS_REG = {}

		if SERVER then
			net.Start( "PlayerEffect" )
				net.WriteBool( true )
				net.WriteString( "" )
				net.WriteBool( false )
			net.Send( self )
		end

		return
	end

	if self.EFFECTS_REG[name] then
		local effect = EFFECTS.effects[name]
		if !effect then return end

		for i, v in rpairs( self.EFFECTS ) do
			if v.name == name then
				if effect.stacks != 2 or all or v.tier == 1 then
					table.remove( self.EFFECTS, i )

					if effect.finish then
						effect.finish( v, self, v.tier, v.args, true, false )
					end

					if effect.stacks != 1 or all then
						self.EFFECTS_REG[name] = nil
					else
						local found = false

						for _, eff in ipairs( self.EFFECTS ) do
							if eff.name == name then
								found = true
								break
							end
						end

						if !found then
							self.EFFECTS_REG[name] = nil
						end
					end
				else
					v.endtime = CurTime() + effect.duration
					v.tier = v.tier - 1

					if effect.begin then
						effect.begin( v, self, v.tier, v.args, true, true )
					end
				end

				if effect.stacks == 0 or effect.stacks == 2 or !all then
					break
				end
			end
		end

		if SERVER then
			net.Start( "PlayerEffect" )
				net.WriteBool( true )
				net.WriteString( name )
				net.WriteBool( all )
			net.Send( self )
		end
	end
end

function PLAYER:RefreshEffect( name, all )
	if !self.EFFECTS_REG[name] then return end
	local effect = EFFECTS.effects[name]
	if !effect then return end


	for i, v in rpairs( self.EFFECTS ) do
		if v.name != name then continue end

		v.endtime = CurTime() + effect.duration

		if effect.begin then
			effect.begin( v, self, v.tier, v.args, true, false )
		end

		if !all then return end
	end
end

function PLAYER:HasEffect( name )
	if self.EFFECTS_REG then
		return self.EFFECTS_REG[name] == true
	end
end

function PLAYER:GetEffect( name )
	if !self.EFFECTS_REG or !self.EFFECTS_REG[name] then return end

	for i, v in rpairs( self.EFFECTS ) do
		if v.name == name then
			return v
		end
	end
end

--[[-------------------------------------------------------------------------
Default checks
---------------------------------------------------------------------------]]
function scp_spec_filter( ply )
	local team = ply:SCPTeam()
	return team != TEAM_SPEC and team != TEAM_SCP
end

function scp_spec_hazard_filter( dmg )
	return function( ply )
		local team = ply:SCPTeam()
		if team == TEAM_SPEC or team == TEAM_SCP then
			return false
		end

		if ply:GetSCP714() then
			return false
		end

		return !ply:CheckHazardProtection( dmg )
	end
end

--[[-------------------------------------------------------------------------
Bleeding
---------------------------------------------------------------------------]]
local decal_up = Vector( 0, 0, 10 )
local decal_down = Vector( 0, 0, -30 )

EFFECTS.RegisterEffect( "bleeding", {
	duration = 15,
	stacks = 2,
	tiers = {
		{ icon = Material( "slc/hud/effects/bleeding1.png" ) },
		{ icon = Material( "slc/hud/effects/bleeding2.png" ) },
		{ icon = Material( "slc/hud/effects/bleeding3.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if refresh and IsValid( args[1] ) then
			self.args[1] = args[1]
		end
	end,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

			local att = args[1]
			local dmg = DamageInfo()

			dmg:SetDamage( tier )
			dmg:SetDamageType( DMG_DIRECT )

			if IsValid( att ) then
				dmg:SetAttacker( att )
			end

			ply:TakeDamageInfo( dmg )
			AddRoundStat( "bleed", tier )
		else
			if self.ndecal and self.ndecal > CurTime() then return end
			self.ndecal = CurTime() + ( 4 - tier ) * 0.75

			//ply:EmitSound( "SLCEffects.Bleeding" )

			local pos = ply:GetPos()
			if self.last_decal and pos:DistToSqr( self.last_decal ) < 500 then return end
			self.last_decal = pos

			util.Decal( "Blood", pos + decal_up, pos + decal_down )
		end
	end,
	wait = 1,
} )

sound.Add( {
	name = "SLCEffects.Bleeding",
	volume = 0.1,
	level = 50,
	pitch = {50, 100},
	sound = "physics/flesh/flesh_squishy_impact_hard1.wav",
	channel = CHAN_STATIC,
} )

--[[-------------------------------------------------------------------------
AMN-C227
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "amnc227", {
	duration = 2.5,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/amn-c227.png" ) }
	},
	cantarget = scp_spec_hazard_filter( 3 ),
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP or !args[2] then return end

			local att = args[1]
			local dmg = DamageInfo()

			dmg:SetDamage( args[2] )
			dmg:SetDamageType( DMG_POISON )

			if IsValid( att ) then
				dmg:SetAttacker( att )
			end

			ply:TakeDamageInfo( dmg )
		end
	end,
	wait = 2,
} )

hook.Add( "StartCommand", "SLCAMNCEffect", function( ply, cmd )
	if ply:HasEffect( "amnc227" ) then
		cmd:RemoveKey( IN_ATTACK )
		cmd:RemoveKey( IN_ATTACK2 )
	end
end )

--[[-------------------------------------------------------------------------
Insane
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "insane", {
	duration = -1,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/insane.png" ) }
	},
	cantarget = scp_spec_filter,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:GetSanity() >= 20 or ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then
				ply:RemoveEffect( "insane" )
			end
		else
			InsaneTick( ply )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if CLIENT then
			InterruptInsane( ply )
		end
	end,
	wait = 3,
} )

--[[-------------------------------------------------------------------------
Gas Choke
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "gas_choke", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/amn-c227.png" ) }
	},
	cantarget = scp_spec_hazard_filter( 2 ),
	begin = function( self, ply, tier, args, refresh )
		if SERVER and !refresh then
			ply:PushSpeed( 0.65, 0.65, -1, "SLC_Choke" )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_Choke" )
		end
	end,
	think = function( self, ply, tier, args )
		if CLIENT then
			ply:EmitSound( "SLCEffects.Choke" )
		end
	end,
	wait = 2.75
} )

if CLIENT then
	local choke_mat = GetMaterial( "slc/misc/exhaust.png" )
	hook.Add( "SLCScreenMod", "ChokeEffect", function( clr )
		if LocalPlayer():HasEffect( "gas_choke" ) then
			clr.colour = 0.5
			clr.contrast = clr.contrast * 1.15
			clr.brightness = clr.brightness - 0.01

			surface.SetDrawColor( 0, 0, 0, 245 )
			surface.SetMaterial( choke_mat )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end
	end )

	AddSounds( "SLCEffects.Choke", "scp_lc/effects/choke/cough%i.ogg", 0, 1, { 90, 110 }, CHAN_STATIC, 1, 3 )
end

--[[-------------------------------------------------------------------------
Radiation
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "radiation", {
	duration = 300,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/radiation.png" ) }
	},
	cantarget = scp_spec_hazard_filter( 1 ),
	begin = function( self, ply, tier, args, refresh )
		
	end,
	finish = function( self, ply, tier, args, interrupt )
		
	end,
	think = function( self, ply, tier, args )
		if CLIENT then
			ply:EmitSound( "SLCEffects.Radiation" )
		end

		return math.random() * 0.15 + 0.05
	end,
	wait = 1,
} )

if CLIENT then
	sound.Add( {
		name = "SLCEffects.Radiation",
		volume = 0.1,
		level = 0,
		pitch = { 95, 110 },
		sound = "player/geiger1.wav",
		channel = CHAN_STATIC,
	} )
end

--[[-------------------------------------------------------------------------
Deep Wounds
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "deep_wounds", {
	duration = 120,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/deep_wounds.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if SERVER then
			ply:ApplyEffect( "bleeding", args[1] )
			ply:PushSpeed( 0.9, 0.9, -1, "SLC_DeepWounds", 1 )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_DeepWounds" )
		end
	end,
} )

--[[-------------------------------------------------------------------------
Spawn protection
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "spawn_protection", {
	duration = 30,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/spawn_protection.png" ) },
	},
	begin = function( self, ply, tier, args, refresh )
		if CLIENT then return end

		ply:SetColor4Part( 255, 255, 255, 127 )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	end,
	finish = function( self, ply, tier, args, interrupt )
		if CLIENT then return end

		ply:SetColor4Part( 255, 255, 255, 255 )
		ply:SetRenderMode( RENDERMODE_NORMAL )
	end,
} )

--Mask used to disable spawn protection
local action_mask = bit.bor( IN_ATTACK, IN_ATTACK2, IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT, IN_DUCK, IN_JUMP )
hook.Add( "StartCommand", "SLCSpawnProtection", function( ply, cmd )
	if !ply:HasEffect( "spawn_protection" ) then return end

	if bit.band( cmd:GetButtons(), action_mask ) != 0 then
		ply:RemoveEffect( "spawn_protection" )
	end
end )

--[[-------------------------------------------------------------------------
Poison
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "poison", {
	duration = 30,
	stacks = 2,
	finish_type = 1,
	tiers = {
		{ icon = Material( "slc/hud/effects/poison1.png" ) },
		{ icon = Material( "slc/hud/effects/poison2.png" ) },
		{ icon = Material( "slc/hud/effects/poison3.png" ) },
		{ icon = Material( "slc/hud/effects/poison4.png" ) },
		{ icon = Material( "slc/hud/effects/poison5.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh, decrease )
		self.args[1] = args[1] --attacker

		if args[2] > self.args[2] then
			self.args[2] = args[2] --dmg
		end

		if SERVER then
			ply:PopSpeed( "SLC_Poison" )

			local speed = 1 - 0.1 * tier
			ply:PushSpeed( speed, speed, -1, "SLC_Poison", 1 )
		end

		if tier == 1 then
			ply:SetDSP( 0 )
		elseif tier == 2 then
			ply:SetDSP( 14 )
		elseif tier < 5 then
			ply:SetDSP( 15 )
		else
			ply:SetDSP( 16 )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_Poison" )
		end

		ply:SetDSP( 0 )
	end,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

			local att = args[1]
			local dmg = DamageInfo()

			dmg:SetDamage( args[2] )
			dmg:SetDamageType( DMG_POISON )

			if IsValid( att ) then
				dmg:SetAttacker( att )
			end

			ply:TakeDamageInfo( dmg )
			AddRoundStat( "poison", tier )
		end
	end,
	wait = 1.5,
} )


local poison_mat = Material( "effects/water_warp01" )
hook.Add( "DrawOverlay", "SLCPoison", function()
	local ply = LocalPlayer()
	if ply.HasEffect and ply:HasEffect( "poison" ) then
		local tier = 0

		for i, v in ipairs( ply.EFFECTS ) do
			if v.name == "poison" then
				tier = v.tier
				break
			end
		end

		if tier >= 4 then
			render.UpdateScreenEffectTexture()

			poison_mat:SetFloat( "$envmap", 0 )
			poison_mat:SetFloat( "$envmaptint", 0 )
			poison_mat:SetFloat( "$refractamount", tier == 5 and 0.075 or 0.03 )
			poison_mat:SetVector( "$refracttint", tier == 5 and Vector( 0.1, 0.5, 0.1 ) or Vector( 0.3, 0.75, 0.3 ) )
			poison_mat:SetInt( "$ignorez", 1 )

			render.SetMaterial( poison_mat )
			render.DrawScreenQuad( true )
		end
	end
end )

hook.Add( "SLCScreenMod", "SLCPoison", function( data )
	local ply = LocalPlayer()
	if ply.HasEffect and ply:HasEffect( "poison" ) then
		local tier = 0

		for i, v in ipairs( ply.EFFECTS ) do
			if v.name == "poison" then
				tier = v.tier
				break
			end
		end

		if tier < 4 and tier > 1 then
			local n = tier - 1
			data.add_g = data.add_g + 0.06 * n
			data.brightness = data.brightness - 0.075 * n
		end
	end
end )

--[[-------------------------------------------------------------------------
Fracture
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "fracture", {
	duration = 120,
	stacks = 1,
	tiers = {
		{ icon = Material( "slc/hud/effects/fracture.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if SERVER then
			ply:PushSpeed( 0.4, 0.4, -1, "SLC_Fracture" )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_Fracture" )
		end
	end,
} )

local fcv = 0
hook.Add( "SLCCalcView", "SLCFracture", function( ply, view )
	if ply:OnGround() and ply.HasEffect and ply:HasEffect( "fracture" ) then
		if !view.vm and ply:GetVelocity():LengthSqr() > 900 then
			fcv = fcv + FrameTime() * 3
		end

		view.origin.z = view.origin.z + math.sin( fcv * 2 ) * 3
		view.origin = view.origin + view.angles:Right() * math.sin( fcv ) * 6
	end
end )

--[[-------------------------------------------------------------------------
Decay
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "decay", {
	duration = -1,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/decay.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh, decrease )
		if IsValid( args[1] ) then
			self.attacker = args[1]
			self.signature = args[1]:TimeSignature()
		end

		self.damage = args[2] or 1

		if SERVER then
			ply:PopSpeed( "SLC_Decay" )
			ply:PushSpeed( 60, 120, -1, "SLC_Decay", 1 )
		end

		ply:SetDSP( 16 )
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_Decay" )
		end

		ply:SetDSP( 0 )
	end,
	think = function( self, ply, tier, args )
		if !SERVER then return end

		local calc = math.ceil( ( CurTime() - self.start ) / 30 * self.damage )
		if !ply:CheckHazmat( calc * 2.5 ) then
			local dmg = DamageInfo()

			dmg:SetDamage( calc )
			dmg:SetDamageType( DMG_ACID )

			if IsValid( self.attacker ) and self.attacker:CheckSignature( self.signature ) then
				dmg:SetAttacker( self.attacker )
			end

			ply:TakeDamageInfo( dmg )
		end

		if ply:IsInZone( ZONE_PD ) then return end
		ply:RemoveEffect( "decay" )
	end,
	wait = 2,
	ignore500 = true,
} )

hook.Add( "SLCPlayerFootstep", "SLCDecaySteps", function( ply, foot, snd )
	if ply:Alive() and ply:HasEffect( "decay" ) then
		ply:EmitSound( "SLCEffects.DecayStep" )
		return true
	end
end )

hook.Add( "SLCFootstepParams", "SLCDecaySteps", function( ply, st, vel, crouch )
	if SERVER and ply:Alive() and ply:HasEffect( "decay" ) then
		return vel:LengthSqr() > 10000 and 75 or 50
	end
end )

local dcv = 0
hook.Add( "SLCCalcView", "SLCDecay", function( ply, view )
	if ply:OnGround() and ply.HasEffect and ply:HasEffect( "decay" ) then
		if !view.vm then
			local len = ply:GetVelocity():Length()
			if len > 30 then
				dcv = dcv + FrameTime() * 0.06 * len
			end
		end

		view.angles.roll = math.sin( dcv * 0.6 ) * 3
	end
end )

AddSounds( "SLCEffects.DecayStep", "#scp_lc/effects/decay/step%i.ogg", 80, 1, { 90, 110 }, CHAN_BODY, 1, 3 )

--[[-------------------------------------------------------------------------
Door lock
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "doorlock", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/doorlock.png" ) }
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if SERVER then return end
		surface.PlaySound( "hl1/fvox/beep.wav" )
	end
} )

hook.Add( "PlayerUse", "SLCDoorLock", function( ply, ent )
	if ply:HasEffect( "doorlock" ) then return false end
end )

--[[-------------------------------------------------------------------------
Chase effects
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "scp_chase", {
	duration = -1,
	stacks = 2,
	tiers = {
		{ icon = Material( "slc/hud/effects/scp_chase1.png" ) },
		{ icon = Material( "slc/hud/effects/scp_chase2.png" ) },
		{ icon = Material( "slc/hud/effects/scp_chase3.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPTeam() == TEAM_SCP
	end,
	begin = function( self, ply, tier, args, refresh, decrease )
		if CLIENT then return end

		ply:PopSpeed( "SLC_SCPChase", true )

		if tier > 1 then
			local mod = 1 + 0.1 * tier
			ply:PushSpeed( mod, mod, -1, "SLC_SCPChase" )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if CLIENT then return end
		ply:PopSpeed( "SLC_SCPChase", true )
	end,
} )

EFFECTS.RegisterEffect( "human_chase", {
	duration = -1,
	stacks = 2,
	tiers = {
		{ icon = Material( "slc/hud/effects/human_chase1.png" ) },
		{ icon = Material( "slc/hud/effects/human_chase2.png" ) },
		{ icon = Material( "slc/hud/effects/human_chase3.png" ) },
	},
	cantarget = scp_spec_filter,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		ply:TakeSanity( 1 )
		return 4 - tier
	end,
	wait = 3,
} )

hook.Add( "AcceptInput", "SLCDoorlock", function( ent, input, activator, caller, value )
	if !ent.IsDoor then return end
	if !IsValid( activator ) or !activator:IsPlayer() then return end
	if activator:GetChaseLevel() < 3 then return end

	local at = activator:SCPTeam()
	if at == TEAM_SPEC or at == TEAM_SCP then return end

	for k, ply in ipairs( FindInCylinder( activator:GetPos(), 500, -128, 128, nil, nil, player.GetAll() ) ) do
		local t = ply:SCPTeam()
		if t == TEAM_SPEC or t == TEAM_SCP then continue end

		local dc = ply:GetProperty( "door_counter", 0 ) + 1
		
		if dc > 3 then
			dc = 0
			
			ply:ApplyEffect( "doorlock" )
			ply.NextSLCUse = CurTime() + 1
		end
		
		ply:SetProperty( "door_counter", dc )
	end
end )

--[[-------------------------------------------------------------------------
Experimental D
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "expd_rubber_bones", {
	duration = -1,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		pl:SetProperty( "allow_bhop", true )
		pl:SetProperty( "expd_rubber_bones_special", CurTime() + 30 )

		hook.Add( "OnPlayerHitGround", "expd_effect", function( ply, water, floater, speed )
			if ply:SCPClass() != CLASSES.EXPD then return end
			if CLIENT then return true end

			local mj = ply:GetProperty( "expd_rubber_bones", 0 )
			if speed < ( mj == 0 and 450 or 300 ) then
				if mj == 0 and speed < 200 and ply:GetStamina() > 50 and ply:GetProperty( "expd_rubber_bones_special", 0 ) < CurTime() and ply.WasJumpDown then
					ply:SetVelocity( Vector( 0, 0, 500 ) )
					ply:SetStamina( ply:GetStamina() - 50 )
					ply:SetProperty( "expd_rubber_bones_special", CurTime() + 30 )
					ply:EmitSound( "SLCEffects.EXPD.Bounce" )
				else
					ply:PlayStepSound()
				end

				ply:SetProperty( "expd_rubber_bones", 0 )
				return true
			end

			mj = mj + 1
			ply:SetProperty( "expd_rubber_bones", mj )
			ply:SetVelocity( Vector( 0, 0, speed / ( ply:Crouching() and 1.4 or mj == 1 and 0.9 or 1.15 ) ) )
			ply:EmitSound( "SLCEffects.EXPD.Bounce" )

			return true
		end )
	end,
	finish = function()
		hook.Remove( "OnPlayerHitGround", "expd_effect" )
	end,
	ignore500 = true,
} )

AddSounds( "SLCEffects.EXPD.Bounce", "scp_lc/effects/expd/expd_jump_%i.ogg", 75, 1, 100, CHAN_BODY, 1, 3 )

EFFECTS.RegisterEffect( "expd_stamina_tweaks", {
	duration = -1,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		pl:SetStamina( 200 )
		pl:SetMaxStamina( 200 )
		pl:SetStaminaLimit( 200 )

		hook.Add( "FinishMove", "expd_effect", function( ply, mv )
			if ply:SCPClass() != CLASSES.EXPD then return end
			ply:SetHealth( ply:GetStamina() / ply:GetMaxStamina() * ply:GetMaxHealth() )
		end )

		hook.Add( "SLCPostScaleDamage", "expd_effect", function( ply, dmg )
			if !IsValid( ply ) or !ply:IsPlayer() or ply:SCPClass() != CLASSES.EXPD then return end

			local new = ply:GetStamina() - dmg:GetDamage()
			if new < 0 then return end

			ply:SetStamina( new )
			ply:SetHealth( new / ply:GetMaxStamina() * ply:GetMaxHealth() )

			ply.StaminaRegen = CurTime() + 1

			return SERVER
		end )

		hook.Add( "SLCHealed", "expd_effect", function( target, healer, heal )
			local max = target:GetMaxStamina()
			local new = target:GetStamina() + heal / target:GetMaxHealth() * max

			if new > max then
				new = max
			end

			target:SetStamina( new )
		end )
	end,
	finish = function()
		hook.Remove( "FinishMove", "expd_effect" )
		hook.Remove( "SLCPostScaleDamage", "expd_effect" )
		hook.Remove( "SLCHealed", "expd_effect" )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_revive", {
	duration = -1,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		hook.Add( "SLCPostScaleDamage", "expd_effect", function( ply, dmg )
			if CLIENT or !ply:IsPlayer() or ply:SCPClass() != CLASSES.EXPD or dmg:IsDamageType( DMG_DIRECT ) then return end

			if dmg:GetDamage() >= ply:Health() then
				local rag = ply:CreatePlayerRagdoll( true )
				if IsValid( rag ) then
					rag:InstallTable( "Lootable" )
					rag:SetLootData( 4, 2, {} )
				end

				ply:RemoveEffect( "expd_revive" )
				ply:ApplyEffect( "expd_recovery" )

				return true
			end
		end )
	end,
	finish = function()
		hook.Remove( "SLCPostScaleDamage", "expd_effect" )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_recovery", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/expd_recovery.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		if SERVER then
			pl:SelectWeapon( "item_slc_holster" )
			pl:GodEnable()
			pl:SetNoDraw( true )

			for k, v in pairs( pl.EFFECTS_REG ) do
				local obj = EFFECTS.effects[k]
				if !obj or obj.ignore500 then continue end

				pl:RemoveEffect( k, true )
			end
		end

		pl:SetHealth( 1 )
		pl:SetStaminaBoost( CurTime() + 10 )
		pl:SetStaminaBoostDuration( 10 )

		hook.Add( "EntityTakeDamage", "expd_effect", function( ply, dmg )
			if ply == pl then return true end
		end )

		hook.Add( "PlayerSwitchWeapon", "expd_effect", function( ply )
			if ply == pl then return true end
		end )

		hook.Add( "SLCPlayerFootstep", "expd_effect", function( ply )
			if ply == pl then return true end
		end )

		/*hook.Add( "CanPlayerSeePlayer", "expd_effect", function( lp, ply )
			if ply == 
		end )*/
	end,
	finish = function( self, pl )
		if SERVER then
			pl:GodDisable()
			pl:SetNoDraw( false )
		end

		hook.Remove( "EntityTakeDamage", "expd_effect" )
		hook.Remove( "PlayerSwitchWeapon", "expd_effect" )
		hook.Remove( "SLCPlayerFootstep", "expd_effect" )
		hook.Remove( "CanPlayerSeePlayer", "expd_effect" )
	end,
	think = function( self, ply )
		if CLIENT then return end

		if ply:Health() >= ply:GetMaxHealth() then return 999 end
		ply:AddHealth( 5 )
	end,
	wait = 0.3,
	ignore500 = true,
} )

--[[-------------------------------------------------------------------------
Healing Hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCCanHeal", "SLCEffectsCanHeal", function( target, healer, heal_type )
	if target:HasEffect( "radiation" ) then return false end
	if target:HasEffect( "poison" ) then return false end
end )

hook.Add( "SLCNeedHeal", "SLCEffectsNeedHeal", function( target, healer, heal_type )
	if target:HasEffect( "deep_wounds" ) then return true end
	if target:HasEffect( "bleeding" ) then return true end
	if target:HasEffect( "fracture" ) then return true end
end )

hook.Add( "SLCScaleHealing", "SLCEffectsScaleHeal", function( ply, source, heal )
	if ply:HasEffect( "fracture" ) then
		return 0
	end

	if ply:HasEffect( "deep_wounds" ) then
		return heal * 0.25
	end
end )

hook.Add( "SLCHealed", "SLCEffectsHealed", function( target, healer )
	target:RemoveEffect( "bleeding", true )
	target:RemoveEffect( "deep_wounds", true )
	target:RemoveEffect( "fracture" )
end )