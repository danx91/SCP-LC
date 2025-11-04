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
function ENTITY:ResetBones( num )
	if !IsValid( self ) then return end

	local count = self:GetBoneCount()
	if num and num > count then
		count = num
	end

	for i = 0, count do
		self:ManipulateBoneAngles( i, zero_angle )
		self:ManipulateBonePosition( i, zero_vector )
	end
end

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
AddNetworkVar - Deprecated!
GMod added it's own solution to use auto index on network vars. To not break compatibility, I'll just leave AddNetworkVar as binding to NetworkVar
---------------------------------------------------------------------------]]
function ENTITY:AddNetworkVar( name, type )
	self:NetworkVar( type, name )
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

--[[-------------------------------------------------------------------------
Recreate CBaseEntity::ImpactTrace
https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/game/shared/baseentity_shared.cpp#L665-L695
---------------------------------------------------------------------------]]
function ENTITY:DispatchImpactTrace( tr, dmg )
	local data = EffectData()
	data:SetOrigin( tr.HitPos )
	data:SetStart( tr.StartPos )
	data:SetSurfaceProp( tr.SurfaceProps )
	data:SetDamageType( dmg )
	data:SetHitBox( tr.HitBox )

	util.Effect( "Impact", data, false, true )
end