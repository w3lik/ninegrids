TPL_ABILITY_BOSS["觉醒至泠(人屠杀神)"] = {
    AbilityTpl()
        :name("血狱炮轰天地击")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/EntanglementAlong")
        :coolDownAdv(65, 0)
        :mpCostAdv(600, 0)
        :castChantAdv(4, 0)
        :castKeepAdv(9, 0)
        :description(
        function()
            local dmg = math.floor(650 + Game():GD().erode * 1)
            return {
                "喷射巨量血爆抨击敌人，造成轰击一段时间",
                "被击中的木飙移动速度会降低100点3秒",
                "方向上的木飙被击中会受到暗伤害",
                colour.hex(colour.indianred, "轰击伤害：" .. dmg),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 10) then
                hurtData.triggerAbility:effective({
                    targetUnit = hurtData.sourceUnit
                })
            end
        end)
        :onEvent(EVENT.Ability.Casting,
        function(castingData)
            local dmg = math.floor(650 + Game():GD().erode * 1)
            local radius = 200
            local u = castingData.triggerUnit
            local tu = castingData.targetUnit
            local x, y = u:x(), u:y()
            local tx, ty = tu:x(), tu:y()
            local angle = vector2.angle(x, y, tx, ty)
            u:facing(angle)
            local x2, y2 = vector2.polar(x, y, 100, angle)
            local g = {}
            local n = 12
            for i = 1, n do
                local x3, y3 = vector2.polar(x, y, i * radius, angle)
                alerter.square(x3, y3, radius, radius)
            end
            time.setTimeout(1, function()
                if (isDestroy(u) or u:isInterrupt() or u:isDead()) then
                    return
                end
                Effect("eff/SolarEclipseGun", x2, y2, japi.Z(x, y) + 150, 2):rotateZ(angle)
                for i = 1, n do
                    local x3, y3 = vector2.polar(x, y, i * radius, angle)
                    g[#g + 1] = Group():catch(UnitClass, {
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                        end,
                        circle = { x = x3, y = y3, radius = radius },
                        limit = 5,
                    })
                end
                if (#g > 0) then
                    for _, g2 in ipairs(g) do
                        if (#g2 > 0) then
                            for _, eu in ipairs(g2) do
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.dark,
                                    damageTypeLevel = 0,
                                    damage = dmg,
                                })
                                eu:buff("血狱炮轰天地击喷射")
                                  :icon("ability/EntanglementAlong")
                                  :description({ colour.hex(colour.indianred, "移动：-100"), })
                                  :duration(3)
                                  :purpose(function(buffObj) buffObj:move("-=100") end)
                                  :rollback(function(buffObj) buffObj:move("+=100") end)
                                  :run()
                            end
                        end
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("怒岚环风疾走浪")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/MonkEssencefont")
        :coolDownAdv(40, 0)
        :mpCostAdv(300, 0)
        :castChantAdv(2, 0)
        :description(
        function()
            local dmg = math.floor(200 + Game():GD().erode * 0.3)
            local odds = 15
            local radius = 150
            return {
                "旋击出一个飓风龙卷，绽裂山岚15秒",
                "龙卷环绕本体，对木飙持续造成风伤害",
                "并有一定的几率将木飙吹飞至半空",
                colour.hex(colour.violet, "飓风范围：" .. radius),
                colour.hex(colour.indianred, "飓风伤害：" .. dmg),
                colour.hex(colour.indianred, "吹飞几率：" .. odds .. '%'),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 10) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dmg = math.floor(200 + Game():GD().erode * 0.3)
            local odds = 15
            local radius = 150
            local angle = math.rand(0, 359)
            local x, y = vector2.polar(u:x(), u:y(), 350, angle)
            local z = 130
            local e = Effect("slash/WindmillDance", x, y, japi.Z(x, y) + z, -1)
            e:size(radius / 270)
            e:rotateZ(angle - 90)
            local ti = 0
            local frq = 0.03
            time.setInterval(frq, function(curTimer)
                ti = ti + frq
                if (ti >= 15 or isDestroy(u) or u:isDead()) then
                    destroy(curTimer)
                    destroy(e)
                    return
                end
                angle = (angle - 8)
                local x2, y2 = vector2.polar(u:x(), u:y(), 350, angle)
                e:position(x2, y2, japi.Z(x2, y2) + z)
                e:rotateZ(angle - 90)
                local g = Group():catch(UnitClass, {
                    filter = function(enumUnit)
                        return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                    end,
                    circle = { x = x2, y = y2, radius = radius },
                    limit = 3,
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.wind,
                            damageTypeLevel = 1,
                            damage = dmg,
                        })
                        if (math.rand(1, 100) <= odds) then
                            ability.crackFly({
                                sourceUnit = u,
                                targetUnit = eu,
                                effect = "slash/BlueShuttle",
                                attach = "Tornado_Target",
                                distance = 50,
                                height = 200,
                                duration = 0.5,
                            })
                        end
                    end
                end
            end)
        end),
    AbilityTpl()
        :name("幻肢痛悟映紫光")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/LightIsFirmButGentle")
        :coolDownAdv(10, 0)
        :description(
        function()
            local dmg = math.floor(250 + Game():GD().erode * 0.2)
            return {
                "缠出紫色剑光，攻击半径175的敌人",
                "剑光缠击为暗伤害，且无视防御",
                "被剑光攻击到的敌人受伤加深25%",
                colour.hex(colour.indianred, "缠击伤害：" .. dmg),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 30) then
                local source = hurtData.sourceUnit
                if (isClass(source, UnitClass)) then
                    local d = vector2.distance(hurtData.triggerUnit:x(), hurtData.triggerUnit:y(), source:x(), source:y())
                    if (d < 175) then
                        hurtData.triggerAbility:effective()
                    end
                end
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dmg = math.floor(250 + Game():GD().erode * 0.2)
            u:attach("slash/Culling_Slash_II_Purple", "origin", 2)
            local g = Group():catch(UnitClass, {
                filter = function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                end,
                circle = { x = u:x(), y = u:y(), radius = 175 },
                limit = 3,
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 1,
                        damage = dmg,
                        breakArmor = { BREAK_ARMOR.defend },
                    })
                    if (eu:buffHas("幻肢痛悟映紫光") == false) then
                        eu:buff("幻肢痛悟映紫光")
                          :signal(BUFF_SIGNAL.down)
                          :icon("ability/LightIsFirmButGentle")
                          :description({ colour.hex(colour.indianred, "伤害加深：+25%") })
                          :duration(5)
                          :purpose(function(buffObj) buffObj:hurtIncrease("+=25") end)
                          :rollback(function(buffObj) buffObj:hurtIncrease("-=25") end)
                          :run()
                    end
                end
            end
        end),
    AbilityTpl()
        :name("唤作混沌虚空遁")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Blackholeswallowed")
        :coolDownAdv(35, 0)
        :mpCostAdv(400, 0)
        :castChantAdv(2, 0)
        :castKeepAdv(10, 0)
        :description(
        function()
            return {
                "不间断地召唤半径280的混沌虚空",
                "进入虚空的敌人的属性将极速降低",
                colour.hex(colour.indianred, "移动降低：250"),
                colour.hex(colour.indianred, "攻速降低：50%"),
                colour.hex(colour.indianred, "HP恢复降低：150"),
                colour.hex(colour.skyblue, "持续时间：13秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 20) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Casting,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local radius = 280
            local x, y = vector2.polar(u:x(), u:y(), math.rand(250, 850), math.rand(0, 359))
            AuraAttach()
                :radius(radius)
                :duration(13)
                :centerPosition({ x, y, japi.Z(x, y) + 50 })
                :centerEffect("eff/VoidDisc", nil, 1)
                :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    eu:buff("唤作混沌虚空遁")
                      :icon("ability/Blackholeswallowed")
                      :description({
                        colour.hex(colour.indianred, "移动：-250"),
                        colour.hex(colour.indianred, "攻速：-50"),
                        colour.hex(colour.indianred, "HP恢复：-150"),
                    })
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attach("DeathandDecayTarget", "origin")
                        buffObj:move("-=250")
                        buffObj:attackSpeed("-=50")
                        buffObj:hpRegen("-=150")
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("DeathandDecayTarget", "origin")
                        buffObj:move("+=250")
                        buffObj:attackSpeed("+=50")
                        buffObj:hpRegen("+=150")
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    auraData.triggerUnit:buffClear({ key = "唤作混沌虚空遁" })
                end)
        end),
}