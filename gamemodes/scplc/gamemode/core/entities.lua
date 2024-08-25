local ENTITY = FindMetaTable( "Entity" )

--[[-------------------------------------------------------------------------
CallBaseClass
---------------------------------------------------------------------------]]
local disablecall = false
function ENTITY:CallBaseClass( func, bc, ... )
	if disablecall then return end

	if !bc then
		bc = self.BaseClass
	end

	if bc.BaseClass and bc.ClassName != bc.Base and ( !self.DeepBase or bc.ClassName != self.DeepBase ) then
		self:CallBaseClass( func, bc.BaseClass, ... )
	end

	local val = bc[func]
	if isfunction( val ) then
		disablecall = true

		local ok, err = pcall( val, self, ... )
		if !ok then
			print( "Error in CallBaseClass!" )
			print( err )
		end

		disablecall = false
	end
end

--Java-like super that just binds to CallBaseClass
function ENTITY:Super( ... )
	self:CallBaseClass( ... )
end

--[[-------------------------------------------------------------------------
IsDerived
---------------------------------------------------------------------------]]
function ENTITY:IsDerived( class )
	local base = self
	
	repeat
		if base.ClassName == class then return true end
		if base == base.BaseClass then return false end
		
		base = base.BaseClass
	until !base

	return false
end

--[[-------------------------------------------------------------------------
ResetBones
---------------------------------------------------------------------------]]
local zero_angle = Angle( 0, 0, 0 )
local zero_vector = Vector( 0, 0, 0 )
function ENTITY:ResetBones()
	if IsValid( self ) then
		for i = 0, self:GetBoneCount() do
			self:ManipulateBoneAngles( i, zero_angle )
			self:ManipulateBonePosition( i, zero_vector )
		end
	end
end

--[[-------------------------------------------------------------------------
TakeDamageInfo
---------------------------------------------------------------------------]]
/*if SERVER then
_EntityTakeDamageInfo = _EntityTakeDamageInfo or ENTITY.TakeDamageInfo
	function ENTITY:TakeDamageInfo( info )
		local dmgtype = info:GetDamageType()
		local prevent_forces = bit.band( dmgtype, DMG_PREVENT_PHYSICS_FORCE ) == DMG_PREVENT_PHYSICS_FORCE
		local velocity

		if prevent_forces then
			info:SetDamageType( bit.band( dmgtype, bit.bnot( DMG_PREVENT_PHYSICS_FORCE ) ) )
			velocity = self:GetVelocity()
		end

		_EntityTakeDamageInfo( self, info )

		if prevent_forces then
			if self:IsPlayer() then
				//self:SetVelocity( -self:GetVelocity() + velocity )
				self:SetVelocity( -self:GetVelocity() )
				//print( self:GetVelocity() )
			else
				self:SetPhysVelocity( velocity )
			end
		end
	end
end*/

--[[-------------------------------------------------------------------------
SetPhysVelocity
---------------------------------------------------------------------------]]
function ENTITY:SetPhysVelocity( velocity )
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:SetVelocity( velocity )
	else
		self:SetVelocity( velocity )
	end
end

--[[-------------------------------------------------------------------------
AddNetworkVar
---------------------------------------------------------------------------]]
function ENTITY:AddNetworkVar( name, type )
	if !self._NVTable then
		self._NVTable = {
			Int = { 0, 32 },
			Float = { 0, 32 },
			Bool = { 0, 32 },
			String = { 0, 4 },
			Vector = { 0, 32 },
			Angle = { 0, 32 },
			Entity = { 0, 32 }
		}
	end

	local tab = self._NVTable[type]
	assert( tab, "Unknown NetworkVar type: "..tostring( type ) )
	assert( tab[1] < tab[2], "You have already hit NetworkVar limit for type '"..tostring( type ).."' on this entity! ["..tostring( self ).."]" )

	self:NetworkVar( type, tab[1], name )
	tab[1] = tab[1] + 1
end

--[[-------------------------------------------------------------------------
TestVisibility
---------------------------------------------------------------------------]]
local visibility_trace = {}
visibility_trace.output = visibility_trace

