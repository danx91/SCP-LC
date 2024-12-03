--[[-------------------------------------------------------------------------
Globals
---------------------------------------------------------------------------]]
USE_LEGACY_ITEMS_SPAWN = false

--[[-------------------------------------------------------------------------
Spawn SCPs
---------------------------------------------------------------------------]]
SPAWN_SCP049 = Vector( 4718.4541015625, -2004.3891601563, 41.03125 )
SPAWN_SCP058 = Vector( 3724.503662, -1300.921753, -105.968750 )
SPAWN_SCP066 = Vector( 86.938972, 3897.577393, -64.033432 )
SPAWN_SCP096 = Vector( 4750.299316, 3653.488525, 25.031250 )
SPAWN_SCP106 = Vector( 2216.1745605469, 4706.0395507813, -422.96875 )
SPAWN_SCP173 = Vector( 1170.00, 1646.00, 153.00 )
SPAWN_SCP457 = Vector( 6209.917480, -304.609192, 64.031250 )
SPAWN_SCP682 = Vector( 2053.1604003906, 3009.12109375, -358.96875 )
SPAWN_SCP8602 = Vector( 7284.303711, 5608.904785, -1041.298706 )
SPAWN_SCP939 = Vector( 1141.1956787109, -782.48986816406, -742.96875 )
SPAWN_SCP966 = Vector( 4385.948730, 2360.432861, 50.031250 )
SPAWN_SCP24273 = Vector( 4016.164551, 3882.115967, 1.00 )
SPAWN_SCP3199 = Vector( 2498.00, 1534.00, 1.00 )

SPAWN_SCP023 = {
	Vector( 4140.746094, -194.712585, 25.031250 ),
	Vector( 4166.099609, 1101.125732, 25.031250 ),
	Vector( 2979.323486, 2380.352051, 25.527580 ),
	Vector( 834.628296, 3650.139893, 25.031250 ),
	Vector( -454.112244, 3658.908936, 25.031250 ),
}

OUTSIDE_966 = Vector( 4165.00, 2375.00, 50.00 )

EGGS_3199 = {
	Vector( 610.00, 1891.00, 129.00 ),
	Vector( 1728.00, -2054.00, 1.00 ),
	Vector( 2461.00, -1762.00, 1.00 ),
	Vector( 1474.00, -364.00, 1.00 ),
	Vector( 1821.00, 1030.00, 1.00 ),
	Vector( 1696.00, 490.00, 18.00 ),
	Vector( 2961.00, 316.00, 1.00 ),
	Vector( 2579.00, -414.00, 1.00 ),
	Vector( 474.00, -1314.00, -127.00 ),
	Vector( -803.00, -731.00, 1.00 ),

	Vector( 3928.00, -1214.00, -127.00 ),
	Vector( 5546.00, -85.00, 2.00 ),
	Vector( 4511.00, 377.00, 1.00 ),
	Vector( 4730.00, 1018.00, 1.00 ),
	Vector( 4523.00, 3152.00, -127.00 ),
	Vector( 4062.00, 2302.00, 1.00 ),
	Vector( 4087.00, 3707.00, 1.00 ),
	Vector( 3233.00, 3592.00, 1.00 ),
	Vector( 2458.00, 2600.00, 1.00 ),
	Vector( 2528.00, 1894.00, 1.00 ),

	Vector( 1185.00, 1957.00, 1.00 ),
	Vector( 1042.00, 2962.00, 1.00 ),
	Vector( 890.00, 4585.00, 1.00 ),
	Vector( 114.00, 2210.00, 1.00 ),
	Vector( -566.00, 3297.00, 1.00 ),
	Vector( -97.00, 3102.00, -127.00 ),
	Vector( -1611.00, 2469.00, -127.00 ),
	Vector( -2719.00, 3066.00, 1.00 ),
	Vector( -1023.00, 3735.00, -63.00 ),
	Vector( 1285.00, 3883.00, 1.00 ),
}

--[[-------------------------------------------------------------------------
Player spawns
---------------------------------------------------------------------------]]
SPAWN_CLASSD = {
	Vector( -711.00, 1991.00, 139.00 ),
	Vector( -698.00, 1587.00, 139.00 ),
	Vector( -831.00, 1583.00, 139.00 ),
	Vector( -833.00, 2004.00, 139.00 ),
	Vector( -952.00, 1585.00, 139.00 ),
	Vector( -966.00, 1994.00, 139.00 ),
	Vector( -1083.00, 1590.00, 139.00 ),
	Vector( -1091.00, 1996.00, 139.00 ),
	Vector( -1608.00, 1984.00, 139.00 ),
	Vector( -1592.00, 1601.00, 139.00 ),
	Vector( -1734.00, 2000.00, 139.00 ),
	Vector( -1725.00, 1581.00, 139.00 ),
	Vector( -1859.00, 2008.00, 139.00 ),
	Vector( -1852.00, 1577.00, 139.00 ),
	Vector( -702.00, -18.00, 235.00 ),
	Vector( -831.00, -9.00, 235.00 ),
	Vector( -951.00, -22.00, 235.00 ),
	Vector( -1082.00, -11.00, 235.00 ),
	Vector( -1209.00, -17.00, 235.00 ),
	Vector( -1341.00, -13.00, 235.00 ),
	Vector( -1469.00, -18.00, 235.00 ),
	Vector( -1595.00, -10.00, 235.00 ),
	Vector( -1721.00, -12.00, 235.00 ),
	Vector( -714.00, 1807.00, 139.00 ),
	Vector( -954.00, 1801.00, 139.00 ),
	Vector( -1328.00, 1791.00, 139.00 ),
	Vector( -1682.00, 1791.00, 139.00 ),
	Vector( -2123.00, 1788.00, 139.00 ),
	Vector( -2154.00, 187.00, 235.00 ),
	Vector( -1909.00, 187.00, 235.00 ),
	Vector( -1570.00, 187.00, 235.00 ),
	Vector( -1294.00, 189.00, 235.00 ),
	Vector( -1057.00, 197.00, 235.00 ),
	Vector( -724.00, 196.00, 235.00 ),
}

SPAWN_SCIENT = {
	Vector( -307.00, 1600.00, 267.00 ),
	Vector( 110.00, 2001.00, 267.00 ),
	Vector( -458.00, -895.00, 11.00 ),
	Vector( -13.00, -1033.00, -117.00 ),
	Vector( 399.00, -983.00, -117.00 ),
	Vector( 683.00, -1653.00, 11.00 ),
	Vector( 2112.00, -757.00, 11.00 ),
	Vector( 3077.00, -1663.00, 11.00 ),
	Vector( 2564.00, -1459.00, 11.00 ),
	Vector( 833.00, 528.00, 11.00 ),
	Vector( 1712.00, 227.00, 11.00 ),
	Vector( 1847.00, 231.00, 11.00 ),
	Vector( 1769.00, 635.00, 11.00 ),
	Vector( 1443.00, 1085.00, 11.00 ),
	Vector( 1469.00, -285.00, 11.00 ),
	Vector( 1472.00, 473.00, 11.00 ),
	Vector( 2799.00, 446.00, 11.00 ),
	Vector( 2647.00, -395.00, 11.00 ),
	Vector( -212.00, 854.00, 11.00 ),
	Vector( 1475.00, -2372.00, 12.00 ),
}

SPAWN_GUARD = {
	Vector( -2910.00, 3792.00, 257.00 ),
	Vector( -2910.00, 3851.00, 257.00 ),
	Vector( -2910.00, 3978.00, 257.00 ),
	Vector( -2910.00, 4225.00, 257.00 ),
	Vector( -2800.00, 4225.00, 257.00 ),
	Vector( -2800.00, 4179.00, 257.00 ),
	Vector( -2800.00, 4096.00, 257.00 ),
	Vector( -2713.00, 4096.00, 257.00 ),
	Vector( -2650.00, 4086.00, 257.00 ),
	Vector( -2650.00, 4026.00, 257.00 ),
	Vector( -2643.00, 3947.00, 257.00 ),
	Vector( -2730.00, 3930.00, 257.00 ),
	Vector( -2827.00, 3930.00, 257.00 ),
	Vector( -2808.00, 3770.00, 257.00 ),
	Vector( -2747.00, 3770.00, 257.00 ),
	Vector( -2635.00, 3770.00, 257.00 ),
	Vector( -2625.00, 3860.00, 257.00 ),
	Vector( -2530.00, 3820.00, 257.00 ),
	Vector( -2530.00, 3906.00, 257.00 ),
	Vector( -2530.00, 4104.00, 257.00 ),
}

SPAWN_SUPPORT_MTF = {
	Vector( -2800.00, 2000.00, 2307.00 ),
	Vector( -2800.00, 1940.00, 2307.00 ),
	Vector( -2800.00, 1880.00, 2307.00 ),
	Vector( -2800.00, 1820.00, 2307.00 ),
	Vector( -2800.00, 1760.00, 2307.00 ),
	Vector( -2800.00, 1700.00, 2307.00 ),

	Vector( -2965.00, 2000.00, 2307.00 ),
	Vector( -2965.00, 1940.00, 2307.00 ),
	Vector( -2965.00, 1880.00, 2307.00 ),
	Vector( -2965.00, 1820.00, 2307.00 ),
	Vector( -2965.00, 1760.00, 2307.00 ),
	Vector( -2965.00, 1700.00, 2307.00 ),

	Vector( -3130.00, 2000.00, 2315.00 ),
	Vector( -3130.00, 1940.00, 2315.00 ),
	Vector( -3130.00, 1880.00, 2315.00 ),
	Vector( -3130.00, 1820.00, 2315.00 ),
	Vector( -3130.00, 1760.00, 2315.00 ),
	Vector( -3130.00, 1700.00, 2315.00 ),
}

SPAWN_SUPPORT_CI = {
	Vector( 540.00, 7100.00, 2035.00 ),
	Vector( 452.00, 7100.00, 2056.00 ),
	Vector( 360.00, 7100.00, 2082.00 ),
	Vector( 282.00, 7100.00, 2104.00 ),
	Vector( 196.00, 7100.00, 2128.00 ),
	Vector( 88.00, 7100.00, 2158.00 ),

	Vector( 540.00, 6970.00, 2035.00 ),
	Vector( 452.00, 6970.00, 2056.00 ),
	Vector( 360.00, 6970.00, 2082.00 ),
	Vector( 282.00, 6970.00, 2104.00 ),
	Vector( 196.00, 6970.00, 2128.00 ),
	Vector( 88.00, 6970.00, 2158.00 ),

	Vector( 540.00, 6840.00, 2035.00 ),
	Vector( 452.00, 6840.00, 2056.00 ),
	Vector( 360.00, 6840.00, 2082.00 ),
	Vector( 282.00, 6840.00, 2104.00 ),
	Vector( 196.00, 6840.00, 2128.00 ),
	Vector( 88.00, 6840.00, 2158.00 ),
}

SPAWN_SUPPORT_GOC = {
	Vector( -7050.00, 3400.00, 2563.00 ),
	Vector( -7050.00, 3320.00, 2563.00 ),
	Vector( -7050.00, 3240.00, 2563.00 ),
	Vector( -7050.00, 3160.00, 2563.00 ),
	Vector( -7050.00, 3080.00, 2563.00 ),
	Vector( -7050.00, 3000.00, 2563.00 ),
	Vector( -7150.00, 3400.00, 2563.00 ),
	Vector( -7150.00, 3320.00, 2563.00 ),
	Vector( -7150.00, 3240.00, 2563.00 ),
	Vector( -7150.00, 3160.00, 2563.00 ),
	Vector( -7150.00, 3080.00, 2563.00 ),
	Vector( -7150.00, 3000.00, 2563.00 ),
}

