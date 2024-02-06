TPL_SACRED[3] = ItemTpl()
    :name("雷纹锤")
    :icon("ability/StormHammer")
    :modelAlias("item/StormHammer")
    :description("一把沉重的带有微弱雷至力的铁锤")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { "attackSpeed", -35 }, { "move", -50 }, { "attack", 40 } },
        { { "attackSpeed", -33 }, { "move", -47 }, { "attack", 55 } },
        { { "attackSpeed", -31 }, { "move", -44 }, { "attack", 80 } },
        { { "attackSpeed", -29 }, { "move", -41 }, { "attack", 110 } },
        { { "attackSpeed", -27 }, { "move", -38 }, { "attack", 135 } },
        { { "attackSpeed", -25 }, { "move", -35 }, { "attack", 170 } },
        { { "attackSpeed", -23 }, { "move", -32 }, { "attack", 195 } },
        { { "attackSpeed", -21 }, { "move", -28 }, { "attack", 215 } },
        { { "attackSpeed", -19 }, { "move", -25 }, { "attack", 235 } },
        { { "attackSpeed", -18 }, { "move", -20 }, { "attack", 255 } },
    })
    :ability(
    AbilityTpl()
        :name("雷纹锤")
        :icon("item/StormHammer")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description({ colour.hex(colour.gold, "攻击时激发无视防御的的电链"), colour.hex(colour.gold, "电链基于1%攻击力造成雷伤害") })
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            ability.lightningChain({
                sourceUnit = attackData.triggerUnit,
                targetUnit = attackData.targetUnit,
                qty = 3,
                rate = -20,
                radius = 400,
                damage = math.max(1, 0.1 * attackData.triggerUnit:attack()),
                damageType = DAMAGE_TYPE.thunder,
                damageTypeLevel = 0,
                breakArmor = { BREAK_ARMOR.defend },
            })
        end))