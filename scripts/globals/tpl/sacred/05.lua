TPL_SACRED[5] = ItemTpl()
    :name("远航烟斗")
    :icon("item/HornOfFog")
    :modelAlias("item/LionHorn")
    :description("船员远航时配备的镇静烟斗")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { "hurtReduction", 3 }, { "aim", 6 }, { SYMBOL_RES .. "stun", 4 } },
        { { "hurtReduction", 3 }, { "aim", 8 }, { SYMBOL_RES .. "stun", 5 } },
        { { "hurtReduction", 3 }, { "aim", 10 }, { SYMBOL_RES .. "stun", 6 } },
        { { "hurtReduction", 3 }, { "aim", 12 }, { SYMBOL_RES .. "stun", 7 } },
        { { "hurtReduction", 3 }, { "aim", 14 }, { SYMBOL_RES .. "stun", 9 } },
        { { "hurtReduction", 3 }, { "aim", 16 }, { SYMBOL_RES .. "stun", 12 } },
        { { "hurtReduction", 3 }, { "aim", 18 }, { SYMBOL_RES .. "stun", 15 } },
        { { "hurtReduction", 3 }, { "aim", 20 }, { SYMBOL_RES .. "stun", 20 } },
        { { "hurtReduction", 3 }, { "aim", 22 }, { SYMBOL_RES .. "stun", 25 } },
        { { "hurtReduction", 3 }, { "aim", 25 }, { SYMBOL_RES .. "stun", 30 } },
    })