TPL_ABILITY_SOUL[6] = AbilityTpl()
    :name("魔术奥义")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/TreatmentPlus")
    :coolDownAdv(10, 0)
    :hpCostAdv(200, 50)
    :mpCostAdv(0, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local hurtReduction = 33 + 2 * lv
        return {
            "使用HP恢复同样数量的MP",
            "同时降低" .. colour.hex(colour.gold, hurtReduction .. '%') .. "受到的伤害7秒"
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Prop.Change, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local hurtReduction = 33 + 2 * lv
            return {
                "当MP低于最大数值50%时",
                "使用HP恢复同样数量的MP",
                "同时降低" .. colour.hex(colour.gold, hurtReduction .. '%') .. "受到的伤害7秒"
            }
        end)
        this:bindUnit():onEvent(EVENT.Prop.Change, this:id(), function(propChangeData)
            if (propChangeData.key == "mpCur") then
                local u = propChangeData.triggerUnit
                if (u:mpCur() < (u:mp() / 2)) then
                    this:effective()
                end
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local hpCost = ab:hpCost()
        local lv = ab:level()
        local hurtReduction = 33 + 2 * lv
        u:mpBack(hpCost)
        u:attach("AImaTarget", "origin", 1)
        u:buff("魔术奥义")
         :name("魔术奥义")
         :icon("ability/SunnyDoll")
         :description({ colour.hex(colour.lawngreen, "减伤：+" .. hurtReduction .. '%') })
         :duration(7)
         :purpose(
            function(buffObj)
                buffObj:attach("AIdaTarget", "overhead")
                buffObj:hurtReduction("+=" .. hurtReduction)
            end)
         :rollback(
            function(buffObj)
                buffObj:detach("AIdaTarget", "overhead")
                buffObj:hurtReduction("-=" .. hurtReduction)
            end)
         :run()
    end)