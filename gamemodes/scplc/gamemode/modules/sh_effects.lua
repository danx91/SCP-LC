EFFECTS = {
	registry = {},
	effects = {}
}

/*
data = {
	duration = <time>,
	think = nil'/function( self, ply, tier, args ) return <delay> end,
	wait = 0//time between thinks
	begin = nil'/function( ply, tier, args ) end,
	finish = nil'/function( self, ply, tier, args ) end,
	stacks = 0(nil)/1/2, //0 - don't stack, refresh duration; 1 - stack effects; 2 - increase effect level, refresh duration
	tiers = { { icon = <material> } },
	cantarget = nil'/function( ply ) end //return false to disallow
}
*/

function EFFECTS.registerEffect( name, data )
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

	for k, v in ipairs( ply.EFFECTS ) do
		local eff = EFFECTS.effects[v.name]

		if v.endtime < CurTime() then
			if eff.finish then
				eff.finish( v, ply, v.tier, v.args )
			end

			table.remove( ply.EFFECTS, k )
		elseif eff.think then
			if eff.wait then
				if v.nextthink and v.nextthink > CurTime() then
					return
				end

				v.nextthink = CurTime() + eff.wait
			end

			eff.think( v, ply, v.tier, v.args )
		end
	end
end )

if CLIENT then
	net.Receive( "PlayerEffect", function( len )
		local rem = net.ReadBool()
		local name = net.ReadString()

		if rem then
			local all = net.ReadBool()

			LocalPlayer():RemoveEffect( name, all )
		else
			local args = net.ReadTable()

			LocalPlayer():ApplyEffect( name, args )
		end
	end )
end

local PLAYER = FindMetaTable( "Player" )

function PLAYER:ApplyEffect( name, ... )
 	local args = {...}
	local effect = EFFECTS.effects[name]

	if !effect then return end
	if effect.cantarget and effect.cantarget( self ) == false then return end

	local tier = 1

	if effect.tiers > 1 and isnumber( args[1] ) then
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
					v.endtime = CurTime() + effect.duration

					if effect.stacks == 2 then
						local ntier = v.tier + tier

						if ntier > effect.tiers then
							ntier = effect.tiers
						end

						v.tier = ntier
					end

					if SERVER then
						net.Start( "PlayerEffect" )
							net.WriteBool( false )
							net.WriteString( name )
							net.WriteTable( args )
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

	table.insert( self.EFFECTS, { name = name, tier = tier, icon = EFFECTS.registry[name.."_"..tier], endtime = endtime, args = args } )
	self.EFFECTS_REG[name] = true

	if effect.begin then
		effect.begin( self, tier, args )
	end

	if SERVER then
		net.Start( "PlayerEffect" )
			net.WriteBool( false )
			net.WriteString( name )
			net.WriteTable( args )
		net.Send( self )
	end
end

--if name == nil -> remove all effects
--if all == true -> if effect.stacks == 1: remove all effects with this name instead of oldest one; if effect.stacks == 2: remove effect insetad of decreasing tier
function PLAYER:RemoveEffect( name, all )
	if !name or name == "" then
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

		for i, v in ipairs( self.EFFECTS ) do
			if v.name == name then
				if effect.stacks != 2 or all or v.tier == 1 then
					table.remove( self.EFFECTS, i )

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
	return self.EFFECTS_REG[name] == true
end

--[[-------------------------------------------------------------------------
Bleeding
---------------------------------------------------------------------------]]
EFFECTS.registerEffect( "bleeding", {
	duration = 15,
	stacks = 2,
	tiers = {
		{ icon = Material( "slc_hud/effects/bleeding1.png" ) },
		{ icon = Material( "slc_hud/effects/bleeding2.png" ) },
		{ icon = Material( "slc_hud/effects/bleeding3.png" ) },
	},
	cantarget = function( ply )
		return ply:SCPTeam() != TEAM_SPEC and ply:SCPTeam() != TEAM_SCP
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
	pitch = 50,
	sound = "physics/flesh/flesh_squishy_impact_hard1.wav",
	channel = CHAN_STATIC,
} )

--[[-------------------------------------------------------------------------
Door lock
---------------------------------------------------------------------------]]
EFFECTS.registerEffect( "doorlock", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc_hud/effects/doorlock.png" ) }
	},
	begin = function( ply, tier, args )
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