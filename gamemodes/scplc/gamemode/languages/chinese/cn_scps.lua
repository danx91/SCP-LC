local lang = LANGUAGE
local wep = LANGUAGE.WEAPONS

--[[-------------------------------------------------------------------------
SCPs
---------------------------------------------------------------------------]]
lang.GenericUpgrades = {
	outside_buff = {
		name = "重见天日",
		info = "在地面上时获得被动治疗,与剩余时间正比\n在逃脱时获得极高伤害保护"
	}
}

wep.SCP023 = {  
	skills = {  
		_overview = { "被动", "汲取", "克隆", "猎杀" },  
		drain = {  
			name = "体力汲取",  
			dsc = "开始从附近的玩家身上汲取体力。如果所有玩家都离开该区域，该能力会立即进入冷却时间",  
		},  
		clone = {  
			name = "克隆",  
			dsc = "放置一个克隆体，它会模仿你的被动技能（包括升级效果）的工作。克隆体会四处游荡并追逐附近的玩家",  
		},  
		hunt = {  
			name = "猎杀",  
			dsc = "立即杀死你的一个猎物或他们附近的人，并传送到他们的尸体处",  
		},  
		passive = {  
			name = "被动",  
			dsc = "与玩家碰撞会点燃他们",  
		},  
		drain_bar = {  
			name = "汲取",  
			dsc = "汲取能力的剩余时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive = {  
			name = "炽热余烬",  
			info = "升级你的被动技能，增加燃烧伤害[+burn_power]",  
		},  
		invis1 = {  
			name = "隐形火焰I",  
			info = "增强你的被动技能\n\t• 远离你的玩家将看不见你\n\t• 看不见你的玩家不会被添加到猎杀目标中\n\t• 此升级同样适用于你的克隆体\n\t• 在[invis_range]单位距离外你会完全隐形",  
		},  
		invis2 = {  
			name = "隐形火焰II",  
			info = "升级你的隐形能力\n\t• 在[invis_range]单位距离外你会完全隐形",  
		},  
		prot1 = {  
			name = "不死之火I",  
			info = "通过提供[-prot]的子弹伤害防护来增强你的被动技能",  
		},  
		prot2 = {  
			name = "不死之火II",  
			info = "将你对子弹的防护升级到[-prot]",  
		},  
		drain1 = {  
			name = "能量汲取I",  
			info = "升级你的汲取能力\n\t• 持续时间增加[+drain_dur]\n\t• 最大距离增加[+drain_dist]",  
		},  
		drain2 = {  
			name = "能量汲取II",  
			info = "升级你的汲取能力\n\t• 汲取速率增加[/drain_rate]\n\t• 从汲取的体力中恢复[%drain_heal]的生命值",  
		},  
		drain3 = {  
			name = "能量汲取III",  
			info = "升级你的汲取能力\n\t• 持续时间增加[+drain_dur]\n\t• 最大距离增加[+drain_dist]",  
		},  
		drain4 = {  
			name = "能量汲取IV",  
			info = "升级你的汲取能力\n\t• 汲取速率增加[/drain_rate]\n\t• 从汲取的体力中恢复[%drain_heal]的生命值",  
		},  
		hunt1 = {  
			name = "无尽火焰I",  
			info = "增强你的猎杀能力\n\t• 冷却时间减少[-hunt_cd]",  
		},  
		hunt2 = {  
			name = "无尽火焰II",  
			info = "增强你的猎杀能力\n\t• 冷却时间减少[-hunt_cd]\n\t• 随机猎物搜索半径增加[+hunt_range]",  
		},  
	}  
}
wep.SCP049 = {  
    -- 僵尸类型  
    zombies = {  
        normal = "普通僵尸",  
        assassin = "刺客僵尸",  
        boomer = "爆炸僵尸",  
        heavy = "吐痰僵尸",  
    },  
    -- 僵尸描述  
    zombies_desc = {  
        normal = "一种标准僵尸\n\t• 拥有轻攻击和重攻击\n\t• 属性均衡，是不错的选择",  
        assassin = "一种刺客僵尸\n\t• 拥有轻攻击和快速攻击能力\n\t• 速度最快，但生命值和伤害最低",  
        boomer = "一种爆炸型重型僵尸\n\t• 拥有重攻击和爆炸能力\n\t• 移动速度最慢，但拥有高生命值和最高伤害",  
        heavy = "一种吐痰型重型僵尸\n\t• 拥有重攻击和射击能力\n\t• 速度最慢的僵尸类型，但拥有高伤害和最多的生命值",  
    },  
    -- 技能  
    skills = {  
        _overview = { "passive", "choke", "surgery", "boost" },  
        surgery_failed = "手术失败！",  
  
        choke = {  
            name = "医生的触摸",  
            dsc = "扼喉致死。此技能在受到足够伤害时可以被打断",  
        },  
        surgery = {  
            name = "手术",  
            dsc = "对尸体进行手术，将其转变为SCP-049-2实例。受到伤害会打断手术",  
        },  
        boost = {  
            name = "复苏！",  
            dsc = "为你和所有附近的SCP-049-2实例提供强化",  
        },  
        passive = {  
            name = "被动",  
            dsc = "附近的僵尸获得子弹伤害保护",  
        },  
        choke_bar = {  
            name = "医生的触摸",  
            dsc = "满值时，目标死亡",  
        },  
        surgery_bar = {  
            name = "手术",  
            dsc = "手术的剩余时间",  
        },  
        boost_bar = {  
            name = "复苏！",  
            dsc = "强化的剩余时间",  
        },  
    },  
  
    -- 升级  
    upgrades = {  
        parse_description = true,  
  
        choke1 = {  
            name = "医生的触摸 I",  
            info = "升级你的扼喉能力\n\t• 冷却时间减少[-choke_cd]\n\t• 伤害阈值增加[+choke_dmg]",  
        },  
        choke2 = {  
            name = "医生的触摸 II",  
            info = "升级你的扼喉能力\n\t• 扼喉速度增加[+choke_rate]\n\t• 扼喉后的减速效果减少[-choke_slow]",  
        },  
        choke3 = {  
            name = "医生的触摸 III",  
            info = "升级你的扼喉能力\n\t• 冷却时间减少[-choke_cd]\n\t• 伤害阈值增加[+choke_dmg]\n\t• 扼喉速度增加[+choke_rate]",  
        },  
        buff1 = {  
            name = "复苏 I",  
            info = "升级你的强化能力\n\t• 冷却时间减少[-buff_cd]\n\t• 强化持续时间增加[+buff_dur]",  
        },  
        buff2 = {  
            name = "复苏 II",  
            info = "升级你的强化能力\n\t• 强化范围增加[+buff_radius]\n\t• 强化威力增加[+buff_power]",  
        },  
        surgery_cd1 = {  
            name = "精准手术 I",  
            info = "手术时间减少[surgery_time]秒\n\t• 此升级可叠加",  
        },  
        surgery_cd2 = {  
            name = "精准手术 II",  
            info = "手术时间减少[surgery_time]秒\n\t• 此升级可叠加",  
        },  
        surgery_heal = {  
            name = "移植",  
            info = "升级你的手术能力\n\t• 手术后，你恢复[surgery_heal]点生命值\n\t• 手术后，所有附近的僵尸恢复[surgery_zombie_heal]点生命值",  
        },  
        surgery_dmg = {  
            name = "无法阻挡的手术",  
            info = "受到伤害不再打断手术",  
        },  
        surgery_prot = {  
            name = "稳健之手",  
            info = "手术期间获得[-surgery_prot]的子弹保护",  
        },  
        zombie_prot = {  
            name = "护士",  
            info = "每个附近的SCP-049-2为你提供子弹伤害保护\n\t• 每个附近僵尸提供的保护：[%zombie_prot]\n\t• 最大保护：[%zombie_prot_max]",  
        },  
        zombie_lifesteal = {  
            name = "输血 I",  
            info = "僵尸的普通攻击获得[%zombie_ls]的生命偷取",  
        },  
        stacks_hp = {  
            name = "类固醇注射",  
            info = "创建僵尸时，其生命值根据\n先前的手术次数增加[%stacks_hp]",  
        },  
        stacks_dmg = {  
            name = "激进疗法",  
            info = "创建僵尸时，其伤害根据\n先前的手术次数增加[%stacks_dmg]",  
        },  
        zombie_heal = {  
            name = "输血 II",  
            info = "你从附近僵尸造成的任何伤害中\n恢复[%zombie_heal]的生命值",  
        }  
    }  
}

