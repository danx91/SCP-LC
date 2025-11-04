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
	local num_tiers = data.max_tier or #data.tiers
	local tiers = data.tiers or {}

	for i = 1, num_tiers do
		local tier = table.Copy( tiers[i] or tiers.all or {} )

		tier.tier = i
		EFFECTS.registry[name.."_"..i] = tier
	end

	data.tiers = num_tiers
	EFFECTS.effects[name] = data
end

hook.Add( "PlayerPostThink", "SLCEffectsThink", function( ply )
	if !ply.EFFECTS then ply.EFFECTS = {} end

	local ct = CurTime()

	for i, v in rpairs( ply.EFFECTS ) do
		local eff = EFFECTS.effects[v.name]
		
		if v.endtime != -1 and v.endtime <= ct then
			local decrease = v.decrease or 1
			local keep = eff.finish_type == 1 and v.tier > decrease

			v.decrease = nil

			if keep then
				v.endtime = ct + eff.duration
				v.tier = v.tier - decrease

				if eff.begin then
					eff.begin( v, ply, v.tier, v.args, true, true )
				end

				if v.duration then
					v.endtime = ct + v.duration
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
		local ply = LocalPlayer()
		if !IsValid( ply ) then return end

		local rem = net.ReadBool()
		local name = net.ReadString()

		if rem then
			ply:RemoveEffect( name, net.ReadBool() )
		else
			ply:ApplyEffect( name, unpack( net.ReadTable() ) )
		end
	end )

	net.Receive( "RefreshPlayerEffect", function( len )
		local ply = LocalPlayer()
		if !IsValid( ply ) then return end

		local decrease = net.ReadBool()
		local name = net.ReadString()
		local all = net.ReadBool()

		if decrease then
			ply:DecreaseEffect( name, net.ReadUInt( 16 ), all )
		else
			ply:RefreshEffect( name, all )
		end
	end )
end

local PLAYER = FindMetaTable( "Player" )
function PLAYER:ApplyEffect( name, ... )
	if CLIENT and self != LocalPlayer() then return false end
	
 	local args = {...}
	local effect = EFFECTS.effects[name]

	if !effect then return false end
	if effect.cantarget and effect.cantarget( self ) == false then return false end

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
		return false
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

					if v.duration then
						v.endtime = CurTime() + v.duration
					end

					if SERVER then
						net.Start( "PlayerEffect" )
							net.WriteBool( false )
							net.WriteString( name )
							net.WriteTable( {...} )
						net.Send( self )
					end

					return true
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

	if tab.duration then
		tab.endtime = CurTime() + tab.duration
	end

	if SERVER then
		net.Start( "PlayerEffect" )
			net.WriteBool( false )
			net.WriteString( name )
			net.WriteTable( {...} )
		net.Send( self )
	end

	return true
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

					if v.duration then
						v.endtime = CurTime() + v.duration
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

	if SERVER then
		net.Start( "RefreshPlayerEffect" )
			net.WriteBool( false )
			net.WriteString( name )
			net.WriteBool( all )
		net.Send( self )
	end

	for i, v in rpairs( self.EFFECTS ) do
		if v.name != name then continue end

		v.endtime = CurTime() + effect.duration

		if effect.begin then
			effect.begin( v, self, v.tier, v.args, true, false )
		end

		if v.duration then
			v.endtime = CurTime() + v.duration
		end

		if !all then return end
	end
end

function PLAYER:DecreaseEffect( name, num, all )
	if !self.EFFECTS_REG[name] then return end
	local effect = EFFECTS.effects[name]
	if !effect then return end

	if SERVER then
		net.Start( "RefreshPlayerEffect" )
			net.WriteBool( true )
			net.WriteString( name )
			net.WriteBool( all )
			net.WriteUInt( num or 1, 16 )
		net.Send( self )
	end

	for i, v in rpairs( self.EFFECTS ) do
		if v.name != name then continue end

		v.endtime = CurTime()
		v.decrease = num or 1

		if !all then return end
	end
end

function PLAYER:HasEffect( name )
	return self.EFFECTS_REG and self.EFFECTS_REG[name] == true or false
end

function PLAYER:GetEffect( name )
	if !self.EFFECTS_REG or !self.EFFECTS_REG[name] then return end

	for i, v in rpairs( self.EFFECTS ) do
		if v.name == name then
			return v
		end
	end
end

