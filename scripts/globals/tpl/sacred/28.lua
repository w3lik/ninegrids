TPL_SACRED[28] = ItemTpl()
    :name("光锥水晶锤")
    :icon("item/Mace47")
    :modelAlias("item/Brilliance")
    :description("以璀璨石锤炼而成的光华水晶重锤")
    :prop("forgeList",
    {
        { { "cure", 3 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 10 } },
        { { "cure", 4 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 12 } },
        { { "cure", 5 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 15 } },
        { { "cure", 6 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 18 } },
        { { "cure", 7 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 25 } },
        { { "cure", 8 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 30 } },
        { { "cure", 9 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 35 } },
        { { "cure", 11 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 40 } },
        { { "cure", 13 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 50 } },
        { { "cure", 15 }, { SYMBOL_E .. DAMAGE_TYPE.light.value, 60 } },
    })
    :ability(
    AbilityTpl()
        :name("光锥水晶锤")
        :icon("item/Mace47")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description(
        function(this)
            local lv = this:level()
            local light = 1 + 0.2 * lv
            local dur = 5
            return {
                colour.hex(colour.gold, "木飙为暗体质时降低" .. light .. "%光抗性"),
                colour.hex(colour.gold, "效果持续" .. dur .. "秒"),
                colour.hex(colour.yellow, "在烈日天气下持续时长延长100%"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Damage,
        function(damageData)
            local tu = damageData.targetUnit
            if (tu:enchantMaterial() ~= DAMAGE_TYPE.dark) then
                return
            end
            local ab = damageData.triggerAbility
            local lv = ab:level()
            local light = 1 + 0.2 * lv
            local dur = 5
            if (Game():isWeather("sun")) then
                dur = dur * 2
            end
            tu:buff("光锥圣耀")
              :signal(BUFF_SIGNAL.down)
              :icon("item/Mace47")
              :description({ colour.hex(colour.indianred, "光抗性：-" .. light .. '%') })
              :duration(dur)
              :purpose(
                function(buffObj)
                    buffObj:attach("buff/RadianceHands", "chest")
                    buffObj:enchantResistance(DAMAGE_TYPE.light, "-=" .. light)
                end)
              :rollback(
                function(buffObj)
                    buffObj:detach("buff/RadianceHands", "chest")
                    buffObj:enchantResistance(DAMAGE_TYPE.light, "+=" .. light)
                end)
              :run()
        end))