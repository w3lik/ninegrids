TPL_ABILITY_BOSS["毒泠(怪萌)"] = {
    AbilityTpl()
        :name("萌化抵抗")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/MonkEffuse")
        :coolDownAdv(30, 0)
        :mpCostAdv(150, 0)
        :description(
        function()
            return {
                "在" .. colour.hex(colour.gold, "10秒") .. "内提高抵抗力，",
                "岩、风抗性提高" .. colour.hex(colour.gold, "50%"),
                colour.hex(colour.yellow, "在毒雾天气里，毒强化提升10%")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 35) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dur = 10
            if (Game():isWeather("fogPoison")) then
                u:buff("萌化抵抗")
                 :icon("ability/MonkEffuse")
                 :description({
                    colour.hex(colour.lawngreen, "毒强化：+10%"),
                    colour.hex(colour.lawngreen, "岩抗性：+50%"),
                    colour.hex(colour.lawngreen, "风抗性：+50%"),
                })
                 :duration(dur)
                 :purpose(function(buffObj)
                    buffObj:attach("DeathCoilMissile", "origin")
                    buffObj:enchant(DAMAGE_TYPE.poison, "+=10")
                    buffObj:enchantResistance(DAMAGE_TYPE.rock, "+=50")
                    buffObj:enchantResistance(DAMAGE_TYPE.wind, "+=50")
                end)
                 :rollback(function(buffObj)
                    buffObj:detach("DeathCoilMissile", "origin")
                    buffObj:enchant(DAMAGE_TYPE.poison, "-=10")
                    buffObj:enchantResistance(DAMAGE_TYPE.rock, "-=50")
                    buffObj:enchantResistance(DAMAGE_TYPE.wind, "-=50")
                end)
                 :run()
            else
                u:buff("萌化抵抗")
                 :icon("ability/MonkEffuse")
                 :description({
                    colour.hex(colour.lawngreen, "岩抗性：+50%"),
                    colour.hex(colour.lawngreen, "风抗性：+50%"),
                })
                 :duration(dur)
                 :purpose(function(buffObj)
                    buffObj:attach("DeathCoilMissile", "origin")
                    buffObj:enchantResistance(DAMAGE_TYPE.rock, "+=50")
                    buffObj:enchantResistance(DAMAGE_TYPE.wind, "+=50")
                end)
                 :rollback(function(buffObj)
                    buffObj:detach("DeathCoilMissile", "origin")
                    buffObj:enchantResistance(DAMAGE_TYPE.rock, "-=50")
                    buffObj:enchantResistance(DAMAGE_TYPE.wind, "-=50")
                end)
                 :run()
            end
        end),
    AbilityTpl()
        :name("毒射")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/Mucus")
        :coolDownAdv(13, 0)
        :mpCostAdv(75, 0)
        :castRadiusAdv(200, 0)
        :castChantAdv(1, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(550 + Game():GD().erode * 3)
            local defend = math.floor(60 + Game():GD().erode * 0.15)
            return {
                "远程引爆毒性粘液袭击范围木飙",
                "被击中的木飙将受到" .. colour.hex(colour.indianred, dmg) .. "毒伤害",
                "而且在3秒内防御减少" .. colour.hex(colour.indianred, defend) .. "点",
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
            local radius = ab:castRadius()
            local x, y = effectiveData.targetX, effectiveData.targetY
            local dmg = math.floor(550 + Game():GD().erode * 3)
            local defend = math.floor(60 + Game():GD().erode * 0.15)
            effector("eff/PoisonCrack", x, y, japi.Z(x, y), 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 8,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    u:effect("PoisonStingTarget", 1)
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.poison,
                        damageTypeLevel = 2,
                    })
                    eu:buff("毒射")
                      :signal(BUFF_SIGNAL.down)
                      :icon("ability/Mucus")
                      :duration(3)
                      :description({ colour.hex(colour.indianred, "防御：-" .. defend) })
                      :purpose(function(buffObj)
                        buffObj:attach("buff/PoisonHands", "origin")
                        buffObj:defend("-=" .. defend)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/PoisonHands", "origin")
                        buffObj:defend("+=" .. defend)
                    end)
                      :run()
                end
            end
        end),
    AbilityTpl()
        :name("侵蚀蔓延")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ShadowDemonicCircleTeleport")
        :coolDownAdv(30, 0)
        :mpCostAdv(150, 0)
        :castKeepAdv(3, 0)
        :castRadiusAdv(700, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local n = 3
            local dmg = math.floor(1250 + Game():GD().erode * 3)
            return {
                "向四周发射" .. colour.hex(colour.violet, n) .. "波毒球，",
                "第 1 波发射 " .. colour.hex(colour.violet, 10) .. " 个",
                "第 2 波发射 " .. colour.hex(colour.violet, 7) .. " 个",
                "第 3 波发射 " .. colour.hex(colour.violet, 4) .. " 个",
                "每发毒球造成" .. colour.hex(colour.indianred, dmg) .. "毒伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 35) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local dmg = math.floor(1250 + Game():GD().erode * 3)
            local radius = ab:castRadius()
            local x, y, fac = u:x(), u:y(), u:facing()
            local n = 3
            local m = 10
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
                    ability.missile({
                        modelAlias = "ChimaeraAcidMissile",
                        sourceUnit = u,
                        targetVec = { tx, ty, 100 },
                        weaponLength = 100,
                        weaponHeight = 100,
                        speed = 400,
                        height = 100,
                        onEnd = function(options, vec)
                            local g = Group():catch(UnitClass, {
                                limit = 3,
                                circle = { x = vec[1], y = vec[2], radius = 200 },
                                filter = function(enumUnit)
                                    return ab:isCastTarget(enumUnit)
                                end,
                            })
                            effector("eff/PoisonCrack", vec[1], vec[2], nil, 1)
                            if (#g > 0) then
                                for _, eu in ipairs(g) do
                                    ability.damage({
                                        sourceUnit = options.sourceUnit,
                                        targetUnit = eu,
                                        damage = dmg,
                                        damageSrc = DAMAGE_SRC.ability,
                                        damageType = DAMAGE_TYPE.poison,
                                        damageTypeLevel = 1,
                                    })
                                    ability.stun({
                                        sourceUnit = options.sourceUnit,
                                        targetUnit = eu,
                                        duration = stun,
                                    })
                                end
                            end
                        end
                    })
                end
                m = m - 3
                radius = radius - 220
                dmg = dmg * 1.75
            end)
        end),
}