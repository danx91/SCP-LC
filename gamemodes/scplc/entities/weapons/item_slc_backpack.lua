SWEP.Base 		= "item_slc_base"
SWEP.Language 	= "BACKPACK"

SWEP.ShouldDrawViewModel 	= false
SWEP.ShouldDrawWorldModel 	= false

SWEP.Droppable = true
SWEP.Selectable = false
SWEP.Toggleable = true


//lua_run bp = BACKPACK.Create("small") bp:SetPos(Entity(1):GetEyeTrace().HitPos + Vector(0,0,50)) bp.Dropped = 0
//lua_run PrintTable(Entity(1):GetProperty("inventory"))
//lua_run_cl PrintTable(INVENTORY)

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/backpack.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Backpack", "Int" )
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self:InitializeLanguage()

	local bp = self:GetBackpack()
	//print( "GOTBP", bp )
	if bp <= 0 then return 0 end

	local data = BACKPACK.GetData( bp )
	if !data then return 0 end

	self.WorldModel = data.model

	if CLIENT then
		self:UpdateDescription()
	end
end

SWEP.NextModelCheck = 0
function SWEP:Think()

end

function SWEP:OnSelect()
	local owner = self:GetOwner()
	if owner:GetProperty( "inventory_transition", 0 ) > CurTime() then
		if CLIENT and IsFirstTimePredicted() then
			surface.PlaySound( "common/wpn_denyselect.wav" )
		end

		return
	end

	
	local new = !self:GetEnabled()
	self:SetEnabled( new )
	self.PreventDropping = new

	if SERVER then
		if new then
			owner:DisableControls( "slc_backpack" )
		else
			owner:StopDisableControls( "slc_backpack" )
		end
	else
		RunGUISkinFunction( "eq", new and "open_backpack" or "close_backpack" )

		/*if !new then
			self:ForceClose()
		end*/
	end
end

function SWEP:Equip()
	if CLIENT then
		self:UpdateDescription()
		return
	end

	if !self.StoredItems then return end

	local owner = self:GetOwner()
	local inventory = owner:GetProperty( "inventory", {} )

	local bp_index = 7
	for i, v in ipairs( self.StoredItems ) do
		local wep = owner:RestoreWeapon( v )
		inventory[bp_index] = wep
		bp_index = bp_index + 1
	end

	self.StoredItems = {}

	owner:UpdateEQ()
	owner:SyncEQ()
end

function SWEP:CanDrop()
	local owner = self:GetOwner()
	local inventory = owner:GetProperty( "inventory", {} )

	for i = 7, owner:GetInventorySize() do
		if IsValid( inventory[i] ) and inventory[i].Droppable == false then return false end
	end

	return true
end

function SWEP:SLCPreDrop()
	self:StoreBackpack()
end

function SWEP:OnDrop()
	self.PreventDropping = false
end

function SWEP:StoreBackpack()
	local owner = self:GetOwner()
	local inventory = owner:GetProperty( "inventory", {} )
	self.StoredItems = {}

	for i = 7, owner:GetInventorySize() do
		if !IsValid( inventory[i] ) or inventory[i].Droppable == false then continue end
		table.insert( self.StoredItems, owner:StoreWeapon( inventory[i]:GetClass() ) )
	end

	owner:UpdateEQ()
end

function SWEP:StoreWeapon( data )
	data.Backpack = self:GetBackpack()
	data.StoredItems = self.StoredItems
end

function SWEP:RestoreWeapon( data )
	self:SetBackpack( data.Backpack )
	self.StoredItems = data.StoredItems
end

function SWEP:GetSize()
	local bp = self:GetBackpack()
	if bp <= 0 then return 0 end

	local data = BACKPACK.GetData( bp )
	if !data then return 0 end

	return data.size
end

function SWEP:UpdateDescription( id, override )
	local bp = self:GetBackpack()
	if bp <= 0 then return 0 end

	local data = BACKPACK.GetData( bp )
	if !data then return 0 end

	self.PrintName = self.Lang.NAMES[data.name] or data.name
end

function SWEP:BuildDescription( desc )
	local bp = self:GetBackpack()
	if bp <= 0 then return 0 end

	local data = BACKPACK.GetData( bp )
	if !data then return 0 end

	desc:Print( self.Lang.size ):Print( data.size, Color( 200, 200, 30 ) )
	desc:Print( "\n" ):Print( string.rep( "-", 32 ) ):Print( "\n" )
	desc:Print( self.Lang.info )
end

function SWEP:ForceClose()
	if !IsFirstTimePredicted() then return end

	timer.Simple( 0.25, function()
		if !self:GetEnabled() then return end

		input.SelectWeapon( self )
		self:ForceClose()
	end )
end

function SWEP:DebugInfo( indent )
	local t = string.rep( "\t", indent or 1 )
	print( t.."Backpack ->", self:GetBackpack() )
	print( t.."Enabled ->", self:GetEnabled() )
end