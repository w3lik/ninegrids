TPL_ABILITY_BOSS["酋泠(牛头人)"] = {
    AbilityTpl()
        :name("震动")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Aftershock")
        :description({ "牛头人以强壮的抨击攻击木飙", "能使木飙一段时间内眩晕" })
        :attributes(
        {
            { "stun", 0.5, 0 },
            { SYMBOL_ODD .. "stun", 20, 0 },
        }),
    AbilityTpl()
        :name("裂肺吼叫")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/BullRush")
        :coolDownAdv(16, 0)
        :mpCostAdv(100, 0)
        :description(
        function()
            local erode = Game():GD().erode
            local atk = math.floor(75 + erode * 0.4)
            return {
                "吼叫！吼叫！发起炸裂的吼叫！",
                "在10秒内增加" .. colour.hex(colour.lawngreen, atk) .. "点攻击",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 25) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = u:x(), u:y()
            local erode = Game():GD().erode
            local atk = math.floor(75 + erode * 0.4)
            effector("eff/RoarCasterStromgarde", x, y, japi.Z(x, y), 1)
            u:buff("裂肺吼叫")
             :icon("ability/BullRush")
             :description({ colour.hex(colour.lawngreen, "攻击：+" .. atk) })
             :duration(10)
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/RoarTargetStromgarde", "overhead")
                    buffObj:attack("+=" .. atk)
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/RoarTargetStromgarde", "overhead")
                    buffObj:attack("-=" .. atk)
                end)
             :run()
        end),
    AbilityTpl()
        :name("钢空震撼")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/TheFeetAreTied")
        :coolDownAdv(5, 0)
        :mpCostAdv(50, 0)
        :castRadiusAdv(275, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(500 + erode * 3)
            return {
                "用力践踏地面，被击中的木飙被强力的震动",
                "被击飞至高空中，悬空1.5秒",
                "践踏钢伤害：" .. colour.hex(colour.indianred, dmg)
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 50) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = u:x(), u:y()
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(500 + erode * 3)
            effector("WarStompCaster", x, y, nil, 1)
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
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.steel,
                        damageTypeLevel = 1
                    })
                    ability.crackFly({
                        name = "钢空震撼震飞",
                        icon = "ability/TheFeetAreTied",
                        description = "被震上天了",
                        sourceUnit = u,
                        targetUnit = eu,
                        effect = "StasisTotemTarget",
                        attach = "head",
                        distance = 150,
                        height = math.rand(200, 400),
                        duration = 1.5,
                    })
                end
            end
        end),
}