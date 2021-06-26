EFFECTS = {
	registry = {},
	effects = {}
}

/*
data = {
	duration = <time>,
	think = nil'/function( self, ply, tier, args ) (return <delay> <- not working, use wait instead) end,
	wait = 0//time between thinks
	begin = nil'/function( self, ply, tier, args, refresh ) end,
	finish = nil'/function( self, ply, tier, args, interrupt ) end,
	stacks = 0(nil)/1/2, //0 - don't stack, refresh duration; 1 - stack effects; 2 - increase effect level, refresh duration
	tiers = { { icon = <material> } },
	cantarget = nil'/function( ply ) end //return false to disallow
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

	for i, v in rpairs( ply.EFFECTS ) do
		local eff = EFFECTS.effects[v.name]

		if v.endtime != -1 and v.endtime < CurTime() then
			if eff.finish then
				eff.finish( v, ply, v.tier, v.args, false )
			end

			table.remove( ply.EFFECTS, i )

			local found = false
			for _, e in pairs( ply.EFFECTS ) do
				if e.name == v.name then
					found = true
					break
				end
			end

			if !found then
				ply.EFFECTS_REG[v.name] = nil
			end
		elseif eff.think then
			if eff.wait then
				if v.nextthink and v.nextthink > CurTime() then
					return
				end

				v.nextthink = CurTime() + eff.wait
			end

			local override = eff.think( v, ply, v.tier, v.args )
			if isnumber( override ) then
				v.nextthink = CurTime() + override
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

	if !effect.stacks or effect.stacks == 0 or effect.stacks == 2 then
		if self.EFFECTS_REG[name] then
			for k, v in pairs( self.EFFECTS ) do
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
						effect.begin( v, self, v.tier, args, true )
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
	local tab = { name = name, tier = tier, endtime = endtime, args = args }

	table.insert( self.EFFECTS, 1, tab )
	self.EFFECTS_REG[name] = true

	if effect.begin then
		effect.begin( tab, self, tier, args, false )
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
		for k, v in pairs( self.EFFECTS ) do
			local effect = EFFECTS.effects[v.name]

			if effect and effect.finish then
				effect.finish( v, self, v.tier, v.args, true )
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
						effect.finish( v, self, v.tier, v.args, true )
					end

					if effect.stacks != 1 or all then
						self.EFFECTS_REG[name] = nil
					else
						for k, eff in pairs( self.EFFECTS ) do
							local found = false

							if eff.name == name then
								found = true
								break
							end

							if !found then
								self.EFFECTS_REG[name] = nil
							end
						end
					end
				else
					v.tier = v.tier - 1
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

function PLAYER:HasEffect( name )
	if self.EFFECTS_REG then
		return self.EFFECTS_REG[name] == true
	end
end

--[[-------------------------------------------------------------------------
Bleeding
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "bleeding", {
	duration = 15,
	stacks = 2,
	tiers = {
		{ icon = Material( "slc/hud/effects/bleeding1.png" ) },
		{ icon = Material( "slc/hud/effects/bleeding2.png" ) },
		{ icon = Material( "slc/hud/effects/bleeding3.png" ) },
	},
	cantarget = function( ply )
		local team = ply:SCPTeam()
		return team != TEAM_SPEC and team != TEAM_SCP
	end,
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
			if self.nsound and self.nsound > CurTime() then return end
			self.nsound = CurTime() + 2.5

			ply:EmitSound( "SLCEffects.Bleeding" )
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
Door lock
---------------------------------------------------------------------------]]
EFFECTS.RegisterEffect( "doorlock", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/doorlock.png" ) }
	},
	cantarget = function( ply )
		if CLIENT then
			return true
		end

		return !ply:GetSCP096Chase()
	end,
	begin = function( self, ply, tier, args, refresh )
		if CLIENT then
			ply:EmitSound( "SLCEffects.DoorLockBeep" )
		end
	end
} )

sound.Add( {
	name = "SLCEffects.DoorLockBeep",
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "hl1/fvox/beep.wav",
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
	cantarget = function( ply )
		local team = ply:SCPTeam()

		if team == TEAM_SPEC or team == TEAM_SCP then
			return false
		end

		if CLIENT then
			return true
		end

		local mask = ply:GetWeapon( "item_slc_gasmask" )
		if IsValid( mask ) and mask:GetEnabled() or ply:GetSCP714() then
			return false
		end

		return true
	end,
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
	cantarget = function( ply )
		local team = ply:SCPTeam()
		return team != TEAM_SPEC and team != TEAM_SCP
	end,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

			if ply:GetSanity() / ply:GetMaxSanity() > 0.1 then
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
	cantarget = function( ply )
		local team = ply:SCPTeam()

		if team == TEAM_SPEC or team == TEAM_SCP then
			return false
		end

		local mask = ply:GetWeapon( "item_slc_gasmask" )

		if IsValid( mask ) and mask:GetEnabled() or SERVER and ply:GetSCP714() then
			return false
		end

		return true
	end,
	begin = function( self, ply, tier, args, refresh )
		if SERVER and !refresh then
			ply:PushSpeed( 0.65, 0.65, -1, "SLC_Choke" )
		end

		if CLIENT then
			ply.choke = true
		end
	end,
	finish = function( self, ply, tier, args, interrupt )
		if SERVER then
			ply:PopSpeed( "SLC_Choke" )
		end

		if CLIENT then
			ply.choke = false
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
		if LocalPlayer().choke then
			clr.colour = 0
			clr.contrast = clr.contrast * 0.65
			clr.brightness = clr.brightness - 0.04

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
	cantarget = function( ply )
		local team = ply:SCPTeam()

		if team == TEAM_SPEC or team == TEAM_SCP then
			return false
		end

		local mask = ply:GetWeapon( "item_slc_gasmask" )

		if IsValid( mask ) and mask:GetEnabled() or SERVER and ply:GetSCP714() then
			return false
		end

		return true
	end,
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
	cantarget = function( ply )
		local team = ply:SCPTeam()
		return team != TEAM_SPEC and team != TEAM_SCP
	end,
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

hook.Add( "SLCScaleHealing", "SLCDeepWounds", function( ply, source, heal )
	if ply:HasEffect( "deep_wounds" ) then
		return heal * 0.25
	end
end )