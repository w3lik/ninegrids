TPL_ABILITY_BOSS["破灭至泠(狱炎爆蜥)"] = {
    AbilityTpl()
        :name("火弹连轰")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/FourFireWarheads")
        :coolDownAdv(40, 0)
        :mpCostAdv(250, 0)
        :castChantAdv(2, 0)
        :castKeepAdv(1.7, 0)
        :castRadiusAdv(2000, 0)
        :description(
        function()
            local dmg1 = math.floor(575 + Game():GD().erode * 0.5)
            local dmg2 = math.floor(900 + Game():GD().erode * 0.8)
            return {
                "掷出三轮火弹，共12个小火弹，8个大火弹，15个小火弹，",
                "火弹击中木飙后造成大量的火伤害",
                colour.hex(colour.indianred, "小火弹伤害：" .. dmg1),
                colour.hex(colour.indianred, "大火弹伤害：" .. dmg2),
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
            local ab = effectiveData.triggerAbility
            local distance = ab:castRadius()
            local x, y, fac = u:x(), u:y(), u:facing()
            local dmg1 = math.floor(575 + Game():GD().erode * 0.5)
            local dmg2 = math.floor(900 + Game():GD().erode * 0.8)
            local shot = function(modelAlias, tx, ty, dmg, radius)
                ability.missile({
                    sourceUnit = u,
                    targetVec = { tx, ty },
                    modelAlias = modelAlias,
                    scale = 1,
                    speed = 600,
                    onMove = function(options, vec)
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = radius },
                            limit = 3,
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit)
                            end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                effector("eff/CorpseExplosion", eu:x(), eu:y(), eu:h(), 1)
                                ability.damage({
                                    sourceUnit = options.sourceUnit,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.fire,
                                    damageTypeLevel = 1,
                                })
                            end
                            return false
                        end
                    end,
                })
            end
            time.setTimeout(0.3, function()
                for i = 1, 12 do
                    local tx, ty = vector2.polar(x, y, distance, fac + 30 * i)
                    shot("eff/FireBomb2", tx, ty, dmg1, 150)
                end
                time.setTimeout(0.7, function()
                    for i = 1, 8 do
                        local tx, ty = vector2.polar(x, y, distance, fac + 45 * i)
                        shot("eff/FireBomb", tx, ty, dmg2, 200)
                    end
                    time.setTimeout(0.7, function()
                        for i = 1, 15 do
                            local tx, ty = vector2.polar(x, y, distance, fac + 22.5 * i)
                            shot("eff/FireBomb2", tx, ty, dmg1, 150)
                        end
                    end)
                end)
            end)
        end),
    AbilityTpl()
        :name("升天爆炎")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/DeathManuscript")
        :coolDownAdv(18, 0)
        :mpCostAdv(300, 0)
        :castChantAdv(1, 0)
        :castRadiusAdv(250, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local n = 8
            local dmg = math.floor(1400 + Game():GD().erode * 1)
            return {
                "震击引爆地面烈焰" .. colour.hex(colour.indianred, n) .. "次",
                "爆蜥至后会因为后冲力进入眩晕 2 秒",
                colour.hex(colour.indianred, "爆烈伤害：" .. dmg),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 20) then
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
            local x, y = effectiveData.targetX, effectiveData.targetY
            local angle = vector2.angle(u:x(), u:y(), x, y)
            local n = 8
            local dmg = math.floor(1400 + Game():GD().erode * 1)
            local i = 0
            ability.stun({
                targetUnit = u,
                duration = 2,
            })
            time.setInterval(0.4, function(curTimer)
                local tx, ty = vector2.polar(x, y, 220 + i * 150, angle)
                effector("eff/MagmaExplosion", tx, ty, nil, 1)
                local g = Group():catch(UnitClass, {
                    circle = { x = tx, y = ty, radius = 250 },
                    limit = 3,
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit)
                    end
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        effector("eff/CorpseExplosion", eu:x(), eu:y(), eu:h(), 1)
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.fire,
                            damageTypeLevel = 2,
                        })
                    end
                    return false
                end
                i = i + 1
                if (i >= n) then
                    destroy(curTimer)
                    return
                end
            end)
        end),
    AbilityTpl()
        :name("地狱浪潮")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/DemonHugeFireball")
        :coolDownAdv(30, 0)
        :mpCostAdv(350, 0)
        :castChantAdv(2, 0)
        :castChantEffect("DoomTarget")
        :castRadiusAdv(275, 0)
        :castDistanceAdv(1500, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(300 + Game():GD().erode * 0.3)
            return {
                "凝聚出一个巨大的焱浪，灼烧一直线的敌人",
                "火势会逐渐变大，并且逐渐提升伤害",
                colour.hex(colour.indianred, "灼烧伤害：" .. dmg),
                colour.hex(colour.indianred, "伤害提升：10"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 25) then
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
            local distance = ab:castDistance()
            local dmg = math.floor(300 + Game():GD().erode * 0.3)
            local radius = 275
            local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
            local x, y = vector2.polar(x1, y1, distance, vector2.angle(x1, y1, x2, y2))
            local j = 0
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "eff/MinitypeFlame02",
                scale = 1,
                speed = 280,
                onMove = function(options, vec)
                    j = j + 1
                    radius = radius + 1
                    options.arrowToken:size("+=0.002")
                    if (j % 15 == 0) then
                        local angle = vector2.angle(vec[1], vec[2], x, y)
                        Effect("eff/BurningRock", vec[1], vec[2], nil, 2):size(0.5):rotateZ(angle)
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = radius },
                            limit = 5,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.fire,
                                    damageTypeLevel = 0,
                                })
                            end
                        end
                        dmg = dmg + 10
                    end
                end,
            })
        end),
}