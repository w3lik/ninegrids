TPL_ABILITY_BOSS["蛛泠(牙杀至咬)"] = {
    AbilityTpl()
        :name("痛杀")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Cannibalize")
        :description(
        {
            "每当攻击造成伤害后，都能在至后的2秒内",
            "加深伤害" .. colour.hex(colour.gold, "3%")
        })
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            u:buff("痛杀")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/Cannibalize")
             :description({ colour.hex(colour.lawngreen, "伤害加深：+3%") })
             :duration(2)
             :purpose(function(buffObj) buffObj:hurtIncrease("+=3") end)
             :rollback(function(buffObj) buffObj:hurtIncrease("-=3") end)
             :run()
        end),
    AbilityTpl()
        :name("绞跃")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/TheBoneBreakBlood")
        :coolDownAdv(5, 0)
        :mpCostAdv(150, 0)
        :castDistanceAdv(1000, 0)
        :castRadiusAdv(50, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(150 + erode * 0.6)
            local atkSpd = math.floor(30 + erode * 0.05)
            return {
                "跳跃并绞杀敌人，造成" .. colour.hex(colour.indianred, dmg) .. "毒伤害",
                "并增加自己攻击速度" .. colour.hex(colour.gold, atkSpd) .. "% 6秒",
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
            local dmg = math.floor(150 + erode * 0.6)
            local atkSpd = math.floor(30 + erode * 0.05)
            ability.leap({
                sourceUnit = u,
                targetUnit = tu,
                modelAlias = "buff/WindwalkBlood",
                speed = 1500,
                height = 30,
                onEnd = function(options)
                    if (options.sourceUnit:isDead() or options.targetUnit:isDead()) then
                        return
                    end
                    ability.damage({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.poison,
                        damageTypeLevel = 1,
                    })
                    u:buff("绞跃")
                     :signal(BUFF_SIGNAL.up)
                     :icon("ability/TheBoneBreakBlood")
                     :description("攻速提升" .. atkSpd .. '%')
                     :duration(6)
                     :purpose(
                        function(buffObj)
                            buffObj:attackSpeed("+=" .. atkSpd)
                        end)
                     :rollback(
                        function(buffObj)
                            buffObj:attackSpeed("-=" .. atkSpd)
                        end)
                     :run()
                end
            })
        end),
}