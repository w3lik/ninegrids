TPL_ABILITY_SOUL[14] = AbilityTpl()
    :name("纠缠藤蔓")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/ForestFury")
    :coolDownAdv(28, 0)
    :mpCostAdv(100, 10)
    :castDistanceAdv(300, 0)
    :castRadiusAdv(285, 15)
    :description(
    function(obj)
        local lv = obj:level()
        local move = 40 + lv * 10
        local grass = 12 + 3 * lv
        local dur = 10
        return {
            "在木飙位置种下藤蔓，影响附近场地",
            "敌人进入范围后会急剧降低移动和草抗性",
            "并且在范围内身上会附着草元素",
            colour.hex(colour.indianred, "移动：-" .. move),
            colour.hex(colour.indianred, "草抗性：-" .. grass .. '%'),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local move = 40 + lv * 10
            local grass = 12 + 3 * lv
            local dur = 10
            return {
                "当近距离击中木飙后，",
                "在该位置种下藤蔓，影响附近场地",
                "敌人进入范围后会急剧降低移动和草抗性",
                "并且在范围内身上会附着草元素",
                colour.hex(colour.indianred, "移动：-" .. move),
                colour.hex(colour.indianred, "草抗性：-" .. grass .. '%'),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            local x, y, z = attackData.targetUnit:x(), attackData.targetUnit:y(), attackData.targetUnit:z()
            local d = vector2.distance(attackData.triggerUnit:x(), attackData.triggerUnit:y(), x, y)
            if (d < 250) then
                this:effective({
                    targetX = x,
                    targetY = y,
                    targetZ = z,
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
        local move = 40 + lv * 10
        local grass = 12 + 3 * lv
        local dur = 10
        local x, y = effectiveData.targetX, effectiveData.targetY
        Effect("eff/VinesGoRoundRound", x, y, 0, 1):size(radius / 800)
        AuraAttach()
            :radius(radius)
            :duration(dur)
            :centerPosition({ x, y, 50 + effectiveData.targetZ })
            :centerEffect("aura/ForestblessingForm1", nil, radius / 100)
            :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                local de = {
                    colour.hex(colour.indianred, "移动：-" .. move),
                    colour.hex(colour.indianred, "草抗性：-" .. grass .. '%'),
                }
                eu:buff("纠缠藤蔓")
                  :icon("ability/ForestFury")
                  :description(de)
                  :duration(-1)
                  :purpose(function(buffObj)
                    enchant.append(buffObj, DAMAGE_TYPE.grass, -1, u)
                    buffObj:attach("EntanglingRootsTarget", "origin")
                    buffObj:move("-=" .. move)
                    buffObj:enchantResistance(DAMAGE_TYPE.grass, "-=" .. grass)
                end)
                  :rollback(function(buffObj)
                    enchant.subtract(buffObj, DAMAGE_TYPE.grass, -1, u)
                    buffObj:detach("EntanglingRootsTarget", "origin")
                    buffObj:move("+=" .. move)
                    buffObj:enchantResistance(DAMAGE_TYPE.grass, "+=" .. grass)
                end)
                  :run()
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "纠缠藤蔓" })
            end)
    end)