wep.SCP0492 = {  
    skills = {  
        prot = {  
            name = "防护",  
            dsc = "靠近SCP-049时，你将获得一定的伤害防护",  
        },  
        boost = {  
            name = "增益",  
            dsc = "指示SCP-049的增益效果是否在你身上激活",  
        },  
        light_attack = {  
            name = "轻攻击",  
            dsc = "执行轻攻击",  
        },  
        heavy_attack = {  
            name = "重攻击",  
            dsc = "执行重攻击",  
        },  
        rapid = {  
            name = "速攻",  
            dsc = "执行快速攻击",  
        },  
        shot = {  
            name = "射击",  
            dsc = "发射伤害性投射物",  
        },  
        explode = {  
            name = "自爆",  
            dsc = "当你有50点或更少的生命值时激活。你将变得无法被杀死并获得速度增益。短暂时间后，你将爆炸，对小范围内造成伤害",  
        },  
        boost_bar = {  
            name = "增益条",  
            dsc = "剩余的增益时间",  
        },  
        explode_bar = {  
            name = "自爆条",  
            dsc = "剩余的自爆时间",  
        },  
    },  
  
    upgrades = {  
        parse_description = true,  
  
        primary1 = {  
            name = "主攻击I",  
            info = "升级你的主攻击\n\t• 冷却时间减少[-primary_cd]",  
        },  
        primary2 = {  
            name = "主攻击II",  
            info = "升级你的主攻击\n\t• 冷却时间减少[-primary_cd]\n\t• 伤害增加[+primary_dmg]",  
        },  
        secondary1 = {  
            name = "次攻击I",  
            info = "升级你的次攻击\n\t• 伤害增加[+secondary_dmg]",  
        },  
        secondary2 = {  
            name = "次攻击II",  
            info = "升级你的次攻击\n\t• 伤害增加[+secondary_dmg]\n\t• 冷却时间减少[-secondary_cd]",  
        },  
        overload = {  
            name = "过载",  
            info = "额外获得[overloads]次按钮过载",  
        },  
        buff = {  
            name = "崛起！",  
            info = "增强你的防护和SCP-049的增益\n\t• 防护力量：[%+prot_power]\n\t• 增益力量：[++buff_power]",  
        },  
    }  
}
wep.SCP058 = {  
    -- 技能集合  
    skills = {  
        _overview = { "primary_attack", "shot", "explosion" }, -- 技能概览，包括主攻击、射击和爆炸  
          
        primary_attack = {  
            name = "主攻击",  
            dsc = "使用前方的蜇刺进行攻击。\n如果购买了相应的升级，将附加中毒效果",  
        },  
          
        shot = {  
            name = "射击",  
            dsc = "向瞄准方向发射投射物。投射物将沿弹道曲线移动。\n与射击相关的升级会影响此技能的冷却时间、速度、大小和效果",  
        },  
          
        explosion = {  
            name = "爆炸",  
            dsc = "释放一股被腐蚀的血液，对附近的目标造成大量伤害",  
        },  
          
        shot_stacks = {  
            name = "射击堆叠",  
            dsc = "显示存储的射击数量。各种与射击相关的升级会影响最大数量和冷却时间",  
        },  
    },  
  
    -- 升级集合  
    upgrades = {  
        parse_description = true, -- 是否解析描述信息  
  
        -- 攻击升级  
        attack1 = {  
            name = "毒刺I",  
            info = "为主攻击添加中毒效果",  
        },  
          
        attack2 = {  
            name = "毒刺II",  
            info = "增强攻击伤害、中毒伤害并减少冷却时间\n\t• 攻击伤害增加[prim_dmg]\n\t• 攻击中毒伤害为[pp_dmg]\n\t• 冷却时间减少[prim_cd]秒",  
        },  
          
        attack3 = {  
            name = "毒刺III",  
            info = "增强中毒伤害并减少冷却时间\n\t• 如果目标未中毒，立即施加2层中毒效果\n\t• 攻击中毒伤害为[pp_dmg]\n\t• 冷却时间减少[prim_cd]秒",  
        },  
          
        -- 射击升级  
        shot = {  
            name = "腐血射击",  
            info = "为射击攻击添加中毒效果",  
        },  
          
        shot11 = {  
            name = "激增I",  
            info = "增加伤害和投射物大小\n但也会增加冷却时间并减慢投射物速度\n\t• 投射物伤害增加[+shot_damage]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化[++shot_speed]\n\t• 冷却时间增加[shot_cd]秒",  
        },  
		shot12 = {  
			name = "激流II",  
			info = "增加伤害和投射物大小\n但也会增加冷却时间并减慢投射物速度\n\t• 投射物伤害增加：[+shot_damage]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化：[++shot_speed]\n\t• 冷却时间增加：[shot_cd]秒"  
		}, 
          
        shot21 = {  
            name = "血雾I",  
            info = "射击在撞击时留下迷雾，伤害并中毒接触到的所有人。\n\t• 移除直接伤害和溅射伤害\n\t• 迷雾接触时造成[cloud_damage]伤害\n\t• 迷雾造成的中毒伤害为[sp_dmg]\n\t• 射击堆叠限制为[stacks]\n\t• 冷却时间增加[shot_cd]秒\n\t• 堆叠获取速率：[/+regen_rate]",  
        },  
          
        shot22 = {  
            name = "血雾II",  
            info = "增强射击留下的迷雾效果。\n\t• 迷雾接触时造成[cloud_damage]伤害\n\t• 迷雾造成的中毒伤害为[sp_dmg]\n\t• 堆叠获取速率：[/+regen_rate]",  
        },  
          
        shot31 = {  
            name = "连射I",  
            info = "按住攻击按钮时，可以迅速射击\n\t• 解锁快速射击能力\n\t• 移除直接伤害和溅射伤害\n\t• 射击堆叠限制为[stacks]\n\t• 堆叠获取速率：[/+regen_rate]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化[++shot_speed]",  
        },  
          
        shot32 = {  
            name = "连射II",  
            info = "增加最大堆叠数量和射击速度\n\t• 射击堆叠限制为[stacks]\n\t• 堆叠获取速率：[/+regen_rate]\n\t• 投射物大小变化[++shot_size]\n\t• 投射物速度变化[++shot_speed]",  
        },  
          
        -- 爆炸升级  
        exp1 = {  
            name = "主动脉爆裂",  
            info = "解锁爆炸能力\n对附近目标造成大量伤害。\n当生命值首次降至每个1000HP的倍数以下时\n此能力激活。如果购买时生命值已低于1000HP\n则首次受到伤害时激活此能力\n之前的阈值无法再达到（即使通过治疗）",  
        },  
          
        exp2 = {  
            name = "毒爆",  
            info = "增强你的爆炸能力\n\t• 施加2层中毒效果\n\t• 爆炸半径增加[+explosion_radius]",  
        },  
    }  
}

