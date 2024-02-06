TPL_SACRED[36] = ItemTpl()
    :name("鬼火灵珠")
    :icon("item/OrbOfFire")
    :modelAlias("item/OrbOfFire")
    :description("赤炎型鬼火凝聚而成的灵珠")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 7 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 2 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -3 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 8 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 3 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -4 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 10 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 4 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -5 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 12 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 5 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -7 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 14 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 7 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -9 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 20 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 11 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -12 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 25 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 14 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -16 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 32 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 22 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -30 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 40 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 30 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -36 } },
        { { SYMBOL_E .. DAMAGE_TYPE.fire.value, 50 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 35 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -43 } },
    })
    :ability(
    AbilityTpl()
        :name("鬼火灵珠")
        :icon("item/OrbOfFire")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(20, 0)
        :mpCostAdv(100, 5)
        :castRadiusAdv(155, 10)
        :description(
        function(this)
            local lv = this:level()
            local dur = 6 + 1 * lv
            local dmg = 75 + 30 * lv
            return {
                colour.hex(colour.gold, "以赤炎鬼火环绕己身 " .. dur .. " 秒"),
                colour.hex(colour.gold, "每秒对作用半径内的敌人造成" .. dmg .. "火伤害"),
                colour.hex(colour.gold, "接受湖烧的敌人有15%的几率减少其当前10%的HP"),
                colour.hex(colour.yellow, "在雨天使用时造成伤害降低30%"),
            }
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local lv = effectiveData.triggerAbility:level()
            local radius = effectiveData.triggerAbility:castRadius()
            local dur = 6 + 1 * lv
            local dmg = 75 + 30 * lv
            if (Game():isWeather("rain")) then
                dmg = dmg * 0.7
            end
            local di = 0
            local frq = 1
            u:attach("ImmolationRedTarget", "chest")
            time.setInterval(frq, function(curTimer)
                di = di + frq
                if (di > dur) then
                    destroy(curTimer)
                    u:detach("ImmolationRedTarget", "chest")
                    return
                end
                local g = Group():catch(UnitClass, {
                    circle = { x = u:x(), y = u:y(), radius = radius },
                    filter = function(enumUnit)
                        return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                    end
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        eu:attach("SmallBuildingFire1", "chest", 0.3)
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.item,
                            damageType = DAMAGE_TYPE.fire,
                            damageTypeLevel = 1,
                        })
                        if (math.rand(1, 100) <= 15) then
                            eu:hp("-=" .. math.max(0, eu:hp() * 0.1))
                        end
                    end
                end
            end)
        end))