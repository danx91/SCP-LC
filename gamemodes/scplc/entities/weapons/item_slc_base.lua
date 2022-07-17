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

SWEP.WorldModel 			= ""
SWEP.ViewModel 				= ""

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

SWEP.OwnerChangedTime 		= 0

function SWEP:SetupDataTables()
	if self.Toggleable then self:AddNetworkVar( "Enabled", "Bool" ) end
	if self.HasBattery then self:AddNetworkVar( "Battery", "Int" ) self:SetBattery( 100 ) end
	if self.Stacks > 1 then self:AddNetworkVar( "Count", "Int" ) self:SetCount( 1 ) end

	/*self:AddNetworkVar( "DebugOwner", "Entity" )
	if CLIENT then
		self:NetworkVarNotify( "DebugOwner", self.DebugOwnerChanged )
	end*/
end

/*function SWEP:DebugOwnerChanged( name, old, new )
	if CLIENT then
		if new != old then
			if IsValid( new ) and new:EntIndex() != 0 then
				self:Equip()
			else
				self:OnDrop()
			end
		end
	end
end*/

function SWEP:InitializeLanguage()
	if CLIENT and self.Language then
		self.Lang = LANG.WEAPONS[self.Language] or {}

		if self.Lang then
			self.PrintName = self.Lang.name or self.PrintName
			self.PickupName = self.Lang.pickupname
			self.ShowName = self.Lang.showname
			self.Author	= self.Lang.author
			self.Info = self.Lang.info
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:OnSelect()
	
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
end

function SWEP:Holster( wep )
	return true
end

function SWEP:OwnerChanged()
	if CLIENT then
		if IsValid( self:GetOwner() ) then
			self:Equip()
		else
			self:OnDrop()
		end
	end
end

function SWEP:Equip()
	/*if SERVER then
		self:SetDebugOwner( self:GetOwner() )
	end*/
end

function SWEP:OnDrop()
	/*if SERVER then
		self:SetDebugOwner( Entity( 0 ) )
	end*/
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
	if SERVER and self.HasBattery then
		if !self.Toggleable or self:GetEnabled() then
			if self.NBatteryTake < CurTime() then
				self.NBatteryTake = CurTime() + self.BatteryUsage

				local battery = self:GetBattery()

				if battery > 0 then
					self:SetBattery( battery - 1 )
				end

				if battery <= 0 and self.Toggleable then
					self:SetEnabled( false )
				end
			end
		end
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
	if self.Stacks <= 1 then return end

	local count = self:GetCount()
	if count > 0 then
		self:SetCount( count - 1 )
	end
end

function SWEP:EquipAmmo( ply )
	local wep = ply:GetWeapon( self:GetClass() )
	if IsValid( wep ) and wep.Stack then
		wep:Stack()
	end
end

function SWEP:DragAndDrop( wep )
	if self.HasBattery and wep:GetClass() == "item_slc_battery" then
		if SERVER then
			if self:GetBattery() < 100 then
				self:SetBattery( 100 )

				if wep:GetCount() <= 1 then
					wep:Remove()
				else
					wep:RemoveStack()
				end
			end
		end

		return true
	end

	return false
end

function SWEP:StoreWeapon( data )
	if self.Stacks > 1 then
		data.amount = self:GetCount()
	end

	if self.HasBattery then
		data.battery = self:GetBattery()
	end
end

function SWEP:RestoreWeapon( data )
	/*if data.stacks then
		self:SetCount( data.stacks )
	end*/

	if data.battery then
		self:SetBattery( data.battery )
	end
end

function SWEP:PreDrawViewModel( vm )
	//print( vm, vm:HasBoneManipulations() )
end