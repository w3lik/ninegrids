TPL_ABILITY_SOUL[1] = AbilityTpl()
    :name("帝钢剑光")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/FireSword")
    :coolDownAdv(6, 0)
    :castChantAdv(0.3, 0)
    :castAnimation("attack slam")
    :castDistanceAdv(150, 0)
    :mpCostAdv(120, 10)
    :description(
    function(obj)
        local lv = obj:level()
        local dmg1 = 100 + lv * 70
        local dmg2 = 50 + lv * 30
        return {
            "帝至剑技！刚猛无比！以钢映光！",
            "挥出缠击！造成" .. colour.hex(colour.orange, dmg1) .. "点钢伤害",
            "火花会再次造成" .. colour.hex(colour.silver, dmg2) .. "点光伤害",
            "并有10%几率使护盾立刻恢复",
            colour.hex(colour.yellow, "与剑有缘英泠使用时威力提升75%")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg1 = 100 + lv * 70
            local dmg2 = 50 + lv * 30
            return {
                "帝至剑技，刚猛无比！以钢映光！",
                "挥出缠击！造成" .. colour.hex(colour.orange, dmg1) .. "点钢伤害",
                "火花会再次造成" .. colour.hex(colour.silver, dmg2) .. "点光伤害",
                "并有10%几率使护盾立刻恢复",
                colour.hex(colour.yellow, "与剑有缘英泠使用时威力提升75%")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            this:effective({ targetUnit = attackData.targetUnit })
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local lv = effectiveData.triggerAbility:level()
        local dmg1 = 100 + lv * 70
        local dmg2 = 50 + lv * 30
        if (string.subPos(effectiveData.targetUnit:name(), "剑") ~= -1) then
            dmg1 = dmg1 * 1.75
            dmg2 = dmg2 * 1.75
        end
        local sh = u:shield()
        if (sh > 0 and math.rand(1, 100) <= 10) then
            local t = u:prop("shieldBackTimer")
            if (isClass(t, TimerClass)) then
                u:shieldCur(sh)
                u:clear("shieldBackTimer", true)
            end
        end
        effectiveData.targetUnit:effect("PurificationCaster")
        ability.damage({
            sourceUnit = u,
            targetUnit = effectiveData.targetUnit,
            damageSrc = DAMAGE_SRC.attack,
            damageType = DAMAGE_TYPE.steel,
            damageTypeLevel = 2,
            damage = dmg1,
        })
        time.setTimeout(0.15, function()
            ability.damage({
                sourceUnit = u,
                targetUnit = effectiveData.targetUnit,
                damageSrc = DAMAGE_SRC.attack,
                damageType = DAMAGE_TYPE.light,
                damageTypeLevel = 1,
                damage = dmg2,
            })
        end)
    end)