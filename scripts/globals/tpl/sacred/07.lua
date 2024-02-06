TPL_SACRED[7] = ItemTpl()
    :name("先导至杖")
    :icon("item/ScepterOfMastery")
    :modelAlias("item/ScepterOfMastery")
    :description("通明先导，破除迷失")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { "sight", 100 }, { "mp", 60 } },
        { { "sight", 150 }, { "mp", 80 } },
        { { "sight", 200 }, { "mp", 100 }, { "mpRegen", 2 } },
        { { "sight", 250 }, { "mp", 120 }, { "mpRegen", 3 } },
        { { "sight", 300 }, { "mp", 140 }, { "mpRegen", 4 }, { "mpSuckAttack", 3 }, },
        { { "sight", 350 }, { "mp", 160 }, { "mpRegen", 5 }, { "mpSuckAttack", 5 }, },
        { { "sight", 400 }, { "mp", 200 }, { "mpRegen", 6 }, { "mpSuckAttack", 7 }, },
        { { "sight", 450 }, { "mp", 250 }, { "mpRegen", 7 }, { "mpSuckAttack", 9 }, },
        { { "sight", 500 }, { "mp", 300 }, { "mpRegen", 8 }, { "mpSuckAttack", 12 }, },
        { { "sight", 600 }, { "mp", 350 }, { "mpRegen", 10 }, { "mpSuckAttack", 15 }, },
    })