hook.Add( "SLCRound", "SLCSetupKarma", function()
	if CVAR.slc_scp_karma:GetInt() != 1 then return end

	for i, v in ipairs( player.GetAll() ) do
		--TODO
	end
end )