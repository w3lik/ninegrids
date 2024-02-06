TPL_ABILITY_SOUL[17] = AbilityTpl()
    :name("寒冻漩涡")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/Frostvortex")
    :coolDownAdv(20, 0)
    :mpCostAdv(90, 5)
    :castDistanceAdv(600, 0)
    :castRadiusAdv(300, 25)
    :description(
    function(obj)
        local lv = obj:level()
        local move = 72 + lv * 8
        local atkSpd = 37 + lv * 3
        local ice = 14 + 3 * lv
        local dur = 9.2 + 0.3 * lv
        return {
            "在木飙位置扬起风暴，寒冻附近场地",
            "敌人进入范围后会急剧降低移速攻速",
            "并且在范围内身上会附着冰元素",
            colour.hex(colour.indianred, "移动降低：" .. move),
            colour.hex(colour.indianred, "攻速降低：" .. atkSpd .. '%'),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            colour.hex(colour.yellow, "在雪天天气下，更会降低冰抗性"),
            colour.hex(colour.indianred, "冰抗性降低：" .. ice .. '%'),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local move = 72 + lv * 8
            local atkSpd = 37 + lv * 3
            local ice = 14 + 3 * lv
            local dur = 9.2 + 0.3 * lv
            return {
                "当击中木飙后有20%的几率",
                "在该位置扬起风暴，寒冻附近场地",
                "敌人进入范围后会急剧降低移速攻速",
                "并且在范围内身上会附着冰元素",
                colour.hex(colour.indianred, "移动降低：" .. move),
                colour.hex(colour.indianred, "攻速降低：" .. atkSpd .. '%'),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
                colour.hex(colour.yellow, "在雪天天气下，更会降低冰抗性"),
                colour.hex(colour.indianred, "冰抗性降低：" .. ice .. '%'),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 10) <= 2) then
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
        local move = 72 + lv * 8
        local atkSpd = 37 + lv * 3
        local ice = 14 + 3 * lv
        local dur = 8
        local x, y = effectiveData.targetX, effectiveData.targetY
        Effect("eff/Ringing", x, y, 0, 1):size(radius / 700)
        AuraAttach()
            :radius(radius)
            :duration(dur)
            :centerPosition({ x, y, 50 + effectiveData.targetZ })
            :centerEffect("aura/RemorselessWinter", nil, radius / 350)
            :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                local de = {
                    colour.hex(colour.lightcyan, "附着冰"),
                    colour.hex(colour.indianred, "移动：-" .. move),
                    colour.hex(colour.indianred, "攻速：-" .. atkSpd .. '%'),
                }
                if (Game():isWeather("snow")) then
                    table.insert(de, colour.hex(colour.indianred, "冰抗性：-" .. ice .. '%'))
                    eu:buff("寒冻漩涡")
                      :icon("ability/Frostvortex")
                      :description(de)
                      :duration(-1)
                      :purpose(function(buffObj)
                        enchant.append(buffObj, DAMAGE_TYPE.ice, -1, u)
                        buffObj:attach("buff/Icing", "origin")
                        buffObj:attach("buff/Cold", "chest")
                        buffObj:move("-=" .. move)
                        buffObj:attackSpeed("-=" .. atkSpd)
                        buffObj:enchantResistance(DAMAGE_TYPE.ice, "-=" .. ice)
                    end)
                      :rollback(function(buffObj)
                        enchant.subtract(buffObj, DAMAGE_TYPE.ice, -1, u)
                        buffObj:detach("buff/Icing", "origin")
                        buffObj:detach("buff/Cold", "chest")
                        buffObj:move("+=" .. move)
                        buffObj:attackSpeed("+=" .. atkSpd)
                        buffObj:enchantResistance(DAMAGE_TYPE.ice, "+=" .. ice)
                    end)
                      :run()
                else
                    eu:buff("寒冻漩涡")
                      :icon("ability/Frostvortex")
                      :description(de)
                      :duration(-1)
                      :purpose(function(buffObj)
                        enchant.append(buffObj, DAMAGE_TYPE.ice, -1)
                        buffObj:attach("buff/Icing", "origin")
                        buffObj:move("-=" .. move)
                        buffObj:attackSpeed("-=" .. atkSpd)
                    end)
                      :rollback(function(buffObj)
                        enchant.subtract(buffObj, DAMAGE_TYPE.ice, -1)
                        buffObj:detach("buff/Icing", "origin")
                        buffObj:move("+=" .. move)
                        buffObj:attackSpeed("+=" .. atkSpd)
                    end)
                      :run()
                end
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "寒冻漩涡" })
            end)
    end)