TPL_SACRED[24] = ItemTpl()
    :name("先祖图腾")
    :icon("item/MiscRune11")
    :modelAlias("item/Crystal_Earth")
    :description("代代相传的祖先图腾带来福气")
    :prop("forgeList",
    {
        { { "hp", 300 }, { "cure", 4 } },
        { { "hp", 350 }, { "cure", 6 } },
        { { "hp", 400 }, { "cure", 8 } },
        { { "hp", 550 }, { "cure", 11 } },
        { { "hp", 600 }, { "cure", 14 } },
        { { "hp", 650 }, { "cure", 18 } },
        { { "hp", 700 }, { "cure", 22 } },
        { { "hp", 750 }, { "cure", 26 } },
        { { "hp", 800 }, { "cure", 30 } },
        { { "hp", 1000 }, { "cure", 35 } },
    })
    :ability(
    AbilityTpl()
        :name("先祖图腾")
        :icon("item/MiscRune11")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :coolDownAdv(35, -1)
        :castRadiusAdv(300, 20)
        :mpCostAdv(75, 5)
        :description(
        function(this)
            local lv = this:level()
            local hpRegen = 25 + 8 * lv
            local mpRegen = 9 + 5 * lv
            local attack = 20 + 10 * lv
            local def = 11 + 4 * lv
            return {
                colour.hex(colour.gold, "召唤图腾场地 10 秒"),
                colour.hex(colour.gold, "阵中友军增加" .. attack .. "点攻击，" .. hpRegen .. "HP恢复"),
                colour.hex(colour.gold, "阵中敌军降低" .. def .. "点防御，" .. mpRegen .. "MP恢复"),
            }
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local radius = ab:castRadius()
            local hpRegen = 25 + 8 * lv
            local mpRegen = 9 + 5 * lv
            local attack = 20 + 10 * lv
            local def = 11 + 4 * lv
            local eff
            if (lv >= 15) then
                eff = "aura/AuraOfstrengtht2"
            else
                eff = "aura/AuraOfstrengtht1"
            end
            AuraAttach()
                :radius(radius)
                :duration(10)
                :centerPosition({ effectiveData.targetX, effectiveData.targetY, 80 + effectiveData.targetZ })
                :centerEffect(eff, nil, radius / 128)
                :filter(
                function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false
                end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    if (eu:isEnemy(u:owner())) then
                        eu:buff("先祖图腾镇压")
                          :icon("item/MiscRune11")
                          :description({ colour.hex(colour.indianred, "防御：-" .. def), colour.hex(colour.indianred, "MP恢复：-" .. mpRegen) })
                          :duration(-1)
                          :purpose(function(buffObj)
                            buffObj:attach("buff/ArmorPenetrationRed", "overhead")
                            buffObj:defend("-=" .. def)
                            buffObj:mpRegen("-=" .. mpRegen)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("buff/ArmorPenetrationRed", "overhead")
                            buffObj:defend("+=" .. def)
                            buffObj:mpRegen("+=" .. mpRegen)
                        end)
                          :run()
                    else
                        eu:buff("先祖图腾祝福")
                          :icon("item/MiscRune11")
                          :description({ colour.hex(colour.lawngreen, "攻击：+" .. attack), colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen) })
                          :duration(-1)
                          :purpose(function(buffObj)
                            buffObj:attach("OmMandAura", "origin")
                            buffObj:attack("+=" .. attack)
                            buffObj:hpRegen("+=" .. hpRegen)
                        end)
                          :rollback(function(buffObj)
                            buffObj:detach("OmMandAura", "origin")
                            buffObj:attack("-=" .. attack)
                            buffObj:hpRegen("-=" .. hpRegen)
                        end)
                          :run()
                    end
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    local eu = auraData.triggerUnit
                    if (eu:isEnemy(u:owner())) then
                        eu:buffClear({ key = "先祖图腾镇压" })
                    else
                        eu:buffClear({ key = "先祖图腾祝福" })
                    end
                end)
        end))