-- wep.SCP066配置  
wep.SCP066 = {  
	-- 技能集合  
	skills = {  
		_overview = { "埃里克", "音乐", "冲刺", "增益" }, -- 技能概览，包括eric、music、dash和boost四个技能  
		not_threatened = "你并未感到足够的威胁来发动攻击！", -- 当未受到足够威胁时的提示  
  
		-- 发出大声音乐的技能  
		music = {  
			name = "第二交响曲",  
			dsc = "当你感到威胁时，可以发出大声的音乐。", -- 技能描述  
		},  
		-- 冲刺技能  
		dash = {  
			name = "冲刺",  
			dsc = "向前冲刺。如果击中玩家，你会短暂地附着在他们身上。", -- 技能描述  
		},  
		-- 增益技能  
		boost = {  
			name = "增益",  
			dsc = "获得当前激活的三个增益效果中的一个。使用后，它将被下一个增益效果替换。每个被动叠加层都会增加所有增益效果的威力（最多可叠加[cap]层）。\n\n当前增益：[boost]\n\n速度增益：[speed]\n子弹防御增益：[def]\n再生增益：[regen]", -- 技能描述，包含多个增益效果和它们的当前状态  
			buffs = { -- 增益效果的列表  
				"速度",  
				"子弹防御",  
				"再生",  
			},  
		},  
		-- 询问玩家是否为Eric的技能  
		eric = {  
			name = "Eric？",  
			dsc = "你问未携带武器的玩家他们是否是Eric。每次询问都会获得一个被动叠加层。", -- 技能描述  
		},  
		-- 音乐技能的持续时间条  
		music_bar = {  
			name = "第二交响曲",  
			dsc = "此技能的剩余时间。", -- 技能条描述  
		},  
		-- 冲刺技能的附着时间条  
		dash_bar = {  
			name = "附着时间",  
			dsc = "附着到目标上的剩余时间。", -- 技能条描述  
		},  
		-- 增益技能的持续时间条  
		boost_bar = {  
			name = "增益",  
			dsc = "此技能的剩余时间。", -- 技能条描述  
		},  
	},  
  
	-- 升级集合  
	upgrades = {  
		parse_description = true, -- 是否解析描述（可能是用于动态生成描述文本）  
  
		-- Eric？技能的第一次升级  
		eric1 = {  
			name = "Eric？I",  
			info = "减少被动技能的冷却时间[-eric_cd]。", -- 升级描述  
		},  
		-- Eric？技能的第二次升级  
		eric2 = {  
			name = "Eric？II",  
			info = "减少被动技能的冷却时间[-eric_cd]。", -- 升级描述（注意：这里与eric1的描述相同，可能是个错误或遗漏，实际游戏中应有不同效果）  
		},  
		-- 第二交响曲技能的第一次升级  
		music1 = {  
			name = "第二交响曲I",  
			info = "升级你的主要攻击\n\t• 冷却时间减少[-music_cd]\n\t• 范围增加[+music_range]。", -- 升级描述  
		},  
		-- 第二交响曲技能的第二次升级  
		music2 = {  
			name = "第二交响曲II",  
			info = "升级你的主要攻击\n\t• 冷却时间减少[-music_cd]\n\t• 范围增加[+music_range]。", -- 升级描述（注意：这里与music1的描述相同，可能是个错误或遗漏，实际游戏中应有不同效果）  
		},  
		-- 第二交响曲技能的第三次升级  
		music3 = {  
			name = "第二交响曲III",  
			info = "升级你的主要攻击\n\t• 伤害增加[+music_damage]。", -- 升级描述  
		},  
		-- 冲刺技能的第一次升级  
		dash1 = {  
			name = "冲刺I",  
			info = "升级你的冲刺能力\n\t• 冷却时间减少[-dash_cd]\n\t• 你在目标上停留的时间增加[+detach_time]。", -- 升级描述  
		},  
		-- 冲刺技能的第二次升级  
		dash2 = {  
			name = "冲刺II",  
			info = "升级你的冲刺能力\n\t• 冷却时间减少[-dash_cd]\n\t• 你在目标上停留的时间增加[+detach_time]。", -- 升级描述（注意：这里与dash1的描述相同，可能是个错误或遗漏，实际游戏中应有不同效果）  
		},  
		-- 冲刺技能的第三次升级  
		dash3 = {  
			name = "冲刺III",  
			info = "升级你的冲刺能力\n\t• 当附着在目标上时，你可以再次使用此技能来跳离\n\t• 在跳离时，你可以附着到另一个玩家身上\n\t• 在单次使用此技能的过程中，你不能再次附着到同一个玩家身上。", -- 升级描述  
		},  
		-- 增益技能的第一次升级  
		boost1 = {  
			name = "增益I",  
			info = "升级你的增益能力\n\t• 冷却时间减少[-boost_cd]\n\t• 持续时间增加[+boost_dur]。", -- 升级描述  
		},  
		-- 增益技能的第二次升级  
		boost2 = {  
			name = "增益II",  
			info = "升级你的增益能力\n\t• 冷却时间减少[-boost_cd]\n\t• 威力增加[+boost_power]。", -- 升级描述  
		},  
		-- 增益技能的第三次升级  
		boost3 = {  
			name = "增益III",  
			info = "升级你的增益能力\n\t• 持续时间增加[+boost_dur]\n\t• 威力增加[+boost_power]。", -- 升级描述  
		},  
	}  
}
wep.SCP096 = {  
	skills = {  
		_overview = { "passive", "lunge", "regen", "special" },
		lunge = {  
			name = "猛扑",  
			dsc = "在愤怒状态下向前猛扑。立即结束愤怒状态。猛扑后不会吞噬尸体",  
		},  
		regen = {  
			name = "再生",  
			dsc = "原地坐下，将再生层数转化为生命值",  
		},  
		special = {  
			name = "狩猎结束",  
			dsc = "停止愤怒状态。为每个活跃目标获得再生层数",  
		},  
		passive = {  
			name = "被动",  
			dsc = "如果有人看你，你会变得愤怒。你会立即杀死使你愤怒的玩家",  
		},  
	},  
  
	upgrades = {  
		parse_description = true, -- 解析描述，保留原样，因为这是一个编程指令，不需要翻译  
  
		rage = {  
			name = "愤怒",  
			info = "在[rage_time]秒内从单个玩家那里\n受到[rage_dmg]伤害会让你愤怒",  
		},  
		heal1 = {  
			name = "吞噬I",  
			info = "杀死目标后，吞噬目标的尸体\n并在持续时间内获得子弹防护\n\t• 每刻治疗：[heal]\n\t• 治疗刻数：[heal_ticks]\n\t• 子弹伤害防护：[-prot]",  
		},  
		heal2 = {  
			name = "吞噬II",  
			info = "升级你的吞噬能力\n\t• 每刻治疗：[heal]\n\t• 治疗刻数：[heal_ticks]\n\t• 子弹伤害防护：[-prot]",  
		},  
		multi1 = {  
			name = "无尽愤怒I",  
			info = "在首次击杀后的有限时间内\n允许你在愤怒状态下杀死多个目标\n\t• 最大目标数：[multi]\n\t• 时间限制：[multi_time]秒\n\t• 杀死第一个目标后子弹伤害增加：[+prot]",  
		},  
		multi2 = {  
			name = "无尽愤怒II",  
			info = "允许你在愤怒状态下杀死更多目标\n\t• 最大目标数：[multi]\n\t• 时间限制：[multi_time]秒\n\t• 杀死第一个目标后子弹伤害增加：[+prot]",  
		},  
		regen1 = {  
			name = "绝望之哭I",  
			info = "升级你的再生能力\n\t• 治疗增加：[+regen_mult]",  
		},  
		regen2 = {  
			name = "绝望之哭II",  
			info = "升级你的再生能力\n\t• 层数获得速率增加：[/regen_stacks]",  
		},  
		regen3 = {  
			name = "绝望之哭III",  
			info = "升级你的再生能力\n\t• 治疗增加：[+regen_mult]\n\t• 层数获得速率增加：[/regen_stacks]",  
		},  
		spec1 = {  
			name = "怜悯I",  
			info = "升级你的特殊技能并增加理智消耗\n\t• 获得更多层数：[+spec_mult]\n\t• 理智消耗：[sanity]",  
		},  
		spec2 = {  
			name = "怜悯II",  
			info = "升级你的特殊技能\n\t• 获得更多层数：[+spec_mult]\n\t• 理智消耗：[sanity]",  
		},  
	}  
}

