TPL_ABILITY_BOSS["蛇妖泠(美杜莎)"] = {
    AbilityTpl()
        :name("蛇妖皮肤")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/GreenLightSnakeskin")
        :description({ "蛇妖的皮肤可提升自身的防御力", "对伤害小频率高的打击尤为有效" })
        :attributes(
        {
            { "defend", 100, 0 },
        }),
    AbilityTpl()
        :name("潜水")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/TreadWater")
        :coolDownAdv(13, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(300, 0)
        :castDistanceAdv(800, 0)
        :description(
        function()
            local erode = Game():GD().erode
            local stun = 3 + erode * 0.02
            return {
                "潜入水中向着木飙位置前进",
                "从水中冒出时眩晕附近敌人" .. stun .. "秒",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 40) then
                attackData.triggerAbility:effective({
                    targetX = attackData.targetUnit:x(),
                    targetY = attackData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = effectiveData.targetX, effectiveData.targetY
            local radius = effectiveData.triggerAbility:castRadius()
            local erode = Game():GD().erode
            local stun = 3 + erode * 0.02
            local j = 0
            u:rgba(255, 255, 255, 0, 1)
            ability.leap({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "buff/WaterHands",
                speed = 600,
                height = 0,
                onMove = function(_, vec)
                    j = j + 1
                    if (j % 20 == 0) then
                        effector("eff/WaterBlast", vec[1], vec[2], nil, 0.5)
                    end
                end,
                onEnd = function(options)
                    if (options.sourceUnit:isDead()) then
                        return
                    end
                    local g = Group():catch(UnitClass, {
                        circle = { x = x, y = y, radius = radius },
                        limit = 5,
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                        end
                    })
                    effector("eff/VortexArea", x, y, nil, 0.5)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.stun({
                                sourceUnit = u,
                                targetUnit = eu,
                                duration = stun,
                            })
                        end
                    end
                end
            })
        end),
}