function PLAYER:GetEffectTier( name )
	local data = self:GetEffect( name )
	return data and data.tier or 0
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
		if !scp_spec_filter( ply ) then return false end

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
	duration = 16,
	stacks = 2,
	tiers = {
		{ icon = Material( "slc/hud/effects/bleeding1.png" ) },
		{ icon = Material( "slc/hud/effects/bleeding2.png" ) },
		{ icon = Material( "slc/hud/effects/bleeding3.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if IsValid( args[1] ) and args[1]:IsPlayer() then
			self.args[1] = args[1]
			self.args[2] = args[1]:TimeSignature()
		end
	end,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		local att = args[1]
		local dmg = DamageInfo()

		dmg:SetDamage( tier )
		dmg:SetDamageType( DMG_DIRECT )

		if IsValid( att ) and att:IsPlayer() and att:CheckSignature( args[2] ) then
			dmg:SetAttacker( att )
		end

		ply:TakeDamageInfo( dmg )
		AddRoundStat( "bleed", tier )

		if self.next_decal and self.next_decal > CurTime() then return end
		self.next_decal = CurTime() + ( 4 - tier ) * 0.75

		local pos = ply:GetPos()
		if self.last_decal and pos:DistToSqr( self.last_decal ) < 2500 then return end
		self.last_decal = pos

		util.Decal( "Blood", pos + decal_up, pos + decal_down, ply )
	end,
	wait = 2,
} )

EFFECTS.RegisterEffect( "heavy_bleeding", {
	duration = 300,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/bleeding3.png" ) },
	},
	cantarget = function( ply )
		local team = ply:SCPTeam()
		return team != TEAM_SPEC and team != TEAM_SCP
	end,
	begin = function( self, ply, tier, args, refresh )
		if !args[2] then
			args[2] = 1
		end

		if refresh then
			self.args[2] = 1
		end

		if IsValid( args[1] ) then
			self.args[1] = args[1]
			self.args[3] = args[1]:TimeSignature()
		end
	end,
	finish = function( self, ply, tier, args, interrupt, all )
		if CLIENT or !interrupt or all then return end
		
		ply:AddTimer( "reopen_wound", SLCRandom( 30, 120 ), 1, function()
			if !ply:HasEffect( "heavy_bleeding" ) and SLCRandom( 1, 100 ) <= 50 / args[2] then
				ply:ApplyEffect( "heavy_bleeding", args[1], args[2] + 1 )
			end
		end )
	end,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		local att = args[1]
		local dmg = DamageInfo()

		dmg:SetDamage( 2 )
		dmg:SetDamageType( DMG_DIRECT )

		if IsValid( att ) and att:CheckSignature( args[3] ) then
			dmg:SetAttacker( att )
		end

		ply:TakeDamageInfo( dmg )
		AddRoundStat( "bleed", 2 )

		if self.next_decal and self.next_decal > CurTime() then return end
		self.next_decal = CurTime() + 1

		local pos = ply:GetPos()
		if self.last_decal and pos:DistToSqr( self.last_decal ) < 2500 then return end
		self.last_decal = pos

		util.Decal( "Blood", pos + decal_up, pos + decal_down, ply )
	end,
	wait = 3,
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
			if ply:GetSanity() >= 20 or !SCPTeams.HasInfo( ply:SCPTeam(), SCPTeams.INFO_HUMAN ) then
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
			ply:SetNextBlink( 0 )
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

hook.Add( "SLCBlinkParams", "ChokeEffect", function( ply )
	if ply:HasEffect( "gas_choke" ) then
		return CVAR.slc_blink_delay:GetFloat() * 0.25
	end
end )

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
	think = function( self, ply, tier, args )
		if CLIENT then
			ply:EmitSound( "SLCEffects.Radiation" )
		end

		return SLCRandom() * 0.15 + 0.05
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
		self.args[3] = args[1]:TimeSignature()

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

			if IsValid( att ) and att:CheckSignature( args[3] ) then
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
	if !ply:OnGround() or !ply.HasEffect or !ply:HasEffect( "fracture" ) then return end
	
	if !view.vm and ply:GetVelocity():LengthSqr() > 900 then
		fcv = fcv + FrameTime() * 3
	end

	view.origin.z = view.origin.z + math.sin( fcv * 2 ) * 3
	view.origin = view.origin + view.angles:Right() * math.sin( fcv ) * 6
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
	if !ply:OnGround() or !ply.HasEffect or !ply:HasEffect( "decay" ) then return end

	if !view.vm then
		local len = ply:GetVelocity():Length()
		if len > 30 then
			dcv = dcv + FrameTime() * 0.06 * len
		end
	end

	view.angles.roll = math.sin( dcv * 0.6 ) * 3
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
	ignore500 = true,
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
SCP-009
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "scp009", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/scp009.png" ) }
	},
	cantarget = function( ply )
		if !scp_spec_filter( ply ) then return false end
		if ply:GetSCP714() then return false end

		return !ply:CheckHazmat( 175, true )
	end,
	begin = function( self, ply, tier, args, refresh, decrease )
		if IsValid( args[1] ) then
			self.attacker = args[1]
			self.team = args[2] or args[1]:SCPTeam()
		end

		if SERVER then
			ParticleEffectAttach( "SLC_SCP009_Smoke", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		ply:StopParticles()

		if CLIENT or interrupt or ROUND.post then return end

		local rag = ply:CreatePlayerRagdoll( "force_backpack" )
		rag:SetMaterial( "slc/scp/scp009/red_icefloor_01_new" )

		for i = 0, rag:GetPhysicsObjectCount() do
			local physobj = rag:GetPhysicsObjectNum( i )
			if IsValid( physobj ) then
				physobj:EnableMotion( false )
			end
		end

		rag:SetNWBool( "invalid_ragdoll", true )
		rag.Data.invalid = true
		rag.Data.scp009 = true

		local dmg = DamageInfo()
		dmg:SetDamage( ply:Health() )
		dmg:SetDamageType( DMG_DIRECT )

		if IsValid( self.attacker ) then
			self.attacker:SetProperty( "kill_team_override", self.team )
			dmg:SetAttacker( self.attacker )
		else
			ply:SkipNextSuicide()
		end

		ply:SkipNextRagdoll()
		ply:TakeDamageInfo( dmg )
		ply._RagEntity = nil

		if IsValid( self.attacker ) then
			self.attacker:SetProperty( "kill_team_override", nil )
		end
	end,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		local pos = ply:GetPos()
		local radius = 50 ^ 2

		for i, v in ipairs( player.GetAll() ) do
			if SLCRandom( 4 ) < 4 and !v:HasEffect( "scp009" ) and v:GetPos():DistToSqr( pos ) <= radius then
				v:ApplyEffect( "scp009", self.attacker, self.team )
			end
		end
	end,
	wait = 0.5
} )