--[[-------------------------------------------------------------------------
Spawn rules
---------------------------------------------------------------------------]]
if SERVER then
	local post = {
		Dropped = 0,
	}
	
	--[[-------------------------------------------------------------------------
	SCP Items
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "scp009", {
		item = { item_scp_009 = 10, _none = 10 },
		amount = 1,
		spawns = {
			Vector( 413.00, 2028.00, 267.00 ),
			Vector( 2733.00, -1177.00, -21.00 ),
			Vector( 1828.00, 1361.00, 11.00 ),

			Vector( 2177.00, 1957.00, 11.00 ),
			Vector( 4510.00, 3359.00, 11.00 ),
			Vector( 5355.00, 1057.00, -501.00 ),

			Vector( -799.00, 2595.00, 47.00 ),
			Vector( -1444.00, 3328.00, 47.00 ),
			Vector( 1687.00, 4177.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "scp714", {
		item = "item_scp_714",
		spawns = {
			Vector( 2403.00, 880.00, 42.00 )
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "scp1025", {
		item = "item_scp_1025",
		spawns = {
			Vector( 2400.00, 1295.00, 50.00 )
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "scp500", {
		item = "item_scp_500",
		amount = { 3, 9 },
		spawns = {
			Vector( 229.00, 1389.00, 267.00 ),
			Vector( 303.00, -111.00, 11.00 ),
			Vector( 1827.00, 1227.00, 11.00 ),
			Vector( 2157.00, -2166.00, 12.00 ),
			Vector( -443.00, -32.00, -209.00 ),
	
			Vector( 5142.00, -1007.00, 44.00 ),
			Vector( 2064.00, 5020.00, -209.00 ),
			Vector( 2279.00, 3418.00, -217.00 ),
			Vector( 4725.00, 1163.00, 11.00 ),
			Vector( 2132.00, 1730.00, 11.00 ),
	
			Vector( 1515.00, 3101.00, 108.00 ),
			Vector( 93.00, 3106.00, -39.00 ),
			Vector( -2008.00, 2866.00, -84.00 ),
			Vector( -3711.00, 3161.00, 11.00 ),
			Vector( -527.00, 4436.00, -24.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "scp689", {
		item = { slc_scp_689 = 10, _none = 70 },
		amount = 1,
		condition = function()
			local min = CVAR.slc_689_min_players:GetInt()
			return min > 0 and player.GetCount() >= min
		end,
		spawns = {
			Vector( 1237.00, 299.00, 12.00 ),
			Vector( 2894.00, 450.00, 11.00 ),
			Vector( -1362.00, -858.00, 12.00 ),

			Vector( 4155.00, -191.00, 12.00 ),
			Vector( 4161.00, 1089.00, 12.00 ),
			Vector( 2880.00, 3519.00, 11.00 ),
			Vector( 3515.00, 2240.00, 11.00 ),

			Vector( -446.00, 2383.00, 11.00 ),
			Vector( -2366.00, 2994.00, 11.00 ),
			Vector( -444.00, 4262.00, 11.00 ),
			Vector( 989.00, 3014.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Omnitools
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "omnitools_lcz", {
		item = "func:omnitool:60:25",
		amount = { 2, 5 },
		spawns = {
			Vector( 387.00, -621.00, 24.00 ),
			Vector( 324.00, -621.00, 44.00 ),
			Vector( -377.00, 1349.00, 40.00 ),
			Vector( -34.00, 807.00, 11.00 ),
			Vector( 1408.00, -1131.00, 45.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "omnitools_hcz", {
		item = "func:omnitool:90:30:5",
		amount = { 1, 3 },
		spawns = {
			Vector( 4229.00, -1383.00, -117.00 ),
			Vector( 4466.00, 525.00, 11.00 ),
			Vector( 4125.00, 2257.00, 47.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "omnitools_ez", {
		item = "func:omnitool:100:50:10",
		amount = 1,
		spawns = {
			Vector( 436.00, 3346.00, -77.00 ),
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Chips
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "chip_lcz_open_pre", {
		item = "func:chip:1",
		amount = { 2, 4 },
		spawns = {
			Vector( 28.00, -620.00, 44.00 ),
			Vector( -168.00, 1271.00, 40.00 ),
			Vector( 1307.00, 1509.00, 139.00 ),
			Vector( 1473.00, -1130.00, 25.00 ),
			Vector( 791.00, -2389.00, 11.00 ),
			Vector( 281.00, -1100.00, 51.00 ),
			Vector( -334.00, 790.00, 40.00 ),
			Vector( -1473.00, 305.00, -117.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "chip_lcz_open_post", {
		item = "func:chip:1",
		amount = { 1, 3 },
		spawns = {
			Vector( 2794.00, 37.00, 43.00 ),
			Vector( 1779.00, 744.00, 55.00 ),
			Vector( 2627.00, 596.00, 11.00 ),
			Vector( 769.00, 153.00, 11.00 ),
			Vector( 484.00, -330.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "chip_lcz_closed", {
		item = "func:chip:2",
		amount = { 2, 4 },
		spawns = {
			Vector( -159.00, -359.00, -245.00 ),
			Vector( 550.00, -1181.00, 47.00 ),
			Vector( 1593.00, 55.00, -757.00 ),
			Vector( 2946.00, -962.00, -21.00 ),
			Vector( 1633.00, 798.00, 47.00 ),
			Vector( 1129.00, 431.00, 11.00 ),
			Vector( -1376.00, -18.00, 228.00 ),
			Vector( -1134.00, 1918.00, 132.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "chip_hcz_open", {
		item = "func:chip:2",
		amount = 3,
		spawns = {
			Vector( 5676.00, -540.00, 11.00 ),
			Vector( 5321.00, 2137.00, 39.00 ),
			Vector( 4032.00, 3580.00, 45.00 ),
			Vector( 2276.00, 2369.00, 11.00 ),
			Vector( 2078.00, 4109.00, 12.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "chip_hcz_closed", {
		item = "func:chip:3",
		amount = 3,
		spawns = {
			Vector( 4008.00, -740.00, -245.00 ),
			Vector( 4743.00, -2807.00, 27.00 ),
			Vector( 5010.00, 3801.00, 49.00 ),
			Vector( 2009.00, 1604.00, 47.00 ),
			Vector( 5544.00, 613.00, -61.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "chip_ez", {
		item = "func:chip:3",
		amount = 1,
		spawns = {
			Vector( -1435.00, 2628.00, -81.00 ),
			Vector( 1713.00, 3941.00, 47.00 ),
			Vector( -988.00, 2667.00, 24.00 ),
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Fuses
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "fuses_lcz", {
		item = "func:fuse:3:7",
		amount = 2,
		spawns = {
			Vector( 751.00, -190.00, -757.00 ),
			Vector( 57.00, 2024.00, 267.00 ),
			Vector( 1752.00, -1667.00, 11.00 ),
			Vector( 2672.00, 796.00, 47.00 ),
			Vector( 1138.00, 657.00, 11.00 ),
			Vector( -1567.00, -524.00, 40.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "fuses_hcz", {
		item = "func:fuse:5:12",
		amount = 1,
		spawns = {
			Vector( 5453.00, -956.00, 47.00 ),
			Vector( 5005.00, 2371.00, 11.00 ),
			Vector( 4257.00, 995.00, 12.00 ),
			Vector( 2262.00, 1608.00, 39.00 ),
			Vector( 2365.00, 5038.00, -245.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "fuses_ez", {
		item = "func:fuse:5:8",
		amount = 1,
		spawns = {
			Vector( 1494.00, 2848.00, 111.00 ),
			Vector( -106.00, 2545.00, 45.00 ),
			Vector( -1850.00, 2471.00, -117.00 ),
			Vector( -2559.00, 4120.00, 267.00 ),
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Items spawn
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "med_misc", {
		item = { item_slc_medkit = 95, item_slc_medkitplus = 5, item_slc_adrenaline = 30, item_slc_adrenaline_big = 3, item_slc_morphine = 30, item_slc_morphine_big = 3 },
		amount = { 4, 10 },
		spawns = {
			--lcz
			Vector( -1450.00, 3516.00, 11.00 ),
			Vector( -1860.00, 3297.00, 11.00 ),
			Vector( 283.00, 3648.00, -77.00 ),
			Vector( 1252.00, 2423.00, 11.00 ),

			--hcz
			Vector( 4525.00, 3075.00, -5.00 ),
			Vector( 3991.00, 184.00, -337.00 ),
			Vector( 3858.00, -822.00, -117.00 ),
			Vector( 5792.00, 28.00, 4.00 ),

			--ez
			Vector( 452.00, -974.00, -117.00 ),
			Vector( 1377.00, -2105.00, -757.00 ),
			Vector( 2676.00, 100.00, 47.00 ),
			Vector( 1150.00, 721.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "loose_lcz", {
		item = { item_slc_battery = 10, item_slc_cctv = 10, item_slc_flashlight = 10, item_slc_gasmask = 10, item_slc_nvg = 10,
			item_slc_radio = 10, item_slc_snav = 10 },
		amount = { 6, 12 },
		spawns = {
			Vector( -2036.00, 1162.00, 140.00 ),
			Vector( -377.00, 906.00, 47.00 ),
			Vector( -830.00, -909.00, 11.00 ),
			Vector( 1726.00, -2156.00, 11.00 ),
			Vector( 3033.00, 408.00, 11.00 ),
			Vector( 1422.00, 1140.00, 11.00 ),
			Vector( 834.00, -306.00, 11.00 ),
			Vector( 2226.00, -299.00, 11.00 ),
			Vector( -328.00, 1333.00, 47.00 ),
			Vector( -597.00, 815.00, 11.00 ),
			Vector( -32.00, -613.00, 41.00 ),
			Vector( 450.00, -1300.00, -117.00 ),
			Vector( 1364.00, -1127.00, 11.00 ),
			Vector( 2650.00, -1406.00, 11.00 ),
			Vector( 2566.00, 857.00, 11.00 ),
			Vector( 1786.00, 153.00, 54.00 ),
			Vector( 450.00, -77.00, 11.00 ),
			Vector( -41.00, 1990.00, 139.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "loose_hcz", {
		item = { item_slc_battery = 5, item_slc_cctv = 5, item_slc_flashlight = 10, item_slc_gasmask = 10, item_slc_nvg = 10,
			item_slc_radio = 5, item_slc_snav = 10 },
		amount = { 4, 8 },
		spawns = {
			Vector( 5139.00, 3502.00, 11.00 ),
			Vector( 4213.00, 3920.00, 11.00 ),
			Vector( 4579.00, 27.00, 11.00 ),
			Vector( 3371.00, 2218.00, 11.00 ),
			Vector( 2153.00, 3552.00, 12.00 ),
			Vector( 3936.00, -1233.00, -117.00 ),
			Vector( 5539.00, -283.00, 12.00 ),
			Vector( 4797.00, 2330.00, 11.00 ),
			Vector( 4111.00, 2459.00, 11.00 ),
			Vector( 2811.00, 1659.00, 11.00 ),
			Vector( 2918.00, 3252.00, -372.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "loose_ez", {
		item = { item_slc_battery = 5, item_slc_cctv = 5, item_slc_flashlight = 5, item_slc_gasmask = 5, item_slc_nvg = 5,
			item_slc_radio = 5, item_slc_snav = 5 },
		spawns = {
			Vector( 60.00, 2515.00, 4.00 ),
			Vector( -1022.00, 3952.00, -53.00 ),
			Vector( 1428.00, 1948.00, 47.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "melee_lcz", {
		item = { weapon_slc_glass_knife = 5, weapon_slc_pipe = 5 },
		amount = { 3, 5 },
		spawns = {
			Vector( -868.00, 1579.00, 173.00 ),
			Vector( -794.00, -28.00, 277.00 ),
			Vector( -1349.00, 967.00, -117.00 ),
			Vector( -329.00, 1637.00, 267.00 ),
			Vector( 688.00, -1773.00, 44.00 ),
			Vector( -11.00, -992.00, -117.00 ),
			Vector( 1365.00, -620.00, 11.00 ),
			Vector( 1525.00, -1029.00, -757.00 ),
			Vector( 1826.00, 407.00, 28.00 ),
			Vector( 2625.00, -1132.00, -21.00 ),
			Vector( 765.00, 1850.00, 139.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "melee_hcz", {
		item = { weapon_slc_crowbar = 15, weapon_slc_stunstick = 10 },
		amount = { 1, 2 },
		spawns = {
			Vector( 4686.00, 453.00, 11.00 ),
			Vector( 5510.00, 250.00, 12.00 ),
			Vector( 4582.00, 3719.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "forest", {
		item = { item_slc_medkit = 15, item_slc_medkitplus = 15, item_slc_morphine = 10, item_slc_adrenaline = 10, item_slc_nvgplus = 10, item_slc_thermal = 10,
			item_slc_snav = 10, item_slc_snav_ultimate = 10, item_slc_morphine_big = 10, item_slc_adrenaline_big = 10, item_scp_500 = 10, item_slc_heavymask = 10,
			weapon_slc_crowbar = 5, weapon_slc_stunstick = 5, weapon_taser = 5, item_slc_turret = 5, item_slc_commander_tablet = 2, item_slc_battery_x = 1,
			["func:fuse:4:8"] = 10, ["func:fuse:8:12"] = 5, ["func:chip:3"] = 10, ["func:chip:4"] = 5, ["func:vest:ntf"] = 5, ["func:vest:alpha1"] = 2 },
		amount = { 4, 8 },
		spawns = {
			Vector( 6463.00, 4750.00, -1100.00 ),
			Vector( 7372.00, 4645.00, -1100.00 ),
			Vector( 7368.00, 3395.00, -1100.00 ),
			Vector( 6470.00, 3870.00, -1100.00 ),
			Vector( 6372.00, 5502.00, -1100.00 ),
			Vector( 7261.00, 5632.00, -1100.00 ),
			Vector( 5465.00, 5586.00, -1100.00 ),
			Vector( 4423.00, 5536.00, -1100.00 ),
			Vector( 4369.00, 4865.00, -1100.00 ),
			Vector( 4358.00, 3690.00, -1100.00 ),
			Vector( 5307.00, 4708.00, -1100.00 ),
			Vector( 5334.00, 3762.00, -1090.00 ),
		},
		post_tab = post,
	}, true )
	--[[-------------------------------------------------------------------------
	Spawn documents
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "documents", {
		item = "func:document",
		amount = { 4, 8 },
		spawns = {
			Vector( -212.00, 1344.00, 47.00 ),
			Vector( -322.00, -225.00, -110.00 ),
			Vector( -1624.00, -527.00, 60.00 ),
			Vector( 166.00, -721.00, 68.00 ),
			Vector( 614.00, -1746.00, 5.00 ),
			Vector( 1423.00, -515.00, -757.00 ),
			Vector( 3003.00, -1339.00, -21.00 ),
			Vector( 1680.00, -1668.00, 11.00 ),
			Vector( 1349.00, 581.00, 11.00 ),
			Vector( 2990.00, 793.00, 47.00 ),
			Vector( 2246.00, 1221.00, 68.00 ),
			Vector( 540.00, 1382.00, 267.00 ),
			Vector( 1750.00, 793.00, 47.00 ),

			Vector( 4560.00, -2165.00, 60.00 ),
			Vector( 5221.00, 419.00, 40.00 ),
			Vector( 5786.00, -267.00, 44.00 ),
			Vector( 4011.00, -918.00, -95.00 ),
			Vector( 5151.00, 2076.00, 4.00 ),
			Vector( 4524.00, 3297.00, -117.00 ),
			Vector( 2159.00, 1611.00, 47.00 ),
			Vector( 1921.00, 5231.00, -212.00 ),
			Vector( 1824.00, 3582.00, -245.00 ),

			Vector( 1572.00, 2081.00, 47.00 ),
			Vector( 10.00, 2461.00, 40.00 ),
			Vector( 1441.00, 2952.00, 104.00 ),
			Vector( -1.00, 3257.00, -81.00 ),
			Vector( -1344.00, 2484.00, 47.00 ),
			Vector( -1238.00, 3750.00, -60.00 ),
			Vector( -3843.00, 2296.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Spawn ammo
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "ammo", {
		item = "cw_ammo_kit_regular",
		spawns = {
			--GOC
			Vector( -7350.00, 3450.00, 2571.00 ),
			Vector( -7350.00, 3350.00, 2571.00 ),
			Vector( -7350.00, 3250.00, 2571.00 ),
			Vector( -7350.00, 3150.00, 2571.00 ),
			Vector( -7350.00, 3050.00, 2571.00 ),

			--MTF
			Vector( -2630.00, 1660.00, 2315.00 ),
			Vector( -2630.00, 1750.00, 2315.00 ),
			Vector( -2630.00, 1840.00, 2315.00 ),
			Vector( -2630.00, 1930.00, 2315.00 ),
			Vector( -2630.00, 2020.00, 2315.00 ),

			--CI
			Vector( 605.00, 7125.00, 2040.00 ),
			Vector( 605.00, 7050.00, 2040.00 ),
			Vector( 605.00, 6975.00, 2040.00 ),
			Vector( 605.00, 6900.00, 2040.00 ),
			Vector( 605.00, 6825.00, 2040.00 ),

			--guards
			Vector( -3020.00, 3775.00, 257.00 ),
			Vector( -3020.00, 3955.00, 257.00 ),
			Vector( -3020.00, 4135.00, 257.00 ),

			--armory
			Vector( 1300.00, -1630.00, 11.00 ),
			Vector( 1450.00, -1630.00, 11.00 ),
		
			Vector( 1300.00, -1460.00, 11.00 ),
			Vector( 1450.00, -1460.00, 11.00 ),
		
			Vector( 1300.00, -1550.00, 11.00 ),
			Vector( 1450.00, -1550.00, 11.00 ),
		},
		post_tab = {
			ResupplyMultiplier = 8,
			AmmoCapacity = 15
		},
	}, true )

	ItemSpawnRule( "ammo_random_inside", {
		item = "cw_ammo_kit_small",
		amount = { 2, 5 },
		spawns = {
			Vector( 2051.00, -767.00, -757.00 ),

			Vector( 4814.00, -2802.00, 27.00 ),
			Vector( 4947.00, 2749.00, 11.00 ),
			Vector( 4262.00, 3011.00, 11.00 ),
			Vector( 1896.00, 4577.00, -245.00 ),
			Vector( 1464.00, 2087.00, 11.00 ),

			Vector( 404.00, 2654.00, 11.00 ),
			Vector( -3555.00, 2587.00, 11.00 ),
			Vector( -751.00, 4351.00, -53.00 ),
			Vector( 873.00, 4574.00, 11.00 ),
		},
		post_tab = {
			ResupplyMultiplier = 2,
			AmmoCapacity = 5
		},
	}, true )

	ItemSpawnRule( "ammo_random_outside", {
		item = "cw_ammo_kit_small",
		amount = { 2, 5 },
		spawns = {
			Vector( -2009.00, 6588.00, 2187.00 ),
			Vector( -601.00, 4917.00, 2571.00 ),
			Vector( -2384.00, 6608.00, 3115.00 ),
			Vector( 51.00, 6470.00, 3115.00 ),
			Vector( -2600.00, 7216.00, 3115.00 ),
			Vector( 622.00, 6723.00, 2187.00 ),
		},
		post_tab = {
			ResupplyMultiplier = 4,
			AmmoCapacity = 10
		},
	}, true )

	--[[-------------------------------------------------------------------------
	Spawn weapons
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "super_weapon", {
		item = "weapon_slc_pc",
		spawns = {
			Vector( 3577.00, 1715.00, 60.00 )
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "pitols", {
		item = { ["loadout:pistol_low"] = 30, _none = 10 },
		spawns = {
			Vector( 1900.00, -562.00, -764.00 ),
			Vector( 173.00, -319.00, 11.00 ),
			Vector( -153.00, 97.00, -188.00 ),

			Vector( 5537.00, 417.00, -501.00 ),
			Vector( 4323.00, 2276.00, 11.00 ),
			Vector( 2883.00, 4926.00, -437.00 ),
			Vector( 2398.00, 1616.00, 11.00 ),

			Vector( -774.00, 2713.00, 54.00 ),
			Vector( 480.00, 2468.00, 47.00 ),
			Vector( 786.00, 4579.00, 11.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "smgs", {
		item = "loadout:smg_low",
		amount = 1,
		spawns = {
			Vector( 1981.00, 3372.00, -245.00 ),
			Vector( 2996.00, 102.00, 47.00 ),
			Vector( 2672.00, 788.00, 4.00 ),
			Vector( 1396.00, 3941.00, 47.00 ),
			Vector( 5358.00, 3571.00, -1099.00 ),
			Vector( 7416.00, 5633.00, -1141.00 ),
			Vector( 6514.00, 3686.00, -1139.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "shotguns_outside", {
		item = "loadout:shotgun_all",
		amount = { 0, 3 },
		spawns = {
			Vector( 574.00, 6715.00, 2187.00 ),
			Vector( -3146.00, 5326.00, 2187.00 ),
			Vector( -678.00, 4916.00, 2571.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "rifles_outside", {
		item = "loadout:rifle_all",
		amount = { 0, 3 },
		spawns = {
			Vector( -1940.00, 6590.00, 2187.00 ),
			Vector( -5549.00, 2768.00, 2571.00 ),
			Vector( -7349.00, 1725.00, 2571.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "snipers_outside", {
		item = { ["loadout:sniper_low"] = 30, ["loadout:sniper_mid"] = 10 },
		amount = { 0, 5 },
		spawns = {
			Vector( -6948.00, -818.00, 2287.00 ),
			Vector( -3760.00, 1970.00, 2571.00 ),
			Vector( -52.00, 6477.00, 3115.00 ),
			Vector( -2521.00, 6610.00, 3115.00 ),
			Vector( -2741.00, 7375.00, 3115.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "armory_lcz_pistols", {
		item = { ["loadout:pistol_low"] = 30, ["loadout:pistol_mid"] = 10 },
		amount = { 6, 12 },
		spawns = {
			Vector( 1585, -1406, 28 ),
			Vector( 1520, -1406, 28 ),
			Vector( 1465, -1406, 28 ),
			Vector( 1395, -1406, 28 ),
			Vector( 1350, -1406, 28 ),
			Vector( 1275, -1406, 28 ),
			Vector( 1585, -1406, 52 ),
			Vector( 1520, -1406, 52 ),
			Vector( 1465, -1406, 52 ),
			Vector( 1395, -1406, 52 ),
			Vector( 1350, -1406, 52 ),
			Vector( 1275, -1406, 52 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "armory_lcz_heavy", {
		item = { ["loadout:smg_low"] = 30, ["loadout:smg_mid"] = 10 },
		amount = { 0, 2 },
		spawns = {
			Vector( 1585, -1700, 28 ),
			Vector( 1520, -1700, 28 ),
			Vector( 1465, -1700, 28 ),
			Vector( 1395, -1700, 28 ),
			Vector( 1350, -1700, 28 ),
			Vector( 1275, -1700, 28 ),
			Vector( 1585, -1700, 52 ),
			Vector( 1520, -1700, 52 ),
			Vector( 1465, -1700, 52 ),
			Vector( 1395, -1700, 52 ),
			Vector( 1350, -1700, 52 ),
			Vector( 1275, -1700, 52 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "armory_sniper_shotgun", {
		item = { ["loadout:sniper_low"] = 15, ["loadout:shotgun_low"] = 15 },
		spawns = {
			Vector( 1585.00, -1563.00, 11.00 )
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Vests
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "vests", {
		item = { ["func:vest:?"] = 9, _none = 1 },
		spawns = {
			Vector( 768.00, 1873.00, 257.00 ),
			Vector( -1625.00, -1112.00, 1.00 ),
			Vector( 551.00, -1397.00, 1.00 ),
			Vector( 1884.00, -1050.00, -767.00 ),
			Vector( 1531.00, -1627.00, 1.00 ),
			Vector( 1532.00, -1570.00, 1.00 ),
			Vector( 1303.00, 432.00, 1.00 ),
		
			Vector( 3652.00, -1375.00, -127.00 ),
			Vector( 5520.00, -686.00, 1.00 ),
			Vector( 2518.00, 2859.00, -383.00 ),
			Vector( 4262.00, 2470.00, 1.00 ),
			Vector( 3884.00, 3937.00, 1.00 ),
			Vector( 2464.00, 4899.00, 1.00 ),
			Vector( 5219.00, 2294.00, 1.00 ),
			Vector( 5031.00, -2265.00, 53.00 ),
			Vector( 1967.00, 1511.00, 1.00 ),
		
			Vector( 983.00, 3076.00, 1.00 ),
			Vector( -92.00, 3624.00, -127.00 ),
			Vector( 1580.00, 2411.00, 1.00 ),
			Vector( 404.00, 2466.00, 1.00 ),
			Vector( -2975.00, 3776.00, 257.00 ),
		},
		post_tab = post,
	}, true )

	ItemSpawnRule( "hazmats", {
		item = "func:vest:hazmat",
		amount = { 3, 6 },
		spawns = {
			Vector( -157.00, -16.00, -255.00 ),
			Vector( 1476.00, -2401.00, 2.00 ),
			Vector( 1757.00, 965.00, 1.00 ),
			
			Vector( 5525.00, -779.00, 1.00 ),
			Vector( 2285.00, 1706.00, 1.00 ),
			Vector( 2385.00, 1711.00, 1.00 ),
			
			Vector( -798.00, 3045.00, 20.00 ),
		},
		post_tab = post,
	}, true )

	--[[-------------------------------------------------------------------------
	Backpacks
	---------------------------------------------------------------------------]]
	ItemSpawnRule( "backpacks", {
		item = { ["func:backpack:small"] = 8, ["func:backpack:medium"] = 4 },
		amount = { 0, 4 },
		spawns = {
			Vector( -566.00, 1912.00, 11.00 ),
			Vector( 653.00, -1182.00, 47.00 ),
			Vector( 2214.00, -1765.00, -757.00 ),
			Vector( 2462.00, -1763.00, 11.00 ),
			Vector( 2745.00, 215.00, 11.00 ),
			Vector( 2173.00, 1360.00, 11.00 ),
			Vector( -678.00, -423.00, 11.00 ),
			Vector( 833.00, 557.00, 11.00 ),

			Vector( 4990.00, -427.00, 11.00 ),
			Vector( 5121.00, 2613.00, 11.00 ),
			Vector( 2982.00, 3642.00, 11.00 ),
			Vector( 2942.00, 1788.00, 11.00 ),
			
			Vector( -447.00, 2203.00, 11.00 ),
			Vector( -2201.00, 3010.00, 11.00 ),
		},
		post_tab = post,
	}, true )
end

--[[-------------------------------------------------------------------------
Fuse Boxes
---------------------------------------------------------------------------]]
FUSE_BOXES = {
	{
		name = "lcz_underground_1",
		pos = Vector( 2500.00, -2171.00, -705.00 ),
		ang = Angle( 0, 90, 0 ),
		rating = 3,
		fuse = 3,
	},
	{
		name = "lcz_underground_2",
		pos = Vector( 2185.00, -1669.00, -705.00 ),
		ang = Angle( 0, -90, 0 ),
		rating = 5,
		fuse = 0,
	},
	{
		name = "hcz_049_door",
		pos = Vector( 4235.00, -645.00, 60.00 ),
		ang = Angle( 0, 180, 0 ),
		rating = 3,
		fuse = 0.333,
	},
	{
		name = "ez_cp_room",
		pos = Vector( 355.00, 3562.00, -70.00 ),
		ang = Angle( 0, -90, 0 ),
		rating = 5,
		fuse = 0.1,
	},
	{
		name = "gate_b_1",
		pos = Vector( -3779.00, 2950.00, 60.00 ),
		ang = Angle( 0, 90, 0 ),
		rating = 10,
		fuse = 0,
	},
	{
		name = "ez_vent_1",
		pos = Vector( -3057.00, 4056.00, 319.00 ),
		ang = Angle( 0, 0, 0 ),
		rating = 5,
		fuse = 0,
	},
	{
		name = "ez_vent_2",
		pos = Vector( -3057.00, 3870.00, 319.00 ),
		ang = Angle( 0, 0, 0 ),
		rating = 5,
		fuse = 0,
	},
	{
		name = "ez_vent_3",
		pos = Vector( -3057.00, 3790.00, 319.00 ),
		ang = Angle( 0, 0, 0 ),
		rating = 5,
		fuse = 0,
	},
	{
		name = "hcz_106_vent",
		pos = Vector( 1835.00, 4010.00, 60.00 ),
		ang = Angle( 0, 180, 0 ),
		rating = 6,
		fuse = 0,
		time = 90,
	},
	{
		name = "scp106_recontain",
		pos = Vector( 4070.00, 3644.00, 60.00 ),
		ang = Angle( 0, 0, 0 ),
		rating = 16,
		fuse = 0,
	},
	{
		name = "hcz_682_passage",
		pos = Vector( 3184.00, 3010.00, -323.00 ),
		ang = Angle( 0, 180, 0 ),
		rating = 5,
		fuse = 0,
	}
}

--[[-------------------------------------------------------------------------
Lootables

{
	pos = Vector(),
	bounds = { --optional, if not used default 32x32x32 will be used
		mins = Vector(),
		maxs = Vector(),
	},
	loot_pool = "",
	width = 1,
	height = 1,
}
---------------------------------------------------------------------------]]
LOOTABLES = {
	{ --guard desk
		pos = Vector( -2416, 1550, 160 ),
		bounds = {
			mins = Vector( -32, -8, -32 ),
			maxs = Vector( 32, 16, 32 ),
		},
		width = 2,
		height = 4,
		loot_pool = "guard_desk"
	},
	{ --class d office 1
		pos = Vector( -385, 1198, 20 ),
		bounds = {
			mins = Vector( -8, -12, -14 ),
			maxs = Vector( 8, 12, 12 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_loose_loot"
	},
	{ --class d office 2
		pos = Vector( -380, 810, 20 ),
		bounds = {
			mins = Vector( -12, -8, -14 ),
			maxs = Vector( 10, 8, 12 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_loose_loot"
	},
	{ --scp 012
		pos = Vector( -150, 92.5, -222 ),
		bounds = {
			mins = Vector( -16, -64, -32 ),
			maxs = Vector( 8, 64, 32 ),
		},
		width = 4,
		height = 3,
		loot_pool = "lcz_large_loot"
	},
	{ --scp 173
		pos = Vector( 207, 1984, 289 ),
		bounds = {
			mins = Vector( -8, -64, -32 ),
			maxs = Vector( 16, 64, 32 ),
		},
		width = 4,
		height = 3,
		loot_pool = "lcz_large_loot"
	},
	{ --scp 372
		pos = Vector( -1144, -527, 33 ),
		bounds = {
			mins = Vector( -16, -16, -32 ),
			maxs = Vector( 16, 8, 32 ),
		},
		width = 1,
		height = 4,
		loot_pool = "lcz_rare_loot"
	},
	{ --scp 372
		pos = Vector( -1650, -576, 19 ),
		bounds = {
			mins = Vector( -16, -22, -16 ),
			maxs = Vector( 16, 22, 8 ),
		},
		width = 2,
		height = 2,
		loot_pool = "lcz_valuable_loot"
	},
	{ --scp 372
		pos = Vector( -1072, -1104, 5 ),
		bounds = {
			mins = Vector( -18, -24, -4 ),
			maxs = Vector( 18, 24, 8 ),
		},
		width = 3,
		height = 3,
		loot_pool = "lcz_military_crate"
	},
	{ --corridor
		pos = Vector( 222, -627, 33 ),
		bounds = {
			mins = Vector( -64, -12, -32 ),
			maxs = Vector( 64, 8, 32 ),
		},
		width = 4,
		height = 3,
		loot_pool = "lcz_large_loot"
	},
	{ --914
		pos = Vector( 1378, -544, 15 ),
		bounds = {
			mins = Vector( -20, -20, -18 ),
			maxs = Vector( 20, 20, 18 ),
		},
		width = 2,
		height = 2,
		loot_pool = "lcz_rare_loot"
	},
	{ --1123
		pos = Vector( 664, -1190, 16 ),
		bounds = {
			mins = Vector( -12, -12, -16 ),
			maxs = Vector( 12, 6, 16 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_loose_loot"
	},
	{ --1123
		pos = Vector( 540, -1312, 33 ),
		bounds = {
			mins = Vector( -6, -32, -32 ),
			maxs = Vector( 12, 32, 32 ),
		},
		width = 2,
		height = 4,
		loot_pool = "lcz_rare_loot"
	},
	{ --205
		pos = Vector( 2713, -1505, 33 ),
		bounds = {
			mins = Vector( -16, -8, -32 ),
			maxs = Vector( 16, 16, 32 ),
		},
		width = 2,
		height = 4,
		loot_pool = "lcz_rare_loot"
	},
	{ --glass room
		pos = Vector( 1361, 528, 33 ),
		bounds = {
			mins = Vector( -16, -16, -32 ),
			maxs = Vector( 8, 16, 32 ),
		},
		width = 2,
		height = 4,
		loot_pool = "lcz_rare_loot"
	},
	{ --galass room
		pos = Vector( 1131, 588, 15 ),
		bounds = {
			mins = Vector( -24, -20, -16 ),
			maxs = Vector( 24, 20, 16 ),
		},
		width = 2,
		height = 2,
		loot_pool = "lcz_valuable_loot"
	},
	{ --1162
		pos = Vector( 1627, 807, 18 ),
		bounds = {
			mins = Vector( -14, -6, -16 ),
			maxs = Vector( 14, 12, 16 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_loose_loot"
	},
	{ --714
		pos = Vector( 2240, 797, 33 ),
		bounds = {
			mins = Vector( -16, -8, -32 ),
			maxs = Vector( 16, 16, 32 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_rare_loot"
	},
	{ --860
		pos = Vector( 1987, 1376, 33 ),
		bounds = {
			mins = Vector( -16, -16, -32 ),
			maxs = Vector( 8, 16, 32 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_rare_loot"
	},
	{ --1025
		pos = Vector( 2240, 1216, 33 ),
		bounds = {
			mins = Vector( -16, -8, -32 ),
			maxs = Vector( 16, 16, 32 ),
		},
		width = 1,
		height = 3,
		loot_pool = "lcz_rare_loot"
	},
	{ --toilet lcz
		pos = Vector( 1760, 485, 15 ),
		bounds = {
			mins = Vector( -12, -12, -12 ),
			maxs = Vector( 12, 12, 12 ),
		},
		width = 1,
		height = 1,
		loot_pool = "lcz_toilet"
	},
	{ --457
		pos = Vector( 5784, -400, 33 ),
		bounds = {
			mins = Vector( -8, -48, -32 ),
			maxs = Vector( 16, 48, 32 ),
		},
		width = 3,
		height = 4,
		loot_pool = "hcz_large_loot"
	},
	{ --035
		pos = Vector( 5200, -1122, 15 ),
		bounds = {
			mins = Vector( -64, -18, -12 ),
			maxs = Vector( 64, 18, 12 ),
		},
		width = 7,
		height = 2,
		loot_pool = "hcz_035"
	},
	{ --096
		pos = Vector( 5216, 3760, 33 ),
		bounds = {
			mins = Vector( -8, -48, -32 ),
			maxs = Vector( 16, 48, 32 ),
		},
		width = 3,
		height = 4,
		loot_pool = "hcz_large_loot"
	},
	{ --049
		pos = Vector( 4860, -2624, 33 ),
		bounds = {
			mins = Vector( -18, -20, -16 ),
			maxs = Vector( 18, 20, 12 ),
		},
		width = 2,
		height = 2,
		loot_pool = "hcz_valuable_loot"
	},
	{ --ez room
		pos = Vector( 1314, 3163, 81 ),
		bounds = {
			mins = Vector( -14, -12, -16 ),
			maxs = Vector( 14, 6, 16 ),
		},
		width = 1,
		height = 3,
		loot_pool = "ez_loose_loot"
	},
	{ --ez room
		pos = Vector( 1453, 2963, 81 ),
		bounds = {
			mins = Vector( -12, -14, -16 ),
			maxs = Vector( 6, 14, 16 ),
		},
		width = 1,
		height = 3,
		loot_pool = "ez_loose_loot"
	},
	{ --ez office
		pos = Vector( -1123, 2485, 15 ),
		bounds = {
			mins = Vector( -20, -14, -14 ),
			maxs = Vector( 20, 14, 14 ),
		},
		width = 2,
		height = 2,
		loot_pool = "ez_valuable_loot"
	},
	{ --ec
		pos = Vector( -2836, 4016, 271 ),
		bounds = {
			mins = Vector( -22, -22, -14 ),
			maxs = Vector( 22, 22, 14 ),
		},
		width = 2,
		height = 2,
		loot_pool = "ez_valuable_loot"
	},
	{ --medbay
		pos = Vector( -1824, 3536, 33 ),
		bounds = {
			mins = Vector( -16, -16, -32 ),
			maxs = Vector( 16, 8, 32 ),
		},
		width = 2,
		height = 4,
		loot_pool = "medbay"
	},
	{ --ez toilet
		pos = Vector( -672, 2970, 15 ),
		bounds = {
			mins = Vector( -12, -12, -12 ),
			maxs = Vector( 12, 12, 12 ),
		},
		width = 1,
		height = 1,
		loot_pool = "toilet"
	},
}

/*hook.Add( "Think", "gastest", function()
	if true then return end
	//local i = 29
	for i, v in ipairs( LOOTABLES ) do
		debugoverlay.Axis( v.pos, Angle( 0 ), 5, 0.1, true )
		debugoverlay.BoxAngles(v.pos, v.bounds and v.bounds.mins or Vector(-16,-16,-16), v.bounds and v.bounds.maxs or Vector(16,16,16), Angle( 0 ), 0.1, Color( 255, 255, 255, 0 ), true )
		debugoverlay.Text( v.pos + Vector( 0, 0, 8 ), v.loot_pool, 0.1, false )
	end
end )*/

--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
ZERO_POS = Vector( -1100, 500, 0 )

GAS_POS = {
	Vector( 2268.5, -2267.5, 2 ),
	Vector( 4800, 3042.5, 1 ),
	Vector( 640, -37.5, -757 ),
	Vector( 675, -160, -700 ),
}

GAS_DIM = {
	{ mins = Vector( -137, -137, 0 ), maxs = Vector( 137, 137, 64 ), bounds = 1 },
	{ mins = Vector( -80, -117.5, 0 ), maxs = Vector( 75, 117.5, 96 ), bounds = 1 },
	{ mins = Vector( -100, -47.5, 0 ), maxs = Vector( 100, 47.5, 64 ), bounds = 1 },
	{ mins = Vector( -20, -50, 0 ), maxs = Vector( 20, 40, 48 ), bounds = 1 }
}

SAFE_SPOTS = {
	{ mins = Vector( -120, -1925, -130 ), maxs = Vector( 500, -1375, 40 ) }, --omega shelter
	{ mins = Vector( 1330, -1150, -5 ), maxs = Vector( 1790, -515, 275 ) }, --914
}

PREVENT_BREAK = {
	Vector( 1536.00, 3856.00, 74.00 ),
	Vector( 1536.00, 3440.00, 74.00 ),
	Vector( 2176.00, 2576.00, 74.00 ),
	Vector( 2176.00, 2160.00, 74.00 ),
	Vector( 2816.00, -400.00, 74.00 ),
	Vector( 2816.00, 16.00, 74.00 ),
	Vector( 2816.00, 880.00, 74.00 ),
	Vector( 2816.00, 1296.00, 74.00 ),
	//Vector( -6752.00, -512.50, 2308.00 ), --escape wiindow
	//Vector( -6880.00, -512.50, 2308.00 ), --escape wiindow
}

--[[-------------------------------------------------------------------------
Blockers
---------------------------------------------------------------------------]]
BLOCKERS = {
	/*{
		name = "family_friendly_name",
		pos = Vector( 0, 0, 0 ),
		bounds = { Vector( mins ), Vector( maxs ) },
		filter = {
			mode = BLOCKER_WHITELIST, --or BLOCKER_BLACKLIST
			group = "filter_group_name", --this is prefered over options below, however these can be mixed together
			classes = { "list", "of", "classes" }, --names, not ids - classes are registered few (1?) ticks after map config
			teams = { TEAM_NAME1, TEAM_NAME2 },
			round = { --Block everything during preparing/postround
				preparing = true/false,
				post = true/false,
			},
			custom_check = function( ply ) end, --custom check function, return true to allow, false to block, nil to allow other filters do the job
				(In whitelist mode, any function returning true allows. In blacklist mode, any function returning false blocks)
		}
	},*/
	{
		name = "omega_shelter",
		pos = Vector( 190, -1390, -80 ),
		bounds = { Vector( -70, -10, -50 ), Vector( 75, 15, 60 ) },
		filter = {
			mode = BLOCKER_BLACKLIST,
			group = "non_human",
		}
	},
	{
		name = "pocket_dim",
		pos = Vector( 2685, 4040, -460 ),
		bounds = { Vector( -80, -55, 0 ), Vector( 80, 75, 15 ) },
		filter = {
			mode = BLOCKER_WHITELIST,
			classes = { "SCP106" },
			round = {
				preparing = true,
			},
		}
	},
	{
		name = "escape_windows",
		pos = Vector( -6816, -510, 2308 ),
		bounds = { Vector( -125, -5, -40 ), Vector( 125, 5, 40 ) },
	},
	{
		name = "gatea_elevator",
		pos = Vector( -190, 5184, 55 ),
		bounds = { Vector( -5, -35, -60 ), Vector( 5, 35, 60 ) },
		filter = {
			mode = BLOCKER_BLACKLIST,
			custom_check = function( ply )
				if ply:SCPClass() != CLASSES.SCP173 then return true end

				local wep = ply:GetSCPWeapon()
				if !IsValid( wep ) then return true end

				return !wep:GetInStealth()
			end
		}
	},
	{
		name = "forest_door",
		pos = Vector( 1472.00, 2272.50, 50.00 ),
		bounds = { Vector( -0.1, -24, -54 ), Vector( 0.1, 24, 54 ) },
	},
}

/*if CLIENT then
	local showid = 4

	hook.Add( "Think", "gastest", function()
		//debugoverlay.Axis( GAS_POS[showid] + GAS_DIM[showid].mins, Angle( 0 ), 5, 0.1, true )
		debugoverlay.Axis( GAS_POS[showid], Angle( 0 ), 5, 0.1, true )
		debugoverlay.BoxAngles(GAS_POS[showid], GAS_DIM[showid].mins, GAS_DIM[showid].maxs, Angle( 0 ), 0.1, Color( 255, 255, 255, 0 ), true )
	end )
end*/

--[[-------------------------------------------------------------------------
Map checkers
---------------------------------------------------------------------------]]
local function v_lever_check( name )
	return function()
		local ent = CacheEntity( name )
		return IsValid( ent ) and ent:GetState()
	end
end

local function lever_check( name, roll )
	return function()
		local ent = CacheEntity( name )
		return IsValid( ent ) and ent:GetAngles().roll == roll
	end
end

MAP_CHECKERS = {
	ALPHA_REMOTE = v_lever_check( "warhead_lever_alpha" ),
	OMEGA_REMOTE = v_lever_check( "warhead_lever_omega" ),
	SCP106_SOUND = lever_check( "sound_lever_106", -180 ),
	SCP106_CAGE = function()
		local ent = ents.GetMapCreatedEntity( 2330 )
		if IsValid( ent ) and ent:GetPos() == CAGE_DOWN_POS then
			return true
		end

		return false
	end,
}

--[[-------------------------------------------------------------------------
Zones
---------------------------------------------------------------------------]]
MAP_ZONES = {
	[ZONE_SURFACE] = function( pos )
		return pos.z > 1675
	end,
	[ZONE_PD] = {
		{ Vector( 1500, 3760, 500 ), Vector( 4350, 5390, 1200 ) },
		{ Vector( 1500, 5390, -250 ), Vector( 4350, 6500, 1200 ) },
	},
	[ZONE_LCZ] = {
		{ Vector( -2600, -500, -1000 ), Vector( 2816, 1440, 500 ) },
		{ Vector( -2600, -2500, -1000 ), Vector( 3250, -500, 500 ) },
		{ Vector( 1000, 1440, -1000 ), Vector( 1400, 1900, 500 ) },
		{ Vector( -2600, 1440, -1000 ), Vector( 1000, 2100, 500 ) },
		{ Vector( 2816, 72, -1000 ), Vector( 3250, 824, 500 ) },
	},
	[ZONE_HCZ] = {
		{ Vector( 3250, -3000, -1000 ), Vector( 6500, 1440, 500 ) },
		{ Vector( 1900, 1440, -1000 ), Vector( 5500, 2100, 500 ) },
		{ Vector( 2176, 2100, -500 ), Vector( 5500, 2650, 500 ) },
		{ Vector( 1536, 2650, -500 ), Vector( 5500, 3912, 500 ) },
		{ Vector( 1850, 3912, -500 ), Vector( 3000, 4500, 500 ) },
		{ Vector( 1750, 4500, -500 ), Vector( 3000, 5300, 500 ) },
		{ Vector( 2816, -500, -1000 ), Vector( 3250, 72, 500 ) },
		{ Vector( 2816, 824, -1000 ), Vector( 3250, 1440, 500 ) },
	},
	[ZONE_EZ] = {
		{ Vector( -3250, 2100, -250 ), Vector( 1536, 5500, 500 ) },
		{ Vector( -4000, 1700, -250 ), Vector( -3250, 3500, 500 ) },
		{ Vector( 1536, 2100, -250 ), Vector( 2176, 2650, 500 ) },
		{ Vector( 1000, 1900, -250 ), Vector( 1900, 2100, 500 ) },
		{ Vector( 1536, 3912, -250 ), Vector( 1850, 4500, 500 ) },
		{ Vector( 3200, 2300, -1500 ), Vector( 8750, 6750, -600 ) },
	},
	[ZONE_WARHEAD] = {
		{ Vector( 3900.00, 100.00, -600.00 ), Vector( 4800.00, 800.00, -200.00 ) },
	},
	[ZONE_SCP106] = {
		{ Vector( 1850, 3912, -500 ), Vector( 3000, 4500, 500 ) },
		{ Vector( 1750, 4500, -500 ), Vector( 3000, 5300, 500 ) },
	},
	[ZONE_RESTRICT173] = {
		{ Vector( -760.00, 4835.00, -5.00 ), Vector( 10.00, 5420.00, 400.00 ) },
		{ Vector( -4010.00, 1710.00, -5.00 ), Vector( -3250.00, 2470.00, 300.00 ) },
	},
	[ZONE_SCP914] = {
		{ Vector( 1326.25, -1150.00, -5.00 ), Vector( 1800.00, -505.00, 290.00 ) },
	},
	[ZONE_FOREST] = {
		{ Vector( 3200, 2300, -1500 ), Vector( 8750, 6750, -600 ) },
	},
}

--[[-------------------------------------------------------------------------
SCP 914
---------------------------------------------------------------------------]]
SCP_914_MODE = function()
	local button = CacheEntity( "bt_914_4" )
	if !IsValid( button ) then return end

	local angle = math.Round( button:GetAngles().roll )
	if angle >= -22.5 and angle < 22.5 then
		return UPGRADE_MODE.ROUGH
	elseif angle >= 22.5 and angle < 67.5 then
		return UPGRADE_MODE.COARSE
	elseif angle >= 67.5 and angle < 112.5 then
		return UPGRADE_MODE.ONE_ONE
	elseif angle >= 112.5 and angle < 157.5 then
		return UPGRADE_MODE.FINE
	elseif angle >= 157.5 and angle < 202.5 then
		return UPGRADE_MODE.VERY_FINE
	end

	print( "[SCP-914] Error! Failed to select upgrade mode! Defaulting to FINE", angle )
	return UPGRADE_MODE.FINE
end

SCP_914_INTAKE_MINS = Vector( 1600.00, -683.00, 0.00 )
SCP_914_INTAKE_MAXS = Vector( 1677.00, -549.00, 128.00 )

SCP_914_OUTPUT_MINS = Vector( 1618.00, -1116.00, 0.00 )
SCP_914_OUTPUT_MAXS = Vector( 1675.00, -995.00, 128.00 )

SCP_914_OUTPUT = Vector( 1651.584229, -1052.149902, 7.470211 )

--[[-------------------------------------------------------------------------
Intercom
---------------------------------------------------------------------------]]
INTERCOM = { Vector( -2595.00, 4035.00, 310.00 ), Angle( 0, 180, 0 ) }

--[[-------------------------------------------------------------------------
S-NAV
---------------------------------------------------------------------------]]
SNAV = {
	{ material = Material( "slc/items/snav/gm_site19/gm_site19_layer1.png" ), z = 5000 }, -- z is the upper bound, material = nil displays "no signal"
	{ material = Material( "slc/items/snav/gm_site19/gm_site19_layer2.png" ), z = 2425 },
	{ material = nil, z = 1400 },
	{ material = Material( "slc/items/snav/gm_site19/gm_site19_layer3.png" ), z = 400 },
	{ material = Material( "slc/items/snav/gm_site19/gm_site19_layer4.png" ), z = -60 },
	{ material = Material( "slc/items/snav/gm_site19/gm_site19_layer5.png" ), z = -500 },
}

--[[-------------------------------------------------------------------------
Alpha Warhead
---------------------------------------------------------------------------]]
ALPHA_CARD_SPAWN = {
	{
		Vector( -2538.00, 1751.00, 160.00 ),
		Vector( 732.00, -164.00, -757.00 ),
		Vector( 3163.00, -1174.00, -21.00 ),
		Vector( 1234.00, 258.00, 12.00 ),
		Vector( 721.00, 1841.00, 267.00 ),
	},
	{
		Vector( 5423.00, 1266.00, -508.00 ),
		Vector( 3991.00, 498.00, -373.00 ),
		Vector( 1820.00, 2717.00, -372.00 ),
		Vector( 1945.00, 3993.00, -437.00 ),
		Vector( 4872.00, 3287.00, -117.00 ),
	},
	{
		Vector( 1559.00, 4076.00, 32.00 ),
		Vector( -2840.00, 3845.00, 340.00 ),
		Vector( -3751.00, 2653.00, 11.00 ),
		Vector( -553.00, 4154.00, -24.00 ),
		Vector( 5281.00, 3351.00, -1016.00 ),
	},
}

ALPHA_ACTIVATION = { Vector( -1275.00, 2678.00, 51.00 ), Angle( 0, -90, 0 ) }

--[[-------------------------------------------------------------------------
Omega warhead
---------------------------------------------------------------------------]]
OMEGA_ACTIVATION_1 = { Vector( -133.00, 6433.00, 3155.00 ), Angle( 0, 0, 0 ) }
OMEGA_ACTIVATION_2 = { Vector( -2298.00, 6405.00, 3155.00 ), Angle( 0, 180, 0 ) }

OMEGA_GATE_A_DOOR_L = "gate_containment_door_l"
OMEGA_GATE_A_DOOR_R = "gate_containment_door_r"

OMEGA_SHELTER_DOOR_L = "shelter_door_l"
OMEGA_SHELTER_DOOR_R = "shelter_door_r"

OMEGA_SHELTER = { Vector( -110, -1918, -128 ), Vector( 495, -1408, 30 ) }

--[[-------------------------------------------------------------------------
Escape/Escort
---------------------------------------------------------------------------]]
POS_ESCAPE = { Vector( -6986.00, -896.00, 2230.00 ), Vector( -6450.00, -500.00, 2395.00 ) }

POS_ESCORT = { Vector( -3071, 1600, 2290 ), Vector( -2689, 1800, 2400 ), Angle( 0, 0, -2.2 ) } --Generic escort pos, used if game fails to find escort pos for specified team
POS_ESCORT_MTF = POS_ESCORT
POS_ESCORT_CI = { Vector( 501, 6785, 2020 ), Vector( 629, 7167, 2120 ) }

--[[-------------------------------------------------------------------------
Gate destroy system
---------------------------------------------------------------------------]]
POS_EXPLODE_A = Vector( -450.00, 4950.00, 30.00 )
POS_MIDDLE_GATE_A = Vector( -448.00, 4836.00, 50.00 )
POS_GATE_A_DOORS = {
	Vector( -484.00, 4836.00, 50.00 ),
	Vector( -412.00, 4836.00, 50.00 ),
}

GATE_A_EXPLOSION_RADIUS = 1000

EXPLOSION_AREAS_A = {
	{ Vector( -750, 4607, -10 ), Vector( 25, 5400, 314 ) },
	{ Vector( -772, 3775, -80 ), Vector( -300, 4610, 130 ) },
}

--[[-------------------------------------------------------------------------
GOC
---------------------------------------------------------------------------]]
GOC_DEVICE_SPAWN = {
	Vector( -2776.00, 7394.00, 3115.00 ),
	Vector( 609.00, 6694.00, 2187.00 ),
	Vector( -3183.00, 5217.00, 2259.00 ),

	Vector( -1023.00, 3729.00, -53.00 ),
	Vector( 393.00, 2655.00, 11.00 ),
}
GOC_DEVICE_PLACE = Vector( 4020, 445, -350 )
GOC_DEVICE_BOUNDS = { Vector( 3955, 150, -400 ), Vector( 4085, 740, -250 ) }

--[[-------------------------------------------------------------------------
SCP doors
---------------------------------------------------------------------------]]
POS_DOOR = {
	
}

POS_BUTTON = {
	Vector( 5040.000000, -2376.000000, 54.000000 ), --049
	Vector( 362.000000, 1592.000000, 294.000000 ), --173
	Vector (4993.000000, 3592.000000, 53.000000 ), --096
	Vector( 4216.00, 2256.00, 38.00 ), --966
	Vector( 1264.00, -958.50, 53.00 ), --914
}

POS_ROT_BUTTON = {
	Vector(2288.000000, 3396.010010, -201.139999 ), --682
}

--[[-------------------------------------------------------------------------
??
---------------------------------------------------------------------------]]
FORCE_USE = {}
FORCE_DESTROY = {}

--[[-------------------------------------------------------------------------
SCP 106 config
---------------------------------------------------------------------------]]
ELO_IID = "magnet_lever_106" --can also be vector
CAGE_INSIDE = Vector( 2498.16, 4482.72, -402.50 )
CAGE_DOWN_POS = Vector( 2488.00, 4488.00, -307.00 )
CAGE_BOUNDS = {
	MINS = Vector( 2325.47, 4363.59, -403.00 ),
	MAXS = Vector( 2611.38, 4651.63, -200.00 )
}

DOOR_RESTRICT106 = {
	Vector( 2190.00, 3968.00, 55.50 ),
	Vector( 2688.00, 4040.00, -456.00 ),
	Vector( -3684.00, 2468.00, 49.75 ),
	Vector( -3612.00, 2468.00, 49.75 ),
	Vector( -3904.00, 1915.50, 55.50 ),
	Vector( -3904.00, 1915.50, 2563.50 ),
	Vector( -412.00, 4836.00, 50.00 ),
	Vector( -484.00, 4836.00, 50.00 ),
	Vector( -187.50, 5184.00, 2563.50 ),
	Vector( -187.50, 5184.00, 55.50 ),
	Vector( 4540.50, 448.00, 55.50 ),
	Vector( 4540.50, 448.00, -328.50 ),
	Vector( 4608.00, -84.50, 55.50 ),
	Vector( 4608.00, -1508.50, 71.50 ),
	Vector( 4992.00, -292.50, 55.50 ),
	Vector( 4992.00, -1716.50, 71.50 ),
	Vector( 3676.00, -1164.00, -78.00 ),
	Vector( 3748.00, -1164.00, -78.00 ),
	Vector( 832.00, -2244.50, 55.50 ),
	Vector( 832.00, 420.50, 55.50 ),
	Vector( 576.00, -452.50, -712.50 ),
	Vector( 2496.00, 132.50, -712.50 ),
	Vector( 1324.00, -795.97, 50.00 ),
	Vector( 1324.00, -868.00, 50.00 ),
	Vector( 2344.00, 4488.00, -360.00 ),
	Vector( -2400.00, 6878.03, 2257.97 ),
	Vector( -2782.03, 5152.00, 2256.97 ),
	Vector( -2977.97, 5152.00, 2256.97 ),
	Vector( -2400.00, 7073.97, 2257.97 ),
}

--[[-------------------------------------------------------------------------
Pocket dimension
---------------------------------------------------------------------------]]
POS_POCKETD = {
	Vector( 2421.7827148438, 4650.9155273438, 537.03125 ),
	Vector( 2378.9016113281, 4566.8305664063, 537.03125 ),
	Vector( 2273.0007324219, 4526.1396484375, 537.03125 ),
	Vector( 2203.7729492188, 4572.9760742188, 537.03125 ),
	Vector( 2165.5126953125, 4657.6489257813, 537.03125 ),
	Vector( 2233.5170898438, 4717.2373046875, 537.03125 ),
	Vector( 2308.3076171875, 4728.3671875, 537.03125 ),
	Vector( 2357.279296875, 4665.8432617188, 537.03125 ),
	Vector( 2335.2951660156, 4590.3525390625, 537.03125 ),
	Vector( 2279.5068359375, 4589.185546875, 537.03125 ),
	Vector( 2300.6682128906, 4651.541015625, 537.03125 ),
	Vector( 2246.9846191406, 4668.0068359375, 537.03125 ),
	Vector( 2232.6259765625, 4620.3232421875, 537.03125 ),
}

--[[-------------------------------------------------------------------------
Map buttons config
---------------------------------------------------------------------------]]
local function preparing_override( ply, ent, data )
	if ROUND.preparing then
		return false
	end
end

local function class_check_and_close( class )
	return function( ply, ent, data )
		if ply:SCPClass() == CLASSES[class] and !GetRoundProperty( "privilege_used_"..class ) then
			SetRoundProperty( "privilege_used_"..class, true )

			ent.NextSLCUse = CurTime() + 5.5

			AddTimer( "scp_privilege_"..class.."_"..ply:EntIndex(), 5, 1, function()
				ent:Fire( "use" )
			end )

			return true, true
		end
	end
end

BUTTONS = {
	/*
	{
		name = "",
		pos = Vector(  ),
		access = ACCESS_,
	},
	*/

	--misc--
	{
		name = "LCZ Underground",
		pos = Vector( 2313.00, -2072.00, -715.00 ),
		suppress_texts = true,
		fuse_box = { "lcz_underground_1", "lcz_underground_2" }
	},
	{
		name = "SCP 049 Door",
		ent_name = "049_hall_button",
		suppress_texts = true,
		fuse_box = "hcz_049_door"
	},
	{
		name = "EZ Check Point Room",
		pos = Vector( 792.00, 3977.00, 53.00 ),
		suppress_texts = true,
		fuse_box = "ez_cp_room"
	},
	{
		name = "HCZ SCP-682 Passage",
		pos = Vector( 2696.00, 2999.00, 53.00 ),
		suppress_texts = true,
		fuse_box = "hcz_682_passage"
	},
	{
		name = "D Cells Control",
		pos = Vector( -2239.00, 1832.00, 181.00 ),
		access = ACCESS_OFFICE,
	},
	{
		name = "Armory",
		pos = Vector( 1801.00, -1432.00, 53.00 ),
		access = ACCESS_ARMORY,
	},
	{
		name = "Glass Room",
		pos = Vector( 1393.00, 728.00, 53.00 ),
		access = ACCESS_GENERAL,
	},
	{
		name = "Checkpoint room LCZ_1",
		pos = Vector( 2968.00, 273.00, 53.00 ),
		access = ACCESS_CHECKPOINT_LCZ,
	},
	{
		name = "Checkpoint room LCZ_2",
		pos = Vector( 2616.00, 641.00, 53.00 ),
		access = ACCESS_CHECKPOINT_LCZ,
	},
	{
		name = "Checkpoint room EZ",
		pos = Vector( 1688.00, 4113.00, 53.00 ),
		access = ACCESS_CHECKPOINT_EZ,
	},
	{
		name = "Portla Observation #1",
		pos = Vector( 1673.00, 2055.989990, 53.00 ),
		access = ACCESS_GENERAL,
	},
	{
		name = "Portla Observation #2",
		pos = Vector( 1289.00, 2055.989990, 53.00 ),
		access = ACCESS_GENERAL,
	},
	{
		name = "Office 1",
		pos = Vector( 1297.00, 3047.989990, 117.00 ),
		access = ACCESS_OFFICE,
	},
	{
		name = "Office 2",
		pos = Vector( -936.00, 2465.00, 53.00 ),
		access = ACCESS_OFFICE,
	},
	{
		name = "Office 3",
		pos = Vector( -1288.00, 2465.00, 53.00 ),
		access = ACCESS_OFFICE,
	},
	{
		name = "MedBay",
		pos = Vector( -1928.00, 3551.00, 53.00 ),
		access = ACCESS_MEDBAY,
	},
	{
		name = "Electrical Center",
		pos = Vector( -2328.00, 3775.00, 53.00 ),
		access = ACCESS_EC,
		override = preparing_override,
	},
	{
		name = "Particle Cannon",
		pos = Vector( 3676.00, 2156.00, 59.00 ),
		access = ACCESS_PARTICLE,
		advanced_overload = true,
		overload_delay = 0,
	},
	{
		name = "Gate A",
		pos = Vector( -321.00, 4784.00, 53.00 ),
		access = ACCESS_GATE_A,
		omega_disable = true,
		disable_overload = true,
	},
	{
		name = "Gate B",
		pos = Vector( -3790.50, 2472.50, 53.00 ),
		access = ACCESS_GATE_B,
		disable_overload = true,
		fuse_box = "gate_b_1",
	},
	{
		name = "SCP-008 Observation",
		pos = Vector( 2441.00, 1576.00, 53.00 ),
		access = ACCESS_GENERAL,
	},
	{
		name = "Facility Exit",
		pos = Vector( -6655.00, -664.00, 2293.00 ),
		access = ACCESS_GENERAL,
	},

	--Checkpoints--
	{
		name = "Checkpoint LCZ1",
		pos = Vector( 2816.00, -192.00, 53.00 ),
		access = ACCESS_CHECKPOINT_LCZ,
		decon_override = ZONE_LCZ,
		omega_override = true,
		overload_delay = 0,
		override = preparing_override,
	},
	{
		name = "Checkpoint LCZ2",
		pos = Vector( 2816.00, 1088.00, 53.00 ),
		access = ACCESS_CHECKPOINT_LCZ,
		decon_override = ZONE_LCZ,
		omega_override = true,
		overload_delay = 0,
		override = preparing_override,
	},
	{
		name = "Checkpoint EZ1",
		pos = Vector( 1536.00, 3648.00, 53.00 ),
		access = ACCESS_CHECKPOINT_EZ,
		decon_override = ZONE_HCZ,
		omega_override = true,
		overload_delay = 0,
		override = preparing_override,
	},
	{
		name = "Checkpoint EZ2",
		pos = Vector( 2176.00, 2368.00, 53.00 ),
		access = ACCESS_CHECKPOINT_EZ,
		decon_override = ZONE_HCZ,
		omega_override = true,
		overload_delay = 0,
		override = preparing_override,
	},

	--SCPs--
	--safe
	{
		name = "SCP-914",
		pos = Vector( 1264.00, -958.50, 53.00 ),
		access = ACCESS_SAFE,
		advanced_overload = true,
	},
	{
		name = "SCP-1123",
		pos = Vector( 737.00, -1240.00, 53.00 ),
		access = ACCESS_SAFE,
	},
	{
		name = "SCP-714",
		pos = Vector( 2225.00, 920.00, 53.00 ),
		access = ACCESS_SAFE,
	},
	{
		name = "SCP-860-1025",
		pos = Vector( 2072.00, 1185.00, 53.00 ),
		access = ACCESS_SAFE,
	},
	{
		name = "SCP-860",
		pos = Vector( 2017.00, 1336.00, 53.00 ),
		access = ACCESS_SAFE,
	},
	{
		name = "SCP-1025",
		pos = Vector( 2225.00, 1336.00, 53.00 ),
		access = ACCESS_SAFE,
	},
	{
		name = "Forest #1",
		pos = Vector( 1673.00, 2216.00, 53.00 ),
		access = ACCESS_SAFE,
		override = class_check_and_close( "SCP8602" ),
	},
	{
		name = "Forset #2",
		pos = Vector( 1289.00, 2216.00, 53.00 ),
		access = ACCESS_SAFE,
		override = class_check_and_close( "SCP8602" ),
	},

	--euclid
	{
		name = "SCP-096",
		pos = Vector( 4993.00, 3432.00, 53.00 ),
		access = ACCESS_EUCLID,
		override = class_check_and_close( "SCP096" )
	},
	{
		name = "SCP-173",
		pos = Vector( 193.00, 1768.00, 309.00 ),
		access = ACCESS_EUCLID,
		override = preparing_override
	},
	{
		name = "SCP-012",
		pos = Vector( -527.00, -344.00, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-372",
		pos = Vector( -944.00, -705.50, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-205",
		pos = Vector( 3096.01001, -1519.00, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-178",
		pos = Vector( 393.00, -152.00, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-1162",
		pos = Vector( 1569.00, 892.00, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-895",
		pos = Vector( 5440.50, 360.00, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-079",
		pos = Vector( 3723.50, -1162.00, -75.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-513",
		pos = Vector( 3896.00, 3745.00, 53.00 ),
		access = ACCESS_EUCLID,
	},
	{
		name = "SCP-008",
		pos = Vector( 2441.00, 1896.00, 53.00 ),
		access = ACCESS_EUCLID,
	},

	--keter
	{
		name = "SCP-035",
		pos = Vector( 5336.00, -639.00, 53.00 ),
		access = ACCESS_KETER,
	},
	{
		name = "SCP-106",
		pos = Vector( 2200.00, 4145.00, 53.00 ),
		access = ACCESS_KETER,
	},
	{
		name = "SCP-682",
		pos = Vector( 2344.00, 3201.00, -331.00 ),
		access = ACCESS_KETER,
	},

	--special--
	--scps
	{
		name = "SCP-106",
		pos = Vector( 2280.00, 3959.00, 53.00 ),
		override = preparing_override,
		msg_access = "",
	},
	{
		name = "SCP-457",
		pos = Vector( 6208.00, -144.00, 53.00 ),
		override = preparing_override,
		msg_access = "",
	},

	--scp 914
	{
		name = "SCP-914 Upgrade",
		ent_id = 2197,
		override = function( ply, ent, data )
			return SCP914Use( ply )
		end,
		suppress_texts = true,
		scp_disallow = true,
	},
	{
		name = "SCP-914 Mode",
		pos = Vector( 1563.00, -832.00, 62.00 ),
		override = function( ply, ent, data )
			return !GetRoundProperty( "scp914_in_use" )
		end,
		suppress_texts = true,
		scp_disallow = true,
		cooldown = 1,
	},

	--scp 106 recontamination
	{
		name = "Femur Breaker",
		pos = Vector( 2176.00, 5244.50, -201.00 ),
		access = ACCESS_FEMUR,
		access_granted = function( ply, ent, data )
			return !Recontain106( ply )
		end,
		msg_access = "femur_act",
		msg_deny = "",
		msg_omnitool = "device_noomni",
		disable_overload = true,
		fuse_box = "scp106_recontain"
	},
	{
		name = "ELO-IID",
		pos = Vector( 2048.000000, 5244.009766, -202.139999 ),
		override = function( pl, ent, data )
			return !GetRoundStat( "106recontain" )
		end,
		suppress_texts = true,
		scp_disallow = true,
	},
	{
		name = "Sound Transmission",
		pos = Vector( 2088.000000, 5243.990234, -201.860001 ),
		override = function( pl, ent, data )
			return !GetRoundStat( "106recontain" )
		end,
		suppress_texts = true,
		scp_disallow = true,
	},

	--warheads
	{
		name = "OMEGA Warhead Detonation",
		pos = Vector( -2317.50, 6476.50, 3137.00 ),
		disabled = true,
	},
	{
		name = "Evacuation Shelter",
		pos = Vector( 195.679993, -1387.290039, -75.00 ),
		disabled = true,
	},

	--gas
	{
		name = "Gas",
		pos = Vector( 2344.010010, -2031.00, 53.00 ),
		suppress_check = true,
		cooldown = 10,
	},

	--lockdown
	{
		name = "Lockdown Lever",
		ent_id = 3529,
		disabled = true,
	},
	{
		name = "Facility Lockdown",
		pos = Vector( -2451.989990, 4120.00, 310.25 ),
		scp_disallow = true,
		suppress_texts = true,
		override = function( ply, ent, data )
			local status = InitiateLockdown( ply, ent, function()
				if IsValid( ent ) then
					ent:Fire( "PressOut" )
					ent:Fire( "Lock" )
				end

				local relay = CacheEntity( "relay_lockdown_off" )
				if IsValid( relay ) then
					relay:Fire( "Trigger" )
				end

				return true
			end )

			if status then
				ent:Fire( "PressIn" )
			end

			return false //InitiateLockdown( ply, ent )
		end
	},

	--tesla
	{
		name = "Tesla Lever",
		ent_id = 3528,
		disabled = true,
	},
	{
		name = "Tesla",
		pos = { Vector( -2451.989990, 4078.00, 310.25 ), Vector( -2451.979980, 4078.00, 310.50 ) },
		disabled = true,
	},

	--SCP use disallow
	{
		name = "173",
		pos = Vector( 362.00, 1592.00, 294.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "012",
		pos = Vector( -560.00, -52.00, -192.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "372",
		pos = Vector( -1056.00, -530.00, 38.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "035 door",
		pos = Vector( 5468.00, -784.00, 53.860001 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "035 gas",
		pos = Vector( 5468.00, -808.00, 54.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "966 door",
		pos = Vector( 4216.00, 2256.00, 38.00 ),
		disabled = true,
	},
	{
		name = "049 door",
		pos = Vector( 5040.00, -2376.00, 54.00 ),
		disabled = true,
	},
	{
		name = "Alpha Lever",
		pos = Vector( 3972.00, 264.00, -330.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "Omega Lever",
		pos = Vector( 3972.00, 306.00, -330.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "682 door",
		pos = Vector( 2288.00, 3396.010010, -201.139999 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "682 acid",
		pos = Vector( 2264.00, 3396.00, -201.00 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "remote",
		pos = Vector( -2452.00, 3876.00, 309.859985 ),
		scp_disallow = true,
		suppress_check = true,
	},
	{
		name = "cannon",
		pos = Vector( -29.00, 6648.00, 3138.00 ),
		scp_disallow = true,
		suppress_check = true,
	},

	--disabled
	{
		name = "Admin Room",
		ent_id = 3071,
		disabled = true,
	},
}

--[[-------------------------------------------------------------------------
Catch Inputs
---------------------------------------------------------------------------]]
if SERVER then
	local function lockdown_input( state )
		local dur = CVAR.slc_lockdown_duration:GetInt()
		if dur < 0 then return true end

		local status = GetRoundProperty( "facility_lockdown", 0 )
		if state and status != 1 then return true end
		if !state and status != 2 then return true end
	end

	hook.Add( "SLCPreround", "Site19LockdownInput", function()
		CatchInput( "relay_lockdown_on", function( ent, input, activator, caller, data )
			if input != "Trigger" then return end
			return lockdown_input( true )
		end )

		CatchInput( "relay_lockdown_off", function( ent, input, activator, caller, data )
			if input != "Trigger" then return end
			return lockdown_input( false )
		end )
	end )
end

--[[-------------------------------------------------------------------------
Button controllers
---------------------------------------------------------------------------]]
if SERVER then
	ButtonController( "Warhead Elevator", {
		access = ACCESS_WARHEAD_ELEVATOR,
		msg_omnitool = "elevator_noomni",
		buttons_set = {
			{ Vector( 4535.00, 408.00, 53.00 ), Vector( 4553.00, 492.00, -331.00 ) },
			{ Vector( 4553.00, 492.00, 53.00 ), Vector( 4535.00, 408.00, -331.00 ) },
		},
		cooldown = 15,
		initial_state = 1,
		debug_use = true,

		elevator = true,
	} )

	ButtonController( "LCZ Elevator 1", {
		buttons_set = {
			{ Vector( 792.00, -2239.00, 53.00 ), Vector( 620.00, -465.00, -715.00 ) },
			{ Vector( 876.00, -2257.00, 53.00 ), Vector( 533.00, -447.00, -715.00 ) },
		},
		suppress_texts = true,
		cooldown = 15,
		initial_state = 1,
		debug_use = true,
		disable_overload = true,

		elevator = true,
	} )

	ButtonController( "LCZ Elevator 2", {
		buttons_set = {
			{ Vector( 872.00, 415.00, 53.00 ), Vector( 2452.00, 145.00, -715.00 ) },
			{ Vector( 788.00, 433.00, 53.00 ), Vector( 2537.00, 127.00, -715.00 ) },
		},
		suppress_texts = true,
		cooldown = 15,
		initial_state = 1,
		debug_use = true,
		disable_overload = true,
		
		elevator = true,
	} )

	ButtonController( "HCZ Elevator 1", {
		buttons_set = {
			{ Vector( 4648.00, -97.00, 53.00 ), Vector( 4564.00, -1503.00, 69.00 ) },
			{ Vector( 4564.00, -79.00, 53.00 ), Vector( 4664.00, -1533.00, 69.00 ) },
		},
		suppress_texts = true,
		cooldown = 15,
		initial_state = 1,
		debug_use = true,
		disable_overload = true,
		
		elevator = true,
	} )

	ButtonController( "HCZ Elevator 2", {
		buttons_set = {
			{ Vector( 4952.00, -287.00, 53.00 ), Vector( 5036.00, -1729.00, 69.00 ) },
			{ Vector( 5036.00, -305.00, 53.00 ), Vector( 4936.00, -1699.00, 69.00 ) },
		},
		suppress_texts = true,
		cooldown = 15,
		initial_state = 1,
		debug_use = true,
		disable_overload = true,
		
		elevator = true,
	} )

	ButtonController( "Gate A Elevator", {
		buttons_set = {
			{ Vector( -193.00, 5144.00, 53.00 ), Vector( -175.00, 5228.00, 2613.00 ) },
			{ Vector( -175.00, 5228.00, 53.00 ), Vector( -193.00, 5144.00, 2613.00 ) },
		},
		on_use = function( ply, ent, data, setid )
			if !GetRoundProperty( "gatea" ) then return end

			local id = ent:MapCreationID()
			return id == 3789 or id == 3792
		end,
		suppress_texts = true,
		cooldown = 15,
		initial_state = 1,
		debug_use = true,
		warhead_lockdown = true,
		disable_overload = true,
		
		elevator = true,
	} )

	ButtonController( "Gate B Elevator", {
		buttons_set = {
			{ Vector( -3944.00, 1921.00, 53.00 ), Vector( -3860.00, 1903.00, 2613.00 ) },
			{ Vector( -3860.00, 1903.00, 53.00 ), Vector( -3944.00, 1921.00, 2613.00 ) },
		},
		suppress_texts = true,
		cooldown = 15,
		initial_state = 1,
		debug_use = true,
		warhead_lockdown = true,
		disable_overload = true,
		
		elevator = true,
	} )
end

--[[-------------------------------------------------------------------------
Cameras
---------------------------------------------------------------------------]]
CCTV_CONFIG = {
	{
		name = "LCZ #1",
		material = Material( "slc/items/cctv/gm_site19/gm_site19_lcz.png" ),
		u_offset = 1050 / 2048,
		v_offset = 644 / 2048,
		u_size = 593 / 2048,
		v_size = 735 / 2048,
		assign = function( vec )
			return vec.z > -500 and SLCZones.IsInZone( vec, ZONE_LCZ )
		end
	},
	{
		name = "LCZ #2",
		material = Material( "slc/items/cctv/gm_site19/gm_site19_under.png" ),
		u_offset = 1175 / 2048,
		v_offset = 594 / 2048,
		u_size = 512 / 2048,
		v_size = 512 / 2048,
		assign = function( vec )
			return vec.z <= -500 and SLCZones.IsInZone( vec, ZONE_LCZ )
		end
	},
	{
		name = "HCZ",
		material = Material( "slc/items/cctv/gm_site19/gm_site19_hcz.png" ),
		u_offset = 663 / 2048,
		v_offset = 251 / 2048,
		u_size = 1024 / 2048,
		v_size = 620 / 2048,
		assign = function( vec )
			return SLCZones.IsInZone( vec, ZONE_HCZ )
		end
	},
	{
		name = "EZ",
		material = Material( "slc/items/cctv/gm_site19/gm_site19_ez.png" ),
		u_offset = 646 / 2048,
		v_offset = 767 / 2048,
		u_size = 475 / 2048,
		v_size = 786 / 2048,
		assign = function( vec )
			return SLCZones.IsInZone( vec, ZONE_EZ )
		end
	},
	{
		name = "Surface",
		material = Material( "slc/items/cctv/gm_site19/gm_site19_surf.png" ),
		u_offset = 371 / 2048,
		v_offset = 943 / 2048,
		u_size = 1095 / 2048,
		v_size = 1041 / 2048,
		assign = function( vec )
			return SLCZones.IsInZone( vec, ZONE_SURFACE )
		end
	},
}

CCTV = {
	{
		name = "Class D - Control Room",
		pos = Vector( -2545.00, 1843.00, 245.00 ),
		ang = Angle( 29.00, -47.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Class D #1",
		pos = Vector( -648.00, 1847.00, 246.00 ),
		ang = Angle( 25.00, -162.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Class D #2",
		pos = Vector( -655.00, 135.00, 342.00 ),
		ang = Angle( 28.00, 150.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-173",
		pos = Vector( 823.00, 1161.00, 377.00 ),
		ang = Angle( 39.00, 135.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "LCZ #1",
		pos = Vector( -443.00, -978.00, 242.00 ),
		ang = Angle( 48.00, 90.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Blast Shelter",
		pos = Vector( 452.00, -1904.00, 22.00 ),
		ang = Angle( 16.00, 131.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-914",
		pos = Vector( 1406.00, -928.00, 219.00 ),
		ang = Angle( 51.00, 29.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "LCZ - Airlock",
		pos = Vector( 2407.00, -2413.00, 118.00 ),
		ang = Angle( 31.00, 134.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Armory",
		pos = Vector( 1248.00, -1555.00, 118.00 ),
		ang = Angle( 32.00, -1.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "LCZ #2",
		pos = Vector( 2044.00, 107.00, 247.00 ),
		ang = Angle( 45.00, -59.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "LCZ #3",
		pos = Vector( 1402.00, 1156.00, 248.00 ),
		ang = Angle( 47.00, -41.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Basement #1",
		pos = Vector( 528.00, 238.00, -646.00 ),
		ang = Angle( 22.00, -44.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Basement #2",
		pos = Vector( 909.00, -1073.00, -644.00 ),
		ang = Angle( 14.00, 53.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Basement #3",
		pos = Vector( 1795.00, -2126.00, -657.00 ),
		ang = Angle( 20.00, 45.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Basement #4",
		pos = Vector( 2529.00, -1081.00, -650.00 ),
		ang = Angle( 26.00, 132.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "LCZ-HCZ #1",
		pos = Vector( 3180.00, -193.00, 242.00 ),
		ang = Angle( 45.00, -180.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "LCZ-HCZ #2",
		pos = Vector( 3180.00, 1087.00, 242.00 ),
		ang = Angle( 45.00, -180.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-079",
		pos = Vector( 3799.00, -1139.00, -5.00 ),
		ang = Angle( 31.00, 116.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "HCZ #1",
		pos = Vector( 5555.00, -79.00, 252.00 ),
		ang = Angle( 53.00, -132.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Warhead",
		pos = Vector( 4068.00, 173.00, -268.00 ),
		ang = Angle( 30.00, 115.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "HCZ #2",
		pos = Vector( 4160.00, 1087.00, 244.00 ),
		ang = Angle( 89.00, 90.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-966",
		pos = Vector( 4273.00, 2481.00, 151.00 ),
		ang = Angle( 47.00, -138.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "HCZ #3",
		pos = Vector( 4503.00, 3305.00, 123.00 ),
		ang = Angle( 29.00, -44.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "CCTV #4",
		pos = Vector( 3176.00, 2073.00, 121.00 ),
		ang = Angle( 16.00, 140.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-106 #1",
		pos = Vector( 2879.00, 4035.00, 232.00 ),
		ang = Angle( 38.00, 131.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-106 #2",
		pos = Vector( 2299.00, 5012.00, -144.00 ),
		ang = Angle( 28.00, 137.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-682",
		pos = Vector( 2310.00, 3609.00, -136.00 ),
		ang = Angle( 28.00, -129.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "SCP-049",
		pos = Vector( 4559.00, -2365.00, 155.00 ),
		ang = Angle( 33.00, 40.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "EZ-HCZ #1",
		pos = Vector( 1898.00, 3648.00, 242.00 ),
		ang = Angle( 45.00, 180.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "EZ-HCZ #2",
		pos = Vector( 2538.00, 2368.00, 242.00 ),
		ang = Angle( 45.00, 180.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "EZ #1",
		pos = Vector( 947.00, 2189.00, 120.00 ),
		ang = Angle( 26.00, 132.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Cafeteria",
		pos = Vector( -97.00, 3101.00, 123.00 ),
		ang = Angle( 30.00, 47.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "EZ #2",
		pos = Vector( -793.00, 3951.00, 112.00 ),
		ang = Angle( 24.00, -135.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Gate A",
		pos = Vector( -692.00, 5349.00, 247.00 ),
		ang = Angle( 37.00, -44.00, 0.00 ),
		destroy_omega = true,
		destroy_gatea = true,
	},
	{
		name = "EZ #3",
		pos = Vector( -1439.00, 2853.00, 232.00 ),
		ang = Angle( 34.00, -133.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "EZ #4",
		pos = Vector( -2284.00, 3348.00, 113.00 ),
		ang = Angle( 31.00, 133.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Electrical Center",
		pos = Vector( -2576.00, 3966.00, 375.00 ),
		ang = Angle( 30.00, 8.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "EZ #5",
		pos = Vector( -3750.00, 3115.00, 115.00 ),
		ang = Angle( 28.00, -56.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Gate B",
		pos = Vector( -3952.00, 2293.00, 238.00 ),
		ang = Angle( 36.00, -27.00, 0.00 ),
		destroy_omega = true,
	},
	{
		name = "Gate A",
		pos = Vector( -1076.00, 5068.00, 2798.00 ),
		ang = Angle( 27.00, 45.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Surface #1",
		pos = Vector( -777.00, 6911.00, 2523.00 ),
		ang = Angle( 20.00, 179.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Surface #2",
		pos = Vector( -2514.00, 7144.00, 3232.00 ),
		ang = Angle( 36.00, -33.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Tunnel #1",
		pos = Vector( -2974.00, 5091.00, 2458.00 ),
		ang = Angle( 20.00, -80.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Tunnel #2",
		pos = Vector( -2658.00, 1968.00, 2724.00 ),
		ang = Angle( 30.00, 133.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Tunnel #3",
		pos = Vector( -3722.00, 2521.00, 2766.00 ),
		ang = Angle( 25.00, -142.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Surface #3",
		pos = Vector( -7403.00, 1860.00, 3001.00 ),
		ang = Angle( 34.00, 32.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Exit #1",
		pos = Vector( -6527.00, -69.00, 2453.00 ),
		ang = Angle( 37.00, -128.00, 0.00 ),
		destroy_alpha = true,
	},
	{
		name = "Exit #2",
		pos = Vector( -6968.00, -536.00, 2361.00 ),
		ang = Angle( 29.00, -43.00, 0.00 ),
		destroy_alpha = true,
	},
}

for i, v in ipairs( CCTV_CONFIG ) do
	v.cams = {}

	for id, tab in ipairs( CCTV ) do
		if v.assign( tab.pos ) then
			table.insert( v.cams, id )
		end
	end
end