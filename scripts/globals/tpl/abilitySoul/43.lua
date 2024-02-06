TPL_ABILITY_SOUL[43] = AbilityTpl()
    :name("破灭断光")
    :targetType(ABILITY_TARGET_TYPE.tag_loc)
    :icon("ability/InvincibleChopSweep")
    :condition(function() return Game():achievement(3) == true end)
    :conditionTips("通过破灭探秘区")
    :coolDownAdv(18, 0)
    :mpCostAdv(120, 10)
    :castDistanceAdv(800, 0)
    :castChantAdv(1, 0)
    :castChantEffect("buff/EmberPurple")
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 40 + lv * 33
        local dmg2 = 245 + lv * 85
        return {
            "缠出逐渐变大的强大剑光破灭大地",
            "沿途会对木飙造成多段的光属性伤害",
            "且有5%几率破坏地面崩裂造成岩伤害",
            colour.hex(colour.violet, "受到震裂的木飙会眩晕 3 秒"),
            colour.hex(colour.indianred, "剑光缠光伤害：" .. dmg),
            colour.hex(colour.indianred, "大地崩裂伤害：" .. dmg2),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 40 + lv * 33
            local dmg2 = 245 + lv * 85
            return {
                "当攻击击中木飙时有25%的几率",
                "缠出逐渐变大的强大剑光破灭大地",
                "沿途会对木飙造成多段的光属性伤害",
                "且有5%几率破坏地面崩裂造成岩伤害",
                colour.hex(colour.violet, "受到震裂的木飙会眩晕 3 秒"),
                colour.hex(colour.indianred, "剑光缠光伤害：" .. dmg),
                colour.hex(colour.indianred, "大地崩裂伤害：" .. dmg2),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 100) <= 25) then
                local tu = attackData.targetUnit
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
        local distance = ab:castDistance()
        local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
        local x, y = vector2.polar(x1, y1, distance, vector2.angle(x1, y1, x2, y2))
        local j = 0
        local radius = 100 + 5 * lv
        local scale = 0.9 + 0.07 * lv
        ability.missile({
            sourceUnit = u,
            targetVec = { x, y },
            modelAlias = "slash/Cracked_ground",
            scale = scale,
            speed = 400,
            acceleration = -2,
            onMove = function(options, vec)
                options.scale = options.scale + 0.02
                radius = radius + 1
                j = j + 1
                if (j % 10 == 0) then
                    local g = Group():catch(UnitClass, {
                        circle = { x = vec[1], y = vec[2], radius = radius },
                        limit = 8,
                        filter = function(enumUnit) return ab:isCastTarget(enumUnit)
                        end
                    })
                    if (#g > 0) then
                        local dmg = 40 + lv * 33
                        for _, eu in ipairs(g) do
                            effector("slash/Flame_flash2", eu:x(), eu:y(), eu:h(), 0.6)
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.light,
                                damageTypeLevel = 0,
                            })
                            if (math.rand(1, 100) <= 5) then
                                local dmg2 = 245 + lv * 85
                                Effect("eff/LavaSlam", vec[1], vec[2], vec[3], 1.6):size(0.4)
                                local g2 = Group():catch(UnitClass, {
                                    limit = 3,
                                    circle = { x = vec[1], y = vec[2], radius = radius },
                                    filter = function(enumUnit) return ab:isCastTarget(enumUnit)
                                    end
                                })
                                if (#g > 0) then
                                    for _, eu2 in ipairs(g2) do
                                        ability.damage({
                                            sourceUnit = u,
                                            targetUnit = eu2,
                                            damage = dmg2,
                                            damageSrc = DAMAGE_SRC.ability,
                                            damageType = DAMAGE_TYPE.rock,
                                            damageTypeLevel = 2,
                                        })
                                        ability.stun({ sourceUnit = u, targetUnit = eu2, duration = 3 })
                                    end
                                end
                            end
                        end
                    end
                end
            end,
        })
    end)