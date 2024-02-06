TPL_ABILITY_SOUL[40] = AbilityTpl()
    :name("砂尘莲葬")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/Sandstorm")
    :coolDownAdv(60, 0)
    :mpCostAdv(100, 30)
    :castKeepAdv(6, 0.2)
    :castRadiusAdv(600, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local steel = 30 + lv * 3
        local sight = 200 + lv * 20
        local d = math.trunc(0.5 + lv * 0.07, 2)
        local d2 = math.trunc(0.4 + lv * 0.05, 2)
        local dmg, dmg2
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            dmg = math.floor(bu:defend()) * d
            dmg2 = math.floor(bu:attack()) * d2
        else
            dmg = "防御 x " .. d
            dmg2 = "攻击 x " .. d2
        end
        return {
            "扬起岩石抵御，自身钢抗性显著增加",
            "在周边形成高速砂暴，降低敌人视野",
            "处于砂暴中的敌人会一直被砂石撞击造成岩伤",
            "撞击更有17%几率眩晕敌人0.1秒",
            "届时为敌人哀悼，绽放莲花造成范围光伤害",
            colour.hex(colour.lawngreen, "钢抗增加：" .. steel .. '%'),
            colour.hex(colour.indianred, "视野降低：" .. sight),
            colour.hex(colour.indianred, "砂石伤害：" .. dmg),
            colour.hex(colour.indianred, "莲花伤害：" .. dmg2),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local steel = 30 + lv * 3
            local sight = 200 + lv * 20
            local d = math.trunc(0.5 + lv * 0.07, 2)
            local d2 = math.trunc(0.4 + lv * 0.05, 2)
            local dmg, dmg2
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:defend()) * d
                dmg2 = math.floor(bu:attack()) * d2
            else
                dmg = "防御 x " .. d
                dmg2 = "攻击 x " .. d2
            end
            return {
                "当即将被攻击时，有10%的几率",
                "扬起岩石抵御，自身钢抗性显著增加",
                "在周边形成高速砂暴，降低敌人视野",
                "处于砂暴中的敌人会一直被砂石撞击造成岩伤",
                "撞击更有17%几率眩晕敌人0.1秒",
                "届时为敌人哀悼，绽放莲花造成范围光伤害",
                colour.hex(colour.lawngreen, "钢抗增加：" .. steel .. '%'),
                colour.hex(colour.indianred, "视野降低：" .. sight),
                colour.hex(colour.indianred, "砂石伤害：" .. dmg),
                colour.hex(colour.indianred, "莲花伤害：" .. dmg2),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), function()
            if (math.rand(1, 100) <= 10) then
                this:effective()
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local steel = 30 + lv * 3
        local sight = 200 + lv * 20
        local d = math.trunc(0.5 + lv * 0.07, 2)
        local d2 = math.trunc(0.4 + lv * 0.05, 2)
        local dmg = math.floor(u:defend()) * d
        local dmg2 = math.floor(u:attack()) * d2
        local x, y = u:x(), u:y()
        u:buff("砂尘莲葬岩盾")
         :icon("ability/Sandstorm")
         :description(colour.hex(colour.lawngreen, "钢抗：+" .. steel .. '%'))
         :duration(10)
         :purpose(function(buffObj)
            buffObj:attach("buff/StoneShield", "origin")
            buffObj:enchantResistance(DAMAGE_TYPE.steel, "+=" .. steel)
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/StoneShield", "origin")
            buffObj:enchantResistance(DAMAGE_TYPE.steel, "-=" .. steel)
        end)
         :run()
        local aura = AuraAttach()
            :radius(radius)
            :duration(10)
            :centerPosition({ x, y })
            :centerEffect("eff/SandAura", nil, radius / 76.8)
            :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner()))
        end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                eu:buff("砂尘莲葬风沙")
                  :icon("ability/Sandstorm")
                  :description(colour.hex(colour.indianred, "视野：-" .. sight))
                  :duration(-1)
                  :purpose(function(buffObj)
                    buffObj:sight("-=" .. sight)
                end)
                  :rollback(function(buffObj)
                    buffObj:sight("+=" .. sight)
                end)
                  :run()
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "砂尘莲葬风沙" })
            end)
        local ti = 0
        local frq = 0.4
        time.setInterval(frq, function(curTimer)
            ti = ti + frq
            if (ti >= 10 or u:isAbilityKeepCasting() == false) then
                destroy(curTimer)
                destroy(aura)
                u:buffClear({ key = "砂尘莲葬岩盾" })
                return
            end
            local g = Group():catch(UnitClass, {
                limit = 30,
                circle = { x = x, y = y, radius = radius },
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    effector("eff/SandTrap", eu:x(), eu:y(), nil, 2)
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.rock,
                        damageTypeLevel = 1,
                        damage = dmg,
                    })
                    if (math.rand(1, 100) <= 17 and false == eu:buffHas("砂尘迷惑")) then
                        ability.stun({
                            name = "砂尘迷惑",
                            icon = "ability/Sandstorm",
                            description = "被砂尘撞晕了",
                            sourceUnit = u,
                            targetUnit = eu,
                            effect = "StasisTotemTarget",
                            duration = 0.1
                        })
                        effector("eff/LotusLight", eu:x(), eu:y(), nil, 2)
                        local g2 = Group():catch(UnitClass, {
                            limit = 10,
                            circle = { x = x, y = y, radius = 300 },
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit)
                            end
                        })
                        if (#g2 > 0) then
                            for _, eu2 in ipairs(g) do
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu2,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.light,
                                    damageTypeLevel = 3,
                                    damage = dmg2,
                                })
                            end
                        end
                    end
                end
            end
        end)
    end)