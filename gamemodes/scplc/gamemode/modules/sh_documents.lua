SLC_DOCUMENTS = {}

function SLCAddDocument( name, mat_path, reward, merge )
	local mat

	if mat_path then
		mat = Material( mat_path )

		if mat:IsError() then
			mat = nil
		end
	end

	local tbl = {
		Base = "item_slc_document",
		Selectable = !!mat_path,
		Name = name,
		Reward = reward,
		Page = mat,
	}

	if merge then
		table.Merge( tbl, merge )
	end

	local class = "item_slc_document_"..name
	local id = table.insert( SLC_DOCUMENTS, class )
	tbl.ID = id

	weapons.Register( tbl, class )
end

local function document_escape( ply )
	local num, total = 0, 0

	for k, v in pairs( ply:GetWeapons() ) do
		if !v.IS_DOCUMENT then continue end

		num = num + 1

		if v.Reward and v.Reward > 0 then
			total = total + v.Reward
		end
	end

	if total > 0 then
		PlayerMessage( string.format( "docs$%i,%i", total, num ), ply )
		ply:AddFrags( total )
	end
end

hook.Add( "SLCPlayerEscaped", "SLCDocuments", document_escape )
hook.Add( "SLCPlayerEscorted", "SLCDocuments", document_escape )

--[[-------------------------------------------------------------------------
Base documents
---------------------------------------------------------------------------]]
/*local names = {
	"",
}*/

for i = 1, 47 do
	local name = string.format( "doc%02i", i )
	SLCAddDocument( name, "slc/documents/"..name..".jpg" )
end

if SERVER then
	SLC_ROUND_DOCUMENTS = {}

	hook.Add( "SLCRoundCleanup", "SLCDocuments", function()
		SLC_ROUND_DOCUMENTS = table.Copy( SLC_DOCUMENTS )
	end )

	hook.Add( "SLCFullyLoaded", "SLCDocuments", function()
		ItemSpawnFunction( "document", function()
			local class

			if !SLC_ROUND_DOCUMENTS or #SLC_ROUND_DOCUMENTS == 0 then
				class = SLC_DOCUMENTS[math.random( #SLC_DOCUMENTS )]
			else
				class = table.remove( SLC_ROUND_DOCUMENTS, math.random( #SLC_ROUND_DOCUMENTS ) )
			end

			if class then
				return ents.Create( class )
			end
		end )
	end )
end