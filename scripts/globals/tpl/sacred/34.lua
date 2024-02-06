TPL_SACRED[34] = ItemTpl()
    :name("离子球")
    :icon("item/OrbOfLightning")
    :modelAlias("item/OrbOfLightning")
    :description("霹雳雷霆粒子构成的神奇球体")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 10 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 15 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 20 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 25 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 30 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 35 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 40 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 45 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 50 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 55 } },
    })
    :ability(
    AbilityTpl()
        :name("离子球")
        :icon("item/OrbOfLightning")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :description(colour.hex(colour.gold, "攻击模式转变为群体4木飙雷伤闪电(优先级4)"))
        :onEvent(EVENT.Ability.Get,
        function(abData)
            local u = abData.triggerAbility:bindItem():bindUnit()
            local k = "离子球" .. u:id()
            if (isStaticClass(k, AttackModeClass) == false) then
                u:attackModePush(AttackModeStatic(k)
                    :priority(4)
                    :mode("lightning")
                    :lightningType(LIGHTNING_TYPE.thunderShot)
                    :radius(400):scatter(4)
                    :damageType(DAMAGE_TYPE.thunder))
            end
        end)
        :onEvent(EVENT.Ability.Lose,
        function(abData)
            local u = abData.triggerAbility:bindItem():bindUnit()
            local k = "离子球" .. u:id()
            if (isStaticClass(k, AttackModeClass)) then
                u:attackModeRemove(AttackModeStatic(k):id())
            end
        end))