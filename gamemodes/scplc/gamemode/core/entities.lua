local ent = FindMetaTable( "Entity" )

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

function ent:GetNameEx( pname_limit, blacklist, rep )
	if !IsValid( self ) then return end
	local name = self.GetName and self:GetName() or self:GetClass()

	if self:IsPlayer() and isnumber( pname_limit ) and string.len( name ) > pname_limit then
		name = string.sub( name, 1, pname_limit )

		if blacklist then
			name = string.gsub( name, blacklist, rep or "?" )
		end
	end

	return name
end