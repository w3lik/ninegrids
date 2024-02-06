TPL_ACHIEVEMENT = {
    Tpl()
        :name("初生至主")
        :icon("ability/InscriptionVantusRuneAzure")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +10"),
            colour.hex(colour.mediumpurple, "HP: +100"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me:hp("+=100")
            Game():upgradePoint(10)
        end)
        :description(
        {
            colour.format("通过探秘区难度：%s", nil, {
                { colour.skyblue, "初生" },
            })
        }),
    Tpl()
        :name("洞悉至主")
        :icon("ability/InscriptionVantusRuneTomb")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +10"),
            colour.hex(colour.mediumpurple, "HP: +200"),
            colour.hex(colour.mediumpurple, "MP: +50"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me:hp("+=200"):mp("+=50")
            Game():upgradePoint(10)
        end)
        :description(
        {
            colour.format("通过探秘区难度：%s", nil, {
                { "f5ff22", "洞悉" },
            })
        }),
    Tpl()
        :name("破灭至主")
        :icon("ability/InscriptionVantusRuneSuramar")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +10"),
            colour.hex(colour.mediumpurple, "HP: +300"),
            colour.hex(colour.mediumpurple, "MP: +100"),
            colour.hex(colour.mediumpurple, "防御: +5"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me:hp("+=300"):mp("+=100"):defend("+=5")
            Game():upgradePoint(10)
        end)
        :description(
        {
            colour.format("通过探秘区难度：%s", nil, {
                { "e3c6ee", "破灭" },
            })
        }),
    Tpl()
        :name("觉醒至主")
        :icon("ability/InscriptionVantusRuneNightmare")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +10"),
            colour.hex(colour.mediumpurple, "HP: +400"),
            colour.hex(colour.mediumpurple, "MP: +150"),
            colour.hex(colour.mediumpurple, "防御: +10"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me:hp("+=400"):mp("+=150"):defend("+=10")
            Game():upgradePoint(10)
        end)
        :description(
        {
            colour.format("通过探秘区难度：%s", nil, {
                { colour.red, "觉醒" },
            })
        }),
    Tpl()
        :name("本命至我")
        :icon("ability/InscriptionVantusRuneOdyn")
        :prop("reward", colour.hex(colour.gold, "强大的证明"))
        :description(
        function()
            return {
                colour.format("击败：%s", nil, {
                    { colour.red, "我" },
                })
            }
        end),
    Tpl()
        :name("呼风唤雨")
        :icon("ability/ControlMagic")
        :prop("reward", colour.hex(colour.mediumpurple, "怪老头的气候控制"))
        :description(
        {
            colour.format("给%s找到%s块%s", nil, {
                { colour.gold, "怪老头" },
                { colour.gold, 5 },
                { colour.skyblue, "大空陨石" },
            })
        }),
    Tpl()
        :name("孜孜求学者")
        :icon("ability/Uniting")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +4"),
            colour.hex(colour.mediumpurple, "HP恢复: +3"),
            colour.hex(colour.mediumpurple, "MP恢复: +2"),
            colour.hex(colour.mediumpurple, "攻击: +9"),
            colour.hex(colour.mediumpurple, "攻速: +6%"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me:hpRegen("+=3"):mpRegen("+=1"):attack("+=9"):attackSpeed("+=6")
            Game():upgradePoint(4)
        end)
        :description(
        {
            colour.format("完成%s的%s", nil, {
                { colour.gold, "一本书" },
                { colour.skyblue, "最后教学指导" },
            })
        }),
    Tpl()
        :name("断还断，理不乱")
        :icon("ability/DemonEnhancement")
        :prop("reward",
        {
            colour.hex(colour.mediumpurple, "减伤: +7%"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me:hurtReduction("+=7")
        end)
        :description(
        {
            colour.format("断泠累计%s次", nil, {
                { colour.red, 99 },
            })
        }),
    Tpl()
        :name("邪道掌控人")
        :icon("ability/ShadowAntiShadow")
        :prop("reward",
        {
            colour.hex(colour.mediumpurple, "暗强化: +10%"),
            colour.hex(colour.mediumpurple, "暗抗性: +10%"),
        })
        :prop("rewardDo",
        function()
            Game():GD().me
                  :enchant(DAMAGE_TYPE.dark, "+=10")
                  :enchantResistance(DAMAGE_TYPE.dark, "+=10")
        end)
        :description(
        {
            colour.format("学习%s的%s后过关1次", nil, {
                { colour.gold, "谜语人" },
                { colour.violet, "奇异魔技" },
            })
        }),
    Tpl()
        :name("邪念噬毒者")
        :icon("ability/GreenGhostInHand2")
        :prop("reward", colour.hex(colour.mediumpurple, "毒抗性: +15%"))
        :prop("rewardDo",
        function()
            Game():GD().me:enchantResistance(DAMAGE_TYPE.poison, "+=15")
        end)
        :description(
        {
            colour.format("侵蚀程度达至%s", nil, {
                { colour.violet, 150 },
            })
        }),
    Tpl()
        :name("响彻大泠音")
        :icon("ability/FreakMusic")
        :prop("reward",
        {
            colour.hex(colour.mediumpurple, "技能升级价格降低20%"),
            colour.hex(colour.mediumpurple, "泠器精炼价格降低20%"),
        })
        :prop("rewardDo",
        function()
            Game():GD().abilityDiscount = 0.8
            Game():GD().sacredDiscount = 0.8
        end)
        :description(
        {
            colour.format("解封所有的%s", nil, {
                { colour.gold, "英泠伙伴" },
            })
        }),
    Tpl()
        :name("成功至母")
        :icon("ability/WarriorSunder")
        :prop("reward", colour.hex(colour.mediumpurple, "泠器精炼失败后下一次成功率提升0.4%"))
        :description(
        {
            colour.format("泠器连续精炼失败%s次", nil, {
                { colour.red, 30 },
            })
        }),
    Tpl()
        :name("多财多亿")
        :icon("item/NatureEarthBindTotem")
        :prop("reward", colour.hex(colour.mediumpurple, "泠器精炼成功率提升5%"))
        :prop("rewardDo",
        function()
            Game():GD().sacredOdds = 5
        end)
        :description(
        {
            colour.format("金币数量达到%s以上", nil, {
                { colour.gold, 233 },
            })
        }),
    Tpl()
        :name("蜘蛛秘宝")
        :icon("unit/SpiderShrine")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +5"),
            colour.hex(colour.skyblue, "获得100黄金（一次性的）"),
            colour.hex(colour.mediumpurple, "泠器装备时精炼等级额外+1")
        })
        :prop("rewardDo",
        function()
            Game():upgradePoint(5)
            Game():sacredUpLv(1)
        end)
        :description(
        {
            colour.format("得到%s的%s", nil, {
                { colour.skyblue, "蜘蛛雕像" },
                { colour.gold, "隐藏宝藏" },
            })
        }),
    Tpl()
        :name("遗迹秘宝")
        :icon("item/MiscRune13")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +10"),
            colour.hex(colour.skyblue, "获得300黄金（一次性的）"),
            colour.hex(colour.mediumpurple, "泠技习得时等级额外+2")
        })
        :prop("rewardDo",
        function()
            Game():upgradePoint(10)
            Game():abilityUpLv(2)
        end)
        :description(
        {
            colour.format("得到%s的%s", nil, {
                { colour.sandybrown, "遗迹符文" },
                { colour.gold, "隐藏宝藏" },
            })
        }),
    Tpl()
        :name("冻结反应")
        :icon("ability/Circleoffrost")
        :prop("reward", colour.format(
        "激活反应：冻结（全局特性）|n当%s和%s相遇时会形成反应|n造成%s%s|n%s|n%s", colour.mediumpurple, {
            { colour.skyblue, "水" },
            { colour.lightcyan, "冰" },
            { colour.indianred, "[伤害源10%攻击]" },
            { colour.lightcyan, "1级冰伤" },
            { colour.lightcyan, "可能使木飙冻结无法正常行动" },
            { colour.lightcyan, "有几率35%冻结1到3秒" },
        }))
        :prop("rewardDo",
        function()
            local react = function(evtData)
                local target = evtData.targetUnit
                local dmg = 0
                local dmgType = DAMAGE_TYPE.ice
                if (isClass(evtData.sourceUnit, UnitClass)) then
                    local mystery = evtData.sourceUnit:enchantMystery() * 0.01 + 1
                    mystery = math.max(0, mystery)
                    dmg = 0.10 * evtData.sourceUnit:attack() * mystery
                end
                if (dmg > 1) then
                    ability.damage({
                        sourceUnit = evtData.sourceUnit,
                        targetUnit = target,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.reaction,
                        damageType = dmgType,
                        damageTypeLevel = 1,
                    })
                end
                if (math.rand(1, 100) <= 35) then
                    ability.freeze({
                        name = "冻结反应",
                        icon = "ability/Circleoffrost",
                        duration = 0.1 * math.rand(10, 30),
                        description = "冻结无法正常行动",
                        whichUnit = target,
                        red = 100,
                        green = 100,
                        blue = 255,
                    })
                end
            end
            Enchant(DAMAGE_TYPE.water.value):reaction(DAMAGE_TYPE.ice.value, react)
            Enchant(DAMAGE_TYPE.ice.value):reaction(DAMAGE_TYPE.water.value, react)
        end)
        :description(
        {
            "任意一个单位",
            colour.format("身上附着%s时遇到%s伤害", nil, { { colour.skyblue, "水" }, { colour.lightcyan, "冰" } }),
            colour.format("或者附着%s时遇到%s伤害", nil, { { colour.lightcyan, "冰" }, { colour.skyblue, "水" } }),
        }),
    Tpl()
        :name("湖烧反应")
        :icon("ability/FlameImpulse")
        :prop("reward", colour.format(
        "激活反应：湖烧（全局特性）|n当%s和%s相遇时会形成反应|n每秒造成1次%s%s|n%s", colour.mediumpurple, {
            { colour.palegreen, "草" },
            { colour.red, "火" },
            { colour.indianred, "[伤害源10%攻击]" },
            { colour.red, "无附着火伤" },
            { colour.indianred, "持续时间5秒" },
        }))
        :prop("rewardDo",
        function()
            local react = function(evtData)
                local target = evtData.targetUnit
                local source = evtData.sourceUnit
                local dmg = 0
                local dmgType = DAMAGE_TYPE.fire
                if (isClass(source, UnitClass)) then
                    local mystery = source:enchantMystery() * 0.01 + 1
                    mystery = math.max(0, mystery)
                    dmg = 0.10 * source:attack() * mystery
                end
                if (dmg > 1) then
                    local di = 0
                    local dur = 5
                    async.setInterval(1, function(curTimer)
                        di = di + 1
                        if (di > dur) then
                            destroy(curTimer)
                            return
                        end
                        ability.damage({
                            sourceUnit = source,
                            targetUnit = target,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.reaction,
                            damageType = dmgType,
                            damageTypeLevel = 0,
                        })
                    end)
                end
            end
            Enchant(DAMAGE_TYPE.grass.value):reaction(DAMAGE_TYPE.fire.value, react)
            Enchant(DAMAGE_TYPE.fire.value):reaction(DAMAGE_TYPE.grass.value, react)
        end)
        :description(
        {
            "任意一个单位",
            colour.format("身上附着%s时遇到%s伤害", nil, { { colour.palegreen, "草" }, { colour.indianred, "火" } }),
            colour.format("或者附着%s时遇到%s伤害", nil, { { colour.indianred, "火" }, { colour.palegreen, "草" } }),
        }),
    Tpl()
        :name("感电反应")
        :icon("ability/Eddycurrentelectricball")
        :prop("reward", colour.format(
        "激活反应：感电（全局特性）|n当%s和%s相遇时会形成反应|n最多%s|n电流造成%s的%s", colour.mediumpurple, {
            { colour.lightcyan, "冰|水" },
            { colour.aquamarine, "雷" },
            { colour.aquamarine, "会产生最多2道新的电流向四周渐弱扩散" },
            { colour.aquamarine, "3次" },
            { colour.indianred, "[伤害源5%攻击]" },
            { colour.aquamarine, "无附着雷伤" },
        }))
        :prop("rewardDo",
        function()
            local react = function(evtData)
                local target = evtData.targetUnit
                local source = evtData.sourceUnit
                local dmg = 0
                local dmgType = DAMAGE_TYPE.thunder
                if (isClass(source, UnitClass)) then
                    local mystery = source:enchantMystery() * 0.01 + 1
                    mystery = math.max(0, mystery)
                    dmg = 0.05 * source:attack() * mystery
                end
                if (dmg > 1) then
                    local radius = 350
                    local g = Group():rand(UnitClass, {
                        circle = { x = target:x(), y = target:y(), radius = radius },
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:isEnemy(source:owner())
                        end
                    }, 2)
                    for _, eu in ipairs(g) do
                        ability.lightningChain({
                            sourceUnit = source,
                            targetUnit = eu,
                            lightningType = LIGHTNING_TYPE.thunderLite,
                            qty = 3,
                            rate = -20,
                            radius = radius,
                            isRepeat = true,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.reaction,
                            damageType = dmgType,
                            damageTypeLevel = 0,
                        })
                    end
                end
            end
            Enchant(DAMAGE_TYPE.ice.value):reaction(DAMAGE_TYPE.thunder.value, react)
            Enchant(DAMAGE_TYPE.thunder.value):reaction(DAMAGE_TYPE.ice.value, react)
            Enchant(DAMAGE_TYPE.water.value):reaction(DAMAGE_TYPE.thunder.value, react)
            Enchant(DAMAGE_TYPE.thunder.value):reaction(DAMAGE_TYPE.water.value, react)
        end)
        :description(
        {
            "任意一个单位",
            colour.format("身上附着%s时遇到%s伤害", nil, { { colour.lightcyan, "冰" }, { colour.aquamarine, "雷" } }),
            colour.format("或者附着%s时遇到%s伤害", nil, { { colour.aquamarine, "雷" }, { colour.lightcyan, "冰" } }),
        }),
    Tpl()
        :name("破碎反应")
        :icon("ability/Earthquake")
        :prop("reward", colour.format(
        "激活反应：破碎（全局特性）|n当%s和%s相遇时会形成反应|n会受到额外%s%s|n有75%几率在%s里%s|n%s|n%s", colour.mediumpurple, {
            { colour.khaki, "岩" },
            { colour.orange, "钢" },
            { colour.orange, "无视防御的随机50~300" },
            { colour.khaki, "岩伤害" },
            { colour.orange, "7到10秒" },
            { colour.cornflowerblue, "降低眩晕抗性和减伤" },
            { colour.indianred, "眩晕抗性降低10%" },
            { colour.indianred, "减伤抗性降低5%" },
        }))
        :prop("rewardDo",
        function()
            local react = function(evtData)
                local target = evtData.targetUnit
                local source = evtData.sourceUnit
                target:attach("ReplenishHealthCaster", "origin", 2)
                local dmg = math.rand(50, 300)
                if (isClass(source, UnitClass)) then
                    local mystery = source:enchantMystery() * 0.01 + 1
                    mystery = math.max(0, mystery)
                    dmg = dmg * mystery
                end
                local dmgType = DAMAGE_TYPE.rock
                if (dmg > 1) then
                    ability.damage({
                        sourceUnit = source,
                        targetUnit = target,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.reaction,
                        damageType = dmgType,
                        damageTypeLevel = 1,
                        breakArmor = { BREAK_ARMOR.defend },
                    })
                end
                if (math.rand(1, 100) <= 75) then
                    local de = { stun = 10, hurtReduction = 5 }
                    local dur = math.rand(7, 10)
                    target
                        :buff("破碎破防")
                        :name("破碎破防")
                        :icon("ability/Earthquake")
                        :description(
                        {
                            "防御被击碎", colour.hex(colour.red, "晕抗：-" .. de.stun .. '%'),
                            colour.hex(colour.red, "减伤：-" .. de.hurtReduction .. '%')
                        })
                        :duration(dur)
                        :purpose(
                        function(buffObj)
                            buffObj:stun("-=" .. de.stun)
                            buffObj:hurtReduction("-=" .. de.hurtReduction)
                        end)
                        :rollback(
                        function(buffObj)
                            buffObj:stun("+=" .. de.stun)
                            buffObj:hurtReduction("+=" .. de.hurtReduction)
                        end)
                        :run()
                end
            end
            Enchant(DAMAGE_TYPE.rock.value):reaction(DAMAGE_TYPE.steel.value, react)
            Enchant(DAMAGE_TYPE.steel.value):reaction(DAMAGE_TYPE.rock.value, react)
        end)
        :description(
        {
            "任意一个单位",
            colour.format("身上附着%s时遇到%s伤害", nil, { { colour.khaki, "岩" }, { colour.orange, "钢" } }),
            colour.format("或者附着%s时遇到%s伤害", nil, { { colour.orange, "钢" }, { colour.khaki, "岩" } }),
        }),
    Tpl()
        :name("传染反应")
        :icon("ability/Unused")
        :prop("reward", colour.format(
        "激活反应：传染（全局特性）|n当%s和%s相遇时会形成反应|n周边400半径随机5个敌人会受到%s|n%s|n%s|n%s|n%s|n%s", colour.mediumpurple, {
            { colour.violet, "毒" },
            { colour.lawngreen, "风" },
            { colour.violet, "毒辐射" },
            { colour.violet, "受到影响的单位会产生" },
            { colour.violet, "眩晕、致盲、中毒等各种随机效果5秒" },
            { colour.cornflowerblue, "有25%几率眩晕" },
            { colour.plum, "有30%几率视野减少50点" },
            { colour.violet, "有45%几率毒抗性降低5%" },
        }))
        :prop("rewardDo",
        function()
            local react = function(evtData)
                local target = evtData.targetUnit
                local source = evtData.sourceUnit
                local radius = 400
                local x, y = target:x(), target:y()
                local g = Group():rand(UnitClass, {
                    circle = { x = target:x(), y = target:y(), radius = radius },
                    filter = function(enumUnit)
                        return enumUnit:isAlive() and enumUnit:isEnemy(source:owner())
                    end
                }, 5)
                local dur = 5
                if (isClass(evtData.sourceUnit, UnitClass)) then
                    local mystery = evtData.sourceUnit:enchantMystery() * 0.01 + 1
                    mystery = math.max(0, mystery)
                    dur = dur * mystery
                end
                Effect("PlagueCloud", x, y, 100, 1):size(2)
                for _, eu in ipairs(g) do
                    local isStun = (math.rand(1, 100)) <= 25
                    local isBlind = (math.rand(1, 100)) <= 30
                    local isPoison = (math.rand(1, 100)) <= 45
                    if (isStun or isBlind or isPoison) then
                        eu:attach("PlagueCloudTarget", "origin", 1)
                    end
                    if (isStun) then
                        ability.stun({
                            whichUnit = eu,
                            name = "传染反应",
                            icon = "ability/Unused",
                            duration = dur,
                            description = "传染眩晕",
                        })
                    end
                    if (isBlind) then
                        eu:buff("传染反应")
                          :name("传染反应")
                          :icon("ability/Unused")
                          :description({ "传染致盲", colour.hex(colour.red, "视野：-50") })
                          :duration(dur)
                          :purpose(function(buffObj) buffObj:sight("-=50") end)
                          :rollback(function(buffObj) buffObj:sight("+=50") end)
                          :run()
                    end
                    if (isPoison) then
                        eu:buff("传染反应")
                          :name("传染反应")
                          :icon("ability/Unused")
                          :description({ "传染中毒", colour.hex(colour.red, "毒抗性：-5%") })
                          :duration(dur)
                          :purpose(function(buffObj) buffObj:enchantResistance(DAMAGE_TYPE.poison, "-=5") end)
                          :rollback(function(buffObj) buffObj:enchantResistance(DAMAGE_TYPE.poison, "+=5") end)
                          :run()
                    end
                end
            end
            Enchant(DAMAGE_TYPE.poison.value):reaction(DAMAGE_TYPE.wind.value, react)
            Enchant(DAMAGE_TYPE.wind.value):reaction(DAMAGE_TYPE.poison.value, react)
        end)
        :description(
        {
            "任意一个单位",
            colour.format("身上附着%s时遇到%s伤害", nil, { { colour.violet, "毒" }, { colour.lawngreen, "风" } }),
            colour.format("或者附着%s时遇到%s伤害", nil, { { colour.lawngreen, "风" }, { colour.violet, "毒" } }),
        }),
    Tpl()
        :name("疾风劲草")
        :icon("ability/QuietChop")
        :prop("reward", colour.hex(colour.mediumpurple, "泠技习得时等级额外+1"))
        :prop("rewardDo", function() Game():abilityUpLv(1) end)
        :description(
        {
            colour.format("战胜%s", nil, {
                { colour.lawngreen, "剑泠(疾风)" },
                { colour.gold, "1次" },
            })
        }),
    Tpl()
        :name("影阎红殇")
        :icon("ability/InvincibleChopDown")
        :prop("reward", colour.hex(colour.mediumpurple, "泠技习得时等级额外+1"))
        :prop("rewardDo", function() Game():abilityUpLv(1) end)
        :description(
        {
            colour.format("战胜%s", nil, {
                { colour.indianred, "剑泠(阎殇)" },
                { colour.gold, "1次" },
            })
        }),
    Tpl()
        :name("微波缠水")
        :icon("ability/CleanTheTarget")
        :prop("reward", colour.hex(colour.mediumpurple, "泠技习得时等级额外+1"))
        :prop("rewardDo", function() Game():abilityUpLv(1) end)
        :description(
        {
            colour.format("战胜%s", nil, {
                { colour.deepskyblue, "剑泠(缠水)" },
                { colour.gold, "1次" },
            })
        }),
    Tpl()
        :name("幽冥黑月")
        :icon("ability/DimensionalChop")
        :prop("reward", colour.hex(colour.mediumpurple, "泠技习得时等级额外+1"))
        :prop("rewardDo", function() Game():abilityUpLv(1) end)
        :description(
        {
            colour.format("战胜%s", nil, {
                { colour.mediumpurple, "剑泠(黑月)" },
                { colour.gold, "1次" },
            })
        }),
    Tpl()
        :name("探秘区规则法")
        :icon("ability/AlienRune")
        :prop("reward",
        {
            colour.hex(colour.gold, "能力点: +5"),
            colour.hex(colour.mediumpurple, "了解探秘区神秘"),
        })
        :prop("rewardDo", function() Game():upgradePoint(5) end)
        :description(
        function()
            if (Game():achievement(25)) then
                return "快乐~快乐~"
            else
                return "聊天输入 " .. colour.hex(colour.gold, "快乐探秘区")
            end
        end)
}
local f = function(evtData)
    Game():achievement(25, true)
    async.call(evtData.triggerPlayer, function()
        UIKit("ninegrids_essence"):essence("achievement", 5, false)
    end)
    Game():unCommand("kuailetantanqu")
    Game():unCommand("快乐探秘区")
end
Game():command("kuailetantanqu", f)
Game():command("快乐探秘区", f)
local s = Store("achievement")
s:name("成就")
s:description(function(this)
    return {
        this:name() .. "(" .. colour.hex(colour.gold, "J") .. ")",
        "纪录在这里",
        "效果自动激活"
    }
end)
local c = s:salesGoods():count()
for i = 1, #TPL_ACHIEVEMENT, 1 do
    local v = TPL_ACHIEVEMENT[i]
    v:condition(function() return Game():achievement(i) == true end)
     :conditionPassTips("已达成")
    if (i > c) then
        s:insert(v)
    end
end