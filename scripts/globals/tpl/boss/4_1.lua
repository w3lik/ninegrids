TPL_ABILITY_BOSS["剑泠(黑月)"] = {
    AbilityTpl()
        :name("幽月")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/TalentspecDruidBalance")
        :coolDownAdv(60, 0)
        :mpCostAdv(235, 0)
        :castRadiusAdv(180, 0)
        :description(
        function()
            local erode = Game():GD().erode
            local attack = math.floor(50 + erode * 0.05)
            local defend = math.floor(30 + erode * 0.02)
            local dark = 30
            local dur = 15
            return {
                "与月共舞，天气会后续变为幽月",
                "还会在身边形成月至暗域，进入领域的敌人",
                "攻击、防御及暗抗性都会降低",
                colour.hex(colour.indianred, "攻击：-" .. attack),
                colour.hex(colour.indianred, "防御：-" .. defend),
                colour.hex(colour.indianred, "水抗性：-" .. dark .. '%'),
                colour.hex(colour.skyblue, "领域持续时间：" .. dur .. "秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 30) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local attack = math.floor(50 + erode * 0.05)
            local defend = math.floor(30 + erode * 0.02)
            local dark = 30
            local dur = 15
            u:attach("StarFallCaster", "origin", 2)
            Game():weather(3)
            AuraAttach()
                :radius(radius)
                :duration(dur)
                :centerUnit(u)
                :centerEffect("aura/Voidwalker", "origin", 1)
                :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    local de = {
                        colour.hex(colour.indianred, "攻击：-" .. attack),
                        colour.hex(colour.indianred, "防御：-" .. defend),
                        colour.hex(colour.indianred, "暗抗性：-" .. dark .. '%'),
                    }
                    eu:buff("幽月")
                      :icon("ability/TalentspecDruidBalance")
                      :description(de)
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attach("buff/NetherInferno", "origin")
                        buffObj:attack("-=" .. attack)
                        buffObj:defend("-=" .. defend)
                        buffObj:enchantResistance(DAMAGE_TYPE.dark, "-=" .. dark)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/NetherInferno", "origin")
                        buffObj:attack("+=" .. attack)
                        buffObj:defend("+=" .. defend)
                        buffObj:enchantResistance(DAMAGE_TYPE.dark, "+=" .. dark)
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    auraData.triggerUnit:buffClear({ key = "幽月" })
                end)
        end),
    AbilityTpl()
        :name("真空")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/SpellMageSupernova")
        :coolDownAdv(25, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(300, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(300 + erode * 1.3)
            return {
                "于中心形成真空圈，将附近的木飙向里牵引0.5秒",
                "并造成" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 30) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local x, y = u:x(), u:y()
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(300 + erode * 1.3)
            u:attach("eff/GravityStorm", "origin", 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 5,
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
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 0
                    })
                end
            end
            local ti = 0
            local frq = 0.03
            time.setInterval(frq, function(curTimer)
                ti = ti + frq
                if (ti >= 0.5) then
                    destroy(curTimer)
                    return
                end
                x, y = u:x(), u:y()
                local g2 = Group():catch(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    limit = 5,
                    filter = function(enumUnit)
                        return ab:isCastTarget(enumUnit)
                    end
                })
                if (#g2 > 0) then
                    for _, eu in ipairs(g2) do
                        local ex, ey = eu:x(), eu:y()
                        local tx, ty
                        if (vector2.distance(ex, ey, x, y) > 50) then
                            tx, ty = vector2.polar(ex, ey, 10, vector2.angle(ex, ey, x, y))
                        else
                            tx, ty = ex, ey
                        end
                        eu:position(tx, ty)
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("强压")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/SpellMageNethertempest")
        :coolDownAdv(26, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(300, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(300 + erode * 1.3)
            return {
                "于中心形成强压圈，将附近的木飙向外压飞0.5秒",
                "并造成" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 20) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local x, y = u:x(), u:y()
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(300 + erode * 1.3)
            u:attach("eff/CallOfAggression", "origin", 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 5,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.crackFly({
                        name = "强压击飞",
                        icon = "ability/SpellMageNethertempest",
                        description = "被强压压上天了",
                        sourceUnit = u,
                        targetUnit = eu,
                        effect = "AvengerMissile",
                        attach = "origin",
                        distance = 300,
                        height = 150,
                        duration = 0.5,
                        onEnd = function(options)
                            ability.damage({
                                sourceUnit = options.sourceUnit,
                                targetUnit = options.targetUnit,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.dark,
                                damageTypeLevel = 0
                            })
                        end
                    })
                end
            end
        end),
    AbilityTpl()
        :name("坠下")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/ShadowShadowfury")
        :coolDownAdv(75, 0)
        :mpCostAdv(275, 0)
        :castRadiusAdv(500, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(550 + Game():GD().erode * 2)
            local defend = 66
            return {
                "以月至名，降下",
                "击中木飙将每次受到" .. colour.hex(colour.indianred, dmg) .. "毒伤害",
                "而且在3秒内防御减少" .. colour.hex(colour.indianred, defend) .. "点",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 35) then
                atkData.triggerAbility:effective({
                    targetX = atkData.targetUnit:x(),
                    targetY = atkData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = effectiveData.targetX, effectiveData.targetY
            local times = 33
            local dmg = math.floor(550 + Game():GD().erode * 2)
            local z = 800
            effector("eff/Moon", x, y, nil, 1)
            local e = Effect("eff/BlackHolePurpleshift", x, y, z, -1):size(4)
            local ti = 0
            time.setInterval(0.15, function(curTimer)
                ti = ti + 1
                if (ti > times) then
                    destroy(curTimer)
                    destroy(e)
                    return
                end
                z = z - 18
                japi.EXSetEffectZ(e:handle(), z)
                if (ti % 6 == 0) then
                    effector("eff/DarkNova", x, y, nil, 0.5)
                    local g = Group():catch(UnitClass, {
                        circle = { x = x, y = y, radius = radius },
                        limit = 10,
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end
                    })
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            eu:attach("DeathandDecayDamage", "origin", 0.5)
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.dark,
                                damageTypeLevel = 0,
                            })
                        end
                    end
                end
            end)
        end),
}