--[[-------------------------------------------------------------------------
Electrical shock
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "electrical_shock", {
	duration = 5,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/electrical_shock.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if SERVER then
			ply:PushSpeed( 0.2, 0.2, -1, "SLC_ElectricalShock", 1 )
			ply:SelectWeaponByBase( "item_slc_holster" )
		end

		ply:SetProperty( "prevent_weapon_switch", CurTime() + 0.5 )
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_ElectricalShock" )
		end
	end,
} )

--[[-------------------------------------------------------------------------
Ephedrine (speed)
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "ephedrine", {
	duration = 60,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/items/ephedrine.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if SERVER then
			ply:PushSpeed( args[1], args[1], -1, "SLC_EphedrineBoost", 1 )
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_EphedrineBoost" )
		end
	end,
	ignore500 = true,
} )

--[[-------------------------------------------------------------------------
Hemostatic
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "hemostatic", {
	duration = 5,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/items/hemostatic.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		self.duration = args[1]
	end,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		if ply:HasEffect( "bleeding" ) then
			ply:RemoveEffect( "bleeding" )
		end

		if ply:HasEffect( "heavy_bleeding" ) then
			ply:RemoveEffect( "heavy_bleeding" )
		end
	end,
	wait = 1,
	ignore500 = true,
} )

--[[-------------------------------------------------------------------------
Antidote
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "antidote", {
	duration = 5,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/items/antidote.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		self.duration = args[1]
	end,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		if ply:HasEffect( "poison" ) then
			ply:RemoveEffect( "poison" )
		end

		if ply:HasEffect( "poison_syringe" ) then
			ply:RemoveEffect( "poison_syringe" )
		end
	end,
	wait = 1,
	ignore500 = true,
} )

--[[-------------------------------------------------------------------------
Poison (syringe)
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "poison_syringe", {
	duration = 60,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/poison_alt.png" ) },
	},
	cantarget = scp_spec_filter,
	begin = function( self, ply, tier, args, refresh )
		if !IsValid( args[1] ) or !args[1]:IsPlayer() then return end
		if args[2] > self.args[2] then
			self.args[2] = args[2]
		end

		if args[3] < self.args[3] then
			self.args[3] = args[3]
		end

		self.args[1] = args[1]
		self.args[4] = args[1]:TimeSignature()
	end,
	think = function( self, ply, tier, args )
		if CLIENT then return end

		local att = args[1]
		local dmg = DamageInfo()

		dmg:SetDamage( args[2] )
		dmg:SetDamageType( DMG_DIRECT )

		if IsValid( att ) and att:IsPlayer() and att:CheckSignature( args[4] ) then
			dmg:SetAttacker( att )
		end

		ply:TakeDamageInfo( dmg )

		return args[3]
	end,
	wait = 1,
} )

--[[-------------------------------------------------------------------------
Experimental D
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "expd_rubber_bones", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		pl:SetProperty( "allow_bhop", true )
		pl:SetProperty( "expd_rubber_bones_special", CurTime() + 30 )

		local id = pl:SteamID64()

		AddRoundHook( "OnPlayerHitGround", "expd_effect"..id, function( ply, water, floater, speed )
			if ply != pl then return end
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
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "OnPlayerHitGround", "expd_effect"..id )
	end,
	ignore500 = true,
} )

AddSounds( "SLCEffects.EXPD.Bounce", "scp_lc/effects/expd/expd_jump_%i.ogg", 75, 1, 100, CHAN_BODY, 1, 3 )

EFFECTS.RegisterEffect( "expd_stamina_tweaks", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
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

		if SERVER then
			pl.ClassData.stamina = 200
		end

		local id = pl:SteamID64()

		AddRoundHook( "FinishMove", "expd_effect"..id, function( ply, mv )
			if ply != pl then return end
			ply:SetHealth( ply:GetStamina() / ply:GetMaxStamina() * ply:GetMaxHealth() )
		end )

		AddRoundHook( "SLCPostScaleDamage", "expd_effect"..id, function( ply, dmg )
			if ply != pl then return end

			local new = ply:GetStamina() - dmg:GetDamage()
			if new < 0 then return end

			ply:SetStamina( new )
			ply:SetHealth( new / ply:GetMaxStamina() * ply:GetMaxHealth() )

			ply.StaminaRegen = CurTime() + 1.5

			return SERVER
		end )

		AddRoundHook( "SLCHealed", "expd_effect"..id, function( target, healer, heal )
			if target != pl then return end

			local max = target:GetMaxStamina()
			local new = target:GetStamina() + heal / target:GetMaxHealth() * max

			if new > max then
				new = max
			end

			target:SetStamina( new )
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "FinishMove", "expd_effect"..id )
		RemoveRoundHook( "SLCPostScaleDamage", "expd_effect"..id )
		RemoveRoundHook( "SLCHealed", "expd_effect"..id )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_revive", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "SLCPostScaleDamage", "expd_effect"..id, function( ply, dmg )
			if CLIENT or ply != pl or dmg:IsDamageType( DMG_DIRECT ) then return end

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
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "SLCPostScaleDamage", "expd_effect"..id )
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
			pl:SelectWeaponByBase( "item_slc_holster" )
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

		local id = pl:SteamID64()

		AddRoundHook( "EntityTakeDamage", "expd_effect"..id, function( ply, dmg )
			if ply == pl then return true end
		end )

		AddRoundHook( "PlayerSwitchWeapon", "expd_effect"..id, function( ply )
			if ply == pl then return true end
		end )

		AddRoundHook( "SLCPlayerFootstep", "expd_effect"..id, function( ply )
			if ply == pl then return true end
		end )
	end,
	finish = function( self, pl )
		if SERVER then
			pl:GodDisable()
			pl:SetNoDraw( false )
		end

		local id = pl:SteamID64()
		RemoveRoundHook( "EntityTakeDamage", "expd_effect"..id )
		RemoveRoundHook( "PlayerSwitchWeapon", "expd_effect"..id )
		RemoveRoundHook( "SLCPlayerFootstep", "expd_effect"..id )
	end,
	think = function( self, ply )
		if CLIENT then return end

		if ply:Health() >= ply:GetMaxHealth() then return 999 end
		ply:AddHealth( 5 )
	end,
	wait = 0.3,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_lifesteal", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "SLCPostScaleDamage", "expd_effect"..id, function( ply, dmg )
			if !IsValid( ply ) or !ply:IsPlayer() or dmg:IsDamageType( DMG_DIRECT ) then return end

			local attacker = dmg:GetAttacker()
			if attacker != pl or SCPTeams.IsAlly( attacker:SCPTeam(), ply:SCPTeam() ) then return end
			
			attacker:AddHealth( dmg:GetDamage() * 0.25 )
		end )

		AddRoundHook( "SLCCanHeal", "expd_effect"..id, function( target, healer, heal_type )
			if target == pl then return false end
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "SLCPostScaleDamage", "expd_effect"..id )
		RemoveRoundHook( "SLCCanHeal", "expd_effect"..id )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_glass_cannon", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "SLCPlayerDeath", "expd_effect"..id, function( victim, attacker )
			if attacker != pl or !IsValid( victim ) or !victim:IsPlayer() or !IsValid( attacker ) or !attacker:IsPlayer() then return end
			if SCPTeams.IsAlly( attacker:SCPTeam(), victim:SCPTeam() ) then return end

			attacker:SetProperty( "expd_glass_cannon", attacker:GetProperty( "expd_glass_cannon", 0 ) + 1 )
		end )

		AddRoundHook( "EntityTakeDamage", "expd_effect"..id, function( ply, dmg )
			if ply != pl then
				local attacker = dmg:GetAttacker()
				if attacker != pl then return end

				ply = attacker
			end

			local num = ply:GetProperty( "expd_glass_cannon", 0 )
			if num <= 0 then return end

			dmg:ScaleDamage( 1 + 0.25 * num )
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "SLCPLayerDeath", "expd_effect"..id )
		RemoveRoundHook( "EntityTakeDamage", "expd_effect"..id )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_speedy_gonzales", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "SLCScaleSpeed", "expd_effect"..id, function( ply, mod )
			if ply != pl then return end

			local stamina = ply:GetStamina() / ply:GetMaxStamina()
			if stamina > 0.5 then
				mod[1] = mod[1] * ( 1.5 - stamina )
			elseif stamina < 0.5 then
				mod[1] = mod[1] * ( 1 - stamina ) * 2
			end
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "SLCScaleSpeed", "expd_effect"..id )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_reflect", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "SLCPostScaleDamage", "expd_effect"..id, function( ply, dmg )
			if !IsValid( ply ) or !ply:IsPlayer() or dmg:IsDamageType( DMG_DIRECT ) or ply:GetProperty( "expd_reflected" ) then return end

			if ply == pl then
				local attacker = dmg:GetAttacker()
				if !IsValid( attacker ) or !attacker:IsPlayer() or attacker == ply then return end

				attacker:SetProperty( "expd_reflected", true )
				ply:SetProperty( "prevent_rdm", true )

				attacker:TakeDamage( dmg:GetDamage(), ply, ply )

				attacker:SetProperty( "expd_reflected", false )
				ply:SetProperty( "prevent_rdm", false )
			else
				local attacker = dmg:GetAttacker()
				if attacker != pl or attacker == ply then return end

				attacker:SetProperty( "expd_reflected", true )
				attacker:TakeDamage( dmg:GetDamage() / 3, attacker, attacker )
				attacker:SetProperty( "expd_reflected", false )
			end
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "SLCPostScaleDamage", "expd_effect"..id )
	end,
	ignore500 = true,
} )

