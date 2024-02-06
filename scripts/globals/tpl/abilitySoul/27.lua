TPL_ABILITY_SOUL[27] = AbilityTpl()
    :name("清醒梦游荡")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/EntertainIdea")
    :coolDownAdv(30, 0)
    :mpCostAdv(125, 0)
    :castDistanceAdv(200, 0)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local sight = 100 + lv * 20
        local defend = 40 + lv * 7
        local dur = 4 + lv * 1
        return {
            "催眠木飙使其进入似睡非睡的梦游态" .. colour.hex(colour.gold, dur) .. "秒",
            "木飙会一旦失去明确的指示，会漫无目的地随意走动",
            "在这期间木飙视野、防御也会相应地减少",
            colour.hex(colour.indianred, "视野降低：" .. sight),
            colour.hex(colour.indianred, "防御降低：" .. defend),
            colour.hex(colour.yellow, "在幽月天气下持续时间加3秒"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Hurt, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local sight = 100 + lv * 20
            local defend = 40 + lv * 7
            local dur = 4 + lv * 1
            return {
                "当受到伤害时有40%的几率",
                "催眠木飙使其进入似睡非睡的梦游态" .. colour.hex(colour.gold, dur) .. "秒",
                "木飙会一旦失去明确的指示，会漫无目的地随意走动",
                "在这期间木飙视野、防御也会相应地减少",
                colour.hex(colour.indianred, "视野降低：" .. sight),
                colour.hex(colour.indianred, "防御降低：" .. defend),
                colour.hex(colour.yellow, "在幽月天气下持续时间加3秒"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Hurt, this:id(), function(hurtData)
            if (math.rand(1, 10) <= 4 and nil ~= hurtData.sourceUnit) then
                this:effective({ targetUnit = hurtData.sourceUnit })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local tu = effectiveData.targetUnit
        local lv = effectiveData.triggerAbility:level()
        local sight = 100 + lv * 20
        local defend = 40 + lv * 7
        local dur = 4 + lv * 1
        if (Game():isWeather("moon")) then
            dur = dur + 3
        end
        local x, y = u:x(), u:y()
        local rFunc = function(orderUnit)
            if (orderUnit:owner():isComputer() and math.rand(1, 10) <= 3) then
                orderUnit:orderAttackTargetUnit(u)
                time.setTimeout(2, function()
                    orderUnit:orderRouteResume()
                end)
                return
            end
            orderUnit:orderRouteResume()
        end
        local rp = {}
        for _ = 1, 10 do
            local tx, ty = vector2.polar(x, y, math.rand(0, 400), math.rand(0, 359))
            table.insert(rp, { tx, ty, rFunc })
        end
        tu:buff("清醒梦游荡")
          :signal(BUFF_SIGNAL.down)
          :icon("ability/EntertainIdea")
          :description({
            colour.hex(colour.indianred, "视野：-" .. sight),
            colour.hex(colour.indianred, "防御：-" .. defend)
        })
          :duration(dur)
          :purpose(function(buffObj)
            buffObj:attach("buff/ManaAura", "overhead")
            buffObj:attach("SleepTarget", "head")
            buffObj:sight("-=" .. sight)
            buffObj:defend("-=" .. defend)
            buffObj:orderRoute(true, rp)
        end)
          :rollback(function(buffObj)
            buffObj:orderRouteDestroy()
            buffObj:detach("buff/ManaAura", "overhead")
            buffObj:detach("SleepTarget", "head")
            buffObj:sight("+=" .. sight)
            buffObj:defend("+=" .. defend)
        end)
          :run()
    end)