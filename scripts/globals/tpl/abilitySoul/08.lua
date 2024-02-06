TPL_ABILITY_SOUL[8] = AbilityTpl()
    :name("三板斧")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :coolDownAdv(30, -1)
    :mpCostAdv(0, 0)
    :icon("ability/CrossBackAxe")
    :description(
    function(obj)
        local lv = obj:level()
        local atk = 4 + lv * 0.5
        local dur = 5
        return {
            "在一次攻击后做好架势",
            "为" .. colour.hex(colour.gold, "后面3次") .. "攻击做好准备",
            "至后的每一次攻击都会基于上一次攻击",
            "造成攻击伤害时吸收" .. colour.hex(colour.indianred, atk .. '%') .. "到攻击力中",
            colour.hex(colour.skyblue, "效果最长持续：" .. dur .. "秒"),
        }
    end)
    :onUnitEvent(EVENT.Unit.Attack,
    function(attackData)
        if (false == event.has(attackData.triggerUnit, EVENT.Unit.Attack, "threeAxeAtk")) then
            local lv = attackData.triggerAbility:level()
            local atk = 4 + lv * 0.5
            attackData.triggerUnit:prop("threeAxeAtk", math.ceil(attackData.damage * atk * 0.01))
        end
        attackData.triggerAbility:effective()
    end)
    :onEvent(EVENT.Ability.Lose,
    function(loseData)
        loseData.triggerUnit:clear("threeAxeAtk")
        loseData.triggerUnit:clear("threeAxeCount")
        loseData.triggerUnit:onEvent(EVENT.Unit.Attack, "threeAxeAtk", nil)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local lv = effectiveData.triggerAbility:level()
        local atk = 4 + lv * 0.5
        local u = effectiveData.triggerUnit
        local dur = 5
        local setBuff = function(whichUnit, add, duration)
            local taa = (whichUnit:prop("threeAxeAtk") or 0) + add
            whichUnit:prop("threeAxeAtk", taa)
            whichUnit:buffClear({ key = "三板斧" })
            whichUnit
                :buff("三板斧")
                :name("三板斧")
                :icon("ability/CrossBackAxe")
                :description({ "攻击覆盖中", colour.hex(colour.indianred, "攻击：+" .. taa) })
                :duration(duration)
                :purpose(
                function(buffObj)
                    buffObj:attach("BloodLustTarget", "weapon")
                    buffObj:attack("+=" .. taa)
                end)
                :rollback(
                function(buffObj)
                    buffObj:detach("BloodLustTarget", "weapon")
                    buffObj:attack("-=" .. taa)
                end)
                :run()
        end
        setBuff(u, u:prop("threeAxeAtk") or 1, dur)
        u:prop("threeAxeCount", 0)
        u:onEvent(EVENT.Unit.Attack, "threeAxeAtk", function(attackData2)
            local u2 = attackData2.triggerUnit
            local count = u2:prop("threeAxeCount") or 0
            count = count + 1
            if (count > 3) then
                u2:onEvent(EVENT.Unit.Attack, "threeAxeAtk", nil)
                u2:clear("threeAxeCount")
                u:buffClear({ key = "三板斧" })
                return
            end
            u2:prop("threeAxeCount", count)
            setBuff(u2, math.ceil(attackData2.damage * atk * 0.01), dur)
        end)
    end)