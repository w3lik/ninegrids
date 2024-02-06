TPL_SACRED[32] = ItemTpl()
    :name("恶魔猎刀")
    :icon("item/ThrowingKnife08")
    :modelAlias("item/DoubleBlade")
    :description("被恶魔猎杀者终将逝去")
    :prop("forgeList",
    {
        { { SYMBOL_MUT .. "attack", 5 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 10 } },
        { { SYMBOL_MUT .. "attack", 7 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 15 } },
        { { SYMBOL_MUT .. "attack", 8 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 20 } },
        { { SYMBOL_MUT .. "attack", 9 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 25 }, { "aim", 5 } },
        { { SYMBOL_MUT .. "attack", 10 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 30 }, { "aim", 7 } },
        { { SYMBOL_MUT .. "attack", 12 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 35 }, { "aim", 9 } },
        { { SYMBOL_MUT .. "attack", 14 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 40 }, { "aim", 11 } },
        { { SYMBOL_MUT .. "attack", 17 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 45 }, { "aim", 13 } },
        { { SYMBOL_MUT .. "attack", 20 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 50 }, { "aim", 15 } },
        { { SYMBOL_MUT .. "attack", 25 }, { SYMBOL_E .. DAMAGE_TYPE.poison.value, 55 }, { "aim", 20 } },
    })
    :ability(
    AbilityTpl()
        :name("恶魔猎刀")
        :icon("item/ThrowingKnife08")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :coolDownAdv(0, 0)
        :description(
        function(this)
            local lv = this:level()
            local hpRegen = 13 + 4 * lv
            local dur = 7
            return {
                colour.hex(colour.gold, "被猎刀击中的木飙HP恢复会下降"),
                colour.hex(colour.gold, "HP恢复下降 " .. hpRegen .. "，持续 " .. dur .. " 秒"),
                colour.hex(colour.darkgray, "下降特效最多叠加2次"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local tu = attackData.targetUnit
            if (tu:buffCount("猎刀损伤") >= 2) then
                return
            end
            local ab = attackData.triggerAbility
            local lv = ab:level()
            local hpRegen = 13 + 4 * lv
            local dur = 7
            tu:buff("猎刀损伤")
              :signal(BUFF_SIGNAL.down)
              :icon("item/ThrowingKnife08")
              :description({ colour.hex(colour.indianred, "HP恢复：-" .. hpRegen) })
              :duration(dur)
              :purpose(function(buffObj) buffObj:hpRegen("-=" .. hpRegen) end)
              :rollback(function(buffObj) buffObj:hpRegen("+=" .. hpRegen) end)
              :run()
        end))