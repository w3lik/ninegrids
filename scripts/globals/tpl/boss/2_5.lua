TPL_ABILITY_BOSS["洞悉至泠(噬灵妖怪)"] = {
    AbilityTpl()
        :name("深渊魔怪")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/DOTAdeptTraining")
        :coolDownAdv(35, 0)
        :mpCostAdv(250, 0)
        :castRadiusAdv(220, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg1 = math.floor(800 + Game():GD().erode * 4)
            local dmg2 = math.floor(120 + Game():GD().erode * 0.5)
            return {
                "从海底深渊召唤而来的4个巨大触手",
                "降下深渊黑暗打击范围木飙造成" .. colour.hex(colour.indianred, dmg1) .. "暗伤害",
                "触手会集中并持续对范围木飙造成" .. colour.hex(colour.indianred, dmg2) .. "水伤害",
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
            local dmg1 = math.floor(800 + Game():GD().erode * 4)
            local dmg2 = math.floor(120 + Game():GD().erode * 0.5)
            effector("eff/ShadowAssault", x, y, nil, 1)
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
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 2,
                    })
                end
            end
            local e
            time.setTimeout(0.1, function()
                e = Effect("eff/WatcherInTheWater", x, y, nil, -1)
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
                    limit = 5,
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
                            damageType = DAMAGE_TYPE.water,
                            damageTypeLevel = 0,
                        })
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("深渊侵蚀")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/Blackholecorrosion")
        :coolDownAdv(12, 0)
        :mpCostAdv(200, 0)
        :castChantAdv(1, 0)
        :castRadiusAdv(180, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(450 + Game():GD().erode * 0.5)
            local defend = 50
            return {
                "使用深渊漩涡侵蚀范围木飙",
                "被击中的木飙将受到" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
                "而且在5秒内防御减少" .. colour.hex(colour.indianred, defend) .. "点",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 40) then
                atkData.triggerAbility:effective({
                    targetUnit = atkData.targetUnit
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = effectiveData.targetUnit:x(), effectiveData.targetUnit:y()
            local dmg = math.floor(450 + Game():GD().erode * 0.5)
            local defend = 50
            Effect("eff/VoidRiftIIPurple", x, y, japi.Z(x, y), 1):speed(0.7)
            time.setTimeout(1.5, function()
                local g = Group():catch(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    limit = 5,
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
                            damageType = DAMAGE_TYPE.dark,
                            damageTypeLevel = 1,
                        })
                        eu:buff("深渊侵蚀")
                          :signal(BUFF_SIGNAL.down)
                          :icon("ability/Blackholecorrosion")
                          :duration(5)
                          :description({ colour.hex(colour.indianred, "防御：-" .. defend) })
                          :purpose(function(buffObj)
                            buffObj:attach("ShadowStrike", "overhead")
                            buffObj:defend("-=" .. defend)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("ShadowStrike", "overhead")
                            buffObj:defend("+=" .. defend)
                        end)
                          :run()
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("洞天至触")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("unit/NzothTentacleIcon")
        :coolDownAdv(70, 0)
        :castChantAdv(3, 0)
        :mpCostAdv(300, 0)
        :castRadiusAdv(500, 0)
        :description(
        function()
            local hp = 500
            local atk1 = 150
            local atk2 = 235
            return {
                "在身边召唤最多10条洞天至触手，魔怪最大持续 20 秒",
                "分为眼、鞭两种，被眼击中时降低攻击，被鞭击中时会被眩晕",
                colour.hex(colour.lawngreen, "触手HP：" .. hp),
                colour.hex(colour.indianred, "触手眼攻击：" .. atk1),
                colour.hex(colour.indianred, "触手鞭攻击：" .. atk2),
                colour.hex(colour.indianred, "攻击降低：7点3秒"),
                colour.hex(colour.indianred, "眩晕时间：0.3秒"),
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
            local hp = 500
            local atk1 = 150
            local atk2 = 235
            local dur = 20
            local ti = 0
            local atk = { atk1, atk2 }
            local tpl = { TPL_UNIT.SUMMON_NzothEye, TPL_UNIT.SUMMON_NzothTentacle }
            time.setInterval(0.15, function(curTimer)
                ti = ti + 1
                if (ti > 10 or u:isInterrupt()) then
                    destroy(curTimer)
                end
                local tx, ty = vector2.polar(x, y, math.rand(150, 500), math.rand(0, 359))
                effector("eff/CallOfDreadPurple", tx, ty, nil, 1)
                local su = Game():summons(u:owner(), tpl[1 + ti % 2], tx, ty, 270)
                su:period(dur)
                su:attack(atk[1 + ti % 2])
                su:hp(hp)
                su:animate("birth")
            end)
        end),
}