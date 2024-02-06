TPL_SACRED[38] = ItemTpl()
    :name("灭世法杖")
    :icon("item/Staff25")
    :modelAlias("item/TheTimeDistorter")
    :description("灭世恶魔使用的法杖至一")
    :prop("forgeList",
    {
        { { "mpSuckAbility", 9 }, { "damageIncrease", 4 } },
        { { "mpSuckAbility", 11 }, { "damageIncrease", 6 } },
        { { "mpSuckAbility", 13 }, { "damageIncrease", 8 } },
        { { "mpSuckAbility", 15 }, { "damageIncrease", 10 } },
        { { "mpSuckAbility", 16 }, { "damageIncrease", 12 } },
        { { "mpSuckAbility", 17 }, { "damageIncrease", 14 } },
        { { "mpSuckAbility", 18 }, { "damageIncrease", 16 } },
        { { "mpSuckAbility", 19 }, { "damageIncrease", 18 } },
        { { "mpSuckAbility", 20 }, { "damageIncrease", 20 } },
        { { "mpSuckAbility", 22 }, { "damageIncrease", 22 } },
    })
    :ability(
    AbilityTpl()
        :name("灭世法杖")
        :icon("item/Staff25")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :coolDownAdv(90, -2)
        :hpCostAdv(225, 15)
        :castRadiusAdv(160, 0)
        :description(
        function(this)
            local lv = this:level()
            local dmg = 210 + 130 * lv
            local dmg2 = 100 + 50 * lv
            local dark = 4 + 2 * lv
            return {
                colour.hex(colour.gold, "发出一道恐怖黑闪雷攻击造成" .. dmg .. "暗伤害"),
                colour.hex(colour.gold, "闪雷会降低木飙" .. dark .. "%暗抗性20秒"),
                colour.hex(colour.gold, "并会在位置引爆造成160半径范围" .. dmg2 .. "暗伤害"),
            }
        end)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local dmg = 210 + 130 * lv
            local dmg2 = 100 + 50 * lv
            local dark = 4 + 2 * lv
            local tx, ty, tz = tu:x(), tu:y(), tu:z()
            lightning(LIGHTNING_TYPE.thunderRed, u:x(), u:y(), u:z(), tx, ty, tz, 0.2)
            time.setTimeout(0.1, function()
                effector("eff/Bloody2", tx, ty, tz + 50, 3)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = tu,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.item,
                    damageType = DAMAGE_TYPE.dark,
                    damageTypeLevel = 2,
                })
                tu:buff("灭世减抗")
                  :signal(BUFF_SIGNAL.down)
                  :icon("item/Staff25")
                  :description({ colour.hex(colour.indianred, "暗抗性：-" .. dark .. '%') })
                  :duration(20)
                  :purpose(
                    function(buffObj)
                        buffObj:attach("buff/BurningRagePink", "head")
                        buffObj:attach("buff/DarkCurse", "overhead")
                        buffObj:enchantResistance(DAMAGE_TYPE.dark, "-=" .. dark)
                    end)
                  :rollback(
                    function(buffObj)
                        buffObj:detach("buff/BurningRagePink", "head")
                        buffObj:detach("buff/DarkCurse", "overhead")
                        buffObj:enchantResistance(DAMAGE_TYPE.dark, "+=" .. dark)
                    end)
                  :run()
            end)
            time.setTimeout(0.2, function()
                effector("eff/FlamestrikeDarkBloodII", tx, ty, tz + 20, 1.5)
                local g = Group():catch(UnitClass, {
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                    circle = { x = tx, y = ty, radius = 160 },
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg2,
                            damageSrc = DAMAGE_SRC.item,
                            damageType = DAMAGE_TYPE.dark,
                            damageTypeLevel = 0,
                        })
                    end
                end
            end)
        end))