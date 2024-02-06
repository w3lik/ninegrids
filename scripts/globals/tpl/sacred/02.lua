TPL_SACRED[2] = ItemTpl()
    :name("小木弓")
    :icon("item/ImprovedBows")
    :modelAlias("item/Bow")
    :description("轻便特点的精灵族常用小弓箭")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { "attackSpeed", 3 } },
        { { "attackSpeed", 5 } },
        { { "attackSpeed", 7 } },
        { { "attackSpeed", 10 }, { "attackRange", 25 } },
        { { "attackSpeed", 13 }, { "attackRange", 35 }, { "move", 10 } },
        { { "attackSpeed", 16 }, { "attackRange", 45 }, { "move", 15 } },
        { { "attackSpeed", 19 }, { "attackRange", 60 }, { "move", 20 } },
        { { "attackSpeed", 21 }, { "attackRange", 80 }, { "move", 25 } },
        { { "attackSpeed", 23 }, { "attackRange", 100 }, { "move", 30 } },
        { { "attackSpeed", 25 }, { "attackRange", 125 }, { "move", 35 } },
    })