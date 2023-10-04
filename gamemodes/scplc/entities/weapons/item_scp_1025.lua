SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "SCP1025"

SWEP.WorldModel		= "models/mishka/models/scp1025.mdl"

SWEP.ShouldDrawWorldModel 	= false
SWEP.ShouldDrawViewModel = false

SWEP.DrawCrosshair = false

SWEP.SelectFont = "SCPHUDMedium"

local diseases = {}
local callbacks = {}
local pages = {}

function SWEP:SetupDataTables()
	self:AddNetworkVar( "Disease", "Int" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	self.PlayerCache = {}
end

function SWEP:Equip()
	if SERVER then
		local owner = self:GetOwner()
		local sig = owner:TimeSignature()

		if !self.PlayerCache[sig] then
			local rand = math.random( #diseases )

			self:SetDisease( rand )
			self.PlayerCache[sig] = rand
		else
			self:SetDisease( self.PlayerCache[sig] or 0 )
		end
	end
end

function SWEP:Deploy()
	if SERVER then
		local owner = self:GetOwner()
		local sig = owner:TimeSignature()

		if !self.PlayerCache[sig] then
			self:Equip()
		end

		if !owner:GetProperty( "slc_1025_disease" ) and !owner:GetSCP714() then
			local cb = callbacks[self.PlayerCache[sig]]
			if cb then
				cb( owner )
			end
		end
	end
end

function SWEP:PrimaryAttack()

end

if CLIENT then
	local page = Material( "slc/misc/page.png" )
	local pw = page:Width()
	local ph = page:Height()
	local ratio = pw / ph

	local page_color = Color( 255, 255, 255, 255 )
	local text_color = Color( 0, 0, 0, 255 )

	function SWEP:DrawHUD()
		local w, h = ScrW(), ScrH()

		local dh = h * 0.75
		local dw = dh * ratio

		local x = w * 0.5 - dw * 0.5
		local y = h * 0.5 - dh * 0.5

		surface.SetDrawColor( page_color )
		surface.SetMaterial( page )
		surface.DrawTexturedRect( x, y, dw, dh )

		local id = self:GetDisease()
		local name = diseases[id]

		if name then
			draw.Text{
				text = pages[id] or "00",
				pos = { x + dw - 16, y + dh - 16 },
				font = "SCP1025Font",
				color = text_color,
				xalign = TEXT_ALIGN_RIGHT,
				yalign = TEXT_ALIGN_BOTTOM,
			}

			local _, th = draw.Text{
				text = self.Lang.diseases[name] or name,
				pos = { w * 0.5, y + w * 0.03 },
				font = "SCPHUDMedium",
				color = text_color,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}

			local desc = self.Lang.descriptions[name]
			if desc then
				draw.MultilineText( x, y + w * 0.03 + th * 0.5, desc, "SCP1025Font", text_color, dw, w * 0.0175, 4, "justify" )
			end
		end
	end

	hook.Add( "RebuildFonts", "SCP1025Font", function()
		surface.CreateFont( "SCP1025Font", {
			font = "Arial",
			size = ScrW() * 0.012,
			antialias = true,
			weight = 550,
		} )
	end )
end

--[[-------------------------------------------------------------------------
Global functions
---------------------------------------------------------------------------]]
function AddSCP1025Disease( name, page, cb )
	local id = table.insert( diseases, name )
	callbacks[id] = cb
	pages[id] = page
end

--Negative
AddSCP1025Disease( "arrest", 17, function( ply )
	local t = ply:AddTimer( "1025disease", math.random( 30, 90 ), 1, function( self )
		if IsValid( ply ) then
			ply:SetProperty( "death_info_override", {
				type = "dead",
				args = {
					"table;WEAPONS;SCP1025;death_info_arrest"
				}
			} )

			ply:Kill()
		end
	end, nil, false, true )

	ply:SetProperty( "slc_1025_disease", {
		id = "arrest",
		remove = function()
			if IsValid( t ) then
				t:Destroy()
			end
		end
	} )
end )

local function gen_effect_cb( name )
	return function( ply )
		ply:ApplyEffect( name )
	
		ply:SetProperty( "slc_1025_disease", {
			id = name,
			remove = function()
				if IsValid( ply ) then
					ply:RemoveEffect( name )
				end
			end
		} )
	end
end

AddSCP1025Disease( "asthma", 30, gen_effect_cb( "asthma" ) )
AddSCP1025Disease( "blindness", 47, gen_effect_cb( "blindness" ) )
AddSCP1025Disease( "hemo", 24, gen_effect_cb( "hemo" ) )
AddSCP1025Disease( "oste", 49, gen_effect_cb( "oste" ) )

--Positive
AddSCP1025Disease( "adhd", 15, gen_effect_cb( "adhd" ) )
AddSCP1025Disease( "throm", 66, gen_effect_cb( "throm" ) )
AddSCP1025Disease( "urbach", 92, gen_effect_cb( "urbach" ) )

local can_target = function( ply )
	local team = ply:SCPTeam()

	if team == TEAM_SPEC or team == TEAM_SCP then
		return false
	end

	if ply:GetSCP714() then
		return false
	end

	return true
end

EFFECTS.RegisterEffect( "asthma", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:GetStamina() < ply:GetMaxStamina() * 0.75 then
				ply:EmitSound( "SLCEffects.Asthma" )
				return math.random( 10, 30 )
			end
		end
	end,
	wait = 3,
	hide = true,
} )

AddSounds( "SLCEffects.Asthma", "scp_lc/effects/choke/cough%i.ogg", 90, 1, { 90, 110 }, CHAN_STATIC, 1, 3 )

EFFECTS.RegisterEffect( "blindness", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	hide = true,
} )

