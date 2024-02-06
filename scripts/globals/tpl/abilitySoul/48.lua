TPL_ABILITY_SOUL[48] = AbilityTpl()
    :name("附魔大精通")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/ElementalSilk")
    :condition(
    function()
        return Game():achievement(16) == true
            and Game():achievement(17) == true
            and Game():achievement(18) == true
            and Game():achievement(19) == true
            and Game():achievement(20) == true
    end)
    :conditionTips("获得5种反应式")
    :description("附魔精通可提升元素反应效果伤害")
    :attributes({ { "enchantMystery", 25, 5 } })
    :onEvent(EVENT.Ability.Get,
    function(abData)
        abData.triggerUnit:attach("buff/Soap", "origin")
    end)
    :onEvent(EVENT.Ability.Lose,
    function(abData)
        abData.triggerUnit:detach("buff/Soap", "origin")
    end)