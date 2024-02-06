TPL_ABILITY_SOUL[42] = AbilityTpl()
    :name("洞悉至眼")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/AncientEye")
    :condition(
    function()
        return Game():achievement(2) == true
    end)
    :conditionTips("通过洞悉探秘区")
    :attributes({ { "visible", 200, 100 } })
    :onEvent(EVENT.Ability.Get,
    function(abData)
        abData.triggerUnit:attach("buff/ProvidenceAuraGreen", "origin")
    end)
    :onEvent(EVENT.Ability.Lose,
    function(abData)
        abData.triggerUnit:detach("buff/ProvidenceAuraGreen", "origin")
    end)