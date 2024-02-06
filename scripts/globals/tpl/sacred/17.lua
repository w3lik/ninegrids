TPL_SACRED[17] = ItemTpl()
    :name("巫冥戒")
    :icon("item/JewelryRing63")
    :modelAlias("item/Ror")
    :description("寓意神祗的冥界戒指")
    :prop("forgeList",
    {
        { { "defend", 2 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 3 } },
        { { "defend", 3 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 5 } },
        { { "defend", 4 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 7 } },
        { { "defend", 5 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 9 } },
        { { "defend", 6 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 11 } },
        { { "defend", 7 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 13 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.dark.value, 6 } },
        { { "defend", 9 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.dark.value, 9 } },
        { { "defend", 11 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 18 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.dark.value, 12 } },
        { { "defend", 13 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 20 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.dark.value, 15 } },
        { { "defend", 15 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, 25 }, { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.dark.value, 20 } },
    })
    :ability(
    AbilityTpl()
        :name("巫冥戒")
        :icon("item/JewelryRing63")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :coolDownAdv(22, -1)
        :hpCostAdv(180, 10)
        :castDistanceAdv(500, 0)
        :castRadiusAdv(250, 15)
        :description(
        {
            colour.hex(colour.gold, "使用后降低范围木飙木飙"),
            colour.hex(colour.gold, "攻速 43% 和移动 110点"),
            colour.hex(colour.gold, "持续6秒")
        })
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            Effect("eff/BlizzardEruption", effectiveData.targetX, effectiveData.targetY, effectiveData.targetZ, 2):size(radius / 300)
            local g = Group():catch(UnitClass, {
                circle = { x = effectiveData.targetX, y = effectiveData.targetY, radius = radius },
                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    eu:buff("巫冥戒降速")
                      :signal(BUFF_SIGNAL.down)
                      :icon("item/JewelryRing63")
                      :description({ colour.hex(colour.indianred, "攻速：-43%"), colour.hex(colour.indianred, "移动：-110") })
                      :duration(6)
                      :purpose(
                        function(buffObj)
                            buffObj:attach("FrostDamage", "origin")
                            buffObj:attackSpeed("-=43")
                            buffObj:move("-=110")
                        end)
                      :rollback(
                        function(buffObj)
                            buffObj:detach("FrostDamage", "origin")
                            buffObj:attackSpeed("+=43")
                            buffObj:move("+=110")
                        end)
                      :run()
                end
            end
        end))