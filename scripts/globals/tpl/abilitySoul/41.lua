TPL_ABILITY_SOUL[41] = AbilityTpl()
    :name("初生双雷")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/SplitLightning2")
    :coolDownAdv(15, 0)
    :mpCostAdv(100, 10)
    :castDistanceAdv(500, 0)
    :castRadiusAdv(250, 0)
    :condition(function() return Game():achievement(1) == true end)
    :conditionTips("通过初生探秘区")
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 110 + lv * 50
        local stun = 0.6 + lv * 0.2
        return {
            "发出引雷从而召唤两种属性的诞生至雷",
            "暗与雷的打击将从空中劈下打击敌人",
            "雷霆打击敌人会使其有50%几率进入短暂的眩晕",
            colour.hex(colour.indianred, "单雷伤害：" .. dmg),
            colour.hex(colour.violet, "眩晕时间：" .. stun .. "秒"),
            colour.hex(colour.yellow, "通过探秘区难度越高伤害越高"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 110 + lv * 50
            local stun = 0.6 + lv * 0.2
            return {
                "当攻击时发出引雷从而召唤诞生至双雷，劈下打击随机敌人",
                "雷霆打击敌人会使其有50%几率进入短暂的眩晕",
                colour.hex(colour.indianred, "单雷伤害：" .. dmg),
                colour.hex(colour.violet, "眩晕时间：" .. stun .. "秒"),
                colour.hex(colour.yellow, "通过探秘区难度越高伤害越高"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(atkData)
            this:effective({
                targetX = atkData.targetUnit:x(),
                targetY = atkData.targetUnit:y(),
            })
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local dmg = (110 + lv * 50) * (0.7 + 0.3 * Game():GD().diffMax)
        local stun = 0.6 + lv * 0.2
        local x, y, z = u:x(), u:y(), u:h()
        local tx, ty = effectiveData.targetX, effectiveData.targetY
        local g = Group():catch(UnitClass, {
            circle = { x = tx, y = ty, radius = radius },
            limit = 10,
            filter = function(enumUnit)
                return ab:isCastTarget(enumUnit)
            end
        })
        Effect("eff/EddyCurrentStorm", tx, ty, japi.Z(tx, ty) + 100, 0.3):size(radius / 330)
        if (#g > 0) then
            for _, eu in ipairs(g) do
                lightning(LIGHTNING_TYPE.thunderFork, x, y, z, eu:x(), eu:y(), eu:h(), 0.15)
                time.setTimeout(0.3, function()
                    eu:effect("eff/RedAndBlueLightning", 0.3)
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 2,
                    })
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.thunder,
                        damageTypeLevel = 2,
                    })
                    ability.stun({
                        sourceUnit = u,
                        targetUnit = eu,
                        duration = stun,
                        odds = 50,
                    })
                end)
            end
        end
    end)