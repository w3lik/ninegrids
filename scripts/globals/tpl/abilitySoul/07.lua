TPL_ABILITY_SOUL[7] = AbilityTpl()
    :name("预知")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/SunnyDoll")
    :coolDownAdv(45, -2)
    :description(
    function(obj)
        local lv = obj:level()
        local sight = 600
        local damageIncrease = 19 + lv * 7
        return {
            "向全能者预知未来实力一段时间",
            "代价是视野范围大大降低",
            colour.hex(colour.skyblue, "效果持续时间：9秒"),
            colour.hex(colour.indianred, "视野降低：" .. sight),
            colour.hex(colour.lawngreen, "伤害加成：" .. damageIncrease .. '%'),
            colour.hex(colour.yellow, "在白雾天气里，效果提升50%")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local sight = 600
            local damageIncrease = 19 + lv * 7
            return {
                "当移动时向全能者预知未来实力一段时间",
                "代价是视野范围大大降低",
                colour.hex(colour.skyblue, "效果持续时间：9秒"),
                colour.hex(colour.indianred, "视野降低：" .. sight),
                colour.hex(colour.lawngreen, "伤害加成：" .. damageIncrease .. '%'),
                colour.hex(colour.yellow, "在白雾天气里，效果提升50%")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), function()
            this:effective()
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local lv = effectiveData.triggerAbility:level()
        local sight = 600
        local damageIncrease = 19 + lv * 3
        if (Game():isWeather("fogWhite")) then
            damageIncrease = damageIncrease * 1.5
        end
        u:buff("预知")
         :name("预知")
         :icon("ability/SunnyDoll")
         :description({ "透支未来中", colour.hex(colour.indianred, "视野：-" .. sight) })
         :duration(5)
         :purpose(
            function(buffObj)
                buffObj:attach("buff/Chain3555", "chest")
                buffObj:sight("-=" .. sight)
                buffObj:damageIncrease("+=" .. damageIncrease)
            end)
         :rollback(
            function(buffObj)
                buffObj:detach("buff/Chain3555", "chest")
                buffObj:damageIncrease("-=" .. damageIncrease)
                buffObj:sight("+=" .. sight)
            end)
         :run()
    end)