EFFECTS.RegisterEffect( "expd_invis", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "PlayerPostThink", "expd_effect"..id, function( ply )
			if CLIENT or ply != pl then return end

			local is_crouching = ply:Crouching()
			ply:SetNoDraw( is_crouching )

			local snd = ply:GetProperty( "expd_clown_sound", 0 )
			if !is_crouching then
				ply:SetProperty( "expd_clown_sound", 0 )
			elseif snd == 0 then
				ply:SetProperty( "expd_clown_sound", CurTime() + 4 + SLCRandom() * 6 )
			elseif snd < CurTime() then
				ply:SetProperty( "expd_clown_sound", 0 )
				ply:EmitSound( "SLCEffects.EXPD.Clown" )
			end

			if !is_crouching then return end

			local stamina = ply:GetStamina() - FrameTime() * ( ply:GetVelocity():Length2DSqr() > 25 and 4 or 2 )
			if stamina <= 0 then
				ply:TakeDamage( 5, ply, ply )
				stamina = 5
			end

			ply:SetStamina( stamina )
			ply.StaminaRegen = CurTime() + 1.5
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "PlayerPostThink", "expd_effect"..id )
	end,
	ignore500 = true,
} )

AddSounds( "SLCEffects.EXPD.Clown", "scp_lc/effects/expd/expd_clown_%i.ogg", 70, 0.5, { 90, 110 }, CHAN_BODY, 1, 2 )

