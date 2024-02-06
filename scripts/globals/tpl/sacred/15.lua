TPL_SACRED[15] = ItemTpl()
    :name("荆飒")
    :icon("item/WeaponHalberd19")
    :modelAlias("item/JWeapon5")
    :description("剑 · 荆疾 · 踏风")
    :prop("forgeList",
    {
        { { "attack", 20 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 5 } },
        { { "attack", 30 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 7 } },
        { { "attack", 40 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 9 } },
        { { "attack", 55 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 11 } },
        { { "attack", 70 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 13 } },
        { { "attack", 90 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 15 } },
        { { "attack", 110 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 18 } },
        { { "attack", 130 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 23 } },
        { { "attack", 150 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 30 } },
        { { "attack", 175 }, { SYMBOL_E .. DAMAGE_TYPE.wind.value, 40 } },
    })
    :ability(
    AbilityTpl()
        :name("荆飒")
        :icon("item/WeaponHalberd19")
        :coolDownAdv(2, 0)
        :targetType(ABILITY_TARGET_TYPE.pas)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :description(
        function(this)
            local lv = this:level()
            local per = 1 * lv
            local dmg = 20 + lv * 7
            local desc = {
                colour.hex(colour.gold, "攻击时附带一道疾风剑气"),
                colour.hex(colour.gold, "剑气风伤害：" .. per .. "%攻击+" .. dmg),
            }
            if (lv >= 15) then
                table.insert(desc, colour.hex(colour.gold, "剑气消散时造成范围风爆"))
            end
            return desc
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            attackData.triggerAbility:effective({
                targetUnit = attackData.targetUnit
            })
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local scale = 0.3 + (lv - 1) * 0.05
            local per = 1 * lv
            local dmg = u:attack() * per * 0.01 + (20 + lv * 7)
            local x1, y1, x2, y2 = u:x(), u:y(), tu:x(), tu:y()
            local fac = vector2.angle(x1, y1, x2, y2)
            local x, y = vector2.polar(x1, y1, 500, fac)
            local n = 0
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "slash/Bladewave",
                scale = scale,
                speed = 700,
                onMove = function(_, vec)
                    n = n + 1
                    if (n % 7 == 0) then
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = 80 },
                            limit = 3,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                eu:effect("Tornado_Target", 1)
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.item,
                                    damageType = DAMAGE_TYPE.wind,
                                    damageTypeLevel = 0,
                                })
                            end
                        end
                    end
                end,
                onEnd = function(_, vec)
                    if (lv >= 15) then
                        Effect("slash/Light_speed_cutting", vec[1], vec[2], vec[3], 2):size(0.6)
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = 400 },
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                eu:effect("Tornado_Target", 1)
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg * 5,
                                    damageSrc = DAMAGE_SRC.item,
                                    damageType = DAMAGE_TYPE.wind,
                                    damageTypeLevel = 3,
                                })
                            end
                        end
                    end
                end,
            })
        end))