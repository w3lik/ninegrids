TPL_ABILITY_SOUL[31] = AbilityTpl()
    :name("暗影隧圈")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/SpellMageEvanesce")
    :coolDownAdv(35, 0)
    :mpCostAdv(120, 6)
    :castRadiusAdv(500, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local move = 40 + lv * 5
        local atkSpd = 20 + lv * 3
        local aa = 21 + lv * 3
        return {
            "弥漫暗影领域场地20秒",
            "友军获得速度提升、攻击速度提升",
            "并且获得观察300半径隐身木飙的能力",
            "敌人木飙在圈内回避、命中都将降低",
            colour.hex(colour.lawngreen, "移动速度提升：" .. move),
            colour.hex(colour.lawngreen, "攻击速度提升：" .. atkSpd),
            colour.hex(colour.lawngreen, "探查隐身半径：300"),
            colour.hex(colour.indianred, "回避降低：" .. aa .. '%'),
            colour.hex(colour.indianred, "命中降低：" .. aa .. '%'),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Hurt, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local move = 40 + lv * 5
            local atkSpd = 20 + lv * 3
            local aa = 21 + lv * 3
            return {
                "受伤时弥漫暗影领域场地20秒",
                "友军获得速度提升、攻击速度提升",
                "并且获得观察300半径隐身木飙的能力",
                "敌人木飙在圈内回避、命中都将降低",
                colour.hex(colour.lawngreen, "移动速度提升：" .. move),
                colour.hex(colour.lawngreen, "攻击速度提升：" .. atkSpd),
                colour.hex(colour.lawngreen, "探查隐身半径：300"),
                colour.hex(colour.indianred, "回避降低：" .. aa .. '%'),
                colour.hex(colour.indianred, "命中降低：" .. aa .. '%'),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Hurt, this:id(), function()
            this:effective()
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local radius = ab:castRadius()
        local x, y = u:x(), u:y()
        local move = 40 + lv * 5
        local atkSpd = 20 + lv * 3
        local aa = 21 + lv * 3
        AuraAttach()
            :radius(radius)
            :duration(20)
            :centerPosition({ x, y, 0 })
            :centerEffect("aura/EmptyBigSpace", nil, 500 / 640)
            :filter(function(enumUnit) return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false
        end)
            :onEvent(EVENT.Aura.Leave,
            function(auraData)
                auraData.triggerUnit:buffClear({ key = "暗影隧圈" })
            end)
            :onEvent(EVENT.Aura.Enter,
            function(auraData)
                local eu = auraData.triggerUnit
                if (eu:isEnemy(u:owner())) then
                    eu:buff("暗影隧圈")
                      :icon("ability/SpellMageEvanesce")
                      :description({
                        colour.hex(colour.indianred, "回避：-" .. aa .. '%'),
                        colour.hex(colour.indianred, "命中：-" .. aa .. '%'),
                    })
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:avoid("-=" .. aa)
                        buffObj:aim("-=" .. aa)
                    end)
                      :rollback(function(buffObj)
                        buffObj:avoid("+=" .. aa)
                        buffObj:aim("+=" .. aa)
                    end)
                      :run()
                else
                    eu:buff("暗影隧圈")
                      :icon("ability/SpellMageEvanesce")
                      :description({
                        colour.hex(colour.lawngreen, "移动：+" .. move),
                        colour.hex(colour.lawngreen, "攻速：+" .. atkSpd .. '%'),
                        colour.hex(colour.lawngreen, "反隐：+300"),
                    })
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:move("+=" .. move)
                        buffObj:attackSpeed("+=" .. atkSpd)
                        buffObj:visible("+=300")
                    end)
                      :rollback(function(buffObj)
                        buffObj:move("-=" .. move)
                        buffObj:attackSpeed("-=" .. atkSpd)
                        buffObj:visible("-=300")
                    end)
                      :run()
                end
            end)
    end)