SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "FUSE"

SWEP.WorldModel		= "models/slusher/fuzebox/fuze.mdl"

if CLIENT then
	SWEP.WepSelectIcon 	= Material( "slc/items/fuse.png" )
	SWEP.SelectColor 	= Color( 255, 210, 0, 255 )
end

SWEP.Selectable = false
SWEP.Group 		= "fuse"

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Int", "Rating" )

	self:NetworkVarNotify( "Rating", function( ent, name, old, new )
		if CLIENT then
			self.PrintName = self.OrigName.." "..new.."A"
		end
	end )
end

function SWEP:Initialize()
	self:CallBaseClass( "Initialize" )

	if CLIENT then
		self.OrigName = self.PrintName
		self.PrintName = self.OrigName.." "..self:GetRating().."A"
	end
end

function SWEP:Equip()
	if CLIENT then
		self.PrintName = self.OrigName.." "..self:GetRating().."A"
	end
end

local upgrade_mul = {
	[0] = 0,
	0.5,
	1,
	2,
	3
}

function SWEP:StoreWeapon( data )
	data.rating = self:GetRating()
end

function SWEP:RestoreWeapon( data )
	self:SetRating( data.rating )
end

function SWEP:HandleUpgrade( mode, exit, ply )
	self:SetPos( exit )
	self:SetRating( math.Clamp( math.floor( self:GetRating() * upgrade_mul[mode] ), 1, 5000 ) )

	if self.PickupPriority then
		self.Dropped = CurTime()
		self.PickupPriorityTime = CurTime() + 10
	end
end