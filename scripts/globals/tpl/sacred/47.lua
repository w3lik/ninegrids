TPL_SACRED[47] = ItemTpl()
    :name("无穷药剂")
    :icon("item/Potion31")
    :modelAlias("item/Potion_BigYellow")
    :description("以神器药瓶装满的药剂永远用不完")
    :conditionTips("运气获得")
    :prop("forgeList",
    {
        { { "hpRegen", 8 }, { "mpRegen", 4 } },
        { { "hpRegen", 10 }, { "mpRegen", 5 } },
        { { "hpRegen", 12 }, { "mpRegen", 7 } },
        { { "hpRegen", 15 }, { "mpRegen", 8 } },
        { { "hpRegen", 20 }, { "mpRegen", 11 } },
        { { "hpRegen", 25 }, { "mpRegen", 13 } },
        { { "hpRegen", 33 }, { "mpRegen", 15 } },
        { { "hpRegen", 40 }, { "mpRegen", 18 } },
        { { "hpRegen", 50 }, { "mpRegen", 20 } },
        { { "hpRegen", 55 }, { "mpRegen", 25 } },
    })
    :ability(
    AbilityTpl()
        :name("无穷药剂")
        :icon("item/Potion31")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(50, 0)
        :description(
        function(this)
            local lv = this:level()
            local dur = 8 + 1 * lv
            local hpRegen = 39 + 11 * lv
            local mpRegen = 18 + 7 * lv
            return {
                colour.hex(colour.gold, "使用后能增快HP和MP的恢复速度 " .. dur .. " 秒"),
                colour.hex(colour.gold, "HP恢复增加" .. hpRegen),
                colour.hex(colour.gold, "MP恢复增加" .. mpRegen),
            }
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local dur = 8 + 1 * lv
            local hpRegen = 39 + 11 * lv
            local mpRegen = 18 + 7 * lv
            u:buff("无穷药剂恢复")
             :signal(BUFF_SIGNAL.up)
             :icon("item/Potion31")
             :description({ colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen), colour.hex(colour.lawngreen, "MP恢复：+" .. mpRegen) })
             :duration(dur)
             :purpose(
                function(buffObj)
                    buffObj:attach("ClarityTarget", "origin")
                    buffObj:hpRegen("+=" .. hpRegen)
                    buffObj:mpRegen("+=" .. mpRegen)
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("ClarityTarget", "origin")
                    buffObj:hpRegen("-=" .. hpRegen)
                    buffObj:mpRegen("-=" .. mpRegen)
                end)
             :run()
        end))