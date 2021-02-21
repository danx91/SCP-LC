SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "ACCESS_CHIP"

SWEP.WorldModel		= "models/weapons/alski/chip.mdl"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false
SWEP.EnableHolsterThink = true

SWEP.Selectable = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/chip.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.ChipName = ""

function SWEP:HandleUpgrade( mode, num_mode, exit, ply )
	local new, override = SelectUpgrade( self.ChipName, mode )

	hook.Run( "SLCChipUpgraded", self.ChipName, new, ply )

	//print( "Chip upgraded!", new, override )

	if new == true then
		self:Remove()
	else
		if new then
			if self.ChipName != new then
				local chip = GetChip( new )
				if chip then
					self:SetChipData( chip, override )
				end
			else
				self:SetAccessOverride( override or 0 )
			end
		end

		self:SetPos( exit )
		
		self.Dropped = nil
		self.PriorityTime = CurTime() + 10
	end
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "ChipID", "Int" )
	self:AddNetworkVar( "AccessOverride", "Int" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	if CLIENT then
		self:UpdateDescription()
	end
end

function SWEP:HolsterThink()
	if SERVER and !self.PickupPriority then
		--print( "setting pickup priority to", self.Owner )
		self.PickupPriority = self:GetOwner()
	end
end

function SWEP:Equip()
	self:CallBaseClass( "Equip" )
	self.PickupPriority = nil

	if CLIENT then
		self:UpdateDescription()
	end
end

function SWEP:OnDrop()
	self:CallBaseClass( "OnDrop" )

	self.PreventDropping = false
end

function SWEP:SetChipData( chip, override )
	self.ChipName = chip.name

	self:SetChipID( chip.id )
	self:SetAccessOverride( override or 0 )

	self:SetSkin( chip.skin )

	if chip.model then
		self:SetModel( chip.model )
	end
end

if CLIENT then
	function SWEP:UpdateDescription( id, override )
		local chip = GetChipByID( id or self:GetChipID() )

		if chip then
			local name = chip.name

			if self.Lang.NAMES[name] then
				name = self.Lang.NAMES[name]
			end

			self.PrintName = string.format( self.Lang.cname, name )
			self.Info = string.format( self.Lang.clearance, chip.level )

			--print( "desc", id, self:GetChipID(), override, self:GetAccessOverride() )
			local desc = GetChipDescription( chip.name, override or self:GetAccessOverride(), self.Lang.ACCESS, false )
			if desc then
				self.Info = self.Info..string.format( "\n%s\n\t%s", self.Lang.hasaccess, desc )
			end
		end
	end
end