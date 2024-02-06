TPL_SACRED[30] = ItemTpl()
    :name("电池炮")
    :icon("item/Battery02")
    :modelAlias("item/WeaponSemiMachineGun")
    :description("猫耳族科技产物新一代电池造物")
    :prop("forgeList",
    {
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 8 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 10 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 12 }, { "shield", 200 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 15 }, { "shield", 225 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 18 }, { "shield", 250 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 22 }, { "shield", 300 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 27 }, { "shield", 350 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 32 }, { "shield", 400 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 36 }, { "shield", 450 } },
        { { SYMBOL_E .. DAMAGE_TYPE.thunder.value, 40 }, { "shield", 475 } },
    })
    :ability(
    AbilityTpl()
        :name("电池炮")
        :icon("item/Battery02")
        :targetType(ABILITY_TARGET_TYPE.tag_square)
        :coolDownAdv(30, 0)
        :castChantAdv(2.5, -0.1)
        :castAnimation("stand channel,spell")
        :castChantEffect("buff/EnergyFocusBlue")
        :castKeepAdv(6, 0)
        :castWidthAdv(300, 20)
        :castHeightAdv(300, 20)
        :castDistanceAdv(1000, 0)
        :mpCostAdv(125, 15)
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :description(
        function(this)
            local lv = this:level()
            local limit = 3 + math.ceil(lv / 3)
            local dmg = 125 + 90 * lv
            return {
                colour.hex(colour.gold, "对范围内敌人持续发射6次最多" .. limit .. "发轰击"),
                colour.hex(colour.gold, "电池炮击每一发将造成" .. dmg .. "雷伤害"),
                colour.hex(colour.gold, "木飙每次发射最多只会受到2次打击"),
            }
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = effectiveData.targetX, effectiveData.targetY
            local w = effectiveData.triggerAbility:castWidth()
            local ti = 0
            time.setInterval(1.3, function(curTimer)
                ti = ti + 1
                if (ti >= 6 or u:isDead() or false == u:isAbilityKeepCasting()) then
                    destroy(curTimer)
                    return
                end
                curTimer:period(1)
                Effect("eff/ElectricSpark", x, y, 20, 0.5):size(0.6)
                Effect("eff/ElectricMouseGlow", x, y, 30, 3):size(w / 512)
            end)
        end)
        :onEvent(EVENT.Ability.Casting,
        function(castingData)
            local u = castingData.triggerUnit
            local ab = castingData.triggerAbility
            local lv = ab:level()
            local x, y, w, h = castingData.targetX, castingData.targetY, ab:castWidth(), ab:castHeight()
            local limit = 3 + math.ceil(lv / 3)
            local dmg = 125 + 90 * lv
            time.setTimeout(0.35, function()
                local g = Group():rand(UnitClass, {
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                    square = { x = x, y = y, width = w, height = h },
                }, limit)
                local remain = limit
                local _shot = function(target)
                    local opt = {
                        sourceUnit = u,
                        modelAlias = "missile/ElectricMouseMissileR",
                        scale = 0.16,
                        height = 400,
                        weaponHeight = 120,
                        weaponLength = 20,
                        shake = math.rand(-75, 75),
                        shakeOffset = 60,
                        speed = 1300,
                    }
                    if (isClass(target, UnitClass)) then
                        opt.targetUnit = target
                        opt.onEnd = function(options)
                            target:attach("eff/ElectricMouseTargetW", "origin", 1)
                            ability.damage({
                                sourceUnit = options.sourceUnit,
                                targetUnit = options.targetUnit,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.item,
                                damageType = DAMAGE_TYPE.thunder,
                                damageTypeLevel = 2,
                            })
                        end
                    elseif (type(target) == "table") then
                        opt.targetVec = target
                    else
                        return
                    end
                    ability.missile(opt)
                end
                if (type(g) == "table") then
                    local gl = #g
                    if (gl > 0) then
                        for i = 1, limit do
                            if (i <= gl) then
                                _shot(g[i])
                                remain = remain - 1
                            elseif (i <= 2 * gl) then
                                local j = i - gl
                                _shot(g[j])
                                remain = remain - 1
                            end
                        end
                    end
                end
                if (remain > 0) then
                    for _ = 1, remain do
                        local x2, y2 = vector2.polar(x, y, w / 2, math.rand(1, 359))
                        _shot({ x2, y2 })
                    end
                end
            end)
        end))