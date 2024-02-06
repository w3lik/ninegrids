TPL_SACRED[20] = ItemTpl()
    :name("阎王")
    :icon("item/Sword98")
    :modelAlias("item/JWeapon3")
    :description("剑 · 赤炼 · 阎王")
    :prop("forgeList",
    {
        { { "attack", 20 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 3 } },
        { { "attack", 25 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 4 } },
        { { "attack", 30 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 5 } },
        { { "attack", 40 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 7 } },
        { { "attack", 50 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 9 } },
        { { "attack", 60 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 11 } },
        { { "attack", 70 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 13 } },
        { { "attack", 80 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 15 } },
        { { "attack", 90 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 18 } },
        { { "attack", 100 }, { SYMBOL_E .. DAMAGE_TYPE.fire.value, 25 } },
    })
    :ability(
    AbilityTpl()
        :name("阎王")
        :icon("item/Sword98")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :coolDownAdv(3, 0)
        :description(
        {
            colour.hex(colour.gold, "暴击时有14%几率发起一次群体缠击"),
            colour.hex(colour.gold, "后再提升7%暴击几率及11%暴击加成"),
            "缠击火伤害：" .. colour.hex(colour.indianred, "攻击 x 0.25"),
            "提升持续时间：" .. colour.hex(colour.skyblue, "10秒"),
        })
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onUnitEvent(EVENT.Unit.Crit,
        function(critData)
            if (math.rand(1, 100) <= 14) then
                local u = critData.triggerUnit
                local ab = critData.triggerAbility
                local dmg = 0.25 * u:attack()
                u:effect("slash/Blood", 1)
                local g = Group():catch(UnitClass, {
                    circle = { x = u:x(), y = u:y(), radius = 265 },
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                })
                audio(V3d("sword2"), nil, function(this)
                    this:unit(u)
                end)
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.attack,
                            damageType = DAMAGE_TYPE.fire,
                            damageTypeLevel = 3,
                        })
                    end
                end
                critData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            u:buff("阎王暴动")
             :signal(BUFF_SIGNAL.up)
             :icon("item/Sword98")
             :description({ colour.hex(colour.lawngreen, "暴击几率：+7%"), colour.hex(colour.lawngreen, "暴击伤害：+11%") })
             :duration(10)
             :purpose(
                function(buffObj)
                    buffObj:odds("crit", "+=7")
                    buffObj:crit("+=11")
                end)
             :rollback(
                function(buffObj)
                    buffObj:odds("crit", "-=7")
                    buffObj:crit("-=11")
                end)
             :run()
        end))