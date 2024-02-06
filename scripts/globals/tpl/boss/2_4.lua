TPL_ABILITY_BOSS["剑泠(阎殇)"] = {
    AbilityTpl()
        :name("赤剑泠")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/DemonSword")
        :description({ "领悟赤至剑意", "增加自身的伤害" })
        :attributes(
        {
            { "attack", 45, 0 },
            { "damageIncrease", 7.5, 0 },
            { "crit", 15, 0 },
            { SYMBOL_ODD .. "crit", 15, 0 },
        }),
    AbilityTpl()
        :name("龙神气焰归泠缠")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/FireDragonTotem")
        :coolDownAdv(10, 0)
        :mpCostAdv(150, 0)
        :castDistanceAdv(1000, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = 140 + Game():GD().erode * 3
            return {
                "缠出致死性的剑气，沿途会对木飙造成多段的火属性伤害",
                "挥缠达3次后，剑气会幻化成龙神，造成更快更强的打击",
                colour.hex(colour.indianred, "缠击伤害：" .. dmg),
                colour.hex(colour.indianred, "龙神伤害：" .. dmg * 2),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 40) then
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
            local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
            local x, y = vector2.polar(x1, y1, distance, vector2.angle(x1, y1, x2, y2))
            local dmg = 140 + Game():GD().erode * 3
            local radius = 130
            local modelAlias = "slash/RedBladeShockwave"
            local speed = 400
            local scale = 1.5
            local n = ab:prop("龙神气焰归泠缠") or 0
            if (n >= 3) then
                n = 0
                dmg = dmg * 2
                radius = 150
                modelAlias = "eff/FireworksDragonHead"
                speed = 500
                scale = 1.3
            end
            n = n + 1
            ab:prop("龙神气焰归泠缠", n)
            local j = 0
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = modelAlias,
                scale = scale,
                speed = speed,
                onMove = function(_, vec)
                    j = j + 1
                    if (j % 7 == 0) then
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = radius },
                            limit = 10,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                effector("slash/Flame_flash2", eu:x(), eu:y(), eu:h(), 0.6)
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
                    end
                end,
            })
        end),
    AbilityTpl()
        :name("落九天")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Firebird")
        :coolDownAdv(60, 0)
        :mpCostAdv(250, 0)
        :castKeepAdv(9, 0)
        :castRadiusAdv(800, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local gd = Game():GD()
            local dmg = math.floor(450 + gd.erode * 3)
            return {
                "从深渊召唤剑阵，从天而降攻击范围木飙",
                "剑阵在持续时间内最多召唤9把剑",
                colour.hex(colour.indianred, "剑阵伤害：" .. dmg),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 20) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local gd = Game():GD()
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local dmg = math.floor(450 + gd.erode * 3)
            local x, y = u:x(), u:y()
            local ti = 0
            local frq = 1
            time.setInterval(frq, function(curTimer)
                ti = ti + frq
                if (ti >= 9 or u:isAbilityKeepCasting() == false) then
                    destroy(curTimer)
                    return
                end
                local r2 = 400
                local cu = Group():closest(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                })
                local tx, ty
                if (isClass(cu, UnitClass)) then
                    tx, ty = cu:x(), cu:y()
                else
                    tx, ty = vector2.polar(x, y, math.rand(r2 / 2, radius), math.rand(0, 359))
                end
                alerter.circle(tx, ty, r2, 1.1)
                local e = Effect("eff/KingdomComeOpt", tx, ty, 0, 1.5)
                time.setTimeout(0.5, function()
                    e:speed(2)
                    local g = Group():catch(UnitClass, {
                        circle = { x = tx, y = ty, radius = r2 },
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
                                damageType = DAMAGE_TYPE.fire,
                                damageTypeLevel = 3
                            })
                        end
                    end
                end)
            end)
        end),
}