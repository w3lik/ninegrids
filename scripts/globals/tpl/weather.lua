TPL_WEATHER = {
    Tpl()
        :name("晴空")
        :icon("ability/AtmosphericShock")
        :description(
        {
            "神情气爽，一览无遗",
            "一切的最终",
            "都将归于平静"
        }),
    Tpl()
        :name("烈日")
        :icon("ability/TheEndOfTheSun")
        :description(
        {
            "烈日当空，万物复苏",
            "万物有灵，日照大地",
            colour.format("恢复附近木飙的%s或%s", nil, {
                { colour.limegreen, "生命" },
                { colour.limegreen, "生命恢复" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.sun)
        :prop("weatherInterval", 25)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local at = math.rand(1, 2)
                    if (at == 1) then
                        eu:effect("RejuvenationTarget", 1)
                        eu:hpBack(10 * math.rand(30, 60))
                    elseif (at == 2) then
                        local dur = math.rand(7, 12)
                        local re = math.trunc(0.1 * (math.rand(9, 23) + 0.3 * Game():GD().erode), 1)
                        eu:buff("weather_sun")
                          :signal(BUFF_SIGNAL.up)
                          :name("日光浴")
                          :icon("ability/TheEndOfTheSun")
                          :description({ "日光笼罩", colour.hex(colour.limegreen, "HP恢复：+" .. re) })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                enchant.append(buffObj, DAMAGE_TYPE.light, 1)
                                buffObj:attach("RejuvenationTarget", "origin")
                                buffObj:hpRegen("+=" .. re)
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("RejuvenationTarget", "origin")
                                buffObj:hpRegen("-=" .. re)
                            end)
                          :run()
                    end
                end
            end
        end),
    Tpl()
        :name("幽月")
        :icon("ability/TalentspecDruidBalance")
        :description(
        {
            "云儿织布，月梯徐徐",
            "银光铺洒，悠然恬静",
            colour.format("恢复附近木飙的%s或%s", nil, {
                { colour.skyblue, "魔法" },
                { colour.skyblue, "魔法恢复" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.moon)
        :prop("weatherInterval", 25)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local at = math.rand(1, 2)
                    if (at == 1) then
                        eu:effect("ClarityTarget", 1)
                        eu:mpBack(10 * math.rand(15, 30))
                    elseif (at == 2) then
                        local dur = math.rand(8, 13)
                        local re = math.trunc(0.07 * (math.rand(5, 15) + 0.1 * Game():GD().erode), 1)
                        eu:buff("weather_moon")
                          :signal(BUFF_SIGNAL.up)
                          :name("月光浴")
                          :icon("ability/TalentspecDruidBalance")
                          :description({ "月光幽静", colour.hex(colour.skyblue, "MP恢复：+" .. re) })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                enchant.append(buffObj, DAMAGE_TYPE.dark, 1)
                                buffObj:attach("ClarityTarget", "origin")
                                buffObj:mpRegen("+=" .. re)
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("ClarityTarget", "origin")
                                buffObj:mpRegen("-=" .. re)
                            end)
                          :run()
                    end
                end
            end
        end),
    Tpl()
        :name("狂风")
        :icon("ability/Cyclone")
        :description(
        {
            "凌冽大风，呼呼作响",
            "风刃刮起",
            colour.format("可能会被吹飞和造成%s伤害", nil, {
                { colour.lawngreen, "风属性" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.wind)
        :prop("weatherInterval", 16)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local x = eu:x() + math.rand(-230, 230)
                    local y = eu:y() + math.rand(-230, 230)
                    local ti = 0
                    local t = math.rand(3, 6)
                    local e = Effect("aura/CycloneShield", x, y, japi.Z(x, y) + 40, -1)
                    audio(V3d("wind001"), nil, function(this) this:xyz(x, y, 0) end)
                    async.setInterval(0.3, function(curTimer)
                        local gus = Group():catch(UnitClass, {
                            circle = { x = x, y = y, radius = 110 },
                            filter = function(enumUnit) return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false end
                        })
                        ti = ti + 0.3
                        if (ti > t) then
                            destroy(curTimer)
                            destroy(e)
                            if (#gus > 0) then
                                for _, gu in ipairs(gus) do
                                    gu:effect("TornadoElementalSmall", 0.5)
                                    local h = math.rand(175, 300)
                                    ability.crackFly({
                                        name = "旋风",
                                        description = "凌冽大风吹飞",
                                        icon = "ability/Cyclone",
                                        targetUnit = gu,
                                        effect = "Tornado_Target",
                                        distance = math.rand(25, 50),
                                        height = h,
                                        duration = h / 200,
                                        onEnd = function(options, _)
                                            ability.damage({
                                                targetUnit = options.targetUnit,
                                                damage = h / 7 + 3 * Game():GD().erode,
                                                damageSrc = DAMAGE_SRC.common,
                                                damageType = DAMAGE_TYPE.wind,
                                                damageTypeLevel = 1
                                            })
                                        end
                                    })
                                end
                            end
                        else
                            if (#gus > 0) then
                                for _, gu in ipairs(gus) do
                                    ability.damage({
                                        targetUnit = gu,
                                        damage = 6 + Game():GD().erode,
                                        damageSrc = DAMAGE_SRC.common,
                                        damageType = DAMAGE_TYPE.wind,
                                        damageTypeLevel = 0
                                    })
                                end
                            end
                        end
                    end)
                end
            end
        end),
    Tpl()
        :name("细雨")
        :icon("ability/Tranquility")
        :description(
        {
            "细雨绵绵，如芒刺背",
            "雨中漫步",
            colour.format("可能使%s变%s", nil, {
                { colour.violet, "速度" },
                { colour.red, "慢" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.rain)
        :prop("weatherInterval", 20)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local at = math.rand(1, 2)
                    if (at == 1) then
                        local de = math.rand(10, 23)
                        local dur = math.rand(3, 5)
                        eu:buff("weather_rain")
                          :signal(BUFF_SIGNAL.down)
                          :name("细雨绵缠")
                          :icon("ability/Tranquility")
                          :description({ "令人厌烦的湿润", colour.hex(colour.red, "攻击速度：-" .. de .. '%') })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                enchant.append(buffObj, DAMAGE_TYPE.water, 1)
                                buffObj:attach("buff/waterHands", "origin")
                                buffObj:attackSpeed("-=" .. de)
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("buff/waterHands", "origin")
                                buffObj:attackSpeed("+=" .. de)
                            end)
                          :run()
                    elseif (at == 2) then
                        local de = math.rand(40, 80)
                        local dur = math.rand(4, 7)
                        eu:buff("weather_rain")
                          :signal(BUFF_SIGNAL.down)
                          :name("细雨如链")
                          :icon("ability/Tranquility")
                          :description({ "步途被浸透", colour.hex(colour.red, "移动速度：-" .. de) })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                enchant.append(buffObj, DAMAGE_TYPE.water, 1)
                                buffObj:attach("buff/waterHands", "origin")
                                buffObj:move("-=" .. de)
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("buff/waterHands", "origin")
                                buffObj:move("+=" .. de)
                            end)
                          :run()
                    end
                end
            end
        end),
    Tpl()
        :name("雷暴")
        :icon("ability/Stormthundercloud")
        :description(
        {
            "千军雷霆，万马崩腾",
            "突如其来的霹雳",
            colour.format("可能打断动作和造成%s伤害", nil, {
                { colour.yellow, "雷属性" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.rainstorm)
        :prop("weatherInterval", 15)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                audio(V3d("electronic002"), nil, function(this)
                    this:xyz(enumUnits[1]:x(), enumUnits[1]:y(), 0)
                end)
                for _, eu in ipairs(enumUnits) do
                    for _ = 1, 3 do
                        local x = eu:x() + math.rand(-230, 230)
                        local y = eu:y() + math.rand(-230, 230)
                        local t = math.rand(1, 3)
                        local e = Effect("aura/MassDispel", x, y, japi.Z(x, y) + 20, -1)
                        async.setTimeout(t, function()
                            destroy(e)
                            local gus = Group():catch(UnitClass, {
                                circle = { x = x, y = y, radius = 100 },
                                filter = function(enumUnit) return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false end
                            })
                            effector("eff/LightningsLong", x, y, japi.Z(x, y), 0.3)
                            effector("eff/LightningWeb", x, y, japi.Z(x, y), 3)
                            if (#gus > 0) then
                                for _, uu in ipairs(gus) do
                                    ability.stun({ targetUnit = uu, duration = 0.2, icon = "ability/Stormthundercloud" })
                                    uu:effect("eff/ThunderballFlashing", 0)
                                    uu:attach("buff/LightningBlueFire", "origin", 2)
                                    ability.damage({
                                        targetUnit = uu,
                                        damage = 55 + 6 * Game():GD().erode,
                                        damageSrc = DAMAGE_SRC.common,
                                        damageType = DAMAGE_TYPE.thunder,
                                        damageTypeLevel = 1
                                    })
                                end
                            end
                        end)
                    end
                end
            end
        end),
    Tpl()
        :name("纷飞雪")
        :icon("ability/BranchSnowFlake")
        :description(
        {
            "飘落白花，透彻心寒",
            "在雪中穿行",
            colour.format("可能会%s和%s急剧变%s", nil, {
                { colour.aliceblue, "被冻结" },
                { colour.violet, "速度" },
                { colour.red, "慢" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.snow)
        :prop("weatherInterval", 20)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local at = math.rand(1, 2)
                    if (at == 1) then
                        local dur = math.rand(1, 3)
                        enchant.append(eu, DAMAGE_TYPE.ice, 1)
                        ability.freeze({
                            name = "凝聚至雪",
                            icon = "ability/BranchSnowFlake",
                            description = "雪的寒冷令其冻结",
                            whichUnit = eu,
                            red = 100,
                            green = 100,
                            blue = 255,
                            duration = dur
                        })
                    elseif (at == 2) then
                        local de = math.rand(120, 150)
                        local dur = math.rand(2, 3)
                        eu:buff("weather_snow")
                          :name("心寒至雪")
                          :icon("ability/BranchSnowFlake")
                          :description({ "透彻至寒心", colour.hex(colour.red, "移动速度：-" .. de) })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                enchant.append(eu, DAMAGE_TYPE.ice, 1)
                                buffObj:move("-=" .. de)
                                buffObj:attach("buff/IceCube", "origin")
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("buff/IceCube", "origin")
                                buffObj:move("+=" .. de)
                            end)
                          :run()
                    end
                end
            end
        end),
    Tpl()
        :name("暴风雪")
        :icon("ability/RainOfSnow")
        :description(
        {
            "凛冽寒风，惊涛骇浪",
            "暴风雪中行动",
            colour.format("很可能受到%s的%s侵害", nil, {
                { colour.lightsteelblue, "减速雪风" },
                { colour.lightsteelblue, "冰属性" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.snowstorm)
        :prop("weatherInterval", 18)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local x = eu:x() + math.rand(-325, 325)
                    local y = eu:y() + math.rand(-325, 325)
                    local ti = 0
                    local t = math.rand(7, 11)
                    local e = Effect("aura/FreezingField", x, y, japi.Z(x, y) + 20, -1)
                    async.setInterval(1.5, function(curTimer)
                        local gus = Group():catch(UnitClass, {
                            circle = { x = x, y = y, radius = 375 },
                            filter = function(enumUnit) return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false end
                        })
                        ti = ti + 1.5
                        if (ti > t) then
                            destroy(curTimer)
                            destroy(e)
                            return
                        end
                        if (#gus > 0) then
                            for _, gu in ipairs(gus) do
                                local de = math.rand(45, 60)
                                eu:buff("weather_snowstorm")
                                  :name("凛冽风雪")
                                  :icon("ability/RainOfSnow")
                                  :description({ "惊涛骇浪", colour.hex(colour.red, "移动速度：-" .. de) })
                                  :duration(1)
                                  :purpose(
                                    function(buffObj)
                                        buffObj:move("-=" .. de)
                                        buffObj:attach("buff/Icing", "origin")
                                    end)
                                  :rollback(
                                    function(buffObj)
                                        buffObj:detach("buff/Icing", "origin")
                                        buffObj:move("+=" .. de)
                                    end)
                                  :run()
                                ability.damage({
                                    targetUnit = gu,
                                    damage = 12 + 2 * Game():GD().erode,
                                    damageSrc = DAMAGE_SRC.common,
                                    damageType = DAMAGE_TYPE.ice,
                                    damageTypeLevel = 2
                                })
                            end
                        end
                    end)
                end
            end
        end),
    Tpl()
        :name("迷雾")
        :icon("ability/WindofFrost")
        :description(
        {
            "变幻莫测，凝重如海",
            "处于梦幻迷雾中",
            colour.format("很可能%s和%s", nil, {
                { colour.khaki, "失去视野" },
                { colour.beige, "丢失木飙" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.mistWhiteHeave)
        :prop("weatherInterval", 16)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    local at = math.rand(1, 2)
                    if (at == 1) then
                        local de = math.rand(20, 35)
                        local dur = math.rand(5, 8)
                        eu:buff("weather_mistWhite")
                          :name("遮眼至雾")
                          :icon("ability/WindofFrost")
                          :description({ "诡异魔气", colour.hex(colour.red, "命中率：-" .. de) })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                buffObj:aim("-=" .. de)
                                buffObj:attach("buff/VerityView", "origin")
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("buff/VerityView", "origin")
                                buffObj:aim("+=" .. de)
                            end)
                          :run()
                    elseif (at == 2) then
                        local de
                        if (time.isNight()) then
                            de = table.rand({ 100, 150, 200 })
                        else
                            de = table.rand({ 200, 250, 300 })
                        end
                        local dur = math.rand(7, 11)
                        eu:buff("weather_mistWhite")
                          :name("迷踪至雾")
                          :icon("ability/WindofFrost")
                          :description({ "白气弥漫", colour.hex(colour.red, "视野范围：-" .. de) })
                          :duration(dur)
                          :purpose(
                            function(buffObj)
                                buffObj:sight("-=" .. de)
                                buffObj:attach("buff/VerityView", "origin")
                            end)
                          :rollback(
                            function(buffObj)
                                buffObj:detach("buff/VerityView", "origin")
                                buffObj:sight("+=" .. de)
                            end)
                          :run()
                    end
                end
            end
        end),
    Tpl()
        :name("毒雾")
        :icon("ability/FrozenSoil")
        :description(
        {
            "雾恒熏昼，毒风烧心",
            "侵泡在毒雾中",
            colour.format("极大可能会持续地受到毒雾的%s侵害", nil, {
                { colour.palegreen, "毒属性" },
            })
        })
        :prop("weatherType", WEATHER_TYPE.mistGreenHeave)
        :prop("weatherInterval", 1.5)
        :prop("weatherDo",
        function(enumUnits)
            if (#enumUnits > 0) then
                for _, eu in ipairs(enumUnits) do
                    eu:attach("buff/VenomousGaleV2Portrait", "origin", 1)
                    ability.damage({
                        targetUnit = eu,
                        damage = 8 + Game():GD().erode,
                        damageSrc = DAMAGE_SRC.common,
                        damageType = DAMAGE_TYPE.poison,
                        damageTypeLevel = 0
                    })
                end
            end
        end),
}
local s = Store("weather")
s:name("气候控制")
s:description(function(this)
    local desc = {
        this:name() .. "(" .. colour.hex(colour.gold, "T") .. ")",
        "神奇的力量",
        "能控制天气"
    }
    if (Game():achievement(6) ~= true) then
        table.insert(desc, colour.hex(colour.red, "尚未习得气候控制"))
    end
    return desc
end)
local c = s:salesGoods():count()
for i = 1, #TPL_WEATHER, 1 do
    local v = TPL_WEATHER[i]
    v:prop("idx", i)
    v:condition(function() return true == Game():achievement(6) end)
    v:conditionTips("获得" .. colour.hex(colour.red, "气候控制"))
    if (i > c) then
        s:insert(v)
    end
end