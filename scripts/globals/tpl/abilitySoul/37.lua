TPL_ABILITY_SOUL[37] = AbilityTpl()
    :name("海皇龙卷")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/SuperIceStorm")
    :coolDownAdv(60, 1)
    :hpCostAdv(400, 20)
    :castChantAdv(4, 0)
    :castChantEffect("eff/CyclonExplosion")
    :castKeepAdv(10, 0)
    :castRadiusAdv(800, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local move = 250
        local dmg = 140 + lv * 60
        local dmg2 = 300 + lv * 150
        return {
            "在周边形成海潮领域，降低敌人移动",
            "并逐渐生成巨大的龙卷风，持续不断的袭卷敌人",
            "风场更有13%几率将海水龙卷起并冲击敌人",
            colour.hex(colour.indianred, "移动降低：" .. move),
            colour.hex(colour.indianred, "风卷伤害：" .. dmg),
            colour.hex(colour.indianred, "冲击伤害：" .. dmg2),
            colour.hex(colour.yellow, "在狂风天气中龙卷风袭伤害提升20%"),
            colour.hex(colour.yellow, "在雨天天气中水龙冲击伤害提升30%"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local move = 250
            local dmg = 140 + lv * 60
            local dmg2 = 300 + lv * 150
            return {
                "当即将被攻击时，有10%的几率",
                "在周边形成海潮领域，降低敌人移动",
                "并逐渐生成巨大的龙卷风，持续不断的袭卷敌人",
                "风场更有13%几率将海水龙卷起并冲击敌人",
                colour.hex(colour.indianred, "移动降低：" .. move),
                colour.hex(colour.indianred, "风卷伤害：" .. dmg),
                colour.hex(colour.indianred, "冲击伤害：" .. dmg2),
                colour.hex(colour.yellow, "在狂风天气中龙卷风袭伤害提升20%"),
                colour.hex(colour.yellow, "在狂风天气中海水龙卷伤害提升20%"),
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
        local move = 250
        local x, y = u:x(), u:y()
        local aura = AuraAttach()
            :radius(radius)
            :duration(10)
            :centerPosition({ x, y })
            :centerEffect("eff/WhirlPool", nil, radius / 530)
            :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner()))
        end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                eu:buff("海皇龙卷水漫")
                  :icon("ability/SuperIceStorm")
                  :description(colour.hex(colour.indianred, "移动：-" .. move))
                  :duration(-1)
                  :purpose(function(buffObj)
                    buffObj:attach("buff/WaterHands", "origin")
                    buffObj:move("-=" .. move)
                end)
                  :rollback(function(buffObj)
                    buffObj:detach("buff/WaterHands", "origin")
                    buffObj:move("+=" .. move)
                end)
                  :run()
            end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "海皇龙卷水漫" })
            end)
        local dmg = 140 + lv * 60
        local dmg2 = 300 + lv * 150
        if (Game():isWeather("wind")) then
            dmg = dmg * 1.2
        elseif (Game():isWeather("rain")) then
            dmg2 = dmg2 * 1.2
        end
        local radiusE = 50
        local e = Effect("eff/CycloneBigBang", x, y, nil, -1):speed(0.55):size(radiusE / 1536)
        local ti = 0
        time.setInterval(0.05, function(curTimer)
            ti = ti + 1
            if (ti >= 200 or u:isAbilityKeepCasting() == false) then
                destroy(curTimer)
                destroy(aura)
                return
            end
            if (radiusE < radius) then
                radiusE = radiusE + 12.5
                e:size(radiusE / 1536)
            end
            if (ti % 12 == 0) then
                local g = Group():catch(UnitClass, {
                    limit = 20,
                    circle = { x = x, y = y, radius = radiusE },
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit)
                    end
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        eu:attach("TornadoElementalSmall", "origin", 0.5)
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.wind,
                            damageTypeLevel = 0,
                            damage = dmg,
                        })
                        if (math.rand(1, 100) <= 13 and false == eu:buffHas("海皇龙卷水卷")) then
                            eu:effect("eff/TidalEruption", 2)
                            ability.crackFly({
                                name = "海皇龙卷水卷",
                                icon = "ability/SuperIceStorm",
                                description = "被水龙卷上天了",
                                sourceUnit = u,
                                targetUnit = eu,
                                effect = "buff/WaterHands",
                                attach = "head",
                                distance = 0,
                                height = math.rand(400, 600),
                                duration = 3,
                                onEnd = function(options)
                                    ability.damage({
                                        sourceUnit = options.sourceUnit,
                                        targetUnit = options.targetUnit,
                                        damage = dmg2,
                                        damageSrc = DAMAGE_SRC.ability,
                                        damageType = DAMAGE_TYPE.water,
                                        damageTypeLevel = 3,
                                    })
                                end
                            })
                        end
                    end
                end
            end
        end)
    end)