local expd_enderman_trace = {}
expd_enderman_trace.mask = MASK_ALL
expd_enderman_trace.output = expd_enderman_trace

EFFECTS.RegisterEffect( "expd_enderman", {
	duration = -1,
	stacks = 0,
	lang = "expd_all",
	tiers = {
		{ icon = Material( "slc/hud/effects/expd.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPClass() == CLASSES.EXPD
	end,
	begin = function( self, pl )
		local id = pl:SteamID64()

		AddRoundHook( "PostEntityTakeDamage", "expd_effect"..id, function( ply, dmg )
			if ply != pl or dmg:GetDamage() >= ply:Health() or ply:IsInZone( ZONE_PD ) then return end

			local n = 0
			local nav_list = {}

			for i, v in ipairs( navmesh.Find( ply:GetPos(), 1500, 256, 256 ) ) do
				if v:GetSizeX() >= 100 and v:GetSizeY() >= 100 then
					n = n + 1
					nav_list[n] = v
				end
			end

			if n <= 0 then return end

			for i = 1, n > 5 and 5 or n do
				local nav = table.remove( nav_list, SLCRandom( n ) )
				n = n - 1

				for j = 1, 5 do
					local pos = j < 5 and nav:GetRandomPoint() or nav:GetCenter()

					local mins, maxs = ply:GetCollisionBounds()
					mins.x = mins.x * 1.1
					mins.y = mins.y * 1.1
					maxs.x = maxs.x * 1.1
					maxs.y = maxs.y * 1.1

					expd_enderman_trace.start = pos + Vector( 0, 0, 8 )
					expd_enderman_trace.endpos = pos - Vector( 0, 0, 8 )
					expd_enderman_trace.mins = mins
					expd_enderman_trace.maxs = maxs

					util.TraceHull( expd_enderman_trace )
					if expd_enderman_trace.Fraction == 0 then continue end

					ply:EmitSound( "SLCEffects.EXPD.Enderman" )
					ply:SetProperty( "expd_enderman_pos", expd_enderman_trace.HitPos )
					//ply:SetPos( expd_enderman_trace.HitPos )

					return
				end
			end
		end )

		AddRoundHook( "PlayerPostThink", "expd_effect"..id, function( ply )
			if ply != pl then return end

			local pos = ply:GetProperty( "expd_enderman_pos" )
			if !pos then return end

			ply:SetPos( pos )
			ply:SetProperty( "expd_enderman_pos", nil )
		end )
	end,
	finish = function( self, pl )
		local id = pl:SteamID64()
		RemoveRoundHook( "PostEntityTakeDamage", "expd_effect"..id )
		RemoveRoundHook( "PlayerPostThink", "expd_effect"..id )
	end,
	ignore500 = true,
} )

AddSounds( "SLCEffects.EXPD.Enderman", "scp_lc/effects/expd/expd_enderman_%i.ogg", 75, 0.75, { 95, 105 }, CHAN_BODY, 1, 4 )

--[[-------------------------------------------------------------------------
Healing Hooks
---------------------------------------------------------------------------]]
hook.Add( "SLCCanHeal", "SLCEffectsCanHeal", function( target, healer, heal_type )
	if heal_type == "poison" then return end

	if target:HasEffect( "radiation" ) then return false end
	if target:HasEffect( "poison" ) and heal_type != "antidote" then return false end
end )

hook.Add( "SLCNeedHeal", "SLCEffectsNeedHeal", function( target, healer, heal_type )
	if target:HasEffect( "bleeding" ) then return true end
	if target:HasEffect( "heavy_bleeding" ) then return true end
	if target:HasEffect( "deep_wounds" ) then return true end
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
	target:RemoveEffect( "heavy_bleeding", true )
	target:RemoveEffect( "deep_wounds", true )
	target:RemoveEffect( "fracture" )
end )