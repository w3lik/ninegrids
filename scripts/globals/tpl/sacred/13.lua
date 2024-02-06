TPL_SACRED[13] = ItemTpl()
    :name("幽蓝青妖核")
    :icon("item/MiscGemPearl14")
    :modelAlias("item/CrystalShard")
    :description("发着幽蓝光芒的珍贵妖核胜似宝玉")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 4 }, { "damageIncrease", 5 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 6 }, { "damageIncrease", 6 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 9 }, { "damageIncrease", 7 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 14 }, { "damageIncrease", 8 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 17 }, { "damageIncrease", 9 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 20 }, { "damageIncrease", 10 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 23 }, { "damageIncrease", 11 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 25 }, { "damageIncrease", 13 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 30 }, { "damageIncrease", 15 } },
        { { SYMBOL_E .. DAMAGE_TYPE.water.value, 34 }, { "damageIncrease", 17 } },
    })
    :ability(
    AbilityTpl()
        :name("幽蓝青妖核")
        :icon("item/MiscGemPearl14")
        :coolDownAdv(1, 0)
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description(
        {
            colour.hex(colour.gold, "受到伤害时自动使用MP回补HP"),
            colour.hex(colour.gold, "可最多回补相当于伤害30%的量"),
            colour.hex(colour.gold, "HP充足、MP不足时无法生效"),
        })
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            local u = hurtData.triggerUnit
            local back = hurtData.damage * 0.3
            local bh = u:hp() - u:hpCur()
            if (back > bh) then
                back = bh
            end
            if (back <= 0) then
                return
            end
            local mpCur = u:mpCur()
            if (mpCur < back) then
                return
            end
            hurtData.triggerAbility:effective({ back = back })
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            u:attach("AIheTarget", "origin", 0.5)
            u:attach("ReplenishManaCaster", "origin", 0.5)
            u:mpBack(effectiveData.back)
            u:hpBack(effectiveData.back)
        end))