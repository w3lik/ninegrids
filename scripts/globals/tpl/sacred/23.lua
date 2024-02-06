TPL_SACRED[23] = ItemTpl()
    :name("醉天璇液")
    :icon("item/AlchemyPotion06")
    :modelAlias("item/Potion_Red")
    :description("散发浓香，妙哉奇酒，一口便倒，看透世间")
    :prop("forgeList",
    {
        { { "visible", 300 }, { "cure", 6 } },
        { { "visible", 300 }, { "cure", 9 } },
        { { "visible", 400 }, { "cure", 12 } },
        { { "visible", 400 }, { "cure", 16 } },
        { { "visible", 500 }, { "cure", 20 } },
        { { "visible", 500 }, { "cure", 25 } },
        { { "visible", 600 }, { "cure", 30 } },
        { { "visible", 700 }, { "cure", 40 } },
        { { "visible", 800 }, { "cure", 55 } },
        { { "visible", 900 }, { "cure", 60 } },
    })
    :ability(
    AbilityTpl()
        :name("醉天璇液")
        :icon("item/AlchemyPotion06")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :coolDownAdv(9, -0.2)
        :castRadiusAdv(50, 0)
        :description(
        function(this)
            local lv = this:level()
            local move = 60 + 5 * lv
            local aim = 30 + 5 * lv
            local hpRegen = 35 + 7 * lv
            local avoid = 25 + 5 * lv
            return {
                colour.hex(colour.gold, "喝下此酒的单位会迷失 5 秒"),
                colour.hex(colour.gold, "移动降低" .. move .. "，命中降低" .. aim .. '%'),
                colour.hex(colour.gold, "HP恢复增加" .. hpRegen .. "，回避增加" .. avoid .. '%'),
            }
        end)
        :castTargetFilter(CAST_TARGET_FILTER.notNeutral)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.targetUnit
            local lv = effectiveData.triggerAbility:level()
            local move = 60 + 5 * lv
            local aim = 30 + 5 * lv
            local hpRegen = 35 + 7 * lv
            local avoid = 25 + 5 * lv
            u:buff("醉天璇液熏醉")
             :icon("item/AlchemyPotion06")
             :description({
                colour.hex(colour.indianred, "移动：-" .. move),
                colour.hex(colour.indianred, "命中：-" .. aim .. '%'),
                colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen),
                colour.hex(colour.lawngreen, "回避：+" .. avoid .. '%'),
            })
             :duration(5)
             :purpose(function(buffObj)
                buffObj:attach("StasisTotemTarget", "overhead")
                buffObj:move("-=" .. move)
                buffObj:aim("-=" .. aim)
                buffObj:hpRegen("+=" .. hpRegen)
                buffObj:avoid("+=" .. avoid)
            end)
             :rollback(function(buffObj)
                buffObj:detach("StasisTotemTarget", "overhead")
                buffObj:move("+=" .. move)
                buffObj:aim("+=" .. aim)
                buffObj:hpRegen("-=" .. hpRegen)
                buffObj:avoid("-=" .. avoid)
            end)
             :run()
        end))