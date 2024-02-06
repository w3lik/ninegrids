TPL_SACRED[39] = ItemTpl()
    :name("破空长斧")
    :icon("item/Axe60")
    :modelAlias("item/ChieftainAxeBlue")
    :description("据说可断裂天空，但应该不能")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 2 }, { "attackRange", 30 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 4 }, { "attackRange", 40 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 6 }, { "attackRange", 50 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 8 }, { "attackRange", 60 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 10 }, { "attackRange", 70 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 12 }, { "attackRange", 80 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 15 }, { "attackRange", 90 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 18 }, { "attackRange", 100 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 20 }, { "attackRange", 130 } },
        { { SYMBOL_E .. DAMAGE_TYPE.wind.value, 25 }, { "attackRange", 160 } },
    })
    :ability(
    AbilityTpl()
        :name("破空长斧")
        :icon("item/Axe60")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(20, 0)
        :mpCostAdv(75, 7)
        :description(
        function(this)
            local lv = this:level()
            local atkSpd = 30 + 3 * lv
            local dur = 5
            return {
                colour.hex(colour.gold, "使用后增加自身攻击速度" .. atkSpd .. "%"),
                colour.hex(colour.gold, "效果持续时间为" .. dur .. "秒"),
                colour.hex(colour.yellow, "在狂风天气中持续时间将延迟3秒"),
            }
        end)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local atkSpd = 30 + 3 * lv
            local dur = 5
            if (Game():isWeather("wind")) then
                dur = dur + 3
            end
            effector("eff/DustWindCirclefaster", u:x(), u:y(), u:z() + 30, 1)
            u:buff("破空升速")
             :signal(BUFF_SIGNAL.up)
             :icon("item/Axe60")
             :description({ colour.hex(colour.lawngreen, "攻速：+" .. atkSpd .. '%') })
             :duration(dur)
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/WindwalkNecroSoul", "origin")
                    buffObj:attach("buff/Echo", "origin")
                    buffObj:attackSpeed("+=" .. atkSpd)
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/WindwalkNecroSoul", "origin")
                    buffObj:detach("buff/Echo", "origin")
                    buffObj:attackSpeed("-=" .. atkSpd)
                end)
             :run()
        end))