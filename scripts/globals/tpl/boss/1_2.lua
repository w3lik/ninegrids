TPL_ABILITY_BOSS["影泠(无踪刺客)"] = {
    AbilityTpl()
        :name("窃步")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/BlueFlyBoots")
        :description({ "提升速度的步法", "移动攻速回避都得到提升" })
        :attributes(
        {
            { "move", 70, 0 },
            { "attackSpeed", 35, 0 },
            { "avoid", 10, 0 },
        }),
    AbilityTpl()
        :name("毒爆弹")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/Barbedbomb")
        :coolDownAdv(30, 0)
        :mpCostAdv(100, 0)
        :castRadiusAdv(200, 0)
        :castDistanceAdv(600, 0)
        :description(
        function(obj)
            local erode = Game():GD().erode
            local dmg = math.floor(240 + erode * 2)
            local stun = 1.75 + erode * 0.02
            return {
                "向木飙半径范围扔出一个毒性炸弹",
                "炸弹对附近200范围所有木飙造成毒伤",
                "并会使被炸到的木飙眩晕一段时间",
                colour.hex(colour.indianred, "炸弹伤害：" .. dmg),
                colour.hex(colour.indianred, "眩晕时间：" .. stun .. "秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 30) then
                local u = attackData.triggerUnit
                local x, y = u:x(), u:y()
                local tar = attackData.targetUnit
                local angle = vector2.angle(x, y, tar:x(), tar:y())
                local tx, ty = vector2.polar(x, y, 110, angle)
                attackData.triggerAbility:effective({
                    targetX = tx,
                    targetY = ty,
                })
            end
        end)
        :onUnitEvent(EVENT.Unit.Damage,
        function(dmgData)
            if (math.rand(1, 100) <= 10) then
                dmgData.triggerAbility:effective({
                    targetX = dmgData.targetUnit:x(),
                    targetY = dmgData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local erode = Game():GD().erode
            local dmg = math.floor(240 + erode * 2)
            local stun = 1.75 + erode * 0.02
            ability.missile({
                modelAlias = "missile/SpiritBolt",
                sourceUnit = u,
                weaponLength = 100,
                weaponHeight = 120,
                targetVec = { effectiveData.targetX, effectiveData.targetY, 100 },
                speed = 300,
                onEnd = function(options, vec)
                    local g = Group():catch(UnitClass, {
                        circle = { x = vec[1], y = vec[2], radius = 200 },
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false
                        end,
                    })
                    effector("eff/PoisonCrack", vec[1], vec[2], nil, 1)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = options.sourceUnit,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.poison,
                                damageTypeLevel = 1,
                            })
                            ability.stun({
                                sourceUnit = options.sourceUnit,
                                targetUnit = eu,
                                duration = stun,
                            })
                        end
                    end
                end
            })
        end),
}