local default_mask = bit.bor( CONTENTS_MOVEABLE, CONTENTS_OPAQUE, CONTENTS_SOLID, CONTENTS_BLOCKLOS, CONTENTS_MONSTER )
function ENTITY:TestVisibility( ply, mask, headonly, vlimit, hlimit, z_offset )
	if !IsValid( ply ) then return end
	if SERVER and !ply:TestPVS( self ) then return false end

	local dist = self:GetPos():DistToSqr( ply:GetPos() )
	local sight = ply:GetSightLimit()

	if sight != -1 then
		if dist > sight * sight then
			return false
		end
	end

	local obb_bot, obb_top = self:GetModelBounds()
	local obb_mid = ( obb_bot + obb_top ) * 0.5

	obb_bot.x = obb_mid.x
	obb_bot.y = obb_mid.y
	obb_bot.z = obb_bot.z + 10

	obb_top.x = obb_mid.x
	obb_top.y = obb_mid.y
	obb_top.z = obb_top.z - 10

	local top, mid, bot = self:LocalToWorld( obb_top ), self:LocalToWorld( obb_mid ), self:LocalToWorld( obb_bot )

	local eyepos = ply:EyePos()
	local eyeang = ply:EyeAngles()

	local mid_z = mid:Copy()
	mid_z.z = mid_z.z + ( z_offset or 17.5 )

	local line = ( ( headonly and top or mid_z ) - eyepos ):GetNormalized()
	if vlimit != false and eyeang:Forward():Dot( line ) < 0 then return false end

	local ang = line:Angle()
	local diff = ang - eyeang
	diff:Normalize()

	if vlimit != false and ( math.abs( diff.y ) > ( hlimit or 53 ) or math.abs( diff.p ) > ( vlimit or 43 ) ) then return false end

	visibility_trace.start = eyepos
	visibility_trace.mask = mask or default_mask
	visibility_trace.filter = { self, ply }

	visibility_trace.endpos = top
	util.TraceLine( visibility_trace )

	if !visibility_trace.Hit then return true end
	if headonly then return false end

	visibility_trace.endpos = mid
	util.TraceLine( visibility_trace )

	if !visibility_trace.Hit then return true end

	visibility_trace.endpos = bot
	util.TraceLine( visibility_trace )

	return !visibility_trace.Hit
end

--[[-------------------------------------------------------------------------
GetNameEx
---------------------------------------------------------------------------]]
function ENTITY:GetNameEx( pname_limit, blacklist, rep )
	if !IsValid( self ) then return end
	local name = self.GetName and self:GetName() or self:GetClass()

	if self:IsPlayer() then
		if isnumber( pname_limit ) and string.len( name ) > pname_limit then
			name = string.sub( name, 1, pname_limit )
		end

		if blacklist then
			name = string.gsub( name, blacklist, rep or "?" )
		end
	end

	return name
end

--[[-------------------------------------------------------------------------
DT Registry
---------------------------------------------------------------------------]]
/*ENTITY.OldInstallDataTable = ENTITY.OldInstallDataTable or ENTITY.InstallDataTable
function ENTITY:InstallDataTable()
	self:OldInstallDataTable()

	self.OldNetworkVar = self.NetworkVar
	function self:NetworkVar( type, slot, name, ex )
		if !self.DTRegistry then
			self.DTRegistry = {}
		end

		table.insert( self.DTRegistry, name )

		self:OldNetworkVar( type, slot, name, ex )
	end
end*/

--[[-------------------------------------------------------------------------
FullSwapModels
---------------------------------------------------------------------------]]
function ENTITY:FullSwapModels( other )
	local other_data = {
		model = other:GetModel(),
		color = other:GetColor(),
		material = other:GetMaterial(),
		skin = other:GetSkin(),
		bodygroups = {},
		materials = {},
	}

	for i = 0, other:GetNumBodyGroups() - 1 do
		other_data.bodygroups[i] = other:GetBodygroup( i )
	end

	for i = 0, #other:GetMaterials() - 1 do
		other_data.materials[i] = other:GetSubMaterial( i )
	end

	other:SetModel( self:GetModel() )
	other:SetColor( self:GetColor() )
	other:SetMaterial( self:GetMaterial() )
	other:SetSkin( self:GetSkin() )

	for i = 0, other:GetNumBodyGroups() - 1 do
		other:SetBodygroup( i, self:GetBodygroup( i ) )
	end

	for i = 0, #other:GetMaterials() - 1 do
		other:SetSubMaterial( i, self:GetSubMaterial( i ) )
	end

	self:SetModel( other_data.model )
	self:SetColor( other_data.color )
	self:SetMaterial( other_data.material )
	self:SetSkin( other_data.skin )

	for i = 0, self:GetNumBodyGroups() - 1 do
		self:SetBodygroup( i, other_data.bodygroups[i] )
	end

	for i = 0, #self:GetMaterials() - 1 do
		self:SetSubMaterial( i, other_data.materials[i] )
	end
end