TPL_SACRED[27] = ItemTpl()
    :name("苦多披风")
    :icon("item/ChestLeather06")
    :modelAlias("item/Jerkin")
    :description("步行八荒，受尽苦难")
    :prop("forgeList",
    {
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 1 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 1 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 2 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 2 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 3 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 3 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 4 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 4 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 6 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 6 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 8 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 8 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 10 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 10 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 15 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 20 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 20 } },
        { { "move", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.rock.value, 25 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, 25 } },
    })
    :ability(
    AbilityTpl()
        :name("苦多披风")
        :icon("item/ChestLeather06")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(55, 0)
        :mpCostAdv(100, 5)
        :description(
        function(this)
            local lv = this:level()
            local dur = 16
            local avoid = 23 + 3 * lv
            return {
                colour.hex(colour.gold, "卷缩披风至内提升自身回避 " .. dur .. " 秒"),
                colour.hex(colour.gold, "回避将提升" .. avoid .. '%'),
                colour.hex(colour.yellow, "在狂风天气中效果时长降低50%"),
                colour.hex(colour.yellow, "在幽月天气下效果时长延长50%"),
            }
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local lv = effectiveData.triggerAbility:level()
            local dur = 16
            local avoid = 23 + 3 * lv
            if (Game():isWeather("wind")) then
                dur = dur / 2
            elseif (Game():isWeather("moon")) then
                dur = dur * 1.5
            end
            u:buff("堪舆避祸")
             :signal(BUFF_SIGNAL.up)
             :icon("item/ChestLeather06")
             :description({ colour.hex(colour.indianred, "回避：+" .. avoid .. '%') })
             :duration(dur)
             :purpose(function(buffObj)
                buffObj:attach("buff/FeatherVertigo", "foot")
                buffObj:avoid("+=" .. avoid)
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/FeatherVertigo", "foot")
                buffObj:avoid("-=" .. avoid)
            end)
             :run()
        end))