SWEP.Base 				= "weapon_scp_base"
SWEP.DeepBase 			= "weapon_scp_base"
SWEP.PrintName			= "SCP-023"

SWEP.HoldType 			= "fist"

SWEP.IndicatorEnabled = false
SWEP.IndicatorRotation = 0
//SWEP.Indicator = NULL

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Preys", "Int" )
	self:AddNetworkVar( "NextAttack", "Int" )
	self:AddNetworkVar( "Trap", "Entity" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage( "SCP023" )

	self.Preys = {}
	self.PreysLookup = {}

	--test only
	//self.MSGTimeout = {}
end		

SWEP.NThink = 0
SWEP.NextAttack = 0
function SWEP:Think()
	self:PlayerFreeze()

	local owner = self:GetOwner()

	if SERVER then
		if self.NThink < CurTime() then
			self.NThink = CurTime() + 0.5

			if #self.Preys > 0 then
				self:CheckPreys()
			end
		end

		if ROUND.preparing or ROUND.post then return end

		local pos = owner:GetPos()
		for k, v in pairs( player.GetAll() ) do
			if v != owner and !self.PreysLookup[v] then
				if IsValid( v ) and v:Alive() and v:SCPTeam() != TEAM_SPEC and v:SCPTeam() != TEAM_SCP then
					if pos:DistToSqr( v:GetPos() ) <= 490000 and owner:TestVisibility( v ) then
						self:AddPrey( v )
					end
				end
			/*elseif self.PreysLookup[v] and ( !self.MSGTimeout[v] or self.MSGTimeout[v] < CurTime() ) then
				print( "Not checking, in preys", v )
				self.MSGTimeout[v] = CurTime() + 1*/
			end
		end

		if self.NextAttack != 0 and self.NextAttack < CurTime() then
			self:CheckPreys()

			local len = #self.Preys
			local tab = table.remove( self.Preys, math.random( len ) )

			if tab then
				local target = tab[1]
				self.PreysLookup[target] = nil

				len = len - 1

				//print( "kill and tp", target )
				if IsValid( target ) and target:CheckSignature( tab[2] ) then
					self.NextAttack = CurTime() + 120 - ( self:GetUpgradeMod( "acd" ) or 0 ) - ( self:GetUpgradeMod( "acd2" ) or 0 )
					self:SetNextAttack( self.NextAttack )
					self:AddScore( 1 )

					AddRoundStat( "023" )

					target:StopAmbient( "023" )

					owner:SetPos( target:GetPos() )
					target:Burn( -1, 0, owner, 20, true, true, true )
					--target:EmitSound( "NPC_FastZombie.Scream" )

					local torem = math.ceil( len / 2 )
					//local n = 1

					/*print( "Pre", torem )
					PrintTable( self.Preys )
					PrintTable( self.PreysLookup )*/
					for i = 1, torem do
						local old = self.Preys[i][1] --player that is removed from list
						local ply_obj = self.Preys[i + torem] --player that is placed in the place of old player

						self.PreysLookup[old] = nil --remove old player from lookup

						self.Preys[i + torem] = nil --ply_obj overrides old player (old player is ultimately removed from list)
						self.Preys[i] = ply_obj
						//print( "Removing", old )
						//self.PreysLookup[self.Preys[i][1]] = nil


						//print( "SWAP", (i + torem).." -> "..i, ply_obj and ply_obj[1], old )

						/*if ply_obj and IsValid( ply_obj[1] ) then --?? local old?
							//print( "Removing ambient for", ply_obj[1] )
							ply_obj[1]:StopAmbient( "023" )
						end*/
						if IsValid( old ) then --stop ambient for removed player
							old:StopAmbient( "023" )
							//print( "stopping ambient for", old )
						end
					end
					/*print("Post")
					PrintTable( self.Preys )
					PrintTable( self.PreysLookup )*/

					self:CheckPreys()
				end
			end
		end
	end

	if CLIENT then
		if self.IndicatorEnabled then
			if IsValid( self.Indicator ) then
				//if !self.Hold then
					local pos = owner:EyePos()
					local ea = owner:EyeAngles()
					local ep = pos + ea:Forward() * 250

					local ang = Angle( 0, ea.y + self.IndicatorRotation, 0 )

					//self.LastPos = pos
					//self.LastEP = ep
					//self.LastAng = ang

					local result, valid = self:TraceIndicator( pos, ep, ang )

					self.Indicator:SetColor( valid and Color( 0, 255, 0, 50 ) or Color( 255, 0, 0, 50 ) )
					self.Indicator:SetPos( result )

					self.Indicator:SetAngles( ang )
				//else
					//self:TraceIndicator( self.LastPos, self.LastEP, self.LastAng )
				//end
			end
		end
	end
end

function SWEP:OnRemove()
	if SERVER then
		local trap = self:GetTrap()
		if IsValid( trap ) then
			trap:Remove()
		end
	end

	if CLIENT and IsValid( self.Indicator ) then
		self.Indicator:Remove()
	end
end

local trace_length = 75
function SWEP:PrimaryAttack()
	if ROUND.preparing then return end
	if self:GetUpgradeMod( "tdisable" ) then return end

	if self.IndicatorEnabled then
		self.IndicatorEnabled = false
		//self.NSecondary = CurTime() + 60 - ( self:GetUpgradeMod( "tcd" ) or 0 ) + ( self:GetUpgradeMod( "tadd" ) or 0 )
		local ct = CurTime()
		self:SetNextSecondaryFire( ct + 1 )
		//self.Hold = true

		if IsValid( self.Indicator ) then
			self.Indicator:SetNoDraw( true )
		end

		if SERVER then
			local owner = self:GetOwner()
			local pos = owner:EyePos()
			local ea = owner:EyeAngles()
			local ep = pos + ea:Forward() * 250

			local ang = Angle( 0, ea.y + self.IndicatorRotation, 0 )
			local result, valid, traces = self:TraceIndicator( pos, ep, ang )

			if valid then
				//local trap
				self:SetNextSecondaryFire( ct + 60 - ( self:GetUpgradeMod( "tcd" ) or 0 ) + ( self:GetUpgradeMod( "tadd" ) or 0 ) )

				local old = self:GetTrap()
				if IsValid( old ) then
					if old:GetIdle() then
						old:Remove()
						--trap = old
					end
				end

				--if !IsValid( trap ) then
					local trap = ents.Create( "slc_023_trap" )
				--end

				if IsValid( trap ) then
					trap:SetPos( result )
					trap:SetAngles( ang )
					trap:SetData( traces, trace_length + ( self:GetUpgradeMod( "dist" ) or 0 ), self )
					trap:SetOwner( owner )
					trap:Spawn()

					self:SetTrap( trap )
				end
			end
		end
	else
		self:CallBaseClass( "PrimaryAttack" )
	end
end

//SWEP.NSecondary = 0
function SWEP:SecondaryAttack()
	if ROUND.preparing then return end
	if self:GetUpgradeMod( "tdisable" ) then return end

	//if self.NSecondary < CurTime() then
		//self.NSecondary = CurTime() + 0.5
	if self:GetNextSecondaryFire() < CurTime() then
		self:SetNextSecondaryFire( CurTime() + 0.5 )

		//if IsValid( self:GetTrap() ) then return end
		//self.Hold = false

		if CLIENT then
			if !IsValid( self.Indicator ) then self:CreateIndicator() end
			//self:CreateIndicator()
			self.Indicator:SetNoDraw( self.IndicatorEnabled )
		end

		self.IndicatorEnabled = !self.IndicatorEnabled
		self.IndicatorRotation = 0
	end
end

SWEP.NReload = 0
function SWEP:Reload()
	if ROUND.preparing then return end
	
	if self.IndicatorEnabled and self.NReload < CurTime() then
		self.NReload = CurTime() + 0.05

		self.IndicatorRotation = self.IndicatorRotation + 6

		if self.IndicatorRotation >= 360 then
			self.IndicatorRotation = self.IndicatorRotation - 360
		end
	end
end

function SWEP:TraceIndicator( pos, ep, ang )
	local final
	local valid = false

	local trace1 = util.TraceLine( {
		start = pos,
		endpos = ep,
		mask = MASK_SOLID_BRUSHONLY,
	} )

	if trace1.Hit then
		final = trace1.HitPos
		valid = trace1.HitNormal.z > 0.9
	else
		local trace2 = util.TraceLine( {
			start = ep,
			endpos = ep - Vector( 0, 0, 100 ),
			mask = MASK_SOLID_BRUSHONLY,
		} )

		if trace2.Hit then
			final = trace2.HitPos
			valid = trace2.HitNormal.z > 0.9
		end
	end

	if !final then
		final = ep
	end

	local target
	if valid then
		local forward = ang:Forward()
		local p = final + Vector( 0, 0, 20 )

		--debugoverlay.Line( p - forward * 20, p + forward * trace_length, 0, Color( 255, 255, 255 ), false )

		local trpos = p + forward * trace_length
		local spacetr = util.TraceLine( {
			start = p - forward * 20,
			endpos = trpos,
			mask = MASK_SOLID_BRUSHONLY,
		} )

		if spacetr.Hit then
			return final, false
		end

		local trfirst = util.TraceLine( {
			start = trpos,
			endpos = trpos - Vector( 0, 0, 30 ),
			mask = MASK_SOLID_BRUSHONLY,
		} )

		if !trfirst.Hit then
			return final, false
		end

		local inworld
		local validtraces = {}
		local z1 = final.z

		local tl = trace_length + ( self:GetUpgradeMod( "dist" ) or 0 )
		for i = 1, 5 do
			local npos = trpos + forward * tl * i

			local tr = util.TraceLine( {
				start = npos,
				endpos = npos - Vector( 0, 0, 30 ),
				mask = MASK_SOLID_BRUSHONLY,
			} )

			if tr.StartSolid then
				/*if inworld then
					debugoverlay.Line( trpos + forward * tl * (i - 1), trpos + forward * tl * i, 0, Color( 255, 0, 0 ), true )
					break
				end*/

				--debugoverlay.Line( trpos + forward * tl * (i - 1), trpos + forward * tl * i, 0, Color( 0, 0, 255 ), true )
				inworld = true
			elseif tr.Hit then
				inworld = false
				table.insert( validtraces, i )
				--debugoverlay.Line( trpos + forward * tl * (i - 1), trpos + forward * tl * i, 0, Color( 0, 255, 0 ), true )
			else
				--debugoverlay.Line( trpos + forward * tl * (i - 1), trpos + forward * tl * i, 0, Color( 0, 255, 255 ), true )
				break
			end
		end

		local len = #validtraces 
		if len < 3 then
			return final, false
		end

		return final, true, validtraces
	end

	return final, false
end

function SWEP:AddPrey( ply )
	if !self.PreysLookup[ply] then
		//print( "Adding prey", ply )
		self.PreysLookup[ply] = true

		if #self.Preys == 0 then
			self.NextAttack = CurTime() + 120 - ( self:GetUpgradeMod( "acd" ) or 0 ) - ( self:GetUpgradeMod( "acd2" ) or 0 )
			self:SetNextAttack( self.NextAttack )
		end

		table.insert( self.Preys, { ply, ply:TimeSignature() } )

		local owner  = self:GetOwner()
		ply:PlayAmbient( "023", true, false, function( ply )
			return !IsValid( self ) or !IsValid( owner )
		end )
	else
		//print( "Alredy in preylist", ply )
	end
end

function SWEP:CheckPreys()
	for i, v in rpairs( self.Preys ) do
		local ply = v[1]
		local rem = false

		if !IsValid( ply ) then
			rem = true
			//print( "Not Valid!" )
		elseif !ply:Alive() then
			rem = true
			//print( "Not Alive!" )
		else
			local team = ply:SCPTeam()

			if team == TEAM_SPEC or team == TEAM_SCP or !ply:CheckSignature( v[2] ) then
				rem = true
				//print( "Wrong team or signature!" )
			end
		end

		if rem then
			self.PreysLookup[ply] = nil
			table.remove( self.Preys, i )

			if IsValid( ply ) then
				ply:StopAmbient( "023" )
			end

			//print( "Removed from preys", ply )
		end
	end

	if #self.Preys == 0 then
		self.NextAttack = 0
		self:SetNextAttack( 0 )
		//print( "No preys - disabling attack" )
		//print( "Preys:" )
		//PrintTable( self.Preys )
		//print( "Lookup:" )
		//PrintTable( self.PreysLookup )
	end

	self:SetPreys( #self.Preys )
end

function SWEP:DrawSCPHUD()
	if self.IndicatorEnabled then
		draw.Text{
			text = self.Lang.editMode1,
			pos = { ScrW() * 0.5, ScrH() * 0.97 },
			color = Color( 0, 255, 0 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
		draw.Text{
			text = self.Lang.editMode2,
			pos = { ScrW() * 0.5, ScrH() * 0.95 },
			color = Color( 0, 255, 0 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	else
		local time = self:GetNextAttack()

		if time > CurTime() then
			time = string.ToMinutesSeconds( time - CurTime() )
		else
			time = "-"
		end

		draw.Text{
			text = string.format( self.Lang.preys, self:GetPreys() )..", "..string.format( self.Lang.attack, time ),
			pos = { ScrW() * 0.5, ScrH() * 0.97 },
			color = Color( 0, 255, 0 ),
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}

		local txt, clr
		local trap = self:GetTrap()
		if IsValid( trap ) and trap:GetIdle() then
			txt = self.Lang.trapActive
			clr = Color( 0, 255, 0 )
		else
			txt = self.Lang.trapInactive
			clr = Color( 255, 0, 0 )
		end

		draw.Text{
			text = txt,
			pos = { ScrW() * 0.5, ScrH() * 0.95 },
			color = clr,
			font = "SCPHUDSmall",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}
	end
end

if CLIENT then
	function SWEP:CreateIndicator()
		if IsValid( self.Indicator ) then self.Indicator:Remove() end

		self.Indicator = CreateIndicator( "models/Novux/023/Novux_SCP-023.mdl", true, RENDERGROUP_TRANSLUCENT, RENDERMODE_TRANSCOLOR )
		self.Indicator:SetPos( self:GetOwner():GetPos() )
	end
end

hook.Add( "CanPlayerSeePlayer", "SCP023Visibility", function( p1, p2 )
	if p2:SCPClass() == CLASSES.SCP023 then
		local dist = p1:GetPos():Distance( p2:GetPos() )
		if dist > 700 then
			return false
		else
			local a = ( 670 - dist ) / 30
			if a > 0 then a = 0 end
			a = a + 1
			p2:SetColor( Color( 0, 0, 0, 178 + a * 77 ) )
		end
	end
end )

if SERVER then --Let's just copy 106 door behaviour
	hook.Add( "ShouldCollide", "SCP023Collision", function ( ent1, ent2 )
		if ent1:IsPlayer() and ent1:SCPClass() == CLASSES.SCP023 or ent2:IsPlayer() and ent2:SCPClass() == CLASSES.SCP023 then
			if ent1.ignorecollide106 or ent2.ignorecollide106 then
				return false
			end
		end
	end )
end

hook.Add( "EntityTakeDamage", "SCP106DMGMod", function( ent, dmg )
	if IsValid( ent ) and ent:IsPlayer() and ent:SCPClass() == CLASSES.SCP023 then
		local wep = ent:GetActiveWeapon()
		if IsValid( wep ) and wep.UpgradeSystemMounted then
			local mod = wep:GetUpgradeMod( "def" )

			if mod then
				if dmg:IsDamageType( DMG_BULLET ) then
					dmg:ScaleDamage( mod )
				end
			end
		end
	end
end )

AddAmbient( "023", "sound/scp_lc/scp/023/ambient.ogg", nil, nil, 0.2 )

DefineUpgradeSystem( "scp023", {
	grid_x = 4,
	grid_y = 3,
	upgrades = {
		{ name = "attack1", cost = 1, req = {}, reqany = false,  pos = { 1, 1 }, mod = { acd = 20 }, active = false },
		{ name = "attack2", cost = 2, req = { "attack1" }, reqany = false,  pos = { 1, 2 }, mod = { acd = 40 }, active = false },
		{ name = "attack3", cost = 4, req = { "attack2" }, reqany = false,  pos = { 1, 3 }, mod = { acd = 60 }, active = false },

		{ name = "trap1", cost = 1, req = {}, reqany = false,  pos = { 2, 1 }, mod = { tcd = 20 }, active = false },
		{ name = "trap2", cost = 2, req = { "trap1" }, reqany = false,  pos = { 2, 2 }, mod = { tcd = 40, dist = 5 }, active = false },
		{ name = "trap3", cost = 3, req = { "trap2" }, reqany = false,  pos = { 2, 3 }, mod = { dist = 10 }, active = false },

		{ name = "hp", cost = 2, req = {}, reqany = false,  pos = { 3, 1 }, mod = { tadd = 30, def = 0.9 }, active = 1000 },
		{ name = "speed", cost = 3, req = { "hp" }, reqany = false,  pos = { 3, 2 }, mod = { tadd = 60, def = 0.75 }, active = 1.1 },
		{ name = "alt", cost = 5, req = { "speed" }, reqany = false,  pos = { 3, 3 }, mod = { tdisable = true, def = 0.6, acd2 = 30 }, active = true },

		{ name = "nvmod", cost = 1, req = {}, reqany = false,  pos = { 4, 2 }, mod = {}, active = false },
	},
	rewards = { --16 + 1
		{ 1, 1 },
		{ 2, 2 },
		{ 3, 1 },
		{ 4, 1 },
		{ 5, 2 },
		{ 6, 1 },
		{ 7, 1 },
		{ 8, 2 },
		{ 9, 2 },
		{ 10, 3 },
	}
} )

function SWEP:OnUpgradeBought( name, data, group )
	if name == "alt" then
		self.IndicatorEnabled = false

		if CLIENT and IsValid( self.Indicator ) then
			self.Indicator:SetNoDraw( true )
		end
	elseif name == "speed" then
		if SERVER then
			local owner = self:GetOwner()
			if IsValid( owner ) then
				owner:PushSpeed( data, data, -1 )
			end
		end
	elseif name == "hp" then
		if SERVER then
			local owner = self:GetOwner()
			if IsValid( owner ) then
				owner:SetMaxHealth( owner:GetMaxHealth() + data )
				owner:SetHealth( owner:Health() + data )
			end
		end
	end
end

InstallUpgradeSystem( "scp023", SWEP )