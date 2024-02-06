TPL_ABILITY_SOUL[18] = AbilityTpl()
    :name("渐进毒药")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/Quadruplevenom")
    :description(
    function(obj)
        local lv = obj:level()
        local poison = lv * 1
        local dmg = 67 + lv * 24
        return {
            "当攻击木飙时有30%几率额外附着渐进叠层",
            "当叠层存在时，可降低毒抗性，最多持续5秒",
            "当叠层大于3时，产生毒性聚爆",
            "毒爆会打击木飙附近150半径范围的敌人",
            colour.hex(colour.indianred, "每层毒抗降低：" .. poison .. "%"),
            colour.hex(colour.indianred, "聚爆伤害：" .. dmg),
            colour.hex(colour.yellow, "在毒雾天气里，毒爆伤害提升75%"),
        }
    end)
    :onUnitEvent(EVENT.Unit.Attack,
    function(attackData)
        local u = attackData.triggerUnit
        local tu = attackData.targetUnit
        local tx, ty = tu:x(), tu:y()
        local ab = attackData.triggerAbility
        local lv = ab:level()
        local n = 0
        local b = tu:buffOne("渐进毒药")
        if (b) then
            n = b:prop("layer") or n
        end
        if (math.rand(1, 100) <= 30) then
            n = n + 1
        end
        if (n >= 1) then
            tu:buffClear({ key = "渐进毒药" })
            local dur = 5
            local poison = lv * 1 * n
            tu:buff("渐进毒药")
              :signal(BUFF_SIGNAL.down)
              :icon("ability/Quadruplevenom")
              :description({ colour.hex(colour.indianred, "毒抗性：-" .. poison .. '%') })
              :prop("layer", n)
              :text(colour.hex(colour.red, n))
              :duration(dur)
              :purpose(function(buffObj)
                buffObj:attach("buff/HydraCorrosiveGroundEffectV054", "origin")
                buffObj:attach("buff/PoisonHands", "chest")
                buffObj:enchantResistance(DAMAGE_TYPE.poison, "-=" .. poison)
            end)
              :rollback(function(buffObj)
                buffObj:detach("buff/HydraCorrosiveGroundEffectV054", "origin")
                buffObj:detach("buff/PoisonHands", "chest")
                buffObj:enchantResistance(DAMAGE_TYPE.poison, "+=" .. poison)
            end)
              :run()
        end
        if (n > 3) then
            local dmg = 67 + lv * 24
            if (Game():isWeather("fogPoison")) then
                dmg = dmg * 1.75
            end
            time.setTimeout(0.15, function()
                effector("eff/PillarOfFlameGreen", tx, ty, 20, 1.2)
                local g = Group():catch(UnitClass, {
                    limit = 4,
                    circle = { x = tx, y = ty, radius = 150 },
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit)
                    end
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.poison,
                            damageTypeLevel = 0,
                        })
                    end
                end
            end)
        end
    end)