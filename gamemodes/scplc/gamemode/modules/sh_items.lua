--[[-------------------------------------------------------------------------
Documents
---------------------------------------------------------------------------]]
SLC_DOCUMENTS = {}

function SLCAddDocument( name, mat_path, reward, merge )
	local mat

	if mat_path then
		mat = Material( mat_path )

		if mat:IsError() then
			mat = nil
		end
	end

	local tbl = {
		Base = "item_slc_document",
		Selectable = !!mat_path,
		Name = name,
		Reward = reward,
		Page = mat,
	}

	if merge then
		table.Merge( tbl, merge )
	end

	local class = "item_slc_document_"..name
	local id = table.insert( SLC_DOCUMENTS, class )
	tbl.ID = id

	weapons.Register( tbl, class )
end

local function document_escape( ply )
	local num, total = 0, 0

	for k, v in pairs( ply:GetWeapons() ) do
		if !v.IS_DOCUMENT then continue end

		num = num + 1

		if v.Reward and v.Reward > 0 then
			total = total + v.Reward
		end
	end

	if total > 0 then
		PlayerMessage( string.format( "docs$%i,%i", total, num ), ply )
		ply:AddFrags( total )
	end
end

hook.Add( "SLCPlayerEscaped", "SLCDocuments", document_escape )
hook.Add( "SLCPlayerEscorted", "SLCDocuments", document_escape )

for i = 1, 47 do
	local name = string.format( "doc%02i", i )
	SLCAddDocument( name, "slc/documents/"..name..".jpg" )
end

