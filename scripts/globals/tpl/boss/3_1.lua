TPL_ABILITY_BOSS["龙泠(青龙拳师)"] = {
    AbilityTpl()
        :name("秘术·龙拳")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/LightArrowBrust")
        :coolDownAdv(10, 0)
        :mpCostAdv(125, 0)
        :castDistanceAdv(1000, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = 280 + Game():GD().erode * 2.5
            return {
                "挥出龙拳气功波，沿途会对木飙造成多段的光属性伤害",
                colour.hex(colour.indianred, "龙拳气功波：" .. dmg),
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
            local distance = ab:castDistance()
            local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
            local x, y = vector2.polar(x1, y1, distance, vector2.angle(x1, y1, x2, y2))
            local dmg = 280 + Game():GD().erode * 2.5
            local j = 0
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "missile/ValiantChargeRoyal",
                scale = 1.5,
                speed = 450,
                height = 0,
                onMove = function(_, vec)
                    j = j + 1
                    if (j % 9 == 0) then
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = 150 },
                            limit = 8,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                effector("slash/Ephemeral_Cut_Teal", eu:x(), eu:y(), eu:h(), 0.6)
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.light,
                                    damageTypeLevel = 0,
                                })
                            end
                        end
                    end
                end,
            })
        end),
    AbilityTpl()
        :name("秘术·挄散")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/FlowersDazzling")
        :coolDownAdv(55, 0)
        :mpCostAdv(200, 0)
        :castKeepAdv(3, 0)
        :castRadiusAdv(150, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local n = 4
            local dmg = math.floor(500 + Game():GD().erode * 3)
            return {
                "向四周爆冲" .. colour.hex(colour.violet, n) .. "波光至爆散，",
                "第 1 波炸裂 " .. colour.hex(colour.violet, 5) .. " 个",
                "第 2 波炸裂 " .. colour.hex(colour.violet, 7) .. " 个",
                "第 3 波炸裂 " .. colour.hex(colour.violet, 9) .. " 个",
                "第 4 波炸裂 " .. colour.hex(colour.violet, 11) .. " 个",
                "每发爆散造成" .. colour.hex(colour.indianred, dmg) .. "光伤害",
                "还能同时造成" .. colour.hex(colour.indianred, dmg) .. "雷伤害",
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
            local ab = effectiveData.triggerAbility
            local dmg = math.floor(500 + Game():GD().erode * 3)
            local x, y, fac = u:x(), u:y(), u:facing()
            local radius = 150
            local n = 4
            local m = 5
            local j = 0
            time.setInterval(0.3, function(curTimer)
                curTimer:period(1)
                j = j + 1
                if (j > n or u:isAbilityKeepCasting() == false) then
                    destroy(curTimer)
                    destroy(aura)
                    return
                end
                local a = 360 / m
                for i = 1, m do
                    local tx, ty = vector2.polar(x, y, radius, fac + a * i)
                    local g = Group():catch(UnitClass, {
                        limit = 3,
                        circle = { x = tx, y = ty, radius = 160 },
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end,
                    })
                    effector("war3mapImports\\ElectricMouseTargetW.mdl", tx, ty, 100 + japi.Z(tx, ty), 1)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            eu:attach("BoltImpact", "origin", 1)
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.light,
                                damageTypeLevel = 1,
                            })
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.thunder,
                                damageTypeLevel = 1,
                            })
                        end
                    end
                end
                m = m + 2
                radius = radius + 150
            end)
        end),
    AbilityTpl()
        :name("秘术·降雷")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/ManaFlare")
        :coolDownAdv(13, 0)
        :mpCostAdv(75, 0)
        :castRadiusAdv(150, 0)
        :castDistanceAdv(600, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(400 + erode * 2)
            local thunder = 50
            return {
                "乘上雷霆冲击木飙，造成" .. colour.hex(colour.indianred, dmg) .. "雷伤害",
                "被击中的木飙在5秒内" .. colour.hex(colour.indianred, thunder) .. "%雷抗性",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 10) <= 5) then
                atkData.triggerAbility:effective({
                    targetUnit = atkData.targetUnit,
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(400 + erode * 2)
            local thunder = 50
            ability.leap({
                sourceUnit = u,
                targetUnit = tu,
                modelAlias = "buff/LightningBlueFire",
                speed = 1500,
                height = 100,
                onEnd = function(options, vec)
                    effector("eff/ElectricSpark", vec[1], vec[2], nil, 1)
                    if (options.sourceUnit:isDead() or options.targetUnit:isDead()) then
                        return
                    end
                    local g = Group():catch(UnitClass, {
                        limit = 3,
                        circle = { x = vec[1], y = vec[2], radius = radius },
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end,
                    })
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = options.sourceUnit,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.thunder,
                                damageTypeLevel = 0,
                            })
                            eu:buff("秘术·翔雷")
                              :signal(BUFF_SIGNAL.down)
                              :icon("ability/ManaFlare")
                              :duration(5)
                              :description({ colour.hex(colour.indianred, "雷抗：-" .. thunder .. '%') })
                              :purpose(function(buffObj)
                                buffObj:attach("buff/SweepLightningSmall", "origin")
                                buffObj:resistance(DAMAGE_TYPE.thunder, "-=" .. thunder)
                            end)
                              :rollback(function(buffObj)
                                buffObj:detach("buff/SweepLightningSmall", "origin")
                                buffObj:resistance(DAMAGE_TYPE.thunder, "+=" .. thunder)
                            end)
                              :run()
                        end
                    end
                end
            })
        end),
}