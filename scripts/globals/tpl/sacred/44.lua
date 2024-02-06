TPL_SACRED[44] = ItemTpl()
    :name("鬼冰灵珠")
    :icon("item/OrbOfFrost")
    :modelAlias("item/OrbOfFrost")
    :description("霜冻型鬼火凝聚而成的灵珠")
    :conditionTips("运气获得")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 7 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 2 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -3 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 8 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 3 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -4 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 10 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 4 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -5 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 12 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 5 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -7 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 14 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 7 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -9 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 20 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 11 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -12 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 25 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 14 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -16 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 32 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 22 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -30 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 40 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 30 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -36 } },
        { { SYMBOL_E .. DAMAGE_TYPE.ice.value, 50 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 35 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -43 } },
    })
    :ability(
    AbilityTpl()
        :name("鬼冰灵珠")
        :icon("item/OrbOfFrost")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(20, 0)
        :mpCostAdv(100, 5)
        :castRadiusAdv(155, 10)
        :description(
        function(this)
            local lv = this:level()
            local dur = 6 + 1 * lv
            local dmg = 75 + 30 * lv
            local desc = {
                colour.hex(colour.gold, "以霜冻鬼火环绕己身 " .. dur .. " 秒"),
                colour.hex(colour.gold, "每秒对作用半径内的敌人造成" .. dmg .. "冰伤害"),
                colour.hex(colour.gold, "接受寒霜的敌人有15%的几率减少其当前10%的MP"),
                colour.hex(colour.yellow, "在雪天天气下，造成伤害提升100%"),
            }
            return desc
        end)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local radius = ab:castRadius()
            local dur = 6 + 1 * lv
            local dmg = 75 + 30 * lv
            if (Game():isWeather("snow")) then
                dmg = dmg * 2
            end
            local di = 0
            local frq = 1
            u:attach("FrostArmorTarget", "chest")
            time.setInterval(frq, function(curTimer)
                di = di + frq
                if (di > dur) then
                    destroy(curTimer)
                    u:detach("FrostArmorTarget", "chest")
                    return
                end
                local g = Group():catch(UnitClass, {
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                    circle = { x = u:x(), y = u:y(), radius = radius },
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        eu:attach("FrostDamage", "chest", 0.3)
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.item,
                            damageType = DAMAGE_TYPE.ice,
                            damageTypeLevel = 1,
                        })
                        if (math.rand(1, 100) <= 15) then
                            eu:mp("-=" .. math.max(0, eu:mp() * 0.1))
                        end
                    end
                end
            end)
        end))