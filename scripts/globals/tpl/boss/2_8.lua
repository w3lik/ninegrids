TPL_ABILITY_BOSS["熊猫泠(醉仙)"] = {
    AbilityTpl()
        :name("醉拳")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/MonkJab")
        :description({ "醉生梦死？不！实则虚至", "增加自身躲避灾祸的能力" })
        :attributes(
        {
            { "avoid", 30, 0 },
            { SYMBOL_RES .. "stun", 15, 0 },
        }),
    AbilityTpl()
        :name("狂")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/MonkIronskinbrew")
        :description(
        function()
            local erode = Game():GD().erode
            local atk = math.floor(10 + erode * 0.2)
            local atkSpd = math.floor(4 + erode * 0.04)
            local move = math.floor(15 + erode * 0.3)
            return {
                "每次攻击成功时会获得下列增益中的其中一个",
                "一、增加" .. colour.hex(colour.lawngreen, atk) .. "攻击",
                "二、增加" .. colour.hex(colour.lawngreen, atkSpd) .. "%攻击速度",
                "三、增加" .. colour.hex(colour.lawngreen, move) .. "移动",
                "增益效果最多持续5秒",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            local u = atkData.triggerUnit
            local erode = Game():GD().erode
            local rd = math.rand(1, 3)
            if (rd == 1) then
                local atk = math.floor(10 + erode * 0.2)
                u:attack("+=" .. atk .. ";5")
            elseif (rd == 2) then
                local atkSpd = math.floor(4 + erode * 0.04)
                u:attackSpeed("+=" .. atkSpd .. ";5")
            else
                local move = math.floor(15 + erode * 0.3)
                u:move("+=" .. move .. ";5")
            end
        end),
    AbilityTpl()
        :name("飞撞")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/MonkHurricanestrike")
        :coolDownAdv(5, 0)
        :mpCostAdv(150, 0)
        :castDistanceAdv(1000, 0)
        :castRadiusAdv(50, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(450 + erode * 3)
            return {
                "跳跃撞击敌人，造成" .. colour.hex(colour.indianred, dmg) .. "岩伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 10) <= 5 and nil ~= hurtData.sourceUnit) then
                hurtData.triggerAbility:effective({ targetUnit = hurtData.sourceUnit })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local erode = Game():GD().erode
            local dmg = math.floor(450 + erode * 3)
            ability.leap({
                sourceUnit = u,
                targetUnit = tu,
                modelAlias = "buff/Windwalk",
                speed = 1300,
                height = 150,
                onEnd = function(options)
                    if (options.sourceUnit:isDead() or options.targetUnit:isDead()) then
                        return
                    end
                    ability.damage({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.rock,
                        damageTypeLevel = 2,
                    })
                end
            })
        end),
}