SWEP.DeepBase 				= "item_slc_base"

SWEP.PrintName 				= "base_weapon"
SWEP.Author 				= "danx91"
//SWEP.Language 			= nil

SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.ViewModelFOV			= 60
SWEP.HoldType 				= "normal"
SWEP.DrawCrosshair 			= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

SWEP.WorldModel 			= "models/hunter/blocks/cube025x025x025.mdl"
SWEP.ViewModel 				= "models/hunter/blocks/cube025x025x025.mdl"

SWEP.SCP 					= false
SWEP.Droppable				= true

SWEP.ShouldDrawViewModel 	= true
SWEP.ShouldDrawWorldModel 	= true

//SWEP.Lang 					= {}

SWEP.Stacks 				= 0

SWEP.Toggleable 			= false
SWEP.Selectable 			= true
SWEP.PreventDropping 		= false
SWEP.EnableHolsterThink 	= false
SWEP.HasBattery 			= false
SWEP.HolsterBatteryUsage 	= false
SWEP.BatteryUsage 			= 2.5
SWEP.NBatteryTake 			= 0
SWEP.Durability				= 0

SWEP.OwnerChangedTime 		= 0

function SWEP:SetupDataTables()
	if self.Toggleable then self:AddNetworkVar( "Enabled", "Bool" ) end
	if self.HasBattery then self:AddNetworkVar( "Battery", "Int" ) self:SetBattery( 100 ) end
	if self.Stacks > 1 then self:AddNetworkVar( "Count", "Int" ) self:SetCount( 1 ) end
	if self.Durability > 0 then self:AddNetworkVar( "Durability", "Int" ) self:SetDurability( self.Durability ) end
end

function SWEP:InitializeLanguage()
	if SERVER or !self.Language then return end

	self.Lang = LANG.WEAPONS[self.Language] or {}
	if !self.Lang then return end

	self.PrintName = self.Lang.name or self.PrintName
	self.PickupName = self.Lang.pickupname
	self.ShowName = self.Lang.showname
	self.Author	= self.Lang.author
	self.Info = self.Lang.info
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:OnSelect()
	
end

function SWEP:CanEnable()
	if !self.UseGroup then return true end

	local owner = self:GetOwner()
	if !IsValid( owner ) then return false end

	for i, v in ipairs( owner:GetWeapons() ) do
		if v != self and v.UseGroup == self.UseGroup and v.Toggleable and v:GetEnabled() then return false end
	end

	return true
end

function SWEP:Deploy()
	local owner = self:GetOwner()
	if IsValid( owner ) then
		owner:DrawViewModel( self.ShouldDrawViewModel )

		if SERVER then
			owner:DrawWorldModel( self.ShouldDrawWorldModel )
		end

		self:ResetViewModelBones()
	end

	return true
end

function SWEP:Holster( wep )
	return true
end

function SWEP:OwnerChanged()
	if SERVER then return end

	if IsValid( self:GetOwner() ) then
		self:Equip()
	else
		self:OnDrop()
	end
end

function SWEP:Equip()
	
end

function SWEP:OnDrop()
	
end

function SWEP:HolsterThink()
	if self.HolsterBatteryUsage then
		self:BatteryTick()
	end
end

function SWEP:Think()
	self:BatteryTick()
end

function SWEP:BatteryTick()
	if CLIENT or !self.HasBattery or self.BatteryUsage <= 0 or ( self.Toggleable and !self:GetEnabled() ) then return end
	if self.NBatteryTake > CurTime() then return end

	self.NBatteryTake = CurTime() + self.BatteryUsage

	local battery = self:GetBattery()
	if battery > 0 then
		self:SetBattery( battery - 1 )
	end

	if battery <= 0 and self.Toggleable then
		self:SetEnabled( false )
		self:BatteryDepleted()
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CanStack()
	if self.Stacks <= 1 then return false end
	return self:GetCount() < self.Stacks
end

function SWEP:Stack()
	if self.Stacks <= 1 then return end

	local count = self:GetCount()
	if count < self.Stacks then
		self:SetCount( count + 1 )
	end
end

function SWEP:RemoveStack()
	if self.Stacks <= 1 then return false end

	local count = self:GetCount()
	if count > 0 then
		self:SetCount( count - 1 )
		return count > 1
	end

	return false
end

function SWEP:BatteryDepleted()

end

function SWEP:BatteryInserted()

end

function SWEP:EquipAmmo( ply )
	local wep = ply:GetWeapon( self:GetClass() )
	if IsValid( wep ) and wep.Stack then
		wep:Stack()
	end
end

function SWEP:DragAndDrop( wep, test )
	if !self.HasBattery or !wep:IsDerived( "item_slc_battery" ) then return false end
	
	if self:GetBattery() >= ( wep.Power or 100 ) then return false end
	if !SERVER or test then return true end

	self:SetBattery( wep.Power or 100 )
	self:BatteryInserted()
	
	if wep:GetCount() <= 1 then
		wep:Remove()
	else
		wep:RemoveStack()
	end

	return true
end

function SWEP:Damage( dmg )
	if self.Durability <= 0 then return end
	dmg = dmg or 1

	local dur = math.Clamp( self:GetDurability() - dmg, 0, self.Durability )
	self:SetDurability( dur )

	if dur <= 0 and self.Toggleable then
		self:SetEnabled( false )
	end
end

function SWEP:StoreWeapon( data )
	if self.Stacks > 1 then
		data.amount = self:GetCount()
		data.stacks = self:GetCount()
	end

	if self.HasBattery then
		data.battery = self:GetBattery()
	end
end

function SWEP:RestoreWeapon( data )
	if data.stacks then
		self:SetCount( data.stacks )
	end

	if data.battery then
		self:SetBattery( data.battery )
	end
end

function SWEP:DrawWorldModel()
	if !IsValid( self:GetOwner() ) or self.ShouldDrawWorldModel then
		self:DrawModel()
	end
end