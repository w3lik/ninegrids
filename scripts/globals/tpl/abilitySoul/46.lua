TPL_ABILITY_SOUL[46] = AbilityTpl()
    :name("缴械")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/ShadowCurseOfMannoroth")
    :coolDownAdv(23, -1)
    :mpCostAdv(100, 0)
    :castDistanceAdv(600, 0)
    :castRadiusAdv(175, 0)
    :condition(function() return Game():achievement(7) == true end)
    :conditionTips("完成一本书的最后教学指导")
    :description(
    function(obj)
        local lv = obj:level()
        local dur = 2.8 + lv * 0.2
        return "缴械范围木飙" .. colour.hex(colour.gold, dur) .. "秒"
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Be.BeforeAttack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dur = 2.8 + lv * 0.2
            return "当即将被攻击时有15%几率缴械附近木飙" .. colour.hex(colour.gold, dur) .. "秒"
        end)
        this:bindUnit():onEvent(EVENT.Unit.Be.BeforeAttack, this:id(), function(beBeforeAttackData)
            if (math.rand(1, 100) <= 15 and beBeforeAttackData.sourceUnit) then
                this:effective({
                    targetX = beBeforeAttackData.sourceUnit:x(),
                    targetY = beBeforeAttackData.sourceUnit:y(),
                })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local ab = effectiveData.triggerAbility
        local x, y = effectiveData.targetX, effectiveData.targetY
        local lv = ab:level()
        local radius = ab:castRadius()
        local dur = 2.8 + lv * 0.2
        local g = Group():catch(UnitClass, {
            limit = 4,
            circle = { x = x, y = y, radius = radius },
            filter = function(enumUnit)
                return ab:isCastTarget(enumUnit)
            end
        })
        if (#g > 0) then
            for _, eu in ipairs(g) do
                eu:effect("DispelMagicTarget", dur)
                ability.unArm({
                    whichUnit = eu,
                    duration = dur,
                })
            end
        end
    end)