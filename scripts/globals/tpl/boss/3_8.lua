TPL_ABILITY_BOSS["夜泠(游侠)"] = {
    AbilityTpl()
        :name("专注")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/WarriorFocusedRage")
        :description({ "常年的夜间作战令游侠具有极高的专注力", "更容易设置致命的一箭" })
        :attributes(
        {
            { "crit", 55, 0 },
            { SYMBOL_ODD .. "crit", 25, 0 },
            { "stun", 0.3, 0 },
            { SYMBOL_ODD .. "stun", 15, 0 },
        }),
    AbilityTpl()
        :name("夜游")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/PhantomStyle")
        :coolDownAdv(16, 0)
        :mpCostAdv(100, 0)
        :description(
        function()
            return { "进入隐身状态 3 秒", "并悄然移动" }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 50 and nil ~= hurtData.sourceUnit) then
                hurtData.triggerAbility:effective({
                    targetUnit = hurtData.sourceUnit
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local x, y = u:x(), u:y()
            local dur = 3
            effector("AIviTarget", x, y, japi.Z(x, y) + 100, 1)
            ability.invisible({
                whichUnit = u,
                duration = dur,
            })
            local tx, ty = tu:x(), tu:y()
            local px, py = vector2.polar(tx, ty, 300, vector2.angle(x, y, tx, ty) + math.rand(-30, 30))
            u:orderMove(px, py)
        end),
    AbilityTpl()
        :name("抗拒")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Catchthepsychedeliclight")
        :coolDownAdv(7, 0)
        :mpCostAdv(175, 0)
        :description(
        function()
            local dmg = math.floor(330 + Game():GD().erode * 2)
            return {
                "当受到伤害时，如果伤害来源与游侠间距小于250",
                "伤害来源会被拒绝靠近，击飞到后300的距离位置",
                "击飞时会受到" .. colour.hex(colour.indianred, dmg) .. "暗伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 70 and nil ~= hurtData.sourceUnit) then
                if (vector2.distance(hurtData.triggerUnit:x(), hurtData.triggerUnit:y(), hurtData.sourceUnit:x(), hurtData.sourceUnit:y()) < 250) then
                    hurtData.triggerAbility:effective({
                        targetUnit = hurtData.sourceUnit
                    })
                end
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local dmg = math.floor(330 + Game():GD().erode * 2)
            tu:attach("CycloneTarget", "origin", 1.5)
            ability.crackFly({
                sourceUnit = u,
                targetUnit = tu,
                distance = 100,
                height = 150,
                duration = 0.6,
                bounce = { qty = 2 },
                onEnd = function(options, _)
                    local eu = options.targetUnit
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.dark,
                        damageTypeLevel = 1,
                    })
                end
            })
        end),
}