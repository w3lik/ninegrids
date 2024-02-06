TPL_SACRED[29] = ItemTpl()
    :name("渤泓")
    :icon("item/WeaponShortblade37")
    :modelAlias("item/JWeapon4")
    :description("剑 · 湍渤 · 泓流")
    :prop("forgeList",
    {
        { { "attack", 11 }, { "attackSpeed", 11 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 6 } },
        { { "attack", 14 }, { "attackSpeed", 13 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 8 } },
        { { "attack", 17 }, { "attackSpeed", 15 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 10 } },
        { { "attack", 23 }, { "attackSpeed", 17 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 13 } },
        { { "attack", 29 }, { "attackSpeed", 19 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 15 } },
        { { "attack", 35 }, { "attackSpeed", 21 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 18 } },
        { { "attack", 43 }, { "attackSpeed", 23 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 23 } },
        { { "attack", 58 }, { "attackSpeed", 25 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 28 } },
        { { "attack", 70 }, { "attackSpeed", 27 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 33 } },
        { { "attack", 85 }, { "attackSpeed", 30 }, { SYMBOL_E .. DAMAGE_TYPE.water.value, 36 } },
    })
    :ability(
    AbilityTpl()
        :name("渤泓")
        :icon("item/WeaponHalberd19")
        :coolDownAdv(3, 0)
        :targetType(ABILITY_TARGET_TYPE.pas)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :description(
        function(this)
            local lv = this:level()
            local dmg1 = 25 + 8 * lv
            local dmg2 = 18 + 5 * lv
            return {
                colour.hex(colour.gold, "攻击时会触发渤或泓2种效果的其中1种"),
                colour.hex(colour.gold, "[渤]近距离快速进行多次缠击造成：" .. dmg1 .. "水伤害"),
                colour.hex(colour.gold, "[泓]远距挥出紊流对前方敌人造成：" .. dmg2 .. "水伤害"),
                colour.hex(colour.gold, "[激流效应]渤会降低水抗而后泓会进行额外伤害"),
                colour.hex(colour.yellow, "在雨天使用会产生渤泓的激流效应"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            attackData.triggerAbility:effective({
                targetUnit = attackData.targetUnit
            })
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local ab = effectiveData.triggerAbility
            local lv = ab:level()
            local dmg1 = 25 + 8 * lv
            local dmg2 = 18 + 5 * lv
            local typ = math.rand(1, 2)
            local isUpgrade = Game():isWeather("rain")
            local _slash = function(targetUnit, dmg)
                local j = math.rand(1, 4)
                if (j == 1) then
                    targetUnit:attach("slash/Ephemeral_Cut_Teal", "origin", 0.3)
                elseif (j == 2) then
                    targetUnit:attach("slash/Ephemeral_Cut_Teal", "chest", 0.3)
                elseif (j == 3) then
                    targetUnit:attach("slash/Ephemeral_Cut_Teal", "head", 0.3)
                elseif (j == 4) then
                    targetUnit:attach("slash/Ephemeral_Cut_Teal", "weapon", 0.3)
                end
                audio(V3d("sword4"), nil, function(this)
                    this:unit(tu)
                end)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = targetUnit,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.item,
                    damageType = DAMAGE_TYPE.water,
                    damageTypeLevel = 1,
                })
            end
            local x1, y1, x2, y2 = u:x(), u:y(), tu:x(), tu:y()
            local fac = vector2.angle(x1, y1, x2, y2)
            if (typ == 1) then
                local i = 0
                local e = Effect("slash/CrescentKnife", x2, y2, 10, 1)
                e:size(0.4):rotateZ(fac)
                time.setInterval(0.1, function(curTimer)
                    i = i + 1
                    if (i > 5 or u:isInterrupt()) then
                        destroy(curTimer)
                        return
                    end
                    local g = Group():catch(UnitClass, {
                        circle = { x = x2, y = y2, radius = 100 },
                        limit = 3,
                        filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                    })
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            _slash(eu, dmg1)
                            if (isUpgrade) then
                                eu:buff("激流减抗")
                                  :signal(BUFF_SIGNAL.down)
                                  :icon("item/WeaponHalberd19")
                                  :description({ colour.hex(colour.indianred, "水抗性：-5%") })
                                  :duration(5)
                                  :purpose(
                                    function(buffObj)
                                        buffObj:attach("buff/RadianceRoyal", "chest")
                                        buffObj:enchantResistance(DAMAGE_TYPE.water, "-=5")
                                    end)
                                  :rollback(
                                    function(buffObj)
                                        buffObj:detach("buff/RadianceRoyal", "chest")
                                        buffObj:enchantResistance(DAMAGE_TYPE.water, "+=5")
                                    end)
                                  :run()
                            end
                        end
                    end
                end)
            elseif (typ == 2) then
                local x, y = vector2.polar(x1, y1, 600, fac)
                local n = 0
                local radius = 128
                ability.missile({
                    sourceUnit = u,
                    targetVec = { x, y, radius / 2 },
                    modelAlias = "slash/XBluRayCut",
                    scale = 1.0,
                    speed = 400,
                    acceleration = -2,
                    onMove = function(options, vec)
                        n = n + 1
                        if (n % 7 == 0) then
                            local g = Group():catch(UnitClass, {
                                circle = { x = vec[1], y = vec[2], radius = radius * options.scale },
                                limit = 4,
                                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                            })
                            if (#g > 0) then
                                for _, eu in ipairs(g) do
                                    _slash(eu, dmg2)
                                    if (isUpgrade) then
                                        local c = eu:buffCount("激流减抗")
                                        if (c >= 1) then
                                            eu:attach("eff/Enchantment", "chest", 1)
                                            eu:buffClear({ key = "激流减抗" })
                                            local g2 = Group():catch(UnitClass, {
                                                circle = { x = eu:x(), y = eu:y(), radius = 120 },
                                                limit = 3,
                                                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                                            })
                                            if (#g2 > 0) then
                                                _slash(eu, dmg2 * 0.1 * c)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        options.scale = options.scale + 0.05
                    end
                })
            end
        end))