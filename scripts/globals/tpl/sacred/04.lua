TPL_SACRED[4] = ItemTpl()
    :name("诡异指环")
    :icon("item/JewelryRing15")
    :modelAlias("item/RingPurple")
    :description("通身发紫具有象征形象的指环")
    :conditionTips("场景探索")
    :prop("forgeList",
    {
        { { "defend", 3 } },
        { { "defend", 4 }, { "avoid", 5 } },
        { { "defend", 5 }, { "avoid", 7 } },
        { { "defend", 7 }, { "avoid", 10 } },
        { { "defend", 9 }, { "avoid", 13 } },
        { { "defend", 11 }, { "avoid", 16 } },
        { { "defend", 13 }, { "avoid", 19 } },
        { { "defend", 17 }, { "avoid", 21 } },
        { { "defend", 20 }, { "avoid", 23 } },
        { { "defend", 25 }, { "avoid", 25 } },
    })
    :ability(
    AbilityTpl()
        :name("诡异指环")
        :icon("item/JewelryRing15")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(35, 0)
        :hpCostAdv(100, 0)
        :description(
        {
            colour.hex(colour.gold, "使用后移动提升 120 点"),
            colour.hex(colour.gold, "同时回避提升 30%"),
            colour.hex(colour.gold, "效果持续 5 秒")
        })
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            u:buff("诡异指环移动")
             :signal(BUFF_SIGNAL.up)
             :icon("item/JewelryRing15")
             :description(
                {
                    colour.hex(colour.lawngreen, "移动：+120"),
                    colour.hex(colour.lawngreen, "回避：+30%"),
                })
             :duration(5)
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/WindwalkBlood", "origin")
                    buffObj:move("+=120")
                    buffObj:avoid("+=30")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/WindwalkBlood", "origin")
                    buffObj:move("-=120")
                    buffObj:avoid("-=30")
                end)
             :run()
        end))