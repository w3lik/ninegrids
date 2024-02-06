TPL_ABILITY_BOSS["枪泠(电弧鼠)"] = {
    AbilityTpl()
        :name("磁化")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/HolyStrike")
        :description(
        {
            "攻击成功时有5%几率令木飙感电",
            "木飙会被绝对打断0.1秒，并在2秒内降低" .. colour.hex(colour.indianred, "100点移动")
        })
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            local tu = atkData.targetUnit
            ability.stun({
                odds = 999,
                targetUnit = tu,
                duration = 0.1,
            })
            tu:buff("磁化")
              :signal(BUFF_SIGNAL.down)
              :icon("ability/HolyStrike")
              :description({ colour.hex(colour.lawngreen, "移动：-100") })
              :duration(2)
              :purpose(function(buffObj) buffObj:move("-=100") end)
              :rollback(function(buffObj) buffObj:move("+=100") end)
              :run()
        end),
    AbilityTpl()
        :name("宇宙射线")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/EarthquakeAndThunder")
        :coolDownAdv(75, 0)
        :mpCostAdv(245, 0)
        :castChantAdv(3, 0)
        :castRadiusAdv(350, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(1100 + Game():GD().erode * 5)
            local sight = 300
            return {
                "从太空发射巨大的雷打击，持续伤害范围木飙",
                "被击中的木飙会受到持续的" .. colour.hex(colour.indianred, dmg) .. "雷伤害",
                "同时视野在10秒内降低" .. colour.hex(colour.indianred, sight),
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
            local dmg = math.floor(1100 + Game():GD().erode * 5)
            local sight = 300
            Effect("eff/LightningStrike", x, y, nil, 1):size(radius / 256)
            local i = 0
            time.setInterval(0.08, function(curTimer)
                i = i + 1
                if (i > 3) then
                    destroy(curTimer)
                    return
                end
                local g = Group():catch(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    limit = 10,
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit)
                    end
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.thunder,
                            damageTypeLevel = 2,
                        })
                        eu:buff("宇宙射线")
                          :signal(BUFF_SIGNAL.down)
                          :icon("ability/EarthquakeAndThunder")
                          :duration(10)
                          :description({
                            colour.hex(colour.indianred, "视野：-" .. sight),
                        })
                          :purpose(function(buffObj)
                            buffObj:attach("buff/Vortex", "origin")
                            buffObj:sight("-=" .. sight)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("buff/Vortex", "origin")
                            buffObj:sight("+=" .. sight)
                        end)
                          :run()
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("过去式未来")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/HolyWrath")
        :coolDownAdv(35, 0)
        :mpCostAdv(100, 0)
        :description(
        function()
            local delay = 10
            return {
                "在时间轴写下一笔记录，当前的位置和HP、MP",
                "在未来" .. colour.hex(colour.gold, delay .. "秒后"),
                "回到过去",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 15) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = u:x(), u:y()
            local hpCur = u:hpCur()
            local mpCur = u:mpCur()
            local delay = 10
            u:buff("过去式未来")
             :icon("ability/HolyWrath")
             :description("过去式途中")
             :duration(delay)
             :purpose(function(buffObj)
                buffObj:attach("buff/MysticAndSmart", "head")
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/MysticAndSmart", "head")
                buffObj:position(x, y)
                buffObj:hpCur("+=" .. (hpCur - buffObj:hpCur()))
                buffObj:mpCur("+=" .. (mpCur - buffObj:mpCur()))
            end)
             :run()
        end),
}