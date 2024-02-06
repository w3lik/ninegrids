TPL_SACRED[26] = ItemTpl()
    :name("死神镰钺")
    :icon("item/Axe96")
    :modelAlias("item/Polearm")
    :description("收割灵泠的死神大镰")
    :prop("forgeList",
    {
        { { "hpSuckAttack", 5 } },
        { { "hpSuckAttack", 6 } },
        { { "hpSuckAttack", 7 } },
        { { "hpSuckAttack", 9 } },
        { { "hpSuckAttack", 11 } },
        { { "hpSuckAttack", 14 }, { "mpSuckAttack", 6 } },
        { { "hpSuckAttack", 17 }, { "mpSuckAttack", 9 } },
        { { "hpSuckAttack", 21 }, { "mpSuckAttack", 12 } },
        { { "hpSuckAttack", 23 }, { "mpSuckAttack", 15 } },
        { { "hpSuckAttack", 25 }, { "mpSuckAttack", 20 } },
    })
    :ability(
    AbilityTpl()
        :name("死神镰钺")
        :icon("item/Axe96")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(27, 0)
        :mpCostAdv(150, 10)
        :castRadiusAdv(500, 0)
        :description(
        function(this)
            local lv = this:level()
            local hpRegen = lv * 8
            local def = 9 + lv * 6
            return {
                "进行一次范围群体暗伤缠击",
                colour.hex(colour.gold, "被攻击的敌人"),
                colour.hex(colour.gold, "HP恢复降低 " .. hpRegen),
                colour.hex(colour.gold, "防御降低 " .. def),
                colour.hex(colour.gold, "负面效果持续 7 秒")
            }
        end)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local radius = ab:castRadius()
            local hpRegen = lv * 8
            local def = 9 + lv * 6
            u:animate("attack slam")
            u:effect("slash/Round_dance2", 2.2)
            local g = Group():catch(UnitClass, {
                circle = { x = u:x(), y = u:y(), radius = radius },
                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
            })
            audio(V3d("sword1"), nil, function(this)
                this:unit(u)
            end)
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = u:attack(),
                        damageSrc = DAMAGE_SRC.attack,
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 2,
                    })
                    eu:buff("死神隐伤")
                      :signal(BUFF_SIGNAL.down)
                      :icon("item/Axe96")
                      :description({
                        colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                        colour.hex(colour.indianred, "防御：-" .. def)
                    })
                      :duration(7)
                      :purpose(function(buffObj)
                        buffObj:attach("buff/FatalWoundV2", "origin")
                        buffObj:hpRegen("-=" .. hpRegen)
                        buffObj:defend("-=" .. def)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/FatalWoundV2", "origin")
                        buffObj:hpRegen("+=" .. hpRegen)
                        buffObj:defend("+=" .. def)
                    end)
                      :run()
                end
            end
        end))