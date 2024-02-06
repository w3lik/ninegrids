TPL_SACRED[45] = ItemTpl()
    :name("恶面坚盾")
    :icon("item/AdvancedUnholyArmor")
    :modelAlias("item/Shield3")
    :description("反道而行的进攻盾牌，杀戮无数")
    :conditionTips("运气获得")
    :prop("forgeList",
    {
        { { "hurtIncrease", 3 }, { SYMBOL_ODD .. "hurtRebound", 5 }, { "hurtRebound", 9 } },
        { { "hurtIncrease", 4 }, { SYMBOL_ODD .. "hurtRebound", 5 }, { "hurtRebound", 12 } },
        { { "hurtIncrease", 5 }, { SYMBOL_ODD .. "hurtRebound", 8 }, { "hurtRebound", 15 } },
        { { "hurtIncrease", 6 }, { SYMBOL_ODD .. "hurtRebound", 8 }, { "hurtRebound", 18 } },
        { { "hurtIncrease", 7 }, { SYMBOL_ODD .. "hurtRebound", 10 }, { "hurtRebound", 22 } },
        { { "hurtIncrease", 8 }, { SYMBOL_ODD .. "hurtRebound", 10 }, { "hurtRebound", 27 } },
        { { "hurtIncrease", 9 }, { SYMBOL_ODD .. "hurtRebound", 10 }, { "hurtRebound", 31 } },
        { { "hurtIncrease", 11 }, { SYMBOL_ODD .. "hurtRebound", 15 }, { "hurtRebound", 36 } },
        { { "hurtIncrease", 13 }, { SYMBOL_ODD .. "hurtRebound", 15 }, { "hurtRebound", 40 } },
        { { "hurtIncrease", 15 }, { SYMBOL_ODD .. "hurtRebound", 15 }, { "hurtRebound", 45 } },
    })