if SERVER then
	SLC_ROUND_DOCUMENTS = {}

	hook.Add( "SLCRoundCleanup", "SLCDocuments", function()
		SLC_ROUND_DOCUMENTS = table.Copy( SLC_DOCUMENTS )
	end )

	hook.Add( "SLCFullyLoaded", "SLCDocuments", function()
		ItemSpawnFunction( "document", function()
			local class

			if !SLC_ROUND_DOCUMENTS or #SLC_ROUND_DOCUMENTS == 0 then
				class = SLC_DOCUMENTS[SLCRandom( #SLC_DOCUMENTS )]
			else
				class = table.remove( SLC_ROUND_DOCUMENTS, SLCRandom( #SLC_ROUND_DOCUMENTS ) )
			end

			if class then
				return ents.Create( class )
			end
		end )
	end )
end

--[[-------------------------------------------------------------------------
Syringes
---------------------------------------------------------------------------]]
local syringes = {}
local list_small = {}
local list_big = {}

local function handle_upgrade( self, mode, exit, ply )
	local class = self:GetClass()
	local new_ent

	if mode == 0 then
		self:Remove()
		return
	elseif mode == 1 and SLCRandom( 2 ) == 1 then
		new_ent = "item_slc_poison"
	elseif mode == 2 then
		local s = syringes[class]
		if s then
			local use = s.is_better and list_big or list_small
			new_ent = use[SLCRandom( #use )]
		end
	elseif mode == 3 then
		local s = syringes[class]
		if s and s.better_class then
			new_ent = s.better_class
		end
	elseif mode == 4 then
		local s = syringes[class]
		if s and s.better_class and SLCRandom( 2 ) == 1 then
			new_ent = s.better_class
		else
			new_ent = list_big[SLCRandom( #list_big )]
		end
	end

	if !new_ent then
		self:SetPos( exit )

		if self.PickupPriority then
			self.Dropped = nil
			self.PickupPriorityTime = CurTime() + 10
		end

		return
	end

	local new = ents.Create( new_ent )
	if IsValid( new ) then
		new:SetPos( exit )
		new:Spawn()

		if self.PickupPriority then
			new.PickupPriority = self.PickupPriority
			new.PickupPriorityTime = CurTime() + 10
		end

		self:Remove()
	end
end

function AddSyringe( class, data )
	if !class then return end

	local swep = {
		Base 			= data.base or "item_slc_syringe",
		Language 		= data.lang,
		Color 			= data.color,
		InjectSpeed		= data.other_speed or data.speed,
		SelfInjectSpeed	= data.self_speed or data.speed,
		HandleUpgrade 	= handle_upgrade,
		UsedOn 			= data.callback,
	}

	if data.can_use or ( data.id and !data.base ) then
		local id = data.id

		swep.CanUseOn = data.can_use or function( self, target, owner )
			if !target:Alive() or !target:IsHuman() then return end
			if hook.Run( "SLCCanHeal", target, owner, id ) == false then return end

			return true
		end
	end

	if CLIENT then
		swep.SelectColor = data.select_color or data.is_better and Color( 0, 123, 255, 255 ) or Color( 255, 210, 0, 255 )
		swep.WepSelectIcon = data.select_icon and Material( data.select_icon )
	end

	for k, v in pairs( data.extra or {} ) do
		swep[k] = v
	end

	syringes[class] = {
		better_class = data.better_class,
		is_better = data.is_better or false,
	}

	if !data.no_reg then
		table.insert( data.is_better and list_big or list_small, class )
	end

	weapons.Register( swep, class )
end

// Morphine
AddSyringe( "item_slc_morphine", {
	id 				= "morphine",
	lang			= "MORPHINE",
	color			= Vector( 0.8, 0.2, 0.2 ),
	other_speed 	= 2.25,
	self_speed 		= 2,
	select_icon 	= "slc/items/morphine.png",

	is_better 		= false,
	better_class 	= "item_slc_morphine_big",

	extra = {
		ExtraHealth = 50,
	},

	callback = function( self, target, owner )
		local extra = target:GetExtraHealth() + self.ExtraHealth
		target:SetExtraHealth( extra )
		target:SetMaxExtraHealth( extra )
		target:SetProperty( "extra_hp_think", CurTime() + 1 )
	end
} )

AddSyringe( "item_slc_morphine_big", {
	base			= "item_slc_morphine",
	lang 			= "MORPHINE_BIG",
	other_speed 	= 1.33,
	self_speed 		= 1.15,

	is_better 		= true,

	extra = {
		ExtraHealth = 120,
	}
} )

// Adrenaline
AddSyringe( "item_slc_adrenaline", {
	id 				= "adrenaline",
	lang			= "ADRENALINE",
	color			= Vector( 0.4, 0.6, 1 ),
	other_speed 	= 2.25,
	self_speed 		= 2,
	select_icon 	= "slc/items/adrenaline.png",

	is_better 		= false,
	better_class 	= "item_slc_adrenaline_big",

	extra = {
		BoostTime = 25,
	},

	callback = function( self, target, owner )
		if CLIENT then return end

		local time = target:GetStaminaBoost() - CurTime()
		if time < 0 then
			time = 0
		end

		time = time + self.BoostTime

		target:SetStaminaBoost( CurTime() + time )
		target:SetStaminaBoostDuration( time )
	end
} )

AddSyringe( "item_slc_adrenaline_big", {
	base			= "item_slc_adrenaline",
	lang 			= "ADRENALINE_BIG",
	other_speed 	= 1.33,
	self_speed 		= 1.15,

	is_better 		= true,

	extra = {
		BoostTime = 60,
	}
} )

// Speed
AddSyringe( "item_slc_ephedrine", {
	id 				= "ephedrine",
	lang			= "EPHEDRINE",
	color			= Vector( 0.8, 0.75, 0.25 ),
	other_speed 	= 2.25,
	self_speed 		= 2,
	select_icon 	= "slc/items/ephedrine.png",

	is_better 		= false,
	better_class 	= "item_slc_ephedrine_big",

	extra = {
		BoostPower = 1.2,
	},

	can_use = function( self, target, owner )
		if !target:Alive() or !target:IsHuman() or target:HasEffect( "ephedrine" ) then return end
		if hook.Run( "SLCCanHeal", target, owner, "ephedrine" ) == false then return end

		return true
	end,
	callback = function( self, target, owner )
		if CLIENT then return end
		target:ApplyEffect( "ephedrine", 1, self.BoostPower )
	end,
} )

AddSyringe( "item_slc_ephedrine_big", {
	base			= "item_slc_ephedrine",
	lang 			= "EPHEDRINE_BIG",
	other_speed 	= 1.33,
	self_speed 		= 1.15,

	is_better 		= true,

	extra = {
		BoostPower = 1.5,
	}
} )

// Hemostatic
AddSyringe( "item_slc_hemostatic", {
	id 				= "hemostatic",
	lang			= "HEMOSTATIC",
	color			= Vector( 0.6, 0.4, 0.25 ),
	other_speed 	= 2.25,
	self_speed 		= 2,
	select_icon 	= "slc/items/hemostatic.png",

	is_better 		= false,
	better_class 	= "item_slc_hemostatic_big",

	extra = {
		BoostTime = 180,
	},

	can_use = function( self, target, owner )
		if !target:Alive() or !target:IsHuman() or target:HasEffect( "hemostatic" ) then return end
		if hook.Run( "SLCCanHeal", target, owner, "ephedrine" ) == false then return end

		return true
	end,
	callback = function( self, target, owner )
		if CLIENT then return end
		target:ApplyEffect( "hemostatic", 1, self.BoostTime )
	end
} )

AddSyringe( "item_slc_hemostatic_big", {
	base			= "item_slc_hemostatic",
	lang 			= "HEMOSTATIC_BIG",
	other_speed 	= 1.33,
	self_speed 		= 1.15,

	is_better 		= true,

	extra = {
		BoostTime = 540,
	}
} )

// Antidote
AddSyringe( "item_slc_antidote", {
	id 				= "antidote",
	lang			= "ANTIDOTE",
	color			= Vector( 0.5, 0.3, 0.9 ),
	other_speed 	= 2.25,
	self_speed 		= 2,
	select_icon 	= "slc/items/antidote.png",

	is_better 		= false,
	better_class 	= "item_slc_antidote_big",

	extra = {
		BoostTime = 120,
	},

	can_use = function( self, target, owner )
		if !target:Alive() or !target:IsHuman() or target:HasEffect( "antidote" ) then return end
		if hook.Run( "SLCCanHeal", target, owner, "ephedrine" ) == false then return end

		return true
	end,
	callback = function( self, target, owner )
		if CLIENT then return end
		target:ApplyEffect( "antidote", 1, self.BoostTime )
	end
} )

AddSyringe( "item_slc_antidote_big", {
	base			= "item_slc_antidote",
	lang 			= "ANTIDOTE_BIG",
	other_speed 	= 1.33,
	self_speed 		= 1.15,

	is_better 		= true,

	extra = {
		BoostTime = 360,
	}
} )

// Poison
AddSyringe( "item_slc_poison", {
	id 				= "poison",
	lang			= "POISON",
	color			= Vector( 0.1, 0.65, 0.1 ),
	other_speed 	= 2.25,
	self_speed 		= 2,
	select_icon 	= "slc/items/poison.png",

	is_better 		= false,
	better_class 	= "item_slc_poison_big",
	no_reg			= true,

	extra = {
		PoisonDamage = 1,
		PoisonTick = 0.8,
	},

	can_use = function( self, target, owner )
		return target:Alive() and target:IsHuman()
	end,
	callback = function( self, target, owner )
		if CLIENT then return end
		target:ApplyEffect( "poison_syringe", owner, self.PoisonDamage, self.PoisonTick )
	end
} )

AddSyringe( "item_slc_poison_big", {
	base			= "item_slc_poison",
	lang 			= "POISON_BIG",
	other_speed 	= 1.33,
	self_speed 		= 1.15,

	is_better 		= true,
	no_reg			= true,

	extra = {
		PoisonDamage = 3,
		PoisonTick = 0.333,
	}
} )