EFFECTS.RegisterEffect( "hemo", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	hide = true,
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
		if refresh then
			self.args[2] = 1

			if IsValid( args[1] ) then
				self.args[1] = args[1]
			end
		end
	end,
	finish = function( self, ply, tier, args, interrupt, all )
		if SERVER and interrupt and !all then
			ply:AddTimer( "reopen_wound", math.random( 30, 120 ), 1, function()
				if IsValid( ply ) and !ply:HasEffect( "heavy_bleeding" ) then
					if math.random( 1, 100 ) <= 50 / args[2] then
						ply:ApplyEffect( "heavy_bleeding", args[1], args[2] + 1 )
					end
				end
			end )
		end
	end,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

			local att = args[1]
			local dmg = DamageInfo()

			dmg:SetDamage( 2 )
			dmg:SetDamageType( DMG_DIRECT )

			if IsValid( att ) then
				dmg:SetAttacker( att )
			end

			ply:TakeDamageInfo( dmg )
			AddRoundStat( "bleed", 2 )
		else
			if self.nsound and self.nsound > CurTime() then return end
			self.nsound = CurTime() + 5

			ply:EmitSound( "SLCEffects.Bleeding" )
		end
	end,
	wait = 3,
} )
EFFECTS.RegisterEffect( "oste", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	hide = true,
} )

EFFECTS.RegisterEffect( "adhd", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	hide = true,
} )

EFFECTS.RegisterEffect( "throm", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	hide = true,
} )
EFFECTS.RegisterEffect( "light_bleeding", {
	duration = 10,
	stacks = 0,
	tiers = {
		{ icon = Material( "slc/hud/effects/bleeding1.png" ) },
	},
	cantarget = function( ply )
		local team = ply:SCPTeam()
		return team != TEAM_SPEC and team != TEAM_SCP
	end,
	begin = function( self, ply, tier, args, refresh )
		if refresh then
			self.args[2] = self.args[2] + 0.5

			if self.args[2] > 3 then
				self.args[2] = 3
			end

			if IsValid( args[1] ) then
				self.args[1] = args[1]
			end
		end
	end,
	think = function( self, ply, tier, args )
		if SERVER then
			if ply:SCPTeam() == TEAM_SPEC or ply:SCPTeam() == TEAM_SCP then return end

			local att = args[1]
			local dmg = DamageInfo()

			dmg:SetDamage( args[2] )
			dmg:SetDamageType( DMG_DIRECT )

			if IsValid( att ) then
				dmg:SetAttacker( att )
			end
			
			ply:TakeDamageInfo( dmg )
			AddRoundStat( "bleed", args[2] )
		else
			ply:EmitSound( "SLCEffects.Bleeding" )
		end
	end,
	wait = 2,
} )
EFFECTS.RegisterEffect( "urbach", {
	duration = -1,
	stacks = 0,
	tiers = {
		{}
	},
	cantarget = can_target,
	hide = true,
} )

hook.Add( "SLCStamina", "SLCSCP1025Stamina", function( ply, data )
	if ply:HasEffect( "asthma" ) then
		data.regen_delay = data.regen_delay * 1.5
		data.use_delay = data.use_delay * 0.8
		data.regen_delay_running = 2.5
	elseif ply:HasEffect( "adhd" ) then
		data.regen_delay = data.regen_delay * 0.85
		data.use_delay = data.use_delay * 1.15
	end
end )

hook.Add( "SLCScreenMod", "SLCSCP1025Screen", function( data )
	if LocalPlayer():HasEffect( "blindness" ) then
		data.brightness = -0.1
		data.contrast = 0.7
	end
end )

hook.Add( "SLCApplyEffect", "SLCSCP1025Effect", function( p, name, args )
	if name == "bleeding" and p:HasEffect( "hemo" ) then
		p:ApplyEffect( "heavy_bleeding", args[1], 1 )
		return true
	elseif name == "bleeding" and p:HasEffect( "throm" ) then
		p:ApplyEffect( "light_bleeding", args[1], 1 )
		return true
	end
end )

hook.Add( "SLCFallDamage", "SLCSCP1025Fall", function( ply, water, floater, speed )
	if ply:HasEffect( "oste" ) then
		return speed, 110
	end
end )

hook.Add( "SLCPlayerSanityChange", "SLCSCP1025Sanity", function ( ply, sanitytype, num, data )
	if ply:HasEffect( "urbach" ) then
		return true
	end
end )

hook.Add( "SLCSCP500Used", "SLCSCP1025SCP500", function( ply )
	local prop = ply:GetProperty( "slc_1025_disease" )
	if prop and prop.remove then
		prop.remove()
	end

	ply:SetProperty( "slc_1025_disease", nil )
end )

hook.Add( "SLCHealed", "SLCSCP1025Healed", function( target, healer )
	target:RemoveEffect( "heavy_bleeding", true )
	target:RemoveEffect( "light_bleeding", true )
end )

hook.Add( "SLCNeedHeal", "SLCSCP1025NeedHeal", function( target, healer, heal_type )
	if target:HasEffect( "heavy_bleeding" ) then return true end
	if target:HasEffect( "light_bleeding" ) then return true end
end )