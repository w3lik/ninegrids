TPL_ABILITY_SOUL[34] = AbilityTpl()
    :name("离子湍流")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/BreakMine")
    :coolDownAdv(30, 0)
    :mpCostAdv(110, 7)
    :castDistanceAdv(450, 0)
    :castRadiusAdv(325, 5)
    :description(
    function(obj)
        local lv = obj:level()
        local def = 21 + lv * 6
        local thunder = 10 + 5 * lv
        local dur = 15
        return {
            "在木飙位置生成电场，刺激附近场地",
            "敌人进入范围后会急剧降低防御及雷抗性",
            "并且在范围内身上会附着雷元素",
            colour.hex(colour.indianred, "防御降低：" .. def),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            colour.hex(colour.indianred, "雷抗性降低：" .. thunder .. '%'),
            colour.hex(colour.yellow, "在雨天天气下，持续时间增加5秒"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local def = 21 + lv * 6
            local thunder = 10 + 5 * lv
            local dur = 15
            return {
                "当击中木飙后有15%的几率",
                "在该位置生成电场，刺激附近场地",
                "敌人进入范围后会急剧降低防御及雷抗性",
                "并且在范围内身上会附着雷元素",
                colour.hex(colour.indianred, "防御降低：" .. def),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
                colour.hex(colour.indianred, "雷抗性降低：" .. thunder .. '%'),
                colour.hex(colour.yellow, "在雨天天气下，持续时间增加5秒"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 100) <= 15) then
                this:effective({
                    targetX = attackData.targetUnit:x(),
                    targetY = attackData.targetUnit:y(),
                    targetZ = attackData.targetUnit:z(),
                })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local def = 21 + lv * 6
        local thunder = 10 + 5 * lv
        local dur = 15
        if (Game():isWeather("rain")) then
            dur = dur + 5
        end
        local x, y = effectiveData.targetX, effectiveData.targetY
        AuraAttach()
            :radius(radius)
            :duration(dur)
            :centerPosition({ x, y, 50 + effectiveData.targetZ })
            :centerEffect("eff/SMagicLightningAura", nil, radius / 120)
            :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                eu:buff("离子湍流")
                  :icon("ability/BreakMine")
                  :description(
                    {
                        colour.hex(colour.lightyellow, "附着雷"),
                        colour.hex(colour.indianred, "防御：-" .. def),
                        colour.hex(colour.indianred, "雷抗性：-" .. thunder .. '%'),
                    })
                  :duration(-1)
                  :purpose(function(buffObj)
                    enchant.append(buffObj, DAMAGE_TYPE.thunder, -1, u)
                    buffObj:attach("buff/LightningBlueFire", "origin")
                    buffObj:defend("-=" .. def)
                    buffObj:enchantResistance(DAMAGE_TYPE.thunder, "-=" .. thunder)
                end)
                  :rollback(function(buffObj)
                    enchant.subtract(buffObj, DAMAGE_TYPE.thunder, -1, u)
                    buffObj:detach("buff/LightningBlueFire", "origin")
                    buffObj:defend("+=" .. def)
                    buffObj:enchantResistance(DAMAGE_TYPE.thunder, "+=" .. thunder)
                end)
                  :run()
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "离子湍流" })
            end)
    end)