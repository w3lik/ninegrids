TPL_ABILITY_BOSS["焰泠(鬼火灵)"] = {
    AbilityTpl()
        :name("冰与火")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Iceofhell")
        :description({ "鬼火处于不稳定的状态", "冰火的能力十分混乱" })
        :attributes(
        {
            { SYMBOL_E .. DAMAGE_TYPE.ice.value, 15, 0 },
            { SYMBOL_E .. DAMAGE_TYPE.fire.value, 15, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.ice.value, -15, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, -15, 0 },
        }),
    AbilityTpl()
        :name("反物质")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("unit/FrozenSpirit")
        :coolDownAdv(100, 0)
        :mpCostAdv(300, 10)
        :castChantAdv(1, 0)
        :castChantEffect("eff/IceSlam")
        :description(
        function(_)
            return {
                "由火焰转变为寒冰30秒",
                "攻击模式转变为冰封至球",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 10) <= 5) then
                attackData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local icon = u:icon()
            local modelAlias = u:modelAlias()
            u:buff("反物质")
             :icon("unit/FrozenSpirit")
             :description({ colour.hex(colour.gold, "火变成冰了") })
             :duration(30)
             :purpose(function(buffObj)
                buffObj:icon("unit/FrozenSpirit")
                buffObj:modelAlias("hero/IceCrownOverlord")
                buffObj:attackModePush(AttackModeStatic("寒冰形态" .. buffObj:id())
                    :mode("missile"):homing(true)
                    :missileModel("FrostWyrmMissile")
                    :damageType(DAMAGE_TYPE.ice)
                    :speed(800):height(0))
            end)
             :rollback(function(buffObj)
                buffObj:icon(icon)
                buffObj:modelAlias(modelAlias)
                buffObj:attackModeRemove(AttackModeStatic("寒冰形态" .. buffObj:id()):id())
            end)
             :run()
        end),
    AbilityTpl()
        :name("熔岩炎陨")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ComingDownFireStone")
        :coolDownAdv(60, 0)
        :mpCostAdv(300, 0)
        :castChantAdv(2, 0)
        :castKeepAdv(10, 0)
        :castRadiusAdv(700, 0)
        :description(
        function()
            local gd = Game():GD()
            local dmg = math.floor(500 + gd.erode * 3)
            local hpRegen = 55
            local mpRegen = 30
            return {
                "大面积的湖烧环境形成，在附近陨落熔岩，",
                "熔岩随机产生火球砸下造成冰伤害",
                "被砸中的木飙会HP、MP恢复都会下降大大降低2秒",
                colour.hex(colour.indianred, "火球伤害：" .. dmg),
                colour.hex(colour.indianred, "HP恢复减少：" .. hpRegen),
                colour.hex(colour.indianred, "MP恢复减少：" .. mpRegen),
                colour.hex(colour.yellow, "在火焰形态伤害增加50%")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 15) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local gd = Game():GD()
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local dmg = math.floor(500 + gd.erode * 3)
            if (false == u:buffHas("反物质")) then
                dmg = dmg * 1.5
            end
            local hpRegen = 55
            local mpRegen = 30
            local x, y = u:x(), u:y()
            local ti = 0
            local frq = 0.5
            local e = Effect("aura/FlameSwamp", x, y, nil, -1):size(radius / 640)
            time.setInterval(frq, function(curTimer)
                ti = ti + frq
                if (ti >= 20 or u:isAbilityKeepCasting() == false) then
                    destroy(curTimer)
                    destroy(e)
                    return
                end
                for _ = 1, 5 do
                    local tx, ty = vector2.polar(x, y, math.rand(0, radius), math.rand(0, 359))
                    alerter.circle(tx, ty, 200)
                    effector("eff/RainOfFire2", tx, ty, 0, 0.9)
                    time.setTimeout(1.0, function()
                        local g = Group():catch(UnitClass, {
                            circle = { x = tx, y = ty, radius = 200 },
                            filter = function(enumUnit)
                                return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                            end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                effector("eff/Explosion2", eu:x(), eu:y(), nil, 0.5)
                                ability.damage({
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.fire,
                                    damageTypeLevel = 1
                                })
                                eu:buff("熔岩炎陨")
                                  :icon("ability/ComingDownFireStone")
                                  :description({
                                    colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                                    colour.hex(colour.indianred, "MP恢复：-" .. mpRegen)
                                })
                                  :duration(2)
                                  :purpose(function(buffObj)
                                    buffObj:hpRegen("-=" .. hpRegen)
                                    buffObj:mpRegen("-=" .. mpRegen)
                                end)
                                  :rollback(function(buffObj)
                                    buffObj:hpRegen("+=" .. hpRegen)
                                    buffObj:mpRegen("+=" .. mpRegen)
                                end)
                                  :run()
                            end
                        end
                    end)
                end
            end)
        end),
    AbilityTpl()
        :name("寒霜冰陨")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ComingDownIceStone")
        :coolDownAdv(60, 0)
        :mpCostAdv(300, 0)
        :castChantAdv(2, 0)
        :castKeepAdv(10, 0)
        :castRadiusAdv(700, 0)
        :description(
        function()
            local gd = Game():GD()
            local dmg = math.floor(500 + gd.erode * 3)
            local move = 100
            local atkSpd = 25
            return {
                "大面积的冰雪形成，在附近陨落寒霜，",
                "寒霜随机产生冰雹砸下造成冰伤害",
                "被砸中的木飙会移动攻速大大降低2秒",
                colour.hex(colour.indianred, "冰雹伤害：" .. dmg),
                colour.hex(colour.indianred, "移动减慢：" .. move),
                colour.hex(colour.indianred, "攻速减慢：" .. atkSpd .. '%'),
                colour.hex(colour.yellow, "在寒冰形态伤害增加50%")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 15) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local gd = Game():GD()
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local dmg = math.floor(500 + gd.erode * 3)
            if (true == u:buffHas("反物质")) then
                dmg = dmg * 1.5
            end
            local move = 100
            local atkSpd = 25
            local x, y = u:x(), u:y()
            local ti = 0
            local frq = 0.5
            local e = Effect("eff/SleetStorm", x, y, nil, -1):size(radius / 160)
            time.setInterval(frq, function(curTimer)
                ti = ti + frq
                if (ti >= 20 or u:isAbilityKeepCasting() == false) then
                    destroy(curTimer)
                    destroy(e)
                    return
                end
                for _ = 1, 5 do
                    local tx, ty = vector2.polar(x, y, math.rand(0, radius), math.rand(0, 359))
                    alerter.circle(tx, ty, 200)
                    effector("eff/Blizzard2", tx, ty, 0, 0.9)
                    time.setTimeout(1.0, function()
                        local g = Group():catch(UnitClass, {
                            circle = { x = tx, y = ty, radius = 200 },
                            filter = function(enumUnit)
                                return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                            end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                effector("eff/Ringing", eu:x(), eu:y(), nil, 1)
                                ability.damage({
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.ice,
                                    damageTypeLevel = 1
                                })
                                eu:buff("寒霜冰陨")
                                  :icon("ability/ComingDownIceStone")
                                  :description({
                                    colour.hex(colour.indianred, "攻速：-" .. atkSpd .. "%"),
                                    colour.hex(colour.indianred, "移动：-" .. move)
                                })
                                  :duration(2)
                                  :purpose(function(buffObj)
                                    buffObj:attackSpeed("-=" .. atkSpd)
                                    buffObj:move("-=" .. move)
                                end)
                                  :rollback(function(buffObj)
                                    buffObj:attackSpeed("+=" .. atkSpd)
                                    buffObj:move("+=" .. move)
                                end)
                                  :run()
                            end
                        end
                    end)
                end
            end)
        end),
}