-- SCP106 配置表  
wep.SCP106 = {  
	cancel = "按 [%s] 取消",  -- 取消操作的提示信息  
  
	skills = {  
		_overview = { "passive", "withering", "teleport", "trap" },  -- 技能概览  
		withering = {  
			name = "枯萎",  
			dsc = "对目标施加枯萎效果。枯萎会逐渐减缓目标的速度。攻击处于口袋维度内的目标会立即杀死它们\n\n效果持续时间 [dur]\n最大减速: [slow]",  
		},  
		trap = {  
			name = "陷阱",  
			dsc = "在墙上放置陷阱。当陷阱被触发时，目标会被减速，你可以再次使用这个能力立即传送到陷阱位置",  
		},  
		teleport = {  
			name = "传送",  
			dsc = "用来放置传送点。当靠近已有的传送点时，你可以选择传送目的地，释放以传送到选定位置",  
		},  
		passive = {  
			name = "牙齿收集",  
			dsc = "子弹不能杀死你，但它们可以暂时将你击倒，你还可以穿过门。\n触摸玩家会将其传送到口袋维度。每个被传送到口袋维度的玩家会给予你一个牙齿。收集的牙齿会增强你的枯萎能力",  
		},  
		teleport_cd = {  
			name = "传送",  
			dsc = "显示传送点的冷却时间",  
		},  
		passive_bar = {  
			name = "牙齿收集",  
			dsc = "当这个条达到零时，你会被击倒",  
		},  
		trap_bar = {  
			name = "陷阱",  
			dsc = "显示陷阱将保持激活状态的时间"  
		}  
	},  
  
	upgrades = {  
		parse_description = true,  -- 解析描述信息  
  
		-- 被动技能升级  
		passive1 = {  
			name = "牙齿收集 I",  
			info = "升级你的被动能力\n\t• 增加将你击倒所需的伤害量 [+passive_dmg]\n\t• 减少击倒眩晕时间 [-passive_cd]",  
		},  
		passive2 = {  
			name = "牙齿收集 II",  
			info = "升级你的被动能力\n\t• 增加将你击倒所需的伤害量 [+passive_dmg]\n\t• 对玩家造成的伤害增加 [+teleport_dmg]",  
		},  
		passive3 = {  
			name = "牙齿收集 III",  
			info = "升级你的被动能力\n\t• 增加将你击倒所需的伤害量 [+passive_dmg]\n\t• 减少击倒眩晕时间 [-passive_cd]\n\t• 对玩家造成的伤害增加 [+teleport_dmg]",  
		},  
		-- 枯萎技能升级  
		withering1 = {  
			name = "枯萎 I",  
			info = "升级你的枯萎能力\n\t• 冷却时间减少 [-attack_cd]\n\t• 效果基础持续时间增加 [+withering_dur]",  
		},  
		withering2 = {  
			name = "枯萎 II",  
			info = "升级你的枯萎能力\n\t• 冷却时间减少 [-attack_cd]\n\t• 效果基础减速增加 [+withering_slow]",  
		},  
		withering3 = {  
			name = "枯萎 III",  
			info = "升级你的枯萎能力\n\t• 冷却时间减少 [-attack_cd]\n\t• 效果基础持续时间增加 [+withering_dur]\n\t• 效果基础减速增加 [+withering_slow]",  
		},  
		-- 传送技能升级  
		tp1 = {  
			name = "传送 I",  
			info = "升级你的传送能力\n\t• 最大传送点数量增加 [spot_max]\n\t• 传送点冷却时间减少 [-spot_cd]",  
		},  
		tp2 = {  
			name = "传送 II",  
			info = "升级你的传送能力\n\t• 最大传送点数量增加 [spot_max]\n\t• 传送冷却时间减少 [-tp_cd]",  
		},  
		tp3 = {  
			name = "传送 III",  
			info = "升级你的传送能力\n\t• 最大传送点数量增加 [spot_max]\n\t• 传送点冷却时间减少 [-spot_cd]\n\t• 传送冷却时间减少 [-tp_cd]",  
		},  
		-- 陷阱技能升级  
		trap1 = {  
			name = "陷阱 I",  
			info = "升级你的陷阱能力\n\t• 陷阱冷却时间减少 [-trap_cd]\n\t• 陷阱持续时间增加 [+trap_life]",  
		},  
		trap2 = {  -- 注意：原配置中 trap2 的描述与 trap1 相同，这可能是一个错误或遗漏，实际使用中应予以修正  
			name = "陷阱 II",   
			info = "升级你的陷阱能力\n\t• 陷阱冷却时间减少 [-trap_cd]\n\t• 陷阱持续时间增加 [+trap_life]",  -- 示例信息，实际应根据游戏需求进行填写  
		},  
	
	}  
}

local scp173_prot = {  
	name = "加固混凝土",  
	info = "• 获得[%prot]的子弹伤害减免\n• 此能力与同类型的其他技能叠加",  
}  
  
wep.SCP173 = {  
	restricted = "限制使用！",  
  
	skills = {  
		_overview = { "毒气", "诱饵", "潜行" },  
		gas = {  
			name = "毒气",  
			dsc = "释放刺激性毒气云，减缓附近玩家的速度，遮挡视线并增加他们的眨眼频率",  
		},  
		decoy = {  
			name = "诱饵",  
			dsc = "放置诱饵分散玩家注意力并消耗他们的理智",  
		},  
		stealth = {  
			name = "潜行",  
			dsc = "进入潜行模式。在潜行模式下，你是隐形的，可以穿过门。此外，你变得无敌（但范围伤害如爆炸仍能对你造成伤害），但你无法对玩家造成伤害，也无法与世界互动",  
		},  
		looked_at = {  
			name = "冻结！",  
			dsc = "显示是否有人正在看你",  
		},  
		next_decoy = {  
			name = "诱饵堆叠",  
			dsc = "可用的诱饵数量",  
		},  
		stealth_bar = {  
			name = "潜行",  
			dsc = "潜行能力的剩余时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		horror_a = {  
			name = "压迫性存在",  
			info = "恐怖范围增加[+horror_dist]",  
		},  
		horror_b = {  
			name = "令人不安的存在",  
			info = "恐怖理智消耗增加[+horror_sanity]",  
		},  
		attack_a = {  
			name = "速杀者",  
			info = "击杀范围增加[+snap_dist]",  
		},  
		attack_b = {  
			name = "敏捷杀手",  
			info = "移动范围增加[+move_dist]",  
		},  
		gas1 = {  
			name = "毒气I",  
			info = "毒气范围增加[+gas_dist]",  
		},  
		gas2 = {  
			name = "毒气II",  
			info = "毒气范围增加[+gas_dist]，毒气冷却时间减少[-gas_cd]",  
		},  
		decoy1 = {  
			name = "诱饵I",  
			info = "诱饵冷却时间减少[-decoy_cd]",  
		},  
		decoy2 = {  
			name = "诱饵II",  
			info = "• 诱饵冷却时间减少至0.5秒\n• 原冷却时间适用于诱饵堆叠\n• 诱饵数量上限增加[decoy_max]。",  
		},  
		stealth1 = {  
			name = "潜行I",  
			info = "潜行冷却时间减少[-stealth_cd]",  
		},  
		stealth2 = {  
			name = "潜行II", 
			info = "• 潜行冷却时间减少[-stealth_cd]\n• 潜行持续时间增加[+stealth_dur]",  
		},  
		prot1 = scp173_prot,  
		prot2 = scp173_prot,  
		prot3 = scp173_prot,  
		prot4 = scp173_prot,  
	},  
}

