TPL_ABILITY_SOUL[20] = AbilityTpl()
    :name("烈分缠")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/BurstOfChopping")
    :coolDownAdv(30, 0)
    :mpCostAdv(115, 7)
    :castRadiusAdv(250, 0)
    :castDistanceAdv(900, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local fire = 8 + lv * 3
        local dmg1 = 60 + lv * 16
        local dmg2 = 90 + lv * 30
        local dmg3 = 150 + lv * 75
        return {
            "圆缠向木飙位置舞旋并往返切割，第一缠会赋予引湖至火",
            "木飙引湖后，" .. colour.hex(colour.gold, "火抗性降低" .. fire .. "%10秒"),
            "第二缠如果木飙有引湖则会再次引发爆湖伤害",
            colour.hex(colour.indianred, "第1次缠击伤害：" .. dmg1),
            colour.hex(colour.indianred, "第2次缠击伤害：" .. dmg2),
            colour.hex(colour.indianred, "引湖爆湖伤害：" .. dmg3),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local fire = 8 + lv * 3
            local dmg1 = 60 + lv * 16
            local dmg2 = 90 + lv * 30
            local dmg3 = 150 + lv * 75
            return {
                "当移动时随机选择附近600范围内一个木飙发出圆缠",
                "圆缠向木飙位置舞旋并往返切割，第一缠会赋予引湖至火",
                "木飙引湖后，" .. colour.hex(colour.gold, "火抗性降低" .. fire .. "%10秒"),
                "第二缠如果木飙有引湖则会再次引发爆湖伤害",
                colour.hex(colour.indianred, "第1次缠击伤害：" .. dmg1),
                colour.hex(colour.indianred, "第2次缠击伤害：" .. dmg2),
                colour.hex(colour.indianred, "引湖爆湖伤害：" .. dmg3),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), function(movingData)
            local tu = Group():rand(UnitClass, {
                limit = 1,
                circle = { x = movingData.x, y = movingData.y, radius = 600 },
                filter = function(enumUnit)
                    return this:isCastTarget(enumUnit)
                end,
            }, 1)
            if (isClass(tu, UnitClass)) then
                this:effective({
                    targetX = tu:x(),
                    targetY = tu:y(),
                    targetZ = tu:z(),
                })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local fire = 8 + lv * 3
        local dmg1 = 60 + lv * 16
        local dmg2 = 90 + lv * 30
        local dmg3 = 150 + lv * 75
        ability.missile({
            modelAlias = "slash/Wheel_dance",
            sourceUnit = u,
            weaponLength = 130,
            weaponHeight = 100,
            targetVec = { effectiveData.targetX, effectiveData.targetY, 100 },
            speed = 700,
            onMove = function(opt1, vec1)
                local g = Group():catch(UnitClass, {
                    circle = { x = vec1[1], y = vec1[2], radius = radius },
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit) and false == enumUnit:buffHas("引湖至火")
                    end,
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        eu:buff("引湖至火")
                          :icon("ability/ShadowEnslaveDemon")
                          :description({ colour.hex(colour.indianred, "火抗性：" .. fire .. '%') })
                          :duration(10)
                          :purpose(function(buffObj)
                            buffObj:attach("buff/CursedSTR096", "chest")
                            buffObj:enchantResistance(DAMAGE_TYPE.fire, "-=" .. fire)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("buff/CursedSTR096", "chest")
                            buffObj:enchantResistance(DAMAGE_TYPE.fire, "+=" .. fire)
                        end)
                          :run()
                        ability.damage({
                            sourceUnit = opt1.sourceUnit,
                            targetUnit = eu,
                            damage = dmg1,
                            damageSrc = DAMAGE_SRC.attack,
                            damageType = DAMAGE_TYPE.fire,
                            damageTypeLevel = 2,
                        })
                    end
                end
            end,
            onEnd = function(_, vec)
                local check = {}
                ability.missile({
                    modelAlias = "slash/Wheel_dance",
                    sourceVec = vec,
                    targetUnit = u,
                    weaponLength = 130,
                    weaponHeight = 100,
                    speed = 700,
                    onMove = function(opt2, vec2)
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec2[1], y = vec2[2], radius = radius },
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit) and check[enumUnit:id()] == nil
                            end,
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                check[eu:id()] = 1
                                ability.damage({
                                    sourceUnit = opt2.sourceUnit,
                                    targetUnit = eu,
                                    damage = dmg2,
                                    damageSrc = DAMAGE_SRC.attack,
                                    damageType = DAMAGE_TYPE.fire,
                                    damageTypeLevel = 3,
                                })
                                if (eu:buffHas("引湖至火")) then
                                    eu:buffClear({ key = "引湖至火" })
                                    effector("eff/PillarOfFlameOrange", eu:x(), eu:y(), eu:z() + 30, 1.2)
                                    ability.damage({
                                        sourceUnit = opt2.sourceUnit,
                                        targetUnit = eu,
                                        damage = dmg3,
                                        damageSrc = DAMAGE_SRC.ability,
                                        damageType = DAMAGE_TYPE.fire,
                                        damageTypeLevel = 0,
                                    })
                                end
                            end
                        end
                    end,
                    onEnd = function()
                        check = nil
                    end
                })
            end
        })
    end)