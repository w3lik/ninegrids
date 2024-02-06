TPL_ABILITY_BOSS["灭泠(巨鹿魔)"] = {
    AbilityTpl()
        :name("强制恶化")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/OffhandStratholmeA02")
        :coolDownAdv(35, 0)
        :description(
        function()
            local erode = Game():GD().erode
            local hurtIncrease = math.floor(20 + erode * 0.05)
            return {
                "攻击一个木飙，若木飙不存在强制恶化时",
                "将为木飙附带一个10秒强制状态，处于该状态的木飙",
                "将会受到额外" .. colour.hex(colour.indianred, hurtIncrease .. '%') .. "的伤害加成",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            local tu = atkData.targetUnit
            if (false == tu:buffHas("强制恶化")) then
                atkData.triggerAbility:effective({
                    targetUnit = tu,
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local tu = effectiveData.targetUnit
            local erode = Game():GD().erode
            local hurtIncrease = math.floor(20 + erode * 0.05)
            tu:buff("强制恶化")
              :signal(BUFF_SIGNAL.down)
              :icon("ability/OffhandStratholmeA02")
              :duration(10)
              :description({ colour.hex(colour.indianred, "伤害加深：" .. hurtIncrease .. '%') })
              :purpose(function(buffObj)
                buffObj:attach("buff/BurningRagePink", "overhead")
                buffObj:hurtIncrease("+=" .. hurtIncrease)
            end)
              :rollback(function(buffObj)
                buffObj:detach("buff/BurningRagePink", "overhead")
                buffObj:hurtIncrease("-=" .. hurtIncrease)
            end)
              :run()
        end),
    AbilityTpl()
        :name("缠绕魔根")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/ForestFury")
        :coolDownAdv(20, 0)
        :mpCostAdv(150, 0)
        :castDistanceAdv(800, 0)
        :castRadiusAdv(50, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(250 + erode * 2)
            return {
                "以树根缠绕木飙，树根会攻击木飙9次",
                "每秒持续造成" .. colour.hex(colour.indianred, dmg) .. "草伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 50) then
                attackData.triggerAbility:effective({ targetUnit = attackData.targetUnit })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local erode = Game():GD().erode
            local dmg = math.floor(250 + erode * 2)
            local twine = function(whichUnit)
                whichUnit:attach("EntanglingRootsTarget", "origin", 1)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = whichUnit,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.ability,
                    damageType = DAMAGE_TYPE.grass,
                    damageTypeLevel = 1,
                })
            end
            twine(tu)
            local i = 0
            time.setInterval(0.75, function(curTimer)
                i = i + 1
                if (i > 8 or isDestroy(u) or u:isDead() or isDestroy(tu) or tu:isDead()) then
                    destroy(curTimer)
                    return
                end
                twine(tu)
            end)
        end),
    AbilityTpl()
        :name("血涌")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/DeathKnightBloodBoil")
        :coolDownAdv(50, 0)
        :mpCostAdv(250, 0)
        :castRadiusAdv(120, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(550 + Game():GD().erode * 3)
            return {
                "在地面施下血至咒法，间断性不停地创造血至涌动",
                "血至涌动创造10次后消失，频率将越来越快",
                "对范围木飙造成" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 25) then
                atkData.triggerAbility:effective({
                    targetUnit = atkData.targetUnit
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local dmg = math.floor(550 + Game():GD().erode * 3)
            local lash = function()
                local x, y = tu:x(), tu:y()
                alerter.circle(x, y, radius)
                time.setTimeout(1, function()
                    effector("eff/BloodExplosion", x, y, nil, 0.5)
                    local g = Group():catch(UnitClass, {
                        circle = { x = x, y = y, radius = radius },
                        limit = 4,
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
                                damageTypeLevel = 1,
                            })
                        end
                    end
                end)
            end
            lash()
            local ti = 0
            time.setInterval(3, function(curTimer)
                curTimer:period("-=0.3")
                ti = ti + 1
                if (ti > 9 or u:isDead()) then
                    destroy(curTimer)
                    return
                end
                lash()
            end)
        end),
    AbilityTpl()
        :name("天降正义")
        :targetType(ABILITY_TARGET_TYPE.tag_square)
        :icon("ability/DemonServant")
        :coolDownAdv(75, 0)
        :mpCostAdv(250, 0)
        :castRadiusAdv(600, 0)
        :castChantAdv(2, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(550 + Game():GD().erode * 1.5)
            return {
                "从天空降下正义，16个灭世法球的仁慈",
                "每个球造成" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 25) then
                atkData.triggerAbility:effective({
                    targetX = atkData.targetUnit:x(),
                    targetY = atkData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = effectiveData.targetX, effectiveData.targetY
            local ab = effectiveData.triggerAbility
            local radius = 120
            local dmg = math.floor(550 + Game():GD().erode * 1.5)
            local lash = function()
                local x0, y0 = vector2.polar(x, y, math.rand(100, 550), math.rand(0, 359))
                local xt, yt = vector2.polar(x0, y0, 300, math.rand(0, 359))
                alerter.circle(xt, yt, radius, 0.5)
                ability.missile({
                    modelAlias = "missile/DarknessBomb",
                    scale = 1.2,
                    speed = 1000,
                    height = 0,
                    shake = "rand",
                    sourceUnit = u,
                    sourceVec = { x0, y0, 1000 },
                    targetVec = { xt, yt },
                    onEnd = function(options, vec)
                        effector("eff/BloodExplosion", vec[1], vec[2], nil, 0.5)
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = radius },
                            limit = 3,
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit)
                            end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                ability.damage({
                                    sourceUnit = options.sourceUnit,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.dark,
                                    damageTypeLevel = 0,
                                })
                            end
                        end
                    end
                })
            end
            for i = 1, 16 do
                time.setTimeout(0.12 * i, function()
                    lash()
                end)
            end
        end),
}