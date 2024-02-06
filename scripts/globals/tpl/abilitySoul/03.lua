TPL_ABILITY_SOUL[3] = AbilityTpl()
    :name("强身健体")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/Vigorously")
    :description({ "增强自己的身体强度", "能够抵御更多的伤害" })
    :attributes(
    {
        { "hp", 300, 150 },
        { "hpRegen", 6, 1 },
        { "defend", 12, 3 },
    })