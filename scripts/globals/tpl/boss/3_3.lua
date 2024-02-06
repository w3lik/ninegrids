TPL_ABILITY_BOSS["旅泠(方长)"] = {
    AbilityTpl()
        :name("茫然")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/ShadowDispersion")
        :coolDownAdv(15, 0)
        :mpCostAdv(65, 0)
        :castRadiusAdv(350, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local move = math.floor(200 + Game():GD().erode * 0.5)
            local aim = math.floor(30 + Game():GD().erode * 0.05)
            local sight = 700
            return {
                "迷眼遮光，令范围木飙陷入迷茫",
                "被击中的木飙在8秒内移动减慢" .. colour.hex(colour.indianred, move) .. "点",
                "同时命中率降低" .. colour.hex(colour.indianred, aim) .. "%，视野降低" .. colour.hex(colour.indianred, sight),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 35) then
                atkData.triggerAbility:effective({
                    targetX = atkData.targetUnit:x(),
                    targetY = atkData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = effectiveData.targetX, effectiveData.targetY
            local move = math.floor(200 + Game():GD().erode * 0.5)
            local aim = math.floor(30 + Game():GD().erode * 0.05)
            local sight = 700
            effector("SilenceAreaBirth", x, y, nil, 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 10,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    eu:buff("茫然")
                      :signal(BUFF_SIGNAL.down)
                      :icon("ability/ShadowDispersion")
                      :duration(8)
                      :description({
                        colour.hex(colour.indianred, "移动：-" .. move),
                        colour.hex(colour.indianred, "命中：-" .. aim),
                        colour.hex(colour.indianred, "视野：-" .. sight),
                    })
                      :purpose(function(buffObj)
                        buffObj:attach("buff/Vortex", "origin")
                        buffObj:move("-=" .. move)
                        buffObj:aim("-=" .. aim)
                        buffObj:sight("-=" .. sight)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/Vortex", "origin")
                        buffObj:move("+=" .. move)
                        buffObj:aim("+=" .. aim)
                        buffObj:sight("+=" .. sight)
                    end)
                      :run()
                end
            end
        end),
    AbilityTpl()
        :name("捕捉")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/Ensnare")
        :coolDownAdv(35, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(275, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local atkSpd = 35
            return {
                "使用网捕捉范围木飙，每个网最多捕捉2个木飙",
                "被捕捉到的木飙在4秒内" .. colour.hex(colour.red, "无法移动"),
                "每捕捉到1个木飙，增加己身攻速" .. colour.hex(colour.lawngreen, atkSpd) .. "%",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 30) then
                atkData.triggerAbility:effective({
                    targetX = atkData.targetUnit:x(),
                    targetY = atkData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = effectiveData.targetX, effectiveData.targetY
            local atkSpd = 35
            ability.missile({
                modelAlias = "EnsnareMissile",
                sourceUnit = u,
                targetVec = { x, y },
                weaponLength = 100,
                weaponHeight = 100,
                speed = 400,
                height = 100,
                scale = 2,
                onEnd = function(options, vec)
                    local g = Group():catch(UnitClass, {
                        limit = 2,
                        circle = { x = vec[1], y = vec[2], radius = radius },
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end,
                    })
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            local m
                            if (eu:isAir()) then
                                m = "ensnareTargetAir"
                            else
                                m = "ensnareTarget"
                            end
                            eu:buff("捕捉")
                              :signal(BUFF_SIGNAL.down)
                              :icon("ability/Ensnare")
                              :duration(4)
                              :description({ colour.hex(colour.red, "无法移动") })
                              :purpose(function(buffObj)
                                buffObj:attach(m, "chest")
                                buffObj:move("-=522")
                            end)
                              :rollback(function(buffObj)
                                buffObj:detach(m, "chest")
                                buffObj:move("+=522")
                            end)
                              :run()
                            options.sourceUnit:attackSpeed("+=" .. atkSpd)
                        end
                    end
                end
            })
        end),
    AbilityTpl()
        :name("怕怕")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ArcaneFocusedPower")
        :coolDownAdv(35, 0)
        :mpCostAdv(175, 0)
        :description(
        function()
            return {
                "进入隐身状态 5 秒",
                colour.hex(colour.yellow, "在白雾天气里，持续时间+3秒")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 30) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dur = 5
            if (Game():isWeather("fogWhite")) then
                dur = dur + 3
            end
            ability.invisible({
                whichUnit = u,
                duration = dur,
            })
        end),
}