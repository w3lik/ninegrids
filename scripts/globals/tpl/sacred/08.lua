TPL_SACRED[8] = ItemTpl()
    :name("双刃斧")
    :icon("item/ThrowingAxe05")
    :modelAlias("item/MountainKingAxe")
    :description("看起来极其危险的钢斧")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { "defend", -15 }, { "attack", 60 } },
        { { "defend", -18 }, { "attack", 80 } },
        { { "defend", -22 }, { "attack", 110 } },
        { { "defend", -25 }, { "attack", 140 } },
        { { "defend", -30 }, { "attack", 170 } },
        { { "defend", -35 }, { "attack", 200 } },
        { { "defend", -41 }, { "attack", 230 } },
        { { "defend", -47 }, { "attack", 255 } },
        { { "defend", -53 }, { "attack", 275 } },
        { { "defend", -55 }, { "attack", 300 } },
    })
    :ability(
    AbilityTpl()
        :name("双刃斧")
        :icon("item/ThrowingAxe05")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description(
        function(this)
            local lv = this:level()
            local def = 7 + 3 * lv
            return {
                colour.hex(colour.gold, "攻击时有 25% 几率在 3秒 内"),
                colour.hex(colour.gold, "减少木飙 " .. def .. "点 防御"),
                colour.hex(colour.darkgray, "减防特效最多叠加3次"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 25) then
                local tu = attackData.targetUnit
                if (tu:buffCount("双刃斧破甲") >= 3) then
                    return
                end
                local lv = attackData.triggerAbility:level()
                local def = 7 + 3 * lv
                tu:buff("双刃斧破甲")
                  :signal(BUFF_SIGNAL.down)
                  :duration(3)
                  :icon("item/ThrowingAxe05")
                  :description("防御：-" .. def)
                  :purpose(function(buffObj) buffObj:defend("-=" .. def) end)
                  :rollback(function(buffObj) buffObj:defend("+=" .. def) end)
                  :run()
            end
        end))