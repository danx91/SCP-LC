local ent = FindMetaTable( "Entity" )

--[[-------------------------------------------------------------------------
CallBaseClass
---------------------------------------------------------------------------]]
local disablecall = false
function ent:CallBaseClass( func, bc, ... )
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

--[[-------------------------------------------------------------------------
ResetBones
---------------------------------------------------------------------------]]
local zero_angle = Angle( 0, 0, 0 )
local zero_vector = Vector( 0, 0, 0 )
function ent:ResetBones()
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
if SERVER then
_EntityTakeDamageInfo = _EntityTakeDamageInfo or ent.TakeDamageInfo --TODO
	function ent:TakeDamageInfo( info )
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
end

--[[-------------------------------------------------------------------------
SetPhysVelocity
---------------------------------------------------------------------------]]
function ent:SetPhysVelocity( velocity )
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
function ent:AddNetworkVar( name, type )
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
function ent:TestVisibility( ply, mask, headonly )
	if !IsValid( ply ) then return end
	if !ply:TestPVS( self ) then return false end

	mask = mask or MASK_BLOCKLOS_AND_NPCS

	local obb_bot, obb_top = self:GetModelBounds()
	local obb_mid = ( obb_bot + obb_top ) * 0.5

	obb_bot.x = obb_mid.x
	obb_bot.y = obb_mid.y
	obb_bot.z = obb_bot.z + 10

	obb_top.x = obb_mid.x
	obb_top.y = obb_mid.y
	obb_top.z = obb_top.z - 10

	local top, mid, bot = self:LocalToWorld( obb_top ), self:LocalToWorld( obb_mid ), self:LocalToWorld( obb_bot )

	local dist = self:GetPos():DistToSqr( ply:GetPos() )
	local sight = ply:GetSightLimit()

	if sight != -1 then
		if dist > sight * sight then
			return false
		end
	end

	local eyepos = ply:EyePos()
	local eyevec = ply:EyeAngles():Forward()

	local mid_z = mid:Copy()
	mid_z.z = mid_z.z + 17.5

	local line = ( mid_z - eyepos ):GetNormalized()
	local angle = math.acos( eyevec:Dot( line ) )

	if angle <= 0.8 then
		local trace_top = util.TraceLine{
			start = eyepos,
			endpos = top,
			filter = { self, ply },
			mask = mask
		}

		if !trace_top.Hit then return true end
		if headonly then return false end

		local trace_mid = util.TraceLine{
			start = eyepos,
			endpos = mid,
			filter = { self, ply },
			mask = mask
		}

		if !trace_mid.Hit then return true end

		local trace_bot = util.TraceLine{
			start = eyepos,
			endpos = bot,
			filter = { self, ply },
			mask = mask
		}

		if !trace_bot.Hit then return true end
	end

	return false
end

function ent:GetNameEx( pname_limit, blacklist, rep )
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

ent.OldInstallDataTable = ent.OldInstallDataTable or ent.InstallDataTable
function ent:InstallDataTable()
	self:OldInstallDataTable()

	self.OldNetworkVar = self.NetworkVar
	function self:NetworkVar( type, slot, name, ex )
		if !self.DTRegistry then
			self.DTRegistry = {}
		end

		table.insert( self.DTRegistry, name )

		self:OldNetworkVar( type, slot, name, ex )
	end
end