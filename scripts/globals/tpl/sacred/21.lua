TPL_SACRED[21] = ItemTpl()
    :name("双尖镇海枪")
    :icon("item/ImprovedStrengthOfTheMoon")
    :modelAlias("item/PitlordBlade")
    :description("锋利的双头长枪，具有御海至力")
    :prop("forgeList",
    {
        { { "attack", 15 }, { SYMBOL_ODD .. "stun", 1 }, { "stun", 0.2 } },
        { { "attack", 16 }, { SYMBOL_ODD .. "stun", 2 }, { "stun", 0.3 } },
        { { "attack", 18 }, { SYMBOL_ODD .. "stun", 2 }, { "stun", 0.4 } },
        { { "attack", 22 }, { SYMBOL_ODD .. "stun", 3 }, { "stun", 0.5 } },
        { { "attack", 26 }, { SYMBOL_ODD .. "stun", 3 }, { "stun", 0.6 } },
        { { "attack", 30 }, { SYMBOL_ODD .. "stun", 4 }, { "stun", 0.7 } },
        { { "attack", 33 }, { SYMBOL_ODD .. "stun", 4 }, { "stun", 0.8 } },
        { { "attack", 37 }, { SYMBOL_ODD .. "stun", 5 }, { "stun", 0.9 } },
        { { "attack", 40 }, { SYMBOL_ODD .. "stun", 5 }, { "stun", 1.0 } },
        { { "attack", 45 }, { SYMBOL_ODD .. "stun", 6 }, { "stun", 1.1 } },
    })
    :ability(
    AbilityTpl()
        :name("双尖镇海枪")
        :icon("item/ImprovedStrengthOfTheMoon")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :coolDownAdv(35, -0.5)
        :castChantAdv(1.5, 0)
        :castChantEffect("ManaDrainTarget")
        :castKeepAdv(6, 0.5)
        :castRadiusAdv(250, 0)
        :mpCostAdv(50, 5)
        :description(
        function(this)
            local lv = this:level()
            local dmg = 40 + 13 * lv
            return {
                "使用后在身边不断召唤海浪",
                colour.hex(colour.gold, "每0.25秒一波海浪造成" .. dmg .. "水伤"),
                colour.hex(colour.yellow, "在雨天使用时伤害附加自身3%攻击")
            }
        end)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local radius = ab:castRadius()
            local keep = ab:castKeep()
            local ci = 0
            time.setInterval(0.25, function(curTimer)
                ci = ci + 0.25
                if (ci >= keep or false == u:isAbilityKeepCasting()) then
                    destroy(curTimer)
                    return
                end
                effector("eff/VortexArea", u:x(), u:y(), 30, 1.5)
                local g = Group():catch(UnitClass, {
                    circle = { x = u:x(), y = u:y(), radius = radius },
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                })
                audio(V3d("water2"), nil, function(this)
                    this:unit(u)
                end)
                if (#g > 0) then
                    local dmg = 40 + 13 * lv
                    if (Game():isWeather("rain")) then
                        dmg = dmg + 0.03 * u:attack()
                    end
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.item,
                            damageType = DAMAGE_TYPE.water,
                            damageTypeLevel = 0,
                        })
                    end
                end
            end)
        end))