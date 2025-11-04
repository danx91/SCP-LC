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

function SWEP:HandleUpgrade( mode, exit, ply )
	local new, override = SelectUpgrade( self.ChipName, mode )

	if self.PickupPriority then
		self.Dropped = CurTime()
		self.PickupPriorityTime = CurTime() + 10
	end

	hook.Run( "SLCChipUpgraded", self.ChipName, new, ply, self.PickupPriority )

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
	end
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Int", "ChipID" )
	self:NetworkVar( "Int", "AccessOverride" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	if CLIENT then
		self:UpdateDescription()
	end
end

function SWEP:Equip()
	self:CallBaseClass( "Equip" )

	if CLIENT then
		self:UpdateDescription()
	end
end

function SWEP:OnDrop()
	self:CallBaseClass( "OnDrop" )

	self.PreventDropping = false
end

function SWEP:StoreWeapon( data )
	data.chip_id = self:GetChipID()
	data.override = self:GetAccessOverride()
end

function SWEP:RestoreWeapon( data )
	self:SetChipData( GetChipByID( data.chip_id ), data.override )
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

	function SWEP:BuildDescription( desc )
		local chip = GetChipByID( self:GetChipID() )
		if !chip then return end

		desc:Print( self.Lang.clearance2 ):Print( chip.level, Color( 200, 200, 30 ) )

		local cd = GetChipDescription( chip.name, override or self:GetAccessOverride(), self.Lang.ACCESS, false )
		if cd then
			desc:Print( "\n" ):Print( self.Lang.hasaccess ):Print( "\n\t" ):Print( cd, Color( 30, 200, 30 ) )
		end
	end
end

function SWEP:DebugInfo( indent )
	local t = string.rep( "\t", indent or 1 )
	print( t.."Basic Info ->", self:GetClass(), self.PrintName )
	print( t.."Access ->", self:GetChipID(), self:GetAccessOverride() )
end