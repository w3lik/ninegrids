TPL_ABILITY_BOSS["霜泠(巫妖)"] = {
    AbilityTpl()
        :name("霜降")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/Avigorouschop")
        :coolDownAdv(13, 0)
        :mpCostAdv(75, 0)
        :castRadiusAdv(220, 0)
        :castChantAdv(1, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(550 + Game():GD().erode)
            local move = 50
            return {
                "召唤冰霜爆破范围木飙",
                "被击中的木飙将受到" .. colour.hex(colour.indianred, dmg) .. "冰伤害",
                "而且在3秒内移动速度减少" .. colour.hex(colour.indianred, move) .. "点",
                colour.hex(colour.yellow, "在雪天天气下，移动再降低50")
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
            local dmg = math.floor(550 + Game():GD().erode)
            local move = 50
            if (Game():isWeather("snow")) then
                move = move * 2
            end
            effector("FrostNovaTarget", x, y, japi.Z(x, y), 1)
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
                        damageType = DAMAGE_TYPE.ice,
                        damageTypeLevel = 1,
                    })
                    eu:buff("霜降")
                      :signal(BUFF_SIGNAL.down)
                      :icon("ability/Avigorouschop")
                      :duration(3)
                      :description({ colour.hex(colour.indianred, "移动：-" .. move) })
                      :purpose(function(buffObj)
                        buffObj:attach("buff/Icing", "origin")
                        buffObj:move("-=" .. move)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/Icing", "origin")
                        buffObj:move("+=" .. move)
                    end)
                      :run()
                end
            end
        end),
    AbilityTpl()
        :name("死法灵")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/AnimateDead")
        :coolDownAdv(40, 0)
        :castChantAdv(1, 0)
        :mpCostAdv(150, 0)
        :description(
        function()
            return {
                "在身边召唤10具骷髅法师" .. colour.hex(colour.gold, "25秒"),
                colour.hex(colour.yellow, "在雪天天气下，骷髅法师生命+100%")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 25) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dur = 25
            local num = 10
            local hp = 300
            if (Game():isWeather("snow")) then
                hp = hp * 2
            end
            local x, y, fac = u:x(), u:y(), u:facing()
            local angle = 360 / num
            for i = 1, num, 1 do
                local tx, ty = vector2.polar(x, y, 300, angle * i)
                local e = Game():enemies(TPL_UNIT.SkeletonMage, tx, ty, fac, true):period(dur)
                e:hp(hp)
                e:attack(175)
                e:defend(10)
            end
        end),
    AbilityTpl()
        :name("冰天雪地")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ComingDownIceFragment")
        :coolDownAdv(55, 0)
        :mpCostAdv(250, 0)
        :castChantAdv(2, 0)
        :castKeepAdv(15, 0)
        :castRadiusAdv(800, 0)
        :description(
        function()
            local gd = Game():GD()
            local dmg = math.floor(235 + gd.erode * 1.5)
            return {
                "呼唤冰雪的侵袭，在周边形成银落冰砂，",
                "附近大范围的敌人攻速移动都会被降低",
                "并带有随机冰雹砸下造成冰伤害",
                "被砸中的木飙会冻结0.5秒",
                colour.hex(colour.indianred, "冰雹伤害：" .. dmg),
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
            local dmg = math.floor(235 + gd.erode * 1.5)
            local x, y = u:x(), u:y()
            local aura = AuraAttach()
                :radius(radius)
                :duration(15)
                :centerPosition({ x, y })
                :centerEffect("aura/RemorselessWinter", nil, radius / 350)
                :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    eu:buff("冰天雪地")
                      :icon("ability/ComingDownIceFragment")
                      :description({
                        colour.hex(colour.indianred, "攻速：-30%"),
                        colour.hex(colour.indianred, "移动：-30")
                    })
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attackSpeed("-=30")
                        buffObj:move("-=30")
                    end)
                      :rollback(function(buffObj)
                        buffObj:attackSpeed("+=30")
                        buffObj:move("+=30")
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    auraData.triggerUnit:buffClear({ key = "冰天雪地" })
                end)
            local ti = 0
            local frq = 0.5
            time.setInterval(frq, function(curTimer)
                ti = ti + frq
                if (ti >= 30 or u:isAbilityKeepCasting() == false) then
                    destroy(curTimer)
                    destroy(aura)
                    return
                end
                for _ = 1, 5 do
                    local tx, ty = vector2.polar(x, y, math.rand(0, radius), math.rand(0, 359))
                    alerter.circle( tx, ty, 200)
                    effector("eff/Blizzard2", tx, ty, 0, 0.9)
                    time.setTimeout(1.0, function()
                        local g = Group():catch(UnitClass, {
                            circle = { x = tx, y = ty, radius = 200 },
                            filter = function(enumUnit)
                                return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                            end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                effector("FrostNovaTarget", eu:x(), eu:y(), nil, 1)
                                ability.damage({
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.ice,
                                    damageTypeLevel = 1
                                })
                                ability.freeze({
                                    name = "冰天雪地冻结",
                                    icon = "ability/ComingDownIceFragment",
                                    duration = 0.5,
                                    description = "冻结无法正常行动",
                                    whichUnit = eu,
                                    red = 100,
                                    green = 100,
                                    blue = 255,
                                })
                            end
                        end
                    end)
                end
            end)
        end),
}