wep.SCP457 = {  
	skills = {  
		_overview = { "被动技能", "火球术", "陷阱", "怒火中烧" },  
		fireball = {  
			name = "火球术",  
			dsc = "消耗：[cost]燃料\n发射一个火球，它会一直向前飞行直到碰到物体",  
		},  
		trap = {  
			name = "陷阱",  
			dsc = "消耗：[cost]燃料\n放置一个陷阱，触碰到它的玩家会被点燃",  
		},  
		ignite = {  
			name = "怒火中烧",  
			dsc = "每生成一圈火焰消耗[cost]燃料\n在你周围释放火焰波。此技能的范围无限，并且每一圈后续的火焰会消耗更多燃料。这个技能无法被打断",  
		},  
		passive = {  
			name = "被动技能",  
			dsc = "你接触到的所有人都会被点燃。点燃玩家会为你增加燃料",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "活体火炬I",  
			info = "升级你的被动技能\n\t• 火焰范围增加[+fire_radius]\n\t• 燃料获取增加[+fire_fuel]",  
		},  
		passive2 = {  
			name = "活体火炬II",  
			info = "升级你的被动技能\n\t• 火焰范围增加[+fire_radius]\n\t• 火焰伤害增加[+fire_dmg]",  
		},  
		passive3 = {  
			name = "活体火炬III",  
			info = "升级你的被动技能\n\t• 燃料获取增加[+fire_fuel]\n\t• 火焰伤害增加[+fire_dmg]",  
		},  
		passive_heal1 = {  
			name = "生命之火I",  
			info = "你从任何技能产生的火焰所造成的伤害中\n恢复[%fire_heal]的生命值",  
		},  
		passive_heal2 = {  
			name = "生命之火II",  
			info = "你从任何技能产生的火焰所造成的伤害中\n恢复[%fire_heal]的生命值",  
		},  
		fireball1 = {  
			name = "躲避球I",  
			info = "升级你的火球术技能\n\t• 冷却时间减少[-fireball_cd]\n\t• 速度增加[+fireball_speed]\n\t• 燃料消耗减少[-fireball_cost]",  
		},  
		fireball2 = {  
			name = "躲避球II",  
			info = "升级你的火球术技能\n\t• 伤害增加[+fireball_dmg]\n\t• 大小增加[+fireball_size]\n\t• 燃料消耗减少[-fireball_cost]",  
		},  
		fireball3 = {  
			name = "躲避球III",  
			info = "升级你的火球术技能\n\t• 冷却时间减少[-fireball_cd]\n\t• 伤害增加[+fireball_dmg]\n\t• 速度增加[+fireball_speed]",  
		},  
		trap1 = {  
			name = "陷阱I",  
			info = "升级你的陷阱技能\n\t• 额外陷阱数量：[trap_max]\n\t• 燃料消耗减少[-trap_cost]\n\t• 持续时间增加[+trap_time]",  
		},  
		trap2 = {  
			name = "陷阱II",  
			info = "升级你的陷阱技能\n\t• 额外陷阱数量：[trap_max]\n\t• 伤害增加[+trap_dmg]\n\t• 持续时间增加[+trap_time]",  
		},  
		trap3 = {  
			name = "陷阱III",  
			info = "升级你的陷阱技能\n\t• 燃料消耗减少[-trap_cost]\n\t• 伤害增加[+trap_dmg]\n\t• 持续时间增加[+trap_time]",  
		},  
		ignite1 = {  
			name = "怒火中烧I",  
			info = "升级你的怒火中烧技能\n\t• 波率增加[/ignite_rate]\n\t• 第一圈火焰额外生成[ignite_flames]个火焰",  
		},  
		ignite2 = {  
			name = "怒火中烧II",  
			info = "升级你的怒火中烧技能\n\t• 燃料消耗减少[-ignite_cost]\n\t• 第一圈火焰额外生成[ignite_flames]个火焰",  
		},  
		fuel = {  
			name = "燃料补给！",  
			info = "立即获得[fuel]燃料",  
		}  
	}  
}

