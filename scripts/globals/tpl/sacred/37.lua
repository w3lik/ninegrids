TPL_SACRED[37] = ItemTpl()
    :name("海皇牙叉")
    :icon("item/NagaWeaponUp2")
    :modelAlias("item/NagaLance")
    :description("海族王者使用的三棘叉")
    :prop("forgeList",
    {
        { { "attackRipple", 25 } },
        { { "attackRipple", 31 }, { "attackRange", 10 } },
        { { "attackRipple", 37 }, { "attackRange", 20 } },
        { { "attackRipple", 43 }, { "attackRange", 30 } },
        { { "attackRipple", 51 }, { "attackRange", 40 } },
        { { "attackRipple", 56 }, { "attackRange", 50 } },
        { { "attackRipple", 67 }, { "attackRange", 60 } },
        { { "attackRipple", 82 }, { "attackRange", 70 } },
        { { "attackRipple", 90 }, { "attackRange", 80 } },
        { { "attackRipple", 100 }, { "attackRange", 90 } },
    })
    :ability(
    AbilityTpl()
        :name("海皇牙叉")
        :icon("item/NagaWeaponUp2")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description(
        function(this)
            local lv = this:level()
            local odds = 7 + 1 * lv
            local percent = 34 + 11 * lv
            return {
                colour.hex(colour.gold, "攻击时有" .. odds .. "%几率额外痛击木飙"),
                colour.hex(colour.gold, "痛击造成水伤以最后一次造成伤害为基准的" .. percent .. "%"),
                colour.hex(colour.yellow, "当木飙附着水时，痛击几率提升3倍"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            local tu = attackData.targetUnit
            local lv = attackData.triggerAbility:level()
            local odds = 7 + 1 * lv
            if (tu:isEnchantAppending(DAMAGE_TYPE.water)) then
                odds = odds * 3
            end
            if (math.rand(1, 100) <= odds) then
                local percent = 34 + 11 * lv
                local dmg = percent / 100 * attackData.damage
                ability.crit({
                    sourceUnit = u,
                    targetUnit = tu,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.item,
                    damageType = DAMAGE_TYPE.water,
                    effect = "NagaDeath",
                })
            end
        end))