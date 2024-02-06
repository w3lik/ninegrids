TPL_SACRED[25] = ItemTpl()
    :name("青龙秘宝")
    :icon("item/SpellShieldAmulet")
    :modelAlias("item/SpellShieldAmulet2")
    :description("青龙一族不外传的秘宝能把控风雷")
    :prop("forgeList",
    {
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 4 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 4 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 5 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 5 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 7 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 7 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 10 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 10 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 13 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 13 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 17 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 17 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 21 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 21 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 26 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 26 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 30 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 30 } },
        { { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.wind.value, 35 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.thunder.value, 35 } },
    })
    :onEvent(EVENT.Item.Get, function(itData) itData.triggerUnit:attach("buff/WhiteDragon", "chest") end)
    :onEvent(EVENT.Item.Lose, function(itData) itData.triggerUnit:detach("buff/WhiteDragon", "chest") end)