wep.SCP682 = {  
	skills = {  
		_overview = { "主技能", "副技能", "冲锋", "护盾" },  
		primary = {  
			name = "基础攻击",  
			dsc = "用手直接在前方进行攻击，造成少量伤害",  
		},  
		secondary = {  
			name = "撕咬",  
			dsc = "按住键准备一次强力攻击，将在前方锥形区域内造成大量伤害",  
		},  
		charge = {  
			name = "冲锋",  
			dsc = "经过短暂延迟后向前冲锋，变得势不可挡。当达到全速时，消灭路径上的所有敌人，并获得穿透大多数门的能力。此技能需要在升级树中解锁",  
		},  
		shield = {  
			name = "护盾",  
			dsc = "护盾可以吸收任何非直接/坠落伤害。此能力受技能树中购买的升级影响",  
		},  
		shield_bar = {  
			name = "护盾",  
			dsc = "当前护盾量，可以吸收任何非直接/坠落伤害",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		shield_a = {  
			name = "强化护盾",  
			info = "提升你的护盾威力\n\t• 护盾威力：[%shield]\n\t• 冷却时间：[%shield_cd]",  
		},  
		shield_b = {  
			name = "再生护盾",  
			info = "改变你的护盾威力\n\t• 护盾威力：[%shield]\n\t• 冷却时间：[%shield_cd]\n\t• 护盾完全消耗后开始冷却\n\t• 护盾冷却期间，每秒恢复[shield_regen] HP",  
		},  
		shield_c = {  
			name = "牺牲护盾",  
			info = "改变你的护盾威力\n\t• 冷却时间：[%shield_cd]\n\t• 护盾完全消耗后开始冷却\n\t• 你的护盾威力等于你的最大HP\n\t• 护盾破碎时，你失去[shield_hp]最大HP",  
		},  
		shield_d = {  
			name = "反射护盾",  
			info = "改变你的护盾威力\n\t• 护盾威力：[%shield]\n\t• 冷却时间：[%shield_cd]\n\t• 护盾完全消耗后开始冷却\n\t• 你的护盾只阻挡[%shield_pct]的伤害\n\t• [%reflect_pct]的阻挡伤害会反射给攻击者",  
		},  
  
		shield_1 = {  
			name = "护盾I",  
			info = "为你的护盾增加效果。完全破碎后\n获得额外的[+shield_speed_pow]移动速度，持续[shield_speed_dur]秒",  
		},  
		shield_2 = {  
			name = "护盾II",  
			info = "为你的护盾增加效果。完全破碎后\n获得额外的[+shield_speed_pow]移动速度,持续[shield_speed_dur]秒\n每受到1点伤害，护盾冷却时间缩短[shield_cdr]秒",  
		},  
  
		attack_1 = {  
			name = "强化挥击",  
			info = "升级你的基础攻击\n\t• 冷却时间减少[-prim_cd]\n\t• 伤害增加[prim_dmg]",  
		},  
		attack_2 = {  
			name = "强化撕咬",  
			info = "升级你的撕咬\n\t• 范围增加[+sec_range]\n\t• 准备时的移动速度增加[+sec_speed]",  
		},  
		attack_3 = {  
			name = "无情打击",  
			info = "升级基础攻击和撕咬\n\t• 两次攻击都造成流血效果\n\t• 完全蓄力的撕咬攻击造成骨折",  
		},  
  
		charge_1 = {  
			name = "冲锋",  
			info = "解锁冲锋能力",  
		},  
		charge_2 = {  
			name = "残忍冲锋",  
			info = "强化冲锋能力\n\t• 冷却时间减少[-charge_cd]\n\t• 眩晕和减速持续时间减少[-charge_stun]",  
		},  
	}  
}

wep.SCP8602 = {  
	skills = {  
		_overview = { "被动", "主技能", "防御姿态", "冲锋" },  
		primary = {  
			name = "攻击",  
			dsc = "执行基础攻击",  
		},  
		defense = {  
			name = "防御姿态",  
			dsc = "按住以激活。在按住期间，随时间获得保护效果，但移动速度也会减慢。松开后向前冲刺，并对减免的伤害按[dmg_ratio]的比例造成等量伤害。此能力没有持续时间限制",  
		},  
		charge = {  
			name = "冲锋",  
			dsc = "随时间增加速度，并对前方第一个玩家造成伤害。如果被攻击的玩家离墙壁足够近，则将其钉在墙上以增加伤害",  
		},  
		passive = {  
			name = "被动技能",  
			dsc = "你能看到进入你森林范围内的玩家，并在他们离开一段时间后仍能看到。森林内的玩家会失去理智，如果理智耗尽，则会损失生命值。从森林内玩家身上获取的理智/生命值可以为你治疗，这种治疗可以超过你的最大生命值",  
		},  
		overheal_bar = {  
			name = "过量治疗",  
			dsc = "超出最大生命值的生命量",  
		},  
		defense_bar = {  
			name = "防御",  
			dsc = "当前保护强度",  
		},  
		charge_bar = {  
			name = "冲锋",  
			dsc = "剩余冲锋时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "茂密森林I",  
			info = "升级你的被动技能\n\t• 最大过量治疗增加[+overheal]\n\t• 被动速率增加[/passive_rate]\n\t• 玩家探测时间增加[+detect_time]",  
		},  
		passive2 = {  
			name = "茂密森林II",  
			info = "升级你的被动技能\n\t• 最大过量治疗增加[+overheal]\n\t• 被动速率增加[/passive_rate]\n\t• 玩家探测时间增加[+detect_time]",  
		},  
		primary = {  
			name = "简单却危险",  
			info = "升级你的基础攻击\n\t• 冷却时间减少[-primary_cd]\n\t• 伤害增加[+primary_dmg]",  
		},  
		def1a = {  
			name = "迅捷护甲",  
			info = "改变你的防御姿态技能\n\t• 激活时间减少[-def_time]\n\t• 冷却时间增加[+def_cooldown]",  
		},  
		def1b = {  
			name = "急速护甲",  
			info = "改变你的防御姿态技能\n\t• 激活时间增加[+def_time]\n\t• 冷却时间减少[-def_cooldown]",  
		},  
		def2a = {  
			name = "长距离冲刺",  
			info = "改变你的防御姿态技能\n\t• 冲刺最大距离增加[+def_range]\n\t• 冲刺宽度减少[-def_width]",  
		},  
		def2b = {  
			name = "笨拙冲刺",  
			info = "改变你的防御姿态技能\n\t• 冲刺最大距离减少[-def_range]\n\t• 冲刺宽度增加[+def_width]",  
		},  
		def3a = {  
			name = "重甲",  
			info = "改变你的防御姿态技能\n\t• 最大保护强度增加[+def_prot]\n\t• 最大减速效果增加[+def_slow]",  
		},  
		def3b = {  
			name = "轻甲",  
			info = "改变你的防御姿态技能\n\t• 最大保护强度减少[-def_prot]\n\t• 最大减速效果减少[-def_slow]",  
		},  
		def4 = {  
			name = "高效护甲",  
			info = "升级你的防御姿态技能\n\t• 伤害转换倍率增加[+def_mult]",  
		},  
		charge1 = {  
			name = "冲锋I",  
			info = "升级你的冲锋技能\n\t• 冷却时间减少[-charge_cd]\n\t• 持续时间增加[+charge_time]\n\t• 基础伤害增加[+charge_dmg]",  
		},  
		charge2 = {  
			name = "冲锋II",  
			info = "升级你的冲锋技能\n\t• 范围增加[+charge_range]\n\t• 持续时间增加[+charge_time]\n\t• 钉墙伤害增加[+charge_pin_dmg]",  
		},  
		charge3 = {  
			name = "冲锋III",  
			info = "升级你的冲锋技能\n\t• 速度增加[+charge_speed]\n\t• 基础伤害增加[+charge_dmg]\n\t• 将玩家钉在墙上会使其骨折",  
		},  
	}  
}

wep.SCP939 = {  
	skills = {  
		_overview = { "被动", "主动", "尾随", "特殊" },  
		primary = {  
			name = "攻击",  
			dsc = "咬伤你前方锥形区域内的所有人",  
		},  
		trail = {  
			name = "ANM-C227",  
			dsc = "按住键位在你身后留下ANM-C227轨迹",  
		},  
		special = {  
			name = "探测",  
			dsc = "开始探测你周围的玩家",  
		},  
		passive = {  
			name = "被动",  
			dsc = "你看不见玩家，但你可以看见声波。你周围有ANM-C227光环",  
		},  
		special_bar = {  
			name = "探测",  
			dsc = "剩余探测时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "光环I",  
			info = "升级你的被动能力\n\t• 光环半径增加[+aura_radius]\n\t• 光环伤害增加[aura_damage]",  
		},  
		passive2 = {  
			name = "光环II",  
			info = "升级你的被动能力\n\t• 光环半径增加[+aura_radius]\n\t• 光环伤害增加[aura_damage]",  
		},  
		passive3 = {  
			name = "光环III",  
			info = "升级你的被动能力\n\t• 光环半径增加[+aura_radius]\n\t• 光环伤害增加[aura_damage]",  
		},  
		attack1 = {  
			name = "撕咬I",  
			info = "升级你的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 伤害增加[+attack_dmg]",  
		},  
		attack2 = {  
			name = "撕咬II",  
			info = "升级你的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 范围增加[+attack_range]",  
		},  
		attack3 = {  
			name = "撕咬III",  
			info = "升级你的攻击能力\n\t• 伤害增加[+attack_dmg]\n\t• 范围增加[+attack_range]\n\t• 你的攻击有几率造成流血效果",  
		},  
		trail1 = {  
			name = "失忆I",  
			info = "升级你的ANM-C227能力\n\t• 半径增加[+trail_radius]\n\t• 堆叠生成速率增加[/trail_rate]",  
		},  
		trail2 = {  
			name = "失忆II",  
			info = "升级你的ANM-C227能力\n\t• 伤害增加[trail_dmg]\n\t• 最大堆叠数增加[+trail_stacks]",  
		},  
		trail3a = {  
			name = "失忆III A",  
			info = "升级你的ANM-C227能力\n\t• 轨迹持续时间增加[+trail_life]\n\t• 半径增加[+trail_radius]",  
		},  
		trail3b = {  
			name = "失忆III B",  
			info = "升级你的ANM-C227能力\n\t• 最大堆叠数增加[+trail_stacks]",  
		},  
		trail3c = {  
			name = "失忆III C",  
			info = "升级你的ANM-C227能力\n\t• 堆叠生成速率增加[/trail_rate]",  
		},  
		special1 = {  
			name = "回声定位I",  
			info = "升级你的特殊能力\n\t• 冷却时间减少[-special_cd]\n\t• 半径增加[+special_radius]",  
		},  
		special2 = {  
			name = "回声定位II",  
			info = "升级你的特殊能力\n\t• 冷却时间减少[-special_cd]\n\t• 持续时间增加[+special_times]",  
		},  
	}  
}

wep.SCP966 = {  
	fatigue = "疲劳等级：",  
  
	skills = {  
		_overview = { "被动", "攻击", "引导", "标记" },  
		attack = {  
			name = "基础攻击",  
			dsc = "执行基础攻击。你只能攻击拥有至少10层疲劳累积的玩家。被攻击的玩家会失去一些疲劳累积。此攻击的效果受技能树影响",  
		},  
		channeling = {  
			name = "引导",  
			dsc = "引导技能树中选定的能力",  
		},  
		mark = {  
			name = "死亡标记",  
			dsc = "标记玩家。被标记的玩家会从附近其他玩家那里转移疲劳累积到自己身上",  
		},  
		passive = {  
			name = "疲劳",  
			dsc = "偶尔会对附近的玩家施加疲劳累积。你每施加一层疲劳累积，也会获得一层被动累积",  
		},  
		channeling_bar = {  
			name = "引导",  
			dsc = "引导能力的剩余时间",  
		},  
		mark_bar = {  
			name = "死亡标记",  
			dsc = "被标记玩家身上标记的剩余时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		passive1 = {  
			name = "疲劳I",  
			info = "升级你的被动能力\n\t• 被动触发率提高[/passive_rate]",  
		},  
		passive2 = {  
			name = "疲劳II",  
			info = "升级你的被动能力\n\t• 被动触发率提高[/passive_rate]\n\t• 被动范围增加[+passive_radius]",  
		},  
		basic1 = {  
			name = "锋利爪击I",  
			info = "升级你的基础攻击，每[basic_stacks]层被动累积\n增加[%basic_dmg]的伤害\n此外，获得被动累积可解锁：\n\t• [bleed1_thr]层：如果目标未流血，则施加流血效果\n\t• [drop1_thr]层：目标失去的疲劳累积减少至[%drop1]\n\t• [slow_thr]层：目标减速[-slow_power]，持续[slow_dur]秒",  
		},  
		basic2 = {  
			name = "锋利爪击II",  
			info = "升级基础攻击，每[basic_stacks]层被动累积增加[%basic_dmg]的伤害\n此外，获得被动累积可解锁：\n\t• [bleed2_thr]层：击中时施加流血效果\n\t• [drop2_thr]层：目标失去的疲劳累积减少至[%drop2]\n\t• [hb_thr]层：击中时施加严重流血效果，而不是流血效果",  
		},  
		heal = {  
			name = "血液汲取",  
			info = "击中时，每层被动累积每目标疲劳\n累积回复[%heal_rate]生命值",  
		},  
		channeling_a = {  
			name = "无尽疲劳",  
			info = "解锁引导能力，允许你专注于单个目标\n\t• 引导期间禁用被动\n\t• 冷却时间[channeling_cd]秒\n\t• 最大持续时间[channeling_time]秒\n\t• 目标每[channeling_rate]秒获得一层疲劳累积",  
		},  
		channeling_b = {  
			name = "能量汲取",  
			info = "解锁引导能力，允许你从附近玩家身上汲取疲劳累积\n\t• 引导期间禁用被动\n\t• 冷却时间[channeling_cd]秒\n\t• 最大持续时间[channeling_time]秒\n\t• 每[channeling_rate]秒，从所有附近玩家身上转移1层疲劳累积到被动累积中",  
		},  
		channeling = {  
			name = "强化引导",  
			info = "升级你的引导能力\n\t• 引导范围增加[+channeling_range_mul]\n\t• 引导持续时间增加[+channeling_time_mul]",  
		},  
		mark1 = {  
			name = "致命标记I",  
			info = "升级标记能力：\n\t• 累积转移速率增加[/mark_rate]",  
		},  
		mark2 = {  
			name = "致命标记II",  
			info = "升级标记能力：\n\t• 累积转移速率增加[/mark_rate]\n\t• 累积转移范围增加[+mark_range]",  
		},  
	}  
}

wep.SCP24273 = {  
	skills = {  
		_overview = { "切换", "主技能", "副技能", "特殊技能" },  
		primary = {  
			name = "冲刺/伪装",  
			dsc = "\n法官：\n向前冲刺，对路径上的所有人造成伤害\n\n检察官：\n启用伪装。伪装期间你更难被发现。使用技能、移动或受到伤害会中断伪装",  
		},  
		secondary = {  
			name = "审查/监视",  
			dsc = "\n法官：\n开始锁定目标玩家一段时间。完全施放后，减速目标并造成伤害。如果失去视线，技能会被中断，并且你会被减速\n\n检察官：\n离开你的身体，从附近随机玩家的视角观察。你的被动技能也会从该玩家的视角生效",  
		},  
		special = {  
			name = "审判/幽灵",  
			dsc = "\n法官：\n站在原地，迫使附近的所有人走向你。结束时，近距离的玩家会受到伤害并被击退\n\n检察官：\n进入幽灵形态。在幽灵形态下，你免疫所有伤害（爆炸和直接伤害除外）",  
		},  
		change = {  
			name = "法官/检察官",  
			dsc = "\n在法官和检察官模式之间切换\n\n法官：\n你对目标造成的伤害会根据累积的证据增加。攻击目标会降低证据等级。攻击拥有满额证据的玩家会立即杀死他们\n\n检察官：\n你的速度减慢，并且获得子弹伤害保护。注视玩家可以收集他们的证据",  
		},  
		camo_bar = {  
			name = "伪装",  
			dsc = "剩余伪装时间",  
		},  
		spectate_bar = {  
			name = "监视",  
			dsc = "剩余监视时间",  
		},  
		drain_bar = {  
			name = "审查",  
			dsc = "剩余审查时间",  
		},  
		ghost_bar = {  
			name = "幽灵",  
			dsc = "剩余幽灵时间",  
		},  
		special_bar = {  
			name = "审判",  
			dsc = "剩余审判时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		j_passive1 = {  
			name = "严厉法官I",  
			info = "升级你的法官被动技能\n\t• 证据增加的伤害提升至额外[%j_mult]\n\t• 攻击时证据减少至[%j_loss]",  
		},  
		j_passive2 = {  
			name = "严厉法官II",  
			info = "升级你的法官被动技能\n\t• 证据增加的伤害提升至额外[%j_mult]\n\t• 攻击时证据减少至[%j_loss]",  
		},  
		p_passive1 = {  
			name = "地方检察官I",  
			info = "升级你的检察官被动技能\n\t• 子弹保护提升至[%p_prot]\n\t• 减速提升至[%p_slow]\n\t• 每秒证据收集速率提升至[%p_rate]",  
		},  
		p_passive2 = {  
			name = "地方检察官II",  
			info = "升级你的检察官被动技能\n\t• 子弹保护提升至[%p_prot]\n\t• 减速提升至[%p_slow]\n\t• 每秒证据收集速率提升至[%p_rate]",  
		},  
		dash1 = {  
			name = "冲刺I",  
			info = "升级你的冲刺技能\n\t• 冷却时间减少[-dash_cd]\n\t• 伤害增加[+dash_dmg]",  
		},  
		dash2 = {  
			name = "冲刺II",  
			info = "升级你的冲刺技能\n\t• 冷却时间减少[-dash_cd]\n\t• 伤害增加[+dash_dmg]",  
		},  
		camo1 = {  
			name = "伪装I",  
			info = "升级你的伪装技能\n\t• 冷却时间减少[-camo_cd]\n\t• 持续时间增加[+camo_dur]\n\t• 你可以在不中断此技能的情况下移动[camo_limit]单位",  
		},  
		camo2 = {  
			name = "伪装II",  
			info = "升级你的伪装技能\n\t• 冷却时间减少[-camo_cd]\n\t• 持续时间增加[+camo_dur]\n\t• 你可以在不中断此技能的情况下移动[camo_limit]单位",  
		},  
		drain1 = {  
			name = "审查I",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-drain_cd]\n\t• 持续时间减少[-drain_dur]",  
		},  
		drain2 = {  
			name = "审查II",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-drain_cd]\n\t• 持续时间减少[-drain_dur]",  
		},  
		spect1 = {  
			name = "监视I",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-spect_cd]\n\t• 持续时间增加[+spect_dur]\n\t• 子弹伤害保护提升至[%spect_prot]",  
		},  
		spect2 = {  
			name = "监视II",  
			info = "升级你的检察官被动技能\n\t• 冷却时间减少[-spect_cd]\n\t• 持续时间增加[+spect_dur]\n\t• 子弹伤害保护提升至[%spect_prot]",  
		},  
		combo = {  
			name = "最高法院",  
			info = "升级你的审判和幽灵技能\n\t• 审判保护提升至[%special_prot]\n\t• 幽灵持续时间增加[+ghost_dur]",  
		},  
		spec = {  
			name = "审判",  
			info = "升级你的审判技能\n\t• 冷却时间减少[-special_cd]\n\t• 持续时间增加[+special_dur]\n\t• 保护提升至[%special_prot]",  
		},  
		ghost1 = {  
			name = "幽灵I",  
			info = "升级你的幽灵技能\n\t• 冷却时间减少[-ghost_cd]\n\t• 持续时间增加[+ghost_dur]\n\t• 每消耗1份证据，治疗量增加至[ghost_heal]",  
		},  
		ghost2 = {  
			name = "幽灵II",  
			info = "升级你的幽灵技能\n\t• 冷却时间减少[-ghost_cd]\n\t• 持续时间增加[+ghost_dur]\n\t• 每消耗1份证据，治疗量增加至[ghost_heal]",  
		},  
		change1 = {  
			name = "切换I",  
			info = "切换冷却时间减少[-change_cd]",  
		},  
		change2 = {  
			name = "切换II",  
			info = "切换冷却时间减少[-change_cd]。此外，切换模式不再中断伪装技能",  
		},  
	}  
}


