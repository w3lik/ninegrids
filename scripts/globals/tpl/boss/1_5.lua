TPL_ABILITY_BOSS["初生至泠(雷霆战鬼)"] = {
    AbilityTpl()
        :name("斧刃旋抡")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/TopSpinFlameKnife")
        :coolDownAdv(40, 0)
        :mpCostAdv(200, 0)
        :castRadiusAdv(260, 0)
        :description(
        function(obj)
            local dmg = math.floor(150 + Game():GD().erode * 0.3)
            local u = obj:bindUnit()
            local radius = obj:castRadius()
            if (isClass(u, UnitClass)) then
                local d = u:hpCur() / u:hp()
                if (d > 0) then
                    d = dmg / d
                    dmg = math.min(dmg * 4, d)
                end
            end
            dmg = math.round(dmg)
            return {
                "抡起大斧挥砍敌人，对半径" .. colour.hex(colour.gold, radius) .. "的敌人造成钢伤害",
                "战鬼生命越低则伤害越高，最大提升为4倍伤害",
                colour.hex(colour.indianred, "挥砍伤害：" .. dmg),
                colour.hex(colour.indianred, "持续时间：10秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 25) then
                atkData.triggerAbility:effective({
                    targetX = atkData.triggerUnit:x(),
                    targetY = atkData.triggerUnit:y(),
                    targetZ = atkData.triggerUnit:z(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local radius = effectiveData.triggerAbility:castRadius()
            local dmg = math.floor(150 + Game():GD().erode * 0.3)
            local d = u:hpCur() / u:hp()
            if (d > 0) then
                d = dmg / d
                dmg = math.min(dmg * 4, d)
            end
            dmg = math.round(dmg)
            ability.whirlwind({
                sourceUnit = u,
                radius = radius,
                frequency = 0.3,
                duration = 10,
                enumModel = "slash/Ephemeral_Cut_Orange",
                damage = dmg,
                damageSrc = DAMAGE_SRC.ability,
                damageType = DAMAGE_TYPE.steel,
                damageTypeLevel = 0,
            })
        end),
    AbilityTpl()
        :name("雷霆震")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/NatureUnrelentingStorm")
        :coolDownAdv(15, 0)
        :mpCostAdv(300, 0)
        :castRadiusAdv(400, 0)
        :castDistanceAdv(1000, 0)
        :description(
        function(obj)
            local dmg = math.floor(550 + Game():GD().erode * 0.7)
            local u = obj:bindUnit()
            if (isClass(u, UnitClass)) then
                local d = u:hpCur() / u:hp()
                if (d > 0) then
                    d = dmg / d
                    dmg = math.min(dmg * 4, d)
                end
            end
            dmg = math.round(dmg)
            local stun = 6
            return {
                "跳跃震击地面造成" .. colour.hex(colour.indianred, dmg) .. "雷伤害",
                "战鬼震击后自身会进入眩晕状态 3 秒",
                colour.hex(colour.violet, "但也会眩晕木飙" .. stun .. "秒"),
                "战鬼生命越低则伤害越高，最大提升为4倍伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 35 and nil ~= hurtData.sourceUnit) then
                hurtData.triggerAbility:effective({ targetX = hurtData.sourceUnit:x(), targetY = hurtData.sourceUnit:y() })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = effectiveData.targetX, effectiveData.targetY
            local dmg = math.floor(550 + Game():GD().erode * 0.7)
            local d = u:hpCur() / u:hp()
            if (d > 0) then
                d = dmg / d
                dmg = math.min(dmg * 4, d)
            end
            dmg = math.round(dmg)
            local stun = 6
            ability.leap({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "buff/LightningBlueFire",
                speed = 1000,
                height = 400,
                onEnd = function(options)
                    if (options.sourceUnit:isDead()) then
                        return
                    end
                    local g = Group():catch(UnitClass, {
                        circle = { x = x, y = y, radius = 400 },
                        limit = 6,
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:isEnemy(options.sourceUnit:owner())
                        end
                    })
                    effector("ThunderClapCaster", x, y, nil, 0.3)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = options.sourceUnit,
                                targetUnit = options.targetUnit,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.thunder,
                                damageTypeLevel = 1,
                            })
                            ability.stun({
                                sourceUnit = u,
                                targetUnit = eu,
                                duration = stun,
                            })
                        end
                    end
                    ability.stun({
                        sourceUnit = u,
                        targetUnit = u,
                        duration = 3,
                    })
                end
            })
        end),
}