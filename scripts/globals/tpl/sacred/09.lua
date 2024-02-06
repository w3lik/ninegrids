TPL_SACRED[9] = ItemTpl()
    :name("恸哭夜至剑")
    :icon("item/Sword71")
    :modelAlias("item/Frostmourne")
    :description("痛苦亡灵死骑佩戴的悲鸣武器")
    :prop("forgeList",
    {
        { { SYMBOL_MUT .. "attack", 2 } },
        { { SYMBOL_MUT .. "attack", 4 }, { "attack", 30 } },
        { { SYMBOL_MUT .. "attack", 6 }, { "attack", 45 } },
        { { SYMBOL_MUT .. "attack", 8 }, { "attack", 70 }, { "defend", 7 } },
        { { SYMBOL_MUT .. "attack", 10 }, { "attack", 85 }, { "defend", 9 } },
        { { SYMBOL_MUT .. "attack", 12 }, { "attack", 110 }, { "defend", 11 } },
        { { SYMBOL_MUT .. "attack", 14 }, { "attack", 120 }, { "defend", 13 } },
        { { SYMBOL_MUT .. "attack", 16 }, { "attack", 135 }, { "defend", 15 } },
        { { SYMBOL_MUT .. "attack", 18 }, { "attack", 150 }, { "defend", 18 } },
        { { SYMBOL_MUT .. "attack", 20 }, { "attack", 180 }, { "defend", 20 } },
    })
    :ability(
    AbilityTpl()
        :name("恸哭夜至剑")
        :icon("item/Sword71")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description(
        {
            colour.hex(colour.gold, "攻击时减慢木飙 40 移动"),
            colour.hex(colour.gold, "效果持续时间为 2 秒"),
            colour.hex(colour.darkgray, "减速特效效果唯一"),
        })
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local tu = attackData.targetUnit
            local b = tu:buffOne("恸哭夜至剑减速")
            if (isClass(b, BuffClass)) then
                b:remain(2)
                return
            end
            tu:buff("恸哭夜至剑减速")
              :signal(BUFF_SIGNAL.down)
              :duration(2)
              :icon("item/Sword71")
              :description("移动：-40")
              :purpose(function(buffObj) buffObj:move("-=40") end)
              :rollback(function(buffObj) buffObj:move("+=40") end)
              :run()
        end))