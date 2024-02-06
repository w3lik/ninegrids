TPL_ABILITY_SOUL[44] = AbilityTpl()
    :name("觉醒沼鸩")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/CreaturePoison06")
    :condition(
    function()
        return Game():achievement(4) == true
    end)
    :conditionTips("通过觉醒探秘区")
    :coolDownAdv(28, 0)
    :mpCostAdv(120, 5)
    :castDistanceAdv(500, 0)
    :castRadiusAdv(350, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local radius = obj:castRadius()
        local atk = 33 + lv * 12
        local hpRegen = 17 + lv * 4
        local mpRegen = 11 + lv * 3
        local dur = 10.1 + 0.4 * lv
        return {
            "在木飙位置冒起毒沼，侵蚀" .. colour.hex(colour.gold, radius) .. "半径范围",
            "敌人进入范围后会降低攻击及恢复",
            "并且在范围内身上会附着毒元素",
            colour.hex(colour.indianred, "攻击降低：" .. atk),
            colour.hex(colour.indianred, "HP恢复降低：" .. hpRegen),
            colour.hex(colour.indianred, "MP恢复降低：" .. mpRegen),
            colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            colour.hex(colour.yellow, "在毒雾天气里，持续时间增加50%"),
        }
    end)
    :pasConvBack(
    function(this)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil)
    end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local radius = obj:castRadius()
            local atk = 33 + lv * 12
            local hpRegen = 17 + lv * 4
            local mpRegen = 11 + lv * 3
            local dur = 10.1 + 0.4 * lv
            return {
                "当击中木飙后有20%的几率",
                "在木飙位置冒起毒沼，侵蚀" .. colour.hex(colour.gold, radius) .. "半径范围",
                "敌人进入范围后会降低攻击及恢复",
                "并且在范围内身上会附着毒元素",
                colour.hex(colour.indianred, "攻击降低：" .. atk),
                colour.hex(colour.indianred, "HP恢复降低：" .. hpRegen),
                colour.hex(colour.indianred, "MP恢复降低：" .. mpRegen),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
                colour.hex(colour.yellow, "在毒雾天气里，持续时间增加40%"),
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
        local atk = 33 + lv * 12
        local hpRegen = 17 + lv * 4
        local mpRegen = 11 + lv * 3
        local dur = 10.1 + 0.4 * lv
        if (Game():isWeather("fogPoison")) then
            dur = dur * 1.4
        end
        local x, y = effectiveData.targetX, effectiveData.targetY
        effector("eff/GreenLight", x, y, 0, 1)
        AuraAttach()
            :radius(radius)
            :duration(dur)
            :centerPosition({ x, y, 50 + effectiveData.targetZ })
            :centerEffect("aura/OakAura", nil, radius / 70)
            :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner()))
        end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                local de = {
                    colour.hex(colour.lightcyan, "附着毒"),
                    colour.hex(colour.indianred, "攻击：-" .. atk),
                    colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                    colour.hex(colour.indianred, "MP恢复：-" .. mpRegen),
                }
                eu:buff("觉醒沼鸩")
                  :icon("ability/CreaturePoison06")
                  :description(de)
                  :duration(-1)
                  :purpose(function(buffObj)
                    enchant.append(buffObj, DAMAGE_TYPE.poison, -1, u)
                    buffObj:attach("buff/PoisonHands", "origin")
                    buffObj:attack("-=" .. atk)
                    buffObj:hpRegen("-=" .. hpRegen)
                    buffObj:mpRegen("-=" .. mpRegen)
                end)
                  :rollback(function(buffObj)
                    enchant.subtract(buffObj, DAMAGE_TYPE.poison, -1, u)
                    buffObj:detach("buff/PoisonHands", "origin")
                    buffObj:attack("+=" .. atk)
                    buffObj:hpRegen("+=" .. hpRegen)
                    buffObj:mpRegen("+=" .. mpRegen)
                end)
                  :run()
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "觉醒沼鸩" })
            end)
    end)