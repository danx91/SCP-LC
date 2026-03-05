local fake_obj = {}
setmetatable( fake_obj, {
	__index = function() return fake_obj end,
	__call = function() return fake_obj end,
} )

--[[-------------------------------------------------------------------------
Fake round stats for shared compatibility
---------------------------------------------------------------------------]]
function RoundStat() return fake_obj end
function RoundStatGroup() return fake_obj end
function GetRoundStat() return fake_obj end
function GetRoundStatGroup() return fake_obj end