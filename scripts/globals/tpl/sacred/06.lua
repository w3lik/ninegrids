TPL_SACRED[6] = ItemTpl()
    :name("奥术残卷")
    :icon("item/BansheeAdept")
    :modelAlias("item/ScrollKnowl")
    :description("仅剩一页的奥术残卷")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 5 }, { "mp", 75 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 6 }, { "mp", 90 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 7 }, { "mp", 115 }, { "mpRegen", 1 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 8 }, { "mp", 150 }, { "mpRegen", 2 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 9 }, { "mp", 180 }, { "mpRegen", 3 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 10 }, { "mp", 220 }, { "mpRegen", 4 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 11 }, { "mp", 275 }, { "mpRegen", 5 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 13 }, { "mp", 360 }, { "mpRegen", 7 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 15 }, { "mp", 400 }, { "mpRegen", 9 } },
        { { SYMBOL_E .. DAMAGE_TYPE.dark.value, 18 }, { "mp", 450 }, { "mpRegen", 13 } },
    })