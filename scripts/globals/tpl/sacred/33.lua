TPL_SACRED[33] = ItemTpl()
    :name("吞天")
    :icon("item/WeaponHalberd17")
    :modelAlias("item/JWeapon1")
    :description("剑 · 天穹 · 吞噬")
    :prop("forgeList",
    {
        { { "hurtReduction", 1 }, { "attack", 10 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 13 } },
        { { "hurtReduction", 2 }, { "attack", 13 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 15 } },
        { { "hurtReduction", 3 }, { "attack", 16 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 17 } },
        { { "hurtReduction", 4 }, { "attack", 20 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 20 } },
        { { "hurtReduction", 5 }, { "attack", 24 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 25 } },
        { { "hurtReduction", 7 }, { "attack", 28 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 33 } },
        { { "hurtReduction", 8 }, { "attack", 34 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 39 } },
        { { "hurtReduction", 9 }, { "attack", 40 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 44 } },
        { { "hurtReduction", 10 }, { "attack", 50 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 50 } },
        { { "hurtReduction", 13 }, { "attack", 55 }, { SYMBOL_E .. DAMAGE_TYPE.dark.value, 55 } },
    })
    :ability(
    AbilityTpl()
        :name("吞天")
        :icon("item/WeaponHalberd17")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :coolDownAdv(30, 0)
        :hpCostAdv(80, 15)
        :castRadiusAdv(135, 20)
        :castDistanceAdv(500, 0)
        :description(
        function(this)
            local lv = this:level()
            local dmg = 26 + 6 * lv
            local move = 50 + 8 * lv
            local desc = {
                colour.hex(colour.gold, "吞天会被动压迫附近300半径敌人使其降低" .. move .. "移动"),
                colour.hex(colour.gold, "而使用时以无视防御黑球对范围的敌人造成" .. dmg .. "暗伤害"),
                colour.hex(colour.gold, "若木飙被吞蚀时处在压迫效果中则伤害增加50%"),
            }
            return desc
        end)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Get,
        function(abData)
            local ab = abData.triggerAbility
            local u = ab:bindItem():bindUnit()
            local lv = ab:level()
            local move = 50 + 8 * lv
            AuraAttach("吞天" .. u:id())
                :radius(300)
                :centerUnit(u)
                :centerEffect("buff/FlyingSwordDark", "origin", 1)
                :filter(function(enumUnit) return ab:isCastTarget(enumUnit) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    eu:buff("吞天重力压迫")
                      :icon("item/WeaponHalberd17")
                      :description({ colour.hex(colour.indianred, "移动：-" .. move) })
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attach("buff/ShiningAura", "origin")
                        buffObj:move("-=" .. move)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/ShiningAura", "origin")
                        buffObj:move("+=" .. move)
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    local eu = auraData.triggerUnit
                    eu:buffClear({ key = "吞天重力压迫" })
                end)
        end)
        :onEvent(EVENT.Ability.Lose,
        function(abData)
            local u = abData.triggerAbility:bindItem():bindUnit()
            AuraDetach("吞天" .. u:id())
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local radius = ab:castRadius()
            local distance = ab:castDistance()
            local dmg = 26 + 6 * lv
            local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
            local fac = vector2.angle(x1, y1, x2, y2)
            local x, y = vector2.polar(x1, y1, distance, fac)
            local n = 0
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y, radius / 2 },
                modelAlias = "eff/BlackHolePurpleSmall",
                scale = radius / 128,
                speed = 50,
                weaponLength = radius / 2,
                weaponHeight = radius / 2,
                onMove = function(_, vec)
                    n = n + 1
                    if (n % 20 == 0) then
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = radius },
                            limit = 10,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                if (eu:buffHas("吞天重力压迫")) then
                                    dmg = dmg * 1.5
                                end
                                for _ = 1, 2 do
                                    local ef
                                    local j = math.rand(1, 4)
                                    local k = math.rand(1, 2)
                                    if (k == 1) then
                                        ef = "slash/Ephemeral_Cut_Silver"
                                    else
                                        ef = "slash/Ephemeral_Cut_Purple"
                                    end
                                    if (j == 1) then
                                        eu:attach(ef, "origin", 0.3)
                                    elseif (j == 2) then
                                        eu:attach(ef, "chest", 0.3)
                                    elseif (j == 3) then
                                        eu:attach(ef, "head", 0.3)
                                    elseif (j == 4) then
                                        eu:attach(ef, "weapon", 0.3)
                                    end
                                end
                                audio(V3d("sword4"), nil, function(this)
                                    this:unit(u)
                                end)
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.item,
                                    damageType = DAMAGE_TYPE.dark,
                                    breakArmor = { BREAK_ARMOR.defend },
                                    damageTypeLevel = 0,
                                })
                            end
                        end
                    end
                end
            })
        end))