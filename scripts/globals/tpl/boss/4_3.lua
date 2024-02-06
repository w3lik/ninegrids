TPL_ABILITY_BOSS["骷髅泠(骨王)"] = {
    AbilityTpl()
        :name("彘骨")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/TheBoneBreakBlood")
        :description({ "攻击木飙骨间弱点", "更容易挥打出致命的一击" })
        :attributes(
        {
            { "crit", 75, 0 },
            { SYMBOL_ODD .. "crit", 50, 0 },
        }),
    AbilityTpl()
        :name("钢身")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/DesertTroll")
        :description({ "以钢覆盖全身，不惧怕打击", "能够抵抗更多的伤害" })
        :attributes(
        {
            { "defend", 175, 0 },
        }),
    AbilityTpl()
        :name("狱焰拳")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/HellfireFist")
        :coolDownAdv(10, 0)
        :mpCostAdv(200, 0)
        :castChantAdv(1, 0)
        :castDistanceAdv(600, 0)
        :castRadiusAdv(275, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(700 + erode * 4)
            local move = 20
            return {
                "向木飙击出来自地狱的火焰至拳",
                "被击中的木飙会附着4层火",
                "每击中一个木飙骨王3秒内移动提升" .. colour.hex(colour.lawngreen, move),
                colour.hex(colour.indianred, "拳头伤害：" .. dmg),
            }
        end)
        :onUnitEvent(EVENT.Unit.BeforeAttack,
        function(beforeAttackData)
            if (math.rand(1, 100) <= 50) then
                beforeAttackData.triggerAbility:effective({
                    targetUnit = beforeAttackData.targetUnit
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local tx, ty = effectiveData.targetUnit:x(), effectiveData.targetUnit:y()
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(700 + erode * 4)
            ability.missile({
                modelAlias = "eff/GiantFireFist",
                sourceUnit = u,
                targetVec = { tx, ty },
                weaponLength = 100,
                weaponHeight = 200,
                scale = 1.4,
                speed = 800,
                onEnd = function(options, vec)
                    Effect("eff/LavaBurst2", vec[1], vec[2], nil, 1):size(1.5)
                    local g = Group():catch(UnitClass, {
                        circle = { x = vec[1], y = vec[2], radius = radius },
                        limit = 5,
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end
                    })
                    if (#g > 0) then
                        local su = options.sourceUnit
                        local move = 20 * #g
                        su:buff("狱焰拳移动提升")
                          :signal(BUFF_SIGNAL.up)
                          :icon("ability/HellfireFist")
                          :description({ colour.hex(colour.lawngreen, "移动：+" .. move) })
                          :duration(3)
                          :purpose(function(buffObj)
                            buffObj:attach("buff/WindwalkFire", "origin")
                            buffObj:move("+=" .. move)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("buff/WindwalkFire", "origin")
                            buffObj:move("-=" .. move)
                        end)
                          :run()
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = su,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.fire,
                                damageTypeLevel = 4,
                            })
                        end
                    end
                end
            })
        end),
    AbilityTpl()
        :name("缠火至技")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/SawtoothCutBleeding")
        :description(
        function()
            local dmg = 60
            return {
                "每当攻击成功时，如果木飙附着火元素",
                "将增加" .. colour.hex(colour.indianred, dmg .. "x附着等级") .. "的钢伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            local tu = attackData.targetUnit
            local lv = tu:enchantAppendingLevel(DAMAGE_TYPE.fire)
            if (lv < 0) then
                lv = math.abs(lv)
            end
            local dmg = 60 * lv
            if (dmg > 0) then
                tu:attach("eff/PhosgeneBurst", "origin", 0.5)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = tu,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.ability,
                    damageType = DAMAGE_TYPE.steel,
                    damageTypeLevel = 1,
                })
            end
        end),
}