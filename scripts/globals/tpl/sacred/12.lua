TPL_SACRED[12] = ItemTpl()
    :name("剧毒肢牙")
    :icon("item/MiscMonsterClaw09")
    :modelAlias("item/CrystalLamp_Red")
    :description("怪物的肢解一脚遍布剧毒绒毛")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 3 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 5 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 7 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 10 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 13 }, { "attack", 50 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 17 }, { "attack", 60 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 21 }, { "attack", 75 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 25 }, { "attack", 90 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 30 }, { "attack", 105 } },
        { { SYMBOL_E .. DAMAGE_TYPE.poison.value, 35 }, { "attack", 130 } },
    })