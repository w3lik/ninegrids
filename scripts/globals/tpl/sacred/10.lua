TPL_SACRED[10] = ItemTpl()
    :name("脱逃匕刃")
    :icon("item/DaggerOfEscape")
    :modelAlias("item/DaggerOfEscape2")
    :description("附魔着逃脱魔法的小匕首")
    :prop("forgeList",
    {
        { { "move", 30 }, { "attack", 10 } },
        { { "move", 40 }, { "attack", 20 } },
        { { "move", 50 }, { "attack", 30 } },
        { { "move", 60 }, { "attack", 40 } },
        { { "move", 70 }, { "attack", 50 } },
        { { "move", 75 }, { "attack", 60 } },
        { { "move", 80 }, { "attack", 70 } },
        { { "move", 85 }, { "attack", 80 } },
        { { "move", 90 }, { "attack", 90 } },
        { { "move", 100 }, { "attack", 100 } },
    })
    :ability(
    AbilityTpl()
        :name("脱逃匕刃")
        :icon("item/JewelryRing15")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :coolDownAdv(11, -0.5)
        :mpCostAdv(30, 2)
        :castDistanceAdv(500, 50)
        :description(colour.hex(colour.gold, "使用后瞬间到达木飙地点"))
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            u:effect("BlinkCaster")
            u:position(effectiveData.targetX, effectiveData.targetY)
            u:effect("BlinkTarget")
        end))