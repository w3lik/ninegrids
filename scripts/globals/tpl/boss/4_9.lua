TPL_ABILITY_BOSS["沙泠(法老尸)"] = {
    AbilityTpl()
        :name("却死逆命")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/FireTotemOfWrath")
        :coolDownAdv(25, 0)
        :mpCostAdv(200, 0)
        :castChantAdv(2, 0)
        :castDistanceAdv(500, 0)
        :castRadiusAdv(300, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(1300 + erode * 8)
            local stun = 2
            return {
                "以 4 块大石头阻挡木飙，石头无敌存在 5 秒",
                "石头消失时对附近造成" .. colour.hex(colour.indianred, dmg) .. "岩伤害",
                "并眩晕" .. colour.hex(colour.indianred, stun) .. "秒",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 50) then
                attackData.triggerAbility:effective({ targetUnit = attackData.targetUnit })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local ab = effectiveData.triggerAbility
            local x, y, facing = tu:x(), tu:y(), tu:facing()
            local erode = Game():GD().erode
            local dmg = math.floor(1300 + erode * 8)
            local stun = 2
            for i = 1, 4 do
                local tx, ty = vector2.polar(x, y, 350, facing + i * 90)
                effector("VolcanoDeath", tx, ty, nil, 2)
                effector("ImpaleTargetDust", tx, ty, nil, 2)
                alerter.circle(tx, ty, 250, 5)
                local su = Game():summons(u:owner(), TPL_UNIT.SUMMON_Barrens_Rocks8, tx, ty, 270)
                su:period(5):hp(1000)
                su:onEvent(EVENT.Object.Destruct, "break", function(destructData)
                    local ex, ey = destructData.triggerUnit:x(), destructData.triggerUnit:y()
                    local g = Group():catch(UnitClass, {
                        circle = { x = ex, y = ey, radius = 250 },
                        limit = 5,
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end
                    })
                    effector("ImpaleTargetDust", x, y, nil, 0.5)
                    effector("eff/SpiritualExplosion", x, y, nil, 0.5)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.rock,
                                damageTypeLevel = 1,
                            })
                            ability.stun({
                                sourceUnit = u,
                                targetUnit = eu,
                                duration = stun,
                            })
                        end
                    end
                end)
            end
        end),
    AbilityTpl()
        :name("砂尘袭卷")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/Brownblast")
        :coolDownAdv(30, 0)
        :mpCostAdv(200, 0)
        :castDistanceAdv(1000, 0)
        :castChantAdv(1, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = 375 + Game():GD().erode * 3
            return {
                "卷起恐怖的砂层，沿途会对木飙造成多段的风岩属性伤害",
                colour.hex(colour.indianred, "砂暴伤害：" .. dmg),
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
            local dmg = 375 + Game():GD().erode * 3
            local radius = 256
            local j = 0
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "eff/SandTornado",
                scale = 1.3,
                speed = 500,
                onMove = function(_, vec)
                    j = j + 1
                    if (j % 9 == 0) then
                        effector("ImpaleTargetDust", vec[1], vec[2], nil, 0.6)
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = radius },
                            limit = 6,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            local dmgType = DAMAGE_TYPE.wind
                            if (j % 20 == 0) then
                                dmgType = DAMAGE_TYPE.rock
                            end
                            for _, eu in ipairs(g) do
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = dmgType,
                                    damageTypeLevel = 1,
                                })
                            end
                        end
                    end
                end,
            })
        end),
    AbilityTpl()
        :name("沙尘暴")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Sandstorm")
        :coolDownAdv(70, 0)
        :mpCostAdv(300, 10)
        :castChantAdv(4, 0)
        :castChantEffect("eff/SandAura")
        :castRadiusAdv(500, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(750 + erode * 6)
            return {
                "在周边卷起7个沙尘，持续10秒",
                "沙层暴风每1秒都会对敌人造成袭击",
                "进入的木飙将受到" .. colour.hex(colour.indianred, dmg) .. "风伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 10) <= 5)
            then hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local erode = Game():GD().erode
            local dmg = math.floor(750 + erode * 6)
            local x, y = u:x(), u:y()
            local n = 7
            local angle = 360 / n
            local radius = 250
            for i = 1, n do
                local nx, ny = vector2.polar(x, y, math.rand(200, ab:castRadius() - 200), angle * i)
                time.setTimeout(0.1 * i, function()
                    local su = Game():summons(u:owner(), TPL_UNIT.SUMMON_SandTornado, nx, ny, 270)
                    su:period(10)
                    time.setInterval(1, function(curTime)
                        if (su:isDead()) then
                            destroy(curTime)
                            return
                        end
                        local tx, ty = su:x(), su:y()
                        local g2 = Group():catch(UnitClass, {
                            circle = { x = tx, y = ty, radius = radius },
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit)
                            end,
                        })
                        if (#g2 > 0) then
                            for _, eu in ipairs(g2) do
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.wind,
                                    damageTypeLevel = 1,
                                })
                            end
                        end
                    end)
                end)
            end
        end),
    AbilityTpl()
        :name("辉煌圣法")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/ChrysanthemumSpace")
        :coolDownAdv(45, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(200, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg1 = math.floor(1500 + Game():GD().erode * 7)
            local dmg2 = math.floor(250 + Game():GD().erode * 1.5)
            return {
                "来自法老的古老而神秘的光至术法",
                "降下光至印打击范围木飙造成" .. colour.hex(colour.indianred, dmg1) .. "光伤害",
                "印记会残留并持续对范围木飙造成" .. colour.hex(colour.indianred, dmg2) .. "光伤害",
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
            local dmg1 = math.floor(1500 + Game():GD().erode * 7)
            local dmg2 = math.floor(250 + Game():GD().erode * 1.5)
            effector("eff/ShiningFlare", x, y, nil, 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 8,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg1,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.light,
                        damageTypeLevel = 2,
                    })
                end
            end
            local e
            time.setTimeout(0.1, function()
                e = Effect("eff/SacredStorm", x, y, nil, -1)
            end)
            local ti = 0
            time.setInterval(0.3, function(curTimer)
                ti = ti + 1
                if (ti > 16 or u:isDead()) then
                    destroy(curTimer)
                    destroy(e)
                    return
                end
                local g2 = Group():catch(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    limit = 6,
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit)
                    end
                })
                if (#g2 > 0) then
                    for _, eu in ipairs(g2) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg2,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.light,
                            damageTypeLevel = 0,
                        })
                    end
                end
            end)
        end),
}