wep.SCP3199 = {  
	skills = {  
		_overview = { "被动技能", "主动技能", "特殊技能", "蛋" },  
		eggs_max = "您已达到最大蛋数量！",  
  
		primary = {  
			name = "攻击",  
			dsc = "执行基础攻击。击中目标会激活（或刷新）狂暴状态，施加深度创伤效果，并获得被动层数和狂暴层数。\n对带有深度创伤的目标，攻击伤害会降低。若攻击未命中，则狂暴状态停止。若仅击中带有深度创伤的目标，则狂暴状态停止并施加层数惩罚",  
		},  
		special = {  
			name = "超越攻击",  
			dsc = "在连续[tokens]次成功攻击后激活。使用该技能立即结束狂暴状态，并对所有带有深度创伤的玩家造成伤害。受影响玩家也会被减速",  
		},  
		egg = {  
			name = "蛋",  
			dsc = "击杀玩家后可以孵化蛋。当您受到致命伤害时，将在随机蛋的位置复活。复活会消耗一个蛋。此外，每个蛋提供[prot]点子弹保护（上限为[cap]）\n\n当前蛋数量：[eggs] / [max]",  
		},  
		passive = {  
			name = "被动",  
			dsc = "在狂暴状态下，可以看到附近没有深度创伤的玩家的位置。获得狂暴层数也会获得被动层数。如果攻击仅命中带有深度创伤的玩家，您将失去[penalty]层被动层数。被动层数会升级您的其他能力\n\n在狂暴状态下每秒恢复[heal]点HP\n攻击伤害加成：[dmg]\n狂暴速度加成：[speed]\n特殊攻击额外减速：[slow]\n特殊攻击造成[bleed]级流血效果",  
		},  
		frenzy_bar = {  
			name = "狂暴",  
			dsc = "剩余狂暴时间",  
		},  
		egg_bar = {  
			name = "蛋",  
			dsc = "剩余蛋孵化时间",  
		},  
	},  
  
	upgrades = {  
		parse_description = true,  
  
		frenzy1 = {  
			name = "狂暴I",  
			info = "升级您的狂暴能力\n\t• 持续时间增加[+frenzy_duration]\n\t• 最大层数增加[frenzy_max]",  
		},  
		frenzy2 = {  
			name = "狂暴II",  
			info = "升级您的狂暴能力\n\t• 最大层数增加[frenzy_max]\n\t• 每层被动层数使狂暴速度增加[%frenzy_speed_stacks]",  
		},  
		frenzy3 = {  
			name = "狂暴III",  
			info = "升级您的狂暴能力\n\t• 持续时间增加[+frenzy_duration]\n\t• 每层被动层数使狂暴速度增加[%frenzy_speed_stacks]",  
		},  
		attack1 = {  
			name = "锋利爪击I",  
			info = "升级您的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 伤害增加[+attack_dmg]",  
		},  
		attack2 = {  
			name = "锋利爪击II",  
			info = "升级您的攻击能力\n\t• 冷却时间减少[-attack_cd]\n\t• 每层被动层数使伤害增加[%attack_dmg_stacks]",  
		},  
		attack3 = {  
			name = "锋利爪击III",  
			info = "升级您的攻击能力\n\t• 伤害增加[+attack_dmg]\n\t• 每层被动层数使伤害增加[%attack_dmg_stacks]",  
		},  
		special1 = {  
			name = "超越攻击I",  
			info = "升级您的特殊能力\n\t• 伤害增加[+special_dmg]\n\t• 每层被动层数使减速增加[%special_slow]\n\t• 减速持续时间增加[+special_slow_duration]",  
		},  
		special2 = {  
			name = "超越攻击II",  
			info = "升级您的特殊能力\n\t• 伤害增加[+special_dmg]\n\t• 每层被动层数使减速增加[%special_slow]\n\t• 减速持续时间增加[+special_slow_duration]",  
		},  
		passive = {  
			name = "血腥感知",  
			info = "被动检测范围增加[+passive_radius]",  
		},  
		egg = {  
			name = "复活节彩蛋",  
			info = "立即孵化新蛋。\n此能力可以超出蛋的数量限制",  
		},  
	}  
}