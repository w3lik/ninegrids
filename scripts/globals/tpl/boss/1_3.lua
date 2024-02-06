TPL_ABILITY_BOSS["匠泠(军技师)"] = {
    AbilityTpl()
        :name("机巧齿轮")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/EngineeringUpgrade")
        :description({ "提升自身火药元素的伤害", "并可能反弹受到的伤害" })
        :attributes(
        {
            { SYMBOL_ODD .. "hurtRebound", 10, 0 },
            { "hurtRebound", 30, 0 },
            { "enchantMystery", 40, 0 },
        }),
    AbilityTpl()
        :name("重天岩弹")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/SkrBomb")
        :coolDownAdv(10, 0)
        :mpCostAdv(175, 0)
        :castDistanceAdv(1000, 0)
        :castRadiusAdv(50, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(500 + erode * 3)
            local stun = 7
            return {
                "向木飙发射混重天岩弹打击",
                "岩弹有25%几率会使木飙眩晕一段长时间",
                colour.hex(colour.indianred, "岩弹伤害：" .. dmg),
                colour.hex(colour.indianred, "眩晕时间：" .. stun .. "秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.BeforeAttack,
        function(beforeAttackData)
            if (math.rand(1, 100) <= 50) then
                beforeAttackData.triggerAbility:effective({
                    targetUnit = beforeAttackData.targetUnit
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local erode = Game():GD().erode
            local dmg = math.floor(500 + erode * 3)
            local stun = 7
            ability.missile({
                modelAlias = "RockBoltMissile",
                sourceUnit = u,
                weaponLength = 0,
                weaponHeight = 200,
                targetUnit = effectiveData.targetUnit,
                scale = 3.0,
                speed = 400,
                onEnd = function(options)
                    ability.damage({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.rock,
                        damageTypeLevel = 2,
                    })
                    ability.stun({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        duration = stun,
                        odds = 25,
                    })
                end
            })
        end),
}